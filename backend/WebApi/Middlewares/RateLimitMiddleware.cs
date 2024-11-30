using Microsoft.Extensions.Caching.Memory;

namespace backend.WebApi.Middlewares
{
    public class RateLimitMiddleware
    {
        private readonly RequestDelegate _next;
        private readonly IMemoryCache _cache;
        
        // Set rate limit period to 10 seconds
        private readonly TimeSpan _rateLimitPeriod = TimeSpan.FromSeconds(90); 
        
        // Allow up to 10 requests per 10 seconds
        private readonly int _maxRequestsPerPeriod = 45;

        public RateLimitMiddleware(RequestDelegate next, IMemoryCache cache)
        {
            _next = next;
            _cache = cache;
        }

        public async Task InvokeAsync(HttpContext context)
        {
            var clientId = GetClientId(context);
            var currentTime = DateTime.UtcNow;
            
            // Retrieve rate limit data from the cache
            var rateLimitData = _cache.Get<RateLimitData>(clientId);
            if (rateLimitData == null)
            {
                rateLimitData = new RateLimitData
                {
                    RequestCount = 0,
                    FirstRequestTime = currentTime
                };
            }
            
            // Check if the request is within the rate limit period
            if (currentTime - rateLimitData.FirstRequestTime < _rateLimitPeriod)
            {
                if (rateLimitData.RequestCount >= _maxRequestsPerPeriod)
                {
                    // If request limit exceeded, return 429 Too Many Requests
                    context.Response.StatusCode = 429;
                    await context.Response.WriteAsync("Too many requests. Please try again later.");
                    return;
                }
            }
            else
            {
                // If the time window has expired, reset the request count
                rateLimitData.FirstRequestTime = currentTime;
                rateLimitData.RequestCount = 0;
            }
            
            // Increment the request count
            rateLimitData.RequestCount++;
            
            // Store updated data in cache
            _cache.Set(clientId, rateLimitData, _rateLimitPeriod);
            
            // Proceed to the next middleware
            await _next(context);
        }

        // Extract client IP or use X-Forwarded-For header if behind a proxy
        private string GetClientId(HttpContext context)
        {
            var clientIp = context.Connection.RemoteIpAddress?.ToString();
            if (context.Request.Headers.ContainsKey("X-Forwarded-For"))
            {
                clientIp = context.Request.Headers["X-Forwarded-For"];
            }
            return clientIp;
        }
    }

    // Store rate limit data for each client
    public class RateLimitData
    {
        public int RequestCount { get; set; }
        public DateTime FirstRequestTime { get; set; }
    }
}

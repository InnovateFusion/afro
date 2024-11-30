using backend.Application.Contracts.Infrastructure.Services;
using System.Text.Json;
using StackExchange.Redis;

namespace backend.Infrastructure.Repository
{
    public class CacheService(IConnectionMultiplexer redis) : ICacheService
    {
        private readonly TimeSpan _expiry = TimeSpan.FromDays(1);

        public async Task Add<T>(string key, T value)
        {
            var db = redis.GetDatabase();
            await db.StringSetAsync(key, JsonSerializer.Serialize(value), expiry: _expiry);
        }

        public async Task<T?> Get<T>(string key)
        {
            var db = redis.GetDatabase();
            var value = await db.StringGetAsync(key);
            return value.HasValue ? JsonSerializer.Deserialize<T>(value) : default;
        }

        public async Task Remove(string key)
        {
            var db = redis.GetDatabase();
            await db.KeyDeleteAsync(key);
        }

        public async Task AddToSet(string key, string value)
        {
            var db = redis.GetDatabase();
            await db.SetAddAsync(key, value);
            await db.KeyExpireAsync(key, _expiry);
        }

        public async Task RemoveFromSet(string key, string value)
        {
            var db = redis.GetDatabase();
            await db.SetRemoveAsync(key, value);
        }

        public async Task<IEnumerable<string>> GetSetMembers(string key)
        {
            var db = redis.GetDatabase();
            return (await db.SetMembersAsync(key)).Select(x => x.ToString());
        }

        public async Task<bool> KeyExists(string key)
        {
            var db = redis.GetDatabase();
            return await db.KeyExistsAsync(key);
        }
        
        public async Task AddList<T>(string key, List<T> values)
        {
            var db = redis.GetDatabase();
            var serializedValues = values.Select(value => JsonSerializer.Serialize(value)).ToArray();
            await db.ListRightPushAsync(key, serializedValues.Select(v => (RedisValue)v).ToArray());
            await db.KeyExpireAsync(key, _expiry);
        }
        
        public async Task<List<T>> GetList<T>(string key)
        {
            var db = redis.GetDatabase();
            var values = await db.ListRangeAsync(key);
            return values.Select(value => JsonSerializer.Deserialize<T>(value!)!).ToList();
        }
        
        public async Task RemoveList(string key)
        {
            var db = redis.GetDatabase();
            await db.KeyDeleteAsync(key);
        }
    }
}

using backend.Application.Features.Product_Features.Category.Requests.Queries;
using MediatR;

namespace backend.Application.Features.Product_Features.Category.Handlers.Queries
{
    public class GetAllCategoryDomainHandler : IRequestHandler<GetAllCategoryDomain, List<Dictionary<string, List<string>>>>
    {
        public Task<List<Dictionary<string, List<string>>>> Handle(GetAllCategoryDomain request, CancellationToken cancellationToken)
        {
            var validDomains = new List<Dictionary<string, List<string>>>
            {
                new Dictionary<string, List<string>> { { "men", new List<string> { "tops", "casual", "belts","formal", "outerwear", "sportswear", "accessories", "shoes", "suits", "jeans", "shorts", "swimwear", "underwear" } } },
                new Dictionary<string, List<string>> { { "women", new List<string> { "tops", "casual", "belts","formal", "outerwear", "sportswear", "accessories", "shoes", "dresses", "skirts", "blouses", "jeans", "shorts", "swimwear", "lingerie",  "loungewear", "panties", "bras", "nightwear" } } },
                new Dictionary<string, List<string>> { { "kids", new List<string> { "tops", "casual","formal", "hats", "playwear", "outerwear", "sportswear", "accessories", "shoes", "dresses", "skirts", "jeans", "shorts", "swimwear", "pajamas", "scarves" } } },
                new Dictionary<string, List<string>> { { "accessories", new List<string> { "hats", "belts", "scarves", "gloves", "jewelry", "sunglasses", "watches", "bags", "wallets", "socks" } } },
                new Dictionary<string, List<string>> { { "shoes", new List<string> { "sneakers", "boots", "sandals", "formal", "casual", "loafers", "heels", "flats", "running", "hiking" } } },
            };
            return Task.FromResult(validDomains);
        }
    }
}

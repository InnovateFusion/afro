using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using backend.Application.Contracts.Persistence.Repositories.Product;
using backend.Application.DTO.Product.CategoryDTO.DTO;
using FluentValidation;

namespace backend.Application.DTO.Product.CategoryDTO.Validations
{
    public class BaseCategoryValidation : AbstractValidator<CreateCategoryDTO>
    {
        private readonly ICategoryRepository _categoryRepository;

        public BaseCategoryValidation(ICategoryRepository categoryRepository)
        {
            _categoryRepository = categoryRepository;

            RuleFor(x => x.Name)
                .NotNull()
                .WithMessage("Name is required")
                .NotEmpty()
                .WithMessage("Name cannot be empty")
                .Custom((name, context) => context.InstanceToValidate.Name = name.ToLower());

            RuleFor(x => x.Image)
                .NotNull()
                .WithMessage("Image is required")
                .NotEmpty()
                .WithMessage("Image cannot be empty");

            RuleFor(x => x.Domain)
                .NotNull()
                .WithMessage("Domain is required")
                .Must(BeAValidDomain)
                .WithMessage("Domain must contain valid entries");
            
            RuleFor(x => x.ParentFilterType)
                .NotNull()
                .WithMessage("ParentFilterType is required.")
                .IsInEnum()
                .WithMessage("ParentFilterType must be a valid value from the ParentFilterType enum.");
        }

        private bool BeAValidDomain(Dictionary<string, List<string>> domain)
        {
            var validDomains = new Dictionary<string, List<string>>
            {
                { "men", new List<string> { "tops", "casual", "belts","hats", "formal", "outerwear", "sportswear", "accessories", "shoes", "suits", "jeans", "shorts", "swimwear", "underwear" } },
                { "women", new List<string> { "tops", "casual", "belts", "hats", "formal", "outerwear", "sportswear", "accessories", "shoes", "dresses", "skirts", "blouses", "jeans", "bras", "shorts", "swimwear", "lingerie", "loungewear", "panties", "bras", "nightwear" } },
                { "kids", new List<string> { "tops", "casual", "formal", "playwear", "hats","outerwear", "sportswear", "accessories", "shoes", "dresses", "skirts", "jeans", "shorts", "swimwear", "pajamas", "scarves" } },
                { "accessories", new List<string> { "hats", "belts", "scarves", "gloves", "jewelry", "sunglasses", "watches", "bags", "wallets", "socks" } } ,
                { "shoes", new List<string> { "sneakers", "boots", "sandals", "formal", "casual", "loafers", "heels", "flats", "running", "hiking" } }
            };

            return domain.All(entry =>
            {
                var key = entry.Key;
                var values = entry.Value;
                if (!validDomains.ContainsKey(key))
                {
                    return false;
                }
                return values.All(value => validDomains[key].Contains(value));
            });
        }
    }
}

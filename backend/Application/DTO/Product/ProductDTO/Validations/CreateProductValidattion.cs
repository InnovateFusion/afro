using backend.Application.Contracts.Persistence.Repositories.Shop;
using backend.Application.DTO.Product.ProductDTO.DTO;
using FluentValidation;

namespace backend.Application.DTO.Product.ProductDTO.Validations
{
    public class CreateProductValidation : AbstractValidator<CreateProductDTO>
    {
        private string[] Status = { "draft", "active", "archive" };

        public CreateProductValidation(IShopRepository shopRepository)
        {
            RuleFor(x => x.Title)
                .NotNull()
                .WithMessage("Title is required")
                .NotEmpty()
                .WithMessage("Title cannot be empty")
                .MinimumLength(3)
                .WithMessage("Title must be at least 3 characters long")
                .MaximumLength(60)
                .WithMessage("Title must be at most 50 characters long");

            RuleFor(x => x.Description)
                .NotNull()
                .WithMessage("Description is required");

            RuleFor(x => x.Price)
                .NotNull()
                .WithMessage("Price is required")
                .NotEmpty()
                .WithMessage("Price cannot be empty")
                .GreaterThan(0)
                .WithMessage("Price must be greater than 0");

            RuleFor(x => x.Status)
                .NotNull()
                .WithMessage("Status is required")
                .NotEmpty()
                .WithMessage("Status cannot be empty")
                .Must(x => Status.Contains(x))
                .WithMessage("Status must be draft, archive or active");


            RuleFor(x => x.IsNew)
                .NotNull()
                .WithMessage("Condition is required");

            RuleFor(x => x.ShopId)
                .NotNull()
                .WithMessage("ShopId is required")
                .NotEmpty()
                .WithMessage("ShopId cannot be empty")
                .MustAsync(async (shopId, token) => await shopRepository.ExistsAsync(shopId));
            
            RuleFor(x => x.VideoUrl)
                .Cascade(CascadeMode.Stop)
                .Must(x => string.IsNullOrEmpty(x) || Uri.IsWellFormedUriString(x, UriKind.Absolute))
                .WithMessage("VideoUrl must be a valid URL");
        }
    }
}

using backend.Application.Contracts.Persistence.Repositories.Product;
using backend.Application.DTO.Product.BrandDTO.DTO;
using backend.Application.Enum;
using FluentValidation;

namespace backend.Application.DTO.Product.BrandDTO.Validations
{
    public class CreateBrandValidation : AbstractValidator<CreateBrandDTO>
    {
        IBrandRepository _brandRepository;

        public CreateBrandValidation(IBrandRepository brandRepository)
        {
            _brandRepository = brandRepository;

            RuleFor(x => x.Name)
                .NotNull()
                .WithMessage("Name is required")
                .NotEmpty()
                .WithMessage("Name cannot be empty")
                .Custom((name, context) => context.InstanceToValidate.Name = name.ToLower());

            RuleFor(x => x.Name)
                .MustAsync(
                    async (name, cancellation) =>
                    {
                        var brand = await _brandRepository.GetByName(name);
                        return brand == null;
                    }
                )
                .WithMessage("Brand already exists");

            RuleFor(x => x.ParentFilterType)
                .NotNull()
                .WithMessage("ParentFilterType is required.")
                .IsInEnum()
                .WithMessage("ParentFilterType must be a valid value from the ParentFilterType enum.");
        }
        
    }
}

using backend.Application.Contracts.Persistence.Repositories.Product;
using backend.Application.DTO.Product.ColorDTO.DTO;
using FluentValidation;

namespace backend.Application.DTO.Product.ColorDTO.Validations
{
    public class CreateColorValidation : AbstractValidator<CreateColorDTO>
    {
        IColorRepository _colorRepository;

        public CreateColorValidation(IColorRepository colorRepository)
        {
            _colorRepository = colorRepository;

            RuleFor(x => x.Name)
                .NotNull()
                .WithMessage("Name is required")
                .NotEmpty()
                .WithMessage("Name cannot be empty")
                .Custom((name, context) => context.InstanceToValidate.Name = name.ToLower());

            RuleFor(x => x.HexCode)
                .NotNull()
                .WithMessage("HexCode is required")
                .NotEmpty()
                .WithMessage("HexCode cannot be empty")
                .Custom(
                    (hexCode, context) => context.InstanceToValidate.HexCode = hexCode.ToLower()
                );

            RuleFor(x => x.Name)
                .MustAsync(
                    async (name, cancellation) =>
                    {
                        var color = await _colorRepository.GetByName(name);
                        return color == null;
                    }
                )
                .WithMessage("Color already exists");

            RuleFor(x => x.HexCode)
                .MustAsync(
                    async (hexCode, cancellation) =>
                    {
                        var color = await _colorRepository.GetByHexCode(hexCode);
                        return color == null;
                    }
                )
                .WithMessage("Color already exists");
            
            RuleFor(x => x.ParentFilterType)
                .NotNull()
                .WithMessage("ParentFilterType is required.")
                .IsInEnum()
                .WithMessage("ParentFilterType must be a valid value from the ParentFilterType enum.");
        }
    }
}

using backend.Application.DTO.Common.Chat.DTO;
using FluentValidation;

namespace backend.Application.DTO.Common.Chat.Validations;

enum ChatType   
{
    Text,
    Image
}

public class CreateChatDtoValidation : AbstractValidator<CreateChatDTO>
{
    public CreateChatDtoValidation()
    {
        RuleFor(x => x.Message)
            .NotEmpty()
            .WithMessage("Message is required and cannot be empty");

        RuleFor(x => x.Type)
            .Must(x => x.Equals(0) || x.Equals(1))
            .WithMessage("Type must be either Text or Image");

        RuleFor(x => x.ReceiverId)
            .NotEmpty()
            .WithMessage("ReceiverId is required and cannot be empty");
    }
}
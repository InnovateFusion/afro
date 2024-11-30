using backend.Application.DTO.Common.Notification.DTO;
using FluentValidation;

namespace backend.Application.DTO.Common.Notification.Validations;

public class CreateNotificationValidation:  AbstractValidator<CreateNotificationDto>
{
    public CreateNotificationValidation()
    {
        RuleFor(x => x.Message)
            .NotNull().WithMessage("Message is required")
            .NotEmpty().WithMessage("Message cannot be empty");

        RuleFor(x => x.Type)
            .NotNull().WithMessage("Type is required")
            .IsInEnum().WithMessage("Type must be a valid NotificationType");

        RuleFor(x => x.ReceiverId)
            .NotNull().WithMessage("ReceiverId is required")
            .NotEmpty().WithMessage("ReceiverId cannot be empty");
    }
    
}
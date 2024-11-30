using backend.Application.DTO.Common.Notification.DTO;
using backend.Application.Response;
using MediatR;

namespace backend.Application.Features.Common_Features.Notification.Requests.Commands;

public class CreateNotificationRequest: IRequest<BaseResponse<NotificationResponseDto>>
{
    public required CreateNotificationDto Notification { get; set; }
    public required string SenderId { get; set; }
}
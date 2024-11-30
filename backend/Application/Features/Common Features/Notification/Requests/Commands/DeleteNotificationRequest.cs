using backend.Application.DTO.Common.Notification.DTO;
using backend.Application.Response;
using MediatR;

namespace backend.Application.Features.Common_Features.Notification.Requests.Commands;

public class DeleteNotificationRequest: IRequest<BaseResponse<NotificationResponseDto>>
{
    public required string Id { get; set; }
    public required string UserId { get; set; }
}
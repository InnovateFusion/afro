using backend.Application.DTO.Common.Notification.DTO;
using MediatR;

namespace backend.Application.Features.Common_Features.Notification.Requests.Queries;

public class GetNotificationForUserRequest: IRequest<List<NotificationResponseDto>>
{
    public required string UserId { get; set; }
    public int Limit { get; set; }
    public int Skip { get; set; }
}
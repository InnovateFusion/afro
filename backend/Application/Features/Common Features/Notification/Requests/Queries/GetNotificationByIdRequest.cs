using backend.Application.DTO.Common.Notification.DTO;
using MediatR;

namespace backend.Application.Features.Common_Features.Notification.Requests.Queries;

public class GetNotificationByIdRequest : IRequest<NotificationResponseDto>
{
    public required string Id { get; set; }
}
using backend.Application.DTO.Common.Notification.DTO;
using MediatR;

namespace backend.Application.Features.Common_Features.Notification.Requests.Queries;

public class MarkNotificationAsReadRequest: IRequest<bool>
{
    public required string UserId { get; set; }
}
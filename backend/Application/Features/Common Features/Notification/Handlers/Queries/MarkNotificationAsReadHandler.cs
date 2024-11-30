using AutoMapper;
using backend.Application.Contracts.Persistence;
using backend.Application.Features.Common_Features.Notification.Requests.Queries;
using MediatR;

namespace backend.Application.Features.Common_Features.Notification.Handlers.Queries;

public class MarkNotificationAsReadHandler(IUnitOfWork unitOfWork, IMapper mapper)
    : IRequestHandler<MarkNotificationAsReadRequest, bool>
{
    public async Task<bool> Handle(MarkNotificationAsReadRequest request, CancellationToken cancellationToken)
    {
        return await unitOfWork.NotificationRepository.MarkAsRead(request.UserId);
    }
}
using AutoMapper;
using backend.Application.Contracts.Persistence;
using backend.Application.DTO.Common.Notification.DTO;
using backend.Application.Features.Common_Features.Notification.Requests.Queries;
using MediatR;

namespace backend.Application.Features.Common_Features.Notification.Handlers.Queries;

public class GetNotificationForUserHandler(IUnitOfWork unitOfWork, IMapper mapper)
    : IRequestHandler<GetNotificationForUserRequest, List<NotificationResponseDto>>
{
    public async Task<List<NotificationResponseDto>> Handle(GetNotificationForUserRequest request, CancellationToken cancellationToken)
    {
        var notifications = await unitOfWork.NotificationRepository.GetAll(
            userId: request.UserId,
            limit: request.Limit,
            skip: request.Skip
            );
        return mapper.Map<List<NotificationResponseDto>>(notifications);
    }
}
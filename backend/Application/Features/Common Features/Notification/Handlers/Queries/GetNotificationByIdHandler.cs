using AutoMapper;
using backend.Application.Contracts.Persistence;
using backend.Application.DTO.Common.Notification.DTO;
using backend.Application.Exceptions;
using backend.Application.Features.Common_Features.Notification.Requests.Queries;
using MediatR;

namespace backend.Application.Features.Common_Features.Notification.Handlers.Queries;

public class GetNotificationByIdHandler(IUnitOfWork unitOfWork, IMapper mapper)
    : IRequestHandler<GetNotificationByIdRequest, NotificationResponseDto>
{
    public async Task<NotificationResponseDto> Handle(GetNotificationByIdRequest request, CancellationToken cancellationToken)
    {
        var notification = await unitOfWork.NotificationRepository.GetById(request.Id);
        if (notification == null)
        {
            throw new NotFoundException("Notification Not Found");
        }
        return mapper.Map<NotificationResponseDto>(notification);
    }
}
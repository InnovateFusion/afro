using AutoMapper;
using backend.Application.Contracts.Infrastructure.Services;
using backend.Application.Contracts.Persistence;
using backend.Application.DTO.Common.Notification.DTO;
using backend.Application.Exceptions;
using backend.Application.Features.Common_Features.Notification.Requests.Commands;
using backend.Application.Response;
using MediatR;

namespace backend.Application.Features.Common_Features.Notification.Handlers.Commands;

public class DeleteNotificationHandler(IUnitOfWork unitOfWork, IRabbitMQService rabbitMqService, IMapper mapper)
    : IRequestHandler<DeleteNotificationRequest, BaseResponse<NotificationResponseDto>>
{
    public async Task<BaseResponse<NotificationResponseDto>> Handle(DeleteNotificationRequest request, CancellationToken cancellationToken)
    {
        var notification = await unitOfWork.NotificationRepository.GetById(request.Id);
        if (notification == null)
        {
            throw new NotFoundException("Notification Not Found");
        }
        
        if (notification.Sender.Id != request.UserId)
        {
            throw new BadRequestException("You are not the sender of this notification");
        }
        
        await unitOfWork.NotificationRepository.Delete(notification);
        rabbitMqService.PublishMessageAsync("delete-notification", "delete-notification", "delete-notification", request.Id);

        
        return new BaseResponse<NotificationResponseDto>
        {
            Message = "Notification Deleted Successfully",
            Success = true,
            Data = mapper.Map<NotificationResponseDto>(notification)
        };
    }
}
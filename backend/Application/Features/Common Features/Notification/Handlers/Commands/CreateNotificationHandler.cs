using AutoMapper;
using backend.Application.Contracts.Infrastructure.Services;
using backend.Application.Contracts.Persistence;
using backend.Application.DTO.Common.Chat.DTO;
using backend.Application.DTO.Common.Notification.DTO;
using backend.Application.Enum;
using backend.Application.Exceptions;
using backend.Application.Features.Common_Features.Notification.Requests.Commands;
using backend.Application.Response;
using MediatR;

namespace backend.Application.Features.Common_Features.Notification.Handlers.Commands;

public class CreateNotificationHandler(IUnitOfWork unitOfWork, IMapper mapper,  IRabbitMQService rabbitMqService, ICacheService cacheService)
    : IRequestHandler<CreateNotificationRequest, BaseResponse<NotificationResponseDto>>
{
    public async Task<BaseResponse<NotificationResponseDto>> Handle(CreateNotificationRequest request, CancellationToken cancellationToken)
    {
        var notification = mapper.Map<Domain.Entities.Common.Notification>(request.Notification);
        var recipient = await unitOfWork.UserRepository.GetById(request.Notification.ReceiverId);
        if (recipient == null)
        {
            throw new NotFoundException("Recipient Not Found");
        }
        notification.Type = (int)request.Notification.Type;
        notification.SenderId = request.SenderId;
        notification.ReceiverId = request.Notification.ReceiverId;
        notification.Message = request.Notification.Message;
        notification.CreatedAt = DateTime.Now;
        notification.TypeId = request.SenderId;
        if (await cacheService.KeyExists($"{notification.SenderId}-data"))
        {
            var senderData = await cacheService.Get<RealTimeChatUserDataDto>($"{notification.SenderId}-data");
            var notify = new NotificationResponseRealTimeDto
            {
                Id = notification.Id, 
                TypeId = notification.Id,
                Message = notification.Message,
                ReceiverId = notification.ReceiverId,
                Type = NotificationType.Verify,
                FirstName = senderData.name,
                LastName = "",
                Avatar = senderData.avatar,
                IsRead = false,
                CreatedAt = DateTime.Now,
                IsAdmin = true,
                MessageType = 0
            };
            rabbitMqService.PublishMessageAsync("notification", "notification", "notification", notify.ToJSon());
        }
        await unitOfWork.NotificationRepository.Add(notification);
        
  

        return new BaseResponse<NotificationResponseDto>
        {
            Message = "Notification Created Successfully",
            Success = true,
            Data = mapper.Map<NotificationResponseDto>(notification)
        };
    }
}
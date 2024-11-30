using AutoMapper;
using backend.Application.Contracts.Infrastructure.Services;
using backend.Application.Contracts.Persistence;
using backend.Application.DTO.Common.Chat.DTO;
using backend.Application.DTO.Common.Notification.DTO;
using backend.Application.DTO.User.UserDTO.DTO;
using backend.Application.Enum;
using backend.Application.Exceptions;
using backend.Application.Features.Shop_Features.Shop.Requests.Queries;
using backend.Application.Response;
using backend.Domain.Entities.Common;
using MediatR;

namespace backend.Application.Features.Shop_Features.Shop.Handlers.Queries;

public class FollowShopHandler(IUnitOfWork unitOfWork,  IRabbitMQService rabbitMqService, ICacheService cacheService): IRequestHandler<FollowShopRequest, BaseResponse<string>>
{
    public async Task<BaseResponse<string>> Handle(FollowShopRequest request, CancellationToken cancellationToken)
    {
        var data = await unitOfWork.ShopRepository.FollowShopAsync(request.ShopId, request.UserId);

        if (data)
        {
            var notification = new Notification
            {
                Message =  "Start following your shop",
                SenderId = request.UserId,
                ReceiverId = request.ShopId,
                Type = (int)NotificationType.Follow,
                TypeId = request.UserId,
            };
            
            var user = await unitOfWork.UserRepository.GetById(request.ShopId);
            if (user == null)
                throw new BadRequestException("User not found");
            var userNotificationSetting = UserNotificationSettingSharedDto.FromJson(user.NotificationSettings);

            if (request.UserId != request.ShopId && (userNotificationSetting?.Follow ?? false))
            {
                if (await cacheService.KeyExists($"{notification.SenderId}-data"))
                {
                    var senderData = await cacheService.Get<RealTimeChatUserDataDto>($"{notification.SenderId}-data");
                    var notify = new NotificationResponseRealTimeDto
                    {
                        Id = notification.Id,
                        Message = notification.Message,
                        ReceiverId = notification.ReceiverId,
                        Type = NotificationType.Follow,
                        FirstName = senderData.name,
                        LastName = "",
                        Avatar = senderData.avatar,
                        IsRead = false,
                        CreatedAt = DateTime.Now,
                        TypeId = notification.TypeId,
                        MessageType = 0,
                        IsAdmin = false,
                    };
                    rabbitMqService.PublishMessageAsync("notification", "notification", "notification", notify.ToJSon());
                }

                await unitOfWork.NotificationRepository.Add(notification);
            }
        }

        return new BaseResponse<string>
        {
            Success = true,
            Message = "Shop followed successfully",
            Data = "Shop followed successfully"
        };
    }
}
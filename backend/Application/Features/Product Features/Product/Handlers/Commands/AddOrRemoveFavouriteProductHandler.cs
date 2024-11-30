using backend.Application.Contracts.Infrastructure.Services;
using backend.Application.Contracts.Persistence;
using backend.Application.DTO.Common.Chat.DTO;
using backend.Application.DTO.Common.Notification.DTO;
using backend.Application.DTO.User.UserDTO.DTO;
using backend.Application.Enum;
using backend.Application.Exceptions;
using backend.Application.Features.Product_Features.Product.Requests.Commands;
using backend.Application.Response;
using backend.Domain.Entities.Common;
using MediatR;

namespace backend.Application.Features.Product_Features.Product.Handlers.Commands;

public class AddOrRemoveFavouriteProductHandler(IUnitOfWork unitOfWork,  IRabbitMQService rabbitMqService, ICacheService cacheService)
    : IRequestHandler<AddOrRemoveFavouriteProduct, BaseResponse<string>>
{
    public async Task<BaseResponse<string>> Handle(AddOrRemoveFavouriteProduct request, CancellationToken cancellationToken)
    {
      var result =  await unitOfWork.FavouriteProductRepository.AddOrRemove(
            request.UserId,
            request.ProductId
        );

        if (result)
        {
            var product = await unitOfWork.ProductRepository.GetById(request.ProductId);
            if (product == null)
            {
                throw new NotFoundException("No product found with this id");
            }
            
            var user = await unitOfWork.UserRepository.GetById(product.ShopId);
            if (user == null)
                throw new BadRequestException("User not found");
            var userNotificationSetting = UserNotificationSettingSharedDto.FromJson(user.NotificationSettings);

            if (request.UserId != product.ShopId && (userNotificationSetting?.Favorite ?? false))
            {
                var notification = new Notification
                {
                    TypeId = product.Id,
                    Message = "Your product has been added to favourite.",
                    SenderId = request.UserId,
                    ReceiverId = product.ShopId,
                    Type = (int)NotificationType.Favorite,
                };
                
                if (await cacheService.KeyExists($"{notification.SenderId}-data"))
                {
                    var senderData = await cacheService.Get<RealTimeChatUserDataDto>($"{notification.SenderId}-data");
                    var notify = new NotificationResponseRealTimeDto
                    {
                        Id = notification.Id,
                        TypeId = notification.TypeId,
                        Message = notification.Message,
                        ReceiverId = notification.ReceiverId,
                        Type = NotificationType.Favorite,
                        FirstName = senderData.name,
                        LastName = "",
                        Avatar = senderData.avatar,
                        IsRead = false,
                        CreatedAt = DateTime.Now,
                        MessageType = 0,
                        IsAdmin = false
                    };
                    rabbitMqService.PublishMessageAsync("notification", "notification", "notification", notify.ToJSon());
                }
                
                await unitOfWork.NotificationRepository.Add(notification);
            }
        }
        
        return new BaseResponse<string>
        {
            Message = "Product added or removed from favourite successfully",
            Success = true,
            Data = $"Product with id {request.ProductId} added or removed from favourite successfully"
        };
    }
}
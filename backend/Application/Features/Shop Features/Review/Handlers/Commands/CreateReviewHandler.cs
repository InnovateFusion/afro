using AutoMapper;
using backend.Application.Contracts.Infrastructure.Services;
using backend.Application.Contracts.Persistence;
using backend.Application.DTO.Common.Chat.DTO;
using backend.Application.DTO.Common.Notification.DTO;
using backend.Application.DTO.Shop.ReviewDTO.DTO;
using backend.Application.DTO.Shop.ReviewDTO.Validations;
using backend.Application.DTO.User.UserDTO.DTO;
using backend.Application.Enum;
using backend.Application.Exceptions;
using backend.Application.Features.Shop_Features.Review.Requests.Commands;
using backend.Application.Response;
using backend.Domain.Entities.Common;
using backend.Domain.Entities.Shop;
using backend.Infrastructure.Repository;
using MediatR;

namespace backend.Application.Features.Shop_Features.Review.Handlers.Commands;

public class CreateReviewHandler(IUnitOfWork unitOfWork, IRabbitMQService rabbitMqService, ICacheService cacheService,  IMapper mapper): IRequestHandler<CreateReviewRequest, BaseResponse<ReviewResponseDTO>>
{
    public async Task<BaseResponse<ReviewResponseDTO>> Handle(CreateReviewRequest request,
        CancellationToken cancellationToken)
    {
        var validator = new CreateReviewValidation(unitOfWork.ShopRepository);
        var validationResult = await validator.ValidateAsync(request.Review);

        if (!validationResult.IsValid)
            throw new BadRequestException(
                validationResult.Errors.FirstOrDefault()?.ErrorMessage!
            );

        var review = mapper.Map<ShopReview>(request.Review);
        review.UserId = request.UserId;
        await unitOfWork.ShopReviewRepository.Add(review);
        review = await unitOfWork.ShopReviewRepository.GetShopReviewByIdAsync(review.Id);
        var reviewResponse = mapper.Map<ReviewResponseDTO>(review);
        
        var user = await unitOfWork.UserRepository.GetById(review.Shop.UserId);
        if (user == null)
            throw new BadRequestException("User not found");
        var userNotificationSetting = UserNotificationSettingSharedDto.FromJson(user.NotificationSettings);
        
        if (request.UserId != review.Shop.UserId && (userNotificationSetting?.Review ?? false))
        {
            var notification = new Notification
            {
                Message = review.Review,
                SenderId = request.UserId,
                ReceiverId = review.Shop.UserId,
                TypeId = review.Shop.Id,
                Type = (int)NotificationType.Review,
            };
            await unitOfWork.NotificationRepository.Add(notification);
            
            if (await cacheService.KeyExists($"{notification.SenderId}-data"))
            {
                var senderData = await cacheService.Get<RealTimeChatUserDataDto>($"{notification.SenderId}-data"); 
                var notify = new NotificationResponseRealTimeDto
                {
                    Id = notification.Id,
                    Message = notification.Message,
                    ReceiverId = notification.ReceiverId,
                    Type = NotificationType.Review,
                    FirstName = senderData.name,
                    LastName = "",
                    Avatar = senderData.avatar,
                    IsRead = false,
                    CreatedAt = DateTime.Now,
                    TypeId = notification.TypeId,
                    IsAdmin = false,
                    MessageType = 0,
                };
                rabbitMqService.PublishMessageAsync("notification", "notification", "notification", notify.ToJSon());
            }
        }
        
        return new BaseResponse<ReviewResponseDTO>
        {
            Success = true,
            Data = reviewResponse,
            Message = "Review Created Successfully"
        };
    }
}
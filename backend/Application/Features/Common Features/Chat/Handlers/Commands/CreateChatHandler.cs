using AutoMapper;
using backend.Application.Contracts.Infrastructure.Repositories;
using backend.Application.Contracts.Infrastructure.Services;
using backend.Application.Contracts.Persistence;
using backend.Application.DTO.Common.Chat.DTO;
using backend.Application.DTO.Common.Chat.Validations;
using backend.Application.DTO.Common.Notification.DTO;
using backend.Application.DTO.User.UserDTO.DTO;
using backend.Application.Enum;
using backend.Application.Exceptions;
using backend.Application.Features.Common_Features.Chat.Requests.Commads;
using backend.Infrastructure.Repository;
using MediatR;
using Newtonsoft.Json;

namespace backend.Application.Features.Common_Features.Chat.Handlers.Commands;

public class CreateChatHandler(IUnitOfWork unitOfWork, IMapper mapper, IRabbitMQService rabbitMqService, ICacheService cacheService, 		IAzureBlobStorageService azureBlobStorageService,	IImageRepository imageRepository)
    : IRequestHandler<CreateChatRequest, ChatResponseDTO>
{
    public async Task<ChatResponseDTO> Handle(CreateChatRequest request, CancellationToken cancellationToken)
    {
        var validator = new CreateChatDtoValidation();
        var validationResult = await validator.ValidateAsync(request.Chat!);
        if (!validationResult.IsValid)
            throw new BadRequestException(
                validationResult.Errors.FirstOrDefault()?.ErrorMessage!
            );
        string id = Guid.NewGuid().ToString();
        var dateTime = DateTime.UtcNow.AddHours(3);
        
        var senderData = new RealTimeChatUserDataDto
        {
            id = request.SenderId,
            name = "Unknown",
            avatar = "Unknown"
        };
        
        var receiverData = new RealTimeChatUserDataDto
        {
            id = request.Chat.ReceiverId,
            name = "Unknown",
            avatar = "Unknown"
        };
        if (await cacheService.KeyExists($"{request.SenderId}-data"))
        {
            senderData = await cacheService.Get<RealTimeChatUserDataDto>($"{request.SenderId}-data");
        }
        
        if (await cacheService.KeyExists($"{request.Chat.ReceiverId}-data"))
        {
            receiverData = await cacheService.Get<RealTimeChatUserDataDto>($"{request.Chat.ReceiverId}-data");
        }
            
        if (request.Chat.Type == 1)
        {
            string base64Image = request.Chat.Message.Split(',')[1];
            byte[] imageBytes = Convert.FromBase64String(base64Image);
            var image = await azureBlobStorageService.UploadImageAsync(imageBytes, id);
            //var image = await imageRepository.Upload(request.Chat.Message, id);
            if (image == null)
                throw new BadRequestException("Image not found");
            request.Chat.Message = image;
        }
        
        var message = SterilizeMessage(id, request.Chat.Message, request.Chat.Type, senderData, receiverData, dateTime);
        rabbitMqService.PublishMessageAsync("chat", "chat", "chat", message);

        var chat = new Domain.Entities.Common.Chat
        {
            Id = id,
            Message = request.Chat.Message,
            Type = request.Chat.Type,
            SenderId = request.SenderId,
            ReceiverId = request.Chat.ReceiverId,
            CreatedAt = dateTime
        };

        var user = await unitOfWork.UserRepository.GetById(request.Chat.ReceiverId);
        if (user == null)
            throw new BadRequestException("User not found");
        var userNotificationSetting = UserNotificationSettingSharedDto.FromJson(user.NotificationSettings);

        if (userNotificationSetting?.Message ?? false)
        {
            var notification = new Domain.Entities.Common.Notification
            {
                Message = request.Chat.Message,
                SenderId = request.SenderId,
                ReceiverId = request.Chat.ReceiverId,
                Type = (int)NotificationType.Message,
                TypeId = chat.Id,
            };
        
            if (await cacheService.KeyExists($"{notification.SenderId}-data"))
            {
                var notify = new NotificationResponseRealTimeDto
                {
                    Id = notification.Id,
                    Message = notification.Message,
                    ReceiverId = notification.ReceiverId,
                    Type = NotificationType.Message,
                    FirstName = senderData.name,
                    LastName = "",
                    Avatar = senderData.avatar,
                    IsRead = false,
                    CreatedAt = dateTime,
                    TypeId = chat.Id,
                    IsAdmin = false,
                    MessageType = chat.Type,
                };
                rabbitMqService.PublishMessageAsync("notification", "notification", "notification", notify.ToJSon());
            }
        }
        
      
        
        chat = await unitOfWork.ChatRepository.Add(chat);
        return mapper.Map<ChatResponseDTO>(chat);
    }

    private string SterilizeMessage( string id, string message, int type, RealTimeChatUserDataDto sender, RealTimeChatUserDataDto receiver, DateTime dateTime)
    {
        var json = new RealTimeChatDto
        {
            id = id,
            message = message,
            type = type,
            senderId = sender.id,
            receiverId = receiver.id,
            senderName = sender.name,
            receiverName = receiver.name,
            senderAvatar = sender.avatar,
            receiverAvatar = receiver.avatar,
            isRead = false,
            createdAt = DateTime.UtcNow
        };
        return json.ToJson();
    }
}
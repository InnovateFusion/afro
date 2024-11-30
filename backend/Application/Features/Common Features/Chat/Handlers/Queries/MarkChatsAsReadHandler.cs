using AutoMapper;
using backend.Application.Contracts.Infrastructure.Services;
using backend.Application.Contracts.Persistence;
using backend.Application.DTO.Common.Chat.DTO;
using backend.Application.Features.Common_Features.Chat.Requests.Queries;
using MediatR;

namespace backend.Application.Features.Common_Features.Chat.Handlers.Queries;

public class MarkChatsAsReadHandler(IUnitOfWork unitOfWork, IMapper mapper, IRabbitMQService rabbitMqService, ICacheService cacheService): IRequestHandler<MarkChatsAsReadRequest, int>
{
    public async Task<int> Handle(MarkChatsAsReadRequest request, CancellationToken cancellationToken)
    {
        rabbitMqService.PublishMessageAsync("isChatRead", "isChatRead", "isChatRead", JsonMessage(request.ChatId, request.SenderId, request.ReceiverId, true));
        var chats = await unitOfWork.ChatRepository.MarkChatsAsRead( request.ChatId);
        return chats;
    }

    private string JsonMessage(string chatId, string senderId, string receiverId, bool isRead)
    {
        var message = new MarkReadedChat
        {
            chatId = chatId,
            senderId = senderId,
            receiverId = receiverId,
            isRead = isRead
        };
        return message.ToJson();
    }
    
}

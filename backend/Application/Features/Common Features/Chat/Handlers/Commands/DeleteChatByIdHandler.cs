using AutoMapper;
using backend.Application.Contracts.Infrastructure.Repositories;
using backend.Application.Contracts.Infrastructure.Services;
using backend.Application.Contracts.Persistence;
using backend.Application.DTO.Common.Chat.DTO;
using backend.Application.Exceptions;
using backend.Application.Features.Common_Features.Chat.Requests.Commads;
using MediatR;

namespace backend.Application.Features.Common_Features.Chat.Handlers.Commands;

public class DeleteChatByIdHandler(IUnitOfWork unitOfWork, IMapper mapper, IRabbitMQService rabbitMqService, 	IImageRepository imageRepository)
    : IRequestHandler<DeleteChatByIdRequest, ChatResponseDTO>
{
    public async Task<ChatResponseDTO> Handle(DeleteChatByIdRequest request, CancellationToken cancellationToken)
    {
        var chat = await unitOfWork.ChatRepository.GetById(request.Id);
        if (chat == null)
        {
            throw new NotFoundException("Chat not found");
        }
        
        rabbitMqService.PublishMessageAsync("isChatDeleted", "isChatDeleted", "isChatDeleted", new RealTimeDeleteChatDto()
        {
            senderId = chat.SenderId,
            receiverId = chat.ReceiverId,
            chatId = chat.Id,
            isDeleted = true
        }.ToJson());
        
        rabbitMqService.PublishMessageAsync("delete-notification", "delete-notification", "delete-notification", chat.Id);

        // if (chat.Type == 1)
        // {
        //     await imageRepository.Delete(chat.Id);
        // }
        
        chat.IsDeleted = true;
        chat.DeletedAt = DateTime.UtcNow;
        await unitOfWork.ChatRepository.Update(chat);
        
        //await unitOfWork.ChatRepository.Delete(chat);
        return mapper.Map<ChatResponseDTO>(chat);
    }
}

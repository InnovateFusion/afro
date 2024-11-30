using AutoMapper;
using backend.Application.Contracts.Persistence;
using backend.Application.DTO.Common.Chat.DTO;
using backend.Application.Exceptions;
using backend.Application.Features.Common_Features.Chat.Requests.Queries;
using MediatR;

namespace backend.Application.Features.Common_Features.Chat.Handlers.Queries;

public class GetAllChatBetweenSenderAndReceiveByIdHandler(IUnitOfWork unitOfWork, IMapper mapper)
    : IRequestHandler<GetAllChatBetweenSenderAndReceiveById, List<ChatResponseDTO>>
{
    public async Task<List<ChatResponseDTO>> Handle(GetAllChatBetweenSenderAndReceiveById request, CancellationToken cancellationToken)
    {
        var chats = await unitOfWork.ChatRepository.GetAll(request.SenderId, request.ReceiverId, request.Skip, request.Take);
        var chatResponse = mapper.Map<List<ChatResponseDTO>>(chats);
        return chatResponse;
    }
}
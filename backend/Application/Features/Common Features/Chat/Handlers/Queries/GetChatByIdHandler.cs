using AutoMapper;
using backend.Application.Contracts.Persistence;
using backend.Application.DTO.Common.Chat.DTO;
using backend.Application.Exceptions;
using backend.Application.Features.Common_Features.Chat.Requests.Queries;
using MediatR;

namespace backend.Application.Features.Common_Features.Chat.Handlers.Queries;

public class GetChatByIdHandler(IUnitOfWork unitOfWork, IMapper mapper)
    : IRequestHandler<GetChatById, ChatResponseDTO>
{
    public async Task<ChatResponseDTO> Handle(GetChatById request, CancellationToken cancellationToken)
    {
        var chat = await unitOfWork.ChatRepository.GetById(request.Id);
        if (chat == null)
        {
            throw new NotFoundException("Chat not found");
        }

        var chatResponse = mapper.Map<ChatResponseDTO>(chat);
        return chatResponse;
    }
}

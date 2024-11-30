using backend.Application.DTO.Common.Chat.DTO;
using MediatR;

namespace backend.Application.Features.Common_Features.Chat.Requests.Commads;

public class DeleteChatByIdRequest: IRequest<ChatResponseDTO>
{
    public required string Id { get; set; }
}
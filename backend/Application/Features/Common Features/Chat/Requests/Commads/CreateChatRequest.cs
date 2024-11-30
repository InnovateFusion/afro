using backend.Application.DTO.Common.Chat.DTO;
using MediatR;

namespace backend.Application.Features.Common_Features.Chat.Requests.Commads;

public class CreateChatRequest:  IRequest<ChatResponseDTO>
{
    public required string SenderId { get; set; }
    public required CreateChatDTO Chat { get; set; }
}
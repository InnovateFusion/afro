using backend.Application.DTO.Common.Chat.DTO;
using MediatR;

namespace backend.Application.Features.Common_Features.Chat.Requests.Queries;

public class GetChatById: IRequest<ChatResponseDTO>
{
    public required string Id { get; set; }
}
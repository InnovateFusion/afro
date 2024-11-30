using backend.Application.DTO.Common.Chat.DTO;
using MediatR;

namespace backend.Application.Features.Common_Features.Chat.Requests.Queries;

public class GetAllChatBetweenSenderAndReceiveById: IRequest<List<ChatResponseDTO>>
{
    public required string SenderId { get; set; }
    public required string ReceiverId { get; set; }
    public required int Skip { get; set; }
    public required int Take { get; set; }
}
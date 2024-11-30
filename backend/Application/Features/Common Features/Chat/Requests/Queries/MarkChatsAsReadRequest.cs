using backend.Application.DTO.User.UserDTO.DTO;
using MediatR;

namespace backend.Application.Features.Common_Features.Chat.Requests.Queries;

public class MarkChatsAsReadRequest : IRequest<int>
{
    public required  string ChatId { get; set; }
    public required string SenderId { get; set; }
    public required string ReceiverId { get; set; }
}
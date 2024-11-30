using backend.Application.DTO.Common.Chat.DTO;
using backend.Application.DTO.User.UserDTO.DTO;
using MediatR;

namespace backend.Application.Features.Common_Features.Chat.Requests.Queries;

public class GetUsersChatWithLastMessageRequests : IRequest<List<UserChatDtoResponse>>
{
    public required string UserId { get; set; }
    public required int Skip { get; set; }
    public required int Take { get; set; }
}
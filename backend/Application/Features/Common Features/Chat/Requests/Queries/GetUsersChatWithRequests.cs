using backend.Application.DTO.User.UserDTO.DTO;
using MediatR;

namespace backend.Application.Features.Common_Features.Chat.Requests.Queries;

public class GetUsersChatWithRequests : IRequest<List<UserResponseDTO>>
{
    public required string UserId { get; set; }
    public required int Skip { get; set; }
    public required int Take { get; set; }
}
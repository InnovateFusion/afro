using backend.Application.DTO.User.UserDTO.DTO;

namespace backend.Application.DTO.Common.Chat.DTO;

public class UserChatDtoResponse
{
    public required UserResponseDTO User { get; set; }
    
    public required Domain.Entities.Common.Chat LastMessage { get; set; }
}
using backend.Application.DTO.User.UserDTO.DTO;

namespace backend.Application.DTO.Common.Chat.DTO;

public class ChatResponseDTO
{
    public required string Id { get; set; }
    public required string Message { get; set; }
    public int Type { get; set; }
    public required string SenderId { get; set; }
    public required string ReceiverId { get; set; }
    public required DateTime CreatedAt { get; set; }
    public required bool IsRead { get; set; }
}
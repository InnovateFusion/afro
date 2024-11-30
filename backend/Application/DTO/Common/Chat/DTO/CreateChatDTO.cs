namespace backend.Application.DTO.Common.Chat.DTO;
public class CreateChatDTO
{
    public required string Message { get; set; }
    public int Type { get; set; }
    public required string ReceiverId { get; set; }
}
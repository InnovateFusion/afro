namespace backend.Application.DTO.Common.Chat.DTO;

public class UserChatDto
{
    public required Domain.Entities.User.User User { get; set; }
    public required Domain.Entities.Common.Chat? LastMessage { get; set; }
}
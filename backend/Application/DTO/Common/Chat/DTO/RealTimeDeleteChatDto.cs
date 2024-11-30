using Newtonsoft.Json;

namespace backend.Application.DTO.Common.Chat.DTO;

public class RealTimeDeleteChatDto
{
    public required string senderId { get; set; }
    public required  string receiverId { get; set; }
    public required bool isDeleted { get; set; }
    public required string chatId { get; set; }
    
    public string ToJson()
    {
        return JsonConvert.SerializeObject(this);
    }
}
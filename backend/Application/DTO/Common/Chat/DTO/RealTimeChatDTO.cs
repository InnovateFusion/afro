using Newtonsoft.Json;

namespace backend.Application.DTO.Common.Chat.DTO;

public class RealTimeChatDto
{
    public required string id { get; set; }
    public required string message { get; set; }
    public int type { get; set; }
    public required string senderId { get; set; }
    public required string receiverId { get; set; }
    public required string senderName { get; set; }
    public required string receiverName { get; set; }
    public required string senderAvatar { get; set; }
    public required string receiverAvatar { get; set; }
    public required bool isRead { get; set; }
    public required DateTime createdAt { get; set; }
    
    public string ToJson()
    {
        return JsonConvert.SerializeObject(this);
    }
}
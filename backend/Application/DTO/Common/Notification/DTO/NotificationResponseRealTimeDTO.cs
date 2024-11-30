using backend.Application.DTO.User.UserDTO.DTO;
using backend.Application.Enum;
using Newtonsoft.Json;

namespace backend.Application.DTO.Common.Notification.DTO;

class NotificationResponseRealTimeDto
{
    public required string Id { get; set; }
    public required string TypeId { get; set; } 
    public required string ReceiverId { get; set; }
    public required string Message { get; set; }
    public required NotificationType Type { get; set; }
    public required bool IsRead { get; set; }
    public required DateTime CreatedAt { get; set; }
    public required string FirstName { get; set; }
    public required string LastName { get; set; }
    public required string Avatar { get; set; }
    public required bool IsAdmin { get; set; } = false;
    public required int MessageType { get; set; } = 0;
    
    public string ToJSon()
    {
        return JsonConvert.SerializeObject(this);
    }
    
    public static NotificationResponseDto? FromJson(string data)
    {
        return JsonConvert.DeserializeObject<NotificationResponseDto>(data);
    }
}
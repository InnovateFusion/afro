using backend.Application.DTO.User.UserDTO.DTO;
using backend.Application.Enum;
namespace backend.Application.DTO.Common.Notification.DTO;

public class NotificationResponseDto
{
    public string Id { get; set; }
    public string Message { get; set; }
    public NotificationType Type { get; set; }
    public bool IsRead { get; set; }
    public required DateTime CreatedAt { get; set; }
    public string TypeId { get; set; }
    public UserNotificationSharedResponse Sender { get; set; }
    public bool IsAdmin { get; set; }
    public int MessageType { get; set; }
    
}
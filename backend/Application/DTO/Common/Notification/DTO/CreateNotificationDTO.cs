using backend.Application.Enum;

namespace backend.Application.DTO.Common.Notification.DTO;

public class CreateNotificationDto
{
    public string Message { get; set; }
    public NotificationType Type { get; set; }
    public required string ReceiverId { get; set; }
}
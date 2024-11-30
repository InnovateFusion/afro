using backend.Application.Enum;

namespace backend.Application.DTO.Common.Notification.DTO;

public class UpdateNotificationDto
{
    public required string Id { get; set; }
    public string? Message { get; set; }
}
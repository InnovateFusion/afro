using System.ComponentModel.DataAnnotations;
using backend.Domain.Common;

namespace backend.Domain.Entities.Common;

public class Chat: BaseEntity
{
    public required string Message { get; set; }
    public required int Type { get; set; }
    [Required]
    public required string SenderId { get; set; }
    [Required]
    public required string ReceiverId { get; set; }
    public bool IsRead { get; set; } = false;
    
    public bool IsDeleted { get; set; } = false;
    
    public DateTime DeletedAt { get; set; }
    
    public override string ToString()
    {
        return $"Id: {Id}, Message: {Message}, Type: {Type}, IsRead: {IsRead}, SenderId: {SenderId}, ReceiverId: {ReceiverId}";
    }
}
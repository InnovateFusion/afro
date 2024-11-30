using System.ComponentModel.DataAnnotations.Schema;
using backend.Application.Enum;
using backend.Domain.Common;
using Newtonsoft.Json;

namespace backend.Domain.Entities.Common;

public class Notification : BaseEntity
{
    public required string Message { get; set; }
    public required int Type { get; set; }
    public required string TypeId { get; set; }
    public bool IsRead { get; set; } = false;
    [ForeignKey("User")]
    public required string SenderId { get; set; }
    [ForeignKey("User")]
    public required string ReceiverId { get; set; }
    public  User.User Sender { get; set; }
    public  User.User Receiver { get; set; }
    public bool IsAdmin { get; set; } = false;
    public int MessageType { get; set; } = 0;
    
    public override string ToString()
    {
        return $"Id: {Id}, Message: {Message}, Type: {Type}, IsRead: {IsRead}, SenderId: {SenderId}, ReceiverId: {ReceiverId}, TypeId: {TypeId}, CreatedAt: {CreatedAt}, UpdatedAt: {UpdatedAt}, MessageType: {MessageType}, IsAdmin: {IsAdmin}";
    }
    
    public void MarkAsRead()
    {
        IsRead = true;
    }

    public string ToJson()
    {
        return JsonConvert.SerializeObject(this);
    }
}
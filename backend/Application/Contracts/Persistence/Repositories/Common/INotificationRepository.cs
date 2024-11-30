using backend.Application.Enum;
using backend.Domain.Entities.Common;
using Task = Twilio.TwiML.Voice.Task;

namespace backend.Application.Contracts.Persistence.Repositories.Common;

public interface INotificationRepository: IGenericRepository<Notification>
{
    Task<IReadOnlyList<Notification>> GetAll(string userId, int skip, int limit);
    Task<Notification> GetById(string id);
    Task<bool> MarkAsRead(string userId);

    Task<IReadOnlyList<string>> SendNotificationForFollower(string message, string shopId, NotificationType type,
        string typeId, int messageType);
    
    Task<bool> DeleteNotification(string typeId);
}
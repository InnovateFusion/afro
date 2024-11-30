using backend.Application.Contracts.Persistence.Repositories.Common;
using backend.Application.DTO.User.UserDTO.DTO;
using backend.Application.Enum;
using backend.Domain.Entities.Common;
using backend.Persistence.Configuration;
using Microsoft.EntityFrameworkCore;

namespace backend.Persistence.Repositories.Common;

public class NotificationRepository(StyleHubDBContext context)
    : GenericRepository<Notification>(context), INotificationRepository
{
    public async Task<IReadOnlyList<Notification>> GetAll(string userId, int skip, int take)
    {
        var result = await context.Notifications.Include(u => u.Sender).Where(u => u.ReceiverId == userId).OrderByDescending(u => u.CreatedAt).Skip(skip).Take(take).ToListAsync();
        foreach (var item in result)
        {
            if (item.Type == (int)NotificationType.AddProduct)
            {
                var shop = await context.Shops.FirstOrDefaultAsync(u => u.Id == item.SenderId);
                if (shop != null)
                {
                    item.Sender.FirstName = shop.Name;
                    item.Sender.LastName = "";
                    item.Sender.ProfilePicture = shop.Logo;
                }
            }
        }
        return result;
    }

    public async Task<Notification> GetById(string id)
    {
        var notification = await context.Notifications.FirstOrDefaultAsync(u => u.Id == id);
        return notification!;
    }

    public async Task<bool> MarkAsRead(string userId)
    {
        var notifications = await context.Notifications
            .Where(u => u.Receiver.Id == userId && !u.IsRead)
            .ToListAsync();

        if (notifications.Any())
        {
            notifications.ForEach(n => n.IsRead = true);
            await context.SaveChangesAsync();
        }

        return true;
    }

    public async Task<IReadOnlyList<string>> SendNotificationForFollower(string message, string shopId, NotificationType type, string typeId, int messageType)
    {
        int batchSize = 1000;
        var followers = new List<string>();
        var notifications = new List<Notification>();
        
        try
        {
            // Fetch followers for the shop
            var followerList = await context.ShopFollows
                                            .Where(u => u.ShopId == shopId)
                                            .Select(u => u.UserId)
                                            .ToListAsync();  // Changed to synchronous for debugging purposes

            if (followerList.Count == 0)
            {
                Console.WriteLine("No followers found for the shop.");
                return followers.AsReadOnly();
            }

            Console.WriteLine($"{followerList.Count} followers found for shopId: {shopId}");

            // Loop through followers and build notifications
            foreach (var follower in followerList)
            {
                followers.Add(follower);
                
                notifications.Add(new Notification
                {
                    Message = message,
                    ReceiverId = follower,
                    SenderId = shopId,
                    Type = (int)type,
                    TypeId = typeId,
                    MessageType = messageType
                });

                if (notifications.Count >= batchSize)
                {
                    await SaveNotificationsBatch(notifications);
                    notifications.Clear();  // Clear the list after saving
                }
            }

            // Save remaining notifications if any
            if (notifications.Count > 0)
            {
                await SaveNotificationsBatch(notifications);
            }
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Error fetching followers or processing notifications: {ex.Message}");
        }

        return followers.AsReadOnly();
    }

    private async Task SaveNotificationsBatch(List<Notification> notifications)
    {
        try
        {
            await context.Notifications.AddRangeAsync(notifications);
            await context.SaveChangesAsync();

            Console.WriteLine($"{notifications.Count} notifications successfully saved to the database.");
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Error saving notifications batch: {ex.Message}");
        }
    }
    public async Task<bool> DeleteNotification(string typeId)
    {
        int affectedRows = await context.Notifications
            .Where(u => u.TypeId == typeId)
            .ExecuteDeleteAsync();
        return affectedRows > 0;
    }

}
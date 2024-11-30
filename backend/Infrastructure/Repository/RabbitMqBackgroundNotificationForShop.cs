using System.Text;
using backend.Application.Contracts.Persistence;
using backend.Application.Contracts.Infrastructure.Services;
using backend.Application.DTO.Common.Notification.DTO;
using backend.Application.Enum;
using backend.Domain.Entities.Common;
using backend.WebApi.Controllers.RealTime;
using RabbitMQ.Client;
using RabbitMQ.Client.Events;
using Newtonsoft.Json;
using Microsoft.AspNetCore.SignalR;
using Microsoft.Extensions.DependencyInjection;

namespace backend.Infrastructure.Repository;

public class RabbitMqBackgroundNotificationForShop : BackgroundService
{
    private readonly IModel _channel;
    private readonly IServiceProvider _serviceProvider; // Inject IServiceProvider
    private readonly ICacheService _cacheService;
    private readonly IHubContext<ChatHub> _hubContext;

    public RabbitMqBackgroundNotificationForShop(
        IModel channel,
        IServiceProvider serviceProvider,  // Use IServiceProvider to resolve scoped services
        ICacheService cacheService,
        IHubContext<ChatHub> hubContext
    )
    {
        _channel = channel;
        _serviceProvider = serviceProvider;
        _cacheService = cacheService;
        _hubContext = hubContext;
    }

    protected override Task ExecuteAsync(CancellationToken stoppingToken)
    {
        stoppingToken.ThrowIfCancellationRequested();

        // Declare the queue
        _channel.QueueDeclare(queue: "notification-shop",
            durable: false,
            exclusive: false,
            autoDelete: false,
            arguments: null);

        var consumer = new EventingBasicConsumer(_channel);
        consumer.Received += async (model, ea) =>
        {
            var body = ea.Body.ToArray();
            var message = Encoding.UTF8.GetString(body);
            var notification = JsonConvert.DeserializeObject<Notification>(message);
            if (notification != null)
            {
                // Create a new scope to resolve scoped services
                using (var scope = _serviceProvider.CreateScope())
                {
                    var unitOfWork = scope.ServiceProvider.GetRequiredService<IUnitOfWork>();
                    await SendNotificationForFollower(notification, unitOfWork);
                }
            }
            Console.WriteLine(" [x] Received {0}", message);
        };

        _channel.BasicConsume(queue: "notification-shop",
            autoAck: true,
            consumer: consumer);

        return Task.CompletedTask;
    }

    private async Task SendNotificationForFollower(Notification notification, IUnitOfWork unitOfWork)
    {
        // Use unitOfWork within the scope to send notifications
        var usersId = await unitOfWork.NotificationRepository.SendNotificationForFollower(
            notification.Message,
            notification.SenderId,
            (NotificationType)notification.Type,
            notification.TypeId,
            messageType: notification.MessageType
        );
        
        var shop = await unitOfWork.ShopRepository.GetShopByIdAsync(notification.SenderId);
        var notificationResponse = new NotificationResponseRealTimeDto
        {
            Id = notification.Id,
            TypeId = notification.TypeId,
            ReceiverId = notification.ReceiverId,
            Message = notification.Message,
            Type = (NotificationType)notification.Type,
            IsRead = notification.IsRead,
            CreatedAt = notification.CreatedAt,
            FirstName = shop.Name,
            LastName = "",
            Avatar = shop.Logo,
            IsAdmin = false,
            MessageType = notification.MessageType,
        };
        // Broadcast to all users
        foreach (var id in usersId)
        {
            await BroadcastToUser(id, "notification", notificationResponse.ToJSon());
        }
    }

    private async Task BroadcastToUser(string userId, string type, string message)
    {
        if (await _cacheService.KeyExists($"{userId}-data"))
        {
            var connectionIds = await _cacheService.GetSetMembers(userId);
            foreach (var connectionId in connectionIds)
            {
                await _hubContext.Clients.Client(connectionId).SendAsync("ReceiveMessage", type, message);
            }
        }
    }
}

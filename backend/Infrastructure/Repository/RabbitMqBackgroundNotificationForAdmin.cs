using System.Text;
using backend.Application.Contracts.Persistence;
using backend.Application.Contracts.Infrastructure.Services;
using backend.WebApi.Controllers.RealTime;
using RabbitMQ.Client;
using RabbitMQ.Client.Events;
using Microsoft.AspNetCore.SignalR;

namespace backend.Infrastructure.Repository;

public class RabbitMqBackgroundNotificationForAdmin(
    IModel channel,
    IServiceProvider serviceProvider, 
    ICacheService cacheService,
    IHubContext<ChatHub> hubContext)
    : BackgroundService
{
    protected override Task ExecuteAsync(CancellationToken stoppingToken)
    {
        stoppingToken.ThrowIfCancellationRequested();
        
        channel.QueueDeclare(queue: "notification-for-admin-product",
            durable: false,
            exclusive: false,
            autoDelete: false,
            arguments: null);

        var consumer = new EventingBasicConsumer(channel);
        consumer.Received += async (model, ea) =>
        {
            var body = ea.Body.ToArray();
            var message = Encoding.UTF8.GetString(body);
            using (var scope = serviceProvider.CreateScope())
            {
                var unitOfWork = scope.ServiceProvider.GetRequiredService<IUnitOfWork>();
                await SendNotificationForAdmin(message, unitOfWork);
            }
            Console.WriteLine(" [x] Received {0}", message);
        };

        channel.BasicConsume(queue: "notification-for-admin-product",
            autoAck: true,
            consumer: consumer);

        return Task.CompletedTask;
    }

    private async Task SendNotificationForAdmin(string message, IUnitOfWork unitOfWork)
    {
        var role = await unitOfWork.RoleRepository.GetByName("admin");
        if (role != null)
        {
            var admins = await unitOfWork.UserRepository.GetUserByRole(role.Id, 0, 50);
            for (int i = 0; i < admins.Count(); i++)
                await BroadcastToUser(admins[i].Id, "notification-for-admin-product", message);
        }
    }

    private async Task BroadcastToUser(string userId, string type, string message)
    {
        if (await cacheService.KeyExists($"{userId}-data"))
        {
            var connectionIds = await cacheService.GetSetMembers(userId);
            foreach (var connectionId in connectionIds)
            {
                await hubContext.Clients.Client(connectionId).SendAsync("ReceiveMessage", type, message);
            }
        }
    }
}

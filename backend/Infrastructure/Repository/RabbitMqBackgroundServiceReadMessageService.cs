using System.Text;
using backend.Application.Contracts.Infrastructure.Services;
using backend.Application.DTO.Common.Chat.DTO;
using backend.WebApi.Controllers.RealTime;
using RabbitMQ.Client;
using RabbitMQ.Client.Events;
using Microsoft.AspNetCore.SignalR;
using Newtonsoft.Json;

namespace backend.Infrastructure.Repository;

public class RabbitMqBackgroundServiceReadMessageService(
    RabbitMQ.Client.IModel channel,
    ICacheService cacheService,
    IHubContext<ChatHub> hubContext

)
    : BackgroundService
{
    protected override Task ExecuteAsync(CancellationToken stoppingToken)
    {
        stoppingToken.ThrowIfCancellationRequested();
        
        channel.QueueDeclare(queue: "isChatRead",
            durable: false,
            exclusive: false,
            autoDelete: false,
            arguments: null);
        
        var consumer = new EventingBasicConsumer(channel);
        consumer.Received += async (model, ea) =>
        {
            var body = ea.Body.ToArray();
            var message = Encoding.UTF8.GetString(body);
            var chatResponse = JsonConvert.DeserializeObject<MarkReadedChat>(message);
            await BroadcastToUser(chatResponse?.senderId ?? "", "isChatRead", message);
            await BroadcastToUser(chatResponse?.receiverId ?? "", "isChatRead", message);
            Console.WriteLine(" [x] Received {0}", message);
        };
        
        channel.BasicConsume(queue: "isChatRead",
            autoAck: true,
            consumer: consumer);

        return Task.CompletedTask;
    }
    
    private async Task BroadcastToUser(string userId, string type, string message)
    {
        var connectionIds = await cacheService.GetSetMembers(userId);
        foreach (var connectionId in connectionIds)
        {
            await hubContext.Clients.Client( connectionId).SendAsync("ReceiveMessage", type, message);
        }
    }
    
}
using System.Text;
using backend.Application.Contracts.Persistence;
using RabbitMQ.Client;
using RabbitMQ.Client.Events;
using Microsoft.Extensions.DependencyInjection;

namespace backend.Infrastructure.Repository;

public class RabbitMqBackgroundDeleteNotification : BackgroundService
{
    private readonly IModel _channel;
    private readonly IServiceProvider _serviceProvider; // Inject service provider to create scopes

    public RabbitMqBackgroundDeleteNotification(
        IModel channel,
        IServiceProvider serviceProvider // Inject service provider instead of directly injecting IUnitOfWork
    )
    {
        _channel = channel;
        _serviceProvider = serviceProvider;
    }

    protected override Task ExecuteAsync(CancellationToken stoppingToken)
    {
        stoppingToken.ThrowIfCancellationRequested();

        // Declare the queue
        _channel.QueueDeclare(queue: "delete-notification",
            durable: false,
            exclusive: false,
            autoDelete: false,
            arguments: null);

        var consumer = new EventingBasicConsumer(_channel);
        consumer.Received += async (model, ea) =>
        {
            var body = ea.Body.ToArray();
            var message = Encoding.UTF8.GetString(body);

            // Create a scope to resolve IUnitOfWork
            using (var scope = _serviceProvider.CreateScope())
            {
                var unitOfWork = scope.ServiceProvider.GetRequiredService<IUnitOfWork>();
                await DeleteNotification(message, unitOfWork);
            }

            Console.WriteLine(" [x] Received {0}", message);
        };

        _channel.BasicConsume(queue: "delete-notification",
            autoAck: true,
            consumer: consumer);

        return Task.CompletedTask;
    }

    private async Task DeleteNotification(string id, IUnitOfWork unitOfWork)
    {
        await unitOfWork.NotificationRepository.DeleteNotification(id);
    }
}

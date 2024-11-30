namespace backend.Application.Contracts.Infrastructure.Services;

public interface IRabbitMQService
{
    void PublishMessageAsync(string queue, string exchange, string routingKey, string message);
}
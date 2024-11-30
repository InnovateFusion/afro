using System.Text;
using backend.Application.Contracts.Infrastructure.Services;
using RabbitMQ.Client;


namespace backend.Infrastructure.Repository
{
    public class RabbitMqService(RabbitMQ.Client.IModel channel) : IRabbitMQService
    {
        public void PublishMessageAsync(string queue, string exchange, string routingKey, string message)
        {
         
            channel.QueueDeclare(queue: queue,
                durable: false,
                exclusive: false,
                autoDelete: false,
                arguments: null);

            var body = Encoding.UTF8.GetBytes(message);

            channel.BasicPublish(exchange: string.Empty,
                routingKey: routingKey,
                basicProperties: null,
                body: body);

        }
        
    }
}
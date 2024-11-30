using backend.Infrastructure.Models;
using RabbitMQ.Client;

namespace backend.Infrastructure.Configuration
{
    public static class RabbitMqConfig
    {
        public static RabbitMQ.Client.IModel Configure(RabbitMQSettings apiSettings)
        {
            var factory = new ConnectionFactory { HostName = apiSettings.Hostname, UserName = apiSettings.Username, Password = apiSettings.Password};
            var connection = factory.CreateConnection();
            var channel = connection.CreateModel();
            return channel;
        }
    }
}
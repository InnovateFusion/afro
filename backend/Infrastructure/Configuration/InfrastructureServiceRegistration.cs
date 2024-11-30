using System.Text;
using backend.Application.Common;
using backend.Application.Contracts.Infrastructure.Repositories;
using backend.Application.Contracts.Infrastructure.Services;
using backend.Infrastructure.Models;
using backend.Infrastructure.Repository;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.IdentityModel.Tokens;
using StackExchange.Redis;

namespace backend.Infrastructure.Configuration
{
    public static class InfrastructureServiceRegistration
    {
        public static IServiceCollection ConfigureInfrastructureService(
            this IServiceCollection services,
            IConfiguration configuration,
            IHostEnvironment hostEnvironment
        )
        {
            var cloudinarySettings = new CloudinarySettings();
            var rabbitMq = new RabbitMQSettings();
            var tiktokSetting = new TikTokSettings();
            var blobStorageSettings = new BlobStorageSettings();
            if (hostEnvironment.IsDevelopment())
            {
                services.Configure<EmailSettings>(options =>
                    configuration.GetSection("EmailSettings").Bind(options)
                );

                services.Configure<PhoneNumberOTPSettings>(options =>
                    configuration.GetSection("PhoneNumberOTPSettings").Bind(options)
                );

                services.Configure<ApiSettings>(options =>
                    configuration.GetSection("ApiSettings").Bind(options)
                );

                services.Configure<JwtSettings>(options =>
                    configuration.GetSection("JwtSettings").Bind(options)
                );

                services.Configure<CloudinarySettings>(options =>
                    configuration.GetSection("CloudinarySettings").Bind(options)
                );
                
                services.Configure<TikTokSettings>(options =>
                    configuration.GetSection("TikTokSettings").Bind(options)
                );
                
                services.Configure<BlobStorageSettings>(options =>
                    configuration.GetSection("BlobStorageSettings").Bind(options)
                );
                
                cloudinarySettings.CloudName = configuration["CloudinarySettings:CloudName"];
                cloudinarySettings.APIKey = configuration["CloudinarySettings:APIKey"];
                cloudinarySettings.APISecret = configuration["CloudinarySettings:APISecret"];
                
                rabbitMq.Hostname = configuration["RabbitMQSettings:Hostname"] ?? "";
                rabbitMq.Username = configuration["RabbitMQSettings:Username"] ?? "";
                rabbitMq.Password = configuration["RabbitMQSettings:Password" ] ?? "";
                
                tiktokSetting.ClientId = configuration["TikTokSettings:ClientId"] ?? "";
                tiktokSetting.ClientSecret = configuration["TikTokSettings:ClientSecret"] ?? "";
                tiktokSetting.RedirectUri = configuration["TikTokSettings:RedirectUri"] ?? "";
                tiktokSetting.CodeVerifier = configuration["TikTokSettings:CodeVerifier"] ?? "";
                
                blobStorageSettings.ConnectionString = configuration["BlobStorageSettings:ConnectionString"];
                blobStorageSettings.ContainerName = configuration["BlobStorageSettings:ContainerName"];
                blobStorageSettings.BlobUrl = configuration["BlobStorageSettings:BlobUrl"];
                blobStorageSettings.ImageBackgroundRemoverUrl = configuration["BlobStorageSettings:ImageBackgroundRemoverUrl"];
                
                var redisConnectionString = configuration.GetConnectionString("Redis") ?? "";

                services
                    .AddAuthentication(options =>
                    {
                        options.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
                        options.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
                    })
                    .AddJwtBearer(options =>
                    {
                        options.TokenValidationParameters = new TokenValidationParameters
                        {
                            ValidateIssuer = true,
                            ValidateAudience = true,
                            ValidateLifetime = true,
                            ValidateIssuerSigningKey = true,
                            ValidIssuer = configuration["JwtSettings:Issuer"],
                            ValidAudience = configuration["JwtSettings:Audience"],
                            ClockSkew = TimeSpan.Zero,
                            IssuerSigningKey = new SymmetricSecurityKey(
                                Encoding.UTF8.GetBytes(configuration["JwtSettings:Key"] ?? "")
                            )
                        };
                        
                        options.Events = new JwtBearerEvents
                        {
                            OnMessageReceived = context =>
                            {
                                var accessToken = context.Request.Query["access_token"];
                                var path = context.HttpContext.Request.Path;
                                if (!string.IsNullOrEmpty(accessToken) &&
                                    (path.StartsWithSegments("/chatHub")))
                                {
                                    context.Token = accessToken;
                                }
                                return Task.CompletedTask;
                            }
                        };
                    });
                
                services.AddSingleton<IConnectionMultiplexer>(ConnectionMultiplexer.Connect(redisConnectionString));
            }
            else
            {
                services.Configure<EmailSettings>(options =>
                {
                    options.SenderEmail = Environment.GetEnvironmentVariable("SenderEmail");
                    options.SenderPassword = Environment.GetEnvironmentVariable("SenderPassword");
                    options.DisplayName = Environment.GetEnvironmentVariable("DisplayName");
                });

                services.Configure<PhoneNumberOTPSettings>(options =>
                {
                    options.AccountSid = Environment.GetEnvironmentVariable("AccountSid");
                    options.AuthToken = Environment.GetEnvironmentVariable("AuthToken");
                    options.PhoneNumber = Environment.GetEnvironmentVariable("PhoneNumber");
                });

                services.Configure<ApiSettings>(options =>
                {
                    options.SecretKey = Environment.GetEnvironmentVariable("SecretKey");
                });

                services.Configure<JwtSettings>(options =>
                {
                    options.Key = Environment.GetEnvironmentVariable("JwtKey");
                    options.Issuer = Environment.GetEnvironmentVariable("Issuer");
                    options.Audience = Environment.GetEnvironmentVariable("Audience");
                });

                services.Configure<CloudinarySettings>(options =>
                {
                    options.CloudName = Environment.GetEnvironmentVariable("CloudName");
                    options.APIKey = Environment.GetEnvironmentVariable("APIKey");
                    options.APISecret = Environment.GetEnvironmentVariable("APISecret");
                });
                
                services.Configure<TikTokSettings>(options =>
                {
                    options.ClientId = Environment.GetEnvironmentVariable("ClientId");
                    options.ClientSecret = Environment.GetEnvironmentVariable("ClientSecret");
                    options.RedirectUri = Environment.GetEnvironmentVariable("RedirectUri");
                    options.CodeVerifier = Environment.GetEnvironmentVariable("CodeVerifier");
                });
                
                services.Configure<BlobStorageSettings>(options =>
                {
                    options.ConnectionString = Environment.GetEnvironmentVariable("BlobStorageConnectionString");
                    options.ContainerName = Environment.GetEnvironmentVariable("BlobStorageContainerName");
                    options.BlobUrl = Environment.GetEnvironmentVariable("BlobStorageBlobUrl");
                    options.ImageBackgroundRemoverUrl = Environment.GetEnvironmentVariable("BlobStorageImageBackgroundRemoverUrl");
                });

                var key = Encoding.ASCII.GetBytes(
                    Environment.GetEnvironmentVariable("JwtKey") ?? ""
                );
                
                var redisConnectionString = Environment.GetEnvironmentVariable("Redis") ?? "";

                services
                    .AddAuthentication(
                        Microsoft
                            .AspNetCore
                            .Authentication
                            .JwtBearer
                            .JwtBearerDefaults
                            .AuthenticationScheme
                    )
                    .AddJwtBearer(options =>
                    {
                        options.TokenValidationParameters = new TokenValidationParameters
                        {
                            ValidateIssuer = true,
                            ValidateAudience = true,
                            ValidateLifetime = true,
                            ValidateIssuerSigningKey = true,
                            ValidIssuer = Environment.GetEnvironmentVariable("Issuer"),
                            ValidAudience = Environment.GetEnvironmentVariable("Audience"),
                            IssuerSigningKey = new SymmetricSecurityKey(key)
                        };
                    });

                Console.WriteLine(
                    "EmailSettings: " + Environment.GetEnvironmentVariable("SenderEmail")
                );
                Console.WriteLine(
                    "PhoneNumberOTPSettings: " + Environment.GetEnvironmentVariable("AccountSid")
                );
                Console.WriteLine(
                    "ApiSettings: " + Environment.GetEnvironmentVariable("SecretKey")
                );
                Console.WriteLine("JwtSettings: " + Environment.GetEnvironmentVariable("JwtKey"));
                Console.WriteLine(
                    "CloudinarySettings: " + Environment.GetEnvironmentVariable("CloudName")
                );
                Console.WriteLine(
                    "CloudinarySettings: " + Environment.GetEnvironmentVariable("APIKey")
                );
                Console.WriteLine(
                    "CloudinarySettings: " + Environment.GetEnvironmentVariable("APISecret")
                );
               
                cloudinarySettings.CloudName = Environment.GetEnvironmentVariable("CloudName");
                cloudinarySettings.APIKey = Environment.GetEnvironmentVariable("APIKey");
                cloudinarySettings.APISecret = Environment.GetEnvironmentVariable("APISecret");
                
                rabbitMq.Hostname = Environment.GetEnvironmentVariable("RabbitMqHostname") ?? "";
                rabbitMq.Username = Environment.GetEnvironmentVariable("RabbitMqUsername") ?? "";
                rabbitMq.Password = Environment.GetEnvironmentVariable("RabbitMqPassword") ?? "";
                
                services.AddSingleton<IConnectionMultiplexer>(ConnectionMultiplexer.Connect(redisConnectionString));
            }
            
            services.AddScoped<IImageRepository, ImageRepository>();
            services.AddScoped<IAuthenticationService, AuthenticationService>();
            services.AddSingleton(CloudinaryConfiguration.Configure(cloudinarySettings));
            services.AddSingleton(RabbitMqConfig.Configure(rabbitMq));
            services.AddSingleton<RabbitMQ.Client.IModel>(provider => RabbitMqConfig.Configure(rabbitMq));
            services.AddHttpClient<PhoneNumberOTPManager>();
            services.AddHttpContextAccessor();
            services.AddSingleton<PhoneNumberOTPManager>();
            services.AddScoped<IOtpService, OtpService>();
            services.AddScoped<IEmailSender, EmailSender>();
            services.AddScoped<ICurrentLoggedInService, CurrentLoggedInService>();
            services.AddScoped<IAzureBlobStorageService, AzureBlobStorageService>();
            services.AddScoped<IRabbitMQService, RabbitMqService>();
            services.AddHostedService<RabbitMqBackgroundService>();
            services.AddHostedService<RabbitMqBackgroundServiceReadMessageService>();
            services.AddHostedService<RabbitMqBackgroundNotificationForShop>();
            services.AddHostedService<RabbitMqBackgroundDeleteChatService>();
            services.AddHostedService<RabbitMqBackgroundNotification>();
            services.AddHostedService<RabbitMqBackgroundDeleteNotification>();
            services.AddHostedService<RabbitMqBackgroundNotificationForAdmin>();
            services.AddSingleton<ICacheService, CacheService>();
            services.AddAuthorization(options =>
            {
                options.AddPolicy("Admin", policy => policy.RequireRole("admin"));
                options.AddPolicy("User", policy => policy.RequireRole("user"));
            });

            return services;
        }
    }
}
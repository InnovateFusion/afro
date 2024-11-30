using backend.Application.DTO.User.UserDTO.DTO;
using backend.Domain.Entities.Common;

namespace backend.Application.DTO.User.AuthenticationDTO.DTO
{
    public class AuthenticationResponseDTO
    {
        public required string Id { get; set; }
        public string? FirstName { get; set; }
        public string? LastName { get; set; }
        public string? PhoneNumber { get; set; }
        public string? Email { get; set; }
        public string? Token { get; set; }
        public string? RefreshToken { get; set; }
        public double? Latitude { get; set; }
        public double? Longitude { get; set; }
        public string? ProfilePicture { get; set; }
        public string? Street { get; set; }
        public string? SubLocality { get; set; }
        public string? SubAdministrativeArea { get; set; }
        public string? PostalCode { get; set; }
        public string? Gender { get; set; }
        public DateTime? DateOfBirth { get; set; }
        public string? ProductCategoryPreferences { get; set; }
        public string? ProductSizePreferences { get; set; }
        public string? ProductDesignPreferences { get; set; }
        public string? ProductBrandPreferences { get; set; }
        public string? ProductColorPreferences { get; set; }
        public int RegisterWith { get; set; }
        public string? TikTokAccessToken { get; set; }
        public string? TikTokRefreshToken { get; set; }
        public required UserNotificationSettingSharedDto? NotificationSettings { get; set; }
        public bool IsEmailVerified { get; set; }
        public required Role Role { get; set; }
        public  String Version { get; set; } = "1.0.0";
    }
}

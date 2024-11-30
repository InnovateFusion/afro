using backend.Application.DTO.User.UserDTO.DTO;
using backend.Application.Enum;
using backend.Domain.Common;
using backend.Domain.Entities.Common;

namespace backend.Domain.Entities.User
{
    public class User : BaseEntity
    {
        public  int RegisterWith { get; set; } = (int) RegisterType.WithEmail;
        public string? FirstName { get; set; }
        public string? LastName { get; set; }
        public string? PhoneNumber { get; set; }
        public string? Password { get; set; }
        public string? Street { get; set; }
        public string? SubLocality { get; set; }
        public string? SubAdministrativeArea { get; set; }
        public string? PostalCode { get; set; }
        public double? Latitude { get; set; }
        public double? Longitude { get; set; }
        public string? ProfilePicture { get; set; }
        public string? Email { get; set; }
        public DateTime? DateOfBirth { get; set; }
        public string? Gender { get; set; }
        public string? productCategoryPreferences { get; set; }
        public string? productSizePreferences { get; set; }
        public string? productDesignPreferences { get; set; }
        public string? productBrandPreferences { get; set; }
        public string? productColorPreferences { get; set; }
        public bool IsEmailVerified { get; set; } = false;
        public int OtpVerificationTrail { get; set; } = 0;
        public bool IsPhoneNumberVerified { get; set; } = false;
        public string? PhoneNumberVerificationCode { get; set; }
        public DateTime? PhoneNumberVerificationCodeExpiration { get; set; }
        public string? ResetPasswordCode { get; set; }
        public DateTime? ResetPasswordCodeExpiration { get; set; }
        public string? EmailVerificationCode { get; set; }
        public DateTime? EmailVerificationCodeExpiration { get; set; }
        public string? TikTokRefreshToken { get; set; }
        public required bool IsDeleted { get; set; } = false;
        public DateTime DeletedAt { get; set; }
        public required Role Role { get; set; }
        
        public required string NotificationSettings { get; set; } = new UserNotificationSettingSharedDto
        {
            Message = true,
            Review = true,
            Follow = false,
            Favorite = false,
            Verify = true
        }.ToJson();

        public override string ToString()
        {
            return
                $"Id: {Id}, FirstName: {FirstName}, LastName: {LastName}, PhoneNumber: {PhoneNumber}, Password: {Password}, Street: {Street}, SubLocality: {SubLocality}, SubAdministrativeArea: {SubAdministrativeArea}, PostalCode: {PostalCode}, Latitude: {Latitude}, Longitude: {Longitude}, ProfilePicture: {ProfilePicture}, Email: {Email}, DateOfBirth: {DateOfBirth}";
        }
        
    }
}

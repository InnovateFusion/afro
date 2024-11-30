using backend.Application.DTO.Common.Role.DTO;

namespace backend.Application.DTO.User.UserDTO.DTO
{
	public class UserResponseDTO
	{
		public required string Id { get; set; }
		public string? FirstName { get; set; }
		public string? LastName { get; set; }
		public string? PhoneNumber { get; set; }
		public string? Email { get; set; }
		public double? Latitude { get; set; }
		public double? Longitude { get; set; }
		public string? ProfilePicture { get; set; }
		public string? Street { get; set; }
		public string? SubLocality { get; set; }
		public string? SubAdministrativeArea { get; set; }
		public string? PostalCode { get; set; }
		public string? Gender { get; set; }
		public DateTime? DateOfBirth { get; set; }
		public string? productCategoryPreferences { get; set; }
		public string? productSizePreferences { get; set; }
		public string? productDesignPreferences { get; set; }
		public string? productBrandPreferences { get; set; }
		public string? productColorPreferences { get; set; }
		public UserNotificationSettingSharedDto NotificationSettings { get; set; }
		public required RoleResponseDTO Role { get; set; }
	}
}

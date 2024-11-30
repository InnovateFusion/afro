namespace backend.Application.DTO.User.UserDTO.DTO
{
    public class UserSharedResponseDTO
    {
        public required string Id { get; set; }
        public string? FirstName { get; set; }
        public string? LastName { get; set; }
        public string? PhoneNumber { get; set; }
        public string? Email { get; set; }
        public double? Latitude { get; set; }
        public double? Longitude { get; set; }
        public string? ProfilePicture { get; set; }
        public  string? Street { get; set; }
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
    }
}

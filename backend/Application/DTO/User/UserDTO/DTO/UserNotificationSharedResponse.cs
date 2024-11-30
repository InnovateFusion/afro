namespace backend.Application.DTO.User.UserDTO.DTO
{
    public class UserNotificationSharedResponse
    {
        public required string Id { get; set; }
        public string? FirstName { get; set; }
        public string? LastName { get; set; }
        public string? ProfilePicture { get; set; }
    }
}

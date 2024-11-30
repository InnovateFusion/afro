using System.Text.Json;

namespace backend.Application.DTO.User.UserDTO.DTO;

public class UserNotificationSettingSharedDto
{
    public bool Message { get; set; }
    public bool Review { get; set; }
    public bool Follow { get; set; }
    public bool Favorite { get; set; }
    public bool Verify { get; set; }
    
    public override string ToString()
    {
        return
            $"Message: {Message}, Review: {Review}, Follow: {Follow}, Favorite: {Favorite}, Verify: {Verify}";
    }
    
    public string ToJson()
    {
        return JsonSerializer.Serialize(this);
    }
    
    public static UserNotificationSettingSharedDto? FromJson(string data)
    {
        return JsonSerializer.Deserialize<UserNotificationSettingSharedDto>(data);
    }
}
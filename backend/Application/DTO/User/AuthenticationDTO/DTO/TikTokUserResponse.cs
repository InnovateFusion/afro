using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

namespace backend.Application.DTO.User.AuthenticationDTO.DTO
{
    public class TikTokUserResponse
    {
        [JsonProperty("avatar_url")]
        public string AvatarUrl { get; set; }
        
        [JsonProperty("open_id")]
        public string OpenId { get; set; }
        
        [JsonProperty("display_name")]
        public string DisplayName { get; set; }
        
        [JsonProperty("username")]
        public string Username { get; set; }
        
        [JsonProperty("profile_deep_link")]
        public string ProfileDeepLink { get; set; }
        
        public static TikTokUserResponse? FromJson(string json)
        {
 
            JObject jsonObj = JObject.Parse(json);
            if (jsonObj.ContainsKey("data") && jsonObj["data"]!["user"] != null)
            {
                var userJson = jsonObj["data"]!["user"]?.ToString();
                if (userJson != null)
                {
                    return JsonConvert.DeserializeObject<TikTokUserResponse>(userJson);
                }
            }
            return null;
        }
    }
}

using Newtonsoft.Json;

namespace backend.Application.DTO.User.AuthenticationDTO.DTO
{
    public class TikTokResponseDTO
    {
        [JsonProperty("access_token")]
        public string AccessToken { get; set; }

        [JsonProperty("expires_in")]
        public int ExpiresIn { get; set; }

        [JsonProperty("open_id")]
        public string OpenId { get; set; }

        [JsonProperty("refresh_expires_in")]
        public int RefreshExpiresIn { get; set; }

        [JsonProperty("refresh_token")]
        public string RefreshToken { get; set; }

        [JsonProperty("scope")]
        public string Scope { get; set; }

        [JsonProperty("token_type")]
        public string TokenType { get; set; }
        
        public static TikTokResponseDTO? FromJson(string json)
        {
            return JsonConvert.DeserializeObject<TikTokResponseDTO>(json);
        }
    }
}

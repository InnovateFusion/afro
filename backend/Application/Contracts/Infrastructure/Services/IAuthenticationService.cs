using backend.Application.DTO.User.AuthenticationDTO.DTO;
using backend.Domain.Entities.User;

namespace backend.Application.Contracts.Infrastructure.Services
{
    public interface IAuthenticationService
    {
        public AuthenticationResponseDTO Login(
            LoginRequestDTO user,
            User userEntity,
            bool LoginAfterOtpVerification = default
        );
        public bool ValidateTokenAsync(string token);
        public string GenerateTokenAsync(User user, bool refreshToken = false);
        public string GetUserIdFromToken(string token);
        public Task<TikTokResponseDTO> VerifyTikTokAccessCode(string authCode);
        public Task<TikTokResponseDTO> RefreshTikTokAccessToken(string refreshToken);
        public Task<TikTokUserResponse> GetTikTokUserDetails(string accessToken);
        public Task<bool> TikTokRevokeAccess(string accessToken);
        
        public Task<string> InternetImageToBase64(string url);
    }
}

using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using AutoMapper;
using backend.Application.Common;
using backend.Application.Contracts.Infrastructure.Services;
using backend.Application.DTO.User.AuthenticationDTO.DTO;
using backend.Application.Exceptions;
using backend.Domain.Entities.User;
using backend.Infrastructure.Models;
using Microsoft.AspNetCore.Cryptography.KeyDerivation;
using Microsoft.Extensions.Options;
using Microsoft.IdentityModel.Tokens;

namespace backend.Infrastructure.Repository
{
	public class AuthenticationService(
		IOptions<JwtSettings> jwtSettings,
		IMapper mapper,
		IOptions<TikTokSettings> tikTokSettings,
		IOptions<ApiSettings> apiSettings)
		: IAuthenticationService
	{
		private readonly JwtSettings _jwtSettings = jwtSettings.Value;
		private readonly ApiSettings _apiSettings = apiSettings.Value;
		private readonly TikTokSettings _tikTokSettings = tikTokSettings.Value;
		private static readonly HttpClient Client = new HttpClient();

		public AuthenticationResponseDTO Login(
			LoginRequestDTO user,
			User userEntity,
			bool loginAfterOtpVerification = false
		)
		{
			if (loginAfterOtpVerification)
			{
				if (userEntity.Password != HashPassword(user.Password ?? ""))
				{
					throw new BadRequestException("Invalid password");
				}
			}

			var token = GenerateTokenAsync(userEntity);
			var refreshToken = GenerateTokenAsync(userEntity, true);
			var response = mapper.Map<AuthenticationResponseDTO>(userEntity);
			response.Token = token;
			response.RefreshToken = refreshToken;
			return response;
		}

		public string GenerateTokenAsync(User user, bool refreshToken = false)
		{
			var claims = new List<Claim>
			{
				new Claim(ClaimTypes.MobilePhone, user.PhoneNumber ?? string.Empty),
				new Claim(ClaimTypes.Email, user.Email ?? string.Empty),
				new Claim(ClaimTypes.NameIdentifier, user.Id.ToString()),
				new Claim(ClaimTypes.Role, user.Role.Name ?? string.Empty)
			};

			var key = new SymmetricSecurityKey(
				Encoding.UTF8.GetBytes(_jwtSettings.Key ?? string.Empty)
			);
			var credentials = new SigningCredentials(key, SecurityAlgorithms.HmacSha256);

			var token = new JwtSecurityToken(
				issuer: _jwtSettings.Issuer,
				audience: _jwtSettings.Audience,
				claims: claims,
				expires: DateTime.Now.AddMinutes(
					refreshToken ? _jwtSettings.RefreshTokenExpirationInMinutes : _jwtSettings.DurationInMinutes
				),
				signingCredentials: credentials
			);

			return new JwtSecurityTokenHandler().WriteToken(token);
		}

		public string GetUserIdFromToken(string token)
		{
			var tokenHandler = new JwtSecurityTokenHandler();
			var key = new SymmetricSecurityKey(
				Encoding.UTF8.GetBytes(_jwtSettings.Key ?? string.Empty)
			);

			tokenHandler.ValidateToken(
				token,
				new TokenValidationParameters
				{
					ValidateIssuerSigningKey = true,
					IssuerSigningKey = key,
					ValidateIssuer = true,
					ValidIssuer = _jwtSettings.Issuer,
					ValidateAudience = true,
					ValidAudience = _jwtSettings.Audience,
					ValidateLifetime = true,
					ClockSkew = TimeSpan.Zero
				},
				out SecurityToken validatedToken
			);

			var jwtToken = (JwtSecurityToken)validatedToken;
			var userId = jwtToken.Claims.First(x => x.Type == ClaimTypes.NameIdentifier).Value;
			return userId;
		}

		public async Task<TikTokResponseDTO> VerifyTikTokAccessCode(string authCode)
		{
			var request = new HttpRequestMessage(HttpMethod.Post, "https://open.tiktokapis.com/v2/oauth/token/");
			request.Headers.Add("Cache-Control", "no-cache");
			
			var formData = new Dictionary<string, string>
			{
				{ "client_key", _tikTokSettings.ClientId ?? "" },
				{ "client_secret", _tikTokSettings.ClientSecret ?? "" },
				{ "code", authCode },
				{ "grant_type", "authorization_code" },
				{ "redirect_uri", _tikTokSettings.RedirectUri ?? "" },
				{"code_verifier", _tikTokSettings.CodeVerifier ?? ""}
			};
			
			var content = new FormUrlEncodedContent(formData);
			request.Content = content; 
			
			var response = await Client.SendAsync(request);
			
			response.EnsureSuccessStatusCode();
			
			var responseBody = await response.Content.ReadAsStringAsync();
			
			if (response.IsSuccessStatusCode)
			{
				var tikTokResponse = TikTokResponseDTO.FromJson(responseBody);
				if (tikTokResponse == null)
				{
					throw new BadRequestException("Invalid TikTok response");
				}

				return tikTokResponse;
			}
			throw new BadRequestException("Invalid TikTok access code");
		}

		public async Task<TikTokResponseDTO> RefreshTikTokAccessToken(string refreshToken)
		{
			var request = new HttpRequestMessage(HttpMethod.Post, "https://open.tiktokapis.com/v2/oauth/token/");
			request.Headers.Add("Cache-Control", "no-cache");
			
			var formData = new Dictionary<string, string>
			{
				{ "client_key", _tikTokSettings.ClientId ?? "" },
				{ "client_secret", _tikTokSettings.ClientSecret ?? "" },
				{ "refresh_token", refreshToken },
				{ "grant_type", "refresh_token" }
			};
			
			var content = new FormUrlEncodedContent(formData);
			request.Content = content; 
			
			var response = await Client.SendAsync(request);
			
			response.EnsureSuccessStatusCode();
			
			var responseBody = await response.Content.ReadAsStringAsync();
			
			if (response.IsSuccessStatusCode)
			{
				var tikTokResponse = TikTokResponseDTO.FromJson(responseBody);
				if (tikTokResponse == null)
				{
					throw new BadRequestException("Invalid TikTok response");
				}

				return tikTokResponse;
			}
			throw new BadRequestException("Invalid TikTok refresh token");
		}

		public async Task<TikTokUserResponse> GetTikTokUserDetails(string accessToken)
		{
			var request = new HttpRequestMessage(HttpMethod.Get, "https://open.tiktokapis.com/v2/user/info/?fields=open_id,avatar_url,display_name,username,profile_deep_link");
			request.Headers.Add("Authorization", $"Bearer {accessToken}");
			
			var response = await Client.SendAsync(request);
			
			var responseBody = await response.Content.ReadAsStringAsync();
			
			if (response.IsSuccessStatusCode)
			{
				var tikTokUserResponse = TikTokUserResponse.FromJson(responseBody);
				if (tikTokUserResponse == null)
				{
					throw new BadRequestException("Invalid TikTok user response");
				}

				return tikTokUserResponse;
			}
			
			throw new BadRequestException("Invalid TikTok access token");
		}

		public async Task<bool> TikTokRevokeAccess(string accessToken)
		{
			var request = new HttpRequestMessage(HttpMethod.Post, "https://open.tiktokapis.com/v2/oauth/revoke/");
			request.Headers.Add("Cache-Control", "no-cache");
			
			var formData = new Dictionary<string, string>
			{
				{ "client_key", _tikTokSettings.ClientId ?? "" },
				{ "client_secret", _tikTokSettings.ClientSecret ?? "" },
				{ "token", accessToken }
			};
			
			var content = new FormUrlEncodedContent(formData);
			request.Content = content; 
			
			var response = await Client.SendAsync(request);
			
			response.EnsureSuccessStatusCode();
			
			if (response.IsSuccessStatusCode)
			{
				return true;
			}
			return false;
		}

		public async Task<string> InternetImageToBase64(string url)
		{
			var response = await Client.GetAsync(url);
			response.EnsureSuccessStatusCode();
			var imageBytes = await response.Content.ReadAsByteArrayAsync();
			return Convert.ToBase64String(imageBytes);
		}

		public bool ValidateTokenAsync(string token)
		{
			var tokenHandler = new JwtSecurityTokenHandler();
			var key = new SymmetricSecurityKey(
				Encoding.UTF8.GetBytes(_jwtSettings.Key ?? string.Empty)
			);

			try
			{
				tokenHandler.ValidateToken(
					token,
					new TokenValidationParameters
					{
						ValidateIssuerSigningKey = true,
						IssuerSigningKey = key,
						ValidateIssuer = true,
						ValidIssuer = _jwtSettings.Issuer,
						ValidateAudience = true,
						ValidAudience = _jwtSettings.Audience,
						ValidateLifetime = true,
						ClockSkew = TimeSpan.Zero
					},
					out SecurityToken validatedToken
				);
				return true;
			}
			catch
			{
				return false;
			}
		}

		private string HashPassword(string password)
		{
			var saltBytes = Encoding.UTF8.GetBytes(_apiSettings.SecretKey ?? "SecretKey");
			

			string hashedPassword = Convert.ToBase64String(
				KeyDerivation.Pbkdf2(
					password: password,
					salt: saltBytes,
					prf: KeyDerivationPrf.HMACSHA512,
					iterationCount: 10000,
					numBytesRequested: 256 / 8
				)
			);
			return hashedPassword;
		}
	}
}

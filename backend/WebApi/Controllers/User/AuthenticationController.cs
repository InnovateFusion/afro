using System.Security.Claims;
using backend.Application.DTO.User.AuthenticationDTO.DTO;
using backend.Application.Features.User_Features.Authentication.Requests.Commands;
using MediatR;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace backend.WebApi.Controllers.User
{
	[ApiController]
	[Route("api/[controller]")]
	public class AuthenticationController(IMediator mediator) : ControllerBase
	{
		[HttpPost("Register")]
		public async Task<IActionResult> Register(
			[FromBody] RegisterUserRequest registerUserCommand
		)
		{
			var result = await mediator.Send(registerUserCommand);
			return Ok(result);
		}

		[HttpPost("Login")]
		public async Task<IActionResult> Login([FromBody] LoginUserRequest loginUserCommand)
		{
			var result = await mediator.Send(loginUserCommand);
			return Ok(result);
		}

		[HttpPost("Send-Verfication-Email-Code")]
		public async Task<IActionResult> SendOTPForEmail([FromBody] EmailOTPSenderRequest email)
		{
			var result = await mediator.Send(email);
			return Ok(result);
		}

		[HttpPost("Verify-Email")]
		public async Task<IActionResult> VerifyEmail(
			[FromBody] VerifyEmailRequest verifyEmailCommand
		)
		{
			var result = await mediator.Send(verifyEmailCommand);
			return Ok(result);
		}
		
		[HttpPost("Send-Reset-Password-Code")]
		public async Task<IActionResult> SendResetPasswordCode(
			[FromBody] ForgetPasswordRequest sendResetPasswordCodeCommand
		)
		{
			var result = await mediator.Send(sendResetPasswordCodeCommand);
			return Ok(result);
		}
		
		[HttpPost("Reset-Password")]
		public async Task<IActionResult> ResetPassword(
			[FromBody] ResetPasswordRequest resetPasswordCommand
		)
		{
			var result = await mediator.Send(resetPasswordCommand);
			return Ok(result);
		}

		[HttpPost("Verify-Password-Reset-Code")]
		public async Task<IActionResult> VerifyPasswordResetCode(
			[FromBody] PasswordResetCodeVerificationRequest verifyPasswordResetCodeCommand
		)
		{
			var result = await mediator.Send(verifyPasswordResetCodeCommand);
			return Ok(result);
		}
		
		[HttpGet("Refresh-Token/{refreshToken}")]
		public async Task<IActionResult> RefreshToken(
			String refreshToken
		)
		{
			var result = await mediator.Send(new RefereshTokenRequest { RefreshToken = refreshToken });
			return Ok(result);
		}
		
		[HttpGet("Login-With-TikTok/{tikTokToken}")]
		public async Task<IActionResult> LoginWithTikTokMethod(
			String tikTokToken
		)
		{
			var result = await mediator.Send(new LoginWithTikTok { AuthCode = tikTokToken });
			return Ok(result);
		}
		
		[HttpGet("Refresh-TikTok-Access-Token/{refreshToken}")]
		public async Task<IActionResult> RefreshTikTokAccessToken(
			String refreshToken
		)
		{
			var result = await mediator.Send(new RefreshTiktokAccessToken { RefreshToken = refreshToken });
			return Ok(result);
		}
		
		[HttpGet("Connect-With-TikTok/{tikTokToken}")]
		[Authorize]
		public async Task<IActionResult> ConnectWithTikTok(
			String tikTokToken
		)
		{
			var userId = User.FindFirstValue(ClaimTypes.NameIdentifier)!;
			var result = await mediator.Send(new ConnectWithTikTokRequest { AccessCode = tikTokToken, UserId = userId });
			return Ok(result);
		}
		
		[HttpGet("Disconnect-TikTok/{tikTokToken}")]
		[Authorize]
		public async Task<IActionResult> DisconnectTikTok(
			String tikTokToken
		)
		{
			var userId = User.FindFirstValue(ClaimTypes.NameIdentifier)!;
			var result = await mediator.Send(new TikTokRevokeAccessRequest
			{
				AuthToken = tikTokToken,
				UserId = userId
			});
			return Ok(result);
		}
		
		[HttpPost("Profile-Email-Verification-Code")]
		[Authorize]
		public async Task<IActionResult> SendOtpForProfileEmail([FromBody] ProfileEmailOtpSenderDto dto)
		{
			var userId = User.FindFirstValue(ClaimTypes.NameIdentifier)!;
			var result = await mediator.Send(new ProfileEmailOTPSenderRequest
			{
				UserId = userId,
				ProfileEmailOtpSenderDto = dto
			});
			return Ok(result);
		}
		
		[HttpPost("Verify-Profile-Email")]
		[Authorize]
		public async Task<IActionResult> VerifyProfileEmail(
			[FromBody] VerifyProfileEmailCodeDto dto
		)
		{
			var userId = User.FindFirstValue(ClaimTypes.NameIdentifier)!;
			var result = await mediator.Send(new VerifyProfileEmailRequest
			{
				Email = dto.Email,
				Code = dto.Code,
				UserId = userId
			});
			return Ok(result);
		}
	}
}

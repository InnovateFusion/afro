using backend.Application.Contracts.Infrastructure.Services;
using backend.Application.Contracts.Persistence;
using backend.Application.Exceptions;
using backend.Application.Features.User_Features.Authentication.Requests.Commands;
using backend.Application.Response;
using MediatR;

namespace backend.Application.Features.User_Features.Authentication.Handlers.Commands
{
    public class ProfileEmailOTPSenderHandler(IUnitOfWork unitOfWork, IOtpService otpService)
        : IRequestHandler<ProfileEmailOTPSenderRequest, BaseResponse<string>>
    {
        public async Task<BaseResponse<string>> Handle(
            ProfileEmailOTPSenderRequest request,
            CancellationToken cancellationToken
        )
        {
            var user = await unitOfWork.UserRepository.GetById(request.UserId);
            if (user == null)
                throw new NotFoundException("User not found");
            var emailExist = await unitOfWork.UserRepository.GetByEmail(request.ProfileEmailOtpSenderDto.Email);
            if (emailExist.IsEmailVerified)
                throw new NotFoundException("User with this email already exists");
            user.Email = request.ProfileEmailOtpSenderDto.Email;
            user.EmailVerificationCode = await otpService.SendVerificationEmailAsync(user, 5);
            user.EmailVerificationCodeExpiration = DateTime.Now.AddMinutes(5);
            user.OtpVerificationTrail = 0;
            await unitOfWork.UserRepository.Update(user);

            return new BaseResponse<string>
            {
                Data =
                    "The email verification code has been sent to your email address. Please check your email. If you do not receive the email, please check your spam folder.",
                Message = "Email verification code sent",
                Success = true
            };
        }
    }
}

using backend.Application.Contracts.Infrastructure.Services;
using backend.Application.Contracts.Persistence;
using backend.Application.DTO.User.AuthenticationDTO.DTO;
using backend.Application.Exceptions;
using backend.Application.Features.User_Features.Authentication.Requests.Commands;
using MediatR;

namespace backend.Application.Features.User_Features.Authentication.Handlers.Commands
{
    public class VerifyEmailHandler(
        IUnitOfWork unitOfWork,
        IAuthenticationService authenticationService)
        : IRequestHandler<VerifyEmailRequest, VerifyEmailResponseDTO>
    {
        public async Task<VerifyEmailResponseDTO> Handle(
            VerifyEmailRequest request,
            CancellationToken cancellationToken
        )
        {
            var user = await unitOfWork.UserRepository.GetByEmail(request.Email);
            if (user == null)
                throw new NotFoundException("User not found");
            if (user.IsEmailVerified)
                throw new BadRequestException("Email is already verified");

            if (user.OtpVerificationTrail > 6)
            {
                throw new BadRequestException("Otp verification trail is limit exceeded");
            }

            if (user.EmailVerificationCodeExpiration < DateTime.Now)
                throw new BadRequestException("Email verification code has expired");
            
            if (user.EmailVerificationCode != request.Code)
            {
                user.OtpVerificationTrail += 1;
                await unitOfWork.UserRepository.Update(user);
                throw new BadRequestException("Invalid email verification code");
            }


            var token = authenticationService.Login(
                new LoginRequestDTO { Email = user.Email, Password = user.Password },
                user,
                false
            );

            user.IsEmailVerified = true;
            user.Email = request.Email;
            user.EmailVerificationCode = null;
            user.EmailVerificationCodeExpiration = null;
            user.OtpVerificationTrail = 0;
            

            await unitOfWork.UserRepository.Update(user);

            return new VerifyEmailResponseDTO
            {
                Email = user.Email!,
                IsVerified = user.IsEmailVerified,
                Message = "Email verified successfully",
                VerificationDate = DateTime.Now,
                Token = token.Token!
            };
        }
    }
}

using backend.Application.Contracts.Infrastructure.Services;
using backend.Application.Contracts.Persistence;
using backend.Application.DTO.User.AuthenticationDTO.DTO;
using backend.Application.Exceptions;
using backend.Application.Features.User_Features.Authentication.Requests.Commands;
using MediatR;

namespace backend.Application.Features.User_Features.Authentication.Handlers.Commands
{
    public class PasswordResetCodeVerificationHandler(IUnitOfWork unitOfWork)
        : IRequestHandler<PasswordResetCodeVerificationRequest, PasswordResetCodeVerificationResponseDTO>
    {
        public async Task<PasswordResetCodeVerificationResponseDTO> Handle(PasswordResetCodeVerificationRequest request, CancellationToken cancellationToken)
        {
            var user = await unitOfWork.UserRepository.GetByEmail(request.Email);
            if (user == null)
                throw new NotFoundException("User not found");
            
            if (user.OtpVerificationTrail > 6)
            {
                throw new BadRequestException("Otp verification trail is limit exceeded");
            }
            
            if (user.ResetPasswordCodeExpiration < DateTime.Now)
                throw new BadRequestException("Password reset code expired");

            if (user.ResetPasswordCode != request.Code)
            {

                user.OtpVerificationTrail += 1;
                await unitOfWork.UserRepository.Update(user);
                throw new BadRequestException("Invalid password reset code");
            }

            user.OtpVerificationTrail = 0;
            user.ResetPasswordCodeExpiration = null;
            user.ResetPasswordCode = null;
            await unitOfWork.UserRepository.Update(user);

            return new PasswordResetCodeVerificationResponseDTO
            {
                Email = user.Email!,
                IsVerified = true,
                Message = "Password reset code verified successfully",
                VerificationDate = DateTime.Now
            };
        }
    }
}

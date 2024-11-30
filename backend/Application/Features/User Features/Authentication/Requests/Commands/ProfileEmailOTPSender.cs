using backend.Application.DTO.User.AuthenticationDTO.DTO;
using backend.Application.Response;
using MediatR;

namespace backend.Application.Features.User_Features.Authentication.Requests.Commands
{
    public class ProfileEmailOTPSenderRequest : IRequest<BaseResponse<string>>
    {
       public  ProfileEmailOtpSenderDto ProfileEmailOtpSenderDto { get; set; }
       public required string UserId { get; set; }
    }
}

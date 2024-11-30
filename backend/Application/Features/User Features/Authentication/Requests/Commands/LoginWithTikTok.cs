using backend.Application.DTO.User.AuthenticationDTO.DTO;
using backend.Application.Response;
using MediatR;

namespace backend.Application.Features.User_Features.Authentication.Requests.Commands;

public class LoginWithTikTok: IRequest<BaseResponse<AuthenticationResponseDTO>>
{
    public required string AuthCode { get; set; }
}
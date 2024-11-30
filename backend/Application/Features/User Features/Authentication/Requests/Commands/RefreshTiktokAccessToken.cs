using backend.Application.DTO.User.AuthenticationDTO.DTO;
using backend.Application.Response;
using MediatR;

namespace backend.Application.Features.User_Features.Authentication.Requests.Commands;

public class RefreshTiktokAccessToken: IRequest<BaseResponse<AuthenticationResponseDTO>>
{
    public string RefreshToken { get; set; }
}
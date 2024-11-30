using backend.Application.DTO.User.AuthenticationDTO.DTO;
using backend.Application.Response;
using MediatR;

namespace backend.Application.Features.User_Features.Authentication.Requests.Commands;

public class TikTokRevokeAccessRequest: IRequest<BaseResponse<AuthenticationResponseDTO>>
{
    public required string AuthToken { get; set; }
    public required string UserId { get; set; }
}

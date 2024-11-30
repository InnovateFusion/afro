using backend.Application.DTO.User.AuthenticationDTO.DTO;
using backend.Application.Response;
using MediatR;

namespace backend.Application.Features.User_Features.Authentication.Requests.Commands;

public class ConnectWithTikTokRequest: IRequest<BaseResponse<AuthenticationResponseDTO>>
{ 
    public required string AccessCode { get; set; }
    
    public required string UserId { get; set; }
}

using AutoMapper;
using backend.Application.Contracts.Infrastructure.Services;
using backend.Application.Contracts.Persistence;
using backend.Application.DTO.User.AuthenticationDTO.DTO;
using backend.Application.Exceptions;
using backend.Application.Features.User_Features.Authentication.Requests.Commands;
using backend.Application.Response;
using MediatR;


namespace backend.Application.Features.User_Features.Authentication.Handlers.Commands;

public class ConnectWithTiktokHandler(
    IUnitOfWork unitOfWork,
    IMapper mapper,
    IAuthenticationService authenticationService)
    : IRequestHandler<ConnectWithTikTokRequest, BaseResponse<AuthenticationResponseDTO>>
{
    public async Task<BaseResponse<AuthenticationResponseDTO>> Handle(ConnectWithTikTokRequest request, CancellationToken cancellationToken)
    {
        var tikTokResponse = await authenticationService.VerifyTikTokAccessCode(request.AccessCode);
        if (tikTokResponse == null || string.IsNullOrEmpty(tikTokResponse.OpenId))
            throw new BadRequestException("Invalid TikTok Auth Code");
        var userExists = await unitOfWork.UserRepository.GetById(request.UserId);
        
        if (userExists == null)
            throw new BadRequestException("User not found");
        
        userExists.TikTokRefreshToken = tikTokResponse.RefreshToken;
        await unitOfWork.UserRepository.Update(userExists);
        
        var token = authenticationService.GenerateTokenAsync(userExists);
        var refreshToken = authenticationService.GenerateTokenAsync(userExists, true);
        
        var response = mapper.Map<AuthenticationResponseDTO>(userExists);
        response.Token = token;
        response.RefreshToken = refreshToken;
        response.TikTokAccessToken = tikTokResponse.AccessToken;
        response.TikTokRefreshToken = tikTokResponse.RefreshToken;
        
        return new BaseResponse<AuthenticationResponseDTO>
        {
            Data = response,
            Message = "Connected with TikTok",
            Success = true
        };
    }
}
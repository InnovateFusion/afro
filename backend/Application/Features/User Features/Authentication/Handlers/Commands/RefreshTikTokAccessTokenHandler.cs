using AutoMapper;
using backend.Application.Contracts.Infrastructure.Services;
using backend.Application.Contracts.Persistence;
using backend.Application.DTO.User.AuthenticationDTO.DTO;
using backend.Application.Exceptions;
using backend.Application.Features.User_Features.Authentication.Requests.Commands;
using backend.Application.Response;
using MediatR;

namespace backend.Application.Features.User_Features.Authentication.Handlers.Commands;

public class RefreshTikTokAccessTokenHandler(
    IUnitOfWork unitOfWork,
    IMapper mapper,
    IAuthenticationService authenticationService)
    : IRequestHandler<RefreshTiktokAccessToken, BaseResponse<AuthenticationResponseDTO>>
{
    public async Task<BaseResponse<AuthenticationResponseDTO>> Handle(RefreshTiktokAccessToken request, CancellationToken cancellationToken)
    {
        var tikTokResponse = await authenticationService.RefreshTikTokAccessToken(refreshToken: request.RefreshToken);
        if (tikTokResponse == null || string.IsNullOrEmpty(tikTokResponse.OpenId))
            throw new BadRequestException("Invalid TikTok Refresh Token");
        
        var userExists = await unitOfWork.UserRepository.GetById(tikTokResponse.OpenId);
        if (userExists == null)
            throw new NotFoundException("User Not Found");
        
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
            Message = "Login successful",
            Success = true
        };

    }
}
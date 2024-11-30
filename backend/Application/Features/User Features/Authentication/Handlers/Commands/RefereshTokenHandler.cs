using AutoMapper;
using backend.Application.Contracts.Infrastructure.Services;
using backend.Application.Contracts.Persistence;
using backend.Application.DTO.User.AuthenticationDTO.DTO;
using backend.Application.Exceptions;
using backend.Application.Features.User_Features.Authentication.Requests.Commands;
using backend.Application.Response;
using MediatR;

namespace backend.Application.Features.User_Features.Authentication.Handlers.Commands;

public class RefereshTokenHandler(
    IUnitOfWork unitOfWork,
    IMapper mapper,
    IAuthenticationService authenticationService)
    : IRequestHandler<RefereshTokenRequest, BaseResponse<AuthenticationResponseDTO>>
{
    public async Task<BaseResponse<AuthenticationResponseDTO>> Handle(RefereshTokenRequest request, CancellationToken cancellationToken)
    {
        var isValid = authenticationService.ValidateTokenAsync(request.RefreshToken);
        
        if (!isValid)
        {
            throw new BadRequestException("Expired token");
        }
        
        var userId = authenticationService.GetUserIdFromToken(request.RefreshToken);
        var user = await unitOfWork.UserRepository.GetById(userId);
        if (user == null)
        {
            throw new NotFoundException("User not found");
        } 
        
        var token = authenticationService.GenerateTokenAsync(user);
        var refreshToken = authenticationService.GenerateTokenAsync(user, true);
        
        var response = mapper.Map<AuthenticationResponseDTO>(user);
        response.Token = token;
        response.RefreshToken = refreshToken;
        
        if (user.TikTokRefreshToken != null)
        {
            var tikTokResponse = await authenticationService.RefreshTikTokAccessToken(user.TikTokRefreshToken);
            if (tikTokResponse != null && !string.IsNullOrEmpty(tikTokResponse.AccessToken))
            {   
                response.TikTokAccessToken = tikTokResponse.AccessToken;
                response.TikTokRefreshToken = tikTokResponse.RefreshToken;
                user.TikTokRefreshToken = tikTokResponse.RefreshToken;
                await unitOfWork.UserRepository.Update(user);
            }
        }
        
        return new BaseResponse<AuthenticationResponseDTO>
        {
            Data = response,
            Message = "Login successful",
            Success = true
        };
        
    }
}
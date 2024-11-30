using AutoMapper;
using backend.Application.Contracts.Infrastructure.Services;
using backend.Application.Contracts.Persistence;
using backend.Application.DTO.User.AuthenticationDTO.DTO;
using backend.Application.Exceptions;
using backend.Application.Features.User_Features.Authentication.Requests.Commands;
using backend.Application.Response;
using MediatR;

namespace backend.Application.Features.User_Features.Authentication.Handlers.Commands;

public class TikTokRevokeAccessHandler(
    IUnitOfWork unitOfWork,
    IMapper mapper,
    IAuthenticationService authenticationService)
    : IRequestHandler<TikTokRevokeAccessRequest, BaseResponse<AuthenticationResponseDTO>>
{
    public async Task<BaseResponse<AuthenticationResponseDTO>> Handle(TikTokRevokeAccessRequest request, CancellationToken cancellationToken)
    {
        var userExists = await unitOfWork.UserRepository.GetById(request.UserId);
        if (userExists == null)
            throw new NotFoundException("User Not Found");
        
        var result = await authenticationService.TikTokRevokeAccess(request.AuthToken);
        if (!result)
            throw new BadRequestException("Failed to revoke TikTok Access");
        
        userExists.TikTokRefreshToken = null;
        userExists = await unitOfWork.UserRepository.Update(userExists);
        
        var token = authenticationService.GenerateTokenAsync(userExists);
        var refreshToken = authenticationService.GenerateTokenAsync(userExists, true);
        var response = mapper.Map<AuthenticationResponseDTO>(userExists);
        response.Token = token;
        response.RefreshToken = refreshToken;
        
        return new BaseResponse<AuthenticationResponseDTO>
        {
            Data = response,
            Message = "TikTok Access Revoked",
            Success = true
        };
    }
}
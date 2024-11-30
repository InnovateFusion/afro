using AutoMapper;
using backend.Application.Contracts.Infrastructure.Repositories;
using backend.Application.Contracts.Infrastructure.Services;
using backend.Application.Contracts.Persistence;
using backend.Application.DTO.User.AuthenticationDTO.DTO;
using backend.Application.DTO.User.UserDTO.DTO;
using backend.Application.Enum;
using backend.Application.Exceptions;
using backend.Application.Features.User_Features.Authentication.Requests.Commands;
using backend.Application.Response;
using MediatR;

namespace backend.Application.Features.User_Features.Authentication.Handlers.Commands;

public class LoginWithTikTokHandler(
    IUnitOfWork unitOfWork,
    IMapper mapper,
    IAuthenticationService authenticationService,   
    IAzureBlobStorageService azureBlobStorageService,
    IImageRepository imageRepository)
    : IRequestHandler<LoginWithTikTok, BaseResponse<AuthenticationResponseDTO>>
{
    public async Task<BaseResponse<AuthenticationResponseDTO>> Handle(LoginWithTikTok request, CancellationToken cancellationToken)
    {
        var tikTokResponse = await authenticationService.VerifyTikTokAccessCode(request.AuthCode);
        if (tikTokResponse == null || string.IsNullOrEmpty(tikTokResponse.OpenId))
            throw new BadRequestException("Invalid TikTok Auth Code");
        var userExists = await unitOfWork.UserRepository.GetById(tikTokResponse.OpenId);
        
        if (userExists == null) 
        {
            var tiktokUser = await authenticationService.GetTikTokUserDetails(accessToken: tikTokResponse.AccessToken);
            if (tiktokUser == null || string.IsNullOrEmpty(tiktokUser.OpenId))
                throw new BadRequestException("Invalid TikTok Access Token");

            var role = await unitOfWork.RoleRepository.GetByName("user");
            if (role == null)
                throw new NotFoundException("Role Not Found");
            var base64Image = await authenticationService.InternetImageToBase64(tiktokUser.AvatarUrl);
            byte[] imageBytes = Convert.FromBase64String(base64Image);
            //var base64Image = "data:image/png;base64," + temp;
            var newUser = new Domain.Entities.User.User
            {
                Id = tikTokResponse.OpenId,
                RegisterWith = (int) RegisterType.WithTikTok,
                FirstName = tiktokUser.DisplayName,
                ProfilePicture = await azureBlobStorageService.UploadImageAsync(imageBytes, tiktokUser.OpenId),
               // ProfilePicture = await imageRepository.Update(base64Image, tiktokUser.OpenId),
                Role = role,
                TikTokRefreshToken = tikTokResponse.RefreshToken,
                IsDeleted = false,
                NotificationSettings = new UserNotificationSettingSharedDto
                {
                    Message = true,
                    Review = true,
                    Follow = false,
                    Favorite = false,
                    Verify = true
                }.ToJson()
            };
             newUser = await unitOfWork.UserRepository.Add(newUser);
            var result = new AuthenticationResponseDTO
            {
                Id = newUser.Id,
                Role = newUser.Role,
                FirstName = newUser.FirstName,   
                RegisterWith = newUser.RegisterWith,
                ProfilePicture = newUser.ProfilePicture,
                NotificationSettings = UserNotificationSettingSharedDto.FromJson(newUser.NotificationSettings),
                Token = authenticationService.GenerateTokenAsync(newUser),
                RefreshToken = authenticationService.GenerateTokenAsync(newUser, true),
                TikTokAccessToken = tikTokResponse.AccessToken,
                TikTokRefreshToken = tikTokResponse.RefreshToken
                
            };
            return new BaseResponse<AuthenticationResponseDTO>
            {
                Data = result,
                Message = "Account created successfully",
                Success = true
            };
        }

        var response = mapper.Map<AuthenticationResponseDTO>(userExists);
        response.RefreshToken = authenticationService.GenerateTokenAsync(userExists, true);
        response.Token = authenticationService.GenerateTokenAsync(userExists);
        if (!string.IsNullOrEmpty(userExists.TikTokRefreshToken))
        {
            var updatedRefeshTiktokDto = await authenticationService.RefreshTikTokAccessToken(userExists.TikTokRefreshToken);
            if (updatedRefeshTiktokDto != null && !string.IsNullOrEmpty(updatedRefeshTiktokDto.AccessToken))
            {   
                response.TikTokAccessToken = updatedRefeshTiktokDto.AccessToken;
                userExists.TikTokRefreshToken= updatedRefeshTiktokDto.RefreshToken;
                await unitOfWork.UserRepository.Update(userExists);
            }
            else
            {
                response.TikTokAccessToken = tikTokResponse.AccessToken;
                userExists.TikTokRefreshToken = tikTokResponse.RefreshToken;
                await unitOfWork.UserRepository.Update(userExists);
            }
        }
        else
        {
            response.TikTokAccessToken = tikTokResponse.AccessToken;   
            userExists.TikTokRefreshToken = tikTokResponse.RefreshToken;
            await unitOfWork.UserRepository.Update(userExists);
        }
        response.TikTokRefreshToken = userExists.TikTokRefreshToken;

        return new BaseResponse<AuthenticationResponseDTO>
        {
            Data = response,
            Message = "Login successful with TikTok",
            Success = true
        };
    }
}
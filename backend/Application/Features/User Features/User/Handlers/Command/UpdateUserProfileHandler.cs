using System.ComponentModel.DataAnnotations;
using System.Text;
using System.Text.Json;
using AutoMapper;
using backend.Application.Common;
using backend.Application.Contracts.Infrastructure.Repositories;
using backend.Application.Contracts.Persistence;
using backend.Application.DTO.User.UserDTO.DTO;
using backend.Application.Exceptions;
using backend.Application.Features.User_Features.User.Requests.Command;
using backend.Application.Response;
using MediatR;
using Microsoft.AspNetCore.Cryptography.KeyDerivation;
using Microsoft.Extensions.Options;

namespace backend.Application.Features.User_Features.User.Handlers.Command
{
    public class UpdateUserProfileHandler(
        IUnitOfWork unitOfWork,
        IMapper mapper,
        IOptions<ApiSettings> apiSettings,    
        IAzureBlobStorageService azureBlobStorageService,
        IImageRepository imageRepository)
        : IRequestHandler<UpdateUserProfileRequest, BaseResponse<UserResponseDTO>>
    {
        private readonly ApiSettings _apiSettings = apiSettings.Value;

        public async Task<BaseResponse<UserResponseDTO>> Handle(
            UpdateUserProfileRequest request,
            CancellationToken cancellationToken
        )
        {
            var user = await unitOfWork.UserRepository.GetById(request.Id);
            if (user == null)
                throw new NotFoundException("User not found");

            if (request.updateUserProfileDTO.FirstName != null)
            {
                if (request.updateUserProfileDTO.FirstName.Length < 3)
                    throw new ValidationException("First name must be at least 3 characters long");

                user.FirstName = request.updateUserProfileDTO.FirstName;
            }

            if (request.updateUserProfileDTO.LastName != null)
            {
                if (request.updateUserProfileDTO.LastName.Length < 3)
                    throw new ValidationException("Last name must be at least 3 characters long");

                user.LastName = request.updateUserProfileDTO.LastName;
            }

            if (request.updateUserProfileDTO.Latitude != null)
            {
                if (
                    request.updateUserProfileDTO.Latitude < -90
                    || request.updateUserProfileDTO.Latitude > 90
                )
                    throw new ValidationException("Latitude must be between -90 and 90");
                user.Latitude = request.updateUserProfileDTO.Latitude;
            }

            if (request.updateUserProfileDTO.Longitude != null)
            {
                if (
                    request.updateUserProfileDTO.Longitude < -180
                    || request.updateUserProfileDTO.Longitude > 180
                )
                    throw new ValidationException("Longitude must be between -180 and 180");
                user.Longitude = request.updateUserProfileDTO.Longitude;
            }

            if (
                request.updateUserProfileDTO.Street is { Length: > 0 }
            )
                user.Street = request.updateUserProfileDTO.Street;

            if (
                request.updateUserProfileDTO.SubLocality is { Length: > 0 }
            )
                user.SubLocality = request.updateUserProfileDTO.SubLocality;

            if (
                request.updateUserProfileDTO.SubAdministrativeArea is { Length: > 0 }
            )
                user.SubAdministrativeArea = request.updateUserProfileDTO.SubAdministrativeArea;
            
            if (
                request.updateUserProfileDTO.PostalCode is { Length: > 0 }
            )
                user.PostalCode = request.updateUserProfileDTO.PostalCode;

            if (request.updateUserProfileDTO is { Password: not null, OldPassword: not null })
            {
                if (
                    request.updateUserProfileDTO.Password.Length < 6
                    || request.updateUserProfileDTO.Password.Length > 20
                )
                    throw new ValidationException(
                        "Password must be at least 6 characters long and at most 20 characters long"
                    );
                
                if (HashPassword(request.updateUserProfileDTO.OldPassword) != user.Password)
                    throw new ValidationException(
                        "Old password is incorrect"
                    );

                if (HashPassword(request.updateUserProfileDTO.Password) == user.Password)
                    throw new ValidationException(
                        "New password must be different from the old password"
                    );

                user.Password = HashPassword(request.updateUserProfileDTO.Password);
            }

            if (request.updateUserProfileDTO.ProfilePictureBase64 != null)
            {
                if (request.updateUserProfileDTO.ProfilePictureBase64.Length < 100)
                    throw new ValidationException("Profile picture must not be empty");

                if (user.ProfilePicture != null)
                {
                    string base64Image = request.updateUserProfileDTO.ProfilePictureBase64.Split(',')[1];
                    byte[] imageBytes = Convert.FromBase64String(base64Image); 
                    user.ProfilePicture = await azureBlobStorageService.UploadImageAsync(
                       imageBytes,
                        user.Id
                    );
                    // user.ProfilePicture = await imageRepository.Update(
                    //     request.updateUserProfileDTO.ProfilePictureBase64,
                    //     user.Id
                    // );
                }
                else
                {
                    string base64Image = request.updateUserProfileDTO.ProfilePictureBase64.Split(',')[1];
                    byte[] imageBytes = Convert.FromBase64String(base64Image); 
                    user.ProfilePicture = await azureBlobStorageService.UpdateImageAsync(
                        imageBytes,
                        user.Id
                    );
                    // user.ProfilePicture = await imageRepository.Upload(
                    //     request.updateUserProfileDTO.ProfilePictureBase64,
                    //     user.Id
                    // );
                }
            }
            
            if (request.updateUserProfileDTO.PhoneNumber != null)
            {
                if (request.updateUserProfileDTO.PhoneNumber.Length < 10)
                    throw new ValidationException("Phone number must be at least 10 characters long");

                user.PhoneNumber = request.updateUserProfileDTO.PhoneNumber;
            }
            
            if (request.updateUserProfileDTO.DateOfBirth != null)
            {
                if (request.updateUserProfileDTO.DateOfBirth > DateTime.Now)
                    throw new ValidationException("Date of birth must be in the past");

                user.DateOfBirth = request.updateUserProfileDTO.DateOfBirth;
            }

            if (request.updateUserProfileDTO.Gender != null)
            {
                if (request.updateUserProfileDTO.Gender == "male" || request.updateUserProfileDTO.Gender == "female")
                {
                    user.Gender = request.updateUserProfileDTO.Gender;
                }
                else
                {
                    throw new ValidationException("Gender must be male or female");
                }
            }
            
            if (request.updateUserProfileDTO.ProductCategoryPreferences != null)
            {
                try
                {
                    var preferences = JsonSerializer.Deserialize<string[]>(request.updateUserProfileDTO.ProductCategoryPreferences);
                    user.productCategoryPreferences = request.updateUserProfileDTO.ProductCategoryPreferences;
                }
                catch (JsonException ex)
                {
                    throw new ValidationException("Invalid JSON format for ProductCategoryPreferences.");
                }
            }
            
            if (request.updateUserProfileDTO.ProductSizePreferences != null)
            {
                try
                {
                    var preferences = JsonSerializer.Deserialize<string[]>(request.updateUserProfileDTO.ProductSizePreferences);
                    user.productSizePreferences = request.updateUserProfileDTO.ProductSizePreferences;
                }
                catch (JsonException ex)
                {
                    throw new ValidationException("Invalid JSON format for productSizePreferences.");
                }
            }
            
            if (request.updateUserProfileDTO.ProductDesignPreferences != null)
            {
                try
                {
                    var preferences = JsonSerializer.Deserialize<string[]>(request.updateUserProfileDTO.ProductDesignPreferences);
                    user.productDesignPreferences = request.updateUserProfileDTO.ProductDesignPreferences;
                }
                catch (JsonException ex)
                {
                    throw new ValidationException("Invalid JSON format for ProductDesignPreferences.");
                }
            }
            
            if (request.updateUserProfileDTO.ProductBrandPreferences != null)
            { 
                try
                {
                    var preferences = JsonSerializer.Deserialize<string[]>(request.updateUserProfileDTO.ProductBrandPreferences);
                    user.productBrandPreferences = request.updateUserProfileDTO.ProductBrandPreferences;
                }
                catch (JsonException ex)
                {
                    throw new ValidationException("Invalid JSON format for ProductBrandPreferences.");
                }
            }
            
            if (request.updateUserProfileDTO.ProductColorPreferences != null)
            {
                try
                {
                    var preferences = JsonSerializer.Deserialize<string[]>(request.updateUserProfileDTO.ProductColorPreferences);
                    user.productColorPreferences = request.updateUserProfileDTO.ProductColorPreferences;
                }
                catch (JsonException ex)
                {
                    throw new ValidationException("Invalid JSON format for ProductColorPreferences.");
                }
            }

            if (request.updateUserProfileDTO.NotificationSettings != null)
            {
                user.NotificationSettings = JsonSerializer.Serialize(request.updateUserProfileDTO.NotificationSettings);
            }
            
            await unitOfWork.UserRepository.Update(user);
            
            return new BaseResponse<UserResponseDTO>
            {
                Data = mapper.Map<UserResponseDTO>(user),
                Message = "User deleted successfully",
                Success = true
            };
        }

        private string HashPassword(string password)
        {
            var saltBytes = Encoding.UTF8.GetBytes(_apiSettings.SecretKey ?? "SecretKey");

            string hashedPassword = Convert.ToBase64String(
                KeyDerivation.Pbkdf2(
                    password: password,
                    salt: saltBytes,
                    prf: KeyDerivationPrf.HMACSHA512,
                    iterationCount: 10000,
                    numBytesRequested: 256 / 8
                )
            );
            return hashedPassword;
        }
    }
}

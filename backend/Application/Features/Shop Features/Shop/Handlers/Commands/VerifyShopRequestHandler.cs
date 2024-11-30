using AutoMapper;
using backend.Application.Contracts.Infrastructure.Repositories;
using backend.Application.Contracts.Infrastructure.Services;
using backend.Application.Contracts.Persistence;
using backend.Application.DTO.Common.Chat.DTO;
using backend.Application.DTO.Common.Notification.DTO;
using backend.Application.DTO.Shop.ShopDTO.DTO;
using backend.Application.Enum;
using backend.Application.Exceptions;
using backend.Application.Features.Shop_Features.Shop.Requests.Commands;
using backend.Application.Response;
using backend.Domain.Entities.Common;
using MediatR;
using Microsoft.IdentityModel.Tokens;
using Newtonsoft.Json;

namespace backend.Application.Features.Shop_Features.Shop.Handlers.Commands;

public class VerifyShopRequestHandler(IUnitOfWork unitOfWork, IMapper mapper, IAzureBlobStorageService azureBlobStorageService, IImageRepository imageRepository)
    : IRequestHandler<VerifyShopRequest, BaseResponse<ShopResponseDTO>>
{
    public async Task<BaseResponse<ShopResponseDTO>> Handle(VerifyShopRequest request, CancellationToken cancellationToken)
    {
        var shop = await unitOfWork.ShopRepository.GetShopByIdAsync(request.ShopVerifyRequest.Id);
        if (shop == null)
            throw new NotFoundException("Shop Not Found");

        if (shop.UserId != request.UserId)
            throw new BadRequestException("You are not the owner of this shop");
        
        if (!string.IsNullOrEmpty(request.ShopVerifyRequest.BusinessRegistrationNumber))
            shop.BusinessRegistrationNumber = request.ShopVerifyRequest.BusinessRegistrationNumber;

        if (!string.IsNullOrEmpty(request.ShopVerifyRequest.BusinessRegistrationDocumentUrl))
        {
            string base64Image = request.ShopVerifyRequest.BusinessRegistrationDocumentUrl.Split(',')[1];
            byte[] imageBytes = Convert.FromBase64String(base64Image);
            if (shop.BusinessRegistrationDocumentUrl.IsNullOrEmpty())
            {
                shop.BusinessRegistrationDocumentUrl =  await azureBlobStorageService.UploadImageAsync(imageBytes, shop.Id + "-BusinessRegistrationDocumentUrl");
                //shop.BusinessRegistrationDocumentUrl =  await imageRepository.Upload(request.ShopVerifyRequest.BusinessRegistrationDocumentUrl, shop.Id + "-BusinessRegistrationDocumentUrl");
            }
            else
            {
                shop.BusinessRegistrationDocumentUrl =  await azureBlobStorageService.UpdateImageAsync(imageBytes, shop.Id + "-BusinessRegistrationDocumentUrl");
                //shop.BusinessRegistrationDocumentUrl =  await imageRepository.Update(request.ShopVerifyRequest.BusinessRegistrationDocumentUrl, shop.Id + "-BusinessRegistrationDocumentUrl");
            }
        }

        if (!string.IsNullOrEmpty(request.ShopVerifyRequest.OwnerIdentityCardUrl))
        {
            string base64Image = request.ShopVerifyRequest.OwnerIdentityCardUrl.Split(',')[1];
            byte[] imageBytes = Convert.FromBase64String(base64Image);
            if (shop.OwnerIdentityCardUrl.IsNullOrEmpty())
            {
                shop.OwnerIdentityCardUrl = await azureBlobStorageService.UploadImageAsync(imageBytes, shop.Id + "-OwnerIdentityCardUrl");
                //shop.OwnerIdentityCardUrl = await imageRepository.Upload(request.ShopVerifyRequest.OwnerIdentityCardUrl, shop.Id + "-OwnerIdentityCardUrl");
            }
            else
            {
                shop.OwnerIdentityCardUrl = await azureBlobStorageService.UpdateImageAsync(imageBytes, shop.Id + "-OwnerIdentityCardUrl");
                //shop.OwnerIdentityCardUrl = await imageRepository.Update(request.ShopVerifyRequest.OwnerIdentityCardUrl, shop.Id + "-OwnerIdentityCardUrl");
            }
            
        }

        if (!string.IsNullOrEmpty(request.ShopVerifyRequest.OwnerSelfieUrl))
        {
            string base64Image = request.ShopVerifyRequest.OwnerSelfieUrl.Split(',')[1];
            byte[] imageBytes = Convert.FromBase64String(base64Image);
            if (shop.OwnerSelfieUrl.IsNullOrEmpty())
            {
                shop.OwnerSelfieUrl = await azureBlobStorageService.UploadImageAsync(imageBytes, shop.Id + "-OwnerSelfieUrl");
                //shop.OwnerSelfieUrl = await imageRepository.Upload(request.ShopVerifyRequest.OwnerSelfieUrl, shop.Id + "-OwnerSelfieUrl");
            }
            else
            {
                shop.OwnerSelfieUrl = await azureBlobStorageService.UpdateImageAsync(imageBytes, shop.Id + "-OwnerSelfieUrl");
                //shop.OwnerSelfieUrl = await imageRepository.Update(request.ShopVerifyRequest.OwnerSelfieUrl, shop.Id + "-OwnerSelfieUrl");
            }
        }
            
        shop.VerificationStatus = (int) ShopVerificationStatus.Pending;
        shop.UpdatedAt = DateTime.Now;
        
         shop =  await unitOfWork.ShopRepository.Update(shop);
         var shopResponse = mapper.Map<ShopResponseDTO>(shop);
         shopResponse.Categories = JsonConvert.DeserializeObject<List<string>>(shop.Category) ?? new List<string>();
         shopResponse.SocialMediaLinks = JsonConvert.DeserializeObject<Dictionary<string, string>>(shop.SocialMedias) ?? new Dictionary<string, string>();
         shopResponse.Rating =  await unitOfWork.ShopRepository.GetShopAverageRatingAsync(request.ShopVerifyRequest.Id);
        
        return new BaseResponse<ShopResponseDTO>
        {
            Data = shopResponse,
            Message = "Shop Verification Request Sent Successfully",
            Success = true
        };

    }
}
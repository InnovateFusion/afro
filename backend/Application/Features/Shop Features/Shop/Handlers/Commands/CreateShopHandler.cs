using AutoMapper;
using backend.Application.Contracts.Infrastructure.Repositories;
using backend.Application.Contracts.Persistence;
using backend.Application.DTO.Shop.ShopDTO.DTO;
using backend.Application.DTO.Shop.ShopDTO.Validations;
using backend.Application.Exceptions;
using backend.Application.Features.Shop_Features.Shop.Requests.Commands;
using backend.Application.Response;
using backend.Infrastructure.Models;
using MediatR;
using Microsoft.Extensions.Options;
using Newtonsoft.Json;
using IImageRepository = backend.Application.Contracts.Infrastructure.Repositories.IImageRepository;

namespace backend.Application.Features.Shop_Features.Shop.Handlers.Commands;

public class CreateShopHandler(IUnitOfWork unitOfWork, IMapper mapper,   IImageRepository imageRepository, 		IAzureBlobStorageService azureBlobStorageService,
    IOptions<BlobStorageSettings> blobStorageSettings)
    : IRequestHandler<CreateShopRequest, BaseResponse<ShopResponseDTO>>
{
    private readonly BlobStorageSettings _blobStorageSettings = blobStorageSettings.Value;
    public async Task<BaseResponse<ShopResponseDTO>> Handle(CreateShopRequest request, CancellationToken cancellationToken)
    {
        var shopExists = await unitOfWork.ShopRepository.IsUserShopOwnerAsync(request.UserId);
        if (shopExists)
            throw new BadRequestException("User already has a shop");
        
        var validator = new CreateShopValidation(
            unitOfWork.ShopRepository);
        var validationResult = await validator.ValidateAsync(request.Shop);
        if (!validationResult.IsValid)
            throw new BadRequestException(
                validationResult.Errors.FirstOrDefault()?.ErrorMessage!
            );
        
        var isShopDeleted = await unitOfWork.ShopRepository.IsShopDeletedAsync(request.UserId);

        var shop = mapper.Map<Domain.Entities.Shop.Shop>(request.Shop);
        shop.Id = request.UserId;
        string base64Image = shop.Logo.Split(',')[1];
        byte[] imageBytes = Convert.FromBase64String(base64Image);
        shop.Logo = await azureBlobStorageService.UploadImageAsync(imageBytes, shop.Id + "-logo"); 
       // shop.Logo =  await imageRepository.Upload(shop.Logo, shop.Id + "-logo");
       if (request.Shop.Banner != null)
       {
            base64Image = request.Shop.Banner.Split(',')[1];
            imageBytes = Convert.FromBase64String(base64Image);
            shop.Banner = await azureBlobStorageService.UploadImageAsync(imageBytes, shop.Id + "-banner");
           //shop.Banner = await imageRepository.Upload(request.Shop.Banner, shop.Id + "-banner");
       }
       else
       {
           shop.Banner = null;
       }

        shop.UserId = request.UserId;
        shop.Category = JsonConvert.SerializeObject(request.Shop.Categories);
        shop.SocialMedias = JsonConvert.SerializeObject(request.Shop.SocialMediaLinks);

        if (isShopDeleted)
        {
            var updateShop = await unitOfWork.ShopRepository.GetAllShopByIdAsync(request.UserId);
            updateShop.Name = shop.Name;
            updateShop.Description = shop.Description;
            updateShop.Category = shop.Category;
            updateShop.Street = shop.Street;
            updateShop.SubLocality = shop.SubLocality;
            updateShop.SubAdministrativeArea = shop.SubAdministrativeArea;
            updateShop.PostalCode = shop.PostalCode;
            updateShop.Latitude = shop.Latitude;
            updateShop.Longitude = shop.Longitude;
            updateShop.PhoneNumber = shop.PhoneNumber;
            updateShop.Banner = shop.Banner;
            updateShop.Logo = shop.Logo;
            updateShop.SocialMedias = shop.SocialMedias;
            updateShop.Website = shop.Website;
            updateShop.OwnerIdentityCardUrl = shop.OwnerIdentityCardUrl;
            updateShop.BusinessRegistrationNumber = shop.BusinessRegistrationNumber;
            updateShop.BusinessRegistrationDocumentUrl = shop.BusinessRegistrationDocumentUrl;
            updateShop.OwnerSelfieUrl = shop.OwnerSelfieUrl;
            updateShop.VerifiedAt = shop.VerifiedAt;
            updateShop.IsDeleted = false;
            updateShop.DeletedAt = DateTime.Now;
            updateShop.VerificationStatus = 0;
            
            await unitOfWork.ShopRepository.Update(updateShop);
            
            var workingHours = await unitOfWork.WorkingHourRepository.GetWorkingHoursByShopIdAsync(request.UserId);
            await unitOfWork.WorkingHourRepository.DeleteRangeAsync(workingHours);
        }
        else
        {
            await unitOfWork.ShopRepository.Add(shop);   
        }
        var shopResponse = mapper.Map<ShopResponseDTO>(shop);
        shopResponse.Categories =  JsonConvert.DeserializeObject<List<string>>(shop.Category) ?? new List<string>();
        shopResponse.SocialMediaLinks = JsonConvert.DeserializeObject<Dictionary<string, string>>(shop.SocialMedias) ?? new Dictionary<string, string>();
        
        return new BaseResponse<ShopResponseDTO>
        {
            Success = true,
            Data = shopResponse,
            Message = "Shop Created Successfully"
        };
    }
}
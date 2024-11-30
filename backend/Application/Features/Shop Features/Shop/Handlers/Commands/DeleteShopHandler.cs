using AutoMapper;
using backend.Application.Contracts.Infrastructure.Services;
using backend.Application.Contracts.Persistence;
using backend.Application.DTO.Shop.ShopDTO.DTO;
using backend.Application.Exceptions;
using backend.Application.Features.Shop_Features.Shop.Requests.Commands;
using backend.Application.Response;
using MediatR;
using Microsoft.IdentityModel.Tokens;
using Newtonsoft.Json;
using IImageRepository = backend.Application.Contracts.Infrastructure.Repositories.IImageRepository;

namespace backend.Application.Features.Shop_Features.Shop.Handlers.Commands;

public class DeleteShopHandler(IUnitOfWork unitOfWork,IRabbitMQService rabbitMqService, IMapper mapper)
    : IRequestHandler<DeleteShopRequest, BaseResponse<ShopResponseDTO>>
{
    public async Task<BaseResponse<ShopResponseDTO>> Handle(DeleteShopRequest request, CancellationToken cancellationToken)
    {
        var shop = await unitOfWork.ShopRepository.GetShopByIdAsync(request.Id);
        if (shop == null)
            throw new NotFoundException("Shop Not Found");
        
        if (shop.UserId != request.UserId)
            throw new BadRequestException("You are not the owner of this shop");
        //await imageRepository.Delete(shop.Id + "-logo");
        // if (shop.Banner != null)
        // {
        //     await imageRepository.Delete(shop.Id + "-banner");
        // }
        //
        // if (!string.IsNullOrEmpty(shop.BusinessRegistrationDocumentUrl))
        // {
        //     await imageRepository.Delete($"{shop.Id}-BusinessRegistrationDocumentUrl");
        // }
        //
        // if (!string.IsNullOrEmpty(shop.OwnerIdentityCardUrl))
        // {
        //     await imageRepository.Delete($"{shop.Id}-OwnerIdentityCardUrl");
        // }
        //
        // if (!string.IsNullOrEmpty(shop.OwnerSelfieUrl))
        // {
        //     await imageRepository.Delete($"{shop.Id}-OwnerSelfieUrl");
        // }
        rabbitMqService.PublishMessageAsync("delete-notification", "delete-notification", "delete-notification", request.Id);

        await unitOfWork.ProductRepository.DeleteAllShopProductsAsync(request.Id);
        await unitOfWork.ImageRepository.DeleteAllShopImagesAsync(request.Id);
        
        shop.IsDeleted = true;
        shop.DeletedAt = DateTime.UtcNow;
        await unitOfWork.ShopRepository.Update(shop);
        var shopResponse = mapper.Map<ShopResponseDTO>(shop);
        shopResponse.Categories =  JsonConvert.DeserializeObject<List<string>>(shop.Category) ?? new List<string>();
        shopResponse.SocialMediaLinks = JsonConvert.DeserializeObject<Dictionary<string, string>>(shop.SocialMedias) ?? new Dictionary<string, string>();
        
        
        return new BaseResponse<ShopResponseDTO>
        {
            Success = true,
            Data = shopResponse,
            Message = "Shop Deleted Successfully"
        };
    }
}
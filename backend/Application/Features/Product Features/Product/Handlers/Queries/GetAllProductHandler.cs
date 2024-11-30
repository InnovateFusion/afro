using AutoMapper;
using backend.Application.Contracts.Persistence;
using backend.Application.DTO.Product.ProductDTO.DTO;
using backend.Application.Enum;
using backend.Application.Features.Product_Features.Product.Requests.Queries;
using backend.Domain.Entities.Product;
using MediatR;

namespace backend.Application.Features.Product_Features.Product.Handlers.Queries
{
	public class GetAllProductHandler(IUnitOfWork unitOfWork, IMapper mapper)
		: IRequestHandler<GetAllProduct, List<ProductResponseDTO>>
	{
		public async Task<List<ProductResponseDTO>> Handle(
			GetAllProduct request,
			CancellationToken cancellationToken
		)
		{
			var products = await unitOfWork.ProductRepository.GetAll(
				search: request.Search,
				colorIds: request.ColorIds,
				materialIds: request.MaterialIds,
				sizeIds: request.SizeIds,
				brandIds: request.BrandIds,
				designIds: request.DesignIds,
				categoryIds: request.CategoryIds,
				isNegotiable: request.IsNegotiable,
				userId: request.UserId,
				minPrice: request.MinPrice,
				maxPrice: request.MaxPrice,
				shopId: request.ShopId,
				status: request.Status,
				inStock:request.InStock,
				isNew: request.IsNew,
				isDeliverable: request.IsDeliverable,
				availableQuantity: request.AvailableQuantity,
				latitude: request.Latitude,
				longitude: request.Longitude,
				radiusInKilometers: request.RadiusInKilometers,
				sortBy: request.SortBy,
				sortOrder: request.SortOrder,
				skip: request.Skip,
				limit: request.Limit
			);
			
			foreach (var product in products)
			{
				if (product.Shop.Id != request.UserId)
				{
					await unitOfWork.ProductViewRepository.Add(
						new ProductView
						{
							UserId = request.UserId,
							ProductId = product.Id,
							ViewedAt = DateTime.Now
						}
					);
				}
			}
			
			var productResponse = mapper.Map<List<ProductResponseDTO>>(products);
			if (request.UserId != null)
			{
				foreach (var product in productResponse)
				{
					product.IsFavorite = await unitOfWork.FavouriteProductRepository.IsFavourite(
						userId: request.UserId,
						productId: product.Id
					);
				}
			}

			List<ProductResponseDTO> productList = new List<ProductResponseDTO>();

			foreach (var product in productResponse)
			{
				if (product.ProductApprovalStatus == (int)ProductApprovalStatus.Approved || request.UserId == product.Shop.Id) 
				{
					productList.Add(product);
				}
			}
			
			return productList;
		}
	}
}

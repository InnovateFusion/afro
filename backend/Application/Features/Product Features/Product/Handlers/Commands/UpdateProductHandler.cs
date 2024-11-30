using System.Text.Json;
using AutoMapper;
using backend.Application.Contracts.Infrastructure.Services;
using backend.Application.Contracts.Persistence;
using backend.Application.DTO.Product.ProductDTO.DTO;
using backend.Application.Enum;
using backend.Application.Exceptions;
using backend.Application.Features.Product_Features.Product.Requests.Commands;
using backend.Application.Response;
using backend.Domain.Entities.Product;
using MediatR;

namespace backend.Application.Features.Product_Features.Product.Handlers.Commands
{
    public class UpdateProductHandler(IUnitOfWork unitOfWork, IMapper mapper, IRabbitMQService rabbitMqService)
        : IRequestHandler<UpdateProductRequest, BaseResponse<ProductResponseDTO>>
    {
        public async Task<BaseResponse<ProductResponseDTO>> Handle(
            UpdateProductRequest request,
            CancellationToken cancellationToken
        )
        {
            var product = await unitOfWork.ProductRepository.GetById(request.Id);

            if (request.Product.Title != null)
                product.Title = request.Product.Title;
            if (request.Product.Description != null)
                product.Description = request.Product.Description;
            if (request.Product.Price != null)
                product.Price = request.Product.Price ?? 1;
            if (request.Product.InStock != null)
                product.InStock = request.Product.InStock ?? false;
            if (request.Product.IsNew != null)
                product.IsNew = request.Product.IsNew ?? false;
            if (request.Product.Status != null)
                product.Status = request.Product.Status;
            if (request.Product.IsNegotiable != null)
                product.IsNegotiable = request.Product.IsNegotiable ?? false;
            if (request.Product.VideoUrl != null)
                product.VideoUrl = request.Product.VideoUrl;
            if (request.Product.AvailableQuantity != null)
                product.AvailableQuantity = request.Product.AvailableQuantity ?? 1;
            if (request.Product.IsDeliverable != null)
                product.IsDeliverable = request.Product.IsDeliverable ?? false;
            
            if (request.Product.CategoryIds is { Count: > 0 })
            {
                var categories = await unitOfWork.CategoryRepository.GetByIds(
                    request.Product.CategoryIds
                );

                if (categories == null || categories.Count != request.Product.CategoryIds.Count)
                    throw new NotFoundException("category Not Found");

                await unitOfWork.ProductCategoryRepository.DeleteByProductId(product.Id);

                foreach (var t in categories)
                {
                    var productCategory = new ProductCategory
                    {
                        ProductId = product.Id,
                        Category = t
                    };
                    product.ProductCategories.Add(productCategory);
                    await unitOfWork.ProductCategoryRepository.Add(productCategory);
                }
            }

            if (request.Product.ColorIds is { Count: > 0 })
            {
                var colors = await unitOfWork.ColorRepository.GetByIds(request.Product.ColorIds);

                if (colors == null || colors.Count != request.Product.ColorIds.Count)
                    throw new NotFoundException("color Not Found");

                await unitOfWork.ProductColorRepository.DeleteByProductId(product.Id);

                foreach (var t in colors)
                {
                    var productColor = new ProductColor
                    {
                        ProductId = product.Id,
                        Color = t
                    };
                    product.ProductColors.Add(productColor);
                    await unitOfWork.ProductColorRepository.Add(productColor);
                }
            }
            
            if (request.Product.ImageIds is { Count: > 0 })
            {
                var imagesExist = await unitOfWork.ImageRepository.AllImagesExist(request.Product.ImageIds);

                if (!imagesExist)
                    throw new NotFoundException("image Not Found");
                
                await unitOfWork.ImageRepository.DeleteProductId( product.Id);
                
                var images = await unitOfWork.ImageRepository.GetByIds(request.Product.ImageIds);
                
                foreach (var t in images)
                {
                    var productImage = new ProductImage
                    {
                        ProductId = product.Id,
                        Image = t
                    };
                    product.ProductImages.Add(productImage);
                   await unitOfWork.ImageRepository.AddProductImage(productImage);
                }
            }

            if (request.Product.SizeIds is { Count: > 0 })
            {
                var sizes = await unitOfWork.SizeRepository.GetByIds(request.Product.SizeIds);

                if (sizes == null || sizes.Count != request.Product.SizeIds.Count)
                    throw new NotFoundException("sizes Not Found");

                await unitOfWork.ProductSizeRepository.DeleteByProductId(product.Id);

                foreach (var t in sizes)
                {
                    var productSize = new ProductSize { ProductId = product.Id, Size = t };
                    product.ProductSizes.Add(productSize);
                    await unitOfWork.ProductSizeRepository.Add(productSize);
                }
            }

            if (request.Product.MaterialIds is { Count: > 0 })
            {
                var materialIds = await unitOfWork.MaterialRepository.GetByIds(
                    request.Product.MaterialIds
                );

                if (materialIds == null || materialIds.Count != request.Product.MaterialIds.Count)
                    throw new NotFoundException("materialIds Not Found");

                await unitOfWork.ProductMaterialRepository.DeleteByProductId(product.Id);

                foreach (var t in materialIds)
                {
                    var productMaterial = new ProductMaterial
                    {
                        ProductId = product.Id,
                        Material = t
                    };
                    product.ProductMaterials.Add(productMaterial);
                    await unitOfWork.ProductMaterialRepository.Add(productMaterial);
                }
            }
            
            if (request.Product.BrandIds is { Count: > 0 })
            {
                var brands = await unitOfWork.BrandRepository.GetByIds(request.Product.BrandIds);

                if (brands == null || brands.Count != request.Product.BrandIds.Count)
                    throw new NotFoundException("brands Not Found");

                await unitOfWork.ProductBrandRepository.DeleteByProductId(product.Id);

                foreach (var t in brands)
                {
                    var productBrand = new ProductBrand
                    {
                        ProductId = product.Id,
                        Brand = t
                    };
                    product.ProductBrands.Add(productBrand);
                    await unitOfWork.ProductBrandRepository.Add(productBrand);
                }
            }
            
            if (request.Product.DesignIds is { Count: > 0 })
            {
                var designs = await unitOfWork.DesignRepository.GetByIds(request.Product.DesignIds);

                if (designs == null || designs.Count != request.Product.DesignIds.Count)
                    throw new NotFoundException("designs Not Found");

                await unitOfWork.ProductDesignRepository.DeleteByProductId(product.Id);

                foreach (var t in designs)
                {
                    var productDesign = new ProductDesign
                    {
                        ProductId = product.Id,
                        Design = t
                    };
                    product.ProductDesigns.Add(productDesign);
                    await unitOfWork.ProductDesignRepository.Add(productDesign);
                }
            }
            
            product.ProductApprovalStatus = (int)ProductApprovalStatus.Pending;

            product = await unitOfWork.ProductRepository.Update(product);
            var response = mapper.Map<ProductResponseDTO>(product);
            
            rabbitMqService.PublishMessageAsync("notification-for-admin-product", "notification-for-admin-product", "notification-for-admin-product",  
                response.ToJson());

            return new BaseResponse<ProductResponseDTO>
            {
                Message = "Product Created Successfully",
                Success = true,
                Data = response
            };
        }
    }
}

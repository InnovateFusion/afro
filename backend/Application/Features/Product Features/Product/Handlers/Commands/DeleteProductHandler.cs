using AutoMapper;
using backend.Application.Contracts.Infrastructure.Repositories;
using backend.Application.Contracts.Infrastructure.Services;
using backend.Application.Contracts.Persistence;
using backend.Application.DTO.Product.ProductDTO.DTO;
using backend.Application.Exceptions;
using backend.Application.Features.Product_Features.Product.Requests.Commands;
using backend.Application.Response;
using MediatR;

namespace backend.Application.Features.Product_Features.Product.Handlers.Commands
{
	public class DeleteProductHandler(
		IUnitOfWork unitOfWork,
		IRabbitMQService rabbitMqService,
		IMapper mapper,
		IImageRepository imageRepository)
		: IRequestHandler<DeleteProductRequest, BaseResponse<ProductResponseDTO>>
	{
		public async Task<BaseResponse<ProductResponseDTO>> Handle(
			DeleteProductRequest request,
			CancellationToken cancellationToken
		)
		{
			if (request.Id.Length == 0)
				throw new BadRequestException("Invalid Product Id");

			var product = await unitOfWork.ProductRepository.GetById(request.Id);

			if (product == null)
				throw new NotFoundException("Product Not Found");

			foreach (var image in product.ProductImages)
			{
				if (await unitOfWork.ProductRepository.GetCountProductImages(image.Image.Id) == 1)
				{
					var theImage = await unitOfWork.ImageRepository.GetById(image.Image.Id);
					await unitOfWork.ImageRepository.Delete(theImage);
				}
			}

			product.IsDeleted = true;
			product.DeletedAt = DateTime.UtcNow;
			await unitOfWork.ProductRepository.Update(product);
			rabbitMqService.PublishMessageAsync("delete-notification", "delete-notification", "delete-notification", request.Id);


			return new BaseResponse<ProductResponseDTO>
			{
				Message = "Product Deleted Successfully",
				Success = true,
				Data = mapper.Map<ProductResponseDTO>(product)
			};
		}
	}
}

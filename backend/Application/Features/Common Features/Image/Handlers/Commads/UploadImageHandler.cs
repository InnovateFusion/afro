using AutoMapper;
using backend.Application.Contracts.Infrastructure.Repositories;
using backend.Application.Contracts.Persistence;
using backend.Application.DTO.Common.Image.DTO;
using backend.Application.DTO.Common.Image.Validations;
using backend.Application.Exceptions;
using backend.Application.Features.Common_Features.Image.Requests.Commands;
using backend.Application.Response;
using MediatR;
using IImageRepository = backend.Application.Contracts.Infrastructure.Repositories.IImageRepository;

namespace backend.Application.Features.Common_Features.Image.Handlers.Commads
{
	public class UploadImageHandler(
		IUnitOfWork unitOfWork,
		IMapper mapper,
		IAzureBlobStorageService azureBlobStorageService,
		IImageRepository imageRepository)
		: IRequestHandler<UploadImageRequest, BaseResponse<ImageResponseDTO>>
	{
		
		public async Task<BaseResponse<ImageResponseDTO>> Handle(
			UploadImageRequest request,
			CancellationToken cancellationToken
		)
		{
			var validator = new ImageUploadValidation();
			var validationResult = await validator.ValidateAsync(request.Image!);
			if (!validationResult.IsValid)
			{
				throw new BadRequestException(validationResult.Errors.First().ErrorMessage);
			}

			var user = await unitOfWork.UserRepository.GetById(request.UserId);
			
			var _image = new Domain.Entities.Common.Image
			{
				ImageUrl = "",
				User = user,
				IsDeleted = false
			};
			string base64Image = request.Image.Base64Image.Split(',')[1];
			byte[] imageBytes = Convert.FromBase64String(base64Image);
			_image.ImageUrl = await azureBlobStorageService.UploadImageAsync(imageBytes, _image.Id);
			//_image.ImageUrl = await imageRepository.Upload(request.Image.Base64Image, _image.Id);
			await unitOfWork.ImageRepository.Add(_image);
			return new BaseResponse<ImageResponseDTO>
			{
				Message = "Image Uploaded Successfully",
				Success = true,
				Data = mapper.Map<ImageResponseDTO>(_image)
			};
		}
	}
}

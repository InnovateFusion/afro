using AutoMapper;
using backend.Application.Contracts.Infrastructure.Repositories;
using backend.Application.Contracts.Persistence;
using backend.Application.DTO.Product.CategoryDTO.DTO;
using backend.Application.DTO.Product.CategoryDTO.Validations;
using backend.Application.Exceptions;
using backend.Application.Features.Product_Features.Category.Requests.Commands;
using backend.Application.Response;
using MediatR;
using Newtonsoft.Json;

namespace backend.Application.Features.Product_Features.Category.Handlers.Commands
{
    public class UpdateCategoryHandler(
        IUnitOfWork unitOfWork,
        IMapper mapper,
        IImageRepository imageRepository)
        : IRequestHandler<UpdateCategoryRequest, BaseResponse<CategoryResponseDTO>>
    {
        public async Task<BaseResponse<CategoryResponseDTO>> Handle(
            UpdateCategoryRequest request,
            CancellationToken cancellationToken
        )
        {
            var validator = new UpdateCategoryValidation(unitOfWork.CategoryRepository);
            var validationResult = await validator.ValidateAsync(request.Category);
            if (!validationResult.IsValid)
            {
                throw new BadRequestException(validationResult.Errors.First().ErrorMessage);
            }
            
            var existingCategory = await unitOfWork.CategoryRepository.GetById(request.Id);
            if (existingCategory == null)
                throw new NotFoundException("Category Not Found");

            if (request?.Category?.Name != null)
            {
                var existingCategoryName = await unitOfWork.CategoryRepository.GetByName(
                    request.Category.Name
                );
                if (existingCategoryName != null && existingCategoryName.Id != request.Id)
                    throw new BadRequestException("Category Name Already Exists");
                if (request.Category.Name.Length == 0)
                    throw new BadRequestException("Category Name Cannot Be Empty");
                existingCategory.Name = request.Category.Name.Trim().ToLower();
            }

            if (request?.Category?.Image != null)
                existingCategory.Image = await imageRepository.Update(
                    request.Category.Image,
                    existingCategory.Id
                );
            
            if (request?.Category?.Domain != null)
                existingCategory.Domain = JsonConvert.SerializeObject(request.Category.Domain);

            existingCategory.UpdatedAt = DateTime.Now;

            await unitOfWork.CategoryRepository.Update(existingCategory);
            return new BaseResponse<CategoryResponseDTO>
            {
                Message = "Category Updated Successfully",
                Success = true,
                Data = new CategoryResponseDTO
                {
                    Id = existingCategory.Id,
                    Name = existingCategory.Name,
                    Image = existingCategory.Image,
                    Domain = JsonConvert.DeserializeObject<Dictionary<string, List<string>>>(existingCategory.Domain)
                }
            };
        }
    }
}

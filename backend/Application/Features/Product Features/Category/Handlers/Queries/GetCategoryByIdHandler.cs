using AutoMapper;
using backend.Application.Contracts.Persistence;
using backend.Application.DTO.Product.CategoryDTO.DTO;
using backend.Application.Exceptions;
using backend.Application.Features.Product_Features.Category.Requests.Queries;
using MediatR;
using Newtonsoft.Json;

namespace backend.Application.Features.Product_Features.Category.Handlers.Queries
{
    public class GetCategoryByIdHandler(IUnitOfWork unitOfWork, IMapper mapper)
        : IRequestHandler<GetCategoryById, CategoryResponseDTO>
    {
        public async Task<CategoryResponseDTO> Handle(GetCategoryById request, CancellationToken cancellationToken)
        {
            if (request.Id == null || request.Id.Length == 0)
            {
                throw new BadRequestException("Id is required");
            }

            var category = await unitOfWork.CategoryRepository.GetById(request.Id);
            if (category == null)
            {
                throw new NotFoundException("Category with that {request.Id} does not exist");
            }
            return new CategoryResponseDTO
            {
                Id = category.Id,
                Name = category.Name,
                Image = category.Image,
                Domain = JsonConvert.DeserializeObject<Dictionary<string, List<string>>>(category.Domain)
            };
        }

    }
}
using AutoMapper;
using backend.Application.Contracts.Infrastructure.Services;
using backend.Application.Contracts.Persistence;
using backend.Application.DTO.Product.CategoryDTO.DTO;
using backend.Application.Exceptions;
using backend.Application.Features.Product_Features.Category.Requests.Queries;
using MediatR;
using Newtonsoft.Json;

namespace backend.Application.Features.Product_Features.Category.Handlers.Queries
{
    public class GetAllCategoryHandler(IUnitOfWork unitOfWork, IMapper mapper, ICacheService cacheService)
        : IRequestHandler<GetAllCategory, List<CategoryResponseDTO>>
    {
        private readonly IMapper _mapper = mapper;

        public async Task<List<CategoryResponseDTO>> Handle(GetAllCategory request, CancellationToken cancellationToken)
        {
            var cacheKey = "CategoryList";
            if (await cacheService.KeyExists(cacheKey))
            {
                return await cacheService.GetList<CategoryResponseDTO>(cacheKey);
            }
            
            var categories = await unitOfWork.CategoryRepository.GetAll();
            if (categories == null)
            {
                throw new NotFoundException("No categories found");
            }

            var categoryResponse = new List<CategoryResponseDTO>();
            foreach (var category in categories)
            {
                categoryResponse.Add(new CategoryResponseDTO
                {
                    Id = category.Id,
                    Name = category.Name,
                    Image = category.Image,
                    Domain = JsonConvert.DeserializeObject<Dictionary<string, List<string>>>(category.Domain)
                });
            }
            
            await cacheService.AddList<CategoryResponseDTO>(cacheKey, categoryResponse);
            return categoryResponse;
        }
    }
}
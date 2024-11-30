using AutoMapper;
using backend.Application.Contracts.Infrastructure.Services;
using backend.Application.Contracts.Persistence;
using backend.Application.DTO.Product.BrandDTO.DTO;
using backend.Application.Exceptions;
using backend.Application.Features.Product_Features.Brand.Requests.Queries;
using MediatR;

namespace backend.Application.Features.Product_Features.Brand.Handlers.Queries
{
    public class GetAllBrandHandler(IUnitOfWork unitOfWork, IMapper mapper, ICacheService cacheService)
        : IRequestHandler<GetAllBrand, List<BrandResponseDTO>>
    {
        public async Task<List<BrandResponseDTO>> Handle(
            GetAllBrand request,
            CancellationToken cancellationToken
        )
        {
            var cacheKey = "BrandList";
            if (await cacheService.KeyExists(cacheKey))
            {
                return await cacheService.GetList<BrandResponseDTO>(cacheKey);
            }
            var brands = await unitOfWork.BrandRepository.GetAll();
            if (brands == null)
            {
                throw new NotFoundException("No Brands found");
            }
            
            var result = mapper.Map<List<BrandResponseDTO>>(brands);
            await cacheService.AddList<BrandResponseDTO>(cacheKey, result);
            return result;
        }
    }
}

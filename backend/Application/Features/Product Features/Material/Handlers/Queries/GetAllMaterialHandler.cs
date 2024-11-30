using AutoMapper;
using backend.Application.Contracts.Infrastructure.Services;
using backend.Application.Contracts.Persistence;
using backend.Application.DTO.Product.MaterialDTO.DTO;
using backend.Application.Exceptions;
using backend.Application.Features.Product_Features.Material.Requests.Queries;
using MediatR;

namespace backend.Application.Features.Product_Features.Material.Handlers.Queries
{
    public class GetAllMaterialHandler(IUnitOfWork unitOfWork, IMapper mapper, ICacheService cacheService)
        : IRequestHandler<GetAllMaterial, List<MaterialResponseDTO>>
    {
        public async Task<List<MaterialResponseDTO>> Handle(GetAllMaterial request, CancellationToken cancellationToken)
        {
            var cacheKey = "MaterialList";
            if (await cacheService.KeyExists(cacheKey))
            {
                return await cacheService.GetList<MaterialResponseDTO>(cacheKey);
            }
            var materials = await unitOfWork.MaterialRepository.GetAll();
            if (materials == null)
            {
                throw new NotFoundException("No Materials found");
            }
            var materialResponse = mapper.Map<List<MaterialResponseDTO>>(materials);
            await cacheService.AddList<MaterialResponseDTO>(cacheKey, materialResponse);
            return materialResponse;
        }
    }
}
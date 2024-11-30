using AutoMapper;
using backend.Application.Contracts.Infrastructure.Services;
using backend.Application.Contracts.Persistence;
using backend.Application.DTO.Product.DesignDTO.DTO;
using backend.Application.Exceptions;
using backend.Application.Features.Product_Features.Design.Requests.Queries;
using MediatR;

namespace backend.Application.Features.Product_Features.Design.Handlers.Queries
{
    public class GetAllDesignHandler(IUnitOfWork unitOfWork, IMapper mapper, ICacheService cacheService)
        : IRequestHandler<GetAllDesign, List<DesignResponseDTO>>
    {
        public async Task<List<DesignResponseDTO>> Handle(GetAllDesign request, CancellationToken cancellationToken)
        {
            var cacheKey = "DesignList";
            if (await cacheService.KeyExists(cacheKey))
            {
                return await cacheService.GetList<DesignResponseDTO>(cacheKey);
            }
            var designs = await unitOfWork.DesignRepository.GetAll();
            if (designs == null)
            {
                throw new NotFoundException("No Designs found");
            }
            var designResponse = mapper.Map<List<DesignResponseDTO>>(designs);
            await cacheService.AddList<DesignResponseDTO>(cacheKey, designResponse);
            return designResponse;
        }
    }
}
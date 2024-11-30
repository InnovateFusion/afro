using AutoMapper;
using backend.Application.Contracts.Infrastructure.Services;
using backend.Application.Contracts.Persistence;
using backend.Application.DTO.Product.ColorDTO.DTO;
using backend.Application.Exceptions;
using backend.Application.Features.Product_Features.Color.Requests.Queries;
using MediatR;

namespace backend.Application.Features.Product_Features.Color.Handlers.Queries
{
    public class GetAllColorHandler(IUnitOfWork unitOfWork, IMapper mapper,  ICacheService cacheService)
        : IRequestHandler<GetAllColor, List<ColorResponseDTO>>
    {
        public async Task<List<ColorResponseDTO>> Handle(GetAllColor request, CancellationToken cancellationToken)
        {
            var cacheKey = "ColorList";
            if (await cacheService.KeyExists(cacheKey))
            {
                return await cacheService.GetList<ColorResponseDTO>(cacheKey);
            }
            var colors = await unitOfWork.ColorRepository.GetAll();
            if (colors == null)
            {
                throw new NotFoundException("No Colors found");
            }
            var result = mapper.Map<List<ColorResponseDTO>>(colors);
            await cacheService.AddList<ColorResponseDTO>(cacheKey, result);
            return result;
            
        }
    }
}
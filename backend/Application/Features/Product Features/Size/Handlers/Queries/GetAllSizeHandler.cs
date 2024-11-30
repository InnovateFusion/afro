using AutoMapper;
using backend.Application.Contracts.Infrastructure.Services;
using backend.Application.Contracts.Persistence;
using backend.Application.DTO.Product.SizeDTO.DTO;
using backend.Application.Exceptions;
using backend.Application.Features.Product_Features.Size.Requests.Queries;
using MediatR;

namespace backend.Application.Features.Product_Features.Size.Handlers.Queries
{
    public class GetAllSizeHandler(IUnitOfWork unitOfWork, IMapper mapper, ICacheService cacheService)
        : IRequestHandler<GetAllSize, List<SizeResponseDTO>>
    {
        public async Task<List<SizeResponseDTO>> Handle(GetAllSize request, CancellationToken cancellationToken)
        {
            var cacheKey = "SizeList";
            if (await cacheService.KeyExists(cacheKey))
            {
                return await cacheService.GetList<SizeResponseDTO>(cacheKey);
            }
            var sizes = await unitOfWork.SizeRepository.GetAll();
            if (sizes == null)
            {
                throw new NotFoundException("No Sizes found");
            }
            var sizeResponse = mapper.Map<List<SizeResponseDTO>>(sizes);
            await cacheService.AddList<SizeResponseDTO>(cacheKey, sizeResponse);
            return sizeResponse;
        }
    }
}
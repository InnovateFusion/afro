using AutoMapper;
using backend.Application.Contracts.Infrastructure.Services;
using backend.Application.Contracts.Persistence;
using backend.Application.DTO.Common.Location.DTO;
using backend.Application.Exceptions;
using backend.Application.Features.Common_Features.Location.Requests.Queries;
using MediatR;

namespace backend.Application.Features.Common_Features.Location.Handlers.Queries
{
    public class GetAllLocationHandler(IUnitOfWork unitOfWork, IMapper mapper, ICacheService cacheService)
        : IRequestHandler<GetAllLocation, List<LocationResponseDTO>>
    {
        public async Task<List<LocationResponseDTO>> Handle(
            GetAllLocation request,
            CancellationToken cancellationToken
        )
        {
            var cacheKey = "LocationList";
            if (await cacheService.KeyExists(cacheKey))
            {
                return await cacheService.GetList<LocationResponseDTO>(cacheKey);
            }
            var locations = await unitOfWork.LocationRepository.GetAll();
            if (locations == null)
            {
                throw new NotFoundException("No Locations found");
            }
            var locationResponse = mapper.Map<List<LocationResponseDTO>>(locations);
            await cacheService.AddList<LocationResponseDTO>(cacheKey, locationResponse);
            return locationResponse;
        }
    }
}

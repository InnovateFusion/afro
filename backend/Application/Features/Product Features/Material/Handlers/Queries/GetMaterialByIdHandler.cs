using AutoMapper;
using backend.Application.Contracts.Persistence;
using backend.Application.DTO.Product.MaterialDTO.DTO;
using backend.Application.Exceptions;
using backend.Application.Features.Product_Features.Material.Requests.Queries;
using MediatR;

namespace backend.Application.Features.Product_Features.Material.Handlers.Queries
{
    public class GetMaterialByIdHandler(IUnitOfWork unitOfWork, IMapper mapper)
        : IRequestHandler<GetMaterialById, MaterialResponseDTO>
    {
        public async Task<MaterialResponseDTO> Handle(GetMaterialById request, CancellationToken cancellationToken)
        {
            if (request.Id == null || request.Id.Length == 0)
            {
                throw new BadRequestException("Id is required");
            }

            var Material = await unitOfWork.MaterialRepository.GetById(request.Id);
            if (Material == null)
            {
                throw new NotFoundException("Material with that {request.Id} does not exist");
            }
            var MaterialResponse = mapper.Map<MaterialResponseDTO>(Material);
            return MaterialResponse;
        }

    }
}
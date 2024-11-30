using AutoMapper;
using backend.Application.Contracts.Infrastructure.Repositories;
using backend.Application.Contracts.Persistence;
using backend.Application.DTO.Product.BrandDTO.DTO;
using backend.Application.Exceptions;
using backend.Application.Features.Product_Features.Brand.Requests.Commands;
using backend.Application.Response;
using MediatR;

namespace backend.Application.Features.Product_Features.Brand.Handlers.Commands
{
    public class DeleteBrandHandler(
        IUnitOfWork unitOfWork,
        IMapper mapper,
        IImageRepository imageRepository)
        : IRequestHandler<DeleteBrandRequest, BaseResponse<BrandResponseDTO>>
    {
        public async Task<BaseResponse<BrandResponseDTO>> Handle(
            DeleteBrandRequest request,
            CancellationToken cancellationToken
        )
        {
            if (request.Id.Length == 0)
                throw new BadRequestException("Invalid Brand Id");

            var brand = await unitOfWork.BrandRepository.GetById(request.Id);

            if (brand == null)
                throw new NotFoundException("Brand Not Found");

            await unitOfWork.BrandRepository.Delete(brand);

            return new BaseResponse<BrandResponseDTO>
            {
                Message = "Brand Deleted Successfully",
                Success = true,
                Data = mapper.Map<BrandResponseDTO>(brand)
            };
        }
    }
}

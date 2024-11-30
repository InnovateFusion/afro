using AutoMapper;
using backend.Application.Contracts.Persistence;
using backend.Application.DTO.Product.ProductDTO.DTO;
using backend.Application.Enum;
using backend.Application.Features.Product_Features.Product.Requests.Queries;
using MediatR;

namespace backend.Application.Features.Product_Features.Product.Handlers.Queries;

public class GetProductListToBeApprovedHandler(IUnitOfWork unitOfWork, IMapper mapper)
		: IRequestHandler<GetProductListToBeApproved, List<ProductResponseDTO>>
	{
		public async Task<List<ProductResponseDTO>> Handle(
			GetProductListToBeApproved request,
			CancellationToken cancellationToken
		)
		{
			var products = await unitOfWork.ProductRepository.GetAll(
				productApproval: (int) ProductApprovalStatus.Pending,
				skip: request.Skip,
				limit: request.Limit 
			);

			return  mapper.Map<List<ProductResponseDTO>>(products);
		}
	}


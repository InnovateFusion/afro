using backend.Application.DTO.Product.ProductDTO.DTO;
using MediatR;

namespace backend.Application.Features.Product_Features.Product.Requests.Queries;
    public class GetProductListToBeApproved (
    int skip = 0,
    int limit = 20)
        : IRequest<List<ProductResponseDTO>>
    {
    public int Skip { get; set; } = skip;
    public int Limit { get; set; } = limit;
}


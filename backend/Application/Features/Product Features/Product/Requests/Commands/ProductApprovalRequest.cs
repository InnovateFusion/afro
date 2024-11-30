using backend.Application.DTO.Product.ProductDTO.DTO;
using backend.Application.DTO.Shop.ShopDTO.DTO;
using backend.Application.Response;
using MediatR;

namespace backend.Application.Features.Product_Features.Product.Requests.Commands;

public class ProductApproval : IRequest<BaseResponse<ProductResponseDTO>>
{
    public required string ProductId { get; set; }
    public required int ProductApprovalStatusId { get; set; }
    
    public required string UserId { get; set; }
}

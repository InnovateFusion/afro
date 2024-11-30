using backend.Application.DTO.Shop.ShopDTO.DTO;
using backend.Application.Response;
using MediatR;

namespace backend.Application.Features.Shop_Features.Shop.Requests.Commands;

public class VerifyShopRequest : IRequest<BaseResponse<ShopResponseDTO>>
{
    public required string UserId { get; set; }
    public required ShopVerifyRequestDto ShopVerifyRequest { get; set; }
}
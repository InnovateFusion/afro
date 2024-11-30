using AutoMapper;
using backend.Application.Contracts.Persistence;
using backend.Application.Features.Shop_Features.Shop.Requests.Queries;
using MediatR;

namespace backend.Application.Features.Shop_Features.Shop.Handlers.Queries;

public class GetShopVerificationPendingHandler(IUnitOfWork unitOfWork, IMapper mapper): IRequestHandler<GetShopVerificationPendingRequest, List<Domain.Entities.Shop.Shop>>
{
    public async Task<List<Domain.Entities.Shop.Shop>> Handle(GetShopVerificationPendingRequest request, CancellationToken cancellationToken)
    {
        var shops = await unitOfWork.ShopRepository.GetVerificationReviewPendingShopsAsync(
            skip: request.Skip,
            limit: request.Limit
        );
        return shops.ToList();
    }
}
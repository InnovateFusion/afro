using backend.Application.Contracts.Persistence;
using backend.Application.DTO.Shop.ShopDTO.DTO;
using backend.Application.Features.Shop_Features.Shop.Requests.Queries;
using MediatR;

namespace backend.Application.Features.Shop_Features.Shop.Handlers.Queries;

public class ShopAnalyticHandler(IUnitOfWork unitOfWork): IRequestHandler<ShopAnalyticRequest, ShopAnalyticsDTO>
{
    public async Task<ShopAnalyticsDTO> Handle(ShopAnalyticRequest request, CancellationToken cancellationToken)
    {
        var totalProducts = await unitOfWork.ShopRepository.GetShopProductsCountAsync(request.ShopId);
        var totalReviews = await unitOfWork.ShopRepository.GetShopReviewsCountAsync(request.ShopId);
        var totalViews = await unitOfWork.ShopRepository.GetShopViewsCountAsync(request.ShopId);
        var totalFavorites = await unitOfWork.ShopRepository.GetShopFavoritesCountAsync(request.ShopId);
        var totalContacts = await unitOfWork.ShopRepository.GetShopProductsContactedCountAsync(request.ShopId);
        var totalFollowers = await unitOfWork.ShopRepository.GetShopFollowersCountAsync(request.ShopId);
        var oneStarReviews = await unitOfWork.ShopRepository.CountReviewStart(request.ShopId, 1);
        var twoStarReviews = await unitOfWork.ShopRepository.CountReviewStart(request.ShopId, 2);
        var threeStarReviews = await unitOfWork.ShopRepository.CountReviewStart(request.ShopId, 3);
        var fourStarReviews = await unitOfWork.ShopRepository.CountReviewStart(request.ShopId, 4);
        var fiveStarReviews = await unitOfWork.ShopRepository.CountReviewStart(request.ShopId, 5);
        
        return new ShopAnalyticsDTO
        {
            TotalProducts = totalProducts,
            TotalReviews = totalReviews,
            TotalViews = totalViews,
            TotalFavorites = totalFavorites,
            TotalContacts = totalContacts,
            TotalFollowers = totalFollowers,
            OneStarReviews = oneStarReviews,
            TwoStarReviews = twoStarReviews,
            ThreeStarReviews = threeStarReviews,
            FourStarReviews = fourStarReviews,
            FiveStarReviews = fiveStarReviews
        };
    }
}
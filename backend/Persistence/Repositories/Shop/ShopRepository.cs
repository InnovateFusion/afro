using backend.Application.Contracts.Persistence.Repositories.Shop;
using backend.Application.DTO.Shop.ShopDTO.DTO;
using backend.Application.Enum;
using backend.Application.Exceptions;
using backend.Domain.Entities.Common;
using backend.Domain.Entities.Shop;
using backend.Infrastructure.Repository;
using backend.Persistence.Configuration;
using backend.Persistence.Repositories.Common;
using Microsoft.EntityFrameworkCore;

namespace backend.Persistence.Repositories.Shop;

public class ShopRepository(StyleHubDBContext context)
    : GenericRepository<Domain.Entities.Shop.Shop>(context), IShopRepository
{
    public async Task<IReadOnlyList<Domain.Entities.Shop.Shop>> GetShopListAsync(string? search, List<string>? category,    List<WorkingHourQueryParamater>? workingHours,   double? radiusInKilometers, double? latitude, double? longitude,
        int? rating,     ShopVerificationStatus? verified, bool? active, string? ownerId, string? sortBy, string? sortOrder, int skip = 0, int limit = 10)
    {
        Console.WriteLine("Fetching shops");
        Console.WriteLine($"search: {search}, category: {category}, workingHours: {workingHours}, radiusInKilometers: {radiusInKilometers}, latitude: {latitude}, longitude: {longitude}, rating: {rating}, verified: {verified}, active: {active}, ownerId: {ownerId}, sortBy: {sortBy}, sortOrder: {sortOrder}, skip: {skip}, limit: {limit}");
        IQueryable<Domain.Entities.Shop.Shop> query = context.Shops
            .Where(p => !p.IsDeleted)
            .AsSplitQuery()
            .AsNoTracking();
        
        if (latitude != null && longitude != null && radiusInKilometers != null)
        {
            Console.WriteLine("Filtering by location");

            double earthRadius = 6371;

            double minLat =
                latitude.Value - (radiusInKilometers.Value / earthRadius) * (180 / Math.PI);
            double maxLat =
                latitude.Value + (radiusInKilometers.Value / earthRadius) * (180 / Math.PI);

            double deltaLon = Math.Asin(
                Math.Sin(radiusInKilometers.Value / earthRadius)
                / Math.Cos(latitude.Value * (Math.PI / 180))
            );
            double minLon = longitude.Value - (deltaLon * (180 / Math.PI));
            double maxLon = longitude.Value + (deltaLon * (180 / Math.PI));

            Console.WriteLine(
                $"minLat: {minLat}, maxLat: {maxLat}, minLon: {minLon}, maxLon: {maxLon}"
            );

            query = query.Where(p =>
                p.Latitude >= minLat
                && p.Latitude <= maxLat
                && p.Longitude >= minLon
                && p.Longitude <= maxLon
            );
        }
        
        if (!string.IsNullOrWhiteSpace(search))
        {
            query = query.Where(p =>
                EF.Functions.Like(p.Name, $"%{search}%")
                || EF.Functions.Like(p.Street, $"%{search}%")
                || EF.Functions.Like(p.SubLocality, $"%{search}%")
                || EF.Functions.Like(p.SubAdministrativeArea, $"%{search}%")
            );
        }
        
        if (category != null && category.Any())
        {
            foreach (var cat in category)
            {
                query = query.Where(p => EF.Functions.Like(p.Category, $"%{cat}%"));
            }
        }

        if (rating != null)
        {
            query = query.Where(p => p.ShopReviews.Average(r => r.Rating) >= rating);
        }
        
        if (workingHours != null)
        {
            foreach (var workingHour in workingHours)
            {
                query = query.Where(p =>
                    p.WorkingHours.Any(wh =>
                        wh.Day == workingHour.Day
                        && wh.Time == workingHour.Time
                    )
                );
            }
        }
        
        if (verified != null)
        {
            query = query.Where(p => p.VerificationStatus == (int)verified);
        }
        
        if (active != null)
        {
            query = query.Where(p => p.Active == active);
        }
        
        if (!string.IsNullOrWhiteSpace(ownerId))
        {
            query = query.Where(p => p.UserId == ownerId);
        }
        
        if (!string.IsNullOrWhiteSpace(sortBy))
        {
            query = sortBy switch
            {
                "name" => sortOrder == "asc"
                    ? query.OrderBy(p => p.CreatedAt)
                    : query.OrderByDescending(p => p.CreatedAt),
                "category" => sortOrder == "asc"
                    ? query.OrderBy(p => p.Category)
                    : query.OrderByDescending(p => p.Category),
                "subLocality" => sortOrder == "asc"
                    ? query.OrderBy(p => p.SubLocality)
                    : query.OrderByDescending(p => p.SubLocality),
                "subAdministrativeArea" => sortOrder == "asc"
                    ? query.OrderBy(p => p.SubAdministrativeArea)
                    : query.OrderByDescending(p => p.SubAdministrativeArea),
                "verified" => sortOrder == "asc"
                    ? query.OrderBy(p => p.VerificationStatus)
                    : query.OrderByDescending(p => p.VerificationStatus),
                "active" => sortOrder == "asc"
                    ? query.OrderBy(p => p.Active)
                    : query.OrderByDescending(p => p.Active),
                _ => query
            };
        }  else
        {
            query = query.OrderByDescending(p => p.ShopReviews.Average(r => r.Rating));
        }

        query = query.Skip(skip).Take(limit);
            
        var shops = await query.ToListAsync();
        
        return shops;
    }

    public async Task<Domain.Entities.Shop.Shop> GetShopByIdAsync(string id)
    {
        var shop = await context.Shops.FirstOrDefaultAsync(u => u.Id == id && !u.IsDeleted);
        return shop!;
    }

    public async Task<Domain.Entities.Shop.Shop> GetAllShopByIdAsync(string id)
    {
        var shop = await context.Shops.FirstOrDefaultAsync(u => u.Id == id);
        return shop!;
    }

    public async Task<bool> IsShopNameUniqueAsync(string name)
    {
        var shop = await context.Shops.FirstOrDefaultAsync(s => s.Name == name && !s.IsDeleted);
        return shop == null;
    }

    public async Task<bool> IsShopOwnerAsync(string shopId, string userId)
    {
        var shop = await context.Shops.FirstOrDefaultAsync(s => s.Id == shopId && !s.IsDeleted);
        if (shop == null)
        {
            throw new NotFoundException("Shop not found");
        }
        return shop.UserId == userId;
    }

    public async Task<bool> IsShopVerifiedAsync(string shopId)
    {
        var shop = await context.Shops.FirstOrDefaultAsync(s => s.Id == shopId && !s.IsDeleted);
        if (shop == null)
        {
            throw new NotFoundException("Shop not found");
        }
        return shop.VerificationStatus == (int)ShopVerificationStatus.Verified;
    }

    public async Task<bool> IsShopActiveAsync(string shopId)
    {
        var shop = await context.Shops.FirstOrDefaultAsync(s => s.Id == shopId && !s.IsDeleted);
        if (shop == null)
        {
            throw new NotFoundException("Shop not found");
        }
        return shop.Active;
    }

    public async Task<bool> IsUserShopOwnerAsync(string userId)
    {
        var shop = await context.Shops.FirstOrDefaultAsync(s => s.UserId == userId && !s.IsDeleted);
        return shop != null;
    }

    public async Task<bool> IsShopDeletedAsync(string shopId)
    {
        var shop = await context.Shops.FirstOrDefaultAsync(s => s.Id == shopId && s.IsDeleted);
        return shop != null;
    }

    public async Task<bool> ExistsAsync(string shopId)
    {
        var shop = await context.Shops.FirstOrDefaultAsync(s => s.Id == shopId && !s.IsDeleted);
        return shop != null;
    }

    public async Task<IReadOnlyList<Image>> GetShopImagesAsync(string shopId, int skip = 0, int limit = 10)
    {
        var shop = await context.Shops.FirstOrDefaultAsync(s => s.Id == shopId && !s.IsDeleted);
        if (shop == null)
        {
            throw new NotFoundException("Shop not found");
        }
    
        // First, select all images, then ensure they are distinct, then paginate
        var images = await context.Products
            .Include(p => p.ProductImages)
            .ThenInclude(pi => pi.Image)
            .Where(p => p.ShopId == shopId && !p.IsDeleted && p.ProductApprovalStatus == (int)ProductApprovalStatus.Approved)
            .SelectMany(p => p.ProductImages.Select(pi => pi.Image))
            .Distinct() // Ensure uniqueness before pagination
            .OrderBy(i => i.CreatedAt)
            .Where(i => !i.IsDeleted)
            .Skip(skip)
            .Take(limit)
            .ToListAsync();

        return images;
    }



    public async Task<IReadOnlyList<string>> GetShopVideosAsync(string shopId, int skip = 0, int limit = 10)
    {
        var shop = await context.Shops.FirstOrDefaultAsync(s => s.Id == shopId && !s.IsDeleted);
        if (shop == null)
        {
            throw new NotFoundException("Shop not found");
        }

        var videos = await context.Products
            .Where(p => p.ShopId == shopId && !string.IsNullOrEmpty(p.VideoUrl) && !p.IsDeleted && p.ProductApprovalStatus == (int)ProductApprovalStatus.Approved)
            .OrderByDescending(p => p.CreatedAt)
            .Skip(skip)
            .Take(limit)
            .Select(p => p.VideoUrl)
            .ToListAsync();

        var result = new List<string>();
        foreach (var video in videos)
        {
            if (!string.IsNullOrEmpty(video))
            {
                result.Add(video);
            }
        }

        return result;
    }

    public async Task<bool> FollowShopAsync(string shopId, string userId)
    {
        var shop = await context.Shops.FirstOrDefaultAsync(s => s.Id == shopId && !s.IsDeleted);
        if (shop == null)
        {
            throw new NotFoundException("Shop not found");
        }
    
        var follow = await context.ShopFollows
            .FirstOrDefaultAsync(f => f.ShopId == shopId && f.UserId == userId);

        if (follow != null)
        {
            context.ShopFollows.Remove(follow);
            await context.SaveChangesAsync();
            return false;
        } 

        var newFollow = new ShopFollow
        {
            ShopId = shopId,
            UserId = userId,
            FollowedAt = default,
        };
        await context.ShopFollows.AddAsync(newFollow);
        await context.SaveChangesAsync();
        return true;
    }

    public async  Task<IReadOnlyList<Domain.Entities.Shop.Shop>> GetShopFollowedUsersAsync(string userId,int skip = 0,
        int limit = 10)
    {
        var shops = await context.ShopFollows
            .Where(f => f.UserId == userId  && !f.Shop.IsDeleted)
            .Select(f => f.Shop)
            .Skip(skip)
            .Take(limit)
            .ToListAsync();
        return shops;
        
    }

    public async Task<IReadOnlyList<Domain.Entities.Product.Product>> GetShopProductsAsync(string userId, int skip = 0, int limit = 10)
    {
        var products = await context.ShopFollows
            .Where(f => f.UserId == userId && !f.Shop.IsDeleted )
            .SelectMany(f => f.Shop.Products)
            .Include(p => p.ProductImages)
            .ThenInclude(pi => pi.Image)
            .Include(p => p.Shop)
            .Include(p => p.ProductColors)
            .ThenInclude(pc => pc.Color)
            .Include(p => p.ProductMaterials)
            .ThenInclude(pm => pm.Material)
            .Include(p => p.ProductSizes)
            .ThenInclude(ps => ps.Size)
            .Include(p => p.ProductCategories)
            .ThenInclude(pc => pc.Category)
            .Include(p => p.ProductDesigns)
            .ThenInclude(pd => pd.Design)
            .Include(p => p.ProductBrands)
            .ThenInclude(pb => pb.Brand)
            .OrderByDescending(p => p.CreatedAt)
            .Where(f => !f.IsDeleted && f.Status == "active" && f.ProductApprovalStatus == (int) ProductApprovalStatus.Approved)
            .Skip(skip)
            .Take(limit)
            .AsSplitQuery()
            .ToListAsync();

        return products;
    }

    public async Task<int> GetShopFollowersCountAsync(string shopId)
    {
        var count = await context.ShopFollows
            .CountAsync(f => f.ShopId == shopId && !f.Shop.IsDeleted);
        return count;
    }

    public async Task<int> GetShopProductsCountAsync(string shopId)
    {
        var count = await context.Products
            .CountAsync(p => p.ShopId == shopId && !p.IsDeleted);
        return count;
    }

    public async Task<int> GetShopReviewsCountAsync(string shopId)
    {
        var count = await context.ShopReviews
            .CountAsync(r => r.ShopId == shopId && !r.Shop.IsDeleted && !r.IsDeleted);
        return count;
    }

    public async Task<int> GetShopFavoritesCountAsync(string shopId)
    {
        var count = await context.FavouriteProducts
            .CountAsync(f => f.Product.ShopId == shopId && !f.Product.IsDeleted && f.Product.ProductApprovalStatus == (int) ProductApprovalStatus.Approved);
        return count;
    }

    public async Task<int> GetShopViewsCountAsync(string shopId)
    {
        var count = await context.ProductViews
            .CountAsync(v => v.Product.ShopId == shopId && !v.Product.IsDeleted);
        return count;
    }

    public async Task<int> GetShopProductsContactedCountAsync(string shopId)
    {
        var count = await context.ContactedProducts
            .CountAsync(c => c.Product.ShopId == shopId && !c.Product.IsDeleted);
        return count;
    }

    public async Task<double> GetShopAverageRatingAsync(string shopId)
    {
        var ratings = await context.ShopReviews
            .Where(r => r.ShopId == shopId && !r.Shop.IsDeleted && !r.IsDeleted)
            .Select(r => (double?)r.Rating)
            .ToListAsync();
        
        if (ratings.Count == 0)
        {
            return 0.0;
        }

        return ratings.Average() ?? 0.0;
    
    }


    public async Task<bool> IsShopFollowedByUserAsync(string shopId, string userId)
    {
        var follow = await context.ShopFollows
            .FirstOrDefaultAsync(f => f.ShopId == shopId && f.UserId == userId && !f.Shop.IsDeleted);
        return follow != null;
    }

    public async Task<int> CountReviewStart(string shopId, int start)
    {
        var count = await context.ShopReviews
            .CountAsync(r => r.ShopId == shopId && r.Rating == start && !r.Shop.IsDeleted && !r.IsDeleted);
        return count;
    }

    public async Task<List<Domain.Entities.Shop.Shop>> GetVerificationReviewPendingShopsAsync(int skip = 0, int limit = 10)
    {
        var shops = await context.Shops
            .Where(s => s.VerificationStatus == (int)ShopVerificationStatus.Pending && !s.IsDeleted)
            .OrderByDescending(u => u.UpdatedAt)
            .Skip(skip)
            .Take(limit)
            .ToListAsync();
        return shops;
    }
    
}

using backend.Application.Contracts.Persistence.Repositories.Product;
using backend.Application.Enum;
using backend.Application.Exceptions;
using backend.Domain.Entities.Product;
using backend.Infrastructure.Repository;
using backend.Persistence.Configuration;
using Microsoft.EntityFrameworkCore;

namespace backend.Persistence.Repositories.Product
{
    public class FavouriteProductRepository(StyleHubDBContext context)
        : IFavouriteProductRepository
    {
        public async Task<IReadOnlyList<Domain.Entities.Product.Product>> GetAll(string userId, int skip = 0, int limit = 10)
        {
            var favouriteProductsQuery = context.FavouriteProducts
                .Where(fp => fp.UserId == userId && !fp.Product.IsDeleted && fp.Product.ProductApprovalStatus == (int) ProductApprovalStatus.Approved)
                .Skip(skip)
                .Take(limit)
                .Include(fp => fp.Product)
                .ThenInclude(p => p.ProductColors)
                .ThenInclude(pc => pc.Color)
                .Include(fp => fp.Product)
                .ThenInclude(p => p.ProductMaterials)
                .ThenInclude(pm => pm.Material)
                .Include(fp => fp.Product)
                .ThenInclude(p => p.ProductSizes)
                .ThenInclude(ps => ps.Size)
                .Include(fp => fp.Product)
                .ThenInclude(p => p.ProductCategories)
                .ThenInclude(pc => pc.Category)
                .Include(fp => fp.Product)
                .ThenInclude(p => p.ProductImages)
                .ThenInclude(pi => pi.Image)
                .Include(fp => fp.Product)
                .ThenInclude(p => p.ProductDesigns)
                .ThenInclude(pd => pd.Design)
                .Include(fp => fp.Product)
                .ThenInclude(p => p.ProductBrands)
                .ThenInclude(pb => pb.Brand)
                .Include(fp => fp.Product)
                .ThenInclude(p => p.Shop)
                .AsSplitQuery()
                .AsNoTracking();

            var favouriteProducts = await favouriteProductsQuery
                .Select(fp => fp.Product)
                .OrderByDescending(fp => fp.CreatedAt)
                .ToListAsync();

            return favouriteProducts;
        }
        
        public async Task<bool> IsFavourite(string userId, string productId)
        {
            return await context.FavouriteProducts
                .AnyAsync(fp => fp.UserId == userId && fp.ProductId == productId && !fp.Product.IsDeleted);
        }

        public async Task<int> Count(string productId)
        {
            return await context.FavouriteProducts
                .CountAsync(fp => fp.ProductId == productId && !fp.Product.IsDeleted);
        }
        
        public async Task<bool> AddOrRemove(string userId, string productId)
        {
            if (string.IsNullOrEmpty(userId) || string.IsNullOrEmpty(productId))
            {
                throw new NotFoundException("User or Product Not Found");
            }

            var favouriteProduct = await context.FavouriteProducts
                .Include(fp => fp.Product)
                .FirstOrDefaultAsync(fp => fp.UserId == userId && fp.ProductId == productId);

            if (favouriteProduct == null)
            {
                var productExists = await context.Products
                    .AnyAsync(p => p.Id == productId && !p.IsDeleted);

                if (!productExists)
                {
                    throw new NotFoundException("Product Not Found");
                }

                favouriteProduct = new FavouriteProduct
                {
                    UserId = userId,
                    ProductId = productId
                };
                await context.FavouriteProducts.AddAsync(favouriteProduct);
                await context.SaveChangesAsync();
                return true;
            }

            context.FavouriteProducts.Remove(favouriteProduct);
            await context.SaveChangesAsync();

            return false;
        }

    }
}
using backend.Application.Contracts.Persistence.Repositories.Common;
using backend.Domain.Entities.Common;
using backend.Domain.Entities.Product;
using backend.Persistence.Configuration;
using Microsoft.EntityFrameworkCore;

namespace backend.Persistence.Repositories.Common
{
	public class ImageRepository(StyleHubDBContext context) : IImageRepository
	{
		public async Task<Image> Add(Image entity)
		{
			var result = await context.Images.AddAsync(entity);
			await context.SaveChangesAsync();
			return result.Entity;
		}
		
		public async Task<Image> Update(Image entity)
		{
			var result = context.Images.Update(entity);
			await context.SaveChangesAsync();
			return result.Entity;
		}

		public async Task<Image> Delete(Image entity)
		{
			if (entity == null) throw new ArgumentNullException(nameof(entity));
			
			entity.IsDeleted = true;
			entity.DeletedAt = DateTime.UtcNow;
	
			context.Images.Update(entity);
			await context.SaveChangesAsync();
	
			return entity;
		}

		public async Task<IReadOnlyList<Image>> GetAll(string userId)
		{
			return await context.Images
				.Where(i => i.User.Id == userId && !i.IsDeleted)
				.ToListAsync();
		}

		public async Task<IReadOnlyList<Image>> GetByIds(List<string> ids)
		{
			return await context.Images
				.Where(i => ids.Contains(i.Id) && !i.IsDeleted)
				.ToListAsync();
		}

		public async Task<bool> AllImagesExist(List<string> ids)
		{
			var existingIds = await context.Images
				.Where(i => ids.Contains(i.Id) && !i.IsDeleted)
				.Select(i => i.Id)
				.ToListAsync();
			
			return ids.All(id => existingIds.Contains(id));
		}

		public async Task<Image> GetById(string id)
		{
			var result = await context.Images.FirstOrDefaultAsync(i => i.Id == id && !i.IsDeleted);
			return result!;
		}

		public async Task<bool> DeleteProductId(string productId)
		{
			var images = await context.ProductImages
				.Where(pi => pi.ProductId == productId)
				.ToListAsync();

			if (!images.Any()) return false;

			context.ProductImages.RemoveRange(images);
			await context.SaveChangesAsync();
			return true;
		}

		public async Task<ProductImage> AddProductImage(ProductImage entity)
		{
			var result = await context.ProductImages.AddAsync(entity);
			await context.SaveChangesAsync();
			return result.Entity;
		}

		public async Task<bool> DeleteAllShopImagesAsync(string shopId)
		{
			var images = await context.Images
				.Where(i => i.User.Id == shopId && !i.IsDeleted)
				.ToListAsync();

			if (!images.Any()) return false;

			foreach (var image in images)
			{
				image.IsDeleted = true;
				image.DeletedAt = DateTime.UtcNow;
			}

			await context.SaveChangesAsync();
			return true;
		}

	}
}

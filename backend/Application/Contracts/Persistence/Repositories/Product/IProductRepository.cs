using backend.Application.Contracts.Persistence.Repositories.Common;
using backend.Domain.Entities.Product;

namespace backend.Application.Contracts.Persistence.Repositories.Product
{
	public interface IProductRepository : IGenericRepository<Domain.Entities.Product.Product>
	{
		Task<IReadOnlyList<Domain.Entities.Product.Product>> GetAll(
			string search = "",
			IEnumerable<string>? colorIds = null,
			IEnumerable<string>? materialIds = null,
			IEnumerable<string>? sizeIds = null,
			IEnumerable<string>? categoryIds = null,
			IEnumerable<string>? brandIds = null,
			IEnumerable<string>? designIds = null,
			string? userId = null,
			string? shopId = null,
			bool? isNegotiable = null,
			bool? isNew = null, 
			bool? isDeliverable = null,
			int? availableQuantity = null,
			float? minPrice = null,
			float? maxPrice = null,
			string? status = null,
			bool? inStock = null,
			double? latitude = null,
			double? longitude = null,
			double? radiusInKilometers = null,
			string? sortBy = null,
			string? sortOrder = null,
			int? productApproval = null,
			int skip = 0,
			int limit = 10
		);

		Task<Domain.Entities.Product.Product> GetById(string id);
		
		Task<int> GetCountProductImages(string productId); 
		
		Task<bool> DeleteAllShopProductsAsync(string shopId);
		
	}
}

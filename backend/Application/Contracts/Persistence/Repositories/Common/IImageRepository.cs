using backend.Domain.Entities.Common;
using backend.Domain.Entities.Product;

namespace backend.Application.Contracts.Persistence.Repositories.Common
{
    public interface IImageRepository
    {
        Task<Image> Add(Image entity);
        Task<Image> Delete(Image entity);
        Task<Image> Update(Image entity);
        Task<IReadOnlyList<Image>> GetAll(string userId);
        Task<IReadOnlyList<Image>> GetByIds(List<string> ids);
        Task<bool> AllImagesExist(List<string> ids);
        Task<Image> GetById(string id);
        Task<bool> DeleteProductId(string productId);
        Task<ProductImage> AddProductImage(ProductImage entity);
        Task<bool> DeleteAllShopImagesAsync(string shopId);
    }
}

using backend.Application.Contracts.Persistence.Repositories.Product;
using backend.Domain.Entities.Product;
using backend.Persistence.Configuration;
using backend.Persistence.Repositories.Common;
using Microsoft.EntityFrameworkCore;

namespace backend.Persistence.Repositories.Product
{
    public class BrandRepository(StyleHubDBContext context) : GenericRepository<Brand>(context), IBrandRepository
    {
        public async Task<IReadOnlyList<Brand>> GetAll()
        {
            return await context.Brands.OrderBy(u => u.Name).ToListAsync();
        }

        public async Task<Brand> GetById(string id)
        {
            var user = await context.Brands.FirstOrDefaultAsync(u => u.Id == id);
            return user!;
        }

        public async Task<Brand> GetByName(string name)
        {
            var brand = await context.Brands.FirstOrDefaultAsync(u => u.Name == name);
            return brand!;
        }
        
        public async Task<IReadOnlyList<Brand>> GetByIds(List<string> ids)
        {
            return await context.Brands.Where(u => ids.Contains(u.Id)).OrderBy(
                u => u.Name).ToListAsync();
               
        }

    }
}
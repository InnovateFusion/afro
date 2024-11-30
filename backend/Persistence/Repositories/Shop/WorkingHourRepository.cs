using backend.Application.Contracts.Persistence.Repositories.Shop;
using backend.Domain.Entities.Shop;
using backend.Persistence.Configuration;
using backend.Persistence.Repositories.Common;
using Microsoft.EntityFrameworkCore;

namespace backend.Persistence.Repositories.Shop;

public class WorkingHourRepository(StyleHubDBContext context)
    : GenericRepository<WorkingHour>(context), IWorkingHourRepository
{
    public async Task<WorkingHour> GetWorkingHourByShopIdAsync(string shopId)
    {
        var workingHour = await context.WorkingHours
            .FirstOrDefaultAsync(wh => wh.ShopId == shopId );
        return workingHour!;
    }

    public async Task<WorkingHour> GetWorkingHourByIdAsync(string id)
    {
        var workingHour = await context.WorkingHours
            .FirstOrDefaultAsync(wh => wh.Id == id );
        return workingHour!;
    }

    public async Task<IReadOnlyList<WorkingHour>> GetWorkingHoursByShopIdAsync(string shopId)
    {
        var shop = await context.Shops
            .FirstOrDefaultAsync(s => s.Id == shopId && !s.IsDeleted);
        if (shop == null)
        {
            return new List<WorkingHour>();
        }
        var workingHours = await context.WorkingHours
            .Where(wh => wh.ShopId == shopId)
            .ToListAsync();
        return workingHours;
    }

    public async Task<bool> IsWorkingHourDayTimeExistsAsync(string shopId, string day)
    {
        var shop = await context.Shops
            .FirstOrDefaultAsync(s => s.Id == shopId && !s.IsDeleted);
        if (shop == null)
        {
            return false;
        }
        var workingHour = await context.WorkingHours
            .FirstOrDefaultAsync(wh => wh.ShopId == shopId && wh.Day == day);
        return workingHour != null;
    }

    public async Task<bool> IsExistingWorkingHourAsync(string id)
    {
        var workingHour = await context.WorkingHours
            .FirstOrDefaultAsync(wh => wh.Id == id);
        return workingHour != null;
    }

    public async Task<bool> DeleteRangeAsync(IReadOnlyList<WorkingHour> workingHours)
    {
        context.WorkingHours.RemoveRange(workingHours);
        var deleted = await context.SaveChangesAsync();
        return deleted > 0;
    }
}
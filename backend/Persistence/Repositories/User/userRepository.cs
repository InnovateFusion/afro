using backend.Application.Contracts.Persistence.Repositories.User;
using backend.Persistence.Configuration;
using backend.Persistence.Repositories.Common;
using Microsoft.EntityFrameworkCore;

namespace backend.Persistence.Repositories.User
{
    public class UserRepository(StyleHubDBContext context)
        : GenericRepository<Domain.Entities.User.User>(context), IUserRepository
    {
        public async Task<Domain.Entities.User.User> GetById(string id)
        {
            var user = await context
                .Users.Include(u => u.Role)
                .FirstOrDefaultAsync(u => u.Id == id && !u.IsDeleted);

            return user!;
        }

        public async Task<Domain.Entities.User.User> GetByPhoneNumber(string phoneNumber)
        {
            var user = await context
                .Users.Include(u => u.Role)
                .FirstOrDefaultAsync(u => u.PhoneNumber == phoneNumber && !u.IsDeleted);
            return user!;
        }

        public async Task<Domain.Entities.User.User> GetByEmail(string email)
        {
            var user = await context
                .Users.Include(u => u.Role)
                .FirstOrDefaultAsync(u => u.Email == email && !u.IsDeleted);
            return user!;
        }

        public async Task<bool> IsPhoneNumberRegistered(string phoneNumber)
        {
            return await context
                .Users.Include(u => u.Role)
                .AnyAsync(u => u.PhoneNumber == phoneNumber && !u.IsDeleted);
        }

        public async Task<IReadOnlyList<Domain.Entities.User.User>> GetUserByRole(string id, int skip,
            int limit)
        {
            var query = context.Users.Include(u => u.Role).AsQueryable();
            query = query.Where(u => u.Role.Id == id);
            query = query.Skip(skip).Take(limit);

            return await query.ToListAsync();
        }

        public async Task<IReadOnlyList<Domain.Entities.User.User>> GetAll(
            int skip,
            int limit,
            string search,
            string sortBy,
            string orderBy,
            bool isVerified
        )
        {
            var query = context.Users.Include(u => u.Role).AsQueryable();

            if (!string.IsNullOrEmpty(search))
            {
                query = query.Where(u =>
                    (u.FirstName != null && u.FirstName.Contains(search))
                    || (u.LastName != null && u.LastName.Contains(search))
                    || (u.Email != null && u.Email.Contains(search))
                );
            }

            if (isVerified)
            {
                query = query.Where(u => u.IsEmailVerified && !u.IsDeleted);
            }

            query = sortBy switch
            {
                "firstName"
                    => orderBy == "asc"
                        ? query.OrderBy(u => u.FirstName)
                        : query.OrderByDescending(u => u.FirstName),
                "lastName"
                    => orderBy == "asc"
                        ? query.OrderBy(u => u.LastName)
                        : query.OrderByDescending(u => u.LastName),
                "phoneNumber"
                    => orderBy == "asc"
                        ? query.OrderBy(u => u.PhoneNumber)
                        : query.OrderByDescending(u => u.PhoneNumber),
                "email"
                    => orderBy == "asc"
                        ? query.OrderBy(u => u.Email)
                        : query.OrderByDescending(u => u.Email),
                _ => query
            };

            query = query.Skip(skip).Take(limit);

            return await query.ToListAsync();
        }
    }
}

using EduLab_Domain.Entities;
using EduLab_Domain.RepoInterfaces;
using EduLab_Infrastructure.DB;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;

namespace EduLab_Infrastructure.Persistence.Repositories
{
    public class WishlistRepository : Repository<Wishlist>, IWishlistRepository
    {
        private readonly ApplicationDbContext _db;
        private readonly ILogger<WishlistRepository> _logger;
        public WishlistRepository(ApplicationDbContext db, ILogger<WishlistRepository> logger)
            : base(db, logger)
        {
            _db = db;
            _logger = logger;
        }

        public async Task<List<Wishlist>> GetUserWishlistAsync(string userId, CancellationToken cancellationToken = default)
        {
            return await _db.WishlistItems
                .Where(x => x.UserId == userId)
                .Include(x => x.Course)
                    .ThenInclude(c => c.Instructor)
                .Include(x => x.Course)
                    .ThenInclude(c => c.Category)
                .OrderByDescending(x => x.AddedAt)
                .ToListAsync(cancellationToken);
        }

        public async Task<Wishlist> GetWishlistItemAsync(string userId, int courseId, CancellationToken cancellationToken = default)
        {
            return await _db.WishlistItems
                .FirstOrDefaultAsync(x => x.UserId == userId && x.CourseId == courseId, cancellationToken);
        }

        public async Task<bool> IsCourseInWishlistAsync(string userId, int courseId, CancellationToken cancellationToken = default)
        {
            return await _db.WishlistItems
                .AnyAsync(x => x.UserId == userId && x.CourseId == courseId, cancellationToken);
        }

        public async Task<int> GetWishlistCountAsync(string userId, CancellationToken cancellationToken = default)
        {
            return await _db.WishlistItems
                .Where(x => x.UserId == userId)
                .CountAsync(cancellationToken);
        }
    }
}
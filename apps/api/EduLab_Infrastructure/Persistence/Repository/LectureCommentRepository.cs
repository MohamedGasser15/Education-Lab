using EduLab_Domain.Entities;
using EduLab_Domain.IRepository;
using EduLab_Infrastructure.DB;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;

namespace EduLab_Infrastructure.Persistence.Repositories
{
    public class LectureCommentRepository : Repository<LectureComment>, ILectureCommentRepository
    {
        private readonly ApplicationDbContext _db;

        public LectureCommentRepository(ApplicationDbContext db, ILogger<Repository<LectureComment>> logger)
            : base(db, logger)
        {
            _db = db;
        }

        public async Task<List<LectureComment>> GetLectureCommentsAsync(int lectureId, CancellationToken cancellationToken = default)
        {
            return await _db.Set<LectureComment>()
                .Where(c => c.LectureId == lectureId && c.ParentCommentId == null)
                .Include(c => c.User)
                .Include(c => c.Replies).ThenInclude(r => r.User)
                .OrderByDescending(c => c.CreatedAt)
                .ToListAsync(cancellationToken);
        }

        public async Task<bool> HasUserCommentedOnLectureAsync(string userId, int lectureId, CancellationToken cancellationToken = default)
        {
            return await _db.Set<LectureComment>()
                .AnyAsync(c => c.UserId == userId && c.LectureId == lectureId, cancellationToken);
        }
    }
}

using EduLab_Domain.Entities;
using EduLab_Domain.IRepository;
using EduLab_Infrastructure.DB;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;

namespace EduLab_Infrastructure.Persistence.Repositories
{
    /// <summary>
    /// Repository implementation for lecture comment operations
    /// </summary>
    public class LectureCommentRepository : Repository<LectureComment>, ILectureCommentRepository
    {
        private readonly ApplicationDbContext _db;

        /// <summary>
        /// Initializes a new instance of the LectureCommentRepository class
        /// </summary>
        /// <param name="db">Application database context</param>
        /// <param name="logger">Logger instance</param>
        public LectureCommentRepository(ApplicationDbContext db, ILogger<Repository<LectureComment>> logger)
            : base(db, logger)
        {
            _db = db;
        }

        /// <summary>
        /// Gets the top-level comments for a lecture, including their replies and authors
        /// </summary>
        /// <param name="lectureId">The lecture identifier</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>List of comments ordered by creation date descending</returns>
        public async Task<List<LectureComment>> GetLectureCommentsAsync(int lectureId, CancellationToken cancellationToken = default)
        {
            return await _db.Set<LectureComment>()
                .Where(c => c.LectureId == lectureId && c.ParentCommentId == null)
                .Include(c => c.User)
                .Include(c => c.Replies).ThenInclude(r => r.User)
                .OrderByDescending(c => c.CreatedAt)
                .ToListAsync(cancellationToken);
        }

        /// <summary>
        /// Checks whether a user has already commented on a lecture
        /// </summary>
        /// <param name="userId">The user identifier</param>
        /// <param name="lectureId">The lecture identifier</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>True if the user has commented; otherwise false</returns>
        public async Task<bool> HasUserCommentedOnLectureAsync(string userId, int lectureId, CancellationToken cancellationToken = default)
        {
            return await _db.Set<LectureComment>()
                .AnyAsync(c => c.UserId == userId && c.LectureId == lectureId, cancellationToken);
        }
    }
}

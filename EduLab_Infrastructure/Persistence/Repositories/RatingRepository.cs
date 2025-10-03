// EduLab_Infrastructure/Persistence/Repositories/RatingRepository.cs
using EduLab_Domain.Entities;
using EduLab_Domain.RepoInterfaces;
using EduLab_Infrastructure.DB;
using EduLab_Shared.DTOs.Rating;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using System.Linq.Expressions;

namespace EduLab_Infrastructure.Persistence.Repositories
{
    public class RatingRepository : Repository<Rating>, IRatingRepository
    {
        private readonly ILogger<RatingRepository> _logger;
        private readonly ApplicationDbContext _db;
        public RatingRepository(ApplicationDbContext db, ILogger<RatingRepository> logger)
            : base(db, logger)
        {
            _db = db;
            _logger = logger;
        }

        public async Task<Rating?> GetUserRatingForCourseAsync(string userId, int courseId)
        {
            return await _db.Ratings
                .Include(r => r.User)
                .FirstOrDefaultAsync(r => r.UserId == userId && r.CourseId == courseId);
        }

        public async Task<List<Rating>> GetCourseRatingsAsync(int courseId,
            Expression<Func<Rating, bool>>? filter = null,
            string? includeProperties = null,
            bool isTracking = false,
            Func<IQueryable<Rating>, IOrderedQueryable<Rating>>? orderBy = null,
            int? take = null)
        {
            Expression<Func<Rating, bool>> courseFilter = r => r.CourseId == courseId;

            if (filter != null)
            {
                var parameter = Expression.Parameter(typeof(Rating), "r");
                var combined = Expression.AndAlso(
                    Expression.Invoke(courseFilter, parameter),
                    Expression.Invoke(filter, parameter)
                );
                var lambda = Expression.Lambda<Func<Rating, bool>>(combined, parameter);
                filter = lambda;
            }
            else
            {
                filter = courseFilter;
            }

            return await GetAllAsync(filter, includeProperties, isTracking, orderBy, take);
        }
        public async Task<CourseRatingSummaryDto> GetCourseRatingSummaryAsync(int courseId, CancellationToken cancellationToken = default)
        {
            var ratings = await _db.Ratings
                .Where(r => r.CourseId == courseId)
                .ToListAsync(cancellationToken);

            if (!ratings.Any()) return null;

            return new CourseRatingSummaryDto
            {
                AverageRating = ratings.Average(r => r.Value),
                TotalRatings = ratings.Count,
                RatingDistribution = ratings
                    .GroupBy(r => r.Value)
                    .ToDictionary(g => g.Key, g => g.Count())
            };
        }
        public async Task<CourseRatingSummaryDto> GetCourseRatingSummaryAsync(int courseId)
        {
            var ratings = await _db.Ratings
                .Where(r => r.CourseId == courseId)
                .ToListAsync();

            if (!ratings.Any())
            {
                return new CourseRatingSummaryDto
                {
                    CourseId = courseId,
                    AverageRating = 0,
                    TotalRatings = 0,
                    RatingDistribution = new Dictionary<int, int>
                    {
                        {1, 0}, {2, 0}, {3, 0}, {4, 0}, {5, 0}
                    }
                };
            }

            var distribution = Enumerable.Range(1, 5)
                .ToDictionary(i => i, i => ratings.Count(r => r.Value == i));

            return new CourseRatingSummaryDto
            {
                CourseId = courseId,
                AverageRating = Math.Round(ratings.Average(r => r.Value), 1),
                TotalRatings = ratings.Count,
                RatingDistribution = distribution
            };
        }

        public async Task<bool> HasUserRatedCourseAsync(string userId, int courseId)
        {
            return await _db.Ratings
                .AnyAsync(r => r.UserId == userId && r.CourseId == courseId);
        }
    }
}
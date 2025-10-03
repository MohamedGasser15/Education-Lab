// EduLab_Domain/RepoInterfaces/IRatingRepository.cs
using EduLab_Domain.Entities;
using EduLab_Shared.DTOs.Rating;
using System.Linq.Expressions;

namespace EduLab_Domain.RepoInterfaces
{
    public interface IRatingRepository : IRepository<Rating>
    {
        Task<Rating?> GetUserRatingForCourseAsync(string userId, int courseId);
        Task<List<Rating>> GetCourseRatingsAsync(int courseId,
            Expression<Func<Rating, bool>>? filter = null,
            string? includeProperties = null,
            bool isTracking = false,
            Func<IQueryable<Rating>, IOrderedQueryable<Rating>>? orderBy = null,
            int? take = null);

        Task<CourseRatingSummaryDto> GetCourseRatingSummaryAsync(int courseId);
        Task<bool> HasUserRatedCourseAsync(string userId, int courseId);
        Task<CourseRatingSummaryDto> GetCourseRatingSummaryAsync(int courseId, CancellationToken cancellationToken = default);
    }
}
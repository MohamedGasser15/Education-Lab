// EduLab_Domain/RepoInterfaces/IRatingRepository.cs
using EduLab_Domain.Entities;
using EduLab_Shared.DTOs.Rating;
using System.Linq.Expressions;

namespace EduLab_Domain.RepoInterfaces
{
    #region Rating Repository Interface
    /// <summary>
    /// Interface for Rating repository operations
    /// Extends the base IRepository interface with rating-specific methods
    /// </summary>
    public interface IRatingRepository : IRepository<Rating>
    {
        #region Rating-specific Operations
        /// <summary>
        /// Retrieves a user's rating for a specific course
        /// </summary>
        /// <param name="userId">User identifier</param>
        /// <param name="courseId">Course identifier</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>User's rating for the course or null if not found</returns>
        Task<Rating?> GetUserRatingForCourseAsync(string userId, int courseId, CancellationToken cancellationToken = default);

        /// <summary>
        /// Retrieves all ratings for a specific course with optional filtering and ordering
        /// </summary>
        /// <param name="courseId">Course identifier</param>
        /// <param name="filter">Additional filter to apply on ratings</param>
        /// <param name="includeProperties">Related properties to include in the query</param>
        /// <param name="isTracking">Whether to enable entity tracking</param>
        /// <param name="orderBy">Ordering function to sort the results</param>
        /// <param name="take">Number of records to take (limit results)</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>List of ratings for the specified course</returns>
        Task<List<Rating>> GetCourseRatingsAsync(
            int courseId,
            Expression<Func<Rating, bool>>? filter = null,
            string? includeProperties = null,
            bool isTracking = false,
            Func<IQueryable<Rating>, IOrderedQueryable<Rating>>? orderBy = null,
            int? take = null,
            CancellationToken cancellationToken = default);

        /// <summary>
        /// Retrieves rating summary for a specific course including average rating and distribution
        /// </summary>
        /// <param name="courseId">Course identifier</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>Course rating summary with statistics</returns>
        Task<CourseRatingSummaryDto> GetCourseRatingSummaryAsync(int courseId, CancellationToken cancellationToken = default);

        /// <summary>
        /// Checks if a user has already rated a specific course
        /// </summary>
        /// <param name="userId">User identifier</param>
        /// <param name="courseId">Course identifier</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>True if user has rated the course, otherwise false</returns>
        Task<bool> HasUserRatedCourseAsync(string userId, int courseId, CancellationToken cancellationToken = default);
        #endregion
    }
    #endregion
}
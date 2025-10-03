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
    #region Rating Repository Implementation
    /// <summary>
    /// Repository implementation for handling Rating entity operations
    /// Provides specialized methods for rating-related data access
    /// </summary>
    public class RatingRepository : Repository<Rating>, IRatingRepository
    {
        #region Fields
        private readonly ILogger<RatingRepository> _logger;
        private readonly ApplicationDbContext _db;
        #endregion

        #region Constructor
        /// <summary>
        /// Initializes a new instance of the RatingRepository class
        /// </summary>
        /// <param name="db">Application database context</param>
        /// <param name="logger">Logger instance for logging operations</param>
        /// <exception cref="ArgumentNullException">Thrown when db or logger is null</exception>
        public RatingRepository(ApplicationDbContext db, ILogger<RatingRepository> logger)
            : base(db, logger)
        {
            _db = db ?? throw new ArgumentNullException(nameof(db));
            _logger = logger ?? throw new ArgumentNullException(nameof(logger));
        }
        #endregion

        #region Public Methods
        /// <summary>
        /// Retrieves a user's rating for a specific course
        /// </summary>
        /// <param name="userId">User identifier</param>
        /// <param name="courseId">Course identifier</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>User's rating for the course or null if not found</returns>
        public async Task<Rating?> GetUserRatingForCourseAsync(string userId, int courseId, CancellationToken cancellationToken = default)
        {
            const string operationName = "GetUserRatingForCourseAsync";

            try
            {
                _logger.LogDebug("Starting {OperationName} for User: {UserId}, Course: {CourseId}",
                    operationName, userId, courseId);

                var rating = await _db.Ratings
                    .Include(r => r.User)
                    .FirstOrDefaultAsync(r => r.UserId == userId && r.CourseId == courseId, cancellationToken);

                if (rating == null)
                {
                    _logger.LogDebug("No rating found for User: {UserId}, Course: {CourseId}", userId, courseId);
                }
                else
                {
                    _logger.LogDebug("Rating found with ID: {RatingId} for User: {UserId}, Course: {CourseId}",
                        rating.Id, userId, courseId);
                }

                return rating;
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {OperationName} was cancelled for User: {UserId}, Course: {CourseId}",
                    operationName, userId, courseId);
                throw;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred in {OperationName} for User: {UserId}, Course: {CourseId}",
                    operationName, userId, courseId);
                throw;
            }
        }

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
        public async Task<List<Rating>> GetCourseRatingsAsync(
            int courseId,
            Expression<Func<Rating, bool>>? filter = null,
            string? includeProperties = null,
            bool isTracking = false,
            Func<IQueryable<Rating>, IOrderedQueryable<Rating>>? orderBy = null,
            int? take = null,
            CancellationToken cancellationToken = default)
        {
            const string operationName = "GetCourseRatingsAsync";

            try
            {
                _logger.LogDebug("Starting {OperationName} for Course: {CourseId}", operationName, courseId);

                // Create base filter for course
                Expression<Func<Rating, bool>> courseFilter = r => r.CourseId == courseId;

                // Combine filters if additional filter is provided
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

                var ratings = await GetAllAsync(filter, includeProperties, isTracking, orderBy, take, cancellationToken);

                _logger.LogInformation("Successfully retrieved {Count} ratings for Course: {CourseId} in {OperationName}",
                    ratings.Count, courseId, operationName);

                return ratings;
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {OperationName} was cancelled for Course: {CourseId}",
                    operationName, courseId);
                throw;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred in {OperationName} for Course: {CourseId}",
                    operationName, courseId);
                throw;
            }
        }

        /// <summary>
        /// Retrieves rating summary for a specific course including average rating and distribution
        /// </summary>
        /// <param name="courseId">Course identifier</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>Course rating summary with statistics</returns>
        public async Task<CourseRatingSummaryDto> GetCourseRatingSummaryAsync(int courseId, CancellationToken cancellationToken = default)
        {
            const string operationName = "GetCourseRatingSummaryAsync";

            try
            {
                _logger.LogDebug("Starting {OperationName} for Course: {CourseId}", operationName, courseId);

                var ratings = await _db.Ratings
                    .Where(r => r.CourseId == courseId)
                    .ToListAsync(cancellationToken);

                if (!ratings.Any())
                {
                    _logger.LogDebug("No ratings found for Course: {CourseId}", courseId);

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

                // Calculate rating distribution for all possible values (1-5)
                var distribution = Enumerable.Range(1, 5)
                    .ToDictionary(i => i, i => ratings.Count(r => r.Value == i));

                var summary = new CourseRatingSummaryDto
                {
                    CourseId = courseId,
                    AverageRating = Math.Round(ratings.Average(r => r.Value), 1),
                    TotalRatings = ratings.Count,
                    RatingDistribution = distribution
                };

                _logger.LogInformation(
                    "Successfully generated rating summary for Course: {CourseId}. Average: {AverageRating}, Total: {TotalRatings}",
                    courseId, summary.AverageRating, summary.TotalRatings);

                return summary;
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {OperationName} was cancelled for Course: {CourseId}",
                    operationName, courseId);
                throw;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred in {OperationName} for Course: {CourseId}",
                    operationName, courseId);
                throw;
            }
        }

        /// <summary>
        /// Checks if a user has already rated a specific course
        /// </summary>
        /// <param name="userId">User identifier</param>
        /// <param name="courseId">Course identifier</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>True if user has rated the course, otherwise false</returns>
        public async Task<bool> HasUserRatedCourseAsync(string userId, int courseId, CancellationToken cancellationToken = default)
        {
            const string operationName = "HasUserRatedCourseAsync";

            try
            {
                _logger.LogDebug("Starting {OperationName} for User: {UserId}, Course: {CourseId}",
                    operationName, userId, courseId);

                var hasRated = await _db.Ratings
                    .AnyAsync(r => r.UserId == userId && r.CourseId == courseId, cancellationToken);

                _logger.LogDebug("User {UserId} has rated Course {CourseId}: {HasRated}",
                    userId, courseId, hasRated);

                return hasRated;
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {OperationName} was cancelled for User: {UserId}, Course: {CourseId}",
                    operationName, userId, courseId);
                throw;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred in {OperationName} for User: {UserId}, Course: {CourseId}",
                    operationName, userId, courseId);
                throw;
            }
        }
        #endregion
    }
    #endregion
}
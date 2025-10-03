// EduLab_Application/ServiceInterfaces/IRatingService.cs
using EduLab_Shared.DTOs.Rating;

namespace EduLab_Application.ServiceInterfaces
{
    #region Rating Service Interface
    /// <summary>
    /// Interface for rating service operations
    /// Defines business logic methods for rating management
    /// </summary>
    public interface IRatingService
    {
        #region Rating Operations
        /// <summary>
        /// Adds a new rating for a course with validation
        /// </summary>
        /// <param name="userId">User identifier adding the rating</param>
        /// <param name="createRatingDto">Rating data to create</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>Created rating DTO</returns>
        Task<RatingDto> AddRatingAsync(string userId, CreateRatingDto createRatingDto, CancellationToken cancellationToken = default);

        /// <summary>
        /// Updates an existing rating
        /// </summary>
        /// <param name="userId">User identifier updating the rating</param>
        /// <param name="ratingId">Rating identifier to update</param>
        /// <param name="updateRatingDto">Updated rating data</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>Updated rating DTO</returns>
        Task<RatingDto> UpdateRatingAsync(string userId, int ratingId, UpdateRatingDto updateRatingDto, CancellationToken cancellationToken = default);

        /// <summary>
        /// Deletes a user's rating
        /// </summary>
        /// <param name="userId">User identifier deleting the rating</param>
        /// <param name="ratingId">Rating identifier to delete</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>True if deletion was successful</returns>
        Task<bool> DeleteRatingAsync(string userId, int ratingId, CancellationToken cancellationToken = default);

        /// <summary>
        /// Retrieves a user's rating for a specific course
        /// </summary>
        /// <param name="userId">User identifier</param>
        /// <param name="courseId">Course identifier</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>User's rating DTO or null if not found</returns>
        Task<RatingDto?> GetUserRatingForCourseAsync(string userId, int courseId, CancellationToken cancellationToken = default);

        /// <summary>
        /// Retrieves all ratings for a specific course with pagination
        /// </summary>
        /// <param name="courseId">Course identifier</param>
        /// <param name="page">Page number for pagination (default: 1)</param>
        /// <param name="pageSize">Number of items per page (default: 10)</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>List of rating DTOs for the specified course</returns>
        Task<List<RatingDto>> GetCourseRatingsAsync(int courseId, int page = 1, int pageSize = 10, CancellationToken cancellationToken = default);

        /// <summary>
        /// Retrieves rating summary for a specific course
        /// </summary>
        /// <param name="courseId">Course identifier</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>Course rating summary with statistics</returns>
        Task<CourseRatingSummaryDto> GetCourseRatingSummaryAsync(int courseId, CancellationToken cancellationToken = default);

        /// <summary>
        /// Checks if a user can rate a specific course
        /// </summary>
        /// <param name="userId">User identifier</param>
        /// <param name="courseId">Course identifier</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>Response indicating rating eligibility and status</returns>
        Task<CanRateResponseDto> CanUserRateCourseAsync(string userId, int courseId, CancellationToken cancellationToken = default);
        #endregion
    }
    #endregion
}
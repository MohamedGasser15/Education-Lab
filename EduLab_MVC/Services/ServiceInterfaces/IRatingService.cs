// EduLab_MVC/Services/ServiceInterfaces/IRatingService.cs
using EduLab_MVC.Models.DTOs.Rating;

namespace EduLab_MVC.Services.ServiceInterfaces
{
    #region MVC Rating Service Interface
    /// <summary>
    /// Interface for MVC rating service operations
    /// Defines methods for rating management in the presentation layer
    /// </summary>
    public interface IRatingService
    {
        #region Rating Operations
        /// <summary>
        /// Retrieves all ratings for a specific course with pagination
        /// </summary>
        /// <param name="courseId">Course identifier</param>
        /// <param name="page">Page number for pagination (default: 1)</param>
        /// <param name="pageSize">Number of items per page (default: 10)</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>List of ratings for the specified course</returns>
        Task<List<RatingDto>> GetCourseRatingsAsync(int courseId, int page = 1, int pageSize = 10, CancellationToken cancellationToken = default);

        /// <summary>
        /// Retrieves rating summary for a specific course
        /// </summary>
        /// <param name="courseId">Course identifier</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>Course rating summary with statistics</returns>
        Task<CourseRatingSummaryDto> GetCourseRatingSummaryAsync(int courseId, CancellationToken cancellationToken = default);

        /// <summary>
        /// Retrieves the current user's rating for a specific course
        /// </summary>
        /// <param name="courseId">Course identifier</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>User's rating for the course or null if not found</returns>
        Task<RatingDto> GetMyRatingForCourseAsync(int courseId, CancellationToken cancellationToken = default);

        /// <summary>
        /// Adds a new rating for a course
        /// </summary>
        /// <param name="createRatingDto">Rating data to create</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>Created rating DTO</returns>
        Task<RatingDto> AddRatingAsync(CreateRatingDto createRatingDto, CancellationToken cancellationToken = default);

        /// <summary>
        /// Updates an existing rating
        /// </summary>
        /// <param name="ratingId">Rating identifier to update</param>
        /// <param name="updateRatingDto">Updated rating data</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>Updated rating DTO</returns>
        Task<RatingDto> UpdateRatingAsync(int ratingId, UpdateRatingDto updateRatingDto, CancellationToken cancellationToken = default);

        /// <summary>
        /// Deletes a user's rating
        /// </summary>
        /// <param name="ratingId">Rating identifier to delete</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>True if deletion was successful</returns>
        Task<bool> DeleteRatingAsync(int ratingId, CancellationToken cancellationToken = default);

        /// <summary>
        /// Checks if a user can rate a specific course
        /// </summary>
        /// <param name="courseId">Course identifier</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>Rating eligibility information</returns>
        Task<CanRateResponseDto> CanUserRateCourseAsync(int courseId, CancellationToken cancellationToken = default);
        #endregion
    }
    #endregion
}
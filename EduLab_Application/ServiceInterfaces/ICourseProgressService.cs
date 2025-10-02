using EduLab_Shared.DTOs.CourseProgress;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;

namespace EduLab_Application.ServiceInterfaces
{
    /// <summary>
    /// Service interface for managing course progress operations
    /// Defines contract for course progress business logic
    /// </summary>
    public interface ICourseProgressService
    {
        #region Progress Retrieval Operations

        /// <summary>
        /// Retrieves a specific course progress record by enrollment ID and lecture ID
        /// </summary>
        /// <param name="enrollmentId">The enrollment identifier</param>
        /// <param name="lectureId">The lecture identifier</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>
        /// A task that represents the asynchronous operation
        /// The task result contains the course progress DTO or null if not found
        /// </returns>
        Task<CourseProgressDto> GetProgressAsync(int enrollmentId, int lectureId, CancellationToken cancellationToken = default);

        /// <summary>
        /// Retrieves all progress records for a specific enrollment
        /// </summary>
        /// <param name="enrollmentId">The enrollment identifier</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>
        /// A task that represents the asynchronous operation
        /// The task result contains a list of course progress DTOs
        /// </returns>
        Task<List<CourseProgressDto>> GetProgressByEnrollmentAsync(int enrollmentId, CancellationToken cancellationToken = default);

        #endregion

        #region Progress Update Operations

        /// <summary>
        /// Marks a specific lecture as completed for an enrollment
        /// </summary>
        /// <param name="enrollmentId">The enrollment identifier</param>
        /// <param name="lectureId">The lecture identifier</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>
        /// A task that represents the asynchronous operation
        /// The task result contains the updated course progress DTO
        /// </returns>
        Task<CourseProgressDto> MarkLectureAsCompletedAsync(int enrollmentId, int lectureId, CancellationToken cancellationToken = default);

        /// <summary>
        /// Marks a specific lecture as incomplete for an enrollment
        /// </summary>
        /// <param name="enrollmentId">The enrollment identifier</param>
        /// <param name="lectureId">The lecture identifier</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>
        /// A task that represents the asynchronous operation
        /// The task result contains the updated course progress DTO or null if record not found
        /// </returns>
        Task<CourseProgressDto> MarkLectureAsIncompleteAsync(int enrollmentId, int lectureId, CancellationToken cancellationToken = default);

        /// <summary>
        /// Updates an existing course progress record or creates a new one if it doesn't exist
        /// </summary>
        /// <param name="progressDto">The progress data transfer object containing update information</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>
        /// A task that represents the asynchronous operation
        /// The task result contains the updated or created course progress DTO
        /// </returns>
        Task<CourseProgressDto> UpdateProgressAsync(UpdateCourseProgressDto progressDto, CancellationToken cancellationToken = default);

        #endregion

        #region Progress Management Operations

        /// <summary>
        /// Deletes a course progress record by its ID
        /// </summary>
        /// <param name="progressId">The progress record identifier</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>
        /// A task that represents the asynchronous operation
        /// The task result contains true if deletion was successful, false if record was not found
        /// </returns>
        Task<bool> DeleteProgressAsync(int progressId, CancellationToken cancellationToken = default);

        #endregion

        #region Progress Analytics Operations

        /// <summary>
        /// Gets the count of completed lectures for a specific enrollment
        /// </summary>
        /// <param name="enrollmentId">The enrollment identifier</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>
        /// A task that represents the asynchronous operation
        /// The task result contains the count of completed lectures
        /// </returns>
        Task<int> GetCompletedLecturesCountAsync(int enrollmentId, CancellationToken cancellationToken = default);

        /// <summary>
        /// Checks if a specific lecture is completed for a given enrollment
        /// </summary>
        /// <param name="enrollmentId">The enrollment identifier</param>
        /// <param name="lectureId">The lecture identifier</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>
        /// A task that represents the asynchronous operation
        /// The task result contains true if the lecture is completed, false otherwise
        /// </returns>
        Task<bool> IsLectureCompletedAsync(int enrollmentId, int lectureId, CancellationToken cancellationToken = default);

        /// <summary>
        /// Gets a comprehensive progress summary for a specific enrollment
        /// </summary>
        /// <param name="enrollmentId">The enrollment identifier</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>
        /// A task that represents the asynchronous operation
        /// The task result contains the course progress summary DTO
        /// </returns>
        Task<CourseProgressSummaryDto> GetCourseProgressSummaryAsync(int enrollmentId, CancellationToken cancellationToken = default);

        /// <summary>
        /// Calculates the course progress percentage for a specific enrollment
        /// </summary>
        /// <param name="enrollmentId">The enrollment identifier</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>
        /// A task that represents the asynchronous operation
        /// The task result contains the progress percentage (0-100)
        /// </returns>
        Task<decimal> GetCourseProgressPercentageAsync(int enrollmentId, CancellationToken cancellationToken = default);

        #endregion
    }
}
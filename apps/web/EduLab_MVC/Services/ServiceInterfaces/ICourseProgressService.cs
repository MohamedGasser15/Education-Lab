using EduLab_MVC.Models.DTOs.CourseProgress;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;

namespace EduLab_MVC.Services.ServiceInterfaces
{
    /// <summary>
    /// Service interface for managing course progress operations in the MVC application
    /// Defines contract for course progress tracking and analytics
    /// </summary>
    public interface ICourseProgressService
    {
        #region Progress Tracking Operations

        /// <summary>
        /// Marks a specific lecture as completed for a course
        /// </summary>
        /// <param name="courseId">The course identifier</param>
        /// <param name="lectureId">The lecture identifier</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>
        /// A task that represents the asynchronous operation
        /// The task result contains true if operation was successful, false otherwise
        /// </returns>
        Task<bool> MarkLectureAsCompletedAsync(int courseId, int lectureId, CancellationToken cancellationToken = default);

        /// <summary>
        /// Marks a specific lecture as incomplete for a course
        /// </summary>
        /// <param name="courseId">The course identifier</param>
        /// <param name="lectureId">The lecture identifier</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>
        /// A task that represents the asynchronous operation
        /// The task result contains true if operation was successful, false otherwise
        /// </returns>
        Task<bool> MarkLectureAsIncompleteAsync(int courseId, int lectureId, CancellationToken cancellationToken = default);

        #endregion

        #region Progress Retrieval Operations

        /// <summary>
        /// Gets the course progress summary for a specific course
        /// </summary>
        /// <param name="courseId">The course identifier</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>
        /// A task that represents the asynchronous operation
        /// The task result contains the course progress summary DTO or null if not found
        /// </returns>
        Task<CourseProgressSummaryDto> GetCourseProgressAsync(int courseId, CancellationToken cancellationToken = default);

        /// <summary>
        /// Gets the completion status of a specific lecture in a course
        /// </summary>
        /// <param name="courseId">The course identifier</param>
        /// <param name="lectureId">The lecture identifier</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>
        /// A task that represents the asynchronous operation
        /// The task result contains true if the lecture is completed, false otherwise
        /// </returns>
        Task<bool> GetLectureStatusAsync(int courseId, int lectureId, CancellationToken cancellationToken = default);

        /// <summary>
        /// Gets detailed progress information for all lectures in a course
        /// </summary>
        /// <param name="courseId">The course identifier</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>
        /// A task that represents the asynchronous operation
        /// The task result contains a list of lecture progress DTOs
        /// </returns>
        Task<List<LectureProgressDto>> GetCourseProgressDetailsAsync(int courseId, CancellationToken cancellationToken = default);

        #endregion

        #region Batch Operations

        /// <summary>
        /// Gets the completion status for multiple lectures in a course
        /// </summary>
        /// <param name="courseId">The course identifier</param>
        /// <param name="lectureIds">The list of lecture identifiers</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>
        /// A task that represents the asynchronous operation
        /// The task result contains a dictionary mapping lecture IDs to their completion status
        /// </returns>
        Task<Dictionary<int, bool>> GetLecturesStatusAsync(int courseId, List<int> lectureIds, CancellationToken cancellationToken = default);

        #endregion
    }
}
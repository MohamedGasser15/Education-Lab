using EduLab_Domain.Entities;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;

namespace EduLab_Domain.RepoInterfaces
{
    /// <summary>
    /// Interface for course progress repository operations
    /// Defines contract for managing course progress data
    /// </summary>
    public interface ICourseProgressRepository
    {
        #region CRUD Operations

        /// <summary>
        /// Retrieves a specific course progress record by enrollment ID and lecture ID
        /// </summary>
        /// <param name="enrollmentId">The enrollment identifier</param>
        /// <param name="lectureId">The lecture identifier</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>
        /// A task that represents the asynchronous operation
        /// The task result contains the course progress record or null if not found
        /// </returns>
        Task<CourseProgress> GetProgressAsync(int enrollmentId, int lectureId, CancellationToken cancellationToken = default);

        /// <summary>
        /// Creates a new course progress record
        /// </summary>
        /// <param name="progress">The course progress entity to create</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>
        /// A task that represents the asynchronous operation
        /// The task result contains the created course progress record
        /// </returns>
        Task<CourseProgress> CreateProgressAsync(CourseProgress progress, CancellationToken cancellationToken = default);

        /// <summary>
        /// Updates an existing course progress record
        /// </summary>
        /// <param name="progress">The course progress entity to update</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>
        /// A task that represents the asynchronous operation
        /// The task result contains the updated course progress record
        /// </returns>
        Task<CourseProgress> UpdateProgressAsync(CourseProgress progress, CancellationToken cancellationToken = default);

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

        #region Query Operations

        /// <summary>
        /// Retrieves all progress records for a specific enrollment
        /// </summary>
        /// <param name="enrollmentId">The enrollment identifier</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>
        /// A task that represents the asynchronous operation
        /// The task result contains a list of course progress records
        /// </returns>
        Task<List<CourseProgress>> GetProgressByEnrollmentAsync(int enrollmentId, CancellationToken cancellationToken = default);

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

        #endregion

        #region Progress Calculation Operations

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
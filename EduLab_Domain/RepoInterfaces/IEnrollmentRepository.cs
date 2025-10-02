using EduLab_Domain.Entities;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;

namespace EduLab_Domain.RepoInterfaces
{
    /// <summary>
    /// Interface for enrollment repository operations
    /// Defines contract for managing enrollment data
    /// </summary>
    public interface IEnrollmentRepository
    {
        #region CRUD Operations

        /// <summary>
        /// Creates a new enrollment record
        /// </summary>
        /// <param name="enrollment">The enrollment entity to create</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>
        /// A task that represents the asynchronous operation
        /// The task result contains the created enrollment record
        /// </returns>
        Task<Enrollment> CreateEnrollmentAsync(Enrollment enrollment, CancellationToken cancellationToken = default);

        /// <summary>
        /// Deletes an enrollment record by its ID
        /// </summary>
        /// <param name="enrollmentId">The enrollment identifier</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>
        /// A task that represents the asynchronous operation
        /// The task result contains true if deletion was successful, false if record was not found
        /// </returns>
        Task<bool> DeleteEnrollmentAsync(int enrollmentId, CancellationToken cancellationToken = default);

        #endregion

        #region Query Operations

        /// <summary>
        /// Retrieves an enrollment record by its ID
        /// </summary>
        /// <param name="enrollmentId">The enrollment identifier</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>
        /// A task that represents the asynchronous operation
        /// The task result contains the enrollment record or null if not found
        /// </returns>
        Task<Enrollment> GetEnrollmentByIdAsync(int enrollmentId, CancellationToken cancellationToken = default);

        /// <summary>
        /// Retrieves all enrollments for a specific user
        /// </summary>
        /// <param name="userId">The user identifier</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>
        /// A task that represents the asynchronous operation
        /// The task result contains a collection of enrollment records
        /// </returns>
        Task<IEnumerable<Enrollment>> GetUserEnrollmentsAsync(string userId, CancellationToken cancellationToken = default);

        /// <summary>
        /// Retrieves a specific user's enrollment in a specific course
        /// </summary>
        /// <param name="userId">The user identifier</param>
        /// <param name="courseId">The course identifier</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>
        /// A task that represents the asynchronous operation
        /// The task result contains the enrollment record or null if not found
        /// </returns>
        Task<Enrollment> GetUserCourseEnrollmentAsync(string userId, int courseId, CancellationToken cancellationToken = default);

        /// <summary>
        /// Checks if a user is enrolled in a specific course
        /// </summary>
        /// <param name="userId">The user identifier</param>
        /// <param name="courseId">The course identifier</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>
        /// A task that represents the asynchronous operation
        /// The task result contains true if the user is enrolled, false otherwise
        /// </returns>
        Task<bool> IsUserEnrolledInCourseAsync(string userId, int courseId, CancellationToken cancellationToken = default);

        #endregion

        #region Bulk Operations

        /// <summary>
        /// Creates multiple enrollment records in a single operation
        /// </summary>
        /// <param name="enrollments">The collection of enrollment entities to create</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>
        /// A task that represents the asynchronous operation
        /// The task result contains the number of records created
        /// </returns>
        Task<int> CreateBulkEnrollmentsAsync(IEnumerable<Enrollment> enrollments, CancellationToken cancellationToken = default);

        #endregion

        #region Analytics Operations

        /// <summary>
        /// Gets the total count of enrollments for a specific user
        /// </summary>
        /// <param name="userId">The user identifier</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>
        /// A task that represents the asynchronous operation
        /// The task result contains the count of user enrollments
        /// </returns>
        Task<int> GetUserEnrollmentsCountAsync(string userId, CancellationToken cancellationToken = default);

        #endregion
    }
}
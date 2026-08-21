using EduLab_Application.DTOs.CourseProgress;
using EduLab_Application.DTOs.Enrollment;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;

namespace EduLab_Application.ServiceInterfaces
{
    /// <summary>
    /// Service interface for managing course enrollments
    /// </summary>
    public interface IEnrollmentService
    {
        /// <summary>
        /// Retrieves an enrollment by its ID
        /// </summary>
        /// <param name="enrollmentId">Unique identifier of the enrollment</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>Enrollment DTO or null if not found</returns>
        Task<EnrollmentDto> GetEnrollmentByIdAsync(int enrollmentId, CancellationToken cancellationToken = default);

        /// <summary>
        /// Retrieves all enrollments of a specific user
        /// </summary>
        /// <param name="userId">Unique identifier of the user</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>List of enrollment DTOs</returns>
        Task<IEnumerable<EnrollmentDto>> GetUserEnrollmentsAsync(string userId, CancellationToken cancellationToken = default);

        /// <summary>
        /// Retrieves the enrollment of a user in a specific course
        /// </summary>
        /// <param name="userId">Unique identifier of the user</param>
        /// <param name="courseId">Unique identifier of the course</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>Enrollment DTO or null if not enrolled</returns>
        Task<EnrollmentDto> GetUserCourseEnrollmentAsync(string userId, int courseId, CancellationToken cancellationToken = default);

        /// <summary>
        /// Checks whether a user is enrolled in a course
        /// </summary>
        /// <param name="userId">Unique identifier of the user</param>
        /// <param name="courseId">Unique identifier of the course</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>True if the user is enrolled, otherwise false</returns>
        Task<bool> IsUserEnrolledInCourseAsync(string userId, int courseId, CancellationToken cancellationToken = default);

        /// <summary>
        /// Retrieves an enrollment together with its progress data
        /// </summary>
        /// <param name="enrollmentId">Unique identifier of the enrollment</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>Enrollment progress DTO or null if not found</returns>
        Task<EnrollmentProgressDto> GetEnrollmentWithProgressAsync(int enrollmentId, CancellationToken cancellationToken = default);

        /// <summary>
        /// Enrolls a user in a course
        /// </summary>
        /// <param name="userId">Unique identifier of the user</param>
        /// <param name="courseId">Unique identifier of the course</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>The created enrollment DTO</returns>
        Task<EnrollmentDto> CreateEnrollmentAsync(string userId, int courseId, CancellationToken cancellationToken = default);

        /// <summary>
        /// Deletes an enrollment by its ID
        /// </summary>
        /// <param name="enrollmentId">Unique identifier of the enrollment</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>True if the enrollment was deleted, otherwise false</returns>
        Task<bool> DeleteEnrollmentAsync(int enrollmentId, CancellationToken cancellationToken = default);

        /// <summary>
        /// Enrolls a user in multiple courses at once
        /// </summary>
        /// <param name="userId">Unique identifier of the user</param>
        /// <param name="courseIds">List of course identifiers</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>The number of created enrollments</returns>
        Task<int> CreateBulkEnrollmentsAsync(string userId, IEnumerable<int> courseIds, CancellationToken cancellationToken = default);

        /// <summary>
        /// Gets the total number of enrollments of a user
        /// </summary>
        /// <param name="userId">Unique identifier of the user</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>The enrollments count</returns>
        Task<int> GetUserEnrollmentsCountAsync(string userId, CancellationToken cancellationToken = default);
    }
}
using EduLab_MVC.Models.DTOs.Enrollment;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;

namespace EduLab_MVC.Services.ServiceInterfaces
{
    /// <summary>
    /// Interface for enrollment operations in the MVC application.
    /// </summary>
    public interface IEnrollmentService
    {
        /// <summary>
        /// Retrieves the current user's enrollments.
        /// </summary>
        Task<IEnumerable<EnrollmentDto>> GetUserEnrollmentsAsync(CancellationToken cancellationToken = default);

        /// <summary>
        /// Retrieves an enrollment by its ID.
        /// </summary>
        Task<EnrollmentDto> GetEnrollmentByIdAsync(int enrollmentId, CancellationToken cancellationToken = default);

        /// <summary>
        /// Retrieves the current user's enrollment for a specific course.
        /// </summary>
        Task<EnrollmentDto> GetUserCourseEnrollmentAsync(int courseId, CancellationToken cancellationToken = default);

        /// <summary>
        /// Checks whether the current user is enrolled in a course.
        /// </summary>
        Task<bool> IsUserEnrolledInCourseAsync(int courseId, CancellationToken cancellationToken = default);

        /// <summary>
        /// Enrolls the current user in a course.
        /// </summary>
        Task<EnrollmentDto> EnrollInCourseAsync(int courseId, CancellationToken cancellationToken = default);

        /// <summary>
        /// Unenrolls the current user from a course.
        /// </summary>
        Task<bool> UnenrollAsync(int enrollmentId, CancellationToken cancellationToken = default);

        /// <summary>
        /// Retrieves the total number of enrollments.
        /// </summary>
        Task<int> GetEnrollmentsCountAsync(CancellationToken cancellationToken = default);

        /// <summary>
        /// Checks the current user's enrollment status for a course.
        /// </summary>
        Task<bool> CheckEnrollmentAsync(int courseId, CancellationToken cancellationToken = default);
    }
}

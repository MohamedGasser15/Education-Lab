using EduLab_Shared.DTOs.Enrollment;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;

namespace EduLab_Application.ServiceInterfaces
{
    public interface IEnrollmentService
    {
        Task<EnrollmentDto> GetEnrollmentByIdAsync(int enrollmentId, CancellationToken cancellationToken = default);
        Task<IEnumerable<EnrollmentDto>> GetUserEnrollmentsAsync(string userId, CancellationToken cancellationToken = default);
        Task<EnrollmentDto> GetUserCourseEnrollmentAsync(string userId, int courseId, CancellationToken cancellationToken = default);
        Task<bool> IsUserEnrolledInCourseAsync(string userId, int courseId, CancellationToken cancellationToken = default);
        Task<EnrollmentDto> CreateEnrollmentAsync(string userId, int courseId, CancellationToken cancellationToken = default);
        Task<bool> DeleteEnrollmentAsync(int enrollmentId, CancellationToken cancellationToken = default);
        Task<int> CreateBulkEnrollmentsAsync(string userId, IEnumerable<int> courseIds, CancellationToken cancellationToken = default);
        Task<int> GetUserEnrollmentsCountAsync(string userId, CancellationToken cancellationToken = default);
    }
}
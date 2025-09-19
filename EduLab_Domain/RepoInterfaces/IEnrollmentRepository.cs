using EduLab_Domain.Entities;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;

namespace EduLab_Domain.RepoInterfaces
{
    public interface IEnrollmentRepository
    {
        Task<Enrollment> GetEnrollmentByIdAsync(int enrollmentId, CancellationToken cancellationToken = default);
        Task<IEnumerable<Enrollment>> GetUserEnrollmentsAsync(string userId, CancellationToken cancellationToken = default);
        Task<Enrollment> GetUserCourseEnrollmentAsync(string userId, int courseId, CancellationToken cancellationToken = default);
        Task<bool> IsUserEnrolledInCourseAsync(string userId, int courseId, CancellationToken cancellationToken = default);
        Task<Enrollment> CreateEnrollmentAsync(Enrollment enrollment, CancellationToken cancellationToken = default);
        Task<bool> DeleteEnrollmentAsync(int enrollmentId, CancellationToken cancellationToken = default);
        Task<int> CreateBulkEnrollmentsAsync(IEnumerable<Enrollment> enrollments, CancellationToken cancellationToken = default);
        Task<int> GetUserEnrollmentsCountAsync(string userId, CancellationToken cancellationToken = default);
    }
}
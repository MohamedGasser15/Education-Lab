using EduLab_MVC.Models.DTOs.Enrollment;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;

namespace EduLab_MVC.Services.ServiceInterfaces
{
    public interface IEnrollmentService
    {
        Task<IEnumerable<EnrollmentDto>> GetUserEnrollmentsAsync(CancellationToken cancellationToken = default);
        Task<EnrollmentDto> GetEnrollmentByIdAsync(int enrollmentId, CancellationToken cancellationToken = default);
        Task<EnrollmentDto> GetUserCourseEnrollmentAsync(int courseId, CancellationToken cancellationToken = default);
        Task<bool> IsUserEnrolledInCourseAsync(int courseId, CancellationToken cancellationToken = default);
        Task<EnrollmentDto> EnrollInCourseAsync(int courseId, CancellationToken cancellationToken = default);
        Task<bool> UnenrollAsync(int enrollmentId, CancellationToken cancellationToken = default);
        Task<int> GetEnrollmentsCountAsync(CancellationToken cancellationToken = default);
        Task<bool> CheckEnrollmentAsync(int courseId, CancellationToken cancellationToken = default);
    }
}
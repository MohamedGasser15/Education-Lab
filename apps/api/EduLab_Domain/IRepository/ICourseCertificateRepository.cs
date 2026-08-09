using EduLab_Domain.Entities;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;

namespace EduLab_Domain.IRepository
{
    public interface ICourseCertificateRepository
    {
        Task<CourseCertificate> CreateAsync(CourseCertificate certificate, CancellationToken cancellationToken = default);
        Task<CourseCertificate> GetByEnrollmentIdAsync(int enrollmentId, CancellationToken cancellationToken = default);
        Task<CourseCertificate> GetByCodeAsync(string code, CancellationToken cancellationToken = default);
        Task<List<CourseCertificate>> GetByUserIdAsync(string userId, CancellationToken cancellationToken = default);
    }
}

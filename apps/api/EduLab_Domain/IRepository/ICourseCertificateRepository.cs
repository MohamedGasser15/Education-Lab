using EduLab_Domain.Entities;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;

namespace EduLab_Domain.IRepository
{
    /// <summary>
    /// Repository interface for course certificate data operations
    /// </summary>
    public interface ICourseCertificateRepository
    {
        /// <summary>
        /// Creates a new course certificate
        /// </summary>
        /// <param name="certificate">Certificate entity to create</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>The created certificate</returns>
        Task<CourseCertificate> CreateAsync(CourseCertificate certificate, CancellationToken cancellationToken = default);

        /// <summary>
        /// Retrieves the certificate issued for an enrollment
        /// </summary>
        /// <param name="enrollmentId">Enrollment identifier</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>The certificate or null</returns>
        Task<CourseCertificate> GetByEnrollmentIdAsync(int enrollmentId, CancellationToken cancellationToken = default);

        /// <summary>
        /// Retrieves a certificate by its verification code
        /// </summary>
        /// <param name="code">Certificate code</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>The certificate or null</returns>
        Task<CourseCertificate> GetByCodeAsync(string code, CancellationToken cancellationToken = default);

        /// <summary>
        /// Retrieves all certificates issued to a user
        /// </summary>
        /// <param name="userId">User identifier</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>List of user certificates</returns>
        Task<List<CourseCertificate>> GetByUserIdAsync(string userId, CancellationToken cancellationToken = default);
    }
}

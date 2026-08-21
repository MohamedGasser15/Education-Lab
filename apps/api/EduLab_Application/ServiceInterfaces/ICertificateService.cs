using EduLab_Application.DTOs.Certificates;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;

namespace EduLab_Application.ServiceInterfaces
{
    /// <summary>
    /// Service interface for managing course completion certificates
    /// </summary>
    public interface ICertificateService
    {
        /// <summary>
        /// Retrieves a certificate by its associated enrollment
        /// </summary>
        /// <param name="enrollmentId">Unique identifier of the enrollment</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>Certificate DTO or null if not found</returns>
        Task<CertificateDto> GetByEnrollmentAsync(int enrollmentId, CancellationToken cancellationToken = default);

        /// <summary>
        /// Retrieves a certificate by its verification code
        /// </summary>
        /// <param name="code">Verification code of the certificate</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>Certificate DTO or null if not found</returns>
        Task<CertificateDto> GetByCodeAsync(string code, CancellationToken cancellationToken = default);

        /// <summary>
        /// Retrieves all certificates issued to a specific user
        /// </summary>
        /// <param name="userId">Unique identifier of the user</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>List of certificate DTOs</returns>
        Task<List<CertificateDto>> GetMyCertificatesAsync(string userId, CancellationToken cancellationToken = default);

        /// <summary>
        /// Generates a certificate for a completed enrollment
        /// </summary>
        /// <param name="enrollmentId">Unique identifier of the enrollment</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>The generated certificate DTO</returns>
        Task<CertificateDto> GenerateCertificateAsync(int enrollmentId, CancellationToken cancellationToken = default);

        /// <summary>
        /// Gets the file path of a certificate by its code
        /// </summary>
        /// <param name="code">Verification code of the certificate</param>
        /// <returns>The certificate file path</returns>
        string GetCertificateFilePath(string code);
    }
}
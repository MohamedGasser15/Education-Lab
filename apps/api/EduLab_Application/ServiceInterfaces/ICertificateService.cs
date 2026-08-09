using EduLab_Application.DTOs.Certificates;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;

namespace EduLab_Application.ServiceInterfaces
{
    public interface ICertificateService
    {
        Task<CertificateDto> GetByEnrollmentAsync(int enrollmentId, CancellationToken cancellationToken = default);
        Task<CertificateDto> GetByCodeAsync(string code, CancellationToken cancellationToken = default);
        Task<List<CertificateDto>> GetMyCertificatesAsync(string userId, CancellationToken cancellationToken = default);
        Task<CertificateDto> GenerateCertificateAsync(int enrollmentId, CancellationToken cancellationToken = default);
        string GetCertificateFilePath(string code);
    }
}

using EduLab_MVC.Models.DTOs.Certificates;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;

namespace EduLab_MVC.Services.ServiceInterfaces
{
    /// <summary>
    /// Interface for certificate operations in the MVC application.
    /// </summary>
    public interface ICertificateService
    {
        /// <summary>
        /// Retrieves the current user's certificates.
        /// </summary>
        Task<List<CertificateDto>> GetMyCertificatesAsync(CancellationToken cancellationToken = default);
    }
}

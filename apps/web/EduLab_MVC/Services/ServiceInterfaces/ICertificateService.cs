using EduLab_MVC.Models.DTOs.Certificates;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;

namespace EduLab_MVC.Services.ServiceInterfaces
{
    public interface ICertificateService
    {
        Task<List<CertificateDto>> GetMyCertificatesAsync(CancellationToken cancellationToken = default);
    }
}

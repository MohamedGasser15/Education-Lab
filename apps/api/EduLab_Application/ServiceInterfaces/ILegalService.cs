using EduLab_Application.DTOs.Legal;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;

namespace EduLab_Application.ServiceInterfaces
{
    /// <summary>
    /// Service interface for retrieving platform information, about us, privacy policy, and terms of service
    /// </summary>
    public interface ILegalService
    {
        Task<LegalContentDto> GetAboutInfoAsync(string? language = null, CancellationToken cancellationToken = default);
        Task<LegalContentDto> GetPrivacyPolicyAsync(string? language = null, CancellationToken cancellationToken = default);
        Task<LegalContentDto> GetTermsOfServiceAsync(string? language = null, CancellationToken cancellationToken = default);
        Task<Dictionary<string, LegalContentDto>> GetAllLegalInfoAsync(string? language = null, CancellationToken cancellationToken = default);
    }
}

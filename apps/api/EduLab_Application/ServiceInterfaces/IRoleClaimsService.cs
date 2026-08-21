using EduLab_Domain.Entities;
using System.Threading;
using System.Threading.Tasks;

namespace EduLab_Application.ServiceInterfaces
{
    /// <summary>
    /// Service interface for managing role claims
    /// </summary>
    public interface IRoleClaimsService
    {
        /// <summary>
        /// Retrieves the claims configuration of a role
        /// </summary>
        /// <param name="roleId">Unique identifier of the role</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>The claims model or null if the role does not exist</returns>
        Task<ClaimsModel?> GetClaimsForRoleAsync(string roleId, CancellationToken cancellationToken = default);

        /// <summary>
        /// Replaces the claims of a role with the provided configuration
        /// </summary>
        /// <param name="roleId">Unique identifier of the role</param>
        /// <param name="model">The new claims configuration</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>True if the claims were updated, otherwise false</returns>
        Task<bool> UpdateRoleClaimsAsync(string roleId, ClaimsModel model, CancellationToken cancellationToken = default);
    }
}
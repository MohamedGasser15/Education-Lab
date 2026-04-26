using EduLab_Domain.Entities;
using System.Threading;
using System.Threading.Tasks;

namespace EduLab_Application.ServiceInterfaces
{
    public interface IRoleClaimsService
    {
        Task<ClaimsModel?> GetClaimsForRoleAsync(string roleId, CancellationToken cancellationToken = default);
        Task<bool> UpdateRoleClaimsAsync(string roleId, ClaimsModel model, CancellationToken cancellationToken = default);
    }
}
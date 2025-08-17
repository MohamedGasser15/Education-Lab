using Microsoft.AspNetCore.Identity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Claims;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_Domain.RepoInterfaces
{
    public interface IRoleRepository
    {
        Task<IdentityResult> CreateAsync(IdentityRole role);
        Task<IdentityResult> UpdateAsync(IdentityRole role);
        Task<IdentityResult> DeleteAsync(IdentityRole role);
        Task<IdentityRole> FindByIdAsync(string roleId);
        Task<IdentityRole> FindByNameAsync(string roleName);
        Task<IEnumerable<IdentityRole>> GetAllAsync();
        Task<bool> RoleExistsAsync(string roleName);
        Task<IdentityResult> AddClaimAsync(IdentityRole role, Claim claim);
        Task<IdentityResult> RemoveClaimAsync(IdentityRole role, Claim claim);
        Task<IList<Claim>> GetClaimsAsync(IdentityRole role);
    }
}

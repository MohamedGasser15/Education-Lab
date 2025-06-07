using EduLab_Domain.Entities;
using Microsoft.AspNetCore.Identity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_Domain.RepoInterfaces
{
    public interface IUserRepository
    {
        Task<ApplicationUser> GetUserByEmail(string email);

        Task<ApplicationUser> GetUserById(string id);

        Task<ApplicationUser> GetUserByUserName(string userName);

        Task<IdentityResult> CreateUser(ApplicationUser user, string password);

        Task<bool> CheckPassword(ApplicationUser user, string password);

        Task<IList<string>> GetUserRoles(ApplicationUser user);
        Task<List<ApplicationUser>> GetAllUsersWithRolesAsync();
        Task<bool> DeleteUserAsync(string id);
        Task<bool> DeleteRangeUserAsync(List<string> userIds);
        Task<bool> IsEmailExistsAsync(string email);
        Task<bool> IsFullNameExistsAsync(string fullName);
        Task<IdentityResult> UpdateUserAsync(string userId, string fullName, string role);
    }
}

using EduLab_Domain.Entities;
using EduLab_Shared.DTOs.Auth;
using Microsoft.AspNetCore.Authentication;
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
        Task<IdentityResult> CreateUserWithExternalLoginAsync(ApplicationUser user, ExternalLoginInfo info);


        AuthenticationProperties GetExternalAuthProperties(string provider, string redirectUrl);

        Task<ExternalLoginInfo> GetExternalLoginInfoAsync();

        Task<ApplicationUser> FindByExternalLoginAsync(string provider, string providerKey);

        Task<SignInResult> ExternalLoginSignInAsync(string provider, string providerKey, bool isPersistent);

        Task<IdentityResult> AddLoginAsync(ApplicationUser user, ExternalLoginInfo info);

        Task UpdateExternalAuthTokensAsync(ExternalLoginInfo info);

        Task<bool> CheckPassword(ApplicationUser user, string password);

        Task<IList<string>> GetUserRoles(ApplicationUser user);

        Task<List<ApplicationUser>> GetAllUsersWithRolesAsync();

        Task<bool> DeleteUserAsync(string id);

        Task<bool> DeleteRangeUserAsync(List<string> userIds);

        Task<bool> IsEmailExistsAsync(string email);

        Task<bool> IsFullNameExistsAsync(string fullName);

        Task<IdentityResult> UpdateUserAsync(string userId, string fullName, string role);

        Task UpdateAsync(ApplicationUser user);

        Task<List<ApplicationUser>> GetInstructorsAsync();

        Task<List<ApplicationUser>> GetAdminsAsync();

        Task<List<UserDTO>> LockUsersAsync(List<string> userIds, int minutes);

        Task<List<UserDTO>> UnlockUsersAsync(List<string> userIds);
    }
}

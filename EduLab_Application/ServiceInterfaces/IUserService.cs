using EduLab_Domain.Entities;
using EduLab_Shared.DTOs.Auth;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_Application.ServiceInterfaces
{
    public interface IUserService
    {
        Task<APIResponse> Register(RegisterRequestDTO request);
        Task<APIResponse> VerifyEmailCodeAsync(string email, string code);
        Task<APIResponse> SendVerificationCodeAsync(string email);
        Task<List<UserDTO>> GetAllUsersWithRolesAsync();
        Task<string?> DeleteUserAsync(string id);
        Task<List<string>> DeleteRangeUserAsync(List<string> userIds);
        Task<bool> UpdateUserAsync(UpdateUserDTO dto);
        Task<List<UserDTO>> GetInstructorsAsync();
        Task<UserInfoDTO?> GetUserByIdAsync(string id);
        Task<List<UserDTO>> GetAdminsAsync();
        Task<APIResponse> ForgotPasswordAsync(string email);
        Task<APIResponse> VerifyResetCodeAsync(string email, string code);
        Task<APIResponse> ResetPasswordAsync(ResetPasswordDTO dto);
        Task<List<UserDTO>> LockUsersAsync(List<string> userIds, int minutes);
        Task UnlockUsersAsync(List<string> userIds);
    }
}

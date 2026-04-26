using EduLab_Application.Common;
using EduLab_Application.DTOs.Auth;
using EduLab_Domain.Entities;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace EduLab_Application.ServiceInterfaces
{
    public interface IUserService
    {
        // Authentication & Registration
        Task<ApiResponse<object>> Register(RegisterRequestDTO request);
        Task<ApiResponse<object>> VerifyEmailCodeAsync(string email, string code);
        Task<ApiResponse<object>> SendVerificationCodeAsync(string email);
        Task<ApiResponse<object>> ForgotPasswordAsync(string email);
        Task<ApiResponse<object>> VerifyResetCodeAsync(string email, string code);
        Task<ApiResponse<object>> ResetPasswordAsync(ResetPasswordDTO dto);

        // User Management
        Task<List<UserDTO>> GetAllUsersWithRolesAsync();
        Task<ApiResponse<object>> DeleteUserAsync(string id);
        Task<ApiResponse<object>> DeleteRangeUserAsync(List<string> userIds);
        Task<ApiResponse<object>> UpdateUserAsync(UpdateUserDTO dto);
        Task<UserInfoDTO?> GetUserByIdAsync(string id);

        // Role-based Retrieval
        Task<List<UserDTO>> GetInstructorsAsync();
        Task<List<UserDTO>> GetAdminsAsync();

        // Account Locking/Unlocking
        Task<ApiResponse<object>> LockUsersAsync(List<string> userIds, int minutes);
        Task<ApiResponse<object>> UnlockUsersAsync(List<string> userIds);
    }
}
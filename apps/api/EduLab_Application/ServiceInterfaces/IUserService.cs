using EduLab_Application.Common;
using EduLab_Application.DTOs.Auth;
using EduLab_Domain.Entities;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace EduLab_Application.ServiceInterfaces
{
    /// <summary>
    /// Service interface for user management, authentication and account operations
    /// </summary>
    public interface IUserService
    {
        // Authentication & Registration

        /// <summary>
        /// Registers a new user account
        /// </summary>
        /// <param name="request">Registration request data</param>
        /// <param name="preferredLanguage">Preferred language of the user</param>
        /// <returns>API response with the registration result</returns>
        Task<ApiResponse<object>> Register(RegisterRequestDTO request, string? preferredLanguage = null);

        /// <summary>
        /// Verifies the email confirmation code of a user
        /// </summary>
        /// <param name="email">The user email</param>
        /// <param name="code">The verification code</param>
        /// <returns>API response with the verification result</returns>
        Task<ApiResponse<object>> VerifyEmailCodeAsync(string email, string code);

        /// <summary>
        /// Sends a verification code to the user email
        /// </summary>
        /// <param name="email">The user email</param>
        /// <returns>API response with the sending result</returns>
        Task<ApiResponse<object>> SendVerificationCodeAsync(string email);

        /// <summary>
        /// Initiates the password reset flow for a user
        /// </summary>
        /// <param name="email">The user email</param>
        /// <returns>API response with the reset request result</returns>
        Task<ApiResponse<object>> ForgotPasswordAsync(string email);

        /// <summary>
        /// Verifies the password reset code of a user
        /// </summary>
        /// <param name="email">The user email</param>
        /// <param name="code">The reset code</param>
        /// <returns>API response with the verification result</returns>
        Task<ApiResponse<object>> VerifyResetCodeAsync(string email, string code);

        /// <summary>
        /// Resets the password of a user using a verified reset code
        /// </summary>
        /// <param name="dto">Password reset data</param>
        /// <returns>API response with the reset result</returns>
        Task<ApiResponse<object>> ResetPasswordAsync(ResetPasswordDTO dto);

        // User Management

        /// <summary>
        /// Retrieves all users together with their roles
        /// </summary>
        /// <returns>List of users with role information</returns>
        Task<List<UserDTO>> GetAllUsersWithRolesAsync();

        /// <summary>
        /// Deletes a user account
        /// </summary>
        /// <param name="id">Unique identifier of the user</param>
        /// <returns>API response with the deletion result</returns>
        Task<ApiResponse<object>> DeleteUserAsync(string id);

        /// <summary>
        /// Deletes multiple user accounts at once
        /// </summary>
        /// <param name="userIds">List of user identifiers to delete</param>
        /// <returns>API response with the deletion summary</returns>
        Task<ApiResponse<object>> DeleteRangeUserAsync(List<string> userIds);

        /// <summary>
        /// Updates the data of a user account
        /// </summary>
        /// <param name="dto">User update data</param>
        /// <returns>API response with the update result</returns>
        Task<ApiResponse<object>> UpdateUserAsync(UpdateUserDTO dto);

        /// <summary>
        /// Retrieves a user by their ID
        /// </summary>
        /// <param name="id">Unique identifier of the user</param>
        /// <returns>User info DTO or null if not found</returns>
        Task<UserInfoDTO?> GetUserByIdAsync(string id);

        // Role-based Retrieval

        /// <summary>
        /// Retrieves all users with the instructor role
        /// </summary>
        /// <returns>List of instructor users</returns>
        Task<List<UserDTO>> GetInstructorsAsync();

        /// <summary>
        /// Retrieves all users with the admin role
        /// </summary>
        /// <returns>List of admin users</returns>
        Task<List<UserDTO>> GetAdminsAsync();

        // Account Locking/Unlocking

        /// <summary>
        /// Locks multiple user accounts for a specified duration
        /// </summary>
        /// <param name="userIds">List of user identifiers to lock</param>
        /// <param name="minutes">Lockout duration in minutes</param>
        /// <returns>API response with the locking result</returns>
        Task<ApiResponse<object>> LockUsersAsync(List<string> userIds, int minutes);

        /// <summary>
        /// Unlocks multiple user accounts
        /// </summary>
        /// <param name="userIds">List of user identifiers to unlock</param>
        /// <returns>API response with the unlocking result</returns>
        Task<ApiResponse<object>> UnlockUsersAsync(List<string> userIds);

        // Language Preference

        /// <summary>
        /// Updates the preferred language of a user
        /// </summary>
        /// <param name="userId">Unique identifier of the user</param>
        /// <param name="language">The new language code</param>
        /// <returns>API response with the update result</returns>
        Task<ApiResponse<object>> UpdatePreferredLanguageAsync(string userId, string language);
    }
}
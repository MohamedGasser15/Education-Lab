using EduLab_MVC.Models.DTOs.Auth;

namespace EduLab_MVC.Services.ServiceInterfaces
{
    /// <summary>
    /// Interface for managing user operations including retrieval, update, and deletion
    /// </summary>
    public interface IUserService
    {
        #region User Retrieval Methods

        /// <summary>
        /// Retrieves all users from the API
        /// </summary>
        /// <returns>List of all users</returns>
        Task<List<UserDTO>> GetAllUsersAsync();

        /// <summary>
        /// Retrieves all instructors from the API
        /// </summary>
        /// <returns>List of all instructors</returns>
        Task<List<UserDTO>> GetInstructorsAsync();

        /// <summary>
        /// Retrieves all administrators from the API
        /// </summary>
        /// <returns>List of all administrators</returns>
        Task<List<UserDTO>> GetAdminsAsync();

        /// <summary>
        /// Retrieves a specific user by ID
        /// </summary>
        /// <param name="id">User identifier</param>
        /// <returns>User information if found, otherwise null</returns>
        Task<UserInfoDTO?> GetUserByIdAsync(string id);

        /// <summary>
        /// Retrieves the currently authenticated user
        /// </summary>
        /// <returns>Current user information if found, otherwise null</returns>
        Task<UserInfoDTO?> GetCurrentUserAsync();

        #endregion

        #region User Management Methods

        /// <summary>
        /// Deletes a user by ID
        /// </summary>
        /// <param name="userId">User identifier</param>
        /// <returns>Null if deletion succeeded, otherwise error message</returns>
        Task<string?> DeleteUserAsync(string userId);

        /// <summary>
        /// Deletes multiple users by their IDs
        /// </summary>
        /// <param name="userIds">List of user identifiers</param>
        /// <returns>Null if success, otherwise error message</returns>
        Task<string?> DeleteRangeUsersAsync(List<string> userIds);

        /// <summary>
        /// Updates user information
        /// </summary>
        /// <param name="dto">User update data transfer object</param>
        /// <returns>Tuple indicating success status and message</returns>
        Task<(bool Success, string Message)> UpdateUserAsync(UpdateUserDTO dto);

        #endregion

        #region Account Locking/Unlocking Methods

        /// <summary>
        /// Locks user accounts for a specified duration
        /// </summary>
        /// <param name="userIds">List of user identifiers to lock</param>
        /// <param name="minutes">Duration of lock in minutes</param>
        /// <returns>True if locking was successful, otherwise false</returns>
        Task<bool> LockUsersAsync(List<string> userIds, int minutes);

        /// <summary>
        /// Unlocks user accounts
        /// </summary>
        /// <param name="userIds">List of user identifiers to unlock</param>
        /// <returns>True if unlocking was successful, otherwise false</returns>
        Task<bool> UnlockUsersAsync(List<string> userIds);

        #endregion
    }
}

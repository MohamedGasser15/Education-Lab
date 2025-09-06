using EduLab_Application.ServiceInterfaces;
using EduLab_Shared.DTOs.Auth;
using EduLab_Shared.Utitlites;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Net;
using System.Security.Claims;
using System.Text.Json;

namespace EduLab_API.Controllers.Admin
{
    /// <summary>
    /// Controller for managing user operations including retrieval, update, and deletion
    /// </summary>
    [Route("api/[controller]")]
    [ApiController]
    [Authorize]
    public class UserController : ControllerBase
    {
        #region Dependencies

        private readonly IUserService _userService;
        private readonly ILogger<UserController> _logger;

        #endregion

        #region Constructor

        /// <summary>
        /// Initializes a new instance of the UserController class
        /// </summary>
        /// <param name="userService">User service for business logic operations</param>
        /// <param name="logger">Logger for tracking operations and errors</param>
        public UserController(IUserService userService, ILogger<UserController> logger)
        {
            _userService = userService;
            _logger = logger;
        }

        #endregion

        #region User Retrieval Endpoints

        /// <summary>
        /// Retrieves all users with their roles
        /// </summary>
        /// <returns>List of all users with role information</returns>
        [HttpGet]
        [Authorize(Roles = $"{SD.Admin},{SD.Moderator}")]
        [ProducesResponseType(typeof(IEnumerable<UserDTO>), (int)HttpStatusCode.OK)]
        [ProducesResponseType((int)HttpStatusCode.Unauthorized)]
        [ProducesResponseType((int)HttpStatusCode.Forbidden)]
        [ProducesResponseType((int)HttpStatusCode.InternalServerError)]
        public async Task<IActionResult> GetAllUsers()
        {
            try
            {
                _logger.LogInformation("Retrieving all users with roles");

                var users = await _userService.GetAllUsersWithRolesAsync();

                _logger.LogInformation("Successfully retrieved {Count} users", users.Count);
                return Ok(users);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while retrieving all users");
                return StatusCode((int)HttpStatusCode.InternalServerError, new { message = "حدث خطأ أثناء استرجاع المستخدمين" });
            }
        }

        /// <summary>
        /// Retrieves a specific user by ID
        /// </summary>
        /// <param name="id">User identifier</param>
        /// <returns>User information if found</returns>
        [HttpGet("{id}")]
        [Authorize]
        [ProducesResponseType(typeof(UserInfoDTO), (int)HttpStatusCode.OK)]
        [ProducesResponseType((int)HttpStatusCode.NotFound)]
        [ProducesResponseType((int)HttpStatusCode.Unauthorized)]
        [ProducesResponseType((int)HttpStatusCode.BadRequest)]
        [ProducesResponseType((int)HttpStatusCode.InternalServerError)]
        public async Task<IActionResult> GetById(string id)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(id))
                {
                    _logger.LogWarning("Get user by ID attempt with empty ID");
                    return BadRequest(new { message = "معرف المستخدم غير صالح" });
                }

                _logger.LogInformation("Retrieving user with ID: {UserId}", id);

                var user = await _userService.GetUserByIdAsync(id);
                if (user == null)
                {
                    _logger.LogWarning("User not found with ID: {UserId}", id);
                    return NotFound(new { message = "المستخدم غير موجود" });
                }

                _logger.LogInformation("Successfully retrieved user with ID: {UserId}", id);
                return Ok(user);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while retrieving user with ID: {UserId}", id);
                return StatusCode((int)HttpStatusCode.InternalServerError, new { message = "حدث خطأ أثناء استرجاع بيانات المستخدم" });
            }
        }

        /// <summary>
        /// Retrieves the currently authenticated user
        /// </summary>
        /// <returns>Current user information</returns>
        [HttpGet("me")]
        [Authorize]
        [ProducesResponseType(typeof(UserInfoDTO), (int)HttpStatusCode.OK)]
        [ProducesResponseType((int)HttpStatusCode.Unauthorized)]
        [ProducesResponseType((int)HttpStatusCode.NotFound)]
        [ProducesResponseType((int)HttpStatusCode.InternalServerError)]
        public async Task<IActionResult> GetCurrentUser()
        {
            try
            {
                var userId = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
                var role = User.FindFirst(ClaimTypes.Role)?.Value;

                if (string.IsNullOrWhiteSpace(userId))
                {
                    _logger.LogWarning("Get current user attempt with null user ID");
                    return Unauthorized(new { message = "المستخدم غير مصرح به" });
                }

                _logger.LogInformation("Retrieving current user with ID: {UserId}", userId);

                var user = await _userService.GetUserByIdAsync(userId);
                if (user == null)
                {
                    _logger.LogWarning("Current user not found with ID: {UserId}", userId);
                    return NotFound(new { message = "المستخدم غير موجود" });
                }

                user.Role = role;

                _logger.LogInformation("Successfully retrieved current user with ID: {UserId}", userId);
                return Ok(user);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while retrieving current user");
                return StatusCode((int)HttpStatusCode.InternalServerError, new { message = "حدث خطأ أثناء استرجاع بيانات المستخدم الحالي" });
            }
        }

        #endregion

        #region Role-based User Retrieval

        /// <summary>
        /// Retrieves all instructors
        /// </summary>
        /// <returns>List of instructors</returns>
        [HttpGet("Instructors")]
        [Authorize(Roles = $"{SD.Admin},{SD.Moderator}")]
        [ProducesResponseType(typeof(IEnumerable<UserDTO>), (int)HttpStatusCode.OK)]
        [ProducesResponseType((int)HttpStatusCode.NotFound)]
        [ProducesResponseType((int)HttpStatusCode.Unauthorized)]
        [ProducesResponseType((int)HttpStatusCode.Forbidden)]
        [ProducesResponseType((int)HttpStatusCode.InternalServerError)]
        public async Task<IActionResult> GetInstructors()
        {
            try
            {
                _logger.LogInformation("Retrieving all instructors");

                var instructors = await _userService.GetInstructorsAsync();
                if (instructors == null || instructors.Count == 0)
                {
                    _logger.LogWarning("No instructors found");
                    return NotFound(new { message = "No instructors found" });
                }

                _logger.LogInformation("Successfully retrieved {Count} instructors", instructors.Count);
                return Ok(instructors);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while retrieving instructors");
                return StatusCode((int)HttpStatusCode.InternalServerError, new { message = "حدث خطأ أثناء استرجاع المدربين" });
            }
        }

        /// <summary>
        /// Retrieves all administrators
        /// </summary>
        /// <returns>List of administrators</returns>
        [HttpGet("Admins")]
        [Authorize(Roles = SD.Admin)]
        [ProducesResponseType(typeof(IEnumerable<UserDTO>), (int)HttpStatusCode.OK)]
        [ProducesResponseType((int)HttpStatusCode.NotFound)]
        [ProducesResponseType((int)HttpStatusCode.Unauthorized)]
        [ProducesResponseType((int)HttpStatusCode.Forbidden)]
        [ProducesResponseType((int)HttpStatusCode.InternalServerError)]
        public async Task<IActionResult> GetAdmins()
        {
            try
            {
                _logger.LogInformation("Retrieving all admins");

                var admins = await _userService.GetAdminsAsync();
                if (admins == null || admins.Count == 0)
                {
                    _logger.LogWarning("No admins found");
                    return NotFound(new { message = "No admins found" });
                }

                _logger.LogInformation("Successfully retrieved {Count} admins", admins.Count);
                return Ok(admins);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while retrieving admins");
                return StatusCode((int)HttpStatusCode.InternalServerError, new { message = "حدث خطأ أثناء استرجاع المديرين" });
            }
        }

        #endregion

        #region User Management Endpoints

        /// <summary>
        /// Deletes a user by ID
        /// </summary>
        /// <param name="id">User identifier</param>
        /// <returns>No content if successful</returns>
        [HttpDelete("{id}")]
        [Authorize(Roles = SD.Admin)]
        [ProducesResponseType((int)HttpStatusCode.NoContent)]
        [ProducesResponseType((int)HttpStatusCode.BadRequest)]
        [ProducesResponseType((int)HttpStatusCode.InternalServerError)]
        public async Task<IActionResult> DeleteUser(string id)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(id))
                {
                    _logger.LogWarning("Delete user attempt with empty ID");
                    return BadRequest(new { message = "معرف المستخدم غير صالح" });
                }

                _logger.LogInformation("Deleting user with ID: {UserId}", id);

                var errorMessage = await _userService.DeleteUserAsync(id);

                if (errorMessage != null)
                {
                    _logger.LogWarning("Failed to delete user {UserId}: {ErrorMessage}", id, errorMessage);
                    return BadRequest(new { message = errorMessage });
                }

                _logger.LogInformation("Successfully deleted user with ID: {UserId}", id);
                return NoContent();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while deleting user with ID: {UserId}", id);
                return StatusCode((int)HttpStatusCode.InternalServerError, new { message = "حدث خطأ أثناء حذف المستخدم" });
            }
        }


        /// <summary>
        /// Deletes multiple users by their IDs
        /// </summary>
        /// <param name="userIds">List of user identifiers</param>
        /// <returns>No content if successful</returns>
        [HttpPost("DeleteUsers")]
        [Authorize(Roles = SD.Admin)]
        [ProducesResponseType((int)HttpStatusCode.NoContent)]
        [ProducesResponseType((int)HttpStatusCode.BadRequest)]
        [ProducesResponseType((int)HttpStatusCode.InternalServerError)]
        public async Task<IActionResult> DeleteRangeUsers([FromBody] List<string> userIds)
        {
            try
            {
                if (userIds == null || userIds.Count == 0)
                {
                    _logger.LogWarning("Delete range users attempt with empty list");
                    return BadRequest(new { message = "لم يتم توفير أي معرفات مستخدمين" });
                }

                _logger.LogInformation("Deleting {Count} users", userIds.Count);

                var errorMessage = await _userService.DeleteRangeUserAsync(userIds);

                if (errorMessage != null)
                {
                    _logger.LogWarning("Failed to delete some users: {ErrorMessage}", errorMessage);
                    return BadRequest(new { message = errorMessage });
                }

                _logger.LogInformation("Successfully deleted {Count} users", userIds.Count);
                return NoContent();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while deleting range of users");
                return StatusCode((int)HttpStatusCode.InternalServerError, new { message = "حدث خطأ أثناء حذف المستخدمين" });
            }
        }


        /// <summary>
        /// Updates user information
        /// </summary>
        /// <param name="dto">User update data transfer object</param>
        /// <returns>No content if successful</returns>
        [HttpPut]
        [Authorize(Roles = SD.Admin)]
        [ProducesResponseType((int)HttpStatusCode.NoContent)]
        [ProducesResponseType((int)HttpStatusCode.NotFound)]
        [ProducesResponseType((int)HttpStatusCode.Unauthorized)]
        [ProducesResponseType((int)HttpStatusCode.Forbidden)]
        [ProducesResponseType((int)HttpStatusCode.BadRequest)]
        [ProducesResponseType((int)HttpStatusCode.InternalServerError)]
        public async Task<IActionResult> UpdateUser([FromBody] UpdateUserDTO dto)
        {
            try
            {
                if (dto == null)
                {
                    _logger.LogWarning("Update user attempt with null DTO");
                    return BadRequest(new { message = "Invalid user data" });
                }

                if (string.IsNullOrEmpty(dto.Id) || string.IsNullOrEmpty(dto.FullName) || string.IsNullOrEmpty(dto.Role))
                {
                    _logger.LogWarning("Update user attempt with invalid data: {Data}", JsonSerializer.Serialize(dto));
                    return BadRequest(new { message = "بيانات المستخدم غير مكتملة" });
                }

                _logger.LogInformation("Updating user with ID: {UserId}", dto.Id);

                var result = await _userService.UpdateUserAsync(dto);
                if (!result)
                {
                    _logger.LogWarning("User not found or could not be updated: {UserId}", dto.Id);
                    return NotFound(new
                    {
                        message = "User not found or could not be updated",
                        details = "قد يكون المستخدم غير موجود أو الدور المطلوب غير صحيح"
                    });
                }

                _logger.LogInformation("Successfully updated user with ID: {UserId}", dto.Id);
                return NoContent();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while updating user with ID: {UserId}", dto?.Id);
                return StatusCode((int)HttpStatusCode.InternalServerError, new
                {
                    message = "حدث خطأ أثناء تحديث بيانات المستخدم",
                    details = ex.Message
                });
            }
        }

        #endregion

        #region Account Locking/Unlocking Endpoints

        /// <summary>
        /// Locks user accounts for a specified duration
        /// </summary>
        /// <param name="request">Lock request containing user IDs and duration</param>
        /// <returns>Success message if successful</returns>
        [HttpPost("LockUsers")]
        [Authorize(Roles = SD.Admin)]
        [ProducesResponseType((int)HttpStatusCode.OK)]
        [ProducesResponseType((int)HttpStatusCode.Unauthorized)]
        [ProducesResponseType((int)HttpStatusCode.Forbidden)]
        [ProducesResponseType((int)HttpStatusCode.BadRequest)]
        [ProducesResponseType((int)HttpStatusCode.InternalServerError)]
        public async Task<IActionResult> LockUsers([FromBody] LockUsersRequestDto request)
        {
            try
            {
                if (request == null)
                    return BadRequest(new { message = "Request data is required" });

                if (request.UserIds == null || !request.UserIds.Any())
                    return BadRequest(new { message = "No users selected" });

                if (request.Minutes < 0)
                    return BadRequest(new { message = "Minutes must be zero or more" });

                var lockedUsers = await _userService.LockUsersAsync(request.UserIds, request.Minutes);

                if (!lockedUsers.Any())
                {
                    return BadRequest(new { message = "لم يتم قفل أي مستخدم (قد تكون حاولت قفل حسابك الشخصي أو مستخدمين غير موجودين)" });
                }

                return Ok(new
                {
                    message = $"تم قفل {lockedUsers.Count} مستخدم بنجاح لمدة {request.Minutes} دقيقة",
                    users = lockedUsers
                });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while locking users");
                return StatusCode((int)HttpStatusCode.InternalServerError, new { message = "حدث خطأ أثناء قفل حسابات المستخدمين" });
            }
        }


        /// <summary>
        /// Unlocks user accounts
        /// </summary>
        /// <param name="userIds">List of user identifiers to unlock</param>
        /// <returns>Success message if successful</returns>
        [HttpPost("UnlockUsers")]
        [Authorize(Roles = SD.Admin)]
        [ProducesResponseType((int)HttpStatusCode.OK)]
        [ProducesResponseType((int)HttpStatusCode.Unauthorized)]
        [ProducesResponseType((int)HttpStatusCode.Forbidden)]
        [ProducesResponseType((int)HttpStatusCode.BadRequest)]
        [ProducesResponseType((int)HttpStatusCode.InternalServerError)]
        public async Task<IActionResult> UnlockUsers([FromBody] List<string> userIds)
        {
            try
            {
                if (userIds == null || !userIds.Any())
                {
                    _logger.LogWarning("Unlock users attempt with empty user IDs list");
                    return BadRequest("No users selected");
                }

                _logger.LogInformation("Unlocking {Count} users", userIds.Count);

                await _userService.UnlockUsersAsync(userIds);

                _logger.LogInformation("Successfully unlocked {Count} users", userIds.Count);
                return Ok(new { Message = "Users unlocked successfully" });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while unlocking users");
                return StatusCode((int)HttpStatusCode.InternalServerError, new { message = "حدث خطأ أثناء فتح قفل حسابات المستخدمين" });
            }
        }

        #endregion
    }
} 
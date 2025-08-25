using EduLab_Application.ServiceInterfaces;
using EduLab_Shared.DTOs.Auth;
using Microsoft.AspNetCore.Mvc;

namespace EduLab_API.Controllers.Admin
{
    [Route("api/[Controller]")]
    [ApiController]
    public class UserController : ControllerBase
    {
        private readonly IUserService _userService;
        public UserController(IUserService userService)
        {
            _userService = userService;
        }

        [HttpGet]
        public async Task<IActionResult> GetAllUsers()
        {
            var users = await _userService.GetAllUsersWithRolesAsync();
            return Ok(users);
        }
        [HttpGet("Instructors")]
        public async Task<IActionResult> GetInstructors()
        {
            var instructors = await _userService.GetInstructorsAsync();
            if (instructors == null || instructors.Count == 0)
            {
                return NotFound(new { message = "No instructors found" });
            }
            return Ok(instructors);
        }
        [HttpGet("Admins")]
        public async Task<IActionResult> GetAdmins()
        {
            var admins = await _userService.GetAdminsAsync();
            if (admins == null || admins.Count == 0)
            {
                return NotFound(new { message = "No admins found" });
            }
            return Ok(admins);
        }
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteUser(string id)
        {
            var result = await _userService.DeleteUserAsync(id);
            if (!result)
            {
                return NotFound(new { message = "User not found or could not be deleted" });
            }

            return NoContent();
        }
        [HttpPost("DeleteUsers")]
        public async Task<IActionResult> DeleteRangeUsers([FromBody] List<string> userIds)
        {
            if (userIds == null || userIds.Count == 0)
            {
                return BadRequest(new { message = "No user IDs provided" });
            }
            var result = await _userService.DeleteRangeUserAsync(userIds);
            if (!result)
            {
                return NotFound(new { message = "Some users not found or could not be deleted" });
            }
            return NoContent();
        }
        [HttpPut]
        public async Task<IActionResult> UpdateUser([FromBody] UpdateUserDTO dto)
        {
            if (dto == null || string.IsNullOrEmpty(dto.Id))
            {
                return BadRequest(new { message = "Invalid user data" });
            }
            var result = await _userService.UpdateUserAsync(dto);
            if (!result)
            {
                return NotFound(new { message = "User not found or could not be updated" });
            }
            return NoContent();
        }

        [HttpPost("LockUsers")]
        public async Task<IActionResult> LockUsers([FromBody] LockUsersRequestDto request)
        {
            if (request.UserIds == null || !request.UserIds.Any())
            {
                return BadRequest("No users selected");
            }
            if (request.Minutes < 0)
            {
                return BadRequest("Minutes must be zero or more");
            }

            await _userService.LockUsersAsync(request.UserIds, request.Minutes);
            return Ok(new { Message = "Users locked successfully" });
        }
        [HttpPost("UnlockUsers")]
        public async Task<IActionResult> UnlockUsers([FromBody] List<string> userIds)
        {
            if (userIds == null || !userIds.Any())
            {
                return BadRequest("No users selected");
            }

            await _userService.UnlockUsersAsync(userIds);
            return Ok(new { Message = "Users unlocked successfully" });
        }
        [HttpGet("{id}")]
        public async Task<IActionResult> GetById(string id)
        {
            var user = await _userService.GetUserByIdAsync(id);
            if (user == null)
                return NotFound(new { message = "المستخدم غير موجود" });

            return Ok(user);
        }
    }
}

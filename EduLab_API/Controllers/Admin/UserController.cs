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
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteUser(string id)
        {
            var result = await _userService.DeleteUserAsync(id);
            if (!result)
            {
                return NotFound(new { message = "User not found or could not be deleted" });
            }

            return NoContent(); // 204
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
            return NoContent(); // 204
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
            return NoContent(); // 204
        }

    }
}

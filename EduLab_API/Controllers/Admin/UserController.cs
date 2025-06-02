using EduLab_Application.ServiceInterfaces;
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
    }
}

using EduLab_Application.ServiceInterfaces;
using EduLab_Shared.DTOs.Auth;
using Microsoft.AspNetCore.Mvc;

namespace EduLab_API.Controllers.Customer
{
    [Route("api/[Controller]")]
    [ApiController]
    public class AuthController : ControllerBase
    {
        private readonly IUserService _userService;
        private readonly IAuthService _authService;

        public AuthController(IAuthService authService, IUserService userService)
        {
            _authService = authService;
            _userService = userService;
        }

        [HttpPost("Login")]
        public async Task<IActionResult> Login([FromBody] LoginRequestDTO model)
        {
            var response = await _authService.Login(model);

            return Ok(response);
        }

        [HttpPost("Register")]
        public async Task<IActionResult> Register([FromBody] RegisterRequestDTO model)
        {
            var response = await _userService.Register(model);
            if (response == null)
                return BadRequest(new { message = "Registration failed" });
            return Ok(response);
        }
    }
}

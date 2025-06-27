using EduLab_API.Responses;
using EduLab_Application.ServiceInterfaces;
using EduLab_Shared.DTOs.Auth;
using Microsoft.AspNetCore.Mvc;
using System.Net;

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
            if (!ModelState.IsValid)
            {
                var errors = ModelState.Values.SelectMany(v => v.Errors).Select(e => e.ErrorMessage).ToList();
                return BadRequest(new { isSuccess = false, errors });
            }
            var response = await _userService.Register(model);

            if (response == null)
                return BadRequest(new { message = "Registration failed" });
            return Ok(response);
        }
        [HttpPost("verify-email")]
        public async Task<IActionResult> VerifyEmail([FromBody] VerifyEmailDTO dto)
        {
            var response = await _userService.VerifyEmailCodeAsync(dto.Email, dto.Code);
            return StatusCode((int)response.StatusCode, response);
        }

        [HttpPost("send-code")]
        public async Task<IActionResult> SendVerificationCodeAsync([FromBody] SendCodeDTO dto)
        {
            var response = await _userService.SendVerificationCodeAsync(dto.Email);

            if (response == null)
            {
                return StatusCode(500, new APIResponse
                {
                    IsSuccess = false,
                    StatusCode = HttpStatusCode.InternalServerError,
                    ErrorMessages = new List<string> { "حدث خطأ أثناء إرسال كود التفعيل" }
                });
            }

            return StatusCode((int)response.StatusCode, response);
        }

    }
}

using EduLab_API.Responses;
using EduLab_Application.ServiceInterfaces;
using EduLab_Application.Services;
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
        private readonly IExternalLoginService _externalLoginService;

        public AuthController(IAuthService authService, IUserService userService, IExternalLoginService externalLoginService)
        {
            _authService = authService;
            _userService = userService;
            _externalLoginService = externalLoginService;
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
        [HttpGet("ExternalLogin")]
        public IActionResult ExternalLogin([FromQuery] string provider, [FromQuery] string returnUrl = null)
        {
            var redirectUrl = Url.Action(nameof(ExternalLoginCallback), "Auth", new { returnUrl }, Request.Scheme);
            var properties = _externalLoginService.ConfigureExternalAuthProperties(provider, redirectUrl);
            return Challenge(properties, provider);
        }


        [HttpGet("ExternalLoginCallback")]
        public async Task<IActionResult> ExternalLoginCallback([FromQuery] string returnUrl = null, [FromQuery] string remoteError = null)
        {
            var result = await _externalLoginService.HandleExternalLoginCallbackAsync(remoteError, returnUrl);

            if (!string.IsNullOrEmpty(remoteError) || result == null || string.IsNullOrEmpty(result.Email))
                return Redirect($"{returnUrl}?error=external_login_failed");

            // 👇 دي مهمة! تأكد إن returnUrl جاي من الـ MVC مش الـ API نفسه
            var url = $"{returnUrl}?email={Uri.EscapeDataString(result.Email)}&isNewUser={result.IsNewUser.ToString().ToLower()}";
            return Redirect(url);
        }


        [HttpPost("ExternalLoginConfirmation")]
        public async Task<IActionResult> ExternalLoginConfirmation([FromBody] ExternalLoginConfirmationDto model)
        {
            try
            {
                Console.WriteLine($"[API] Email: {model.Email}, Name: {model.Name}");

                var result = await _externalLoginService.ConfirmExternalUserAsync(model);
                if (!result.Succeeded)
                    return BadRequest(new APIResponse
                    {
                        IsSuccess = false,
                        ErrorMessages = result.Errors.Select(e => e.Description).ToList()
                    });

                return Ok(new { message = "User registered via external provider" });
            }
            catch (Exception ex)
            {
                return BadRequest(new APIResponse
                {
                    IsSuccess = false,
                    ErrorMessages = new List<string> { ex.Message }
                });
            }
        }
    }
}

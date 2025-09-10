using Azure;
using EduLab_API.Responses;
using EduLab_Application.ServiceInterfaces;
using EduLab_Shared.DTOs.Auth;
using EduLab_Shared.DTOs.Token;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using Microsoft.IdentityModel.Tokens;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Security.Claims;
using System.Threading.Tasks;

namespace EduLab_API.Controllers.Customer
{
    /// <summary>
    /// Controller for handling authentication operations including login, registration, and token management.
    /// </summary>
    [Route("api/[Controller]")]
    [ApiController]
    public class AuthController : ControllerBase
    {
        private readonly IUserService _userService;
        private readonly IAuthService _authService;
        private readonly IExternalLoginService _externalLoginService;
        private readonly ILogger<AuthController> _logger;

        /// <summary>
        /// Initializes a new instance of the <see cref="AuthController"/> class.
        /// </summary>
        /// <param name="authService">The authentication service.</param>
        /// <param name="userService">The user service.</param>
        /// <param name="externalLoginService">The external login service.</param>
        /// <param name="logger">The logger instance.</param>
        public AuthController(
            IAuthService authService,
            IUserService userService,
            IExternalLoginService externalLoginService,
            ILogger<AuthController> logger)
        {
            _authService = authService ?? throw new ArgumentNullException(nameof(authService));
            _userService = userService ?? throw new ArgumentNullException(nameof(userService));
            _externalLoginService = externalLoginService ?? throw new ArgumentNullException(nameof(externalLoginService));
            _logger = logger ?? throw new ArgumentNullException(nameof(logger));
        }

        #region Authentication Endpoints

        /// <summary>
        /// Authenticates a user and returns access and refresh tokens.
        /// </summary>
        /// <param name="model">The login request data.</param>
        /// <returns>Authentication response with tokens and user information.</returns>
        [HttpPost("Login")]
        [ProducesResponseType(typeof(LoginResponseDTO), StatusCodes.Status200OK)]
        [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status400BadRequest)]
        [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status500InternalServerError)]
        public async Task<IActionResult> Login([FromBody] LoginRequestDTO model)
        {
            try
            {
                _logger.LogInformation("Login attempt for email: {Email}", model?.Email);

                if (!ModelState.IsValid)
                {
                    var errors = ModelState.Values.SelectMany(v => v.Errors).Select(e => e.ErrorMessage).ToList();
                    _logger.LogWarning("Invalid model state for login: {Errors}", string.Join(", ", errors));
                    return BadRequest(new ProblemDetails
                    {
                        Title = "Invalid request",
                        Detail = "Please check your input data",
                        Status = StatusCodes.Status400BadRequest
                    });
                }

                var response = await _authService.Login(model);

                if (response == null)
                {
                    _logger.LogWarning("Login failed for email: {Email}", model.Email);
                    return Unauthorized(new ProblemDetails
                    {
                        Title = "Login failed",
                        Status = StatusCodes.Status401Unauthorized
                    });
                }

                _logger.LogInformation("Login successful for email: {Email}", model.Email);
                return Ok(response);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Unexpected error during login for email: {Email}", model?.Email);
                return StatusCode(StatusCodes.Status500InternalServerError, new ProblemDetails
                {
                    Title = "Internal server error",
                    Detail = "An error occurred while processing your login request.",
                    Status = StatusCodes.Status500InternalServerError
                });
            }
        }

        /// <summary>
        /// Refreshes an access token using a valid refresh token.
        /// </summary>
        /// <param name="request">The refresh token request data.</param>
        /// <returns>New access and refresh tokens.</returns>
        [HttpPost("refresh")]
        [ProducesResponseType(typeof(TokenResponseDTO), StatusCodes.Status200OK)]
        [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status401Unauthorized)]
        [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status400BadRequest)]
        [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status500InternalServerError)]
        public async Task<IActionResult> RefreshToken([FromBody] RefreshTokenRequestDTO request)
        {
            try
            {
                _logger.LogInformation("Refresh token request received");

                if (!ModelState.IsValid)
                {
                    var errors = ModelState.Values.SelectMany(v => v.Errors).Select(e => e.ErrorMessage).ToList();
                    _logger.LogWarning("Invalid model state for token refresh: {Errors}", string.Join(", ", errors));
                    return BadRequest(new ProblemDetails
                    {
                        Title = "Invalid request",
                        Detail = "Please check your input data",
                        Status = StatusCodes.Status400BadRequest
                    });
                }

                var result = await _authService.RefreshToken(request);

                if (result == null)
                {
                    _logger.LogWarning("Token refresh failed");
                    return Unauthorized(new ProblemDetails
                    {
                        Title = "Token refresh failed",
                        Status = StatusCodes.Status401Unauthorized
                    });
                }

                _logger.LogInformation("Token refresh successful");
                return Ok(result);
            }
            catch (SecurityTokenException ex)
            {
                _logger.LogWarning(ex, "Security token exception during token refresh");
                return Unauthorized(new ProblemDetails
                {
                    Title = "Invalid token",
                    Detail = ex.Message,
                    Status = StatusCodes.Status401Unauthorized
                });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Unexpected error during token refresh");
                return StatusCode(StatusCodes.Status500InternalServerError, new ProblemDetails
                {
                    Title = "Internal server error",
                    Detail = "An error occurred while refreshing your token.",
                    Status = StatusCodes.Status500InternalServerError
                });
            }
        }

        /// <summary>
        /// Revokes a refresh token for the authenticated user.
        /// </summary>
        /// <param name="refreshToken">The refresh token to revoke.</param>
        /// <returns>Success status of the revocation operation.</returns>
        [HttpPost("revoke")]
        [Authorize]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status401Unauthorized)]
        [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status400BadRequest)]
        [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status500InternalServerError)]
        public async Task<IActionResult> RevokeToken([FromBody] string refreshToken)
        {
            try
            {
                _logger.LogInformation("Revoke token request received");

                if (string.IsNullOrEmpty(refreshToken))
                {
                    _logger.LogWarning("Refresh token is null or empty");
                    return BadRequest(new ProblemDetails
                    {
                        Title = "Invalid request",
                        Detail = "Refresh token is required",
                        Status = StatusCodes.Status400BadRequest
                    });
                }

                var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
                if (string.IsNullOrEmpty(userId))
                {
                    _logger.LogWarning("User ID not found in claims");
                    return Unauthorized(new ProblemDetails
                    {
                        Title = "Unauthorized",
                        Detail = "User not authenticated",
                        Status = StatusCodes.Status401Unauthorized
                    });
                }

                await _authService.RevokeRefreshToken(userId, refreshToken);

                _logger.LogInformation("Refresh token revoked successfully for user {UserId}", userId);
                return Ok(new { message = "Token revoked successfully" });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Unexpected error during token revocation");
                return StatusCode(StatusCodes.Status500InternalServerError, new ProblemDetails
                {
                    Title = "Internal server error",
                    Detail = "An error occurred while revoking your token.",
                    Status = StatusCodes.Status500InternalServerError
                });
            }
        }

        #endregion

        #region Registration Endpoints

        /// <summary>
        /// Registers a new user.
        /// </summary>
        /// <param name="model">The registration request data.</param>
        /// <returns>Registration response with user information.</returns>
        [HttpPost("Register")]
        [ProducesResponseType(typeof(object), StatusCodes.Status200OK)]
        [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status400BadRequest)]
        [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status500InternalServerError)]
        public async Task<IActionResult> Register([FromBody] RegisterRequestDTO model)
        {
            try
            {
                _logger.LogInformation("Registration attempt for email: {Email}", model?.Email);

                if (!ModelState.IsValid)
                {
                    var errors = ModelState.Values.SelectMany(v => v.Errors).Select(e => e.ErrorMessage).ToList();
                    _logger.LogWarning("Invalid model state for registration: {Errors}", string.Join(", ", errors));
                    return BadRequest(new { isSuccess = false, errors });
                }

                var response = await _userService.Register(model);

                if (response == null)
                {
                    _logger.LogWarning("Registration failed for email: {Email}", model.Email);
                    return BadRequest(new { message = "Registration failed" });
                }

                _logger.LogInformation("Registration successful for email: {Email}", model.Email);
                return Ok(response);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Unexpected error during registration for email: {Email}", model?.Email);
                return StatusCode(StatusCodes.Status500InternalServerError, new ProblemDetails
                {
                    Title = "Internal server error",
                    Detail = "An error occurred while processing your registration.",
                    Status = StatusCodes.Status500InternalServerError
                });
            }
        }

        #endregion

        #region Email Verification Endpoints

        /// <summary>
        /// Verifies a user's email using a verification code.
        /// </summary>
        /// <param name="dto">The email verification data.</param>
        /// <returns>Verification result.</returns>
        [HttpPost("verify-email")]
        [ProducesResponseType(typeof(APIResponse), StatusCodes.Status200OK)]
        [ProducesResponseType(typeof(APIResponse), StatusCodes.Status400BadRequest)]
        [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status500InternalServerError)]
        public async Task<IActionResult> VerifyEmail([FromBody] VerifyEmailDTO dto)
        {
            try
            {
                _logger.LogInformation("Email verification attempt for email: {Email}", dto?.Email);

                if (!ModelState.IsValid)
                {
                    var errors = ModelState.Values.SelectMany(v => v.Errors).Select(e => e.ErrorMessage).ToList();
                    _logger.LogWarning("Invalid model state for email verification: {Errors}", string.Join(", ", errors));
                    return BadRequest(new APIResponse
                    {
                        IsSuccess = false,
                        StatusCode = HttpStatusCode.BadRequest,
                        ErrorMessages = errors
                    });
                }

                var response = await _userService.VerifyEmailCodeAsync(dto.Email, dto.Code);
                return StatusCode((int)response.StatusCode, response);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Unexpected error during email verification for email: {Email}", dto?.Email);
                return StatusCode(StatusCodes.Status500InternalServerError, new ProblemDetails
                {
                    Title = "Internal server error",
                    Detail = "An error occurred while verifying your email.",
                    Status = StatusCodes.Status500InternalServerError
                });
            }
        }

        /// <summary>
        /// Sends a verification code to the specified email.
        /// </summary>
        /// <param name="dto">The email address to send the code to.</param>
        /// <returns>Result of the code sending operation.</returns>
        [HttpPost("send-code")]
        [ProducesResponseType(typeof(APIResponse), StatusCodes.Status200OK)]
        [ProducesResponseType(typeof(APIResponse), StatusCodes.Status500InternalServerError)]
        [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status400BadRequest)]
        public async Task<IActionResult> SendVerificationCodeAsync([FromBody] SendCodeDTO dto)
        {
            try
            {
                _logger.LogInformation("Send verification code request for email: {Email}", dto?.Email);

                if (!ModelState.IsValid)
                {
                    var errors = ModelState.Values.SelectMany(v => v.Errors).Select(e => e.ErrorMessage).ToList();
                    _logger.LogWarning("Invalid model state for sending verification code: {Errors}", string.Join(", ", errors));
                    return BadRequest(new APIResponse
                    {
                        IsSuccess = false,
                        StatusCode = HttpStatusCode.BadRequest,
                        ErrorMessages = errors
                    });
                }

                var response = await _userService.SendVerificationCodeAsync(dto.Email);

                if (response == null)
                {
                    _logger.LogError("Failed to send verification code to email: {Email}", dto.Email);
                    return StatusCode(500, new APIResponse
                    {
                        IsSuccess = false,
                        StatusCode = HttpStatusCode.InternalServerError,
                        ErrorMessages = new List<string> { "حدث خطأ أثناء إرسال كود التفعيل" }
                    });
                }

                return StatusCode((int)response.StatusCode, response);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Unexpected error sending verification code to email: {Email}", dto?.Email);
                return StatusCode(StatusCodes.Status500InternalServerError, new ProblemDetails
                {
                    Title = "Internal server error",
                    Detail = "An error occurred while sending the verification code.",
                    Status = StatusCodes.Status500InternalServerError
                });
            }
        }

        #endregion

        #region External Authentication Endpoints

        /// <summary>
        /// Initiates external authentication with the specified provider.
        /// </summary>
        /// <param name="provider">The authentication provider name.</param>
        /// <param name="returnUrl">The URL to return to after authentication.</param>
        /// <returns>Challenge result for external authentication.</returns>
        [HttpGet("ExternalLogin")]
        [ProducesResponseType(StatusCodes.Status302Found)]
        [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status400BadRequest)]
        public IActionResult ExternalLogin([FromQuery] string provider, [FromQuery] string returnUrl = null)
        {
            try
            {
                _logger.LogInformation("External login initiated with provider: {Provider}", provider);

                if (string.IsNullOrEmpty(provider))
                {
                    _logger.LogWarning("Provider parameter is null or empty");
                    return BadRequest(new ProblemDetails
                    {
                        Title = "Invalid request",
                        Detail = "Provider is required",
                        Status = StatusCodes.Status400BadRequest
                    });
                }

                var redirectUrl = Url.Action(nameof(ExternalLoginCallback), "Auth", new { returnUrl }, Request.Scheme);
                var properties = _externalLoginService.ConfigureExternalAuthProperties(provider, redirectUrl);

                _logger.LogInformation("Redirecting to external provider: {Provider}", provider);
                return Challenge(properties, provider);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Unexpected error during external login initiation for provider: {Provider}", provider);
                return BadRequest(new ProblemDetails
                {
                    Title = "External login failed",
                    Detail = "An error occurred while initiating external login.",
                    Status = StatusCodes.Status400BadRequest
                });
            }
        }

        /// <summary>
        /// Handles the callback from external authentication providers.
        /// </summary>
        /// <param name="returnUrl">The URL to return to after processing.</param>
        /// <param name="remoteError">Error message from the external provider, if any.</param>
        /// <returns>Redirect result to the appropriate URL.</returns>
        [HttpGet("ExternalLoginCallback")]
        [ProducesResponseType(StatusCodes.Status302Found)]
        [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status400BadRequest)]
        public async Task<IActionResult> ExternalLoginCallback([FromQuery] string returnUrl = null, [FromQuery] string remoteError = null)
        {
            try
            {
                _logger.LogInformation("External login callback received");

                var result = await _externalLoginService.HandleExternalLoginCallbackAsync(remoteError, returnUrl);

                if (!string.IsNullOrEmpty(remoteError) || result == null || string.IsNullOrEmpty(result.Email))
                {
                    _logger.LogWarning("External login callback failed: RemoteError={RemoteError}", remoteError);
                    return Redirect($"{returnUrl}?error=external_login_failed");
                }

                var url = $"{returnUrl}?email={Uri.EscapeDataString(result.Email)}&isNewUser={result.IsNewUser.ToString().ToLower()}";

                _logger.LogInformation("External login callback successful for email: {Email}", result.Email);
                return Redirect(url);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Unexpected error during external login callback processing");
                return Redirect($"{returnUrl}?error=external_login_failed");
            }
        }

        /// <summary>
        /// Confirms and completes external user registration.
        /// </summary>
        /// <param name="model">The external login confirmation data.</param>
        /// <returns>Result of the external login confirmation.</returns>
        [HttpPost("ExternalLoginConfirmation")]
        [ProducesResponseType(typeof(object), StatusCodes.Status200OK)]
        [ProducesResponseType(typeof(APIResponse), StatusCodes.Status400BadRequest)]
        [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status500InternalServerError)]
        public async Task<IActionResult> ExternalLoginConfirmation([FromBody] ExternalLoginConfirmationDto model)
        {
            try
            {
                _logger.LogInformation("External login confirmation for email: {Email}, Name: {Name}", model?.Email, model?.Name);

                if (!ModelState.IsValid)
                {
                    var errors = ModelState.Values.SelectMany(v => v.Errors).Select(e => e.ErrorMessage).ToList();
                    _logger.LogWarning("Invalid model state for external login confirmation: {Errors}", string.Join(", ", errors));
                    return BadRequest(new APIResponse
                    {
                        IsSuccess = false,
                        StatusCode = HttpStatusCode.BadRequest,
                        ErrorMessages = errors
                    });
                }

                var result = await _externalLoginService.ConfirmExternalUserAsync(model);
                if (!result.Succeeded)
                {
                    _logger.LogWarning("External login confirmation failed for email: {Email}", model.Email);
                    return BadRequest(new APIResponse
                    {
                        IsSuccess = false,
                        StatusCode = HttpStatusCode.BadRequest,
                        ErrorMessages = result.Errors.Select(e => e.Description).ToList()
                    });
                }

                _logger.LogInformation("External login confirmation successful for email: {Email}", model.Email);
                return Ok(new { message = "User registered via external provider" });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Unexpected error during external login confirmation for email: {Email}", model?.Email);
                return BadRequest(new APIResponse
                {
                    IsSuccess = false,
                    StatusCode = HttpStatusCode.BadRequest,
                    ErrorMessages = new List<string> { ex.Message }
                });
            }
        }

        #endregion
    }
}
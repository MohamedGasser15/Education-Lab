using EduLab_MVC.Models.DTOs.Auth;
using EduLab_MVC.Models.DTOs.Token;
using EduLab_MVC.Services;
using EduLab_MVC.Services.ServiceInterfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.IdentityModel.Tokens.Jwt;
using System.Linq;
using System.Threading.Tasks;

namespace EduLab_MVC.Areas.Learner.Controllers
{
    /// <summary>
    /// Controller for handling authentication operations in the Learner area.
    /// </summary>
    [Area("Learner")]
    [AllowAnonymous]
    public class AuthController : Controller
    {
        private readonly IAuthService _authService;
        private readonly ILogger<AuthController> _logger;

        /// <summary>
        /// Initializes a new instance of the <see cref="AuthController"/> class.
        /// </summary>
        /// <param name="authService">The authentication service.</param>
        /// <param name="logger">The logger instance.</param>
        public AuthController(IAuthService authService, ILogger<AuthController> logger)
        {
            _authService = authService ?? throw new ArgumentNullException(nameof(authService));
            _logger = logger ?? throw new ArgumentNullException(nameof(logger));
        }

        #region Authentication Views

        /// <summary>
        /// Displays the login view.
        /// </summary>
        /// <returns>The login view.</returns>
        [HttpGet]
        public IActionResult Login() => View();

        /// <summary>
        /// Displays the registration view.
        /// </summary>
        /// <returns>The registration view.</returns>
        [HttpGet]
        public IActionResult Register() => View();

        #endregion

        #region Authentication Operations

        /// <summary>
        /// Handles user login.
        /// </summary>
        /// <param name="model">The login request data.</param>
        /// <returns>Redirect to home page on success, or login view with errors on failure.</returns>
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Login(LoginRequestDTO model)
        {
            try
            {
                _logger.LogInformation("Login attempt for email: {Email}", model?.Email);

                if (!ModelState.IsValid)
                {
                    _logger.LogWarning("Invalid model state for login");
                    return View(model);
                }

                var response = await _authService.Login(model);

                if (!string.IsNullOrWhiteSpace(response?.Token) && response.User != null)
                {
                    _logger.LogInformation("Login successful for email: {Email}", model.Email);

                    // Extract claims from JWT token
                    var handler = new JwtSecurityTokenHandler();
                    var jwtToken = handler.ReadJwtToken(response.Token);

                    var roleClaim = jwtToken.Claims.FirstOrDefault(c => c.Type == "role")?.Value ?? "";
                    var fullNameClaim = jwtToken.Claims.FirstOrDefault(c => c.Type == "UserFullName")?.Value ?? response.User.FullName ?? "";
                    var profileImage = response.User.ProfileImageUrl ?? "";

                    // Save tokens to cookies
                    _authService.SaveTokensToCookies(
                        response.Token,
                        response.RefreshToken,
                        response.RefreshTokenExpiry
                    );

                    // Set user information cookies
                    SetUserInfoCookies(fullNameClaim, roleClaim, profileImage);

                    // Store user information in session
                    SetUserSession(response.Token, fullNameClaim, roleClaim, profileImage);

                    TempData["SuccessMessage"] = "تم تسجيل الدخول بنجاح!";
                    _logger.LogInformation("User {FullName} logged in successfully", fullNameClaim);

                    return RedirectToAction("Index", "Home");
                }

                _logger.LogWarning("Login failed for email: {Email}", model.Email);
                TempData["ErrorMessage"] = "البريد الإلكتروني أو كلمة المرور غير صحيحة";
                return View(model);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Unexpected error during login for email: {Email}", model?.Email);
                TempData["ErrorMessage"] = "حدث خطأ أثناء محاولة تسجيل الدخول. يرجى المحاولة مرة أخرى.";
                return View(model);
            }
        }
        /// <summary>
        /// Displays the forgot password view
        /// </summary>
        /// <returns>The forgot password view</returns>
        [HttpGet]
        public IActionResult ForgotPassword() => View();

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> SendResetCode([FromBody] ForgotPasswordDTO dto)
        {
            try
            {
                _logger.LogInformation("Send reset code request for email: {Email}", dto?.Email);

                if (!ModelState.IsValid)
                {
                    var errors = ModelState.Values.SelectMany(v => v.Errors).Select(e => e.ErrorMessage).ToList();
                    _logger.LogWarning("Invalid model state for send reset code: {Errors}", string.Join(", ", errors));
                    return Json(new { isSuccess = false, errorMessages = errors });
                }

                var response = await _authService.ForgotPasswordAsync(dto);

                if (response.IsSuccess)
                {
                    _logger.LogInformation("Reset code sent successfully to email: {Email}", dto.Email);
                    return Json(new { isSuccess = true, message = "تم إرسال كود التحقق بنجاح" });
                }
                else
                {
                    var errors = response.ErrorMessages ?? new List<string>();
                    _logger.LogWarning("Failed to send reset code to email: {Email}: {Errors}", dto.Email, string.Join(", ", errors));
                    return Json(new { isSuccess = false, errorMessages = errors });
                }
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Unexpected error sending reset code to email: {Email}", dto?.Email);
                return Json(new { isSuccess = false, errorMessages = new List<string> { "حدث خطأ غير متوقع أثناء إرسال كود التحقق" } });
            }
        }


        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> VerifyResetCode([FromBody] VerifyEmailDTO dto)
        {
            try
            {
                _logger.LogInformation("Verify reset code for email: {Email}", dto?.Email);

                if (!ModelState.IsValid)
                {
                    var errors = ModelState.Values.SelectMany(v => v.Errors).Select(e => e.ErrorMessage).ToList();
                    _logger.LogWarning("Invalid model state for verify reset code: {Errors}", string.Join(", ", errors));
                    return Json(new { isSuccess = false, errorMessages = errors });
                }

                var response = await _authService.VerifyResetCodeAsync(dto);

                if (response.IsSuccess)
                {
                    _logger.LogInformation("Reset code verified successfully for email: {Email}", dto.Email);
                    return Json(new { isSuccess = true, message = "تم التحقق من الكود بنجاح" });
                }
                else
                {
                    var errors = response.ErrorMessages ?? new List<string>();
                    _logger.LogWarning("Reset code verification failed for email: {Email}: {Errors}", dto.Email, string.Join(", ", errors));
                    return Json(new { isSuccess = false, errorMessages = errors });
                }
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Unexpected error verifying reset code for email: {Email}", dto?.Email);
                return Json(new { isSuccess = false, errorMessages = new List<string> { "حدث خطأ غير متوقع أثناء التحقق من الكود" } });
            }
        }


        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> ResetPassword([FromBody] ResetPasswordDTO dto)
        {
            try
            {
                _logger.LogInformation("Reset password for email: {Email}", dto?.Email);

                if (!ModelState.IsValid)
                {
                    var errors = ModelState.Values.SelectMany(v => v.Errors).Select(e => e.ErrorMessage).ToList();
                    _logger.LogWarning("Invalid model state for reset password: {Errors}", string.Join(", ", errors));
                    return Json(new { isSuccess = false, errorMessages = errors });
                }

                var response = await _authService.ResetPasswordAsync(dto);

                if (response.IsSuccess)
                {
                    _logger.LogInformation("Password reset successful for email: {Email}", dto.Email);
                    return Json(new { isSuccess = true, message = "تم تغيير كلمة المرور بنجاح" });
                }
                else
                {
                    var errors = response.ErrorMessages ?? new List<string>();
                    _logger.LogWarning("Password reset failed for email: {Email}: {Errors}", dto.Email, string.Join(", ", errors));
                    return Json(new { isSuccess = false, errorMessages = errors });
                }
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Unexpected error resetting password for email: {Email}", dto?.Email);
                return Json(new { isSuccess = false, errorMessages = new List<string> { "حدث خطأ غير متوقع أثناء إعادة تعيين كلمة المرور" } });
            }
        }
        /// <summary>
        /// Refreshes the authentication token.
        /// </summary>
        /// <param name="request">The refresh token request data.</param>
        /// <returns>JSON response with new tokens or error message.</returns>
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> RefreshToken([FromBody] RefreshTokenRequestDTO request)
        {
            try
            {
                _logger.LogInformation("Refresh token request received");

                var result = await _authService.RefreshToken(request);
                if (result != null)
                {
                    _authService.SaveTokensToCookies(
                        result.AccessToken,
                        result.RefreshToken,
                        result.RefreshTokenExpiry
                    );

                    _logger.LogInformation("Token refreshed successfully");
                    return Json(new { success = true, accessToken = result.AccessToken });
                }

                _logger.LogWarning("Token refresh failed");
                return Json(new { success = false, error = "Failed to refresh token" });
            }
            catch (UnauthorizedAccessException ex)
            {
                _logger.LogWarning(ex, "Unauthorized access during token refresh");
                return Json(new { success = false, error = ex.Message });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Unexpected error during token refresh");
                return Json(new { success = false, error = "An error occurred" });
            }
        }

        /// <summary>
        /// Handles user registration.
        /// </summary>
        /// <param name="model">The registration request data.</param>
        /// <returns>JSON response indicating success or failure.</returns>
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Register([FromBody] RegisterRequestDTO model)
        {
            try
            {
                _logger.LogInformation("Registration attempt for email: {Email}", model?.Email);

                if (!ModelState.IsValid)
                {
                    var errors = ModelState.Values.SelectMany(v => v.Errors).Select(e => e.ErrorMessage).ToList();
                    _logger.LogWarning("Invalid model state for registration: {Errors}", string.Join(", ", errors));
                    return Json(new { isSuccess = false, errorMessages = errors });
                }

                var response = await _authService.Register(model);

                if (response.IsSuccess)
                {
                    _logger.LogInformation("Registration successful for email: {Email}", model.Email);
                    TempData["SuccessMessage"] = "تم إنشاء الحساب بنجاح! يرجى تسجيل الدخول";
                    return Json(new { isSuccess = true });
                }
                else
                {
                    var errors = response.ErrorMessages ?? new List<string>();
                    _logger.LogWarning("Registration failed for email: {Email}: {Errors}", model.Email, string.Join(", ", errors));
                    return Json(new { isSuccess = false, errorMessages = errors });
                }
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Unexpected error during registration for email: {Email}", model?.Email);
                return Json(new
                {
                    isSuccess = false,
                    errorMessages = new List<string> { "حدث خطأ غير متوقع أثناء التسجيل" }
                });
            }
        }

        #endregion

        #region Email Verification Operations

        /// <summary>
        /// Verifies an email address using a verification code.
        /// </summary>
        /// <param name="dto">The email verification data.</param>
        /// <returns>JSON response indicating success or failure.</returns>
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> VerifyEmail([FromBody] VerifyEmailDTO dto)
        {
            try
            {
                _logger.LogInformation("Email verification attempt for email: {Email}", dto?.Email);

                if (!ModelState.IsValid)
                {
                    _logger.LogWarning("Invalid model state for email verification");
                    return BadRequest(new { message = "البيانات المدخلة غير صحيحة" });
                }

                var response = await _authService.VerifyEmailCode(dto);

                if (response.IsSuccess)
                {
                    _logger.LogInformation("Email verification successful for email: {Email}", dto.Email);
                    return Ok(new { message = "تم تأكيد البريد الإلكتروني بنجاح" });
                }
                else
                {
                    var errorMessage = response.ErrorMessages?.FirstOrDefault() ?? "الكود غير صحيح";
                    _logger.LogWarning("Email verification failed for email: {Email}: {Error}", dto.Email, errorMessage);
                    return BadRequest(new { message = errorMessage });
                }
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Unexpected error during email verification for email: {Email}", dto?.Email);
                return BadRequest(new { message = "حدث خطأ أثناء التحقق من البريد الإلكتروني" });
            }
        }

        /// <summary>
        /// Sends a verification code to the specified email address.
        /// </summary>
        /// <param name="dto">The email address to send the code to.</param>
        /// <returns>JSON response indicating success or failure.</returns>
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> SendCode([FromBody] SendCodeDTO dto)
        {
            try
            {
                _logger.LogInformation("Send verification code request for email: {Email}", dto?.Email);

                var response = await _authService.SendVerificationCode(dto);
                return Json(response);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Unexpected error sending verification code to email: {Email}", dto?.Email);
                return BadRequest(new { message = "حدث خطأ أثناء إرسال كود التحقق" });
            }
        }

        #endregion

        #region External Authentication Operations

        /// <summary>
        /// Handles the callback from external authentication providers.
        /// </summary>
        /// <param name="email">The user's email address.</param>
        /// <param name="isNewUser">Indicates whether the user is new.</param>
        /// <returns>Redirect to confirmation page for new users, or home page for existing users.</returns>
        [HttpGet]
        public IActionResult ExternalLoginCallbackFromApi(string email, bool isNewUser)
        {
            try
            {
                _logger.LogInformation("External login callback received for email: {Email}, IsNewUser: {IsNewUser}", email, isNewUser);

                if (isNewUser)
                {
                    var model = new ExternalLoginConfirmationDto
                    {
                        Email = email
                    };
                    _logger.LogInformation("Redirecting new external user to confirmation page");
                    return View("ExternalLoginConfirmation", model);
                }

                TempData["Success"] = "تم تسجيل الدخول بنجاح.";
                _logger.LogInformation("External login successful for existing user: {Email}", email);
                return RedirectToAction("Index", "Home");
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Unexpected error during external login callback for email: {Email}", email);
                TempData["ErrorMessage"] = "حدث خطأ أثناء معالجة تسجيل الدخول";
                return RedirectToAction("Login");
            }
        }

        /// <summary>
        /// Confirms external user registration.
        /// </summary>
        /// <param name="model">The external login confirmation data.</param>
        /// <returns>Redirect to home page on success, or confirmation view with errors on failure.</returns>
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> ExternalLoginConfirmation(ExternalLoginConfirmationDto model)
        {
            try
            {
                _logger.LogInformation("External login confirmation for email: {Email}", model?.Email);

                if (!ModelState.IsValid)
                {
                    _logger.LogWarning("Invalid model state for external login confirmation");
                    return View(model);
                }

                var response = await _authService.ConfirmExternalUser(model);

                if (!response.IsSuccess)
                {
                    foreach (var error in response.ErrorMessages)
                    {
                        ModelState.AddModelError(string.Empty, error);
                    }
                    _logger.LogWarning("External login confirmation failed for email: {Email}", model.Email);
                    return View(model);
                }

                TempData["Success"] = "تم إنشاء الحساب بنجاح.";
                _logger.LogInformation("External login confirmation successful for email: {Email}", model.Email);
                return RedirectToAction("Index", "Home");
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Unexpected error during external login confirmation for email: {Email}", model?.Email);
                TempData["ErrorMessage"] = "حدث خطأ أثناء تأكيد الحساب";
                return View(model);
            }
        }

        #endregion

        #region Logout Operation

        /// <summary>
        /// Handles user logout.
        /// </summary>
        /// <returns>Redirect to home page.</returns>
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Logout()
        {
            try
            {
                _logger.LogInformation("Logout request received");

                var refreshToken = Request.Cookies["RefreshToken"];
                if (!string.IsNullOrEmpty(refreshToken))
                {
                    await _authService.RevokeToken(refreshToken);
                }

                ClearAuthenticationCookies();
                HttpContext.Session.Clear();

                _logger.LogInformation("User logged out successfully");
                TempData["SuccessMessage"] = "تم تسجيل الخروج بنجاح";

                return RedirectToAction("Index", "Home");
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Unexpected error during logout");
                TempData["ErrorMessage"] = "حدث خطأ أثناء تسجيل الخروج";
                return RedirectToAction("Index", "Home");
            }
        }

        #endregion

        #region Private Helper Methods

        /// <summary>
        /// Sets user information cookies.
        /// </summary>
        /// <param name="fullName">The user's full name.</param>
        /// <param name="role">The user's role.</param>
        /// <param name="profileImage">The user's profile image URL.</param>
        private void SetUserInfoCookies(string fullName, string role, string profileImage)
        {
            var cookieOptions = new CookieOptions
            {
                Expires = DateTime.UtcNow.AddDays(7),
                IsEssential = true,
                HttpOnly = false,
                Secure = true,
                SameSite = SameSiteMode.Strict
            };

            Response.Cookies.Append("UserFullName", fullName, cookieOptions);
            Response.Cookies.Append("UserRole", role, cookieOptions);
            Response.Cookies.Append("ProfileImageUrl", profileImage, cookieOptions);
        }

        /// <summary>
        /// Sets user information in session.
        /// </summary>
        /// <param name="token">The JWT token.</param>
        /// <param name="fullName">The user's full name.</param>
        /// <param name="role">The user's role.</param>
        /// <param name="profileImage">The user's profile image URL.</param>
        private void SetUserSession(string token, string fullName, string role, string profileImage)
        {
            HttpContext.Session.SetString("JWToken", token);
            HttpContext.Session.SetString("UserFullName", fullName);
            HttpContext.Session.SetString("UserRole", role);
            HttpContext.Session.SetString("ProfileImageUrl", profileImage);
        }

        /// <summary>
        /// Clears authentication cookies.
        /// </summary>
        private void ClearAuthenticationCookies()
        {
            var options = new CookieOptions
            {
                Path = "/",
                Expires = DateTimeOffset.UnixEpoch,
                Secure = true,
                SameSite = SameSiteMode.Strict
            };

            Response.Cookies.Delete("AuthToken", options);
            Response.Cookies.Delete("RefreshToken", options);
            Response.Cookies.Delete("RefreshTokenExpiry", options);
            Response.Cookies.Delete("UserFullName", options);
            Response.Cookies.Delete("UserRole", options);
            Response.Cookies.Delete("ProfileImageUrl", options);
        }

        #endregion
    }
}
using EduLab_MVC.Models.DTOs.Auth;
using EduLab_MVC.Models.DTOs.Token;
using EduLab_MVC.Models.Response;
using EduLab_MVC.Services.ServiceInterfaces;
using Microsoft.Extensions.Logging;
using System.IdentityModel.Tokens.Jwt;
using System.Net;
using System.Text.Json;

namespace EduLab_MVC.Services
{
    /// <summary>
    /// Service for handling authentication operations in the MVC application.
    /// Uses the unified ApiResponse{T} model.
    /// </summary>
    public class AuthService : IAuthService
    {
        private readonly IHttpClientFactory _clientFactory;
        private readonly IHttpContextAccessor _httpContextAccessor;
        private readonly ILogger<AuthService> _logger;

        /// <summary>
        /// Initializes a new instance of the <see cref="AuthService"/> class.
        /// </summary>
        public AuthService(
            IHttpClientFactory clientFactory,
            IHttpContextAccessor httpContextAccessor,
            ILogger<AuthService> logger)
        {
            _clientFactory = clientFactory ?? throw new ArgumentNullException(nameof(clientFactory));
            _httpContextAccessor = httpContextAccessor ?? throw new ArgumentNullException(nameof(httpContextAccessor));
            _logger = logger ?? throw new ArgumentNullException(nameof(logger));
        }

        #region Authentication Methods

        /// <summary>
        /// Authenticates a user with the provided credentials.
        /// </summary>
        public async Task<LoginResponseDTO> Login(LoginRequestDTO model)
        {
            try
            {
                if (model == null)
                    throw new ArgumentNullException(nameof(model));

                _logger.LogInformation("Login attempt for email: {Email}", model.Email);

                var client = _clientFactory.CreateClient("EduLabAPI");
                var response = await client.PostAsJsonAsync("Auth/Login", model);

                if (response.IsSuccessStatusCode)
                {
                    var apiResponse = await response.Content.ReadFromJsonAsync<ApiResponse<LoginResponseDTO>>();
                    if (apiResponse != null && apiResponse.IsSuccess)
                    {
                        _logger.LogInformation("Login successful for email: {Email}", model.Email);
                        return apiResponse.Data;
                    }
                }

                _logger.LogWarning("Login failed for email: {Email}, Status: {StatusCode}", model.Email, response.StatusCode);
                return null;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Unexpected error during login for email: {Email}", model?.Email);
                return null;
            }
        }

        /// <summary>
        /// Refreshes an access token using a valid refresh token.
        /// </summary>
        public async Task<TokenResponseDTO> RefreshToken(RefreshTokenRequestDTO request)
        {
            try
            {
                if (request == null)
                    throw new ArgumentNullException(nameof(request));

                _logger.LogInformation("Refresh token request received");

                var client = _clientFactory.CreateClient("EduLabAPI");
                var response = await client.PostAsJsonAsync("Auth/refresh", request);

                if (response.IsSuccessStatusCode)
                {
                    // ✅ قراءة ApiResponse
                    var apiResponse = await response.Content.ReadFromJsonAsync<ApiResponse<TokenResponseDTO>>();
                    if (apiResponse != null && apiResponse.IsSuccess)
                    {
                        _logger.LogInformation("Token refresh successful");
                        return apiResponse.Data;
                    }
                }

                if (response.StatusCode == HttpStatusCode.Unauthorized)
                {
                    _logger.LogWarning("Invalid refresh token");
                    throw new UnauthorizedAccessException("Refresh token غير صالح");
                }

                _logger.LogWarning("Token refresh failed with status: {StatusCode}", response.StatusCode);
                return null;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Unexpected error during token refresh");
                return null;
            }
        }

        /// <summary>
        /// Revokes a refresh token.
        /// </summary>
        public async Task<bool> RevokeToken(string refreshToken)
        {
            try
            {
                if (string.IsNullOrEmpty(refreshToken))
                    throw new ArgumentException("Refresh token cannot be null or empty.", nameof(refreshToken));

                _logger.LogInformation("Revoking refresh token");

                var client = _clientFactory.CreateClient("EduLabAPI");
                var response = await client.PostAsJsonAsync("Auth/revoke", refreshToken);

                if (response.IsSuccessStatusCode)
                {
                    // ✅ قراءة ApiResponse (حتى لو البيانات null)
                    var apiResponse = await response.Content.ReadFromJsonAsync<ApiResponse<object>>();
                    var success = apiResponse != null && apiResponse.IsSuccess;
                    if (success)
                        _logger.LogInformation("Refresh token revoked successfully");
                    else
                        _logger.LogWarning("Refresh token revocation reported failure from API");
                    return success;
                }

                _logger.LogWarning("Refresh token revocation failed with status: {StatusCode}", response.StatusCode);
                return false;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Unexpected error during token revocation");
                return false;
            }
        }

        /// <summary>
        /// Initiates the forgot password process.
        /// </summary>
        public async Task<ApiResponse<object>> ForgotPasswordAsync(ForgotPasswordDTO dto)
        {
            try
            {
                if (dto == null)
                    throw new ArgumentNullException(nameof(dto));

                _logger.LogInformation("Forgot password request for email: {Email}", dto.Email);

                var client = _clientFactory.CreateClient("EduLabAPI");
                var response = await client.PostAsJsonAsync("Auth/forgot-password", dto);

                if (response.IsSuccessStatusCode)
                {
                    _logger.LogInformation("Forgot password request successful for email: {Email}", dto.Email);
                    var result = await response.Content.ReadFromJsonAsync<ApiResponse<object>>();
                    return result ?? ApiResponse<object>.SuccessResponse(null, "Request processed");
                }
                else
                {
                    var errorContent = await response.Content.ReadAsStringAsync();
                    _logger.LogWarning("Forgot password request failed for email: {Email}, Status: {StatusCode}, Response: {Response}",
                        dto.Email, response.StatusCode, errorContent);

                    try
                    {
                        var apiResponse = await response.Content.ReadFromJsonAsync<ApiResponse<object>>();
                        return apiResponse ?? ApiResponse<object>.FailResponse("حدث خطأ أثناء معالجة طلب استعادة كلمة المرور");
                    }
                    catch
                    {
                        return ApiResponse<object>.FailResponse("حدث خطأ أثناء معالجة طلب استعادة كلمة المرور");
                    }
                }
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Unexpected error during forgot password for email: {Email}", dto?.Email);
                return ApiResponse<object>.FailResponse("حدث خطأ غير متوقع أثناء معالجة طلبك", new List<string> { ex.Message });
            }
        }

        /// <summary>
        /// Verifies the password reset code.
        /// </summary>
        public async Task<ApiResponse<object>> VerifyResetCodeAsync(VerifyEmailDTO dto)
        {
            try
            {
                if (dto == null)
                    throw new ArgumentNullException(nameof(dto));

                _logger.LogInformation("Reset code verification for email: {Email}", dto.Email);

                var client = _clientFactory.CreateClient("EduLabAPI");
                var response = await client.PostAsJsonAsync("Auth/verify-reset-code", dto);

                if (response.IsSuccessStatusCode)
                {
                    _logger.LogInformation("Reset code verification successful for email: {Email}", dto.Email);
                    var result = await response.Content.ReadFromJsonAsync<ApiResponse<object>>();
                    return result ?? ApiResponse<object>.SuccessResponse(null, "Code verified");
                }
                else
                {
                    var errorContent = await response.Content.ReadFromJsonAsync<ApiResponse<object>>();
                    _logger.LogWarning("Reset code verification failed for email: {Email}, Status: {StatusCode}", dto.Email, response.StatusCode);
                    return errorContent ?? ApiResponse<object>.FailResponse("فشل التحقق من الكود");
                }
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Unexpected error during reset code verification for email: {Email}", dto?.Email);
                return ApiResponse<object>.FailResponse("حدث خطأ غير متوقع أثناء التحقق من الكود", new List<string> { ex.Message });
            }
        }

        /// <summary>
        /// Resets the user's password.
        /// </summary>
        public async Task<ApiResponse<object>> ResetPasswordAsync(ResetPasswordDTO dto)
        {
            try
            {
                if (dto == null)
                    throw new ArgumentNullException(nameof(dto));

                _logger.LogInformation("Password reset for email: {Email}", dto.Email);

                var client = _clientFactory.CreateClient("EduLabAPI");
                var response = await client.PostAsJsonAsync("Auth/reset-password", dto);

                if (response.IsSuccessStatusCode)
                {
                    _logger.LogInformation("Password reset successful for email: {Email}", dto.Email);
                    var result = await response.Content.ReadFromJsonAsync<ApiResponse<object>>();
                    return result ?? ApiResponse<object>.SuccessResponse(null, "Password reset successfully");
                }
                else
                {
                    var errorContent = await response.Content.ReadAsStringAsync();
                    _logger.LogWarning("Password reset failed for email: {Email}, Status: {StatusCode}, Response: {Response}",
                        dto.Email, response.StatusCode, errorContent);

                    try
                    {
                        var apiResponse = await response.Content.ReadFromJsonAsync<ApiResponse<object>>();
                        return apiResponse ?? ApiResponse<object>.FailResponse("حدث خطأ أثناء إعادة تعيين كلمة المرور");
                    }
                    catch
                    {
                        return ApiResponse<object>.FailResponse("حدث خطأ أثناء إعادة تعيين كلمة المرور");
                    }
                }
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Unexpected error during password reset for email: {Email}", dto?.Email);
                return ApiResponse<object>.FailResponse("حدث خطأ غير متوقع أثناء إعادة تعيين كلمة المرور", new List<string> { ex.Message });
            }
        }

        #endregion

        #region Token Management Methods

        /// <summary>
        /// Checks if a JWT token is expired.
        /// </summary>
        public bool IsTokenExpired(string token)
        {
            try
            {
                if (string.IsNullOrEmpty(token))
                    return true;

                var handler = new JwtSecurityTokenHandler();
                var jwtToken = handler.ReadJwtToken(token);
                var isExpired = jwtToken.ValidTo < DateTime.UtcNow;

                _logger.LogDebug("Token expiration check: {IsExpired}", isExpired);

                return isExpired;
            }
            catch (Exception ex)
            {
                _logger.LogWarning(ex, "Error checking token expiration");
                return true;
            }
        }

        /// <summary>
        /// Retrieves the refresh token from cookies.
        /// </summary>
        public string GetRefreshTokenFromCookies()
        {
            try
            {
                var refreshToken = _httpContextAccessor.HttpContext?.Request.Cookies["RefreshToken"];

                if (string.IsNullOrEmpty(refreshToken))
                    _logger.LogDebug("Refresh token not found in cookies");
                else
                    _logger.LogDebug("Refresh token retrieved from cookies");

                return refreshToken;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error retrieving refresh token from cookies");
                return null;
            }
        }

        /// <summary>
        /// Saves authentication tokens to cookies.
        /// </summary>
        public void SaveTokensToCookies(string accessToken, string refreshToken, DateTime refreshTokenExpiry)
        {
            try
            {
                var httpContext = _httpContextAccessor.HttpContext;
                if (httpContext == null)
                {
                    _logger.LogWarning("HTTP context is null, cannot save tokens to cookies");
                    return;
                }

                var cookieOptions = new CookieOptions
                {
                    HttpOnly = true,
                    Secure = true,
                    SameSite = SameSiteMode.Strict,
                    Expires = refreshTokenExpiry
                };

                httpContext.Response.Cookies.Append("AuthToken", accessToken, cookieOptions);
                httpContext.Response.Cookies.Append("RefreshToken", refreshToken, cookieOptions);
                httpContext.Response.Cookies.Append("RefreshTokenExpiry", refreshTokenExpiry.ToString("o"), cookieOptions);

                _logger.LogInformation("Tokens saved to cookies successfully");
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error saving tokens to cookies");
            }
        }

        #endregion

        #region Registration Methods

        /// <summary>
        /// Registers a new user.
        /// </summary>
        public async Task<ApiResponse<object>> Register(RegisterRequestDTO model)
        {
            try
            {
                if (model == null)
                    throw new ArgumentNullException(nameof(model));

                _logger.LogInformation("Registration attempt for email: {Email}", model.Email);

                var client = _clientFactory.CreateClient("EduLabAPI");
                var response = await client.PostAsJsonAsync("Auth/Register", model);

                if (response.IsSuccessStatusCode)
                {
                    var content = await response.Content.ReadFromJsonAsync<ApiResponse<object>>();
                    _logger.LogInformation("Registration successful for email: {Email}", model.Email);
                    return content ?? ApiResponse<object>.SuccessResponse(null, "Registration successful");
                }
                else
                {
                    var errorContent = await response.Content.ReadFromJsonAsync<ApiResponse<object>>();
                    _logger.LogWarning("Registration failed for email: {Email}, Status: {StatusCode}", model.Email, response.StatusCode);
                    return errorContent ?? ApiResponse<object>.FailResponse("حدث خطأ أثناء التسجيل.");
                }
            }
            catch (ArgumentNullException ex)
            {
                _logger.LogError(ex, "Null argument in Register method");
                throw;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Unexpected error during registration for email: {Email}", model?.Email);
                return ApiResponse<object>.FailResponse("حدث خطأ غير متوقع أثناء التسجيل.", new List<string> { ex.Message });
            }
        }

        #endregion

        #region Email Verification Methods

        /// <summary>
        /// Verifies an email address using a verification code.
        /// </summary>
        public async Task<ApiResponse<object>> VerifyEmailCode(VerifyEmailDTO dto)
        {
            try
            {
                if (dto == null)
                    throw new ArgumentNullException(nameof(dto));

                _logger.LogInformation("Email verification attempt for email: {Email}", dto.Email);

                var client = _clientFactory.CreateClient("EduLabAPI");
                var response = await client.PostAsJsonAsync("Auth/verify-email", dto);

                if (response.IsSuccessStatusCode)
                {
                    _logger.LogInformation("Email verification successful for email: {Email}", dto.Email);
                    var result = await response.Content.ReadFromJsonAsync<ApiResponse<object>>();
                    return result ?? ApiResponse<object>.SuccessResponse(null, "Email verified");
                }
                else
                {
                    var errorContent = await response.Content.ReadFromJsonAsync<ApiResponse<object>>();
                    _logger.LogWarning("Email verification failed for email: {Email}, Status: {StatusCode}", dto.Email, response.StatusCode);
                    return errorContent ?? ApiResponse<object>.FailResponse("فشل التحقق من الكود");
                }
            }
            catch (ArgumentNullException ex)
            {
                _logger.LogError(ex, "Null argument in VerifyEmailCode method");
                throw;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Unexpected error during email verification for email: {Email}", dto?.Email);
                return ApiResponse<object>.FailResponse("حدث خطأ غير متوقع أثناء التحقق من البريد الإلكتروني.", new List<string> { ex.Message });
            }
        }

        /// <summary>
        /// Sends a verification code to the specified email address.
        /// </summary>
        public async Task<ApiResponse<object>> SendVerificationCode(SendCodeDTO dto)
        {
            try
            {
                if (dto == null)
                    throw new ArgumentNullException(nameof(dto));

                _logger.LogInformation("Sending verification code to email: {Email}", dto.Email);

                var client = _clientFactory.CreateClient("EduLabAPI");
                var response = await client.PostAsJsonAsync("Auth/send-code", dto);

                if (response.IsSuccessStatusCode)
                {
                    _logger.LogInformation("Verification code sent successfully to email: {Email}", dto.Email);
                    var result = await response.Content.ReadFromJsonAsync<ApiResponse<object>>();
                    return result ?? ApiResponse<object>.SuccessResponse(null, "Code sent");
                }
                else
                {
                    var errorContent = await response.Content.ReadFromJsonAsync<ApiResponse<object>>();
                    _logger.LogWarning("Failed to send verification code to email: {Email}, Status: {StatusCode}", dto.Email, response.StatusCode);
                    return errorContent ?? ApiResponse<object>.FailResponse("فشل في إعادة إرسال الكود");
                }
            }
            catch (ArgumentNullException ex)
            {
                _logger.LogError(ex, "Null argument in SendVerificationCode method");
                throw;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Unexpected error sending verification code to email: {Email}", dto?.Email);
                return ApiResponse<object>.FailResponse("حدث خطأ غير متوقع أثناء إرسال كود التحقق.", new List<string> { ex.Message });
            }
        }

        #endregion

        #region External Authentication Methods

        /// <summary>
        /// Handles the callback from external authentication providers.
        /// </summary>
        public async Task<ExternalLoginCallbackResultDTO> HandleExternalLoginCallback(string returnUrl, string remoteError)
        {
            try
            {
                _logger.LogInformation("Handling external login callback, ReturnUrl: {ReturnUrl}", returnUrl);

                var client = _clientFactory.CreateClient("EduLabAPI");

                var safeReturnUrl = Uri.EscapeDataString(returnUrl ?? "");
                var safeRemoteError = Uri.EscapeDataString(remoteError ?? "");

                var url = $"Auth/ExternalLoginCallback?returnUrl={safeReturnUrl}&remoteError={safeRemoteError}";
                var response = await client.GetAsync(url);

                if (response.IsSuccessStatusCode)
                {
                    _logger.LogInformation("External login callback handled successfully");
                    return await response.Content.ReadFromJsonAsync<ExternalLoginCallbackResultDTO>();
                }

                _logger.LogWarning("External login callback failed with status: {StatusCode}", response.StatusCode);
                return null;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Unexpected error handling external login callback");
                return null;
            }
        }

        /// <summary>
        /// Confirms and completes external user registration.
        /// </summary>
        public async Task<ApiResponse<object>> ConfirmExternalUser(ExternalLoginConfirmationDto model)
        {
            try
            {
                if (model == null)
                    throw new ArgumentNullException(nameof(model));

                _logger.LogInformation("Confirming external user registration for email: {Email}", model.Email);

                var client = _clientFactory.CreateClient("EduLabAPI");
                var response = await client.PostAsJsonAsync("Auth/ExternalLoginConfirmation", model);

                if (response.IsSuccessStatusCode)
                {
                    _logger.LogInformation("External user confirmation successful for email: {Email}", model.Email);
                    var result = await response.Content.ReadFromJsonAsync<ApiResponse<object>>();
                    return result ?? ApiResponse<object>.SuccessResponse(null, "External user confirmed");
                }

                var error = await response.Content.ReadFromJsonAsync<ApiResponse<object>>();
                _logger.LogWarning("External user confirmation failed for email: {Email}, Status: {StatusCode}", model.Email, response.StatusCode);

                return error ?? ApiResponse<object>.FailResponse("حدث خطأ أثناء تأكيد المستخدم الخارجي");
            }
            catch (ArgumentNullException ex)
            {
                _logger.LogError(ex, "Null argument in ConfirmExternalUser method");
                throw;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Unexpected error confirming external user for email: {Email}", model?.Email);
                return ApiResponse<object>.FailResponse("حدث خطأ غير متوقع أثناء تأكيد المستخدم الخارجي.", new List<string> { ex.Message });
            }
        }

        #endregion
    }
}
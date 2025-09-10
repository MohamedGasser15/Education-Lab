using EduLab_Domain.Entities;
using EduLab_MVC.Models.DTOs.Auth;
using EduLab_MVC.Models.DTOs.Token;
using EduLab_MVC.Services.ServiceInterfaces;
using Microsoft.Extensions.Logging;
using System.IdentityModel.Tokens.Jwt;
using System.Net;

namespace EduLab_MVC.Services
{
    /// <summary>
    /// Service for handling authentication operations in the MVC application.
    /// </summary>
    public class AuthService : IAuthService
    {
        private readonly IHttpClientFactory _clientFactory;
        private readonly IHttpContextAccessor _httpContextAccessor;
        private readonly ILogger<AuthService> _logger;

        /// <summary>
        /// Initializes a new instance of the <see cref="AuthService"/> class.
        /// </summary>
        /// <param name="clientFactory">The HTTP client factory.</param>
        /// <param name="httpContextAccessor">The HTTP context accessor.</param>
        /// <param name="logger">The logger instance.</param>
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
        /// <param name="model">The login request data.</param>
        /// <returns>Login response containing tokens and user information.</returns>
        /// <exception cref="ArgumentNullException">Thrown when model is null.</exception>
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
                    _logger.LogInformation("Login successful for email: {Email}", model.Email);
                    return await response.Content.ReadFromJsonAsync<LoginResponseDTO>();
                }

                _logger.LogWarning("Login failed for email: {Email}, Status: {StatusCode}", model.Email, response.StatusCode);
                return null;
            }
            catch (ArgumentNullException ex)
            {
                _logger.LogError(ex, "Null argument in Login method");
                throw;
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
        /// <param name="request">The refresh token request data.</param>
        /// <returns>New access and refresh tokens.</returns>
        /// <exception cref="ArgumentNullException">Thrown when request is null.</exception>
        /// <exception cref="UnauthorizedAccessException">Thrown when refresh token is invalid.</exception>
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
                    _logger.LogInformation("Token refresh successful");
                    return await response.Content.ReadFromJsonAsync<TokenResponseDTO>();
                }
                else if (response.StatusCode == HttpStatusCode.Unauthorized)
                {
                    _logger.LogWarning("Invalid refresh token");
                    throw new UnauthorizedAccessException("Refresh token غير صالح");
                }

                _logger.LogWarning("Token refresh failed with status: {StatusCode}", response.StatusCode);
                return null;
            }
            catch (ArgumentNullException ex)
            {
                _logger.LogError(ex, "Null argument in RefreshToken method");
                throw;
            }
            catch (UnauthorizedAccessException ex)
            {
                _logger.LogWarning(ex, "Unauthorized access during token refresh");
                throw;
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
        /// <param name="refreshToken">The refresh token to revoke.</param>
        /// <returns>True if revocation was successful; otherwise, false.</returns>
        /// <exception cref="ArgumentException">Thrown when refresh token is null or empty.</exception>
        public async Task<bool> RevokeToken(string refreshToken)
        {
            try
            {
                if (string.IsNullOrEmpty(refreshToken))
                    throw new ArgumentException("Refresh token cannot be null or empty.", nameof(refreshToken));

                _logger.LogInformation("Revoking refresh token");

                var client = _clientFactory.CreateClient("EduLabAPI");
                var response = await client.PostAsJsonAsync("Auth/revoke", refreshToken);

                var success = response.IsSuccessStatusCode;

                if (success)
                    _logger.LogInformation("Refresh token revoked successfully");
                else
                    _logger.LogWarning("Refresh token revocation failed with status: {StatusCode}", response.StatusCode);

                return success;
            }
            catch (ArgumentException ex)
            {
                _logger.LogError(ex, "Invalid argument in RevokeToken method");
                throw;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Unexpected error during token revocation");
                return false;
            }
        }

        #endregion

        #region Token Management Methods

        /// <summary>
        /// Checks if a JWT token is expired.
        /// </summary>
        /// <param name="token">The JWT token to check.</param>
        /// <returns>True if the token is expired; otherwise, false.</returns>
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
        /// <returns>The refresh token if found; otherwise, null.</returns>
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
        /// <param name="accessToken">The access token.</param>
        /// <param name="refreshToken">The refresh token.</param>
        /// <param name="refreshTokenExpiry">The expiration date of the refresh token.</param>
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
        /// <param name="model">The registration request data.</param>
        /// <returns>API response indicating success or failure.</returns>
        /// <exception cref="ArgumentNullException">Thrown when model is null.</exception>
        public async Task<APIResponse> Register(RegisterRequestDTO model)
        {
            try
            {
                if (model == null)
                    throw new ArgumentNullException(nameof(model));

                _logger.LogInformation("Registration attempt for email: {Email}", model.Email);

                var client = _clientFactory.CreateClient("EduLabAPI");
                var response = await client.PostAsJsonAsync("Auth/Register", model);

                var apiResponse = new APIResponse();

                if (response.IsSuccessStatusCode)
                {
                    var content = await response.Content.ReadFromJsonAsync<APIResponse>();
                    _logger.LogInformation("Registration successful for email: {Email}", model.Email);
                    return content;
                }
                else
                {
                    var errorContent = await response.Content.ReadFromJsonAsync<APIResponse>();
                    _logger.LogWarning("Registration failed for email: {Email}, Status: {StatusCode}", model.Email, response.StatusCode);
                    return errorContent ?? new APIResponse
                    {
                        IsSuccess = false,
                        ErrorMessages = new List<string> { "حدث خطأ أثناء التسجيل." },
                        StatusCode = response.StatusCode
                    };
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
                return new APIResponse
                {
                    IsSuccess = false,
                    ErrorMessages = new List<string> { "حدث خطأ غير متوقع أثناء التسجيل." },
                    StatusCode = HttpStatusCode.InternalServerError
                };
            }
        }

        #endregion

        #region Email Verification Methods

        /// <summary>
        /// Verifies an email address using a verification code.
        /// </summary>
        /// <param name="dto">The email verification data.</param>
        /// <returns>API response indicating success or failure.</returns>
        /// <exception cref="ArgumentNullException">Thrown when DTO is null.</exception>
        public async Task<APIResponse> VerifyEmailCode(VerifyEmailDTO dto)
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
                    return await response.Content.ReadFromJsonAsync<APIResponse>();
                }
                else
                {
                    var errorContent = await response.Content.ReadFromJsonAsync<APIResponse>();
                    _logger.LogWarning("Email verification failed for email: {Email}, Status: {StatusCode}", dto.Email, response.StatusCode);
                    return errorContent ?? new APIResponse
                    {
                        IsSuccess = false,
                        ErrorMessages = new List<string> { "فشل التحقق من الكود" },
                        StatusCode = response.StatusCode
                    };
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
                return new APIResponse
                {
                    IsSuccess = false,
                    ErrorMessages = new List<string> { "حدث خطأ غير متوقع أثناء التحقق من البريد الإلكتروني." },
                    StatusCode = HttpStatusCode.InternalServerError
                };
            }
        }

        /// <summary>
        /// Sends a verification code to the specified email address.
        /// </summary>
        /// <param name="dto">The email address to send the code to.</param>
        /// <returns>API response indicating success or failure.</returns>
        /// <exception cref="ArgumentNullException">Thrown when DTO is null.</exception>
        public async Task<APIResponse> SendVerificationCode(SendCodeDTO dto)
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
                    return await response.Content.ReadFromJsonAsync<APIResponse>();
                }
                else
                {
                    var errorContent = await response.Content.ReadFromJsonAsync<APIResponse>();
                    _logger.LogWarning("Failed to send verification code to email: {Email}, Status: {StatusCode}", dto.Email, response.StatusCode);
                    return errorContent ?? new APIResponse
                    {
                        IsSuccess = false,
                        ErrorMessages = new List<string> { "فشل في إعادة إرسال الكود" },
                        StatusCode = response.StatusCode
                    };
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
                return new APIResponse
                {
                    IsSuccess = false,
                    ErrorMessages = new List<string> { "حدث خطأ غير متوقع أثناء إرسال كود التحقق." },
                    StatusCode = HttpStatusCode.InternalServerError
                };
            }
        }

        #endregion

        #region External Authentication Methods

        /// <summary>
        /// Handles the callback from external authentication providers.
        /// </summary>
        /// <param name="returnUrl">The URL to return to after processing.</param>
        /// <param name="remoteError">Error message from the external provider, if any.</param>
        /// <returns>External login callback result.</returns>
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
        /// <param name="model">The external login confirmation data.</param>
        /// <returns>API response indicating success or failure.</returns>
        /// <exception cref="ArgumentNullException">Thrown when model is null.</exception>
        public async Task<APIResponse> ConfirmExternalUser(ExternalLoginConfirmationDto model)
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
                    return new APIResponse { IsSuccess = true };
                }

                var error = await response.Content.ReadFromJsonAsync<APIResponse>();
                _logger.LogWarning("External user confirmation failed for email: {Email}, Status: {StatusCode}", model.Email, response.StatusCode);

                return error ?? new APIResponse
                {
                    IsSuccess = false,
                    ErrorMessages = new List<string> { "حدث خطأ أثناء تأكيد المستخدم الخارجي" }
                };
            }
            catch (ArgumentNullException ex)
            {
                _logger.LogError(ex, "Null argument in ConfirmExternalUser method");
                throw;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Unexpected error confirming external user for email: {Email}", model?.Email);
                return new APIResponse
                {
                    IsSuccess = false,
                    ErrorMessages = new List<string> { "حدث خطأ غير متوقع أثناء تأكيد المستخدم الخارجي." }
                };
            }
        }

        #endregion
    }
}
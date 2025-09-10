using EduLab_MVC.Models.DTOs.Token;
using EduLab_MVC.Services;
using EduLab_MVC.Services.ServiceInterfaces;
using Microsoft.Extensions.Logging;
using System;
using System.Threading.Tasks;

namespace EduLab_MVC.Middlewares
{
    /// <summary>
    /// Middleware for automatically refreshing JWT tokens when they expire.
    /// </summary>
    public class TokenRefreshMiddleware
    {
        private readonly RequestDelegate _next;
        private readonly ILogger<TokenRefreshMiddleware> _logger;

        /// <summary>
        /// Initializes a new instance of the <see cref="TokenRefreshMiddleware"/> class.
        /// </summary>
        /// <param name="next">The next middleware in the pipeline.</param>
        /// <param name="logger">The logger instance.</param>
        public TokenRefreshMiddleware(RequestDelegate next, ILogger<TokenRefreshMiddleware> logger)
        {
            _next = next ?? throw new ArgumentNullException(nameof(next));
            _logger = logger ?? throw new ArgumentNullException(nameof(logger));
        }

        /// <summary>
        /// Processes the HTTP request and handles token refresh logic.
        /// </summary>
        /// <param name="context">The HTTP context.</param>
        /// <param name="authService">The authentication service.</param>
        /// <returns>A task representing the asynchronous operation.</returns>
        public async Task InvokeAsync(HttpContext context, IAuthService authService)
        {
            try
            {
                var accessToken = context.Request.Cookies["AuthToken"];
                var refreshToken = context.Request.Cookies["RefreshToken"];

                if (!string.IsNullOrEmpty(accessToken) && !string.IsNullOrEmpty(refreshToken))
                {
                    _logger.LogDebug("Checking token expiration for access token");

                    if (authService.IsTokenExpired(accessToken))
                    {
                        _logger.LogInformation("Access token expired, attempting refresh");

                        try
                        {
                            var refreshRequest = new RefreshTokenRequestDTO
                            {
                                AccessToken = accessToken,
                                RefreshToken = refreshToken
                            };

                            var newTokens = await authService.RefreshToken(refreshRequest);

                            if (newTokens != null)
                            {
                                authService.SaveTokensToCookies(
                                    newTokens.AccessToken,
                                    newTokens.RefreshToken,
                                    newTokens.RefreshTokenExpiry
                                );

                                _logger.LogInformation("Token refreshed successfully");
                            }
                            else
                            {
                                _logger.LogWarning("Token refresh failed, logging out user");
                                await LogoutUser(context, authService);
                                return; // Stop further processing if logout occurred
                            }
                        }
                        catch (UnauthorizedAccessException ex)
                        {
                            _logger.LogWarning(ex, "Invalid refresh token, logging out user");
                            await LogoutUser(context, authService);
                            return; // Stop further processing if logout occurred
                        }
                        catch (Exception ex)
                        {
                            _logger.LogError(ex, "Error occurred while attempting token refresh");
                            // Continue with the request despite refresh error
                        }
                    }
                    else
                    {
                        _logger.LogDebug("Access token is still valid");
                    }
                }
                else
                {
                    _logger.LogDebug("No tokens found in cookies");
                }
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Unexpected error in TokenRefreshMiddleware");
                // Continue with the request despite middleware error
            }

            await _next(context);
        }

        /// <summary>
        /// Logs out the user by revoking tokens and clearing cookies/session.
        /// </summary>
        /// <param name="context">The HTTP context.</param>
        /// <param name="authService">The authentication service.</param>
        /// <returns>A task representing the asynchronous operation.</returns>
        private async Task LogoutUser(HttpContext context, IAuthService authService)
        {
            try
            {
                _logger.LogInformation("Initiating user logout");

                // Attempt to revoke the refresh token
                try
                {
                    var refreshToken = context.Request.Cookies["RefreshToken"];
                    if (!string.IsNullOrEmpty(refreshToken))
                    {
                        await authService.RevokeToken(refreshToken);
                        _logger.LogInformation("Refresh token revoked successfully");
                    }
                }
                catch (Exception ex)
                {
                    _logger.LogError(ex, "Error revoking refresh token during logout");
                }

                // Clear authentication cookies
                ClearAuthenticationCookies(context);

                // Clear session
                context.Session.Clear();
                _logger.LogInformation("User session cleared");

                // Redirect to login page if not already there
                if (!context.Request.Path.StartsWithSegments("/Learner/Auth/Login") &&
                    !context.Request.Path.StartsWithSegments("/Account/Login"))
                {
                    _logger.LogInformation("Redirecting to login page");
                    context.Response.Redirect("/Learner/Auth/Login");
                }
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error during user logout process");
            }
        }

        /// <summary>
        /// Clears all authentication-related cookies.
        /// </summary>
        /// <param name="context">The HTTP context.</param>
        private void ClearAuthenticationCookies(HttpContext context)
        {
            try
            {
                var cookieOptions = new CookieOptions
                {
                    Path = "/",
                    Expires = DateTimeOffset.UnixEpoch,
                    Secure = true,
                    SameSite = SameSiteMode.Strict
                };

                context.Response.Cookies.Delete("AuthToken", cookieOptions);
                context.Response.Cookies.Delete("RefreshToken", cookieOptions);
                context.Response.Cookies.Delete("RefreshTokenExpiry", cookieOptions);
                context.Response.Cookies.Delete("UserFullName", cookieOptions);
                context.Response.Cookies.Delete("UserRole", cookieOptions);
                context.Response.Cookies.Delete("ProfileImageUrl", cookieOptions);

                _logger.LogInformation("Authentication cookies cleared");
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error clearing authentication cookies");
            }
        }
    }
}
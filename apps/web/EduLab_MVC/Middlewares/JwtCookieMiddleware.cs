using Microsoft.Extensions.Logging;
using System;
using System.IdentityModel.Tokens.Jwt;
using System.Linq;
using System.Security.Claims;
using System.Threading.Tasks;

namespace EduLab_MVC.Middlewares
{
    /// <summary>
    /// Middleware for extracting JWT tokens from cookies and setting the user principal.
    /// </summary>
    public class JwtCookieMiddleware
    {
        private readonly RequestDelegate _next;
        private readonly ILogger<JwtCookieMiddleware> _logger;

        /// <summary>
        /// Initializes a new instance of the <see cref="JwtCookieMiddleware"/> class.
        /// </summary>
        /// <param name="next">The next middleware in the pipeline.</param>
        /// <param name="logger">The logger instance.</param>
        public JwtCookieMiddleware(RequestDelegate next, ILogger<JwtCookieMiddleware> logger)
        {
            _next = next ?? throw new ArgumentNullException(nameof(next));
            _logger = logger ?? throw new ArgumentNullException(nameof(logger));
        }

        /// <summary>
        /// Processes the HTTP request and extracts JWT token from cookies.
        /// </summary>
        /// <param name="context">The HTTP context.</param>
        /// <returns>A task representing the asynchronous operation.</returns>
        public async Task InvokeAsync(HttpContext context)
        {
            try
            {
                var token = context.Request.Cookies["AuthToken"];

                if (!string.IsNullOrEmpty(token))
                {
                    _logger.LogDebug("JWT token found in cookies, attempting to process");

                    try
                    {
                        var handler = new JwtSecurityTokenHandler();

                        // Basic validation before reading the token
                        if (handler.CanReadToken(token))
                        {
                            var jwtToken = handler.ReadJwtToken(token);

                            // Validate token expiration
                            if (jwtToken.ValidTo >= DateTime.UtcNow)
                            {
                                var claims = jwtToken.Claims.ToList();

                                var identity = new ClaimsIdentity(
                                    claims,
                                    "jwt-cookie",
                                    ClaimTypes.Name,
                                    "role"
                                );

                                var principal = new ClaimsPrincipal(identity);
                                context.User = principal;

                                _logger.LogDebug("JWT token processed successfully, user principal set");
                            }
                            else
                            {
                                _logger.LogWarning("JWT token has expired");
                                context.Response.Cookies.Delete("AuthToken");
                            }
                        }
                        else
                        {
                            _logger.LogWarning("Invalid JWT token format");
                            context.Response.Cookies.Delete("AuthToken");
                        }
                    }
                    catch (ArgumentException ex)
                    {
                        _logger.LogWarning(ex, "Malformed JWT token in cookies");
                        context.Response.Cookies.Delete("AuthToken");
                    }
                    catch (Exception ex)
                    {
                        _logger.LogError(ex, "Error processing JWT token from cookies");
                        context.Response.Cookies.Delete("AuthToken");
                    }
                }
                else
                {
                    _logger.LogDebug("No JWT token found in cookies");
                }
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Unexpected error in JwtCookieMiddleware");
                // Continue with the request despite middleware error
            }

            await _next(context);
        }
    }
}
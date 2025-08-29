using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;

namespace EduLab_MVC.Middlewares
{
    public class JwtCookieMiddleware
    {
        private readonly RequestDelegate _next;
        private readonly ILogger<JwtCookieMiddleware> _logger;

        public JwtCookieMiddleware(RequestDelegate next, ILogger<JwtCookieMiddleware> logger)
        {
            _next = next;
            _logger = logger;
        }

        public async Task InvokeAsync(HttpContext context)
        {
            var token = context.Request.Cookies["AuthToken"];
            if (!string.IsNullOrEmpty(token))
            {
                try
                {
                    var handler = new JwtSecurityTokenHandler();
                    var jwtToken = handler.ReadJwtToken(token);

                    var claims = jwtToken.Claims.ToList();

                    var identity = new ClaimsIdentity(
                        claims,
                        "jwt-cookie",
                        ClaimTypes.Name,
                        "role"
                    );

                    var principal = new ClaimsPrincipal(identity);
                    context.User = principal;
                }
                catch (Exception ex)
                {
                    _logger.LogWarning(ex, "فشل قراءة أو معالجة الـ JWT Token من الكوكيز.");
                    context.Response.Cookies.Delete("AuthToken");
                }
            }

            await _next(context);
        }
    }
}

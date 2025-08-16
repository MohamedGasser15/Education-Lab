using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;

namespace EduLab_MVC.Middlewares
{
    public class JwtCookieMiddleware
    {
        private readonly RequestDelegate _next;

        public JwtCookieMiddleware(RequestDelegate next)
        {
            _next = next;
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

                    var claims = jwtToken.Claims.Select(c => new Claim(c.Type, c.Value)).ToList();
                    var identity = new ClaimsIdentity(claims, "jwt-cookie");
                    var principal = new ClaimsPrincipal(identity);

                    context.User = principal;
                }
                catch
                {
                }
            }

            await _next(context);
        }
    }
}

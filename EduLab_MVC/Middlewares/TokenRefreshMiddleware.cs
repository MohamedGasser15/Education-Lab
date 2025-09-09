using EduLab_MVC.Models.DTOs.Token;
using EduLab_MVC.Services;

namespace EduLab_MVC.Middlewares
{
    public class TokenRefreshMiddleware
    {
        private readonly RequestDelegate _next;
        private readonly ILogger<TokenRefreshMiddleware> _logger;

        public TokenRefreshMiddleware(RequestDelegate next, ILogger<TokenRefreshMiddleware> logger)
        {
            _next = next;
            _logger = logger;
        }

        public async Task InvokeAsync(HttpContext context, AuthService authService)
        {
            var accessToken = context.Request.Cookies["AuthToken"];
            var refreshToken = context.Request.Cookies["RefreshToken"];

            if (!string.IsNullOrEmpty(accessToken) && !string.IsNullOrEmpty(refreshToken))
            {
                if (authService.IsTokenExpired(accessToken))
                {
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

                            _logger.LogInformation("تم تجديد التوكن بنجاح");
                        }
                        else
                        {
                            _logger.LogWarning("فشل تجديد التوكن، سيتم تسجيل الخروج");
                            await LogoutUser(context, authService);
                        }
                    }
                    catch (UnauthorizedAccessException ex)
                    {
                        _logger.LogWarning(ex, "Refresh token غير صالح، سيتم تسجيل الخروج");
                        await LogoutUser(context, authService);
                    }
                    catch (Exception ex)
                    {
                        _logger.LogError(ex, "حدث خطأ أثناء محاولة تجديد التوكن");
                    }
                }
            }

            await _next(context);
        }

        private async Task LogoutUser(HttpContext context, AuthService authService)
        {
            // محاولة عمل revoke للـ refresh token
            try
            {
                var refreshToken = context.Request.Cookies["RefreshToken"];
                if (!string.IsNullOrEmpty(refreshToken))
                {
                    await authService.RevokeToken(refreshToken);
                }
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "خطأ أثناء محاولة revoke الـ refresh token");
            }

            // مسح الكوكيز
            context.Response.Cookies.Delete("AuthToken");
            context.Response.Cookies.Delete("RefreshToken");
            context.Response.Cookies.Delete("RefreshTokenExpiry");
            context.Response.Cookies.Delete("UserFullName");
            context.Response.Cookies.Delete("UserRole");
            context.Response.Cookies.Delete("ProfileImageUrl");

            context.Session.Clear();

            // إذا كان الطلب ليس لصفحة تسجيل الدخول، redirect لل login
            if (!context.Request.Path.StartsWithSegments("/Learner/Auth/Login"))
            {
                context.Response.Redirect("/Learner/Auth/Login");
                return;
            }
        }
    }
}

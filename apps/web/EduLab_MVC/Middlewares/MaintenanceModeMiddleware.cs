using EduLab_MVC.Common;
using EduLab_MVC.Services.ServiceInterfaces;

namespace EduLab_MVC.Middlewares
{
    public class MaintenanceModeMiddleware
    {
        private readonly RequestDelegate _next;
        private readonly ILogger<MaintenanceModeMiddleware> _logger;

        public MaintenanceModeMiddleware(RequestDelegate next, ILogger<MaintenanceModeMiddleware> logger)
        {
            _next = next;
            _logger = logger;
        }

        public async Task InvokeAsync(HttpContext context, ISiteSettingsService siteSettingsService)
        {
            try
            {
                var settings = await siteSettingsService.GetSettingsAsync();
                if (settings == null || !settings.MaintenanceMode)
                {
                    await _next(context);
                    return;
                }

                // Maintenance mode is ON - check if user is admin
                var isAdmin = context.User?.Claims.Any(c =>
                    c.Type == System.Security.Claims.ClaimTypes.Role &&
                    c.Value.Equals(SD.Admin, StringComparison.OrdinalIgnoreCase)) ?? false;

                if (isAdmin)
                {
                    await _next(context);
                    return;
                }

                // Not admin - allow only login, auth, static files, and maintenance page
                var path = context.Request.Path.Value?.ToLowerInvariant() ?? "";
                if (path.StartsWith("/Learner/auth/") ||
                    path.StartsWith("/admin") ||
                    path.StartsWith("/css") ||
                    path.StartsWith("/js") ||
                    path.StartsWith("/lib") ||
                    path.StartsWith("/img") ||
                    path.StartsWith("/fonts") ||
                    path.StartsWith("/error/maintenance"))
                {
                    await _next(context);
                    return;
                }

                _logger.LogInformation("Maintenance mode active - redirecting non-admin request: {Path}", path);
                context.Response.Redirect("/Error/Maintenance");
                return;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error in MaintenanceModeMiddleware");
            }

            await _next(context);
        }
    }
}

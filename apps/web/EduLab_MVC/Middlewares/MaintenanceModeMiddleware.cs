using EduLab_MVC.Common;
using EduLab_MVC.Services.ServiceInterfaces;

namespace EduLab_MVC.Middlewares
{
    /// <summary>
    /// Blocks non-admin traffic when maintenance mode is enabled, redirecting users to the maintenance page.
    /// </summary>
    public class MaintenanceModeMiddleware
    {
        private readonly RequestDelegate _next;
        private readonly ILogger<MaintenanceModeMiddleware> _logger;

        /// <summary>
        /// Initializes a new instance of the <see cref="MaintenanceModeMiddleware"/> class.
        /// </summary>
        /// <param name="next">The next middleware in the pipeline.</param>
        /// <param name="logger">The logger instance.</param>
        public MaintenanceModeMiddleware(RequestDelegate next, ILogger<MaintenanceModeMiddleware> logger)
        {
            _next = next;
            _logger = logger;
        }

        /// <summary>
        /// Applies maintenance mode enforcement when enabled.
        /// </summary>
        /// <param name="context">The HTTP context.</param>
        /// <param name="siteSettingsService">The site settings service.</param>
        /// <returns>A task representing the asynchronous operation.</returns>
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

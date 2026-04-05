using EduLab_Application.ServiceInterfaces;
using EduLab_Application.Services;
using EduLab_Application.Utitlites;
using Microsoft.Extensions.DependencyInjection;

namespace EduLab_Application.Config
{
    public static class ServiceContainer
    {
        public static IServiceCollection AddApplicationServices(
            this IServiceCollection services)
        {
            // ✅ كل Services طبقة التطبيق
            services.AddScoped<IStudentService, StudentService>();
            services.AddScoped<INotificationService, NotificationService>();
            services.AddScoped<IRatingService, RatingService>();
            services.AddScoped<IWishlistService, WishlistService>();
            services.AddScoped<ICourseProgressService, CourseProgressService>();
            services.AddScoped<IEnrollmentService, EnrollmentService>();
            services.AddScoped<IPaymentService, PaymentService>();
            services.AddScoped<ITokenService, TokenService>();
            services.AddScoped<ICartService, CartService>();
            services.AddScoped<IAuthService, AuthService>();
            services.AddScoped<IUserService, UserService>();
            services.AddScoped<ICategoryService, CategoryService>();
            services.AddScoped<ICourseService, CourseService>();
            services.AddScoped<IHistoryService, HistoryService>();
            services.AddScoped<IFileStorageService, FileStorageService>();
            services.AddScoped<IVideoDurationService, VideoDurationService>();
            services.AddScoped<IEmailSender, EmailSender>();
            services.AddScoped<IIpService, IpService>();
            services.AddScoped<ILinkBuilderService, LinkBuilderService>();
            services.AddScoped<IEmailTemplateService, EmailTemplateService>();
            services.AddScoped<IExternalLoginService, ExternalLoginService>();
            services.AddScoped<ICurrentUserService, CurrentUserService>();
            services.AddScoped<IRoleService, RoleService>();
            services.AddScoped<IProfileService, ProfileService>();
            services.AddScoped<IUserSettingsService, UserSettingsService>();
            services.AddScoped<IInstructorService, InstructorService>();
            services.AddScoped<IInstructorApplicationService, InstructorApplicationService>();

            return services;
        }
    }
}
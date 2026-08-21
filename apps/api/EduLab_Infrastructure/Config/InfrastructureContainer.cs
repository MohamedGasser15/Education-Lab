using EduLab_Domain;
using EduLab_Domain.Entities;
using EduLab_Domain.IRepository;
using EduLab_Infrastructure.DB;
using EduLab_Infrastructure.Persistence.Repositories;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;

namespace EduLab_Infrastructure.Config
{
    /// <summary>
    /// Registers infrastructure services (database, identity, repositories) with the DI container.
    /// </summary>
    public static class InfrastructureContainer
    {
        /// <summary>
        /// Adds the application database context, ASP.NET Core Identity, and all repository
        /// implementations to the service collection.
        /// </summary>
        /// <param name="services">The service collection to register services into.</param>
        /// <param name="configuration">The application configuration.</param>
        /// <returns>The same service collection so that registrations can be chained.</returns>
        public static IServiceCollection AddInfrastructureServices(
            this IServiceCollection services,
            IConfiguration configuration)
        {
            services.AddDbContext<ApplicationDbContext>(options =>
                options.UseSqlServer(configuration.GetConnectionString("DefaultConnectionString")));

            services.AddIdentity<ApplicationUser, ApplicationRole>(options =>
            {
                options.Tokens.EmailConfirmationTokenProvider = TokenOptions.DefaultEmailProvider;
                options.Password.RequireDigit = true;
                options.Password.RequiredLength = 8;
                options.Password.RequireNonAlphanumeric = false;
                options.Password.RequireUppercase = true;
                options.Password.RequireLowercase = false;
                options.User.RequireUniqueEmail = true;

                // Lockout settings
                options.Lockout.DefaultLockoutTimeSpan = TimeSpan.FromHours(2);
                options.Lockout.MaxFailedAccessAttempts = 10;
                options.Lockout.AllowedForNewUsers = true;
            })
            .AddPasswordValidator<PasswordValidator<ApplicationUser>>()
            .AddEntityFrameworkStores<ApplicationDbContext>()
            .AddDefaultTokenProviders();

            services.AddHttpContextAccessor();

            services.AddScoped<ICategoryRepository, CategoryRepository>();
            services.AddScoped<ICartRepository, CartRepository>();
            services.AddScoped<ICourseRepository, CourseRepository>();
            services.AddScoped<IHistoryRepository, HistoryRepository>();
            services.AddScoped<IProfileRepository, ProfileRepository>();
            services.AddScoped<ISessionRepository, SessionRepository>();
            services.AddScoped<IRefreshTokenRepository, RefreshTokenRepository>();
            services.AddScoped<IInstructorApplicationRepository, InstructorApplicationRepository>();
            services.AddScoped(typeof(IRepository<>), typeof(Repository<>));
            services.AddScoped<IPaymentRepository, PaymentRepository>();
            services.AddScoped<IEnrollmentRepository, EnrollmentRepository>();
            services.AddScoped<ICourseProgressRepository, CourseProgressRepository>();
            services.AddScoped<IWishlistRepository, WishlistRepository>();
            services.AddScoped<IRatingRepository, RatingRepository>();
            services.AddScoped<ILectureCommentRepository, LectureCommentRepository>();
            services.AddScoped<INotificationRepository, NotificationRepository>();
            services.AddScoped<IStudentRepository, StudentRepository>();
            services.AddScoped<IRefundRequestRepository, RefundRequestRepository>();
            services.AddScoped<ICourseCertificateRepository, CourseCertificateRepository>();
            services.AddScoped<IReportRepository, ReportRepository>();

            return services;
        }
    }
}
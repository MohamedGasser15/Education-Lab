using EduLab_Application.ServiceInterfaces;
using EduLab_Application.Services;
using EduLab_Domain.Entities;
using EduLab_Domain.RepoInterfaces;
using EduLab_Infrastructure.DB;
using EduLab_Infrastructure.Persistence.Repositories;
using EduLab_Shared.Utitlites;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.IdentityModel.Tokens;
using System;
using System.Security.Claims;
using System.Text;

namespace EduLab_Infrastructure.DependancyInjection
{
    public static class ServiceContainer
    {
        public static IServiceCollection AddInfrastructureServices(this IServiceCollection Services, IConfiguration configuration)
        {
            Services.AddDbContext<ApplicationDbContext>(options =>
            {
                options.UseSqlServer(configuration.GetConnectionString("DefaultConnectionString"));
            });

            Services.AddIdentity<ApplicationUser, IdentityRole>(options =>
            {
                options.Tokens.EmailConfirmationTokenProvider = TokenOptions.DefaultEmailProvider;
                options.Password.RequireDigit = true;
                options.Password.RequiredLength = 8;
                options.Password.RequireNonAlphanumeric = false;
                options.Password.RequireUppercase = true;
                options.Password.RequireLowercase = false;
                options.User.RequireUniqueEmail = true;
            })
                .AddPasswordValidator<PasswordValidator<ApplicationUser>>() 
            .AddEntityFrameworkStores<ApplicationDbContext>()
            .AddDefaultTokenProviders();

            Services.AddAuthentication(options =>
            {
                options.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
                options.DefaultScheme = JwtBearerDefaults.AuthenticationScheme;
                options.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
            }).AddJwtBearer(options =>
            {
                options.SaveToken = true;
                options.TokenValidationParameters = new TokenValidationParameters()
                {
                    ValidateAudience = true,
                    ValidateIssuer = true,
                    ValidateIssuerSigningKey = true,
                    ValidateLifetime = true,
                    RequireExpirationTime = true,
                    ValidIssuer = configuration["JWT:Issuer"],
                    ValidAudience = configuration["JWT:Audience"],
                    IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(configuration["JWT:Key"]!)),
                            NameClaimType = ClaimTypes.NameIdentifier,
                    RoleClaimType = ClaimTypes.Role
                };
            });
            Services.AddHttpContextAccessor();

            Services.AddScoped<IUserRepository, UserRepository>();
            Services.AddScoped<ICategoryRepository, CategoryRepository>();
            Services.AddScoped<ICourseRepository, CourseRepository>();
            Services.AddScoped<IHistoryRepository, HistoryRepository>();
            Services.AddScoped<IRoleRepository, RoleRepository>();
            Services.AddScoped<IProfileRepository, ProfileRepository>();
            Services.AddScoped<ISessionRepository, SessionRepository>();
            Services.AddScoped(typeof(IRepository<>), typeof(Repository<>));

            Services.AddScoped<ITokenService, TokenService>();
            Services.AddScoped<IAuthService, AuthService>();
            Services.AddScoped<IUserService, UserService>();
            Services.AddScoped<ICategoryService, CategoryService>();
            Services.AddScoped<ICourseService, CourseService>();
            Services.AddScoped<IHistoryService, HistoryService>();
            Services.AddScoped<IFileStorageService, FileStorageService>();
            Services.AddScoped<IVideoDurationService, VideoDurationService>();
            Services.AddScoped<IEmailSender, EmailSender>();
            Services.AddScoped<IIpService, IpService>();
            Services.AddScoped<ILinkBuilderService, LinkBuilderService>();
            Services.AddScoped<IEmailTemplateService, EmailTemplateService>();
            Services.AddScoped<IExternalLoginService, ExternalLoginService>();
            Services.AddScoped<ICurrentUserService, CurrentUserService>();
            Services.AddScoped<IRoleService, RoleService>();
            Services.AddScoped<IProfileService, ProfileService>();
            Services.AddScoped<IUserSettingsService, UserSettingsService>();
            Services.AddScoped<IInstructorService, InstructorService>();

            Services.AddAuthorization(options =>
            {
                // Users
                options.AddPolicy("Users.View", policy =>
                    policy.RequireClaim("Permission", "Users.View"));

                options.AddPolicy("Users.Edit", policy =>
                    policy.RequireClaim("Permission", "Users.Edit"));

                options.AddPolicy("Users.Delete", policy =>
                    policy.RequireClaim("Permission", "Users.Delete"));

                options.AddPolicy("Users.Lock", policy =>
                    policy.RequireClaim("Permission", "Users.Lock"));

                // Roles
                options.AddPolicy("Roles.View", policy =>
                    policy.RequireClaim("Permission", "Roles.View"));

                options.AddPolicy("Roles.Create", policy =>
                    policy.RequireClaim("Permission", "Roles.Create"));

                options.AddPolicy("Roles.Edit", policy =>
                    policy.RequireClaim("Permission", "Roles.Edit"));

                options.AddPolicy("Roles.Delete", policy =>
                    policy.RequireClaim("Permission", "Roles.Delete"));

                options.AddPolicy("Roles.Claims", policy =>
                    policy.RequireClaim("Permission", "Roles.Claims"));

                // Courses
                options.AddPolicy("Courses.View", policy =>
                    policy.RequireClaim("Permission", "Courses.View"));

                options.AddPolicy("Courses.Create", policy =>
                    policy.RequireClaim("Permission", "Courses.Create"));

                options.AddPolicy("Courses.Edit", policy =>
                    policy.RequireClaim("Permission", "Courses.Edit"));

                options.AddPolicy("Courses.Delete", policy =>
                    policy.RequireClaim("Permission", "Courses.Delete"));

                // Categories
                options.AddPolicy("Categories.View", policy =>
                    policy.RequireClaim("Permission", "Categories.View"));

                options.AddPolicy("Categories.Create", policy =>
                    policy.RequireClaim("Permission", "Categories.Create"));

                options.AddPolicy("Categories.Edit", policy =>
                    policy.RequireClaim("Permission", "Categories.Edit"));

                options.AddPolicy("Categories.Delete", policy =>
                    policy.RequireClaim("Permission", "Categories.Delete"));

                // Dashboard
                options.AddPolicy("Dashboard.View", policy =>
                    policy.RequireClaim("Permission", "Dashboard.View"));

                // Histories
                options.AddPolicy("Histories.View", policy =>
                    policy.RequireClaim("Permission", "Histories.View"));

                // Reports
                options.AddPolicy("Reports.View", policy =>
                    policy.RequireClaim("Permission", "Reports.View"));
            });


            return Services;
        }
    }
}

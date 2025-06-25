using EduLab_Application.ServiceInterfaces;
using EduLab_Application.Services;
using EduLab_Domain.Entities;
using EduLab_Domain.RepoInterfaces;
using EduLab_Infrastructure.DB;
using EduLab_Infrastructure.Persistence.Repositories;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.IdentityModel.Tokens;
using System;
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
                    IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(configuration["JWT:Key"]!))
                };
            });

            Services.AddScoped<IUserRepository, UserRepository>();
            Services.AddScoped<ICategoryRepository, CategoryRepository>();
            Services.AddScoped<ICourseRepository, CourseRepository>();



            Services.AddScoped<ITokenService, TokenService>();
            Services.AddScoped<IAuthService, AuthService>();
            Services.AddScoped<IUserService, UserService>();
            Services.AddScoped<ICategoryService, CategoryService>();
            Services.AddScoped<ICourseService, CourseService>();
            Services.AddScoped<IFileStorageService, FileStorageService>();
            Services.AddScoped<IVideoDurationService, VideoDurationService>();


            return Services;
        }
    }
}

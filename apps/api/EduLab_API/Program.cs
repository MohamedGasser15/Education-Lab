using EduLab_API;
using EduLab_API.MappingConfig;
using EduLab_API.Settings;
using EduLab_Application.Config;
using EduLab_Application.Utitlites;
using EduLab_Domain;
using EduLab_Domain.Entities;
using EduLab_Infrastructure.Config;
using EduLab_Infrastructure.DB;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.DataProtection;
using Microsoft.AspNetCore.Http.Features;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.FileProviders;
using Microsoft.IdentityModel.Tokens;
using Microsoft.OpenApi.Models;
using Scalar.AspNetCore;
using Stripe;
using System.Globalization;
using System.Security.Claims;
using System.Text;
using Microsoft.AspNetCore.Localization;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddInfrastructureServices(builder.Configuration);
builder.Services.AddApplicationServices();
builder.Services.AddAutoMapper(cfg => { }, typeof(MappingConfig).Assembly);
builder.Services.Configure<StripeSettings>(builder.Configuration.GetSection("Stripe"));
builder.Services.Configure<FormOptions>(options =>
{
    options.MultipartBodyLengthLimit = 524288000; // 500MB
});
builder.Services.AddControllers(options =>
{
    options.Conventions.Add(new EduLab_API.Authorization.AdminAreaAuthorizationConvention());
});
builder.Services.AddMemoryCache();

builder.Services.AddAuthorization(options =>
{
    options.AddPolicy("AdminArea", policy =>
        policy.RequireAssertion(ctx =>
            ctx.User.Claims.Any(c => EduLab_Application.Common.Constants.AdminClaims.All.Contains(c.Type, StringComparer.OrdinalIgnoreCase))));
});

builder.Services.AddDataProtection()
    .PersistKeysToFileSystem(new DirectoryInfo(@"C:\KeyRing\EduLab"))
    .SetApplicationName("EduLabSharedCookie");

// 🔑 JWT Authentication
builder.Services
    .AddAuthentication(options =>
    {
        options.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
        options.DefaultScheme = JwtBearerDefaults.AuthenticationScheme;
        options.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
    })
    .AddJwtBearer(options =>
    {
        options.SaveToken = true;
        options.TokenValidationParameters = new TokenValidationParameters
        {
            ValidateAudience = true,
            ValidateIssuer = true,
            ValidateIssuerSigningKey = true,
            ValidateLifetime = true,
            RequireExpirationTime = true,
            ValidIssuer = builder.Configuration["JWT:Issuer"],
            ValidAudience = builder.Configuration["JWT:Audience"],
            IssuerSigningKey = new SymmetricSecurityKey(
                Encoding.UTF8.GetBytes(builder.Configuration["JWT:Key"]!)
            ),
            NameClaimType = ClaimTypes.NameIdentifier,
            RoleClaimType = ClaimTypes.Role
        };
        options.Events = new JwtBearerEvents
        {
            OnMessageReceived = context =>
            {
                // SignalR clients send the token via the "access_token" query string
                var accessToken = context.Request.Query["access_token"];
                var path = context.HttpContext.Request.Path;
                if (!string.IsNullOrEmpty(accessToken) && path.StartsWithSegments("/hubs"))
                {
                    context.Token = accessToken;
                }
                return Task.CompletedTask;
            }
        };
    })
    .AddFacebook(facebookOptions =>
    {
        facebookOptions.AppId = builder.Configuration["Authentication:Facebook:AppId"];
        facebookOptions.AppSecret = builder.Configuration["Authentication:Facebook:AppSecret"];
        facebookOptions.Scope.Add("email");
    })
    .AddGoogle(googleOptions =>
    {
        googleOptions.ClientId = builder.Configuration["Authentication:Google:ClientId"];
        googleOptions.ClientSecret = builder.Configuration["Authentication:Google:ClientSecret"];
    })
    .AddMicrosoftAccount(options =>
    {
        options.ClientId =
            builder.Configuration["Authentication:Microsoft:ClientId"];

        options.ClientSecret =
            builder.Configuration["Authentication:Microsoft:ClientSecret"];

        options.CallbackPath = "/signin-microsoft";
    });

// =======================
// OpenAPI + Scalar
// =======================
builder.Services.AddOpenApi(options =>
{
    options.AddDocumentTransformer((document, context, cancellationToken) =>
    {
        document.Info = new OpenApiInfo
        {
            Title = "EduLab API",
            Version = "v1",
            Description = "Education Lab API Documentation"
        };

        document.Components ??= new OpenApiComponents();
        document.Components.SecuritySchemes = new Dictionary<string, OpenApiSecurityScheme>
        {
            ["Bearer"] = new OpenApiSecurityScheme
            {
                Type = SecuritySchemeType.Http,
                Scheme = "bearer",
                BearerFormat = "JWT",
                In = ParameterLocation.Header,
                Description = "Bearer {your JWT token}"
            }
        };

        foreach (var path in document.Paths.Values)
        {
            foreach (var operation in path.Operations)
            {
                operation.Value.Security = new List<OpenApiSecurityRequirement>
                {
                    new OpenApiSecurityRequirement
                    {
                        {
                            new OpenApiSecurityScheme
                            {
                                Reference = new OpenApiReference
                                {
                                    Type = ReferenceType.SecurityScheme,
                                    Id = "Bearer"
                                }
                            },
                            Array.Empty<string>()
                        }
                    }
                };
            }
        }

        return Task.CompletedTask;
    });
});

StripeConfiguration.ApiKey = builder.Configuration.GetSection("Stripe:SecretKey").Get<string>();

// Real-time support chat
builder.Services.AddSignalR();

// CORS — allows the MVC app (browser) to call the API directly for SignalR
builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowMvcApp", policy =>
        policy.SetIsOriginAllowed(origin =>
                origin.StartsWith("https://edulab.runasp.net", StringComparison.OrdinalIgnoreCase) ||
                origin.StartsWith("http://edulab.runasp.net", StringComparison.OrdinalIgnoreCase) ||
                origin.StartsWith("https://localhost:7204", StringComparison.OrdinalIgnoreCase) ||
                origin.StartsWith("http://localhost:5154", StringComparison.OrdinalIgnoreCase))
              .AllowAnyHeader()
              .AllowAnyMethod()
              .AllowCredentials());
});

// Localization — register IStringLocalizer for EmailResources (resx files inside EduLab_Application)
builder.Services.AddLocalization();

// Localization — detect user language from Accept-Language header
var supportedCultures = new[] { "ar", "en", "zh", "nl", "fr", "de", "hi", "id", "it", "ja", "ko", "ms", "pt", "ru", "es", "vi", "tr", "uk", "ur", "pl" };
var requestLocalizationOptions = new RequestLocalizationOptions
{
    DefaultRequestCulture = new RequestCulture("en"),
    SupportedCultures = supportedCultures.Select(c => new CultureInfo(c)).ToList(),
    SupportedUICultures = supportedCultures.Select(c => new CultureInfo(c)).ToList(),
    RequestCultureProviders = new List<IRequestCultureProvider>
    {
        new AcceptLanguageHeaderRequestCultureProvider()
    }
};

var app = builder.Build();

using (var scope = app.Services.CreateScope())
{
    var services = scope.ServiceProvider;
    try
    {
        var db = services.GetRequiredService<ApplicationDbContext>();
        var userManager = services.GetRequiredService<UserManager<ApplicationUser>>();
        var roleManager = services.GetRequiredService<RoleManager<ApplicationRole>>();

        await DbInitializer.InitializeAsync(db, userManager, roleManager);
    }
    catch (Exception ex)
    {
        var logger = services.GetRequiredService<ILogger<Program>>();
        logger.LogError(ex, "حدث خطأ أثناء تهيئة قاعدة البيانات");
    }
}

app.UseHttpsRedirection();

app.UseRequestLocalization(requestLocalizationOptions);

app.UseStaticFiles(new StaticFileOptions
{
    FileProvider = new PhysicalFileProvider(
        Path.Combine(Directory.GetCurrentDirectory(), "wwwroot")),
    RequestPath = ""
});

app.UseRouting();

app.UseCors("AllowMvcApp");

app.UseAuthentication();
app.UseAuthorization();

app.MapControllers();
app.MapHub<EduLab_API.Hubs.SupportHub>("/hubs/support");

// Scalar endpoints
app.MapOpenApi();
app.MapScalarApiReference(options =>
{
    options.Title = "EduLab API Docs";
    options.Theme = ScalarTheme.BluePlanet;
});

app.MapGet("/", context =>
{
    context.Response.Redirect("/scalar");
    return Task.CompletedTask;
});

app.Run();
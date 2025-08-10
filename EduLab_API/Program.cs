using EduLab_API;
using EduLab_API.MappingConfig;
using EduLab_Domain.Entities;
using EduLab_Infrastructure.DB;
using EduLab_Infrastructure.DependancyInjection;
using FFMpegCore;
using Microsoft.AspNetCore.Authentication.Cookies;
using Microsoft.AspNetCore.Authentication.Google;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.DataProtection;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Options;
using Microsoft.IdentityModel.Tokens;
using Microsoft.OpenApi.Models;
using System.Text;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddInfrastructureServices(builder.Configuration);

//Adding CustomServices
builder.Services.AddAutoMapper(typeof(MappingConfig));

builder.Services.AddControllers();

builder.Services.AddMemoryCache();
// shared data protection بين API و MVC
builder.Services.AddDataProtection()
    .PersistKeysToFileSystem(new DirectoryInfo(@"C:\KeyRing\EduLab"))
    .SetApplicationName("EduLabSharedCookie");

builder.Services.ConfigureApplicationCookie(opts =>
{
    opts.Cookie.Name = ".EduLab.Shared";
    opts.LoginPath = "/Auth/Login";
    opts.AccessDeniedPath = "/Auth/Forbidden";
    opts.Cookie.Domain = "localhost";
});


builder.Services
    .AddAuthentication(options =>
    {
        options.DefaultScheme = CookieAuthenticationDefaults.AuthenticationScheme;
        options.DefaultChallengeScheme = GoogleDefaults.AuthenticationScheme;
    })
    .AddCookie(options =>
    {
        options.Cookie.Name = ".EduLab.Auth";
        // لو حبيت تبعت الكوكي بين الدومينين:
        // options.Cookie.Domain = "localhost";
    });

// Google Auth
var googleClientId = builder.Configuration["Google:ClientId"];
var googleClientSecret = builder.Configuration["Google:ClientSecret"];

if (!string.IsNullOrEmpty(googleClientId) && !string.IsNullOrEmpty(googleClientSecret))
{
    builder.Services.AddAuthentication()
        .AddGoogle(options =>
        {
            options.ClientId = googleClientId;
            options.ClientSecret = googleClientSecret;
            options.CallbackPath = "/signin-google";
            options.SaveTokens = true;
        });
}

// Facebook Auth
var facebookClientId = builder.Configuration["Facebook:ClientId"];
var facebookClientSecret = builder.Configuration["Facebook:ClientSecret"];

if (!string.IsNullOrEmpty(facebookClientId) && !string.IsNullOrEmpty(facebookClientSecret))
{
    builder.Services.AddAuthentication()
        .AddFacebook(facebookOptions =>
        {
            facebookOptions.ClientId = facebookClientId;
            facebookOptions.ClientSecret = facebookClientSecret;
            facebookOptions.CallbackPath = "/signin-facebook";
            facebookOptions.SaveTokens = true;
        });
}



builder.Services.AddSwaggerGen(options =>
{
    options.AddSecurityDefinition("Bearer", new OpenApiSecurityScheme
    {
        Description = "JWT Authorization Header Using the Bearer Schema"
        + "\r\n\r\n Enter 'Bearer' [space] and your token in the text input below.\r\n\r\n"
        + "Example: 'Bearer 12345abcdef'",
        Name = "Authorization",
        In = ParameterLocation.Header,
        Scheme = "Bearer"
    });
    options.AddSecurityRequirement(new OpenApiSecurityRequirement
    {
        {
            new OpenApiSecurityScheme
            {
                Reference = new OpenApiReference
                {
                    Type = ReferenceType.SecurityScheme,
                    Id = "Bearer"
                },
                Scheme = "oauth2",
                Name = "Bearer",
                In = ParameterLocation.Header
            },
            new List<string>()
        }
    });
});

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI(o =>
    {
        o.DocumentTitle = "Education Lab API";
        o.HeadContent = @"
        <style>
            .swagger-ui .topbar { 
                background-color: #5298DF; 
                padding: 10px 0;
            }
        </style>
        <link href='https://fonts.googleapis.com/css?family=Open+Sans:400,700' rel='stylesheet' type='text/css'>";

        o.InjectStylesheet("/swagger-custom.css");
        o.InjectJavascript("/swagger-custom.js");

        o.DefaultModelsExpandDepth(-1);
        o.DisplayRequestDuration();
        o.EnableDeepLinking();
        o.ShowExtensions();
    });
}
using (var scope = app.Services.CreateScope())
{
    var services = scope.ServiceProvider;
    try
    {
        var db = services.GetRequiredService<ApplicationDbContext>();
        var userManager = services.GetRequiredService<UserManager<ApplicationUser>>();
        var roleManager = services.GetRequiredService<RoleManager<IdentityRole>>();

        await DbInitializer.InitializeAsync(db, userManager, roleManager);
    }
    catch (Exception ex)
    {
        var logger = services.GetRequiredService<ILogger<Program>>();
        logger.LogError(ex, "حدث خطأ أثناء تهيئة قاعدة البيانات");
    }
}
app.UseHttpsRedirection();

app.UseRouting();

app.UseAuthentication();

app.UseAuthorization();


app.MapControllers();

app.Run();

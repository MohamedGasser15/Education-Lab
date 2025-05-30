using EduLab_API;
using EduLab_Domain.Entities;
using EduLab_Infrastructure.DB;
using EduLab_Infrastructure.DependancyInjection;
using EduLab_Shared.MappingConfig;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using Microsoft.OpenApi.Models;
using System.Text;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddInfrastructureServices(builder.Configuration);

//Adding CustomServices
builder.Services.AddAutoMapper(typeof(MappingConfig));

builder.Services.AddControllers();

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

app.UseHttpsRedirection();

app.UseAuthentication();

app.UseAuthorization();

app.MapControllers();

app.Run();

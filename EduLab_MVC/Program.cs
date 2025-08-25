using EduLab_MVC.Middlewares;
using EduLab_MVC.Services;
using EduLab_MVC.Services.Helper_Services;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddControllersWithViews();
builder.Services.AddHttpClient("EduLabAPI", client =>
{
    client.BaseAddress = new Uri("https://localhost:7292/api/");
});
builder.Services.AddScoped<AuthService>();
builder.Services.AddScoped<UserService>();
builder.Services.AddScoped<CategoryService>();
builder.Services.AddScoped<CourseService>();
builder.Services.AddScoped<HistoryService>();
builder.Services.AddScoped<RoleService>();
builder.Services.AddScoped<ProfileService>();
builder.Services.AddScoped<InstructorService>();
builder.Services.AddScoped<UserSettingsService>();
builder.Services.AddScoped<AuthorizedHttpClientService>();
builder.Services.AddScoped<InstructorApplicationService>();
builder.Services.AddHttpContextAccessor();

builder.Services.AddSession();
builder.Services.AddSession(options =>
{
    options.IdleTimeout = TimeSpan.FromHours(1);
    options.Cookie.HttpOnly = true;
    options.Cookie.IsEssential = true;
});
// Add logging
builder.Logging.AddConsole();
builder.Logging.AddDebug();

var app = builder.Build();

// Configure the HTTP request pipeline.
if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Error/{0}");
    // The default HSTS value is 30 days. You may want to change this for production scenarios, see https://aka.ms/aspnetcore-hsts.
    app.UseHsts();
}
app.UseStatusCodePagesWithReExecute("/Error/{0}");
app.UseHttpsRedirection();

app.UseStaticFiles();

app.UseRouting();

app.UseSession();

app.UseMiddleware<JwtCookieMiddleware>();

app.UseAuthentication();

app.UseAuthorization();


app.MapControllerRoute(
    name: "areas",
    pattern: "{area:exists}/{controller=Home}/{action=Index}/{id?}");

app.MapControllerRoute(
    name: "default",
    pattern: "{area=Learner}/{controller=Home}/{action=Index}/{id?}").WithStaticAssets();

app.Run();

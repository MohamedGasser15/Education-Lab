using AutoMapper;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Identity;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
using Moq;
using EduLab_Domain;
using EduLab_Domain.Entities;

namespace EduLab.Tests.Fakes;

/// <summary>
/// Shared test infrastructure: configuration, role manager, http context, mapper.
/// </summary>
public static class TestInfrastructure
{
    /// <summary>
    /// In-memory IConfiguration with the keys the API services expect.
    /// </summary>
    public static IConfiguration MockConfiguration(Dictionary<string, string>? overrides = null)
    {
        var values = new Dictionary<string, string>
        {
            ["JWT:Key"] = "ThisIsASuperLongTestSigningKeyForEduLabUnitTests_2026!!",
            ["JWT:Issuer"] = "EduLabAPI",
            ["JWT:Audience"] = "EduLabUsers",
            ["JWT:AccessTokenExpiryDays"] = "7",
            ["JWT:RefreshTokenExpiryDays"] = "30",
            ["Stripe:SecretKey"] = "sk_test_fake",
            ["Stripe:PublishableKey"] = "pk_test_fake",
            ["ApiBaseUrl"] = "https://edulabapi.runasp.net/api/",
            ["AppBaseUrl"] = "https://edulab.runasp.net/"
        };

        if (overrides != null)
        {
            foreach (var kvp in overrides)
                values[kvp.Key] = kvp.Value;
        }

        return new ConfigurationBuilder()
            .AddInMemoryCollection(values)
            .Build();
    }

    /// <summary>
    /// RoleManager mock backed by an in-memory role list.
    /// </summary>
    public static Mock<RoleManager<ApplicationRole>> MockRoleManager(List<ApplicationRole>? roles = null)
    {
        var store = new Mock<IRoleStore<ApplicationRole>>();
        var roleManager = new Mock<RoleManager<ApplicationRole>>(
            store.Object, null!, null!, null!, null!);

        roleManager.Setup(x => x.Roles).Returns((roles ?? new List<ApplicationRole>()).AsQueryable());
        roleManager.Setup(x => x.FindByIdAsync(It.IsAny<string>()))
            .ReturnsAsync((string id) => roles?.FirstOrDefault(r => r.Id == id));
        roleManager.Setup(x => x.FindByNameAsync(It.IsAny<string>()))
            .ReturnsAsync((string name) => roles?.FirstOrDefault(r => r.Name == name));
        roleManager.Setup(x => x.GetClaimsAsync(It.IsAny<ApplicationRole>()))
            .ReturnsAsync(new List<System.Security.Claims.Claim>());
        roleManager.Setup(x => x.RoleExistsAsync(It.IsAny<string>()))
            .ReturnsAsync((string name) => roles?.Any(r => r.Name == name) ?? false);

        return roleManager;
    }

    /// <summary>
    /// HttpContextAccessor mock with request cookies and a writable response cookie collection.
    /// </summary>
    public static IHttpContextAccessor MockHttpContextAccessor(Dictionary<string, string>? cookies = null, string? path = "/")
    {
        var context = new DefaultHttpContext();
        context.Request.Path = path ?? "/";
        context.Request.Cookies = new TestRequestCookieCollection(cookies ?? new Dictionary<string, string>());

        var accessor = new Mock<IHttpContextAccessor>();
        accessor.Setup(x => x.HttpContext).Returns(context);
        return accessor.Object;
    }

    private class TestRequestCookieCollection : IRequestCookieCollection
    {
        private readonly Dictionary<string, string> _cookies;

        public TestRequestCookieCollection(Dictionary<string, string> cookies)
        {
            _cookies = cookies;
        }

        public string? this[string key] => _cookies.TryGetValue(key, out var value) ? value : null;
        public int Count => _cookies.Count;
        public ICollection<string> Keys => _cookies.Keys;
        public bool ContainsKey(string key) => _cookies.ContainsKey(key);
        public bool TryGetValue(string key, out string? value) => _cookies.TryGetValue(key, out value);
        public IEnumerator<KeyValuePair<string, string>> GetEnumerator() => _cookies.GetEnumerator();
        System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => _cookies.GetEnumerator();
    }

    /// <summary>
    /// Real AutoMapper instance. Services under test use it heavily — real maps are more
    /// reliable than hand-written mock setups.
    /// </summary>
    public static IMapper RealMapper()
    {
        var services = new Microsoft.Extensions.DependencyInjection.ServiceCollection();
        services.AddLogging();

        services.AddAutoMapper(cfg =>
        {
            // Self-maps make many tests work without explicit profiles
            cfg.CreateMap<ApplicationUser, ApplicationUser>();

            cfg.CreateMap<Course, EduLab_Application.DTOs.Course.CourseDTO>()
                .ForMember(d => d.EnrollmentCount, o => o.Ignore())
                .ForMember(d => d.AverageRating, o => o.Ignore())
                .ForMember(d => d.TotalRatings, o => o.Ignore());

            cfg.CreateMap<EduLab_Application.DTOs.Course.CourseDTO, Course>();

            cfg.CreateMap<Category, EduLab_Application.DTOs.Category.CategoryDTO>();
            cfg.CreateMap<EduLab_Application.DTOs.Category.CategoryCreateDTO, Category>();
            cfg.CreateMap<EduLab_Application.DTOs.Category.CategoryUpdateDTO, Category>();

            cfg.CreateMap<SiteSettings, EduLab_Application.DTOs.Settings.SiteSettingsDTO>();
            cfg.CreateMap<EduLab_Application.DTOs.Settings.SiteSettingsDTO, SiteSettings>();

            cfg.CreateMap<Rating, EduLab_Application.DTOs.Rating.RatingDto>();

            cfg.CreateMap<Wishlist, EduLab_Application.DTOs.Wishlist.WishlistItemDto>();

            cfg.CreateMap<Notification, EduLab_Application.DTOs.Notification.NotificationDto>();

            cfg.CreateMap<History, EduLab_Application.DTOs.History.HistoryDTO>()
                .ForMember(d => d.UserName, o => o.Ignore());

            cfg.CreateMap<LectureComment, EduLab_Application.DTOs.LectureComment.LectureCommentDTO>()
                .ForMember(d => d.UserName,
                    o => o.MapFrom(s => s.User != null ? s.User.FullName : "مستخدم"))
                .ForMember(d => d.UserProfileImage,
                    o => o.MapFrom(s => s.User != null ? s.User.ProfileImageUrl : null));

            cfg.CreateMap<ApplicationUser, EduLab_Application.DTOs.Settings.GeneralSettingsDTO>();

            cfg.CreateMap<ApplicationUser, EduLab_Application.DTOs.Student.StudentDto>();

            cfg.CreateMap<Enrollment, EduLab_Application.DTOs.Enrollment.EnrollmentDto>();

            cfg.CreateMap<CourseProgress, EduLab_Application.DTOs.CourseProgress.CourseProgressDto>();

            cfg.CreateMap<EduLab_Application.DTOs.CourseProgress.UpdateCourseProgressDto, CourseProgress>();

            cfg.CreateMap<NotificationSummary, EduLab_Application.DTOs.Notification.NotificationSummaryDto>();

            cfg.CreateMap<ApplicationUser, EduLab_Application.DTOs.Auth.UserDTO>();

            cfg.CreateMap<ApplicationUser, EduLab_Application.DTOs.Profile.ProfileDTO>();

            cfg.CreateMap<ApplicationUser, EduLab_Application.DTOs.Profile.InstructorProfileDTO>();

            cfg.CreateMap<Certificate, EduLab_Application.DTOs.Profile.CertificateDTO>();
            cfg.CreateMap<EduLab_Application.DTOs.Profile.CertificateDTO, Certificate>();

            cfg.CreateMap<Section, EduLab_Application.DTOs.Section.SectionDTO>();
            cfg.CreateMap<Lecture, EduLab_Application.DTOs.Lecture.LectureDTO>();
            cfg.CreateMap<LectureResource, EduLab_Application.DTOs.Lecture.LectureResourceDTO>();

            cfg.CreateMap<EduLab_Application.DTOs.Section.SectionDTO, Section>();
            cfg.CreateMap<EduLab_Application.DTOs.Lecture.LectureDTO, Lecture>();

            cfg.CreateMap<EduLab_Application.DTOs.Course.CourseUpdateDTO, Course>()
                .ForMember(dest => dest.Sections, opt => opt.Ignore())
                .ForAllMembers(opts => opts.Condition((src, dest, srcMember) => srcMember != null));
        }, typeof(TestData).Assembly);

        return services.BuildServiceProvider().GetRequiredService<IMapper>();
    }

    /// <summary>
    /// Mock IWebHostEnvironment with a temp content root.
    /// </summary>
    public static IWebHostEnvironment MockWebHostEnvironment()
    {
        var env = new Mock<IWebHostEnvironment>();
        env.Setup(x => x.ContentRootPath).Returns(Path.GetTempPath());
        env.Setup(x => x.WebRootPath).Returns(Path.Combine(Path.GetTempPath(), "wwwroot"));
        return env.Object;
    }

    public static ILogger<T> NullLogger<T>() => Mock.Of<ILogger<T>>();
}

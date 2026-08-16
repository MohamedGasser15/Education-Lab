using AutoMapper;
using EduLab_Application.DTOs.Course;
using EduLab_Application.DTOs.Profile;
using EduLab_Application.ServiceInterfaces;
using EduLab_Application.Services;
using EduLab_Domain.Entities;
using EduLab_Domain.IRepository;
using EduLab.Tests.Fakes;
using Microsoft.AspNetCore.Hosting;
using Moq;
using Xunit;

namespace EduLab.Tests.Services;

public class ProfileServiceTests
{
    private readonly Mock<IProfileRepository> _profiles;
    private readonly Mock<ICourseService> _courseService;
    private readonly IMapper _mapper;
    private readonly ProfileService _service;

    public ProfileServiceTests()
    {
        _profiles = new Mock<IProfileRepository>();
        _courseService = new Mock<ICourseService>();
        _mapper = TestInfrastructure.RealMapper();

        _service = new ProfileService(
            _profiles.Object,
            _mapper,
            TestInfrastructure.MockWebHostEnvironment(),
            _courseService.Object,
            TestData.NullLogger<ProfileService>());
    }

    [Fact]
    public async Task GetUserProfileAsync_ReturnsProfileWithCleanedSocialLinks()
    {
        var user = TestData.User("user-1", "Ahmed");
        user.GitHubUrl = "github.com/username"; // placeholder must be stripped
        user.LinkedInUrl = "https://linkedin.com/in/realuser";
        _profiles.Setup(x => x.GetUserProfileAsync("user-1", It.IsAny<CancellationToken>())).ReturnsAsync(user);

        var profile = await _service.GetUserProfileAsync("user-1");

        Assert.NotNull(profile);
        Assert.Equal("Ahmed", profile.FullName);
        Assert.Equal("Ahmed@test.com", profile.Email);
        Assert.NotNull(profile.SocialLinks);
        Assert.Null(profile.SocialLinks.GitHub);
        Assert.Equal("https://linkedin.com/in/realuser", profile.SocialLinks.LinkedIn);
    }

    [Fact]
    public async Task GetUserProfileAsync_EmptyUserId_ReturnsNull()
    {
        var profile = await _service.GetUserProfileAsync("");

        Assert.Null(profile);
        _profiles.Verify(x => x.GetUserProfileAsync(It.IsAny<string>(), It.IsAny<CancellationToken>()), Times.Never);
    }

    [Fact]
    public async Task GetUserProfileAsync_UserNotFound_ReturnsNull()
    {
        _profiles.Setup(x => x.GetUserProfileAsync("ghost", It.IsAny<CancellationToken>())).ReturnsAsync((ApplicationUser?)null);

        var profile = await _service.GetUserProfileAsync("ghost");

        Assert.Null(profile);
    }

    [Fact]
    public async Task UpdateUserProfileAsync_UpdatesFieldsAndStripsPlaceholderLinks()
    {
        var existing = TestData.User("user-1", "Ahmed");
        existing.Title = "Old Title";
        _profiles.Setup(x => x.GetUserProfileAsync("user-1", It.IsAny<CancellationToken>())).ReturnsAsync(existing);

        ApplicationUser? captured = null;
        _profiles.Setup(x => x.UpdateUserProfileAsync(It.IsAny<ApplicationUser>(), It.IsAny<CancellationToken>()))
            .Callback<ApplicationUser, CancellationToken>((u, ct) => captured = u)
            .ReturnsAsync(true);

        var result = await _service.UpdateUserProfileAsync(new UpdateProfileDTO
        {
            Id = "user-1",
            FullName = "Ahmed New",
            About = "About me",
            SocialLinks = new SocialLinksDTO
            {
                GitHub = "github.com/username",       // placeholder -> null
                LinkedIn = "linkedin.com/realuser"    // real link -> kept
            }
        });

        Assert.True(result);
        Assert.NotNull(captured);
        Assert.Equal("Ahmed New", captured.FullName);
        Assert.Equal("About me", captured.About);
        Assert.Null(captured.GitHubUrl);
        Assert.Equal("linkedin.com/realuser", captured.LinkedInUrl);
        Assert.Equal("Old Title", captured.Title); // not provided -> preserved
        Assert.Equal(existing.UserName, captured.UserName);
        Assert.Equal(existing.Email, captured.Email);
    }

    [Fact]
    public async Task UpdateUserProfileAsync_NullSocialLinks_PreservesExistingLinks()
    {
        var existing = TestData.User("user-1", "Ahmed");
        existing.GitHubUrl = "https://github.com/realuser";
        existing.LinkedInUrl = "https://linkedin.com/in/realuser";
        _profiles.Setup(x => x.GetUserProfileAsync("user-1", It.IsAny<CancellationToken>())).ReturnsAsync(existing);

        ApplicationUser? captured = null;
        _profiles.Setup(x => x.UpdateUserProfileAsync(It.IsAny<ApplicationUser>(), It.IsAny<CancellationToken>()))
            .Callback<ApplicationUser, CancellationToken>((u, ct) => captured = u)
            .ReturnsAsync(true);

        var result = await _service.UpdateUserProfileAsync(new UpdateProfileDTO
        {
            Id = "user-1",
            FullName = "Ahmed New",
            SocialLinks = null
        });

        Assert.True(result);
        Assert.NotNull(captured);
        Assert.Equal("Ahmed New", captured.FullName);
        Assert.Equal("https://github.com/realuser", captured.GitHubUrl);
        Assert.Equal("https://linkedin.com/in/realuser", captured.LinkedInUrl);
    }

    [Fact]
    public async Task UpdateUserProfileAsync_UserNotFound_ReturnsFalse()
    {
        _profiles.Setup(x => x.GetUserProfileAsync("ghost", It.IsAny<CancellationToken>())).ReturnsAsync((ApplicationUser?)null);

        var result = await _service.UpdateUserProfileAsync(new UpdateProfileDTO { Id = "ghost", FullName = "X" });

        Assert.False(result);
    }

    [Fact]
    public async Task GetInstructorProfileAsync_UserNotFound_ReturnsNull()
    {
        _profiles.Setup(x => x.GetInstructorProfileAsync("ghost", It.IsAny<CancellationToken>())).ReturnsAsync((ApplicationUser?)null);

        var profile = await _service.GetInstructorProfileAsync("ghost");

        Assert.Null(profile);
        _courseService.Verify(x => x.GetLatestInstructorCoursesAsync(
            It.IsAny<string>(), It.IsAny<int?>(), It.IsAny<CancellationToken>()), Times.Never);
    }

    [Fact]
    public async Task GetInstructorProfileAsync_MapsSubjectsCertificatesAndCourses()
    {
        var instructor = TestData.User("ins-1", "Instructor One", role: "Instructor");
        instructor.Subjects = new List<string> { "C#", "SQL" };
        instructor.Certificates = new List<Certificate>
        {
            new Certificate { Id = 1, Name = "AWS Certified", Issuer = "Amazon", Year = 2021, UserId = "ins-1" }
        };
        _profiles.Setup(x => x.GetInstructorProfileAsync("ins-1", It.IsAny<CancellationToken>())).ReturnsAsync(instructor);
        _courseService.Setup(x => x.GetLatestInstructorCoursesAsync("ins-1", 2, It.IsAny<CancellationToken>()))
            .ReturnsAsync(new List<CourseDTO>
            {
                new CourseDTO { Id = 1, Title = "C# Deep Dive" },
                new CourseDTO { Id = 2, Title = "SQL Mastery" }
            });

        var profile = await _service.GetInstructorProfileAsync("ins-1", 2);

        Assert.NotNull(profile);
        Assert.Equal(2, profile.Subjects.Count);
        var cert = Assert.Single(profile.Certificates);
        Assert.Equal("AWS Certified", cert.Name);
        Assert.Equal("Amazon", cert.Issuer);
        Assert.Equal(2021, cert.Year);
        Assert.Equal(2, profile.Courses.Count);
    }

    [Fact]
    public async Task AddCertificateAsync_MapsCertificateAndReturnsDto()
    {
        Certificate? captured = null;
        _profiles.Setup(x => x.AddCertificateAsync(It.IsAny<Certificate>(), It.IsAny<CancellationToken>()))
            .Callback<Certificate, CancellationToken>((c, ct) => captured = c)
            .ReturnsAsync((Certificate c, CancellationToken ct) =>
            {
                c.Id = 5;
                return c;
            });

        var result = await _service.AddCertificateAsync("ins-1", new CertificateDTO
        {
            Name = "Azure Fundamentals",
            Issuer = "Microsoft",
            Year = 2022
        });

        Assert.NotNull(result);
        Assert.Equal(5, result.Id);
        Assert.Equal("Azure Fundamentals", result.Name);
        Assert.Equal("Microsoft", result.Issuer);
        Assert.Equal(2022, result.Year);
        Assert.NotNull(captured);
        Assert.Equal("ins-1", captured.UserId);
    }

    [Fact]
    public async Task AddCertificateAsync_NullDto_ReturnsNull()
    {
        var result = await _service.AddCertificateAsync("ins-1", null!);

        Assert.Null(result);
        _profiles.Verify(x => x.AddCertificateAsync(It.IsAny<Certificate>(), It.IsAny<CancellationToken>()), Times.Never);
    }

    [Fact]
    public async Task DeleteCertificateAsync_ReturnsRepositoryResult()
    {
        _profiles.Setup(x => x.DeleteCertificateAsync(5, "ins-1", It.IsAny<CancellationToken>())).ReturnsAsync(true);

        var result = await _service.DeleteCertificateAsync("ins-1", 5);

        Assert.True(result);
        _profiles.Verify(x => x.DeleteCertificateAsync(5, "ins-1", It.IsAny<CancellationToken>()), Times.Once);
    }
}

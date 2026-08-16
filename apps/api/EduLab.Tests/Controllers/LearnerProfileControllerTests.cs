using EduLab_API.Controllers.Learner;
using EduLab_Application.DTOs.Profile;
using EduLab_Application.ServiceInterfaces;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using Moq;
using Xunit;

namespace EduLab.Tests.Controllers;

public class LearnerProfileControllerTests
{
    private readonly Mock<IProfileService> _profileService;
    private readonly Mock<ICurrentUserService> _currentUser;
    private readonly ProfileController _controller;

    public LearnerProfileControllerTests()
    {
        _profileService = new Mock<IProfileService>();
        _currentUser = new Mock<ICurrentUserService>();
        _controller = new ProfileController(
            _profileService.Object,
            _currentUser.Object,
            Mock.Of<ILogger<ProfileController>>());
    }

    private void SetUserId(string? userId)
    {
        _currentUser.Setup(x => x.GetUserIdAsync()).ReturnsAsync(userId);
    }

    [Fact]
    public async Task GetProfile_ReturnsUserProfile()
    {
        SetUserId("user-1");
        var profile = new ProfileDTO { Id = "user-1", FullName = "Ahmed", Email = "ahmed@test.com" };
        _profileService.Setup(x => x.GetUserProfileAsync("user-1", It.IsAny<CancellationToken>()))
            .ReturnsAsync(profile);

        var result = await _controller.GetProfile();

        var ok = Assert.IsType<OkObjectResult>(result);
        Assert.Same(profile, ok.Value);
    }

    [Fact]
    public async Task GetProfile_WithoutUserId_ReturnsUnauthorized()
    {
        SetUserId(null);

        var result = await _controller.GetProfile();

        Assert.IsType<UnauthorizedObjectResult>(result);
        _profileService.Verify(x => x.GetUserProfileAsync(It.IsAny<string>(), It.IsAny<CancellationToken>()), Times.Never);
    }

    [Fact]
    public async Task UpdateProfile_WithInvalidModelState_ReturnsBadRequest()
    {
        SetUserId("user-1");
        _controller.ModelState.AddModelError("Id", "معرف المستخدم مطلوب");

        var result = await _controller.UpdateProfile(new UpdateProfileDTO { Id = "" });

        Assert.IsType<BadRequestObjectResult>(result);
        _profileService.Verify(x => x.UpdateUserProfileAsync(It.IsAny<UpdateProfileDTO>(), It.IsAny<CancellationToken>()), Times.Never);
    }

    [Fact]
    public async Task UpdateProfile_WithValidData_UpdatesAndReturnsOk()
    {
        SetUserId("user-1");
        var dto = new UpdateProfileDTO { Id = "user-1", FullName = "Ahmed Ali" };
        _profileService.Setup(x => x.UpdateUserProfileAsync(dto, It.IsAny<CancellationToken>()))
            .ReturnsAsync(true);

        var result = await _controller.UpdateProfile(dto);

        Assert.IsType<OkObjectResult>(result);
        _profileService.Verify(x => x.UpdateUserProfileAsync(dto, It.IsAny<CancellationToken>()), Times.Once);
    }

    [Fact]
    public async Task GetInstructorProfile_ReturnsInstructorProfile()
    {
        SetUserId("ins-1");
        var profile = new InstructorProfileDTO { Id = "ins-1", FullName = "Dr. Ahmed", Subjects = new List<string> { "Math" } };
        _profileService.Setup(x => x.GetInstructorProfileAsync("ins-1", 2, It.IsAny<CancellationToken>()))
            .ReturnsAsync(profile);

        var result = await _controller.GetInstructorProfile();

        var ok = Assert.IsType<OkObjectResult>(result);
        Assert.Same(profile, ok.Value);
    }

    [Fact]
    public async Task UpdateInstructorProfile_WithCompleteData_UpdatesAndReturnsOk()
    {
        SetUserId("ins-1");
        var dto = new UpdateInstructorProfileDTO
        {
            Id = "ins-1",
            FullName = "Dr. Ahmed",
            Title = "Professor",
            Location = "Cairo",
            PhoneNumber = "01012345678",
            About = "Experienced instructor",
            SocialLinks = new SocialLinksDTO
            {
                GitHub = "https://github.com/ahmed",
                LinkedIn = "https://linkedin.com/in/ahmed",
                Twitter = "https://twitter.com/ahmed",
                Facebook = "https://facebook.com/ahmed"
            },
            Subjects = new List<string> { "Math", "Physics" }
        };
        _profileService.Setup(x => x.UpdateInstructorProfileAsync(dto, It.IsAny<CancellationToken>()))
            .ReturnsAsync(true);

        var result = await _controller.UpdateInstructorProfile(dto);

        Assert.IsType<OkObjectResult>(result);
        _profileService.Verify(x => x.UpdateInstructorProfileAsync(dto, It.IsAny<CancellationToken>()), Times.Once);
    }

    [Fact]
    public async Task AddCertificate_WithValidData_ReturnsCertificate()
    {
        SetUserId("ins-1");
        var certificateDto = new CertificateDTO { Name = "MCSD", Issuer = "Microsoft", Year = 2020 };
        var added = new CertificateDTO { Id = 1, Name = "MCSD", Issuer = "Microsoft", Year = 2020 };
        _profileService.Setup(x => x.AddCertificateAsync("ins-1", certificateDto, It.IsAny<CancellationToken>()))
            .ReturnsAsync(added);

        var result = await _controller.AddCertificate(certificateDto);

        var ok = Assert.IsType<OkObjectResult>(result);
        Assert.Same(added, ok.Value);
    }

    [Fact]
    public async Task DeleteCertificate_WhenNotFound_ReturnsNotFound()
    {
        SetUserId("ins-1");
        _profileService.Setup(x => x.DeleteCertificateAsync("ins-1", 9, It.IsAny<CancellationToken>()))
            .ReturnsAsync(false);

        var result = await _controller.DeleteCertificate(9);

        Assert.IsType<NotFoundObjectResult>(result);
    }
}

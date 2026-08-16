using EduLab_API.Controllers.Learner;
using EduLab_Application.DTOs.InstructorApplication;
using EduLab_Application.ServiceInterfaces;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using Moq;
using Xunit;

namespace EduLab.Tests.Controllers;

public class LearnerInstructorApplicationControllerTests
{
    private readonly Mock<IInstructorApplicationService> _applicationService;
    private readonly Mock<ICurrentUserService> _currentUser;
    private readonly InstructorApplicationController _controller;

    public LearnerInstructorApplicationControllerTests()
    {
        _applicationService = new Mock<IInstructorApplicationService>();
        _currentUser = new Mock<ICurrentUserService>();
        _controller = new InstructorApplicationController(
            _applicationService.Object,
            _currentUser.Object,
            Mock.Of<ILogger<InstructorApplicationController>>());
    }

    private void SetUserId(string? userId)
    {
        _currentUser.Setup(x => x.GetUserIdAsync()).ReturnsAsync(userId);
        _controller.ControllerContext = new ControllerContext
        {
            HttpContext = new DefaultHttpContext()
        };
    }

    private static InstructorApplicationDTO ValidApplication() => new()
    {
        FullName = "Ahmed Ali",
        Phone = "01000000000",
        Bio = "Expert",
        Specialization = "Web",
        Experience = "5",
        Skills = new List<string> { "C#" }
    };

    [Fact]
    public async Task Apply_WithoutUserId_ReturnsUnauthorized()
    {
        SetUserId(null);

        var result = await _controller.Apply(ValidApplication());

        Assert.IsType<UnauthorizedObjectResult>(result);
        _applicationService.Verify(x => x.SubmitApplication(
            It.IsAny<InstructorApplicationDTO>(), It.IsAny<string>(), It.IsAny<CancellationToken>()), Times.Never);
    }

    [Fact]
    public async Task Apply_ReturnsOk()
    {
        SetUserId("user-1");
        _applicationService.Setup(x => x.SubmitApplication(
                It.IsAny<InstructorApplicationDTO>(), "user-1", It.IsAny<CancellationToken>()))
            .ReturnsAsync((true, "Application submitted successfully"));

        var result = await _controller.Apply(ValidApplication());

        Assert.IsType<OkObjectResult>(result);
    }

    [Fact]
    public async Task Apply_WhenServiceRejects_ReturnsBadRequest()
    {
        SetUserId("user-1");
        _applicationService.Setup(x => x.SubmitApplication(
                It.IsAny<InstructorApplicationDTO>(), "user-1", It.IsAny<CancellationToken>()))
            .ReturnsAsync((false, "You already have a pending application"));

        var result = await _controller.Apply(ValidApplication());

        Assert.IsType<BadRequestObjectResult>(result);
    }

    [Fact]
    public async Task GetMyApplications_WithoutUserId_ReturnsUnauthorized()
    {
        SetUserId(null);

        var result = await _controller.GetMyApplications();

        Assert.IsType<UnauthorizedResult>(result);
        _applicationService.Verify(x => x.GetUserApplications(
            It.IsAny<string>(), It.IsAny<CancellationToken>()), Times.Never);
    }

    [Fact]
    public async Task GetMyApplications_ReturnsApplications()
    {
        SetUserId("user-1");
        var applications = new List<InstructorApplicationResponseDto>
        {
            new() { Id = "a-1", FullName = "Ahmed Ali", Status = "Pending" }
        };
        _applicationService.Setup(x => x.GetUserApplications("user-1", It.IsAny<CancellationToken>()))
            .ReturnsAsync(applications);

        var result = await _controller.GetMyApplications();

        var ok = Assert.IsType<OkObjectResult>(result);
        Assert.Equal(applications, ok.Value);
    }
}

using EduLab_API.Controllers.Learner;
using EduLab_Application.DTOs.Enrollment;
using EduLab_Application.ServiceInterfaces;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using Moq;
using System.Security.Claims;
using Xunit;

namespace EduLab.Tests.Controllers;

public class LearnerEnrollmentControllerTests
{
    private readonly Mock<IEnrollmentService> _service;
    private readonly EnrollmentController _controller;

    public LearnerEnrollmentControllerTests()
    {
        _service = new Mock<IEnrollmentService>();
        _controller = new EnrollmentController(_service.Object, Mock.Of<ILogger<EnrollmentController>>());
    }

    private void SetUser(string? userId)
    {
        var identity = userId == null
            ? new ClaimsIdentity()
            : new ClaimsIdentity(new[] { new Claim(ClaimTypes.NameIdentifier, userId) });
        _controller.ControllerContext = new ControllerContext
        {
            HttpContext = new DefaultHttpContext { User = new ClaimsPrincipal(identity) }
        };
    }

    [Fact]
    public async Task GetUserEnrollments_WithoutUserId_ReturnsUnauthorized()
    {
        SetUser(null);

        var result = await _controller.GetUserEnrollments();

        Assert.IsType<UnauthorizedResult>(result.Result);
        _service.Verify(x => x.GetUserEnrollmentsAsync(It.IsAny<string>(), It.IsAny<CancellationToken>()), Times.Never);
    }

    [Fact]
    public async Task GetUserEnrollments_Success_ReturnsEnrollments()
    {
        SetUser("user-1");
        var enrollments = new List<EnrollmentDto> { new() { Id = 1, CourseId = 5, Title = "C# Course" } };
        _service.Setup(x => x.GetUserEnrollmentsAsync("user-1", It.IsAny<CancellationToken>())).ReturnsAsync(enrollments);

        var result = await _controller.GetUserEnrollments();

        var ok = Assert.IsType<OkObjectResult>(result.Result);
        Assert.Equal(enrollments, ok.Value);
    }

    [Fact]
    public async Task EnrollInCourse_WithoutUserId_ReturnsUnauthorized()
    {
        SetUser(null);

        var result = await _controller.EnrollInCourse(5);

        Assert.IsType<UnauthorizedResult>(result.Result);
        _service.Verify(x => x.CreateEnrollmentAsync(It.IsAny<string>(), It.IsAny<int>(), It.IsAny<CancellationToken>()), Times.Never);
    }

    [Fact]
    public async Task EnrollInCourse_Success_ReturnsCreated()
    {
        SetUser("user-1");
        var enrollment = new EnrollmentDto { Id = 10, CourseId = 5 };
        _service.Setup(x => x.CreateEnrollmentAsync("user-1", 5, It.IsAny<CancellationToken>())).ReturnsAsync(enrollment);

        var result = await _controller.EnrollInCourse(5);

        var created = Assert.IsType<CreatedAtActionResult>(result.Result);
        Assert.Equal(enrollment, created.Value);
    }

    [Fact]
    public async Task EnrollInCourse_WhenAlreadyEnrolled_ReturnsConflict()
    {
        SetUser("user-1");
        _service.Setup(x => x.CreateEnrollmentAsync("user-1", 5, It.IsAny<CancellationToken>()))
            .ThrowsAsync(new InvalidOperationException("User is already enrolled"));

        var result = await _controller.EnrollInCourse(5);

        Assert.IsType<ConflictObjectResult>(result.Result);
    }

    [Fact]
    public async Task EnrollInCourse_WhenCourseMissing_ReturnsNotFound()
    {
        SetUser("user-1");
        _service.Setup(x => x.CreateEnrollmentAsync("user-1", 99, It.IsAny<CancellationToken>()))
            .ThrowsAsync(new KeyNotFoundException("Course not found"));

        var result = await _controller.EnrollInCourse(99);

        Assert.IsType<NotFoundObjectResult>(result.Result);
    }

    [Fact]
    public async Task Unenroll_WhenMissing_ReturnsNotFound()
    {
        SetUser("user-1");
        _service.Setup(x => x.DeleteEnrollmentAsync(99, It.IsAny<CancellationToken>())).ReturnsAsync(false);

        var result = await _controller.Unenroll(99);

        Assert.IsType<NotFoundResult>(result);
    }

    [Fact]
    public async Task Unenroll_Success_ReturnsNoContent()
    {
        SetUser("user-1");
        _service.Setup(x => x.DeleteEnrollmentAsync(10, It.IsAny<CancellationToken>())).ReturnsAsync(true);

        var result = await _controller.Unenroll(10);

        Assert.IsType<NoContentResult>(result);
    }

    [Fact]
    public async Task GetEnrollmentById_WhenMissing_ReturnsNotFound()
    {
        SetUser("user-1");
        _service.Setup(x => x.GetEnrollmentByIdAsync(99, It.IsAny<CancellationToken>()))
            .ReturnsAsync((EnrollmentDto)null!);

        var result = await _controller.GetEnrollmentById(99);

        Assert.IsType<NotFoundResult>(result.Result);
    }
}

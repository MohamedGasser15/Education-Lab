using EduLab_API.Controllers.Learner;
using EduLab_Application.Common;
using EduLab_Application.DTOs.CourseProgress;
using EduLab_Application.DTOs.Enrollment;
using EduLab_Application.ServiceInterfaces;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using Moq;
using Xunit;

namespace EduLab.Tests.Controllers;

public class LearnerCourseProgressControllerTests
{
    private readonly Mock<ICourseProgressService> _progressService;
    private readonly Mock<IEnrollmentService> _enrollmentService;
    private readonly Mock<ICurrentUserService> _currentUser;
    private readonly CourseProgressController _controller;

    public LearnerCourseProgressControllerTests()
    {
        _progressService = new Mock<ICourseProgressService>();
        _enrollmentService = new Mock<IEnrollmentService>();
        _currentUser = new Mock<ICurrentUserService>();
        _controller = new CourseProgressController(
            _progressService.Object,
            _enrollmentService.Object,
            _currentUser.Object,
            Mock.Of<ILogger<CourseProgressController>>());
    }

    private void SetUser(string? userId)
    {
        _currentUser.Setup(x => x.GetUserIdAsync()).ReturnsAsync(userId);
        _controller.ControllerContext = new ControllerContext { HttpContext = new DefaultHttpContext() };
    }

    private void SetEnrollment(string userId, int courseId, int enrollmentId = 5)
    {
        _enrollmentService.Setup(x => x.GetUserCourseEnrollmentAsync(userId, courseId, It.IsAny<CancellationToken>()))
            .ReturnsAsync(new EnrollmentDto { Id = enrollmentId, CourseId = courseId });
    }

    [Fact]
    public async Task MarkLectureCompleted_NullRequest_ReturnsBadRequest()
    {
        SetUser("user-1");

        var result = await _controller.MarkLectureAsCompleted(null!);

        Assert.IsType<BadRequestObjectResult>(result);
        _progressService.Verify(x => x.MarkLectureAsCompletedAsync(It.IsAny<int>(), It.IsAny<int>(), It.IsAny<CancellationToken>()), Times.Never);
    }

    [Fact]
    public async Task MarkLectureCompleted_InvalidIds_ReturnsBadRequest()
    {
        SetUser("user-1");

        var result = await _controller.MarkLectureAsCompleted(new MarkLectureCompletedRequest { CourseId = 0, LectureId = 3 });

        Assert.IsType<BadRequestObjectResult>(result);
    }

    [Fact]
    public async Task MarkLectureCompleted_WithoutUser_ReturnsUnauthorized()
    {
        SetUser(null);

        var result = await _controller.MarkLectureAsCompleted(new MarkLectureCompletedRequest { CourseId = 1, LectureId = 3 });

        Assert.IsType<UnauthorizedObjectResult>(result);
        _enrollmentService.Verify(x => x.GetUserCourseEnrollmentAsync(It.IsAny<string>(), It.IsAny<int>(), It.IsAny<CancellationToken>()), Times.Never);
    }

    [Fact]
    public async Task MarkLectureCompleted_WhenNotEnrolled_ReturnsBadRequest()
    {
        SetUser("user-1");
        _enrollmentService.Setup(x => x.GetUserCourseEnrollmentAsync("user-1", 1, It.IsAny<CancellationToken>()))
            .ReturnsAsync((EnrollmentDto)null!);

        var result = await _controller.MarkLectureAsCompleted(new MarkLectureCompletedRequest { CourseId = 1, LectureId = 3 });

        Assert.IsType<BadRequestObjectResult>(result);
        _progressService.Verify(x => x.MarkLectureAsCompletedAsync(It.IsAny<int>(), It.IsAny<int>(), It.IsAny<CancellationToken>()), Times.Never);
    }

    [Fact]
    public async Task MarkLectureCompleted_Success_ReturnsProgress()
    {
        SetUser("user-1");
        SetEnrollment("user-1", 1);
        var progress = new CourseProgressDto { Id = 7, EnrollmentId = 5, LectureId = 3, IsCompleted = true };
        _progressService.Setup(x => x.MarkLectureAsCompletedAsync(5, 3, It.IsAny<CancellationToken>()))
            .ReturnsAsync(progress);

        var result = await _controller.MarkLectureAsCompleted(new MarkLectureCompletedRequest { CourseId = 1, LectureId = 3 });

        var ok = Assert.IsType<OkObjectResult>(result);
        var response = Assert.IsType<ApiResponse<CourseProgressDto>>(ok.Value);
        Assert.True(response.Success);
        Assert.Equal(progress, response.Data);
    }

    [Fact]
    public async Task MarkLectureIncomplete_WhenProgressMissing_ReturnsBadRequest()
    {
        SetUser("user-1");
        SetEnrollment("user-1", 1);
        _progressService.Setup(x => x.MarkLectureAsIncompleteAsync(5, 3, It.IsAny<CancellationToken>()))
            .ReturnsAsync((CourseProgressDto)null!);

        var result = await _controller.MarkLectureAsIncomplete(new MarkLectureCompletedRequest { CourseId = 1, LectureId = 3 });

        Assert.IsType<BadRequestObjectResult>(result);
    }

    [Fact]
    public async Task MarkLectureIncomplete_Success_ReturnsProgress()
    {
        SetUser("user-1");
        SetEnrollment("user-1", 1);
        var progress = new CourseProgressDto { Id = 7, EnrollmentId = 5, LectureId = 3, IsCompleted = false };
        _progressService.Setup(x => x.MarkLectureAsIncompleteAsync(5, 3, It.IsAny<CancellationToken>()))
            .ReturnsAsync(progress);

        var result = await _controller.MarkLectureAsIncomplete(new MarkLectureCompletedRequest { CourseId = 1, LectureId = 3 });

        var ok = Assert.IsType<OkObjectResult>(result);
        var response = Assert.IsType<ApiResponse<CourseProgressDto>>(ok.Value);
        Assert.True(response.Success);
        Assert.Equal(progress, response.Data);
    }

    [Fact]
    public async Task GetCourseProgress_WithoutUser_ReturnsUnauthorized()
    {
        SetUser(null);

        var result = await _controller.GetCourseProgress(1);

        Assert.IsType<UnauthorizedObjectResult>(result);
    }

    [Fact]
    public async Task GetCourseProgress_WhenNotEnrolled_ReturnsBadRequest()
    {
        SetUser("user-1");
        _enrollmentService.Setup(x => x.GetUserCourseEnrollmentAsync("user-1", 1, It.IsAny<CancellationToken>()))
            .ReturnsAsync((EnrollmentDto)null!);

        var result = await _controller.GetCourseProgress(1);

        Assert.IsType<BadRequestObjectResult>(result);
    }

    [Fact]
    public async Task GetCourseProgress_Success_ReturnsSummary()
    {
        SetUser("user-1");
        SetEnrollment("user-1", 1);
        var summary = new CourseProgressSummaryDto { EnrollmentId = 5, CourseId = 1, ProgressPercentage = 75 };
        _progressService.Setup(x => x.GetCourseProgressSummaryAsync(5, It.IsAny<CancellationToken>()))
            .ReturnsAsync(summary);

        var result = await _controller.GetCourseProgress(1);

        var ok = Assert.IsType<OkObjectResult>(result);
        var response = Assert.IsType<ApiResponse<CourseProgressSummaryDto>>(ok.Value);
        Assert.True(response.Success);
        Assert.Equal(summary, response.Data);
    }

    [Fact]
    public async Task GetProgressSummary_WhenSummaryMissing_ReturnsNotFound()
    {
        _progressService.Setup(x => x.GetCourseProgressSummaryAsync(99, It.IsAny<CancellationToken>()))
            .ReturnsAsync((CourseProgressSummaryDto)null!);

        var result = await _controller.GetProgressSummary(99);

        Assert.IsType<NotFoundObjectResult>(result);
    }

    [Fact]
    public async Task GetProgressSummary_Success_ReturnsSummary()
    {
        var summary = new CourseProgressSummaryDto { EnrollmentId = 5, CourseId = 1, ProgressPercentage = 40 };
        _progressService.Setup(x => x.GetCourseProgressSummaryAsync(5, It.IsAny<CancellationToken>()))
            .ReturnsAsync(summary);

        var result = await _controller.GetProgressSummary(5);

        var ok = Assert.IsType<OkObjectResult>(result);
        var response = Assert.IsType<ApiResponse<CourseProgressSummaryDto>>(ok.Value);
        Assert.True(response.Success);
        Assert.Equal(summary, response.Data);
    }
}

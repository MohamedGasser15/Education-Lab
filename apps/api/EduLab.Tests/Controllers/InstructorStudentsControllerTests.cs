using EduLab_API.Controllers.Instructor;
using EduLab_Application.Common;
using EduLab_Application.DTOs.Notification;
using EduLab_Application.DTOs.Student;
using EduLab_Application.ServiceInterfaces;
using EduLab_Domain.Entities;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using Moq;
using Xunit;

namespace EduLab.Tests.Controllers;

public class InstructorStudentsControllerTests
{
    private readonly Mock<IStudentService> _studentService;
    private readonly Mock<ICurrentUserService> _currentUser;
    private readonly Mock<IHistoryService> _historyService;
    private readonly Mock<INotificationService> _notificationService;
    private readonly StudentsController _controller;

    public InstructorStudentsControllerTests()
    {
        _studentService = new Mock<IStudentService>();
        _currentUser = new Mock<ICurrentUserService>();
        _historyService = new Mock<IHistoryService>();
        _notificationService = new Mock<INotificationService>();
        _controller = new StudentsController(
            _studentService.Object,
            Mock.Of<ILogger<StudentsController>>(),
            _currentUser.Object,
            _historyService.Object,
            _notificationService.Object);
    }

    private void SetUserId(string? userId)
    {
        _currentUser.Setup(x => x.GetUserIdAsync()).ReturnsAsync(userId);
        _controller.ControllerContext = new ControllerContext
        {
            HttpContext = new DefaultHttpContext()
        };
    }

    [Fact]
    public async Task GetStudents_ReturnsStudentsAndLogsHistory()
    {
        SetUserId("ins-1");
        var students = new List<StudentDto> { new() { Id = "s-1", FullName = "Ali" } };
        _studentService.Setup(x => x.GetStudentsAsync(It.IsAny<CancellationToken>()))
            .ReturnsAsync(students);

        var result = await _controller.GetStudents();

        var ok = Assert.IsType<OkObjectResult>(result);
        var response = Assert.IsType<ApiResponse<List<StudentDto>>>(ok.Value);
        Assert.Equal(students, response.Data);
        _historyService.Verify(x => x.LogOperationAsync(
            "ins-1",
            It.IsAny<string>(),
            It.IsAny<OperationType?>(),
            It.IsAny<string?>(),
            It.IsAny<string?>(),
            It.IsAny<CancellationToken>()), Times.Once);
    }

    [Fact]
    public async Task GetStudentsSummary_WithoutUserId_ReturnsUnauthorized()
    {
        SetUserId(null);

        var result = await _controller.GetStudentsSummary();

        Assert.IsType<UnauthorizedObjectResult>(result);
        _studentService.Verify(x => x.GetStudentsSummaryByInstructorAsync(
            It.IsAny<string>(), It.IsAny<CancellationToken>()), Times.Never);
    }

    [Fact]
    public async Task GetStudentsSummary_ReturnsSummary()
    {
        SetUserId("ins-1");
        var summary = new StudentsSummaryDto { TotalStudents = 12, ActiveStudents = 9 };
        _studentService.Setup(x => x.GetStudentsSummaryByInstructorAsync("ins-1", It.IsAny<CancellationToken>()))
            .ReturnsAsync(summary);

        var result = await _controller.GetStudentsSummary();

        var ok = Assert.IsType<OkObjectResult>(result);
        var response = Assert.IsType<ApiResponse<StudentsSummaryDto>>(ok.Value);
        Assert.Equal(summary, response.Data);
    }

    [Fact]
    public async Task GetMyStudents_WithoutUserId_ReturnsUnauthorized()
    {
        SetUserId("");

        var result = await _controller.GetMyStudents();

        Assert.IsType<UnauthorizedObjectResult>(result);
        _studentService.Verify(x => x.GetStudentsByInstructorAsync(
            It.IsAny<string>(), It.IsAny<CancellationToken>()), Times.Never);
    }

    [Fact]
    public async Task GetMyStudents_ReturnsStudents()
    {
        SetUserId("ins-1");
        var students = new List<StudentDto> { new() { Id = "s-1", FullName = "Ali" } };
        _studentService.Setup(x => x.GetStudentsByInstructorAsync("ins-1", It.IsAny<CancellationToken>()))
            .ReturnsAsync(students);

        var result = await _controller.GetMyStudents();

        var ok = Assert.IsType<OkObjectResult>(result);
        var response = Assert.IsType<ApiResponse<List<StudentDto>>>(ok.Value);
        Assert.Equal(students, response.Data);
    }

    [Fact]
    public async Task GetStudentDetails_WithEmptyId_ReturnsBadRequest()
    {
        SetUserId("ins-1");

        var result = await _controller.GetStudentDetails("  ");

        Assert.IsType<BadRequestObjectResult>(result);
        _studentService.Verify(x => x.GetStudentDetailsAsync(
            It.IsAny<string>(), It.IsAny<CancellationToken>()), Times.Never);
    }

    [Fact]
    public async Task GetStudentDetails_MissingStudent_ReturnsNotFound()
    {
        SetUserId("ins-1");
        _studentService.Setup(x => x.GetStudentDetailsAsync("s-99", It.IsAny<CancellationToken>()))
            .ReturnsAsync((StudentDetailsDto)null!);

        var result = await _controller.GetStudentDetails("s-99");

        Assert.IsType<NotFoundObjectResult>(result);
    }

    [Fact]
    public async Task SendNotification_WithNullRequest_ReturnsBadRequest()
    {
        SetUserId("ins-1");

        var result = await _controller.SendNotification(null!);

        Assert.IsType<BadRequestObjectResult>(result);
        _notificationService.Verify(x => x.SendInstructorNotificationAsync(
            It.IsAny<InstructorNotificationRequestDto>(), It.IsAny<string>()), Times.Never);
    }

    [Fact]
    public async Task SendNotification_WithValidRequest_ReturnsOk()
    {
        SetUserId("ins-1");
        var bulk = new BulkNotificationResultDto { TotalUsers = 5, NotificationsSent = 5 };
        _notificationService.Setup(x => x.SendInstructorNotificationAsync(
                It.IsAny<InstructorNotificationRequestDto>(), "ins-1"))
            .ReturnsAsync(bulk);

        var result = await _controller.SendNotification(
            new InstructorNotificationRequestDto { Title = "T", Message = "M" });

        var ok = Assert.IsType<OkObjectResult>(result);
        var response = Assert.IsType<ApiResponse<BulkNotificationResultDto>>(ok.Value);
        Assert.Equal(bulk, response.Data);
    }

    [Fact]
    public async Task SendNotification_WhenServiceFails_ReturnsBadRequest()
    {
        SetUserId("ins-1");
        _notificationService.Setup(x => x.SendInstructorNotificationAsync(
                It.IsAny<InstructorNotificationRequestDto>(), "ins-1"))
            .ReturnsAsync(new BulkNotificationResultDto { Errors = new List<string> { "Failed" } });

        var result = await _controller.SendNotification(
            new InstructorNotificationRequestDto { Title = "T", Message = "M" });

        Assert.IsType<BadRequestObjectResult>(result);
    }

    [Fact]
    public async Task GetStudentsProgress_WithEmptyIds_ReturnsBadRequest()
    {
        SetUserId("ins-1");

        var result = await _controller.GetStudentsProgress(new List<string>());

        Assert.IsType<BadRequestObjectResult>(result);
        _studentService.Verify(x => x.GetStudentsProgressAsync(
            It.IsAny<List<string>>(), It.IsAny<CancellationToken>()), Times.Never);
    }

    [Fact]
    public async Task GetStudentsProgress_ReturnsProgress()
    {
        SetUserId("ins-1");
        var ids = new List<string> { "s-1", "s-2" };
        var progress = new List<StudentProgressDto> { new() { CourseId = 1, ProgressPercentage = 60 } };
        _studentService.Setup(x => x.GetStudentsProgressAsync(ids, It.IsAny<CancellationToken>()))
            .ReturnsAsync(progress);

        var result = await _controller.GetStudentsProgress(ids);

        var ok = Assert.IsType<OkObjectResult>(result);
        var response = Assert.IsType<ApiResponse<List<StudentProgressDto>>>(ok.Value);
        Assert.Equal(progress, response.Data);
    }
}

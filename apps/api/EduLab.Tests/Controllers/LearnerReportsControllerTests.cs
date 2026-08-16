using EduLab_API.Controllers.Learner;
using EduLab_Application.DTOs.Report;
using EduLab_Application.ServiceInterfaces;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using Moq;
using Xunit;

namespace EduLab.Tests.Controllers;

public class LearnerReportsControllerTests
{
    private readonly Mock<IReportService> _service;
    private readonly ReportsController _controller;

    public LearnerReportsControllerTests()
    {
        _service = new Mock<IReportService>();
        _controller = new ReportsController(_service.Object, Mock.Of<ILogger<ReportsController>>());
    }

    private void SetUser(string userId)
    {
        _controller.ControllerContext = new ControllerContext
        {
            HttpContext = new DefaultHttpContext
            {
                User = new System.Security.Claims.ClaimsPrincipal(new System.Security.Claims.ClaimsIdentity(
                    new[] { new System.Security.Claims.Claim(System.Security.Claims.ClaimTypes.NameIdentifier, userId) }))
            }
        };
    }

    private static CreateReportDto ValidReport(string type = "Course") =>
        new() { Type = type, TargetId = 5, Reason = "Spam" };

    [Fact]
    public async Task Create_WithoutUserId_ReturnsUnauthorized()
    {
        SetUser("");

        var result = await _controller.Create(ValidReport(), CancellationToken.None);

        Assert.IsType<UnauthorizedResult>(result);
        _service.Verify(x => x.CreateReportAsync(
            It.IsAny<string>(), It.IsAny<CreateReportDto>(), It.IsAny<CancellationToken>()), Times.Never);
    }

    [Fact]
    public async Task Create_WithInvalidType_ReturnsBadRequest()
    {
        SetUser("user-1");
        _service.Setup(x => x.CreateReportAsync("user-1", It.IsAny<CreateReportDto>(), It.IsAny<CancellationToken>()))
            .ThrowsAsync(new ArgumentException("Invalid report type"));

        var result = await _controller.Create(ValidReport("Bogus"), CancellationToken.None);

        Assert.IsType<BadRequestObjectResult>(result);
    }

    [Fact]
    public async Task Create_ReturnsOkWithReportId()
    {
        SetUser("user-1");
        _service.Setup(x => x.CreateReportAsync("user-1", It.IsAny<CreateReportDto>(), It.IsAny<CancellationToken>()))
            .ReturnsAsync(new AdminReportDto { Id = 5 });

        var result = await _controller.Create(ValidReport(), CancellationToken.None);

        Assert.IsType<OkObjectResult>(result);
    }

    [Fact]
    public async Task Create_MissingTarget_ReturnsNotFound()
    {
        SetUser("user-1");
        _service.Setup(x => x.CreateReportAsync("user-1", It.IsAny<CreateReportDto>(), It.IsAny<CancellationToken>()))
            .ThrowsAsync(new KeyNotFoundException("Target not found"));

        var result = await _controller.Create(ValidReport(), CancellationToken.None);

        Assert.IsType<NotFoundObjectResult>(result);
    }

    [Fact]
    public async Task Create_DuplicateReport_ReturnsConflict()
    {
        SetUser("user-1");
        _service.Setup(x => x.CreateReportAsync("user-1", It.IsAny<CreateReportDto>(), It.IsAny<CancellationToken>()))
            .ThrowsAsync(new InvalidOperationException("Already reported"));

        var result = await _controller.Create(ValidReport(), CancellationToken.None);

        Assert.IsType<ConflictObjectResult>(result);
    }

    [Fact]
    public async Task Check_WithoutUserId_ReturnsUnauthorized()
    {
        SetUser("");

        var result = await _controller.Check("Course", 5, CancellationToken.None);

        Assert.IsType<UnauthorizedResult>(result);
        _service.Verify(x => x.HasReportedAsync(
            It.IsAny<string>(), It.IsAny<string>(), It.IsAny<int>(), It.IsAny<CancellationToken>()), Times.Never);
    }

    [Fact]
    public async Task Check_ReturnsReportedFlag()
    {
        SetUser("user-1");
        _service.Setup(x => x.HasReportedAsync("user-1", "Course", 5, It.IsAny<CancellationToken>()))
            .ReturnsAsync(true);

        var result = await _controller.Check("Course", 5, CancellationToken.None);

        Assert.IsType<OkObjectResult>(result);
    }
}

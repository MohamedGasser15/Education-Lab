using EduLab_API.Controllers.Instructor;
using EduLab_Application.DTOs.Dashboard;
using EduLab_Application.ServiceInterfaces;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using Moq;
using Xunit;

namespace EduLab.Tests.Controllers;

public class InstructorDashboardControllerTests
{
    private readonly Mock<IDashboardService> _dashboardService;
    private readonly Mock<ICurrentUserService> _currentUser;
    private readonly DashboardController _controller;

    public InstructorDashboardControllerTests()
    {
        _dashboardService = new Mock<IDashboardService>();
        _currentUser = new Mock<ICurrentUserService>();
        _controller = new DashboardController(
            _dashboardService.Object,
            _currentUser.Object,
            Mock.Of<ILogger<DashboardController>>());
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
    public async Task GetInstructorDashboard_WithoutUserId_ReturnsUnauthorized()
    {
        SetUserId(null);

        var result = await _controller.GetInstructorDashboard();

        Assert.IsType<UnauthorizedObjectResult>(result.Result);
        _dashboardService.Verify(x => x.GetInstructorDashboardAsync(
            It.IsAny<string>(), It.IsAny<CancellationToken>()), Times.Never);
    }

    [Fact]
    public async Task GetInstructorDashboard_ReturnsDashboard()
    {
        SetUserId("ins-1");
        var dashboard = new InstructorDashboardDto
        {
            CoursesCount = 5,
            StudentsCount = 120,
            TotalEarnings = 5000m
        };
        _dashboardService.Setup(x => x.GetInstructorDashboardAsync("ins-1", It.IsAny<CancellationToken>()))
            .ReturnsAsync(dashboard);

        var result = await _controller.GetInstructorDashboard();

        var ok = Assert.IsType<OkObjectResult>(result.Result);
        Assert.Equal(dashboard, ok.Value);
    }

    [Fact]
    public async Task GetInstructorRevenue_WithoutUserId_ReturnsUnauthorized()
    {
        SetUserId(null);

        var result = await _controller.GetInstructorRevenue("month");

        Assert.IsType<UnauthorizedObjectResult>(result.Result);
        _dashboardService.Verify(x => x.GetInstructorRevenueAsync(
            It.IsAny<string>(), It.IsAny<string>(), It.IsAny<CancellationToken>()), Times.Never);
    }

    [Fact]
    public async Task GetInstructorRevenue_PassesPeriodToService()
    {
        SetUserId("ins-1");
        var revenue = new InstructorRevenueDto { TotalRevenue = 1500m, TotalSales = 20 };
        _dashboardService.Setup(x => x.GetInstructorRevenueAsync("ins-1", "month", It.IsAny<CancellationToken>()))
            .ReturnsAsync(revenue);

        var result = await _controller.GetInstructorRevenue("month");

        var ok = Assert.IsType<OkObjectResult>(result.Result);
        Assert.Equal(revenue, ok.Value);
    }

    [Fact]
    public async Task GetInstructorDashboard_WhenServiceThrows_Returns500()
    {
        SetUserId("ins-1");
        _dashboardService.Setup(x => x.GetInstructorDashboardAsync("ins-1", It.IsAny<CancellationToken>()))
            .ThrowsAsync(new Exception("boom"));

        var result = await _controller.GetInstructorDashboard();

        var error = Assert.IsType<ObjectResult>(result.Result);
        Assert.Equal(500, error.StatusCode);
    }
}

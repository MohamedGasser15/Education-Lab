using EduLab_API.Controllers.Admin;
using EduLab_Application.DTOs.Dashboard;
using EduLab_Application.ServiceInterfaces;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using Moq;
using Xunit;

namespace EduLab.Tests.Controllers;

public class DashboardControllerTests
{
    private readonly Mock<IDashboardService> _dashboardService;
    private readonly DashboardController _controller;

    public DashboardControllerTests()
    {
        _dashboardService = new Mock<IDashboardService>();
        _controller = new DashboardController(
            _dashboardService.Object,
            Mock.Of<ILogger<DashboardController>>());
    }

    [Fact]
    public async Task GetAdminDashboard_ReturnsOkWithData()
    {
        var dashboard = new AdminDashboardDto { TotalUsers = 10, TotalCourses = 5 };
        _dashboardService.Setup(x => x.GetAdminDashboardAsync(It.IsAny<CancellationToken>()))
            .ReturnsAsync(dashboard);

        var result = await _controller.GetAdminDashboard();

        var ok = Assert.IsType<OkObjectResult>(result.Result);
        Assert.Equal(dashboard, ok.Value);
    }

    [Fact]
    public async Task GetAdminDashboard_WhenServiceThrows_ReturnsServerError()
    {
        _dashboardService.Setup(x => x.GetAdminDashboardAsync(It.IsAny<CancellationToken>()))
            .ThrowsAsync(new InvalidOperationException("db down"));

        var result = await _controller.GetAdminDashboard();

        var statusCode = Assert.IsType<ObjectResult>(result.Result);
        Assert.Equal(500, statusCode.StatusCode);
    }
}

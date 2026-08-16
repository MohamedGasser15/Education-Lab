using EduLab_API.Controllers.Learner;
using EduLab_Application.DTOs.Dashboard;
using EduLab_Application.ServiceInterfaces;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using Moq;
using Xunit;

namespace EduLab.Tests.Controllers;

public class PublicControllerTests
{
    private readonly Mock<IDashboardService> _service;
    private readonly PublicController _controller;

    public PublicControllerTests()
    {
        _service = new Mock<IDashboardService>();
        _controller = new PublicController(_service.Object, Mock.Of<ILogger<PublicController>>());
    }

    [Fact]
    public async Task GetStats_ReturnsSiteStats()
    {
        var stats = new SiteStatsDto { StudentsCount = 10, CoursesCount = 5, InstructorsCount = 2, SatisfactionPercent = 90 };
        _service.Setup(x => x.GetPublicStatsAsync(It.IsAny<CancellationToken>())).ReturnsAsync(stats);

        var result = await _controller.GetStats();

        var ok = Assert.IsType<OkObjectResult>(result.Result);
        Assert.Equal(stats, ok.Value);
    }

    [Fact]
    public async Task GetStats_OnServiceError_Returns500()
    {
        _service.Setup(x => x.GetPublicStatsAsync(It.IsAny<CancellationToken>()))
            .ThrowsAsync(new InvalidOperationException("boom"));

        var result = await _controller.GetStats();

        Assert.IsType<ObjectResult>(result.Result);
        Assert.Equal(500, ((ObjectResult)result.Result).StatusCode);
    }
}

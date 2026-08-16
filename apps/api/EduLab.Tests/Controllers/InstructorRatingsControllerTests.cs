using EduLab_API.Controllers.Instructor;
using EduLab_Application.DTOs.Rating;
using EduLab_Application.ServiceInterfaces;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using Moq;
using Xunit;

namespace EduLab.Tests.Controllers;

public class InstructorRatingsControllerTests
{
    private readonly Mock<IRatingService> _service;
    private readonly InstructorRatingsController _controller;

    public InstructorRatingsControllerTests()
    {
        _service = new Mock<IRatingService>();
        _controller = new InstructorRatingsController(
            _service.Object,
            Mock.Of<ILogger<InstructorRatingsController>>());
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

    [Fact]
    public async Task GetInstructorRatings_WithoutUserId_ReturnsUnauthorized()
    {
        SetUser("");

        var result = await _controller.GetInstructorRatings(CancellationToken.None);

        Assert.IsType<UnauthorizedResult>(result);
        _service.Verify(x => x.GetInstructorRatingsAsync(
            It.IsAny<string>(), It.IsAny<CancellationToken>()), Times.Never);
    }

    [Fact]
    public async Task GetInstructorRatings_ReturnsOverview()
    {
        SetUser("ins-1");
        var overview = new InstructorRatingsOverviewDTO();
        overview.Stats.TotalReviews = 10;
        _service.Setup(x => x.GetInstructorRatingsAsync("ins-1", It.IsAny<CancellationToken>()))
            .ReturnsAsync(overview);

        var result = await _controller.GetInstructorRatings(CancellationToken.None);

        var ok = Assert.IsType<OkObjectResult>(result);
        Assert.Equal(overview, ok.Value);
    }

    [Fact]
    public async Task GetPublicInstructorRatings_WithEmptyId_ReturnsBadRequest()
    {
        var result = await _controller.GetPublicInstructorRatings("  ", CancellationToken.None);

        Assert.IsType<BadRequestObjectResult>(result);
        _service.Verify(x => x.GetInstructorRatingsAsync(
            It.IsAny<string>(), It.IsAny<CancellationToken>()), Times.Never);
    }

    [Fact]
    public async Task GetPublicInstructorRatings_ReturnsOverview()
    {
        var overview = new InstructorRatingsOverviewDTO();
        _service.Setup(x => x.GetInstructorRatingsAsync("ins-9", It.IsAny<CancellationToken>()))
            .ReturnsAsync(overview);

        var result = await _controller.GetPublicInstructorRatings("ins-9", CancellationToken.None);

        var ok = Assert.IsType<OkObjectResult>(result);
        Assert.Equal(overview, ok.Value);
    }

    [Fact]
    public async Task GetInstructorRatings_WhenServiceThrows_Returns500()
    {
        SetUser("ins-1");
        _service.Setup(x => x.GetInstructorRatingsAsync("ins-1", It.IsAny<CancellationToken>()))
            .ThrowsAsync(new Exception("boom"));

        var result = await _controller.GetInstructorRatings(CancellationToken.None);

        var error = Assert.IsType<ObjectResult>(result);
        Assert.Equal(500, error.StatusCode);
    }
}

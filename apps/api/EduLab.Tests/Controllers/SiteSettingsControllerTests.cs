using EduLab_API.Controllers.Admin;
using EduLab_Application.DTOs.Settings;
using EduLab_Application.ServiceInterfaces;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using Moq;
using Xunit;

namespace EduLab.Tests.Controllers;

public class SiteSettingsControllerTests
{
    private readonly Mock<ISiteSettingsService> _siteSettingsService;
    private readonly Mock<ICurrentUserService> _currentUserService;
    private readonly SiteSettingsController _controller;

    public SiteSettingsControllerTests()
    {
        _siteSettingsService = new Mock<ISiteSettingsService>();
        _currentUserService = new Mock<ICurrentUserService>();
        _controller = new SiteSettingsController(
            _siteSettingsService.Object,
            _currentUserService.Object,
            Mock.Of<ILogger<SiteSettingsController>>());
    }

    [Fact]
    public async Task GetSettings_ReturnsOkWithSettings()
    {
        var settings = new SiteSettingsDTO { Id = 1, SiteName = "EduLab" };
        _siteSettingsService.Setup(x => x.GetSettingsAsync(It.IsAny<CancellationToken>()))
            .ReturnsAsync(settings);

        var result = await _controller.GetSettings();

        var ok = Assert.IsType<OkObjectResult>(result);
        Assert.Equal(settings, ok.Value);
    }

    [Fact]
    public async Task UpdateSettings_WithNullDto_ReturnsBadRequest()
    {
        var result = await _controller.UpdateSettings(null!);

        Assert.IsType<BadRequestObjectResult>(result);
        _siteSettingsService.Verify(x => x.UpdateSettingsAsync(It.IsAny<SiteSettingsDTO>(), It.IsAny<string?>(), It.IsAny<CancellationToken>()), Times.Never);
    }

    [Fact]
    public async Task UpdateSettings_WhenUpdateFails_ReturnsServerError()
    {
        var dto = new SiteSettingsDTO { Id = 1, SiteName = "EduLab" };
        _siteSettingsService.Setup(x => x.UpdateSettingsAsync(dto, null, It.IsAny<CancellationToken>()))
            .ReturnsAsync(false);

        var result = await _controller.UpdateSettings(dto);

        var statusCode = Assert.IsType<ObjectResult>(result);
        Assert.Equal(500, statusCode.StatusCode);
    }

    [Fact]
    public async Task UpdateSettings_Success_ReturnsOk()
    {
        var dto = new SiteSettingsDTO { Id = 1, SiteName = "EduLab" };
        _currentUserService.Setup(x => x.GetUserIdAsync()).ReturnsAsync("admin-1");
        _siteSettingsService.Setup(x => x.UpdateSettingsAsync(dto, "admin-1", It.IsAny<CancellationToken>()))
            .ReturnsAsync(true);

        var result = await _controller.UpdateSettings(dto);

        Assert.IsType<OkObjectResult>(result);
    }
}

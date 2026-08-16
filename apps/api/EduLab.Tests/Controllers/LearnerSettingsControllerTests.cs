using EduLab_API.Controllers.Learner;
using EduLab_Application.DTOs.Settings;
using EduLab_Application.ServiceInterfaces;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using Moq;
using Xunit;

namespace EduLab.Tests.Controllers;

public class LearnerSettingsControllerTests
{
    private readonly Mock<IUserSettingsService> _service;
    private readonly SettingsController _controller;

    public LearnerSettingsControllerTests()
    {
        _service = new Mock<IUserSettingsService>();
        _controller = new SettingsController(
            _service.Object,
            Mock.Of<ILogger<SettingsController>>());
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
    public async Task GetGeneralSettings_ReturnsSettings()
    {
        SetUser("user-1");
        var settings = new GeneralSettingsDTO { Email = "ahmed@test.com", FullName = "Ahmed", PhoneNumber = "01012345678" };
        _service.Setup(x => x.GetGeneralSettingsAsync("user-1", It.IsAny<CancellationToken>()))
            .ReturnsAsync(settings);

        var result = await _controller.GetGeneralSettings();

        var ok = Assert.IsType<OkObjectResult>(result);
        Assert.Same(settings, ok.Value);
    }

    [Fact]
    public async Task GetGeneralSettings_WhenUserNotFound_ReturnsNotFound()
    {
        SetUser("missing-1");
        _service.Setup(x => x.GetGeneralSettingsAsync("missing-1", It.IsAny<CancellationToken>()))
            .ReturnsAsync((GeneralSettingsDTO)null);

        var result = await _controller.GetGeneralSettings();

        Assert.IsType<NotFoundObjectResult>(result);
    }

    [Fact]
    public async Task UpdateGeneralSettings_WithInvalidModel_ReturnsBadRequest()
    {
        SetUser("user-1");
        _controller.ModelState.AddModelError("Email", "صيغة البريد الإلكتروني غير صحيحة");

        var result = await _controller.UpdateGeneralSettings(new GeneralSettingsDTO());

        Assert.IsType<BadRequestObjectResult>(result);
        _service.Verify(x => x.UpdateGeneralSettingsAsync(It.IsAny<string>(), It.IsAny<GeneralSettingsDTO>(), It.IsAny<CancellationToken>()), Times.Never);
    }

    [Fact]
    public async Task UpdateGeneralSettings_WithValidData_UpdatesAndReturnsOk()
    {
        SetUser("user-1");
        var settings = new GeneralSettingsDTO { Email = "ahmed@test.com", FullName = "Ahmed Ali" };
        _service.Setup(x => x.UpdateGeneralSettingsAsync("user-1", settings, It.IsAny<CancellationToken>()))
            .ReturnsAsync(true);

        var result = await _controller.UpdateGeneralSettings(settings);

        Assert.IsType<OkObjectResult>(result);
        _service.Verify(x => x.UpdateGeneralSettingsAsync("user-1", settings, It.IsAny<CancellationToken>()), Times.Once);
    }

    [Fact]
    public async Task UpdateGeneralSettings_WhenUpdateFails_ReturnsBadRequest()
    {
        SetUser("user-1");
        var settings = new GeneralSettingsDTO { Email = "ahmed@test.com", FullName = "Ahmed Ali" };
        _service.Setup(x => x.UpdateGeneralSettingsAsync("user-1", settings, It.IsAny<CancellationToken>()))
            .ReturnsAsync(false);

        var result = await _controller.UpdateGeneralSettings(settings);

        Assert.IsType<BadRequestObjectResult>(result);
    }
}

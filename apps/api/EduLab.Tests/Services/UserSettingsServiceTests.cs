using EduLab_Application.DTOs.Settings;
using EduLab_Application.ServiceInterfaces;
using EduLab_Application.Services;
using EduLab_Domain.Entities;
using EduLab_Domain.IRepository;
using EduLab.Tests.Fakes;
using Microsoft.AspNetCore.Identity;
using Moq;
using Xunit;

namespace EduLab.Tests.Services;

public class UserSettingsServiceTests
{
    private readonly ApplicationUser _user;
    private readonly Mock<UserManager<ApplicationUser>> _userManager;
    private readonly Mock<IEmailSender> _emailSender;
    private readonly Mock<IIpService> _ipService;
    private readonly Mock<ITokenService> _tokenService;
    private readonly UserSettingsService _service;

    public UserSettingsServiceTests()
    {
        _user = TestData.User("user-1", "Ahmed");
        _userManager = TestData.MockUserManager(new List<ApplicationUser> { _user });
        _userManager.Setup(x => x.ChangePasswordAsync(_user, It.IsAny<string>(), It.IsAny<string>()))
            .ReturnsAsync(IdentityResult.Success);
        _userManager.Setup(x => x.UpdateAsync(_user)).ReturnsAsync(IdentityResult.Success);

        _emailSender = new Mock<IEmailSender>();
        _ipService = new Mock<IIpService>();
        _ipService.Setup(x => x.GetClientIpAddress()).Returns("1.2.3.4");
        _ipService.Setup(x => x.GetDeviceInfo()).Returns("Chrome on Windows");
        _ipService.Setup(x => x.CreateUserSessionAsync(It.IsAny<string>(), It.IsAny<string>()))
            .Returns(Task.CompletedTask);
        _tokenService = new Mock<ITokenService>();
        _tokenService.Setup(x => x.GenerateAccessToken(_user)).ReturnsAsync("new-token");

        var links = new Mock<ILinkBuilderService>();
        links.Setup(x => x.GenerateResetPasswordLink(It.IsAny<string>()))
            .Returns("https://edulab.runasp.net/Learner/Auth/ForgotPassword");

        var emailTemplates = new Mock<IEmailTemplateService>();
        emailTemplates.Setup(x => x.GeneratePasswordChangeEmail(
                It.IsAny<ApplicationUser>(), It.IsAny<string>(), It.IsAny<string>(),
                It.IsAny<DateTime>(), It.IsAny<string>(), It.IsAny<string>()))
            .Returns("<html></html>");
        emailTemplates.Setup(x => x.GetLocalizedText(It.IsAny<string>(), It.IsAny<string>()))
            .Returns("subject");

        _service = new UserSettingsService(
            TestInfrastructure.RealMapper(),
            _userManager.Object,
            links.Object,
            _emailSender.Object,
            emailTemplates.Object,
            _ipService.Object,
            Mock.Of<ISessionRepository>(),
            _tokenService.Object,
            TestData.NullLogger<UserSettingsService>());
    }

    private static ChangePasswordDTO ChangePassword(string current, string updated) => new()
    {
        CurrentPassword = current,
        NewPassword = updated,
        ConfirmPassword = updated
    };

    [Fact]
    public async Task ChangePasswordAsync_WrongCurrentPassword_ReturnsFalse_AndSendsNoEmail()
    {
        _userManager.Setup(x => x.ChangePasswordAsync(_user, "wrong", It.IsAny<string>()))
            .ReturnsAsync(IdentityResult.Failed(new IdentityError { Description = "Incorrect password." }));

        var result = await _service.ChangePasswordAsync("user-1", ChangePassword("wrong", "NewPass123!"));

        Assert.False(result);
        _emailSender.Verify(x => x.SendEmailAsync(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<string>()),
            Times.Never);
        _ipService.Verify(x => x.CreateUserSessionAsync(It.IsAny<string>(), It.IsAny<string>()), Times.Never);
    }

    [Fact]
    public async Task ChangePasswordAsync_Success_SendsEmailAndStartsSession()
    {
        var result = await _service.ChangePasswordAsync("user-1", ChangePassword("OldPass123!", "NewPass123!"));

        Assert.True(result);
        _emailSender.Verify(x => x.SendEmailAsync("Ahmed@test.com", It.IsAny<string>(), It.IsAny<string>()),
            Times.Once);
        _ipService.Verify(x => x.CreateUserSessionAsync("user-1", "new-token"), Times.Once);
    }

    [Fact]
    public async Task ChangePasswordAsync_UnknownUser_ReturnsFalse()
    {
        var result = await _service.ChangePasswordAsync("missing", ChangePassword("old", "NewPass123!"));

        Assert.False(result);
        _emailSender.Verify(x => x.SendEmailAsync(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<string>()),
            Times.Never);
    }

    [Fact]
    public async Task GetGeneralSettingsAsync_UnknownUser_ReturnsNull()
    {
        var result = await _service.GetGeneralSettingsAsync("missing");

        Assert.Null(result);
    }

    [Fact]
    public async Task GetGeneralSettingsAsync_MapsUserSettings()
    {
        var result = await _service.GetGeneralSettingsAsync("user-1");

        Assert.NotNull(result);
        Assert.Equal("Ahmed", result.FullName);
        Assert.Equal("Ahmed@test.com", result.Email);
    }

    [Fact]
    public async Task UpdateGeneralSettingsAsync_ChangedEmail_MarksEmailUnconfirmed()
    {
        var result = await _service.UpdateGeneralSettingsAsync("user-1", new GeneralSettingsDTO
        {
            Email = "new@test.com",
            FullName = "Ahmed Ali",
            PhoneNumber = "010000"
        });

        Assert.True(result);
        Assert.Equal("new@test.com", _user.Email);
        Assert.False(_user.EmailConfirmed);
    }
}

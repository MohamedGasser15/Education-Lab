using EduLab_Application.DTOs.Auth;
using EduLab_Application.DTOs.Token;
using EduLab_Application.ServiceInterfaces;
using EduLab_Application.Services;
using EduLab_Domain.Entities;
using EduLab_Domain.IRepository;
using EduLab.Tests.Fakes;
using Microsoft.AspNetCore.Identity;
using Microsoft.IdentityModel.Tokens;
using Moq;
using System.Security.Claims;
using Xunit;

namespace EduLab.Tests.Services;

public class AuthServiceTests
{
    private readonly Mock<ITokenService> _tokens;
    private readonly Mock<IEmailSender> _emailSender;
    private readonly Mock<IIpService> _ipService;
    private readonly Mock<ILinkBuilderService> _links;
    private readonly Mock<IEmailTemplateService> _emailTemplates;
    private readonly Mock<IRefreshTokenRepository> _refreshTokens;
    private readonly Mock<UserManager<ApplicationUser>> _userManager;
    private readonly List<ApplicationUser> _users;
    private readonly AuthService _service;

    public AuthServiceTests()
    {
        _tokens = new Mock<ITokenService>();
        _emailSender = new Mock<IEmailSender>();
        _ipService = new Mock<IIpService>();
        _links = new Mock<ILinkBuilderService>();
        _emailTemplates = new Mock<IEmailTemplateService>();
        _refreshTokens = new Mock<IRefreshTokenRepository>();

        _users = new List<ApplicationUser> { TestData.User("user-1", "Ahmed") };
        _userManager = TestData.MockUserManager(_users);

        _tokens.Setup(x => x.GenerateAccessToken(It.IsAny<ApplicationUser>())).ReturnsAsync("access-token");
        _tokens.Setup(x => x.GenerateRefreshToken()).Returns("refresh-token");
        _ipService.Setup(x => x.GetClientIpAddress()).Returns("1.2.3.4");
        _links.Setup(x => x.GenerateResetPasswordLink(It.IsAny<string>())).Returns("https://edulab/reset");
        _emailTemplates.Setup(x => x.GenerateLoginEmail(
                It.IsAny<ApplicationUser>(), It.IsAny<string>(), It.IsAny<string>(),
                It.IsAny<DateTime>(), It.IsAny<string>(), It.IsAny<string>()))
            .Returns("<html>login</html>");
        _emailTemplates.Setup(x => x.GetLocalizedText(It.IsAny<string>(), It.IsAny<string>())).Returns("subject");
        _emailSender.Setup(x => x.SendEmailAsync(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<string>()))
            .Returns(Task.CompletedTask);

        _service = new AuthService(
            _tokens.Object,
            TestInfrastructure.RealMapper(),
            _emailSender.Object,
            _ipService.Object,
            _links.Object,
            _emailTemplates.Object,
            _userManager.Object,
            _refreshTokens.Object,
            TestData.NullLogger<AuthService>());
    }

    [Fact]
    public async Task Login_ValidCredentials_ReturnsTokensAndSavesRefreshToken()
    {
        _userManager.Setup(x => x.FindByNameAsync("Ahmed@test.com")).ReturnsAsync(_users[0]);
        _userManager.Setup(x => x.IsLockedOutAsync(It.IsAny<ApplicationUser>())).ReturnsAsync(false);
        _userManager.Setup(x => x.CheckPasswordAsync(It.IsAny<ApplicationUser>(), "correct-password")).ReturnsAsync(true);
        _userManager.Setup(x => x.ResetAccessFailedCountAsync(It.IsAny<ApplicationUser>())).ReturnsAsync(IdentityResult.Success);

        var result = await _service.Login(new LoginRequestDTO { Email = "Ahmed@test.com", Password = "correct-password" });

        Assert.NotNull(result);
        Assert.Equal("access-token", result.Token);
        Assert.Equal("refresh-token", result.RefreshToken);
        Assert.NotNull(result.User);
        Assert.Equal("Ahmed", result.User.FullName);
        Assert.Equal("Student", result.User.Role);
        Assert.False(result.IsBanned);
        Assert.False(result.IsLockedOut);

        _refreshTokens.Verify(x => x.SaveRefreshTokenAsync(
            "user-1", "refresh-token", It.Is<DateTime>(d => d > DateTime.UtcNow.AddDays(6))), Times.Once);
        _ipService.Verify(x => x.CreateUserSessionAsync("user-1", "access-token"), Times.Once);
        _userManager.Verify(x => x.ResetAccessFailedCountAsync(_users[0]), Times.Once);
    }

    [Fact]
    public async Task Login_WrongPassword_ReturnsNullAndCountsFailure()
    {
        _userManager.Setup(x => x.FindByNameAsync("Ahmed@test.com")).ReturnsAsync(_users[0]);
        _userManager.Setup(x => x.IsLockedOutAsync(It.IsAny<ApplicationUser>())).ReturnsAsync(false);
        _userManager.Setup(x => x.CheckPasswordAsync(It.IsAny<ApplicationUser>(), It.IsAny<string>())).ReturnsAsync(false);
        _userManager.Setup(x => x.AccessFailedAsync(It.IsAny<ApplicationUser>())).ReturnsAsync(IdentityResult.Success);
        _userManager.Setup(x => x.GetAccessFailedCountAsync(It.IsAny<ApplicationUser>())).ReturnsAsync(1);

        var result = await _service.Login(new LoginRequestDTO { Email = "Ahmed@test.com", Password = "wrong" });

        Assert.Null(result);
        _userManager.Verify(x => x.AccessFailedAsync(_users[0]), Times.Once);
        _refreshTokens.Verify(x => x.SaveRefreshTokenAsync(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<DateTime>()), Times.Never);
    }

    [Fact]
    public async Task Login_WrongPassword_AfterThreshold_LocksOutAndSendsEmail()
    {
        var lockoutEnd = DateTimeOffset.UtcNow.AddHours(2);
        _userManager.Setup(x => x.FindByNameAsync("Ahmed@test.com")).ReturnsAsync(_users[0]);
        _userManager.SetupSequence(x => x.IsLockedOutAsync(_users[0]))
            .ReturnsAsync(false)
            .ReturnsAsync(true);
        _userManager.Setup(x => x.CheckPasswordAsync(It.IsAny<ApplicationUser>(), It.IsAny<string>())).ReturnsAsync(false);
        _userManager.Setup(x => x.AccessFailedAsync(It.IsAny<ApplicationUser>())).ReturnsAsync(IdentityResult.Success);
        _userManager.Setup(x => x.GetAccessFailedCountAsync(It.IsAny<ApplicationUser>())).ReturnsAsync(5);
        _userManager.Setup(x => x.GetLockoutEndDateAsync(It.IsAny<ApplicationUser>())).ReturnsAsync(lockoutEnd);
        _emailTemplates.Setup(x => x.GenerateAccountLockoutEmail(It.IsAny<ApplicationUser>(), It.IsAny<DateTimeOffset?>(), It.IsAny<string>()))
            .Returns("<html>locked</html>");

        var result = await _service.Login(new LoginRequestDTO { Email = "Ahmed@test.com", Password = "wrong" });

        Assert.NotNull(result);
        Assert.True(result.IsLockedOut);
        Assert.NotNull(result.ErrorMessage);
        _emailSender.Verify(x => x.SendEmailAsync("Ahmed@test.com", "subject", "<html>locked</html>"), Times.Once);
    }

    [Fact]
    public async Task Login_BannedUser_ReturnsBannedResponse()
    {
        _users[0].IsBanned = true;
        _userManager.Setup(x => x.FindByNameAsync("Ahmed@test.com")).ReturnsAsync(_users[0]);

        var result = await _service.Login(new LoginRequestDTO { Email = "Ahmed@test.com", Password = "whatever" });

        Assert.NotNull(result);
        Assert.True(result.IsBanned);
        Assert.NotNull(result.ErrorMessage);
        Assert.Null(result.Token);
        _userManager.Verify(x => x.CheckPasswordAsync(It.IsAny<ApplicationUser>(), It.IsAny<string>()), Times.Never);
    }

    [Fact]
    public async Task Login_LockedOutUser_ReturnsLockedOutResponse()
    {
        var lockoutEnd = DateTimeOffset.UtcNow.AddHours(1);
        _userManager.Setup(x => x.FindByNameAsync("Ahmed@test.com")).ReturnsAsync(_users[0]);
        _userManager.Setup(x => x.IsLockedOutAsync(It.IsAny<ApplicationUser>())).ReturnsAsync(true);
        _userManager.Setup(x => x.GetLockoutEndDateAsync(It.IsAny<ApplicationUser>())).ReturnsAsync(lockoutEnd);

        var result = await _service.Login(new LoginRequestDTO { Email = "Ahmed@test.com", Password = "whatever" });

        Assert.NotNull(result);
        Assert.True(result.IsLockedOut);
        Assert.Contains("قفل", result.ErrorMessage);
        Assert.Null(result.Token);
    }

    [Fact]
    public async Task Login_UnknownUser_ReturnsNull()
    {
        _userManager.Setup(x => x.FindByNameAsync(It.IsAny<string>())).ReturnsAsync((ApplicationUser?)null);

        var result = await _service.Login(new LoginRequestDTO { Email = "nobody@test.com", Password = "whatever" });

        Assert.Null(result);
    }

    [Fact]
    public async Task RefreshToken_ValidToken_ReturnsNewTokensAndRotates()
    {
        _tokens.Setup(x => x.GetPrincipalFromExpiredToken("expired-access"))
            .Returns(new ClaimsPrincipal(new ClaimsIdentity(new[] { new Claim(ClaimTypes.NameIdentifier, "user-1") })));
        _refreshTokens.Setup(x => x.ValidateRefreshTokenAsync("user-1", "old-refresh")).ReturnsAsync(true);
        _tokens.Setup(x => x.GenerateAccessToken(_users[0])).ReturnsAsync("new-access");
        _tokens.Setup(x => x.GenerateRefreshToken()).Returns("new-refresh");

        var result = await _service.RefreshToken(new RefreshTokenRequestDTO
        {
            AccessToken = "expired-access",
            RefreshToken = "old-refresh"
        });

        Assert.NotNull(result);
        Assert.Equal("new-access", result.AccessToken);
        Assert.Equal("new-refresh", result.RefreshToken);
        _refreshTokens.Verify(x => x.UpdateRefreshTokenAsync(
            "user-1", "old-refresh", "new-refresh", It.Is<DateTime>(d => d > DateTime.UtcNow.AddDays(6))), Times.Once);
    }

    [Fact]
    public async Task RefreshToken_InvalidOrRevokedToken_ThrowsSecurityTokenException()
    {
        _tokens.Setup(x => x.GetPrincipalFromExpiredToken("expired-access"))
            .Returns(new ClaimsPrincipal(new ClaimsIdentity(new[] { new Claim(ClaimTypes.NameIdentifier, "user-1") })));
        _refreshTokens.Setup(x => x.ValidateRefreshTokenAsync("user-1", "revoked-refresh")).ReturnsAsync(false);

        await Assert.ThrowsAsync<SecurityTokenException>(() => _service.RefreshToken(new RefreshTokenRequestDTO
        {
            AccessToken = "expired-access",
            RefreshToken = "revoked-refresh"
        }));

        _refreshTokens.Verify(x => x.UpdateRefreshTokenAsync(
            It.IsAny<string>(), It.IsAny<string>(), It.IsAny<string>(), It.IsAny<DateTime>()), Times.Never);
    }

    [Fact]
    public async Task RevokeRefreshToken_ValidArguments_CallsRepository()
    {
        _refreshTokens.Setup(x => x.RevokeRefreshTokenAsync("user-1", "token-to-revoke"))
            .Returns(Task.CompletedTask);

        await _service.RevokeRefreshToken("user-1", "token-to-revoke");

        _refreshTokens.Verify(x => x.RevokeRefreshTokenAsync("user-1", "token-to-revoke"), Times.Once);
    }

    [Fact]
    public async Task RevokeRefreshToken_EmptyUserId_ThrowsArgumentException()
    {
        await Assert.ThrowsAsync<ArgumentException>(() => _service.RevokeRefreshToken("", "token"));
    }
}

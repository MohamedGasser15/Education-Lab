using EduLab_Application.ServiceInterfaces;
using EduLab_Application.Services;
using EduLab_Domain.Entities;
using EduLab.Tests.Fakes;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Identity;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using Moq;
using Xunit;

namespace EduLab.Tests.Services;

public class ExternalLoginServiceTests
{
    private readonly ExternalLoginService _service;

    public ExternalLoginServiceTests()
    {
        var userManager = TestData.MockUserManager();
        var signInManager = new Mock<SignInManager<ApplicationUser>>(
            userManager.Object,
            new Mock<IHttpContextAccessor>().Object,
            new Mock<IUserClaimsPrincipalFactory<ApplicationUser>>().Object,
            new Mock<IOptions<IdentityOptions>>().Object,
            Mock.Of<ILogger<SignInManager<ApplicationUser>>>(),
            new Mock<IAuthenticationSchemeProvider>().Object,
            new Mock<IUserConfirmation<ApplicationUser>>().Object);

        _service = new ExternalLoginService(
            userManager.Object,
            signInManager.Object,
            TestData.NullLogger<ExternalLoginService>(),
            Mock.Of<ITokenService>(),
            Mock.Of<IEmailSender>(),
            Mock.Of<IEmailTemplateService>(),
            Mock.Of<IIpService>(),
            Mock.Of<ILinkBuilderService>());
    }

    [Fact]
    public async Task FindByExternalLoginAsync_NullProvider_ThrowsArgumentException()
    {
        await Assert.ThrowsAsync<ArgumentException>(
            () => _service.FindByExternalLoginAsync(null, "key"));
    }

    [Fact]
    public async Task FindByExternalLoginAsync_EmptyKey_ThrowsArgumentException()
    {
        await Assert.ThrowsAsync<ArgumentException>(
            () => _service.FindByExternalLoginAsync("Google", ""));
    }

    [Fact]
    public void ConfigureExternalAuthProperties_NullProvider_ThrowsArgumentException()
    {
        Assert.Throws<ArgumentException>(
            () => _service.ConfigureExternalAuthProperties(null, "https://return"));
    }

    [Fact]
    public void ConfigureExternalAuthProperties_EmptyRedirectUrl_ThrowsArgumentException()
    {
        Assert.Throws<ArgumentException>(
            () => _service.ConfigureExternalAuthProperties("Google", ""));
    }

    [Fact]
    public async Task ExternalLoginSignInAsync_EmptyProvider_ThrowsArgumentException()
    {
        await Assert.ThrowsAsync<ArgumentException>(
            () => _service.ExternalLoginSignInAsync("", "key", false));
    }

    [Fact]
    public async Task AddExternalLoginAsync_NullUser_ThrowsArgumentNullException()
    {
        await Assert.ThrowsAsync<ArgumentNullException>(
            () => _service.AddExternalLoginAsync(null, null));
    }
}

using EduLab_Application.Services;
using EduLab_Domain.Entities;
using EduLab.Tests.Fakes;
using Microsoft.AspNetCore.Http;
using Moq;
using System.Security.Claims;
using Xunit;

namespace EduLab.Tests.Services;

public class CurrentUserServiceTests
{
    [Fact]
    public async Task GetUserIdAsync_WithAuthenticatedUser_ReturnsId()
    {
        var users = new List<ApplicationUser> { TestData.User("u1", "Ahmed") };
        var userManager = TestData.MockUserManager(users);

        // userManager.GetUserAsync(principal) — بيجيب المستخدم من الـ NameIdentifier claim
        userManager.Setup(x => x.GetUserAsync(It.IsAny<ClaimsPrincipal>()))
            .ReturnsAsync(users[0]);

        var principal = new ClaimsPrincipal(new ClaimsIdentity(new[]
        {
            new Claim(ClaimTypes.NameIdentifier, "u1")
        }, "test"));

        var context = new DefaultHttpContext { User = principal };
        var accessor = new Mock<IHttpContextAccessor>();
        accessor.Setup(x => x.HttpContext).Returns(context);

        var service = new CurrentUserService(accessor.Object, userManager.Object);

        var id = await service.GetUserIdAsync();

        Assert.Equal("u1", id);
    }

    [Fact]
    public async Task GetUserIdAsync_WithNoHttpContext_ReturnsNull()
    {
        var accessor = new Mock<IHttpContextAccessor>();
        accessor.Setup(x => x.HttpContext).Returns((HttpContext?)null);

        var service = new CurrentUserService(accessor.Object, TestData.MockUserManager().Object);

        var id = await service.GetUserIdAsync();

        Assert.Null(id);
    }

    [Fact]
    public async Task GetUserFullNameAsync_WithUser_ReturnsFullName()
    {
        var users = new List<ApplicationUser> { TestData.User("u1", "Ahmed") };
        var userManager = TestData.MockUserManager(users);
        userManager.Setup(x => x.GetUserAsync(It.IsAny<ClaimsPrincipal>())).ReturnsAsync(users[0]);

        var context = new DefaultHttpContext
        {
            User = new ClaimsPrincipal(new ClaimsIdentity(new[] { new Claim(ClaimTypes.NameIdentifier, "u1") }))
        };
        var accessor = new Mock<IHttpContextAccessor>();
        accessor.Setup(x => x.HttpContext).Returns(context);

        var service = new CurrentUserService(accessor.Object, userManager.Object);

        var name = await service.GetUserFullNameAsync();

        Assert.Equal("Ahmed", name);
    }
}

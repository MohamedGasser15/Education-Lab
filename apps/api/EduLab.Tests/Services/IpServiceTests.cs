using EduLab_Application.Services;
using EduLab_Domain.IRepository;
using Microsoft.AspNetCore.Http;
using Moq;
using System.Net;
using Xunit;

namespace EduLab.Tests.Services;

public class IpServiceTests
{
    private static IpService CreateService(Mock<IHttpContextAccessor> accessor)
        => new(accessor.Object, Mock.Of<ISessionRepository>());

    [Fact]
    public void GetClientIpAddress_UsesFirstXForwardedForIp()
    {
        var context = new DefaultHttpContext();
        context.Request.Headers["X-Forwarded-For"] = "203.0.113.195, 70.41.3.18, 150.172.238.178";
        var accessor = new Mock<IHttpContextAccessor>();
        accessor.Setup(x => x.HttpContext).Returns(context);

        Assert.Equal("203.0.113.195", CreateService(accessor).GetClientIpAddress());
    }

    [Fact]
    public void GetClientIpAddress_NoForwardedHeader_UsesRemoteIpAddress()
    {
        var context = new DefaultHttpContext();
        context.Connection.RemoteIpAddress = IPAddress.Parse("192.168.1.10");
        var accessor = new Mock<IHttpContextAccessor>();
        accessor.Setup(x => x.HttpContext).Returns(context);

        Assert.Equal("192.168.1.10", CreateService(accessor).GetClientIpAddress());
    }

    [Fact]
    public void GetClientIpAddress_NoHttpContext_ReturnsUnknown()
    {
        var accessor = new Mock<IHttpContextAccessor>();

        Assert.Equal("Unknown", CreateService(accessor).GetClientIpAddress());
    }

    [Fact]
    public void GetClientIpAddress_IpV6Loopback_MapsToIpv4()
    {
        var context = new DefaultHttpContext();
        context.Request.Headers["X-Forwarded-For"] = "::1";
        var accessor = new Mock<IHttpContextAccessor>();
        accessor.Setup(x => x.HttpContext).Returns(context);

        Assert.Equal("0.0.0.1", CreateService(accessor).GetClientIpAddress());
    }

    [Fact]
    public void GetDeviceInfo_ChromeOnWindows_DetectsBrowserAndOs()
    {
        var context = new DefaultHttpContext();
        context.Request.Headers["User-Agent"] =
            "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0 Safari/537.36";
        var accessor = new Mock<IHttpContextAccessor>();
        accessor.Setup(x => x.HttpContext).Returns(context);

        Assert.Equal("Chrome on Windows", CreateService(accessor).GetDeviceInfo());
    }

    [Fact]
    public async Task GetLocationFromIP_LocalLoopback_ReturnsLocalDevelopment()
    {
        var accessor = new Mock<IHttpContextAccessor>();

        Assert.Equal("Cairo, Egypt (Local Development)",
            await CreateService(accessor).GetLocationFromIP("::1"));
    }
}

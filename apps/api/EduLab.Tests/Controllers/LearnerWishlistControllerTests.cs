using EduLab_Application.DTOs.Wishlist;
using EduLab_Application.ServiceInterfaces;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Moq;
using System.Security.Claims;
using Xunit;

namespace EduLab.Tests.Controllers;

public class LearnerWishlistControllerTests
{
    private readonly Mock<IWishlistService> _service;
    private readonly EduLab_API.Controllers.WishlistController _controller;

    public LearnerWishlistControllerTests()
    {
        _service = new Mock<IWishlistService>();
        _controller = new EduLab_API.Controllers.WishlistController(_service.Object);
    }

    private void SetUser(string? userId)
    {
        var identity = userId == null
            ? new ClaimsIdentity()
            : new ClaimsIdentity(new[] { new Claim(ClaimTypes.NameIdentifier, userId) });
        _controller.ControllerContext = new ControllerContext
        {
            HttpContext = new DefaultHttpContext { User = new ClaimsPrincipal(identity) }
        };
    }

    [Fact]
    public async Task GetUserWishlist_ReturnsUserWishlist()
    {
        SetUser("user-1");
        var items = new List<WishlistItemDto> { new() { Id = 1, CourseId = 5 } };
        _service.Setup(x => x.GetUserWishlistAsync("user-1", It.IsAny<CancellationToken>())).ReturnsAsync(items);

        var result = await _controller.GetUserWishlist();

        var ok = Assert.IsType<OkObjectResult>(result);
        Assert.Equal(items, ok.Value);
    }

    [Fact]
    public async Task AddToWishlist_Success_ReturnsOk()
    {
        SetUser("user-1");
        var response = new WishlistResponse { Success = true, WishlistCount = 3 };
        _service.Setup(x => x.AddToWishlistAsync("user-1", 5, It.IsAny<CancellationToken>())).ReturnsAsync(response);

        var result = await _controller.AddToWishlist(5);

        var ok = Assert.IsType<OkObjectResult>(result);
        Assert.Equal(response, ok.Value);
    }

    [Fact]
    public async Task AddToWishlist_WhenAlreadyInWishlist_ReturnsBadRequest()
    {
        SetUser("user-1");
        var response = new WishlistResponse { Success = false, Message = "Course is already in wishlist" };
        _service.Setup(x => x.AddToWishlistAsync("user-1", 5, It.IsAny<CancellationToken>())).ReturnsAsync(response);

        var result = await _controller.AddToWishlist(5);

        var bad = Assert.IsType<BadRequestObjectResult>(result);
        Assert.Equal(response, bad.Value);
    }

    [Fact]
    public async Task RemoveFromWishlist_Success_ReturnsOk()
    {
        SetUser("user-1");
        var response = new WishlistResponse { Success = true, Message = "Removed" };
        _service.Setup(x => x.RemoveFromWishlistAsync("user-1", 5, It.IsAny<CancellationToken>())).ReturnsAsync(response);

        var result = await _controller.RemoveFromWishlist(5);

        var ok = Assert.IsType<OkObjectResult>(result);
        Assert.Equal(response, ok.Value);
    }

    [Fact]
    public async Task RemoveFromWishlist_WhenNotInWishlist_ReturnsBadRequest()
    {
        SetUser("user-1");
        var response = new WishlistResponse { Success = false, Message = "Course not found in wishlist" };
        _service.Setup(x => x.RemoveFromWishlistAsync("user-1", 5, It.IsAny<CancellationToken>())).ReturnsAsync(response);

        var result = await _controller.RemoveFromWishlist(5);

        Assert.IsType<BadRequestObjectResult>(result);
    }

    [Fact]
    public async Task IsCourseInWishlist_ReturnsCheckResult()
    {
        SetUser("user-1");
        _service.Setup(x => x.IsCourseInWishlistAsync("user-1", 5, It.IsAny<CancellationToken>())).ReturnsAsync(true);

        var result = await _controller.IsCourseInWishlist(5);

        var ok = Assert.IsType<OkObjectResult>(result);
        var property = ok.Value!.GetType().GetProperty("isInWishlist")!;
        Assert.True((bool)property.GetValue(ok.Value)!);
    }

    [Fact]
    public async Task GetWishlistCount_ReturnsCount()
    {
        SetUser("user-1");
        _service.Setup(x => x.GetWishlistCountAsync("user-1", It.IsAny<CancellationToken>())).ReturnsAsync(4);

        var result = await _controller.GetWishlistCount();

        var ok = Assert.IsType<OkObjectResult>(result);
        var property = ok.Value!.GetType().GetProperty("count")!;
        Assert.Equal(4, property.GetValue(ok.Value));
    }
}

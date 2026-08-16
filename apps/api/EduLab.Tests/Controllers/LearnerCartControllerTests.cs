using EduLab_API.Controllers.Learner;
using EduLab_Application.DTOs.Cart;
using EduLab_Application.ServiceInterfaces;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using Moq;
using System.Security.Claims;
using Xunit;

namespace EduLab.Tests.Controllers;

public class LearnerCartControllerTests
{
    private readonly Mock<ICartService> _service;
    private readonly CartController _controller;

    public LearnerCartControllerTests()
    {
        _service = new Mock<ICartService>();
        _controller = new CartController(_service.Object, Mock.Of<ILogger<CartController>>());
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
    public async Task GetCart_WithAuthenticatedUser_ReturnsUserCart()
    {
        SetUser("user-1");
        var cart = new CartDto { Id = 1, UserId = "user-1" };
        _service.Setup(x => x.GetUserCartAsync("user-1", It.IsAny<CancellationToken>())).ReturnsAsync(cart);

        var result = await _controller.GetCart();

        var ok = Assert.IsType<OkObjectResult>(result.Result);
        Assert.Equal(cart, ok.Value);
        _service.Verify(x => x.GetGuestCartAsync(It.IsAny<CancellationToken>()), Times.Never);
    }

    [Fact]
    public async Task GetCart_WithoutUser_ReturnsGuestCart()
    {
        SetUser(null);
        var cart = new CartDto { Id = 2 };
        _service.Setup(x => x.GetGuestCartAsync(It.IsAny<CancellationToken>())).ReturnsAsync(cart);

        var result = await _controller.GetCart();

        var ok = Assert.IsType<OkObjectResult>(result.Result);
        Assert.Equal(cart, ok.Value);
        _service.Verify(x => x.GetUserCartAsync(It.IsAny<string>(), It.IsAny<CancellationToken>()), Times.Never);
    }

    [Fact]
    public async Task AddItemToCart_NullRequest_ReturnsBadRequest()
    {
        SetUser("user-1");

        var result = await _controller.AddItemToCart(null!);

        Assert.IsType<BadRequestObjectResult>(result.Result);
        _service.Verify(x => x.AddItemToCartAsync(It.IsAny<string>(), It.IsAny<AddToCartRequest>(), It.IsAny<CancellationToken>()), Times.Never);
    }

    [Fact]
    public async Task AddItemToCart_InvalidCourseId_ReturnsBadRequest()
    {
        SetUser("user-1");

        var result = await _controller.AddItemToCart(new AddToCartRequest { CourseId = 0 });

        Assert.IsType<BadRequestObjectResult>(result.Result);
        _service.Verify(x => x.AddItemToCartAsync(It.IsAny<string>(), It.IsAny<AddToCartRequest>(), It.IsAny<CancellationToken>()), Times.Never);
    }

    [Fact]
    public async Task AddItemToCart_WhenAlreadyInCart_ReturnsConflict()
    {
        SetUser("user-1");
        _service.Setup(x => x.AddItemToCartAsync("user-1", It.IsAny<AddToCartRequest>(), It.IsAny<CancellationToken>()))
            .ThrowsAsync(new InvalidOperationException("Course already in cart"));

        var result = await _controller.AddItemToCart(new AddToCartRequest { CourseId = 5 });

        Assert.IsType<ConflictObjectResult>(result.Result);
    }

    [Fact]
    public async Task AddItemToCart_Success_ReturnsUpdatedCart()
    {
        SetUser("user-1");
        var cart = new CartDto { Id = 1, UserId = "user-1" };
        _service.Setup(x => x.AddItemToCartAsync("user-1", It.IsAny<AddToCartRequest>(), It.IsAny<CancellationToken>()))
            .ReturnsAsync(cart);

        var result = await _controller.AddItemToCart(new AddToCartRequest { CourseId = 5 });

        var ok = Assert.IsType<OkObjectResult>(result.Result);
        Assert.Equal(cart, ok.Value);
    }

    [Fact]
    public async Task RemoveItemFromCart_WhenItemMissing_ReturnsNotFound()
    {
        SetUser("user-1");
        _service.Setup(x => x.RemoveItemFromCartAsync("user-1", 99, It.IsAny<CancellationToken>()))
            .ThrowsAsync(new KeyNotFoundException());

        var result = await _controller.RemoveItemFromCart(99);

        Assert.IsType<NotFoundObjectResult>(result.Result);
    }

    [Fact]
    public async Task RemoveItemFromCart_Success_ReturnsCart()
    {
        SetUser("user-1");
        var cart = new CartDto { Id = 1 };
        _service.Setup(x => x.RemoveItemFromCartAsync("user-1", 7, It.IsAny<CancellationToken>())).ReturnsAsync(cart);

        var result = await _controller.RemoveItemFromCart(7);

        var ok = Assert.IsType<OkObjectResult>(result.Result);
        Assert.Equal(cart, ok.Value);
    }

    [Fact]
    public async Task ClearCart_Success_ReturnsNoContent()
    {
        SetUser("user-1");
        _service.Setup(x => x.ClearCartAsync("user-1", It.IsAny<CancellationToken>())).ReturnsAsync(true);

        var result = await _controller.ClearCart();

        Assert.IsType<NoContentResult>(result);
        _service.Verify(x => x.ClearCartAsync("user-1", It.IsAny<CancellationToken>()), Times.Once);
    }

    [Fact]
    public async Task MigrateGuestCart_WithoutUserId_ReturnsUnauthorized()
    {
        SetUser(null);

        var result = await _controller.MigrateGuestCart();

        Assert.IsType<UnauthorizedResult>(result);
        _service.Verify(x => x.MigrateGuestCartToUserAsync(It.IsAny<string>(), It.IsAny<CancellationToken>()), Times.Never);
    }
}

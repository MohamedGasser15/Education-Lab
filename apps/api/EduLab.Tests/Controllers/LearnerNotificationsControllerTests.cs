using EduLab_API.Controllers.Learner;
using EduLab_Application.DTOs.Notification;
using EduLab_Application.ServiceInterfaces;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using Moq;
using Xunit;

namespace EduLab.Tests.Controllers;

public class LearnerNotificationsControllerTests
{
    private readonly Mock<INotificationService> _service;
    private readonly NotificationsController _controller;

    public LearnerNotificationsControllerTests()
    {
        _service = new Mock<INotificationService>();
        _controller = new NotificationsController(
            _service.Object,
            Mock.Of<ILogger<NotificationsController>>());
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
    public async Task GetNotifications_ReturnsUserNotifications()
    {
        SetUser("user-1");
        var filter = new NotificationFilterDto();
        var notifications = new List<NotificationDto>
        {
            new() { Id = 1, Title = "Welcome", Message = "Hello" }
        };
        _service.Setup(x => x.GetUserNotificationsAsync("user-1", filter, It.IsAny<CancellationToken>()))
            .ReturnsAsync(notifications);

        var result = await _controller.GetNotifications(filter);

        var ok = Assert.IsType<OkObjectResult>(result.Result);
        Assert.Equal(notifications, ok.Value);
    }

    [Fact]
    public async Task GetNotifications_WithoutUserId_ReturnsUnauthorized()
    {
        SetUser("");

        var result = await _controller.GetNotifications(new NotificationFilterDto());

        Assert.IsType<UnauthorizedObjectResult>(result.Result);
        _service.Verify(x => x.GetUserNotificationsAsync(It.IsAny<string>(), It.IsAny<NotificationFilterDto>(), It.IsAny<CancellationToken>()), Times.Never);
    }

    [Fact]
    public async Task MarkAsRead_WithInvalidId_ReturnsBadRequest()
    {
        SetUser("user-1");

        var result = await _controller.MarkAsRead(0);

        Assert.IsType<BadRequestObjectResult>(result);
        _service.Verify(x => x.MarkNotificationAsReadAsync(It.IsAny<int>(), It.IsAny<string>(), It.IsAny<CancellationToken>()), Times.Never);
    }

    [Fact]
    public async Task MarkAsRead_WithValidId_MarksAndReturnsOk()
    {
        SetUser("user-1");
        _service.Setup(x => x.MarkNotificationAsReadAsync(7, "user-1", It.IsAny<CancellationToken>()))
            .Returns(Task.CompletedTask);

        var result = await _controller.MarkAsRead(7);

        Assert.IsType<OkObjectResult>(result);
        _service.Verify(x => x.MarkNotificationAsReadAsync(7, "user-1", It.IsAny<CancellationToken>()), Times.Once);
    }

    [Fact]
    public async Task MarkAllAsRead_MarksAllAndReturnsOk()
    {
        SetUser("user-1");
        _service.Setup(x => x.MarkAllNotificationsAsReadAsync("user-1", It.IsAny<CancellationToken>()))
            .Returns(Task.CompletedTask);

        var result = await _controller.MarkAllAsRead();

        Assert.IsType<OkObjectResult>(result);
        _service.Verify(x => x.MarkAllNotificationsAsReadAsync("user-1", It.IsAny<CancellationToken>()), Times.Once);
    }

    [Fact]
    public async Task DeleteNotification_WithInvalidId_ReturnsBadRequest()
    {
        SetUser("user-1");

        var result = await _controller.DeleteNotification(-1);

        Assert.IsType<BadRequestObjectResult>(result);
        _service.Verify(x => x.DeleteNotificationAsync(It.IsAny<int>(), It.IsAny<string>(), It.IsAny<CancellationToken>()), Times.Never);
    }

    [Fact]
    public async Task DeleteNotification_WithValidId_DeletesAndReturnsOk()
    {
        SetUser("user-1");
        _service.Setup(x => x.DeleteNotificationAsync(3, "user-1", It.IsAny<CancellationToken>()))
            .Returns(Task.CompletedTask);

        var result = await _controller.DeleteNotification(3);

        Assert.IsType<OkObjectResult>(result);
        _service.Verify(x => x.DeleteNotificationAsync(3, "user-1", It.IsAny<CancellationToken>()), Times.Once);
    }

    [Fact]
    public async Task GetUnreadCount_ReturnsCount()
    {
        SetUser("user-1");
        _service.Setup(x => x.GetUnreadCountAsync("user-1", It.IsAny<CancellationToken>())).ReturnsAsync(4);

        var result = await _controller.GetUnreadCount();

        var ok = Assert.IsType<OkObjectResult>(result.Result);
        Assert.Equal(4, ok.Value);
    }
}

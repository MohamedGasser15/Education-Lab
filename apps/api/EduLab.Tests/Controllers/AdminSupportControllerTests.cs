using EduLab_API.Controllers.Admin;
using EduLab_API.Hubs;
using EduLab_Application.DTOs.Support;
using EduLab_Application.ServiceInterfaces;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.SignalR;
using Microsoft.Extensions.Logging;
using Moq;
using Xunit;

namespace EduLab.Tests.Controllers;

public class AdminSupportControllerTests
{
    private static Mock<IHubContext<SupportHub>> MockHubContext()
    {
        var clientProxy = new Mock<IClientProxy>();
        clientProxy.Setup(x => x.SendCoreAsync(It.IsAny<string>(), It.IsAny<object[]>(), It.IsAny<CancellationToken>()))
            .Returns(Task.CompletedTask);
        var clients = new Mock<IHubClients>();
        clients.Setup(x => x.Group(It.IsAny<string>())).Returns(clientProxy.Object);
        var hubContext = new Mock<IHubContext<SupportHub>>();
        hubContext.Setup(x => x.Clients).Returns(clients.Object);
        return hubContext;
    }

    private readonly Mock<ISupportService> _service;
    private readonly EduLab_API.Controllers.Admin.SupportController _controller;

    public AdminSupportControllerTests()
    {
        _service = new Mock<ISupportService>();
        _controller = new EduLab_API.Controllers.Admin.SupportController(
            _service.Object,
            MockHubContext().Object,
            Mock.Of<ILogger<EduLab_API.Controllers.Admin.SupportController>>());
    }

    private void SetUser(string userId, params (string Type, string Value)[] claims)
    {
        _controller.ControllerContext = new ControllerContext
        {
            HttpContext = new DefaultHttpContext
            {
                User = new System.Security.Claims.ClaimsPrincipal(new System.Security.Claims.ClaimsIdentity(
                    new[] { new System.Security.Claims.Claim(System.Security.Claims.ClaimTypes.NameIdentifier, userId) }
                        .Concat(claims.Select(c => new System.Security.Claims.Claim(c.Type, c.Value)))))
            }
        };
    }

    [Fact]
    public async Task GetConversations_WithoutViewSupportClaim_ReturnsForbid()
    {
        SetUser("admin-1");

        var result = await _controller.GetConversations();

        Assert.IsType<ForbidResult>(result.Result);
        _service.Verify(x => x.GetAllConversationsAsync(It.IsAny<CancellationToken>()), Times.Never);
    }

    [Fact]
    public async Task GetConversations_WithViewSupportClaim_ReturnsOk()
    {
        SetUser("admin-1", ("ViewSupport", "true"));
        var conversations = new List<AdminSupportConversationDto>
        {
            new() { Id = 1, Subject = "Help", UserName = "Ahmed" }
        };
        _service.Setup(x => x.GetAllConversationsAsync(It.IsAny<CancellationToken>()))
            .ReturnsAsync(conversations);

        var result = await _controller.GetConversations();

        var ok = Assert.IsType<OkObjectResult>(result.Result);
        Assert.Equal(conversations, ok.Value);
    }

    [Fact]
    public async Task SendMessage_WithoutHandleSupportClaim_ReturnsForbid()
    {
        SetUser("admin-1", ("ViewSupport", "true"));

        var result = await _controller.SendMessage(1, new SendSupportMessageRequest { Content = "hi" });

        Assert.IsType<ForbidResult>(result.Result);
        _service.Verify(x => x.SendAgentMessageAsync(It.IsAny<string>(), It.IsAny<int>(), It.IsAny<string>(), It.IsAny<CancellationToken>()), Times.Never);
    }

    [Fact]
    public async Task SendMessage_WithClaimAndEmptyContent_ReturnsBadRequest()
    {
        SetUser("admin-1", ("ViewSupport", "true"), ("HandleSupport", "true"));

        var result = await _controller.SendMessage(1, new SendSupportMessageRequest { Content = "  " });

        Assert.IsType<BadRequestObjectResult>(result.Result);
    }

    [Fact]
    public async Task SendMessage_WithClaim_SendsAndReturnsMessage()
    {
        SetUser("admin-1", ("ViewSupport", "true"), ("HandleSupport", "true"));
        var message = new SupportMessageDto { Id = 5, ConversationId = 1, Content = "Hello", SenderRole = "Agent" };
        _service.Setup(x => x.SendAgentMessageAsync("admin-1", 1, "Hello", It.IsAny<CancellationToken>()))
            .ReturnsAsync(message);
        _service.Setup(x => x.GetConversationDetailAsync(1, It.IsAny<CancellationToken>()))
            .ReturnsAsync(new AdminSupportConversationDetailDto { Id = 1, UserId = "user-1" });

        var result = await _controller.SendMessage(1, new SendSupportMessageRequest { Content = "Hello" });

        var ok = Assert.IsType<OkObjectResult>(result.Result);
        Assert.Equal(message, ok.Value);
    }

    [Fact]
    public async Task SetStatus_WithoutHandleSupportClaim_ReturnsForbid()
    {
        SetUser("admin-1");

        var result = await _controller.SetStatus(1, new SetConversationStatusRequest { Open = false });

        Assert.IsType<ForbidResult>(result);
        _service.Verify(x => x.SetConversationStatusAsync(It.IsAny<int>(), It.IsAny<bool>(), It.IsAny<CancellationToken>()), Times.Never);
    }

    [Fact]
    public async Task SetStatus_WithClaimAndMissingConversation_ReturnsNotFound()
    {
        SetUser("admin-1", ("HandleSupport", "true"));
        _service.Setup(x => x.SetConversationStatusAsync(1, false, It.IsAny<CancellationToken>()))
            .ReturnsAsync(false);

        var result = await _controller.SetStatus(1, new SetConversationStatusRequest { Open = false });

        Assert.IsType<NotFoundObjectResult>(result);
    }

    [Fact]
    public async Task MarkAllRead_WithoutHandleSupportClaim_ReturnsForbid()
    {
        SetUser("admin-1");

        var result = await _controller.MarkAllRead();

        Assert.IsType<ForbidResult>(result.Result);
    }
}

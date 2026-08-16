using EduLab_API.Controllers.Learner;
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

public class LearnerSupportControllerTests
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
    private readonly Mock<ICurrentUserService> _currentUser;
    private readonly EduLab_API.Controllers.Learner.SupportController _controller;

    public LearnerSupportControllerTests()
    {
        _service = new Mock<ISupportService>();
        _currentUser = new Mock<ICurrentUserService>();
        _controller = new EduLab_API.Controllers.Learner.SupportController(
            _service.Object,
            _currentUser.Object,
            MockHubContext().Object,
            Mock.Of<ILogger<EduLab_API.Controllers.Learner.SupportController>>());
    }

    private void SetUserId(string? userId)
    {
        _currentUser.Setup(x => x.GetUserIdAsync()).ReturnsAsync(userId);
        _controller.ControllerContext = new ControllerContext
        {
            HttpContext = new DefaultHttpContext()
        };
    }

    [Fact]
    public async Task GetConversations_WithoutUserId_ReturnsUnauthorized()
    {
        SetUserId(null);

        var result = await _controller.GetConversations();

        Assert.IsType<UnauthorizedResult>(result.Result);
    }

    [Fact]
    public async Task GetConversations_ReturnsUserConversations()
    {
        SetUserId("user-1");
        var conversations = new List<SupportConversationDto> { new() { Id = 1, Subject = "Help" } };
        _service.Setup(x => x.GetUserConversationsAsync("user-1", It.IsAny<CancellationToken>()))
            .ReturnsAsync(conversations);

        var result = await _controller.GetConversations();

        var ok = Assert.IsType<OkObjectResult>(result.Result);
        Assert.Equal(conversations, ok.Value);
    }

    [Fact]
    public async Task CreateConversation_WithEmptyMessage_ReturnsBadRequest()
    {
        SetUserId("user-1");

        var result = await _controller.CreateConversation(new CreateConversationRequest { Message = "  " });

        Assert.IsType<BadRequestObjectResult>(result.Result);
    }

    [Fact]
    public async Task CreateConversation_CreatesAndNotifiesAgents()
    {
        SetUserId("user-1");
        var conversation = new SupportConversationDto { Id = 9, Subject = "Payments" };
        _service.Setup(x => x.CreateConversationAsync("user-1", "Payments", "Hi", It.IsAny<CancellationToken>()))
            .ReturnsAsync(conversation);

        var result = await _controller.CreateConversation(new CreateConversationRequest { Subject = "Payments", Message = "Hi" });

        var ok = Assert.IsType<OkObjectResult>(result.Result);
        Assert.Equal(conversation, ok.Value);
    }

    [Fact]
    public async Task SendMessage_ToMissingConversation_ReturnsNotFound()
    {
        SetUserId("user-1");
        _service.Setup(x => x.SendUserMessageAsync("user-1", 1, "Hi", It.IsAny<CancellationToken>()))
            .ThrowsAsync(new KeyNotFoundException());

        var result = await _controller.SendMessage(1, new SendSupportMessageRequest { Content = "Hi" });

        Assert.IsType<NotFoundObjectResult>(result.Result);
    }

    [Fact]
    public async Task SendMessage_ToClosedConversation_ReturnsBadRequest()
    {
        SetUserId("user-1");
        _service.Setup(x => x.SendUserMessageAsync("user-1", 1, "Hi", It.IsAny<CancellationToken>()))
            .ThrowsAsync(new InvalidOperationException("Conversation is closed"));

        var result = await _controller.SendMessage(1, new SendSupportMessageRequest { Content = "Hi" });

        Assert.IsType<BadRequestObjectResult>(result.Result);
    }

    [Fact]
    public async Task SendMessage_SendsAndBroadcasts()
    {
        SetUserId("user-1");
        var message = new SupportMessageDto { Id = 3, ConversationId = 1, Content = "Hi", SenderRole = "User" };
        _service.Setup(x => x.SendUserMessageAsync("user-1", 1, "Hi", It.IsAny<CancellationToken>()))
            .ReturnsAsync(message);
        _service.Setup(x => x.GetAgentUnreadCountAsync(It.IsAny<CancellationToken>())).ReturnsAsync(2);

        var result = await _controller.SendMessage(1, new SendSupportMessageRequest { Content = "Hi" });

        Assert.IsType<OkObjectResult>(result.Result);
    }

    [Fact]
    public async Task CloseConversation_Missing_ReturnsNotFound()
    {
        SetUserId("user-1");
        _service.Setup(x => x.CloseConversationAsync("user-1", 1, It.IsAny<CancellationToken>()))
            .ReturnsAsync(false);

        var result = await _controller.CloseConversation(1);

        Assert.IsType<NotFoundObjectResult>(result);
    }

    [Fact]
    public async Task ReopenConversation_Missing_ReturnsNotFound()
    {
        SetUserId("user-1");
        _service.Setup(x => x.ReopenConversationAsync("user-1", 1, It.IsAny<CancellationToken>()))
            .ReturnsAsync(false);

        var result = await _controller.ReopenConversation(1);

        Assert.IsType<NotFoundObjectResult>(result);
    }
}

using EduLab_API.Hubs;
using EduLab_Application.DTOs.Support;
using Microsoft.AspNetCore.SignalR;
using Moq;
using System.Security.Claims;
using Xunit;

namespace EduLab.Tests.Hubs;

public class SupportHubTests
{
    private SupportHub CreateHub(ClaimsPrincipal? user = null)
    {
        var hub = new SupportHub();

        var context = new Mock<HubCallerContext>();
        context.Setup(x => x.ConnectionId).Returns("conn-1");
        context.Setup(x => x.UserIdentifier).Returns(user?.FindFirstValue(ClaimTypes.NameIdentifier));
        context.Setup(x => x.User).Returns(user);

        var groups = new Mock<IGroupManager>();
        groups.Setup(x => x.AddToGroupAsync(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<CancellationToken>()))
            .Returns(Task.CompletedTask);
        groups.Setup(x => x.RemoveFromGroupAsync(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<CancellationToken>()))
            .Returns(Task.CompletedTask);

        var clients = new Mock<IHubCallerClients>();
        clients.Setup(x => x.All).Returns(new Mock<IClientProxy>().Object);

        hub.Clients = clients.Object;
        hub.Context = context.Object;
        hub.Groups = groups.Object;

        return hub;
    }

    private static ClaimsPrincipal Principal(string userId, params string[] roles)
    {
        var identity = new ClaimsIdentity(roles.Select(r => new Claim(ClaimTypes.Role, r)));
        identity.AddClaim(new Claim(ClaimTypes.NameIdentifier, userId));
        return new ClaimsPrincipal(identity);
    }

    [Fact]
    public async Task OnConnectedAsync_JoinsUserGroup()
    {
        var hub = CreateHub(Principal("user-1"));

        await hub.OnConnectedAsync();

        Mock.Get(hub.Groups).Verify(x => x.AddToGroupAsync("conn-1", "user-user-1", It.IsAny<CancellationToken>()), Times.Once);
    }

    [Fact]
    public async Task OnConnectedAsync_AdminJoinsAgentsGroupToo()
    {
        var hub = CreateHub(Principal("admin-1", "Admin"));

        await hub.OnConnectedAsync();

        Mock.Get(hub.Groups).Verify(x => x.AddToGroupAsync("conn-1", "user-admin-1", It.IsAny<CancellationToken>()), Times.Once);
        Mock.Get(hub.Groups).Verify(x => x.AddToGroupAsync("conn-1", "agents", It.IsAny<CancellationToken>()), Times.Once);
    }

    [Fact]
    public async Task OnConnectedAsync_SupportRoleJoinsAgentsGroupToo()
    {
        var hub = CreateHub(Principal("support-1", "Support"));

        await hub.OnConnectedAsync();

        Mock.Get(hub.Groups).Verify(x => x.AddToGroupAsync("conn-1", "agents", It.IsAny<CancellationToken>()), Times.Once);
    }

    [Fact]
    public async Task OnConnectedAsync_RegularUserDoesNotJoinAgents()
    {
        var hub = CreateHub(Principal("user-1", "Student"));

        await hub.OnConnectedAsync();

        Mock.Get(hub.Groups).Verify(x => x.AddToGroupAsync("conn-1", "agents", It.IsAny<CancellationToken>()), Times.Never);
    }

    [Fact]
    public async Task JoinConversation_AddsToConversationGroup()
    {
        var hub = CreateHub(Principal("user-1"));

        await hub.JoinConversation(42);

        Mock.Get(hub.Groups).Verify(x => x.AddToGroupAsync("conn-1", "conv-42", It.IsAny<CancellationToken>()), Times.Once);
    }

    [Fact]
    public async Task LeaveConversation_RemovesFromConversationGroup()
    {
        var hub = CreateHub(Principal("user-1"));

        await hub.LeaveConversation(42);

        Mock.Get(hub.Groups).Verify(x => x.RemoveFromGroupAsync("conn-1", "conv-42", It.IsAny<CancellationToken>()), Times.Once);
    }

    [Fact]
    public async Task BroadcastNewMessageAsync_SendsToConversationAndRecipient()
    {
        var clientProxy = new Mock<IClientProxy>();
        clientProxy.Setup(x => x.SendCoreAsync(It.IsAny<string>(), It.IsAny<object[]>(), It.IsAny<CancellationToken>()))
            .Returns(Task.CompletedTask);
        var clients = new Mock<IHubClients>();
        clients.Setup(x => x.Group(It.IsAny<string>())).Returns(clientProxy.Object);
        var hubContext = new Mock<IHubContext<SupportHub>>();
        hubContext.Setup(x => x.Clients).Returns(clients.Object);

        var message = new SupportMessageDto { Id = 1, ConversationId = 7, Content = "Hi" };

        await SupportHub.BroadcastNewMessageAsync(hubContext.Object, message, "user-5", 3);

        clients.Verify(x => x.Group("conv-7"), Times.Once);
        clients.Verify(x => x.Group("user-5"), Times.Once);
        clientProxy.Verify(x => x.SendCoreAsync("ReceiveMessage", It.Is<object[]>(a => a.Length == 1 && a[0] == message), It.IsAny<CancellationToken>()), Times.Once);
        clientProxy.Verify(x => x.SendCoreAsync("UnreadCountChanged", It.Is<object[]>(a => a.Length == 1 && (int)a[0] == 3), It.IsAny<CancellationToken>()), Times.Once);
    }

    [Fact]
    public async Task NotifyAgentsConversationsChangedAsync_NotifiesAgentsGroup()
    {
        var clientProxy = new Mock<IClientProxy>();
        clientProxy.Setup(x => x.SendCoreAsync(It.IsAny<string>(), It.IsAny<object[]>(), It.IsAny<CancellationToken>()))
            .Returns(Task.CompletedTask);
        var clients = new Mock<IHubClients>();
        clients.Setup(x => x.Group("agents")).Returns(clientProxy.Object);
        var hubContext = new Mock<IHubContext<SupportHub>>();
        hubContext.Setup(x => x.Clients).Returns(clients.Object);

        await SupportHub.NotifyAgentsConversationsChangedAsync(hubContext.Object);

        clientProxy.Verify(x => x.SendCoreAsync("ConversationsChanged", It.IsAny<object[]>(), It.IsAny<CancellationToken>()), Times.Once);
    }
}

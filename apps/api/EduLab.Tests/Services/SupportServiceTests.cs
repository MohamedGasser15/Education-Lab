using EduLab_Application.Services;
using EduLab_Domain.Entities;
using EduLab.Tests.Fakes;
using Xunit;

namespace EduLab.Tests.Services;

public class SupportServiceTests
{
    private readonly FakeRepository<SupportConversation> _conversations;
    private readonly FakeRepository<SupportMessage> _messages;
    private readonly SupportService _service;

    public SupportServiceTests()
    {
        _conversations = new FakeRepository<SupportConversation>();
        _messages = new FakeRepository<SupportMessage>();
        _service = new SupportService(
            _conversations,
            _messages,
            TestData.MockUserManager().Object,
            TestData.NullLogger<SupportService>());
    }

    [Fact]
    public async Task CreateConversationAsync_CreatesConversationWithFirstMessage()
    {
        var result = await _service.CreateConversationAsync("user-1", "Payment issue", "Hello, I need help");

        Assert.NotNull(result);
        Assert.Equal("Payment issue", result.Subject);
        Assert.Equal("Open", result.Status);
        Assert.Equal("Hello, I need help", result.LastMessage);

        var stored = Assert.Single(_conversations.Items);
        Assert.Equal("user-1", stored.UserId);
        var message = Assert.Single(_messages.Items);
        Assert.Equal(SupportMessageSenderRole.User, message.SenderRole);
        Assert.Equal(stored.Id, message.ConversationId);
    }

    [Fact]
    public async Task GetConversationMessagesAsync_MarksAgentMessagesAsRead()
    {
        var conversation = TestData.Conversation(1, "user-1");
        conversation.Messages.Add(TestData.Message(1, 1, "agent-1", SupportMessageSenderRole.Agent, "Hello!"));
        conversation.Messages.Add(TestData.Message(2, 1, "user-1", SupportMessageSenderRole.User, "Hi"));
        _conversations.Items.Add(conversation);
        _messages.Items.AddRange(conversation.Messages);

        var messages = await _service.GetConversationMessagesAsync("user-1", 1);

        Assert.Equal(2, messages.Count);
        // agent message was marked as read by reading the conversation
        var agentMessage = Assert.Single(messages.Where(m => m.SenderRole == "Agent"));
        Assert.True(agentMessage.IsRead);
    }

    [Fact]
    public async Task UserUnreadCount_DecreasesAfterReadingConversation()
    {
        var conversation = TestData.Conversation(1, "user-1");
        conversation.Messages.Add(TestData.Message(1, 1, "agent-1", SupportMessageSenderRole.Agent, "Unread reply"));
        _conversations.Items.Add(conversation);
        _messages.Items.AddRange(conversation.Messages);

        var before = await _service.GetUserUnreadCountAsync("user-1");
        Assert.Equal(1, before);

        await _service.GetConversationMessagesAsync("user-1", 1);

        var after = await _service.GetUserUnreadCountAsync("user-1");
        Assert.Equal(0, after);
    }

    [Fact]
    public async Task SendUserMessageAsync_ThrowsWhenConversationClosed()
    {
        var conversation = TestData.Conversation(1, "user-1", status: SupportConversationStatus.Closed);
        _conversations.Items.Add(conversation);

        await Assert.ThrowsAsync<InvalidOperationException>(
            () => _service.SendUserMessageAsync("user-1", 1, "Can I still write?"));
    }

    [Fact]
    public async Task CloseConversationAsync_ThenReopen_FlipsStatus()
    {
        var conversation = TestData.Conversation(1, "user-1");
        _conversations.Items.Add(conversation);

        Assert.True(await _service.CloseConversationAsync("user-1", 1));
        Assert.Equal(SupportConversationStatus.Closed, conversation.Status);

        Assert.True(await _service.ReopenConversationAsync("user-1", 1));
        Assert.Equal(SupportConversationStatus.Open, conversation.Status);
    }

    [Fact]
    public async Task CloseConversationAsync_ReturnsFalseForOtherUsersConversation()
    {
        var conversation = TestData.Conversation(1, "user-1");
        _conversations.Items.Add(conversation);

        var result = await _service.CloseConversationAsync("user-2", 1);

        Assert.False(result);
        Assert.Equal(SupportConversationStatus.Open, conversation.Status);
    }

    [Fact]
    public async Task GetUserConversationsAsync_IncludesLastMessageAndUnreadCount()
    {
        var conversation = TestData.Conversation(1, "user-1");
        conversation.Messages.Add(TestData.Message(1, 1, "user-1", SupportMessageSenderRole.User, "First"));
        conversation.Messages.Add(TestData.Message(2, 1, "agent-1", SupportMessageSenderRole.Agent, "Reply", isRead: false));
        _conversations.Items.Add(conversation);
        _messages.Items.AddRange(conversation.Messages);

        var list = await _service.GetUserConversationsAsync("user-1");

        var dto = Assert.Single(list);
        Assert.Equal("Reply", dto.LastMessage);
        Assert.Equal(1, dto.UnreadCount);
    }

    [Fact]
    public async Task SendAgentMessageAsync_CreatesMessageAndTouchesConversation()
    {
        var conversation = TestData.Conversation(1, "user-1");
        _conversations.Items.Add(conversation);

        var result = await _service.SendAgentMessageAsync("agent-1", 1, "We fixed it");

        Assert.Equal("We fixed it", result.Content);
        Assert.Equal("Agent", result.SenderRole);
        var message = Assert.Single(_messages.Items);
        Assert.Equal(SupportMessageSenderRole.Agent, message.SenderRole);
        Assert.True(conversation.UpdatedAt >= conversation.CreatedAt);
    }

    [Fact]
    public async Task GetAllConversationsAsync_ReportsUserInfoAndUnread()
    {
        var users = new List<ApplicationUser> { TestData.User("user-1", "Ahmed") };
        var service = new SupportService(
            _conversations,
            _messages,
            TestData.MockUserManager(users).Object,
            TestData.NullLogger<SupportService>());

        var conversation = TestData.Conversation(1, "user-1");
        conversation.User = TestData.User("user-1", "Ahmed");
        conversation.Messages.Add(TestData.Message(1, 1, "user-1", SupportMessageSenderRole.User, "Please help", isRead: false));
        _conversations.Items.Add(conversation);
        _messages.Items.AddRange(conversation.Messages);

        var list = await service.GetAllConversationsAsync();

        var dto = Assert.Single(list);
        Assert.Equal("Ahmed", dto.UserName);
        Assert.Equal(1, dto.UnreadCount);
        Assert.Equal("Please help", dto.LastMessage);
    }

    [Fact]
    public async Task GetConversationDetailAsync_MarksUserMessagesRead()
    {
        var users = new List<ApplicationUser> { TestData.User("user-1", "Ahmed") };
        var service = new SupportService(
            _conversations,
            _messages,
            TestData.MockUserManager(users).Object,
            TestData.NullLogger<SupportService>());

        var conversation = TestData.Conversation(1, "user-1");
        conversation.User = TestData.User("user-1", "Ahmed");
        conversation.Messages.Add(TestData.Message(1, 1, "user-1", SupportMessageSenderRole.User, "Help!", isRead: false));
        _conversations.Items.Add(conversation);
        _messages.Items.AddRange(conversation.Messages);

        var detail = await service.GetConversationDetailAsync(1);

        Assert.NotNull(detail);
        Assert.Equal("Ahmed", detail.UserName);
        Assert.True(detail.Messages[0].IsRead);

        var unread = await service.GetAgentUnreadCountAsync();
        Assert.Equal(0, unread);
    }

    [Fact]
    public async Task MarkAllUserMessagesReadAsync_ClearsAgentUnread()
    {
        var conversation = TestData.Conversation(1, "user-1");
        conversation.Messages.Add(TestData.Message(1, 1, "user-1", SupportMessageSenderRole.User, "A", isRead: false));
        conversation.Messages.Add(TestData.Message(2, 1, "user-1", SupportMessageSenderRole.User, "B", isRead: false));
        _conversations.Items.Add(conversation);
        _messages.Items.AddRange(conversation.Messages);

        var marked = await _service.MarkAllUserMessagesReadAsync();

        Assert.Equal(2, marked);
        Assert.Equal(0, await _service.GetAgentUnreadCountAsync());
    }
}

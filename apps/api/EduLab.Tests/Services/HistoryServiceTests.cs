using EduLab_Application.Services;
using EduLab_Domain.Entities;
using EduLab_Domain.IRepository;
using EduLab.Tests.Fakes;
using Moq;
using Xunit;

namespace EduLab.Tests.Services;

public class HistoryServiceTests
{
    private readonly Mock<IHistoryRepository> _repository;
    private readonly HistoryService _service;

    public HistoryServiceTests()
    {
        _repository = new Mock<IHistoryRepository>();
        _service = new HistoryService(_repository.Object, TestData.NullLogger<HistoryService>());
    }

    [Fact]
    public async Task LogOperationAsync_AddsHistoryEntry()
    {
        History? captured = null;
        _repository.Setup(r => r.AddAsync(It.IsAny<History>(), It.IsAny<CancellationToken>()))
            .Callback<History, CancellationToken>((h, _) => captured = h)
            .Returns(Task.CompletedTask);

        await _service.LogOperationAsync("u1", "Created course", OperationType.Create, "course.created", "{\"courseId\":5}");

        Assert.NotNull(captured);
        Assert.Equal("u1", captured.UserId);
        Assert.Equal("Created course", captured.Operation);
        Assert.Equal((int?)OperationType.Create, captured.OperationKeyId);
        Assert.Equal("course.created", captured.MessageKey);
        Assert.Equal("{\"courseId\":5}", captured.Parameters);
        Assert.Equal(DateOnly.FromDateTime(DateTime.Now), captured.Date);
    }

    [Fact]
    public async Task LogOperationAsync_EmptyUserId_ThrowsArgumentException()
    {
        await Assert.ThrowsAsync<ArgumentException>(() => _service.LogOperationAsync("", "Something"));
    }

    [Fact]
    public async Task LogOperationAsync_NoOperationAndNoMessageKey_ThrowsArgumentException()
    {
        await Assert.ThrowsAsync<ArgumentException>(() => _service.LogOperationAsync("u1", null!));
    }

    [Fact]
    public async Task LogOperationAsync_MessageKeyOnly_LogsWithEmptyOperation()
    {
        History? captured = null;
        _repository.Setup(r => r.AddAsync(It.IsAny<History>(), It.IsAny<CancellationToken>()))
            .Callback<History, CancellationToken>((h, _) => captured = h)
            .Returns(Task.CompletedTask);

        await _service.LogOperationAsync("u1", null!, messageKey: "user.login");

        Assert.NotNull(captured);
        Assert.Equal(string.Empty, captured.Operation);
        Assert.Equal("user.login", captured.MessageKey);
    }

    [Fact]
    public async Task GetAllHistoryAsync_MapsAllEntries()
    {
        var logs = new List<History>
        {
            TestData.History(1, "u1", "Login", messageKey: "auth.login"),
            TestData.History(2, "u2", "Edit course")
        };
        logs[0].User = TestData.User("u1", "Ahmed");
        logs[0].OperationKey = new OperationKey { Id = 1, Key = "Login" };
        _repository.Setup(r => r.GetAllAsync(It.IsAny<CancellationToken>())).ReturnsAsync(logs);

        var result = await _service.GetAllHistoryAsync();

        Assert.Equal(2, result.Count);
        Assert.Equal("Ahmed", result[0].UserName);
        Assert.Equal("auth.login", result[0].MessageKey);
        Assert.Equal("Login", result[0].OperationKeyName);
        Assert.Equal("Unknown", result[1].UserName);
    }

    [Fact]
    public async Task GetMyHistoryAsync_ReturnsOnlyCurrentUserLogs()
    {
        var logs = new List<History>
        {
            TestData.History(1, "u1", "Login"),
            TestData.History(2, "u1", "View course")
        };
        logs[0].User = TestData.User("u1", "Ahmed");
        logs[1].User = TestData.User("u1", "Ahmed");
        _repository.Setup(r => r.GetByUserIdAsync("u1", It.IsAny<CancellationToken>())).ReturnsAsync(logs);

        var result = await _service.GetMyHistoryAsync("u1");

        Assert.Equal(2, result.Count);
        Assert.All(result, dto => Assert.Equal("Ahmed", dto.UserName));
        _repository.Verify(r => r.GetByUserIdAsync("u1", It.IsAny<CancellationToken>()), Times.Once);
    }

    [Fact]
    public async Task GetMyHistoryAsync_EmptyUserId_ThrowsArgumentException()
    {
        await Assert.ThrowsAsync<ArgumentException>(() => _service.GetMyHistoryAsync("   "));
    }

    [Fact]
    public async Task GetHistoryByUserAsync_ReturnsUserLogs()
    {
        var logs = new List<History> { TestData.History(1, "u9", "Print certificate") };
        logs[0].User = TestData.User("u9", "Sara");
        _repository.Setup(r => r.GetByUserIdAsync("u9", It.IsAny<CancellationToken>())).ReturnsAsync(logs);

        var result = await _service.GetHistoryByUserAsync("u9");

        var dto = Assert.Single(result);
        Assert.Equal("Sara", dto.UserName);
        Assert.Equal("Print certificate", dto.Operation);
    }

    [Fact]
    public async Task GetHistoryByUserAsync_EmptyUserId_ThrowsArgumentException()
    {
        await Assert.ThrowsAsync<ArgumentException>(() => _service.GetHistoryByUserAsync(null!));
    }

    [Fact]
    public async Task GetMyHistoryAsync_NoLogs_ReturnsEmptyList()
    {
        _repository.Setup(r => r.GetByUserIdAsync("u1", It.IsAny<CancellationToken>()))
            .ReturnsAsync(new List<History>());

        var result = await _service.GetMyHistoryAsync("u1");

        Assert.Empty(result);
    }
}

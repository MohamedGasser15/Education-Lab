using System.Linq.Expressions;
using EduLab_Application.DTOs.Notification;
using EduLab_Application.ServiceInterfaces;
using EduLab_Application.Services;
using EduLab_Domain.Entities;
using EduLab_Domain.IRepository;
using EduLab.Tests.Fakes;
using Moq;
using Xunit;

namespace EduLab.Tests.Services;

public class NotificationServiceTests
{
    private readonly Mock<INotificationRepository> _notificationRepo;
    private readonly Mock<IStudentRepository> _studentRepo;
    private readonly NotificationService _service;

    public NotificationServiceTests()
    {
        _notificationRepo = new Mock<INotificationRepository>();
        _studentRepo = new Mock<IStudentRepository>();

        _service = new NotificationService(
            _notificationRepo.Object,
            TestInfrastructure.RealMapper(),
            TestData.NullLogger<NotificationService>(),
            Mock.Of<IEmailSender>(),
            Mock.Of<IEmailTemplateService>(),
            TestData.MockUserManager().Object,
            _studentRepo.Object,
            Mock.Of<IPushNotificationService>());
    }

    [Fact]
    public async Task CreateNotificationAsync_CreatesUnreadNotificationWithStyle()
    {
        Notification? captured = null;
        _notificationRepo.Setup(x => x.CreateAsync(It.IsAny<Notification>(), It.IsAny<CancellationToken>()))
            .Callback<Notification, CancellationToken>((n, _) => captured = n)
            .Returns(Task.CompletedTask);

        var result = await _service.CreateNotificationAsync(new CreateNotificationDto
        {
            Title = "  New lecture  ",
            Message = " A new video was added ",
            Type = NotificationTypeDto.Course,
            UserId = "u1",
            RelatedEntityId = "42",
            RelatedEntityType = "Course"
        });

        Assert.NotNull(result);
        Assert.Equal("New lecture", result.Title);
        Assert.Equal("A new video was added", result.Message);
        Assert.Equal(NotificationTypeDto.Course, result.Type);
        Assert.Equal(NotificationStatusDto.Unread, result.Status);
        Assert.Equal("fas fa-book", result.IconClass);
        Assert.False(string.IsNullOrEmpty(result.ColorClass));

        Assert.NotNull(captured);
        Assert.Equal(NotificationStatus.Unread, captured.Status);
        Assert.Equal(NotificationType.Course, captured.Type);
        Assert.Equal("u1", captured.UserId);
    }

    [Fact]
    public async Task CreateNotificationAsync_ThrowsWhenDtoIsNull()
    {
        await Assert.ThrowsAsync<NullReferenceException>(
            () => _service.CreateNotificationAsync(null!));
    }

    [Fact]
    public async Task CreateNotificationAsync_ThrowsWhenTitleIsNull()
    {
        await Assert.ThrowsAsync<ArgumentException>(
            () => _service.CreateNotificationAsync(new CreateNotificationDto
            {
                Title = null,
                Message = "msg",
                UserId = "u1"
            }));
    }

    [Fact]
    public async Task CreateNotificationAsync_ThrowsWhenMessageIsNull()
    {
        await Assert.ThrowsAsync<ArgumentException>(
            () => _service.CreateNotificationAsync(new CreateNotificationDto
            {
                Title = "title",
                Message = null,
                UserId = "u1"
            }));
    }

    [Theory]
    [InlineData(null)]
    [InlineData("")]
    [InlineData("  ")]
    public async Task CreateNotificationAsync_ThrowsWhenUserIdIsEmpty(string userId)
    {
        await Assert.ThrowsAsync<ArgumentException>(
            () => _service.CreateNotificationAsync(new CreateNotificationDto
            {
                Title = "title",
                Message = "msg",
                UserId = userId
            }));
    }

    [Fact]
    public async Task GetUserNotificationsAsync_PassesUnreadFilterAndMapsDtos()
    {
        var notifications = new List<Notification>
        {
            TestData.Notification(1, "u1", "First", "Body 1", NotificationType.System, NotificationStatus.Unread),
            TestData.Notification(2, "u1", "Second", "Body 2", NotificationType.Enrollment, NotificationStatus.Unread)
        };
        _notificationRepo.Setup(x => x.GetUserNotificationsAsync(
                "u1",
                It.Is<NotificationType?>(t => t == null),
                It.Is<NotificationStatus?>(s => s == NotificationStatus.Unread),
                1,
                5,
                It.IsAny<CancellationToken>()))
            .ReturnsAsync(notifications);

        var result = await _service.GetUserNotificationsAsync("u1",
            new NotificationFilterDto { Status = NotificationStatusDto.Unread, PageNumber = 1, PageSize = 5 });

        Assert.Equal(2, result.Count);
        Assert.Equal("First", result[0].Title);
        Assert.Equal(NotificationStatusDto.Unread, result[0].Status);
        Assert.All(result, n => Assert.False(string.IsNullOrEmpty(n.IconClass)));
    }

    [Fact]
    public async Task GetUserNotificationsAsync_ThrowsWhenFilterIsNull()
    {
        await Assert.ThrowsAsync<ArgumentNullException>(
            () => _service.GetUserNotificationsAsync("u1", null!));
    }

    [Theory]
    [InlineData(null)]
    [InlineData("")]
    public async Task GetUserNotificationsAsync_ThrowsWhenUserIdIsEmpty(string userId)
    {
        await Assert.ThrowsAsync<ArgumentException>(
            () => _service.GetUserNotificationsAsync(userId, new NotificationFilterDto()));
    }

    [Fact]
    public async Task MarkNotificationAsReadAsync_DelegatesToRepository()
    {
        await _service.MarkNotificationAsReadAsync(5, "u1");

        _notificationRepo.Verify(x => x.MarkAsReadAsync(5, "u1", It.IsAny<CancellationToken>()), Times.Once);
    }

    [Fact]
    public async Task MarkNotificationAsReadAsync_ThrowsForEmptyUserId()
    {
        await Assert.ThrowsAsync<ArgumentException>(
            () => _service.MarkNotificationAsReadAsync(5, ""));
    }

    [Fact]
    public async Task MarkAllNotificationsAsReadAsync_DelegatesToRepository()
    {
        await _service.MarkAllNotificationsAsReadAsync("u1");

        _notificationRepo.Verify(x => x.MarkAllAsReadAsync("u1", It.IsAny<CancellationToken>()), Times.Once);
    }

    [Fact]
    public async Task MarkAllNotificationsAsReadAsync_ThrowsForEmptyUserId()
    {
        await Assert.ThrowsAsync<ArgumentException>(
            () => _service.MarkAllNotificationsAsReadAsync(""));
    }

    [Fact]
    public async Task DeleteNotificationAsync_DeletesWhenNotificationBelongsToUser()
    {
        var notification = TestData.Notification(5, "u1", "T", "M");
        _notificationRepo.Setup(x => x.GetAsync(
                It.IsAny<Expression<Func<Notification, bool>>>(),
                It.IsAny<string>(),
                It.IsAny<bool>(),
                It.IsAny<CancellationToken>()))
            .ReturnsAsync(notification);

        await _service.DeleteNotificationAsync(5, "u1");

        _notificationRepo.Verify(x => x.DeleteAsync(notification, It.IsAny<CancellationToken>()), Times.Once);
    }

    [Fact]
    public async Task DeleteNotificationAsync_DoesNothingWhenNotFound()
    {
        _notificationRepo.Setup(x => x.GetAsync(
                It.IsAny<Expression<Func<Notification, bool>>>(),
                It.IsAny<string>(),
                It.IsAny<bool>(),
                It.IsAny<CancellationToken>()))
            .ReturnsAsync((Notification?)null);

        await _service.DeleteNotificationAsync(999, "u1");

        _notificationRepo.Verify(x => x.DeleteAsync(It.IsAny<Notification>(), It.IsAny<CancellationToken>()), Times.Never);
    }

    [Fact]
    public async Task DeleteNotificationAsync_ThrowsForEmptyUserId()
    {
        await Assert.ThrowsAsync<ArgumentException>(
            () => _service.DeleteNotificationAsync(5, ""));
    }

    [Fact]
    public async Task GetUnreadCountAsync_ReturnsRepositoryCount()
    {
        _notificationRepo.Setup(x => x.GetUserUnreadCountAsync("u1", It.IsAny<CancellationToken>()))
            .ReturnsAsync(7);

        var count = await _service.GetUnreadCountAsync("u1");

        Assert.Equal(7, count);
    }

    [Fact]
    public async Task GetUnreadCountAsync_ThrowsForEmptyUserId()
    {
        await Assert.ThrowsAsync<ArgumentException>(
            () => _service.GetUnreadCountAsync(""));
    }

    [Fact]
    public async Task SendInstructorNotificationAsync_ReturnsErrorsWhenTitleMissing()
    {
        var result = await _service.SendInstructorNotificationAsync(
            new InstructorNotificationRequestDto { Title = "", Message = "msg", SendNotification = true },
            "ins-1");

        Assert.False(result.IsSuccess);
        Assert.Contains("عنوان الإشعار مطلوب", result.Errors);
        Assert.Equal(0, result.NotificationsSent);
    }

    [Fact]
    public async Task SendInstructorNotificationAsync_ReturnsErrorsWhenMessageMissing()
    {
        var result = await _service.SendInstructorNotificationAsync(
            new InstructorNotificationRequestDto { Title = "title", Message = " ", SendNotification = true },
            "ins-1");

        Assert.False(result.IsSuccess);
        Assert.Contains("محتوى الإشعار مطلوب", result.Errors);
    }

    [Fact]
    public async Task SendInstructorNotificationAsync_RejectsStudentsNotBelongingToInstructor()
    {
        _studentRepo.Setup(x => x.ValidateStudentsBelongToInstructorAsync(
                "ins-1", It.IsAny<List<string>>(), It.IsAny<CancellationToken>()))
            .ReturnsAsync(false);

        var result = await _service.SendInstructorNotificationAsync(
            new InstructorNotificationRequestDto
            {
                Title = "title",
                Message = "msg",
                StudentIds = new List<string> { "s1" },
                SendNotification = true
            },
            "ins-1");

        Assert.False(result.IsSuccess);
        Assert.Contains("بعض الطلاب المحددين لا ينتمون لدوراتك", result.Errors);
    }

    [Fact]
    public async Task SendInstructorNotificationAsync_ReturnsErrorWhenNoStudentsFound()
    {
        _studentRepo.Setup(x => x.GetStudentsByInstructorAsync("ins-1", It.IsAny<CancellationToken>()))
            .ReturnsAsync(new List<ApplicationUser>());

        var result = await _service.SendInstructorNotificationAsync(
            new InstructorNotificationRequestDto { Title = "title", Message = "msg", SendNotification = true },
            "ins-1");

        Assert.False(result.IsSuccess);
        Assert.Contains("لم يتم العثور على طلاب مستهدفين", result.Errors);
    }

    [Fact]
    public async Task SendInstructorNotificationAsync_SendsToAllStudentsWhenNoSelection()
    {
        var students = new List<ApplicationUser>
        {
            TestData.User("s1", "Ahmed"),
            TestData.User("s2", "Laila")
        };
        _studentRepo.Setup(x => x.GetStudentsByInstructorAsync("ins-1", It.IsAny<CancellationToken>()))
            .ReturnsAsync(students);

        var result = await _service.SendInstructorNotificationAsync(
            new InstructorNotificationRequestDto { Title = "title", Message = "msg", SendNotification = true },
            "ins-1");

        Assert.True(result.IsSuccess);
        Assert.Equal(2, result.TotalUsers);
        Assert.Equal(2, result.NotificationsSent);
        _notificationRepo.Verify(x => x.CreateAsync(
                It.Is<Notification>(n => n.UserId == "s1"),
                It.IsAny<CancellationToken>()),
            Times.Once);
        _notificationRepo.Verify(x => x.CreateAsync(
                It.Is<Notification>(n => n.UserId == "s2"),
                It.IsAny<CancellationToken>()),
            Times.Once);
    }

    [Fact]
    public async Task SendInstructorNotificationAsync_RespectsSendNotificationFlag()
    {
        var students = new List<ApplicationUser> { TestData.User("s1", "Ahmed") };
        _studentRepo.Setup(x => x.GetStudentsByInstructorAsync("ins-1", It.IsAny<CancellationToken>()))
            .ReturnsAsync(students);

        var result = await _service.SendInstructorNotificationAsync(
            new InstructorNotificationRequestDto
            {
                Title = "title",
                Message = "msg",
                SendNotification = false,
                SendEmail = false
            },
            "ins-1");

        Assert.Equal(1, result.TotalUsers);
        Assert.Equal(0, result.NotificationsSent);
        _notificationRepo.Verify(x => x.CreateAsync(It.IsAny<Notification>(), It.IsAny<CancellationToken>()), Times.Never);
    }
}

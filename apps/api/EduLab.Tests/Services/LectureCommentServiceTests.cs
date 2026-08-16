using System.Linq.Expressions;
using EduLab_Application.DTOs.LectureComment;
using EduLab_Application.DTOs.Notification;
using EduLab_Application.ServiceInterfaces;
using EduLab_Application.Services;
using EduLab_Domain.Entities;
using EduLab_Domain.IRepository;
using EduLab.Tests.Fakes;
using Moq;
using Xunit;

namespace EduLab.Tests.Services;

public class LectureCommentServiceTests
{
    private readonly Mock<ILectureCommentRepository> _comments;
    private readonly List<LectureComment> _stored;
    private readonly Mock<ICourseRepository> _courses;
    private readonly Mock<INotificationService> _notifications;
    private readonly LectureCommentService _service;

    public LectureCommentServiceTests()
    {
        _stored = new List<LectureComment>();
        _comments = new Mock<ILectureCommentRepository>();
        _comments.Setup(r => r.CreateAsync(It.IsAny<LectureComment>(), It.IsAny<CancellationToken>()))
            .Callback<LectureComment, CancellationToken>((c, ct) =>
            {
                if (c.Id == 0) c.Id = _stored.Count + 1;
                _stored.Add(c);
            })
            .Returns(Task.CompletedTask);
        _comments.Setup(r => r.SaveAsync(It.IsAny<CancellationToken>())).Returns(Task.CompletedTask);
        _comments.Setup(r => r.DeleteAsync(It.IsAny<LectureComment>(), It.IsAny<CancellationToken>()))
            .Callback<LectureComment, CancellationToken>((c, ct) => _stored.Remove(c))
            .Returns(Task.CompletedTask);
        _comments.Setup(r => r.DeleteRangeAsync(It.IsAny<IEnumerable<LectureComment>>(), It.IsAny<CancellationToken>()))
            .Callback<IEnumerable<LectureComment>, CancellationToken>((cs, ct) =>
            {
                foreach (var c in cs.ToList()) _stored.Remove(c);
            })
            .Returns(Task.CompletedTask);

        _courses = new Mock<ICourseRepository>();
        _notifications = new Mock<INotificationService>();
        _notifications.Setup(x => x.CreateNotificationAsync(It.IsAny<CreateNotificationDto>(), It.IsAny<CancellationToken>()))
            .ReturnsAsync(new NotificationDto());

        _service = new LectureCommentService(
            _comments.Object,
            _courses.Object,
            Mock.Of<IRepository<Section>>(),
            Mock.Of<IRepository<Lecture>>(),
            _notifications.Object,
            Mock.Of<IEmailSender>(),
            Mock.Of<IEmailTemplateService>(),
            TestData.MockUserManager().Object,
            TestInfrastructure.RealMapper());
    }

    private void SetupGetAsync(LectureComment comment)
    {
        _comments.Setup(r => r.GetAsync(
                It.IsAny<Expression<Func<LectureComment, bool>>>(),
                It.IsAny<string>(),
                It.IsAny<bool>(),
                It.IsAny<CancellationToken>()))
            .ReturnsAsync(comment);
    }

    [Fact]
    public async Task GetLectureCommentsAsync_MapsComments()
    {
        _comments.Setup(r => r.GetLectureCommentsAsync(10, It.IsAny<CancellationToken>()))
            .ReturnsAsync(new List<LectureComment> { TestData.LectureComment(1, 10, "user-1", "Great lecture!") });

        var result = await _service.GetLectureCommentsAsync(10);

        var dto = Assert.Single(result);
        Assert.Equal("Great lecture!", dto.Content);
        Assert.Equal("user-1", dto.UserId);
        Assert.False(dto.IsInstructorReply);
    }

    [Fact]
    public async Task AddCommentAsync_PersistsAndReturnsDto()
    {
        SetupGetAsync(new LectureComment { Id = 1, LectureId = 10, UserId = "user-1", Content = "Nice!" });

        var result = await _service.AddCommentAsync("user-1",
            new CreateLectureCommentDTO { LectureId = 10, Content = "Nice!" });

        Assert.NotNull(result);
        Assert.Equal("Nice!", result.Content);
        Assert.Equal(10, result.LectureId);
        Assert.Contains(_stored, c => c.UserId == "user-1" && c.Content == "Nice!");
    }

    [Fact]
    public async Task AddCommentAsync_NullContent_ServiceDoesNotValidateAndPersists()
    {
        SetupGetAsync(new LectureComment { Id = 1, LectureId = 10, UserId = "user-1", Content = null });

        var result = await _service.AddCommentAsync("user-1",
            new CreateLectureCommentDTO { LectureId = 10, Content = null });

        Assert.NotNull(result);
        Assert.Null(result.Content);
    }

    [Fact]
    public async Task AddCommentAsync_StudentComment_NotifiesCourseInstructor()
    {
        var saved = new LectureComment
        {
            Id = 1,
            LectureId = 10,
            UserId = "student-1",
            Content = "Question?",
            Lecture = new Lecture
            {
                Id = 10,
                Title = "Intro",
                Section = new Section { Id = 1, CourseId = 5 }
            },
            User = TestData.User("student-1", "Sara")
        };
        SetupGetAsync(saved);
        _courses.Setup(r => r.GetCourseByIdAsync(5, false, It.IsAny<CancellationToken>()))
            .ReturnsAsync(new Course { Id = 5, Title = "C#", InstructorId = "instructor-1" });

        await _service.AddCommentAsync("student-1",
            new CreateLectureCommentDTO { LectureId = 10, Content = "Question?" });

        _notifications.Verify(x => x.CreateNotificationAsync(
                It.Is<CreateNotificationDto>(n => n.UserId == "instructor-1"),
                It.IsAny<CancellationToken>()),
            Times.Once);
    }

    [Fact]
    public async Task DeleteCommentAsync_WrongUser_ReturnsFalse_AndKeepsComment()
    {
        SetupGetAsync(TestData.LectureComment(1, 10, "user-1", "Mine"));

        var result = await _service.DeleteCommentAsync(1, "user-2");

        Assert.False(result);
        _comments.Verify(x => x.DeleteAsync(It.IsAny<LectureComment>(), It.IsAny<CancellationToken>()),
            Times.Never);
    }

    [Fact]
    public async Task DeleteCommentAsync_Owner_DeletesCommentAndReplies()
    {
        var reply = TestData.LectureComment(2, 10, "user-2", "Reply");
        var comment = TestData.LectureComment(1, 10, "user-1", "Mine");
        comment.Replies = new List<LectureComment> { reply };
        SetupGetAsync(comment);

        var result = await _service.DeleteCommentAsync(1, "user-1");

        Assert.True(result);
        _comments.Verify(x => x.DeleteRangeAsync(
                It.Is<IEnumerable<LectureComment>>(r => r.Contains(reply)),
                It.IsAny<CancellationToken>()),
            Times.Once);
        _comments.Verify(x => x.DeleteAsync(comment, It.IsAny<CancellationToken>()), Times.Once);
    }

    [Fact]
    public async Task ReplyToCommentAsync_MissingParent_ReturnsNull()
    {
        SetupGetAsync(null);

        var result = await _service.ReplyToCommentAsync("user-1", 99,
            new CreateLectureCommentDTO { Content = "Hi" });

        Assert.Null(result);
    }

    [Fact]
    public async Task GetInstructorCommentsAsync_InstructorWithoutCourses_ReturnsEmpty()
    {
        _courses.Setup(r => r.GetCoursesByInstructorAsync("ins-1", It.IsAny<CancellationToken>()))
            .ReturnsAsync(new List<Course>());

        var result = await _service.GetInstructorCommentsAsync("ins-1");

        Assert.Empty(result);
    }
}

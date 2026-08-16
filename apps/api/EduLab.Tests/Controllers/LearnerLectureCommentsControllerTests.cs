using EduLab_API.Controllers.Learner;
using EduLab_Application.DTOs.LectureComment;
using EduLab_Application.ServiceInterfaces;
using EduLab_Domain.Entities;
using EduLab_Domain.IRepository;
using EduLab.Tests.Fakes;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using Moq;
using Xunit;

namespace EduLab.Tests.Controllers;

public class LearnerLectureCommentsControllerTests
{
    private readonly Mock<ILectureCommentService> _commentService;
    private readonly Mock<IEnrollmentService> _enrollmentService;
    private readonly Mock<ICourseRepository> _courseRepository;
    private readonly LectureCommentsController _controller;

    public LearnerLectureCommentsControllerTests()
    {
        _commentService = new Mock<ILectureCommentService>();
        _enrollmentService = new Mock<IEnrollmentService>();
        _courseRepository = new Mock<ICourseRepository>();
        _controller = new LectureCommentsController(
            _commentService.Object,
            _enrollmentService.Object,
            _courseRepository.Object,
            Mock.Of<ILogger<LectureCommentsController>>());
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
    public async Task GetComments_ReturnsComments()
    {
        var comments = new List<LectureCommentDTO> { new() { Id = 1, LectureId = 10, Content = "Great" } };
        _commentService.Setup(x => x.GetLectureCommentsAsync(10, It.IsAny<CancellationToken>()))
            .ReturnsAsync(comments);

        var result = await _controller.GetComments(10, CancellationToken.None);

        var ok = Assert.IsType<OkObjectResult>(result);
        Assert.Equal(comments, ok.Value);
    }

    [Fact]
    public async Task AddComment_WithoutUserId_ReturnsUnauthorized()
    {
        SetUser("");

        var result = await _controller.AddComment(
            new CreateLectureCommentDTO { LectureId = 10, Content = "Hi" }, CancellationToken.None);

        Assert.IsType<UnauthorizedObjectResult>(result);
        _commentService.Verify(x => x.AddCommentAsync(
            It.IsAny<string>(), It.IsAny<CreateLectureCommentDTO>(), It.IsAny<CancellationToken>()), Times.Never);
    }

    [Fact]
    public async Task AddComment_MissingLecture_ReturnsNotFound()
    {
        SetUser("user-1");
        _courseRepository.Setup(x => x.GetCourseIdByLectureAsync(10, It.IsAny<CancellationToken>()))
            .ReturnsAsync((int?)null);

        var result = await _controller.AddComment(
            new CreateLectureCommentDTO { LectureId = 10, Content = "Hi" }, CancellationToken.None);

        Assert.IsType<NotFoundObjectResult>(result);
    }

    [Fact]
    public async Task AddComment_NotEnrolled_Returns403()
    {
        SetUser("user-1");
        _courseRepository.Setup(x => x.GetCourseIdByLectureAsync(10, It.IsAny<CancellationToken>()))
            .ReturnsAsync(5);
        _courseRepository.Setup(x => x.GetCourseByIdAsync(5, true, It.IsAny<CancellationToken>()))
            .ReturnsAsync(TestData.Course(5, "React", instructorId: "ins-1"));
        _enrollmentService.Setup(x => x.IsUserEnrolledInCourseAsync("user-1", 5, It.IsAny<CancellationToken>()))
            .ReturnsAsync(false);

        var result = await _controller.AddComment(
            new CreateLectureCommentDTO { LectureId = 10, Content = "Hi" }, CancellationToken.None);

        var forbidden = Assert.IsType<ObjectResult>(result);
        Assert.Equal(403, forbidden.StatusCode);
    }

    [Fact]
    public async Task AddComment_Enrolled_ReturnsCreatedComment()
    {
        SetUser("user-1");
        var comment = new LectureCommentDTO { Id = 3, LectureId = 10, Content = "Hi", UserId = "user-1" };
        _courseRepository.Setup(x => x.GetCourseIdByLectureAsync(10, It.IsAny<CancellationToken>()))
            .ReturnsAsync(5);
        _courseRepository.Setup(x => x.GetCourseByIdAsync(5, true, It.IsAny<CancellationToken>()))
            .ReturnsAsync(TestData.Course(5, "React", instructorId: "ins-1"));
        _enrollmentService.Setup(x => x.IsUserEnrolledInCourseAsync("user-1", 5, It.IsAny<CancellationToken>()))
            .ReturnsAsync(true);
        _commentService.Setup(x => x.AddCommentAsync("user-1", It.IsAny<CreateLectureCommentDTO>(), It.IsAny<CancellationToken>()))
            .ReturnsAsync(comment);

        var result = await _controller.AddComment(
            new CreateLectureCommentDTO { LectureId = 10, Content = "Hi" }, CancellationToken.None);

        var ok = Assert.IsType<OkObjectResult>(result);
        Assert.Equal(comment, ok.Value);
    }

    [Fact]
    public async Task ReplyToComment_WithoutUserId_ReturnsUnauthorized()
    {
        SetUser("");

        var result = await _controller.ReplyToComment(1, new ReplyRequest { Content = "Answer" }, CancellationToken.None);

        Assert.IsType<UnauthorizedObjectResult>(result);
    }

    [Fact]
    public async Task ReplyToComment_MissingComment_ReturnsNotFound()
    {
        SetUser("user-1");
        _commentService.Setup(x => x.ReplyToCommentAsync(
                "user-1", 1, It.IsAny<CreateLectureCommentDTO>(), It.IsAny<CancellationToken>()))
            .ReturnsAsync((LectureCommentDTO)null!);

        var result = await _controller.ReplyToComment(1, new ReplyRequest { Content = "Answer" }, CancellationToken.None);

        Assert.IsType<NotFoundObjectResult>(result);
    }

    [Fact]
    public async Task ReplyToComment_ReturnsReply()
    {
        SetUser("user-1");
        var reply = new LectureCommentDTO { Id = 9, ParentCommentId = 1, Content = "Answer" };
        _commentService.Setup(x => x.ReplyToCommentAsync(
                "user-1", 1, It.IsAny<CreateLectureCommentDTO>(), It.IsAny<CancellationToken>()))
            .ReturnsAsync(reply);

        var result = await _controller.ReplyToComment(1, new ReplyRequest { Content = "Answer" }, CancellationToken.None);

        var ok = Assert.IsType<OkObjectResult>(result);
        Assert.Equal(reply, ok.Value);
    }

    [Fact]
    public async Task DeleteComment_WithoutUserId_ReturnsUnauthorized()
    {
        SetUser("");

        var result = await _controller.DeleteComment(1, CancellationToken.None);

        Assert.IsType<UnauthorizedObjectResult>(result);
        _commentService.Verify(x => x.DeleteCommentAsync(
            It.IsAny<int>(), It.IsAny<string>(), It.IsAny<CancellationToken>()), Times.Never);
    }

    [Fact]
    public async Task DeleteComment_MissingComment_ReturnsNotFound()
    {
        SetUser("user-1");
        _commentService.Setup(x => x.DeleteCommentAsync(1, "user-1", It.IsAny<CancellationToken>()))
            .ReturnsAsync(false);

        var result = await _controller.DeleteComment(1, CancellationToken.None);

        Assert.IsType<NotFoundObjectResult>(result);
    }

    [Fact]
    public async Task DeleteComment_ReturnsOk()
    {
        SetUser("user-1");
        _commentService.Setup(x => x.DeleteCommentAsync(1, "user-1", It.IsAny<CancellationToken>()))
            .ReturnsAsync(true);

        var result = await _controller.DeleteComment(1, CancellationToken.None);

        Assert.IsType<OkObjectResult>(result);
    }
}

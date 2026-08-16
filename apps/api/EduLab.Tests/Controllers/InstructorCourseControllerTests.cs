using EduLab_API.Controllers.Instructor;
using EduLab_Application.DTOs.Course;
using EduLab_Application.ServiceInterfaces;
using EduLab.Tests.Fakes;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using Moq;
using Xunit;

namespace EduLab.Tests.Controllers;

public class InstructorCourseControllerTests
{
    private readonly Mock<ICourseService> _courseService;
    private readonly Mock<ICurrentUserService> _currentUser;
    private readonly InstructorCourseController _controller;

    public InstructorCourseControllerTests()
    {
        _courseService = new Mock<ICourseService>();
        _currentUser = new Mock<ICurrentUserService>();
        _controller = new InstructorCourseController(
            _courseService.Object,
            Mock.Of<IFileStorageService>(),
            TestInfrastructure.RealMapper(),
            _currentUser.Object,
            Mock.Of<IHistoryService>(),
            Mock.Of<ILogger<InstructorCourseController>>());
    }

    private void SetUserId(string? userId)
    {
        _currentUser.Setup(x => x.GetUserIdAsync()).ReturnsAsync(userId);
        _controller.ControllerContext = new ControllerContext
        {
            HttpContext = new DefaultHttpContext()
        };
    }

    private static CourseDTO Course(int id, string instructorId = "ins-1") =>
        new() { Id = id, Title = $"Course {id}", InstructorId = instructorId };

    [Fact]
    public async Task GetInstructorCourses_WithoutUserId_ReturnsUnauthorized()
    {
        SetUserId(null);

        var result = await _controller.GetInstructorCourses();

        Assert.IsType<UnauthorizedResult>(result);
        _courseService.Verify(x => x.GetInstructorCoursesAsync(
            It.IsAny<string>(), It.IsAny<CancellationToken>()), Times.Never);
    }

    [Fact]
    public async Task GetInstructorCourses_WithNoCourses_ReturnsNotFound()
    {
        SetUserId("ins-1");
        _courseService.Setup(x => x.GetInstructorCoursesAsync("ins-1", It.IsAny<CancellationToken>()))
            .ReturnsAsync(new List<CourseDTO>());

        var result = await _controller.GetInstructorCourses();

        Assert.IsType<NotFoundObjectResult>(result);
    }

    [Fact]
    public async Task GetInstructorCourses_ReturnsCourses()
    {
        SetUserId("ins-1");
        var courses = new List<CourseDTO> { Course(1), Course(2) };
        _courseService.Setup(x => x.GetInstructorCoursesAsync("ins-1", It.IsAny<CancellationToken>()))
            .ReturnsAsync(courses);

        var result = await _controller.GetInstructorCourses();

        var ok = Assert.IsType<OkObjectResult>(result);
        Assert.Equal(courses, ok.Value);
    }

    [Fact]
    public async Task GetCourseById_WithoutUserId_ReturnsUnauthorized()
    {
        SetUserId(null);

        var result = await _controller.GetCourseById(1);

        Assert.IsType<UnauthorizedResult>(result);
    }

    [Fact]
    public async Task GetCourseById_MissingCourse_ReturnsNotFound()
    {
        SetUserId("ins-1");
        _courseService.Setup(x => x.GetCourseByIdAsync(1, It.IsAny<CancellationToken>()))
            .ReturnsAsync((CourseDTO)null!);

        var result = await _controller.GetCourseById(1);

        Assert.IsType<NotFoundObjectResult>(result);
    }

    [Fact]
    public async Task GetCourseById_NotOwner_ReturnsUnauthorized()
    {
        SetUserId("ins-1");
        _courseService.Setup(x => x.GetCourseByIdAsync(1, It.IsAny<CancellationToken>()))
            .ReturnsAsync(Course(1, "other-ins"));

        var result = await _controller.GetCourseById(1);

        Assert.IsType<UnauthorizedObjectResult>(result);
    }

    [Fact]
    public async Task GetCourseById_ReturnsCourse()
    {
        SetUserId("ins-1");
        var course = Course(1);
        _courseService.Setup(x => x.GetCourseByIdAsync(1, It.IsAny<CancellationToken>()))
            .ReturnsAsync(course);

        var result = await _controller.GetCourseById(1);

        var ok = Assert.IsType<OkObjectResult>(result);
        Assert.Equal(course, ok.Value);
    }

    [Fact]
    public async Task CreateCourseDraft_WithNullDto_ReturnsBadRequest()
    {
        SetUserId("ins-1");

        var result = await _controller.CreateCourseDraft(null!);

        Assert.IsType<BadRequestObjectResult>(result);
        _courseService.Verify(x => x.CreateCourseDraftAsync(
            It.IsAny<CourseDraftDTO>(), It.IsAny<CancellationToken>()), Times.Never);
    }

    [Fact]
    public async Task CreateCourseDraft_WithEmptyTitle_ReturnsBadRequest()
    {
        SetUserId("ins-1");

        var result = await _controller.CreateCourseDraft(new CourseDraftDTO { Title = "  " });

        Assert.IsType<BadRequestObjectResult>(result);
    }

    [Fact]
    public async Task CreateCourseDraft_ReturnsCreatedAt()
    {
        SetUserId("ins-1");
        var created = Course(7);
        _courseService.Setup(x => x.CreateCourseDraftAsync(It.IsAny<CourseDraftDTO>(), It.IsAny<CancellationToken>()))
            .ReturnsAsync(created);

        var result = await _controller.CreateCourseDraft(new CourseDraftDTO { Title = "New Course" });

        var createdAt = Assert.IsType<CreatedAtActionResult>(result);
        Assert.Equal(7, createdAt.RouteValues!["id"]);
        Assert.Equal(created, createdAt.Value);
    }

    [Fact]
    public async Task UpdateCourseDraft_WithNullDto_ReturnsBadRequest()
    {
        SetUserId("ins-1");

        var result = await _controller.UpdateCourseDraft(1, null!);

        Assert.IsType<BadRequestObjectResult>(result);
    }

    [Fact]
    public async Task UpdateCourseDraft_MissingCourse_ReturnsNotFound()
    {
        SetUserId("ins-1");
        _courseService.Setup(x => x.UpdateCourseDetailsAsync(1, It.IsAny<CourseUpdateDTO>(), It.IsAny<CancellationToken>()))
            .ReturnsAsync((CourseDTO)null!);

        var result = await _controller.UpdateCourseDraft(1, new CourseUpdateDTO { Title = "Updated" });

        Assert.IsType<NotFoundObjectResult>(result);
    }

    [Fact]
    public async Task UpdateCourseDraft_ReturnsUpdatedCourse()
    {
        SetUserId("ins-1");
        var updated = Course(1);
        _courseService.Setup(x => x.UpdateCourseDetailsAsync(1, It.IsAny<CourseUpdateDTO>(), It.IsAny<CancellationToken>()))
            .ReturnsAsync(updated);

        var result = await _controller.UpdateCourseDraft(1, new CourseUpdateDTO { Title = "Updated" });

        var ok = Assert.IsType<OkObjectResult>(result);
        Assert.Equal(updated, ok.Value);
    }

    [Fact]
    public async Task DeleteCourseAsInstructor_WithoutUserId_ReturnsUnauthorized()
    {
        SetUserId(null);

        var result = await _controller.DeleteCourseAsInstructor(1);

        Assert.IsType<UnauthorizedObjectResult>(result);
        _courseService.Verify(x => x.DeleteCourseAsInstructorAsync(
            It.IsAny<int>(), It.IsAny<CancellationToken>()), Times.Never);
    }

    [Fact]
    public async Task DeleteCourseAsInstructor_MissingCourse_ReturnsNotFound()
    {
        SetUserId("ins-1");
        _courseService.Setup(x => x.GetCourseByIdAsync(1, It.IsAny<CancellationToken>()))
            .ReturnsAsync((CourseDTO)null!);

        var result = await _controller.DeleteCourseAsInstructor(1);

        Assert.IsType<NotFoundObjectResult>(result);
    }

    [Fact]
    public async Task DeleteCourseAsInstructor_NotOwner_ReturnsUnauthorized()
    {
        SetUserId("ins-1");
        _courseService.Setup(x => x.GetCourseByIdAsync(1, It.IsAny<CancellationToken>()))
            .ReturnsAsync(Course(1, "other-ins"));

        var result = await _controller.DeleteCourseAsInstructor(1);

        Assert.IsType<UnauthorizedObjectResult>(result);
    }

    [Fact]
    public async Task DeleteCourseAsInstructor_WhenServiceFails_ReturnsNotFound()
    {
        SetUserId("ins-1");
        _courseService.Setup(x => x.GetCourseByIdAsync(1, It.IsAny<CancellationToken>()))
            .ReturnsAsync(Course(1));
        _courseService.Setup(x => x.DeleteCourseAsInstructorAsync(1, It.IsAny<CancellationToken>()))
            .ReturnsAsync(false);

        var result = await _controller.DeleteCourseAsInstructor(1);

        Assert.IsType<NotFoundObjectResult>(result);
    }

    [Fact]
    public async Task DeleteCourseAsInstructor_ReturnsOk()
    {
        SetUserId("ins-1");
        _courseService.Setup(x => x.GetCourseByIdAsync(1, It.IsAny<CancellationToken>()))
            .ReturnsAsync(Course(1));
        _courseService.Setup(x => x.DeleteCourseAsInstructorAsync(1, It.IsAny<CancellationToken>()))
            .ReturnsAsync(true);

        var result = await _controller.DeleteCourseAsInstructor(1);

        Assert.IsType<OkObjectResult>(result);
    }
}

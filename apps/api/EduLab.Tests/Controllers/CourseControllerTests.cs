using EduLab_API.Controllers.Admin;
using EduLab_API.Models;
using EduLab_Application.Common.Constants;
using EduLab_Application.DTOs.Course;
using EduLab_Application.DTOs.Section;
using EduLab_Application.ServiceInterfaces;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using Moq;
using Xunit;
using Fakes = EduLab.Tests.Fakes;

namespace EduLab.Tests.Controllers;

public class CourseControllerTests
{
    private readonly Mock<ICourseService> _courseService;
    private readonly Mock<IFileStorageService> _fileStorageService;
    private readonly Mock<ICurrentUserService> _currentUserService;
    private readonly Mock<IHistoryService> _historyService;
    private readonly CourseController _controller;

    public CourseControllerTests()
    {
        _courseService = new Mock<ICourseService>();
        _fileStorageService = new Mock<IFileStorageService>();
        _currentUserService = new Mock<ICurrentUserService>();
        _historyService = new Mock<IHistoryService>();
        _controller = new CourseController(
            _courseService.Object,
            _fileStorageService.Object,
            Fakes.TestInfrastructure.RealMapper(),
            _currentUserService.Object,
            _historyService.Object,
            Mock.Of<ILogger<CourseController>>(),
            Fakes.TestInfrastructure.MockConfiguration(),
            Fakes.TestData.MockUserManager().Object);
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

    private static CourseDTO Course(int id, string instructorId = SD.EduLabInstructorId, string status = SD.CourseStatusApproved) =>
        new()
        {
            Id = id,
            Title = $"Course {id}",
            InstructorId = instructorId,
            Status = status,
            ThumbnailUrl = "/Images/Courses/default.jpg",
            Sections = new List<SectionDTO>()
        };

    [Fact]
    public async Task GetAllCourses_ReturnsOkWithCourses()
    {
        var courses = new List<CourseDTO> { Course(1), Course(2) };
        _courseService.Setup(x => x.GetAllCoursesAsync(It.IsAny<CancellationToken>()))
            .ReturnsAsync(courses);

        var result = await _controller.GetAllCourses();

        var ok = Assert.IsType<OkObjectResult>(result);
        Assert.Equal(courses, ok.Value);
    }

    [Fact]
    public async Task GetAllCourses_WhenNone_ReturnsNotFound()
    {
        _courseService.Setup(x => x.GetAllCoursesAsync(It.IsAny<CancellationToken>()))
            .ReturnsAsync(new List<CourseDTO>());

        var result = await _controller.GetAllCourses();

        Assert.IsType<NotFoundObjectResult>(result);
    }

    [Fact]
    public async Task GetCoursesWithCategory_ReturnsOkWithFilteredCourses()
    {
        var courses = new List<CourseDTO> { Course(1) };
        _courseService.Setup(x => x.GetCoursesWithCategoryAsync(1, It.IsAny<CancellationToken>()))
            .ReturnsAsync(courses);

        var result = await _controller.GetCoursesWithCategory(1);

        var ok = Assert.IsType<OkObjectResult>(result);
        Assert.Equal(courses, ok.Value);
        _courseService.Verify(x => x.GetCoursesWithCategoryAsync(1, It.IsAny<CancellationToken>()), Times.Once);
    }

    [Fact]
    public async Task GetCourseById_WhenNotFound_ReturnsNotFound()
    {
        _courseService.Setup(x => x.GetCourseByIdAsync(99, It.IsAny<CancellationToken>()))
            .ReturnsAsync((CourseDTO?)null);

        var result = await _controller.GetCourseById(99);

        Assert.IsType<NotFoundObjectResult>(result);
    }

    [Fact]
    public async Task GetCourseById_AsAdmin_WithDraftForeignCourse_ReturnsForbidden()
    {
        SetUser("admin-1", (System.Security.Claims.ClaimTypes.Role, SD.Admin));
        _courseService.Setup(x => x.GetCourseByIdAsync(1, It.IsAny<CancellationToken>()))
            .ReturnsAsync(Course(1, instructorId: "other-instructor", status: SD.CourseStatusDraft));

        var result = await _controller.GetCourseById(1);

        var statusCode = Assert.IsType<ObjectResult>(result);
        Assert.Equal(StatusCodes.Status403Forbidden, statusCode.StatusCode);
    }

    [Fact]
    public async Task AddCourse_WithNullData_ReturnsBadRequest()
    {
        var result = await _controller.AddCourse(null!);

        Assert.IsType<BadRequestObjectResult>(result);
        _courseService.Verify(x => x.AddCourseAsync(It.IsAny<CourseCreateDTO>(), It.IsAny<CancellationToken>()), Times.Never);
    }

    [Fact]
    public async Task AddCourse_WithMissingInstructor_ReturnsBadRequest()
    {
        var result = await _controller.AddCourse(new CourseCreateDTO { Title = "Test" });

        Assert.IsType<BadRequestObjectResult>(result);
    }

    [Fact]
    public async Task AddCourse_WithValidData_ReturnsCreated()
    {
        var dto = new CourseCreateDTO { Title = "New Course", InstructorId = SD.EduLabInstructorId, Sections = new List<SectionDTO>() };
        var created = Course(5);
        _courseService.Setup(x => x.AddCourseAsync(dto, It.IsAny<CancellationToken>()))
            .ReturnsAsync(created);

        var result = await _controller.AddCourse(dto);

        var createdResult = Assert.IsType<CreatedAtActionResult>(result);
        Assert.Equal(created, createdResult.Value);
    }

    [Fact]
    public async Task UpdateCourse_WhenNotFound_ReturnsNotFound()
    {
        _courseService.Setup(x => x.GetCourseByIdAsync(1, It.IsAny<CancellationToken>()))
            .ReturnsAsync((CourseDTO?)null);

        var result = await _controller.UpdateCourse(1, new CourseUpdateDTO { Id = 1, Title = "Updated" });

        Assert.IsType<NotFoundObjectResult>(result);
    }

    [Fact]
    public async Task UpdateCourse_WhenIdMismatch_ReturnsBadRequest()
    {
        var result = await _controller.UpdateCourse(1, new CourseUpdateDTO { Id = 2, Title = "Updated" });

        Assert.IsType<BadRequestObjectResult>(result);
        _courseService.Verify(x => x.GetCourseByIdAsync(It.IsAny<int>(), It.IsAny<CancellationToken>()), Times.Never);
    }

    [Fact]
    public async Task DeleteCourse_Success_ReturnsOk()
    {
        _courseService.Setup(x => x.GetCourseByIdAsync(1, It.IsAny<CancellationToken>()))
            .ReturnsAsync(Course(1));
        _courseService.Setup(x => x.DeleteCourseAsync(1, It.IsAny<CancellationToken>()))
            .ReturnsAsync(true);

        var result = await _controller.DeleteCourse(1);

        Assert.IsType<OkObjectResult>(result);
    }

    [Fact]
    public async Task DeleteCourse_WhenNotFound_ReturnsNotFound()
    {
        _courseService.Setup(x => x.GetCourseByIdAsync(99, It.IsAny<CancellationToken>()))
            .ReturnsAsync((CourseDTO?)null);

        var result = await _controller.DeleteCourse(99);

        Assert.IsType<NotFoundObjectResult>(result);
        _courseService.Verify(x => x.DeleteCourseAsync(It.IsAny<int>(), It.IsAny<CancellationToken>()), Times.Never);
    }

    [Fact]
    public async Task AcceptCourse_WhenNotFound_ReturnsNotFound()
    {
        _courseService.Setup(x => x.AcceptCourseAsync(99, It.IsAny<CancellationToken>()))
            .ReturnsAsync(false);

        var result = await _controller.AcceptCourse(99);

        Assert.IsType<NotFoundObjectResult>(result);
    }

    [Fact]
    public async Task AcceptCourse_Success_ReturnsOk()
    {
        _courseService.Setup(x => x.AcceptCourseAsync(1, It.IsAny<CancellationToken>()))
            .ReturnsAsync(true);
        _courseService.Setup(x => x.GetCourseByIdAsync(1, It.IsAny<CancellationToken>()))
            .ReturnsAsync(Course(1));

        var result = await _controller.AcceptCourse(1);

        Assert.IsType<OkObjectResult>(result);
    }

    [Fact]
    public async Task RejectCourse_Success_ReturnsOk()
    {
        _courseService.Setup(x => x.RejectCourseAsync(1, "spam", It.IsAny<CancellationToken>()))
            .ReturnsAsync(true);

        var result = await _controller.RejectCourse(1, new RejectCourseRequest { RejectionReason = "spam" });

        Assert.IsType<OkObjectResult>(result);
    }

    [Fact]
    public async Task RejectCourse_WhenNotFound_ReturnsNotFound()
    {
        _courseService.Setup(x => x.RejectCourseAsync(99, null, It.IsAny<CancellationToken>()))
            .ReturnsAsync(false);

        var result = await _controller.RejectCourse(99);

        Assert.IsType<NotFoundObjectResult>(result);
    }
}

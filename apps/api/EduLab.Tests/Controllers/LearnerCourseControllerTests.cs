using EduLab_API.Controllers.Learner;
using EduLab_Application.DTOs.Course;
using EduLab_Application.ServiceInterfaces;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using Moq;
using Xunit;

namespace EduLab.Tests.Controllers;

public class LearnerCourseControllerTests
{
    private readonly Mock<ICourseService> _service;
    private readonly LearnerCourseController _controller;

    public LearnerCourseControllerTests()
    {
        _service = new Mock<ICourseService>();
        _controller = new LearnerCourseController(
            _service.Object,
            Mock.Of<ILogger<LearnerCourseController>>());
    }

    [Fact]
    public async Task GetApprovedCoursesByCategories_ReturnsCourses()
    {
        var categoryIds = new List<int> { 1, 2 };
        var courses = new List<CourseDTO> { new() { Id = 1, Title = "C# Basics" } };
        _service.Setup(x => x.GetApprovedCoursesByCategoriesAsync(categoryIds, 10, It.IsAny<CancellationToken>()))
            .ReturnsAsync(courses);

        var result = await _controller.GetApprovedCoursesByCategories(categoryIds, 10);

        var ok = Assert.IsType<OkObjectResult>(result);
        Assert.Equal(courses, ok.Value);
    }

    [Fact]
    public async Task GetApprovedCoursesByInstructor_ReturnsCourses()
    {
        var courses = new List<CourseDTO> { new() { Id = 2, Title = "ASP.NET Core", InstructorId = "ins-1" } };
        _service.Setup(x => x.GetApprovedCoursesByInstructorAsync("ins-1", 0, It.IsAny<CancellationToken>()))
            .ReturnsAsync(courses);

        var result = await _controller.GetApprovedCoursesByInstructor("ins-1");

        var ok = Assert.IsType<OkObjectResult>(result);
        Assert.Equal(courses, ok.Value);
    }

    [Fact]
    public async Task GetApprovedCoursesByInstructor_WhenNoCourses_ReturnsNotFound()
    {
        _service.Setup(x => x.GetApprovedCoursesByInstructorAsync("ins-9", 0, It.IsAny<CancellationToken>()))
            .ReturnsAsync(new List<CourseDTO>());

        var result = await _controller.GetApprovedCoursesByInstructor("ins-9");

        Assert.IsType<NotFoundObjectResult>(result);
    }

    [Fact]
    public async Task GetApprovedCoursesByCategory_ReturnsCourses()
    {
        var courses = new List<CourseDTO> { new() { Id = 3, Title = "SQL Mastery", CategoryId = 5 } };
        _service.Setup(x => x.GetApprovedCoursesByCategoryAsync(5, 10, It.IsAny<CancellationToken>()))
            .ReturnsAsync(courses);

        var result = await _controller.GetApprovedCoursesByCategory(5);

        var ok = Assert.IsType<OkObjectResult>(result);
        Assert.Equal(courses, ok.Value);
    }

    [Fact]
    public async Task GetApprovedCoursesByCategories_OnServiceError_Returns500()
    {
        _service.Setup(x => x.GetApprovedCoursesByCategoriesAsync(It.IsAny<List<int>>(), It.IsAny<int>(), It.IsAny<CancellationToken>()))
            .ThrowsAsync(new InvalidOperationException("boom"));

        var result = await _controller.GetApprovedCoursesByCategories(new List<int> { 1 }, 10);

        Assert.IsType<ObjectResult>(result);
        Assert.Equal(500, ((ObjectResult)result).StatusCode);
    }
}

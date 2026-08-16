using EduLab_API.Controllers.Learner;
using EduLab_Application.DTOs.Instructor;
using EduLab_Application.ServiceInterfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using Moq;
using System.Reflection;
using Xunit;

namespace EduLab.Tests.Controllers;

public class LearnerInstructorControllerTests
{
    private readonly Mock<IInstructorService> _service;
    private readonly InstructorController _controller;

    public LearnerInstructorControllerTests()
    {
        _service = new Mock<IInstructorService>();
        _controller = new InstructorController(
            _service.Object,
            Mock.Of<ILogger<InstructorController>>());
    }

    [Fact]
    public void Controller_AllowsAnonymousAccess()
    {
        var attributes = typeof(InstructorController).GetCustomAttributes(typeof(AllowAnonymousAttribute), true);

        Assert.NotEmpty(attributes);
    }

    [Fact]
    public async Task GetAllInstructors_ReturnsInstructors()
    {
        var list = new InstructorListDTO
        {
            TotalCount = 1,
            Instructors = new List<InstructorDTO>
            {
                new() { Id = "ins-1", FullName = "Dr. Ahmed", Title = "Professor" }
            }
        };
        _service.Setup(x => x.GetAllInstructorsAsync(It.IsAny<CancellationToken>())).ReturnsAsync(list);

        var result = await _controller.GetAllInstructors();

        var ok = Assert.IsType<OkObjectResult>(result.Result);
        Assert.Same(list, ok.Value);
    }

    [Fact]
    public async Task GetInstructorById_WhenNotFound_ReturnsNotFound()
    {
        _service.Setup(x => x.GetInstructorByIdAsync("missing-1", It.IsAny<CancellationToken>()))
            .ReturnsAsync((InstructorDTO)null);

        var result = await _controller.GetInstructorById("missing-1");

        Assert.IsType<NotFoundObjectResult>(result.Result);
    }

    [Fact]
    public async Task GetInstructorById_ReturnsInstructor()
    {
        var instructor = new InstructorDTO { Id = "ins-1", FullName = "Dr. Ahmed", TotalCourses = 3 };
        _service.Setup(x => x.GetInstructorByIdAsync("ins-1", It.IsAny<CancellationToken>()))
            .ReturnsAsync(instructor);

        var result = await _controller.GetInstructorById("ins-1");

        var ok = Assert.IsType<OkObjectResult>(result.Result);
        Assert.Same(instructor, ok.Value);
    }

    [Fact]
    public async Task GetTopInstructors_ReturnsTopInstructors()
    {
        var top = new List<InstructorDTO>
        {
            new() { Id = "ins-1", FullName = "Dr. Ahmed", Rating = 4.8 }
        };
        _service.Setup(x => x.GetTopRatedInstructorsAsync(4, It.IsAny<CancellationToken>()))
            .ReturnsAsync(top);

        var result = await _controller.GetTopInstructors(4);

        var ok = Assert.IsType<OkObjectResult>(result.Result);
        Assert.Equal(top, ok.Value);
    }

    [Fact]
    public async Task GetTopInstructors_WithInvalidCount_ReturnsBadRequest()
    {
        var result = await _controller.GetTopInstructors(0);

        Assert.IsType<BadRequestObjectResult>(result.Result);
        _service.Verify(x => x.GetTopRatedInstructorsAsync(It.IsAny<int>(), It.IsAny<CancellationToken>()), Times.Never);
    }
}

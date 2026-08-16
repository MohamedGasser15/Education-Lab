using EduLab_API.Controllers.Instructor;
using EduLab_Application.DTOs.Instructor;
using EduLab_Application.ServiceInterfaces;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using Moq;
using Xunit;

namespace EduLab.Tests.Controllers;

public class InstructorCommentsControllerTests
{
    private readonly Mock<ILectureCommentService> _service;
    private readonly InstructorCommentsController _controller;

    public InstructorCommentsControllerTests()
    {
        _service = new Mock<ILectureCommentService>();
        _controller = new InstructorCommentsController(
            _service.Object,
            Mock.Of<ILogger<InstructorCommentsController>>());
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
    public async Task GetInstructorComments_WithoutUserId_ReturnsUnauthorized()
    {
        SetUser("");

        var result = await _controller.GetInstructorComments(CancellationToken.None);

        Assert.IsType<UnauthorizedResult>(result);
        _service.Verify(x => x.GetInstructorCommentsAsync(
            It.IsAny<string>(), It.IsAny<CancellationToken>()), Times.Never);
    }

    [Fact]
    public async Task GetInstructorComments_ReturnsCommentGroups()
    {
        SetUser("ins-1");
        var groups = new List<InstructorCommentsGroupDTO>
        {
            new() { CourseId = 1, CourseName = "React", TotalCount = 3 }
        };
        _service.Setup(x => x.GetInstructorCommentsAsync("ins-1", It.IsAny<CancellationToken>()))
            .ReturnsAsync(groups);

        var result = await _controller.GetInstructorComments(CancellationToken.None);

        var ok = Assert.IsType<OkObjectResult>(result);
        Assert.Equal(groups, ok.Value);
    }

    [Fact]
    public async Task GetInstructorComments_WithNoComments_ReturnsEmptyList()
    {
        SetUser("ins-1");
        _service.Setup(x => x.GetInstructorCommentsAsync("ins-1", It.IsAny<CancellationToken>()))
            .ReturnsAsync(new List<InstructorCommentsGroupDTO>());

        var result = await _controller.GetInstructorComments(CancellationToken.None);

        var ok = Assert.IsType<OkObjectResult>(result);
        var groups = Assert.IsAssignableFrom<List<InstructorCommentsGroupDTO>>(ok.Value);
        Assert.Empty(groups);
    }

    [Fact]
    public async Task GetInstructorComments_WhenServiceThrows_Returns500()
    {
        SetUser("ins-1");
        _service.Setup(x => x.GetInstructorCommentsAsync("ins-1", It.IsAny<CancellationToken>()))
            .ThrowsAsync(new Exception("boom"));

        var result = await _controller.GetInstructorComments(CancellationToken.None);

        var error = Assert.IsType<ObjectResult>(result);
        Assert.Equal(500, error.StatusCode);
    }
}

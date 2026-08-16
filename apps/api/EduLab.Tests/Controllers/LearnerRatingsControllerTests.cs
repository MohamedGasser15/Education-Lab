using EduLab_API.Controllers;
using EduLab_Application.DTOs.Rating;
using EduLab_Application.ServiceInterfaces;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using Moq;
using Xunit;

namespace EduLab.Tests.Controllers;

public class LearnerRatingsControllerTests
{
    private readonly Mock<IRatingService> _service;
    private readonly RatingsController _controller;

    public LearnerRatingsControllerTests()
    {
        _service = new Mock<IRatingService>();
        _controller = new RatingsController(
            _service.Object,
            Mock.Of<ILogger<RatingsController>>());
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
    public async Task GetCourseRatings_ReturnsRatings()
    {
        var ratings = new List<RatingDto>
        {
            new() { Id = 1, CourseId = 5, UserId = "user-1", Value = 5, UserName = "Ahmed" }
        };
        _service.Setup(x => x.GetCourseRatingsAsync(5, 1, 10, It.IsAny<CancellationToken>()))
            .ReturnsAsync(ratings);

        var result = await _controller.GetCourseRatings(5);

        var ok = Assert.IsType<OkObjectResult>(result);
        Assert.Equal(ratings, ok.Value);
    }

    [Fact]
    public async Task AddRating_WithoutUser_ReturnsUnauthorized()
    {
        SetUser("");

        var result = await _controller.AddRating(new CreateRatingDto { CourseId = 5, Value = 4 });

        Assert.IsType<UnauthorizedResult>(result);
        _service.Verify(x => x.AddRatingAsync(It.IsAny<string>(), It.IsAny<CreateRatingDto>(), It.IsAny<CancellationToken>()), Times.Never);
    }

    [Fact]
    public async Task AddRating_WithInvalidValue_ReturnsBadRequest()
    {
        SetUser("user-1");
        var dto = new CreateRatingDto { CourseId = 5, Value = 9 };
        _service.Setup(x => x.AddRatingAsync("user-1", dto, It.IsAny<CancellationToken>()))
            .ThrowsAsync(new ArgumentException("Rating must be between 1 and 5"));

        var result = await _controller.AddRating(dto);

        Assert.IsType<BadRequestObjectResult>(result);
    }

    [Fact]
    public async Task AddRating_WithValidData_ReturnsCreated()
    {
        SetUser("user-1");
        var dto = new CreateRatingDto { CourseId = 5, Value = 4, Comment = "Great" };
        var rating = new RatingDto { Id = 2, CourseId = 5, UserId = "user-1", Value = 4, Comment = "Great" };
        _service.Setup(x => x.AddRatingAsync("user-1", dto, It.IsAny<CancellationToken>()))
            .ReturnsAsync(rating);

        var result = await _controller.AddRating(dto);

        var created = Assert.IsType<CreatedAtActionResult>(result);
        Assert.Same(rating, created.Value);
    }

    [Fact]
    public async Task UpdateRating_WithValidData_ReturnsUpdatedRating()
    {
        SetUser("user-1");
        var dto = new UpdateRatingDto { Value = 5, Comment = "Updated" };
        var rating = new RatingDto { Id = 2, CourseId = 5, UserId = "user-1", Value = 5, Comment = "Updated" };
        _service.Setup(x => x.UpdateRatingAsync("user-1", 2, dto, It.IsAny<CancellationToken>()))
            .ReturnsAsync(rating);

        var result = await _controller.UpdateRating(2, dto);

        var ok = Assert.IsType<OkObjectResult>(result);
        Assert.Same(rating, ok.Value);
    }

    [Fact]
    public async Task UpdateRating_WhenNotFound_ReturnsNotFound()
    {
        SetUser("user-1");
        _service.Setup(x => x.UpdateRatingAsync("user-1", 99, It.IsAny<UpdateRatingDto>(), It.IsAny<CancellationToken>()))
            .ThrowsAsync(new KeyNotFoundException());

        var result = await _controller.UpdateRating(99, new UpdateRatingDto { Value = 3 });

        Assert.IsType<NotFoundObjectResult>(result);
    }

    [Fact]
    public async Task DeleteRating_WithValidId_ReturnsNoContent()
    {
        SetUser("user-1");
        _service.Setup(x => x.DeleteRatingAsync("user-1", 2, It.IsAny<CancellationToken>()))
            .ReturnsAsync(true);

        var result = await _controller.DeleteRating(2);

        Assert.IsType<NoContentResult>(result);
        _service.Verify(x => x.DeleteRatingAsync("user-1", 2, It.IsAny<CancellationToken>()), Times.Once);
    }

    [Fact]
    public async Task DeleteRating_WhenNotFound_ReturnsNotFound()
    {
        SetUser("user-1");
        _service.Setup(x => x.DeleteRatingAsync("user-1", 99, It.IsAny<CancellationToken>()))
            .ThrowsAsync(new KeyNotFoundException());

        var result = await _controller.DeleteRating(99);

        Assert.IsType<NotFoundObjectResult>(result);
    }
}

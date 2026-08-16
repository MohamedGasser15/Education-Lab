using System.Linq.Expressions;
using AutoMapper;
using EduLab_Application.DTOs.Enrollment;
using EduLab_Application.DTOs.Notification;
using EduLab_Application.DTOs.Rating;
using EduLab_Application.ServiceInterfaces;
using EduLab_Application.Services;
using EduLab_Domain.Entities;
using EduLab_Domain.IRepository;
using EduLab.Tests.Fakes;
using Microsoft.Extensions.Logging;
using Moq;
using Xunit;

namespace EduLab.Tests.Services;

public class RatingServiceTests
{
    private readonly Mock<IRatingRepository> _ratingRepo;
    private readonly Mock<IEnrollmentService> _enrollmentService;
    private readonly Mock<INotificationService> _notificationService;
    private readonly Mock<ICourseRepository> _courseRepo;
    private readonly RatingService _service;

    public RatingServiceTests()
    {
        _ratingRepo = new Mock<IRatingRepository>();
        _enrollmentService = new Mock<IEnrollmentService>();
        _notificationService = new Mock<INotificationService>();
        _courseRepo = new Mock<ICourseRepository>();

        _service = new RatingService(
            _ratingRepo.Object,
            _enrollmentService.Object,
            TestData.NullLogger<RatingService>(),
            TestInfrastructure.RealMapper(),
            _notificationService.Object,
            _courseRepo.Object);
    }

    private static CreateRatingDto CreateRating(int courseId = 10, int value = 5, string? comment = null)
        => new() { CourseId = courseId, Value = value, Comment = comment };

    private static EnrollmentDto EnrollmentWithProgress(int courseId, int progress)
        => new() { CourseId = courseId, ProgressPercentage = progress };

    [Fact]
    public async Task AddRatingAsync_CreatesRatingAndNotifiesInstructor()
    {
        _enrollmentService.Setup(x => x.IsUserEnrolledInCourseAsync("user-1", 10, It.IsAny<CancellationToken>()))
            .ReturnsAsync(true);
        _enrollmentService.Setup(x => x.GetUserCourseEnrollmentAsync("user-1", 10, It.IsAny<CancellationToken>()))
            .ReturnsAsync(EnrollmentWithProgress(10, 100));
        _ratingRepo.Setup(x => x.GetUserRatingForCourseAsync("user-1", 10, It.IsAny<CancellationToken>()))
            .ReturnsAsync((Rating?)null);
        _courseRepo.Setup(x => x.GetCourseByIdAsync(10, It.IsAny<bool>(), It.IsAny<CancellationToken>()))
            .ReturnsAsync(TestData.Course(10, "C# Basics", instructorId: "ins-1"));

        Rating? captured = null;
        _ratingRepo.Setup(x => x.CreateAsync(It.IsAny<Rating>(), It.IsAny<CancellationToken>()))
            .Callback<Rating, CancellationToken>((r, _) => captured = r)
            .Returns(Task.CompletedTask);

        var result = await _service.AddRatingAsync("user-1", CreateRating(10, 5, "Great course"));

        Assert.NotNull(result);
        Assert.Equal(5, result.Value);
        Assert.Equal("Great course", result.Comment);
        Assert.Equal("user-1", result.UserId);
        Assert.Equal(10, result.CourseId);

        Assert.NotNull(captured);
        Assert.Equal(5, captured.Value);
        Assert.Equal(10, captured.CourseId);

        _notificationService.Verify(
            n => n.CreateNotificationAsync(
                It.Is<CreateNotificationDto>(d => d.UserId == "ins-1" && d.Type == NotificationTypeDto.Course),
                It.IsAny<CancellationToken>()),
            Times.Once);
    }

    [Fact]
    public async Task AddRatingAsync_DoesNotNotifyWhenRaterIsTheInstructor()
    {
        _enrollmentService.Setup(x => x.IsUserEnrolledInCourseAsync("ins-1", 10, It.IsAny<CancellationToken>()))
            .ReturnsAsync(true);
        _enrollmentService.Setup(x => x.GetUserCourseEnrollmentAsync("ins-1", 10, It.IsAny<CancellationToken>()))
            .ReturnsAsync(EnrollmentWithProgress(10, 100));
        _ratingRepo.Setup(x => x.GetUserRatingForCourseAsync("ins-1", 10, It.IsAny<CancellationToken>()))
            .ReturnsAsync((Rating?)null);
        _courseRepo.Setup(x => x.GetCourseByIdAsync(10, It.IsAny<bool>(), It.IsAny<CancellationToken>()))
            .ReturnsAsync(TestData.Course(10, "C# Basics", instructorId: "ins-1"));

        var result = await _service.AddRatingAsync("ins-1", CreateRating(10, 4));

        Assert.NotNull(result);
        _notificationService.Verify(
            n => n.CreateNotificationAsync(It.IsAny<CreateNotificationDto>(), It.IsAny<CancellationToken>()),
            Times.Never);
    }

    [Fact]
    public async Task AddRatingAsync_ThrowsWhenUserNotEnrolled()
    {
        _enrollmentService.Setup(x => x.IsUserEnrolledInCourseAsync("user-1", 10, It.IsAny<CancellationToken>()))
            .ReturnsAsync(false);

        await Assert.ThrowsAsync<InvalidOperationException>(
            () => _service.AddRatingAsync("user-1", CreateRating(10)));
    }

    [Fact]
    public async Task AddRatingAsync_ThrowsWhenProgressBelow80Percent()
    {
        _enrollmentService.Setup(x => x.IsUserEnrolledInCourseAsync("user-1", 10, It.IsAny<CancellationToken>()))
            .ReturnsAsync(true);
        _enrollmentService.Setup(x => x.GetUserCourseEnrollmentAsync("user-1", 10, It.IsAny<CancellationToken>()))
            .ReturnsAsync(EnrollmentWithProgress(10, 50));

        await Assert.ThrowsAsync<InvalidOperationException>(
            () => _service.AddRatingAsync("user-1", CreateRating(10)));
    }

    [Fact]
    public async Task AddRatingAsync_ThrowsWhenUserAlreadyRated()
    {
        _enrollmentService.Setup(x => x.IsUserEnrolledInCourseAsync("user-1", 10, It.IsAny<CancellationToken>()))
            .ReturnsAsync(true);
        _enrollmentService.Setup(x => x.GetUserCourseEnrollmentAsync("user-1", 10, It.IsAny<CancellationToken>()))
            .ReturnsAsync(EnrollmentWithProgress(10, 90));
        _ratingRepo.Setup(x => x.GetUserRatingForCourseAsync("user-1", 10, It.IsAny<CancellationToken>()))
            .ReturnsAsync(TestData.Rating(1, 10, "user-1", 4));

        await Assert.ThrowsAsync<InvalidOperationException>(
            () => _service.AddRatingAsync("user-1", CreateRating(10)));
    }

    [Theory]
    [InlineData(0)]
    [InlineData(6)]
    [InlineData(-2)]
    public async Task AddRatingAsync_ThrowsForInvalidRatingValue(int value)
    {
        _enrollmentService.Setup(x => x.IsUserEnrolledInCourseAsync("user-1", 10, It.IsAny<CancellationToken>()))
            .ReturnsAsync(true);
        _enrollmentService.Setup(x => x.GetUserCourseEnrollmentAsync("user-1", 10, It.IsAny<CancellationToken>()))
            .ReturnsAsync(EnrollmentWithProgress(10, 100));
        _ratingRepo.Setup(x => x.GetUserRatingForCourseAsync("user-1", 10, It.IsAny<CancellationToken>()))
            .ReturnsAsync((Rating?)null);

        await Assert.ThrowsAsync<ArgumentException>(
            () => _service.AddRatingAsync("user-1", CreateRating(10, value)));
    }

    [Fact]
    public async Task UpdateRatingAsync_UpdatesValueAndComment()
    {
        var rating = TestData.Rating(7, 10, "user-1", 3, DateTime.UtcNow.AddDays(-1));
        _ratingRepo.Setup(x => x.GetAsync(
                It.IsAny<Expression<Func<Rating, bool>>>(),
                It.IsAny<string>(),
                It.IsAny<bool>(),
                It.IsAny<CancellationToken>()))
            .ReturnsAsync(rating);

        var result = await _service.UpdateRatingAsync("user-1", 7, new UpdateRatingDto { Value = 5, Comment = "Updated!" });

        Assert.Equal(5, result.Value);
        Assert.Equal("Updated!", result.Comment);
        Assert.Equal(5, rating.Value);
        Assert.NotNull(rating.UpdatedAt);
        _ratingRepo.Verify(x => x.SaveAsync(It.IsAny<CancellationToken>()), Times.Once);
    }

    [Fact]
    public async Task UpdateRatingAsync_ThrowsWhenRatingNotFound()
    {
        _ratingRepo.Setup(x => x.GetAsync(
                It.IsAny<Expression<Func<Rating, bool>>>(),
                It.IsAny<string>(),
                It.IsAny<bool>(),
                It.IsAny<CancellationToken>()))
            .ReturnsAsync((Rating?)null);

        await Assert.ThrowsAsync<KeyNotFoundException>(
            () => _service.UpdateRatingAsync("user-1", 999, new UpdateRatingDto { Value = 5 }));
    }

    [Theory]
    [InlineData(0)]
    [InlineData(7)]
    public async Task UpdateRatingAsync_ThrowsForInvalidRatingValue(int value)
    {
        _ratingRepo.Setup(x => x.GetAsync(
                It.IsAny<Expression<Func<Rating, bool>>>(),
                It.IsAny<string>(),
                It.IsAny<bool>(),
                It.IsAny<CancellationToken>()))
            .ReturnsAsync(TestData.Rating(7, 10, "user-1", 3));

        await Assert.ThrowsAsync<ArgumentException>(
            () => _service.UpdateRatingAsync("user-1", 7, new UpdateRatingDto { Value = value }));
    }

    [Fact]
    public async Task GetCourseRatingsAsync_AppliesPagination()
    {
        var ratings = new List<Rating>
        {
            TestData.Rating(1, 10, "u1", 5, DateTime.UtcNow.AddHours(-1)),
            TestData.Rating(2, 10, "u2", 4, DateTime.UtcNow.AddHours(-2)),
            TestData.Rating(3, 10, "u3", 3, DateTime.UtcNow.AddHours(-3))
        };
        _ratingRepo.Setup(x => x.GetCourseRatingsAsync(
                It.IsAny<int>(),
                It.IsAny<Expression<Func<Rating, bool>>>(),
                It.IsAny<string>(),
                It.IsAny<bool>(),
                It.IsAny<Func<IQueryable<Rating>, IOrderedQueryable<Rating>>>(),
                It.IsAny<int?>(),
                It.IsAny<CancellationToken>()))
            .ReturnsAsync(ratings);

        var page2 = await _service.GetCourseRatingsAsync(10, page: 2, pageSize: 1);

        var item = Assert.Single(page2);
        Assert.Equal(2, item.Id);
        Assert.Equal(4, item.Value);
    }

    [Fact]
    public async Task GetCourseRatingSummaryAsync_ReturnsStatistics()
    {
        var distribution = new Dictionary<int, int> { [5] = 8, [4] = 2 };
        _ratingRepo.Setup(x => x.GetCourseRatingSummaryRawAsync(10, It.IsAny<CancellationToken>()))
            .ReturnsAsync((4.5, 10, distribution));

        var summary = await _service.GetCourseRatingSummaryAsync(10);

        Assert.Equal(10, summary.CourseId);
        Assert.Equal(4.5, summary.AverageRating);
        Assert.Equal(10, summary.TotalRatings);
        Assert.Equal(8, summary.RatingDistribution[5]);
    }

    [Fact]
    public async Task CanUserRateCourseAsync_ReturnsEligibleWhenProgressAndNoRating()
    {
        _enrollmentService.Setup(x => x.IsUserEnrolledInCourseAsync("user-1", 10, It.IsAny<CancellationToken>()))
            .ReturnsAsync(true);
        _enrollmentService.Setup(x => x.GetUserCourseEnrollmentAsync("user-1", 10, It.IsAny<CancellationToken>()))
            .ReturnsAsync(EnrollmentWithProgress(10, 100));
        _ratingRepo.Setup(x => x.HasUserRatedCourseAsync("user-1", 10, It.IsAny<CancellationToken>()))
            .ReturnsAsync(false);

        var result = await _service.CanUserRateCourseAsync("user-1", 10);

        Assert.True(result.EligibleToRate);
        Assert.False(result.HasRated);
        Assert.True(result.CanRate);
    }

    [Fact]
    public async Task CanUserRateCourseAsync_ReturnsNotEligibleWhenNotEnrolled()
    {
        _enrollmentService.Setup(x => x.IsUserEnrolledInCourseAsync("user-1", 10, It.IsAny<CancellationToken>()))
            .ReturnsAsync(false);

        var result = await _service.CanUserRateCourseAsync("user-1", 10);

        Assert.False(result.EligibleToRate);
        Assert.False(result.HasRated);
        Assert.False(result.CanRate);
    }

    [Fact]
    public async Task CanUserRateCourseAsync_ReturnsSafeDefaultWhenRepositoryThrows()
    {
        _enrollmentService.Setup(x => x.IsUserEnrolledInCourseAsync("user-1", 10, It.IsAny<CancellationToken>()))
            .ThrowsAsync(new Exception("db down"));

        var result = await _service.CanUserRateCourseAsync("user-1", 10);

        Assert.False(result.EligibleToRate);
        Assert.False(result.HasRated);
    }

    [Fact]
    public async Task DeleteRatingAsync_RemovesRating()
    {
        var rating = TestData.Rating(7, 10, "user-1", 4);
        _ratingRepo.Setup(x => x.GetAsync(
                It.IsAny<Expression<Func<Rating, bool>>>(),
                It.IsAny<string>(),
                It.IsAny<bool>(),
                It.IsAny<CancellationToken>()))
            .ReturnsAsync(rating);

        var result = await _service.DeleteRatingAsync("user-1", 7);

        Assert.True(result);
        _ratingRepo.Verify(x => x.DeleteAsync(rating, It.IsAny<CancellationToken>()), Times.Once);
    }

    [Fact]
    public async Task DeleteRatingAsync_ThrowsWhenRatingNotFound()
    {
        _ratingRepo.Setup(x => x.GetAsync(
                It.IsAny<Expression<Func<Rating, bool>>>(),
                It.IsAny<string>(),
                It.IsAny<bool>(),
                It.IsAny<CancellationToken>()))
            .ReturnsAsync((Rating?)null);

        await Assert.ThrowsAsync<KeyNotFoundException>(
            () => _service.DeleteRatingAsync("user-1", 999));
    }
}

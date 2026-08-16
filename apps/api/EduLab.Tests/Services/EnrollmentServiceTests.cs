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

public class EnrollmentServiceTests
{
    private readonly Mock<IEnrollmentRepository> _enrollmentRepo;
    private readonly Mock<ICourseRepository> _courseRepo;
    private readonly Mock<ICourseProgressService> _courseProgressService;
    private readonly Mock<IRatingRepository> _ratingRepo;
    private readonly Mock<INotificationService> _notificationService;
    private readonly EnrollmentService _service;

    public EnrollmentServiceTests()
    {
        _enrollmentRepo = new Mock<IEnrollmentRepository>();
        _courseRepo = new Mock<ICourseRepository>();
        _courseProgressService = new Mock<ICourseProgressService>();
        _ratingRepo = new Mock<IRatingRepository>();
        _notificationService = new Mock<INotificationService>();

        _enrollmentRepo.Setup(x => x.GetAllAsync(
                It.IsAny<Expression<Func<Enrollment, bool>>>(),
                It.IsAny<string>(),
                It.IsAny<bool>(),
                It.IsAny<Func<IQueryable<Enrollment>, IOrderedQueryable<Enrollment>>>(),
                It.IsAny<int?>(),
                It.IsAny<CancellationToken>()))
            .ReturnsAsync(new List<Enrollment>());

        _service = new EnrollmentService(
            _enrollmentRepo.Object,
            _courseRepo.Object,
            TestInfrastructure.RealMapper(),
            TestData.NullLogger<EnrollmentService>(),
            _courseProgressService.Object,
            _ratingRepo.Object,
            _notificationService.Object);
    }

    [Fact]
    public async Task CreateEnrollmentAsync_CreatesEnrollmentAndSendsNotifications()
    {
        _enrollmentRepo.Setup(x => x.IsUserEnrolledInCourseAsync("u1", 1, It.IsAny<CancellationToken>()))
            .ReturnsAsync(false);
        _courseRepo.Setup(x => x.GetCourseByIdAsync(It.IsAny<int>(), It.IsAny<bool>(), It.IsAny<CancellationToken>()))
            .ReturnsAsync(TestData.Course(1, "C# Basics", instructorId: "ins-1"));
        _enrollmentRepo.Setup(x => x.CreateEnrollmentAsync(It.IsAny<Enrollment>(), It.IsAny<CancellationToken>()))
            .ReturnsAsync((Enrollment e, CancellationToken _) => { e.Id = 10; return e; });

        var result = await _service.CreateEnrollmentAsync("u1", 1);

        Assert.NotNull(result);
        Assert.Equal(10, result.Id);
        Assert.Equal(1, result.CourseId);

        _notificationService.Verify(
            n => n.CreateNotificationAsync(
                It.Is<CreateNotificationDto>(d => d.UserId == "u1" && d.Type == NotificationTypeDto.Enrollment),
                It.IsAny<CancellationToken>()),
            Times.Once);
        _notificationService.Verify(
            n => n.CreateNotificationAsync(
                It.Is<CreateNotificationDto>(d => d.UserId == "ins-1"),
                It.IsAny<CancellationToken>()),
            Times.Once);
    }

    [Fact]
    public async Task CreateEnrollmentAsync_ThrowsWhenAlreadyEnrolled()
    {
        _enrollmentRepo.Setup(x => x.IsUserEnrolledInCourseAsync("u1", 1, It.IsAny<CancellationToken>()))
            .ReturnsAsync(true);

        await Assert.ThrowsAsync<InvalidOperationException>(
            () => _service.CreateEnrollmentAsync("u1", 1));

        _enrollmentRepo.Verify(x => x.CreateEnrollmentAsync(It.IsAny<Enrollment>(), It.IsAny<CancellationToken>()), Times.Never);
    }

    [Fact]
    public async Task CreateEnrollmentAsync_ThrowsWhenCourseNotFound()
    {
        _enrollmentRepo.Setup(x => x.IsUserEnrolledInCourseAsync("u1", 1, It.IsAny<CancellationToken>()))
            .ReturnsAsync(false);
        _courseRepo.Setup(x => x.GetCourseByIdAsync(It.IsAny<int>(), It.IsAny<bool>(), It.IsAny<CancellationToken>()))
            .ReturnsAsync((Course?)null);

        await Assert.ThrowsAsync<KeyNotFoundException>(
            () => _service.CreateEnrollmentAsync("u1", 999));
    }

    [Fact]
    public async Task GetUserEnrollmentsAsync_EnrichesWithProgressAndRatingSummary()
    {
        var course = TestData.Course(1, "C# Basics");
        var enrollment = TestData.Enrollment(10, 1, "u1");
        enrollment.Course = course;

        _enrollmentRepo.Setup(x => x.GetUserEnrollmentsAsync("u1", It.IsAny<CancellationToken>()))
            .ReturnsAsync(new List<Enrollment> { enrollment });
        _enrollmentRepo.Setup(x => x.GetUserCourseEnrollmentAsync("u1", 1, It.IsAny<CancellationToken>()))
            .ReturnsAsync(enrollment);
        _courseProgressService.Setup(x => x.GetCourseProgressPercentageAsync(10, It.IsAny<CancellationToken>()))
            .ReturnsAsync(75m);
        _ratingRepo.Setup(x => x.GetCourseRatingSummaryRawAsync(1, It.IsAny<CancellationToken>()))
            .ReturnsAsync((4.5, 3, new Dictionary<int, int> { [5] = 2, [4] = 1 }));

        var result = await _service.GetUserEnrollmentsAsync("u1");

        var dto = Assert.Single(result);
        Assert.Equal(10, dto.Id);
        Assert.Equal(1, dto.CourseId);
        Assert.Equal(75, dto.ProgressPercentage);
        Assert.Equal(4.5, dto.AverageRating);
        Assert.Equal(3, dto.TotalRatings);
        Assert.Equal(2, dto.RatingDistribution[5]);
    }

    [Theory]
    [InlineData(true)]
    [InlineData(false)]
    public async Task IsUserEnrolledInCourseAsync_DelegatesToRepository(bool expected)
    {
        _enrollmentRepo.Setup(x => x.IsUserEnrolledInCourseAsync("u1", 1, It.IsAny<CancellationToken>()))
            .ReturnsAsync(expected);

        var result = await _service.IsUserEnrolledInCourseAsync("u1", 1);

        Assert.Equal(expected, result);
    }

    [Fact]
    public async Task GetUserEnrollmentsCountAsync_ReturnsRepositoryCount()
    {
        _enrollmentRepo.Setup(x => x.GetUserEnrollmentsCountAsync("u1", It.IsAny<CancellationToken>()))
            .ReturnsAsync(5);

        var count = await _service.GetUserEnrollmentsCountAsync("u1");

        Assert.Equal(5, count);
    }

    [Fact]
    public async Task GetUserCourseEnrollmentAsync_ReturnsNullWhenNotEnrolled()
    {
        _enrollmentRepo.Setup(x => x.GetUserCourseEnrollmentAsync("u1", 1, It.IsAny<CancellationToken>()))
            .ReturnsAsync((Enrollment?)null);

        Assert.Null(await _service.GetUserCourseEnrollmentAsync("u1", 1));
    }
}

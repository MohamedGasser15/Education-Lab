using EduLab_Application.ServiceInterfaces;
using EduLab_Application.Services;
using EduLab_Domain.Entities;
using EduLab_Domain.IRepository;
using EduLab.Tests.Fakes;
using Moq;
using Xunit;

namespace EduLab.Tests.Services;

public class CourseProgressServiceTests
{
    private readonly Mock<ICourseProgressRepository> _progressRepo;
    private readonly Mock<IEnrollmentRepository> _enrollmentRepo;
    private readonly Mock<ICertificateService> _certificateService;
    private readonly CourseProgressService _service;

    public CourseProgressServiceTests()
    {
        _progressRepo = new Mock<ICourseProgressRepository>();
        _enrollmentRepo = new Mock<IEnrollmentRepository>();
        _certificateService = new Mock<ICertificateService>();

        _service = new CourseProgressService(
            _progressRepo.Object,
            _enrollmentRepo.Object,
            _certificateService.Object,
            TestInfrastructure.RealMapper(),
            TestData.NullLogger<CourseProgressService>());
    }

    private static CourseProgress ExistingProgress(int id, int enrollmentId, int lectureId, bool isCompleted)
    {
        var progress = TestData.Progress(id, enrollmentId, lectureId, 10, isCompleted);
        return progress;
    }

    private void MockFullCompletion(int enrollmentId, bool hasCertificate)
    {
        var course = TestData.Course(1, "C# Basics");
        course.HasCertificate = hasCertificate;
        var enrollment = TestData.Enrollment(enrollmentId, 1, "u1");
        enrollment.Course = course;

        _progressRepo.Setup(x => x.GetCourseProgressPercentageAsync(enrollmentId, It.IsAny<CancellationToken>()))
            .ReturnsAsync(100m);
        _enrollmentRepo.Setup(x => x.GetEnrollmentByIdAsync(enrollmentId, It.IsAny<CancellationToken>()))
            .ReturnsAsync(enrollment);
    }

    [Fact]
    public async Task MarkLectureAsCompletedAsync_UpdatesExistingRecord()
    {
        var progress = ExistingProgress(7, 1, 5, isCompleted: false);
        _progressRepo.Setup(x => x.GetProgressAsync(1, 5, It.IsAny<CancellationToken>()))
            .ReturnsAsync(progress);
        _progressRepo.Setup(x => x.UpdateProgressAsync(It.IsAny<CourseProgress>(), It.IsAny<CancellationToken>()))
            .ReturnsAsync((CourseProgress p, CancellationToken _) => p);

        var result = await _service.MarkLectureAsCompletedAsync(1, 5);

        Assert.True(result.IsCompleted);
        Assert.Equal(7, result.Id);
        Assert.True(progress.IsCompleted);
        Assert.Equal("Lecture 5", result.LectureTitle);
        _certificateService.Verify(
            c => c.GenerateCertificateAsync(It.IsAny<int>(), It.IsAny<CancellationToken>()),
            Times.Never);
    }

    [Fact]
    public async Task MarkLectureAsCompletedAsync_CreatesRecordWhenMissing()
    {
        _progressRepo.Setup(x => x.GetProgressAsync(1, 5, It.IsAny<CancellationToken>()))
            .ReturnsAsync((CourseProgress?)null);
        _progressRepo.Setup(x => x.CreateProgressAsync(It.IsAny<CourseProgress>(), It.IsAny<CancellationToken>()))
            .ReturnsAsync((CourseProgress p, CancellationToken _) => { p.Id = 9; return p; });

        var result = await _service.MarkLectureAsCompletedAsync(1, 5);

        Assert.NotNull(result);
        Assert.Equal(9, result.Id);
        Assert.True(result.IsCompleted);
        Assert.Equal(1, result.EnrollmentId);
        Assert.Equal(5, result.LectureId);
    }

    [Fact]
    public async Task MarkLectureAsCompletedAsync_IssuesCertificateAtFullCompletion()
    {
        _progressRepo.Setup(x => x.GetProgressAsync(1, 5, It.IsAny<CancellationToken>()))
            .ReturnsAsync((CourseProgress?)null);
        _progressRepo.Setup(x => x.CreateProgressAsync(It.IsAny<CourseProgress>(), It.IsAny<CancellationToken>()))
            .ReturnsAsync((CourseProgress p, CancellationToken _) => { p.Id = 9; return p; });
        MockFullCompletion(1, hasCertificate: true);

        await _service.MarkLectureAsCompletedAsync(1, 5);

        _certificateService.Verify(
            c => c.GenerateCertificateAsync(1, It.IsAny<CancellationToken>()),
            Times.Once);
    }

    [Fact]
    public async Task MarkLectureAsCompletedAsync_SkipsCertificateWhenCourseOffersNone()
    {
        _progressRepo.Setup(x => x.GetProgressAsync(1, 5, It.IsAny<CancellationToken>()))
            .ReturnsAsync((CourseProgress?)null);
        _progressRepo.Setup(x => x.CreateProgressAsync(It.IsAny<CourseProgress>(), It.IsAny<CancellationToken>()))
            .ReturnsAsync((CourseProgress p, CancellationToken _) => { p.Id = 9; return p; });
        MockFullCompletion(1, hasCertificate: false);

        await _service.MarkLectureAsCompletedAsync(1, 5);

        _certificateService.Verify(
            c => c.GenerateCertificateAsync(It.IsAny<int>(), It.IsAny<CancellationToken>()),
            Times.Never);
    }

    [Fact]
    public async Task MarkLectureAsIncompleteAsync_UpdatesExistingRecord()
    {
        var progress = ExistingProgress(7, 1, 5, isCompleted: true);
        _progressRepo.Setup(x => x.GetProgressAsync(1, 5, It.IsAny<CancellationToken>()))
            .ReturnsAsync(progress);
        _progressRepo.Setup(x => x.UpdateProgressAsync(It.IsAny<CourseProgress>(), It.IsAny<CancellationToken>()))
            .ReturnsAsync((CourseProgress p, CancellationToken _) => p);

        var result = await _service.MarkLectureAsIncompleteAsync(1, 5);

        Assert.False(result.IsCompleted);
        Assert.False(progress.IsCompleted);
    }

    [Fact]
    public async Task MarkLectureAsIncompleteAsync_CreatesRecordWhenMissing()
    {
        _progressRepo.Setup(x => x.GetProgressAsync(1, 5, It.IsAny<CancellationToken>()))
            .ReturnsAsync((CourseProgress?)null);
        _progressRepo.Setup(x => x.CreateProgressAsync(It.IsAny<CourseProgress>(), It.IsAny<CancellationToken>()))
            .ReturnsAsync((CourseProgress p, CancellationToken _) => { p.Id = 9; return p; });

        var result = await _service.MarkLectureAsIncompleteAsync(1, 5);

        Assert.NotNull(result);
        Assert.False(result.IsCompleted);
    }

    [Fact]
    public async Task GetCourseProgressSummaryAsync_ComputesTotalsAndPercentage()
    {
        var course = new Course
        {
            Id = 7,
            Title = "C# Basics",
            Sections = new List<Section>
            {
                new Section
                {
                    Id = 1,
                    CourseId = 7,
                    Lectures = new List<Lecture>
                    {
                        new Lecture { Id = 101 },
                        new Lecture { Id = 102 },
                        new Lecture { Id = 103 }
                    }
                }
            }
        };
        var enrollment = TestData.Enrollment(1, 7, "u1");
        enrollment.Course = course;

        _enrollmentRepo.Setup(x => x.GetEnrollmentByIdAsync(1, It.IsAny<CancellationToken>()))
            .ReturnsAsync(enrollment);
        _progressRepo.Setup(x => x.GetCompletedLecturesCountAsync(1, It.IsAny<CancellationToken>()))
            .ReturnsAsync(2);
        _progressRepo.Setup(x => x.GetCourseProgressPercentageAsync(1, It.IsAny<CancellationToken>()))
            .ReturnsAsync(66.67m);

        var summary = await _service.GetCourseProgressSummaryAsync(1);

        Assert.NotNull(summary);
        Assert.Equal(1, summary.EnrollmentId);
        Assert.Equal(7, summary.CourseId);
        Assert.Equal("C# Basics", summary.CourseTitle);
        Assert.Equal(3, summary.TotalLectures);
        Assert.Equal(2, summary.CompletedLectures);
        Assert.Equal(66.67m, summary.ProgressPercentage);
    }

    [Fact]
    public async Task GetCourseProgressSummaryAsync_ReturnsNullWhenEnrollmentMissing()
    {
        _enrollmentRepo.Setup(x => x.GetEnrollmentByIdAsync(1, It.IsAny<CancellationToken>()))
            .ReturnsAsync((Enrollment?)null);

        Assert.Null(await _service.GetCourseProgressSummaryAsync(1));
    }

    [Fact]
    public async Task GetCompletedLecturesCountAsync_DelegatesToRepository()
    {
        _progressRepo.Setup(x => x.GetCompletedLecturesCountAsync(1, It.IsAny<CancellationToken>()))
            .ReturnsAsync(5);

        Assert.Equal(5, await _service.GetCompletedLecturesCountAsync(1));
    }

    [Fact]
    public async Task GetCourseProgressPercentageAsync_ReturnsZeroWhenRepositoryFails()
    {
        _progressRepo.Setup(x => x.GetCourseProgressPercentageAsync(1, It.IsAny<CancellationToken>()))
            .ThrowsAsync(new Exception("db down"));

        Assert.Equal(0m, await _service.GetCourseProgressPercentageAsync(1));
    }

    [Fact]
    public async Task IsLectureCompletedAsync_DelegatesToRepository()
    {
        _progressRepo.Setup(x => x.IsLectureCompletedAsync(1, 5, It.IsAny<CancellationToken>()))
            .ReturnsAsync(true);

        Assert.True(await _service.IsLectureCompletedAsync(1, 5));
    }
}

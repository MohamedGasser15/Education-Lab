using EduLab_Application.DTOs.Notification;
using EduLab_Application.DTOs.Student;
using EduLab_Application.ServiceInterfaces;
using EduLab_Application.Services;
using EduLab_Domain.Entities;
using EduLab_Domain.IRepository;
using EduLab.Tests.Fakes;
using Moq;
using Xunit;

namespace EduLab.Tests.Services;

public class StudentServiceTests
{
    private readonly Mock<IStudentRepository> _studentRepo;
    private readonly Mock<ICourseProgressRepository> _progressRepo;
    private readonly Mock<INotificationService> _notificationService;
    private readonly StudentService _service;

    public StudentServiceTests()
    {
        _studentRepo = new Mock<IStudentRepository>();
        _progressRepo = new Mock<ICourseProgressRepository>();
        _notificationService = new Mock<INotificationService>();

        _service = new StudentService(
            _studentRepo.Object,
            _progressRepo.Object,
            _notificationService.Object,
            Mock.Of<ICurrentUserService>(),
            TestInfrastructure.RealMapper(),
            TestData.NullLogger<StudentService>());
    }

    private static Enrollment EnrollmentWithLectures(int id, int courseId, string userId, string courseTitle, int lectureCount)
    {
        var course = new Course
        {
            Id = courseId,
            Title = courseTitle,
            ThumbnailUrl = $"thumb-{courseId}.png",
            Sections = new List<Section>
            {
                new Section
                {
                    Id = courseId,
                    CourseId = courseId,
                    Lectures = Enumerable.Range(1, lectureCount)
                        .Select(i => new Lecture { Id = courseId * 100 + i, Title = $"Lecture {i}" })
                        .ToList()
                }
            }
        };

        return new Enrollment
        {
            Id = id,
            CourseId = courseId,
            UserId = userId,
            EnrolledAt = DateTime.UtcNow.AddDays(-3),
            Course = course
        };
    }

    [Fact]
    public async Task GetStudentsByInstructorAsync_MapsStudentsToDtos()
    {
        var students = new List<ApplicationUser>
        {
            TestData.User("s1", "Ahmed"),
            TestData.User("s2", "Laila")
        };
        _studentRepo.Setup(x => x.GetStudentsByInstructorAsync("ins-1", It.IsAny<CancellationToken>()))
            .ReturnsAsync(students);

        var result = await _service.GetStudentsByInstructorAsync("ins-1");

        Assert.Equal(2, result.Count);
        Assert.Equal("Ahmed", result[0].FullName);
        Assert.Equal("s1", result[0].Id);
        Assert.Equal("Ahmed@test.com", result[0].Email);
    }

    [Theory]
    [InlineData(null)]
    [InlineData("")]
    [InlineData("   ")]
    public async Task GetStudentsByInstructorAsync_ThrowsForInvalidInstructorId(string instructorId)
    {
        await Assert.ThrowsAsync<ArgumentException>(
            () => _service.GetStudentsByInstructorAsync(instructorId));
    }

    [Fact]
    public async Task GetStudentDetailsAsync_ComputesProgressAndStatistics()
    {
        var student = TestData.User("s1", "Ahmed");
        var enrollment = EnrollmentWithLectures(1, 10, "s1", "C# Basics", 2);

        _studentRepo.Setup(x => x.GetStudentByIdAsync("s1", It.IsAny<CancellationToken>()))
            .ReturnsAsync(student);
        _studentRepo.Setup(x => x.GetStudentEnrollmentsWithDetailsAsync("s1", It.IsAny<CancellationToken>()))
            .ReturnsAsync(new List<Enrollment> { enrollment });
        _studentRepo.Setup(x => x.GetRecentStudentEnrollmentsAsync("s1", 10, It.IsAny<CancellationToken>()))
            .ReturnsAsync(new List<Enrollment> { enrollment });
        _progressRepo.Setup(x => x.GetProgressByEnrollmentAsync(1, It.IsAny<CancellationToken>()))
            .ReturnsAsync(new List<CourseProgress>
            {
                TestData.Progress(1, 1, 101, 10, isCompleted: true),
                TestData.Progress(2, 1, 102, 10, isCompleted: false)
            });

        var details = await _service.GetStudentDetailsAsync("s1");

        Assert.NotNull(details);
        Assert.Equal("Ahmed", details.Student.FullName);

        var dto = Assert.Single(details.Enrollments);
        Assert.Equal("C# Basics", dto.CourseTitle);
        Assert.Equal(2, dto.TotalLectures);
        Assert.Equal(1, dto.CompletedLectures);
        Assert.Equal(50m, dto.ProgressPercentage);
        Assert.Equal("Active", dto.Status);

        Assert.Equal(1, details.Statistics.TotalEnrollments);
        Assert.Equal(1, details.Statistics.ActiveCourses);
        Assert.Equal(0, details.Statistics.CompletedCourses);
        Assert.Equal(50m, details.Statistics.AverageProgress);

        var activity = Assert.Single(details.RecentActivities);
        Assert.Equal("Enrollment", activity.Type);
        Assert.Equal("C# Basics", activity.CourseTitle);
    }

    [Fact]
    public async Task GetStudentDetailsAsync_ReturnsNullWhenStudentNotFound()
    {
        _studentRepo.Setup(x => x.GetStudentByIdAsync("ghost", It.IsAny<CancellationToken>()))
            .ReturnsAsync((ApplicationUser?)null);

        Assert.Null(await _service.GetStudentDetailsAsync("ghost"));
    }

    [Theory]
    [InlineData(null)]
    [InlineData("")]
    public async Task GetStudentDetailsAsync_ThrowsForInvalidStudentId(string studentId)
    {
        await Assert.ThrowsAsync<ArgumentException>(
            () => _service.GetStudentDetailsAsync(studentId));
    }

    [Fact]
    public async Task SendBulkMessageAsync_SendsNotificationToEachStudent()
    {
        var message = new BulkMessageDto
        {
            StudentIds = new List<string> { "s1", "s2" },
            Subject = "Course update",
            Message = "New lecture added",
            SendNotification = true,
            SendEmail = false
        };

        var result = await _service.SendBulkMessageAsync(message);

        Assert.True(result);
        _notificationService.Verify(
            n => n.CreateNotificationAsync(
                It.Is<CreateNotificationDto>(d => d.UserId == "s1" && d.Title == "Course update"),
                It.IsAny<CancellationToken>()),
            Times.Once);
        _notificationService.Verify(
            n => n.CreateNotificationAsync(
                It.Is<CreateNotificationDto>(d => d.UserId == "s2"),
                It.IsAny<CancellationToken>()),
            Times.Once);
    }

    [Fact]
    public async Task SendBulkMessageAsync_SkipsNotificationsWhenDisabled()
    {
        var message = new BulkMessageDto
        {
            StudentIds = new List<string> { "s1" },
            Subject = "Update",
            Message = "Hello",
            SendNotification = false,
            SendEmail = false
        };

        var result = await _service.SendBulkMessageAsync(message);

        Assert.True(result);
        _notificationService.Verify(
            n => n.CreateNotificationAsync(It.IsAny<CreateNotificationDto>(), It.IsAny<CancellationToken>()),
            Times.Never);
    }

    [Fact]
    public async Task SendBulkMessageAsync_ReturnsFalseWhenNotificationCreationFails()
    {
        var message = new BulkMessageDto
        {
            StudentIds = new List<string> { "s1" },
            Subject = null,
            Message = "Hello",
            SendNotification = true,
            SendEmail = false
        };
        _notificationService
            .Setup(n => n.CreateNotificationAsync(It.IsAny<CreateNotificationDto>(), It.IsAny<CancellationToken>()))
            .ThrowsAsync(new ArgumentException("Title is required"));

        var result = await _service.SendBulkMessageAsync(message);

        Assert.False(result);
    }

    [Fact]
    public async Task GetStudentsProgressAsync_ReturnsEmptyForNullOrEmptyIds()
    {
        Assert.Empty(await _service.GetStudentsProgressAsync(new List<string>()));
        Assert.Empty(await _service.GetStudentsProgressAsync(null));

        _studentRepo.Verify(
            x => x.GetStudentsProgressEnrollmentsAsync(It.IsAny<List<string>>(), It.IsAny<CancellationToken>()),
            Times.Never);
    }

    [Fact]
    public async Task GetStudentsProgressAsync_ComputesPercentageAndStatus()
    {
        var enrollments = new List<Enrollment>
        {
            EnrollmentWithLectures(1, 10, "s1", "C# Basics", 2),
            EnrollmentWithLectures(2, 11, "s1", "SQL", 0)
        };
        _studentRepo.Setup(x => x.GetStudentsProgressEnrollmentsAsync(
                It.Is<List<string>>(ids => ids.Count == 1 && ids[0] == "s1"),
                It.IsAny<CancellationToken>()))
            .ReturnsAsync(enrollments);
        _progressRepo.Setup(x => x.GetProgressByEnrollmentAsync(It.IsAny<int>(), It.IsAny<CancellationToken>()))
            .ReturnsAsync((int enrollmentId, CancellationToken _) => enrollmentId == 1
                ? new List<CourseProgress> { TestData.Progress(1, 1, 101, 10, isCompleted: true) }
                : new List<CourseProgress>());

        var result = await _service.GetStudentsProgressAsync(new List<string> { "s1" });

        Assert.Equal(2, result.Count);

        var active = result.Single(r => r.CourseId == 10);
        Assert.Equal(50m, active.ProgressPercentage);
        Assert.Equal(1, active.CompletedLectures);
        Assert.Equal(2, active.TotalLectures);
        Assert.Equal("Active", active.Status);

        var notStarted = result.Single(r => r.CourseId == 11);
        Assert.Equal(0m, notStarted.ProgressPercentage);
        Assert.Equal("Not Started", notStarted.Status);
    }

    [Fact]
    public async Task GetStudentsProgressAsync_ReturnsEmptyWhenNoEnrollments()
    {
        _studentRepo.Setup(x => x.GetStudentsProgressEnrollmentsAsync(
                It.IsAny<List<string>>(), It.IsAny<CancellationToken>()))
            .ReturnsAsync(new List<Enrollment>());

        var result = await _service.GetStudentsProgressAsync(new List<string> { "s1" });

        Assert.Empty(result);
    }
}

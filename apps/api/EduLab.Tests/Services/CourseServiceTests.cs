using EduLab_Application.DTOs.Course;
using EduLab_Application.DTOs.Lecture;
using EduLab_Application.DTOs.Notification;
using EduLab_Application.DTOs.Rating;
using EduLab_Application.DTOs.Section;
using EduLab_Application.ServiceInterfaces;
using EduLab_Application.Services;
using EduLab_Domain.Entities;
using EduLab_Domain.IRepository;
using EduLab.Tests.Fakes;
using Microsoft.AspNetCore.Identity;
using Moq;
using System.Linq.Expressions;
using Xunit;

namespace EduLab.Tests.Services;

public class CourseServiceTests
{
    private readonly List<Course> _courses;
    private readonly List<Enrollment> _enrollments;
    private readonly Mock<ICourseRepository> _courseRepo;
    private readonly Mock<IEnrollmentRepository> _enrollmentRepo;
    private readonly Mock<ICurrentUserService> _currentUser;
    private readonly Mock<INotificationService> _notifications;
    private readonly Mock<IRatingService> _ratings;
    private readonly Mock<IEmailTemplateService> _emailTemplates;
    private readonly Mock<IEmailSender> _emailSender;
    private readonly List<ApplicationUser> _users;
    private readonly CourseService _service;

    public CourseServiceTests()
    {
        _users = new List<ApplicationUser>
        {
            TestData.User("ins-1", "Instructor One", role: "Instructor"),
            TestData.User("student-1", "Student One")
        };
        _users[0].Title = "Senior Developer";
        _users[0].About = "Teaches C#";

        _courses = new List<Course>();
        _enrollments = new List<Enrollment>();

        _courseRepo = new Mock<ICourseRepository>();
        _courseRepo.Setup(x => x.GetCourseByIdAsync(It.IsAny<int>(), It.IsAny<bool>(), It.IsAny<CancellationToken>()))
            .ReturnsAsync((int id, bool tracking, CancellationToken ct) => _courses.FirstOrDefault(c => c.Id == id));
        _courseRepo.Setup(x => x.AddAsync(It.IsAny<Course>(), It.IsAny<CancellationToken>()))
            .ReturnsAsync((Course c, CancellationToken ct) =>
            {
                if (c.Id == 0) c.Id = _courses.Count + 1;
                _courses.Add(c);
                return c;
            });
        _courseRepo.Setup(x => x.UpdateAsync(It.IsAny<Course>(), It.IsAny<CancellationToken>()))
            .ReturnsAsync((Course c, CancellationToken ct) => c);
        _courseRepo.Setup(x => x.DeleteAsync(It.IsAny<int>(), It.IsAny<CancellationToken>())).ReturnsAsync(true);
        _courseRepo.Setup(x => x.UpdateStatusAsync(It.IsAny<int>(), It.IsAny<Coursestatus>(), It.IsAny<CancellationToken>())).ReturnsAsync(true);
        _courseRepo.Setup(x => x.GetCoursesByInstructorAsync(It.IsAny<string>(), It.IsAny<CancellationToken>()))
            .ReturnsAsync((string instructorId, CancellationToken ct) => _courses.Where(c => c.InstructorId == instructorId));
        _courseRepo.Setup(x => x.GetAllAsync(
                It.IsAny<Expression<Func<Course, bool>>>(),
                It.IsAny<string?>(),
                It.IsAny<bool>(),
                It.IsAny<Func<IQueryable<Course>, IOrderedQueryable<Course>>>(),
                It.IsAny<int?>(),
                It.IsAny<CancellationToken>()))
            .ReturnsAsync((Expression<Func<Course, bool>>? f, string? includeProperties, bool tracking,
                Func<IQueryable<Course>, IOrderedQueryable<Course>>? orderBy, int? take, CancellationToken ct) =>
                f == null ? _courses.ToList() : _courses.AsQueryable().Where(f).ToList());
        _courseRepo.Setup(x => x.GetLectureResourcesAsync(It.IsAny<int>(), It.IsAny<CancellationToken>()))
            .ReturnsAsync(new List<LectureResource>());

        _enrollmentRepo = new Mock<IEnrollmentRepository>();
        _enrollmentRepo.Setup(x => x.GetAllAsync(
                It.IsAny<Expression<Func<Enrollment, bool>>>(),
                It.IsAny<string?>(),
                It.IsAny<bool>(),
                It.IsAny<Func<IQueryable<Enrollment>, IOrderedQueryable<Enrollment>>?>(),
                It.IsAny<int?>(),
                It.IsAny<CancellationToken>()))
            .ReturnsAsync((Expression<Func<Enrollment, bool>>? f, string? includeProperties, bool tracking,
                Func<IQueryable<Enrollment>, IOrderedQueryable<Enrollment>>? orderBy, int? take, CancellationToken ct) =>
                f == null ? _enrollments.ToList() : _enrollments.AsQueryable().Where(f).ToList());

        _currentUser = new Mock<ICurrentUserService>();
        _currentUser.Setup(x => x.GetUserIdAsync()).ReturnsAsync((string?)null);

        _notifications = new Mock<INotificationService>();
        _notifications.Setup(x => x.CreateNotificationAsync(It.IsAny<CreateNotificationDto>(), It.IsAny<CancellationToken>()))
            .ReturnsAsync(new NotificationDto());

        _ratings = new Mock<IRatingService>();

        _emailTemplates = new Mock<IEmailTemplateService>();
        _emailTemplates.Setup(x => x.GetFormattedText(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<object[]>())).Returns("subject");
        _emailTemplates.Setup(x => x.GenerateCourseApprovalEmail(It.IsAny<ApplicationUser>(), It.IsAny<string>(), It.IsAny<string>(), It.IsAny<string>()))
            .Returns("<html>approved</html>");
        _emailTemplates.Setup(x => x.GenerateCourseRejectionEmail(It.IsAny<ApplicationUser>(), It.IsAny<string>(), It.IsAny<string>(), It.IsAny<string>()))
            .Returns("<html>rejected</html>");
        _emailSender = new Mock<IEmailSender>();

        _service = new CourseService(
            _courseRepo.Object,
            Mock.Of<IVideoDurationService>(),
            _currentUser.Object,
            TestData.MockUserManager(_users).Object,
            TestInfrastructure.RealMapper(),
            _emailTemplates.Object,
            _emailSender.Object,
            TestData.NullLogger<CourseService>(),
            Mock.Of<IFileStorageService>(),
            _ratings.Object,
            _notifications.Object,
            _enrollmentRepo.Object);
    }

    [Fact]
    public async Task CreateCourseDraftAsync_DefaultsToDraftStatus()
    {
        var result = await _service.CreateCourseDraftAsync(new CourseDraftDTO
        {
            Title = "C# Basics",
            ShortDescription = "short",
            Description = "long",
            Price = 100,
            Discount = 20,
            CategoryId = 1,
            InstructorId = "ins-1"
        });

        Assert.NotNull(result);
        Assert.Equal("C# Basics", result.Title);
        Assert.Equal("Draft", result.Status);
        Assert.True(result.HasCertificate);
        Assert.Equal("/images/Courses/default.jpg", result.ThumbnailUrl);
        Assert.Equal("ins-1", result.InstructorId);
        Assert.Equal("Instructor One", result.InstructorName);
    }

    [Fact]
    public async Task CreateCourseDraftAsync_NoInstructor_ThrowsUnauthorized()
    {
        await Assert.ThrowsAsync<UnauthorizedAccessException>(() => _service.CreateCourseDraftAsync(new CourseDraftDTO
        {
            Title = "Orphan Course",
            InstructorId = null
        }));
    }

    [Fact]
    public async Task UpdateCourseAsync_UpdatesTitleAndRecalculatesDuration()
    {
        var course = TestData.Course(1, "Old Title", instructorId: "ins-1");
        course.Sections = new List<Section>
        {
            new Section
            {
                Id = 1, Title = "S1", Order = 0, CourseId = 1,
                Lectures = new List<Lecture>
                {
                    new Lecture { Id = 1, Title = "L1", ContentType = ContentType.Video, Duration = 30, SectionId = 1 },
                    new Lecture { Id = 2, Title = "L2", ContentType = ContentType.Article, Duration = 20, SectionId = 1 }
                }
            }
        };
        _courses.Add(course);

        var result = await _service.UpdateCourseAsync(new CourseUpdateDTO
        {
            Id = 1,
            Title = "New Title",
            ShortDescription = "short",
            Description = "long",
            Price = 150,
            CategoryId = 1,
            Level = "advanced",
            Language = "en",
            Sections = new List<SectionDTO>
            {
                new SectionDTO
                {
                    Title = "S1", Order = 0, CourseId = 1,
                    Lectures = new List<LectureDTO>
                    {
                        new LectureDTO { Title = "L1", ContentType = "Video", Duration = 30 },
                        new LectureDTO { Title = "L2", ContentType = "Article", Duration = 20 }
                    }
                }
            }
        });

        Assert.NotNull(result);
        Assert.Equal("New Title", result.Title);
        Assert.Equal(50, result.Duration);
        Assert.Equal(2, result.TotalLectures);
        _courseRepo.Verify(x => x.UpdateAsync(It.IsAny<Course>(), It.IsAny<CancellationToken>()), Times.Once);
    }

    [Fact]
    public async Task UpdateCourseAsync_NotFound_ReturnsNull()
    {
        var result = await _service.UpdateCourseAsync(new CourseUpdateDTO { Id = 99, Title = "Ghost" });

        Assert.Null(result);
    }

    [Fact]
    public async Task DeleteCourseAsync_NoEnrollments_DeletesAndNotifiesInstructor()
    {
        _courses.Add(TestData.Course(1, "To Delete", instructorId: "ins-1"));

        var result = await _service.DeleteCourseAsync(1);

        Assert.True(result);
        _courseRepo.Verify(x => x.DeleteAsync(1, It.IsAny<CancellationToken>()), Times.Once);
        _notifications.Verify(x => x.CreateNotificationAsync(
            It.Is<CreateNotificationDto>(n => n.UserId == "ins-1"),
            It.IsAny<CancellationToken>()), Times.Once);
    }

    [Fact]
    public async Task DeleteCourseAsync_WithEnrollments_Throws()
    {
        _courses.Add(TestData.Course(1, "Popular", instructorId: "ins-1"));
        _enrollments.Add(TestData.Enrollment(1, 1, "student-1"));

        var ex = await Assert.ThrowsAsync<InvalidOperationException>(() => _service.DeleteCourseAsync(1));

        Assert.Contains("طلاب مسجلين", ex.Message);
        _courseRepo.Verify(x => x.DeleteAsync(It.IsAny<int>(), It.IsAny<CancellationToken>()), Times.Never);
    }

    [Fact]
    public async Task DeleteCourseAsync_NotFound_ReturnsFalse()
    {
        var result = await _service.DeleteCourseAsync(99);

        Assert.False(result);
        _courseRepo.Verify(x => x.DeleteAsync(It.IsAny<int>(), It.IsAny<CancellationToken>()), Times.Never);
    }

    [Fact]
    public async Task GetCourseByIdAsync_IncludesInstructorRatingsAndEnrollmentCount()
    {
        var course = TestData.Course(1, "Full Course", price: 120m, discount: 10m, instructorId: "ins-1");
        course.Sections = new List<Section>
        {
            new Section
            {
                Id = 1, Title = "S1", Order = 0, CourseId = 1,
                Lectures = new List<Lecture>
                {
                    new Lecture { Id = 10, Title = "L1", ContentType = ContentType.Video, Duration = 45, SectionId = 1 }
                }
            }
        };
        _courses.Add(course);
        _enrollments.Add(TestData.Enrollment(1, 1, "student-1"));
        _enrollments.Add(TestData.Enrollment(2, 1, "student-2"));
        _ratings.Setup(x => x.GetCourseRatingSummaryAsync(1, It.IsAny<CancellationToken>()))
            .ReturnsAsync(new CourseRatingSummaryDto
            {
                CourseId = 1,
                AverageRating = 4.5,
                TotalRatings = 10,
                RatingDistribution = new Dictionary<int, int> { { 5, 8 }, { 4, 2 } }
            });

        var result = await _service.GetCourseByIdAsync(1);

        Assert.NotNull(result);
        Assert.Equal("Full Course", result.Title);
        Assert.Equal("Instructor One", result.InstructorName);
        Assert.Equal("Teaches C#", result.InstructorAbout);
        Assert.Equal("Senior Developer", result.InstructorTitle);
        Assert.Equal(4.5, result.AverageRating);
        Assert.Equal(10, result.TotalRatings);
        Assert.Equal(2, result.EnrollmentCount);
        Assert.Equal(45, result.Duration);
        Assert.Equal(1, result.TotalLectures);
    }

    [Fact]
    public async Task GetCourseByIdAsync_NotFound_ReturnsNull()
    {
        var result = await _service.GetCourseByIdAsync(99);

        Assert.Null(result);
    }

    [Fact]
    public async Task GetInstructorCoursesAsync_ReturnsOnlyInstructorCourses()
    {
        _courses.Add(TestData.Course(1, "C# Basics", instructorId: "ins-1"));
        _courses.Add(TestData.Course(2, "React", instructorId: "ins-1"));
        _courses.Add(TestData.Course(3, "Design", instructorId: "ins-2"));

        var result = await _service.GetInstructorCoursesAsync("ins-1");

        Assert.Equal(2, result.Count());
        Assert.All(result, c => Assert.Equal("ins-1", c.InstructorId));
    }

    [Fact]
    public async Task AcceptCourseAsync_ApprovesAndNotifiesInstructor()
    {
        var course = TestData.Course(1, "Pending Course", instructorId: "ins-1");
        course.Status = Coursestatus.Pending;
        _courses.Add(course);

        var result = await _service.AcceptCourseAsync(1);

        Assert.True(result);
        _courseRepo.Verify(x => x.UpdateStatusAsync(1, Coursestatus.Approved, It.IsAny<CancellationToken>()), Times.Once);
        _emailSender.Verify(x => x.SendEmailAsync("Instructor One@test.com", "subject", "<html>approved</html>"), Times.Once);
        _notifications.Verify(x => x.CreateNotificationAsync(
            It.Is<CreateNotificationDto>(n => n.UserId == "ins-1"),
            It.IsAny<CancellationToken>()), Times.Once);
    }

    [Fact]
    public async Task RejectCourseAsync_RejectsAndRecordsReason()
    {
        var course = TestData.Course(1, "Bad Course", instructorId: "ins-1");
        _courses.Add(course);

        var result = await _service.RejectCourseAsync(1, "Low quality content");

        Assert.True(result);
        Assert.Equal("Low quality content", course.RejectionReason);
        _courseRepo.Verify(x => x.UpdateStatusAsync(1, Coursestatus.Rejected, It.IsAny<CancellationToken>()), Times.Once);
        _emailSender.Verify(x => x.SendEmailAsync("Instructor One@test.com", "subject", "<html>rejected</html>"), Times.Once);
    }

    [Fact]
    public async Task AcceptCourseAsync_NotFound_ReturnsFalse()
    {
        var result = await _service.AcceptCourseAsync(99);

        Assert.False(result);
        _courseRepo.Verify(x => x.UpdateStatusAsync(It.IsAny<int>(), It.IsAny<Coursestatus>(), It.IsAny<CancellationToken>()), Times.Never);
    }
}

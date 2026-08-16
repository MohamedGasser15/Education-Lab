using System.Linq.Expressions;
using EduLab_Application.Common.Constants;
using EduLab_Application.DTOs.Report;
using EduLab_Application.ServiceInterfaces;
using EduLab_Application.Services;
using EduLab_Domain.Entities;
using EduLab_Domain.IRepository;
using EduLab.Tests.Fakes;
using Microsoft.AspNetCore.Identity;
using Moq;
using Xunit;

namespace EduLab.Tests.Services;

public class ReportServiceTests
{
    private readonly Mock<IReportRepository> _reportRepo;
    private readonly FakeRepository<LectureComment> _comments;
    private readonly Mock<ICourseRepository> _courseRepo;
    private readonly Mock<IRatingRepository> _ratingRepo;
    private readonly Mock<INotificationService> _notificationService;
    private readonly List<ApplicationUser> _users;
    private readonly ReportService _service;

    public ReportServiceTests()
    {
        _reportRepo = new Mock<IReportRepository>();
        _comments = new FakeRepository<LectureComment>();
        _courseRepo = new Mock<ICourseRepository>();
        _ratingRepo = new Mock<IRatingRepository>();
        _notificationService = new Mock<INotificationService>();

        _users = new List<ApplicationUser>
        {
            TestData.User("user-1", "Ahmed"),
            TestData.User("ins-1", "Sara", role: "Instructor"),
            TestData.User("owner-1", "Omar")
        };

        _service = new ReportService(
            _reportRepo.Object,
            _comments,
            _courseRepo.Object,
            _ratingRepo.Object,
            _notificationService.Object,
            Mock.Of<IEmailSender>(),
            Mock.Of<IEmailTemplateService>(),
            TestData.MockUserManager(_users).Object,
            TestData.NullLogger<ReportService>());
    }

    private Course MockCourse(int id, string title, string instructorId = "ins-1")
    {
        var course = TestData.Course(id, title, instructorId: instructorId);
        _courseRepo.Setup(x => x.GetAsync(
                It.IsAny<Expression<Func<Course, bool>>>(),
                It.IsAny<string>(),
                It.IsAny<bool>(),
                It.IsAny<CancellationToken>()))
            .ReturnsAsync(course);
        return course;
    }

    private static Report Report(int id, string type, int targetId, string status = SD.ReportStatusPending, string reason = "Spam", string reporterId = "user-1")
        => new()
        {
            Id = id,
            Type = type,
            TargetId = targetId,
            Reason = reason,
            Status = status,
            ReporterId = reporterId,
            CreatedAt = DateTime.UtcNow
        };

    [Fact]
    public async Task CreateReportAsync_CreatesPendingReportForCourse()
    {
        MockCourse(5, "Bad Course");
        Report? captured = null;
        _reportRepo.Setup(x => x.CreateAsync(It.IsAny<Report>(), It.IsAny<CancellationToken>()))
            .Callback<Report, CancellationToken>((r, _) => captured = r)
            .ReturnsAsync((Report r, CancellationToken _) => { r.Id = 1; return r; });

        var result = await _service.CreateReportAsync("user-1", new CreateReportDto
        {
            Type = SD.ReportTypeCourse,
            TargetId = 5,
            Reason = SD.ReportReasonCopyright,
            Details = "Copied content"
        });

        Assert.NotNull(captured);
        Assert.Equal(SD.ReportTypeCourse, captured.Type);
        Assert.Equal(5, captured.TargetId);
        Assert.Equal(SD.ReportStatusPending, captured.Status);
        Assert.Equal("user-1", captured.ReporterId);

        Assert.Equal(1, result.Id);
        Assert.Equal(SD.ReportStatusPending, result.Status);
        Assert.Equal("Ahmed", result.ReporterName);
        Assert.Equal("Bad Course", result.TargetSummary);
        Assert.Equal("Sara", result.TargetOwnerName);
        Assert.Equal(5, result.CourseId);
        Assert.Equal("Bad Course", result.CourseTitle);
        Assert.False(result.CanDeleteContent);
    }

    [Fact]
    public async Task CreateReportAsync_ThrowsForInvalidType()
    {
        await Assert.ThrowsAsync<ArgumentException>(() => _service.CreateReportAsync("user-1",
            new CreateReportDto { Type = "Weird", TargetId = 1, Reason = "Other" }));
    }

    [Fact]
    public async Task CreateReportAsync_ThrowsForInvalidReason()
    {
        await Assert.ThrowsAsync<ArgumentException>(() => _service.CreateReportAsync("user-1",
            new CreateReportDto { Type = SD.ReportTypeComment, TargetId = 1, Reason = SD.ReportReasonCopyright }));
    }

    [Fact]
    public async Task CreateReportAsync_ThrowsWhenCourseNotFound()
    {
        _courseRepo.Setup(x => x.GetAsync(
                It.IsAny<Expression<Func<Course, bool>>>(),
                It.IsAny<string>(),
                It.IsAny<bool>(),
                It.IsAny<CancellationToken>()))
            .ReturnsAsync((Course?)null);

        await Assert.ThrowsAsync<KeyNotFoundException>(() => _service.CreateReportAsync("user-1",
            new CreateReportDto { Type = SD.ReportTypeCourse, TargetId = 999, Reason = SD.ReportReasonOther }));
    }

    [Fact]
    public async Task CreateReportAsync_ThrowsWhenReportingOwnContent()
    {
        var rating = TestData.Rating(4, 10, "user-1", 4);
        _ratingRepo.Setup(x => x.GetAsync(
                It.IsAny<Expression<Func<Rating, bool>>>(),
                It.IsAny<string>(),
                It.IsAny<bool>(),
                It.IsAny<CancellationToken>()))
            .ReturnsAsync(rating);

        await Assert.ThrowsAsync<InvalidOperationException>(() => _service.CreateReportAsync("user-1",
            new CreateReportDto { Type = SD.ReportTypeReview, TargetId = 4, Reason = SD.ReportReasonSpam }));
    }

    [Fact]
    public async Task CreateReportAsync_ThrowsForDuplicateReport()
    {
        MockCourse(5, "Bad Course");
        _reportRepo.Setup(x => x.AnyAsync(It.IsAny<Expression<Func<Report, bool>>>(), It.IsAny<CancellationToken>()))
            .ReturnsAsync(true);

        await Assert.ThrowsAsync<InvalidOperationException>(() => _service.CreateReportAsync("user-1",
            new CreateReportDto { Type = SD.ReportTypeCourse, TargetId = 5, Reason = SD.ReportReasonOther }));
    }

    [Fact]
    public async Task GetAdminReportsAsync_AppliesFiltersAndPaging()
    {
        MockCourse(5, "Bad Course");
        var reports = new List<Report> { Report(1, SD.ReportTypeCourse, 5) };
        _reportRepo.Setup(x => x.CountFilteredAsync("pending", "Course", "bad", It.IsAny<CancellationToken>()))
            .ReturnsAsync(1);
        _reportRepo.Setup(x => x.GetFilteredAsync("pending", "Course", "bad", 10, 10, It.IsAny<CancellationToken>()))
            .ReturnsAsync(reports);
        _reportRepo.Setup(x => x.CountAsync(It.IsAny<Expression<Func<Report, bool>>>(), It.IsAny<CancellationToken>()))
            .ReturnsAsync(3);

        var result = await _service.GetAdminReportsAsync("pending", "Course", "bad", page: 2, pageSize: 10);

        Assert.Equal(1, result.TotalCount);
        Assert.Equal(3, result.PendingCount);
        Assert.Equal(3, result.ResolvedCount);
        Assert.Equal(3, result.DismissedCount);
        Assert.Equal(2, result.PageNumber);
        Assert.Equal(10, result.PageSize);

        var item = Assert.Single(result.Items);
        Assert.Equal("Bad Course", item.TargetSummary);
        Assert.Equal("Ahmed", item.ReporterName);
    }

    [Fact]
    public async Task UpdateStatusAsync_ResolvesWithContentRemoval()
    {
        var comment = TestData.LectureComment(3, 3, "owner-1", "Spam comment");
        _comments.Items.Add(comment);
        var report = Report(7, SD.ReportTypeComment, 3);
        _reportRepo.Setup(x => x.GetByIdAsync(7, It.IsAny<CancellationToken>()))
            .ReturnsAsync(report);

        await _service.UpdateStatusAsync("admin-1", 7, new UpdateReportStatusDto
        {
            Status = SD.ReportStatusResolved,
            Action = SD.ReportActionRemovedContent,
            AdminNote = "Spam removed"
        });

        Assert.Equal(SD.ReportStatusResolved, report.Status);
        Assert.Equal("admin-1", report.HandledById);
        Assert.Equal(SD.ReportActionRemovedContent, report.ResolvedActions);
        Assert.Equal("Spam removed", report.AdminNote);
        Assert.NotNull(report.HandledAt);
        Assert.Empty(_comments.Items);
        _reportRepo.Verify(x => x.SaveAsync(It.IsAny<CancellationToken>()), Times.Once);
    }

    [Fact]
    public async Task UpdateStatusAsync_ThrowsForInvalidStatus()
    {
        _reportRepo.Setup(x => x.GetByIdAsync(7, It.IsAny<CancellationToken>()))
            .ReturnsAsync(Report(7, SD.ReportTypeComment, 3));

        await Assert.ThrowsAsync<ArgumentException>(() => _service.UpdateStatusAsync("admin-1", 7,
            new UpdateReportStatusDto { Status = "pending" }));
    }

    [Fact]
    public async Task UpdateStatusAsync_ThrowsWhenReportNotFound()
    {
        _reportRepo.Setup(x => x.GetByIdAsync(999, It.IsAny<CancellationToken>()))
            .ReturnsAsync((Report?)null);

        await Assert.ThrowsAsync<KeyNotFoundException>(() => _service.UpdateStatusAsync("admin-1", 999,
            new UpdateReportStatusDto { Status = SD.ReportStatusResolved }));
    }

    [Fact]
    public async Task UpdateStatusAsync_ThrowsWhenRemovingCourseContent()
    {
        _reportRepo.Setup(x => x.GetByIdAsync(7, It.IsAny<CancellationToken>()))
            .ReturnsAsync(Report(7, SD.ReportTypeCourse, 5));

        await Assert.ThrowsAsync<InvalidOperationException>(() => _service.UpdateStatusAsync("admin-1", 7,
            new UpdateReportStatusDto { Status = SD.ReportStatusResolved, Action = SD.ReportActionRemovedContent }));
    }

    [Fact]
    public async Task UpdateStatusAsync_DismissesWithoutDeletingContent()
    {
        var comment = TestData.LectureComment(3, 3, "owner-1", "Reported comment");
        _comments.Items.Add(comment);
        var report = Report(8, SD.ReportTypeComment, 3);
        _reportRepo.Setup(x => x.GetByIdAsync(8, It.IsAny<CancellationToken>()))
            .ReturnsAsync(report);

        await _service.UpdateStatusAsync("admin-1", 8, new UpdateReportStatusDto
        {
            Status = SD.ReportStatusDismissed,
            AdminNote = "No violation"
        });

        Assert.Equal(SD.ReportStatusDismissed, report.Status);
        Assert.Single(_comments.Items);
        _ratingRepo.Verify(x => x.DeleteAsync(It.IsAny<Rating>(), It.IsAny<CancellationToken>()), Times.Never);
    }

    [Fact]
    public async Task DeleteReportedContentAsync_RemovesReviewAndMarksResolved()
    {
        var rating = TestData.Rating(4, 10, "owner-1", 4);
        rating.Comment = "Nice";
        _ratingRepo.Setup(x => x.GetAsync(
                It.IsAny<Expression<Func<Rating, bool>>>(),
                It.IsAny<string>(),
                It.IsAny<bool>(),
                It.IsAny<CancellationToken>()))
            .ReturnsAsync(rating);
        MockCourse(10, "C# Basics");
        var report = Report(9, SD.ReportTypeReview, 4);
        _reportRepo.Setup(x => x.GetByIdAsync(9, It.IsAny<CancellationToken>()))
            .ReturnsAsync(report);

        var result = await _service.DeleteReportedContentAsync("admin-1", 9);

        _ratingRepo.Verify(x => x.DeleteAsync(rating, It.IsAny<CancellationToken>()), Times.Once);
        Assert.Equal(SD.ReportStatusResolved, report.Status);
        Assert.Equal(SD.ReportActionRemovedContent, report.ResolvedActions);
        Assert.Equal("admin-1", report.HandledById);

        Assert.Equal(SD.ReportStatusResolved, result.Status);
        Assert.Equal("تم حذف المحتوى المخالف", result.AdminNote);
        Assert.True(result.CanDeleteContent);
        Assert.Contains("⭐ 4/5", result.TargetSummary);
        Assert.Equal("C# Basics", result.CourseTitle);
    }

    [Fact]
    public async Task DeleteReportedContentAsync_ThrowsWhenReportNotFound()
    {
        _reportRepo.Setup(x => x.GetByIdAsync(999, It.IsAny<CancellationToken>()))
            .ReturnsAsync((Report?)null);

        await Assert.ThrowsAsync<KeyNotFoundException>(
            () => _service.DeleteReportedContentAsync("admin-1", 999));
    }

    [Fact]
    public async Task DeleteReportedContentAsync_ThrowsForCourseReports()
    {
        _reportRepo.Setup(x => x.GetByIdAsync(7, It.IsAny<CancellationToken>()))
            .ReturnsAsync(Report(7, SD.ReportTypeCourse, 5));

        await Assert.ThrowsAsync<InvalidOperationException>(
            () => _service.DeleteReportedContentAsync("admin-1", 7));
    }

    [Fact]
    public async Task GetPendingCountAsync_ReturnsPendingReportsCount()
    {
        _reportRepo.Setup(x => x.CountAsync(It.IsAny<Expression<Func<Report, bool>>>(), It.IsAny<CancellationToken>()))
            .ReturnsAsync(4);

        var count = await _service.GetPendingCountAsync();

        Assert.Equal(4, count);
    }

    [Fact]
    public async Task HasReportedAsync_DelegatesToRepository()
    {
        _reportRepo.Setup(x => x.AnyAsync(It.IsAny<Expression<Func<Report, bool>>>(), It.IsAny<CancellationToken>()))
            .ReturnsAsync(true);

        Assert.True(await _service.HasReportedAsync("user-1", SD.ReportTypeComment, 3));
    }
}

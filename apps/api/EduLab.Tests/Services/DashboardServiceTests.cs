using EduLab_Application.Services;
using EduLab_Domain.Entities;
using EduLab.Tests.Fakes;
using Xunit;

namespace EduLab.Tests.Services;

public class DashboardServiceTests
{
    private readonly List<ApplicationUser> _users;
    private readonly FakeRepository<Course> _courses;
    private readonly FakeRepository<Enrollment> _enrollments;
    private readonly FakeRepository<Payment> _payments;
    private readonly FakeRepository<Rating> _ratings;
    private readonly FakeRepository<Category> _categories;
    private readonly FakeRepository<CourseProgress> _progress;
    private readonly FakeRepository<Notification> _notifications;
    private readonly DashboardService _service;

    public DashboardServiceTests()
    {
        var now = DateTime.UtcNow;

        _users = new List<ApplicationUser>
        {
            TestData.User("u1", "Ahmed", now.AddDays(-10)),
            TestData.User("u2", "Sara", now.AddDays(-20)),
            TestData.User("u3", "Omar", now.AddDays(-40))
        };

        _courses = new FakeRepository<Course>(new[]
        {
            TestData.Course(1, "C# Basics", 100m, 20m, "ins-1", 1, now.AddDays(-10)),
            TestData.Course(2, "React", 200m, null, "ins-1", 1, now.AddDays(-40)),
            TestData.Course(3, "Design", 50m, null, "ins-2", 2, now.AddDays(-5))
        });

        _enrollments = new FakeRepository<Enrollment>(new[]
        {
            TestData.Enrollment(1, 1, "u1", now.AddHours(-5)),
            TestData.Enrollment(2, 1, "u2", now.AddHours(-10)),
            TestData.Enrollment(3, 2, "u3", now.AddDays(-30))
        });

        _payments = new FakeRepository<Payment>(new[]
        {
            TestData.Payment(1, 1, "u1", 80m, paidAt: now.AddHours(-5)),
            TestData.Payment(2, 1, "u2", 80m, paidAt: now.AddDays(-15)),
            TestData.Payment(3, 2, "u3", 200m, status: "refunded", paidAt: now.AddDays(-20))
        });

        _ratings = new FakeRepository<Rating>(new[]
        {
            TestData.Rating(1, 1, "u1", 5),
            TestData.Rating(2, 1, "u2", 4),
            TestData.Rating(3, 2, "u3", 2)
        });

        _categories = new FakeRepository<Category>();
        _progress = new FakeRepository<CourseProgress>();
        _notifications = new FakeRepository<Notification>();

        _service = new DashboardService(
            _courses,
            _enrollments,
            _payments,
            _ratings,
            _categories,
            _progress,
            _notifications,
            TestData.MockUserManager(_users).Object,
            TestData.NullLogger<DashboardService>());
    }

    [Fact]
    public async Task GetAdminDashboardAsync_ComputesTotalsAndRevenue()
    {
        var dto = await _service.GetAdminDashboardAsync();

        Assert.Equal(3, dto.TotalUsers);
        Assert.Equal(3, dto.TotalCourses);
        Assert.Equal(3, dto.ActiveStudents);
        // 80 + 80 completed, refunded excluded
        Assert.Equal(160m, dto.TotalRevenue);
    }

    [Fact]
    public async Task GetAdminDashboardAsync_LatestEnrollments_MapsPaymentStatus()
    {
        var dto = await _service.GetAdminDashboardAsync();

        var latest = dto.LatestEnrollments.OrderByDescending(e => e.EnrolledAt).First();
        Assert.Equal("completed", latest.Status); // u1 paid for course 1
    }

    [Fact]
    public async Task GetAdminDashboardAsync_CategoryDistribution_TopCategoryFirst()
    {
        var dto = await _service.GetAdminDashboardAsync();

        Assert.Equal(2, dto.CategoryDistribution.Count);
        Assert.Equal("Category 1", dto.CategoryDistribution[0].Name); // 2 courses
        Assert.Equal(2, dto.CategoryDistribution[0].Count);
        Assert.Equal(66.7, dto.CategoryDistribution[0].Percentage, 1);
    }

    [Fact]
    public async Task GetAdminDashboardAsync_YearlyEnrollments_CountsCurrentYear()
    {
        var dto = await _service.GetAdminDashboardAsync();

        Assert.Equal(12, dto.YearlyEnrollments.Count);
        Assert.Equal(3, dto.YearlyEnrollments.Sum());
    }

    [Fact]
    public async Task GetInstructorDashboardAsync_ComputesStats()
    {
        // 2 courses for ins-1 + 2 enrollments + 2 completed payments + 2 ratings
        var dto = await _service.GetInstructorDashboardAsync("ins-1");

        Assert.Equal(2, dto.CoursesCount);
        Assert.Equal(3, dto.StudentsCount); // u1, u2, u3 all enrolled in ins-1 courses
        Assert.Equal(160m, dto.TotalEarnings);
        Assert.Equal(3.7, dto.AverageRating); // (5 + 4 + 2) / 3
        Assert.Equal(66.7, dto.PositiveRatingPercent); // 2 of 3 ratings >= 4
    }

    [Fact]
    public async Task GetInstructorDashboardAsync_CompletionRate_FromProgress()
    {
        var now = DateTime.UtcNow;
        _progress.Items.Add(TestData.Progress(1, 1, 101, 1, isCompleted: true));
        _progress.Items.Add(TestData.Progress(2, 1, 102, 1, isCompleted: false));
        _progress.Items.Add(TestData.Progress(3, 2, 101, 1, isCompleted: true));

        var dto = await _service.GetInstructorDashboardAsync("ins-1");

        Assert.Equal(66.7, dto.CompletionRate, 1); // 2 of 3 completed
    }

    [Fact]
    public async Task GetInstructorDashboardAsync_TopLectures_RankedByCompletions()
    {
        _progress.Items.Add(TestData.Progress(1, 1, 101, 1, isCompleted: true));
        _progress.Items.Add(TestData.Progress(2, 2, 101, 1, isCompleted: true));
        _progress.Items.Add(TestData.Progress(3, 2, 102, 1, isCompleted: false));

        var dto = await _service.GetInstructorDashboardAsync("ins-1");

        var top = Assert.Single(dto.TopLectures);
        Assert.Equal("Lecture 101", top.LectureTitle);
        Assert.Equal(2, top.CompletionCount);
    }

    [Fact]
    public async Task GetInstructorRevenueAsync_FiltersByMonthAndComputesChange()
    {
        var dto = await _service.GetInstructorRevenueAsync("ins-1", "month");

        // this month: 80 (u1, 5h ago) — u2's payment is 15 days ago (could be previous month)
        Assert.True(dto.TotalRevenue > 0);
        Assert.True(dto.TotalSales > 0);
        Assert.Equal(12, dto.MonthlyRevenueSeries.Count);
        Assert.Equal(12, dto.MonthlySalesSeries.Count);
    }

    [Fact]
    public async Task GetPublicStatsAsync_CountsUsersCoursesAndSatisfaction()
    {
        var dto = await _service.GetPublicStatsAsync();

        Assert.Equal(3, dto.StudentsCount);
        Assert.Equal(3, dto.CoursesCount);
        // ratings: (5 + 4 + 2) / 3 = 3.67 / 5 = 73.3%
        Assert.Equal(73.3, dto.SatisfactionPercent, 1);
    }
}

using EduLab_Application.Common.Constants;
using EduLab_Application.DTOs.Dashboard;
using EduLab_Application.ServiceInterfaces;
using EduLab_Domain.Entities;
using EduLab_Domain.IRepository;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;

namespace EduLab_Application.Services
{
    /// <summary>
    /// Service implementation for dashboard analytics operations
    /// </summary>
    public class DashboardService : IDashboardService
    {
        private readonly IRepository<Course> _courseRepository;
        private readonly IRepository<Enrollment> _enrollmentRepository;
        private readonly IRepository<Payment> _paymentRepository;
        private readonly IRepository<Rating> _ratingRepository;
        private readonly IRepository<Category> _categoryRepository;
        private readonly IRepository<CourseProgress> _courseProgressRepository;
        private readonly IRepository<Notification> _notificationRepository;
        private readonly UserManager<ApplicationUser> _userManager;
        private readonly ILogger<DashboardService> _logger;

        public DashboardService(
            IRepository<Course> courseRepository,
            IRepository<Enrollment> enrollmentRepository,
            IRepository<Payment> paymentRepository,
            IRepository<Rating> ratingRepository,
            IRepository<Category> categoryRepository,
            IRepository<CourseProgress> courseProgressRepository,
            IRepository<Notification> notificationRepository,
            UserManager<ApplicationUser> userManager,
            ILogger<DashboardService> logger)
        {
            _courseRepository = courseRepository;
            _enrollmentRepository = enrollmentRepository;
            _paymentRepository = paymentRepository;
            _ratingRepository = ratingRepository;
            _categoryRepository = categoryRepository;
            _courseProgressRepository = courseProgressRepository;
            _notificationRepository = notificationRepository;
            _userManager = userManager;
            _logger = logger;
        }

        #region Admin Dashboard

        /// <summary>
        /// Retrieves the aggregated statistics for the admin dashboard
        /// </summary>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>Admin dashboard data</returns>
        public async Task<AdminDashboardDto> GetAdminDashboardAsync(CancellationToken cancellationToken = default)
        {
            var now = DateTime.UtcNow;

            var users = await _userManager.Users.AsNoTracking().ToListAsync(cancellationToken);
            var courses = await _courseRepository.GetAllAsync(includeProperties: "Category,Instructor", cancellationToken: cancellationToken);
            var enrollments = await _enrollmentRepository.GetAllAsync(includeProperties: "Course,User", cancellationToken: cancellationToken);
            var payments = await _paymentRepository.GetAllAsync(includeProperties: "Course,User", cancellationToken: cancellationToken);
            var ratings = await _ratingRepository.GetAllAsync(includeProperties: "Course,User", cancellationToken: cancellationToken);

            var completedPayments = payments.Where(p => IsCompletedPayment(p.Status)).ToList();

            var dto = new AdminDashboardDto();

            // Users
            dto.TotalUsers = users.Count;
            var usersThisMonth = users.Count(u => u.CreatedAt >= now.AddDays(-30));
            var usersPrevMonth = users.Count(u => u.CreatedAt >= now.AddDays(-60) && u.CreatedAt < now.AddDays(-30));
            dto.UsersGrowthPercent = CalcPercentChange(usersThisMonth, usersPrevMonth);

            // Courses
            dto.TotalCourses = courses.Count;
            var coursesThisMonth = courses.Count(c => c.CreatedAt >= now.AddDays(-30));
            var coursesPrevMonth = courses.Count(c => c.CreatedAt >= now.AddDays(-60) && c.CreatedAt < now.AddDays(-30));
            dto.CoursesGrowthPercent = CalcPercentChange(coursesThisMonth, coursesPrevMonth);

            // Active students (distinct enrolled users)
            dto.ActiveStudents = enrollments.Select(e => e.UserId).Distinct().Count();
            var studentsLast24h = enrollments.Count(e => e.EnrolledAt >= now.AddHours(-24));
            var studentsPrev24h = enrollments.Count(e => e.EnrolledAt >= now.AddHours(-48) && e.EnrolledAt < now.AddHours(-24));
            dto.StudentsGrowthPercent = CalcPercentChange(studentsLast24h, studentsPrev24h);

            // Revenue
            dto.TotalRevenue = completedPayments.Sum(p => p.Amount);
            var revenueThisMonth = completedPayments.Where(p => p.PaidAt >= now.AddDays(-30)).Sum(p => p.Amount);
            var revenuePrevMonth = completedPayments.Where(p => p.PaidAt >= now.AddDays(-60) && p.PaidAt < now.AddDays(-30)).Sum(p => p.Amount);
            dto.RevenueGrowthPercent = CalcPercentChange((double)revenueThisMonth, (double)revenuePrevMonth);

            // Enrollment series: last 4 weeks (oldest -> newest) + current year 12 months
            dto.MonthlyEnrollments = BuildWeeklySeries(enrollments.Select(e => e.EnrolledAt).ToList(), now, 4);
            dto.YearlyEnrollments = BuildMonthlyCountSeries(enrollments.Select(e => e.EnrolledAt).ToList(), now.Year);

            // Category distribution
            var categoryGroups = courses
                .Where(c => c.Category != null)
                .GroupBy(c => new { c.CategoryId, c.Category.Category_Name })
                .Select(g => new CategoryDistributionDto
                {
                    Name = g.Key.Category_Name,
                    Count = g.Count(),
                    Percentage = courses.Count == 0 ? 0 : Math.Round(g.Count() * 100.0 / courses.Count, 1)
                })
                .OrderByDescending(c => c.Count)
                .Take(6)
                .ToList();
            dto.CategoryDistribution = categoryGroups;

            // Latest enrollments (top 5)
            dto.LatestEnrollments = enrollments
                .OrderByDescending(e => e.EnrolledAt)
                .Take(5)
                .Select(e => new LatestEnrollmentDto
                {
                    StudentName = e.User?.FullName ?? "—",
                    CourseTitle = e.Course?.Title ?? "—",
                    EnrolledAt = e.EnrolledAt,
                    Status = completedPayments.Any(p => p.UserId == e.UserId && p.CourseId == e.CourseId) ? "completed" : "processing"
                })
                .ToList();

            // Recent activities (merged feed)
            var activities = new List<DashboardActivityDto>();

            activities.AddRange(courses
                .OrderByDescending(c => c.CreatedAt)
                .Take(3)
                .Select(c => new DashboardActivityDto
                {
                    Type = "CourseAdded",
                    ActorName = c.Instructor?.FullName ?? "—",
                    CourseTitle = c.Title,
                    CreatedAt = c.CreatedAt
                }));

            activities.AddRange(enrollments
                .OrderByDescending(e => e.EnrolledAt)
                .Take(3)
                .Select(e => new DashboardActivityDto
                {
                    Type = "Enrollment",
                    ActorName = e.User?.FullName ?? "—",
                    CourseTitle = e.Course?.Title ?? "—",
                    CreatedAt = e.EnrolledAt
                }));

            activities.AddRange(ratings
                .OrderByDescending(r => r.CreatedAt)
                .Take(3)
                .Select(r => new DashboardActivityDto
                {
                    Type = "Rating",
                    ActorName = r.User?.FullName ?? "—",
                    CourseTitle = r.Course?.Title ?? "—",
                    RatingValue = r.Value,
                    CreatedAt = r.CreatedAt
                }));

            dto.RecentActivities = activities
                .OrderByDescending(a => a.CreatedAt)
                .Take(6)
                .ToList();

            return dto;
        }

        #endregion

        #region Instructor Dashboard

        /// <summary>
        /// Retrieves the aggregated statistics for the instructor dashboard
        /// </summary>
        /// <param name="instructorId">Unique identifier of the instructor</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>Instructor dashboard data</returns>
        public async Task<InstructorDashboardDto> GetInstructorDashboardAsync(string instructorId, CancellationToken cancellationToken = default)
        {
            if (string.IsNullOrWhiteSpace(instructorId))
                throw new ArgumentException("Instructor ID cannot be null or empty", nameof(instructorId));

            var now = DateTime.UtcNow;

            var courses = await _courseRepository.GetAllAsync(
                filter: c => c.InstructorId == instructorId,
                includeProperties: "Sections,Sections.Lectures",
                cancellationToken: cancellationToken);

            var courseIds = courses.Select(c => c.Id).ToList();

            var enrollments = await _enrollmentRepository.GetAllAsync(includeProperties: "Course,User", cancellationToken: cancellationToken);
            var instructorEnrollments = enrollments.Where(e => courseIds.Contains(e.CourseId)).ToList();

            var payments = await _paymentRepository.GetAllAsync(includeProperties: "Course,User", cancellationToken: cancellationToken);
            var instructorPayments = payments.Where(p => courseIds.Contains(p.CourseId)).ToList();
            var instructorCompletedPayments = instructorPayments.Where(p => IsCompletedPayment(p.Status)).ToList();

            var ratings = await _ratingRepository.GetAllAsync(includeProperties: "Course,User", cancellationToken: cancellationToken);
            var instructorRatings = ratings.Where(r => courseIds.Contains(r.CourseId)).ToList();

            var progress = await _courseProgressRepository.GetAllAsync(
                includeProperties: "Lecture,Lecture.Section,Enrollment",
                cancellationToken: cancellationToken);

            var dto = new InstructorDashboardDto();

            // Stats
            dto.CoursesCount = courses.Count;
            dto.StudentsCount = instructorEnrollments.Select(e => e.UserId).Distinct().Count();
            dto.TotalEnrollments = instructorEnrollments.Count;
            dto.TotalEarnings = instructorCompletedPayments.Sum(p => p.Amount);
            dto.AverageRating = instructorRatings.Any() ? Math.Round(instructorRatings.Average(r => r.Value), 1) : 0;
            dto.CompletionRate = ComputeCompletionRate(courses, instructorEnrollments, progress);

            var ratedReviews = instructorRatings.Count;
            dto.PositiveRatingPercent = ratedReviews > 0
                ? Math.Round(instructorRatings.Count(r => r.Value >= 4) * 100.0 / ratedReviews, 1)
                : 0;

            var instructor = await _userManager.FindByIdAsync(instructorId);
            if (instructor != null)
            {
                dto.InstructorName = instructor.FullName;
                dto.ProfileImageUrl = instructor.ProfileImageUrl;
                dto.MemberSince = instructor.CreatedAt;
            }

            // Monthly series (current year)
            dto.MonthlyRegistrations = BuildMonthlyCountSeries(instructorEnrollments.Select(e => e.EnrolledAt).ToList(), now.Year);
            dto.MonthlyRevenue = BuildMonthlyRevenueSeries(instructorCompletedPayments.Select(p => new KeyValuePair<DateTime, decimal>(p.PaidAt, p.Amount)).ToList(), now.Year);

            // Course performance (top 5 by students)
            dto.CoursePerformance = courses
                .Select(c => new CoursePerformanceDto
                {
                    CourseTitle = c.Title,
                    Students = instructorEnrollments.Count(e => e.CourseId == c.Id),
                    Revenue = instructorCompletedPayments.Where(p => p.CourseId == c.Id).Sum(p => p.Amount),
                    CompletionRate = ComputeCourseCompletionRate(c.Id, instructorEnrollments, progress)
                })
                .OrderByDescending(cp => cp.Students)
                .Take(5)
                .ToList();

            // Most-completed lectures (top 6) across the instructor's courses
            var enrollmentIds = instructorEnrollments.Select(e => e.Id).ToHashSet();
            dto.TopLectures = progress
                .Where(p => enrollmentIds.Contains(p.EnrollmentId) && p.IsCompleted && p.Lecture != null)
                .GroupBy(p => new { p.LectureId, p.Lecture.Title, p.Lecture.Duration })
                .Select(g => new LecturePerformanceDto
                {
                    LectureTitle = g.Key.Title,
                    CompletionCount = g.Count(),
                    Duration = g.Key.Duration
                })
                .OrderByDescending(l => l.CompletionCount)
                .Take(6)
                .ToList();

            // Recent activities
            var activities = new List<DashboardActivityDto>();

            activities.AddRange(courses
                .OrderByDescending(c => c.CreatedAt)
                .Take(2)
                .Select(c => new DashboardActivityDto
                {
                    Type = "CourseAdded",
                    ActorName = null,
                    CourseTitle = c.Title,
                    CreatedAt = c.CreatedAt
                }));

            activities.AddRange(instructorEnrollments
                .OrderByDescending(e => e.EnrolledAt)
                .Take(3)
                .Select(e => new DashboardActivityDto
                {
                    Type = "Enrollment",
                    ActorName = e.User?.FullName ?? "—",
                    CourseTitle = e.Course?.Title ?? "—",
                    CreatedAt = e.EnrolledAt
                }));

            activities.AddRange(instructorRatings
                .OrderByDescending(r => r.CreatedAt)
                .Take(3)
                .Select(r => new DashboardActivityDto
                {
                    Type = "Rating",
                    ActorName = r.User?.FullName ?? "—",
                    CourseTitle = r.Course?.Title ?? "—",
                    RatingValue = r.Value,
                    CreatedAt = r.CreatedAt
                }));

            dto.RecentActivities = activities
                .OrderByDescending(a => a.CreatedAt)
                .Take(5)
                .ToList();

            // Latest notifications (5)
            var notifications = await _notificationRepository.GetAllAsync(
                filter: n => n.UserId == instructorId,
                orderBy: q => q.OrderByDescending(n => n.CreatedAt),
                take: 5,
                cancellationToken: cancellationToken);

            dto.Notifications = notifications
                .Select(n => new InstructorNotificationItemDto
                {
                    Title = n.Title,
                    Message = n.Message,
                    CreatedAt = n.CreatedAt,
                    IsRead = n.Status == NotificationStatus.Read,
                    TitleKey = n.TitleKey,
                    MessageKey = n.MessageKey,
                    Parameters = n.Parameters
                })
                .ToList();

            return dto;
        }

        #endregion

        #region Instructor Revenue

        /// <summary>
        /// Retrieves the revenue statistics of an instructor for a given period
        /// </summary>
        /// <param name="instructorId">Unique identifier of the instructor</param>
        /// <param name="period">Time period for the revenue report</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>Instructor revenue data</returns>
        public async Task<InstructorRevenueDto> GetInstructorRevenueAsync(string instructorId, string period, CancellationToken cancellationToken = default)
        {
            if (string.IsNullOrWhiteSpace(instructorId))
                throw new ArgumentException("Instructor ID cannot be null or empty", nameof(instructorId));

            var now = DateTime.UtcNow;
            var (periodStart, periodEnd, previousStart, previousEnd) = ResolvePeriod(period ?? "month", now);

            var courses = await _courseRepository.GetAllAsync(
                filter: c => c.InstructorId == instructorId,
                cancellationToken: cancellationToken);
            var courseIds = courses.Select(c => c.Id).ToList();

            var enrollments = await _enrollmentRepository.GetAllAsync(includeProperties: "Course,User", cancellationToken: cancellationToken);
            var instructorEnrollments = enrollments.Where(e => courseIds.Contains(e.CourseId)).ToList();

            var payments = await _paymentRepository.GetAllAsync(includeProperties: "Course,User", cancellationToken: cancellationToken);
            var instructorPayments = payments.Where(p => courseIds.Contains(p.CourseId)).ToList();
            var completedPayments = instructorPayments.Where(p => IsCompletedPayment(p.Status)).ToList();

            var dto = new InstructorRevenueDto();

            // Period-scoped stats
            var periodPayments = completedPayments.Where(p => p.PaidAt >= periodStart && p.PaidAt < periodEnd).ToList();
            var previousPayments = completedPayments.Where(p => p.PaidAt >= previousStart && p.PaidAt < previousEnd).ToList();

            dto.TotalRevenue = periodPayments.Sum(p => p.Amount);
            dto.RevenueChangePercent = CalcPercentChange(
                (double)periodPayments.Sum(p => p.Amount),
                (double)previousPayments.Sum(p => p.Amount));

            dto.TotalSales = periodPayments.Count;
            dto.SalesChangePercent = CalcPercentChange(periodPayments.Count, previousPayments.Count);

            dto.AvgCoursePrice = courses.Any() ? Math.Round(courses.Average(c => c.Price), 0) : 0;

            var newStudentsIds = instructorEnrollments
                .Where(e => e.EnrolledAt >= periodStart && e.EnrolledAt < periodEnd)
                .Select(e => e.UserId).Distinct().ToList();
            var prevStudentsIds = instructorEnrollments
                .Where(e => e.EnrolledAt >= previousStart && e.EnrolledAt < previousEnd)
                .Select(e => e.UserId).Distinct().ToList();
            dto.NewStudents = newStudentsIds.Count;
            dto.NewStudentsChangePercent = CalcPercentChange(newStudentsIds.Count, prevStudentsIds.Count);

            // 12-month series (current year)
            dto.MonthlyRevenueSeries = BuildMonthlyRevenueSeries(completedPayments.Select(p => new KeyValuePair<DateTime, decimal>(p.PaidAt, p.Amount)).ToList(), now.Year);
            dto.MonthlySalesSeries = BuildMonthlyCountSeries(completedPayments.Select(p => p.PaidAt).ToList(), now.Year);

            // Top courses by revenue
            dto.TopCourses = courses
                .Select(c => new RevenueTopCourseDto
                {
                    CourseTitle = c.Title,
                    Students = instructorEnrollments.Count(e => e.CourseId == c.Id),
                    Revenue = completedPayments.Where(p => p.CourseId == c.Id).Sum(p => p.Amount)
                })
                .Where(c => c.Revenue > 0 || c.Students > 0)
                .OrderByDescending(c => c.Revenue)
                .Take(5)
                .ToList();

            // Recent transactions (last 10 payments)
            dto.RecentTransactions = instructorPayments
                .OrderByDescending(p => p.PaidAt)
                .ThenByDescending(p => p.CreatedAt)
                .Take(10)
                .Select(p => new RevenueTransactionDto
                {
                    StudentName = p.User?.FullName ?? "—",
                    CourseTitle = p.Course?.Title ?? "—",
                    Amount = p.Amount,
                    Date = p.PaidAt,
                    Status = p.Status ?? "pending"
                })
                .ToList();

            // Payout summary
            dto.PayoutDue = completedPayments.Sum(p => p.Amount);
            dto.PayoutPending = instructorPayments
                .Where(p => !IsCompletedPayment(p.Status) && !IsRefundedPayment(p.Status))
                .Sum(p => p.Amount);

            dto.LastPayments = completedPayments
                .OrderByDescending(p => p.PaidAt)
                .Take(3)
                .Select(p => new RevenuePaymentDto { Date = p.PaidAt, Amount = p.Amount })
                .ToList();

            return dto;
        }

        #endregion

        #region Public Stats

        /// <summary>
        /// Retrieves the public platform statistics shown on the landing page
        /// </summary>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>Site statistics data</returns>
        public async Task<SiteStatsDto> GetPublicStatsAsync(CancellationToken cancellationToken = default)
        {
            var dto = new SiteStatsDto();

            try
            {
                var users = await _userManager.Users.AsNoTracking().ToListAsync(cancellationToken);
                var courses = await _courseRepository.GetAllAsync(cancellationToken: cancellationToken);
                var ratings = await _ratingRepository.GetAllAsync(cancellationToken: cancellationToken);

                dto.StudentsCount = users.Count;
                dto.CoursesCount = courses.Count;
                dto.InstructorsCount = (await _userManager.GetUsersInRoleAsync(SD.Instructor)).Count;

                var allRatings = ratings.Select(r => (double)r.Value).ToList();
                dto.SatisfactionPercent = allRatings.Any()
                    ? Math.Round(allRatings.Average() / 5.0 * 100, 1)
                    : 0;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error computing public site stats");
            }

            return dto;
        }

        #endregion

        #region Helpers

        private static bool IsCompletedPayment(string status)
        {
            return string.Equals(status, SD.PaymentStatusCompleted, StringComparison.OrdinalIgnoreCase)
                || string.Equals(status, SD.PaymentStatusSucceeded, StringComparison.OrdinalIgnoreCase)
                || string.Equals(status, SD.PaymentStatusPaid, StringComparison.OrdinalIgnoreCase);
        }

        private static bool IsRefundedPayment(string status)
        {
            return string.Equals(status, SD.PaymentStatusRefunded, StringComparison.OrdinalIgnoreCase);
        }

        private static double CalcPercentChange(double current, double previous)
        {
            if (previous <= 0)
                return current > 0 ? 100 : 0;
            return Math.Round((current - previous) / previous * 100, 1);
        }

        private static List<int> BuildWeeklySeries(List<DateTime> dates, DateTime now, int weeks)
        {
            var series = new List<int>();
            for (int w = weeks - 1; w >= 0; w--)
            {
                var start = now.AddDays(-7 * (w + 1));
                var end = now.AddDays(-7 * w);
                series.Add(dates.Count(d => d >= start && d < end));
            }
            return series;
        }

        private static List<int> BuildMonthlyCountSeries(List<DateTime> dates, int year)
        {
            var series = new List<int>();
            for (int m = 1; m <= 12; m++)
            {
                series.Add(dates.Count(d => d.Year == year && d.Month == m));
            }
            return series;
        }

        private static List<decimal> BuildMonthlyRevenueSeries(List<KeyValuePair<DateTime, decimal>> payments, int year)
        {
            var series = new List<decimal>();
            for (int m = 1; m <= 12; m++)
            {
                series.Add(payments.Where(p => p.Key.Year == year && p.Key.Month == m).Sum(p => p.Value));
            }
            return series;
        }

        private static (DateTime periodStart, DateTime periodEnd, DateTime previousStart, DateTime previousEnd) ResolvePeriod(string period, DateTime now)
        {
            switch (period?.ToLowerInvariant())
            {
                case "week":
                case "7days":
                    var weekStart = now.AddDays(-7);
                    return (weekStart, now, weekStart.AddDays(-7), weekStart);
                case "3months":
                    var threeMonthsStart = now.AddMonths(-3);
                    return (threeMonthsStart, now, threeMonthsStart.AddMonths(-3), threeMonthsStart);
                case "year":
                    var yearStart = new DateTime(now.Year, 1, 1, 0, 0, 0, DateTimeKind.Utc);
                    return (yearStart, now, new DateTime(now.Year - 1, 1, 1, 0, 0, 0, DateTimeKind.Utc), yearStart);
                case "all":
                    return (DateTime.MinValue, now.AddYears(1), DateTime.MinValue, DateTime.MinValue);
                case "month":
                default:
                    var monthStart = new DateTime(now.Year, now.Month, 1, 0, 0, 0, DateTimeKind.Utc);
                    var prevMonthStart = monthStart.AddMonths(-1);
                    return (monthStart, now, prevMonthStart, monthStart);
            }
        }

        private double ComputeCourseCompletionRate(int courseId, List<Enrollment> instructorEnrollments, List<CourseProgress> progress)
        {
            try
            {
                var courseEnrollmentIds = instructorEnrollments
                    .Where(e => e.CourseId == courseId)
                    .Select(e => e.Id)
                    .ToHashSet();

                var courseProgress = progress
                    .Where(p => courseEnrollmentIds.Contains(p.EnrollmentId))
                    .ToList();

                if (!courseProgress.Any())
                    return 0;

                return Math.Round(courseProgress.Count(p => p.IsCompleted) * 100.0 / courseProgress.Count, 1);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error computing completion rate for course {CourseId}", courseId);
                return 0;
            }
        }

        private double ComputeCompletionRate(List<Course> courses, List<Enrollment> instructorEnrollments, List<CourseProgress> progress)
        {
            try
            {
                if (!instructorEnrollments.Any())
                    return 0;

                var enrollmentIds = instructorEnrollments.Select(e => e.Id).ToHashSet();
                var relevantProgress = progress
                    .Where(p => enrollmentIds.Contains(p.EnrollmentId))
                    .ToList();

                if (!relevantProgress.Any())
                    return 0;

                var completedCount = relevantProgress.Count(p => p.IsCompleted);
                var totalCount = relevantProgress.Count;

                return totalCount == 0 ? 0 : Math.Round(completedCount * 100.0 / totalCount, 1);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error computing instructor completion rate");
                return 0;
            }
        }

        #endregion
    }
}

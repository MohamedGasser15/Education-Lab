using System;
using System.Collections.Generic;

namespace EduLab_MVC.Models.DTOs.Dashboard
{
    public class SiteStatsDto
    {
        public int StudentsCount { get; set; }
        public int CoursesCount { get; set; }
        public int InstructorsCount { get; set; }
        public double SatisfactionPercent { get; set; }
    }

    public class DashboardActivityDto
    {
        public string Type { get; set; }
        public string ActorName { get; set; }
        public string CourseTitle { get; set; }
        public int? RatingValue { get; set; }
        public DateTime CreatedAt { get; set; }
    }

    public class LatestEnrollmentDto
    {
        public string StudentName { get; set; }
        public string CourseTitle { get; set; }
        public DateTime EnrolledAt { get; set; }
        public string Status { get; set; }
    }

    public class CategoryDistributionDto
    {
        public string Name { get; set; }
        public int Count { get; set; }
        public double Percentage { get; set; }
    }

    public class AdminDashboardDto
    {
        public int TotalUsers { get; set; }
        public double UsersGrowthPercent { get; set; }

        public int TotalCourses { get; set; }
        public double CoursesGrowthPercent { get; set; }

        public int ActiveStudents { get; set; }
        public double StudentsGrowthPercent { get; set; }

        public decimal TotalRevenue { get; set; }
        public double RevenueGrowthPercent { get; set; }

        public List<int> MonthlyEnrollments { get; set; } = new List<int>();
        public List<int> YearlyEnrollments { get; set; } = new List<int>();

        public List<CategoryDistributionDto> CategoryDistribution { get; set; } = new List<CategoryDistributionDto>();

        public List<LatestEnrollmentDto> LatestEnrollments { get; set; } = new List<LatestEnrollmentDto>();

        public List<DashboardActivityDto> RecentActivities { get; set; } = new List<DashboardActivityDto>();
    }

    public class CoursePerformanceDto
    {
        public string CourseTitle { get; set; }
        public int Students { get; set; }
        public decimal Revenue { get; set; }
        public double CompletionRate { get; set; }
    }

    public class LecturePerformanceDto
    {
        public string LectureTitle { get; set; }
        public int CompletionCount { get; set; }
        public int Duration { get; set; }
    }

    public class InstructorNotificationItemDto
    {
        public string Title { get; set; }
        public string Message { get; set; }
        public DateTime CreatedAt { get; set; }
        public bool IsRead { get; set; }
        public string? TitleKey { get; set; }
        public string? MessageKey { get; set; }
        public string? Parameters { get; set; }
    }

    public class InstructorDashboardDto
    {
        public int CoursesCount { get; set; }
        public int StudentsCount { get; set; }
        public int TotalEnrollments { get; set; }
        public decimal TotalEarnings { get; set; }
        public double CompletionRate { get; set; }
        public double AverageRating { get; set; }
        public double PositiveRatingPercent { get; set; }

        public string? InstructorName { get; set; }
        public string? ProfileImageUrl { get; set; }
        public DateTime? MemberSince { get; set; }

        public List<int> MonthlyRegistrations { get; set; } = new List<int>();
        public List<decimal> MonthlyRevenue { get; set; } = new List<decimal>();

        public List<CoursePerformanceDto> CoursePerformance { get; set; } = new List<CoursePerformanceDto>();

        public List<LecturePerformanceDto> TopLectures { get; set; } = new List<LecturePerformanceDto>();

        public List<DashboardActivityDto> RecentActivities { get; set; } = new List<DashboardActivityDto>();

        public List<InstructorNotificationItemDto> Notifications { get; set; } = new List<InstructorNotificationItemDto>();
    }

    public class RevenueTransactionDto
    {
        public string StudentName { get; set; }
        public string CourseTitle { get; set; }
        public decimal Amount { get; set; }
        public DateTime Date { get; set; }
        public string Status { get; set; }
    }

    public class RevenueTopCourseDto
    {
        public string CourseTitle { get; set; }
        public int Students { get; set; }
        public decimal Revenue { get; set; }
    }

    public class RevenuePaymentDto
    {
        public DateTime Date { get; set; }
        public decimal Amount { get; set; }
    }

    public class InstructorRevenueDto
    {
        public decimal TotalRevenue { get; set; }
        public double RevenueChangePercent { get; set; }

        public int TotalSales { get; set; }
        public double SalesChangePercent { get; set; }

        public decimal AvgCoursePrice { get; set; }

        public int NewStudents { get; set; }
        public double NewStudentsChangePercent { get; set; }

        public List<decimal> MonthlyRevenueSeries { get; set; } = new List<decimal>();
        public List<int> MonthlySalesSeries { get; set; } = new List<int>();

        public List<RevenueTopCourseDto> TopCourses { get; set; } = new List<RevenueTopCourseDto>();

        public List<RevenueTransactionDto> RecentTransactions { get; set; } = new List<RevenueTransactionDto>();

        public decimal PayoutDue { get; set; }
        public decimal PayoutPending { get; set; }
        public List<RevenuePaymentDto> LastPayments { get; set; } = new List<RevenuePaymentDto>();
    }
}

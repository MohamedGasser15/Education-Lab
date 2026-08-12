using System;
using System.Collections.Generic;

namespace EduLab_Application.DTOs.Dashboard
{
    public class CoursePerformanceDto
    {
        public string CourseTitle { get; set; }
        public int Students { get; set; }
        public decimal Revenue { get; set; }
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
        public decimal TotalEarnings { get; set; }
        public double CompletionRate { get; set; }
        public double AverageRating { get; set; }

        public List<int> MonthlyRegistrations { get; set; } = new List<int>();
        public List<decimal> MonthlyRevenue { get; set; } = new List<decimal>();

        public List<CoursePerformanceDto> CoursePerformance { get; set; } = new List<CoursePerformanceDto>();

        public List<DashboardActivityDto> RecentActivities { get; set; } = new List<DashboardActivityDto>();

        public List<InstructorNotificationItemDto> Notifications { get; set; } = new List<InstructorNotificationItemDto>();
    }
}

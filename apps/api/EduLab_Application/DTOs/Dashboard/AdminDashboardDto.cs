using System;
using System.Collections.Generic;

namespace EduLab_Application.DTOs.Dashboard
{
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
}

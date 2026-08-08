using System;
using System.Collections.Generic;

namespace EduLab_Application.DTOs.Rating
{
    public class InstructorRatingsOverviewDTO
    {
        public InstructorRatingsStatsDTO Stats { get; set; } = new();
        public List<InstructorRatingCourseDTO> Courses { get; set; } = new();
        public List<InstructorRatingItemDTO> Reviews { get; set; } = new();
    }

    public class InstructorRatingsStatsDTO
    {
        public int TotalReviews { get; set; }
        public double AverageRating { get; set; }
        public int ThisMonthReviews { get; set; }
        public int ReviewedCourses { get; set; }
        public Dictionary<int, int> Distribution { get; set; } = new()
        {
            { 1, 0 }, { 2, 0 }, { 3, 0 }, { 4, 0 }, { 5, 0 }
        };
    }

    public class InstructorRatingCourseDTO
    {
        public int CourseId { get; set; }
        public string CourseName { get; set; }
    }

    public class InstructorRatingItemDTO
    {
        public int Id { get; set; }
        public int CourseId { get; set; }
        public string CourseName { get; set; }
        public string StudentName { get; set; }
        public string? StudentAvatar { get; set; }
        public int Rating { get; set; }
        public string Comment { get; set; }
        public DateTime CreatedAt { get; set; }
        public string TimeAgo { get; set; }
    }
}

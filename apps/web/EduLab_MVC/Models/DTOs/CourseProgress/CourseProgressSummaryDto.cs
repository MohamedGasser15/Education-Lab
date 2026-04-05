using EduLab_MVC.Models.DTOs.Enrollment;

namespace EduLab_MVC.Models.DTOs.CourseProgress
{
    public class CourseProgressSummaryDto
    {
        public int EnrollmentId { get; set; }
        public int CourseId { get; set; }
        public string CourseTitle { get; set; }
        public int TotalLectures { get; set; }
        public int CompletedLectures { get; set; }
        public decimal ProgressPercentage { get; set; }
        public DateTime? LastActivity { get; set; }
        public int TotalDuration { get; set; }
        public int WatchedDuration { get; set; }
    }
}
using EduLab_MVC.Models.DTOs.Enrollment;

namespace EduLab_MVC.Models.DTOsCourseProgress
{
    public class CourseProgressDto
    {
        public int Id { get; set; }
        public int EnrollmentId { get; set; }
        public int LectureId { get; set; }
        public bool IsCompleted { get; set; }
        public DateTime? CompletedAt { get; set; }
        public string LectureTitle { get; set; }
        public int LectureDuration { get; set; }
        public int LectureOrder { get; set; }
        public string SectionTitle { get; set; }
    }

    public class UpdateCourseProgressDto
    {
        public int EnrollmentId { get; set; }
        public int LectureId { get; set; }
        public bool IsCompleted { get; set; }
    }

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

    public class EnrollmentProgressDto
    {
        public EnrollmentDto Enrollment { get; set; }
        public CourseProgressSummaryDto ProgressSummary { get; set; }
        public List<CourseProgressDto> ProgressDetails { get; set; }
    }

    public class CourseProgressResponse
    {
        public bool Success { get; set; }
        public string Message { get; set; }
        public CourseProgressDto Data { get; set; }
    }

    public class CourseProgressSummaryResponse
    {
        public bool Success { get; set; }
        public string Message { get; set; }
        public CourseProgressSummaryDto Data { get; set; }
    }

    public class LectureStatusResponse
    {
        public bool Success { get; set; }
        public bool IsCompleted { get; set; }
        public string Message { get; set; }
    }

    public class LectureProgressDto
    {
        public int LectureId { get; set; }
        public string LectureTitle { get; set; }
        public string SectionTitle { get; set; }
        public bool IsCompleted { get; set; }
        public DateTime? CompletedAt { get; set; }
        public int Duration { get; set; }
        public int Order { get; set; }
    }
}
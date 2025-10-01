// EduLab_Shared/DTOs/CourseProgress/CourseProgressDto.cs
using EduLab_Shared.DTOs.Enrollment;
using System;

namespace EduLab_Shared.DTOs.CourseProgress
{
    public class CourseProgressDto
    {
        public int Id { get; set; }
        public int EnrollmentId { get; set; }
        public int LectureId { get; set; }
        public bool IsCompleted { get; set; }
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
    public class MarkLectureCompletedRequest
    {
        public int CourseId { get; set; }
        public int LectureId { get; set; }
        public double WatchedDuration { get; set; }
        public double TotalDuration { get; set; }
    }
    public class CourseProgressSummaryDto
    {
        public int EnrollmentId { get; set; }
        public int CourseId { get; set; }
        public string CourseTitle { get; set; }
        public int TotalLectures { get; set; }
        public int CompletedLectures { get; set; }
        public decimal ProgressPercentage { get; set; }
        public int TotalDuration { get; set; }
        public int WatchedDuration { get; set; }
    }

    public class EnrollmentProgressDto
    {
        public EnrollmentDto Enrollment { get; set; }
        public CourseProgressSummaryDto ProgressSummary { get; set; }
        public List<CourseProgressDto> ProgressDetails { get; set; }
    }
}
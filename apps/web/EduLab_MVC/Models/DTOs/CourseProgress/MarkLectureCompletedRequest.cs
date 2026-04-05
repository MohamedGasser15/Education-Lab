// EduLab_MVC/Models/DTOs/CourseProgress/MarkLectureCompletedRequest.cs
namespace EduLab_MVC.Models.DTOs.CourseProgress
{
    public class MarkLectureCompletedRequest
    {
        public int CourseId { get; set; }
        public int LectureId { get; set; }
        public double WatchedDuration { get; set; }
        public double TotalDuration { get; set; }
    }
}
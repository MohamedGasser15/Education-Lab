namespace EduLab_MVC.Models.DTOs.CourseProgress
{
    /// <summary>
    /// Represents a lecture progress data transfer object.
    /// </summary>
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

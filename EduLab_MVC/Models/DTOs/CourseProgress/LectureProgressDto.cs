namespace EduLab_MVC.Models.DTOs.CourseProgress
{
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

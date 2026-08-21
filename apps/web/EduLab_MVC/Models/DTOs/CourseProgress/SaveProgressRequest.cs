namespace EduLab_MVC.Models.DTOs.CourseProgress
{
    /// <summary>
    /// Represents a save progress request.
    /// </summary>
    public class SaveProgressRequest
    {
        public int CourseId { get; set; }
        public int LectureId { get; set; }
        public bool IsCompleted { get; set; }
    }
}

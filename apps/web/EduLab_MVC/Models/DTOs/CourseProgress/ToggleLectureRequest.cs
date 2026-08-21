namespace EduLab_MVC.Models.DTOs.CourseProgress
{
    /// <summary>
    /// Represents a toggle lecture request.
    /// </summary>
    public class ToggleLectureRequest
    {
        public int CourseId { get; set; }
        public int LectureId { get; set; }
    }
}

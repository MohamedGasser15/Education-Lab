namespace EduLab_MVC.Models.DTOs.CourseProgress
{
    /// <summary>
    /// Represents a course progress summary response.
    /// </summary>
    public class CourseProgressSummaryResponse
    {
        public bool Success { get; set; }
        public string Message { get; set; }
        public CourseProgressSummaryDto Data { get; set; }
    }
}

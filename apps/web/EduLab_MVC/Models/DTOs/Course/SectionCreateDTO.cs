namespace EduLab_MVC.Models.DTOs.Course
{
    /// <summary>
    /// Represents a section create data transfer object.
    /// </summary>
    public class SectionCreateDTO
    {
        public string Title { get; set; }
        public int CourseId { get; set; }
        public bool IsFreePreview { get; set; }
    }
}

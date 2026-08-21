namespace EduLab_MVC.Models.DTOs.Course
{
    /// <summary>
    /// Represents a section update data transfer object.
    /// </summary>
    public class SectionUpdateDTO
    {
        public int Id { get; set; }
        public string Title { get; set; }
        public bool IsFreePreview { get; set; }
    }
}

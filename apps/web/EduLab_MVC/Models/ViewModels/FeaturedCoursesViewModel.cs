using EduLab_MVC.Models.DTOs.Course;

namespace EduLab_MVC.Models.ViewModels
{
    /// <summary>
    /// View model that supplies data for the featured courses view.
    /// </summary>
    public class FeaturedCoursesViewModel
    {
        public List<CourseDTO> Courses { get; set; } = new();
        public int Count { get; set; } = 8;
        public bool IsFeatured { get; set; } = true;
        public bool IsNew { get; set; } = false;
    }
}

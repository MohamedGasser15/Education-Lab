using EduLab_MVC.Models.DTOs.Certificates;
using EduLab_MVC.Models.DTOs.Enrollment;
using EduLab_MVC.Models.DTOs.Wishlist;
using System;
using System.Collections.Generic;

namespace EduLab_MVC.Models.ViewModels
{
    /// <summary>
    /// View model that supplies data for the my learning view.
    /// </summary>
    public class MyLearningViewModel
    {
        public List<EnrollmentDto> Enrollments { get; set; } = new();
        public List<WishlistItemDto> WishlistItems { get; set; } = new();
        public List<CertificateDto> Certificates { get; set; } = new();
        public List<int> CertificateEnrollmentIds { get; set; } = new();
        public Dictionary<int, decimal> CourseProgress { get; set; } = new();

        public int TotalCourses { get; set; }
        public int CompletedCourses { get; set; }
        public int InProgressCourses { get; set; }
        public int TotalHours { get; set; }

        public List<string> Categories { get; set; } = new();
        public List<string> Instructors { get; set; } = new();
    }
}

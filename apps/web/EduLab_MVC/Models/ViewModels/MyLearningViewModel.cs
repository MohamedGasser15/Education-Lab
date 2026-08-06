using EduLab_MVC.Models.DTOs.Enrollment;
using EduLab_MVC.Models.DTOs.Wishlist;
using System;
using System.Collections.Generic;

namespace EduLab_MVC.Models.ViewModels
{
    public class MyLearningViewModel
    {
        public List<EnrollmentDto> Enrollments { get; set; } = new();
        public List<WishlistItemDto> WishlistItems { get; set; } = new();
        public List<CertificateSeedDto> Certificates { get; set; } = new();
        public Dictionary<int, decimal> CourseProgress { get; set; } = new();

        public int TotalCourses { get; set; }
        public int CompletedCourses { get; set; }
        public int InProgressCourses { get; set; }
        public int TotalHours { get; set; }

        public List<string> Categories { get; set; } = new();
        public List<string> Instructors { get; set; } = new();
    }

    public class CertificateSeedDto
    {
        public string CourseTitle { get; set; }
        public string InstructorName { get; set; }
        public string DateEarned { get; set; }
        public string CredentialId { get; set; }
        public string Grade { get; set; }
        public int TotalHours { get; set; }
        public string ThumbnailUrl { get; set; }
    }
}

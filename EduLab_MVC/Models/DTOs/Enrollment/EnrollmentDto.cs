using System;
using System.Collections.Generic;

namespace EduLab_MVC.Models.DTOs.Enrollment
{
    public class EnrollmentDto
    {
        public int Id { get; set; }
        public int CourseId { get; set; }

        // Course Properties
        public string Title { get; set; }
        public string ShortDescription { get; set; }
        public string Description { get; set; }
        public string Status { get; set; }
        public decimal Price { get; set; }
        public decimal? Discount { get; set; }
        public string ThumbnailUrl { get; set; }
        public DateTime CreatedAt { get; set; }
        public string InstructorId { get; set; }
        public string InstructorName { get; set; }
        public string InstructorAbout { get; set; }
        public string InstructorTitle { get; set; }
        public List<string> InstructorSubjects { get; set; } = new List<string>();
        public string ProfileImageUrl { get; set; }
        public int CategoryId { get; set; }
        public string CategoryName { get; set; }
        public string Level { get; set; }
        public string Language { get; set; }
        public int Duration { get; set; }
        public int TotalLectures { get; set; }
        public bool HasCertificate { get; set; }
        public List<string> Requirements { get; set; } = new List<string>();
        public List<string> Learnings { get; set; } = new List<string>();
        public string TargetAudience { get; set; }

        public DateTime EnrolledAt { get; set; }
        public int ProgressPercentage { get; set; }

        public decimal FinalPrice => Price - (Price * (Discount ?? 0) / 100);
        public bool HasDiscount => Discount > 0;
    }
}
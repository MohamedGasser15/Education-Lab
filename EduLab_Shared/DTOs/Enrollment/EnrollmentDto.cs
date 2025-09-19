using System;

namespace EduLab_Shared.DTOs.Enrollment
{
    public class EnrollmentDto
    {
        public int Id { get; set; }
        public int CourseId { get; set; }
        public string CourseTitle { get; set; }
        public string CourseDescription { get; set; }
        public string CourseThumbnailUrl { get; set; }
        public string InstructorName { get; set; }
        public DateTime EnrolledAt { get; set; }
        public decimal CoursePrice { get; set; }
        public string CourseLevel { get; set; }
        public int CourseDuration { get; set; }
        public int ProgressPercentage { get; set; }
        public bool HasCertificate { get; set; }
    }
}
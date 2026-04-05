using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_MVC.Models.DTOs.Student
{
    public class StudentEnrollmentDto
    {
        public int EnrollmentId { get; set; }
        public int CourseId { get; set; }
        public string CourseTitle { get; set; }
        public string CourseThumbnailUrl { get; set; }
        public DateTime EnrolledAt { get; set; }
        public decimal ProgressPercentage { get; set; }
        public int CompletedLectures { get; set; }
        public int TotalLectures { get; set; }
        public string Status { get; set; } // Active, Completed, Inactive
        public DateTime? LastActivity { get; set; }
        public string LastActivityDescription { get; set; }
    }
}

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_MVC.Models.DTOs.Student
{
    public class StudentProgressDto
    {
        public int EnrollmentId { get; set; }
        public int CourseId { get; set; }
        public string CourseTitle { get; set; }
        public decimal ProgressPercentage { get; set; }
        public int CompletedLectures { get; set; }
        public int TotalLectures { get; set; }
        public DateTime? LastActivity { get; set; }
        public string Status { get; set; }
    }
}

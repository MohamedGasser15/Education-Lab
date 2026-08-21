using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_MVC.Models.DTOs.Student
{
    /// <summary>
    /// Represents a student statistics data transfer object.
    /// </summary>
    public class StudentStatisticsDto
    {
        public int TotalEnrollments { get; set; }
        public int CompletedCourses { get; set; }
        public int ActiveCourses { get; set; }
        public decimal AverageProgress { get; set; }
        public int TotalTimeSpent { get; set; }
        public decimal AverageGrade { get; set; }
    }
}

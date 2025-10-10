using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_Shared.DTOs.Student
{
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

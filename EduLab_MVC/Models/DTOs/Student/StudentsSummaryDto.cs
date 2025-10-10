using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_MVC.Models.DTOs.Student
{
    public class StudentsSummaryDto
    {
        public int TotalStudents { get; set; }
        public int ActiveStudents { get; set; }
        public int CompletedCourses { get; set; }
        public decimal AverageCompletion { get; set; }
    }
}

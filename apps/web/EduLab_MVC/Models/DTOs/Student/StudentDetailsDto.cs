using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_MVC.Models.DTOs.Student
{
    public class StudentDetailsDto
    {
        public StudentDto Student { get; set; }
        public List<StudentEnrollmentDto> Enrollments { get; set; }
        public StudentStatisticsDto Statistics { get; set; }
        public List<StudentActivityDto> RecentActivities { get; set; }
    }
}

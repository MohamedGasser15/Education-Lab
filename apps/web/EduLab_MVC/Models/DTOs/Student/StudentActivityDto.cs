using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_MVC.Models.DTOs.Student
{
    /// <summary>
    /// Represents a student activity data transfer object.
    /// </summary>
    public class StudentActivityDto
    {
        public string Type { get; set; }
        public string Description { get; set; }
        public DateTime ActivityDate { get; set; }
        public string CourseTitle { get; set; }
        public int CourseId { get; set; }
    }
}

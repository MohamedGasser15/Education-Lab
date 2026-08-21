using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_MVC.Models.DTOs.Student
{
    /// <summary>
    /// Represents a student filter data transfer object.
    /// </summary>
    public class StudentFilterDto
    {
        public string Search { get; set; }
        public int? CourseId { get; set; }
        public string Status { get; set; }
        public int PageNumber { get; set; } = 1;
        public int PageSize { get; set; } = 10;
    }
}

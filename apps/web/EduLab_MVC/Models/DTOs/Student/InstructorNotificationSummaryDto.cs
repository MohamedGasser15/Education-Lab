using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_MVC.Models.DTOs.Student
{
    /// <summary>
    /// Represents an instructor notification summary data transfer object.
    /// </summary>
    public class InstructorNotificationSummaryDto
    {
        public int TotalStudents { get; set; }
        public int SelectedStudents { get; set; }
        public bool SendToAll { get; set; }
    }
}

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_Application.DTOs.Student
{
    public class InstructorNotificationSummaryDto
    {
        public int TotalStudents { get; set; }
        public int SelectedStudents { get; set; }
        public bool SendToAll { get; set; }
    }
}

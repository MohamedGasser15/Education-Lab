using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_MVC.Models.DTOs.Student
{
    /// <summary>
    /// Represents a student notification data transfer object.
    /// </summary>
    public class StudentNotificationDto
    {
        public string StudentId { get; set; }
        public string FullName { get; set; }
        public string Email { get; set; }
        public string ProfileImageUrl { get; set; }
        public bool IsSelected { get; set; }
    }
}

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_MVC.Models.DTOs.Instructor
{
    public class InstructorApplicationResponseDto
    {
        public string Id { get; set; }
        public string FullName { get; set; }
        public string Email { get; set; }
        public string Specialization { get; set; }
        public string Experience { get; set; }
        public string Status { get; set; }
        public DateTime AppliedDate { get; set; }
        public string CvUrl { get; set; }
    }
}

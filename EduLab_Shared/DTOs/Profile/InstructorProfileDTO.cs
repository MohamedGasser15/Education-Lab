using EduLab_Shared.DTOs.Course;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_Shared.DTOs.Profile
{
    public class InstructorProfileDTO : ProfileDTO
    {
        public List<string> Subjects { get; set; } = new List<string>(); // Added
        public List<CertificateDTO> Certificates { get; set; } = new List<CertificateDTO>(); // Added
        public List<CourseDTO>? Courses { get; set; }
    }
}

using EduLab_Shared.DTOs.Course;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_Shared.DTOs.Profile
{
    /// <summary>
    /// Data Transfer Object for instructor profile information
    /// </summary>
    public class InstructorProfileDTO : ProfileDTO
    {
        /// <summary>
        /// Gets or sets the list of subjects taught by the instructor
        /// </summary>
        public List<string> Subjects { get; set; } = new List<string>();

        /// <summary>
        /// Gets or sets the list of certificates held by the instructor
        /// </summary>
        public List<CertificateDTO> Certificates { get; set; } = new List<CertificateDTO>();

        /// <summary>
        /// Gets or sets the list of courses taught by the instructor
        /// </summary>
        public List<CourseDTO>? Courses { get; set; }
    }
}

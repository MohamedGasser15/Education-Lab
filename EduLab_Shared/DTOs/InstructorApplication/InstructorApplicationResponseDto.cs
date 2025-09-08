using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_Shared.DTOs.InstructorApplication
{
    /// <summary>
    /// Data transfer object for instructor application response
    /// </summary>
    public class InstructorApplicationResponseDto
    {
        /// <summary>
        /// Gets or sets the application identifier
        /// </summary>
        public string Id { get; set; }

        /// <summary>
        /// Gets or sets the full name of the applicant
        /// </summary>
        public string FullName { get; set; }

        /// <summary>
        /// Gets or sets the email of the applicant
        /// </summary>
        public string Email { get; set; }

        /// <summary>
        /// Gets or sets the specialization of the applicant
        /// </summary>
        public string Specialization { get; set; }

        /// <summary>
        /// Gets or sets the experience of the applicant
        /// </summary>
        public string Experience { get; set; }

        /// <summary>
        /// Gets or sets the status of the application
        /// </summary>
        public string Status { get; set; }

        /// <summary>
        /// Gets or sets the application date
        /// </summary>
        public DateTime AppliedDate { get; set; }

        /// <summary>
        /// Gets or sets the CV URL of the applicant
        /// </summary>
        public string CvUrl { get; set; }
    }
}

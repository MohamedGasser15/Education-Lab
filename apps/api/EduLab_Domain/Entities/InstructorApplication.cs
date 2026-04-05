using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_Domain.Entities
{
    /// <summary>
    /// Represents an instructor application
    /// </summary>
    public class InstructorApplication
    {
        /// <summary>
        /// Gets or sets the application identifier
        /// </summary>
        public Guid Id { get; set; } = Guid.NewGuid();

        /// <summary>
        /// Gets or sets the user identifier
        /// </summary>
        public string UserId { get; set; }

        /// <summary>
        /// Gets or sets the user associated with the application
        /// </summary>
        [ForeignKey("UserId")]
        public ApplicationUser User { get; set; }

        /// <summary>
        /// Gets or sets the specialization of the applicant
        /// </summary>
        public string Specialization { get; set; }

        /// <summary>
        /// Gets or sets the experience of the applicant
        /// </summary>
        public string Experience { get; set; }

        /// <summary>
        /// Gets or sets the skills of the applicant
        /// </summary>
        public string Skills { get; set; }

        /// <summary>
        /// Gets or sets the CV URL of the applicant
        /// </summary>
        public string CvUrl { get; set; }

        /// <summary>
        /// Gets or sets the status of the application
        /// </summary>
        public string Status { get; set; } = "Pending";

        /// <summary>
        /// Gets or sets the application date
        /// </summary>
        public DateTime AppliedDate { get; set; } = DateTime.UtcNow;

        /// <summary>
        /// Gets or sets the review date
        /// </summary>
        public DateTime? ReviewedDate { get; set; }

        /// <summary>
        /// Gets or sets the user who reviewed the application
        /// </summary>
        public string? ReviewedBy { get; set; }
    }
}

using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_Domain.Entities
{
    public class InstructorApplication
    {
        public Guid Id { get; set; } = Guid.NewGuid();

        public string UserId { get; set; }
        [ForeignKey("UserId")]
        public ApplicationUser User { get; set; }

        public string Specialization { get; set; }
        public string Experience { get; set; }
        public string Skills { get; set; }
        public string CvUrl { get; set; }

        public string Status { get; set; } = "Pending";
        public DateTime AppliedDate { get; set; } = DateTime.UtcNow;
        public DateTime? ReviewedDate { get; set; }
        public string? ReviewedBy { get; set; }
    }
}

using System;
using System.ComponentModel.DataAnnotations.Schema;

namespace EduLab_Domain.Entities
{
    public class Report
    {
        public int Id { get; set; }
        public string Type { get; set; } // "Course" | "Comment" | "Review"
        public int TargetId { get; set; }
        public string Reason { get; set; } // code: "Copyright", "Pornographic", ...
        public string? Details { get; set; }
        public string ReporterId { get; set; }
        public string Status { get; set; } = "pending"; // pending | resolved | dismissed
        public string? AdminNote { get; set; }
        public string? ResolvedActions { get; set; } // comma-separated action codes
        public string? HandledById { get; set; }
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
        public DateTime? HandledAt { get; set; }

        [ForeignKey("ReporterId")]
        public ApplicationUser Reporter { get; set; }
    }
}

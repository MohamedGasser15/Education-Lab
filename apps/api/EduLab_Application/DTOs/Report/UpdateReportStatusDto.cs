using System.ComponentModel.DataAnnotations;

namespace EduLab_Application.DTOs.Report
{
    public class UpdateReportStatusDto
    {
        [Required]
        public string Status { get; set; } // resolved | dismissed

        [MaxLength(500)]
        public string? AdminNote { get; set; }

        public string? Action { get; set; } // WarnedUser | RemovedContent | ReviewedNoViolation
    }
}

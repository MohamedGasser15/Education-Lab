using System.ComponentModel.DataAnnotations;

namespace EduLab_Application.DTOs.Report
{
    public class CreateReportDto
    {
        [Required]
        public string Type { get; set; } // Course | Comment | Review

        [Required]
        public int TargetId { get; set; }

        [Required]
        [MaxLength(50)]
        public string Reason { get; set; }

        [MaxLength(1000)]
        public string? Details { get; set; }
    }
}

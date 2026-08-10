using System;

namespace EduLab_Application.DTOs.Report
{
    public class AdminReportDto
    {
        public int Id { get; set; }
        public string Type { get; set; }
        public int TargetId { get; set; }
        public string Reason { get; set; }
        public string? Details { get; set; }
        public string Status { get; set; }
        public DateTime CreatedAt { get; set; }
        public DateTime? HandledAt { get; set; }
        public string? AdminNote { get; set; }
        public string? ResolvedActions { get; set; }
        public string? HandledById { get; set; }
        public string? HandledByName { get; set; }
        public string ReporterId { get; set; }
        public string ReporterName { get; set; }
        public string ReporterEmail { get; set; }
        public string TargetSummary { get; set; }
        public string? TargetOwnerName { get; set; }
        public int? CourseId { get; set; }
        public string? CourseTitle { get; set; }
        public bool CanDeleteContent { get; set; }
    }
}

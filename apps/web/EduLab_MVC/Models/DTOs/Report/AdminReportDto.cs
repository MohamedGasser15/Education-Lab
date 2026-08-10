using System.Text.Json.Serialization;

namespace EduLab_MVC.Models.DTOs.Report
{
    public class AdminReportDto
    {
        [JsonPropertyName("id")] public int Id { get; set; }
        [JsonPropertyName("type")] public string Type { get; set; }
        [JsonPropertyName("targetId")] public int TargetId { get; set; }
        [JsonPropertyName("reason")] public string Reason { get; set; }
        [JsonPropertyName("details")] public string? Details { get; set; }
        [JsonPropertyName("status")] public string Status { get; set; }
        [JsonPropertyName("createdAt")] public DateTime CreatedAt { get; set; }
        [JsonPropertyName("handledAt")] public DateTime? HandledAt { get; set; }
        [JsonPropertyName("adminNote")] public string? AdminNote { get; set; }
        [JsonPropertyName("resolvedActions")] public string? ResolvedActions { get; set; }
        public List<string> ResolvedActionsList =>
            string.IsNullOrEmpty(ResolvedActions)
                ? new List<string>()
                : ResolvedActions.Split(',', StringSplitOptions.RemoveEmptyEntries | StringSplitOptions.TrimEntries).ToList();
        [JsonPropertyName("handledById")] public string? HandledById { get; set; }
        [JsonPropertyName("handledByName")] public string? HandledByName { get; set; }
        [JsonPropertyName("reporterId")] public string ReporterId { get; set; }
        [JsonPropertyName("reporterName")] public string ReporterName { get; set; }
        [JsonPropertyName("reporterEmail")] public string ReporterEmail { get; set; }
        [JsonPropertyName("targetSummary")] public string TargetSummary { get; set; }
        [JsonPropertyName("targetOwnerName")] public string? TargetOwnerName { get; set; }
        [JsonPropertyName("courseId")] public int? CourseId { get; set; }
        [JsonPropertyName("courseTitle")] public string? CourseTitle { get; set; }
        [JsonPropertyName("canDeleteContent")] public bool CanDeleteContent { get; set; }
    }
}

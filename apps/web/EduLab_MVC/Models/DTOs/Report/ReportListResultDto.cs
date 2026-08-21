using System.Text.Json.Serialization;

namespace EduLab_MVC.Models.DTOs.Report
{
    /// <summary>
    /// Represents a report list result data transfer object.
    /// </summary>
    public class ReportListResultDto
    {
        [JsonPropertyName("items")] public List<AdminReportDto> Items { get; set; } = new();
        [JsonPropertyName("totalCount")] public int TotalCount { get; set; }
        [JsonPropertyName("pendingCount")] public int PendingCount { get; set; }
        [JsonPropertyName("resolvedCount")] public int ResolvedCount { get; set; }
        [JsonPropertyName("dismissedCount")] public int DismissedCount { get; set; }
        [JsonPropertyName("pageNumber")] public int PageNumber { get; set; } = 1;
        [JsonPropertyName("pageSize")] public int PageSize { get; set; } = 10;
    }
}

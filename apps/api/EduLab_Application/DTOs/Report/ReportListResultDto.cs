using System.Collections.Generic;

namespace EduLab_Application.DTOs.Report
{
    public class ReportListResultDto
    {
        public List<AdminReportDto> Items { get; set; } = new List<AdminReportDto>();
        public int TotalCount { get; set; }
        public int PendingCount { get; set; }
        public int ResolvedCount { get; set; }
        public int DismissedCount { get; set; }
        public int PageNumber { get; set; } = 1;
        public int PageSize { get; set; } = 10;
    }
}

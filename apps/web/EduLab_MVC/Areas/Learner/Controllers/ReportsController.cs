using EduLab_MVC.Resources;
using EduLab_MVC.Services.ServiceInterfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Localization;
using System.Collections.Generic;

namespace EduLab_MVC.Areas.Learner.Controllers
{
    [Area("Learner")]
    [Authorize]
    public class ReportsController : Controller
    {
        private readonly IReportService _reportService;
        private readonly ILogger<ReportsController> _logger;
        private readonly IStringLocalizer<SharedResources> _localizer;

        public ReportsController(
            IReportService reportService,
            ILogger<ReportsController> logger,
            IStringLocalizer<SharedResources> localizer)
        {
            _reportService = reportService;
            _logger = logger;
            _localizer = localizer;
        }

        [HttpGet]
        public async Task<IActionResult> Check(string type, int targetId)
        {
            try
            {
                var reported = await _reportService.CheckReportedAsync(type, targetId);
                return Json(new { reported });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error checking report status");
                return Json(new { reported = false });
            }
        }

        [HttpGet("check-many")]
        public async Task<IActionResult> CheckMany(string type, string ids)
        {
            try
            {
                var targetIds = new List<int>();
                foreach (var part in (ids ?? "").Split(',', StringSplitOptions.RemoveEmptyEntries | StringSplitOptions.TrimEntries))
                {
                    if (int.TryParse(part, out var id))
                        targetIds.Add(id);
                }

                var reportedIds = await _reportService.CheckReportedManyAsync(type, targetIds);
                return Json(new { reportedIds });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error checking report statuses");
                return Json(new { reportedIds = new List<int>() });
            }
        }

        [HttpPost]
        public async Task<IActionResult> Create([FromBody] CreateReportRequest request)
        {
            try
            {
                if (request == null || string.IsNullOrEmpty(request.Type) || request.TargetId <= 0 || string.IsNullOrEmpty(request.Reason))
                    return Json(new { success = false, message = _localizer["InvalidReportData"].Value });

                var (success, message) = await _reportService.CreateAsync(request.Type, request.TargetId, request.Reason, request.Details);

                return Json(new
                {
                    success,
                    message = success ? _localizer["ReportSubmittedMsg"].Value : (message ?? _localizer["ReportSubmitError"].Value)
                });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error creating report");
                return Json(new { success = false, message = _localizer["ReportSubmitError"].Value });
            }
        }
    }

    public class CreateReportRequest
    {
        public string Type { get; set; }
        public int TargetId { get; set; }
        public string Reason { get; set; }
        public string? Details { get; set; }
    }
}

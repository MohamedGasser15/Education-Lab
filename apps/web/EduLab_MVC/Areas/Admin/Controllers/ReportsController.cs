using EduLab_MVC.Common;
using EduLab_MVC.Resources;
using EduLab_MVC.Services.ServiceInterfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Localization;

namespace EduLab_MVC.Areas.Admin.Controllers
{
    /// <summary>
    /// Controller for user reports management (Admin area)
    /// </summary>
    [Area("Admin")]
    [Authorize(Policy = "AdminArea")]
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

        /// <summary>
        /// Displays all user reports with filters
        /// </summary>
        public async Task<IActionResult> Index(string? status, string? type, string? search, int page = 1, CancellationToken cancellationToken = default)
        {
            try
            {
                if (!User.HasClaim(c => c.Type == "ViewReports"))
                {
                    TempData["Error"] = _localizer["Forbidden"].Value;
                    return RedirectToAction("Index", "Dashboard");
                }

                page = Math.Max(1, page);
                var model = await _reportService.GetAdminReportsAsync(status, type, search, page, 10, cancellationToken);

                if (model == null)
                {
                    TempData["Error"] = _localizer["ErrorLoadingReports"].Value;
                    return View(new EduLab_MVC.Models.DTOs.Report.ReportListResultDto());
                }

                ViewBag.SelectedStatus = status ?? "all";
                ViewBag.SelectedType = type ?? "all";
                ViewBag.Search = search;
                return View(model);
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation cancelled while displaying reports for admin");
                return RedirectToAction("Index", "Dashboard");
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while displaying reports for admin");
                TempData["Error"] = _localizer["ErrorLoadingReports"].Value;
                return RedirectToAction("Index", "Dashboard");
            }
        }

        /// <summary>
        /// Resolves a report (marks as handled)
        /// </summary>
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Resolve(int id, string? adminNote = null, string? action = null, CancellationToken cancellationToken = default)
        {
            try
            {
                if (!User.HasClaim(c => c.Type == "HandleReports"))
                {
                    TempData["Error"] = _localizer["Forbidden"].Value;
                    return RedirectToAction(nameof(Index));
                }

                var result = await _reportService.UpdateStatusAsync(id, SD.ReportStatusResolved, adminNote, action, cancellationToken);

                TempData[result == "success" ? "Success" : "Error"] =
                    result == "success" ? _localizer["ReportResolvedMsg"].Value : result;
                return RedirectToAction(nameof(Index));
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation cancelled while resolving report {ReportId}", id);
                TempData["Error"] = _localizer["OperationCancelled"].Value;
                return RedirectToAction(nameof(Index));
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while resolving report {ReportId}", id);
                TempData["Error"] = _localizer["ErrorProcessingReport"].Value;
                return RedirectToAction(nameof(Index));
            }
        }

        /// <summary>
        /// Dismisses a report (marks as not valid)
        /// </summary>
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Dismiss(int id, string? adminNote = null, CancellationToken cancellationToken = default)
        {
            try
            {
                if (!User.HasClaim(c => c.Type == "HandleReports"))
                {
                    TempData["Error"] = _localizer["Forbidden"].Value;
                    return RedirectToAction(nameof(Index));
                }

                var result = await _reportService.UpdateStatusAsync(id, SD.ReportStatusDismissed, adminNote, null, cancellationToken);

                TempData[result == "success" ? "Success" : "Error"] =
                    result == "success" ? _localizer["ReportDismissedMsg"].Value : result;
                return RedirectToAction(nameof(Index));
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation cancelled while dismissing report {ReportId}", id);
                TempData["Error"] = _localizer["OperationCancelled"].Value;
                return RedirectToAction(nameof(Index));
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while dismissing report {ReportId}", id);
                TempData["Error"] = _localizer["ErrorProcessingReport"].Value;
                return RedirectToAction(nameof(Index));
            }
        }

        /// <summary>
        /// Deletes the reported content (comment or review) and resolves the report
        /// </summary>
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeleteContent(int id, CancellationToken cancellationToken = default)
        {
            try
            {
                if (!User.HasClaim(c => c.Type == "HandleReports"))
                {
                    TempData["Error"] = _localizer["Forbidden"].Value;
                    return RedirectToAction(nameof(Index));
                }

                var result = await _reportService.DeleteContentAsync(id, cancellationToken);

                TempData[result == "success" ? "Success" : "Error"] =
                    result == "success" ? _localizer["ReportedContentDeletedMsg"].Value : result;
                return RedirectToAction(nameof(Index));
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation cancelled while deleting reported content {ReportId}", id);
                TempData["Error"] = _localizer["OperationCancelled"].Value;
                return RedirectToAction(nameof(Index));
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while deleting reported content {ReportId}", id);
                TempData["Error"] = _localizer["ErrorProcessingReport"].Value;
                return RedirectToAction(nameof(Index));
            }
        }
    }
}

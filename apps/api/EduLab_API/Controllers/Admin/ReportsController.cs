using EduLab_Application.Common.Constants;
using EduLab_Application.DTOs.Report;
using EduLab_Application.ServiceInterfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;
using System.Threading;
using System.Threading.Tasks;

namespace EduLab_API.Controllers.Admin
{
    /// <summary>
    /// Controller for admin report management (content reports, status updates, and content deletion)
    /// </summary>
    [Route("api/admin/reports")]
    [Authorize(Policy = "AdminArea")]
    [ApiController]
    public class ReportsController : ControllerBase
    {
        private readonly IReportService _reportService;
        private readonly ILogger<ReportsController> _logger;

        /// <summary>
        /// Initializes a new instance of the ReportsController class
        /// </summary>
        /// <param name="reportService">Report service</param>
        /// <param name="logger">Logger instance</param>
        public ReportsController(IReportService reportService, ILogger<ReportsController> logger)
        {
            _reportService = reportService;
            _logger = logger;
        }

        /// <summary>
        /// Gets all reports with optional filtering and pagination
        /// </summary>
        /// <param name="status">Optional status filter</param>
        /// <param name="type">Optional report type filter</param>
        /// <param name="search">Optional search term</param>
        /// <param name="page">Page number (default: 1)</param>
        /// <param name="pageSize">Page size (default: 10)</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Paginated list of reports</returns>
        /// <response code="200">Returns the list of reports</response>
        /// <response code="403">If the user lacks the ViewReports claim</response>
        /// <response code="500">If an unexpected error occurred</response>
        [HttpGet]
        public async Task<ActionResult<ReportListResultDto>> GetAll(
            [FromQuery] string? status,
            [FromQuery] string? type,
            [FromQuery] string? search,
            [FromQuery] int page = 1,
            [FromQuery] int pageSize = 10,
            CancellationToken cancellationToken = default)
        {
            if (!User.HasClaim(c => c.Type == "ViewReports"))
                return Forbid();

            try
            {
                var result = await _reportService.GetAdminReportsAsync(status, type, search, page, pageSize, cancellationToken);
                return Ok(result);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error retrieving reports for admin");
                return StatusCode(500, new { Message = "An unexpected error occurred while retrieving reports." });
            }
        }

        /// <summary>
        /// Gets the count of pending reports
        /// </summary>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Number of pending reports</returns>
        /// <response code="200">Returns the pending count</response>
        /// <response code="403">If the user lacks the ViewReports claim</response>
        /// <response code="500">If an unexpected error occurred</response>
        [HttpGet("pending-count")]
        public async Task<ActionResult<int>> GetPendingCount(CancellationToken cancellationToken = default)
        {
            if (!User.HasClaim(c => c.Type == "ViewReports"))
                return Forbid();

            try
            {
                var count = await _reportService.GetPendingCountAsync(cancellationToken);
                return Ok(count);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error retrieving pending reports count");
                return StatusCode(500, new { Message = "An unexpected error occurred." });
            }
        }

        /// <summary>
        /// Updates the status of a report
        /// </summary>
        /// <param name="id">Report ID</param>
        /// <param name="dto">New status details</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Operation result</returns>
        /// <response code="200">If the status was updated successfully</response>
        /// <response code="400">If the request data is invalid</response>
        /// <response code="401">If the admin user could not be identified</response>
        /// <response code="403">If the user lacks the HandleReports claim</response>
        /// <response code="404">If the report was not found</response>
        /// <response code="500">If an unexpected error occurred</response>
        [HttpPost("{id}/status")]
        public async Task<IActionResult> UpdateStatus(int id, [FromBody] UpdateReportStatusDto dto, CancellationToken cancellationToken = default)
        {
            if (!User.HasClaim(c => c.Type == "HandleReports"))
                return Forbid();

            try
            {
                var adminId = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
                if (string.IsNullOrEmpty(adminId))
                    return Unauthorized(new { Message = "Admin user not identified." });

                await _reportService.UpdateStatusAsync(adminId, id, dto, cancellationToken);
                return Ok(new { Message = "تم تحديث حالة البلاغ" });
            }
            catch (KeyNotFoundException ex)
            {
                return NotFound(new { Message = ex.Message });
            }
            catch (ArgumentException ex)
            {
                return BadRequest(new { Message = ex.Message });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error updating status of report {ReportId}", id);
                return StatusCode(500, new { Message = "An unexpected error occurred while updating the report." });
            }
        }

        /// <summary>
        /// Deletes the reported content
        /// </summary>
        /// <param name="id">Report ID</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>The updated report details</returns>
        /// <response code="200">Returns the updated report</response>
        /// <response code="400">If the content cannot be deleted</response>
        /// <response code="401">If the admin user could not be identified</response>
        /// <response code="403">If the user lacks the HandleReports claim</response>
        /// <response code="404">If the report was not found</response>
        /// <response code="500">If an unexpected error occurred</response>
        [HttpPost("{id}/delete-content")]
        public async Task<ActionResult<AdminReportDto>> DeleteContent(int id, CancellationToken cancellationToken = default)
        {
            if (!User.HasClaim(c => c.Type == "HandleReports"))
                return Forbid();

            try
            {
                var adminId = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
                if (string.IsNullOrEmpty(adminId))
                    return Unauthorized(new { Message = "Admin user not identified." });

                var report = await _reportService.DeleteReportedContentAsync(adminId, id, cancellationToken);
                return Ok(report);
            }
            catch (KeyNotFoundException ex)
            {
                return NotFound(new { Message = ex.Message });
            }
            catch (InvalidOperationException ex)
            {
                return BadRequest(new { Message = ex.Message });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error deleting content of report {ReportId}", id);
                return StatusCode(500, new { Message = "An unexpected error occurred while deleting the content." });
            }
        }
    }
}

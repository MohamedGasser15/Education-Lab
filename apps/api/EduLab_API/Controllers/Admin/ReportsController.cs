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
    [Route("api/admin/reports")]
    [Authorize(Policy = "AdminArea")]
    [ApiController]
    public class ReportsController : ControllerBase
    {
        private readonly IReportService _reportService;
        private readonly ILogger<ReportsController> _logger;

        public ReportsController(IReportService reportService, ILogger<ReportsController> logger)
        {
            _reportService = reportService;
            _logger = logger;
        }

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

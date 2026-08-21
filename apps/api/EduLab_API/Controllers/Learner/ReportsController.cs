using EduLab_Application.DTOs.Report;
using EduLab_Application.ServiceInterfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Security.Claims;
using System.Threading;
using System.Threading.Tasks;

namespace EduLab_API.Controllers.Learner
{
    /// <summary>
    /// Controller for user content reports
    /// </summary>
    [ApiController]
    [Route("api/reports")]
    [Authorize]
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
        /// Checks whether the current user has already reported a target
        /// </summary>
        /// <param name="type">Report type (course, lecture, comment, etc.)</param>
        /// <param name="targetId">Target identifier</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>True if the user has already reported the target</returns>
        /// <response code="200">Returns the report status</response>
        /// <response code="401">If the user is not authenticated</response>
        /// <response code="500">If there was an internal server error</response>
        [HttpGet("check")]
        public async Task<IActionResult> Check([FromQuery] string type, [FromQuery] int targetId, CancellationToken cancellationToken)
        {
            try
            {
                var userId = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
                if (string.IsNullOrEmpty(userId))
                    return Unauthorized();

                var reported = await _reportService.HasReportedAsync(userId, type, targetId, cancellationToken);
                return Ok(new { reported });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error checking report status for target {TargetId} ({Type})", targetId, type);
                return StatusCode(500, new { Message = "حدث خطأ أثناء الفحص" });
            }
        }

        /// <summary>
        /// Checks report status for multiple targets of the same type
        /// </summary>
        /// <param name="type">Report type (course, lecture, comment, etc.)</param>
        /// <param name="ids">Comma-separated list of target IDs</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>List of target IDs already reported by the user</returns>
        /// <response code="200">Returns the reported target IDs</response>
        /// <response code="401">If the user is not authenticated</response>
        /// <response code="500">If there was an internal server error</response>
        [HttpGet("check-many")]
        public async Task<IActionResult> CheckMany([FromQuery] string type, [FromQuery] string ids, CancellationToken cancellationToken)
        {
            try
            {
                var userId = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
                if (string.IsNullOrEmpty(userId))
                    return Unauthorized();

                var targetIds = new List<int>();
                foreach (var part in (ids ?? "").Split(',', StringSplitOptions.RemoveEmptyEntries | StringSplitOptions.TrimEntries))
                {
                    if (int.TryParse(part, out var id))
                        targetIds.Add(id);
                }

                var reportedIds = await _reportService.GetReportedTargetIdsAsync(userId, type, targetIds, cancellationToken);
                return Ok(new { reportedIds });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error checking report statuses for type {Type}", type);
                return StatusCode(500, new { Message = "حدث خطأ أثناء الفحص" });
            }
        }

        /// <summary>
        /// Creates a new content report
        /// </summary>
        /// <param name="dto">Report details</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>The created report identifier</returns>
        /// <response code="200">If the report was submitted successfully</response>
        /// <response code="400">If the data is invalid</response>
        /// <response code="401">If the user is not authenticated</response>
        /// <response code="404">If the target was not found</response>
        /// <response code="409">If the report conflicts with an existing one</response>
        /// <response code="500">If there was an internal server error</response>
        [HttpPost]
        public async Task<IActionResult> Create([FromBody] CreateReportDto dto, CancellationToken cancellationToken)
        {
            if (!ModelState.IsValid)
                return BadRequest(new { Message = "البيانات غير صالحة" });

            try
            {
                var userId = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
                if (string.IsNullOrEmpty(userId))
                    return Unauthorized();

                var report = await _reportService.CreateReportAsync(userId, dto, cancellationToken);
                return Ok(new { Message = "تم إرسال البلاغ بنجاح", ReportId = report.Id });
            }
            catch (KeyNotFoundException ex)
            {
                return NotFound(new { Message = ex.Message });
            }
            catch (InvalidOperationException ex)
            {
                return Conflict(new { Message = ex.Message });
            }
            catch (ArgumentException ex)
            {
                return BadRequest(new { Message = ex.Message });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error creating report for target {TargetId} ({Type})", dto.TargetId, dto.Type);
                return StatusCode(500, new { Message = "حدث خطأ أثناء إرسال البلاغ" });
            }
        }
    }
}

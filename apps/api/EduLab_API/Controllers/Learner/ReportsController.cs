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
    [ApiController]
    [Route("api/reports")]
    [Authorize]
    public class ReportsController : ControllerBase
    {
        private readonly IReportService _reportService;
        private readonly ILogger<ReportsController> _logger;

        public ReportsController(IReportService reportService, ILogger<ReportsController> logger)
        {
            _reportService = reportService;
            _logger = logger;
        }

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

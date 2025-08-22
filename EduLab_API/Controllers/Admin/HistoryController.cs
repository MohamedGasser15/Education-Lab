using EduLab_Application.ServiceInterfaces;
using EduLab_Domain.Entities;
using EduLab_Shared.DTOs.History;
using Microsoft.AspNetCore.Mvc;

namespace EduLab_API.Controllers.Admin
{
    [Route("api/[controller]")]
    [ApiController]
    public class HistoryController : ControllerBase
    {
        private readonly IHistoryService _historyService;
        private readonly ICurrentUserService _currentUserService;
        public HistoryController(IHistoryService historyService, ICurrentUserService currentUserService)
        {
            _historyService = historyService;
            _currentUserService = currentUserService;
        }

        // GET: api/History
        [HttpGet("all")]
        public async Task<ActionResult<List<HistoryDTO>>> GetAllHistory()
        {
            var logs = await _historyService.GetAllHistoryAsync();
            return Ok(logs);
        }
        // GET: api/History
        [HttpGet("MyHistory")]
        public async Task<ActionResult<List<HistoryDTO>>> GetMyHistory()
        {
            try
            {
                var instructorId = await _currentUserService.GetUserIdAsync();

                if (string.IsNullOrEmpty(instructorId))
                    return Unauthorized();
                var logs = await _historyService.GetMyHistoryAsync(instructorId);
                if (logs == null || !logs.Any())
                {
                    return NotFound(new { message = "No logs found for this instructor" });
                }
                return Ok(logs);
            }
            catch (Exception ex)
            {
                return StatusCode(500, new
                {
                    message = "An error occurred while retrieving instructor logs",
                    error = ex.Message
                });
            }
        }
        // GET: api/History/user/{userId}
        [HttpGet("user/{userId}")]
        public async Task<ActionResult<List<HistoryDTO>>> GetHistoryByUser(string userId)
        {
            var logs = await _historyService.GetHistoryByUserAsync(userId);
            return Ok(logs);
        }

        // POST: api/History/log
        [HttpPost("History")]
        public async Task<ActionResult> HistoryOperation([FromQuery] string userId, [FromQuery] string operation)
        {
            await _historyService.LogOperationAsync(userId, operation);
            return Ok(new { message = "Operation logged successfully" });
        }
    }
}

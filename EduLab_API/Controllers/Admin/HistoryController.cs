using EduLab_Application.ServiceInterfaces;
using EduLab_Shared.DTOs.History;
using Microsoft.AspNetCore.Mvc;

namespace EduLab_API.Controllers.Admin
{
    [Route("api/[controller]")]
    [ApiController]
    public class HistoryController : ControllerBase
    {
        private readonly IHistoryService _historyService;

        public HistoryController(IHistoryService historyService)
        {
            _historyService = historyService;
        }

        // GET: api/History
        [HttpGet("all")]
        public async Task<ActionResult<List<HistoryDTO>>> GetAllHistory()
        {
            var logs = await _historyService.GetAllHistoryAsync();
            return Ok(logs);
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

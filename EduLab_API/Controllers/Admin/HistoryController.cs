using EduLab_Application.ServiceInterfaces;
using EduLab_Shared.DTOs.History;
using EduLab_Shared.Utitlites;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;

namespace EduLab_API.Controllers.Admin
{
    /// <summary>
    /// API controller for managing history operations (Admin only)
    /// </summary>
    [Route("api/[controller]")]
    [ApiController]
    [Authorize(Roles = SD.Admin)]
    public class HistoryController : ControllerBase
    {
        #region Fields

        private readonly IHistoryService _historyService;
        private readonly ICurrentUserService _currentUserService;
        private readonly ILogger<HistoryController> _logger;

        #endregion

        #region Constructor

        /// <summary>
        /// Initializes a new instance of the HistoryController class
        /// </summary>
        /// <param name="historyService">The history service</param>
        /// <param name="currentUserService">The current user service</param>
        /// <param name="logger">Logger for logging operations</param>
        public HistoryController(
            IHistoryService historyService,
            ICurrentUserService currentUserService,
            ILogger<HistoryController> logger)
        {
            _historyService = historyService ?? throw new ArgumentNullException(nameof(historyService));
            _currentUserService = currentUserService ?? throw new ArgumentNullException(nameof(currentUserService));
            _logger = logger ?? throw new ArgumentNullException(nameof(logger));
        }

        #endregion

        #region API Endpoints

        /// <summary>
        /// Gets all history logs from the system
        /// </summary>
        /// <param name="cancellationToken">Cancellation token for async operation</param>
        /// <returns>List of all history logs</returns>
        /// <response code="200">Returns the list of history logs</response>
        /// <response code="500">If an internal server error occurs</response>
        [HttpGet("all")]
        [ProducesResponseType(typeof(List<HistoryDTO>), 200)]
        [ProducesResponseType(500)]
        public async Task<ActionResult<List<HistoryDTO>>> GetAllHistory(CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Getting all history logs");

                var logs = await _historyService.GetAllHistoryAsync(cancellationToken);
                return Ok(logs);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while getting all history logs");
                return StatusCode(500, new
                {
                    message = "An internal server error occurred while retrieving history logs",
                    error = ex.Message
                });
            }
        }

        /// <summary>
        /// Gets history logs for the currently authenticated user
        /// </summary>
        /// <param name="cancellationToken">Cancellation token for async operation</param>
        /// <returns>List of history logs for the current user</returns>
        /// <response code="200">Returns the list of history logs</response>
        /// <response code="401">If user is not authenticated</response>
        /// <response code="404">If no logs found for the user</response>
        /// <response code="500">If an internal server error occurs</response>
        [HttpGet("MyHistory")]
        [ProducesResponseType(typeof(List<HistoryDTO>), 200)]
        [ProducesResponseType(401)]
        [ProducesResponseType(404)]
        [ProducesResponseType(500)]
        public async Task<ActionResult<List<HistoryDTO>>> GetMyHistory(CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Getting history logs for current user");

                var instructorId = await _currentUserService.GetUserIdAsync();

                if (string.IsNullOrEmpty(instructorId))
                {
                    _logger.LogWarning("Unauthorized access attempt to GetMyHistory");
                    return Unauthorized(new { message = "User must be authenticated to access their history" });
                }

                var logs = await _historyService.GetMyHistoryAsync(instructorId, cancellationToken);

                if (logs == null || !logs.Any())
                {
                    _logger.LogInformation("No history logs found for user: {UserId}", instructorId);
                    return NotFound(new { message = "No history logs found for this user" });
                }

                _logger.LogInformation("Retrieved {Count} history logs for user: {UserId}", logs.Count, instructorId);
                return Ok(logs);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while getting history logs for current user");
                return StatusCode(500, new
                {
                    message = "An error occurred while retrieving user history logs",
                    error = ex.Message
                });
            }
        }

        /// <summary>
        /// Gets history logs for a specific user
        /// </summary>
        /// <param name="userId">The ID of the user</param>
        /// <param name="cancellationToken">Cancellation token for async operation</param>
        /// <returns>List of history logs for the specified user</returns>
        /// <response code="200">Returns the list of history logs</response>
        /// <response code="400">If user ID is invalid</response>
        /// <response code="500">If an internal server error occurs</response>
        [HttpGet("user/{userId}")]
        [ProducesResponseType(typeof(List<HistoryDTO>), 200)]
        [ProducesResponseType(400)]
        [ProducesResponseType(500)]
        public async Task<ActionResult<List<HistoryDTO>>> GetHistoryByUser(string userId, CancellationToken cancellationToken = default)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(userId))
                {
                    _logger.LogWarning("GetHistoryByUser called with null or empty userId");
                    return BadRequest(new { message = "User ID is required" });
                }

                _logger.LogInformation("Getting history logs for user: {UserId}", userId);

                var logs = await _historyService.GetHistoryByUserAsync(userId, cancellationToken);
                return Ok(logs);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while getting history logs for user: {UserId}", userId);
                return StatusCode(500, new
                {
                    message = $"An error occurred while retrieving history logs for user {userId}",
                    error = ex.Message
                });
            }
        }

        /// <summary>
        /// Logs a new operation to the history
        /// </summary>
        /// <param name="userId">The ID of the user performing the operation</param>
        /// <param name="operation">Description of the operation performed</param>
        /// <param name="cancellationToken">Cancellation token for async operation</param>
        /// <returns>Operation result message</returns>
        /// <response code="200">If operation was logged successfully</response>
        /// <response code="400">If user ID or operation is invalid</response>
        /// <response code="500">If an internal server error occurs</response>
        [HttpPost("log")]
        [ProducesResponseType(200)]
        [ProducesResponseType(400)]
        [ProducesResponseType(500)]
        public async Task<ActionResult> LogOperation(
            [FromQuery] string userId,
            [FromQuery] string operation,
            CancellationToken cancellationToken = default)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(userId))
                {
                    _logger.LogWarning("LogOperation called with null or empty userId");
                    return BadRequest(new { message = "User ID is required" });
                }

                if (string.IsNullOrWhiteSpace(operation))
                {
                    _logger.LogWarning("LogOperation called with null or empty operation");
                    return BadRequest(new { message = "Operation description is required" });
                }

                _logger.LogInformation("Logging operation for user: {UserId}, Operation: {Operation}", userId, operation);

                await _historyService.LogOperationAsync(userId, operation, cancellationToken);

                _logger.LogInformation("Operation logged successfully for user: {UserId}", userId);
                return Ok(new { message = "Operation logged successfully" });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while logging operation for user: {UserId}", userId);
                return StatusCode(500, new
                {
                    message = "An error occurred while logging the operation",
                    error = ex.Message
                });
            }
        }

        #endregion
    }
}
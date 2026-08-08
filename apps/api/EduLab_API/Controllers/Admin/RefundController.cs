using EduLab_Application.Common.Constants;
using EduLab_Application.DTOs.Payment;
using EduLab_Application.ServiceInterfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;

namespace EduLab_API.Controllers.Admin
{
    /// <summary>
    /// Controller for admin refund request management
    /// </summary>
    [Route("api/admin/refunds")]
    [Authorize(Roles = SD.Admin)]
    [ApiController]
    public class RefundController : ControllerBase
    {
        private readonly IPaymentService _paymentService;
        private readonly ILogger<RefundController> _logger;

        /// <summary>
        /// Initializes a new instance of the RefundController class
        /// </summary>
        /// <param name="paymentService">Payment service</param>
        /// <param name="logger">Logger instance</param>
        public RefundController(IPaymentService paymentService, ILogger<RefundController> logger)
        {
            _paymentService = paymentService;
            _logger = logger;
        }

        /// <summary>
        /// Retrieves all refund requests for admin review
        /// </summary>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>List of refund requests</returns>
        [HttpGet]
        [ProducesResponseType(typeof(List<AdminRefundRequestDto>), StatusCodes.Status200OK)]
        public async Task<ActionResult<List<AdminRefundRequestDto>>> GetAll(CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Admin retrieving all refund requests");

                var requests = await _paymentService.AdminGetRefundRequestsAsync(cancellationToken);
                return Ok(requests);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error retrieving refund requests for admin");
                return StatusCode(500, new { Message = "An unexpected error occurred while retrieving refund requests." });
            }
        }

        /// <summary>
        /// Approves a refund request and issues the Stripe refund
        /// </summary>
        /// <param name="id">Refund request identifier</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Processing result</returns>
        [HttpPost("{id}/accept")]
        [ProducesResponseType(typeof(RefundResponseDto), StatusCodes.Status200OK)]
        public async Task<ActionResult<RefundResponseDto>> Accept(int id, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Admin accepting refund request {RequestId}", id);

                var adminId = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
                if (string.IsNullOrEmpty(adminId))
                {
                    return Unauthorized(new { Message = "Admin user not identified." });
                }

                var result = await _paymentService.AdminProcessRefundAsync(id, adminId, true, null, cancellationToken);
                if (!result.Success)
                {
                    return BadRequest(new { Message = result.Message });
                }

                return Ok(result);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error accepting refund request {RequestId}", id);
                return StatusCode(500, new { Message = "An unexpected error occurred while processing the refund." });
            }
        }

        /// <summary>
        /// Rejects a refund request
        /// </summary>
        /// <param name="id">Refund request identifier</param>
        /// <param name="body">Rejection details</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Processing result</returns>
        [HttpPost("{id}/reject")]
        [ProducesResponseType(typeof(RefundResponseDto), StatusCodes.Status200OK)]
        public async Task<ActionResult<RefundResponseDto>> Reject(int id, [FromBody] RejectRefundBody body, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Admin rejecting refund request {RequestId}", id);

                var adminId = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
                if (string.IsNullOrEmpty(adminId))
                {
                    return Unauthorized(new { Message = "Admin user not identified." });
                }

                var result = await _paymentService.AdminProcessRefundAsync(id, adminId, false, body?.Reason, cancellationToken);
                if (!result.Success)
                {
                    return BadRequest(new { Message = result.Message });
                }

                return Ok(result);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error rejecting refund request {RequestId}", id);
                return StatusCode(500, new { Message = "An unexpected error occurred while processing the refund." });
            }
        }

        /// <summary>
        /// Request body for rejecting a refund request
        /// </summary>
        public class RejectRefundBody
        {
            public string? Reason { get; set; }
        }
    }
}

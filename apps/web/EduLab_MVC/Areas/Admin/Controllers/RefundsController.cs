using EduLab_MVC.Common;
using EduLab_MVC.Resources;
using EduLab_MVC.Services.ServiceInterfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Localization;

namespace EduLab_MVC.Areas.Admin.Controllers
{
    /// <summary>
    /// Controller for refund request management (Admin area)
    /// </summary>
    [Area("Admin")]
    [Authorize(Roles = SD.Admin)]
    public class RefundsController : Controller
    {
        private readonly IRefundRequestService _refundRequestService;
        private readonly ILogger<RefundsController> _logger;
        private readonly IStringLocalizer<SharedResources> _localizer;

        /// <summary>
        /// Initializes a new instance of the RefundsController class
        /// </summary>
        /// <param name="refundRequestService">Refund request service</param>
        /// <param name="logger">Logger instance</param>
        /// <param name="localizer">The string localizer</param>
        public RefundsController(
            IRefundRequestService refundRequestService,
            ILogger<RefundsController> logger,
            IStringLocalizer<SharedResources> localizer)
        {
            _refundRequestService = refundRequestService;
            _logger = logger;
            _localizer = localizer;
        }

        /// <summary>
        /// Displays all refund requests
        /// </summary>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Refund requests list view</returns>
        public async Task<IActionResult> Index(CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Displaying all refund requests for admin");

                if (!User.HasClaim(c => c.Type == "ViewRefunds"))
                {
                    TempData["Error"] = _localizer["Forbidden"].Value;
                    return RedirectToAction("Index", "Dashboard");
                }

                var requests = await _refundRequestService.GetRefundRequestsAsync(cancellationToken);
                return View(requests ?? new List<EduLab_MVC.Models.DTOs.Payment.AdminRefundRequestDto>());
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation cancelled while displaying refund requests for admin");
                return RedirectToAction("Index", "Dashboard");
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while displaying refund requests for admin");
                TempData["Error"] = _localizer["ErrorLoadingTransactions"].Value;
                return RedirectToAction("Index", "Dashboard");
            }
        }

        /// <summary>
        /// Approves a refund request
        /// </summary>
        /// <param name="id">Refund request identifier</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Redirect to index view</returns>
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Approve(int id, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Approving refund request {RequestId}", id);

                if (!User.HasClaim(c => c.Type == "ManageRefunds"))
                {
                    TempData["Error"] = _localizer["Forbidden"].Value;
                    return RedirectToAction(nameof(Index));
                }

                var result = await _refundRequestService.ApproveRefundAsync(id, cancellationToken);

                TempData[result == "success" ? "Success" : "Error"] =
                    result == "success" ? _localizer["RefundApprovedMsg"].Value : result;
                return RedirectToAction(nameof(Index));
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation cancelled while approving refund request {RequestId}", id);
                TempData["Error"] = _localizer["OperationCancelled"].Value;
                return RedirectToAction(nameof(Index));
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while approving refund request {RequestId}", id);
                TempData["Error"] = _localizer["ErrorProcessingRefund"].Value;
                return RedirectToAction(nameof(Index));
            }
        }

        /// <summary>
        /// Rejects a refund request
        /// </summary>
        /// <param name="id">Refund request identifier</param>
        /// <param name="rejectionReason">Rejection reason</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Redirect to index view</returns>
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Reject(int id, string? rejectionReason = null, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Rejecting refund request {RequestId} with reason: {Reason}", id, rejectionReason);

                if (!User.HasClaim(c => c.Type == "ManageRefunds"))
                {
                    TempData["Error"] = _localizer["Forbidden"].Value;
                    return RedirectToAction(nameof(Index));
                }

                var result = await _refundRequestService.RejectRefundAsync(id, rejectionReason, cancellationToken);

                TempData[result == "success" ? "Success" : "Error"] =
                    result == "success" ? _localizer["RefundRejectedMsg"].Value : result;
                return RedirectToAction(nameof(Index));
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation cancelled while rejecting refund request {RequestId}", id);
                TempData["Error"] = _localizer["OperationCancelled"].Value;
                return RedirectToAction(nameof(Index));
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while rejecting refund request {RequestId}", id);
                TempData["Error"] = _localizer["ErrorProcessingRefund"].Value;
                return RedirectToAction(nameof(Index));
            }
        }
    }
}

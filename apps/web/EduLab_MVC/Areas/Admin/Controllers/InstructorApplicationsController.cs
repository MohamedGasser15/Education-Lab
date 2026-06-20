using EduLab_MVC.Common;
using EduLab_MVC.Resources;
using EduLab_MVC.Services.ServiceInterfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Localization;

namespace EduLab_MVC.Areas.Admin.Controllers
{
    /// <summary>
    /// Controller for instructor application operations (Admin area)
    /// </summary>
    [Area("Admin")]
    [Authorize(Roles = SD.Admin)]
    public class InstructorApplicationsController : Controller
    {
        private readonly IInstructorApplicationService _applicationService;
        private readonly ILogger<InstructorApplicationsController> _logger;
        private readonly IStringLocalizer<SharedResources> _localizer;

        /// <summary>
        /// Initializes a new instance of the InstructorApplicationsController class
        /// </summary>
        /// <param name="applicationService">Instructor application service</param>
        /// <param name="logger">Logger instance</param>
        public InstructorApplicationsController(
            IInstructorApplicationService applicationService,
            ILogger<InstructorApplicationsController> logger,
            IStringLocalizer<SharedResources> localizer)
        {
            _applicationService = applicationService;
            _logger = logger;
            _localizer = localizer;
        }

        #region Application Management

        /// <summary>
        /// Displays all applications
        /// </summary>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Applications list view</returns>
        public async Task<IActionResult> Index(CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Displaying all applications for admin");

                var applications = await _applicationService.GetAllApplicationsAsync(cancellationToken);
                return View(applications);
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation cancelled while displaying applications for admin");
                return RedirectToAction("Index", "Dashboard");
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while displaying applications for admin");
                return View("Error");
            }
        }

        /// <summary>
        /// Gets application details for admin
        /// </summary>
        /// <param name="id">Application identifier</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>JSON with application details</returns>
        [HttpGet]
        public async Task<IActionResult> GetApplicationDetails(string id, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Getting application details for admin for {ApplicationId}", id);

                var application = await _applicationService.GetApplicationDetailsAdminAsync(id, cancellationToken);
                if (application == null)
                {
                    _logger.LogWarning("Application {ApplicationId} not found", id);
                    return NotFound();
                }

                return Json(new
                {
                    id = application.Id,
                    fullName = application.FullName,
                    email = application.Email,
                    specialization = application.Specialization,
                    experience = application.Experience,
                    skillsList = application.SkillsList,
                    status = application.Status,
                    appliedDate = application.AppliedDate,
                    reviewedBy = application.ReviewedBy,
                    reviewedDate = application.ReviewedDate,
                    cvUrl = application.CvUrl
                });
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation cancelled while getting application details for admin for {ApplicationId}", id);
                return Json(new { error = _localizer["OperationCancelled"] });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while getting application details for admin for {ApplicationId}", id);
                return Json(new { error = _localizer["ApplicationDetailsError"] });
            }
        }

        /// <summary>
        /// Approves an application
        /// </summary>
        /// <param name="id">Application identifier</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Redirect to index view</returns>
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Approve(string id, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Approving application {ApplicationId}", id);

                var result = await _applicationService.ApproveApplicationAsync(id, cancellationToken);

                TempData["Success"] = result;
                return RedirectToAction(nameof(Index));
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation cancelled while approving application {ApplicationId}", id);
                TempData["Error"] = _localizer["OperationCancelled"].Value;
                return RedirectToAction(nameof(Index));
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while approving application {ApplicationId}", id);
                TempData["Error"] = _localizer["ApplicationApprovalError"].Value;
                return RedirectToAction(nameof(Index));
            }
        }

        /// <summary>
        /// Rejects an application
        /// </summary>
        /// <param name="id">Application identifier</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Redirect to index view</returns>
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Reject(string id, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Rejecting application {ApplicationId}", id);

                var result = await _applicationService.RejectApplicationAsync(id, cancellationToken);

                TempData["Success"] = result;
                return RedirectToAction(nameof(Index));
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation cancelled while rejecting application {ApplicationId}", id);
                TempData["Error"] = _localizer["OperationCancelled"].Value;
                return RedirectToAction(nameof(Index));
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while rejecting application {ApplicationId}", id);
                TempData["Error"] = _localizer["ApplicationRejectionError"].Value;
                return RedirectToAction(nameof(Index));
            }
        }

        #endregion
    }
}
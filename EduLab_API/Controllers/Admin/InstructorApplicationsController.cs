using EduLab_Application.ServiceInterfaces;
using EduLab_Domain.Entities;
using EduLab_Shared.DTOs.InstructorApplication;
using EduLab_Shared.Utitlites;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using System;
using System.ComponentModel;
using System.Threading;
using System.Threading.Tasks;

namespace EduLab_API.Controllers.Admin
{
    /// <summary>
    /// API controller for managing instructor applications (Admin)
    /// </summary>
    [Route("api/[controller]")]
    [ApiController]
    [Authorize(Roles = SD.Admin)]
    [Produces("application/json")]
    public class InstructorApplicationsController : ControllerBase
    {
        private readonly IInstructorApplicationService _instructorApplicationService;
        private readonly IHttpContextAccessor _httpContextAccessor;
        private readonly UserManager<ApplicationUser> _userManager;
        private readonly ILogger<InstructorApplicationsController> _logger;

        /// <summary>
        /// Initializes a new instance of the InstructorApplicationsController class
        /// </summary>
        /// <param name="instructorApplicationService">Instructor application service</param>
        /// <param name="httpContextAccessor">HTTP context accessor</param>
        /// <param name="userManager">User manager</param>
        /// <param name="logger">Logger instance</param>
        public InstructorApplicationsController(
            IInstructorApplicationService instructorApplicationService,
            IHttpContextAccessor httpContextAccessor,
            UserManager<ApplicationUser> userManager,
            ILogger<InstructorApplicationsController> logger)
        {
            _instructorApplicationService = instructorApplicationService;
            _httpContextAccessor = httpContextAccessor;
            _userManager = userManager;
            _logger = logger;
        }

        #region GET Operations

        /// <summary>
        /// Gets all instructor applications
        /// </summary>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>List of all applications</returns>
        /// <response code="200">Returns the list of applications</response>
        /// <response code="500">If there was an internal server error</response>
        [HttpGet]
        [ProducesResponseType(typeof(List<AdminInstructorApplicationDto>), 200)]
        [ProducesResponseType(500)]
        public async Task<IActionResult> GetAllApplications(CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Getting all instructor applications");
                var apps = await _instructorApplicationService.GetAllApplicationsForAdmin(cancellationToken);
                return Ok(apps);
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation cancelled while getting all applications");
                return StatusCode(499, "Request cancelled"); // Client closed request
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while getting all applications");
                return StatusCode(500, "حدث خطأ أثناء جلب الطلبات");
            }
        }

        /// <summary>
        /// Gets application details by ID
        /// </summary>
        /// <param name="id">Application identifier</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Application details</returns>
        /// <response code="200">Returns the application details</response>
        /// <response code="404">If the application is not found</response>
        /// <response code="500">If there was an internal server error</response>
        [HttpGet("{id}")]
        [ProducesResponseType(typeof(AdminInstructorApplicationDto), 200)]
        [ProducesResponseType(404)]
        [ProducesResponseType(500)]
        public async Task<IActionResult> GetApplicationDetails(string id, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Getting application details for {ApplicationId}", id);

                var allApps = await _instructorApplicationService.GetAllApplicationsForAdmin(cancellationToken);
                var app = allApps.FirstOrDefault(a => a.Id == id);

                if (app == null)
                {
                    _logger.LogWarning("Application {ApplicationId} not found", id);
                    return NotFound("الطلب غير موجود");
                }

                return Ok(app);
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation cancelled while getting application details for {ApplicationId}", id);
                return StatusCode(499, "Request cancelled");
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while getting application details for {ApplicationId}", id);
                return StatusCode(500, "حدث خطأ أثناء جلب تفاصيل الطلب");
            }
        }

        #endregion

        #region PUT Operations

        /// <summary>
        /// Approves an instructor application
        /// </summary>
        /// <param name="id">Application identifier</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Operation result</returns>
        /// <response code="200">If the application was approved successfully</response>
        /// <response code="400">If the application could not be approved</response>
        /// <response code="500">If there was an internal server error</response>
        [HttpPut("{id}/approve")]
        [ProducesResponseType(200)]
        [ProducesResponseType(400)]
        [ProducesResponseType(500)]
        public async Task<IActionResult> ApproveApplication(string id, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Approving application {ApplicationId}", id);

                var currentUserId = User.FindFirst(System.Security.Claims.ClaimTypes.NameIdentifier)?.Value;

                var result = await _instructorApplicationService.ApproveApplication(
                    id, currentUserId ?? "System", cancellationToken);

                if (!result.Success)
                {
                    _logger.LogWarning("Failed to approve application {ApplicationId}: {Message}", id, result.Message);
                    return BadRequest(result.Message);
                }

                return Ok(result.Message);
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation cancelled while approving application {ApplicationId}", id);
                return StatusCode(499, "Request cancelled");
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while approving application {ApplicationId}", id);
                return StatusCode(500, "حدث خطأ أثناء الموافقة على الطلب");
            }
        }

        /// <summary>
        /// Rejects an instructor application
        /// </summary>
        /// <param name="id">Application identifier</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Operation result</returns>
        /// <response code="200">If the application was rejected successfully</response>
        /// <response code="400">If the application could not be rejected</response>
        /// <response code="500">If there was an internal server error</response>
        [HttpPut("{id}/reject")]
        [ProducesResponseType(200)]
        [ProducesResponseType(400)]
        [ProducesResponseType(500)]
        public async Task<IActionResult> RejectApplication(string id, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Rejecting application {ApplicationId}", id);

                var currentUserId = User.FindFirst(System.Security.Claims.ClaimTypes.NameIdentifier)?.Value;

                var result = await _instructorApplicationService.RejectApplication(
                    id, currentUserId ?? "System", cancellationToken);

                if (!result.Success)
                {
                    _logger.LogWarning("Failed to reject application {ApplicationId}: {Message}", id, result.Message);
                    return BadRequest(result.Message);
                }

                return Ok(result.Message);
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation cancelled while rejecting application {ApplicationId}", id);
                return StatusCode(499, "Request cancelled");
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while rejecting application {ApplicationId}", id);
                return StatusCode(500, "حدث خطأ أثناء رفض الطلب");
            }
        }

        #endregion
    }
}
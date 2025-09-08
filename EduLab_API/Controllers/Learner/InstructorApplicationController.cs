using EduLab_Application.ServiceInterfaces;
using EduLab_Domain.Entities;
using EduLab_Shared.DTOs.Instructor;
using EduLab_Shared.DTOs.InstructorApplication;
using EduLab_Shared.Utitlites;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using System;
using System.ComponentModel;
using System.Security.Claims;
using System.Threading;
using System.Threading.Tasks;

namespace EduLab_API.Controllers.Learner
{
    /// <summary>
    /// API controller for instructor application operations (Learner)
    /// </summary>
    [ApiController]
    [Route("api/[controller]")]
    [Authorize]
    [Produces("application/json")]
    public class InstructorApplicationController : ControllerBase
    {
        private readonly IInstructorApplicationService _applicationService;
        private readonly ICurrentUserService _currentUserService;
        private readonly ILogger<InstructorApplicationController> _logger;

        /// <summary>
        /// Initializes a new instance of the InstructorApplicationController class
        /// </summary>
        /// <param name="applicationService">Instructor application service</param>
        /// <param name="currentUserService">Current user service</param>
        /// <param name="logger">Logger instance</param>
        public InstructorApplicationController(
            IInstructorApplicationService applicationService,
            ICurrentUserService currentUserService,
            ILogger<InstructorApplicationController> logger)
        {
            _applicationService = applicationService;
            _currentUserService = currentUserService;
            _logger = logger;
        }

        #region POST Operations

        /// <summary>
        /// Submits a new instructor application
        /// </summary>
        /// <param name="applicationDto">Application data</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Operation result</returns>
        /// <response code="200">If the application was submitted successfully</response>
        /// <response code="400">If the application could not be submitted</response>
        /// <response code="401">If the user is not authenticated</response>
        /// <response code="500">If there was an internal server error</response>
        [HttpPost("apply")]
        [Authorize(Roles = SD.Student)]
        [Consumes("multipart/form-data")]
        [ProducesResponseType(200)]
        [ProducesResponseType(400)]
        [ProducesResponseType(401)]
        [ProducesResponseType(500)]
        public async Task<IActionResult> Apply([FromForm] InstructorApplicationDTO applicationDto, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Submitting instructor application");

                var userId = await _currentUserService.GetUserIdAsync();
                if (string.IsNullOrEmpty(userId))
                {
                    _logger.LogWarning("User not authenticated while trying to submit application");
                    return Unauthorized(new { message = "المستخدم غير مسجل دخول" });
                }

                var result = await _applicationService.SubmitApplication(applicationDto, userId, cancellationToken);

                if (result.Success)
                {
                    _logger.LogInformation("Application submitted successfully for user {UserId}", userId);
                    return Ok(new { message = result.Message });
                }

                _logger.LogWarning("Failed to submit application for user {UserId}: {Message}", userId, result.Message);
                return BadRequest(new { message = result.Message });
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation cancelled while submitting application");
                return StatusCode(499, "Request cancelled");
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while submitting application");
                return StatusCode(500, new { message = "حدث خطأ غير متوقع أثناء تقديم الطلب" });
            }
        }

        #endregion

        #region GET Operations

        /// <summary>
        /// Gets all applications for the current user
        /// </summary>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>List of user applications</returns>
        /// <response code="200">Returns the list of applications</response>
        /// <response code="401">If the user is not authenticated</response>
        /// <response code="500">If there was an internal server error</response>
        [HttpGet("my-applications")]
        [ProducesResponseType(typeof(List<InstructorApplicationResponseDto>), 200)]
        [ProducesResponseType(401)]
        [ProducesResponseType(500)]
        public async Task<IActionResult> GetMyApplications(CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Getting user applications");

                var userId = await _currentUserService.GetUserIdAsync();
                if (string.IsNullOrEmpty(userId))
                {
                    _logger.LogWarning("User not authenticated while trying to get applications");
                    return Unauthorized();
                }

                var applications = await _applicationService.GetUserApplications(userId, cancellationToken);
                return Ok(applications);
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation cancelled while getting user applications");
                return StatusCode(499, "Request cancelled");
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while getting user applications");
                return StatusCode(500, "حدث خطأ أثناء جلب الطلبات");
            }
        }

        /// <summary>
        /// Gets application details by ID for the current user
        /// </summary>
        /// <param name="id">Application identifier</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Application details</returns>
        /// <response code="200">Returns the application details</response>
        /// <response code="401">If the user is not authenticated</response>
        /// <response code="404">If the application is not found</response>
        /// <response code="500">If there was an internal server error</response>
        [HttpGet("application-details/{id}")]
        [ProducesResponseType(typeof(InstructorApplicationResponseDto), 200)]
        [ProducesResponseType(401)]
        [ProducesResponseType(404)]
        [ProducesResponseType(500)]
        public async Task<IActionResult> GetApplicationDetails(string id, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Getting application details for application {ApplicationId}", id);

                var userId = await _currentUserService.GetUserIdAsync();
                if (string.IsNullOrEmpty(userId))
                {
                    _logger.LogWarning("User not authenticated while trying to get application details");
                    return Unauthorized();
                }

                var application = await _applicationService.GetApplicationDetails(userId, id, cancellationToken);

                if (application == null)
                {
                    _logger.LogWarning("Application {ApplicationId} not found for user {UserId}", id, userId);
                    return NotFound();
                }

                return Ok(application);
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
    }
}
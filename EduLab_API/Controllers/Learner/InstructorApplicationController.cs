using EduLab_Application.ServiceInterfaces;
using EduLab_Domain.Entities;
using EduLab_Shared.DTOs.Instructor;
using EduLab_Shared.Utitlites;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;

namespace EduLab_API.Controllers.Learner
{
    [ApiController]
    [Route("api/[controller]")]
    public class InstructorApplicationController : ControllerBase
    {
        private readonly IInstructorApplicationService _applicationService;
        private readonly ICurrentUserService _currentUserService;
        public InstructorApplicationController(
            IInstructorApplicationService applicationService,
            ICurrentUserService currentUserService)
        {
            _applicationService = applicationService;
            _currentUserService = currentUserService;
        }

        [HttpPost("apply")]
        public async Task<IActionResult> Apply([FromForm] InstructorApplicationDTO applicationDto)
        {
            var userId = await _currentUserService.GetUserIdAsync();
            if (string.IsNullOrEmpty(userId))
                return Unauthorized(new { message = "المستخدم غير مسجل دخول" });

            var result = await _applicationService.SubmitApplication(applicationDto, userId);

            if (result.Success)
                return Ok(new { message = result.Message });

            return BadRequest(new { message = result.Message });
        }


        [HttpGet("my-applications")]
        public async Task<IActionResult> GetMyApplications()
        {
            var userId = await _currentUserService.GetUserIdAsync();
            if (string.IsNullOrEmpty(userId)) return Unauthorized();

            var applications = await _applicationService.GetUserApplications(userId);
            return Ok(applications);
        }

        [HttpGet("application-details/{id}")]
        public async Task<IActionResult> GetApplicationDetails(string id)
        {
            var userId = await _currentUserService.GetUserIdAsync();
            if (string.IsNullOrEmpty(userId)) return Unauthorized();

            var application = await _applicationService.GetApplicationDetails(userId, id);

            if (application == null)
                return NotFound();

            return Ok(application);
        }
        [HttpGet("admin/all-applications")]
        public async Task<IActionResult> GetAllApplications()
        {
            var applications = await _applicationService.GetAllApplicationsForAdmin();
            return Ok(applications);
        }

        [HttpPost("admin/review-application/{id}")]
        public async Task<IActionResult> ReviewApplication(string id, [FromBody] ReviewApplicationRequest request)
        {
            var reviewerId = await _currentUserService.GetUserIdAsync();
            if (string.IsNullOrEmpty(reviewerId)) return Unauthorized();

            var result = await _applicationService.ReviewApplication(id, request.Status, reviewerId);

            if (result)
                return Ok(new { message = "تمت مراجعة الطلب بنجاح" });

            return BadRequest(new { message = "حدث خطأ أثناء مراجعة الطلب" });
        }

        public class ReviewApplicationRequest
        {
            public string Status { get; set; } // "Approved", "Rejected"
        }
    }
}

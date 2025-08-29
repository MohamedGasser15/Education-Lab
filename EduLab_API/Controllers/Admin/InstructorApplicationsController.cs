using EduLab_Application.ServiceInterfaces;
using EduLab_Domain.Entities;
using EduLab_Shared.Utitlites;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;

namespace EduLab_API.Controllers.Admin
{
    [Route("api/[controller]")]
    [ApiController]
    [Authorize(Roles = SD.Admin)]
    public class InstructorApplicationsController : ControllerBase
    {
        private readonly IInstructorApplicationService _instructorApplicationService;
        private readonly IHttpContextAccessor _httpContextAccessor;
        private readonly UserManager<ApplicationUser> _userManager;

        public InstructorApplicationsController(IInstructorApplicationService instructorApplicationService, IHttpContextAccessor httpContextAccessor, UserManager<ApplicationUser> userManager)
        {
            _instructorApplicationService = instructorApplicationService;
            _httpContextAccessor = httpContextAccessor;
            _userManager = userManager;
        }

        // GET: api/admin/instructor-applications
        [HttpGet]
        public async Task<IActionResult> GetAllApplications()
        {
            var apps = await _instructorApplicationService.GetAllApplicationsForAdmin();
            return Ok(apps);
        }

        // GET: api/admin/instructor-applications/{id}
        [HttpGet("{id}")]
        public async Task<IActionResult> GetApplicationDetails(string id)
        {
            var allApps = await _instructorApplicationService.GetAllApplicationsForAdmin();
            var app = allApps.FirstOrDefault(a => a.Id == id);

            if (app == null)
                return NotFound("الطلب غير موجود");

            return Ok(app);
        }

        [HttpPut("{id}/approve")]
        public async Task<IActionResult> ApproveApplication(string id)
        {
            var currentUserId = User.FindFirst(System.Security.Claims.ClaimTypes.NameIdentifier)?.Value;

            var result = await _instructorApplicationService.ApproveApplication(
                id, currentUserId ?? "System");

            if (!result.Success)
                return BadRequest(result.Message);

            return Ok(result.Message);
        }

        [HttpPut("{id}/reject")]
        public async Task<IActionResult> RejectApplication(string id)
        {
            var currentUserId = User.FindFirst(System.Security.Claims.ClaimTypes.NameIdentifier)?.Value;

            var result = await _instructorApplicationService.RejectApplication(
                id, currentUserId ?? "System");

            if (!result.Success)
                return BadRequest(result.Message);

            return Ok(result.Message);
        }
    }
}

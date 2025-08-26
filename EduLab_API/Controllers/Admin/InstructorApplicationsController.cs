using EduLab_Application.ServiceInterfaces;
using EduLab_Domain.Entities;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;

namespace EduLab_API.Controllers.Admin
{
    [Route("api/[controller]")]
    [ApiController]
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
            // نجيب الطلب باستخدام نفس الدالة العادية، بس نشيل شرط الـ userId
            var allApps = await _instructorApplicationService.GetAllApplicationsForAdmin();
            var app = allApps.FirstOrDefault(a => a.Id == id);

            if (app == null)
                return NotFound("الطلب غير موجود");

            return Ok(app);
        }

        // PUT: api/admin/instructor-applications/{id}/approve
        [HttpPut("{id}/approve")]
        public async Task<IActionResult> ApproveApplication(string id)
        {
            var CurrentName = await GetUserFullNameAsync();
            var result = await _instructorApplicationService.ApproveApplication(
                id, CurrentName ?? "System");

            if (!result.Success) return BadRequest(result.Message);
            return Ok(result.Message);
        }

        [HttpPut("{id}/reject")]
        public async Task<IActionResult> RejectApplication(string id)
        {
            var CurrentName = await GetUserFullNameAsync();
            var result = await _instructorApplicationService.RejectApplication(
                id, CurrentName ?? "System");

            if (!result.Success) return BadRequest(result.Message);
            return Ok(result.Message);
        }
        private async Task<string> GetUserFullNameAsync()
        {
            var user = await _userManager.GetUserAsync(_httpContextAccessor.HttpContext?.User);
            return user?.FullName;
        }
    }
}

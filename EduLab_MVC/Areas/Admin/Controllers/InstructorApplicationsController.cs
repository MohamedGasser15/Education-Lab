using EduLab_MVC.Services;
using EduLab_Shared.Utitlites;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace EduLab_MVC.Areas.Admin.Controllers
{
    [Area("Admin")]
    [Authorize(Roles = SD.Admin)]
    public class InstructorApplicationsController : Controller
    {
        private readonly InstructorApplicationService _applicationService;

        public InstructorApplicationsController(InstructorApplicationService applicationService)
        {
            _applicationService = applicationService;
        }

        public async Task<IActionResult> Index()
        {
            var applications = await _applicationService.GetAllApplicationsAsync();
            return View(applications);
        }

        [HttpGet]
        public async Task<IActionResult> GetApplicationDetails(string id)
        {
            var application = await _applicationService.GetApplicationDetailsAdminAsync(id);
            if (application == null)
            {
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
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Approve(string id)
        {
            var result = await _applicationService.ApproveApplicationAsync(id);

                TempData["Success"] = result;
            return RedirectToAction(nameof(Index));
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Reject(string id)
        {
            var result = await _applicationService.RejectApplicationAsync(id);

                TempData["Success"] = result;
            return RedirectToAction(nameof(Index));
        }
    }
}

using EduLab_MVC.Models.DTOs.Auth;
using EduLab_MVC.Models.DTOs.Instructor;
using EduLab_MVC.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.VisualStudio.Web.CodeGenerators.Mvc.Templates.BlazorIdentity.Pages.Manage;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;

namespace EduLab_MVC.Areas.Learner.Controllers
{
    [Authorize]
    [Area("Learner")]
    public class InstructorApplicationController : Controller
    {
        private readonly InstructorApplicationService _applicationService;
        private readonly UserService _userService;
        private readonly ILogger<InstructorApplicationController> _logger;
        private readonly CategoryService _categoryService;
        public InstructorApplicationController(
            InstructorApplicationService applicationService,
            UserService userService,
            ILogger<InstructorApplicationController> logger,
            CategoryService categoryService)
        {
            _applicationService = applicationService;
            _userService = userService;
            _logger = logger;
            _categoryService = categoryService;
        }

        [HttpGet]
        public async Task<IActionResult> Apply()
        {
            // جلب الـ UserId من HttpContext
            var userId = User.FindFirst(JwtRegisteredClaimNames.Sub)?.Value;

            if (string.IsNullOrEmpty(userId))
                return Unauthorized("User ID not found in token");

            var user = await _userService.GetUserByIdAsync(userId);
            if (user == null)
                return Unauthorized();
            var categories = await _categoryService.GetAllCategoriesAsync();

            ViewBag.Categories = categories.Select(c => new SelectListItem
            {
                Value = c.Category_Id.ToString(),
                Text = c.Category_Name
            }).ToList();

            // تجهيز الموديل
            var model = new InstructorApplicationDTO
            {
                FullName = user.FullName ?? "مستخدم",
                Email = user.Email ?? "بريد إلكتروني",
                Phone = user.PhoneNumber,
                Bio = user.About,
                //ProfileImageUrl = user.ProfileImageUrl
            };

            return View(model);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> Apply(InstructorApplicationDTO model)
        {
            try
            {
                if (!ModelState.IsValid)
                {
                    var errors = ModelState.Values
                        .SelectMany(v => v.Errors)
                        .Select(e => e.ErrorMessage)
                        .ToList();

                    TempData["ErrorMessage"] = "بيانات غير صالحة";
                    return Json(new { success = false, message = "بيانات غير صالحة", errors });
                }

                var result = await _applicationService.ApplyAsync(model);

                if (result.Contains("نجاح") || result.Contains("تم"))
                {
                    TempData["SuccessMessage"] = result;
                    return Json(new { success = true, message = result });
                }
                else
                {
                    TempData["ErrorMessage"] = result;
                    return Json(new { success = false, message = result });
                }
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "خطأ أثناء تقديم طلب مدرب");
                TempData["ErrorMessage"] = "حدث خطأ غير متوقع";
                return Json(new { success = false, message = "حدث خطأ غير متوقع" });
            }
        }


        [HttpGet]
        public async Task<IActionResult> MyApplications()
        {
            try
            {
                var applications = await _applicationService.GetMyApplicationsAsync();
                return View(applications ?? new List<InstructorApplicationResponseDto>());
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "خطأ أثناء جلب طلبات المستخدم");
                return View(new List<InstructorApplicationResponseDto>());
            }
        }

        [HttpGet]
        public async Task<IActionResult> ApplicationDetails(string id)
        {
            if (string.IsNullOrEmpty(id))
            {
                return NotFound();
            }

            try
            {
                var application = await _applicationService.GetApplicationDetailsAsync(id);

                if (application == null)
                {
                    return NotFound();
                }

                return View(application);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "خطأ أثناء جلب تفاصيل الطلب");
                return NotFound();
            }
        }

        [HttpGet("CheckForUpdates")]
        public async Task<JsonResult> CheckForUpdates()
        {
            try
            {
                var applications = await _applicationService.GetMyApplicationsAsync();
                var hasUpdates = applications?.Any(a => a.Status != "Pending") ?? false;

                return Json(new { updated = hasUpdates });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "خطأ أثناء التحقق من التحديثات");
                return Json(new { updated = false });
            }
        }

    }
}

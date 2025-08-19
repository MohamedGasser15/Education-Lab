using EduLab_MVC.Models.DTOs.Profile;
using EduLab_MVC.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;
using System.Threading.Tasks;

namespace EduLab_MVC.Areas.Learner.Controllers
{
    [Area("Learner")]
    [Authorize]
    public class ProfileController : Controller
    {
        private readonly ProfileService _profileService;
        private readonly IWebHostEnvironment _webHostEnvironment;
        private readonly IHttpContextAccessor _httpContextAccessor;
        public ProfileController(ProfileService profileService, IWebHostEnvironment webHostEnvironment, IHttpContextAccessor httpContextAccessor)
        {
            _profileService = profileService;
            _webHostEnvironment = webHostEnvironment;
            _httpContextAccessor = httpContextAccessor;
        }

        public async Task<IActionResult> Index()
        {
            var profile = await _profileService.GetProfileAsync();
            if (profile == null)
            {
                // إذا لم يتم تحميل البروفايل، نعيد نموذجًا افتراضيًا
                profile = new ProfileDTO
                {
                    FullName = User.FindFirstValue(ClaimTypes.Name) ?? "مستخدم",
                    Email = User.FindFirstValue(ClaimTypes.Email) ?? "بريد إلكتروني",
                    Title = "طالب في EduLab",
                    Location = "غير محدد",
                    About = "أهلاً بك في ملفي الشخصي. يمكنك تعديل المعلومات من خلال زر تعديل الملف الشخصي.",
                    SocialLinks = new SocialLinksDTO()
                };
            }

            return View(profile);
        }

        [HttpPost]
        public async Task<IActionResult> UpdateProfile(UpdateProfileDTO model)
        {
            if (ModelState.IsValid)
            {
                var success = await _profileService.UpdateProfileAsync(model);
                if (success)
                {
                    TempData["SuccessMessage"] = "تم تحديث الملف الشخصي بنجاح";
                }
                else
                {
                    TempData["ErrorMessage"] = "فشل في تحديث الملف الشخصي";
                }
            }
            else
            {
                TempData["ErrorMessage"] = "البيانات المدخلة غير صحيحة";
            }

            return RedirectToAction(nameof(Index));
        }

        [HttpPost]
        public async Task<IActionResult> UploadImage(IFormFile imageFile)
        {
            if (imageFile == null || imageFile.Length == 0)
            {
                TempData["ErrorMessage"] = "لم تقم باختيار صورة";
                return RedirectToAction(nameof(Index));
            }

            var imageUrl = await _profileService.UploadProfileImageAsync(imageFile);

            if (!string.IsNullOrEmpty(imageUrl))
            {
                TempData["SuccessMessage"] = "تم تحديث الصورة الشخصية بنجاح";
                TempData["NewImageUrl"] = imageUrl;
            }
            else
            {
                TempData["ErrorMessage"] = "فشل في تحميل الصورة";
            }

            return RedirectToAction(nameof(Index));
        }
    }
}
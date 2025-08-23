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
        private readonly CourseService _courseService;
        public ProfileController(ProfileService profileService, IWebHostEnvironment webHostEnvironment, IHttpContextAccessor httpContextAccessor, CourseService courseService)
        {
            _profileService = profileService;
            _webHostEnvironment = webHostEnvironment;
            _httpContextAccessor = httpContextAccessor;
            _courseService = courseService;
        }

        // ================= User =================
        public async Task<IActionResult> Index()
        {
            var profile = await _profileService.GetProfileAsync();
            if (profile == null)
            {
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
                TempData[success ? "SuccessMessage" : "ErrorMessage"] =
                    success ? "تم تحديث الملف الشخصي بنجاح" : "فشل في تحديث الملف الشخصي";
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

        // ================= Instructor =================
        public async Task<IActionResult> Instructor()
        {
            var profile = await _profileService.GetInstructorProfileAsync();
            if (profile == null)
            {
                profile = new InstructorProfileDTO
                {
                    FullName = User.FindFirstValue(ClaimTypes.Name) ?? "مدرب",
                    Email = User.FindFirstValue(ClaimTypes.Email) ?? "بريد إلكتروني",
                    Title = "مدرب في EduLab",
                    Location = "غير محدد",
                    About = "أهلاً بك في ملفك الشخصي كمدرب.",
                    SocialLinks = new SocialLinksDTO(),
                    Subjects = new List<string>(),
                    Certificates = new List<CertificateDTO>()
                };
            }

            // هنا نجيب الكورسات ونحسب العدد
            var courses = await _courseService.GetInstructorCoursesAsync();
            ViewBag.Count = courses?.Count ?? 0;

            return View(profile);
        }


        [HttpPost]
        public async Task<IActionResult> UpdateInstructorProfile(UpdateInstructorProfileDTO model)
        {
            if (ModelState.IsValid)
            {
                var success = await _profileService.UpdateInstructorProfileAsync(model);
                TempData[success ? "SuccessMessage" : "ErrorMessage"] =
                    success ? "تم تحديث ملف المدرب بنجاح" : "فشل في تحديث ملف المدرب";
            }
            else
            {
                TempData["ErrorMessage"] = "البيانات المدخلة غير صحيحة";
            }

            return RedirectToAction(nameof(Instructor));
        }

        [HttpPost]
        public async Task<IActionResult> UploadInstructorImage(IFormFile imageFile)
        {
            if (imageFile == null || imageFile.Length == 0)
            {
                TempData["ErrorMessage"] = "لم تقم باختيار صورة";
                return RedirectToAction(nameof(Instructor));
            }

            var imageUrl = await _profileService.UploadInstructorProfileImageAsync(imageFile);

            if (!string.IsNullOrEmpty(imageUrl))
            {
                TempData["SuccessMessage"] = "تم تحديث صورة المدرب بنجاح";
                TempData["NewImageUrl"] = imageUrl;
            }
            else
            {
                TempData["ErrorMessage"] = "فشل في تحميل صورة المدرب";
            }

            return RedirectToAction(nameof(Instructor));
        }

        // ================= Certificates =================
        [HttpPost]
        public async Task<IActionResult> AddCertificate(CertificateDTO model)
        {
            if (!ModelState.IsValid)
            {
                TempData["ErrorMessage"] = "البيانات المدخلة غير صحيحة";
                return RedirectToAction(nameof(Instructor));
            }

            var addedCert = await _profileService.AddCertificateAsync(model);

            if (addedCert != null)
            {
                TempData["SuccessMessage"] = "تمت إضافة الشهادة بنجاح";
            }
            else
            {
                TempData["ErrorMessage"] = "فشل في إضافة الشهادة";
            }

            return RedirectToAction(nameof(Instructor));
        }

        [HttpPost]
        public async Task<IActionResult> RemoveCertificate(int certId)
        {
            if (certId <= 0)
            {
                TempData["ErrorMessage"] = "الشهادة غير صالحة";
                return RedirectToAction(nameof(Instructor));
            }

            var success = await _profileService.DeleteCertificateAsync(certId);

            if (success)
            {
                TempData["SuccessMessage"] = "تم حذف الشهادة بنجاح";
            }
            else
            {
                TempData["ErrorMessage"] = "فشل في حذف الشهادة";
            }

            return RedirectToAction(nameof(Instructor));
        }

    }
}

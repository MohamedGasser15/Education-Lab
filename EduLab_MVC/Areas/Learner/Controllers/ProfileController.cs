using EduLab_MVC.Models.DTOs.Profile;
using EduLab_MVC.Services;
using EduLab_Shared.Utitlites;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using System;
using System.Security.Claims;
using System.Threading;
using System.Threading.Tasks;

namespace EduLab_MVC.Areas.Learner.Controllers
{
    /// <summary>
    /// Controller for managing user profiles in the Learner area
    /// </summary>
    [Area("Learner")]
    [Authorize]
    public class ProfileController : Controller
    {
        #region Fields
        private readonly ProfileService _profileService;
        private readonly IWebHostEnvironment _webHostEnvironment;
        private readonly IHttpContextAccessor _httpContextAccessor;
        private readonly CourseService _courseService;
        private readonly ILogger<ProfileController> _logger;
        #endregion

        #region Constructor
        /// <summary>
        /// Initializes a new instance of the ProfileController class
        /// </summary>
        /// <param name="profileService">Profile service instance</param>
        /// <param name="webHostEnvironment">Web host environment instance</param>
        /// <param name="httpContextAccessor">HTTP context accessor instance</param>
        /// <param name="courseService">Course service instance</param>
        /// <param name="logger">Logger instance</param>
        public ProfileController(
            ProfileService profileService,
            IWebHostEnvironment webHostEnvironment,
            IHttpContextAccessor httpContextAccessor,
            CourseService courseService,
            ILogger<ProfileController> logger)
        {
            _profileService = profileService ?? throw new ArgumentNullException(nameof(profileService));
            _webHostEnvironment = webHostEnvironment ?? throw new ArgumentNullException(nameof(webHostEnvironment));
            _httpContextAccessor = httpContextAccessor ?? throw new ArgumentNullException(nameof(httpContextAccessor));
            _courseService = courseService ?? throw new ArgumentNullException(nameof(courseService));
            _logger = logger ?? throw new ArgumentNullException(nameof(logger));
        }
        #endregion

        #region User Profile Actions
        /// <summary>
        /// Displays the current user's profile
        /// </summary>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>The profile view</returns>
        public async Task<IActionResult> Index(CancellationToken cancellationToken = default)
        {
            const string operationName = nameof(Index);

            try
            {
                _logger.LogDebug("Starting {OperationName}", operationName);

                var profile = await _profileService.GetProfileAsync(cancellationToken);
                if (profile == null)
                {
                    _logger.LogWarning("Profile not found, creating default profile");

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

                _logger.LogInformation("Successfully loaded profile page");
                return View(profile);
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {OperationName} was cancelled", operationName);
                return RedirectToAction("Index", "Home");
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred in {OperationName}", operationName);
                TempData["ErrorMessage"] = "حدث خطأ أثناء تحميل الملف الشخصي";
                return RedirectToAction("Index", "Home");
            }
        }

        /// <summary>
        /// Displays a public instructor profile
        /// </summary>
        /// <param name="id">The instructor ID</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>The instructor profile view</returns>
        [Route("instructor/{id}")]
        [AllowAnonymous]
        public async Task<IActionResult> InstructorProfile(string id, CancellationToken cancellationToken = default)
        {
            const string operationName = nameof(InstructorProfile);

            try
            {
                _logger.LogDebug("Starting {OperationName} for instructor ID: {InstructorId}", operationName, id);

                if (string.IsNullOrEmpty(id))
                {
                    _logger.LogWarning("Instructor ID is null or empty in {OperationName}", operationName);
                    return RedirectToAction("Index", "Home");
                }

                var profile = await _profileService.GetPublicInstructorProfileAsync(id, cancellationToken);
                if (profile == null)
                {
                    _logger.LogWarning("Instructor profile not found for ID: {InstructorId}", id);
                    return NotFound();
                }

                // Check if the current user is the profile owner
                var currentUserId = GetCurrentUserId();
                ViewBag.IsOwnProfile = (currentUserId == id);

                _logger.LogInformation("Successfully loaded instructor profile for ID: {InstructorId}", id);
                return View(profile);
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {OperationName} was cancelled for instructor ID: {InstructorId}", operationName, id);
                return RedirectToAction("Index", "Home");
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred in {OperationName} for instructor ID: {InstructorId}", operationName, id);
                TempData["ErrorMessage"] = "حدث خطأ أثناء تحميل ملف المدرب";
                return RedirectToAction("Index", "Home");
            }
        }

        /// <summary>
        /// Updates the current user's profile
        /// </summary>
        /// <param name="model">The profile data to update</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>Redirect to profile page</returns>
        [HttpPost]
        public async Task<IActionResult> UpdateProfile(UpdateProfileDTO model, CancellationToken cancellationToken = default)
        {
            const string operationName = nameof(UpdateProfile);

            try
            {
                _logger.LogDebug("Starting {OperationName} for user ID: {UserId}", operationName, model.Id);

                if (ModelState.IsValid)
                {
                    var success = await _profileService.UpdateProfileAsync(model, cancellationToken);
                    TempData["SuccessMessage"] =
                        "تم تحديث الملف الشخصي بنجاح";
                }
                else
                {
                    _logger.LogWarning("Invalid model state in {OperationName}", operationName);
                    TempData["ErrorMessage"] = "البيانات المدخلة غير صحيحة";
                }

                _logger.LogInformation("Completed {OperationName} for user ID: {UserId}", operationName, model.Id);
                return RedirectToAction(nameof(Index));
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {OperationName} was cancelled for user ID: {UserId}", operationName, model.Id);
                TempData["ErrorMessage"] = "تم إلغاء العملية";
                return RedirectToAction(nameof(Index));
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred in {OperationName} for user ID: {UserId}", operationName, model.Id);
                TempData["ErrorMessage"] = "حدث خطأ أثناء تحديث الملف الشخصي";
                return RedirectToAction(nameof(Index));
            }
        }

        /// <summary>
        /// Uploads a profile image for the current user
        /// </summary>
        /// <param name="imageFile">The image file to upload</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>Redirect to profile page</returns>
        [HttpPost]
        public async Task<IActionResult> UploadImage(IFormFile imageFile, CancellationToken cancellationToken = default)
        {
            const string operationName = nameof(UploadImage);

            try
            {
                _logger.LogDebug("Starting {OperationName}", operationName);

                if (imageFile == null || imageFile.Length == 0)
                {
                    _logger.LogWarning("No image file provided in {OperationName}", operationName);
                    TempData["ErrorMessage"] = "لم تقم باختيار صورة";
                    return RedirectToAction(nameof(Index));
                }

                var imageUrl = await _profileService.UploadProfileImageAsync(imageFile, cancellationToken);

                if (!string.IsNullOrEmpty(imageUrl))
                {
                    TempData["SuccessMessage"] = "تم تحديث الصورة الشخصية بنجاح";
                    TempData["NewImageUrl"] = imageUrl;
                }
                else
                {
                    _logger.LogWarning("Failed to upload image in {OperationName}", operationName);
                    TempData["ErrorMessage"] = "فشل في تحميل الصورة";
                }

                _logger.LogInformation("Completed {OperationName}", operationName);
                return RedirectToAction(nameof(Index));
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {OperationName} was cancelled", operationName);
                TempData["ErrorMessage"] = "تم إلغاء العملية";
                return RedirectToAction(nameof(Index));
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred in {OperationName}", operationName);
                TempData["ErrorMessage"] = "حدث خطأ أثناء تحميل الصورة";
                return RedirectToAction(nameof(Index));
            }
        }
        #endregion

        #region Instructor Profile Actions
        /// <summary>
        /// Displays the current instructor's profile
        /// </summary>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>The instructor profile view</returns>
        [Authorize(Roles = SD.Instructor)]
        public async Task<IActionResult> Instructor(CancellationToken cancellationToken = default)
        {
            const string operationName = nameof(Instructor);

            try
            {
                _logger.LogDebug("Starting {OperationName}", operationName);

                var profile = await _profileService.GetInstructorProfileAsync(cancellationToken);
                if (profile == null)
                {
                    _logger.LogWarning("Instructor profile not found, creating default profile");

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

                // Get courses and count them
                var courses = await _courseService.GetInstructorCoursesAsync(cancellationToken);
                ViewBag.Count = courses?.Count ?? 0;

                _logger.LogInformation("Successfully loaded instructor profile");
                return View(profile);
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {OperationName} was cancelled", operationName);
                return RedirectToAction("Index", "Home");
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred in {OperationName}", operationName);
                TempData["ErrorMessage"] = "حدث خطأ أثناء تحميل ملف المدرب";
                return RedirectToAction("Index", "Home");
            }
        }

        /// <summary>
        /// Updates the current instructor's profile
        /// </summary>
        /// <param name="model">The instructor profile data to update</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>JSON result indicating success or failure</returns>
        [HttpPost]
        [Authorize(Roles = SD.Instructor)]
        public async Task<IActionResult> UpdateInstructorProfile(UpdateInstructorProfileDTO model, CancellationToken cancellationToken = default)
        {
            const string operationName = nameof(UpdateInstructorProfile);

            try
            {
                _logger.LogDebug("Starting {OperationName} for user ID: {UserId}", operationName, model.Id);

                if (ModelState.IsValid)
                {
                    var success = await _profileService.UpdateInstructorProfileAsync(model, cancellationToken);

                    _logger.LogInformation("Instructor profile update {Status} for user ID: {UserId}",
                        success ? "succeeded" : "failed", model.Id);
                    TempData["SuccessMessage"] = "تم تحديث الملف الشخصي بنجاح";
                    return Json(new { success, message = success ? "تم تحديث ملف المدرب بنجاح" : "فشل في تحديث ملف المدرب" });
                }
                else
                {
                    _logger.LogWarning("Invalid model state in {OperationName}", operationName);
                    TempData["ErrorMessage"] = "فشل في تحديث الملف الشخصي";
                    return Json(new { success = false, message = "البيانات المدخلة غير صحيحة" });
                }
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {OperationName} was cancelled for user ID: {UserId}", operationName, model.Id);
                return Json(new { success = false, message = "تم إلغاء العملية" });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred in {OperationName} for user ID: {UserId}", operationName, model.Id);
                return Json(new { success = false, message = "حدث خطأ أثناء تحديث ملف المدرب" });
            }
        }

        /// <summary>
        /// Uploads a profile image for the current instructor
        /// </summary>
        /// <param name="imageFile">The image file to upload</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>Redirect to instructor profile page</returns>
        [HttpPost]
        [Authorize(Roles = SD.Instructor)]
        public async Task<IActionResult> UploadInstructorImage(IFormFile imageFile, CancellationToken cancellationToken = default)
        {
            const string operationName = nameof(UploadInstructorImage);

            try
            {
                _logger.LogDebug("Starting {OperationName}", operationName);

                if (imageFile == null || imageFile.Length == 0)
                {
                    _logger.LogWarning("No image file provided in {OperationName}", operationName);
                    TempData["ErrorMessage"] = "لم تقم باختيار صورة";
                    return RedirectToAction(nameof(Instructor));
                }

                var imageUrl = await _profileService.UploadInstructorProfileImageAsync(imageFile, cancellationToken);

                if (!string.IsNullOrEmpty(imageUrl))
                {
                    TempData["SuccessMessage"] = "تم تحديث صورة المدرب بنجاح";
                    TempData["NewImageUrl"] = imageUrl;
                }
                else
                {
                    _logger.LogWarning("Failed to upload instructor image in {OperationName}", operationName);
                    TempData["ErrorMessage"] = "فشل في تحميل صورة المدرب";
                }

                _logger.LogInformation("Completed {OperationName}", operationName);
                return RedirectToAction(nameof(Instructor));
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {OperationName} was cancelled", operationName);
                TempData["ErrorMessage"] = "تم إلغاء العملية";
                return RedirectToAction(nameof(Instructor));
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred in {OperationName}", operationName);
                TempData["ErrorMessage"] = "حدث خطأ أثناء تحميل صورة المدرب";
                return RedirectToAction(nameof(Instructor));
            }
        }
        #endregion

        #region Certificate Actions
        /// <summary>
        /// Adds a new certificate for the current instructor
        /// </summary>
        /// <param name="model">The certificate data</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>Redirect to instructor profile page</returns>
        [HttpPost]
        [Authorize(Roles = SD.Instructor)]
        public async Task<IActionResult> AddCertificate(CertificateDTO model, CancellationToken cancellationToken = default)
        {
            const string operationName = nameof(AddCertificate);

            try
            {
                _logger.LogDebug("Starting {OperationName}", operationName);

                if (!ModelState.IsValid)
                {
                    _logger.LogWarning("Invalid model state in {OperationName}", operationName);
                    TempData["ErrorMessage"] = "البيانات المدخلة غير صحيحة";
                    return RedirectToAction(nameof(Instructor));
                }

                var addedCertificate = await _profileService.AddCertificateAsync(model, cancellationToken);

                if (addedCertificate != null)
                {
                    TempData["SuccessMessage"] = "تمت إضافة الشهادة بنجاح";
                }
                else
                {
                    _logger.LogWarning("Failed to add certificate in {OperationName}", operationName);
                    TempData["ErrorMessage"] = "فشل في إضافة الشهادة";
                }

                _logger.LogInformation("Completed {OperationName}", operationName);
                return RedirectToAction(nameof(Instructor));
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {OperationName} was cancelled", operationName);
                TempData["ErrorMessage"] = "تم إلغاء العملية";
                return RedirectToAction(nameof(Instructor));
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred in {OperationName}", operationName);
                TempData["ErrorMessage"] = "حدث خطأ أثناء إضافة الشهادة";
                return RedirectToAction(nameof(Instructor));
            }
        }

        /// <summary>
        /// Removes a certificate for the current instructor
        /// </summary>
        /// <param name="certId">The certificate ID</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>JSON result indicating success or failure</returns>
        [HttpPost]
        [Authorize(Roles = SD.Instructor)]
        public async Task<IActionResult> RemoveCertificate(int certId, CancellationToken cancellationToken = default)
        {
            const string operationName = nameof(RemoveCertificate);

            try
            {
                _logger.LogDebug("Starting {OperationName} for certificate ID: {CertificateId}", operationName, certId);

                if (certId <= 0)
                {
                    _logger.LogWarning("Invalid certificate ID in {OperationName}: {CertificateId}", operationName, certId);
                    TempData["ErrorMessage"] = "الشهادة غير صالحة";
                    return Json(new { success = false, message = "الشهادة غير صالحة" });
                }

                var success = await _profileService.DeleteCertificateAsync(certId, cancellationToken);

                if (success)
                {
                    TempData["SuccessMessage"] = "تم حذف الشهادة بنجاح";
                }
                else
                {
                    _logger.LogWarning("Failed to delete certificate in {OperationName} for certificate ID: {CertificateId}", operationName, certId);
                    TempData["ErrorMessage"] = "فشل في حذف الشهادة";
                }

                _logger.LogInformation("Completed {OperationName} for certificate ID: {CertificateId}", operationName, certId);
                return Json(new { success, message = success ? "تم حذف الشهادة بنجاح" : "فشل في حذف الشهادة" });
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {OperationName} was cancelled for certificate ID: {CertificateId}", operationName, certId);
                return Json(new { success = false, message = "تم إلغاء العملية" });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred in {OperationName} for certificate ID: {CertificateId}", operationName, certId);
                return Json(new { success = false, message = "حدث خطأ أثناء حذف الشهادة" });
            }
        }
        #endregion

        #region Helper Methods
        /// <summary>
        /// Gets the current user ID from the authentication context
        /// </summary>
        /// <returns>The current user ID if found, otherwise null</returns>
        private string? GetCurrentUserId()
        {
            try
            {
                var user = _httpContextAccessor.HttpContext?.User;
                if (user == null)
                {
                    _logger.LogWarning("User not found in HTTP context");
                    return null;
                }

                // Try NameIdentifier first
                var userId = user.FindFirst(ClaimTypes.NameIdentifier)?.Value;

                // Fallback if not found
                if (string.IsNullOrEmpty(userId))
                {
                    userId = user.FindFirst("sub")?.Value ?? user.FindFirst("id")?.Value;
                }

                return userId;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while getting current user ID");
                return null;
            }
        }
        #endregion
    }
}
using EduLab_MVC.Models.DTOs.Instructor;
using EduLab_MVC.Services;
using EduLab_Shared.Utitlites;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.IdentityModel.Tokens.Jwt;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;

namespace EduLab_MVC.Areas.Learner.Controllers
{
    /// <summary>
    /// Controller for instructor application operations (Learner area)
    /// </summary>
    [Area("Learner")]
    [Authorize]
    public class InstructorApplicationController : Controller
    {
        private readonly InstructorApplicationService _applicationService;
        private readonly UserService _userService;
        private readonly ILogger<InstructorApplicationController> _logger;
        private readonly CategoryService _categoryService;

        /// <summary>
        /// Initializes a new instance of the InstructorApplicationController class
        /// </summary>
        /// <param name="applicationService">Instructor application service</param>
        /// <param name="userService">User service</param>
        /// <param name="logger">Logger instance</param>
        /// <param name="categoryService">Category service</param>
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

        #region Application Submission

        /// <summary>
        /// Displays the application form
        /// </summary>
        /// <returns>Application form view</returns>
        [HttpGet]
        [Authorize(Roles = SD.Student)]
        public async Task<IActionResult> Apply(CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Displaying application form");

                var userId = User.FindFirst(JwtRegisteredClaimNames.Sub)?.Value;

                if (string.IsNullOrEmpty(userId))
                {
                    _logger.LogWarning("User ID not found in token");
                    return Unauthorized("User ID not found in token");
                }

                var user = await _userService.GetUserByIdAsync(userId);
                if (user == null)
                {
                    _logger.LogWarning("User {UserId} not found", userId);
                    return Unauthorized();
                }

                var categories = await _categoryService.GetAllCategoriesAsync(cancellationToken);

                ViewBag.Categories = categories.Select(c => new SelectListItem
                {
                    Value = c.Category_Id.ToString(),
                    Text = c.Category_Name
                }).ToList();

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
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation cancelled while displaying application form");
                return RedirectToAction("Index", "Home");
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while displaying application form");
                return View("Error");
            }
        }

        /// <summary>
        /// Submits the application form
        /// </summary>
        /// <param name="model">Application data</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>JSON result of the operation</returns>
        [HttpPost]
        [ValidateAntiForgeryToken]
        [Authorize(Roles = SD.Student)]
        public async Task<JsonResult> Apply(InstructorApplicationDTO model, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Submitting application form");

                if (!ModelState.IsValid)
                {
                    var errors = ModelState.Values
                        .SelectMany(v => v.Errors)
                        .Select(e => e.ErrorMessage)
                        .ToList();

                    TempData["ErrorMessage"] = "بيانات غير صالحة";
                    return Json(new { success = false, message = "بيانات غير صالحة", errors });
                }

                var result = await _applicationService.ApplyAsync(model, cancellationToken);

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
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation cancelled while submitting application");
                return Json(new { success = false, message = "تم إلغاء العملية" });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "خطأ أثناء تقديم طلب مدرب");
                TempData["ErrorMessage"] = "حدث خطأ غير متوقع";
                return Json(new { success = false, message = "حدث خطأ غير متوقع" });
            }
        }

        #endregion

        #region Application Management

        /// <summary>
        /// Displays user's applications
        /// </summary>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Applications list view</returns>
        [HttpGet]
        public async Task<IActionResult> MyApplications(CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Displaying user applications");

                var applications = await _applicationService.GetMyApplicationsAsync(cancellationToken);
                return View(applications ?? new List<InstructorApplicationResponseDto>());
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation cancelled while displaying user applications");
                return RedirectToAction("Index", "Home");
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "خطأ أثناء جلب طلبات المستخدم");
                return View(new List<InstructorApplicationResponseDto>());
            }
        }

        /// <summary>
        /// Displays application details
        /// </summary>
        /// <param name="id">Application identifier</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Application details view</returns>
        [HttpGet]
        public async Task<IActionResult> ApplicationDetails(string id, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Displaying application details for {ApplicationId}", id);

                if (string.IsNullOrEmpty(id))
                {
                    _logger.LogWarning("Application ID is null or empty");
                    return NotFound();
                }

                var application = await _applicationService.GetApplicationDetailsAsync(id, cancellationToken);

                if (application == null)
                {
                    _logger.LogWarning("Application {ApplicationId} not found", id);
                    return NotFound();
                }

                return View(application);
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation cancelled while displaying application details for {ApplicationId}", id);
                return RedirectToAction("MyApplications");
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "خطأ أثناء جلب تفاصيل الطلب");
                return NotFound();
            }
        }

        /// <summary>
        /// Checks for application updates
        /// </summary>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>JSON indicating if updates are available</returns>
        [HttpGet("CheckForUpdates")]
        public async Task<JsonResult> CheckForUpdates(CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogDebug("Checking for application updates");

                var applications = await _applicationService.GetMyApplicationsAsync(cancellationToken);
                var hasUpdates = applications?.Any(a => a.Status != "Pending") ?? false;

                return Json(new { updated = hasUpdates });
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation cancelled while checking for updates");
                return Json(new { updated = false });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "خطأ أثناء التحقق من التحديثات");
                return Json(new { updated = false });
            }
        }

        #endregion
    }
}
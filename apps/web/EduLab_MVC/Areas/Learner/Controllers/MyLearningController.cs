using EduLab_MVC.Models.DTOs.Certificates;
using EduLab_MVC.Models.DTOs.Enrollment;
using EduLab_MVC.Models.DTOs.Wishlist;
using EduLab_MVC.Models.ViewModels;
using EduLab_MVC.Resources;
using EduLab_MVC.Services.ServiceInterfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Localization;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;

namespace EduLab_MVC.Areas.Learner.Controllers
{
    [Area("Learner")]
    [Authorize]
    public class MyLearningController : Controller
    {
        private readonly IEnrollmentService _enrollmentService;
        private readonly IWishlistService _wishlistService;
        private readonly ICourseProgressService _courseProgressService;
        private readonly ICertificateService _certificateService;
        private readonly ILogger<MyLearningController> _logger;
        private readonly IStringLocalizer<SharedResources> _localizer;

        public MyLearningController(
            IEnrollmentService enrollmentService,
            IWishlistService wishlistService,
            ICourseProgressService courseProgressService,
            ICertificateService certificateService,
            ILogger<MyLearningController> logger,
            IStringLocalizer<SharedResources> localizer)
        {
            _enrollmentService = enrollmentService ?? throw new ArgumentNullException(nameof(enrollmentService));
            _wishlistService = wishlistService ?? throw new ArgumentNullException(nameof(wishlistService));
            _courseProgressService = courseProgressService ?? throw new ArgumentNullException(nameof(courseProgressService));
            _certificateService = certificateService ?? throw new ArgumentNullException(nameof(certificateService));
            _logger = logger ?? throw new ArgumentNullException(nameof(logger));
            _localizer = localizer ?? throw new ArgumentNullException(nameof(localizer));
        }

        [HttpGet]
        public async Task<IActionResult> Index(string tab = null, CancellationToken cancellationToken = default)
        {
            ViewBag.ActiveTab = tab ?? "all";
            try
            {
                _logger.LogInformation("Loading My Learning page");

                var enrollments = new List<EnrollmentDto>();
                var wishlistItems = new List<WishlistItemDto>();
                var courseProgressDict = new Dictionary<int, decimal>();
                var categories = new HashSet<string>();
                var instructors = new HashSet<string>();
                int totalHours = 0;
                int completedCourses = 0;

                try
                {
                    enrollments = (await _enrollmentService.GetUserEnrollmentsAsync(cancellationToken)).ToList();

                    foreach (var enrollment in enrollments)
                    {
                        if (string.IsNullOrEmpty(enrollment.ThumbnailUrl))
                            enrollment.ThumbnailUrl = "/images/default-course.jpg";
                        if (string.IsNullOrEmpty(enrollment.ProfileImageUrl))
                            enrollment.ProfileImageUrl = "/images/default-instructor.jpg";

                        var progress = await _courseProgressService.GetCourseProgressAsync(enrollment.CourseId);
                        var pct = progress?.ProgressPercentage ?? 0;
                        courseProgressDict[enrollment.CourseId] = pct;

                        if (!string.IsNullOrEmpty(enrollment.CategoryName))
                            categories.Add(enrollment.CategoryName);
                        if (!string.IsNullOrEmpty(enrollment.InstructorName))
                            instructors.Add(enrollment.InstructorName);

                        totalHours += (int)Math.Ceiling(enrollment.Duration / 3600.0);
                        if (pct >= 100) completedCourses++;
                    }
                }
                catch (Exception ex)
                {
                    _logger.LogWarning(ex, "Could not load enrollments");
                }

                try
                {
                    wishlistItems = await _wishlistService.GetUserWishlistAsync(cancellationToken);
                }
                catch (Exception ex)
                {
                    _logger.LogWarning(ex, "Could not load wishlist");
                }

                var certificates = new List<CertificateDto>();
                try
                {
                    certificates = await _certificateService.GetMyCertificatesAsync(cancellationToken);
                }
                catch (Exception ex)
                {
                    _logger.LogWarning(ex, "Could not load certificates");
                }

                var vm = new MyLearningViewModel
                {
                    Enrollments = enrollments,
                    WishlistItems = wishlistItems,
                    Certificates = certificates,
                    CertificateEnrollmentIds = certificates.Select(c => c.EnrollmentId).ToList(),
                    CourseProgress = courseProgressDict,
                    TotalCourses = enrollments.Count,
                    CompletedCourses = completedCourses,
                    InProgressCourses = enrollments.Count - completedCourses,
                    TotalHours = totalHours,
                    Categories = categories.OrderBy(c => c).ToList(),
                    Instructors = instructors.OrderBy(i => i).ToList()
                };

                return View(vm);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error loading My Learning page");
                return View(new MyLearningViewModel());
            }
        }
    }
}

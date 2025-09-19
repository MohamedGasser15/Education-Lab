using EduLab_MVC.Models.DTOs.Enrollment;
using EduLab_MVC.Services.ServiceInterfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;

namespace EduLab_MVC.Controllers
{
    [Area("Learner")]
    [Authorize]
    public class EnrollmentController : Controller
    {
        private readonly IEnrollmentService _enrollmentService;
        private readonly ILogger<EnrollmentController> _logger;

        public EnrollmentController(
            IEnrollmentService enrollmentService,
            ILogger<EnrollmentController> logger)
        {
            _enrollmentService = enrollmentService ?? throw new ArgumentNullException(nameof(enrollmentService));
            _logger = logger ?? throw new ArgumentNullException(nameof(logger));
        }

        [HttpGet]
        public async Task<IActionResult> Index(CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Loading enrollments page");

                var enrollments = await _enrollmentService.GetUserEnrollmentsAsync(cancellationToken);
                return View(enrollments);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error loading enrollments page");
                return View(new List<EnrollmentDto>());
            }
        }

        [HttpGet("Details/{enrollmentId:int}")]
        public async Task<IActionResult> Details(int enrollmentId, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Loading enrollment details for ID: {EnrollmentId}", enrollmentId);

                var enrollment = await _enrollmentService.GetEnrollmentByIdAsync(enrollmentId, cancellationToken);
                if (enrollment == null)
                {
                    return NotFound();
                }

                return View(enrollment);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error loading enrollment details for ID: {EnrollmentId}", enrollmentId);
                return RedirectToAction(nameof(Index));
            }
        }

        [HttpPost("Enroll/{courseId:int}")]
        public async Task<IActionResult> Enroll(int courseId, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Enrolling in course ID: {CourseId}", courseId);

                var enrollment = await _enrollmentService.EnrollInCourseAsync(courseId, cancellationToken);
                if (enrollment != null)
                {
                    TempData["SuccessMessage"] = "تم التسجيل في الكورس بنجاح";
                    return RedirectToAction(nameof(Index));
                }

                TempData["ErrorMessage"] = "فشل في التسجيل في الكورس";
                return RedirectToAction("Details", "Course", new { id = courseId });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error enrolling in course ID: {CourseId}", courseId);
                TempData["ErrorMessage"] = "حدث خطأ أثناء التسجيل في الكورس";
                return RedirectToAction("Details", "Course", new { id = courseId });
            }
        }

        [HttpPost("Unenroll/{enrollmentId:int}")]
        public async Task<IActionResult> Unenroll(int enrollmentId, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Unenrolling from enrollment ID: {EnrollmentId}", enrollmentId);

                var success = await _enrollmentService.UnenrollAsync(enrollmentId, cancellationToken);
                if (success)
                {
                    TempData["SuccessMessage"] = "تم إلغاء التسجيل بنجاح";
                }
                else
                {
                    TempData["ErrorMessage"] = "فشل في إلغاء التسجيل";
                }

                return RedirectToAction(nameof(Index));
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error unenrolling from enrollment ID: {EnrollmentId}", enrollmentId);
                TempData["ErrorMessage"] = "حدث خطأ أثناء إلغاء التسجيل";
                return RedirectToAction(nameof(Index));
            }
        }

        [HttpGet("Check/{courseId:int}")]
        public async Task<JsonResult> CheckEnrollment(int courseId, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Checking enrollment for course ID: {CourseId}", courseId);

                var isEnrolled = await _enrollmentService.CheckEnrollmentAsync(courseId, cancellationToken);
                return Json(new { isEnrolled });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error checking enrollment for course ID: {CourseId}", courseId);
                return Json(new { isEnrolled = false });
            }
        }

        [HttpGet("Count")]
        public async Task<JsonResult> GetEnrollmentsCount(CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Getting enrollments count");

                var count = await _enrollmentService.GetEnrollmentsCountAsync(cancellationToken);
                return Json(new { count });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting enrollments count");
                return Json(new { count = 0 });
            }
        }
    }
}
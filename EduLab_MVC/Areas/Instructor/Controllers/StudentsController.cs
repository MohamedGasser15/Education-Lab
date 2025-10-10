using EduLab_MVC.Models.DTOs.Notifications;
using EduLab_MVC.Models.DTOs.Student;
using EduLab_MVC.Services.ServiceInterfaces;
using EduLab_Shared.Utitlites;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;

namespace EduLab_MVC.Controllers.Instructor
{
    [Authorize(Roles = SD.Instructor)]
    [Area("Instructor")]
    public class StudentsController : Controller
    {
        private readonly IStudentService _studentService;
        private readonly ILogger<StudentsController> _logger;

        public StudentsController(
            IStudentService studentService,
            ILogger<StudentsController> logger)
        {
            _studentService = studentService;
            _logger = logger;
        }

        [HttpGet]
        public async Task<IActionResult> Index()
        {
            try
            {
                var students = await _studentService.GetMyStudentsAsync();
                var summary = await _studentService.GetStudentsSummaryAsync();

                ViewBag.StudentsSummary = summary;

                return View(students);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error loading students page");
                return View(new List<StudentDto>());
            }
        }

        [HttpGet("Instructor/Students/details/{studentId}")]
        public async Task<IActionResult> StudentDetails(string studentId)
        {
            try
            {
                var studentDetails = await _studentService.GetStudentDetailsAsync(studentId);

                if (studentDetails == null)
                {
                    return NotFound(new { success = false, message = "الطالب غير موجود" });
                }

                // رجّع البيانات في JSON
                return Json(new { success = true, data = studentDetails });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error loading student details for: {StudentId}", studentId);
                return StatusCode(500, new { success = false, message = "حدث خطأ أثناء تحميل بيانات الطالب" });
            }
        }


        [HttpPost("Instructor/Students/send-notification")]
        public async Task<IActionResult> SendNotification([FromBody] InstructorNotificationRequestDto request)
        {
            try
            {
                _logger.LogInformation("Sending notification to students");

                var result = await _studentService.SendNotificationAsync(request);

                if (result.IsSuccess)
                {
                    return Json(new { success = true, message = "تم إرسال الإشعار بنجاح", data = result });
                }
                else
                {
                    return Json(new { success = false, message = "فشل في إرسال الإشعار", errors = result.Errors });
                }
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error sending notification");
                return Json(new { success = false, message = "حدث خطأ أثناء إرسال الإشعار" });
            }
        }

        [HttpGet("Instructor/Students/get-students-for-notification")]
        public async Task<IActionResult> GetStudentsForNotification([FromQuery] List<string> selectedStudentIds = null)
        {
            try
            {
                _logger.LogInformation("Getting students for notification");

                var students = await _studentService.GetStudentsForNotificationAsync(selectedStudentIds);

                return Json(new { success = true, data = students });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting students for notification");
                return Json(new { success = false, message = "حدث خطأ أثناء جلب بيانات الطلاب" });
            }
        }

        [HttpGet("get-notification-summary")]
        public async Task<IActionResult> GetNotificationSummary([FromQuery] List<string> selectedStudentIds = null)
        {
            try
            {
                _logger.LogInformation("Getting notification summary");

                var summary = await _studentService.GetNotificationSummaryAsync(selectedStudentIds);

                return Json(new { success = true, data = summary });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting notification summary");
                return Json(new { success = false, message = "حدث خطأ أثناء جلب ملخص الإشعار" });
            }
        }
    }
}
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


        [HttpPost("bulk-message")]
        public async Task<IActionResult> SendBulkMessage([FromBody] BulkMessageDto messageDto)
        {
            try
            {
                var result = await _studentService.SendBulkMessageAsync(messageDto);

                if (result)
                {
                    return Json(new { success = true, message = "تم إرسال الرسالة بنجاح" });
                }
                else
                {
                    return Json(new { success = false, message = "فشل في إرسال الرسالة" });
                }
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error sending bulk message");
                return Json(new { success = false, message = "حدث خطأ أثناء إرسال الرسالة" });
            }
        }
    }
}
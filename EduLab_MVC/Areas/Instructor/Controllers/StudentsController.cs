using EduLab_MVC.Models.DTOs.Notifications;
using EduLab_MVC.Models.DTOs.Student;
using EduLab_MVC.Services.ServiceInterfaces;
using EduLab_Shared.Utitlites;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;

namespace EduLab_MVC.Controllers.Instructor
{
    #region Students Controller
    /// <summary>
    /// MVC Controller for managing student-related operations in the Instructor area
    /// Handles student data display, notifications, and administrative functions
    /// </summary>
    [Authorize(Roles = SD.Instructor)]
    [Area("Instructor")]
    public class StudentsController : Controller
    {
        #region Private Fields
        /// <summary>
        /// Student service for handling business logic and data operations
        /// </summary>
        private readonly IStudentService _studentService;

        /// <summary>
        /// Logger instance for recording controller operations and errors
        /// </summary>
        private readonly ILogger<StudentsController> _logger;
        #endregion

        #region Constructor
        /// <summary>
        /// Initializes a new instance of the StudentsController class
        /// </summary>
        /// <param name="studentService">The student service for business operations</param>
        /// <param name="logger">The logger for recording operations and errors</param>
        /// <exception cref="ArgumentNullException">Thrown when studentService or logger is null</exception>
        public StudentsController(
            IStudentService studentService,
            ILogger<StudentsController> logger)
        {
            _studentService = studentService ?? throw new ArgumentNullException(nameof(studentService));
            _logger = logger ?? throw new ArgumentNullException(nameof(logger));
        }
        #endregion

        #region Student Management Actions
        /// <summary>
        /// Displays the main students index page with student list and summary
        /// </summary>
        /// <returns>
        /// IActionResult representing the students index view with student data and summary
        /// </returns>
        /// <remarks>
        /// This is the main entry point for the students management interface
        /// </remarks>
        [HttpGet]
        public async Task<IActionResult> Index()
        {
            const string operationName = "StudentsIndex";

            try
            {
                _logger.LogInformation("Starting {OperationName} for instructor", operationName);

                // Retrieve students and summary data in parallel for better performance
                var studentsTask = _studentService.GetMyStudentsAsync();
                var summaryTask = _studentService.GetStudentsSummaryAsync();

                await Task.WhenAll(studentsTask, summaryTask);

                var students = studentsTask.Result;
                var summary = summaryTask.Result;

                ViewBag.StudentsSummary = summary;

                _logger.LogInformation("Successfully loaded {Count} students and summary in {OperationName}",
                    students.Count, operationName);

                return View(students);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred in {OperationName}", operationName);

                // Return empty list to prevent view errors while maintaining user experience
                return View(new List<StudentDto>());
            }
        }

        /// <summary>
        /// Retrieves detailed information for a specific student as JSON data
        /// </summary>
        /// <param name="studentId">The unique identifier of the student</param>
        /// <returns>
        /// JSON result containing student details or error information
        /// </returns>
        /// <remarks>
        /// This endpoint is typically called via AJAX for modal displays or detail panels
        /// </remarks>
        [HttpGet("Instructor/Students/details/{studentId}")]
        public async Task<IActionResult> StudentDetails(string studentId)
        {
            const string operationName = "StudentDetails";

            try
            {
                _logger.LogInformation("Starting {OperationName} for student: {StudentId}",
                    operationName, studentId);

                if (string.IsNullOrWhiteSpace(studentId))
                {
                    _logger.LogWarning("Invalid student ID provided in {OperationName}", operationName);
                    return NotFound(new { success = false, message = "معرف الطالب غير صالح" });
                }

                var studentDetails = await _studentService.GetStudentDetailsAsync(studentId);

                if (studentDetails == null)
                {
                    _logger.LogWarning("Student not found with ID: {StudentId} in {OperationName}",
                        studentId, operationName);
                    return NotFound(new { success = false, message = "الطالب غير موجود" });
                }

                _logger.LogInformation("Successfully retrieved student details for: {StudentId} in {OperationName}",
                    studentId, operationName);

                return Json(new { success = true, data = studentDetails });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred in {OperationName} for student: {StudentId}",
                    operationName, studentId);
                return StatusCode(500, new { success = false, message = "حدث خطأ أثناء تحميل بيانات الطالب" });
            }
        }
        #endregion

        #region Notification Management Actions
        /// <summary>
        /// Sends notifications to students based on the provided request data
        /// </summary>
        /// <param name="request">The notification request containing message and recipient information</param>
        /// <returns>
        /// JSON result indicating the success or failure of the notification operation
        /// </returns>
        /// <remarks>
        /// This endpoint handles both in-app notifications and potential email notifications
        /// </remarks>
        [HttpPost("Instructor/Students/send-notification")]
        public async Task<IActionResult> SendNotification([FromBody] InstructorNotificationRequestDto request)
        {
            const string operationName = "SendNotification";

            try
            {
                _logger.LogInformation("Starting {OperationName}", operationName);

                if (request == null)
                {
                    _logger.LogWarning("Null request received in {OperationName}", operationName);
                    return Json(new { success = false, message = "طلب الإشعار غير صالح" });
                }

                var result = await _studentService.SendNotificationAsync(request);

                if (result.IsSuccess)
                {
                    _logger.LogInformation("Successfully completed {OperationName}", operationName);
                    return Json(new { success = true, message = "تم إرسال الإشعار بنجاح", data = result });
                }
                else
                {
                    _logger.LogWarning("Failed to send notification in {OperationName}. Errors: {Errors}",
                        operationName, string.Join(", ", result.Errors ?? new List<string>()));
                    return Json(new { success = false, message = "فشل في إرسال الإشعار", errors = result.Errors });
                }
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred in {OperationName}", operationName);
                return Json(new { success = false, message = "حدث خطأ أثناء إرسال الإشعار" });
            }
        }

        /// <summary>
        /// Retrieves students for notification purposes with optional pre-selection
        /// </summary>
        /// <param name="selectedStudentIds">Optional list of student IDs to mark as selected</param>
        /// <returns>
        /// JSON result containing the list of students available for notifications
        /// </returns>
        /// <remarks>
        /// This endpoint is used to populate student selection interfaces for notifications
        /// </remarks>
        [HttpGet("Instructor/Students/get-students-for-notification")]
        public async Task<IActionResult> GetStudentsForNotification([FromQuery] List<string> selectedStudentIds = null)
        {
            const string operationName = "GetStudentsForNotification";

            try
            {
                _logger.LogInformation("Starting {OperationName} with {Count} pre-selected students",
                    operationName, selectedStudentIds?.Count ?? 0);

                var students = await _studentService.GetStudentsForNotificationAsync(selectedStudentIds);

                _logger.LogInformation("Successfully retrieved {Count} students for notification in {OperationName}",
                    students.Count, operationName);

                return Json(new { success = true, data = students });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred in {OperationName}", operationName);
                return Json(new { success = false, message = "حدث خطأ أثناء جلب بيانات الطلاب" });
            }
        }

        /// <summary>
        /// Retrieves summary information for notification operations
        /// </summary>
        /// <param name="selectedStudentIds">Optional list of selected student IDs for summary calculation</param>
        /// <returns>
        /// JSON result containing notification summary statistics
        /// </returns>
        /// <remarks>
        /// This endpoint provides data for notification summary displays and confirmation dialogs
        /// </remarks>
        [HttpGet("get-notification-summary")]
        public async Task<IActionResult> GetNotificationSummary([FromQuery] List<string> selectedStudentIds = null)
        {
            const string operationName = "GetNotificationSummary";

            try
            {
                _logger.LogInformation("Starting {OperationName} with {Count} selected students",
                    operationName, selectedStudentIds?.Count ?? 0);

                var summary = await _studentService.GetNotificationSummaryAsync(selectedStudentIds);

                _logger.LogInformation("Successfully retrieved notification summary in {OperationName}", operationName);

                return Json(new { success = true, data = summary });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred in {OperationName}", operationName);
                return Json(new { success = false, message = "حدث خطأ أثناء جلب ملخص الإشعار" });
            }
        }
        #endregion
    }
    #endregion
}
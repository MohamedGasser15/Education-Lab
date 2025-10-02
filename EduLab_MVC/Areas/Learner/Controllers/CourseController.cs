using EduLab_MVC.Models.DTOs.Course;
using EduLab_MVC.Services.ServiceInterfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace EduLab_MVC.Areas.Learner.Controllers
{
    /// <summary>
    /// Controller for managing course operations in learner area
    /// </summary>
    [Area("Learner")]
    public class CourseController : Controller
    {
        #region Dependencies

        private readonly ICourseService _courseService;
        private readonly ICategoryService _categoryService;
        private readonly ILogger<CourseController> _logger;
        private readonly IEnrollmentService _enrollmentService;
        private readonly ICartService _cartService;
        private readonly ICourseProgressService _courseProgressService; // أضف هذا

        #endregion

        #region Constructor

        /// <summary>
        /// Initializes a new instance of the CourseController class
        /// </summary>
        public CourseController(
            ICourseService courseService,
            ICategoryService categoryService,
            ILogger<CourseController> logger,
            IEnrollmentService enrollmentService,
            ICartService cartService,
            ICourseProgressService courseProgressService) // أضف هذا
        {
            _courseService = courseService;
            _categoryService = categoryService;
            _logger = logger;
            _enrollmentService = enrollmentService;
            _cartService = cartService;
            _courseProgressService = courseProgressService; // أضف هذا
        }

        #endregion

        #region Public Actions

        /// <summary>
        /// GET: Index - Displays all approved courses by categories
        /// </summary>
        /// <returns>Courses index view</returns>
        public async Task<IActionResult> Index()
        {
            try
            {
                _logger.LogInformation("Loading learner courses index page");

                var categories = await _categoryService.GetAllCategoriesAsync();
                ViewBag.Categories = categories;

                var categoryIds = categories.Select(c => c.Category_Id).ToList();
                var allCourses = await _courseService.GetApprovedCoursesByCategoriesAsync(categoryIds, 8);

                _logger.LogInformation("Loaded {CourseCount} courses for {CategoryCount} categories",
                    allCourses?.Count ?? 0, categoryIds.Count);

                return View(allCourses);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error loading learner courses index");
                TempData["Error"] = "حدث خطأ أثناء تحميل الدورات";
                return View(new List<CourseDTO>());
            }
        }

        /// <summary>
        /// GET: ByCategory - Displays approved courses by specific category
        /// </summary>
        /// <param name="id">Category ID</param>
        /// <returns>Courses by category view</returns>
        public async Task<IActionResult> ByCategory(int id)
        {
            try
            {
                _logger.LogInformation("Loading courses for category ID: {CategoryId}", id);

                var categories = await _categoryService.GetAllCategoriesAsync();
                ViewBag.Categories = categories;
                ViewBag.CategoryId = id;

                var courses = await _courseService.GetApprovedCoursesByCategoryAsync(id, int.MaxValue);

                _logger.LogInformation("Loaded {CourseCount} courses for category ID: {CategoryId}",
                    courses?.Count ?? 0, id);

                return View("Index", courses);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error loading courses for category ID: {CategoryId}", id);
                TempData["Error"] = "حدث خطأ أثناء تحميل دورات التصنيف";
                return RedirectToAction(nameof(Index));
            }
        }

        /// <summary>
        /// GET: Details - Displays course details
        /// </summary>
        /// <param name="id">Course ID</param>
        /// <returns>Course details view</returns>
        public async Task<IActionResult> Details(int id)
        {
            try
            {
                _logger.LogInformation("Loading course details for ID: {CourseId}", id);

                var course = await _courseService.GetCourseByIdAsync(id);
                if (course == null)
                {
                    _logger.LogWarning("Course not found for details. ID: {CourseId}", id);
                    return NotFound();
                }

                await LoadCourseDetailsViewData(course);

                ViewBag.IsUserEnrolled = await IsUserEnrolled(id);
                ViewBag.IsCourseInCart = await IsCourseInCart(id);

                _logger.LogInformation("Course details loaded successfully. ID: {CourseId}", id);
                return View(course);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error loading course details for ID: {CourseId}", id);
                TempData["Error"] = "حدث خطأ أثناء تحميل تفاصيل الدورة";
                return RedirectToAction(nameof(Index));
            }
        }

        #endregion

        #region Learner-Only Actions

[Authorize]
public async Task<IActionResult> Learn(int id)
{
    try
    {
        // التأكد من أن المستخدم مسجل في الكورس
        var isEnrolled = await _enrollmentService.IsUserEnrolledInCourseAsync(id);
        if (!isEnrolled)
        {
            TempData["Error"] = "يجب عليك التسجيل في هذه الدورة أولاً";
            return RedirectToAction("Details", new { id });
        }

        var course = await _courseService.GetCourseByIdAsync(id);
        if (course == null)
        {
            return NotFound();
        }
        
        // الحصول على تقدم المستخدم في الكورس
        var enrollment = await _enrollmentService.GetUserCourseEnrollmentAsync(id);
        var progressSummary = await _courseProgressService.GetCourseProgressAsync(id);

        ViewBag.ProgressPercentage = progressSummary?.ProgressPercentage ?? 0;
        ViewBag.ProgressSummary = progressSummary;

        // جلب جميع محاضرات الكورس وحالتها
        var allLectureIds = new List<int>();
        if (course.Sections != null)
        {
            foreach (var section in course.Sections)
            {
                if (section.Lectures != null)
                {
                    allLectureIds.AddRange(section.Lectures.Select(l => l.Id));
                }
            }
        }

        // جلب حالة إكمال كل محاضرة
        var lectureStatuses = await _courseProgressService.GetLecturesStatusAsync(id, allLectureIds);

        ViewBag.LectureStatuses = lectureStatuses;
        ViewBag.CompletedLectures = progressSummary?.CompletedLectures ?? 0;
        ViewBag.TotalLectures = progressSummary?.TotalLectures ?? 0;

        return View(course);
    }
    catch (Exception ex)
    {
        _logger.LogError(ex, "Error loading learn page for course {CourseId}", id);
        TempData["Error"] = "حدث خطأ أثناء تحميل صفحة التعلم";
        return RedirectToAction("Details", new { id });
    }
}

        [HttpGet]
        [Authorize]
        public async Task<IActionResult> GetLectureData(int courseId, int lectureId)
        {
            try
            {
                var course = await _courseService.GetCourseByIdAsync(courseId);
                if (course == null)
                {
                    return NotFound(new { success = false, message = "الكورس غير موجود" });
                }

                var lecture = course.Sections?
                    .SelectMany(s => s.Lectures)
                    .FirstOrDefault(l => l.Id == lectureId);

                if (lecture == null)
                {
                    return NotFound(new { success = false, message = "المحاضرة غير موجودة" });
                }

                // جلب الموارد الخاصة بالمحاضرة
                var resources = await _courseService.GetLectureResourcesAsync(lectureId);

                // جلب حالة إكمال المحاضرة
                var isCompleted = await _courseProgressService.GetLectureStatusAsync(courseId, lectureId);

                return Ok(new
                {
                    success = true,
                    lecture = new
                    {
                        lecture.Id,
                        lecture.Title,
                        lecture.Description,
                        lecture.VideoUrl,
                        lecture.Duration,
                        lecture.ContentType,
                        Resources = resources,
                        IsCompleted = isCompleted
                    }
                });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting lecture data for lecture {LectureId}", lectureId);
                return StatusCode(500, new { success = false, message = "حدث خطأ أثناء جلب بيانات المحاضرة" });
            }
        }

        // حفظ تقدم المستخدم
        [HttpPost]
        [Authorize]
        public async Task<IActionResult> SaveProgress([FromBody] SaveProgressRequest request)
        {
            try
            {
                if (!ModelState.IsValid)
                {
                    _logger.LogWarning("Invalid model state in SaveProgress: {@Errors}",
                        ModelState.Values.SelectMany(v => v.Errors));
                    return BadRequest(new { success = false, message = "بيانات غير صالحة" });
                }

                _logger.LogInformation("SaveProgress - CourseId: {CourseId}, LectureId: {LectureId}, IsCompleted: {IsCompleted}",
                    request.CourseId, request.LectureId, request.IsCompleted);

                bool result;
                if (request.IsCompleted)
                {
                    result = await _courseProgressService.MarkLectureAsCompletedAsync(request.CourseId, request.LectureId);
                }
                else
                {
                    result = await _courseProgressService.MarkLectureAsIncompleteAsync(request.CourseId, request.LectureId);
                }

                if (result)
                {
                    _logger.LogInformation("Progress saved successfully - Course: {CourseId}, Lecture: {LectureId}, Completed: {IsCompleted}",
                        request.CourseId, request.LectureId, request.IsCompleted);

                    // جلب التحديث الأخير للتقدم
                    var progressSummary = await _courseProgressService.GetCourseProgressAsync(request.CourseId);

                    return Ok(new
                    {
                        success = true,
                        message = "تم حفظ التقدم بنجاح",
                        progressPercentage = progressSummary?.ProgressPercentage ?? 0,
                        completedLectures = progressSummary?.CompletedLectures ?? 0
                    });
                }

                _logger.LogWarning("Failed to save progress for lecture {LectureId}", request.LectureId);
                return BadRequest(new { success = false, message = "فشل في حفظ التقدم" });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error saving progress for lecture {LectureId}", request?.LectureId);
                return StatusCode(500, new { success = false, message = "حدث خطأ أثناء حفظ التقدم" });
            }
        }

        // أضف هذا DTO داخل الـ Controller
        public class SaveProgressRequest
        {
            public int CourseId { get; set; }
            public int LectureId { get; set; }
            public bool IsCompleted { get; set; }
        }

        [HttpGet]
        [Authorize]
        public async Task<IActionResult> GetCourseProgress(int courseId)
        {
            try
            {
                var progressSummary = await _courseProgressService.GetCourseProgressAsync(courseId);
                if (progressSummary == null)
                {
                    return NotFound(new { success = false, message = "لا يوجد تقدم مسجل لهذه الدورة" });
                }

                return Ok(new
                {
                    success = true,
                    progress = progressSummary
                });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting course progress for course {CourseId}", courseId);
                return StatusCode(500, new { success = false, message = "حدث خطأ أثناء جلب بيانات التقدم" });
            }
        }

        [HttpGet]
        [Authorize]
        public async Task<IActionResult> GetLectureStatus(int courseId, int lectureId)
        {
            try
            {
                var isCompleted = await _courseProgressService.GetLectureStatusAsync(courseId, lectureId);
                return Ok(new
                {
                    success = true,
                    isCompleted
                });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting lecture status for lecture {LectureId}", lectureId);
                return Ok(new { success = true, isCompleted = false });
            }
        }

        [HttpPost]
        [Authorize]
        public async Task<IActionResult> ToggleLectureCompletion([FromBody] ToggleLectureRequest request)
        {
            try
            {
                if (!ModelState.IsValid)
                {
                    _logger.LogWarning("Invalid model state: {@Errors}", ModelState.Values.SelectMany(v => v.Errors));
                    return BadRequest(new { success = false, message = "بيانات غير صالحة" });
                }

                _logger.LogInformation("ToggleLectureCompletion - CourseId: {CourseId}, LectureId: {LectureId}",
                    request.CourseId, request.LectureId);

                var currentStatus = await _courseProgressService.GetLectureStatusAsync(request.CourseId, request.LectureId);

                bool result;
                if (currentStatus)
                {
                    result = await _courseProgressService.MarkLectureAsIncompleteAsync(request.CourseId, request.LectureId);
                }
                else
                {
                    result = await _courseProgressService.MarkLectureAsCompletedAsync(request.CourseId, request.LectureId);
                }

                if (result)
                {
                    var progressSummary = await _courseProgressService.GetCourseProgressAsync(request.CourseId);
                    var newStatus = !currentStatus;

                    _logger.LogInformation("Successfully toggled lecture {LectureId} to {Status}",
                        request.LectureId, newStatus ? "completed" : "incomplete");

                    return Ok(new
                    {
                        success = true,
                        isCompleted = newStatus,
                        progressPercentage = progressSummary?.ProgressPercentage ?? 0,
                        completedLectures = progressSummary?.CompletedLectures ?? 0
                    });
                }

                _logger.LogWarning("Failed to toggle lecture {LectureId}", request.LectureId);
                return BadRequest(new { success = false, message = "فشل في تحديث حالة المحاضرة" });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error toggling lecture completion for lecture {LectureId}", request.LectureId);
                return StatusCode(500, new { success = false, message = "حدث خطأ أثناء تحديث حالة المحاضرة" });
            }
        }

        public class ToggleLectureRequest
        {
            public int CourseId { get; set; }
            public int LectureId { get; set; }
        }

        #endregion

        #region Private Helper Methods

        /// <summary>
        /// Loads view data for course details page
        /// </summary>
        /// <param name="course">Course object</param>
        private async Task LoadCourseDetailsViewData(CourseDTO course)
        {
            try
            {
                // Load instructor courses
                var instructorCourses = await _courseService.GetApprovedCoursesByInstructorAsync(course.InstructorId, 4);
                ProcessInstructorCourses(instructorCourses, course);

                // Load similar courses
                var similarCourses = await _courseService.GetApprovedCoursesByCategoryAsync(course.CategoryId, 4);
                ViewBag.SimilarCourses = similarCourses?.Where(c => c.Id != course.Id).Take(3).ToList();

                ViewBag.InstructorCourses = instructorCourses;
                ViewBag.Count = instructorCourses?.Count ?? 0;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error loading course details view data for course ID: {CourseId}", course.Id);
                // Set default values to avoid null reference exceptions
                ViewBag.SimilarCourses = new List<CourseDTO>();
                ViewBag.InstructorCourses = new List<CourseDTO>();
                ViewBag.Count = 0;
            }
        }

        private async Task<bool> IsUserEnrolled(int courseId)
        {
            if (!User.Identity.IsAuthenticated) return false;

            try
            {
                return await _enrollmentService.IsUserEnrolledInCourseAsync(courseId);
            }
            catch
            {
                return false;
            }
        }

        private async Task<bool> IsCourseInCart(int courseId)
        {
            if (!User.Identity.IsAuthenticated) return false;

            try
            {
                return await _cartService.IsCourseInCartAsync(courseId);
            }
            catch
            {
                return false;
            }
        }

        /// <summary>
        /// Processes instructor courses data
        /// </summary>
        /// <param name="instructorCourses">List of instructor courses</param>
        /// <param name="mainCourse">Main course object for reference</param>
        private void ProcessInstructorCourses(List<CourseDTO> instructorCourses, CourseDTO mainCourse)
        {
            if (instructorCourses == null) return;

            foreach (var course in instructorCourses)
            {
                // Fix thumbnail URL if needed
                if (!string.IsNullOrEmpty(course.ThumbnailUrl) && !course.ThumbnailUrl.StartsWith("http"))
                {
                    course.ThumbnailUrl = $"https://localhost:7292{course.ThumbnailUrl}";
                }

                // Set instructor name if missing
                if (string.IsNullOrEmpty(course.InstructorName))
                {
                    course.InstructorName = mainCourse.InstructorName;
                }
            }
        }

        #endregion
    }
}
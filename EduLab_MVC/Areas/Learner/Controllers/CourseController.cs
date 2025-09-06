using EduLab_MVC.Models.DTOs.Course;
using EduLab_MVC.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;

namespace EduLab_MVC.Areas.Learner.Controllers
{
    /// <summary>
    /// Controller for managing course operations in learner area
    /// </summary>
    [Area("Learner")]
    [AllowAnonymous]
    public class CourseController : Controller
    {
        #region Dependencies

        private readonly CourseService _courseService;
        private readonly CategoryService _categoryService;
        private readonly ILogger<CourseController> _logger;

        #endregion

        #region Constructor

        /// <summary>
        /// Initializes a new instance of the CourseController class
        /// </summary>
        public CourseController(
            CourseService courseService,
            CategoryService categoryService,
            ILogger<CourseController> logger)
        {
            _courseService = courseService;
            _categoryService = categoryService;
            _logger = logger;
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
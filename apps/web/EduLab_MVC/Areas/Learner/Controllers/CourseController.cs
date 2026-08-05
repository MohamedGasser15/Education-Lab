using EduLab_MVC.Common;
using EduLab_MVC.Models.DTOs.Category;
using EduLab_MVC.Models.DTOs.Course;
using EduLab_MVC.Models.DTOs.CourseProgress;
using EduLab_MVC.Resources;
using EduLab_MVC.Services.ServiceInterfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Caching.Memory;
using Microsoft.Extensions.Localization;
using System.Globalization;

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
        private readonly ICourseProgressService _courseProgressService;
        private readonly IStringLocalizer<SharedResources> _localizer;
        private readonly IMemoryCache _cache;

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
            ICourseProgressService courseProgressService,
            IStringLocalizer<SharedResources> localizer,
            IMemoryCache cache)
        {
            _courseService = courseService;
            _categoryService = categoryService;
            _logger = logger;
            _enrollmentService = enrollmentService;
            _cartService = cartService;
            _courseProgressService = courseProgressService;
            _localizer = localizer;
            _cache = cache;
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

                var allApproved = await GetCachedApprovedCoursesAsync(CancellationToken.None);
                ViewBag.TotalCourses = allApproved.Count;

                var allCourses = allApproved
                    .GroupBy(c => c.CategoryId)
                    .SelectMany(g => g.Take(8))
                    .ToList();

                _logger.LogInformation("Loaded {CourseCount} courses for {CategoryCount} categories",
                    allCourses?.Count ?? 0, allApproved.GroupBy(c => c.CategoryId).Count());

                return View(allCourses);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error loading learner courses index");
                TempData["Error"] = _localizer["ErrorLoadingCourses"].Value;
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

                var allApproved = await GetCachedApprovedCoursesAsync(CancellationToken.None);
                ViewBag.TotalCourses = allApproved.Count;

                var courses = await _courseService.GetApprovedCoursesByCategoryAsync(id, int.MaxValue);

                _logger.LogInformation("Loaded {CourseCount} courses for category ID: {CategoryId}",
                    courses?.Count ?? 0, id);

                return View("Index", courses);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error loading courses for category ID: {CategoryId}", id);
                TempData["Error"] = _localizer["ErrorLoadingCategoryCourses"].Value;
                return RedirectToAction(nameof(Index));
            }
        }

        /// <summary>
        /// GET: Search - Dedicated search results page
        /// </summary>
        /// <param name="search">Search term</param>
        /// <param name="page">Page number</param>
        /// <returns>Search results view</returns>
        public async Task<IActionResult> Search(string search, int page = 1,
            string language = "", string rating = "", string duration = "",
            string categories = "", string level = "", string price = "",
            string certificate = "", string sort = "")
        {
            try
            {
                if (string.IsNullOrWhiteSpace(search))
                    return RedirectToAction(nameof(Index));

                var query = search.Trim().ToLower();
                var allApproved = await GetCachedApprovedCoursesAsync(CancellationToken.None);

                // --- Filter options (from static sources, not DB distinct) ---
                var isAr = CultureInfo.CurrentUICulture.Name.StartsWith("ar");
                ViewBag.AllLanguages = LanguageData.GetAll().Select(l => l.Code).ToList();
                ViewBag.AllLevels     = LevelData.Levels.Select(l => l.Code).ToList();
                ViewBag.LanguageNames = LanguageData.GetAll().ToDictionary(l => l.Code, l => isAr ? l.ArabicName : l.EnglishName);
                ViewBag.LevelNames    = LevelData.Levels.ToDictionary(l => l.Code, l => isAr ? l.ArabicName : l.EnglishName);
                ViewBag.AllCategories = allApproved.Where(c => !string.IsNullOrEmpty(c.CategoryName))
                    .GroupBy(c => c.CategoryId)
                    .Select(g => new CategoryDTO
                    {
                        Category_Id = g.Key,
                        Category_Name = g.First().CategoryName,
                        Category_EnglishName = g.First().CategoryEnglishName
                    })
                    .OrderBy(c => c.Category_Name)
                    .ToList();

                // --- Text search ---
                var results = allApproved.Where(c =>
                        (c.Title?.ToLower().Contains(query) ?? false) ||
                        (c.ShortDescription?.ToLower().Contains(query) ?? false) ||
                        (c.Description?.ToLower().Contains(query) ?? false) ||
                        (c.InstructorName?.ToLower().Contains(query) ?? false) ||
                        (c.CategoryName?.ToLower().Contains(query) ?? false) ||
                        (c.CategoryEnglishName?.ToLower().Contains(query) ?? false))
                    .ToList();

                // --- Filter: Language (multi) ---
                var langs = ParseCsvFilter(language);
                if (langs.Length > 0)
                    results = results.Where(c => !string.IsNullOrEmpty(c.Language) && langs.Contains(c.Language, StringComparer.OrdinalIgnoreCase)).ToList();

                // --- Filter: Rating ---
                if (!string.IsNullOrWhiteSpace(rating) && double.TryParse(rating, out var minRating))
                    results = results.Where(c => c.AverageRating >= minRating).ToList();

                // --- Filter: Duration ---
                if (!string.IsNullOrWhiteSpace(duration))
                {
                    results = duration switch
                    {
                        "0-1" => results.Where(c => c.Duration <= 3600).ToList(),
                        "1-3" => results.Where(c => c.Duration > 3600 && c.Duration <= 10800).ToList(),
                        "3-6" => results.Where(c => c.Duration > 10800 && c.Duration <= 21600).ToList(),
                        "6-17" => results.Where(c => c.Duration > 21600 && c.Duration <= 61200).ToList(),
                        "17+" => results.Where(c => c.Duration > 61200).ToList(),
                        _ => results
                    };
                }

                // --- Filter: Categories (multi) ---
                var catIds = ParseCsvFilter(categories).Select(s => int.TryParse(s, out var id) ? id : 0).Where(id => id > 0).ToArray();
                if (catIds.Length > 0)
                    results = results.Where(c => catIds.Contains(c.CategoryId)).ToList();

                // --- Filter: Level (multi) ---
                var levels = ParseCsvFilter(level);
                if (levels.Length > 0)
                    results = results.Where(c => !string.IsNullOrEmpty(c.Level) && levels.Contains(c.Level, StringComparer.OrdinalIgnoreCase)).ToList();

                // --- Filter: Price ---
                if (!string.IsNullOrWhiteSpace(price))
                {
                    results = price switch
                    {
                        "free" => results.Where(c => c.Price <= 0).ToList(),
                        "under50" => results.Where(c => c.Price > 0 && c.Price < 50).ToList(),
                        "50to200" => results.Where(c => c.Price >= 50 && c.Price <= 200).ToList(),
                        "200to500" => results.Where(c => c.Price > 200 && c.Price <= 500).ToList(),
                        "500plus" => results.Where(c => c.Price > 500).ToList(),
                        _ => results
                    };
                }

                // --- Filter: Certificate ---
                if (!string.IsNullOrWhiteSpace(certificate) && certificate.Equals("true", StringComparison.OrdinalIgnoreCase))
                    results = results.Where(c => c.HasCertificate).ToList();

                // --- Sort ---
                results = sort switch
                {
                    "highest_rated" => results.OrderByDescending(c => c.AverageRating).ToList(),
                    "most_reviewed" => results.OrderByDescending(c => c.TotalRatings).ToList(),
                    "newest" => results.OrderByDescending(c => c.CreatedAt).ToList(),
                    _ => results
                };

                const int pageSize = 12;
                var totalPages = Math.Max(1, (int)Math.Ceiling(results.Count / (double)pageSize));
                if (page < 1) page = 1;
                if (page > totalPages) page = totalPages;

                ViewBag.Search = search.Trim();
                ViewBag.LanguageFilter = language;
                ViewBag.RatingFilter = rating;
                ViewBag.DurationFilter = duration;
                ViewBag.CategoriesFilter = categories;
                ViewBag.LevelFilter = level;
                ViewBag.PriceFilter = price;
                ViewBag.CertificateFilter = certificate;
                ViewBag.SortFilter = sort;
                ViewBag.TotalResults = results.Count;
                ViewBag.TotalPages = totalPages;
                ViewBag.CurrentPage = page;

                _logger.LogInformation("Search '{Search}' returned {CourseCount} courses after filters", search, results.Count);
                return View(results.Skip((page - 1) * pageSize).Take(pageSize).ToList());
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error performing course search");
                TempData["Error"] = _localizer["ErrorLoadingCourses"].Value;
                return View(new List<CourseDTO>());
            }
        }

        private static string[] ParseCsvFilter(string input)
        {
            return !string.IsNullOrWhiteSpace(input) ? input.Split(',', StringSplitOptions.RemoveEmptyEntries).Select(s => s.Trim()).Where(s => s.Length > 0).ToArray() : Array.Empty<string>();
        }

        /// <summary>
        /// GET: Suggest - Live search suggestions for the navbar search
        /// </summary>
        /// <param name="term">Partial course title</param>
        /// <returns>JSON list of matching courses</returns>
        [HttpGet]
        public async Task<IActionResult> Suggest(string term, CancellationToken cancellationToken = default)
        {
            if (string.IsNullOrWhiteSpace(term) || term.Trim().Length < 2)
                return Json(new List<object>());

            try
            {
                var query = term.Trim().ToLower();
                var isArabic = System.Globalization.CultureInfo.CurrentUICulture.Name.StartsWith("ar");

                var courses = await GetCachedApprovedCoursesAsync(cancellationToken);

                var categories = await _cache.GetOrCreateAsync("Learner_Categories_Suggest", async entry =>
                {
                    entry.AbsoluteExpirationRelativeToNow = TimeSpan.FromMinutes(5);
                    return await _categoryService.GetAllCategoriesAsync(cancellationToken);
                });

                var categoryResults = categories?
                    .Where(cat =>
                        (!string.IsNullOrEmpty(cat.Category_Name) && cat.Category_Name.ToLower().Contains(query)) ||
                        (!string.IsNullOrEmpty(cat.Category_EnglishName) && cat.Category_EnglishName.ToLower().Contains(query)))
                    .Take(4)
                    .Select(cat => (object)new
                    {
                        type = "category",
                        title = isArabic ? cat.Category_Name : (cat.Category_EnglishName ?? cat.Category_Name),
                        subtitle = isArabic ? (cat.Category_EnglishName ?? "") : (cat.Category_Name ?? ""),
                        category = _localizer["CategoriesLabel"].Value,
                        thumb = "",
                        url = Url.Action("ByCategory", new { id = cat.Category_Id })
                    })
                    .ToList() ?? new List<object>();

                var instructorResults = courses?
                    .Where(c => !string.IsNullOrEmpty(c.InstructorName) && c.InstructorName.ToLower().Contains(query))
                    .GroupBy(c => c.InstructorId)
                    .Select(g => g.First())
                    .Take(3)
                    .Select(c => (object)new
                    {
                        type = "instructor",
                        title = c.InstructorName,
                        subtitle = c.InstructorTitle ?? "",
                        category = _localizer["InstructorLabel"].Value,
                        thumb = c.ProfileImageUrl,
                        url = Url.Action("InstructorProfile", "Profile", new { area = "Learner", id = c.InstructorId })
                    })
                    .ToList() ?? new List<object>();

                var courseResults = courses?
                    .Where(c => !string.IsNullOrEmpty(c.Title) && c.Title.ToLower().Contains(query))
                    .OrderByDescending(c => c.Title.StartsWith(query, StringComparison.OrdinalIgnoreCase))
                    .ThenBy(c => c.Title)
                    .Take(8)
                    .Select(c => (object)new
                    {
                        type = "course",
                        title = c.Title,
                        subtitle = c.InstructorName,
                        category = isArabic ? c.CategoryName : (c.CategoryEnglishName ?? c.CategoryName),
                        thumb = c.ThumbnailUrl,
                        url = Url.Action("Details", new { id = c.Id })
                    })
                    .ToList() ?? new List<object>();

                return Json(instructorResults.Concat(categoryResults).Concat(courseResults).ToList());
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error generating search suggestions for term: {Term}", term);
                return Json(new List<object>());
            }
        }

        /// <summary>
        /// Gets all approved courses with an in-memory cache (10 min)
        /// </summary>
        private async Task<List<CourseDTO>> GetCachedApprovedCoursesAsync(CancellationToken cancellationToken)
        {
            return await _cache.GetOrCreateAsync("Learner_ApprovedCourses_Suggest", async entry =>
            {
                entry.AbsoluteExpirationRelativeToNow = TimeSpan.FromMinutes(10);
                var categories = await _categoryService.GetAllCategoriesAsync(cancellationToken);
                var categoryIds = categories.Select(c => c.Category_Id).ToList();
                return await _courseService.GetApprovedCoursesByCategoriesAsync(categoryIds, int.MaxValue, cancellationToken);
            }) ?? new List<CourseDTO>();
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
                TempData["Error"] = _localizer["ErrorLoadingCourseDetails"].Value;
                return RedirectToAction(nameof(Index));
            }
        }

        #endregion

        #region Learner-Only Actions

        /// <summary>
        /// Handles course learning page access and progress tracking
        /// </summary>
        /// <param name="id">Course identifier</param>
        /// <returns>Course learning view with progress data</returns>
        [Authorize]
        public async Task<IActionResult> Learn(int id)
        {
            try
            {
                // Validate user enrollment in the course
                var isEnrolled = await _enrollmentService.IsUserEnrolledInCourseAsync(id);
                if (!isEnrolled)
                {
                    TempData["Error"] = "You must enroll in this course first";
                    return RedirectToAction("Details", new { id });
                }

                var course = await _courseService.GetCourseByIdAsync(id);
                if (course == null)
                {
                    return NotFound();
                }

                // Get user progress in the course
                var enrollment = await _enrollmentService.GetUserCourseEnrollmentAsync(id);
                var progressSummary = await _courseProgressService.GetCourseProgressAsync(id);

                ViewBag.ProgressPercentage = progressSummary?.ProgressPercentage ?? 0;
                ViewBag.ProgressSummary = progressSummary;

                // Retrieve all course lectures and their status
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

                // Get completion status for each lecture
                var lectureStatuses = await _courseProgressService.GetLecturesStatusAsync(id, allLectureIds);

                ViewBag.LectureStatuses = lectureStatuses;
                ViewBag.CompletedLectures = progressSummary?.CompletedLectures ?? 0;
                ViewBag.TotalLectures = progressSummary?.TotalLectures ?? 0;

                return View(course);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error loading learn page for course {CourseId}", id);
                TempData["Error"] = "An error occurred while loading the learning page";
                return RedirectToAction("Details", new { id });
            }
        }

        /// <summary>
        /// Retrieves detailed data for a specific lecture
        /// </summary>
        /// <param name="courseId">Course identifier</param>
        /// <param name="lectureId">Lecture identifier</param>
        /// <returns>Lecture data with resources and completion status</returns>
        [HttpGet]
        [Authorize]
        public async Task<IActionResult> GetLectureData(int courseId, int lectureId)
        {
            try
            {
                var course = await _courseService.GetCourseByIdAsync(courseId);
                if (course == null)
                {
                    return NotFound(new { success = false, message = "Course not found" });
                }

                var lecture = course.Sections?
                    .SelectMany(s => s.Lectures)
                    .FirstOrDefault(l => l.Id == lectureId);

                if (lecture == null)
                {
                    return NotFound(new { success = false, message = "Lecture not found" });
                }

                // Get lecture resources
                var resources = await _courseService.GetLectureResourcesAsync(lectureId);

                // Get lecture completion status
                var isCompleted = await _courseProgressService.GetLectureStatusAsync(courseId, lectureId);

                return Ok(new
                {
                    success = true,
                    lecture = new
                    {
                        lecture.Id,
                        lecture.Title,
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
                return StatusCode(500, new { success = false, message = "An error occurred while retrieving lecture data" });
            }
        }

        /// <summary>
        /// Saves user progress for a specific lecture
        /// </summary>
        /// <param name="request">Progress data containing course ID, lecture ID, and completion status</param>
        /// <returns>Operation result with updated progress information</returns>
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
                    return BadRequest(new { success = false, message = "Invalid data" });
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
                    // Don't mark as incomplete if already completed (user rewatching)
                    var currentStatus = await _courseProgressService.GetLectureStatusAsync(request.CourseId, request.LectureId);
                    if (currentStatus)
                    {
                        _logger.LogInformation("Lecture {LectureId} is already completed, skipping mark as incomplete",
                            request.LectureId);
                        var progressSummary = await _courseProgressService.GetCourseProgressAsync(request.CourseId);
                        return Ok(new
                        {
                            success = true,
                            message = "Progress saved",
                            progressPercentage = progressSummary?.ProgressPercentage ?? 0,
                            completedLectures = progressSummary?.CompletedLectures ?? 0
                        });
                    }
                    result = await _courseProgressService.MarkLectureAsIncompleteAsync(request.CourseId, request.LectureId);
                }

                if (result)
                {
                    _logger.LogInformation("Progress saved successfully - Course: {CourseId}, Lecture: {LectureId}, Completed: {IsCompleted}",
                        request.CourseId, request.LectureId, request.IsCompleted);

                    // Get updated progress summary
                    var progressSummary = await _courseProgressService.GetCourseProgressAsync(request.CourseId);

                    return Ok(new
                    {
                        success = true,
                        message = "Progress saved successfully",
                        progressPercentage = progressSummary?.ProgressPercentage ?? 0,
                        completedLectures = progressSummary?.CompletedLectures ?? 0
                    });
                }

                _logger.LogWarning("Failed to save progress for lecture {LectureId}", request.LectureId);
                return BadRequest(new { success = false, message = "Failed to save progress" });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error saving progress for lecture {LectureId}", request?.LectureId);
                return StatusCode(500, new { success = false, message = "An error occurred while saving progress" });
            }
        }
        /// <summary>
        /// Retrieves overall course progress for the current user
        /// </summary>
        /// <param name="courseId">Course identifier</param>
        /// <returns>Course progress summary</returns>
        [HttpGet]
        [Authorize]
        public async Task<IActionResult> GetCourseProgress(int courseId)
        {
            try
            {
                var progressSummary = await _courseProgressService.GetCourseProgressAsync(courseId);
                if (progressSummary == null)
                {
                    return NotFound(new { success = false, message = "No progress recorded for this course" });
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
                return StatusCode(500, new { success = false, message = "An error occurred while retrieving progress data" });
            }
        }

        /// <summary>
        /// Gets completion status for a specific lecture
        /// </summary>
        /// <param name="courseId">Course identifier</param>
        /// <param name="lectureId">Lecture identifier</param>
        /// <returns>Lecture completion status</returns>
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

        /// <summary>
        /// Toggles lecture completion status between completed and incomplete
        /// </summary>
        /// <param name="request">Toggle request containing course and lecture identifiers</param>
        /// <returns>Updated completion status and progress information</returns>
        [HttpPost]
        [Authorize]
        public async Task<IActionResult> ToggleLectureCompletion([FromBody] ToggleLectureRequest request)
        {
            try
            {
                if (!ModelState.IsValid)
                {
                    _logger.LogWarning("Invalid model state: {@Errors}", ModelState.Values.SelectMany(v => v.Errors));
                    return BadRequest(new { success = false, message = "Invalid data" });
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
                return BadRequest(new { success = false, message = "Failed to update lecture status" });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error toggling lecture completion for lecture {LectureId}", request.LectureId);
                return StatusCode(500, new { success = false, message = "An error occurred while updating lecture status" });
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
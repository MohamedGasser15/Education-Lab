using EduLab_MVC.Models.DTOs.Course;
using EduLab_MVC.Services.ServiceInterfaces;
using EduLab_Shared.Utitlites;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using System.Text.Json;

namespace EduLab_MVC.Areas.Admin.Controllers
{
    /// <summary>
    /// Controller for managing courses in admin area
    /// </summary>
    [Area("Admin")]
    [Authorize(Roles = SD.Admin)]
    public class CourseController : Controller
    {
        private readonly ICourseService _courseService;
        private readonly ICategoryService _categoryService;
        private readonly IUserService _userService;
        private readonly ILogger<CourseController> _logger;
        private readonly IWebHostEnvironment _webHostEnvironment;

        /// <summary>
        /// Initializes a new instance of the CourseController class
        /// </summary>
        public CourseController(
            ICourseService courseService,
            ILogger<CourseController> logger,
            IWebHostEnvironment webHostEnvironment,
            ICategoryService categoryService,
            IUserService userService)
        {
            _courseService = courseService;
            _categoryService = categoryService;
            _userService = userService;
            _logger = logger;
            _webHostEnvironment = webHostEnvironment;
        }

        #region View Actions

        /// <summary>
        /// Displays the main courses index page
        /// </summary>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Courses index view</returns>
        public async Task<IActionResult> Index(CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Loading courses index page");

                var courses = await _courseService.GetAllCoursesAsync(cancellationToken);
                await LoadViewBagsAsync(cancellationToken);

                if (courses == null || !courses.Any())
                {
                    TempData["Warning"] = "لا توجد دورات متاحة حاليًا.";
                }

                _logger.LogInformation("Loaded {Count} courses for index page", courses?.Count ?? 0);
                return View(courses);
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Courses index page loading was cancelled");
                TempData["Error"] = "تم إلغاء تحميل الصفحة";
                return View(new List<CourseDTO>());
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error loading courses index page");
                TempData["Error"] = "حدث خطأ أثناء تحميل الدورات";
                return View(new List<CourseDTO>());
            }
        }

        /// <summary>
        /// Displays the course creation form
        /// </summary>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Course creation view</returns>
        [HttpGet]
        public async Task<IActionResult> Create(CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Loading course creation form");

                await LoadViewBagsAsync(cancellationToken);
                return View();
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Course creation form loading was cancelled");
                TempData["Error"] = "تم إلغاء تحميل النموذج";
                return RedirectToAction(nameof(Index));
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error loading course creation form");
                TempData["Error"] = "حدث خطأ أثناء تحميل نموذج الإنشاء";
                return RedirectToAction(nameof(Index));
            }
        }

        /// <summary>
        /// Displays the course edit form
        /// </summary>
        /// <param name="id">Course ID</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Course edit view</returns>
        [HttpGet]
        public async Task<IActionResult> Edit(int id, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Loading course edit form for ID: {CourseId}", id);

                var course = await _courseService.GetCourseByIdAsync(id, cancellationToken);
                if (course == null)
                {
                    _logger.LogWarning("Course not found for edit. ID: {CourseId}", id);
                    TempData["Error"] = $"الدورة بمعرف {id} غير موجودة";
                    return RedirectToAction(nameof(Index));
                }

                // تحميل الموارد لكل محاضرة
                foreach (var section in course.Sections)
                {
                    foreach (var lecture in section.Lectures)
                    {
                        var resources = await _courseService.GetLectureResourcesAsync(lecture.Id, cancellationToken);
                        lecture.Resources = resources;
                    }
                }

                await LoadViewBagsAsync(cancellationToken);

                var model = new CourseUpdateDTO
                {
                    Id = course.Id,
                    Title = course.Title,
                    ThumbnailUrl = course.ThumbnailUrl,
                    ShortDescription = course.ShortDescription,
                    Description = course.Description,
                    Price = course.Price,
                    Discount = course.Discount,
                    CategoryId = course.CategoryId,
                    Level = course.Level,
                    Language = course.Language,
                    InstructorId = course.InstructorId,
                    Duration = course.Duration / 60,
                    TotalLectures = course.TotalLectures,
                    HasCertificate = course.HasCertificate,
                    Requirements = course.Requirements,
                    Learnings = course.Learnings,
                    TargetAudience = course.TargetAudience,
                    Sections = course.Sections
                };

                return View(model);
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Course edit form loading was cancelled. ID: {CourseId}", id);
                TempData["Error"] = "تم إلغاء تحميل النموذج";
                return RedirectToAction(nameof(Index));
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error loading course edit form for ID: {CourseId}", id);
                TempData["Error"] = "حدث خطأ أثناء تحميل نموذج التعديل";
                return RedirectToAction(nameof(Index));
            }
        }

        #endregion

        #region Data Operations

        /// <summary>
        /// Gets course details by ID
        /// </summary>
        /// <param name="id">Course ID</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Course details JSON</returns>
        [HttpGet]
        public async Task<IActionResult> Details(int id, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Getting course details for ID: {CourseId}", id);

                var course = await _courseService.GetCourseByIdAsync(id, cancellationToken);
                if (course == null)
                {
                    _logger.LogWarning("Course not found for details. ID: {CourseId}", id);
                    return Json(new { success = false, message = $"الدورة بمعرف {id} غير موجودة" });
                }

                return Json(new { success = true, course });
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Get course details operation was cancelled. ID: {CourseId}", id);
                return Json(new { success = false, message = "تم إلغاء العملية" });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting course details for ID: {CourseId}", id);
                return Json(new { success = false, message = "حدث خطأ أثناء جلب تفاصيل الدورة" });
            }
        }

        /// <summary>
        /// Gets all categories
        /// </summary>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Categories JSON</returns>
        [HttpGet]
        public async Task<IActionResult> GetCategories(CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Getting all categories");

                var categories = await _categoryService.GetAllCategoriesAsync(cancellationToken);
                if (categories == null || !categories.Any())
                {
                    return Json(new { success = false, message = "لا توجد تصنيفات متاحة" });
                }

                return Json(new { success = true, data = categories.Select(c => new { id = c.Category_Id, name = c.Category_Name }) });
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Get categories operation was cancelled");
                return Json(new { success = false, message = "تم إلغاء العملية" });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting categories");
                return Json(new { success = false, message = "حدث خطأ أثناء جلب التصنيفات" });
            }
        }

        /// <summary>
        /// Gets all instructors
        /// </summary>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Instructors JSON</returns>
        [HttpGet]
        public async Task<IActionResult> GetInstructors(CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Getting all instructors");

                var instructors = await _userService.GetInstructorsAsync();
                if (instructors == null || !instructors.Any())
                {
                    return Json(new { success = false, message = "لا يوجد مدربين متاحين" });
                }

                return Json(new { success = true, data = instructors.Select(i => new { id = i.Id, name = i.FullName }) });
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Get instructors operation was cancelled");
                return Json(new { success = false, message = "تم إلغاء العملية" });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting instructors");
                return Json(new { success = false, message = "حدث خطأ أثناء جلب المدربين" });
            }
        }

        #endregion

        #region Course Management
        [HttpPost]
        public async Task<IActionResult> AddResourceToLecture(int lectureId, IFormFile resourceFile, CancellationToken cancellationToken = default)
        {
            try
            {
                if (resourceFile == null || resourceFile.Length == 0)
                {
                    return Json(new { success = false, message = "الملف مطلوب" });
                }

                var result = await _courseService.AddResourceToLectureAsync(lectureId, resourceFile, cancellationToken);
                if (result == null)
                {
                    return Json(new { success = false, message = "فشل إضافة المورد" });
                }

                return Json(new { success = true, resource = result });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error adding resource to lecture {LectureId}", lectureId);
                return Json(new { success = false, message = "حدث خطأ أثناء إضافة المورد" });
            }
        }

        [HttpPost]
        public async Task<IActionResult> DeleteResource(int resourceId, CancellationToken cancellationToken = default)
        {
            try
            {
                var result = await _courseService.DeleteResourceAsync(resourceId, cancellationToken);
                if (!result)
                {
                    return Json(new { success = false, message = "فشل حذف المورد" });
                }

                return Json(new { success = true, message = "تم حذف المورد بنجاح" });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error deleting resource {ResourceId}", resourceId);
                return Json(new { success = false, message = "حدث خطأ أثناء حذف المورد" });
            }
        }

        [HttpGet]
        public async Task<IActionResult> GetLectureResources(int lectureId, CancellationToken cancellationToken = default)
        {
            try
            {
                var resources = await _courseService.GetLectureResourcesAsync(lectureId, cancellationToken);
                return Json(new { success = true, resources });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting resources for lecture {LectureId}", lectureId);
                return Json(new { success = false, message = "حدث خطأ أثناء جلب الموارد" });
            }
        }
        /// <summary>
        /// Creates a new course
        /// </summary>
        /// <returns>Creation result JSON</returns>
        [RequestFormLimits(MultipartBodyLengthLimit = 4_000_000_000)]
        [RequestSizeLimit(4_000_000_000)]
        [HttpPost]
        public async Task<IActionResult> CreateCourse()
        {
            try
            {
                _logger.LogInformation("Starting course creation process");

                // التحقق من الحقول المطلوبة
                if (string.IsNullOrEmpty(Request.Form["title"]))
                    return Json(new { success = false, message = "عنوان الدورة مطلوب" });

                // إنشاء الكورس من بيانات النموذج
                var courseFromForm = CreateCourseFromFormData();

                // معالجة الصورة الرئيسية
                var thumbnail = Request.Form.Files["image"];
                if (thumbnail != null && thumbnail.Length > 0)
                    courseFromForm.Image = thumbnail;

                // معالجة الأقسام والمحاضرات والملفات
                await ProcessSectionsAndFiles(courseFromForm);

                // إرسال إلى الخدمة
                var createdCourse = await _courseService.AddCourseAsync(courseFromForm);

                if (createdCourse != null)
                {
                    _logger.LogInformation("Course created successfully. ID: {CourseId}", createdCourse.Id);
                    return Json(new { success = true, message = "تم إنشاء الدورة بنجاح!", courseId = createdCourse.Id });
                }

                return Json(new { success = false, message = "فشل إنشاء الدورة. حاول مرة أخرى" });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error during course creation");
                return Json(new { success = false, message = $"حدث خطأ أثناء إنشاء الدورة: {ex.Message}" });
            }
        }

        /// <summary>
        /// Processes sections and files from form data
        /// </summary>
        private async Task ProcessSectionsAndFiles(CourseCreateDTO course)
        {
            var sectionsData = Request.Form["sections"];
            if (!string.IsNullOrEmpty(sectionsData))
            {
                var sections = JsonSerializer.Deserialize<List<SectionDTO>>(sectionsData);
                if (sections != null)
                {
                    course.Sections = sections;

                    // معالجة الملفات لكل محاضرة
                    foreach (var (section, sIndex) in sections.Select((s, i) => (s, i)))
                    {
                        if (section.Lectures != null)
                        {
                            foreach (var (lecture, lIndex) in section.Lectures.Select((l, i) => (l, i)))
                            {
                                // معالجة فيديو المحاضرة
                                var videoFile = Request.Form.Files[$"video_{sIndex}_{lIndex}"];
                                if (videoFile != null && videoFile.Length > 0)
                                {
                                    lecture.Video = videoFile;
                                }

                                // معالجة موارد المحاضرة
                                lecture.ResourceFiles = new List<IFormFile>();
                                var resourceIndex = 0;
                                while (true)
                                {
                                    var resourceFile = Request.Form.Files[$"resource_{sIndex}_{lIndex}_{resourceIndex}"];
                                    if (resourceFile == null || resourceFile.Length == 0)
                                        break;

                                    lecture.ResourceFiles.Add(resourceFile);
                                    resourceIndex++;
                                }
                            }
                        }
                    }
                }
            }
        }

        /// <summary>
        /// Updates an existing course
        /// </summary>
        /// <returns>Update result JSON</returns>
        /// <summary>
        /// Updates an existing course
        /// </summary>
        /// <returns>Update result JSON</returns>
        [RequestFormLimits(MultipartBodyLengthLimit = 4_000_000_000)]
        [RequestSizeLimit(4_000_000_000)]
        [HttpPost]
        public async Task<IActionResult> Edit()
        {
            try
            {
                _logger.LogInformation("Starting course update process");

                if (!int.TryParse(Request.Form["id"], out int id))
                    return Json(new { success = false, message = "معرف الدورة غير صالح" });

                // Create course DTO from form data
                var course = CreateCourseUpdateFromFormData(id);

                // ✅ التأكد من أن الوصف يتم معالجته بشكل صحيح
                if (!string.IsNullOrEmpty(Request.Form["Description"]))
                {
                    course.Description = Request.Form["Description"];
                }

                // Handle image upload
                var image = Request.Form.Files["Image"];
                if (image != null && image.Length > 0)
                {
                    course.Image = image;
                }
                else if (!string.IsNullOrEmpty(Request.Form["ThumbnailUrl"]))
                {
                    course.ThumbnailUrl = Request.Form["ThumbnailUrl"];
                }

                // ✅ تحميل الموارد القديمة قبل التحديث
                // ✅ تحميل الموارد القديمة قبل التحديث ودمجها
                var existingCourse = await _courseService.GetCourseByIdAsync(id);
                if (existingCourse != null)
                {
                    foreach (var section in existingCourse.Sections)
                    {
                        var updatedSection = course.Sections?.FirstOrDefault(s => s.Id == section.Id);
                        if (updatedSection != null)
                        {
                            foreach (var lecture in section.Lectures)
                            {
                                var updatedLecture = updatedSection.Lectures?.FirstOrDefault(l => l.Id == lecture.Id);
                                if (updatedLecture != null)
                                {
                                    // لو فيه موارد قديمة
                                    if (lecture.Resources != null && lecture.Resources.Any())
                                    {
                                        // لو مفيش موارد جديدة في الفورم
                                        if (updatedLecture.Resources == null)
                                            updatedLecture.Resources = new List<LectureResourceDTO>();

                                        // ✅ نضيف الموارد القديمة جنب الجديدة
                                        foreach (var oldRes in lecture.Resources)
                                        {
                                            if (!updatedLecture.Resources.Any(r => r.Id == oldRes.Id))
                                            {
                                                updatedLecture.Resources.Add(oldRes);
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }


                // Parse and process sections with resources
                await ParseAndProcessSectionsWithResourcesAsync(course);

                // Send to service
                var updatedCourse = await _courseService.UpdateCourseAsync(id, course);

                if (updatedCourse != null)
                {
                    _logger.LogInformation("Course updated successfully. ID: {CourseId}", id);
                    return Json(new { success = true, message = "تم تعديل الدورة بنجاح!" });
                }

                _logger.LogWarning("Course update failed for ID: {CourseId}", id);
                return Json(new { success = false, message = "فشل تعديل الدورة" });
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Course update operation was cancelled");
                return Json(new { success = false, message = "تم إلغاء العملية" });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error during course update");
                return Json(new { success = false, message = $"حدث خطأ أثناء تعديل الدورة: {ex.Message}" });
            }
        }
        /// <summary>
        /// Parses and processes sections with resources for update
        /// </summary>
        /// <param name="course">Course DTO</param>
        private async Task ParseAndProcessSectionsWithResourcesAsync(CourseUpdateDTO course)
        {
            var sectionsData = Request.Form["sections"];
            if (!string.IsNullOrEmpty(sectionsData))
            {
                var sections = JsonSerializer.Deserialize<List<SectionDTO>>(sectionsData);
                int sOrder = 1;
                foreach (var section in sections)
                {
                    section.Order = sOrder++;
                    int lOrder = 1;
                    foreach (var lecture in section.Lectures)
                    {
                        lecture.Order = lOrder++;
                        lecture.ContentType ??= "video";

                        // Handle video upload
                        var videoFile = Request.Form.Files[$"video_{section.Order - 1}_{lecture.Order - 1}"];
                        if (videoFile != null && videoFile.Length > 0)
                        {
                            lecture.Video = videoFile;
                        }

                        // Handle new resource files
                        lecture.ResourceFiles = new List<IFormFile>();
                        var resourceIndex = 0;
                        while (true)
                        {
                            var resourceFile = Request.Form.Files[$"resource_{section.Order - 1}_{lecture.Order - 1}_{resourceIndex}"];
                            if (resourceFile == null || resourceFile.Length == 0)
                                break;

                            lecture.ResourceFiles.Add(resourceFile);
                            resourceIndex++;
                        }

                        // ✅ دمج الموارد القديمة مع الجديدة
                        var oldLecture = course.Sections?
                            .FirstOrDefault(s => s.Id == section.Id)?
                            .Lectures?.FirstOrDefault(l => l.Id == lecture.Id);

                        if (oldLecture?.Resources != null && oldLecture.Resources.Any())
                        {
                            // حافظ على الموارد القديمة + ضيف أي جديد
                            if (lecture.Resources == null) lecture.Resources = new List<LectureResourceDTO>();
                            foreach (var oldRes in oldLecture.Resources)
                            {
                                if (!lecture.Resources.Any(r => r.Id == oldRes.Id))
                                    lecture.Resources.Add(oldRes);
                            }
                        }
                    }
                }

                course.Sections = sections;
            }
        }

        /// <summary>
        /// Deletes a course
        /// </summary>
        /// <param name="id">Course ID</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Delete result JSON</returns>
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Delete(int id, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Deleting course ID: {CourseId}", id);

                var isDeleted = await _courseService.DeleteCourseAsync(id, cancellationToken);
                if (isDeleted)
                {
                    _logger.LogInformation("Course deleted successfully. ID: {CourseId}", id);
                    return Json(new { success = true, message = "تم حذف الدورة بنجاح" });
                }

                _logger.LogWarning("Course deletion failed. ID: {CourseId}", id);
                return Json(new { success = false, message = $"الدورة بمعرف {id} غير موجودة" });
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Course deletion operation was cancelled. ID: {CourseId}", id);
                return Json(new { success = false, message = "تم إلغاء العملية" });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error deleting course ID: {CourseId}", id);
                return Json(new { success = false, message = $"حدث خطأ أثناء حذف الدورة: {ex.Message}" });
            }
        }

        #endregion

        #region Bulk Operations

        /// <summary>
        /// Bulk delete courses
        /// </summary>
        /// <param name="ids">List of course IDs</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Bulk delete result JSON</returns>
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> BulkDelete([FromBody] List<int> ids, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Bulk deleting {Count} courses", ids?.Count ?? 0);

                if (ids == null || !ids.Any())
                {
                    return Json(new { success = false, message = "لم يتم تحديد أي دورات للحذف" });
                }

                var result = await _courseService.BulkDeleteCoursesAsync(ids, cancellationToken);
                if (result)
                {
                    _logger.LogInformation("Bulk delete completed successfully. Deleted {Count} courses", ids.Count);
                    return Json(new { success = true, message = $"تم حذف {ids.Count} دورة بنجاح" });
                }

                _logger.LogWarning("Bulk delete failed for {Count} courses", ids.Count);
                return Json(new { success = false, message = "حدث خطأ أثناء حذف الدورات" });
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Bulk delete operation was cancelled");
                return Json(new { success = false, message = "تم إلغاء العملية" });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error during bulk delete of {Count} courses", ids?.Count ?? 0);
                return Json(new { success = false, message = $"حدث خطأ أثناء الحذف الجماعي: {ex.Message}" });
            }
        }

        /// <summary>
        /// Accepts multiple courses
        /// </summary>
        /// <param name="ids">List of course IDs</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Acceptance result JSON</returns>
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> AcceptMultiple([FromBody] List<int> ids, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Accepting {Count} courses", ids?.Count ?? 0);

                if (ids == null || !ids.Any())
                {
                    return Json(new { success = false, message = "لم يتم تحديد أي كورسات" });
                }

                var successCount = 0;
                foreach (var id in ids)
                {
                    var result = await _courseService.AcceptCourseAsync(id, cancellationToken);
                    if (result) successCount++;
                }

                _logger.LogInformation("Accepted {SuccessCount} out of {TotalCount} courses", successCount, ids.Count);
                return Json(new { success = true, message = $"تم قبول {successCount} من {ids.Count} كورسات بنجاح" });
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Accept multiple courses operation was cancelled");
                return Json(new { success = false, message = "تم إلغاء العملية" });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error accepting {Count} courses", ids?.Count ?? 0);
                return Json(new { success = false, message = "حدث خطأ أثناء قبول الكورسات", error = ex.Message });
            }
        }

        /// <summary>
        /// Rejects multiple courses
        /// </summary>
        /// <param name="ids">List of course IDs</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Rejection result JSON</returns>
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> RejectMultiple([FromBody] List<int> ids, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Rejecting {Count} courses", ids?.Count ?? 0);

                if (ids == null || !ids.Any())
                {
                    return Json(new { success = false, message = "لم يتم تحديد أي كورسات" });
                }

                var successCount = 0;
                foreach (var id in ids)
                {
                    var result = await _courseService.RejectCourseAsync(id, cancellationToken);
                    if (result) successCount++;
                }

                _logger.LogInformation("Rejected {SuccessCount} out of {TotalCount} courses", successCount, ids.Count);
                return Json(new { success = true, message = $"تم رفض {successCount} من {ids.Count} كورسات بنجاح" });
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Reject multiple courses operation was cancelled");
                return Json(new { success = false, message = "تم إلغاء العملية" });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error rejecting {Count} courses", ids?.Count ?? 0);
                return Json(new { success = false, message = "حدث خطأ أثناء رفض الكورسات", error = ex.Message });
            }
        }

        #endregion

        #region Filter Operations

        /// <summary>
        /// Gets courses by instructor
        /// </summary>
        /// <param name="instructorId">Instructor ID</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Courses view</returns>
        public async Task<IActionResult> CoursesByInstructor(string instructorId, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Getting courses for instructor ID: {InstructorId}", instructorId);

                var courses = await _courseService.GetCoursesByInstructorAsync(instructorId, cancellationToken);
                await LoadViewBagsAsync(cancellationToken);

                if (courses == null || !courses.Any())
                {
                    TempData["Warning"] = "لا توجد دورات لهذا المدرب";
                }

                _logger.LogInformation("Found {Count} courses for instructor ID: {InstructorId}", courses?.Count ?? 0, instructorId);
                return View("Index", courses);
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Get courses by instructor operation was cancelled. Instructor ID: {InstructorId}", instructorId);
                TempData["Error"] = "تم إلغاء العملية";
                return RedirectToAction(nameof(Index));
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting courses for instructor ID: {InstructorId}", instructorId);
                TempData["Error"] = "حدث خطأ أثناء جلب دورات المدرب";
                return RedirectToAction(nameof(Index));
            }
        }

        /// <summary>
        /// Gets courses by category
        /// </summary>
        /// <param name="categoryId">Category ID</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Courses view</returns>
        public async Task<IActionResult> CoursesByCategory(int categoryId, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Getting courses for category ID: {CategoryId}", categoryId);

                var courses = await _courseService.GetCoursesWithCategoryAsync(categoryId, cancellationToken);
                await LoadViewBagsAsync(cancellationToken);

                if (courses == null || !courses.Any())
                {
                    TempData["Warning"] = "لا توجد دورات في هذا التصنيف";
                }

                _logger.LogInformation("Found {Count} courses for category ID: {CategoryId}", courses?.Count ?? 0, categoryId);
                return View("Index", courses);
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Get courses by category operation was cancelled. Category ID: {CategoryId}", categoryId);
                TempData["Error"] = "تم إلغاء العملية";
                return RedirectToAction(nameof(Index));
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting courses for category ID: {CategoryId}", categoryId);
                TempData["Error"] = "حدث خطأ أثناء جلب دورات التصنيف";
                return RedirectToAction(nameof(Index));
            }
        }

        #endregion

        #region Status Management

        /// <summary>
        /// Accepts a single course
        /// </summary>
        /// <param name="id">Course ID</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Redirect to index</returns>
        [HttpPost]
        public async Task<IActionResult> Accept(int id, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Accepting course ID: {CourseId}", id);

                var result = await _courseService.AcceptCourseAsync(id, cancellationToken);
                if (result)
                {
                    TempData["Success"] = "تم قبول الكورس بنجاح";
                }
                else
                {
                    TempData["Error"] = "حدث خطأ أثناء قبول الكورس";
                }

                return RedirectToAction(nameof(Index));
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Accept course operation was cancelled. ID: {CourseId}", id);
                TempData["Error"] = "تم إلغاء العملية";
                return RedirectToAction(nameof(Index));
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error accepting course ID: {CourseId}", id);
                TempData["Error"] = "حدث خطأ أثناء قبول الكورس";
                return RedirectToAction(nameof(Index));
            }
        }

        /// <summary>
        /// Rejects a single course
        /// </summary>
        /// <param name="id">Course ID</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Redirect to index</returns>
        [HttpPost]
        public async Task<IActionResult> Reject(int id, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Rejecting course ID: {CourseId}", id);

                var result = await _courseService.RejectCourseAsync(id, cancellationToken);
                if (result)
                {
                    TempData["Success"] = "تم رفض الكورس بنجاح";
                }
                else
                {
                    TempData["Error"] = "حدث خطأ أثناء رفض الكورس";
                }

                return RedirectToAction(nameof(Index));
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Reject course operation was cancelled. ID: {CourseId}", id);
                TempData["Error"] = "تم إلغاء العملية";
                return RedirectToAction(nameof(Index));
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error rejecting course ID: {CourseId}", id);
                TempData["Error"] = "حدث خطأ أثناء رفض الكورس";
                return RedirectToAction(nameof(Index));
            }
        }

        #endregion

        #region Private Helper Methods

        /// <summary>
        /// Loads view bags with categories and instructors
        /// </summary>
        /// <param name="cancellationToken">Cancellation token</param>
        private async Task LoadViewBagsAsync(CancellationToken cancellationToken = default)
        {
            try
            {
                var categories = await _categoryService.GetAllCategoriesAsync(cancellationToken);
                ViewBag.Categories = categories.Select(c => new SelectListItem
                {
                    Value = c.Category_Id.ToString(),
                    Text = c.Category_Name
                }).ToList();

                var instructors = await _userService.GetInstructorsAsync();
                ViewBag.Instructors = instructors.Select(i => new SelectListItem
                {
                    Value = i.Id,
                    Text = i.FullName
                }).ToList();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error loading view bags");
                // Continue with empty lists if there's an error
                ViewBag.Categories = new List<SelectListItem>();
                ViewBag.Instructors = new List<SelectListItem>();
            }
        }

        /// <summary>
        /// Creates CourseCreateDTO from form data
        /// </summary>
        /// <returns>CourseCreateDTO object</returns>
        private CourseCreateDTO CreateCourseFromFormData()
        {
            return new CourseCreateDTO
            {
                Title = Request.Form["title"],
                ShortDescription = Request.Form["shortDescription"],
                Description = Request.Form["description"],
                Price = decimal.Parse(Request.Form["price"]),
                Discount = string.IsNullOrEmpty(Request.Form["discount"]) ? 0 : decimal.Parse(Request.Form["discount"]),
                CategoryId = int.Parse(Request.Form["CategoryId"]),
                Level = Request.Form["level"],
                Language = Request.Form["language"],
                HasCertificate = Request.Form["certificate"] == "on",
                Requirements = Request.Form["requirements"].ToString()
                    .Split('\n', StringSplitOptions.RemoveEmptyEntries)
                    .Select(r => r.Trim()).ToList(),
                Learnings = Request.Form["learnings"].ToString()
                    .Split('\n', StringSplitOptions.RemoveEmptyEntries)
                    .Select(l => l.Trim()).ToList(),
                TargetAudience = Request.Form["targetAudience"],
                InstructorId = Request.Form["InstructorId"],
                Sections = new List<SectionDTO>()
            };
        }

        /// <summary>
        /// Creates CourseUpdateDTO from form data
        /// </summary>
        /// <param name="id">Course ID</param>
        /// <returns>CourseUpdateDTO object</returns>
        private CourseUpdateDTO CreateCourseUpdateFromFormData(int id)
        {
            return new CourseUpdateDTO
            {
                Id = id,
                Title = Request.Form["Title"],
                ShortDescription = Request.Form["ShortDescription"],
                Description = Request.Form["Description"],
                Price = decimal.Parse(Request.Form["Price"]),
                Discount = string.IsNullOrEmpty(Request.Form["Discount"]) ? null : decimal.Parse(Request.Form["Discount"]),
                CategoryId = int.Parse(Request.Form["CategoryId"]),
                Level = Request.Form["Level"],
                Language = Request.Form["Language"],
                HasCertificate = Request.Form["certificate"] == "on",
                Requirements = Request.Form["requirements"].ToString()
                    .Split('\n', StringSplitOptions.RemoveEmptyEntries)
                    .Select(r => r.Trim()).ToList(),
                Learnings = Request.Form["learnings"].ToString()
                    .Split('\n', StringSplitOptions.RemoveEmptyEntries)
                    .Select(l => l.Trim()).ToList(),
                TargetAudience = Request.Form["TargetAudience"],
                InstructorId = Request.Form["InstructorId"],
                Sections = new List<SectionDTO>()
            };
        }

        /// <summary>
        /// Parses and validates sections from form data
        /// </summary>
        /// <param name="course">Course DTO</param>
        /// <returns>True if validation successful</returns>
        private async Task<bool> ParseAndValidateSectionsAsync(CourseCreateDTO course)
        {
            var sectionsData = Request.Form["sections"];
            if (string.IsNullOrEmpty(sectionsData))
            {
                _logger.LogWarning("No sections data provided");
                return false;
            }

            try
            {
                var sections = JsonSerializer.Deserialize<List<SectionDTO>>(sectionsData);
                if (sections == null || sections.Count == 0)
                {
                    _logger.LogWarning("No sections found in data");
                    return false;
                }

                int sectionOrder = 1;
                foreach (var section in sections)
                {
                    if (string.IsNullOrWhiteSpace(section.Title))
                    {
                        _logger.LogWarning("Section title is required");
                        return false;
                    }

                    section.Order = sectionOrder++;

                    if (section.Lectures == null || section.Lectures.Count == 0)
                    {
                        _logger.LogWarning("Section '{SectionTitle}' must contain at least one lecture", section.Title);
                        return false;
                    }

                    int lectureOrder = 1;
                    foreach (var lecture in section.Lectures)
                    {
                        if (string.IsNullOrWhiteSpace(lecture.Title))
                        {
                            _logger.LogWarning("Lecture title is required");
                            return false;
                        }

                        lecture.Order = lectureOrder++;
                        lecture.ContentType ??= "video";

                        // Handle video upload
                        var videoFile = Request.Form.Files[$"video_{section.Order - 1}_{lecture.Order - 1}"];
                        if (videoFile != null && videoFile.Length > 0)
                        {
                            lecture.Video = videoFile;
                        }
                    }
                }

                course.Sections = sections;
                return true;
            }
            catch (JsonException ex)
            {
                _logger.LogWarning(ex, "Failed to parse sections JSON");
                return false;
            }
        }

        /// <summary>
        /// Parses and processes sections for update
        /// </summary>
        /// <param name="course">Course DTO</param>
        private async Task ParseAndProcessSectionsAsync(CourseUpdateDTO course)
        {
            var sectionsData = Request.Form["sections"];
            if (!string.IsNullOrEmpty(sectionsData))
            {
                var sections = JsonSerializer.Deserialize<List<SectionDTO>>(sectionsData);
                int sOrder = 1;
                foreach (var section in sections)
                {
                    section.Order = sOrder++;
                    int lOrder = 1;
                    foreach (var lecture in section.Lectures)
                    {
                        lecture.Order = lOrder++;
                        lecture.ContentType ??= "video";

                        // Handle video upload
                        var videoFile = Request.Form.Files[$"video_{section.Order - 1}_{lecture.Order - 1}"];
                        if (videoFile != null && videoFile.Length > 0)
                        {
                            lecture.Video = videoFile;
                        }
                        else
                        {
                            lecture.VideoUrl = lecture.VideoUrl;
                        }
                    }
                }
                course.Sections = sections;
            }
        }

        #endregion
    }
}
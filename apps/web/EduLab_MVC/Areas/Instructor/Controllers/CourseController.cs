using EduLab_MVC.Models.DTOs.Course;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using System.Text.Json;
using Microsoft.AspNetCore.Authorization;
using EduLab_MVC.Common;
using EduLab_MVC.Services.ServiceInterfaces;
using Microsoft.Extensions.Localization;
using EduLab_MVC.Resources;

namespace EduLab_MVC.Areas.Instructor.Controllers
{
    /// <summary>
    /// Controller for managing courses in instructor area
    /// </summary>
    [Area("Instructor")]
    [Authorize(Roles = SD.Instructor)]
    public class CourseController : Controller
    {
        #region Dependencies

        private readonly ICourseService _courseService;
        private readonly ICategoryService _categoryService;
        private readonly ILogger<CourseController> _logger;
        private readonly IHttpContextAccessor _httpContextAccessor;
        private readonly IStringLocalizer<SharedResources> _localizer;

        #endregion

        #region Constructor

        /// <summary>
        /// Initializes a new instance of the CourseController class
        /// </summary>
        public CourseController(
            ICourseService courseService,
            ICategoryService categoryService,
            ILogger<CourseController> logger,
            IHttpContextAccessor httpContextAccessor,
            IStringLocalizer<SharedResources> localizer)
        {
            _courseService = courseService;
            _categoryService = categoryService;
            _logger = logger;
            _httpContextAccessor = httpContextAccessor;
            _localizer = localizer;
        }

        #endregion

        #region View Actions

        /// <summary>
        /// GET: Index - Displays list of instructor courses
        /// </summary>
        /// <returns>Courses index view</returns>
        public async Task<IActionResult> Index()
        {
            try
            {
                _logger.LogInformation("Loading instructor courses index page");

                var courses = await _courseService.GetInstructorCoursesAsync();
                await LoadCategoriesViewBagAsync();

                if (!courses.Any())
                {
                    _logger.LogWarning("No courses found for instructor");
                    TempData["Error"] = "لا توجد دورات متاحة حالياً.";
                }

                _logger.LogInformation("Loaded {CourseCount} courses for instructor", courses.Count);
                return View(courses);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error while loading instructor courses");
                TempData["Error"] = "حدث خطأ أثناء تحميل الكورسات.";
                return View(new List<CourseDTO>());
            }
        }

        /// <summary>
        /// GET: Create - Displays course creation form
        /// </summary>
        /// <returns>Course creation view</returns>
        [HttpGet]
        public async Task<IActionResult> Create()
        {
            try
            {
                _logger.LogInformation("Loading course creation form");

                await LoadCategoriesViewBagAsync();
                await LoadInstructorIdViewBagAsync();

                return View();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error loading course creation form");
                TempData["Error"] = "حدث خطأ أثناء تحميل نموذج الإنشاء";
                return RedirectToAction(nameof(Index));
            }
        }

        /// <summary>
        /// GET: Edit - Displays course edit form
        /// </summary>
        /// <param name="id">Course ID</param>
        /// <returns>Course edit view</returns>
        [HttpGet]
        public IActionResult Edit(int id)
        {
            return RedirectToAction("Settings", new { id });
        }

        #endregion

        #region Lecture Resources Operations - مثل الـ Admin تماماً

        /// <summary>
        /// Adds resource to lecture
        /// </summary>
        [HttpPost]
        public async Task<IActionResult> AddResourceToLecture(int lectureId, IFormFile resourceFile)
        {
            try
            {
                if (resourceFile == null || resourceFile.Length == 0)
                {
                    return Json(new { success = false, message = "الملف مطلوب" });
                }

                var result = await _courseService.AddResourceToLectureAsync(lectureId, resourceFile);
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

        /// <summary>
        /// Deletes a resource
        /// </summary>
        [HttpPost]
        public async Task<IActionResult> DeleteResource(int resourceId)
        {
            try
            {
                var result = await _courseService.DeleteResourceAsync(resourceId);
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

        /// <summary>
        /// Gets lecture resources
        /// </summary>
        [HttpGet]
        public async Task<IActionResult> GetLectureResources(int lectureId)
        {
            try
            {
                var resources = await _courseService.GetLectureResourcesAsync(lectureId);
                return Json(new { success = true, resources });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting resources for lecture {LectureId}", lectureId);
                return Json(new { success = false, message = "حدث خطأ أثناء جلب الموارد" });
            }
        }

        #endregion

        #region API Actions

        /// <summary>
        /// GET: Details - Gets course details by ID
        /// </summary>
        [HttpGet]
        public async Task<IActionResult> Details(int id)
        {
            try
            {
                _logger.LogInformation("Getting course details for ID: {CourseId}", id);

                var course = await _courseService.GetCourseByIdAsync(id);
                if (course == null)
                {
                    _logger.LogWarning("Course not found for details. ID: {CourseId}", id);
                    return Json(new { success = false, message = $"الدورة بمعرف {id} غير موجودة." });
                }

                return Json(new { success = true, course });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting course details for ID: {CourseId}", id);
                return Json(new { success = false, message = "حدث خطأ أثناء جلب تفاصيل الدورة." });
            }
        }

        /// <summary>
        /// GET: GetCategories - Gets all categories
        /// </summary>
        [HttpGet]
        public async Task<IActionResult> GetCategories()
        {
            try
            {
                _logger.LogInformation("Getting all categories");

                var categories = await _categoryService.GetAllCategoriesAsync();
                if (categories == null || !categories.Any())
                {
                    return Json(new { success = false, message = "لا توجد تصنيفات متاحة." });
                }

                return Json(new { success = true, data = categories.Select(c => new { id = c.Category_Id, name = c.Category_Name }) });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting categories");
                return Json(new { success = false, message = "حدث خطأ أثناء جلب التصنيفات." });
            }
        }

        /// <summary>
        /// POST: CreateCourse - Creates a new course draft
        /// </summary>
        [HttpPost]
        public async Task<IActionResult> CreateCourse([FromForm] CourseDraftDTO draftDto)
        {
            try
            {
                _logger.LogInformation("Starting course creation process");

                if (draftDto == null || string.IsNullOrWhiteSpace(draftDto.Title))
                    return Json(new { success = false, message = "عنوان الدورة مطلوب" });

                if (draftDto.CategoryId <= 0)
                    return Json(new { success = false, message = "التصنيف مطلوب" });

                var createdCourse = await _courseService.CreateCourseDraftAsync(draftDto);

                if (createdCourse != null)
                {
                    _logger.LogInformation("Course draft created. ID: {CourseId}", createdCourse.Id);
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
        /// POST: Edit - Updates an existing course
        /// </summary>
        [HttpPost]
        public async Task<IActionResult> Edit(CourseUpdateDTO courseDto)
        {
            try
            {
                _logger.LogInformation("Starting course update process");

                if (courseDto == null || courseDto.Id <= 0)
                    return Json(new { success = false, message = _localizer["InvalidData"].Value });

                var updatedCourse = await _courseService.UpdateCourseDetailsAsync(courseDto.Id, courseDto);

                if (updatedCourse != null)
                {
                    _logger.LogInformation("Course updated successfully. ID: {CourseId}", courseDto.Id);
                    TempData["Success"] = _localizer["CourseUpdatedSuccess"].Value;
                    return Json(new { success = true, message = _localizer["CourseUpdatedSuccess"].Value });
                }

                TempData["Error"] = _localizer["CourseUpdateFailed"].Value;
                return Json(new { success = false, message = _localizer["CourseUpdateFailed"].Value });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error during course update");
                TempData["Error"] = _localizer["ErrorOccurred"].Value;
                return Json(new { success = false, message = $"{_localizer["ErrorOccurred"].Value}: {ex.Message}" });
            }
        }

        /// <summary>
        /// POST: Delete - Deletes a course
        /// </summary>
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Delete(int id)
        {
            try
            {
                _logger.LogInformation("Deleting course ID: {CourseId}", id);

                var isDeleted = await _courseService.DeleteCourseAsInstructorAsync(id);
                if (isDeleted)
                {
                    _logger.LogInformation("Course deleted successfully. ID: {CourseId}", id);
                    TempData["Success"] = "تم حذف الدورة بنجاح";
                    return Json(new { success = true, message = "تم حذف الدورة بنجاح." });
                }

                _logger.LogWarning("Course deletion failed. ID: {CourseId}", id);
                TempData["Error"] = "فشل حذف الدورة . حاول مرة أخرى";
                return Json(new { success = false, message = $"الدورة بمعرف {id} غير موجودة." });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error deleting course ID: {CourseId}", id);
                TempData["Error"] = "حدث خطأ أثناء حذف الدورة";
                return Json(new { success = false, message = $"حدث خطأ أثناء حذف الدورة: {ex.Message}" });
            }
        }

        /// <summary>
        /// POST: BulkDelete - Bulk delete courses
        /// </summary>
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> BulkDelete([FromBody] List<int> ids)
        {
            try
            {
                _logger.LogInformation("Bulk deleting {Count} courses", ids?.Count ?? 0);

                if (ids == null || !ids.Any())
                {
                    return Json(new { success = false, message = "لم يتم تحديد أي دورات للحذف." });
                }

                var result = await _courseService.BulkDeleteCoursesAsInstructorAsync(ids);
                if (result)
                {
                    _logger.LogInformation("Bulk delete completed successfully. Deleted {Count} courses", ids.Count);
                    TempData["Success"] = $"تم حذف {ids.Count} دورة بنجاح.";
                    return Json(new { success = true, message = $"تم حذف {ids.Count} دورة بنجاح." });
                }

                _logger.LogWarning("Bulk delete failed for {Count} courses", ids.Count);
                TempData["Error"] = "حدث خطأ أثناء حذف الدورات";
                return Json(new { success = false, message = "حدث خطأ أثناء حذف الدورات." });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error during bulk delete of {Count} courses", ids?.Count ?? 0);
                TempData["Error"] = "حدث خطأ أثناء حذف الدورات";
                return Json(new { success = false, message = $"حدث خطأ أثناء الحذف الجماعي: {ex.Message}" });
            }
        }

        #endregion

        #region New Workflow Actions

        [HttpGet]
        public async Task<IActionResult> Curriculum(int id)
        {
            try
            {
                _logger.LogInformation("Loading curriculum page for course ID: {CourseId}", id);

                var course = await _courseService.GetCourseByIdAsync(id);
                if (course == null)
                    return NotFound();

                return View(course);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error loading curriculum for course ID: {CourseId}", id);
                TempData["Error"] = "حدث خطأ أثناء تحميل المنهج";
                return RedirectToAction(nameof(Index));
            }
        }

        [HttpGet]
        public async Task<IActionResult> Settings(int id)
        {
            try
            {
                _logger.LogInformation("Loading settings page for course ID: {CourseId}", id);

                var course = await _courseService.GetCourseByIdAsync(id);
                if (course == null)
                    return NotFound();

                await LoadCategoriesViewBagAsync();
                return View(course);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error loading settings for course ID: {CourseId}", id);
                TempData["Error"] = "حدث خطأ أثناء تحميل الإعدادات";
                return RedirectToAction(nameof(Index));
            }
        }

        [HttpPost]
        public async Task<IActionResult> AddSection([FromBody] SectionCreateDTO sectionDto)
        {
            try
            {
                if (sectionDto == null || sectionDto.CourseId <= 0)
                    return Json(new { success = false, message = "بيانات غير صالحة" });

                var section = await _courseService.AddSectionAsync(sectionDto.CourseId, sectionDto);
                if (section == null)
                    return Json(new { success = false, message = "فشل إضافة القسم" });

                return Json(new { success = true, section });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error adding section");
                return Json(new { success = false, message = ex.Message });
            }
        }

        [HttpPost]
        public async Task<IActionResult> UpdateSection([FromBody] SectionUpdateDTO sectionDto)
        {
            try
            {
                if (sectionDto == null || sectionDto.Id <= 0)
                    return Json(new { success = false, message = "بيانات غير صالحة" });

                var section = await _courseService.UpdateSectionAsync(sectionDto.Id, sectionDto);
                if (section == null)
                    return Json(new { success = false, message = "فشل تعديل القسم" });

                return Json(new { success = true, section });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error updating section");
                return Json(new { success = false, message = ex.Message });
            }
        }

        [HttpPost]
        public async Task<IActionResult> DeleteSection([FromBody] int sectionId)
        {
            try
            {
                if (sectionId <= 0)
                    return Json(new { success = false, message = "بيانات غير صالحة" });

                var result = await _courseService.DeleteSectionAsync(sectionId);
                return Json(new { success = result });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error deleting section");
                return Json(new { success = false, message = ex.Message });
            }
        }

        [HttpPost]
        public async Task<IActionResult> AddLecture([FromForm] LectureCreateDTO lectureDto)
        {
            try
            {
                if (lectureDto == null || lectureDto.SectionId <= 0)
                    return Json(new { success = false, message = "بيانات غير صالحة" });

                var lecture = await _courseService.AddLectureAsync(lectureDto.SectionId, lectureDto);
                if (lecture == null)
                    return Json(new { success = false, message = "فشل إضافة المحاضرة" });

                return Json(new { success = true, lecture });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error adding lecture");
                return Json(new { success = false, message = ex.Message });
            }
        }

        [HttpPost]
        public async Task<IActionResult> UpdateLecture([FromForm] LectureUpdateDTO lectureDto)
        {
            try
            {
                if (lectureDto == null || lectureDto.Id <= 0)
                    return Json(new { success = false, message = "بيانات غير صالحة" });

                var lecture = await _courseService.UpdateLectureAsync(lectureDto.Id, lectureDto);
                if (lecture == null)
                    return Json(new { success = false, message = "فشل تعديل المحاضرة" });

                return Json(new { success = true, lecture });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error updating lecture");
                return Json(new { success = false, message = ex.Message });
            }
        }

        [HttpPost]
        public async Task<IActionResult> DeleteLecture([FromBody] int lectureId)
        {
            try
            {
                if (lectureId <= 0)
                    return Json(new { success = false, message = "بيانات غير صالحة" });

                var result = await _courseService.DeleteLectureAsync(lectureId);
                return Json(new { success = result });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error deleting lecture");
                return Json(new { success = false, message = ex.Message });
            }
        }

        [HttpPost]
        public async Task<IActionResult> Publish(int courseId)
        {
            try
            {
                var result = await _courseService.PublishCourseAsync(courseId);
                if (result == null)
                    return Json(new { success = false, message = _localizer["PublishFailed"].Value });

                if (result.Success)
                {
                    return Json(new { success = true, message = _localizer["CoursePublished"].Value });
                }

                return Json(result);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error publishing course");
                return Json(new { success = false, message = _localizer["ErrorOccurred"].Value });
            }
        }

        #endregion

        #region Private Helper Methods

        /// <summary>
        /// Loads categories into ViewBag
        /// </summary>
        private async Task LoadCategoriesViewBagAsync()
        {
            try
            {
                var categories = await _categoryService.GetAllCategoriesAsync();
                ViewBag.Categories = categories.Select(c => new SelectListItem
                {
                    Value = c.Category_Id.ToString(),
                    Text = c.Category_Name
                }).ToList();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error loading categories for ViewBag");
                ViewBag.Categories = new List<SelectListItem>();
            }
        }

        /// <summary>
        /// Loads instructor ID into ViewBag from JWT token
        /// </summary>
        private async Task LoadInstructorIdViewBagAsync()
        {
            try
            {
                var token = Request.Cookies["AuthToken"];
                string instructorId = null;

                if (!string.IsNullOrEmpty(token))
                {
                    var handler = new System.IdentityModel.Tokens.Jwt.JwtSecurityTokenHandler();
                    var jwtToken = handler.ReadJwtToken(token);
                    instructorId = jwtToken.Claims.FirstOrDefault(c => c.Type == "sub")?.Value;
                }

                ViewBag.InstructorId = instructorId;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error extracting instructor ID from token");
                ViewBag.InstructorId = null;
            }
        }

        /// <summary>
        /// Creates CourseCreateDTO from form data 
        /// </summary>
        private CourseCreateDTO CreateCourseFromFormData()
        {
            var httpContext = _httpContextAccessor.HttpContext;
            var instructorIdCookie = httpContext?.Request.Cookies["InstructorId"];
            var instructorId = !string.IsNullOrEmpty(instructorIdCookie) ? instructorIdCookie : "";

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
                InstructorId = instructorId,
                Sections = new List<SectionDTO>()
            };
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

                    foreach (var (section, sIndex) in sections.Select((s, i) => (s, i)))
                    {
                        if (section.Lectures != null)
                        {
                            foreach (var (lecture, lIndex) in section.Lectures.Select((l, i) => (l, i)))
                            {
                                var videoFile = Request.Form.Files[$"video_{sIndex}_{lIndex}"];
                                if (videoFile != null && videoFile.Length > 0)
                                {
                                    lecture.Video = videoFile;
                                }

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
        /// Builds CourseUpdateDTO from request data 
        /// </summary>
        private CourseUpdateDTO BuildCourseUpdateFromRequest(int id)
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
                Requirements = Request.Form["Requirements"].ToString()
                    .Split('\n', StringSplitOptions.RemoveEmptyEntries)
                    .Select(r => r.Trim()).ToList(),
                Learnings = Request.Form["Learnings"].ToString()
                    .Split('\n', StringSplitOptions.RemoveEmptyEntries)
                    .Select(l => l.Trim()).ToList(),
                TargetAudience = Request.Form["TargetAudience"],
                InstructorId = User.Identity.Name,
                Sections = new List<SectionDTO>()
            };
        }

        /// <summary>
        /// Processes media files for course update
        /// </summary>
        private async Task ProcessCourseUpdateMedia(CourseUpdateDTO course)
        {
            // Handle image upload
            var image = Request.Form.Files["Image"];
            if (image != null && image.Length > 0)
            {
                course.Image = image;
            }
            else if (!string.IsNullOrEmpty(Request.Form["ThumbnailUrl"]))
            {
                course.ThumbnailUrl = Request.Form["ThumbnailUrl"];
                course.Image = null;
            }
        }

        /// <summary>
        /// Parses and processes sections with resources for update 
        /// </summary>
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
                        else
                        {
                            lecture.VideoUrl = lecture.VideoUrl;
                        }

                        // Handle resource files
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
                    }
                }
                course.Sections = sections;
            }
        }

        #endregion
    }
}
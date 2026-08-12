using EduLab_MVC.Models.DTOs.Course;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using System.Globalization;
using System.Text.Json;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http.Features;
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

                _logger.LogInformation("Loaded {CourseCount} courses for instructor", courses.Count);
                return View(courses);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error while loading instructor courses");
                TempData["Error"] = _localizer["ErrorLoadingCourses"].Value;
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
                TempData["Error"] = _localizer["ErrorLoadingCreateForm"].Value;
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
                    return Json(new { success = false, message = _localizer["FileRequired"].Value });
                }

                if (!await IsOwnedLectureAsync(lectureId))
                    return Json(new { success = false, message = _localizer["CannotEditNotYourCourse"].Value });

                var result = await _courseService.AddResourceToLectureAsync(lectureId, resourceFile);
                if (result == null)
                {
                    return Json(new { success = false, message = _localizer["ResourceAddFailed"].Value });
                }

                return Json(new { success = true, resource = result });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error adding resource to lecture {LectureId}", lectureId);
                return Json(new { success = false, message = _localizer["ResourceAddError"].Value });
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
                    return Json(new { success = false, message = _localizer["ResourceDeleteFailed"].Value });
                }

                return Json(new { success = true, message = _localizer["ResourceDeletedSuccess"].Value });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error deleting resource {ResourceId}", resourceId);
                return Json(new { success = false, message = _localizer["ResourceDeleteError"].Value });
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
                if (!await IsOwnedLectureAsync(lectureId))
                    return Json(new { success = false, message = _localizer["NotYourCourse"].Value });

                var resources = await _courseService.GetLectureResourcesAsync(lectureId);
                return Json(new { success = true, resources });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting resources for lecture {LectureId}", lectureId);
                return Json(new { success = false, message = _localizer["ResourcesFetchError"].Value });
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
                    TempData["Error"] = $"الدورة بمعرف {id} غير موجودة";
                    return RedirectToAction(nameof(Index));
                }

                if (!await IsCurrentInstructorOwnerAsync(course))
                {
                    TempData["Error"] = _localizer["NotYourCourse"].Value;
                    return RedirectToAction(nameof(Index));
                }

                return View(course);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting course details for ID: {CourseId}", id);
                TempData["Error"] = _localizer["ErrorLoadingCourseDetails"].Value;
                return RedirectToAction(nameof(Index));
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
                    return Json(new { success = false, message = _localizer["NoCategoriesAvailable"].Value });
                }

                return Json(new { success = true, data = categories.Select(c => new { id = c.Category_Id, name = c.Category_Name }) });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting categories");
                return Json(new { success = false, message = _localizer["CategoriesFetchError"].Value });
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
                    return Json(new { success = false, message = _localizer["CourseTitleRequired"].Value });

                if (draftDto.CategoryId <= 0)
                    return Json(new { success = false, message = _localizer["CategoryRequired"].Value });

                if (decimal.TryParse(Request.Form["price"], NumberStyles.Number, CultureInfo.InvariantCulture, out var priceValue))
                    draftDto.Price = priceValue;
                if (decimal.TryParse(Request.Form["discount"], NumberStyles.Number, CultureInfo.InvariantCulture, out var discountValue))
                    draftDto.Discount = discountValue;

                var createdCourse = await _courseService.CreateCourseDraftAsync(draftDto);

                if (createdCourse != null)
                {
                    _logger.LogInformation("Course draft created. ID: {CourseId}", createdCourse.Id);
                    return Json(new { success = true, message = _localizer["CourseCreated"].Value, courseId = createdCourse.Id });
                }

                return Json(new { success = false, message = _localizer["CourseCreateFailed"].Value });
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

                if (!await IsOwnedCourseAsync(courseDto.Id))
                    return Json(new { success = false, message = _localizer["CannotEditNotYourCourse"].Value });

                if (decimal.TryParse(Request.Form["Price"], NumberStyles.Number, CultureInfo.InvariantCulture, out var priceValue))
                    courseDto.Price = priceValue;
                if (decimal.TryParse(Request.Form["Discount"], NumberStyles.Number, CultureInfo.InvariantCulture, out var discountValue))
                    courseDto.Discount = discountValue;

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

                if (!await IsOwnedCourseAsync(id))
                {
                    return Json(new { success = false, message = _localizer["CannotDeleteNotYourCourses"].Value });
                }

                var isDeleted = await _courseService.DeleteCourseAsInstructorAsync(id);
                if (isDeleted)
                {
                    _logger.LogInformation("Course deleted successfully. ID: {CourseId}", id);
                    TempData["Success"] = _localizer["CourseDeleted"].Value;
                    return Json(new { success = true, message = _localizer["CourseDeleted"].Value });
                }

                _logger.LogWarning("Course deletion failed. ID: {CourseId}", id);
                TempData["Error"] = _localizer["CoursesBulkDeleteError"].Value;
                return Json(new { success = false, message = $"الدورة بمعرف {id} غير موجودة." });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error deleting course ID: {CourseId}", id);
                TempData["Error"] = _localizer["CourseDeleteError"].Value;
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
                    return Json(new { success = false, message = _localizer["NoCoursesSelected"].Value });
                }

                var ownedIds = new List<int>();
                foreach (var courseId in ids)
                {
                    if (await IsOwnedCourseAsync(courseId))
                        ownedIds.Add(courseId);
                }

                if (!ownedIds.Any())
                    return Json(new { success = false, message = _localizer["CannotDeleteNotYourCourses"].Value });

                var result = await _courseService.BulkDeleteCoursesAsInstructorAsync(ownedIds);
                if (result)
                {
                    _logger.LogInformation("Bulk delete completed successfully. Deleted {Count} courses", ownedIds.Count);
                    TempData["Success"] = $"تم حذف {ownedIds.Count} دورة بنجاح.";
                    return Json(new { success = true, message = $"تم حذف {ownedIds.Count} دورة بنجاح." });
                }

                _logger.LogWarning("Bulk delete failed for {Count} courses", ids.Count);
                TempData["Error"] = _localizer["CoursesBulkDeleteError"].Value;
                return Json(new { success = false, message = _localizer["CoursesBulkDeleteError"].Value });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error during bulk delete of {Count} courses", ids?.Count ?? 0);
                TempData["Error"] = _localizer["CoursesBulkDeleteError"].Value;
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

                if (!await IsCurrentInstructorOwnerAsync(course))
                {
                    TempData["Error"] = _localizer["NotYourCourse"].Value;
                    return RedirectToAction(nameof(Index));
                }

                return View(course);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error loading curriculum for course ID: {CourseId}", id);
                TempData["Error"] = _localizer["ErrorLoadingCurriculum"].Value;
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

                if (!await IsCurrentInstructorOwnerAsync(course))
                {
                    TempData["Error"] = _localizer["NotYourCourse"].Value;
                    return RedirectToAction(nameof(Index));
                }

                await LoadCategoriesViewBagAsync();
                return View(course);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error loading settings for course ID: {CourseId}", id);
                TempData["Error"] = _localizer["ErrorLoadingCourseSettings"].Value;
                return RedirectToAction(nameof(Index));
            }
        }

        [HttpPost]
        public async Task<IActionResult> AddSection([FromBody] SectionCreateDTO sectionDto)
        {
            try
            {
                if (sectionDto == null || sectionDto.CourseId <= 0)
                    return Json(new { success = false, message = _localizer["InvalidData"].Value });

                if (!await IsOwnedCourseAsync(sectionDto.CourseId))
                    return Json(new { success = false, message = _localizer["CannotEditNotYourCourse"].Value });

                var section = await _courseService.AddSectionAsync(sectionDto.CourseId, sectionDto);
                if (section == null)
                    return Json(new { success = false, message = _localizer["SectionAddFailed"].Value });

                return Json(new { success = true, section });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error adding section");
                return Json(new { success = false, message = _localizer["SectionAddFailed"].Value });
            }
        }

        [HttpPost]
        public async Task<IActionResult> UpdateSection([FromBody] SectionUpdateDTO sectionDto)
        {
            try
            {
                if (sectionDto == null || sectionDto.Id <= 0)
                    return Json(new { success = false, message = _localizer["InvalidData"].Value });

                if (!await IsOwnedSectionAsync(sectionDto.Id))
                    return Json(new { success = false, message = _localizer["CannotEditNotYourCourse"].Value });

                var section = await _courseService.UpdateSectionAsync(sectionDto.Id, sectionDto);
                if (section == null)
                    return Json(new { success = false, message = _localizer["SectionUpdateFailed"].Value });

                return Json(new { success = true, section });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error updating section");
                return Json(new { success = false, message = _localizer["SectionUpdateFailed"].Value });
            }
        }

        [HttpPost]
        public async Task<IActionResult> DeleteSection([FromBody] int sectionId)
        {
            try
            {
                if (sectionId <= 0)
                    return Json(new { success = false, message = _localizer["InvalidData"].Value });

                if (!await IsOwnedSectionAsync(sectionId))
                    return Json(new { success = false, message = _localizer["CannotEditNotYourCourse"].Value });

                var result = await _courseService.DeleteSectionAsync(sectionId);
                return Json(new { success = result });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error deleting section");
                return Json(new { success = false, message = _localizer["SectionDeleteFailed"].Value });
            }
        }

        [HttpPost]
        [RequestFormLimits(MultipartBodyLengthLimit = 524288000)] // 500MB
        public async Task<IActionResult> AddLecture([FromForm] LectureCreateDTO lectureDto)
        {
            try
            {
                if (lectureDto == null || lectureDto.SectionId <= 0)
                    return Json(new { success = false, message = _localizer["InvalidData"].Value });

                if (!await IsOwnedSectionAsync(lectureDto.SectionId))
                    return Json(new { success = false, message = _localizer["CannotEditNotYourCourse"].Value });

                var lecture = await _courseService.AddLectureAsync(lectureDto.SectionId, lectureDto);
                if (lecture == null)
                    return Json(new { success = false, message = _localizer["LectureAddFailed"].Value });

                return Json(new { success = true, lecture });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error adding lecture");
                return Json(new { success = false, message = _localizer["LectureAddFailed"].Value });
            }
        }

        [HttpPost]
        public async Task<IActionResult> UpdateLecture([FromForm] LectureUpdateDTO lectureDto)
        {
            try
            {
                if (lectureDto == null || lectureDto.Id <= 0)
                    return Json(new { success = false, message = _localizer["InvalidData"].Value });

                if (!await IsOwnedLectureAsync(lectureDto.Id))
                    return Json(new { success = false, message = _localizer["CannotEditNotYourCourse"].Value });

                var lecture = await _courseService.UpdateLectureAsync(lectureDto.Id, lectureDto);
                if (lecture == null)
                    return Json(new { success = false, message = _localizer["LectureUpdateFailed"].Value });

                return Json(new { success = true, lecture });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error updating lecture");
                return Json(new { success = false, message = _localizer["LectureUpdateFailed"].Value });
            }
        }

        [HttpPost]
        public async Task<IActionResult> DeleteLecture([FromBody] int lectureId)
        {
            try
            {
                if (lectureId <= 0)
                    return Json(new { success = false, message = _localizer["InvalidData"].Value });

                if (!await IsOwnedLectureAsync(lectureId))
                    return Json(new { success = false, message = _localizer["CannotEditNotYourCourse"].Value });

                var result = await _courseService.DeleteLectureAsync(lectureId);
                return Json(new { success = result });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error deleting lecture");
                return Json(new { success = false, message = _localizer["LectureDeleteFailed"].Value });
            }
        }

        [HttpPost]
        public async Task<IActionResult> Publish(int courseId)
        {
            try
            {
                if (!await IsOwnedCourseAsync(courseId))
                    return Json(new { success = false, message = _localizer["CannotPublishNotYourCourse"].Value });

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
                var isArabic = System.Globalization.CultureInfo.CurrentUICulture.Name.StartsWith("ar");
                ViewBag.Categories = categories.Select(c => new SelectListItem
                {
                    Value = c.Category_Id.ToString(),
                    Text = isArabic ? c.Category_Name : (c.Category_EnglishName ?? c.Category_Name)
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
        /// يتأكد أن الكورس يخص المدرس الحالي (يمنع الوصول لكورسات مدرسين آخرين بالـ ID المباشر)
        /// </summary>
        private Task<bool> IsCurrentInstructorOwnerAsync(CourseDTO course)
        {
            if (course == null)
                return Task.FromResult(false);

            try
            {
                var token = Request.Cookies["AuthToken"];
                if (string.IsNullOrEmpty(token))
                    return Task.FromResult(false);

                var handler = new System.IdentityModel.Tokens.Jwt.JwtSecurityTokenHandler();
                var jwtToken = handler.ReadJwtToken(token);
                var instructorId = jwtToken.Claims.FirstOrDefault(c => c.Type == "sub")?.Value;

                return Task.FromResult(!string.IsNullOrEmpty(instructorId) && course.InstructorId == instructorId);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error validating course ownership for course ID: {CourseId}", course.Id);
                return Task.FromResult(false);
            }
        }

        private async Task<bool> IsOwnedCourseAsync(int courseId)
        {
            var course = await _courseService.GetCourseByIdAsync(courseId);
            return await IsCurrentInstructorOwnerAsync(course);
        }

        private async Task<bool> IsOwnedSectionAsync(int sectionId)
        {
            var section = await _courseService.GetSectionByIdAsync(sectionId);
            if (section == null)
                return false;
            return await IsOwnedCourseAsync(section.CourseId);
        }

        private async Task<bool> IsOwnedLectureAsync(int lectureId)
        {
            var lecture = await _courseService.GetLectureByIdAsync(lectureId);
            if (lecture == null)
                return false;
            return await IsOwnedSectionAsync(lecture.SectionId);
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
                Price = decimal.Parse(Request.Form["price"], CultureInfo.InvariantCulture),
                Discount = string.IsNullOrEmpty(Request.Form["discount"]) ? 0 : decimal.Parse(Request.Form["discount"], CultureInfo.InvariantCulture),
                CategoryId = int.Parse(Request.Form["CategoryId"]),
                Level = Request.Form["level"],
                Language = Request.Form["language"],
                HasCertificate = true,
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
                Price = decimal.Parse(Request.Form["Price"], CultureInfo.InvariantCulture),
                Discount = string.IsNullOrEmpty(Request.Form["Discount"]) ? null : decimal.Parse(Request.Form["Discount"], CultureInfo.InvariantCulture),
                CategoryId = int.Parse(Request.Form["CategoryId"]),
                Level = Request.Form["Level"],
                Language = Request.Form["Language"],
                HasCertificate = true,
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

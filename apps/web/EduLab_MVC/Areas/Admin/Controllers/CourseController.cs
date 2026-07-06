using EduLab_MVC.Common;
using EduLab_MVC.Models.DTOs.Course;
using EduLab_MVC.Services.ServiceInterfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using System.Text.Json;
using Microsoft.Extensions.Localization;
using EduLab_MVC.Resources;

namespace EduLab_MVC.Areas.Admin.Controllers
{
    [Area("Admin")]
    [Authorize(Roles = SD.Admin)]
    public class CourseController : Controller
    {
        private readonly ICourseService _courseService;
        private readonly ICategoryService _categoryService;
        private readonly IUserService _userService;
        private readonly ILogger<CourseController> _logger;
        private readonly IWebHostEnvironment _webHostEnvironment;
        private readonly IStringLocalizer<SharedResources> _localizer;

        public CourseController(
            ICourseService courseService,
            ILogger<CourseController> logger,
            IWebHostEnvironment webHostEnvironment,
            ICategoryService categoryService,
            IUserService userService,
            IStringLocalizer<SharedResources> localizer)
        {
            _courseService = courseService;
            _categoryService = categoryService;
            _logger = logger;
            _webHostEnvironment = webHostEnvironment;
            _userService = userService;
            _localizer = localizer;
        }

        #region View Actions

        public async Task<IActionResult> Index(CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Loading admin courses index page");

                var courses = await _courseService.GetAllCoursesAsync(cancellationToken);
                await LoadCategoriesViewBagAsync(cancellationToken);

                if (courses == null || !courses.Any())
                {
                    TempData["Warning"] = _localizer["NoCoursesAvailable"].Value;
                }

                _logger.LogInformation("Loaded {Count} courses for admin index", courses?.Count ?? 0);
                return View(courses);
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Courses index page loading was cancelled");
                TempData["Error"] = _localizer["PageLoadCancelled"].Value;
                return View(new List<CourseDTO>());
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error loading courses index page");
                TempData["Error"] = _localizer["CourseLoadError"].Value;
                return View(new List<CourseDTO>());
            }
        }

        [HttpGet]
        public async Task<IActionResult> Create(CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Loading admin course creation form");

                await LoadCategoriesViewBagAsync(cancellationToken);
                return View();
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Course creation form loading was cancelled");
                TempData["Error"] = _localizer["FormLoadCancelled"].Value;
                return RedirectToAction(nameof(Index));
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error loading course creation form");
                TempData["Error"] = _localizer["FormLoadError"].Value;
                return RedirectToAction(nameof(Index));
            }
        }

        [HttpGet]
        public IActionResult Edit(int id)
        {
            return RedirectToAction("Settings", new { id });
        }

        [HttpGet]
        public async Task<IActionResult> Curriculum(int id, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Loading curriculum page for course ID: {CourseId}", id);

                var course = await _courseService.GetCourseByIdAsync(id, cancellationToken);
                if (course == null)
                    return NotFound();

                return View(course);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error loading curriculum for course ID: {CourseId}", id);
                TempData["Error"] = _localizer["ErrorOccurred"].Value;
                return RedirectToAction(nameof(Index));
            }
        }

        [HttpGet]
        public async Task<IActionResult> Settings(int id, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Loading settings page for course ID: {CourseId}", id);

                var course = await _courseService.GetCourseByIdAsync(id, cancellationToken);
                if (course == null)
                    return NotFound();

                await LoadCategoriesViewBagAsync(cancellationToken);
                return View(course);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error loading settings for course ID: {CourseId}", id);
                TempData["Error"] = _localizer["ErrorOccurred"].Value;
                return RedirectToAction(nameof(Index));
            }
        }

        #endregion

        #region API / Data Actions

        [HttpGet]
        public async Task<IActionResult> Details(int id, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Getting course details for ID: {CourseId}", id);

                var course = await _courseService.GetCourseByIdAsync(id, cancellationToken);
                if (course == null)
                {
                    return Json(new { success = false, message = _localizer["CourseNotFoundJson", id] });
                }

                return Json(new { success = true, course });
            }
            catch (OperationCanceledException)
            {
                return Json(new { success = false, message = _localizer["OperationCancelledJson"] });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting course details for ID: {CourseId}", id);
                return Json(new { success = false, message = _localizer["CourseDetailsFetchError"] });
            }
        }

        [HttpGet]
        public async Task<IActionResult> GetCategories(CancellationToken cancellationToken = default)
        {
            try
            {
                var categories = await _categoryService.GetAllCategoriesAsync(cancellationToken);
                if (categories == null || !categories.Any())
                    return Json(new { success = false, message = _localizer["NoCategoriesAvailable"] });

                return Json(new { success = true, data = categories.Select(c => new { id = c.Category_Id, name = c.Category_Name }) });
            }
            catch (OperationCanceledException)
            {
                return Json(new { success = false, message = _localizer["OperationCancelledJson"] });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting categories");
                return Json(new { success = false, message = _localizer["CategoriesFetchError"] });
            }
        }

        [HttpGet]
        public async Task<IActionResult> GetInstructors(CancellationToken cancellationToken = default)
        {
            try
            {
                var instructors = await _userService.GetInstructorsAsync();
                if (instructors == null || !instructors.Any())
                    return Json(new { success = false, message = _localizer["NoInstructorsAvailable"] });

                return Json(new { success = true, data = instructors.Select(i => new { id = i.Id, name = i.FullName }) });
            }
            catch (OperationCanceledException)
            {
                return Json(new { success = false, message = _localizer["OperationCancelledJson"] });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting instructors");
                return Json(new { success = false, message = _localizer["InstructorsFetchError"] });
            }
        }

        #endregion

        #region Course CRUD

        [HttpPost]
        public async Task<IActionResult> CreateCourse([FromForm] CourseDraftDTO draftDto)
        {
            try
            {
                _logger.LogInformation("Admin creating course");

                if (draftDto == null || string.IsNullOrWhiteSpace(draftDto.Title))
                    return Json(new { success = false, message = _localizer["CourseTitleRequired"] });

                if (draftDto.CategoryId <= 0)
                    return Json(new { success = false, message = _localizer["CategoryRequired"] });

                var createdCourse = await _courseService.AdminCreateCourseDraftAsync(draftDto);

                if (createdCourse != null)
                {
                    _logger.LogInformation("Course created by admin. ID: {CourseId}", createdCourse.Id);
                    return Json(new { success = true, message = _localizer["CourseCreated"], courseId = createdCourse.Id });
                }

                return Json(new { success = false, message = _localizer["CourseCreateFailed"] });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error during admin course creation");
                return Json(new { success = false, message = $"{_localizer["CourseCreateError"]}: {ex.Message}" });
            }
        }

        [RequestFormLimits(MultipartBodyLengthLimit = 4_000_000_000)]
        [RequestSizeLimit(4_000_000_000)]
        [HttpPost]
        public async Task<IActionResult> Edit()
        {
            try
            {
                _logger.LogInformation("Starting admin course update process");

                if (!int.TryParse(Request.Form["id"], out int id))
                    return Json(new { success = false, message = _localizer["InvalidCourseId"] });

                var course = CreateCourseUpdateFromFormData(id);

                if (!string.IsNullOrEmpty(Request.Form["Description"]))
                    course.Description = Request.Form["Description"];

                var image = Request.Form.Files["Image"];
                if (image != null && image.Length > 0)
                    course.Image = image;
                else if (!string.IsNullOrEmpty(Request.Form["ThumbnailUrl"]))
                    course.ThumbnailUrl = Request.Form["ThumbnailUrl"];

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
                                if (updatedLecture != null && lecture.Resources != null && lecture.Resources.Any())
                                {
                                    if (updatedLecture.Resources == null)
                                        updatedLecture.Resources = new List<LectureResourceDTO>();
                                    foreach (var oldRes in lecture.Resources)
                                    {
                                        if (!updatedLecture.Resources.Any(r => r.Id == oldRes.Id))
                                            updatedLecture.Resources.Add(oldRes);
                                    }
                                }
                            }
                        }
                    }
                }

                await ParseAndProcessSectionsWithResourcesAsync(course);
                var updatedCourse = await _courseService.UpdateCourseAsync(id, course);

                if (updatedCourse != null)
                {
                    _logger.LogInformation("Course updated by admin. ID: {CourseId}", id);
                    return Json(new { success = true, message = _localizer["CourseUpdated"] });
                }

                return Json(new { success = false, message = _localizer["CourseUpdateFailed"] });
            }
            catch (OperationCanceledException)
            {
                return Json(new { success = false, message = _localizer["OperationCancelledJson"] });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error during admin course update");
                return Json(new { success = false, message = _localizer["CourseUpdateError", ex.Message] });
            }
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Delete(int id, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Admin deleting course ID: {CourseId}", id);

                var isDeleted = await _courseService.DeleteCourseAsync(id, cancellationToken);
                if (isDeleted)
                {
                    _logger.LogInformation("Course deleted by admin. ID: {CourseId}", id);
                    return Json(new { success = true, message = _localizer["CourseDeleted"] });
                }

                return Json(new { success = false, message = _localizer["CourseNotFoundJson", id] });
            }
            catch (OperationCanceledException)
            {
                return Json(new { success = false, message = _localizer["OperationCancelledJson"] });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error deleting course ID: {CourseId}", id);
                return Json(new { success = false, message = _localizer["CourseDeleteError", ex.Message] });
            }
        }

        #endregion

        #region Section & Lecture Management

        [HttpPost]
        public async Task<IActionResult> AddSection([FromBody] SectionCreateDTO sectionDto)
        {
            try
            {
                if (sectionDto == null || sectionDto.CourseId <= 0)
                    return Json(new { success = false, message = _localizer["InvalidData"] });

                var section = await _courseService.AdminAddSectionAsync(sectionDto.CourseId, sectionDto);
                if (section == null)
                    return Json(new { success = false, message = _localizer["SectionAddFailed"] });

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
                    return Json(new { success = false, message = _localizer["InvalidData"] });

                var section = await _courseService.AdminUpdateSectionAsync(sectionDto.Id, sectionDto);
                if (section == null)
                    return Json(new { success = false, message = _localizer["SectionUpdateFailed"] });

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
                    return Json(new { success = false, message = _localizer["InvalidData"] });

                var result = await _courseService.AdminDeleteSectionAsync(sectionId);
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
                    return Json(new { success = false, message = _localizer["InvalidData"] });

                var lecture = await _courseService.AdminAddLectureAsync(lectureDto.SectionId, lectureDto);
                if (lecture == null)
                    return Json(new { success = false, message = _localizer["LectureAddFailed"] });

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
                    return Json(new { success = false, message = _localizer["InvalidData"] });

                var lecture = await _courseService.AdminUpdateLectureAsync(lectureDto.Id, lectureDto);
                if (lecture == null)
                    return Json(new { success = false, message = _localizer["LectureUpdateFailed"] });

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
                    return Json(new { success = false, message = _localizer["InvalidData"] });

                var result = await _courseService.AdminDeleteLectureAsync(lectureId);
                return Json(new { success = result });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error deleting lecture");
                return Json(new { success = false, message = ex.Message });
            }
        }

        [HttpPost]
        public async Task<IActionResult> AddResourceToLecture(int lectureId, IFormFile resourceFile, CancellationToken cancellationToken = default)
        {
            try
            {
                if (resourceFile == null || resourceFile.Length == 0)
                    return Json(new { success = false, message = _localizer["FileRequired"] });

                var result = await _courseService.AddResourceToLectureAsync(lectureId, resourceFile, cancellationToken);
                if (result == null)
                    return Json(new { success = false, message = _localizer["ResourceAddFailed"] });

                return Json(new { success = true, resource = result });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error adding resource to lecture {LectureId}", lectureId);
                return Json(new { success = false, message = _localizer["ResourceAddError"] });
            }
        }

        [HttpPost]
        public async Task<IActionResult> DeleteResource(int resourceId, CancellationToken cancellationToken = default)
        {
            try
            {
                var result = await _courseService.DeleteResourceAsync(resourceId, cancellationToken);
                if (!result)
                    return Json(new { success = false, message = _localizer["ResourceDeleteFailed"] });

                return Json(new { success = true, message = _localizer["ResourceDeletedSuccess"] });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error deleting resource {ResourceId}", resourceId);
                return Json(new { success = false, message = _localizer["ResourceDeleteError"] });
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
                return Json(new { success = false, message = _localizer["ResourcesFetchError"] });
            }
        }

        #endregion

        #region Publish (Admin = Approve)

        [HttpPost]
        public async Task<IActionResult> Publish(int courseId)
        {
            try
            {
                _logger.LogInformation("Admin publishing course ID: {CourseId}", courseId);

                var result = await _courseService.AdminPublishCourseAsync(courseId);
                if (result == null)
                    return Json(new { success = false, message = _localizer["PublishFailed"] });

                if (result.Success)
                {
                    return Json(new { success = true, message = _localizer["CourseApprovedDirectly"] });
                }

                return Json(result);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error publishing course ID: {CourseId}", courseId);
                return Json(new { success = false, message = _localizer["ErrorOccurred"] });
            }
        }

        #endregion

        #region Status Management

        [HttpPost]
        public async Task<IActionResult> Accept(int id, CancellationToken cancellationToken = default)
        {
            try
            {
                var result = await _courseService.AcceptCourseAsync(id, cancellationToken);
                if (result)
                    TempData["Success"] = _localizer["CourseAccepted"].Value;
                else
                    TempData["Error"] = _localizer["CourseAcceptError"].Value;

                return RedirectToAction(nameof(Index));
            }
            catch (OperationCanceledException)
            {
                TempData["Error"] = _localizer["OperationCancelledJson"].Value;
                return RedirectToAction(nameof(Index));
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error accepting course ID: {CourseId}", id);
                TempData["Error"] = _localizer["CourseAcceptError"].Value;
                return RedirectToAction(nameof(Index));
            }
        }

        [HttpPost]
        public async Task<IActionResult> Reject(int id, CancellationToken cancellationToken = default)
        {
            try
            {
                var result = await _courseService.RejectCourseAsync(id, cancellationToken);
                if (result)
                    TempData["Success"] = _localizer["CourseRejected"].Value;
                else
                    TempData["Error"] = _localizer["CourseRejectError"].Value;

                return RedirectToAction(nameof(Index));
            }
            catch (OperationCanceledException)
            {
                TempData["Error"] = _localizer["OperationCancelledJson"].Value;
                return RedirectToAction(nameof(Index));
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error rejecting course ID: {CourseId}", id);
                TempData["Error"] = _localizer["CourseRejectError"].Value;
                return RedirectToAction(nameof(Index));
            }
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> BulkDelete([FromBody] List<int> ids, CancellationToken cancellationToken = default)
        {
            try
            {
                if (ids == null || !ids.Any())
                    return Json(new { success = false, message = _localizer["NoCoursesSelected"] });

                var result = await _courseService.BulkDeleteCoursesAsync(ids, cancellationToken);
                if (result)
                    return Json(new { success = true, message = _localizer["CoursesBulkDeleted", ids.Count] });

                return Json(new { success = false, message = _localizer["CoursesDeleteError"] });
            }
            catch (OperationCanceledException)
            {
                return Json(new { success = false, message = _localizer["OperationCancelledJson"] });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error during bulk delete");
                return Json(new { success = false, message = _localizer["CoursesBulkDeleteError", ex.Message] });
            }
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> AcceptMultiple([FromBody] List<int> ids, CancellationToken cancellationToken = default)
        {
            try
            {
                if (ids == null || !ids.Any())
                    return Json(new { success = false, message = _localizer["NoCoursesForAction"] });

                var successCount = 0;
                foreach (var id in ids)
                {
                    var result = await _courseService.AcceptCourseAsync(id, cancellationToken);
                    if (result) successCount++;
                }

                return Json(new { success = true, message = _localizer["CoursesBulkAccepted", successCount, ids.Count] });
            }
            catch (OperationCanceledException)
            {
                return Json(new { success = false, message = _localizer["OperationCancelledJson"] });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error accepting multiple courses");
                return Json(new { success = false, message = _localizer["CoursesBulkAcceptError"], error = ex.Message });
            }
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> RejectMultiple([FromBody] List<int> ids, CancellationToken cancellationToken = default)
        {
            try
            {
                if (ids == null || !ids.Any())
                    return Json(new { success = false, message = _localizer["NoCoursesForAction"] });

                var successCount = 0;
                foreach (var id in ids)
                {
                    var result = await _courseService.RejectCourseAsync(id, cancellationToken);
                    if (result) successCount++;
                }

                return Json(new { success = true, message = _localizer["CoursesBulkRejected", successCount, ids.Count] });
            }
            catch (OperationCanceledException)
            {
                return Json(new { success = false, message = _localizer["OperationCancelledJson"] });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error rejecting multiple courses");
                return Json(new { success = false, message = _localizer["CoursesBulkRejectError"], error = ex.Message });
            }
        }

        #endregion

        #region Filter Operations

        public async Task<IActionResult> CoursesByInstructor(string instructorId, CancellationToken cancellationToken = default)
        {
            try
            {
                var courses = await _courseService.GetCoursesByInstructorAsync(instructorId, cancellationToken);
                await LoadCategoriesViewBagAsync(cancellationToken);
                return View("Index", courses);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting courses by instructor");
                TempData["Error"] = _localizer["InstructorCoursesFetchError"].Value;
                return RedirectToAction(nameof(Index));
            }
        }

        #endregion

        #region Private Helpers

        private async Task LoadCategoriesViewBagAsync(CancellationToken cancellationToken = default)
        {
            try
            {
                var categories = await _categoryService.GetAllCategoriesAsync(cancellationToken);
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
                Sections = new List<SectionDTO>()
            };
        }

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

                        var videoFile = Request.Form.Files[$"video_{section.Order - 1}_{lecture.Order - 1}"];
                        if (videoFile != null && videoFile.Length > 0)
                            lecture.Video = videoFile;
                        else
                            lecture.VideoUrl = lecture.VideoUrl;

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

                        var oldLecture = course.Sections?
                            .FirstOrDefault(s => s.Id == section.Id)?
                            .Lectures?.FirstOrDefault(l => l.Id == lecture.Id);

                        if (oldLecture?.Resources != null && oldLecture.Resources.Any())
                        {
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

        #endregion
    }
}

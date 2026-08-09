using AutoMapper;
using EduLab_Application.ServiceInterfaces;
using EduLab_Application.DTOs.Course;
using EduLab_Application.DTOs.Lecture;
using EduLab_Application.Common;
using EduLab_Domain.Entities;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using System.ComponentModel;
using System.Text.Json;
using System.Threading;
using EduLab_Application.Common.Constants;
using EduLab_Application.DTOs.Section;
using EduLab_API.Models;

namespace EduLab_API.Controllers.Admin
{
    /// <summary>
    /// Controller for managing courses
    /// </summary>
    [Route("api/[controller]")]
    [ApiController]
    [Produces("application/json")]
    [DisplayName("Course Management")]
    [Description("APIs for managing courses, including CRUD operations and bulk actions")]
    public class CourseController : ControllerBase
    {
        private readonly ICourseService _courseService;
        private readonly IFileStorageService _fileStorageService;
        private readonly IMapper _mapper;
        private readonly ICurrentUserService _currentUserService;
        private readonly IHistoryService _historyService;
        private readonly ILogger<CourseController> _logger;
        private readonly IConfiguration _configuration;
        private readonly UserManager<ApplicationUser> _userManager;

        /// <summary>
        /// Initializes a new instance of the CourseController class
        /// </summary>
        /// <param name="courseService">Course service</param>
        /// <param name="fileStorageService">File storage service</param>
        /// <param name="mapper">AutoMapper instance</param>
        /// <param name="logger">Logger instance</param>
        public CourseController(
            ICourseService courseService,
            IFileStorageService fileStorageService,
            IMapper mapper,
            ICurrentUserService currentUserService,
            IHistoryService historyService,
            ILogger<CourseController> logger,
            IConfiguration configuration,
            UserManager<ApplicationUser> userManager)
        {
            _courseService = courseService;
            _fileStorageService = fileStorageService;
            _mapper = mapper;
            _currentUserService = currentUserService;
            _historyService = historyService;
            _logger = logger;
            _configuration = configuration;
            _userManager = userManager;
        }

        #region EduLab Access Guards

        private static string? _cachedEduLabInstructorId;

        /// <summary>
        /// يجلب ID حساب مدرب المنصة (EduLab) من إيميله في appsettings.json
        /// </summary>
        private async Task<string> GetEduLabInstructorIdAsync()
        {
            if (!string.IsNullOrEmpty(_cachedEduLabInstructorId))
                return _cachedEduLabInstructorId!;

            var fallback = SD.EduLabInstructorId;
            var email = _configuration["EduLab:InstructorEmail"];
            if (string.IsNullOrEmpty(email))
            {
                _cachedEduLabInstructorId = fallback;
                return fallback;
            }

            try
            {
                var user = await _userManager.FindByEmailAsync(email);
                _cachedEduLabInstructorId = user?.Id ?? fallback;
            }
            catch
            {
                _cachedEduLabInstructorId = fallback;
            }

            return _cachedEduLabInstructorId;
        }

        private async Task<bool> IsEduLabCourseAsync(CourseDTO course)
        {
            if (course?.InstructorId == SD.EduLabInstructorId)
                return true;
            return course?.InstructorId == await GetEduLabInstructorIdAsync();
        }

        private async Task<bool> CanAdminViewCourseAsync(CourseDTO course) =>
            await IsEduLabCourseAsync(course) || (course != null && course.Status != SD.CourseStatusDraft);

        private IActionResult ForbiddenCourseAccess() =>
            StatusCode(StatusCodes.Status403Forbidden, new { success = false, message = "لا يمكنك الوصول لهذا الكورس — إدارة الكورسات متاحة لكورسات المنصة (EduLab) فقط" });

        /// <summary>
        /// يمنع الوصول لأي كورس ليس تابعًا للمنصة (EduLab) أو غير معروض للمراجعة
        /// </summary>
        private async Task<CourseDTO> LoadAdminCourseAsync(int courseId, bool requireManage, CancellationToken cancellationToken)
        {
            var course = await _courseService.GetCourseByIdAsync(courseId, cancellationToken);
            if (course == null) return null;
            if (requireManage ? await IsEduLabCourseAsync(course) : await CanAdminViewCourseAsync(course)) return course;
            return null;
        }

        #endregion

        #region Get Operations

        /// <summary>
        /// Gets all courses
        /// </summary>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>List of all courses</returns>
        /// <response code="200">Returns the list of courses</response>
        /// <response code="404">If no courses are found</response>
        /// <response code="500">If there was an internal server error</response>
        [HttpGet]
        [ProducesResponseType(typeof(IEnumerable<CourseDTO>), StatusCodes.Status200OK)]
        [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status404NotFound)]
        [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status500InternalServerError)]
        public async Task<IActionResult> GetAllCourses(CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Getting all courses");

                var courses = await _courseService.GetAllCoursesAsync(cancellationToken);
                if (courses == null || !courses.Any())
                {
                    _logger.LogWarning("No courses found");
                    return NotFound(new { message = "No courses found" });
                }

                var userId = await _currentUserService.GetUserIdAsync();
                if (!string.IsNullOrEmpty(userId))
                    await _historyService.LogOperationAsync(userId, "قام المستخدم بعرض جميع الكورسات.", OperationType.View, HistoryMessages.CoursesViewed, null, CancellationToken.None);

                _logger.LogInformation("Retrieved {Count} courses", courses.Count());
                return Ok(courses);
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Get all courses operation was cancelled");
                return StatusCode(499, new { message = "Request was cancelled" }); // Client closed request
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while retrieving courses");
                return StatusCode(500, new { message = "An error occurred while retrieving courses", error = ex.Message });
            }
        }

        /// <summary>
        /// Gets a course by ID
        /// </summary>
        /// <param name="id">Course ID</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Course details</returns>
        /// <response code="200">Returns the course</response>
        /// <response code="404">If course is not found</response>
        /// <response code="500">If there was an internal server error</response>
        [HttpGet("{id:int}")]
        [ProducesResponseType(typeof(CourseDTO), StatusCodes.Status200OK)]
        [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status404NotFound)]
        [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status500InternalServerError)]
        public async Task<IActionResult> GetCourseById(int id, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Getting course by ID: {CourseId}", id);

                var course = await _courseService.GetCourseByIdAsync(id, cancellationToken);
                if (course == null)
                {
                    _logger.LogWarning("Course not found. ID: {CourseId}", id);
                    return NotFound(new { message = $"No course found with ID {id}" });
                }

                // قيد العرض يخص الـ Admin فقط — المدرسين والمتعلمين يستخدمون نفس الـ endpoint
                if (User.IsInRole(SD.Admin) && !await CanAdminViewCourseAsync(course))
                    return ForbiddenCourseAccess();

                var userId = await _currentUserService.GetUserIdAsync();
                if (!string.IsNullOrEmpty(userId))
                    await _historyService.LogOperationAsync(userId, $"قام المستخدم بعرض الكورس [ID: {id}] بعنوان \"{course.Title}\".", OperationType.View, HistoryMessages.CourseViewed,
                        JsonSerializer.Serialize(new { id }), CancellationToken.None);

                _logger.LogInformation("Retrieved course ID: {CourseId}", id);
                return Ok(course);
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Get course by ID operation was cancelled. ID: {CourseId}", id);
                return StatusCode(499, new { message = "Request was cancelled" });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while retrieving course ID: {CourseId}", id);
                return StatusCode(500, new { message = "An error occurred while retrieving the course", error = ex.Message });
            }
        }

        /// <summary>
        /// Gets courses by instructor ID
        /// </summary>
        /// <param name="instructorId">Instructor ID</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>List of courses by instructor</returns>
        /// <response code="200">Returns the list of courses</response>
        /// <response code="404">If no courses are found for the instructor</response>
        /// <response code="500">If there was an internal server error</response>
        [HttpGet("instructor/{instructorId}")]
        [ProducesResponseType(typeof(IEnumerable<CourseDTO>), StatusCodes.Status200OK)]
        [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status404NotFound)]
        [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status500InternalServerError)]
        public async Task<IActionResult> GetCoursesByInstructor(string instructorId, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Getting courses for instructor ID: {InstructorId}", instructorId);

                var courses = await _courseService.GetInstructorCoursesAsync(instructorId, cancellationToken);
                if (courses == null || !courses.Any())
                {
                    _logger.LogWarning("No courses found for instructor ID: {InstructorId}", instructorId);
                    return NotFound(new { message = $"No courses found for instructor with ID {instructorId}" });
                }

                _logger.LogInformation("Retrieved {Count} courses for instructor ID: {InstructorId}", courses.Count(), instructorId);
                return Ok(courses);
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Get courses by instructor operation was cancelled. Instructor ID: {InstructorId}", instructorId);
                return StatusCode(499, new { message = "Request was cancelled" });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while retrieving courses for instructor ID: {InstructorId}", instructorId);
                return StatusCode(500, new { message = "An error occurred while retrieving courses by instructor", error = ex.Message });
            }
        }

        /// <summary>
        /// Gets courses by category ID
        /// </summary>
        /// <param name="categoryId">Category ID</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>List of courses in category</returns>
        /// <response code="200">Returns the list of courses</response>
        /// <response code="404">If no courses are found for the category</response>
        /// <response code="500">If there was an internal server error</response>
        [HttpGet("category/{categoryId:int}")]
        [ProducesResponseType(typeof(IEnumerable<CourseDTO>), StatusCodes.Status200OK)]
        [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status404NotFound)]
        [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status500InternalServerError)]
        public async Task<IActionResult> GetCoursesWithCategory(int categoryId, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Getting courses for category ID: {CategoryId}", categoryId);

                var courses = await _courseService.GetCoursesWithCategoryAsync(categoryId, cancellationToken);
                if (courses == null || !courses.Any())
                {
                    _logger.LogWarning("No courses found for category ID: {CategoryId}", categoryId);
                    return NotFound(new { message = $"No courses found for category ID {categoryId}" });
                }

                _logger.LogInformation("Retrieved {Count} courses for category ID: {CategoryId}", courses.Count(), categoryId);
                return Ok(courses);
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Get courses by category operation was cancelled. Category ID: {CategoryId}", categoryId);
                return StatusCode(499, new { message = "Request was cancelled" });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while retrieving courses for category ID: {CategoryId}", categoryId);
                return StatusCode(500, new { message = "An error occurred while retrieving courses with category", error = ex.Message });
            }
        }
        /// <summary>
        /// Gets resources for a lecture
        /// </summary>
        [HttpGet("lecture/{lectureId}/resources")]
        [ProducesResponseType(typeof(List<LectureResourceDTO>), StatusCodes.Status200OK)]
        [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status500InternalServerError)]
        public async Task<IActionResult> GetLectureResources(int lectureId, CancellationToken cancellationToken = default)
        {
            try
            {
                // قيد الوصول يخص الـ Admin فقط — المدرسون والمتعلمون يستخدمون نفس الـ endpoint
                if (User.IsInRole(SD.Admin))
                {
                    var resourcesCourseId = await _courseService.GetCourseIdByLectureAsync(lectureId, cancellationToken);
                    var resourcesCourse = resourcesCourseId.HasValue
                        ? await LoadAdminCourseAsync(resourcesCourseId.Value, true, cancellationToken)
                        : null;
                    if (resourcesCourse == null)
                        return ForbiddenCourseAccess();
                }

                var resources = await _courseService.GetLectureResourcesAsync(lectureId, cancellationToken);

                // لو السيرفيس رجّع null أو مفيش أي موارد، هنرجع ليستة فاضية (مش NotFound)
                if (resources == null || !resources.Any())
                {
                    return Ok(new List<LectureResourceDTO>());
                }

                return Ok(resources);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting resources for lecture ID: {LectureId}", lectureId);

                var problemDetails = new ProblemDetails
                {
                    Status = StatusCodes.Status500InternalServerError,
                    Title = "خطأ في الخادم",
                    Detail = "حدث خطأ أثناء جلب الموارد. برجاء المحاولة لاحقًا.",
                    Extensions = { ["traceId"] = HttpContext.TraceIdentifier }
                };

                return StatusCode(StatusCodes.Status500InternalServerError, problemDetails);
            }
        }

        #endregion

        #region Create Operations

        /// <summary>
        /// Creates a new course
        /// </summary>
        /// <param name="course">Course data</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Created course</returns>
        /// <response code="201">Returns the created course</response>
        /// <response code="400">If the data is invalid</response>
        /// <response code="401">If user is not authenticated</response>
        /// <response code="403">If user is not authorized</response>
        /// <response code="500">If there was an internal server error</response>
        [RequestFormLimits(MultipartBodyLengthLimit = 4_000_000_000)]
        [RequestSizeLimit(4_000_000_000)]
        [HttpPost]
        [Consumes("multipart/form-data")]
        [Authorize(Policy = "AdminArea")]
        [ProducesResponseType(typeof(CourseDTO), StatusCodes.Status201Created)]
        [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status400BadRequest)]
        [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status401Unauthorized)]
        [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status403Forbidden)]
        [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status500InternalServerError)]
        public async Task<IActionResult> AddCourse([FromForm] CourseCreateDTO course, CancellationToken cancellationToken = default)
        {
            if (course == null)
            {
                _logger.LogWarning("Add course request with null data");
                return BadRequest(new { message = "البيانات ناقصة" });
            }

            if (string.IsNullOrEmpty(course.InstructorId))
            {
                _logger.LogWarning("Add course request with missing instructor ID");
                return BadRequest(new { message = "معرف المدرب ناقص" });
            }



            try
            {
                _logger.LogInformation("Adding new course: {CourseTitle}", course.Title);

                course.ThumbnailUrl = course.ThumbnailUrl ?? "/Images/Courses/default.jpg";

                // Handle image upload
                if (course.Image != null && course.Image.Length > 0)
                {
                    _logger.LogInformation("Uploading image for course: {CourseTitle}, Size: {Size} bytes",
                        course.Title, course.Image.Length);

                    var thumbnailUrl = await _fileStorageService.UploadFileAsync(course.Image, "Images/Courses", cancellationToken);
                    course.ThumbnailUrl = thumbnailUrl ?? course.ThumbnailUrl;

                    _logger.LogInformation("Image uploaded successfully. Thumbnail URL: {ThumbnailUrl}", course.ThumbnailUrl);
                }
                else
                {
                    _logger.LogInformation("No image uploaded for course: {CourseTitle}", course.Title);
                }

                // Handle lectures and videos + resources
                if (course.Sections != null && course.Sections.Any())
                {
                    foreach (var section in course.Sections)
                    {
                        if (section.Lectures != null && section.Lectures.Any())
                        {
                            foreach (var lecture in section.Lectures)
                            {
                                // 🎥 رفع الفيديو
                                var contentType = lecture.ContentType?.Trim().ToLower();
                                if (lecture.Video != null && contentType == "video")
                                {
                                    lecture.VideoUrl = await _fileStorageService.UploadFileAsync(
                                        lecture.Video, "Videos/Courses", cancellationToken
                                    ) ?? "";
                                }
                                else if (contentType != "video")
                                {
                                    lecture.VideoUrl = "";
                                }

                                // 📂 رفع الموارد (Resources داخل DTO)
                                if (lecture.Resources != null && lecture.Resources.Any())
                                {
                                    foreach (var res in lecture.Resources)
                                    {
                                        if (res.File != null && res.File.Length > 0)
                                        {
                                            res.FileUrl = await _fileStorageService.UploadFileAsync(
                                                res.File, "Resources/Lectures", cancellationToken
                                            );

                                            res.FileName = res.File.FileName;
                                            res.FileType = res.File.ContentType;
                                            res.FileSize = res.File.Length;
                                        }
                                    }
                                }

                                // 📂 رفع الموارد (ResourceFiles لو مبعوتة كـ List<IFormFile>)
                                if (lecture.ResourceFiles != null && lecture.ResourceFiles.Any())
                                {
                                    foreach (var file in lecture.ResourceFiles)
                                    {
                                        var fileUrl = await _fileStorageService.UploadFileAsync(
                                            file, "Resources/Lectures", cancellationToken
                                        );

                                        lecture.Resources.Add(new LectureResourceDTO
                                        {
                                            FileName = file.FileName,
                                            FileUrl = fileUrl,
                                            FileType = file.ContentType,
                                            FileSize = file.Length
                                        });
                                    }
                                }
                            }
                        }
                    }
                }



                var createdCourse = await _courseService.AddCourseAsync(course, cancellationToken);

                var userId = await _currentUserService.GetUserIdAsync();
                if (!string.IsNullOrEmpty(userId))
                    await _historyService.LogOperationAsync(userId, $"قام المستخدم بإضافة كورس جديد [ID: {createdCourse.Id}] بعنوان \"{createdCourse.Title}\".", OperationType.Create, HistoryMessages.CourseCreated,
                        JsonSerializer.Serialize(new { id = createdCourse.Id, title = createdCourse.Title }), CancellationToken.None);

                _logger.LogInformation("Course created successfully. ID: {CourseId}, Title: {CourseTitle}",
                    createdCourse.Id, createdCourse.Title);

                return CreatedAtAction(nameof(GetCourseById), new { id = createdCourse.Id }, createdCourse);
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Add course operation was cancelled. Course: {CourseTitle}", course.Title);
                return StatusCode(499, new { message = "Request was cancelled" });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while adding course: {CourseTitle}", course.Title);
                return StatusCode(500, new
                {
                    message = "في مشكلة",
                    error = ex.Message,
                    innerError = ex.InnerException?.Message
                });
            }
        }
        [HttpPost("lecture/{lectureId}/resources")]
        public async Task<IActionResult> AddResourceToLecture(int lectureId, IFormFile resourceFile, CancellationToken cancellationToken = default)
        {
            try
            {
                // قيد الوصول يخص الـ Admin فقط — المدرسون يستخدمون نفس الـ endpoint
                if (User.IsInRole(SD.Admin))
                {
                    var addResourceCourseId = await _courseService.GetCourseIdByLectureAsync(lectureId, cancellationToken);
                    var addResourceCourse = addResourceCourseId.HasValue
                        ? await LoadAdminCourseAsync(addResourceCourseId.Value, true, cancellationToken)
                        : null;
                    if (addResourceCourse == null)
                        return ForbiddenCourseAccess();
                }

                var resource = await _courseService.AddResourceToLectureAsync(lectureId, resourceFile, cancellationToken);
                var userId = await _currentUserService.GetUserIdAsync();
                if (!string.IsNullOrEmpty(userId))
                    await _historyService.LogOperationAsync(userId, $"قام المستخدم بإضافة مورد للمحاضرة [ID: {lectureId}] باسم \"{resource?.FileName}\".", OperationType.Create, HistoryMessages.ResourceAdded, null, CancellationToken.None);
                return Ok(resource);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }
        #endregion

        #region Update Operations

        /// <summary>
        /// Updates an existing course
        /// </summary>
        /// <param name="id">Course ID</param>
        /// <param name="course">Updated course data</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Updated course</returns>
        /// <response code="200">Returns the updated course</response>
        /// <response code="400">If the data is invalid</response>
        /// <response code="404">If course is not found</response>
        /// <response code="401">If user is not authenticated</response>
        /// <response code="403">If user is not authorized</response>
        /// <response code="500">If there was an internal server error</response>
        /// <summary>
        /// Updates an existing course
        /// </summary>
        [RequestFormLimits(MultipartBodyLengthLimit = 4_000_000_000)]
        [RequestSizeLimit(4_000_000_000)]
        [HttpPut("{id:int}")]
        [Consumes("multipart/form-data")]
        [Authorize(Policy = "AdminArea")]
        [ProducesResponseType(typeof(CourseDTO), StatusCodes.Status200OK)]
        [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status400BadRequest)]
        [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status404NotFound)]
        [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status401Unauthorized)]
        [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status403Forbidden)]
        [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status500InternalServerError)]
        public async Task<IActionResult> UpdateCourse(int id, [FromForm] CourseUpdateDTO course, CancellationToken cancellationToken = default)
        {
            if (course == null || course.Id != id)
            {
                _logger.LogWarning("Update course request with invalid data. ID: {CourseId}", id);
                return BadRequest(new { message = "البيانات غير صالحة" });
            }

            try
            {
                _logger.LogInformation("Updating course ID: {CourseId}", id);

                var existingCourse = await _courseService.GetCourseByIdAsync(id, cancellationToken);
                if (existingCourse == null)
                {
                    _logger.LogWarning("Course not found for update. ID: {CourseId}", id);
                    return NotFound(new { message = "الكورس غير موجود" });
                }

                if (!await IsEduLabCourseAsync(existingCourse))
                    return ForbiddenCourseAccess();

                string oldImageUrl = null;
                List<string> oldVideoUrls = new();
                List<string> oldResourceFiles = new();

                // Handle image upload - بنفس طريقة الـ Add
                if (course.Image != null && course.Image.Length > 0)
                {
                    _logger.LogInformation("Uploading new image for course ID: {CourseId}", id);

                    oldImageUrl = existingCourse.ThumbnailUrl;
                    var thumbnailUrl = await _fileStorageService.UploadFileAsync(course.Image, "Images/Courses", cancellationToken);
                    course.ThumbnailUrl = thumbnailUrl ?? course.ThumbnailUrl;

                    _logger.LogInformation("New image uploaded successfully for course ID: {CourseId}", id);
                }
                else
                {
                    course.ThumbnailUrl = existingCourse.ThumbnailUrl;
                }

                // Handle lectures and videos + resources - بنفس طريقة الـ Add بالضبط
                if (course.Sections != null && course.Sections.Any())
                {
                    foreach (var section in course.Sections)
                    {
                        if (section.Lectures != null && section.Lectures.Any())
                        {
                            foreach (var lecture in section.Lectures)
                            {
                                // 🎥 رفع الفيديو - نفس طريقة الـ Add
                                var contentType = lecture.ContentType?.Trim().ToLower();
                                if (lecture.Video != null && contentType == "video")
                                {
                                    // حفظ الفيديو القديم لحذفه لاحقاً
                                    var existingLecture = existingCourse.Sections?
                                        .SelectMany(s => s.Lectures ?? new List<LectureDTO>())
                                        .FirstOrDefault(l => l.Id == lecture.Id);

                                    if (existingLecture != null && !string.IsNullOrEmpty(existingLecture.VideoUrl))
                                    {
                                        oldVideoUrls.Add(existingLecture.VideoUrl);
                                    }

                                    // رفع الفيديو الجديد
                                    lecture.VideoUrl = await _fileStorageService.UploadFileAsync(
                                        lecture.Video, "Videos/Courses", cancellationToken
                                    ) ?? "";
                                }
                                else if (contentType != "video")
                                {
                                    lecture.VideoUrl = "";
                                }
                                else if (lecture.Id > 0) // محاضرة موجودة بدون فيديو جديد
                                {
                                    // الحفاظ على الـ VideoUrl الحالي
                                    var existingLecture = existingCourse.Sections?
                                        .SelectMany(s => s.Lectures ?? new List<LectureDTO>())
                                        .FirstOrDefault(l => l.Id == lecture.Id);

                                    if (existingLecture != null)
                                    {
                                        lecture.VideoUrl = existingLecture.VideoUrl;
                                    }
                                }

                                // 📂 رفع الموارد الجديدة (Resources داخل DTO) - نفس طريقة الـ Add
                                if (lecture.Resources != null && lecture.Resources.Any())
                                {
                                    foreach (var res in lecture.Resources)
                                    {
                                        if (res.File != null && res.File.Length > 0)
                                        {
                                            res.FileUrl = await _fileStorageService.UploadFileAsync(
                                                res.File, "Resources/Lectures", cancellationToken
                                            );

                                            res.FileName = res.File.FileName;
                                            res.FileType = res.File.ContentType;
                                            res.FileSize = res.File.Length;
                                        }
                                    }
                                }

                                // 📂 رفع الموارد الجديدة (ResourceFiles) - نفس طريقة الـ Add
                                if (lecture.ResourceFiles != null && lecture.ResourceFiles.Any())
                                {
                                    foreach (var file in lecture.ResourceFiles)
                                    {
                                        var fileUrl = await _fileStorageService.UploadFileAsync(
                                            file, "Resources/Lectures", cancellationToken
                                        );

                                        lecture.Resources.Add(new LectureResourceDTO
                                        {
                                            FileName = file.FileName,
                                            FileUrl = fileUrl,
                                            FileType = file.ContentType,
                                            FileSize = file.Length
                                        });
                                    }
                                }

                                // دمج الموارد القديمة مع الجديدة
                                var oldLecture = existingCourse.Sections?
                                    .SelectMany(s => s.Lectures ?? new List<LectureDTO>())
                                    .FirstOrDefault(l => l.Id == lecture.Id);

                                if (oldLecture?.Resources != null && oldLecture.Resources.Any())
                                {
                                    // لو مفيش موارد جديدة متباعتة للمحاضرة دي
                                    if (lecture.Resources == null || !lecture.Resources.Any())
                                    {
                                        lecture.Resources = oldLecture.Resources.ToList();
                                    }
                                    else
                                    {
                                        // ضيف القديم مع الجديد
                                        foreach (var res in oldLecture.Resources)
                                        {
                                            if (!lecture.Resources.Any(r => r.Id == res.Id))
                                            {
                                                lecture.Resources.Add(res);
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }

                var updatedCourse = await _courseService.UpdateCourseAsync(course, cancellationToken);
                if (updatedCourse == null)
                {
                    return NotFound(new { message = $"الكورس مش موجود بـ ID {id}" });
                }

                var userId = await _currentUserService.GetUserIdAsync();
                if (!string.IsNullOrEmpty(userId))
                    await _historyService.LogOperationAsync(userId, $"قام المستخدم بتعديل الكورس [ID: {id}] بعنوان \"{course.Title}\".", OperationType.Edit, HistoryMessages.CourseUpdated,
                        JsonSerializer.Serialize(new { id, title = course.Title }), CancellationToken.None);

                // حذف الملفات القديمة بعد التأكد من نجاح التحديث
                await DeleteOldFilesAsync(oldImageUrl, oldVideoUrls, oldResourceFiles);

                _logger.LogInformation("Course updated successfully. ID: {CourseId}", id);
                return Ok(updatedCourse);
            }
            catch (OperationCanceledException)
            {
                return StatusCode(499, new { message = "Request was cancelled" });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while updating course ID: {CourseId}", id);
                return StatusCode(500, new { message = "حدث خطأ أثناء التعديل", error = ex.Message });
            }
        }

        // دالة مساعدة لحذف الملفات القديمة
        private async Task DeleteOldFilesAsync(string oldImageUrl, List<string> oldVideoUrls, List<string> oldResourceFiles)
        {
            try
            {
                if (!string.IsNullOrEmpty(oldImageUrl) && !oldImageUrl.Equals("/Images/Courses/default.jpg"))
                {
                    await Task.Run(() => _fileStorageService.DeleteFile(oldImageUrl));
                }

                foreach (var videoUrl in oldVideoUrls)
                {
                    if (!string.IsNullOrEmpty(videoUrl))
                    {
                        await Task.Run(() => _fileStorageService.DeleteVideoFileIfExists(videoUrl));
                    }
                }

                foreach (var fileUrl in oldResourceFiles)
                {
                    if (!string.IsNullOrEmpty(fileUrl))
                    {
                        await Task.Run(() => _fileStorageService.DeleteFile(fileUrl));
                    }
                }
            }
            catch (Exception ex)
            {
                _logger.LogWarning(ex, "Error deleting old files, but update operation completed successfully");
                // لا نرمي خطأ هنا لأن العملية الأساسية تمت بنجاح
            }
        }


        #endregion

        #region Delete Operations

        /// <summary>
        /// Deletes a course
        /// </summary>
        /// <param name="id">Course ID</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Delete result</returns>
        /// <response code="200">If course was deleted successfully</response>
        /// <response code="404">If course is not found</response>
        /// <response code="401">If user is not authenticated</response>
        /// <response code="403">If user is not authorized</response>
        /// <response code="500">If there was an internal server error</response>
        [HttpDelete("{id:int}")]
        [Authorize(Policy = "AdminArea")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status404NotFound)]
        [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status401Unauthorized)]
        [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status403Forbidden)]
        [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status500InternalServerError)]
        public async Task<IActionResult> DeleteCourse(int id, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Deleting course ID: {CourseId}", id);

                // Get course first to know file paths
                var course = await _courseService.GetCourseByIdAsync(id, cancellationToken);
                if (course == null)
                {
                    _logger.LogWarning("Course not found for deletion. ID: {CourseId}", id);
                    return NotFound(new { success = false, message = $"الكورس بمعرف {id} غير موجود" });
                }

                if (!await IsEduLabCourseAsync(course))
                    return ForbiddenCourseAccess();

                // Delete course from database
                var isDeleted = await _courseService.DeleteCourseAsync(id, cancellationToken);
                if (!isDeleted)
                {
                    _logger.LogWarning("Course deletion failed. ID: {CourseId}", id);
                    return NotFound(new { success = false, message = $"الكورس بمعرف {id} غير موجود" });
                }

                var userId = await _currentUserService.GetUserIdAsync();
                if (!string.IsNullOrEmpty(userId))
                    await _historyService.LogOperationAsync(userId, $"قام المستخدم بحذف الكورس [ID: {id}] بعنوان \"{course.Title}\".", OperationType.Delete, HistoryMessages.CourseDeleted,
                        JsonSerializer.Serialize(new { id, title = course.Title }), CancellationToken.None);

                // Delete associated files
                if (!string.IsNullOrEmpty(course.ThumbnailUrl) && !course.ThumbnailUrl.Equals("/Images/Courses/default.jpg"))
                {
                    _logger.LogInformation("Deleting course thumbnail: {ThumbnailUrl}", course.ThumbnailUrl);
                    _fileStorageService.DeleteFile(course.ThumbnailUrl);
                }

                // Delete associated videos
                if (course.Sections != null)
                {
                    foreach (var section in course.Sections)
                    {
                        if (section.Lectures != null)
                        {
                            foreach (var lecture in section.Lectures)
                            {
                                if (!string.IsNullOrEmpty(lecture.VideoUrl))
                                {
                                    _logger.LogInformation("Deleting lecture video: {VideoUrl}", lecture.VideoUrl);
                                    _fileStorageService.DeleteVideoFileIfExists(lecture.VideoUrl);
                                }
                            }
                        }
                    }
                }

                _logger.LogInformation("Course deleted successfully. ID: {CourseId}", id);
                return Ok(new { success = true, message = "تم حذف الكورس بنجاح" });
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Delete course operation was cancelled. ID: {CourseId}", id);
                return StatusCode(499, new { message = "Request was cancelled" });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while deleting course ID: {CourseId}", id);
                return StatusCode(500, new { success = false, message = "حدث خطأ أثناء حذف الكورس", error = ex.Message });
            }
        }
        [HttpDelete("resources/{resourceId}")]
        public async Task<IActionResult> DeleteResource(int resourceId, CancellationToken cancellationToken = default)
        {
            try
            {
                // قيد الوصول يخص الـ Admin فقط — المدرسون يستخدمون نفس الـ endpoint
                if (User.IsInRole(SD.Admin))
                {
                    var resourceCourseId = await _courseService.GetCourseIdByResourceAsync(resourceId, cancellationToken);
                    var resourceCourse = resourceCourseId.HasValue
                        ? await LoadAdminCourseAsync(resourceCourseId.Value, true, cancellationToken)
                        : null;
                    if (resourceCourse == null)
                        return ForbiddenCourseAccess();
                }

                var result = await _courseService.DeleteResourceAsync(resourceId, cancellationToken);
                var userId = await _currentUserService.GetUserIdAsync();
                if (!string.IsNullOrEmpty(userId))
                    await _historyService.LogOperationAsync(userId, $"قام المستخدم بحذف المورد [ID: {resourceId}].", OperationType.Delete, HistoryMessages.ResourceDeleted, null, CancellationToken.None);
                return Ok(new { success = result });
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }
        /// <summary>
        /// Bulk delete courses
        /// </summary>
        /// <param name="ids">List of course IDs</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Bulk delete result</returns>
        /// <response code="200">If courses were deleted successfully</response>
        /// <response code="400">If no courses were specified</response>
        /// <response code="404">If courses are not found</response>
        /// <response code="401">If user is not authenticated</response>
        /// <response code="403">If user is not authorized</response>
        /// <response code="500">If there was an internal server error</response>
        [HttpPost("BulkDelete")]
        [Authorize(Policy = "AdminArea")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status400BadRequest)]
        [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status404NotFound)]
        [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status401Unauthorized)]
        [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status403Forbidden)]
        [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status500InternalServerError)]
        public async Task<IActionResult> BulkDelete([FromBody] List<int> ids, CancellationToken cancellationToken = default)
        {
            if (ids == null || !ids.Any())
            {
                _logger.LogWarning("Bulk delete request with empty IDs list");
                return BadRequest(new { success = false, message = "لم يتم تحديد أي دورات للحذف" });
            }

            try
            {
                _logger.LogInformation("Bulk deleting {Count} courses", ids.Count);

                // Get course information first to delete files
                var edulabInstructorId = await GetEduLabInstructorIdAsync();
                var coursesToDelete = new List<CourseDTO>();
                foreach (var id in ids)
                {
                    var course = await _courseService.GetCourseByIdAsync(id, cancellationToken);
                    if (course != null && (course.InstructorId == SD.EduLabInstructorId || course.InstructorId == edulabInstructorId))
                    {
                        coursesToDelete.Add(course);
                    }
                }

                if (!coursesToDelete.Any())
                    return ForbiddenCourseAccess();

                ids = coursesToDelete.Select(c => c.Id).ToList();

                // Delete courses from database
                var result = await _courseService.BulkDeleteCoursesAsync(ids, cancellationToken);
                if (!result)
                {
                    _logger.LogWarning("Bulk delete failed for {Count} courses", ids.Count);
                    return NotFound(new { success = false, message = "لم يتم العثور على الدورات المحددة" });
                }

                // Delete associated files
                foreach (var course in coursesToDelete)
                {
                    if (!string.IsNullOrEmpty(course.ThumbnailUrl) && !course.ThumbnailUrl.Equals("/Images/Courses/default.jpg"))
                    {
                        _logger.LogInformation("Deleting thumbnail for course ID: {CourseId}", course.Id);
                        _fileStorageService.DeleteFileIfExists(course.ThumbnailUrl);
                    }

                    if (course.Sections != null)
                    {
                        foreach (var section in course.Sections)
                        {
                            if (section.Lectures != null)
                            {
                                foreach (var lecture in section.Lectures)
                                {
                                    if (!string.IsNullOrEmpty(lecture.VideoUrl))
                                    {
                                        _logger.LogInformation("Deleting video for lecture ID: {LectureId}", lecture.Id);
                                        _fileStorageService.DeleteVideoFileIfExists(lecture.VideoUrl);
                                    }
                                }
                            }
                        }
                    }
                }

                _logger.LogInformation("Bulk delete completed successfully. Deleted {Count} courses", ids.Count);
                return Ok(new { success = true, message = $"تم حذف {ids.Count} دورة بنجاح" });
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Bulk delete operation was cancelled");
                return StatusCode(499, new { message = "Request was cancelled" });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred during bulk delete of {Count} courses", ids.Count);
                return StatusCode(500, new { success = false, message = "حدث خطأ أثناء حذف الدورات", error = ex.Message });
            }
        }

        #endregion

        #region Bulk Operations

        /// <summary>
        /// Performs bulk actions on courses (delete/publish/unpublish)
        /// </summary>
        /// <param name="action">Action to perform</param>
        /// <param name="ids">List of course IDs</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Bulk action result</returns>
        /// <response code="200">If action was performed successfully</response>
        /// <response code="400">If no courses were specified or action is invalid</response>
        /// <response code="401">If user is not authenticated</response>
        /// <response code="403">If user is not authorized</response>
        /// <response code="500">If there was an internal server error</response>
        [HttpPost("BulkAction")]
        [Authorize(Policy = "AdminArea")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status400BadRequest)]
        [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status401Unauthorized)]
        [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status403Forbidden)]
        [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status500InternalServerError)]
        public async Task<IActionResult> BulkAction([FromForm] string action, [FromForm] List<int> ids, CancellationToken cancellationToken = default)
        {
            if (ids == null || !ids.Any())
            {
                _logger.LogWarning("Bulk action request with empty IDs list");
                return BadRequest(new { success = false, message = "لم يتم تحديد أي دورات" });
            }

            try
            {
                _logger.LogInformation("Performing bulk action '{Action}' on {Count} courses", action, ids.Count);

                bool result = false;
                string actionName = "";

                switch (action.ToLower())
                {
                    case "delete":
                        result = await _courseService.BulkDeleteCoursesAsync(ids, cancellationToken);
                        actionName = "حذف";
                        break;
                    case "publish":
                        result = await _courseService.BulkPublishCoursesAsync(ids, cancellationToken);
                        actionName = "نشر";
                        break;
                    case "unpublish":
                        result = await _courseService.BulkUnpublishCoursesAsync(ids, cancellationToken);
                        actionName = "إلغاء نشر";
                        break;
                    default:
                        _logger.LogWarning("Unknown bulk action: {Action}", action);
                        return BadRequest(new { success = false, message = "إجراء غير معروف" });
                }

                if (result)
                {
                    _logger.LogInformation("Bulk action '{Action}' completed successfully on {Count} courses", action, ids.Count);
                    return Ok(new { success = true, message = $"تم {actionName} {ids.Count} دورة بنجاح" });
                }

                _logger.LogWarning("Bulk action '{Action}' failed on {Count} courses", action, ids.Count);
                return StatusCode(500, new { success = false, message = $"حدث خطأ أثناء {actionName} الدورات" });
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Bulk action operation was cancelled. Action: {Action}", action);
                return StatusCode(499, new { message = "Request was cancelled" });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred during bulk action '{Action}' on {Count} courses", action, ids.Count);
                return StatusCode(500, new { success = false, message = "حدث خطأ أثناء معالجة الطلب", error = ex.Message });
            }
        }

        #endregion

        #region Status Management

        /// <summary>
        /// Accepts a course
        /// </summary>
        /// <param name="id">Course ID</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Acceptance result</returns>
        /// <response code="200">If course was accepted successfully</response>
        /// <response code="404">If course is not found</response>
        /// <response code="401">If user is not authenticated</response>
        /// <response code="403">If user is not authorized</response>
        /// <response code="500">If there was an internal server error</response>
        [HttpPost("{id:int}/Accept")]
        [Authorize(Policy = "AdminArea")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status404NotFound)]
        [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status401Unauthorized)]
        [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status403Forbidden)]
        [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status500InternalServerError)]
        public async Task<IActionResult> AcceptCourse(int id, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Accepting course ID: {CourseId}", id);

                var result = await _courseService.AcceptCourseAsync(id, cancellationToken);
                if (!result)
                {
                    _logger.LogWarning("Course not found for acceptance. ID: {CourseId}", id);
                    return NotFound(new { success = false, message = $"الكورس بمعرف {id} غير موجود" });
                }

                var course = await _courseService.GetCourseByIdAsync(id, cancellationToken);
                var userId = await _currentUserService.GetUserIdAsync();
                if (!string.IsNullOrEmpty(userId) && course != null)
                    await _historyService.LogOperationAsync(userId, $"قام المستخدم بالموافقة على الكورس [ID: {id}] بعنوان \"{course.Title}\".", OperationType.Approve, HistoryMessages.CourseApproved,
                        JsonSerializer.Serialize(new { id, title = course.Title }), CancellationToken.None);

                _logger.LogInformation("Course accepted successfully. ID: {CourseId}", id);
                return Ok(new { success = true, message = "تم قبول الكورس بنجاح" });
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Accept course operation was cancelled. ID: {CourseId}", id);
                return StatusCode(499, new { message = "Request was cancelled" });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while accepting course ID: {CourseId}", id);
                return StatusCode(500, new { success = false, message = "حدث خطأ أثناء قبول الكورس", error = ex.Message });
            }
        }

        /// <summary>
        /// Rejects a course
        /// </summary>
        /// <param name="id">Course ID</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Rejection result</returns>
        /// <response code="200">If course was rejected successfully</response>
        /// <response code="404">If course is not found</response>
        /// <response code="401">If user is not authenticated</response>
        /// <response code="403">If user is not authorized</response>
        /// <response code="500">If there was an internal server error</response>
        [HttpPost("{id:int}/Reject")]
        [Authorize(Policy = "AdminArea")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status404NotFound)]
        [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status401Unauthorized)]
        [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status403Forbidden)]
        [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status500InternalServerError)]
        public async Task<IActionResult> RejectCourse(int id, [FromBody] RejectCourseRequest? request = null, CancellationToken cancellationToken = default)
        {
            try
            {
                var reason = request?.RejectionReason;
                _logger.LogInformation("Rejecting course ID: {CourseId} with reason: {Reason}", id, reason);

                var result = await _courseService.RejectCourseAsync(id, reason, cancellationToken);
                if (!result)
                {
                    _logger.LogWarning("Course not found for rejection. ID: {CourseId}", id);
                    return NotFound(new { success = false, message = $"الكورس بمعرف {id} غير موجود" });
                }

                var course = await _courseService.GetCourseByIdAsync(id, cancellationToken);
                var userId = await _currentUserService.GetUserIdAsync();
                if (!string.IsNullOrEmpty(userId) && course != null)
                    await _historyService.LogOperationAsync(userId, $"قام المستخدم برفض الكورس [ID: {id}] بعنوان \"{course.Title}\"." + (string.IsNullOrEmpty(reason) ? "" : $" السبب: {reason}"), OperationType.Reject, HistoryMessages.CourseRejected,
                        JsonSerializer.Serialize(new { id, title = course.Title, reason }), CancellationToken.None);

                _logger.LogInformation("Course rejected successfully. ID: {CourseId}", id);
                return Ok(new { success = true, message = "تم رفض الكورس بنجاح" });
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Reject course operation was cancelled. ID: {CourseId}", id);
                return StatusCode(499, new { message = "Request was cancelled" });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while rejecting course ID: {CourseId}", id);
                return StatusCode(500, new { success = false, message = "حدث خطأ أثناء رفض الكورس", error = ex.Message });
            }
        }

        #endregion

        #region Admin Course Draft Creation

        /// <summary>
        /// Creates a new course draft (Admin version - uses EduLab instructor)
        /// </summary>
        [HttpPost("create-draft")]
        [Consumes("multipart/form-data")]
        [Authorize(Policy = "AdminArea")]
        public async Task<IActionResult> CreateCourseDraft([FromForm] CourseDraftDTO draftDto, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Admin creating course draft: {CourseTitle}", draftDto?.Title);

                if (draftDto == null || string.IsNullOrWhiteSpace(draftDto.Title))
                    return BadRequest(new { success = false, message = "عنوان الكورس مطلوب" });

                draftDto.InstructorId = SD.EduLabInstructorId;

                var createdCourse = await _courseService.CreateCourseDraftAsync(draftDto, cancellationToken);
                if (createdCourse == null)
                    return StatusCode(500, new { success = false, message = "فشل إنشاء الكورس" });

                _logger.LogInformation("Admin created course draft. ID: {CourseId}", createdCourse.Id);
                return CreatedAtAction(nameof(GetCourseById), new { id = createdCourse.Id }, createdCourse);
            }
            catch (OperationCanceledException)
            {
                return StatusCode(499, new { message = "Request was cancelled" });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error creating course draft by admin");
                return StatusCode(500, new { success = false, message = "حدث خطأ", error = ex.Message });
            }
        }

        #endregion

        #region Admin Section Operations

        /// <summary>
        /// Adds a section to a course (Admin version)
        /// </summary>
        [HttpPost("{courseId:int}/sections")]
        [Authorize(Policy = "AdminArea")]
        public async Task<IActionResult> AddSection(int courseId, [FromBody] SectionCreateDTO sectionDto, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Admin adding section to course ID: {CourseId}", courseId);

                if (sectionDto == null || string.IsNullOrWhiteSpace(sectionDto.Title))
                    return BadRequest(new { success = false, message = "عنوان القسم مطلوب" });

                sectionDto.CourseId = courseId;
                var section = await _courseService.AddSectionAsync(sectionDto, cancellationToken);
                if (section == null)
                    return StatusCode(500, new { success = false, message = "فشل إضافة القسم" });

                var userId = await _currentUserService.GetUserIdAsync();
                if (!string.IsNullOrEmpty(userId))
                    await _historyService.LogOperationAsync(userId, $"قام المستخدم بإنشاء قسم جديد [ID: {section.Id}] بعنوان \"{sectionDto.Title}\" للكورس [ID: {courseId}].", OperationType.Create, HistoryMessages.SectionCreated,
                        JsonSerializer.Serialize(new { id = section.Id, title = sectionDto.Title }), CancellationToken.None);

                return CreatedAtAction(nameof(GetSection), new { sectionId = section.Id }, section);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error adding section by admin");
                return StatusCode(500, new { success = false, message = "حدث خطأ", error = ex.Message });
            }
        }

        [HttpGet("sections/{sectionId:int}")]
        [Authorize(Policy = "AdminArea")]
        public async Task<IActionResult> GetSection(int sectionId, CancellationToken cancellationToken = default)
        {
            try
            {
                var section = await _courseService.GetSectionByIdAsync(sectionId, cancellationToken);
                if (section == null)
                    return NotFound(new { message = "القسم غير موجود" });

                var sectionCourse = await LoadAdminCourseAsync(section.CourseId, true, cancellationToken);
                if (sectionCourse == null)
                    return ForbiddenCourseAccess();

                return Ok(section);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting section ID: {SectionId}", sectionId);
                return StatusCode(500, new { message = "حدث خطأ", error = ex.Message });
            }
        }

        [HttpPut("sections/{sectionId:int}")]
        [Authorize(Policy = "AdminArea")]
        public async Task<IActionResult> UpdateSection(int sectionId, [FromBody] SectionUpdateDTO sectionDto, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Admin updating section ID: {SectionId}", sectionId);

                if (sectionDto == null || string.IsNullOrWhiteSpace(sectionDto.Title))
                    return BadRequest(new { success = false, message = "عنوان القسم مطلوب" });

                var existingSection = await _courseService.GetSectionByIdAsync(sectionId, cancellationToken);
                if (existingSection == null)
                    return NotFound(new { success = false, message = "القسم غير موجود" });

                var sectionCourse = await LoadAdminCourseAsync(existingSection.CourseId, true, cancellationToken);
                if (sectionCourse == null)
                    return ForbiddenCourseAccess();

                var section = await _courseService.UpdateSectionAsync(sectionId, sectionDto, cancellationToken);
                if (section == null)
                    return StatusCode(500, new { success = false, message = "فشل تعديل القسم" });

                var userId = await _currentUserService.GetUserIdAsync();
                if (!string.IsNullOrEmpty(userId))
                    await _historyService.LogOperationAsync(userId, $"قام المستخدم بتحديث القسم [ID: {sectionId}] بعنوان \"{sectionDto.Title}\".", OperationType.Edit, HistoryMessages.SectionUpdated,
                        JsonSerializer.Serialize(new { id = sectionId, title = sectionDto.Title }), CancellationToken.None);

                return Ok(section);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error updating section by admin");
                return StatusCode(500, new { success = false, message = "حدث خطأ", error = ex.Message });
            }
        }

        [HttpDelete("sections/{sectionId:int}")]
        [Authorize(Policy = "AdminArea")]
        public async Task<IActionResult> DeleteSection(int sectionId, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Admin deleting section ID: {SectionId}", sectionId);

                var existingSection = await _courseService.GetSectionByIdAsync(sectionId, cancellationToken);
                if (existingSection == null)
                    return NotFound(new { success = false, message = "القسم غير موجود" });

                var sectionCourse = await LoadAdminCourseAsync(existingSection.CourseId, true, cancellationToken);
                if (sectionCourse == null)
                    return ForbiddenCourseAccess();

                var result = await _courseService.DeleteSectionAsync(sectionId, cancellationToken);
                if (!result)
                    return NotFound(new { success = false, message = "القسم غير موجود" });

                var section = await _courseService.GetSectionByIdAsync(sectionId, cancellationToken);
                var userId = await _currentUserService.GetUserIdAsync();
                if (!string.IsNullOrEmpty(userId))
                    await _historyService.LogOperationAsync(userId, $"قام المستخدم بحذف القسم [ID: {sectionId}] بعنوان \"{section?.Title}\".", OperationType.Delete, HistoryMessages.SectionDeleted,
                        JsonSerializer.Serialize(new { id = sectionId, title = section?.Title }), CancellationToken.None);

                return Ok(new { success = true, message = "تم حذف القسم بنجاح" });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error deleting section by admin");
                return StatusCode(500, new { success = false, message = "حدث خطأ", error = ex.Message });
            }
        }

        #endregion

        #region Admin Lecture Operations

        [HttpPost("sections/{sectionId:int}/lectures")]
        [Consumes("multipart/form-data")]
        [Authorize(Policy = "AdminArea")]
        public async Task<IActionResult> AddLecture(int sectionId, [FromForm] LectureCreateDTO lectureDto, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Admin adding lecture to section ID: {SectionId}", sectionId);

                if (lectureDto == null || string.IsNullOrWhiteSpace(lectureDto.Title))
                    return BadRequest(new { success = false, message = "عنوان المحاضرة مطلوب" });

                var lectureSection = await _courseService.GetSectionByIdAsync(sectionId, cancellationToken);
                if (lectureSection == null)
                    return NotFound(new { success = false, message = "القسم غير موجود" });

                var lectureCourse = await LoadAdminCourseAsync(lectureSection.CourseId, true, cancellationToken);
                if (lectureCourse == null)
                    return ForbiddenCourseAccess();

                lectureDto.SectionId = sectionId;
                var lecture = await _courseService.AddLectureAsync(lectureDto, cancellationToken);
                if (lecture == null)
                    return StatusCode(500, new { success = false, message = "فشل إضافة المحاضرة" });

                var userId = await _currentUserService.GetUserIdAsync();
                if (!string.IsNullOrEmpty(userId))
                    await _historyService.LogOperationAsync(userId, $"قام المستخدم بإنشاء محاضرة جديدة [ID: {lecture.Id}] بعنوان \"{lectureDto.Title}\" في القسم [ID: {sectionId}].", OperationType.Create, HistoryMessages.LectureCreated,
                        JsonSerializer.Serialize(new { id = lecture.Id, title = lectureDto.Title }), CancellationToken.None);

                return CreatedAtAction(nameof(GetLecture), new { lectureId = lecture.Id }, lecture);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error adding lecture by admin");
                return StatusCode(500, new { success = false, message = "حدث خطأ", error = ex.Message });
            }
        }

        [HttpGet("lectures/{lectureId:int}")]
        [Authorize(Policy = "AdminArea")]
        public async Task<IActionResult> GetLecture(int lectureId, CancellationToken cancellationToken = default)
        {
            try
            {
                var lecture = await _courseService.GetLectureByIdAsync(lectureId, cancellationToken);
                if (lecture == null)
                    return NotFound(new { message = "المحاضرة غير موجودة" });

                var lectureCourseId = await _courseService.GetCourseIdByLectureAsync(lectureId, cancellationToken);
                var lectureCourse = lectureCourseId.HasValue
                    ? await LoadAdminCourseAsync(lectureCourseId.Value, true, cancellationToken)
                    : null;
                if (lectureCourse == null)
                    return ForbiddenCourseAccess();

                return Ok(lecture);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting lecture ID: {LectureId}", lectureId);
                return StatusCode(500, new { message = "حدث خطأ", error = ex.Message });
            }
        }

        [HttpPut("lectures/{lectureId:int}")]
        [Consumes("multipart/form-data")]
        [Authorize(Policy = "AdminArea")]
        public async Task<IActionResult> UpdateLecture(int lectureId, [FromForm] LectureUpdateDTO lectureDto, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Admin updating lecture ID: {LectureId}", lectureId);

                if (lectureDto == null || string.IsNullOrWhiteSpace(lectureDto.Title))
                    return BadRequest(new { success = false, message = "عنوان المحاضرة مطلوب" });

                var updateLectureCourseId = await _courseService.GetCourseIdByLectureAsync(lectureId, cancellationToken);
                var updateLectureCourse = updateLectureCourseId.HasValue
                    ? await LoadAdminCourseAsync(updateLectureCourseId.Value, true, cancellationToken)
                    : null;
                if (updateLectureCourse == null)
                    return ForbiddenCourseAccess();

                var lecture = await _courseService.UpdateLectureAsync(lectureId, lectureDto, cancellationToken);
                if (lecture == null)
                    return StatusCode(500, new { success = false, message = "فشل تعديل المحاضرة" });

                var userId = await _currentUserService.GetUserIdAsync();
                if (!string.IsNullOrEmpty(userId))
                    await _historyService.LogOperationAsync(userId, $"قام المستخدم بتحديث المحاضرة [ID: {lectureId}] بعنوان \"{lectureDto.Title}\".", OperationType.Edit, HistoryMessages.LectureUpdated,
                        JsonSerializer.Serialize(new { id = lectureId, title = lectureDto.Title }), CancellationToken.None);

                return Ok(lecture);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error updating lecture by admin");
                return StatusCode(500, new { success = false, message = "حدث خطأ", error = ex.Message });
            }
        }

        [HttpDelete("lectures/{lectureId:int}")]
        [Authorize(Policy = "AdminArea")]
        public async Task<IActionResult> DeleteLecture(int lectureId, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Admin deleting lecture ID: {LectureId}", lectureId);

                var deleteLectureCourseId = await _courseService.GetCourseIdByLectureAsync(lectureId, cancellationToken);
                var deleteLectureCourse = deleteLectureCourseId.HasValue
                    ? await LoadAdminCourseAsync(deleteLectureCourseId.Value, true, cancellationToken)
                    : null;
                if (deleteLectureCourse == null)
                    return ForbiddenCourseAccess();

                var lecture = await _courseService.GetLectureByIdAsync(lectureId, cancellationToken);
                var lectureTitle = lecture?.Title;

                var result = await _courseService.DeleteLectureAsync(lectureId, cancellationToken);
                if (!result)
                    return NotFound(new { success = false, message = "المحاضرة غير موجودة" });

                var userId = await _currentUserService.GetUserIdAsync();
                if (!string.IsNullOrEmpty(userId))
                    await _historyService.LogOperationAsync(userId, $"قام المستخدم بحذف المحاضرة [ID: {lectureId}] بعنوان \"{lectureTitle}\".", OperationType.Delete, HistoryMessages.LectureDeleted,
                        JsonSerializer.Serialize(new { id = lectureId, title = lectureTitle }), CancellationToken.None);

                return Ok(new { success = true, message = "تم حذف المحاضرة بنجاح" });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error deleting lecture by admin");
                return StatusCode(500, new { success = false, message = "حدث خطأ", error = ex.Message });
            }
        }

        #endregion

        #region Admin Publish (Direct Approve)

        [HttpPost("{courseId:int}/publish")]
        [Authorize(Policy = "AdminArea")]
        public async Task<IActionResult> PublishCourse(int courseId, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Admin publishing course ID: {CourseId}", courseId);

                var result = await _courseService.AdminPublishCourseAsync(courseId, cancellationToken);
                if (!result.Success)
                    return BadRequest(result);

                var course = await _courseService.GetCourseByIdAsync(courseId, cancellationToken);
                var userId = await _currentUserService.GetUserIdAsync();
                if (!string.IsNullOrEmpty(userId))
                    await _historyService.LogOperationAsync(userId, $"قام المستخدم بنشر الكورس [ID: {courseId}] بعنوان \"{course?.Title}\" وتمت الموافقة عليه مباشرة.", OperationType.Publish, HistoryMessages.CoursePublished,
                        JsonSerializer.Serialize(new { id = courseId, title = course?.Title }), CancellationToken.None);

                return Ok(result);
            }
            catch (OperationCanceledException)
            {
                return StatusCode(499, new { message = "Request was cancelled" });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error publishing course by admin. ID: {CourseId}", courseId);
                return StatusCode(500, new { success = false, message = "حدث خطأ", error = ex.Message });
            }
        }

        #endregion
    }
}
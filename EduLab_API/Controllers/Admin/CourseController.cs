using AutoMapper;
using EduLab_Application.ServiceInterfaces;
using EduLab_Domain.Entities;
using EduLab_Shared.DTOs.Course;
using EduLab_Shared.DTOs.Lecture;
using EduLab_Shared.Utitlites;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.ComponentModel;
using System.Threading;

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
        private readonly ILogger<CourseController> _logger;

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
            ILogger<CourseController> logger)
        {
            _courseService = courseService;
            _fileStorageService = fileStorageService;
            _mapper = mapper;
            _logger = logger;
        }

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
        [Authorize(Roles = SD.Admin)]
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
                var resource = await _courseService.AddResourceToLectureAsync(lectureId, resourceFile, cancellationToken);
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
        [Authorize(Roles = SD.Admin)]
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
        [Authorize(Roles = SD.Admin)]
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

                // Delete course from database
                var isDeleted = await _courseService.DeleteCourseAsync(id, cancellationToken);
                if (!isDeleted)
                {
                    _logger.LogWarning("Course deletion failed. ID: {CourseId}", id);
                    return NotFound(new { success = false, message = $"الكورس بمعرف {id} غير موجود" });
                }

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
                var result = await _courseService.DeleteResourceAsync(resourceId, cancellationToken);
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
        [Authorize(Roles = SD.Admin)]
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
                var coursesToDelete = new List<CourseDTO>();
                foreach (var id in ids)
                {
                    var course = await _courseService.GetCourseByIdAsync(id, cancellationToken);
                    if (course != null)
                    {
                        coursesToDelete.Add(course);
                    }
                }

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
        [Authorize(Roles = SD.Admin)]
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
        [Authorize(Roles = SD.Admin)]
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
        [Authorize(Roles = SD.Admin)]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status404NotFound)]
        [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status401Unauthorized)]
        [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status403Forbidden)]
        [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status500InternalServerError)]
        public async Task<IActionResult> RejectCourse(int id, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Rejecting course ID: {CourseId}", id);

                var result = await _courseService.RejectCourseAsync(id, cancellationToken);
                if (!result)
                {
                    _logger.LogWarning("Course not found for rejection. ID: {CourseId}", id);
                    return NotFound(new { success = false, message = $"الكورس بمعرف {id} غير موجود" });
                }

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
    }
}
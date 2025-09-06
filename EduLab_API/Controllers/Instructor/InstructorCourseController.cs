using AutoMapper;
using EduLab_Application.ServiceInterfaces;
using EduLab_Shared.DTOs.Course;
using EduLab_Shared.DTOs.Lecture;
using EduLab_Shared.Utitlites;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.ComponentModel;
using System.Threading;

namespace EduLab_API.Controllers.Instructor
{
    /// <summary>
    /// Controller for instructor course management operations
    /// </summary>
    [Route("api/[controller]")]
    [ApiController]
    [Produces("application/json")]
    [DisplayName("Instructor Course Management")]
    [Description("APIs for managing courses by instructors, including CRUD operations")]
    [Authorize(Roles = SD.Instructor)]
    public class InstructorCourseController : ControllerBase
    {
        private readonly ICourseService _courseService;
        private readonly IFileStorageService _fileStorageService;
        private readonly IMapper _mapper;
        private readonly ICurrentUserService _currentUserService;
        private readonly ILogger<InstructorCourseController> _logger;

        /// <summary>
        /// Initializes a new instance of the InstructorCourseController class
        /// </summary>
        /// <param name="courseService">Course service</param>
        /// <param name="fileStorageService">File storage service</param>
        /// <param name="mapper">AutoMapper instance</param>
        /// <param name="currentUserService">Current user service</param>
        /// <param name="logger">Logger instance</param>
        public InstructorCourseController(
            ICourseService courseService,
            IFileStorageService fileStorageService,
            IMapper mapper,
            ICurrentUserService currentUserService,
            ILogger<InstructorCourseController> logger)
        {
            _courseService = courseService;
            _fileStorageService = fileStorageService;
            _mapper = mapper;
            _currentUserService = currentUserService;
            _logger = logger;
        }

        #region Get Operations

        /// <summary>
        /// Gets courses for the current instructor
        /// </summary>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>List of instructor's courses</returns>
        /// <response code="200">Returns the list of courses</response>
        /// <response code="401">If user is not authenticated</response>
        /// <response code="404">If no courses are found</response>
        /// <response code="500">If there was an internal server error</response>
        [HttpGet("instructor-courses")]
        [ProducesResponseType(typeof(IEnumerable<CourseDTO>), StatusCodes.Status200OK)]
        [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status401Unauthorized)]
        [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status404NotFound)]
        [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status500InternalServerError)]
        public async Task<IActionResult> GetInstructorCourses(CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Getting courses for current instructor");

                var instructorId = await _currentUserService.GetUserIdAsync();
                if (string.IsNullOrEmpty(instructorId))
                {
                    _logger.LogWarning("Unauthorized access attempt to get instructor courses");
                    return Unauthorized();
                }

                var courses = await _courseService.GetInstructorCoursesAsync(instructorId, cancellationToken);
                if (courses == null || !courses.Any())
                {
                    _logger.LogWarning("No courses found for instructor ID: {InstructorId}", instructorId);
                    return NotFound(new { message = "No courses found for this instructor" });
                }

                _logger.LogInformation("Retrieved {Count} courses for instructor ID: {InstructorId}", courses.Count(), instructorId);
                return Ok(courses);
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Get instructor courses operation was cancelled");
                return StatusCode(499, new { message = "Request was cancelled" });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while retrieving instructor courses");
                return StatusCode(500, new
                {
                    message = "An error occurred while retrieving instructor courses",
                    error = ex.Message
                });
            }
        }

        /// <summary>
        /// Gets a course by ID for the current instructor
        /// </summary>
        /// <param name="id">Course ID</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Course details</returns>
        /// <response code="200">Returns the course</response>
        /// <response code="401">If user is not authenticated</response>
        /// <response code="404">If course is not found</response>
        /// <response code="500">If there was an internal server error</response>
        [HttpGet("{id:int}")]
        [ProducesResponseType(typeof(CourseDTO), StatusCodes.Status200OK)]
        [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status401Unauthorized)]
        [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status404NotFound)]
        [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status500InternalServerError)]
        public async Task<IActionResult> GetCourseById(int id, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Getting course by ID: {CourseId} for current instructor", id);

                var instructorId = await _currentUserService.GetUserIdAsync();
                if (string.IsNullOrEmpty(instructorId))
                {
                    _logger.LogWarning("Unauthorized access attempt to get course ID: {CourseId}", id);
                    return Unauthorized();
                }

                var course = await _courseService.GetCourseByIdAsync(id, cancellationToken);
                if (course == null)
                {
                    _logger.LogWarning("Course not found. ID: {CourseId}", id);
                    return NotFound(new { message = $"No course found with ID {id}" });
                }

                // Verify course ownership
                if (course.InstructorId != instructorId)
                {
                    _logger.LogWarning("Instructor ID: {InstructorId} attempted to access course ID: {CourseId} which they don't own",
                        instructorId, id);
                    return Unauthorized(new { message = "لا يمكن الوصول إلى كورس لا يخصك" });
                }

                _logger.LogInformation("Retrieved course ID: {CourseId} for instructor ID: {InstructorId}", id, instructorId);
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

        #endregion

        #region Create Operations

        /// <summary>
        /// Creates a new course as instructor
        /// </summary>
        /// <param name="course">Course data</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Created course</returns>
        /// <response code="201">Returns the created course</response>
        /// <response code="400">If the data is invalid</response>
        /// <response code="401">If user is not authenticated</response>
        /// <response code="500">If there was an internal server error</response>
        [RequestFormLimits(MultipartBodyLengthLimit = 4_000_000_000)]
        [RequestSizeLimit(4_000_000_000)]
        [HttpPost("instructor")]
        [Consumes("multipart/form-data")]
        [ProducesResponseType(typeof(CourseDTO), StatusCodes.Status201Created)]
        [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status400BadRequest)]
        [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status401Unauthorized)]
        [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status500InternalServerError)]
        public async Task<IActionResult> AddCourseAsInstructor([FromForm] CourseCreateDTO course, CancellationToken cancellationToken = default)
        {
            if (course == null)
            {
                _logger.LogWarning("Add course as instructor request with null data");
                return BadRequest(new { message = "البيانات ناقصة" });
            }

            try
            {
                _logger.LogInformation("Adding new course as instructor: {CourseTitle}", course.Title);

                // Get current user ID
                var instructorId = await _currentUserService.GetUserIdAsync();
                if (string.IsNullOrEmpty(instructorId))
                {
                    _logger.LogWarning("Unauthorized attempt to add course");
                    return Unauthorized(new { message = "المستخدم غير مسجل دخول" });
                }

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

                // Handle lectures and videos
                if (course.Sections != null && course.Sections.Any())
                {
                    _logger.LogInformation("Processing {SectionCount} sections for course: {CourseTitle}",
                        course.Sections.Count, course.Title);

                    foreach (var section in course.Sections)
                    {
                        if (section.Lectures != null && section.Lectures.Any())
                        {
                            _logger.LogInformation("Processing {LectureCount} lectures for section: {SectionTitle}",
                                section.Lectures.Count, section.Title);

                            foreach (var lecture in section.Lectures)
                            {
                                lecture.VideoUrl = lecture.VideoUrl ?? "";
                                var contentType = lecture.ContentType?.Trim().ToLower();

                                if (lecture.Video != null && contentType == "video")
                                {
                                    _logger.LogInformation("Uploading video for lecture: {LectureTitle}, Size: {Size} bytes",
                                        lecture.Title, lecture.Video.Length);

                                    lecture.VideoUrl = await _fileStorageService.UploadFileAsync(
                                        lecture.Video, "Videos/Courses", cancellationToken) ?? "";

                                    _logger.LogInformation("Video uploaded successfully. Video URL: {VideoUrl}", lecture.VideoUrl);
                                }
                                else
                                {
                                    _logger.LogInformation("No video uploaded for lecture: {LectureTitle}. ContentType: {ContentType}",
                                        lecture.Title, contentType);
                                }

                                if (contentType != "video")
                                {
                                    lecture.VideoUrl = "";
                                }
                            }
                        }
                    }
                }

                var createdCourse = await _courseService.AddCourseAsInstructorAsync(course, cancellationToken);

                _logger.LogInformation("Course created successfully as instructor. ID: {CourseId}, Title: {CourseTitle}",
                    createdCourse.Id, createdCourse.Title);

                return CreatedAtAction(nameof(GetCourseById), new { id = createdCourse.Id }, createdCourse);
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Add course as instructor operation was cancelled. Course: {CourseTitle}", course.Title);
                return StatusCode(499, new { message = "Request was cancelled" });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while adding course as instructor: {CourseTitle}", course.Title);
                return StatusCode(500, new { message = "في مشكلة", error = ex.Message, innerError = ex.InnerException?.Message });
            }
        }

        #endregion

        #region Update Operations

        /// <summary>
        /// Updates an existing course as instructor
        /// </summary>
        /// <param name="id">Course ID</param>
        /// <param name="course">Updated course data</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Updated course</returns>
        /// <response code="200">Returns the updated course</response>
        /// <response code="400">If the data is invalid</response>
        /// <response code="401">If user is not authenticated or doesn't own the course</response>
        /// <response code="404">If course is not found</response>
        /// <response code="500">If there was an internal server error</response>
        [RequestFormLimits(MultipartBodyLengthLimit = 4_000_000_000)]
        [RequestSizeLimit(4_000_000_000)]
        [HttpPut("instructor/{id:int}")]
        [Consumes("multipart/form-data")]
        [ProducesResponseType(typeof(CourseDTO), StatusCodes.Status200OK)]
        [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status400BadRequest)]
        [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status401Unauthorized)]
        [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status404NotFound)]
        [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status500InternalServerError)]
        public async Task<IActionResult> UpdateCourseAsInstructor(int id, [FromForm] CourseUpdateDTO course, CancellationToken cancellationToken = default)
        {
            if (course == null || course.Id != id)
            {
                _logger.LogWarning("Update course as instructor request with invalid data. ID: {CourseId}", id);
                return BadRequest(new { message = "البيانات غير صالحة" });
            }

            try
            {
                _logger.LogInformation("Updating course as instructor. ID: {CourseId}", id);

                // Get current user ID
                var instructorId = await _currentUserService.GetUserIdAsync();
                if (string.IsNullOrEmpty(instructorId))
                {
                    _logger.LogWarning("Unauthorized attempt to update course ID: {CourseId}", id);
                    return Unauthorized(new { message = "المستخدم غير مسجل دخول" });
                }

                var existingCourse = await _courseService.GetCourseByIdAsync(id, cancellationToken);
                if (existingCourse == null)
                {
                    _logger.LogWarning("Course not found for update. ID: {CourseId}", id);
                    return NotFound(new { message = "الكورس غير موجود" });
                }

                // Verify course ownership
                if (existingCourse.InstructorId != instructorId)
                {
                    _logger.LogWarning("Instructor ID: {InstructorId} attempted to update course ID: {CourseId} which they don't own",
                        instructorId, id);
                    return Unauthorized(new { message = "لا يمكن تعديل كورس لا يخصك" });
                }

                string oldImageUrl = null;
                List<string> oldVideoUrls = new List<string>();

                // Handle image upload
                if (course.Image != null && course.Image.Length > 0)
                {
                    _logger.LogInformation("Uploading new image for course ID: {CourseId}", id);

                    oldImageUrl = existingCourse.ThumbnailUrl;
                    var thumbnailUrl = await _fileStorageService.UploadFileAsync(course.Image, "Images/Courses", cancellationToken);
                    course.ThumbnailUrl = thumbnailUrl;

                    _logger.LogInformation("New image uploaded successfully for course ID: {CourseId}", id);
                }
                else
                {
                    course.ThumbnailUrl = existingCourse.ThumbnailUrl;
                }

                // Handle video uploads
                if (course.Sections != null && course.Sections.Any())
                {
                    _logger.LogInformation("Processing videos for course ID: {CourseId}", id);

                    foreach (var section in course.Sections)
                    {
                        if (section.Lectures != null && section.Lectures.Any())
                        {
                            foreach (var lecture in section.Lectures)
                            {
                                if (lecture.Video != null && lecture.ContentType?.ToLower() == "video")
                                {
                                    var existingLecture = existingCourse.Sections?
                                        .SelectMany(s => s.Lectures ?? new List<LectureDTO>())
                                        .FirstOrDefault(l => l.Id == lecture.Id);

                                    if (existingLecture != null && !string.IsNullOrEmpty(existingLecture.VideoUrl))
                                    {
                                        oldVideoUrls.Add(existingLecture.VideoUrl);
                                    }

                                    _logger.LogInformation("Uploading new video for lecture ID: {LectureId}", lecture.Id);

                                    lecture.VideoUrl = await _fileStorageService.UploadFileAsync(
                                        lecture.Video, "Videos/Courses", cancellationToken) ?? lecture.VideoUrl;

                                    _logger.LogInformation("New video uploaded successfully for lecture ID: {LectureId}", lecture.Id);
                                }
                                else
                                {
                                    lecture.VideoUrl = lecture.VideoUrl ?? "";
                                }
                            }
                        }
                    }
                }

                var updatedCourse = await _courseService.UpdateCourseAsInstructorAsync(course, cancellationToken);
                if (updatedCourse == null)
                {
                    _logger.LogWarning("Course not found after update attempt. ID: {CourseId}", id);
                    return NotFound(new { message = $"الكورس مش موجود بـ ID {id}" });
                }

                // Delete old files after successful update
                if (!string.IsNullOrEmpty(oldImageUrl) && !oldImageUrl.Equals("/Images/Courses/default.jpg"))
                {
                    _logger.LogInformation("Deleting old image: {OldImageUrl}", oldImageUrl);
                    _fileStorageService.DeleteFile(oldImageUrl);
                }

                foreach (var videoUrl in oldVideoUrls)
                {
                    _logger.LogInformation("Deleting old video: {VideoUrl}", videoUrl);
                    _fileStorageService.DeleteVideoFileIfExists(videoUrl);
                }

                _logger.LogInformation("Course updated successfully as instructor. ID: {CourseId}", id);
                return Ok(updatedCourse);
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Update course as instructor operation was cancelled. ID: {CourseId}", id);
                return StatusCode(499, new { message = "Request was cancelled" });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while updating course as instructor. ID: {CourseId}", id);
                return StatusCode(500, new { message = "حدث خطأ أثناء التعديل", error = ex.Message });
            }
        }

        #endregion

        #region Delete Operations

        /// <summary>
        /// Deletes a course as instructor
        /// </summary>
        /// <param name="id">Course ID</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Delete result</returns>
        /// <response code="200">If course was deleted successfully</response>
        /// <response code="401">If user is not authenticated or doesn't own the course</response>
        /// <response code="404">If course is not found</response>
        /// <response code="500">If there was an internal server error</response>
        [HttpDelete("instructor/{id:int}")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status401Unauthorized)]
        [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status404NotFound)]
        [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status500InternalServerError)]
        public async Task<IActionResult> DeleteCourseAsInstructor(int id, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Deleting course as instructor. ID: {CourseId}", id);

                // Get current user ID
                var instructorId = await _currentUserService.GetUserIdAsync();
                if (string.IsNullOrEmpty(instructorId))
                {
                    _logger.LogWarning("Unauthorized attempt to delete course ID: {CourseId}", id);
                    return Unauthorized(new { success = false, message = "المستخدم غير مسجل دخول" });
                }

                // Get course to verify ownership and file paths
                var course = await _courseService.GetCourseByIdAsync(id, cancellationToken);
                if (course == null)
                {
                    _logger.LogWarning("Course not found for deletion. ID: {CourseId}", id);
                    return NotFound(new { success = false, message = $"الكورس بمعرف {id} غير موجود" });
                }

                // Verify course ownership
                if (course.InstructorId != instructorId)
                {
                    _logger.LogWarning("Instructor ID: {InstructorId} attempted to delete course ID: {CourseId} which they don't own",
                        instructorId, id);
                    return Unauthorized(new { success = false, message = "لا يمكن حذف كورس لا يخصك" });
                }

                // Delete course
                var isDeleted = await _courseService.DeleteCourseAsInstructorAsync(id, cancellationToken);
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

                _logger.LogInformation("Course deleted successfully as instructor. ID: {CourseId}", id);
                return Ok(new { success = true, message = "تم حذف الكورس بنجاح" });
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Delete course as instructor operation was cancelled. ID: {CourseId}", id);
                return StatusCode(499, new { message = "Request was cancelled" });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while deleting course as instructor. ID: {CourseId}", id);
                return StatusCode(500, new { success = false, message = "حدث خطأ أثناء حذف الكورس", error = ex.Message });
            }
        }

        /// <summary>
        /// Bulk delete courses as instructor
        /// </summary>
        /// <param name="ids">List of course IDs</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Bulk delete result</returns>
        /// <response code="200">If courses were deleted successfully</response>
        /// <response code="400">If no courses were specified</response>
        /// <response code="401">If user is not authenticated</response>
        /// <response code="404">If courses are not found</response>
        /// <response code="500">If there was an internal server error</response>
        [HttpPost("instructor/BulkDelete")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status400BadRequest)]
        [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status401Unauthorized)]
        [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status404NotFound)]
        [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status500InternalServerError)]
        public async Task<IActionResult> BulkDeleteAsInstructor([FromBody] List<int> ids, CancellationToken cancellationToken = default)
        {
            if (ids == null || !ids.Any())
            {
                _logger.LogWarning("Bulk delete as instructor request with empty IDs list");
                return BadRequest(new { success = false, message = "لم يتم تحديد أي دورات للحذف" });
            }

            try
            {
                _logger.LogInformation("Bulk deleting {Count} courses as instructor", ids.Count);

                // Get current user ID
                var instructorId = await _currentUserService.GetUserIdAsync();
                if (string.IsNullOrEmpty(instructorId))
                {
                    _logger.LogWarning("Unauthorized attempt to bulk delete courses");
                    return Unauthorized(new { success = false, message = "المستخدم غير مسجل دخول" });
                }

                // Get courses that belong to the instructor
                var coursesToDelete = new List<CourseDTO>();
                foreach (var id in ids)
                {
                    var course = await _courseService.GetCourseByIdAsync(id, cancellationToken);
                    if (course != null && course.InstructorId == instructorId)
                    {
                        coursesToDelete.Add(course);
                    }
                }

                if (!coursesToDelete.Any())
                {
                    _logger.LogWarning("No courses found for bulk deletion by instructor ID: {InstructorId}", instructorId);
                    return NotFound(new { success = false, message = "لا توجد كورسات تخصك للحذف" });
                }

                // Delete courses from database
                var idsToDelete = coursesToDelete.Select(c => c.Id).ToList();
                var result = await _courseService.BulkDeleteCoursesAsInstructorAsync(idsToDelete, cancellationToken);

                if (!result)
                {
                    _logger.LogWarning("Bulk delete failed for {Count} courses by instructor ID: {InstructorId}",
                        idsToDelete.Count, instructorId);
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

                _logger.LogInformation("Bulk delete completed successfully as instructor. Deleted {Count} courses", idsToDelete.Count);
                return Ok(new { success = true, message = $"تم حذف {idsToDelete.Count} دورة بنجاح" });
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Bulk delete as instructor operation was cancelled");
                return StatusCode(499, new { message = "Request was cancelled" });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred during bulk delete as instructor of {Count} courses", ids.Count);
                return StatusCode(500, new
                {
                    success = false,
                    message = "حدث خطأ أثناء حذف الدورات",
                    error = ex.Message
                });
            }
        }

        #endregion
    }
}
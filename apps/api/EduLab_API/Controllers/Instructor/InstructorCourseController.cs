using AutoMapper;
using EduLab_Application.ServiceInterfaces;
using EduLab_Application.DTOs.Course;
using EduLab_Application.DTOs.Lecture;
using EduLab_Application.DTOs.Section;
using EduLab_Application.Common;
using EduLab_Domain.Entities;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.ComponentModel;
using System.Text.Json;
using System.Threading;
using EduLab_Application.Common.Constants;

namespace EduLab_API.Controllers.Instructor
{
    /// <summary>
    /// Controller for managing courses by instructors
    /// </summary>
    [Route("api/[controller]")]
    [ApiController]
    [Produces("application/json")]
    [DisplayName("Instructor Course Management")]
    [Description("APIs for managing courses by instructors")]
    [Authorize(Roles = SD.Instructor)]
    public class InstructorCourseController : ControllerBase
    {
        private readonly ICourseService _courseService;
        private readonly IFileStorageService _fileStorageService;
        private readonly IMapper _mapper;
        private readonly ICurrentUserService _currentUserService;
        private readonly IHistoryService _historyService;
        private readonly ILogger<InstructorCourseController> _logger;

        /// <summary>
        /// Initializes a new instance of the InstructorCourseController class
        /// </summary>
        /// <param name="courseService">Course service</param>
        /// <param name="fileStorageService">File storage service</param>
        /// <param name="mapper">AutoMapper instance</param>
        /// <param name="currentUserService">Current user service</param>
        /// <param name="historyService">History service</param>
        /// <param name="logger">Logger instance</param>
        public InstructorCourseController(
            ICourseService courseService,
            IFileStorageService fileStorageService,
            IMapper mapper,
            ICurrentUserService currentUserService,
            IHistoryService historyService,
            ILogger<InstructorCourseController> logger)
        {
            _courseService = courseService;
            _fileStorageService = fileStorageService;
            _mapper = mapper;
            _currentUserService = currentUserService;
            _historyService = historyService;
            _logger = logger;
        }

        #region Ownership Guards

        private IActionResult NotOwner() => Unauthorized(new { message = "لا يمكن الوصول إلى كورس لا يخصك" });

        /// <summary>
        /// Ensures that the course belongs to the current instructor
        /// </summary>
        private async Task<bool> IsCourseOwnerAsync(int courseId, CancellationToken cancellationToken)
        {
            var instructorId = await _currentUserService.GetUserIdAsync();
            if (string.IsNullOrEmpty(instructorId))
                return false;

            var course = await _courseService.GetCourseByIdAsync(courseId, cancellationToken);
            return course != null && course.InstructorId == instructorId;
        }

        /// <summary>
        /// Ensures that the section belongs to the current instructor
        /// </summary>
        private async Task<bool> IsSectionOwnerAsync(int sectionId, CancellationToken cancellationToken)
        {
            var section = await _courseService.GetSectionByIdAsync(sectionId, cancellationToken);
            if (section == null)
                return false;
            return await IsCourseOwnerAsync(section.CourseId, cancellationToken);
        }

        /// <summary>
        /// Ensures that the lecture belongs to the current instructor
        /// </summary>
        private async Task<bool> IsLectureOwnerAsync(int lectureId, CancellationToken cancellationToken)
        {
            var courseId = await _courseService.GetCourseIdByLectureAsync(lectureId, cancellationToken);
            if (!courseId.HasValue)
                return false;
            return await IsCourseOwnerAsync(courseId.Value, cancellationToken);
        }

        /// <summary>
        /// Ensures that the resource belongs to the current instructor
        /// </summary>
        private async Task<bool> IsResourceOwnerAsync(int resourceId, CancellationToken cancellationToken)
        {
            var courseId = await _courseService.GetCourseIdByResourceAsync(resourceId, cancellationToken);
            if (!courseId.HasValue)
                return false;
            return await IsCourseOwnerAsync(courseId.Value, cancellationToken);
        }

        #endregion

        #region Get Operations

        /// <summary>
        /// Gets all courses belonging to the current instructor
        /// </summary>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>List of the instructor's courses</returns>
        /// <response code="200">Returns the list of courses</response>
        /// <response code="401">If the user is not authenticated</response>
        /// <response code="404">If no courses are found</response>
        /// <response code="500">If there was an internal server error</response>
        [HttpGet("instructor-courses")]
        [ProducesResponseType(typeof(IEnumerable<CourseDTO>), StatusCodes.Status200OK)]
        public async Task<IActionResult> GetInstructorCourses(CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Getting courses for current instructor");

                var instructorId = await _currentUserService.GetUserIdAsync();
                if (string.IsNullOrEmpty(instructorId))
                    return Unauthorized();

                var courses = await _courseService.GetInstructorCoursesAsync(instructorId, cancellationToken);
                if (courses == null || !courses.Any())
                    return NotFound(new { message = "No courses found for this instructor" });

                if (!string.IsNullOrEmpty(instructorId))
                    await _historyService.LogOperationAsync(instructorId, "قام المستخدم بعرض جميع الكورسات الخاصة به.", OperationType.View, HistoryMessages.InstructorCoursesViewed, null, CancellationToken.None);

                return Ok(courses);
            }
            catch (OperationCanceledException)
            {
                return StatusCode(499, new { message = "Request was cancelled" });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error retrieving instructor courses");
                return StatusCode(500, new { message = "An error occurred", error = ex.Message });
            }
        }

        /// <summary>
        /// Gets a course by ID (ownership enforced)
        /// </summary>
        /// <param name="id">Course ID</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Course details</returns>
        /// <response code="200">Returns the course</response>
        /// <response code="401">If the user is not authenticated or does not own the course</response>
        /// <response code="404">If the course is not found</response>
        /// <response code="500">If there was an internal server error</response>
        [HttpGet("{id:int}")]
        [ProducesResponseType(typeof(CourseDTO), StatusCodes.Status200OK)]
        public async Task<IActionResult> GetCourseById(int id, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Getting course by ID: {CourseId}", id);

                var instructorId = await _currentUserService.GetUserIdAsync();
                if (string.IsNullOrEmpty(instructorId))
                    return Unauthorized();

                var course = await _courseService.GetCourseByIdAsync(id, cancellationToken);
                if (course == null)
                    return NotFound(new { message = $"No course found with ID {id}" });

                if (course.InstructorId != instructorId)
                    return Unauthorized(new { message = "لا يمكن الوصول إلى كورس لا يخصك" });

                if (!string.IsNullOrEmpty(instructorId))
                    await _historyService.LogOperationAsync(instructorId, $"قام المستخدم بعرض الكورس [ID: {id}] بعنوان \"{course.Title}\".", OperationType.View, HistoryMessages.CourseViewed,
                        JsonSerializer.Serialize(new { id }), CancellationToken.None);

                return Ok(course);
            }
            catch (OperationCanceledException)
            {
                return StatusCode(499, new { message = "Request was cancelled" });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error retrieving course ID: {CourseId}", id);
                return StatusCode(500, new { message = "An error occurred", error = ex.Message });
            }
        }

        #endregion

        #region Course Draft Operations

        /// <summary>
        /// Creates a new course draft
        /// </summary>
        /// <param name="draftDto">Course draft data</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>The created course draft</returns>
        /// <response code="201">Returns the created course draft</response>
        /// <response code="400">If the data is invalid</response>
        /// <response code="401">If the user is not authenticated</response>
        /// <response code="500">If there was an internal server error</response>
        [HttpPost]
        [Consumes("multipart/form-data")]
        [ProducesResponseType(typeof(CourseDTO), StatusCodes.Status201Created)]
        public async Task<IActionResult> CreateCourseDraft([FromForm] CourseDraftDTO draftDto, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Creating course draft: {CourseTitle}", draftDto?.Title);

                if (draftDto == null || string.IsNullOrWhiteSpace(draftDto.Title))
                    return BadRequest(new { message = "عنوان الكورس مطلوب" });

                var instructorId = await _currentUserService.GetUserIdAsync();
                if (string.IsNullOrEmpty(instructorId))
                    return Unauthorized();

                var createdCourse = await _courseService.CreateCourseDraftAsync(draftDto, cancellationToken);
                return CreatedAtAction(nameof(GetCourseById), new { id = createdCourse.Id }, createdCourse);
            }
            catch (OperationCanceledException)
            {
                return StatusCode(499, new { message = "Request was cancelled" });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error creating course draft");
                return StatusCode(500, new { message = "حدث خطأ", error = ex.Message });
            }
        }

        /// <summary>
        /// Updates a course draft
        /// </summary>
        /// <param name="id">Course ID</param>
        /// <param name="courseDto">Updated course data</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>The updated course</returns>
        /// <response code="200">Returns the updated course</response>
        /// <response code="400">If the data is invalid</response>
        /// <response code="401">If the user is not authenticated</response>
        /// <response code="404">If the course is not found</response>
        /// <response code="500">If there was an internal server error</response>
        [HttpPut("{id:int}")]
        [Consumes("multipart/form-data")]
        [ProducesResponseType(typeof(CourseDTO), StatusCodes.Status200OK)]
        public async Task<IActionResult> UpdateCourseDraft(int id, [FromForm] CourseUpdateDTO courseDto, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Updating course draft. ID: {CourseId}", id);

                if (courseDto == null)
                    return BadRequest(new { message = "البيانات غير صالحة" });

                if (courseDto.Image != null && courseDto.Image.Length > 0)
                {
                    var thumbnailUrl = await _fileStorageService.UploadFileAsync(courseDto.Image, "Images/Courses", cancellationToken);
                    courseDto.ThumbnailUrl = thumbnailUrl;
                }

                var updatedCourse = await _courseService.UpdateCourseDetailsAsync(id, courseDto, cancellationToken);
                if (updatedCourse == null)
                    return NotFound(new { message = $"الكورس مش موجود بـ ID {id}" });

                return Ok(updatedCourse);
            }
            catch (OperationCanceledException)
            {
                return StatusCode(499, new { message = "Request was cancelled" });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error updating course. ID: {CourseId}", id);
                return StatusCode(500, new { message = "حدث خطأ", error = ex.Message });
            }
        }

        #endregion

        #region Section Operations

        /// <summary>
        /// Adds a section to a course
        /// </summary>
        /// <param name="courseId">Course ID</param>
        /// <param name="sectionDto">Section data</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>The created section</returns>
        /// <response code="201">Returns the created section</response>
        /// <response code="400">If the data is invalid</response>
        /// <response code="401">If the user is not authenticated or does not own the course</response>
        /// <response code="500">If there was an internal server error</response>
        [HttpPost("{courseId:int}/sections")]
        [ProducesResponseType(typeof(SectionDTO), StatusCodes.Status201Created)]
        public async Task<IActionResult> AddSection(int courseId, [FromBody] SectionCreateDTO sectionDto, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Adding section to course ID: {CourseId}", courseId);

                if (sectionDto == null || string.IsNullOrWhiteSpace(sectionDto.Title))
                    return BadRequest(new { message = "عنوان القسم مطلوب" });

                if (!await IsCourseOwnerAsync(sectionDto.CourseId, cancellationToken))
                    return NotOwner();

                sectionDto.CourseId = courseId;
                var section = await _courseService.AddSectionAsync(sectionDto, cancellationToken);
                return CreatedAtAction(nameof(GetSection), new { sectionId = section.Id }, section);
            }
            catch (ArgumentException ex)
            {
                return BadRequest(new { message = ex.Message });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error adding section to course ID: {CourseId}", courseId);
                return StatusCode(500, new { message = "حدث خطأ", error = ex.Message });
            }
        }

        /// <summary>
        /// Gets a section by ID (ownership enforced)
        /// </summary>
        /// <param name="sectionId">Section ID</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Section details</returns>
        /// <response code="200">Returns the section</response>
        /// <response code="401">If the user is not authenticated or does not own the course</response>
        /// <response code="404">If the section is not found</response>
        /// <response code="500">If there was an internal server error</response>
        [HttpGet("sections/{sectionId:int}")]
        [ProducesResponseType(typeof(SectionDTO), StatusCodes.Status200OK)]
        public async Task<IActionResult> GetSection(int sectionId, CancellationToken cancellationToken = default)
        {
            try
            {
                if (!await IsSectionOwnerAsync(sectionId, cancellationToken))
                    return NotOwner();

                var section = await _courseService.GetSectionByIdAsync(sectionId, cancellationToken);
                if (section == null)
                    return NotFound(new { message = "القسم غير موجود" });

                return Ok(section);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting section ID: {SectionId}", sectionId);
                return StatusCode(500, new { message = "حدث خطأ", error = ex.Message });
            }
        }

        /// <summary>
        /// Updates a section
        /// </summary>
        /// <param name="sectionId">Section ID</param>
        /// <param name="sectionDto">Updated section data</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>The updated section</returns>
        /// <response code="200">Returns the updated section</response>
        /// <response code="400">If the data is invalid</response>
        /// <response code="401">If the user is not authenticated or does not own the course</response>
        /// <response code="500">If there was an internal server error</response>
        [HttpPut("sections/{sectionId:int}")]
        [ProducesResponseType(typeof(SectionDTO), StatusCodes.Status200OK)]
        public async Task<IActionResult> UpdateSection(int sectionId, [FromBody] SectionUpdateDTO sectionDto, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Updating section ID: {SectionId}", sectionId);

                if (sectionDto == null || string.IsNullOrWhiteSpace(sectionDto.Title))
                    return BadRequest(new { message = "عنوان القسم مطلوب" });

                if (!await IsSectionOwnerAsync(sectionId, cancellationToken))
                    return NotOwner();

                var section = await _courseService.UpdateSectionAsync(sectionId, sectionDto, cancellationToken);
                return Ok(section);
            }
            catch (ArgumentException ex)
            {
                return BadRequest(new { message = ex.Message });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error updating section ID: {SectionId}", sectionId);
                return StatusCode(500, new { message = "حدث خطأ", error = ex.Message });
            }
        }

        /// <summary>
        /// Deletes a section
        /// </summary>
        /// <param name="sectionId">Section ID</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Delete result</returns>
        /// <response code="200">If the section was deleted successfully</response>
        /// <response code="401">If the user is not authenticated or does not own the course</response>
        /// <response code="404">If the section is not found</response>
        /// <response code="500">If there was an internal server error</response>
        [HttpDelete("sections/{sectionId:int}")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<IActionResult> DeleteSection(int sectionId, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Deleting section ID: {SectionId}", sectionId);

                if (!await IsSectionOwnerAsync(sectionId, cancellationToken))
                    return NotOwner();

                var result = await _courseService.DeleteSectionAsync(sectionId, cancellationToken);
                if (!result)
                    return NotFound(new { message = "القسم غير موجود" });

                return Ok(new { success = true, message = "تم حذف القسم بنجاح" });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error deleting section ID: {SectionId}", sectionId);
                return StatusCode(500, new { message = "حدث خطأ", error = ex.Message });
            }
        }

        /// <summary>
        /// Reorders the sections of a course
        /// </summary>
        /// <param name="reorderDto">Reorder data with the desired section order</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Operation result</returns>
        /// <response code="200">If the sections were reordered successfully</response>
        /// <response code="401">If the user is not authenticated or does not own the course</response>
        /// <response code="500">If there was an internal server error</response>
        [HttpPut("sections/reorder")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<IActionResult> ReorderSections([FromBody] SectionReorderDTO reorderDto, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Reordering sections for course ID: {CourseId}", reorderDto.CourseId);

                if (!await IsCourseOwnerAsync(reorderDto.CourseId, cancellationToken))
                    return NotOwner();

                var result = await _courseService.ReorderSectionsAsync(reorderDto.CourseId, reorderDto.SectionIds, cancellationToken);
                return Ok(new { success = result });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error reordering sections");
                return StatusCode(500, new { message = "حدث خطأ", error = ex.Message });
            }
        }

        #endregion

        #region Lecture Operations

        /// <summary>
        /// Adds a lecture to a section
        /// </summary>
        /// <param name="sectionId">Section ID</param>
        /// <param name="lectureDto">Lecture data</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>The created lecture</returns>
        /// <response code="201">Returns the created lecture</response>
        /// <response code="400">If the data is invalid</response>
        /// <response code="401">If the user is not authenticated or does not own the course</response>
        /// <response code="500">If there was an internal server error</response>
        [HttpPost("sections/{sectionId:int}/lectures")]
        [Consumes("multipart/form-data")]
        [ProducesResponseType(typeof(LectureDTO), StatusCodes.Status201Created)]
        public async Task<IActionResult> AddLecture(int sectionId, [FromForm] LectureCreateDTO lectureDto, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Adding lecture to section ID: {SectionId}", sectionId);

                if (lectureDto == null || string.IsNullOrWhiteSpace(lectureDto.Title))
                    return BadRequest(new { message = "عنوان المحاضرة مطلوب" });

                if (!await IsSectionOwnerAsync(sectionId, cancellationToken))
                    return NotOwner();

                lectureDto.SectionId = sectionId;
                var lecture = await _courseService.AddLectureAsync(lectureDto, cancellationToken);
                return CreatedAtAction(nameof(GetLecture), new { lectureId = lecture.Id }, lecture);
            }
            catch (ArgumentException ex)
            {
                return BadRequest(new { message = ex.Message });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error adding lecture to section ID: {SectionId}", sectionId);
                return StatusCode(500, new { message = "حدث خطأ", error = ex.Message });
            }
        }

        /// <summary>
        /// Gets a lecture by ID (ownership enforced)
        /// </summary>
        /// <param name="lectureId">Lecture ID</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Lecture details</returns>
        /// <response code="200">Returns the lecture</response>
        /// <response code="401">If the user is not authenticated or does not own the course</response>
        /// <response code="404">If the lecture is not found</response>
        /// <response code="500">If there was an internal server error</response>
        [HttpGet("lectures/{lectureId:int}")]
        [ProducesResponseType(typeof(LectureDTO), StatusCodes.Status200OK)]
        public async Task<IActionResult> GetLecture(int lectureId, CancellationToken cancellationToken = default)
        {
            try
            {
                if (!await IsLectureOwnerAsync(lectureId, cancellationToken))
                    return NotOwner();

                var lecture = await _courseService.GetLectureByIdAsync(lectureId, cancellationToken);
                if (lecture == null)
                    return NotFound(new { message = "المحاضرة غير موجودة" });

                return Ok(lecture);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting lecture ID: {LectureId}", lectureId);
                return StatusCode(500, new { message = "حدث خطأ", error = ex.Message });
            }
        }

        /// <summary>
        /// Updates a lecture
        /// </summary>
        /// <param name="lectureId">Lecture ID</param>
        /// <param name="lectureDto">Updated lecture data</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>The updated lecture</returns>
        /// <response code="200">Returns the updated lecture</response>
        /// <response code="400">If the data is invalid</response>
        /// <response code="401">If the user is not authenticated or does not own the course</response>
        /// <response code="500">If there was an internal server error</response>
        [HttpPut("lectures/{lectureId:int}")]
        [Consumes("multipart/form-data")]
        [ProducesResponseType(typeof(LectureDTO), StatusCodes.Status200OK)]
        public async Task<IActionResult> UpdateLecture(int lectureId, [FromForm] LectureUpdateDTO lectureDto, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Updating lecture ID: {LectureId}", lectureId);

                if (lectureDto == null || string.IsNullOrWhiteSpace(lectureDto.Title))
                    return BadRequest(new { message = "عنوان المحاضرة مطلوب" });

                if (!await IsLectureOwnerAsync(lectureId, cancellationToken))
                    return NotOwner();

                var lecture = await _courseService.UpdateLectureAsync(lectureId, lectureDto, cancellationToken);
                return Ok(lecture);
            }
            catch (ArgumentException ex)
            {
                return BadRequest(new { message = ex.Message });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error updating lecture ID: {LectureId}", lectureId);
                return StatusCode(500, new { message = "حدث خطأ", error = ex.Message });
            }
        }

        /// <summary>
        /// Deletes a lecture
        /// </summary>
        /// <param name="lectureId">Lecture ID</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Delete result</returns>
        /// <response code="200">If the lecture was deleted successfully</response>
        /// <response code="401">If the user is not authenticated or does not own the course</response>
        /// <response code="404">If the lecture is not found</response>
        /// <response code="500">If there was an internal server error</response>
        [HttpDelete("lectures/{lectureId:int}")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<IActionResult> DeleteLecture(int lectureId, CancellationToken cancellationToken = default)
        {
        try
        {
                _logger.LogInformation("Deleting lecture ID: {LectureId}", lectureId);

                if (!await IsLectureOwnerAsync(lectureId, cancellationToken))
                    return NotOwner();

                var result = await _courseService.DeleteLectureAsync(lectureId, cancellationToken);
                if (!result)
                    return NotFound(new { message = "المحاضرة غير موجودة" });

                return Ok(new { success = true, message = "تم حذف المحاضرة بنجاح" });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error deleting lecture ID: {LectureId}", lectureId);
                return StatusCode(500, new { message = "حدث خطأ", error = ex.Message });
            }
        }

        /// <summary>
        /// Reorders the lectures of a section
        /// </summary>
        /// <param name="reorderDto">Reorder data with the desired lecture order</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Operation result</returns>
        /// <response code="200">If the lectures were reordered successfully</response>
        /// <response code="401">If the user is not authenticated or does not own the course</response>
        /// <response code="500">If there was an internal server error</response>
        [HttpPut("lectures/reorder")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<IActionResult> ReorderLectures([FromBody] LectureReorderDTO reorderDto, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Reordering lectures for section ID: {SectionId}", reorderDto.SectionId);

                if (!await IsSectionOwnerAsync(reorderDto.SectionId, cancellationToken))
                    return NotOwner();

                var result = await _courseService.ReorderLecturesAsync(reorderDto.SectionId, reorderDto.LectureIds, cancellationToken);
                return Ok(new { success = result });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error reordering lectures");
                return StatusCode(500, new { message = "حدث خطأ", error = ex.Message });
            }
        }

        #endregion

        #region Lecture Resources Operations

        /// <summary>
        /// Adds a resource file to a lecture
        /// </summary>
        /// <param name="lectureId">Lecture ID</param>
        /// <param name="resourceFile">Resource file to upload</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>The created resource</returns>
        /// <response code="200">Returns the created resource</response>
        /// <response code="400">If the upload failed</response>
        /// <response code="401">If the user is not authenticated or does not own the course</response>
        /// <response code="500">If there was an internal server error</response>
        [HttpPost("lecture/{lectureId}/resources")]
        [ProducesResponseType(typeof(LectureResourceDTO), StatusCodes.Status200OK)]
        public async Task<IActionResult> AddResourceToLecture(int lectureId, IFormFile resourceFile, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Adding resource to lecture ID: {LectureId}", lectureId);

                var instructorId = await _currentUserService.GetUserIdAsync();
                if (string.IsNullOrEmpty(instructorId))
                    return Unauthorized(new { message = "المستخدم غير مسجل دخول" });

                if (!await IsLectureOwnerAsync(lectureId, cancellationToken))
                    return NotOwner();

                var resource = await _courseService.AddResourceToLectureAsync(lectureId, resourceFile, cancellationToken);
                return Ok(resource);
            }
            catch (ArgumentException ex)
            {
                return BadRequest(new { message = ex.Message });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error adding resource to lecture ID: {LectureId}", lectureId);
                return StatusCode(500, new { message = "حدث خطأ", error = ex.Message });
            }
        }

        /// <summary>
        /// Deletes a resource from a lecture
        /// </summary>
        /// <param name="resourceId">Resource ID</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Delete result</returns>
        /// <response code="200">If the resource was deleted successfully</response>
        /// <response code="401">If the user is not authenticated or does not own the course</response>
        /// <response code="500">If there was an internal server error</response>
        [HttpDelete("resources/{resourceId}")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<IActionResult> DeleteResource(int resourceId, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Deleting resource ID: {ResourceId}", resourceId);

                if (!await IsResourceOwnerAsync(resourceId, cancellationToken))
                    return NotOwner();

                var result = await _courseService.DeleteResourceAsync(resourceId, cancellationToken);
                return Ok(new { success = result });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error deleting resource ID: {ResourceId}", resourceId);
                return StatusCode(500, new { message = "حدث خطأ", error = ex.Message });
            }
        }

        #endregion

        #region Publish Operations

        /// <summary>
        /// Publishes a course (submits it for admin review)
        /// </summary>
        /// <param name="courseId">Course ID</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Publish result</returns>
        /// <response code="200">Returns the publish result</response>
        /// <response code="400">If the course could not be published</response>
        /// <response code="401">If the user is not authenticated</response>
        /// <response code="500">If there was an internal server error</response>
        [HttpPost("{courseId:int}/publish")]
        [ProducesResponseType(typeof(PublishResultDTO), StatusCodes.Status200OK)]
        public async Task<IActionResult> PublishCourse(int courseId, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Publishing course ID: {CourseId}", courseId);

                var instructorId = await _currentUserService.GetUserIdAsync();
                if (string.IsNullOrEmpty(instructorId))
                    return Unauthorized();

                var result = await _courseService.PublishCourseAsync(courseId, cancellationToken);
                if (!result.Success)
                    return BadRequest(result);

                return Ok(result);
            }
            catch (UnauthorizedAccessException ex)
            {
                return Unauthorized(new { message = ex.Message });
            }
            catch (OperationCanceledException)
            {
                return StatusCode(499, new { message = "Request was cancelled" });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error publishing course ID: {CourseId}", courseId);
                return StatusCode(500, new { message = "حدث خطأ", error = ex.Message });
            }
        }

        #endregion

        #region Delete Operations

        /// <summary>
        /// Deletes a course as an instructor (ownership enforced)
        /// </summary>
        /// <param name="id">Course ID</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Delete result</returns>
        /// <response code="200">If the course was deleted successfully</response>
        /// <response code="401">If the user is not authenticated or does not own the course</response>
        /// <response code="404">If the course is not found</response>
        /// <response code="500">If there was an internal server error</response>
        [HttpDelete("instructor/{id:int}")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<IActionResult> DeleteCourseAsInstructor(int id, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Deleting course as instructor. ID: {CourseId}", id);

                var instructorId = await _currentUserService.GetUserIdAsync();
                if (string.IsNullOrEmpty(instructorId))
                    return Unauthorized(new { message = "المستخدم غير مسجل دخول" });

                var course = await _courseService.GetCourseByIdAsync(id, cancellationToken);
                if (course == null)
                    return NotFound(new { message = $"الكورس بمعرف {id} غير موجود" });

                if (course.InstructorId != instructorId)
                    return Unauthorized(new { message = "لا يمكن حذف كورس لا يخصك" });

                var isDeleted = await _courseService.DeleteCourseAsInstructorAsync(id, cancellationToken);
                if (!isDeleted)
                    return NotFound(new { message = $"الكورس بمعرف {id} غير موجود" });

                return Ok(new { success = true, message = "تم حذف الكورس بنجاح" });
            }
            catch (OperationCanceledException)
            {
                return StatusCode(499, new { message = "Request was cancelled" });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error deleting course. ID: {CourseId}", id);
                return StatusCode(500, new { message = "حدث خطأ", error = ex.Message });
            }
        }

        /// <summary>
        /// Bulk deletes courses owned by the current instructor
        /// </summary>
        /// <param name="ids">List of course IDs</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Bulk delete result</returns>
        /// <response code="200">If the courses were deleted successfully</response>
        /// <response code="400">If no course IDs were provided</response>
        /// <response code="401">If the user is not authenticated or does not own the courses</response>
        /// <response code="404">If the specified courses were not found</response>
        /// <response code="500">If there was an internal server error</response>
        [HttpPost("instructor/BulkDelete")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [ProducesResponseType(StatusCodes.Status401Unauthorized)]
        [ProducesResponseType(StatusCodes.Status500InternalServerError)]
        public async Task<IActionResult> BulkDeleteCoursesAsInstructor([FromBody] List<int> ids, CancellationToken cancellationToken = default)
        {
            try
            {
                if (ids == null || !ids.Any())
                {
                    _logger.LogWarning("Bulk delete request with empty IDs list");
                    return BadRequest(new { success = false, message = "لم يتم تحديد أي دورات للحذف" });
                }

                _logger.LogInformation("Bulk deleting {Count} courses as instructor", ids.Count);

                var instructorId = await _currentUserService.GetUserIdAsync();
                if (string.IsNullOrEmpty(instructorId))
                    return Unauthorized(new { message = "المستخدم غير مسجل دخول" });

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
                    return Unauthorized(new { message = "لا يمكن حذف كورسات لا تخصك" });

                var ownedIds = coursesToDelete.Select(c => c.Id).ToList();

                var result = await _courseService.BulkDeleteCoursesAsInstructorAsync(ownedIds, cancellationToken);
                if (!result)
                {
                    _logger.LogWarning("Bulk delete failed for {Count} courses", ownedIds.Count);
                    return NotFound(new { success = false, message = "لم يتم العثور على الدورات المحددة" });
                }

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

                _logger.LogInformation("Bulk delete completed successfully. Deleted {Count} courses", ownedIds.Count);
                return Ok(new { success = true, message = $"تم حذف {ownedIds.Count} دورة بنجاح" });
            }
            catch (OperationCanceledException)
            {
                return StatusCode(499, new { message = "Request was cancelled" });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error bulk deleting courses as instructor");
                return StatusCode(500, new { success = false, message = "حدث خطأ", error = ex.Message });
            }
        }

        #endregion
    }
}

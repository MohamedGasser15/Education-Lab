using AutoMapper;
using EduLab_Application.ServiceInterfaces;
using EduLab_Application.DTOs.Course;
using EduLab_Application.DTOs.Lecture;
using EduLab_Application.DTOs.Section;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.ComponentModel;
using System.Threading;
using EduLab_Application.Common.Constants;

namespace EduLab_API.Controllers.Instructor
{
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
        private readonly ILogger<InstructorCourseController> _logger;

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

        [HttpPost("{courseId:int}/sections")]
        [ProducesResponseType(typeof(SectionDTO), StatusCodes.Status201Created)]
        public async Task<IActionResult> AddSection(int courseId, [FromBody] SectionCreateDTO sectionDto, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Adding section to course ID: {CourseId}", courseId);

                if (sectionDto == null || string.IsNullOrWhiteSpace(sectionDto.Title))
                    return BadRequest(new { message = "عنوان القسم مطلوب" });

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

        [HttpGet("sections/{sectionId:int}")]
        [ProducesResponseType(typeof(SectionDTO), StatusCodes.Status200OK)]
        public async Task<IActionResult> GetSection(int sectionId, CancellationToken cancellationToken = default)
        {
            try
            {
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

        [HttpPut("sections/{sectionId:int}")]
        [ProducesResponseType(typeof(SectionDTO), StatusCodes.Status200OK)]
        public async Task<IActionResult> UpdateSection(int sectionId, [FromBody] SectionUpdateDTO sectionDto, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Updating section ID: {SectionId}", sectionId);

                if (sectionDto == null || string.IsNullOrWhiteSpace(sectionDto.Title))
                    return BadRequest(new { message = "عنوان القسم مطلوب" });

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

        [HttpDelete("sections/{sectionId:int}")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<IActionResult> DeleteSection(int sectionId, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Deleting section ID: {SectionId}", sectionId);

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

        [HttpPut("sections/reorder")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<IActionResult> ReorderSections([FromBody] SectionReorderDTO reorderDto, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Reordering sections for course ID: {CourseId}", reorderDto.CourseId);

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

        [HttpGet("lectures/{lectureId:int}")]
        [ProducesResponseType(typeof(LectureDTO), StatusCodes.Status200OK)]
        public async Task<IActionResult> GetLecture(int lectureId, CancellationToken cancellationToken = default)
        {
            try
            {
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

        [HttpDelete("lectures/{lectureId:int}")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<IActionResult> DeleteLecture(int lectureId, CancellationToken cancellationToken = default)
        {
        try
        {
                _logger.LogInformation("Deleting lecture ID: {LectureId}", lectureId);

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

        [HttpPut("lectures/reorder")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<IActionResult> ReorderLectures([FromBody] LectureReorderDTO reorderDto, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Reordering lectures for section ID: {SectionId}", reorderDto.SectionId);

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

        [HttpDelete("resources/{resourceId}")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<IActionResult> DeleteResource(int resourceId, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Deleting resource ID: {ResourceId}", resourceId);

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

        #endregion
    }
}

using AutoMapper;
using EduLab_Application.ServiceInterfaces;
using EduLab_Domain.Entities;
using EduLab_Shared.DTOs.Course;
using Microsoft.AspNetCore.Mvc;

namespace EduLab_API.Controllers.Admin
{
    [Route("api/[controller]")]
    [ApiController]
    public class CourseController : ControllerBase
    {
        private readonly ICourseService _courseService;
        private readonly IFileStorageService _fileStorageService;
        private readonly IMapper _mapper;

        public CourseController(ICourseService courseService, IFileStorageService fileStorageService, IMapper mapper)
        {
            _courseService = courseService;
            _fileStorageService = fileStorageService;
            _mapper = mapper;
        }

        [HttpGet]
        public async Task<IActionResult> GetAllCourses()
        {
            try
            {
                var courses = await _courseService.GetAllCoursesAsync();
                if (courses == null || !courses.Any())
                {
                    return NotFound(new { message = "No courses found" });
                }
                return Ok(courses);
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { message = "An error occurred while retrieving courses", error = ex.Message });
            }
        }

        [HttpGet("{id}")]
        public async Task<IActionResult> GetCourseById(int id)
        {
            try
            {
                var course = await _courseService.GetCourseByIdAsync(id);
                if (course == null)
                {
                    return NotFound(new { message = $"No course found with ID {id}" });
                }
                return Ok(course);
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { message = "An error occurred while retrieving the course", error = ex.Message });
            }
        }

        [HttpGet("instructor/{instructorId}")]
        public async Task<IActionResult> GetCoursesByInstructor(string instructorId)
        {
            try
            {
                var courses = await _courseService.GetCoursesByInstructorAsync(instructorId);
                if (courses == null || !courses.Any())
                {
                    return NotFound(new { message = $"No courses found for instructor with ID {instructorId}" });
                }
                return Ok(courses);
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { message = "An error occurred while retrieving courses by instructor", error = ex.Message });
            }
        }

        [HttpGet("category/{categoryId}")]
        public async Task<IActionResult> GetCoursesWithCategory(int categoryId)
        {
            try
            {
                var courses = await _courseService.GetCoursesWithCategoryAsync(categoryId);
                if (courses == null || !courses.Any())
                {
                    return NotFound(new { message = $"No courses found for category ID {categoryId}" });
                }
                return Ok(courses);
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { message = "An error occurred while retrieving courses with category", error = ex.Message });
            }
        }
        [HttpPost]
        [Consumes("multipart/form-data")]
        public async Task<IActionResult> AddCourse([FromForm] CourseCreateDTO course)
        {
            if (course == null)
                return BadRequest(new { message = "البيانات ناقصة" });

            if (string.IsNullOrEmpty(course.InstructorId))
                return BadRequest(new { message = "معرف المدرب ناقص" });

            try
            {
                course.ThumbnailUrl = course.ThumbnailUrl ?? "/Images/Courses/default.jpg";
                if (course.Image != null && course.Image.Length > 0)
                {
                    Console.WriteLine($"Uploading image: {course.Image.FileName}, Size: {course.Image.Length} bytes");
                    var thumbnailUrl = await _fileStorageService.UploadFileAsync(course.Image, "Images/Courses");
                    course.ThumbnailUrl = thumbnailUrl ?? course.ThumbnailUrl;
                    Console.WriteLine($"Thumbnail URL: {course.ThumbnailUrl}");
                }
                else
                {
                    Console.WriteLine("No image uploaded");
                }

                if (course.Sections != null && course.Sections.Any())
                {
                    foreach (var section in course.Sections)
                    {
                        if (section.Lectures != null && section.Lectures.Any())
                        {
                            foreach (var lecture in section.Lectures)
                            {
                                lecture.VideoUrl = lecture.VideoUrl ?? "";
                                var contentType = lecture.ContentType?.Trim().ToLower();
                                Console.WriteLine($"Lecture: {lecture.Title}, ContentType: {lecture.ContentType}, Trimmed: {contentType}");

                                if (lecture.Video != null && contentType == "video")
                                {
                                    Console.WriteLine($"Uploading video: {lecture.Title}, File: {lecture.Video.FileName}, Size: {lecture.Video.Length} bytes");
                                    lecture.VideoUrl = await _fileStorageService.UploadFileAsync(lecture.Video, "Videos/Courses") ?? "";
                                    Console.WriteLine($"Video URL: {lecture.VideoUrl}");
                                }
                                else
                                {
                                    Console.WriteLine($"No video uploaded or ContentType is not 'video' for lecture {lecture.Title}. ContentType: {contentType}, Video: {(lecture.Video != null ? lecture.Video.FileName : "null")}");
                                }

                                if (contentType != "video")
                                {
                                    lecture.VideoUrl = "";
                                }
                            }
                        }
                    }
                }

                var createdCourse = await _courseService.AddCourseAsync(course);
                return CreatedAtAction(nameof(GetCourseById), new { id = createdCourse.Id }, createdCourse);
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { message = "في مشكلة", error = ex.Message, innerError = ex.InnerException?.Message });
            }
        }

        [HttpPut("{id}")]
        [Consumes("multipart/form-data")]
        public async Task<IActionResult> UpdateCourse(int id, [FromForm] CourseUpdateDTO course)
        {
            if (course == null || course.Id != id)
                return BadRequest(new { message = "البيانات غلط" });

            try
            {
                if (course.Image != null && course.Image.Length > 0)
                {
                    var thumbnailUrl = await _fileStorageService.UploadFileAsync(course.Image, "Images/Courses");
                    course.ThumbnailUrl = thumbnailUrl ?? course.ThumbnailUrl;
                }

                if (course.Sections != null && course.Sections.Any())
                {
                    foreach (var section in course.Sections)
                    {
                        if (section.Lectures != null && section.Lectures.Any())
                        {
                            foreach (var lecture in section.Lectures)
                            {
                                if (lecture.Video != null && lecture.ContentType?.ToLower() == "video")
                                {
                                    lecture.VideoUrl = await _fileStorageService.UploadFileAsync(lecture.Video, "Videos/Courses") ?? lecture.VideoUrl;
                                }
                            }
                        }
                    }
                }

                var updatedCourse = await _courseService.UpdateCourseAsync(course);
                if (updatedCourse == null)
                    return NotFound(new { message = $"الكورس مش موجود بـ ID {id}" });

                return Ok(updatedCourse);
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { message = "في مشكلة", error = ex.Message });
            }
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteCourse(int id)
        {
            try
            {
                var isDeleted = await _courseService.DeleteCourseAsync(id);
                if (!isDeleted)
                {
                    return NotFound(new { success = false, message = $"الكورس بمعرف {id} غير موجود" });
                }
                return Ok(new { success = true, message = "تم حذف الكورس بنجاح" });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { success = false, message = "حدث خطأ أثناء حذف الكورس", error = ex.Message });
            }
        }
    }
}
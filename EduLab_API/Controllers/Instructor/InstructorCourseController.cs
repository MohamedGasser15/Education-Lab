using AutoMapper;
using EduLab_Application.ServiceInterfaces;
using EduLab_Shared.DTOs.Course;
using EduLab_Shared.DTOs.Lecture;
using Microsoft.AspNetCore.Mvc;

namespace EduLab_API.Controllers.Instructor
{
    [Route("api/[controller]")]
    [ApiController]
    public class InstructorCourseController : ControllerBase
    {
        private readonly ICourseService _courseService;
        private readonly IFileStorageService _fileStorageService;
        private readonly IMapper _mapper;
        private readonly ICurrentUserService _currentUserService;

        public InstructorCourseController(ICourseService courseService, IFileStorageService fileStorageService, IMapper mapper, ICurrentUserService currentUserService)
        {
            _courseService = courseService;
            _fileStorageService = fileStorageService;
            _mapper = mapper;
            _currentUserService = currentUserService;
        }

        [HttpGet("instructor-courses")]
        public async Task<IActionResult> GetInstructorCourses()
        {
            try
            {
                var instructorId = await _currentUserService.GetUserIdAsync();

                if (string.IsNullOrEmpty(instructorId))
                    return Unauthorized();

                var courses = await _courseService.GetInstructorCoursesAsync(instructorId);

                if (courses == null || !courses.Any())
                {
                    return NotFound(new { message = "No courses found for this instructor" });
                }

                return Ok(courses);
            }
            catch (Exception ex)
            {
                return StatusCode(500, new
                {
                    message = "An error occurred while retrieving instructor courses",
                    error = ex.Message
                });
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

        [RequestFormLimits(MultipartBodyLengthLimit = 4_000_000_000)]
        [RequestSizeLimit(4_000_000_000)]
        [HttpPost("instructor")]
        [Consumes("multipart/form-data")]
        public async Task<IActionResult> AddCourseAsInstructor([FromForm] CourseCreateDTO course)
        {
            if (course == null)
                return BadRequest(new { message = "البيانات ناقصة" });

            try
            {
                // جلب Id المستخدم الحالي (Instructor)
                var instructorId = await _currentUserService.GetUserIdAsync();
                if (string.IsNullOrEmpty(instructorId))
                    return Unauthorized(new { message = "المستخدم غير مسجل دخول" });

                course.ThumbnailUrl = course.ThumbnailUrl ?? "/Images/Courses/default.jpg";
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
                                lecture.VideoUrl = lecture.VideoUrl ?? "";
                                var contentType = lecture.ContentType?.Trim().ToLower();

                                if (lecture.Video != null && contentType == "video")
                                {
                                    lecture.VideoUrl = await _fileStorageService.UploadFileAsync(lecture.Video, "Videos/Courses") ?? "";
                                }
                                else
                                {
                                    lecture.VideoUrl = "";
                                }
                            }
                        }
                    }
                }

                var createdCourse = await _courseService.AddCourseAsInstructorAsync(course);

                return CreatedAtAction(nameof(GetCourseById), new { id = createdCourse.Id }, createdCourse);
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { message = "في مشكلة", error = ex.Message, innerError = ex.InnerException?.Message });
            }
        }

        [RequestFormLimits(MultipartBodyLengthLimit = 4_000_000_000)]
        [RequestSizeLimit(4_000_000_000)]
        [HttpPut("instructor/{id}")]
        [Consumes("multipart/form-data")]
        public async Task<IActionResult> UpdateCourseAsInstructor(int id, [FromForm] CourseUpdateDTO course)
        {
            if (course == null || course.Id != id)
                return BadRequest(new { message = "البيانات غير صالحة" });

            try
            {
                var existingCourse = await _courseService.GetCourseByIdAsync(id);
                if (existingCourse == null)
                    return NotFound(new { message = "الكورس غير موجود" });

                // جلب Id المستخدم الحالي (Instructor)
                var instructorId = await _currentUserService.GetUserIdAsync();
                if (string.IsNullOrEmpty(instructorId))
                    return Unauthorized(new { message = "المستخدم غير مسجل دخول" });

                // التأكد إن الـ Instructor الحالي هو صاحب الكورس
                if (existingCourse.InstructorId != instructorId)
                    return Unauthorized(new { message = "لا يمكن تعديل كورس لا يخصك" });

                string oldImageUrl = null;
                List<string> oldVideoUrls = new List<string>();

                // التعامل مع الصورة
                if (course.Image != null && course.Image.Length > 0)
                {
                    oldImageUrl = existingCourse.ThumbnailUrl;
                    var thumbnailUrl = await _fileStorageService.UploadFileAsync(course.Image, "Images/Courses");
                    course.ThumbnailUrl = thumbnailUrl;
                }
                else
                {
                    course.ThumbnailUrl = existingCourse.ThumbnailUrl;
                }

                // التعامل مع الفيديوهات
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
                                    var existingLecture = existingCourse.Sections?
                                        .SelectMany(s => s.Lectures ?? new List<LectureDTO>())
                                        .FirstOrDefault(l => l.Id == lecture.Id);

                                    if (existingLecture != null && !string.IsNullOrEmpty(existingLecture.VideoUrl))
                                    {
                                        oldVideoUrls.Add(existingLecture.VideoUrl);
                                    }

                                    lecture.VideoUrl = await _fileStorageService.UploadFileAsync(lecture.Video, "Videos/Courses") ?? lecture.VideoUrl;
                                }
                                else
                                {
                                    lecture.VideoUrl = lecture.VideoUrl ?? "";
                                }
                            }
                        }
                    }
                }

                // استدعاء الميثود المعدلة للـ Instructor
                var updatedCourse = await _courseService.UpdateCourseAsInstructorAsync(course);
                if (updatedCourse == null)
                    return NotFound(new { message = $"الكورس مش موجود بـ ID {id}" });

                // حذف الصورة القديمة بعد التأكد من نجاح التحديث
                if (!string.IsNullOrEmpty(oldImageUrl) && !oldImageUrl.Equals("/Images/Courses/default.jpg"))
                {
                    _fileStorageService.DeleteFile(oldImageUrl);
                }

                // حذف الفيديوهات القديمة التي تم استبدالها فقط
                foreach (var videoUrl in oldVideoUrls)
                {
                    _fileStorageService.DeleteVideoFileIfExists(videoUrl);
                }

                return Ok(updatedCourse);
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { message = "حدث خطأ أثناء التعديل", error = ex.Message });
            }
        }

        [HttpDelete("instructor/{id}")]
        public async Task<IActionResult> DeleteCourseAsInstructor(int id)
        {
            try
            {
                // الحصول على Id الـ Instructor الحالي
                var instructorId = await _currentUserService.GetUserIdAsync();
                if (string.IsNullOrEmpty(instructorId))
                    return Unauthorized(new { success = false, message = "المستخدم غير مسجل دخول" });

                // الحصول على الكورس للتأكد من ملكيته ومسار الصورة والفيديوهات
                var course = await _courseService.GetCourseByIdAsync(id);
                if (course == null)
                    return NotFound(new { success = false, message = $"الكورس بمعرف {id} غير موجود" });

                // التأكد أن الكورس يخص هذا الـ Instructor
                if (course.InstructorId != instructorId)
                    return Unauthorized(new { success = false, message = "لا يمكن حذف كورس لا يخصك" });

                // حذف الكورس
                var isDeleted = await _courseService.DeleteCourseAsInstructorAsync(id);
                if (!isDeleted)
                    return NotFound(new { success = false, message = $"الكورس بمعرف {id} غير موجود" });

                // حذف الصورة المرتبطة إذا لم تكن الصورة الافتراضية
                if (!string.IsNullOrEmpty(course.ThumbnailUrl) &&
                    !course.ThumbnailUrl.Equals("/Images/Courses/default.jpg"))
                {
                    _fileStorageService.DeleteFile(course.ThumbnailUrl);
                }

                // حذف الفيديوهات المرتبطة
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
                                    _fileStorageService.DeleteVideoFileIfExists(lecture.VideoUrl);
                                }
                            }
                        }
                    }
                }

                return Ok(new { success = true, message = "تم حذف الكورس بنجاح" });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { success = false, message = "حدث خطأ أثناء حذف الكورس", error = ex.Message });
            }
        }

        // في ملف EduLab_API/Controllers/Admin/CourseController.cs
        [HttpPost("instructor/BulkDelete")]
        public async Task<IActionResult> BulkDeleteAsInstructor([FromBody] List<int> ids)
        {
            if (ids == null || !ids.Any())
                return BadRequest(new { success = false, message = "لم يتم تحديد أي دورات للحذف" });

            try
            {
                var instructorId = await _currentUserService.GetUserIdAsync();
                if (string.IsNullOrEmpty(instructorId))
                    return Unauthorized(new { success = false, message = "المستخدم غير مسجل دخول" });

                // جلب الكورسات الخاصة بالـ Instructor فقط
                var coursesToDelete = new List<CourseDTO>();
                foreach (var id in ids)
                {
                    var course = await _courseService.GetCourseByIdAsync(id);
                    if (course != null && course.InstructorId == instructorId)
                        coursesToDelete.Add(course);
                }

                if (!coursesToDelete.Any())
                    return NotFound(new { success = false, message = "لا توجد كورسات تخصك للحذف" });

                // حذف الكورسات من قاعدة البيانات
                var idsToDelete = coursesToDelete.Select(c => c.Id).ToList();
                var result = await _courseService.BulkDeleteCoursesAsInstructorAsync(idsToDelete);

                if (!result)
                    return NotFound(new { success = false, message = "لم يتم العثور على الدورات المحددة" });

                // حذف الصور والفيديوهات المرتبطة
                foreach (var course in coursesToDelete)
                {
                    if (!string.IsNullOrEmpty(course.ThumbnailUrl) &&
                        !course.ThumbnailUrl.Equals("/Images/Courses/default.jpg"))
                    {
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
                                        _fileStorageService.DeleteVideoFileIfExists(lecture.VideoUrl);
                                }
                            }
                        }
                    }
                }

                return Ok(new
                {
                    success = true,
                    message = $"تم حذف {idsToDelete.Count} دورة بنجاح"
                });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new
                {
                    success = false,
                    message = "حدث خطأ أثناء حذف الدورات",
                    error = ex.Message
                });
            }
        }
    }
}

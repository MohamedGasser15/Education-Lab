using AutoMapper;
using EduLab_Application.ServiceInterfaces;
using EduLab_Domain.Entities;
using EduLab_Shared.DTOs.Course;
using EduLab_Shared.DTOs.Lecture;
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
        [RequestFormLimits(MultipartBodyLengthLimit = 4_000_000_000)]
        [RequestSizeLimit(4_000_000_000)]
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

        [RequestFormLimits(MultipartBodyLengthLimit = 4_000_000_000)]
        [RequestSizeLimit(4_000_000_000)]
        [HttpPut("{id}")]
        [Consumes("multipart/form-data")]
        public async Task<IActionResult> UpdateCourse(int id, [FromForm] CourseUpdateDTO course)
        {
            if (course == null || course.Id != id)
                return BadRequest(new { message = "البيانات غير صالحة" });

            try
            {
                var existingCourse = await _courseService.GetCourseByIdAsync(id);
                if (existingCourse == null)
                    return NotFound(new { message = "الكورس غير موجود" });

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

                // جمع الفيديوهات القديمة التي سيتم استبدالها فقط
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
                            }
                        }
                    }
                }

                var updatedCourse = await _courseService.UpdateCourseAsync(course);
                if (updatedCourse == null)
                    return NotFound(new { message = $"الكورس مش موجود بـ ID {id}" });

                // حذف الصورة القديمة بعد التأكد من نجاح التحديث
                if (!string.IsNullOrEmpty(oldImageUrl) &&
                    !oldImageUrl.Equals("/Images/Courses/default.jpg"))
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

        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteCourse(int id)
        {
            try
            {
                // الحصول على الكورس أولاً لمعرفة مسار الصورة والفيديوهات
                var course = await _courseService.GetCourseByIdAsync(id);
                if (course == null)
                {
                    return NotFound(new { success = false, message = $"الكورس بمعرف {id} غير موجود" });
                }

                // حذف الكورس من قاعدة البيانات
                var isDeleted = await _courseService.DeleteCourseAsync(id);
                if (!isDeleted)
                {
                    return NotFound(new { success = false, message = $"الكورس بمعرف {id} غير موجود" });
                }

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
        [HttpPost("BulkDelete")]
        public async Task<IActionResult> BulkDelete([FromBody] List<int> ids)
        {
            if (ids == null || !ids.Any())
            {
                return BadRequest(new { success = false, message = "لم يتم تحديد أي دورات للحذف" });
            }

            try
            {
                // الحصول على معلومات الكورسات أولاً لحذف صورها وفيديوهاتها
                var coursesToDelete = new List<CourseDTO>();
                foreach (var id in ids)
                {
                    var course = await _courseService.GetCourseByIdAsync(id);
                    if (course != null)
                    {
                        coursesToDelete.Add(course);
                    }
                }

                // حذف الكورسات من قاعدة البيانات
                var result = await _courseService.BulkDeleteCoursesAsync(ids);
                if (!result)
                {
                    return NotFound(new
                    {
                        success = false,
                        message = "لم يتم العثور على الدورات المحددة"
                    });
                }

                // حذف الصور والفيديوهات المرتبطة
                foreach (var course in coursesToDelete)
                {
                    // حذف الصورة
                    if (!string.IsNullOrEmpty(course.ThumbnailUrl) &&
                        !course.ThumbnailUrl.Equals("/Images/Courses/default.jpg"))
                    {
                        _fileStorageService.DeleteFileIfExists(course.ThumbnailUrl);
                    }

                    // حذف الفيديوهات
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
                }

                return Ok(new
                {
                    success = true,
                    message = $"تم حذف {ids.Count} دورة بنجاح"
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

        // في ملف EduLab_API/Controllers/Admin/CourseController.cs
        [HttpPost("BulkAction")]
        public async Task<IActionResult> BulkAction([FromForm] string action, [FromForm] List<int> ids)
        {
            if (ids == null || !ids.Any())
            {
                return BadRequest(new { success = false, message = "لم يتم تحديد أي دورات" });
            }

            try
            {
                bool result = false;
                string actionName = "";

                switch (action.ToLower())
                {
                    case "delete":
                        result = await _courseService.BulkDeleteCoursesAsync(ids);
                        actionName = "حذف";
                        break;
                    case "publish":
                        result = await _courseService.BulkPublishCoursesAsync(ids);
                        actionName = "نشر";
                        break;
                    case "unpublish":
                        result = await _courseService.BulkUnpublishCoursesAsync(ids);
                        actionName = "إلغاء نشر";
                        break;
                    default:
                        return BadRequest(new { success = false, message = "إجراء غير معروف" });
                }

                if (result)
                {
                    return Ok(new
                    {
                        success = true,
                        message = $"تم {actionName} {ids.Count} دورة بنجاح"
                    });
                }

                return StatusCode(500, new
                {
                    success = false,
                    message = $"حدث خطأ أثناء {actionName} الدورات"
                });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new
                {
                    success = false,
                    message = "حدث خطأ أثناء معالجة الطلب",
                    error = ex.Message
                });
            }
        }

        [HttpPost("{id}/Accept")]
        public async Task<IActionResult> AcceptCourse(int id)
        {
            try
            {
                var result = await _courseService.AcceptCourseAsync(id);
                if (!result)
                    return NotFound(new { success = false, message = $"الكورس بمعرف {id} غير موجود" });

                return Ok(new { success = true, message = "تم قبول الكورس بنجاح" });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { success = false, message = "حدث خطأ أثناء قبول الكورس", error = ex.Message });
            }
        }

        [HttpPost("{id}/Reject")]
        public async Task<IActionResult> RejectCourse(int id)
        {
            try
            {
                var result = await _courseService.RejectCourseAsync(id);
                if (!result)
                    return NotFound(new { success = false, message = $"الكورس بمعرف {id} غير موجود" });

                return Ok(new { success = true, message = "تم رفض الكورس بنجاح" });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { success = false, message = "حدث خطأ أثناء رفض الكورس", error = ex.Message });
            }
        }
        [HttpGet("approved/by-categories")]
        public async Task<IActionResult> GetApprovedCoursesByCategories([FromQuery] List<int> categoryIds, [FromQuery] int countPerCategory = 10)
        {
            try
            {
                var courses = await _courseService.GetApprovedCoursesByCategoriesAsync(categoryIds, countPerCategory);
                return Ok(courses);
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { message = "An error occurred", error = ex.Message });
            }
        }

        [HttpGet("approved/by-category/{categoryId}")]
        public async Task<IActionResult> GetApprovedCoursesByCategory(int categoryId, [FromQuery] int count = 10)
        {
            try
            {
                var courses = await _courseService.GetApprovedCoursesByCategoryAsync(categoryId, count);
                return Ok(courses);
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { message = "An error occurred", error = ex.Message });
            }
        }
    }
}
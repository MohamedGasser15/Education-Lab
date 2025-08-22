using EduLab_MVC.Filters;
using EduLab_MVC.Models.DTOs.Course;
using EduLab_MVC.Services;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using System.Text.Json;
using System.Net.Http.Headers;

namespace EduLab_MVC.Areas.Instructor.Controllers
{
    [Area("Instructor")]
    [InstructorOnly]
    public class CourseController : Controller
    {
        private readonly CourseService _courseService;
        private readonly CategoryService _categoryService;
        private readonly ILogger<CourseController> _logger;
        private readonly IHttpContextAccessor _httpContextAccessor;
        public CourseController(CourseService courseService, CategoryService categoryService, ILogger<CourseController> logger, IHttpContextAccessor httpContextAccessor)
        {
            _courseService = courseService;
            _categoryService = categoryService;
            _logger = logger;
            _httpContextAccessor = httpContextAccessor;
        }

        // GET: Index - قائمة الكورسات
        public async Task<IActionResult> Index()
        {
            try
            {
                var courses = await _courseService.GetInstructorCoursesAsync();
                var categories = await _categoryService.GetAllCategoriesAsync();

                ViewBag.Categories = categories.Select(c => new SelectListItem
                {
                    Value = c.Category_Id.ToString(),
                    Text = c.Category_Name
                }).ToList();

                if (!courses.Any())
                    TempData["Warning"] = "لا توجد دورات متاحة حالياً.";

                return View(courses);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "خطأ أثناء جلب قائمة الكورسات.");
                TempData["Error"] = "حدث خطأ أثناء تحميل الكورسات.";
                return View(new List<CourseDTO>());
            }
        }

        [HttpGet]
        public async Task<IActionResult> Details(int id)
        {
            var course = await _courseService.GetCourseByIdAsync(id);

            if (course == null)
            {
                TempData["Error"] = $"الدورة بمعرف {id} غير موجودة.";
                return Json(new { success = false, message = "الدورة غير موجودة." });
            }
            return Json(new { success = true, course });
        }

        [HttpGet]
        public async Task<IActionResult> GetCategories()
        {
            var categories = await _categoryService.GetAllCategoriesAsync();
            if (categories == null || !categories.Any())
            {
                return Json(new { success = false, message = "لا توجد تصنيفات متاحة." });
            }
            return Json(categories.Select(c => new { id = c.Category_Id, name = c.Category_Name }));
        }
        // GET: Create
        [HttpGet]
        public async Task<IActionResult> Create()
        {
            var categories = await _categoryService.GetAllCategoriesAsync();
            ViewBag.Categories = categories.Select(c => new SelectListItem
            {
                Value = c.Category_Id.ToString(),
                Text = c.Category_Name
            }).ToList();

            // جلب الـ token من الكوكي
            var token = Request.Cookies["AuthToken"];
            string instructorId = null;

            if (!string.IsNullOrEmpty(token))
            {
                // هنا محتاج تفك الـ JWT عشان تجيب الـ instructorId
                var handler = new System.IdentityModel.Tokens.Jwt.JwtSecurityTokenHandler();
                var jwtToken = handler.ReadJwtToken(token);
                instructorId = jwtToken.Claims.FirstOrDefault(c => c.Type == "sub")?.Value; // أو Type اللي بيحتوي الـ ID
            }

            ViewBag.InstructorId = instructorId;

            return View();
        }

        // POST: Create
        [RequestFormLimits(MultipartBodyLengthLimit = 4_000_000_000)]
        [RequestSizeLimit(4_000_000_000)]
        [HttpPost]
        public async Task<IActionResult> CreateCourse()
        {
            try
            {
                var courseFromForm = BuildCourseFromRequest();
                var createdCourse = await _courseService.AddCourseAsInstructorAsync(courseFromForm);

                if (createdCourse != null)
                    return Json(new { success = true, message = "تم إنشاء الدورة بنجاح!", courseId = createdCourse.Id });

                _logger.LogWarning("AddCourseAsInstructorAsync returned null.");
                return Json(new { success = false, message = "فشل إنشاء الدورة. حاول مرة أخرى." });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "خطأ أثناء إنشاء الدورة.");
                return Json(new { success = false, message = "حدث خطأ أثناء إنشاء الدورة: " + ex.Message });
            }
        }

        // GET: Edit
        [HttpGet]
        public async Task<IActionResult> Edit(int id)
        {
            var course = await _courseService.GetCourseByIdAsync(id);
            if (course == null) return NotFound();

            var categories = await _categoryService.GetAllCategoriesAsync();
            ViewBag.Categories = categories.Select(c => new SelectListItem
            {
                Value = c.Category_Id.ToString(),
                Text = c.Category_Name
            }).ToList();
            // جلب الـ token من الكوكي
            var token = Request.Cookies["AuthToken"];
            string instructorId = null;

            if (!string.IsNullOrEmpty(token))
            {
                // هنا محتاج تفك الـ JWT عشان تجيب الـ instructorId
                var handler = new System.IdentityModel.Tokens.Jwt.JwtSecurityTokenHandler();
                var jwtToken = handler.ReadJwtToken(token);
                instructorId = jwtToken.Claims.FirstOrDefault(c => c.Type == "sub")?.Value; // أو Type اللي بيحتوي الـ ID
            }

            ViewBag.InstructorId = instructorId;
            var model = new CourseUpdateDTO
            {
                Id = course.Id,
                Title = course.Title,
                ShortDescription = course.ShortDescription,
                Description = course.Description,
                Price = course.Price,
                Discount = course.Discount,
                CategoryId = course.CategoryId,
                Level = course.Level,
                Language = course.Language,
                Duration = course.Duration / 60,
                TotalLectures = course.TotalLectures,
                HasCertificate = course.HasCertificate,
                Requirements = course.Requirements,
                Learnings = course.Learnings,
                TargetAudience = course.TargetAudience,
                Sections = course.Sections
            };

            return View(model);
        }

        [RequestFormLimits(MultipartBodyLengthLimit = 4_000_000_000)]
        [RequestSizeLimit(4_000_000_000)]
        [HttpPost]
        public async Task<IActionResult> Edit()
        {
            try
            {
                var id = int.Parse(Request.Form["id"]);

                var course = new CourseUpdateDTO
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
                    Requirements = Request.Form["Requirements"].ToString()
                        .Split('\n', StringSplitOptions.RemoveEmptyEntries)
                        .Select(r => r.Trim()).ToList(),
                    Learnings = Request.Form["Learnings"].ToString()
                        .Split('\n', StringSplitOptions.RemoveEmptyEntries)
                        .Select(l => l.Trim()).ToList(),
                    TargetAudience = Request.Form["TargetAudience"],
                    InstructorId = User.Identity.Name, // دايمًا الـ instructor الحالي
                    Sections = new List<SectionDTO>()
                };

                // Thumbnail / Image
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

                // Sections + Lectures
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

                            // رفع فيديو جديد إذا موجود
                            var videoFile = Request.Form.Files[$"video_{section.Order - 1}_{lecture.Order - 1}"];
                            if (videoFile != null && videoFile.Length > 0)
                            {
                                lecture.Video = videoFile;
                                lecture.VideoUrl = null;
                            }
                            else
                            {
                                lecture.Video = null;
                                // نحتفظ بالرابط القديم لو موجود
                                lecture.VideoUrl = lecture.VideoUrl;
                            }
                        }
                    }
                    course.Sections = sections;
                }

                // تحديث الكورس باستخدام الـ service بتاعك
                var updatedCourse = await _courseService.UpdateCourseAsInstructorAsync(id, course);

                return Json(new
                {
                    success = updatedCourse != null,
                    message = updatedCourse != null ? "تم تعديل الدورة بنجاح!" : "فشل تعديل الدورة"
                });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "خطأ أثناء تعديل الدورة");
                return Json(new { success = false, message = "حدث خطأ أثناء تعديل الدورة: " + ex.Message });
            }
        }

        // POST: Delete
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Delete(int id)
        {
            try
            {
                var isDeleted = await _courseService.DeleteCourseAsInstructorAsync(id);
                return Json(new { success = isDeleted, message = isDeleted ? "تم حذف الدورة بنجاح." : $"الدورة بمعرف {id} غير موجودة." });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, $"خطأ أثناء حذف الدورة بمعرف {id}.");
                return Json(new { success = false, message = "حدث خطأ أثناء حذف الدورة: " + ex.Message });
            }
        }
        // Bulk delete courses
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> BulkDelete([FromBody] List<int> ids)
        {
            try
            {
                if (ids == null || !ids.Any())
                {
                    return Json(new { success = false, message = "لم يتم تحديد أي دورات للحذف." });
                }

                var result = await _courseService.BulkDeleteCoursesAsInstructorAsync(ids);
                if (result)
                {
                    return Json(new
                    {
                        success = true,
                        message = $"تم حذف {ids.Count} دورة بنجاح."
                    });
                }

                return Json(new
                {
                    success = false,
                    message = "حدث خطأ أثناء حذف الدورات."
                });
            }
            catch (Exception ex)
            {
                return Json(new
                {
                    success = false,
                    message = "حدث خطأ أثناء الحذف الجماعي: " + ex.Message
                });
            }
        }

        // Helper: Build Course from Request
        private CourseCreateDTO BuildCourseFromRequest(bool update = false)
        {
            var httpContext = _httpContextAccessor.HttpContext;

            // قراءة الكوكي
            var instructorIdCookie = httpContext?.Request.Cookies["InstructorId"];
            var instructorId = !string.IsNullOrEmpty(instructorIdCookie) ? instructorIdCookie : "";

            var course = new CourseCreateDTO
            {
                Title = Request.Form["Title"],
                ShortDescription = Request.Form["ShortDescription"],
                Description = Request.Form["Description"],
                Price = decimal.TryParse(Request.Form["Price"], out var p) ? p : 0,
                Discount = string.IsNullOrEmpty(Request.Form["Discount"]) ? 0 : decimal.Parse(Request.Form["Discount"]),
                CategoryId = int.TryParse(Request.Form["CategoryId"], out var cId) ? cId : 0,
                Level = Request.Form["Level"],
                Language = Request.Form["Language"],
                HasCertificate = Request.Form["certificate"] == "on",
                Requirements = Request.Form["Requirements"].ToString().Split('\n', StringSplitOptions.RemoveEmptyEntries).Select(r => r.Trim()).ToList(),
                Learnings = Request.Form["Learnings"].ToString().Split('\n', StringSplitOptions.RemoveEmptyEntries).Select(l => l.Trim()).ToList(),
                TargetAudience = Request.Form["TargetAudience"],
                InstructorId = instructorId, // جاي من الكوكي
                Sections = new List<SectionDTO>()
            };

            // Image
            var image = Request.Form.Files["Image"];
            if (image != null && image.Length > 0) course.Image = image;
            else if (!string.IsNullOrEmpty(Request.Form["ThumbnailUrl"])) course.ThumbnailUrl = Request.Form["ThumbnailUrl"];

            // Sections + Lectures
            var sectionsData = Request.Form["sections"];
            if (!string.IsNullOrEmpty(sectionsData))
            {
                var sections = JsonSerializer.Deserialize<List<SectionDTO>>(sectionsData);
                if (sections != null)
                {
                    int sOrder = 1;
                    foreach (var section in sections)
                    {
                        section.Order = sOrder++;
                        int lOrder = 1;
                        foreach (var lecture in section.Lectures)
                        {
                            lecture.Order = lOrder++;
                            lecture.ContentType ??= "video";

                            // رفع فيديو
                            var videoFile = Request.Form.Files[$"video_{section.Order - 1}_{lecture.Order - 1}"];
                            if (videoFile != null && videoFile.Length > 0) lecture.Video = videoFile;
                        }
                    }
                    course.Sections = sections;
                }
            }

            return course;
        }
    }
}

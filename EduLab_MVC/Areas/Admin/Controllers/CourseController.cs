﻿using EduLab_MVC.Filters;
using EduLab_MVC.Models.DTOs.Course;
using EduLab_MVC.Services;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using System.Text.Json;

namespace EduLab_MVC.Areas.Admin.Controllers
{
    [AdminOnly]
    [Area("Admin")]
    public class CourseController : Controller
    {
        private readonly CourseService _courseService;
        private readonly CategoryService _categoryService;
        private readonly UserService _userService;

        private readonly ILogger<CourseController> _logger;
        private readonly IWebHostEnvironment _webHostEnvironment;

        public CourseController(CourseService courseService, ILogger<CourseController> logger, IWebHostEnvironment webHostEnvironment, CategoryService categoryService , UserService userService)
        {
            _courseService = courseService;
            _categoryService = categoryService;
            _userService = userService;
            _logger = logger;
            _webHostEnvironment = webHostEnvironment;
        }

        public async Task<IActionResult> Index()
        {
            var courses = await _courseService.GetAllCoursesAsync();
            if (courses == null || !courses.Any())
            {
                TempData["Warning"] = "لا توجد دورات متاحة حاليًا.";
            }
            return View(courses);
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
            return Json(course);
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

        [HttpGet]
        public async Task<IActionResult> GetInstructors()
        {
            try
            {
                var instructors = await _userService.GetInstructorsAsync();
                if (instructors == null || !instructors.Any())
                {
                    return Json(new { success = false, message = "لا يوجد مدربين متاحين" });
                }

                return Json(instructors.Select(i => new {
                    id = i.Id,
                    name = i.FullName
                }));
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error while fetching instructors");
                return Json(new { success = false, message = "حدث خطأ أثناء جلب المدربين" });
            }
        }

        [HttpGet]
        public async Task<IActionResult> Create()
        {
            var categories = await _categoryService.GetAllCategoriesAsync();
            ViewBag.Categories = categories.Select(c => new SelectListItem
            {
                Value = c.Category_Id.ToString(),
                Text = c.Category_Name
            }).ToList();

            var instructors = await _userService.GetInstructorsAsync();
            ViewBag.Instructors = instructors.Select(i => new SelectListItem
            {
                Value = i.Id,
                Text = i.FullName
            }).ToList();

            return View();
        }


        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> CreateCourse()
        {
            try
            {
                // التحقق من الحقول المطلوبة
                if (string.IsNullOrEmpty(Request.Form["title"]))
                    return Json(new { success = false, message = "عنوان الدورة مطلوب" });

                if (!int.TryParse(Request.Form["CategoryId"], out int categoryId))
                    return Json(new { success = false, message = "يجب اختيار تصنيف صحيح" });

                if (!decimal.TryParse(Request.Form["price"], out decimal price))
                    return Json(new { success = false, message = "يجب إدخال سعر صحيح" });

                // إنشاء الكائن
                var courseFromForm = new CourseCreateDTO
                {
                    Title = Request.Form["title"],
                    ShortDescription = Request.Form["shortDescription"],
                    Description = Request.Form["description"],
                    Price = price,
                    Discount = string.IsNullOrEmpty(Request.Form["discount"]) ? 0 : decimal.Parse(Request.Form["discount"]),
                    CategoryId = categoryId,
                    Level = Request.Form["level"],
                    Language = Request.Form["language"],
                    HasCertificate = Request.Form["certificate"] == "on",
                    Requirements = Request.Form["requirements"].ToString()
                        .Split('\n', StringSplitOptions.RemoveEmptyEntries)
                        .Select(r => r.Trim()).ToList(),
                    Learnings = Request.Form["learnings"].ToString()
                        .Split('\n', StringSplitOptions.RemoveEmptyEntries)
                        .Select(l => l.Trim()).ToList(),
                    TargetAudience = Request.Form["targetAudience"],
                    InstructorId = Request.Form["InstructorId"],
                    Sections = new List<SectionDTO>()
                };

                // رفع الصورة
                var thumbnail = Request.Form.Files["image"];
                if (thumbnail != null && thumbnail.Length > 0)
                    courseFromForm.Image = thumbnail;

                // تحليل السكاشن
                var sectionsData = Request.Form["sections"];
                if (!string.IsNullOrEmpty(sectionsData))
                {
                    try
                    {
                        var sections = JsonSerializer.Deserialize<List<SectionDTO>>(sectionsData);

                        if (sections == null || sections.Count == 0)
                        {
                            return Json(new { success = false, message = "يجب إضافة قسم واحد على الأقل" });
                        }

                        int sectionOrder = 1;
                        foreach (var section in sections)
                        {
                            if (string.IsNullOrWhiteSpace(section.Title))
                                return Json(new { success = false, message = "عنوان القسم مطلوب" });

                            section.Order = sectionOrder++;

                            if (section.Lectures == null || section.Lectures.Count == 0)
                                return Json(new { success = false, message = $"القسم '{section.Title}' يجب أن يحتوي على محاضرة واحدة على الأقل" });

                            int lectureOrder = 1;
                            foreach (var lecture in section.Lectures)
                            {
                                if (string.IsNullOrWhiteSpace(lecture.Title))
                                    return Json(new { success = false, message = "عنوان المحاضرة مطلوب" });

                                lecture.Order = lectureOrder++;
                                lecture.ContentType ??= "video";
                            }
                        }

                        courseFromForm.Sections = sections;
                    }
                    catch (JsonException ex)
                    {
                        _logger.LogWarning(ex, "فشل في تحليل JSON الخاص بالسكاشن");
                        return Json(new { success = false, message = "السكاشن غير صالحة. تأكد من البيانات." });
                    }
                }
                else
                {
                    return Json(new { success = false, message = "يجب إضافة قسم واحد على الأقل" });
                }

                // إرسال إلى الخدمة
                var createdCourse = await _courseService.AddCourseAsync(courseFromForm);
                if (createdCourse != null)
                {
                    return Json(new
                    {
                        success = true,
                        message = "تم إنشاء الدورة بنجاح!",
                        courseId = createdCourse.Id
                    });
                }

                _logger.LogWarning("AddCourseAsync رجع null - فشل إنشاء الدورة.");
                return Json(new { success = false, message = "فشل إنشاء الدورة. حاول مرة أخرى." });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "خطأ أثناء إنشاء الدورة.");
                return Json(new
                {
                    success = false,
                    message = "حدث خطأ أثناء إنشاء الدورة: " + ex.Message
                });
            }
        }


        [HttpGet]
        public async Task<IActionResult> Edit(int id)
        {
            var course = await _courseService.GetCourseByIdAsync(id);
            if (course == null)
            {
                return Json(new { success = false, message = $"الدورة بمعرف {id} غير موجودة." });
            }

            var courseEditDTO = new
            {
                id = course.Id,
                title = course.Title,
                shortDescription = course.ShortDescription,
                description = course.Description,
                price = course.Price,
                discount = course.Discount,
                thumbnailUrl = course.ThumbnailUrl,
                categoryId = course.CategoryId,
                level = course.Level,
                language = course.Language,
                duration = course.Duration / 60, // Convert minutes to hours
                lectures = course.TotalLectures,
                hasCertificate = course.HasCertificate,
                requirements = course.Requirements,
                learnings = course.Learnings,
                targetAudience = course.TargetAudience,
                sections = course.Sections
            };

            return Json(new { success = true, course = courseEditDTO });
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit()
        {
            try
            {
                var id = int.Parse(Request.Form["id"]);
                var course = new CourseUpdateDTO
                {
                    Id = id,
                    Title = Request.Form["title"],
                    ShortDescription = Request.Form["shortDescription"],
                    Description = Request.Form["description"],
                    Price = decimal.Parse(Request.Form["price"]),
                    Discount = string.IsNullOrEmpty(Request.Form["discount"]) ? null : decimal.Parse(Request.Form["discount"]),
                    CategoryId = int.Parse(Request.Form["category"]),
                    Level = Request.Form["level"],
                    Language = Request.Form["language"],
                    Duration = int.Parse(Request.Form["duration"]) * 60, // Convert hours to minutes
                    TotalLectures = int.Parse(Request.Form["lectures"]),
                    HasCertificate = Request.Form["certificate"] == "on",
                    Requirements = Request.Form["requirements"].ToString()
                        .Split('\n', StringSplitOptions.RemoveEmptyEntries)
                        .Select(r => r.Trim())
                        .ToList(),
                    Learnings = Request.Form["learnings"].ToString()
                        .Split('\n', StringSplitOptions.RemoveEmptyEntries)
                        .Select(l => l.Trim())
                        .ToList(),
                    TargetAudience = Request.Form["targetAudience"],
                    InstructorId = "admin", // Default instructor ID for admin
                    Sections = new List<SectionDTO>()
                };

                // Handle thumbnail upload
                var thumbnail = Request.Form.Files["image"];
                if (thumbnail != null && thumbnail.Length > 0)
                {
                    course.Image = thumbnail;
                }

                // Handle sections and lectures
                var sectionsData = Request.Form["sections"];
                if (!string.IsNullOrEmpty(sectionsData))
                {
                    try
                    {
                        var sections = JsonSerializer.Deserialize<List<SectionDTO>>(sectionsData);
                        int sectionOrder = 1;

                        foreach (var section in sections)
                        {
                            section.Order = sectionOrder++;
                            int lectureOrder = 1;

                            foreach (var lecture in section.Lectures)
                            {
                                lecture.Order = lectureOrder++;
                                lecture.ContentType = lecture.ContentType ?? "video";
                            }
                        }

                        course.Sections = sections;
                    }
                    catch (JsonException ex)
                    {
                        _logger.LogWarning(ex, "Failed to parse sections JSON");
                        course.Sections = new List<SectionDTO>();
                    }
                }

                var updatedCourse = await _courseService.UpdateCourseAsync(id, course);
                if (updatedCourse != null)
                {
                    return Json(new { success = true, message = "تم تعديل الدورة بنجاح!" });
                }
                else
                {
                    return Json(new { success = false, message = "فشل تعديل الدورة. حاول مرة أخرى." });
                }
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, $"خطأ أثناء تعديل الدورة بمعرف {Request.Form["id"]}.");
                return Json(new { success = false, message = "حدث خطأ أثناء تعديل الدورة: " + ex.Message });
            }
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Delete(int id)
        {
            try
            {
                var isDeleted = await _courseService.DeleteCourseAsync(id);
                if (isDeleted)
                {
                    return Json(new { success = true, message = "تم حذف الدورة بنجاح." });
                }
                else
                {
                    return Json(new { success = false, message = $"الدورة بمعرف {id} غير موجودة." });
                }
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

                var deletedCount = 0;
                foreach (var id in ids)
                {
                    var isDeleted = await _courseService.DeleteCourseAsync(id);
                    if (isDeleted)
                    {
                        deletedCount++;
                    }
                }

                return Json(new { 
                    success = true, 
                    message = $"تم حذف {deletedCount} من {ids.Count} دورة بنجاح." 
                });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "خطأ أثناء الحذف الجماعي للدورات.");
                return Json(new { success = false, message = "حدث خطأ أثناء الحذف الجماعي: " + ex.Message });
            }
        }

        // Bulk actions
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> BulkAction([FromBody] BulkActionRequest request)
        {
            try
            {
                if (request.Ids == null || !request.Ids.Any())
                {
                    return Json(new { success = false, message = "لم يتم تحديد أي دورات." });
                }

                var successCount = 0;
                foreach (var id in request.Ids)
                {
                    var course = await _courseService.GetCourseByIdAsync(id);
                    if (course != null)
                    {
                        var updateCourse = new CourseUpdateDTO
                        {
                            Id = course.Id,
                            Title = course.Title,
                            ShortDescription = course.ShortDescription,
                            Description = course.Description,
                            Price = course.Price,
                            Discount = course.Discount,
                            ThumbnailUrl = course.ThumbnailUrl,
                            CategoryId = course.CategoryId,
                            Level = course.Level,
                            Language = course.Language,
                            Duration = course.Duration,
                            TotalLectures = course.TotalLectures,
                            HasCertificate = course.HasCertificate,
                            Requirements = course.Requirements,
                            Learnings = course.Learnings,
                            TargetAudience = course.TargetAudience,
                            InstructorId = course.InstructorId,
                            Sections = course.Sections
                        };

                        // Apply action
                        switch (request.Action.ToLower())
                        {
                            case "publish":
                                // Add publish logic here
                                break;
                            case "unpublish":
                                // Add unpublish logic here
                                break;
                        }

                        var updated = await _courseService.UpdateCourseAsync(id, updateCourse);
                        if (updated != null)
                        {
                            successCount++;
                        }
                    }
                }

                return Json(new { 
                    success = true, 
                    message = $"تم تطبيق الإجراء على {successCount} من {request.Ids.Count} دورة بنجاح." 
                });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "خطأ أثناء تطبيق الإجراء الجماعي.");
                return Json(new { success = false, message = "حدث خطأ أثناء تطبيق الإجراء الجماعي: " + ex.Message });
            }
        }

        public async Task<IActionResult> CoursesByInstructor(string instructorId)
        {
            var courses = await _courseService.GetCoursesByInstructorAsync(instructorId);
            if (courses == null || !courses.Any())
            {
                TempData["Warning"] = "لا توجد دورات لهذا المدرب.";
            }
            return View("Index", courses);
        }

        public async Task<IActionResult> CoursesByCategory(int categoryId)
        {
            var courses = await _courseService.GetCoursesWithCategoryAsync(categoryId);
            if (courses == null || !courses.Any())
            {
                TempData["Warning"] = "لا توجد دورات في هذا التصنيف.";
            }
            return View("Index", courses); 
        }
    }
}

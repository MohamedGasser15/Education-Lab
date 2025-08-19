using EduLab_MVC.Models.DTOs.Course;
using EduLab_MVC.Services;
using Microsoft.AspNetCore.Mvc;
using System.Threading.Tasks;

namespace EduLab_MVC.Areas.Learner.Controllers
{
    [Area("Learner")]
    public class CourseController : Controller
    {
        private readonly CourseService _courseService;
        private readonly CategoryService _categoryService;

        public CourseController(CourseService courseService, CategoryService categoryService)
        {
            _courseService = courseService;
            _categoryService = categoryService;
        }

        public async Task<IActionResult> Index()
        {
            var categories = await _categoryService.GetAllCategoriesAsync();
            ViewBag.Categories = categories;

            var categoryIds = categories.Select(c => c.Category_Id).ToList();
            var allCourses = await _courseService.GetApprovedCoursesByCategoriesAsync(categoryIds, int.MaxValue);

            return View(allCourses);
        }

        public async Task<IActionResult> ByCategory(int id)
        {
            var categories = await _categoryService.GetAllCategoriesAsync();
            ViewBag.Categories = categories;
            ViewBag.CategoryId = id;

            var courses = await _courseService.GetApprovedCoursesByCategoryAsync(id, int.MaxValue);

            return View("Index", courses);
        }
        public async Task<IActionResult> Details(int id)
        {
            var course = await _courseService.GetCourseByIdAsync(id);
            if (course == null)
            {
                return NotFound();
            }

            // جلب دورات المدرب الأخرى
            var instructorCourses = await _courseService.GetCoursesByInstructorAsync(course.InstructorId);
            var similarCourses = await _courseService.GetApprovedCoursesByCategoryAsync(course.CategoryId, 4);

            // تصحيح مسار الصور وإضافة البيانات المطلوبة
            foreach (var c in instructorCourses)
            {
                if (!string.IsNullOrEmpty(c.ThumbnailUrl) && !c.ThumbnailUrl.StartsWith("http"))
                {
                    c.ThumbnailUrl = $"https://localhost:7292{c.ThumbnailUrl}";
                }

                if (string.IsNullOrEmpty(c.InstructorName))
                {
                    c.InstructorName = course.InstructorName; // استخدام اسم المدرب من الكورس الحالي إذا لم يكن موجوداً
                }
            }
            // جلب دورات مشابهة
            ViewBag.SimilarCourses = similarCourses.Where(c => c.Id != id).Take(3).ToList();

            ViewBag.InstructorCourses = instructorCourses.Where(c => c.Id != id).Take(10).ToList();

            return View(course);
        }

    }
}
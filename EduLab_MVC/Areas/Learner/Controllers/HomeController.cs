using EduLab_MVC.Services;
using Microsoft.AspNetCore.Mvc;

namespace EduLab_MVC.Areas.Learner.Controllers
{
    [Area("Learner")]
    public class HomeController : Controller
    {
        private readonly CourseService _courseService;
        public HomeController(CourseService courseService)
        {
            _courseService = courseService;
        }
        public IActionResult Index()
        {
            return View();
        }
        public async Task<IActionResult> Courses()
        {
            var courses = await _courseService.GetAllCoursesAsync();
            if (courses == null || !courses.Any())
            {
                TempData["Warning"] = "لا توجد دورات متاحة حاليًا.";
            }
            return View(courses);
        }
        public IActionResult CourseDetails()
        {
            return View();
        }
        public IActionResult instructors()
        {
            return View();
        }
        public IActionResult Cart()
        {
            return View();
        }
        public IActionResult Checkout()
        {
            return View();
        }
        public IActionResult Profile()
        {
            return View();
        }
        public IActionResult MyCourses()
        {
            return View();
        }
        public IActionResult Settings()
        {
            return View();
        }
        public IActionResult blog()
        {
            return View();
        }
        public IActionResult about()
        {
            return View();
        }
        public IActionResult wishlist()
        {
            return View();
        }
        public IActionResult Notification()
        {
            return View();
        }
        public IActionResult faq()
        {
            return View();
        }
        public IActionResult contact()
        {
            return View();
        }
        public IActionResult Privacy()
        {
            return View();
        }
        public IActionResult terms()
        {
            return View();
        }
        public IActionResult help()
        {
            return View();
        }
        [Route("AccessDenied")]
        public IActionResult AccessDenied()
        {
            return View();
        }
    }
}

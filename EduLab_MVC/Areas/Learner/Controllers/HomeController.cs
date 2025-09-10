using EduLab_MVC.Services.ServiceInterfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace EduLab_MVC.Areas.Learner.Controllers
{
    [Area("Learner")]
    [AllowAnonymous]
    public class HomeController : Controller
    {
        private readonly ICourseService _courseService;
        public HomeController(ICourseService courseService)
        {
            _courseService = courseService;
        }
        public async Task<IActionResult> Index()
        {
            var allCourses = await _courseService.GetAllCoursesAsync();

            var approvedCourses = allCourses
                                    .Where(c => c.Status?.ToLower() == "approved" || c.Status == "Approved")
                                    .Take(10)
                                    .ToList();

            return View(approvedCourses);
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
    }
}

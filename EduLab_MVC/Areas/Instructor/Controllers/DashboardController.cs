using EduLab_MVC.Filters;
using Microsoft.AspNetCore.Mvc;

namespace EduLab_MVC.Areas.Instructor.Controllers
{
    [Area("Instructor")]
    [InstructorOnly]
    public class DashboardController : Controller
    {
        public IActionResult Index()
        {
            return View();
        }
        public IActionResult create()
        {
            return View();
        }
        public IActionResult Course ()
        {
            return View();
        }
        public IActionResult revenue()
        {
            return View();
        }
        public IActionResult messages()
        {
            return View();
        }
        public IActionResult reviews()
        {
            return View();
        }
        public IActionResult profile()
        {
            return View();
        }
        public IActionResult settings()
        {
            return View();
        }
    }
}

using Microsoft.AspNetCore.Mvc;

namespace EduLab_MVC.Areas.Learner.Controllers
{
    public class HomeController : Controller
    {
        public IActionResult Index()
        {
            return View();
        }
    }
}

using Microsoft.AspNetCore.Mvc;

namespace EduLab_MVC.Areas.Admin.Controllers
{
    public class UserController : Controller
    {
        public IActionResult Index()
        {
            return View();
        }

    }
}

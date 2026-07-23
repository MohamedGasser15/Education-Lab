using EduLab_MVC.Common;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace EduLab_MVC.Areas.Instructor.Controllers
{
    [Area("Instructor")]
    [Authorize(Roles = SD.Instructor)]
    public class RevenueController : Controller
    {
        public IActionResult Index()
        {
            return View();
        }
    }
}

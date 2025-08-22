using Microsoft.AspNetCore.Mvc;

namespace EduLab_MVC.Areas.Learner.Controllers
{
    [Area("Learner")]
    public class ErrorController : Controller
    {
        [Route("Error/400")]
        public IActionResult Error400()
        {
            return View();
        }

        [Route("Error/401")]
        public IActionResult Error401()
        {
            return View();
        }

        [Route("Error/402")]
        public IActionResult Error402()
        {
            return View();
        }

        [Route("Error/403")]
        public IActionResult Error403()
        {
            return View();
        }

        [Route("Error/404")]
        public IActionResult Error404()
        {
            return View();
        }

        [Route("Error/408")]
        public IActionResult Error408()
        {
            return View();
        }

        [Route("Error/429")]
        public IActionResult Error429()
        {
            return View();
        }

        [Route("Error/500")]
        public IActionResult Error500()
        {
            return View();
        }

        [Route("Error/502")]
        public IActionResult Error502()
        {
            return View();
        }

        [Route("Error/503")]
        public IActionResult Error503()
        {
            return View();
        }

        [Route("Error/504")]
        public IActionResult Error504()
        {
            return View();
        }
    }
}

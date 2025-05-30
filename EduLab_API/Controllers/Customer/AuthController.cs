using Microsoft.AspNetCore.Mvc;

namespace EduLab_API.Controllers.Customer
{
    [Route("api/[Controller]")]
    [ApiController]
    public class AuthController : Controller
    {
        public IActionResult Index()
        {
            return View();
        }
    }
}

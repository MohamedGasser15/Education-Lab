using EduLab_MVC.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace EduLab_MVC.Areas.Learner.Controllers
{
    [Area("Learner")]
    [AllowAnonymous]
    public class InstructorsController : Controller
    {
        private readonly InstructorService _instructorService;

        public InstructorsController(InstructorService instructorService)
        {
            _instructorService = instructorService;
        }

        public async Task<IActionResult> Index()
        {
            var instructors = await _instructorService.GetAllInstructorsAsync();
            return View(instructors);
        }

        public async Task<IActionResult> Details(string id)
        {
            var instructor = await _instructorService.GetInstructorByIdAsync(id);
            if (instructor == null)
                return NotFound();

            return View(instructor);
        }

        public async Task<IActionResult> Top(int count = 4)
        {
            var instructors = await _instructorService.GetTopInstructorsAsync(count);
            return View(instructors);
        }
    }
}

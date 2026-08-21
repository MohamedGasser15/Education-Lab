using EduLab_MVC.Common;
using EduLab_MVC.Models.DTOs.Instructor;
using EduLab_MVC.Services.ServiceInterfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace EduLab_MVC.Areas.Instructor.Controllers
{
    [Area("Instructor")]
    [Authorize(Roles = SD.Instructor)]
    /// <summary>
    /// Manages reviews for the instructor's courses.
    /// </summary>
    public class ReviewsController : Controller
    {
        private readonly IInstructorService _instructorService;
        private readonly ILogger<ReviewsController> _logger;

        public ReviewsController(IInstructorService instructorService, ILogger<ReviewsController> logger)
        {
            _instructorService = instructorService;
            _logger = logger;
        }

        public async Task<IActionResult> Index()
        {
            try
            {
                var model = await _instructorService.GetInstructorRatingsAsync();
                return View(model);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error loading reviews page");
                return View(new InstructorRatingsDTO());
            }
        }
    }
}

using EduLab_MVC.Filters;
using EduLab_MVC.Services;
using Microsoft.AspNetCore.Mvc;

namespace EduLab_MVC.Areas.Instructor.Controllers
{ 
    [Area("Instructor")]
    [InstructorOnly]
    public class HistoryController : Controller
    {
        private readonly HistoryService _historyService;

        public HistoryController(HistoryService historyService)
        {
            _historyService = historyService;
        }

        // GET: /History
        public async Task<IActionResult> Index()
        {
            var logs = await _historyService.GetMyHistoryAsync();
            return View(logs); // هنحتاج نعمل View باسم Index.cshtml
        }
    }
}

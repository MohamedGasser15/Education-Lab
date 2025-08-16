using EduLab_MVC.Filters;
using EduLab_MVC.Services;
using Microsoft.AspNetCore.Mvc;

namespace EduLab_MVC.Areas.Admin.Controllers
{
    [AdminOnly]
    [Area("Admin")]
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
            var logs = await _historyService.GetAllHistoryAsync();
            return View(logs); // هنحتاج نعمل View باسم Index.cshtml
        }

        // GET: /History/User/5
        public async Task<IActionResult> ByUser(string userId)
        {
            if (string.IsNullOrEmpty(userId))
                return BadRequest("UserId is required");

            var logs = await _historyService.GetHistoryByUserAsync(userId);
            return View("Index", logs); 
        }
    }
}

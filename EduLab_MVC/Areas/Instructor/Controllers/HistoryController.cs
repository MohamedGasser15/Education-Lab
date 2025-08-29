using EduLab_MVC.Services;
using EduLab_Shared.Utitlites;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace EduLab_MVC.Areas.Instructor.Controllers
{ 
    [Area("Instructor")]
    [Authorize(Roles = SD.Instructor)]
    public class HistoryController : Controller
    {
        private readonly HistoryService _historyService;

        public HistoryController(HistoryService historyService)
        {
            _historyService = historyService;
        }

        public async Task<IActionResult> Index()
        {
            var logs = await _historyService.GetMyHistoryAsync();
            return View(logs);
        }
    }
}

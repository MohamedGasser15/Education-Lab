using EduLab_MVC.Common;
using EduLab_MVC.Services.ServiceInterfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Threading.Tasks;

namespace EduLab_MVC.Areas.Instructor.Controllers
{
    [Area("Instructor")]
    [Authorize(Roles = SD.Instructor)]
    public class RevenueController : Controller
    {
        private readonly IDashboardService _dashboardService;

        public RevenueController(IDashboardService dashboardService)
        {
            _dashboardService = dashboardService;
        }

        public async Task<IActionResult> Index(string period = "month")
        {
            var revenue = await _dashboardService.GetInstructorRevenueAsync(period);
            ViewBag.SelectedPeriod = period ?? "month";
            return View(revenue);
        }
    }
}

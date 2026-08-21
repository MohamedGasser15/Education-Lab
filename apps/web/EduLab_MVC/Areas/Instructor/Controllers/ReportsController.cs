using EduLab_MVC.Common;
using EduLab_MVC.Services.ServiceInterfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Threading.Tasks;

namespace EduLab_MVC.Areas.Instructor.Controllers
{
    [Area("Instructor")]
    [Authorize(Roles = SD.Instructor)]
    /// <summary>
    /// Shows reports related to the instructor's content.
    /// </summary>
    public class ReportsController : Controller
    {
        private readonly IDashboardService _dashboardService;

        public ReportsController(IDashboardService dashboardService)
        {
            _dashboardService = dashboardService;
        }

        public async Task<IActionResult> Index(string period = "month")
        {
            var dashboard = await _dashboardService.GetInstructorDashboardAsync();
            var revenue = await _dashboardService.GetInstructorRevenueAsync(period);

            ViewBag.Dashboard = dashboard;
            ViewBag.Revenue = revenue;
            ViewBag.SelectedPeriod = string.IsNullOrWhiteSpace(period) ? "month" : period;

            return View();
        }
    }
}

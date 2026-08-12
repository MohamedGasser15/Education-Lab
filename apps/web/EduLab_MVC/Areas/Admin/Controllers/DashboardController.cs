using EduLab_MVC.Common;
using EduLab_MVC.Services.ServiceInterfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Threading.Tasks;

namespace EduLab_MVC.Areas.Admin.Controllers
{
    [Area("Admin")]
    [Authorize(Policy = "AdminArea")]
    public class DashboardController : Controller
    {
        private readonly IDashboardService _dashboardService;

        public DashboardController(IDashboardService dashboardService)
        {
            _dashboardService = dashboardService;
        }

        public async Task<IActionResult> Index()
        {
            var dashboard = await _dashboardService.GetAdminDashboardAsync();
            return View(dashboard);
        }
    }
}

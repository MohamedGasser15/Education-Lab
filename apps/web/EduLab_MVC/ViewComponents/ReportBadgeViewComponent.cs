using EduLab_MVC.Services.ServiceInterfaces;
using Microsoft.AspNetCore.Mvc;

namespace EduLab_MVC.ViewComponents
{
    public class ReportBadgeViewComponent : ViewComponent
    {
        private readonly IReportService _reportService;

        public ReportBadgeViewComponent(IReportService reportService)
        {
            _reportService = reportService;
        }

        public async Task<IViewComponentResult> InvokeAsync()
        {
            try
            {
                var count = await _reportService.GetPendingCountAsync();
                return View(count);
            }
            catch (Exception)
            {
                return View(0);
            }
        }
    }
}

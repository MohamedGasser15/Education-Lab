using EduLab_MVC.Services.ServiceInterfaces;
using Microsoft.AspNetCore.Mvc;

namespace EduLab_MVC.ViewComponents
{
    /// <summary>
    /// Renders the pending report count badge used in the admin navigation.
    /// </summary>
    public class ReportBadgeViewComponent : ViewComponent
    {
        private readonly IReportService _reportService;

        /// <summary>
        /// Initializes a new instance of the <see cref="ReportBadgeViewComponent"/> class.
        /// </summary>
        /// <param name="reportService">The report service.</param>
        public ReportBadgeViewComponent(IReportService reportService)
        {
            _reportService = reportService;
        }

        /// <summary>
        /// Loads the pending report count for the badge view.
        /// </summary>
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

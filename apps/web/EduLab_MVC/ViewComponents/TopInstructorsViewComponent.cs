using EduLab_MVC.Services.ServiceInterfaces;
using Microsoft.AspNetCore.Mvc;

namespace EduLab_MVC.ViewComponents
{
    /// <summary>
    /// Renders the top-rated instructors section.
    /// </summary>
    public class TopInstructorsViewComponent : ViewComponent
    {
        private readonly IInstructorService _instructorService;

        /// <summary>
        /// Initializes a new instance of the <see cref="TopInstructorsViewComponent"/> class.
        /// </summary>
        /// <param name="instructorService">The instructor service.</param>
        public TopInstructorsViewComponent(IInstructorService instructorService)
        {
            _instructorService = instructorService;
        }

        /// <summary>
        /// Loads the top instructors for the view.
        /// </summary>
        public async Task<IViewComponentResult> InvokeAsync(int count = 4)
        {
            var instructors = await _instructorService.GetTopInstructorsAsync(count);
            return View(instructors);
        }
    }
}

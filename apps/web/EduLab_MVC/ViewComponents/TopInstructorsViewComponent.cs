using EduLab_MVC.Services.ServiceInterfaces;
using Microsoft.AspNetCore.Mvc;

namespace EduLab_MVC.ViewComponents
{
    public class TopInstructorsViewComponent : ViewComponent
    {
        private readonly IInstructorService _instructorService;

        public TopInstructorsViewComponent(IInstructorService instructorService)
        {
            _instructorService = instructorService;
        }

        public async Task<IViewComponentResult> InvokeAsync(int count = 4)
        {
            var instructors = await _instructorService.GetTopInstructorsAsync(count);
            return View(instructors);
        }
    }
}

// EduLab_MVC/ViewComponents/NewCoursesViewComponent.cs
using EduLab_MVC.Models.DTOs.Course;
using EduLab_MVC.Models.ViewModels;
using EduLab_MVC.Services.ServiceInterfaces;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;

namespace EduLab_MVC.ViewComponents
{
    public class NewCoursesViewComponent : ViewComponent
    {
        private readonly ICourseService _courseService;
        private readonly ILogger<NewCoursesViewComponent> _logger;

        public NewCoursesViewComponent(
            ICourseService courseService,
            ILogger<NewCoursesViewComponent> logger)
        {
            _courseService = courseService;
            _logger = logger;
        }

        public async Task<IViewComponentResult> InvokeAsync(int count = 8)
        {
            try
            {
                _logger.LogInformation("Loading new courses with count: {Count}", count);

                var allCourses = await _courseService.GetAllCoursesAsync();

                var newCourses = allCourses
                    .Where(c => c.Status == "Approved")
                    .OrderByDescending(c => c.CreatedAt)
                    .Take(count)
                    .ToList();

                var viewModel = new NewCoursesViewModel
                {
                    Courses = newCourses,
                    Count = count,
                    IsFeatured = false,
                    IsNew = true
                };

                _logger.LogInformation("Loaded {CourseCount} new courses", newCourses.Count);

                return View(viewModel);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error loading new courses");
                return View(new NewCoursesViewModel { Courses = new List<CourseDTO>() });
            }
        }
    }
}
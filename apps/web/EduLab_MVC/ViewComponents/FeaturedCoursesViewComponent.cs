// EduLab_MVC/ViewComponents/FeaturedCoursesViewComponent.cs
using EduLab_MVC.Models.DTOs.Course;
using EduLab_MVC.Models.ViewModels;
using EduLab_MVC.Services.ServiceInterfaces;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;

namespace EduLab_MVC.ViewComponents
{
    public class FeaturedCoursesViewComponent : ViewComponent
    {
        private readonly ICourseService _courseService;
        private readonly ILogger<FeaturedCoursesViewComponent> _logger;

        public FeaturedCoursesViewComponent(
            ICourseService courseService,
            ILogger<FeaturedCoursesViewComponent> logger)
        {
            _courseService = courseService;
            _logger = logger;
        }

        public async Task<IViewComponentResult> InvokeAsync(int count = 8)
        {
            try
            {
                _logger.LogInformation("Loading featured courses with count: {Count}", count);

                var allCourses = await _courseService.GetAllCoursesAsync();

                var featuredCourses = allCourses
                    .Where(c => c.Status == "Approved" && c.AverageRating > 0)
                    .OrderByDescending(c => c.AverageRating)
                    .ThenByDescending(c => c.TotalRatings)
                    .Take(count)
                    .ToList();

                var viewModel = new FeaturedCoursesViewModel
                {
                    Courses = featuredCourses,
                    Count = count,
                    IsFeatured = true,
                    IsNew = false
                };

                _logger.LogInformation("Loaded {CourseCount} featured courses", featuredCourses.Count);

                return View(viewModel);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error loading featured courses");
                return View(new FeaturedCoursesViewModel { Courses = new List<CourseDTO>() });
            }
        }
    }
}
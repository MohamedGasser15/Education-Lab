// EduLab_MVC/ViewComponents/FeaturedCoursesViewComponent.cs
using EduLab_MVC.Common;
using EduLab_MVC.Models.DTOs.Course;
using EduLab_MVC.Models.ViewModels;
using EduLab_MVC.Services.ServiceInterfaces;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;

namespace EduLab_MVC.ViewComponents
{
    /// <summary>
    /// Renders a list of top-rated approved courses as featured courses.
    /// </summary>
    public class FeaturedCoursesViewComponent : ViewComponent
    {
        private readonly ICourseService _courseService;
        private readonly ILogger<FeaturedCoursesViewComponent> _logger;

        /// <summary>
        /// Initializes a new instance of the <see cref="FeaturedCoursesViewComponent"/> class.
        /// </summary>
        /// <param name="courseService">The course service.</param>
        /// <param name="logger">The logger instance.</param>
        public FeaturedCoursesViewComponent(
            ICourseService courseService,
            ILogger<FeaturedCoursesViewComponent> logger)
        {
            _courseService = courseService;
            _logger = logger;
        }

        /// <summary>
        /// Loads the top-rated approved courses for the featured section.
        /// </summary>
        public async Task<IViewComponentResult> InvokeAsync(int count = 8)
        {
            try
            {
                _logger.LogInformation("Loading featured courses with count: {Count}", count);

                var allCourses = await _courseService.GetAllCoursesAsync();

                var featuredCourses = allCourses
                    .Where(c => c.Status == SD.CourseStatusApproved)
                    .OrderByDescending(c => c.AverageRating > 0)
                    .ThenByDescending(c => c.AverageRating)
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
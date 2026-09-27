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
        private readonly IEnrollmentService _enrollmentService;
        private readonly ILogger<FeaturedCoursesViewComponent> _logger;

        /// <summary>
        /// Initializes a new instance of the <see cref="FeaturedCoursesViewComponent"/> class.
        /// </summary>
        /// <param name="courseService">The course service.</param>
        /// <param name="enrollmentService">The enrollment service.</param>
        /// <param name="logger">The logger instance.</param>
        public FeaturedCoursesViewComponent(
            ICourseService courseService,
            IEnrollmentService enrollmentService,
            ILogger<FeaturedCoursesViewComponent> logger)
        {
            _courseService = courseService;
            _enrollmentService = enrollmentService;
            _logger = logger;
        }

        /// <summary>
        /// Loads the top-rated approved courses for the featured section.
        /// When logged in, un-enrolled courses are prioritized so purchased courses don't appear first.
        /// </summary>
        public async Task<IViewComponentResult> InvokeAsync(int count = 8)
        {
            try
            {
                _logger.LogInformation("Loading featured courses with count: {Count}", count);

                var enrolledIds = await _enrollmentService.GetEnrolledCourseIdsAsync();
                List<CourseDTO> featuredCourses;

                if (enrolledIds.Count > 0)
                {
                    // Fetch a larger candidate pool to ensure un-enrolled featured courses fill the requested count
                    var candidateCount = Math.Max(count * 2, 24);
                    var candidateCourses = await _courseService.GetFeaturedCoursesAsync(candidateCount);
                    featuredCourses = candidateCourses.PrioritizeUnenrolled(enrolledIds).Take(count).ToList();
                }
                else
                {
                    var candidateCount = Math.Max(count * 2, 24);
                    var candidateCourses = await _courseService.GetFeaturedCoursesAsync(candidateCount);
                    featuredCourses = candidateCourses.DiversifyByInstructor().Take(count).ToList();
                }

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
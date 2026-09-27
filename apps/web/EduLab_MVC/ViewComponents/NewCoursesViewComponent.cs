// EduLab_MVC/ViewComponents/NewCoursesViewComponent.cs
using EduLab_MVC.Common;
using EduLab_MVC.Models.DTOs.Course;
using EduLab_MVC.Models.ViewModels;
using EduLab_MVC.Services.ServiceInterfaces;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;

namespace EduLab_MVC.ViewComponents
{
    /// <summary>
    /// Renders the most recently created approved courses as new courses.
    /// </summary>
    public class NewCoursesViewComponent : ViewComponent
    {
        private readonly ICourseService _courseService;
        private readonly IEnrollmentService _enrollmentService;
        private readonly ILogger<NewCoursesViewComponent> _logger;

        /// <summary>
        /// Initializes a new instance of the <see cref="NewCoursesViewComponent"/> class.
        /// </summary>
        /// <param name="courseService">The course service.</param>
        /// <param name="enrollmentService">The enrollment service.</param>
        /// <param name="logger">The logger instance.</param>
        public NewCoursesViewComponent(
            ICourseService courseService,
            IEnrollmentService enrollmentService,
            ILogger<NewCoursesViewComponent> logger)
        {
            _courseService = courseService;
            _enrollmentService = enrollmentService;
            _logger = logger;
        }

        /// <summary>
        /// Loads the newest approved courses for the new courses section.
        /// When logged in, un-enrolled courses are prioritized so purchased courses don't appear first.
        /// </summary>
        public async Task<IViewComponentResult> InvokeAsync(int count = 8)
        {
            try
            {
                _logger.LogInformation("Loading new courses with count: {Count}", count);

                var enrolledIds = await _enrollmentService.GetEnrolledCourseIdsAsync();
                List<CourseDTO> newCourses;

                if (enrolledIds.Count > 0)
                {
                    // Fetch a larger candidate pool to ensure un-enrolled new releases fill the requested count
                    var candidateCount = Math.Max(count * 2, 24);
                    var candidateCourses = await _courseService.GetNewCoursesAsync(candidateCount);
                    newCourses = candidateCourses.PrioritizeUnenrolled(enrolledIds).Take(count).ToList();
                }
                else
                {
                    var candidateCount = Math.Max(count * 2, 24);
                    var candidateCourses = await _courseService.GetNewCoursesAsync(candidateCount);
                    newCourses = candidateCourses.DiversifyByInstructor().Take(count).ToList();
                }

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
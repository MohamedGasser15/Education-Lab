using AutoMapper;
using EduLab_Application.ServiceInterfaces;
using EduLab_Domain.Entities;
using EduLab_Shared.DTOs.Course;
using EduLab_Shared.DTOs.Lecture;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace EduLab_API.Controllers.Learner
{
    [Route("api/[controller]")]
    [ApiController]
    [AllowAnonymous]
    public class LearnerCourseController : ControllerBase
    {
        private readonly ICourseService _courseService;
        public LearnerCourseController(ICourseService courseService)
        {
            _courseService = courseService;
        }

        [HttpGet("approved/by-categories")]
        public async Task<IActionResult> GetApprovedCoursesByCategories([FromQuery] List<int> categoryIds, [FromQuery] int countPerCategory = 10)
        {
            try
            {
                var courses = await _courseService.GetApprovedCoursesByCategoriesAsync(categoryIds, countPerCategory);
                return Ok(courses);
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { message = "An error occurred", error = ex.Message });
            }
        }

        [HttpGet("approved/by-instructor/{instructorId}")]
        public async Task<IActionResult> GetApprovedCoursesByInstructor(string instructorId, [FromQuery] int count = 0)
        {
            try
            {
                var courses = await _courseService.GetApprovedCoursesByInstructorAsync(instructorId, count);

                if (courses == null || !courses.Any())
                {
                    return NotFound(new { message = $"No approved courses found for instructor with ID {instructorId}" });
                }

                return Ok(courses);
            }
            catch (Exception ex)
            {
                return StatusCode(500, new
                {
                    message = "An error occurred while retrieving approved courses by instructor",
                    error = ex.Message
                });
            }
        }


        [HttpGet("approved/by-category/{categoryId}")]
        public async Task<IActionResult> GetApprovedCoursesByCategory(int categoryId, [FromQuery] int count = 10)
        {
            try
            {
                var courses = await _courseService.GetApprovedCoursesByCategoryAsync(categoryId, count);
                return Ok(courses);
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { message = "An error occurred", error = ex.Message });
            }
        }
    }
}
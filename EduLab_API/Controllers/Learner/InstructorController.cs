using EduLab_Application.ServiceInterfaces;
using EduLab_Shared.DTOs.Instructor;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace EduLab_API.Controllers.Learner
{
    [ApiController]
    [Route("api/[controller]")]
    [AllowAnonymous]
    public class InstructorController : ControllerBase
    {
        private readonly IInstructorService _instructorService;

        public InstructorController(IInstructorService instructorService)
        {
            _instructorService = instructorService;
        }

        [HttpGet]
        public async Task<ActionResult<InstructorListDTO>> GetAllInstructors()
        {
            try
            {
                var instructors = await _instructorService.GetAllInstructorsAsync();
                return Ok(instructors);
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { message = "حدث خطأ أثناء جلب بيانات المدربين", error = ex.Message });
            }
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<InstructorDTO>> GetInstructorById(string id)
        {
            try
            {
                var instructor = await _instructorService.GetInstructorByIdAsync(id);
                if (instructor == null)
                    return NotFound(new { message = "المدرب غير موجود" });

                return Ok(instructor);
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { message = "حدث خطأ أثناء جلب بيانات المدرب", error = ex.Message });
            }
        }

        [HttpGet("top/{count}")]
        public async Task<ActionResult<List<InstructorDTO>>> GetTopInstructors(int count = 4)
        {
            try
            {
                var instructors = await _instructorService.GetTopRatedInstructorsAsync(count);
                return Ok(instructors);
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { message = "حدث خطأ أثناء جلب أفضل المدربين", error = ex.Message });
            }
        }
    }
}

using EduLab_Application.ServiceInterfaces;
using EduLab_Shared.DTOs.Instructor;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;

namespace EduLab_API.Controllers.Learner
{
    /// <summary>
    /// API controller for managing instructor operations
    /// </summary>
    [ApiController]
    [Route("api/[controller]")]
    [AllowAnonymous]
    [Produces("application/json")]
    public class InstructorController : ControllerBase
    {
        #region Private Fields

        private readonly IInstructorService _instructorService;
        private readonly ILogger<InstructorController> _logger;

        #endregion

        #region Constructor

        /// <summary>
        /// Initializes a new instance of the <see cref="InstructorController"/> class
        /// </summary>
        /// <param name="instructorService">Instructor service for business logic</param>
        /// <param name="logger">Logger for logging operations</param>
        public InstructorController(
            IInstructorService instructorService,
            ILogger<InstructorController> logger)
        {
            _instructorService = instructorService ?? throw new ArgumentNullException(nameof(instructorService));
            _logger = logger ?? throw new ArgumentNullException(nameof(logger));
        }

        #endregion

        #region Public API Methods

        /// <summary>
        /// Retrieves all instructors from the system
        /// </summary>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>List of all instructors</returns>
        /// <response code="200">Returns the list of instructors</response>
        /// <response code="500">If there was an internal server error</response>
        [HttpGet]
        [ProducesResponseType(typeof(InstructorListDTO), StatusCodes.Status200OK)]
        [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status500InternalServerError)]
        public async Task<ActionResult<InstructorListDTO>> GetAllInstructors(CancellationToken cancellationToken = default)
        {
            const string methodName = nameof(GetAllInstructors);
            _logger.LogInformation("Starting {MethodName}", methodName);

            try
            {
                var instructors = await _instructorService.GetAllInstructorsAsync(cancellationToken);
                return Ok(instructors);
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {MethodName} was cancelled", methodName);
                return StatusCode(499, new { message = "Request was cancelled" });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred in {MethodName}", methodName);
                return StatusCode(500, new { message = "حدث خطأ أثناء جلب بيانات المدربين", error = ex.Message });
            }
        }

        /// <summary>
        /// Retrieves a specific instructor by their unique identifier
        /// </summary>
        /// <param name="id">The unique identifier of the instructor</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>Instructor details if found</returns>
        /// <response code="200">Returns the instructor details</response>
        /// <response code="404">If the instructor is not found</response>
        /// <response code="500">If there was an internal server error</response>
        [HttpGet("{id}")]
        [ProducesResponseType(typeof(InstructorDTO), StatusCodes.Status200OK)]
        [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status404NotFound)]
        [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status500InternalServerError)]
        public async Task<ActionResult<InstructorDTO>> GetInstructorById(
            [FromRoute] string id,
            CancellationToken cancellationToken = default)
        {
            const string methodName = nameof(GetInstructorById);
            _logger.LogInformation("Starting {MethodName} for instructor ID: {InstructorId}", methodName, id);

            if (string.IsNullOrWhiteSpace(id))
            {
                return BadRequest(new { message = "معرف المدرب غير صالح" });
            }

            try
            {
                var instructor = await _instructorService.GetInstructorByIdAsync(id, cancellationToken);
                if (instructor == null)
                    return NotFound(new { message = "المدرب غير موجود" });

                return Ok(instructor);
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {MethodName} was cancelled for instructor ID: {InstructorId}", methodName, id);
                return StatusCode(499, new { message = "Request was cancelled" });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred in {MethodName} for instructor ID: {InstructorId}", methodName, id);
                return StatusCode(500, new { message = "حدث خطأ أثناء جلب بيانات المدرب", error = ex.Message });
            }
        }

        /// <summary>
        /// Retrieves top-rated instructors
        /// </summary>
        /// <param name="count">Number of top instructors to retrieve (default: 4)</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>List of top-rated instructors</returns>
        /// <response code="200">Returns the list of top instructors</response>
        /// <response code="500">If there was an internal server error</response>
        [HttpGet("top/{count}")]
        [ProducesResponseType(typeof(List<InstructorDTO>), StatusCodes.Status200OK)]
        [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status500InternalServerError)]
        public async Task<ActionResult<List<InstructorDTO>>> GetTopInstructors(
            [FromRoute] int count = 4,
            CancellationToken cancellationToken = default)
        {
            const string methodName = nameof(GetTopInstructors);
            _logger.LogInformation("Starting {MethodName} for {Count} instructors", methodName, count);

            if (count <= 0)
            {
                return BadRequest(new { message = "عدد المدربين يجب أن يكون أكبر من الصفر" });
            }

            try
            {
                var instructors = await _instructorService.GetTopRatedInstructorsAsync(count, cancellationToken);
                return Ok(instructors);
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {MethodName} was cancelled for count: {Count}", methodName, count);
                return StatusCode(499, new { message = "Request was cancelled" });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred in {MethodName}", methodName);
                return StatusCode(500, new { message = "حدث خطأ أثناء جلب أفضل المدربين", error = ex.Message });
            }
        }

        #endregion
    }
}
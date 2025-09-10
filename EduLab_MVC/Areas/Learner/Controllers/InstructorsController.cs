using EduLab_MVC.Services.ServiceInterfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace EduLab_MVC.Areas.Learner.Controllers
{
    /// <summary>
    /// Controller for handling instructor-related views in the Learner area
    /// </summary>
    [Area("Learner")]
    [AllowAnonymous]
    public class InstructorsController : Controller
    {
        #region Private Fields

        private readonly IInstructorService _instructorService;
        private readonly ILogger<InstructorsController> _logger;

        #endregion

        #region Constructor

        /// <summary>
        /// Initializes a new instance of the <see cref="InstructorsController"/> class
        /// </summary>
        /// <param name="instructorService">Instructor service for business logic</param>
        /// <param name="logger">Logger for logging operations</param>
        public InstructorsController(
            IInstructorService instructorService,
            ILogger<InstructorsController> logger)
        {
            _instructorService = instructorService ?? throw new ArgumentNullException(nameof(instructorService));
            _logger = logger ?? throw new ArgumentNullException(nameof(logger));
        }

        #endregion

        #region Public Action Methods

        /// <summary>
        /// Displays the list of all instructors
        /// </summary>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>View with list of instructors</returns>
        public async Task<IActionResult> Index(CancellationToken cancellationToken = default)
        {
            const string methodName = nameof(Index);
            _logger.LogInformation("Starting {MethodName}", methodName);

            try
            {
                var instructors = await _instructorService.GetAllInstructorsAsync(cancellationToken);
                return View(instructors);
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {MethodName} was cancelled", methodName);
                return View(new System.Collections.Generic.List<Models.DTOs.Instructor.InstructorDTO>());
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred in {MethodName}", methodName);
                return View("Error");
            }
        }

        /// <summary>
        /// Displays details of a specific instructor
        /// </summary>
        /// <param name="id">The unique identifier of the instructor</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>View with instructor details if found, NotFound otherwise</returns>
        public async Task<IActionResult> Details(string id, CancellationToken cancellationToken = default)
        {
            const string methodName = nameof(Details);
            _logger.LogInformation("Starting {MethodName} for instructor ID: {InstructorId}", methodName, id);

            if (string.IsNullOrWhiteSpace(id))
            {
                _logger.LogWarning("Invalid instructor ID provided in {MethodName}", methodName);
                return NotFound();
            }

            try
            {
                var instructor = await _instructorService.GetInstructorByIdAsync(id, cancellationToken);
                if (instructor == null)
                {
                    _logger.LogWarning("Instructor with ID {InstructorId} not found", id);
                    return NotFound();
                }

                return View(instructor);
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {MethodName} was cancelled for instructor ID: {InstructorId}", methodName, id);
                return RedirectToAction(nameof(Index));
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred in {MethodName} for instructor ID: {InstructorId}", methodName, id);
                return View("Error");
            }
        }

        /// <summary>
        /// Displays top instructors
        /// </summary>
        /// <param name="count">Number of top instructors to display</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>View with list of top instructors</returns>
        public async Task<IActionResult> Top(int count = 4, CancellationToken cancellationToken = default)
        {
            const string methodName = nameof(Top);
            _logger.LogInformation("Starting {MethodName} for {Count} instructors", methodName, count);

            if (count <= 0)
            {
                _logger.LogWarning("Invalid count value {Count} provided in {MethodName}", count, methodName);
                count = 4; // Default value
            }

            try
            {
                var instructors = await _instructorService.GetTopInstructorsAsync(count, cancellationToken);
                return View(instructors);
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {MethodName} was cancelled for count: {Count}", methodName, count);
                return View(new System.Collections.Generic.List<Models.DTOs.Instructor.InstructorDTO>());
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred in {MethodName}", methodName);
                return View("Error");
            }
        }

        #endregion
    }
}
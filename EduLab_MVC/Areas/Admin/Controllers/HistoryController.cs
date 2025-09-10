using EduLab_MVC.Models.DTOs.History;
using EduLab_MVC.Services;
using EduLab_MVC.Services.ServiceInterfaces;
using EduLab_Shared.Utitlites;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using System;
using System.Threading;
using System.Threading.Tasks;

namespace EduLab_MVC.Areas.Admin.Controllers
{
    /// <summary>
    /// Controller for managing history views in the Admin area
    /// </summary>
    [Area("Admin")]
    [Authorize(Roles = SD.Admin)]
    public class HistoryController : Controller
    {
        #region Fields

        private readonly IHistoryService _historyService;
        private readonly ILogger<HistoryController> _logger;

        #endregion

        #region Constructor

        /// <summary>
        /// Initializes a new instance of the HistoryController class
        /// </summary>
        /// <param name="historyService">The history service</param>
        /// <param name="logger">Logger for logging operations</param>
        public HistoryController(IHistoryService historyService, ILogger<HistoryController> logger)
        {
            _historyService = historyService ?? throw new ArgumentNullException(nameof(historyService));
            _logger = logger ?? throw new ArgumentNullException(nameof(logger));
        }

        #endregion

        #region Action Methods

        /// <summary>
        /// Displays the main history index view with all logs
        /// </summary>
        /// <param name="cancellationToken">Cancellation token for async operation</param>
        /// <returns>The history index view</returns>
        [HttpGet]
        public async Task<IActionResult> Index(CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Loading history index view");

                var logs = await _historyService.GetAllHistoryAsync(cancellationToken);
                return View(logs);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while loading history index view");
                TempData["Error"] = "An error occurred while loading history data";
                return View(new List<HistoryDTO>());
            }
        }

        /// <summary>
        /// Displays history logs for a specific user
        /// </summary>
        /// <param name="userId">The ID of the user</param>
        /// <param name="cancellationToken">Cancellation token for async operation</param>
        /// <returns>The history view filtered by user</returns>
        [HttpGet]
        public async Task<IActionResult> ByUser(string userId, CancellationToken cancellationToken = default)
        {
            try
            {
                if (string.IsNullOrEmpty(userId))
                {
                    _logger.LogWarning("ByUser action called with null or empty userId");
                    TempData["Error"] = "User ID is required";
                    return RedirectToAction(nameof(Index));
                }

                _logger.LogInformation("Loading history view for user: {UserId}", userId);

                var logs = await _historyService.GetHistoryByUserAsync(userId, cancellationToken);
                return View("Index", logs);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while loading history for user: {UserId}", userId);
                TempData["Error"] = $"An error occurred while loading history for user {userId}";
                return RedirectToAction(nameof(Index));
            }
        }

        #endregion
    }
}
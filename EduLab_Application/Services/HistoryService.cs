using EduLab_Application.ServiceInterfaces;
using EduLab_Domain.Entities;
using EduLab_Domain.RepoInterfaces;
using EduLab_Shared.DTOs.History;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;

namespace EduLab_Application.Services
{
    /// <summary>
    /// Service implementation for history-related operations
    /// </summary>
    public class HistoryService : IHistoryService
    {
        #region Fields

        private readonly IHistoryRepository _historyRepository;
        private readonly ILogger<HistoryService> _logger;

        #endregion

        #region Constructor

        /// <summary>
        /// Initializes a new instance of the HistoryService class
        /// </summary>
        /// <param name="historyRepository">The history repository</param>
        /// <param name="logger">Logger for logging operations</param>
        public HistoryService(IHistoryRepository historyRepository, ILogger<HistoryService> logger)
        {
            _historyRepository = historyRepository ?? throw new ArgumentNullException(nameof(historyRepository));
            _logger = logger ?? throw new ArgumentNullException(nameof(logger));
        }

        #endregion

        #region Public Methods

        /// <summary>
        /// Logs a user operation to the history
        /// </summary>
        /// <param name="userId">The ID of the user performing the operation</param>
        /// <param name="operation">Description of the operation performed</param>
        /// <param name="cancellationToken">Cancellation token for async operation</param>
        /// <returns>Task representing the asynchronous operation</returns>
        public async Task LogOperationAsync(string userId, string operation, CancellationToken cancellationToken = default)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(userId))
                {
                    _logger.LogWarning("LogOperationAsync called with null or empty userId");
                    throw new ArgumentException("User ID cannot be null or empty", nameof(userId));
                }

                if (string.IsNullOrWhiteSpace(operation))
                {
                    _logger.LogWarning("LogOperationAsync called with null or empty operation");
                    throw new ArgumentException("Operation cannot be null or empty", nameof(operation));
                }

                _logger.LogInformation("Logging operation for user: {UserId}, Operation: {Operation}", userId, operation);

                var log = new History
                {
                    UserId = userId,
                    Operation = operation,
                    Date = DateOnly.FromDateTime(DateTime.Now),
                    Time = TimeOnly.FromDateTime(DateTime.Now)
                };

                await _historyRepository.AddAsync(log, cancellationToken);

                _logger.LogInformation("Operation logged successfully for user: {UserId}", userId);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while logging operation for user: {UserId}", userId);
                throw;
            }
        }

        /// <summary>
        /// Retrieves all history logs from the system
        /// </summary>
        /// <param name="cancellationToken">Cancellation token for async operation</param>
        /// <returns>List of all history DTOs</returns>
        public async Task<List<HistoryDTO>> GetAllHistoryAsync(CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Retrieving all history logs");

                var logs = await _historyRepository.GetAllAsync(cancellationToken);

                var result = logs.Select(h => new HistoryDTO
                {
                    Id = h.Id,
                    UserName = h.User != null ? h.User.FullName : "Unknown",
                    ProfileImageUrl = h.User?.ProfileImageUrl,
                    Operation = h.Operation,
                    Date = h.Date,
                    Time = h.Time
                }).ToList();

                _logger.LogInformation("Retrieved {Count} history logs successfully", result.Count);
                return result;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while retrieving all history logs");
                throw;
            }
        }

        /// <summary>
        /// Retrieves history logs for the current user
        /// </summary>
        /// <param name="currentUserId">The ID of the current user</param>
        /// <param name="cancellationToken">Cancellation token for async operation</param>
        /// <returns>List of history DTOs for the current user</returns>
        public async Task<List<HistoryDTO>> GetMyHistoryAsync(string currentUserId, CancellationToken cancellationToken = default)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(currentUserId))
                {
                    _logger.LogWarning("GetMyHistoryAsync called with null or empty currentUserId");
                    throw new ArgumentException("Current user ID cannot be null or empty", nameof(currentUserId));
                }

                _logger.LogInformation("Retrieving history logs for current user: {UserId}", currentUserId);

                var logs = await _historyRepository.GetByUserIdAsync(currentUserId, cancellationToken);

                var result = logs.Select(h => new HistoryDTO
                {
                    Id = h.Id,
                    UserName = h.User?.FullName ?? "Unknown",
                    ProfileImageUrl = h.User?.ProfileImageUrl,
                    Operation = h.Operation,
                    Date = h.Date,
                    Time = h.Time
                }).ToList();

                _logger.LogInformation("Retrieved {Count} history logs for current user: {UserId}", result.Count, currentUserId);
                return result;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while retrieving history logs for current user: {UserId}", currentUserId);
                throw;
            }
        }

        /// <summary>
        /// Retrieves history logs for a specific user
        /// </summary>
        /// <param name="userId">The ID of the user</param>
        /// <param name="cancellationToken">Cancellation token for async operation</param>
        /// <returns>List of history DTOs for the specified user</returns>
        public async Task<List<HistoryDTO>> GetHistoryByUserAsync(string userId, CancellationToken cancellationToken = default)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(userId))
                {
                    _logger.LogWarning("GetHistoryByUserAsync called with null or empty userId");
                    throw new ArgumentException("User ID cannot be null or empty", nameof(userId));
                }

                _logger.LogInformation("Retrieving history logs for user: {UserId}", userId);

                var logs = await _historyRepository.GetByUserIdAsync(userId, cancellationToken);

                var result = logs.Select(h => new HistoryDTO
                {
                    Id = h.Id,
                    UserName = h.User?.FullName ?? "Unknown",
                    ProfileImageUrl = h.User?.ProfileImageUrl,
                    Operation = h.Operation,
                    Date = h.Date,
                    Time = h.Time
                }).ToList();

                _logger.LogInformation("Retrieved {Count} history logs for user: {UserId}", result.Count, userId);
                return result;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while retrieving history logs for user: {UserId}", userId);
                throw;
            }
        }

        #endregion
    }
}
using EduLab_Domain.Entities;
using EduLab_Domain.RepoInterfaces;
using EduLab_Infrastructure.DB;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;

namespace EduLab_Infrastructure.Persistence.Repositories
{
    /// <summary>
    /// Repository implementation for History entity operations
    /// </summary>
    public class HistoryRepository : Repository<History>, IHistoryRepository
    {
        #region Fields

        private readonly ApplicationDbContext _db;
        private readonly ILogger<HistoryRepository> _logger;

        #endregion

        #region Constructor

        /// <summary>
        /// Initializes a new instance of the HistoryRepository class
        /// </summary>
        /// <param name="db">The application database context</param>
        /// <param name="logger">Logger for logging operations</param>
        public HistoryRepository(ApplicationDbContext db, ILogger<HistoryRepository> logger) : base(db, logger)
        {
            _db = db;
            _logger = logger;
        }

        #endregion

        #region Public Methods

        /// <summary>
        /// Adds a new history log entry asynchronously
        /// </summary>
        /// <param name="history">The history entity to add</param>
        /// <param name="cancellationToken">Cancellation token for async operation</param>
        /// <returns>Task representing the asynchronous operation</returns>
        public async Task AddAsync(History history, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Adding new history log for user: {UserId}", history.UserId);

                await base.CreateAsync(history, cancellationToken);

                _logger.LogInformation("History log added successfully for user: {UserId}", history.UserId);
            }
            catch (DbUpdateException dbEx)
            {
                _logger.LogError(dbEx, "Database error occurred while adding history log for user: {UserId}", history.UserId);
                throw new ApplicationException("Database operation failed while adding history log", dbEx);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Unexpected error occurred while adding history log for user: {UserId}", history.UserId);
                throw;
            }
        }

        /// <summary>
        /// Retrieves all history logs asynchronously
        /// </summary>
        /// <param name="cancellationToken">Cancellation token for async operation</param>
        /// <returns>List of all history logs ordered by date and time descending</returns>
        public async Task<List<History>> GetAllAsync(CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Retrieving all history logs");

                var histories = await _db.Histories
                    .Include(h => h.User) // Eager loading user data
                    .OrderByDescending(l => l.Date)
                    .ThenByDescending(l => l.Time)
                    .AsNoTracking() // Read-only operation for better performance
                    .ToListAsync(cancellationToken);

                _logger.LogInformation("Retrieved {Count} history logs successfully", histories.Count);
                return histories;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while retrieving all history logs");
                throw;
            }
        }

        /// <summary>
        /// Retrieves history logs for a specific user asynchronously
        /// </summary>
        /// <param name="userId">The user identifier</param>
        /// <param name="cancellationToken">Cancellation token for async operation</param>
        /// <returns>List of history logs for the specified user ordered by date and time descending</returns>
        public async Task<List<History>> GetByUserIdAsync(string userId, CancellationToken cancellationToken = default)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(userId))
                {
                    _logger.LogWarning("GetByUserIdAsync called with null or empty userId");
                    throw new ArgumentException("User ID cannot be null or empty", nameof(userId));
                }

                _logger.LogInformation("Retrieving history logs for user: {UserId}", userId);

                var userHistories = await _db.Histories
                    .Include(h => h.User) // Eager loading user data
                    .Where(l => l.UserId == userId)
                    .OrderByDescending(l => l.Date)
                    .ThenByDescending(l => l.Time)
                    .AsNoTracking() // Read-only operation for better performance
                    .ToListAsync(cancellationToken);

                _logger.LogInformation("Retrieved {Count} history logs for user: {UserId}", userHistories.Count, userId);
                return userHistories;
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

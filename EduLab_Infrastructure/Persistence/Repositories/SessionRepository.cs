using EduLab_Domain.Entities;
using EduLab_Domain.RepoInterfaces;
using EduLab_Infrastructure.DB;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;

namespace EduLab_Infrastructure.Persistence.Repositories
{
    #region SessionRepository Class
    /// <summary>
    /// Repository implementation for managing user sessions
    /// </summary>
    public class SessionRepository : ISessionRepository
    {
        #region Fields
        private readonly ApplicationDbContext _context;
        private readonly ILogger<SessionRepository> _logger;
        #endregion

        #region Constructor
        /// <summary>
        /// Initializes a new instance of the SessionRepository class
        /// </summary>
        /// <param name="context">Application database context</param>
        /// <param name="logger">Logger instance for logging operations</param>
        /// <exception cref="ArgumentNullException">Thrown when context or logger is null</exception>
        public SessionRepository(ApplicationDbContext context, ILogger<SessionRepository> logger)
        {
            _context = context ?? throw new ArgumentNullException(nameof(context));
            _logger = logger ?? throw new ArgumentNullException(nameof(logger));
        }
        #endregion

        #region Public Methods
        /// <summary>
        /// Retrieves all active sessions for a specific user
        /// </summary>
        /// <param name="userId">The unique identifier of the user</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>List of active user sessions</returns>
        /// <exception cref="ArgumentException">Thrown when userId is null or empty</exception>
        public async Task<List<UserSession>> GetActiveSessionsForUser(string userId,
            CancellationToken cancellationToken = default)
        {
            const string operationName = "GetActiveSessionsForUser";

            if (string.IsNullOrWhiteSpace(userId))
                throw new ArgumentException("User ID cannot be null or empty", nameof(userId));

            try
            {
                _logger.LogDebug("Starting {OperationName} for user ID: {UserId}", operationName, userId);

                var sessions = await _context.UserSessions
                    .Where(s => s.UserId == userId && s.IsActive && s.LogoutTime == null)
                    .OrderByDescending(s => s.LastActivity ?? s.LoginTime)
                    .ToListAsync(cancellationToken);

                _logger.LogInformation("Successfully retrieved {Count} active sessions for user ID: {UserId} in {OperationName}",
                    sessions.Count, userId, operationName);

                return sessions;
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {OperationName} was cancelled for user ID: {UserId}",
                    operationName, userId);
                throw;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred in {OperationName} for user ID: {UserId}",
                    operationName, userId);
                throw;
            }
        }

        /// <summary>
        /// Retrieves a session by its unique identifier
        /// </summary>
        /// <param name="sessionId">The unique identifier of the session</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>The user session or null if not found</returns>
        public async Task<UserSession?> GetSessionById(Guid sessionId, CancellationToken cancellationToken = default)
        {
            const string operationName = "GetSessionById";

            try
            {
                _logger.LogDebug("Starting {OperationName} for session ID: {SessionId}", operationName, sessionId);

                var session = await _context.UserSessions.FindAsync(new object[] { sessionId }, cancellationToken);

                if (session == null)
                {
                    _logger.LogWarning("Session not found with ID: {SessionId} in {OperationName}",
                        sessionId, operationName);
                }
                else
                {
                    _logger.LogInformation("Successfully retrieved session with ID: {SessionId} in {OperationName}",
                        sessionId, operationName);
                }

                return session;
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {OperationName} was cancelled for session ID: {SessionId}",
                    operationName, sessionId);
                throw;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred in {OperationName} for session ID: {SessionId}",
                    operationName, sessionId);
                throw;
            }
        }

        /// <summary>
        /// Creates a new user session
        /// </summary>
        /// <param name="session">The session object to create</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>Task representing the asynchronous operation</returns>
        /// <exception cref="ArgumentNullException">Thrown when session is null</exception>
        public async Task CreateSession(UserSession session, CancellationToken cancellationToken = default)
        {
            const string operationName = "CreateSession";

            if (session == null)
                throw new ArgumentNullException(nameof(session));

            try
            {
                _logger.LogDebug("Starting {OperationName} for user ID: {UserId}",
                    operationName, session.UserId);

                _context.UserSessions.Add(session);
                await _context.SaveChangesAsync(cancellationToken);

                _logger.LogInformation("Successfully created session with ID: {SessionId} for user ID: {UserId} in {OperationName}",
                    session.Id, session.UserId, operationName);
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {OperationName} was cancelled for user ID: {UserId}",
                    operationName, session.UserId);
                throw;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred in {OperationName} for user ID: {UserId}",
                    operationName, session.UserId);
                throw;
            }
        }

        /// <summary>
        /// Revokes (deactivates) a specific session
        /// </summary>
        /// <param name="sessionId">The unique identifier of the session to revoke</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>True if session was found and revoked, false otherwise</returns>
        public async Task<bool> RevokeSession(Guid sessionId, CancellationToken cancellationToken = default)
        {
            const string operationName = "RevokeSession";

            try
            {
                _logger.LogDebug("Starting {OperationName} for session ID: {SessionId}", operationName, sessionId);

                var session = await GetSessionById(sessionId, cancellationToken);
                if (session == null)
                {
                    _logger.LogWarning("Session not found for revocation with ID: {SessionId}", sessionId);
                    return false;
                }

                session.IsActive = false;
                session.LogoutTime = DateTime.UtcNow;
                await _context.SaveChangesAsync(cancellationToken);

                _logger.LogInformation("Successfully revoked session with ID: {SessionId} in {OperationName}",
                    sessionId, operationName);

                return true;
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {OperationName} was cancelled for session ID: {SessionId}",
                    operationName, sessionId);
                throw;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred in {OperationName} for session ID: {SessionId}",
                    operationName, sessionId);
                throw;
            }
        }

        /// <summary>
        /// Revokes all active sessions for a user, optionally excluding a specific session
        /// </summary>
        /// <param name="userId">The unique identifier of the user</param>
        /// <param name="excludeSessionId">Optional session ID to exclude from revocation</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>Number of sessions revoked</returns>
        /// <exception cref="ArgumentException">Thrown when userId is null or empty</exception>
        public async Task<int> RevokeAllSessionsForUser(string userId, Guid? excludeSessionId = null,
            CancellationToken cancellationToken = default)
        {
            const string operationName = "RevokeAllSessionsForUser";

            if (string.IsNullOrWhiteSpace(userId))
                throw new ArgumentException("User ID cannot be null or empty", nameof(userId));

            try
            {
                _logger.LogDebug("Starting {OperationName} for user ID: {UserId}", operationName, userId);

                var sessionsQuery = _context.UserSessions
                    .Where(s => s.UserId == userId && s.IsActive && s.LogoutTime == null);

                if (excludeSessionId.HasValue)
                {
                    sessionsQuery = sessionsQuery.Where(s => s.Id != excludeSessionId.Value);
                }

                var sessions = await sessionsQuery.ToListAsync(cancellationToken);

                foreach (var session in sessions)
                {
                    session.IsActive = false;
                    session.LogoutTime = DateTime.UtcNow;
                }

                var revokedCount = sessions.Count;
                if (revokedCount > 0)
                {
                    await _context.SaveChangesAsync(cancellationToken);
                }

                _logger.LogInformation("Successfully revoked {RevokedCount} sessions for user ID: {UserId} in {OperationName}",
                    revokedCount, userId, operationName);

                return revokedCount;
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {OperationName} was cancelled for user ID: {UserId}",
                    operationName, userId);
                throw;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred in {OperationName} for user ID: {UserId}",
                    operationName, userId);
                throw;
            }
        }
        #endregion
    }
    #endregion
}
using EduLab_Domain.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_Domain.IRepository
{
    /// <summary>
    /// Repository interface for user session management
    /// </summary>
    public interface ISessionRepository
    {
        /// <summary>
        /// Retrieves all active sessions for a user
        /// </summary>
        /// <param name="userId">User identifier</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>List of active sessions</returns>
        Task<List<UserSession>> GetActiveSessionsForUser(string userId,
            CancellationToken cancellationToken = default);

        /// <summary>
        /// Retrieves a session by its identifier
        /// </summary>
        /// <param name="sessionId">Session identifier</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>The session or null</returns>
        Task<UserSession?> GetSessionById(Guid sessionId, CancellationToken cancellationToken = default);

        /// <summary>
        /// Creates a new user session
        /// </summary>
        /// <param name="session">Session entity to create</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Task representing the asynchronous operation</returns>
        Task CreateSession(UserSession session, CancellationToken cancellationToken = default);

        /// <summary>
        /// Revokes a specific session
        /// </summary>
        /// <param name="sessionId">Session identifier</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>True if revoked successfully</returns>
        Task<bool> RevokeSession(Guid sessionId, CancellationToken cancellationToken = default);

        /// <summary>
        /// Revokes all sessions of a user except the specified one
        /// </summary>
        /// <param name="userId">User identifier</param>
        /// <param name="excludeSessionId">Session to keep active</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Number of revoked sessions</returns>
        Task<int> RevokeAllSessionsForUser(string userId, Guid? excludeSessionId = null,
            CancellationToken cancellationToken = default);
    }
}

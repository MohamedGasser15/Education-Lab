using EduLab_Domain.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_Domain.RepoInterfaces
{
    public interface ISessionRepository
    {
        Task<List<UserSession>> GetActiveSessionsForUser(string userId,
            CancellationToken cancellationToken = default);
        Task<UserSession?> GetSessionById(Guid sessionId, CancellationToken cancellationToken = default);
        Task CreateSession(UserSession session, CancellationToken cancellationToken = default);
        Task<bool> RevokeSession(Guid sessionId, CancellationToken cancellationToken = default);
        Task<int> RevokeAllSessionsForUser(string userId, Guid? excludeSessionId = null,
            CancellationToken cancellationToken = default);
    }
}

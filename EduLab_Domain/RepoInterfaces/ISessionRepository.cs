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
        Task<List<UserSession>> GetActiveSessionsForUser(string userId);
        Task<UserSession> GetSessionById(Guid sessionId);
        Task CreateSession(UserSession session);
        Task RevokeSession(Guid sessionId);
        Task RevokeAllSessionsForUser(string userId, Guid? excludeSessionId = null);
    }
}

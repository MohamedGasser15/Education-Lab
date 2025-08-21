using EduLab_Domain.Entities;
using EduLab_Domain.RepoInterfaces;
using EduLab_Infrastructure.DB;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_Infrastructure.Persistence.Repositories
{
    public class SessionRepository : ISessionRepository
    {
        private readonly ApplicationDbContext _context;

        public SessionRepository(ApplicationDbContext context)
        {
            _context = context;
        }

        public async Task<List<UserSession>> GetActiveSessionsForUser(string userId)
        {
            return await _context.UserSessions
                .Where(s => s.UserId == userId && s.IsActive && s.LogoutTime == null)
                .OrderByDescending(s => s.LastActivity ?? s.LoginTime)
                .ToListAsync();
        }

        public async Task<UserSession> GetSessionById(Guid sessionId)
        {
            return await _context.UserSessions.FindAsync(sessionId);
        }

        public async Task CreateSession(UserSession session)
        {
            _context.UserSessions.Add(session);
            await _context.SaveChangesAsync();
        }

        public async Task RevokeSession(Guid sessionId)
        {
            var session = await GetSessionById(sessionId);
            if (session != null)
            {
                session.IsActive = false;
                session.LogoutTime = DateTime.UtcNow;
                await _context.SaveChangesAsync();
            }
        }

        public async Task RevokeAllSessionsForUser(string userId, Guid? excludeSessionId = null)
        {
            var sessions = await _context.UserSessions
                .Where(s => s.UserId == userId && s.IsActive && s.LogoutTime == null && s.Id != excludeSessionId)
                .ToListAsync();

            foreach (var session in sessions)
            {
                session.IsActive = false;
                session.LogoutTime = DateTime.UtcNow;
            }

            await _context.SaveChangesAsync();
        }
    }
}

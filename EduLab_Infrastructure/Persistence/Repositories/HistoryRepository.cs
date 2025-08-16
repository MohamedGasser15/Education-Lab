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
    public class HistoryRepository : Repository<History>, IHistoryRepository
    {
        private readonly ApplicationDbContext _db;

        // Constructor with dependency injection
        public HistoryRepository(ApplicationDbContext db) : base(db)
        {
            _db = db ;
        }
        public async Task AddAsync(History history)
        {
            await _db.Histories.AddAsync(history);
            await _db.SaveChangesAsync();
        }

        public async Task<List<History>> GetAllAsync()
        {
            return await _db.Histories
                .OrderByDescending(l => l.Date)
                .ThenByDescending(l => l.Time)
                .ToListAsync();
        }

        public async Task<List<History>> GetByUserIdAsync(string userId)
        {
            return await _db.Histories
                .Where(l => l.UserId == userId)
                .OrderByDescending(l => l.Date)
                .ThenByDescending(l => l.Time)
                .ToListAsync();
        }
    }
}

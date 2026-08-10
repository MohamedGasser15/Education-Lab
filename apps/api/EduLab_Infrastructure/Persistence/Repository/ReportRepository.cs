using EduLab_Domain.Entities;
using EduLab_Domain.IRepository;
using EduLab_Infrastructure.DB;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Threading;
using System.Threading.Tasks;

namespace EduLab_Infrastructure.Persistence.Repositories
{
    public class ReportRepository : IReportRepository
    {
        private readonly ApplicationDbContext _db;

        public ReportRepository(ApplicationDbContext db)
        {
            _db = db;
        }

        public async Task<Report> CreateAsync(Report report, CancellationToken cancellationToken = default)
        {
            await _db.Reports.AddAsync(report, cancellationToken);
            return report;
        }

        public async Task<Report?> GetByIdAsync(int id, CancellationToken cancellationToken = default)
        {
            return await _db.Reports.FindAsync(new object[] { id }, cancellationToken);
        }

        public async Task<Report?> GetByIdWithReporterAsync(int id, CancellationToken cancellationToken = default)
        {
            return await _db.Reports
                .Include(r => r.Reporter)
                .FirstOrDefaultAsync(r => r.Id == id, cancellationToken);
        }

        public async Task<List<Report>> GetFilteredAsync(
            string? status,
            string? type,
            string? search,
            int skip,
            int take,
            CancellationToken cancellationToken = default)
        {
            var query = _db.Reports.Include(r => r.Reporter).AsQueryable();

            if (!string.IsNullOrEmpty(status) && status != "all")
                query = query.Where(r => r.Status == status);

            if (!string.IsNullOrEmpty(type) && type != "all")
                query = query.Where(r => r.Type == type);

            if (!string.IsNullOrWhiteSpace(search))
            {
                var term = search.Trim();
                query = query.Where(r => r.Details != null && r.Details.Contains(term));
            }

            return await query
                .OrderByDescending(r => r.CreatedAt)
                .Skip(skip)
                .Take(take)
                .ToListAsync(cancellationToken);
        }

        public async Task<int> CountFilteredAsync(string? status, string? type, string? search, CancellationToken cancellationToken = default)
        {
            var query = _db.Reports.AsQueryable();

            if (!string.IsNullOrEmpty(status) && status != "all")
                query = query.Where(r => r.Status == status);

            if (!string.IsNullOrEmpty(type) && type != "all")
                query = query.Where(r => r.Type == type);

            if (!string.IsNullOrWhiteSpace(search))
            {
                var term = search.Trim();
                query = query.Where(r => r.Details != null && r.Details.Contains(term));
            }

            return await query.CountAsync(cancellationToken);
        }

        public async Task<int> CountAsync(Expression<Func<Report, bool>> predicate, CancellationToken cancellationToken = default)
        {
            return await _db.Reports.CountAsync(predicate, cancellationToken);
        }

        public async Task<bool> AnyAsync(Expression<Func<Report, bool>> predicate, CancellationToken cancellationToken = default)
        {
            return await _db.Reports.AnyAsync(predicate, cancellationToken);
        }

        public async Task<List<int>> GetReportedTargetIdsAsync(string userId, string type, IEnumerable<int> targetIds, CancellationToken cancellationToken = default)
        {
            var ids = targetIds.ToList();
            if (ids.Count == 0)
                return new List<int>();

            return await _db.Reports
                .Where(r => r.ReporterId == userId && r.Type == type && ids.Contains(r.TargetId))
                .Select(r => r.TargetId)
                .Distinct()
                .ToListAsync(cancellationToken);
        }

        public async Task SaveAsync(CancellationToken cancellationToken = default)
        {
            await _db.SaveChangesAsync(cancellationToken);
        }
    }
}

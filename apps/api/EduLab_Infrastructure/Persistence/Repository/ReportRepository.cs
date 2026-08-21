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
    /// <summary>
    /// Repository implementation for report operations
    /// </summary>
    public class ReportRepository : IReportRepository
    {
        private readonly ApplicationDbContext _db;

        /// <summary>
        /// Initializes a new instance of the ReportRepository class
        /// </summary>
        /// <param name="db">Application database context</param>
        public ReportRepository(ApplicationDbContext db)
        {
            _db = db;
        }

        /// <summary>
        /// Adds a new report to the database
        /// </summary>
        /// <param name="report">The report to create</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>The created report</returns>
        public async Task<Report> CreateAsync(Report report, CancellationToken cancellationToken = default)
        {
            await _db.Reports.AddAsync(report, cancellationToken);
            return report;
        }

        /// <summary>
        /// Gets a report by its ID
        /// </summary>
        /// <param name="id">The report identifier</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>The report, or null if it was not found</returns>
        public async Task<Report?> GetByIdAsync(int id, CancellationToken cancellationToken = default)
        {
            return await _db.Reports.FindAsync(new object[] { id }, cancellationToken);
        }

        /// <summary>
        /// Gets a report by its ID including the reporting user
        /// </summary>
        /// <param name="id">The report identifier</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>The report with its reporter, or null if it was not found</returns>
        public async Task<Report?> GetByIdWithReporterAsync(int id, CancellationToken cancellationToken = default)
        {
            return await _db.Reports
                .Include(r => r.Reporter)
                .FirstOrDefaultAsync(r => r.Id == id, cancellationToken);
        }

        /// <summary>
        /// Gets a filtered and paged list of reports
        /// </summary>
        /// <param name="status">Optional status filter; "all" or null means no filter</param>
        /// <param name="type">Optional report type filter; "all" or null means no filter</param>
        /// <param name="search">Optional text search against report details</param>
        /// <param name="skip">Number of records to skip</param>
        /// <param name="take">Number of records to return</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>List of matching reports ordered by creation date descending</returns>
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

        /// <summary>
        /// Counts reports matching the given filters
        /// </summary>
        /// <param name="status">Optional status filter; "all" or null means no filter</param>
        /// <param name="type">Optional report type filter; "all" or null means no filter</param>
        /// <param name="search">Optional text search against report details</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>The number of matching reports</returns>
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

        /// <summary>
        /// Counts reports matching a predicate
        /// </summary>
        /// <param name="predicate">The filter expression</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>The number of matching reports</returns>
        public async Task<int> CountAsync(Expression<Func<Report, bool>> predicate, CancellationToken cancellationToken = default)
        {
            return await _db.Reports.CountAsync(predicate, cancellationToken);
        }

        /// <summary>
        /// Checks whether any report matches a predicate
        /// </summary>
        /// <param name="predicate">The filter expression</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>True if a matching report exists; otherwise false</returns>
        public async Task<bool> AnyAsync(Expression<Func<Report, bool>> predicate, CancellationToken cancellationToken = default)
        {
            return await _db.Reports.AnyAsync(predicate, cancellationToken);
        }

        /// <summary>
        /// Gets the distinct target IDs already reported by a user for a given type
        /// </summary>
        /// <param name="userId">The reporting user identifier</param>
        /// <param name="type">The report type</param>
        /// <param name="targetIds">The candidate target IDs to check</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>List of target IDs already reported by the user</returns>
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

        /// <summary>
        /// Persists all pending report changes to the database
        /// </summary>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>A task representing the asynchronous operation</returns>
        public async Task SaveAsync(CancellationToken cancellationToken = default)
        {
            await _db.SaveChangesAsync(cancellationToken);
        }
    }
}

using EduLab_Domain.Entities;
using System;
using System.Collections.Generic;
using System.Linq.Expressions;
using System.Threading;
using System.Threading.Tasks;

namespace EduLab_Domain.IRepository
{
    /// <summary>
    /// Repository interface for content report data operations
    /// </summary>
    public interface IReportRepository
    {
        /// <summary>
        /// Creates a new report
        /// </summary>
        /// <param name="report">Report entity to create</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>The created report</returns>
        Task<Report> CreateAsync(Report report, CancellationToken cancellationToken = default);

        /// <summary>
        /// Retrieves a report by its identifier
        /// </summary>
        /// <param name="id">Report identifier</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>The report or null</returns>
        Task<Report?> GetByIdAsync(int id, CancellationToken cancellationToken = default);

        /// <summary>
        /// Retrieves a report by its identifier including the reporting user
        /// </summary>
        /// <param name="id">Report identifier</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>The report with reporter or null</returns>
        Task<Report?> GetByIdWithReporterAsync(int id, CancellationToken cancellationToken = default);

        /// <summary>
        /// Retrieves reports filtered by status, type, and search text with pagination
        /// </summary>
        /// <param name="status">Optional status filter</param>
        /// <param name="type">Optional type filter</param>
        /// <param name="search">Optional search text</param>
        /// <param name="skip">Number of records to skip</param>
        /// <param name="take">Number of records to return</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>List of matching reports</returns>
        Task<List<Report>> GetFilteredAsync(
            string? status,
            string? type,
            string? search,
            int skip,
            int take,
            CancellationToken cancellationToken = default);

        /// <summary>
        /// Counts reports matching the given filters
        /// </summary>
        /// <param name="status">Optional status filter</param>
        /// <param name="type">Optional type filter</param>
        /// <param name="search">Optional search text</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Count of matching reports</returns>
        Task<int> CountFilteredAsync(string? status, string? type, string? search, CancellationToken cancellationToken = default);

        /// <summary>
        /// Counts reports matching the specified predicate
        /// </summary>
        /// <param name="predicate">Predicate to evaluate</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Count of matching reports</returns>
        Task<int> CountAsync(Expression<Func<Report, bool>> predicate, CancellationToken cancellationToken = default);

        /// <summary>
        /// Checks whether any report matches the specified predicate
        /// </summary>
        /// <param name="predicate">Predicate to evaluate</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>True if a match exists, otherwise false</returns>
        Task<bool> AnyAsync(Expression<Func<Report, bool>> predicate, CancellationToken cancellationToken = default);

        /// <summary>
        /// Retrieves the IDs of targets already reported by a user for a given type
        /// </summary>
        /// <param name="userId">Reporting user identifier</param>
        /// <param name="type">Target type</param>
        /// <param name="targetIds">Target IDs to check</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>List of reported target IDs</returns>
        Task<List<int>> GetReportedTargetIdsAsync(string userId, string type, IEnumerable<int> targetIds, CancellationToken cancellationToken = default);

        /// <summary>
        /// Persists all pending changes
        /// </summary>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Task representing the asynchronous operation</returns>
        Task SaveAsync(CancellationToken cancellationToken = default);
    }
}

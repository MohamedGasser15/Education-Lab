using EduLab_Domain.Entities;
using System;
using System.Collections.Generic;
using System.Linq.Expressions;
using System.Threading;
using System.Threading.Tasks;

namespace EduLab_Domain.IRepository
{
    public interface IReportRepository
    {
        Task<Report> CreateAsync(Report report, CancellationToken cancellationToken = default);
        Task<Report?> GetByIdAsync(int id, CancellationToken cancellationToken = default);
        Task<Report?> GetByIdWithReporterAsync(int id, CancellationToken cancellationToken = default);
        Task<List<Report>> GetFilteredAsync(
            string? status,
            string? type,
            string? search,
            int skip,
            int take,
            CancellationToken cancellationToken = default);
        Task<int> CountFilteredAsync(string? status, string? type, string? search, CancellationToken cancellationToken = default);
        Task<int> CountAsync(Expression<Func<Report, bool>> predicate, CancellationToken cancellationToken = default);
        Task<bool> AnyAsync(Expression<Func<Report, bool>> predicate, CancellationToken cancellationToken = default);
        Task<List<int>> GetReportedTargetIdsAsync(string userId, string type, IEnumerable<int> targetIds, CancellationToken cancellationToken = default);
        Task SaveAsync(CancellationToken cancellationToken = default);
    }
}

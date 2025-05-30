using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_Domain.RepoInterfaces
{
    public interface IRepository<T> where T : class
    {
        Task<List<T>> GetAllAsync(Expression<Func<T, bool>>? filter = null, string? includeProperties = null, bool isTracking = false);
        Task<T> GetAsync(Expression<Func<T, bool>> filter, string? includeProperties = null, bool isTracking = false);
        Task CreateAsync(T entity);
        Task DeleteAsync(T entity);
        Task DeleteRangeAsync(IEnumerable<T> entities);
        Task SaveAsync();
    }
}

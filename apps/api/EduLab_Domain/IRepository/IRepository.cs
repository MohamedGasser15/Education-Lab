using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_Domain.IRepository
{
    /// <summary>
    /// Generic repository interface providing common data access operations
    /// </summary>
    /// <typeparam name="T">The entity type managed by the repository</typeparam>
    public interface IRepository<T> where T : class
    {
        /// <summary>
        /// Retrieves a filtered, ordered, and optionally paginated list of entities
        /// </summary>
        /// <param name="filter">Optional predicate to filter results</param>
        /// <param name="includeProperties">Comma-separated related properties to include</param>
        /// <param name="isTracking">Whether to enable entity tracking</param>
        /// <param name="orderBy">Ordering function to sort results</param>
        /// <param name="take">Maximum number of records to return</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>List of entities</returns>
        Task<List<T>> GetAllAsync(
            Expression<Func<T, bool>>? filter = null,
            string? includeProperties = null,
            bool isTracking = false,
            Func<IQueryable<T>, IOrderedQueryable<T>>? orderBy = null,
            int? take = null,
            CancellationToken cancellationToken = default);

        /// <summary>
        /// Retrieves a single entity matching the specified filter
        /// </summary>
        /// <param name="filter">Predicate to match the entity</param>
        /// <param name="includeProperties">Comma-separated related properties to include</param>
        /// <param name="isTracking">Whether to enable entity tracking</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>The matching entity</returns>
        Task<T> GetAsync(
            Expression<Func<T, bool>> filter,
            string? includeProperties = null,
            bool isTracking = false,
            CancellationToken cancellationToken = default);

        /// <summary>
        /// Checks whether any entity matches the specified predicate
        /// </summary>
        /// <param name="predicate">Predicate to evaluate</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>True if a match exists, otherwise false</returns>
        Task<bool> AnyAsync(Expression<Func<T, bool>> predicate, CancellationToken cancellationToken = default);

        /// <summary>
        /// Adds a new entity
        /// </summary>
        /// <param name="entity">Entity to add</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Task representing the asynchronous operation</returns>
        Task CreateAsync(T entity, CancellationToken cancellationToken = default);

        /// <summary>
        /// Removes an entity
        /// </summary>
        /// <param name="entity">Entity to remove</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Task representing the asynchronous operation</returns>
        Task DeleteAsync(T entity, CancellationToken cancellationToken = default);

        /// <summary>
        /// Removes a range of entities
        /// </summary>
        /// <param name="entities">Entities to remove</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Task representing the asynchronous operation</returns>
        Task DeleteRangeAsync(IEnumerable<T> entities, CancellationToken cancellationToken = default);

        /// <summary>
        /// Persists all pending changes
        /// </summary>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Task representing the asynchronous operation</returns>
        Task SaveAsync(CancellationToken cancellationToken = default);
    }
}
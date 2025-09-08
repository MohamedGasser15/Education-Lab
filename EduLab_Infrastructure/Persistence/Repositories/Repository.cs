using EduLab_Domain.RepoInterfaces;
using EduLab_Infrastructure.DB;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Threading;
using System.Threading.Tasks;

namespace EduLab_Infrastructure.Persistence.Repositories
{
    /// <summary>
    /// Generic repository implementation for CRUD operations
    /// </summary>
    /// <typeparam name="T">Entity type</typeparam>
    public class Repository<T> : IRepository<T> where T : class
    {
        private readonly ApplicationDbContext _db;
        private readonly ILogger<Repository<T>> _logger;
        internal DbSet<T> dbSet;

        /// <summary>
        /// Initializes a new instance of the Repository class
        /// </summary>
        /// <param name="db">Application database context</param>
        /// <param name="logger">Logger instance</param>
        public Repository(ApplicationDbContext db, ILogger<Repository<T>> logger)
        {
            _db = db;
            _logger = logger;
            this.dbSet = _db.Set<T>();
        }

        #region Read Operations

        /// <summary>
        /// Retrieves all entities with optional filtering, ordering, and including related properties
        /// </summary>
        /// <param name="filter">Filter expression</param>
        /// <param name="includeProperties">Comma-separated related properties to include</param>
        /// <param name="isTracking">Whether to enable entity tracking</param>
        /// <param name="orderBy">Ordering function</param>
        /// <param name="take">Number of records to take</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>List of entities</returns>
        public async Task<List<T>> GetAllAsync(
            Expression<Func<T, bool>>? filter = null,
            string? includeProperties = null,
            bool isTracking = false,
            Func<IQueryable<T>, IOrderedQueryable<T>>? orderBy = null,
            int? take = null,
            CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogDebug("Getting all entities of type {Type}", typeof(T).Name);

                IQueryable<T> query = isTracking ? dbSet : dbSet.AsNoTracking();

                if (filter != null)
                    query = query.Where(filter);

                if (!string.IsNullOrEmpty(includeProperties))
                {
                    foreach (var includeProperty in includeProperties.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries))
                    {
                        query = query.Include(includeProperty);
                    }
                }

                if (orderBy != null)
                    query = orderBy(query);

                if (take.HasValue)
                    query = query.Take(take.Value);

                return await query.ToListAsync(cancellationToken);
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation cancelled while getting all entities of type {Type}", typeof(T).Name);
                throw;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while getting all entities of type {Type}", typeof(T).Name);
                throw;
            }
        }

        /// <summary>
        /// Retrieves a single entity based on filter criteria
        /// </summary>
        /// <param name="filter">Filter expression</param>
        /// <param name="includeProperties">Comma-separated related properties to include</param>
        /// <param name="isTracking">Whether to enable entity tracking</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Entity or null if not found</returns>
        public async Task<T?> GetAsync(
            Expression<Func<T, bool>> filter,
            string? includeProperties = null,
            bool isTracking = false,
            CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogDebug("Getting entity of type {Type} with filter", typeof(T).Name);

                IQueryable<T> query = isTracking ? dbSet : dbSet.AsNoTracking();

                query = query.Where(filter);

                if (!string.IsNullOrEmpty(includeProperties))
                {
                    foreach (var includeProperty in includeProperties.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries))
                    {
                        query = query.Include(includeProperty);
                    }
                }

                return await query.FirstOrDefaultAsync(cancellationToken);
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation cancelled while getting entity of type {Type}", typeof(T).Name);
                throw;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while getting entity of type {Type}", typeof(T).Name);
                throw;
            }
        }

        /// <summary>
        /// Checks if any entity satisfies the given condition
        /// </summary>
        /// <param name="predicate">Condition to check</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>True if any entity exists, otherwise false</returns>
        public async Task<bool> AnyAsync(Expression<Func<T, bool>> predicate, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogDebug("Checking existence of entity of type {Type}", typeof(T).Name);
                return await dbSet.AsNoTracking().AnyAsync(predicate, cancellationToken);
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation cancelled while checking existence of entity of type {Type}", typeof(T).Name);
                throw;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while checking existence of entity of type {Type}", typeof(T).Name);
                throw;
            }
        }
        #endregion

        #region Create Operations

        /// <summary>
        /// Creates a new entity
        /// </summary>
        /// <param name="entity">Entity to create</param>
        /// <param name="cancellationToken">Cancellation token</param>
        public async Task CreateAsync(T entity, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogDebug("Creating new entity of type {Type}", typeof(T).Name);
                await dbSet.AddAsync(entity, cancellationToken);
                await SaveAsync(cancellationToken);
                _logger.LogInformation("Entity of type {Type} created successfully", typeof(T).Name);
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation cancelled while creating entity of type {Type}", typeof(T).Name);
                throw;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while creating entity of type {Type}", typeof(T).Name);
                throw;
            }
        }

        #endregion

        #region Delete Operations

        /// <summary>
        /// Deletes an entity
        /// </summary>
        /// <param name="entity">Entity to delete</param>
        /// <param name="cancellationToken">Cancellation token</param>
        public async Task DeleteAsync(T entity, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogDebug("Deleting entity of type {Type}", typeof(T).Name);
                dbSet.Remove(entity);
                await SaveAsync(cancellationToken);
                _logger.LogInformation("Entity of type {Type} deleted successfully", typeof(T).Name);
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation cancelled while deleting entity of type {Type}", typeof(T).Name);
                throw;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while deleting entity of type {Type}", typeof(T).Name);
                throw;
            }
        }

        /// <summary>
        /// Deletes multiple entities
        /// </summary>
        /// <param name="entities">Entities to delete</param>
        /// <param name="cancellationToken">Cancellation token</param>
        public async Task DeleteRangeAsync(IEnumerable<T> entities, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogDebug("Deleting {Count} entities of type {Type}", entities.Count(), typeof(T).Name);
                dbSet.RemoveRange(entities);
                await SaveAsync(cancellationToken);
                _logger.LogInformation("{Count} entities of type {Type} deleted successfully", entities.Count(), typeof(T).Name);
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation cancelled while deleting multiple entities of type {Type}", typeof(T).Name);
                throw;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while deleting multiple entities of type {Type}", typeof(T).Name);
                throw;
            }
        }

        #endregion

        #region Utility Methods

        /// <summary>
        /// Saves changes to the database
        /// </summary>
        /// <param name="cancellationToken">Cancellation token</param>
        public async Task SaveAsync(CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogDebug("Saving changes to database");
                await _db.SaveChangesAsync(cancellationToken);
                _logger.LogDebug("Changes saved successfully");
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation cancelled while saving changes to database");
                throw;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while saving changes to database");
                throw;
            }
        }

        #endregion
    }
}
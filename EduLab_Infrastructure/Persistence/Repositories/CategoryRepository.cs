using EduLab_Domain.Entities;
using EduLab_Domain.RepoInterfaces;
using EduLab_Infrastructure.DB;
using Microsoft.Extensions.Logging;
using System.Threading;
using System.Threading.Tasks;

namespace EduLab_Infrastructure.Persistence.Repositories
{
    /// <summary>
    /// Repository implementation for Category entity with specific operations
    /// </summary>
    public class CategoryRepository : Repository<Category>, ICategoryRepository
    {
        private readonly ApplicationDbContext _db;
        private readonly ILogger<CategoryRepository> _logger;

        /// <summary>
        /// Initializes a new instance of the CategoryRepository class
        /// </summary>
        /// <param name="db">Application database context</param>
        /// <param name="logger">Logger instance</param>
        public CategoryRepository(ApplicationDbContext db, ILogger<CategoryRepository> logger)
            : base(db, logger)
        {
            _db = db;
            _logger = logger;
        }

        #region Update Operations

        /// <summary>
        /// Updates a category entity
        /// </summary>
        /// <param name="entity">Category entity to update</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Updated category entity</returns>
        public async Task<Category> UpdateAsync(Category entity, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogDebug("Updating category with ID: {CategoryId}", entity.Category_Id);
                _db.Categories.Update(entity);
                await _db.SaveChangesAsync(cancellationToken);
                _logger.LogInformation("Category with ID: {CategoryId} updated successfully", entity.Category_Id);
                return entity;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while updating category with ID: {CategoryId}", entity.Category_Id);
                throw;
            }
        }

        #endregion
    }
}
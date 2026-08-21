using EduLab_Domain.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_Domain.IRepository
{
    /// <summary>
    /// Repository interface for category data operations
    /// </summary>
    public interface ICategoryRepository : IRepository<Category>
    {
        /// <summary>
        /// Updates an existing category
        /// </summary>
        /// <param name="entity">Category entity with updated values</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>The updated category</returns>
        Task<Category> UpdateAsync(Category entity, CancellationToken cancellationToken = default);
    }
}

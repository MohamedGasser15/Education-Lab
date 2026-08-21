using EduLab_Domain.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_Domain.IRepository
{
    /// <summary>
    /// Repository interface for instructor application data operations
    /// </summary>
    public interface IInstructorApplicationRepository : IRepository<InstructorApplication>
    {
        /// <summary>
        /// Updates the status of an instructor application
        /// </summary>
        /// <param name="applicationId">Application identifier</param>
        /// <param name="status">New application status</param>
        /// <param name="reviewedByUserId">Identifier of the reviewing user</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Task representing the asynchronous operation</returns>
        Task UpdateStatusAsync(Guid applicationId, string status, string reviewedByUserId, CancellationToken cancellationToken = default);
    }
}

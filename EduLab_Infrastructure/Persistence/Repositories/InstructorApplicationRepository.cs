using EduLab_Domain.Entities;
using EduLab_Domain.RepoInterfaces;
using EduLab_Infrastructure.DB;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using System;
using System.Threading;
using System.Threading.Tasks;

namespace EduLab_Infrastructure.Persistence.Repositories
{
    /// <summary>
    /// Repository implementation for InstructorApplication entity
    /// </summary>
    public class InstructorApplicationRepository
            : Repository<InstructorApplication>, IInstructorApplicationRepository
    {
        private readonly ApplicationDbContext _db;
        private readonly ILogger<InstructorApplicationRepository> _logger;

        /// <summary>
        /// Initializes a new instance of the InstructorApplicationRepository class
        /// </summary>
        /// <param name="db">Application database context</param>
        /// <param name="logger">Logger instance</param>
        public InstructorApplicationRepository(ApplicationDbContext db, ILogger<InstructorApplicationRepository> logger) : base(db, logger)
        {
            _db = db;
            _logger = logger;
        }

        #region Custom Operations

        /// <summary>
        /// Update the status of an instructor application
        /// </summary>
        /// <param name="applicationId">Application identifier</param>
        /// <param name="status">New status to set</param>
        /// <param name="reviewedByUserId">User ID who reviewed the application</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <exception cref="KeyNotFoundException">Thrown when application is not found</exception>
        public async Task UpdateStatusAsync(Guid applicationId, string status, string reviewedByUserId, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogDebug("Updating status for application {ApplicationId} to {Status}", applicationId, status);

                var application = await _db.InstructorApplications.FindAsync(new object[] { applicationId }, cancellationToken);
                if (application == null)
                {
                    _logger.LogWarning("Application {ApplicationId} not found", applicationId);
                    throw new KeyNotFoundException("الطلب غير موجود");
                }

                application.Status = status;
                application.ReviewedDate = DateTime.UtcNow;
                application.ReviewedBy = reviewedByUserId;

                await _db.SaveChangesAsync(cancellationToken);
                _logger.LogInformation("Application {ApplicationId} status updated to {Status}", applicationId, status);
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation cancelled while updating status for application {ApplicationId}", applicationId);
                throw;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while updating status for application {ApplicationId}", applicationId);
                throw;
            }
        }

        #endregion
    }
}
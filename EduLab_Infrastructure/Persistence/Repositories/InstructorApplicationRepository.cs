using EduLab_Domain.Entities;
using EduLab_Domain.RepoInterfaces;
using EduLab_Infrastructure.DB;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_Infrastructure.Persistence.Repositories
{
    public class InstructorApplicationRepository
            : Repository<InstructorApplication>, IInstructorApplicationRepository
    {
        private readonly ApplicationDbContext _db;
        private readonly ILogger<InstructorApplicationRepository> _logger;

        public InstructorApplicationRepository(ApplicationDbContext db, ILogger<InstructorApplicationRepository> logger) : base(db, logger)
        {
            _db = db;
            _logger = logger;
        }

        /// <summary>
        /// Update the status of an instructor application
        /// </summary>
        public async Task UpdateStatusAsync(Guid applicationId, string status, string reviewedByUserId)
        {
            var application = await _db.InstructorApplications.FindAsync(applicationId);
            if (application == null)
                throw new KeyNotFoundException("الطلب غير موجود");

            application.Status = status;
            application.ReviewedDate = DateTime.UtcNow;
            application.ReviewedBy = reviewedByUserId;

            await _db.SaveChangesAsync();
        }
    }
}

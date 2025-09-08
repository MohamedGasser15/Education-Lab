using EduLab_Domain.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_Domain.RepoInterfaces
{
    public interface IInstructorApplicationRepository : IRepository<InstructorApplication>
    {
        Task UpdateStatusAsync(Guid applicationId, string status, string reviewedByUserId, CancellationToken cancellationToken = default);
    }
}

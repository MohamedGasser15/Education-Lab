using EduLab_Shared.DTOs.InstructorApplication;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_Application.ServiceInterfaces
{
    public interface IInstructorApplicationService
    {
        Task<(bool Success, string Message)> SubmitApplication(
            InstructorApplicationDTO applicationDto,
            string userId,
            CancellationToken cancellationToken = default);
        Task<List<InstructorApplicationResponseDto>> GetUserApplications(
            string userId,
            CancellationToken cancellationToken = default);
        Task<InstructorApplicationResponseDto> GetApplicationDetails(
            string userId,
            string applicationId,
            CancellationToken cancellationToken = default);
        Task<List<AdminInstructorApplicationDto>> GetAllApplicationsForAdmin(
            CancellationToken cancellationToken = default);
        Task<(bool Success, string Message)> ApproveApplication(
            string applicationId,
            string reviewedByUserId,
            CancellationToken cancellationToken = default);
        Task<(bool Success, string Message)> RejectApplication(
            string applicationId,
            string reviewedByUserId,
            CancellationToken cancellationToken = default);
    }
}

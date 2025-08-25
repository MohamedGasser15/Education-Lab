using EduLab_Shared.DTOs.Instructor;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_Application.ServiceInterfaces
{
    public interface IInstructorApplicationService
    {
        Task<(bool Success, string Message)> SubmitApplication(InstructorApplicationDTO applicationDto, string userId);
        Task<List<InstructorApplicationResponseDto>> GetUserApplications(string userId);
        Task<InstructorApplicationResponseDto> GetApplicationDetails(string userId, string applicationId);
        Task<List<AdminInstructorApplicationDto>> GetAllApplicationsForAdmin();
        Task<bool> ReviewApplication(string applicationId, string status, string reviewedByUserId);
    }
}

using EduLab_MVC.Models.DTOs.Notifications;
using EduLab_MVC.Models.DTOs.Student;

namespace EduLab_MVC.Services.ServiceInterfaces
{
    public interface IStudentService
    {
        Task<List<StudentDto>> GetStudentsAsync(StudentFilterDto filter);
        Task<StudentsSummaryDto> GetStudentsSummaryAsync();
        Task<List<StudentDto>> GetMyStudentsAsync();
        Task<List<StudentDto>> GetStudentsByInstructorAsync(string instructorId);
        Task<BulkNotificationResultDto> SendNotificationAsync(InstructorNotificationRequestDto request);
        Task<List<StudentNotificationDto>> GetStudentsForNotificationAsync(List<string> selectedStudentIds = null);
        Task<InstructorNotificationSummaryDto> GetNotificationSummaryAsync(List<string> selectedStudentIds = null);
        Task<StudentDetailsDto> GetStudentDetailsAsync(string studentId);
    }
}

using EduLab_Shared.DTOs.Student;

namespace EduLab_Application.ServiceInterfaces
{
    public interface IStudentService
    {
        Task<List<StudentDto>> GetStudentsAsync(StudentFilterDto filter, CancellationToken cancellationToken = default);
        Task<StudentDetailsDto> GetStudentDetailsAsync(string studentId, CancellationToken cancellationToken = default);
        Task<StudentsSummaryDto> GetStudentsSummaryByInstructorAsync(string instructorId, CancellationToken cancellationToken = default);
        Task<List<StudentDto>> GetStudentsByInstructorAsync(string instructorId, CancellationToken cancellationToken = default);
        Task<bool> SendBulkMessageAsync(BulkMessageDto messageDto, CancellationToken cancellationToken = default);
        Task<List<StudentProgressDto>> GetStudentsProgressAsync(List<string> studentIds, CancellationToken cancellationToken = default);
    }
}

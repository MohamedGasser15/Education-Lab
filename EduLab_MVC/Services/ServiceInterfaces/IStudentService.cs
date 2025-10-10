using EduLab_MVC.Models.DTOs.Student;

namespace EduLab_MVC.Services.ServiceInterfaces
{
    public interface IStudentService
    {
        Task<List<StudentDto>> GetStudentsAsync(StudentFilterDto filter);
        Task<StudentsSummaryDto> GetStudentsSummaryAsync();
        Task<List<StudentDto>> GetMyStudentsAsync();
        Task<List<StudentDto>> GetStudentsByInstructorAsync(string instructorId);
        Task<StudentDetailsDto> GetStudentDetailsAsync(string studentId);
        Task<bool> SendBulkMessageAsync(BulkMessageDto messageDto);
    }
}

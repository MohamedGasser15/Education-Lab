using EduLab_Domain.Entities;
using EduLab_Shared.DTOs.Student;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_Domain.RepoInterfaces
{
    public interface IStudentRepository
    {
        Task<List<ApplicationUser>> GetStudentsAsync(StudentFilterDto filter, CancellationToken cancellationToken = default);
        Task<ApplicationUser> GetStudentByIdAsync(string studentId, CancellationToken cancellationToken = default);

        Task<List<ApplicationUser>> GetStudentsByInstructorAsync(string instructorId, CancellationToken cancellationToken = default);
        Task<List<StudentEnrollmentDto>> GetStudentEnrollmentsAsync(string studentId, CancellationToken cancellationToken = default);
        Task<List<StudentActivityDto>> GetStudentActivitiesAsync(string studentId, int count = 10, CancellationToken cancellationToken = default);
        Task<StudentsSummaryDto> GetStudentsSummaryByInstructorAsync(string instructorId, CancellationToken cancellationToken = default);
        Task<List<StudentProgressDto>> GetStudentsProgressAsync(List<string> studentIds, CancellationToken cancellationToken = default);
        Task<int> GetStudentsCountAsync(StudentFilterDto filter, CancellationToken cancellationToken = default);
    }
}

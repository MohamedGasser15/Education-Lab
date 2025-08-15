using EduLab_Domain.Entities;
using EduLab_Shared.DTOs.Course;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_Domain.RepoInterfaces
{
    public interface ICourseRepository : IRepository<Course>
    {
        Task<IEnumerable<Course>> GetCoursesByInstructorAsync(string instructorId);
        Task<IEnumerable<Course>> GetCoursesWithCategoryAsync(int categoryId);
        Task<Course> GetCourseByIdAsync(int id, bool isTracking = false);
        Task<Course> AddAsync(Course course);
        Task<Course> UpdateAsync(Course course);
        Task<bool> DeleteAsync(int id);
        Task<bool> BulkDeleteAsync(List<int> ids);
        Task<bool> BulkUpdateStatusAsync(List<int> ids, Coursestatus status);
        Task<bool> UpdateStatusAsync(int courseId, Coursestatus status);
    }
}

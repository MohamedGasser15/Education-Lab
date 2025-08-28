using EduLab_Domain.Entities;
using EduLab_Shared.DTOs.Course;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_Application.ServiceInterfaces
{
    public interface ICourseService
    {
        Task<IEnumerable<CourseDTO>> GetAllCoursesAsync();
        Task<CourseDTO> GetCourseByIdAsync(int id);
        Task<IEnumerable<CourseDTO>> GetInstructorCoursesAsync(string instructorId);
        Task<CourseDTO> AddCourseAsync(CourseCreateDTO course);

        Task<IEnumerable<CourseDTO>> GetApprovedCoursesByInstructorAsync(string instructorId, int count);
        Task<CourseDTO> AddCourseAsInstructorAsync(CourseCreateDTO courseDto);
        Task<CourseDTO> UpdateCourseAsync(CourseUpdateDTO course);
        Task<CourseDTO> UpdateCourseAsInstructorAsync(CourseUpdateDTO courseDto);
        Task<bool> DeleteCourseAsync(int id);
        Task<bool> DeleteCourseAsInstructorAsync(int id);
        Task<IEnumerable<CourseDTO>> GetCoursesByInstructorAsync(string instructorId);
        Task<IEnumerable<CourseDTO>> GetLatestInstructorCoursesAsync(string instructorId, int? count = null);
        Task<IEnumerable<CourseDTO>> GetCoursesWithCategoryAsync(int categoryId);
        Task<bool> BulkDeleteCoursesAsync(List<int> ids);
        Task<bool> BulkDeleteCoursesAsInstructorAsync(List<int> ids);
        Task<bool> BulkPublishCoursesAsync(List<int> ids);
        Task<bool> BulkUnpublishCoursesAsync(List<int> ids);
        Task<bool> AcceptCourseAsync(int id);
        Task<bool> RejectCourseAsync(int id);
        Task<IEnumerable<CourseDTO>> GetApprovedCoursesByCategoriesAsync(List<int> categoryIds, int countPerCategory);
        Task<IEnumerable<CourseDTO>> GetApprovedCoursesByCategoryAsync(int categoryId, int count);
    }
}

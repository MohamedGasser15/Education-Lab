using EduLab_MVC.Models.DTOs.Course;
using System;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;

namespace EduLab_MVC.Services.ServiceInterfaces
{
    public interface ICourseService
    {
        #region Public Course Operations
        Task<List<CourseDTO>> GetAllCoursesAsync(CancellationToken cancellationToken = default);
        Task<CourseDTO?> GetCourseByIdAsync(int id, CancellationToken cancellationToken = default);
        Task<List<CourseDTO>> GetCoursesByInstructorAsync(string instructorId, CancellationToken cancellationToken = default);
        Task<List<CourseDTO>> GetCoursesWithCategoryAsync(int categoryId, CancellationToken cancellationToken = default);
        #endregion

        #region Approved Courses Operations
        Task<List<CourseDTO>> GetApprovedCoursesByInstructorAsync(string instructorId, int count = 0, CancellationToken cancellationToken = default);
        Task<List<CourseDTO>> GetApprovedCoursesByCategoriesAsync(List<int> categoryIds, int countPerCategory = 10, CancellationToken cancellationToken = default);
        Task<List<CourseDTO>> GetApprovedCoursesByCategoryAsync(int categoryId, int count = 10, CancellationToken cancellationToken = default);
        #endregion

        #region Course Management Operations
        Task<CourseDTO> AddCourseAsync(CourseCreateDTO course, CancellationToken cancellationToken = default);
        Task<LectureResourceDTO> AddResourceToLectureAsync(int lectureId, IFormFile resourceFile, CancellationToken cancellationToken = default);
        Task<bool> DeleteResourceAsync(int resourceId, CancellationToken cancellationToken = default);
        Task<List<LectureResourceDTO>> GetLectureResourcesAsync(int lectureId, CancellationToken cancellationToken = default);
        Task<CourseDTO?> UpdateCourseAsync(int id, CourseUpdateDTO course, CancellationToken cancellationToken = default);
        Task<bool> DeleteCourseAsync(int id, CancellationToken cancellationToken = default);
        #endregion

        #region Status Management
        Task<bool> AcceptCourseAsync(int id, CancellationToken cancellationToken = default);
        Task<bool> RejectCourseAsync(int id, CancellationToken cancellationToken = default);
        Task<bool> BulkDeleteCoursesAsync(List<int> ids, CancellationToken cancellationToken = default);
        #endregion

        #region Instructor Course Operations
        Task<List<CourseDTO>> GetInstructorCoursesAsync(CancellationToken cancellationToken = default);
        Task<CourseDTO?> AddCourseAsInstructorAsync(CourseCreateDTO course, CancellationToken cancellationToken = default);
        Task<CourseDTO?> CreateCourseDraftAsync(CourseDraftDTO draftDto, CancellationToken cancellationToken = default);
        Task<CourseDTO?> UpdateCourseDetailsAsync(int id, CourseUpdateDTO course, CancellationToken cancellationToken = default);
        Task<CourseDTO?> UpdateCourseAsInstructorAsync(int id, CourseUpdateDTO course, CancellationToken cancellationToken = default);
        Task<bool> DeleteCourseAsInstructorAsync(int id, CancellationToken cancellationToken = default);
        Task<bool> BulkDeleteCoursesAsInstructorAsync(List<int> ids, CancellationToken cancellationToken = default);
        #endregion

        #region Section Operations
        Task<SectionDTO?> AddSectionAsync(int courseId, SectionCreateDTO sectionDto, CancellationToken cancellationToken = default);
        Task<SectionDTO?> UpdateSectionAsync(int sectionId, SectionUpdateDTO sectionDto, CancellationToken cancellationToken = default);
        Task<bool> DeleteSectionAsync(int sectionId, CancellationToken cancellationToken = default);
        Task<bool> ReorderSectionsAsync(int courseId, List<int> sectionIds, CancellationToken cancellationToken = default);
        Task<SectionDTO?> GetSectionByIdAsync(int sectionId, CancellationToken cancellationToken = default);
        #endregion

        #region Lecture Operations
        Task<LectureDTO?> AddLectureAsync(int sectionId, LectureCreateDTO lectureDto, CancellationToken cancellationToken = default);
        Task<LectureDTO?> UpdateLectureAsync(int lectureId, LectureUpdateDTO lectureDto, CancellationToken cancellationToken = default);
        Task<bool> DeleteLectureAsync(int lectureId, CancellationToken cancellationToken = default);
        Task<bool> ReorderLecturesAsync(int sectionId, List<int> lectureIds, CancellationToken cancellationToken = default);
        Task<LectureDTO?> GetLectureByIdAsync(int lectureId, CancellationToken cancellationToken = default);
        #endregion

        #region Publish Operations
        Task<PublishResultDTO?> PublishCourseAsync(int courseId, CancellationToken cancellationToken = default);
        #endregion
    }
}

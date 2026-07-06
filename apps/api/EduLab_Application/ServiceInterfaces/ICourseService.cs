using EduLab_Domain.Entities;
using EduLab_Application.DTOs.Course;
using EduLab_Application.DTOs.Lecture;
using EduLab_Application.DTOs.Section;
using Microsoft.AspNetCore.Http;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace EduLab_Application.ServiceInterfaces
{
    /// <summary>
    /// Service interface for course operations
    /// </summary>
    public interface ICourseService
    {
        #region Course Retrieval
        Task<List<LectureResourceDTO>> GetLectureResourcesAsync(int lectureId, CancellationToken cancellationToken = default);
        Task<IEnumerable<CourseDTO>> GetAllCoursesAsync(CancellationToken cancellationToken = default);
        Task<LectureResourceDTO> AddResourceToLectureAsync(int lectureId, IFormFile resourceFile, CancellationToken cancellationToken = default);
        Task<bool> DeleteResourceAsync(int resourceId, CancellationToken cancellationToken = default);
        Task<CourseDTO> GetCourseByIdAsync(int id, CancellationToken cancellationToken = default);
        Task<IEnumerable<CourseDTO>> GetInstructorCoursesAsync(string instructorId, CancellationToken cancellationToken = default);
        Task<IEnumerable<CourseDTO>> GetLatestInstructorCoursesAsync(string instructorId, int? count = null, CancellationToken cancellationToken = default);
        Task<IEnumerable<CourseDTO>> GetCoursesWithCategoryAsync(int categoryId, CancellationToken cancellationToken = default);
        Task<IEnumerable<CourseDTO>> GetApprovedCoursesByInstructorAsync(string instructorId, int count, CancellationToken cancellationToken = default);
        Task<IEnumerable<CourseDTO>> GetApprovedCoursesByCategoriesAsync(List<int> categoryIds, int countPerCategory, CancellationToken cancellationToken = default);
        Task<IEnumerable<CourseDTO>> GetApprovedCoursesByCategoryAsync(int categoryId, int count, CancellationToken cancellationToken = default);
        #endregion

        #region Course Management
        Task<CourseDTO> AddCourseAsync(CourseCreateDTO courseDto, CancellationToken cancellationToken = default);
        Task<CourseDTO> AddCourseAsInstructorAsync(CourseCreateDTO courseDto, CancellationToken cancellationToken = default);
        Task<CourseDTO> CreateCourseDraftAsync(CourseDraftDTO draftDto, CancellationToken cancellationToken = default);
        Task<CourseDTO> UpdateCourseAsync(CourseUpdateDTO courseDto, CancellationToken cancellationToken = default);
        Task<CourseDTO> UpdateCourseAsInstructorAsync(CourseUpdateDTO courseDto, CancellationToken cancellationToken = default);
        Task<CourseDTO> UpdateCourseDetailsAsync(int courseId, CourseUpdateDTO courseDto, CancellationToken cancellationToken = default);
        Task<bool> DeleteCourseAsync(int id, CancellationToken cancellationToken = default);
        Task<bool> DeleteCourseAsInstructorAsync(int id, CancellationToken cancellationToken = default);
        #endregion

        #region Section Operations
        Task<SectionDTO> AddSectionAsync(SectionCreateDTO sectionDto, CancellationToken cancellationToken = default);
        Task<SectionDTO> UpdateSectionAsync(int sectionId, SectionUpdateDTO sectionDto, CancellationToken cancellationToken = default);
        Task<bool> DeleteSectionAsync(int sectionId, CancellationToken cancellationToken = default);
        Task<bool> ReorderSectionsAsync(int courseId, List<int> sectionIds, CancellationToken cancellationToken = default);
        Task<SectionDTO> GetSectionByIdAsync(int sectionId, CancellationToken cancellationToken = default);
        #endregion

        #region Lecture Operations
        Task<LectureDTO> AddLectureAsync(LectureCreateDTO lectureDto, CancellationToken cancellationToken = default);
        Task<LectureDTO> UpdateLectureAsync(int lectureId, LectureUpdateDTO lectureDto, CancellationToken cancellationToken = default);
        Task<bool> DeleteLectureAsync(int lectureId, CancellationToken cancellationToken = default);
        Task<bool> ReorderLecturesAsync(int sectionId, List<int> lectureIds, CancellationToken cancellationToken = default);
        Task<LectureDTO> GetLectureByIdAsync(int lectureId, CancellationToken cancellationToken = default);
        #endregion

        #region Publish Operations
        Task<PublishResultDTO> PublishCourseAsync(int courseId, CancellationToken cancellationToken = default);
        Task<PublishResultDTO> AdminPublishCourseAsync(int courseId, CancellationToken cancellationToken = default);
        Task<List<string>> ValidateCourseForPublishAsync(int courseId, CancellationToken cancellationToken = default);
        #endregion

        #region Bulk Operations
        Task<bool> BulkDeleteCoursesAsync(List<int> ids, CancellationToken cancellationToken = default);
        Task<bool> BulkDeleteCoursesAsInstructorAsync(List<int> ids, CancellationToken cancellationToken = default);
        Task<bool> BulkPublishCoursesAsync(List<int> ids, CancellationToken cancellationToken = default);
        Task<bool> BulkUnpublishCoursesAsync(List<int> ids, CancellationToken cancellationToken = default);
        #endregion

        #region Status Management
        Task<bool> AcceptCourseAsync(int id, CancellationToken cancellationToken = default);
        Task<bool> RejectCourseAsync(int id, CancellationToken cancellationToken = default);
        #endregion
    }
}

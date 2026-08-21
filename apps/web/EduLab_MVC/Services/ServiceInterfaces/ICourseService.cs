using EduLab_MVC.Models.DTOs.Course;
using System;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;

namespace EduLab_MVC.Services.ServiceInterfaces
{
    /// <summary>
    /// Interface for course operations in the MVC application.
    /// </summary>
    public interface ICourseService
    {
        #region Public Course Operations
        /// <summary>
        /// Retrieves all courses.
        /// </summary>
        Task<List<CourseDTO>> GetAllCoursesAsync(CancellationToken cancellationToken = default);

        /// <summary>
        /// Retrieves a course by its ID.
        /// </summary>
        Task<CourseDTO?> GetCourseByIdAsync(int id, CancellationToken cancellationToken = default);

        /// <summary>
        /// Retrieves the courses created by a specific instructor.
        /// </summary>
        Task<List<CourseDTO>> GetCoursesByInstructorAsync(string instructorId, CancellationToken cancellationToken = default);

        /// <summary>
        /// Retrieves the courses belonging to a specific category.
        /// </summary>
        Task<List<CourseDTO>> GetCoursesWithCategoryAsync(int categoryId, CancellationToken cancellationToken = default);
        #endregion

        #region Approved Courses Operations
        /// <summary>
        /// Retrieves approved courses for an instructor.
        /// </summary>
        Task<List<CourseDTO>> GetApprovedCoursesByInstructorAsync(string instructorId, int count = 0, CancellationToken cancellationToken = default);

        /// <summary>
        /// Retrieves approved courses for a list of categories.
        /// </summary>
        Task<List<CourseDTO>> GetApprovedCoursesByCategoriesAsync(List<int> categoryIds, int countPerCategory = 10, CancellationToken cancellationToken = default);

        /// <summary>
        /// Retrieves approved courses for a single category.
        /// </summary>
        Task<List<CourseDTO>> GetApprovedCoursesByCategoryAsync(int categoryId, int count = 10, CancellationToken cancellationToken = default);
        #endregion

        #region Course Management Operations
        /// <summary>
        /// Adds a new course.
        /// </summary>
        Task<CourseDTO> AddCourseAsync(CourseCreateDTO course, CancellationToken cancellationToken = default);

        /// <summary>
        /// Adds a resource file to a lecture.
        /// </summary>
        Task<LectureResourceDTO> AddResourceToLectureAsync(int lectureId, IFormFile resourceFile, CancellationToken cancellationToken = default);

        /// <summary>
        /// Deletes a lecture resource.
        /// </summary>
        Task<bool> DeleteResourceAsync(int resourceId, CancellationToken cancellationToken = default);

        /// <summary>
        /// Retrieves the resources of a lecture.
        /// </summary>
        Task<List<LectureResourceDTO>> GetLectureResourcesAsync(int lectureId, CancellationToken cancellationToken = default);

        /// <summary>
        /// Updates an existing course.
        /// </summary>
        Task<CourseDTO?> UpdateCourseAsync(int id, CourseUpdateDTO course, CancellationToken cancellationToken = default);

        /// <summary>
        /// Deletes a course.
        /// </summary>
        Task<bool> DeleteCourseAsync(int id, CancellationToken cancellationToken = default);
        #endregion

        #region Status Management
        /// <summary>
        /// Accepts a course.
        /// </summary>
        Task<bool> AcceptCourseAsync(int id, CancellationToken cancellationToken = default);

        /// <summary>
        /// Rejects a course with an optional rejection reason.
        /// </summary>
        Task<bool> RejectCourseAsync(int id, string? rejectionReason = null, CancellationToken cancellationToken = default);

        /// <summary>
        /// Deletes multiple courses in bulk.
        /// </summary>
        Task<bool> BulkDeleteCoursesAsync(List<int> ids, CancellationToken cancellationToken = default);
        #endregion

        #region Instructor Course Operations
        /// <summary>
        /// Retrieves the current instructor's courses.
        /// </summary>
        Task<List<CourseDTO>> GetInstructorCoursesAsync(CancellationToken cancellationToken = default);

        /// <summary>
        /// Adds a new course as an instructor.
        /// </summary>
        Task<CourseDTO?> AddCourseAsInstructorAsync(CourseCreateDTO course, CancellationToken cancellationToken = default);

        /// <summary>
        /// Creates a course draft as an instructor.
        /// </summary>
        Task<CourseDTO?> CreateCourseDraftAsync(CourseDraftDTO draftDto, CancellationToken cancellationToken = default);

        /// <summary>
        /// Updates the details of a course as an instructor.
        /// </summary>
        Task<CourseDTO?> UpdateCourseDetailsAsync(int id, CourseUpdateDTO course, CancellationToken cancellationToken = default);

        /// <summary>
        /// Updates a course as an instructor.
        /// </summary>
        Task<CourseDTO?> UpdateCourseAsInstructorAsync(int id, CourseUpdateDTO course, CancellationToken cancellationToken = default);

        /// <summary>
        /// Deletes a course as an instructor.
        /// </summary>
        Task<bool> DeleteCourseAsInstructorAsync(int id, CancellationToken cancellationToken = default);

        /// <summary>
        /// Deletes multiple courses in bulk as an instructor.
        /// </summary>
        Task<bool> BulkDeleteCoursesAsInstructorAsync(List<int> ids, CancellationToken cancellationToken = default);
        #endregion

        #region Section Operations
        /// <summary>
        /// Adds a section to a course.
        /// </summary>
        Task<SectionDTO?> AddSectionAsync(int courseId, SectionCreateDTO sectionDto, CancellationToken cancellationToken = default);

        /// <summary>
        /// Updates a course section.
        /// </summary>
        Task<SectionDTO?> UpdateSectionAsync(int sectionId, SectionUpdateDTO sectionDto, CancellationToken cancellationToken = default);

        /// <summary>
        /// Deletes a course section.
        /// </summary>
        Task<bool> DeleteSectionAsync(int sectionId, CancellationToken cancellationToken = default);

        /// <summary>
        /// Reorders the sections of a course.
        /// </summary>
        Task<bool> ReorderSectionsAsync(int courseId, List<int> sectionIds, CancellationToken cancellationToken = default);

        /// <summary>
        /// Retrieves a section by its ID.
        /// </summary>
        Task<SectionDTO?> GetSectionByIdAsync(int sectionId, CancellationToken cancellationToken = default);
        #endregion

        #region Lecture Operations
        /// <summary>
        /// Adds a lecture to a section.
        /// </summary>
        Task<LectureDTO?> AddLectureAsync(int sectionId, LectureCreateDTO lectureDto, CancellationToken cancellationToken = default);

        /// <summary>
        /// Updates a lecture.
        /// </summary>
        Task<LectureDTO?> UpdateLectureAsync(int lectureId, LectureUpdateDTO lectureDto, CancellationToken cancellationToken = default);

        /// <summary>
        /// Deletes a lecture.
        /// </summary>
        Task<bool> DeleteLectureAsync(int lectureId, CancellationToken cancellationToken = default);

        /// <summary>
        /// Reorders the lectures of a section.
        /// </summary>
        Task<bool> ReorderLecturesAsync(int sectionId, List<int> lectureIds, CancellationToken cancellationToken = default);

        /// <summary>
        /// Retrieves a lecture by its ID.
        /// </summary>
        Task<LectureDTO?> GetLectureByIdAsync(int lectureId, CancellationToken cancellationToken = default);
        #endregion

        #region Publish Operations
        /// <summary>
        /// Publishes a course.
        /// </summary>
        Task<PublishResultDTO?> PublishCourseAsync(int courseId, CancellationToken cancellationToken = default);
        #endregion

        #region Admin Course Operations
        /// <summary>
        /// Creates a course draft as an admin.
        /// </summary>
        Task<CourseDTO?> AdminCreateCourseDraftAsync(CourseDraftDTO draftDto, CancellationToken cancellationToken = default);

        /// <summary>
        /// Adds a section to a course as an admin.
        /// </summary>
        Task<SectionDTO?> AdminAddSectionAsync(int courseId, SectionCreateDTO sectionDto, CancellationToken cancellationToken = default);

        /// <summary>
        /// Updates a course section as an admin.
        /// </summary>
        Task<SectionDTO?> AdminUpdateSectionAsync(int sectionId, SectionUpdateDTO sectionDto, CancellationToken cancellationToken = default);

        /// <summary>
        /// Deletes a course section as an admin.
        /// </summary>
        Task<bool> AdminDeleteSectionAsync(int sectionId, CancellationToken cancellationToken = default);

        /// <summary>
        /// Adds a lecture to a section as an admin.
        /// </summary>
        Task<LectureDTO?> AdminAddLectureAsync(int sectionId, LectureCreateDTO lectureDto, CancellationToken cancellationToken = default);

        /// <summary>
        /// Updates a lecture as an admin.
        /// </summary>
        Task<LectureDTO?> AdminUpdateLectureAsync(int lectureId, LectureUpdateDTO lectureDto, CancellationToken cancellationToken = default);

        /// <summary>
        /// Deletes a lecture as an admin.
        /// </summary>
        Task<bool> AdminDeleteLectureAsync(int lectureId, CancellationToken cancellationToken = default);

        /// <summary>
        /// Publishes a course as an admin.
        /// </summary>
        Task<PublishResultDTO?> AdminPublishCourseAsync(int courseId, CancellationToken cancellationToken = default);
        #endregion
    }
}

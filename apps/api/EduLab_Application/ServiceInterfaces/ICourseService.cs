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

        /// <summary>
        /// Retrieves all resources for a specific lecture
        /// </summary>
        /// <param name="lectureId">Unique identifier of the lecture</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>List of lecture resource DTOs</returns>
        Task<List<LectureResourceDTO>> GetLectureResourcesAsync(int lectureId, CancellationToken cancellationToken = default);

        /// <summary>
        /// Retrieves all courses
        /// </summary>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>List of course DTOs</returns>
        Task<IEnumerable<CourseDTO>> GetAllCoursesAsync(CancellationToken cancellationToken = default);

        /// <summary>
        /// Adds a resource file to a lecture
        /// </summary>
        /// <param name="lectureId">Unique identifier of the lecture</param>
        /// <param name="resourceFile">The resource file to upload</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>The created lecture resource DTO</returns>
        Task<LectureResourceDTO> AddResourceToLectureAsync(int lectureId, IFormFile resourceFile, CancellationToken cancellationToken = default);

        /// <summary>
        /// Deletes a resource by its ID
        /// </summary>
        /// <param name="resourceId">Unique identifier of the resource</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>True if the resource was deleted, otherwise false</returns>
        Task<bool> DeleteResourceAsync(int resourceId, CancellationToken cancellationToken = default);

        /// <summary>
        /// Retrieves a course by its ID
        /// </summary>
        /// <param name="id">Unique identifier of the course</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>Course DTO or null if not found</returns>
        Task<CourseDTO> GetCourseByIdAsync(int id, CancellationToken cancellationToken = default);

        /// <summary>
        /// Retrieves all courses of a specific instructor
        /// </summary>
        /// <param name="instructorId">Unique identifier of the instructor</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>List of course DTOs</returns>
        Task<IEnumerable<CourseDTO>> GetInstructorCoursesAsync(string instructorId, CancellationToken cancellationToken = default);

        /// <summary>
        /// Retrieves the latest courses of an instructor
        /// </summary>
        /// <param name="instructorId">Unique identifier of the instructor</param>
        /// <param name="count">Optional maximum number of courses to return</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>List of course DTOs</returns>
        Task<IEnumerable<CourseDTO>> GetLatestInstructorCoursesAsync(string instructorId, int? count = null, CancellationToken cancellationToken = default);

        /// <summary>
        /// Retrieves the courses of a specific category
        /// </summary>
        /// <param name="categoryId">Unique identifier of the category</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>List of course DTOs</returns>
        Task<IEnumerable<CourseDTO>> GetCoursesWithCategoryAsync(int categoryId, CancellationToken cancellationToken = default);

        /// <summary>
        /// Retrieves approved courses of an instructor
        /// </summary>
        /// <param name="instructorId">Unique identifier of the instructor</param>
        /// <param name="count">Maximum number of courses to return</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>List of course DTOs</returns>
        Task<IEnumerable<CourseDTO>> GetApprovedCoursesByInstructorAsync(string instructorId, int count, CancellationToken cancellationToken = default);

        /// <summary>
        /// Retrieves approved courses grouped by the given categories
        /// </summary>
        /// <param name="categoryIds">List of category identifiers</param>
        /// <param name="countPerCategory">Maximum number of courses per category</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>List of course DTOs</returns>
        Task<IEnumerable<CourseDTO>> GetApprovedCoursesByCategoriesAsync(List<int> categoryIds, int countPerCategory, CancellationToken cancellationToken = default);

        /// <summary>
        /// Retrieves approved courses of a specific category
        /// </summary>
        /// <param name="categoryId">Unique identifier of the category</param>
        /// <param name="count">Maximum number of courses to return</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>List of course DTOs</returns>
        Task<IEnumerable<CourseDTO>> GetApprovedCoursesByCategoryAsync(int categoryId, int count, CancellationToken cancellationToken = default);

        #endregion

        #region Course Management

        /// <summary>
        /// Adds a new course
        /// </summary>
        /// <param name="courseDto">Course creation data</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>The created course DTO</returns>
        Task<CourseDTO> AddCourseAsync(CourseCreateDTO courseDto, CancellationToken cancellationToken = default);

        /// <summary>
        /// Adds a new course on behalf of an instructor
        /// </summary>
        /// <param name="courseDto">Course creation data</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>The created course DTO</returns>
        Task<CourseDTO> AddCourseAsInstructorAsync(CourseCreateDTO courseDto, CancellationToken cancellationToken = default);

        /// <summary>
        /// Creates a new course as a draft
        /// </summary>
        /// <param name="draftDto">Course draft creation data</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>The created course DTO</returns>
        Task<CourseDTO> CreateCourseDraftAsync(CourseDraftDTO draftDto, CancellationToken cancellationToken = default);

        /// <summary>
        /// Updates an existing course
        /// </summary>
        /// <param name="courseDto">Course update data</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>The updated course DTO</returns>
        Task<CourseDTO> UpdateCourseAsync(CourseUpdateDTO courseDto, CancellationToken cancellationToken = default);

        /// <summary>
        /// Updates an existing course on behalf of an instructor
        /// </summary>
        /// <param name="courseDto">Course update data</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>The updated course DTO</returns>
        Task<CourseDTO> UpdateCourseAsInstructorAsync(CourseUpdateDTO courseDto, CancellationToken cancellationToken = default);

        /// <summary>
        /// Updates the details of an existing course
        /// </summary>
        /// <param name="courseId">Unique identifier of the course</param>
        /// <param name="courseDto">Course update data</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>The updated course DTO</returns>
        Task<CourseDTO> UpdateCourseDetailsAsync(int courseId, CourseUpdateDTO courseDto, CancellationToken cancellationToken = default);

        /// <summary>
        /// Deletes a course by its ID
        /// </summary>
        /// <param name="id">Unique identifier of the course</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>True if the course was deleted, otherwise false</returns>
        Task<bool> DeleteCourseAsync(int id, CancellationToken cancellationToken = default);

        /// <summary>
        /// Deletes a course by its ID on behalf of an instructor
        /// </summary>
        /// <param name="id">Unique identifier of the course</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>True if the course was deleted, otherwise false</returns>
        Task<bool> DeleteCourseAsInstructorAsync(int id, CancellationToken cancellationToken = default);

        #endregion

        #region Section Operations

        /// <summary>
        /// Adds a new section to a course
        /// </summary>
        /// <param name="sectionDto">Section creation data</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>The created section DTO</returns>
        Task<SectionDTO> AddSectionAsync(SectionCreateDTO sectionDto, CancellationToken cancellationToken = default);

        /// <summary>
        /// Updates an existing section
        /// </summary>
        /// <param name="sectionId">Unique identifier of the section</param>
        /// <param name="sectionDto">Section update data</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>The updated section DTO</returns>
        Task<SectionDTO> UpdateSectionAsync(int sectionId, SectionUpdateDTO sectionDto, CancellationToken cancellationToken = default);

        /// <summary>
        /// Deletes a section by its ID
        /// </summary>
        /// <param name="sectionId">Unique identifier of the section</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>True if the section was deleted, otherwise false</returns>
        Task<bool> DeleteSectionAsync(int sectionId, CancellationToken cancellationToken = default);

        /// <summary>
        /// Reorders the sections of a course
        /// </summary>
        /// <param name="courseId">Unique identifier of the course</param>
        /// <param name="sectionIds">List of section identifiers in the new order</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>True if the sections were reordered, otherwise false</returns>
        Task<bool> ReorderSectionsAsync(int courseId, List<int> sectionIds, CancellationToken cancellationToken = default);

        /// <summary>
        /// Retrieves a section by its ID
        /// </summary>
        /// <param name="sectionId">Unique identifier of the section</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>The section DTO or null if not found</returns>
        Task<SectionDTO> GetSectionByIdAsync(int sectionId, CancellationToken cancellationToken = default);

        #endregion

        #region Lecture Operations

        /// <summary>
        /// Adds a new lecture to a section
        /// </summary>
        /// <param name="lectureDto">Lecture creation data</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>The created lecture DTO</returns>
        Task<LectureDTO> AddLectureAsync(LectureCreateDTO lectureDto, CancellationToken cancellationToken = default);

        /// <summary>
        /// Updates an existing lecture
        /// </summary>
        /// <param name="lectureId">Unique identifier of the lecture</param>
        /// <param name="lectureDto">Lecture update data</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>The updated lecture DTO</returns>
        Task<LectureDTO> UpdateLectureAsync(int lectureId, LectureUpdateDTO lectureDto, CancellationToken cancellationToken = default);

        /// <summary>
        /// Deletes a lecture by its ID
        /// </summary>
        /// <param name="lectureId">Unique identifier of the lecture</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>True if the lecture was deleted, otherwise false</returns>
        Task<bool> DeleteLectureAsync(int lectureId, CancellationToken cancellationToken = default);

        /// <summary>
        /// Reorders the lectures of a section
        /// </summary>
        /// <param name="sectionId">Unique identifier of the section</param>
        /// <param name="lectureIds">List of lecture identifiers in the new order</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>True if the lectures were reordered, otherwise false</returns>
        Task<bool> ReorderLecturesAsync(int sectionId, List<int> lectureIds, CancellationToken cancellationToken = default);

        /// <summary>
        /// Retrieves a lecture by its ID
        /// </summary>
        /// <param name="lectureId">Unique identifier of the lecture</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>The lecture DTO or null if not found</returns>
        Task<LectureDTO> GetLectureByIdAsync(int lectureId, CancellationToken cancellationToken = default);

        /// <summary>
        /// Resolves the course ID that contains a given lecture
        /// </summary>
        /// <param name="lectureId">Unique identifier of the lecture</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>The course ID or null if not found</returns>
        Task<int?> GetCourseIdByLectureAsync(int lectureId, CancellationToken cancellationToken = default);

        /// <summary>
        /// Resolves the course ID that owns a given resource
        /// </summary>
        /// <param name="resourceId">Unique identifier of the resource</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>The course ID or null if not found</returns>
        Task<int?> GetCourseIdByResourceAsync(int resourceId, CancellationToken cancellationToken = default);

        #endregion

        #region Publish Operations

        /// <summary>
        /// Publishes a course by the instructor, submitting it for review
        /// </summary>
        /// <param name="courseId">Unique identifier of the course</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>Publish result with validation errors if any</returns>
        Task<PublishResultDTO> PublishCourseAsync(int courseId, CancellationToken cancellationToken = default);

        /// <summary>
        /// Publishes a course by an admin, making it available to students
        /// </summary>
        /// <param name="courseId">Unique identifier of the course</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>Publish result with validation errors if any</returns>
        Task<PublishResultDTO> AdminPublishCourseAsync(int courseId, CancellationToken cancellationToken = default);

        /// <summary>
        /// Validates a course for publishing
        /// </summary>
        /// <param name="courseId">Unique identifier of the course</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>List of validation errors, empty if valid</returns>
        Task<List<string>> ValidateCourseForPublishAsync(int courseId, CancellationToken cancellationToken = default);

        #endregion

        #region Bulk Operations

        /// <summary>
        /// Deletes multiple courses at once
        /// </summary>
        /// <param name="ids">List of course identifiers to delete</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>True if the courses were deleted, otherwise false</returns>
        Task<bool> BulkDeleteCoursesAsync(List<int> ids, CancellationToken cancellationToken = default);

        /// <summary>
        /// Deletes multiple courses at once on behalf of an instructor
        /// </summary>
        /// <param name="ids">List of course identifiers to delete</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>True if the courses were deleted, otherwise false</returns>
        Task<bool> BulkDeleteCoursesAsInstructorAsync(List<int> ids, CancellationToken cancellationToken = default);

        /// <summary>
        /// Publishes multiple courses at once
        /// </summary>
        /// <param name="ids">List of course identifiers to publish</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>True if the courses were published, otherwise false</returns>
        Task<bool> BulkPublishCoursesAsync(List<int> ids, CancellationToken cancellationToken = default);

        /// <summary>
        /// Unpublishes multiple courses at once
        /// </summary>
        /// <param name="ids">List of course identifiers to unpublish</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>True if the courses were unpublished, otherwise false</returns>
        Task<bool> BulkUnpublishCoursesAsync(List<int> ids, CancellationToken cancellationToken = default);

        #endregion

        #region Status Management

        /// <summary>
        /// Accepts (approves) a course by its ID
        /// </summary>
        /// <param name="id">Unique identifier of the course</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>True if the course was accepted, otherwise false</returns>
        Task<bool> AcceptCourseAsync(int id, CancellationToken cancellationToken = default);

        /// <summary>
        /// Rejects a course by its ID
        /// </summary>
        /// <param name="id">Unique identifier of the course</param>
        /// <param name="rejectionReason">Optional reason for the rejection</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>True if the course was rejected, otherwise false</returns>
        Task<bool> RejectCourseAsync(int id, string? rejectionReason = null, CancellationToken cancellationToken = default);

        #endregion
    }
}
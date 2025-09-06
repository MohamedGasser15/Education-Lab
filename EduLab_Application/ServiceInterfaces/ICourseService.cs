using EduLab_Domain.Entities;
using EduLab_Shared.DTOs.Course;
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
        /// Gets all courses
        /// </summary>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>List of course DTOs</returns>
        Task<IEnumerable<CourseDTO>> GetAllCoursesAsync(CancellationToken cancellationToken = default);

        /// <summary>
        /// Gets course by ID
        /// </summary>
        /// <param name="id">Course identifier</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Course DTO</returns>
        Task<CourseDTO> GetCourseByIdAsync(int id, CancellationToken cancellationToken = default);

        /// <summary>
        /// Gets instructor courses
        /// </summary>
        /// <param name="instructorId">Instructor identifier</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>List of course DTOs</returns>
        Task<IEnumerable<CourseDTO>> GetInstructorCoursesAsync(string instructorId, CancellationToken cancellationToken = default);

        /// <summary>
        /// Gets latest instructor courses
        /// </summary>
        /// <param name="instructorId">Instructor identifier</param>
        /// <param name="count">Number of courses to return</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>List of course DTOs</returns>
        Task<IEnumerable<CourseDTO>> GetLatestInstructorCoursesAsync(string instructorId, int? count = null, CancellationToken cancellationToken = default);

        /// <summary>
        /// Gets courses with category
        /// </summary>
        /// <param name="categoryId">Category identifier</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>List of course DTOs</returns>
        Task<IEnumerable<CourseDTO>> GetCoursesWithCategoryAsync(int categoryId, CancellationToken cancellationToken = default);

        /// <summary>
        /// Gets approved courses by instructor
        /// </summary>
        /// <param name="instructorId">Instructor identifier</param>
        /// <param name="count">Number of courses to return</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>List of course DTOs</returns>
        Task<IEnumerable<CourseDTO>> GetApprovedCoursesByInstructorAsync(string instructorId, int count, CancellationToken cancellationToken = default);

        /// <summary>
        /// Gets approved courses by categories
        /// </summary>
        /// <param name="categoryIds">List of category IDs</param>
        /// <param name="countPerCategory">Number of courses per category</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>List of course DTOs</returns>
        Task<IEnumerable<CourseDTO>> GetApprovedCoursesByCategoriesAsync(List<int> categoryIds, int countPerCategory, CancellationToken cancellationToken = default);

        /// <summary>
        /// Gets approved courses by category
        /// </summary>
        /// <param name="categoryId">Category identifier</param>
        /// <param name="count">Number of courses to return</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>List of course DTOs</returns>
        Task<IEnumerable<CourseDTO>> GetApprovedCoursesByCategoryAsync(int categoryId, int count, CancellationToken cancellationToken = default);

        #endregion

        #region Course Management

        /// <summary>
        /// Adds a new course
        /// </summary>
        /// <param name="courseDto">Course creation DTO</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Created course DTO</returns>
        Task<CourseDTO> AddCourseAsync(CourseCreateDTO courseDto, CancellationToken cancellationToken = default);

        /// <summary>
        /// Adds a new course as instructor
        /// </summary>
        /// <param name="courseDto">Course creation DTO</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Created course DTO</returns>
        Task<CourseDTO> AddCourseAsInstructorAsync(CourseCreateDTO courseDto, CancellationToken cancellationToken = default);

        /// <summary>
        /// Updates an existing course
        /// </summary>
        /// <param name="courseDto">Course update DTO</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Updated course DTO</returns>
        Task<CourseDTO> UpdateCourseAsync(CourseUpdateDTO courseDto, CancellationToken cancellationToken = default);

        /// <summary>
        /// Updates an existing course as instructor
        /// </summary>
        /// <param name="courseDto">Course update DTO</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Updated course DTO</returns>
        Task<CourseDTO> UpdateCourseAsInstructorAsync(CourseUpdateDTO courseDto, CancellationToken cancellationToken = default);

        /// <summary>
        /// Deletes a course
        /// </summary>
        /// <param name="id">Course identifier</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>True if deleted successfully</returns>
        Task<bool> DeleteCourseAsync(int id, CancellationToken cancellationToken = default);

        /// <summary>
        /// Deletes a course as instructor
        /// </summary>
        /// <param name="id">Course identifier</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>True if deleted successfully</returns>
        Task<bool> DeleteCourseAsInstructorAsync(int id, CancellationToken cancellationToken = default);

        #endregion

        #region Bulk Operations

        /// <summary>
        /// Bulk delete courses
        /// </summary>
        /// <param name="ids">List of course IDs</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>True if bulk delete successful</returns>
        Task<bool> BulkDeleteCoursesAsync(List<int> ids, CancellationToken cancellationToken = default);

        /// <summary>
        /// Bulk delete courses as instructor
        /// </summary>
        /// <param name="ids">List of course IDs</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>True if bulk delete successful</returns>
        Task<bool> BulkDeleteCoursesAsInstructorAsync(List<int> ids, CancellationToken cancellationToken = default);

        /// <summary>
        /// Bulk publish courses
        /// </summary>
        /// <param name="ids">List of course IDs</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>True if bulk publish successful</returns>
        Task<bool> BulkPublishCoursesAsync(List<int> ids, CancellationToken cancellationToken = default);

        /// <summary>
        /// Bulk unpublish courses
        /// </summary>
        /// <param name="ids">List of course IDs</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>True if bulk unpublish successful</returns>
        Task<bool> BulkUnpublishCoursesAsync(List<int> ids, CancellationToken cancellationToken = default);

        #endregion

        #region Status Management

        /// <summary>
        /// Accepts a course
        /// </summary>
        /// <param name="id">Course identifier</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>True if accepted successfully</returns>
        Task<bool> AcceptCourseAsync(int id, CancellationToken cancellationToken = default);

        /// <summary>
        /// Rejects a course
        /// </summary>
        /// <param name="id">Course identifier</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>True if rejected successfully</returns>
        Task<bool> RejectCourseAsync(int id, CancellationToken cancellationToken = default);

        #endregion
    }
}
using EduLab_Domain.Entities;
using EduLab_Shared.DTOs.Course;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace EduLab_Domain.RepoInterfaces
{
    /// <summary>
    /// Repository interface for Course entity operations
    /// </summary>
    public interface ICourseRepository : IRepository<Course>
    {
        #region Course Operations

        /// <summary>
        /// Gets courses by instructor ID
        /// </summary>
        /// <param name="instructorId">Instructor identifier</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>List of courses</returns>
        Task<IEnumerable<Course>> GetCoursesByInstructorAsync(string instructorId, CancellationToken cancellationToken = default);

        /// <summary>
        /// Gets courses with category information
        /// </summary>
        /// <param name="categoryId">Category identifier</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>List of courses with category</returns>
        Task<IEnumerable<Course>> GetCoursesWithCategoryAsync(int categoryId, CancellationToken cancellationToken = default);

        /// <summary>
        /// Gets approved courses by instructor with count limit
        /// </summary>
        /// <param name="instructorId">Instructor identifier</param>
        /// <param name="count">Number of courses to return</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>List of approved courses</returns>
        Task<IEnumerable<Course>> GetApprovedCoursesByInstructorAsync(string instructorId, int count, CancellationToken cancellationToken = default);

        Task<List<LectureResource>> GetLectureResourcesAsync(int lectureId, CancellationToken cancellationToken = default);

        Task<LectureResource> AddResourceAsync(LectureResource resource, CancellationToken cancellationToken = default);

        // أسلوب لحذف Resource
        Task<bool> DeleteResourceAsync(int resourceId, CancellationToken cancellationToken = default);

        /// <summary>
        /// Gets course by ID with optional tracking
        /// </summary>
        /// <param name="id">Course identifier</param>
        /// <param name="isTracking">Whether to enable entity tracking</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Course entity</returns>
        Task<Course> GetCourseByIdAsync(int id, bool isTracking = false, CancellationToken cancellationToken = default);

        /// <summary>
        /// Adds a new course
        /// </summary>
        /// <param name="course">Course entity to add</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Added course</returns>
        Task<Course> AddAsync(Course course, CancellationToken cancellationToken = default);

        /// <summary>
        /// Updates an existing course
        /// </summary>
        /// <param name="course">Course entity to update</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Updated course</returns>
        Task<Course> UpdateAsync(Course course, CancellationToken cancellationToken = default);

        /// <summary>
        /// Deletes a course by ID
        /// </summary>
        /// <param name="id">Course identifier</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>True if deleted successfully</returns>
        Task<bool> DeleteAsync(int id, CancellationToken cancellationToken = default);

        #endregion

        #region Bulk Operations

        /// <summary>
        /// Bulk delete courses by IDs
        /// </summary>
        /// <param name="ids">List of course IDs</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>True if bulk delete successful</returns>
        Task<bool> BulkDeleteAsync(List<int> ids, CancellationToken cancellationToken = default);

        /// <summary>
        /// Bulk update course status
        /// </summary>
        /// <param name="ids">List of course IDs</param>
        /// <param name="status">New status to set</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>True if bulk update successful</returns>
        Task<bool> BulkUpdateStatusAsync(List<int> ids, Coursestatus status, CancellationToken cancellationToken = default);

        /// <summary>
        /// Updates course status
        /// </summary>
        /// <param name="courseId">Course identifier</param>
        /// <param name="status">New status</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>True if update successful</returns>
        Task<bool> UpdateStatusAsync(int courseId, Coursestatus status, CancellationToken cancellationToken = default);

        #endregion

        #region Approved Courses Operations

        /// <summary>
        /// Gets approved courses by multiple categories
        /// </summary>
        /// <param name="categoryIds">List of category IDs</param>
        /// <param name="countPerCategory">Number of courses per category</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>List of approved courses</returns>
        Task<IEnumerable<Course>> GetApprovedCoursesByCategoriesAsync(List<int> categoryIds, int countPerCategory, CancellationToken cancellationToken = default);

        /// <summary>
        /// Gets approved courses by category
        /// </summary>
        /// <param name="categoryId">Category identifier</param>
        /// <param name="count">Number of courses to return</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>List of approved courses</returns>
        Task<IEnumerable<Course>> GetApprovedCoursesByCategoryAsync(int categoryId, int count, CancellationToken cancellationToken = default);

        #endregion
    }
}
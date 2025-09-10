using EduLab_MVC.Models.DTOs.Course;
using System;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;

namespace EduLab_MVC.Services.ServiceInterfaces
{
    /// <summary>
    /// Interface for managing course operations in MVC application
    /// </summary>
    public interface ICourseService
    {
        #region Public Course Operations

        /// <summary>
        /// Gets all courses
        /// </summary>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>List of all courses</returns>
        Task<List<CourseDTO>> GetAllCoursesAsync(CancellationToken cancellationToken = default);

        /// <summary>
        /// Gets a course by ID
        /// </summary>
        /// <param name="id">Course ID</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Course details</returns>
        Task<CourseDTO?> GetCourseByIdAsync(int id, CancellationToken cancellationToken = default);

        /// <summary>
        /// Gets courses by instructor ID
        /// </summary>
        /// <param name="instructorId">Instructor ID</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>List of courses by instructor</returns>
        Task<List<CourseDTO>> GetCoursesByInstructorAsync(string instructorId, CancellationToken cancellationToken = default);

        /// <summary>
        /// Gets courses with category
        /// </summary>
        /// <param name="categoryId">Category ID</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>List of courses in category</returns>
        Task<List<CourseDTO>> GetCoursesWithCategoryAsync(int categoryId, CancellationToken cancellationToken = default);

        #endregion

        #region Approved Courses Operations

        /// <summary>
        /// Gets approved courses by instructor
        /// </summary>
        /// <param name="instructorId">Instructor ID</param>
        /// <param name="count">Number of courses to return</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>List of approved courses by instructor</returns>
        Task<List<CourseDTO>> GetApprovedCoursesByInstructorAsync(string instructorId, int count = 0, CancellationToken cancellationToken = default);

        /// <summary>
        /// Gets approved courses by categories
        /// </summary>
        /// <param name="categoryIds">List of category IDs</param>
        /// <param name="countPerCategory">Number of courses per category</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>List of approved courses by categories</returns>
        Task<List<CourseDTO>> GetApprovedCoursesByCategoriesAsync(List<int> categoryIds, int countPerCategory = 10, CancellationToken cancellationToken = default);

        /// <summary>
        /// Gets approved courses by category
        /// </summary>
        /// <param name="categoryId">Category ID</param>
        /// <param name="count">Number of courses to return</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>List of approved courses by category</returns>
        Task<List<CourseDTO>> GetApprovedCoursesByCategoryAsync(int categoryId, int count = 10, CancellationToken cancellationToken = default);

        #endregion

        #region Course Management Operations

        /// <summary>
        /// Adds a new course
        /// </summary>
        /// <param name="course">Course data</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Created course</returns>
        Task<CourseDTO> AddCourseAsync(CourseCreateDTO course, CancellationToken cancellationToken = default);

        /// <summary>
        /// Updates an existing course
        /// </summary>
        /// <param name="id">Course ID</param>
        /// <param name="course">Updated course data</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Updated course</returns>
        Task<CourseDTO?> UpdateCourseAsync(int id, CourseUpdateDTO course, CancellationToken cancellationToken = default);

        /// <summary>
        /// Deletes a course
        /// </summary>
        /// <param name="id">Course ID</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>True if deleted successfully</returns>
        Task<bool> DeleteCourseAsync(int id, CancellationToken cancellationToken = default);

        #endregion

        #region Bulk Operations

        /// <summary>
        /// Bulk delete courses
        /// </summary>
        /// <param name="ids">List of course IDs</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>True if bulk delete successful</returns>
        Task<bool> BulkDeleteCoursesAsync(List<int> ids, CancellationToken cancellationToken = default);

        #endregion

        #region Status Management

        /// <summary>
        /// Accepts a course
        /// </summary>
        /// <param name="id">Course ID</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>True if accepted successfully</returns>
        Task<bool> AcceptCourseAsync(int id, CancellationToken cancellationToken = default);

        /// <summary>
        /// Rejects a course
        /// </summary>
        /// <param name="id">Course ID</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>True if rejected successfully</returns>
        Task<bool> RejectCourseAsync(int id, CancellationToken cancellationToken = default);

        #endregion

        #region Instructor Course Operations

        /// <summary>
        /// Gets courses for the current instructor
        /// </summary>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>List of instructor's courses</returns>
        Task<List<CourseDTO>> GetInstructorCoursesAsync(CancellationToken cancellationToken = default);

        /// <summary>
        /// Adds a new course as instructor
        /// </summary>
        /// <param name="course">Course data</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Created course</returns>
        Task<CourseDTO?> AddCourseAsInstructorAsync(CourseCreateDTO course, CancellationToken cancellationToken = default);

        /// <summary>
        /// Updates an existing course as instructor
        /// </summary>
        /// <param name="id">Course ID</param>
        /// <param name="course">Updated course data</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Updated course</returns>
        Task<CourseDTO?> UpdateCourseAsInstructorAsync(int id, CourseUpdateDTO course, CancellationToken cancellationToken = default);

        /// <summary>
        /// Deletes a course as instructor
        /// </summary>
        /// <param name="id">Course ID</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>True if deleted successfully</returns>
        Task<bool> DeleteCourseAsInstructorAsync(int id, CancellationToken cancellationToken = default);

        /// <summary>
        /// Bulk delete courses as instructor
        /// </summary>
        /// <param name="ids">List of course IDs</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>True if bulk delete successful</returns>
        Task<bool> BulkDeleteCoursesAsInstructorAsync(List<int> ids, CancellationToken cancellationToken = default);

        #endregion
    }
}
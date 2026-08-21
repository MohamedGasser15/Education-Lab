using EduLab_Domain.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace EduLab_Domain.IRepository
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

        /// <summary>
        /// Gets lecture resources by lecture ID
        /// </summary>
        /// <param name="lectureId">Lecture identifier</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>List of lecture resources</returns>
        Task<List<LectureResource>> GetLectureResourcesAsync(int lectureId, CancellationToken cancellationToken = default);

        /// <summary>
        /// Adds a new resource to a lecture
        /// </summary>
        /// <param name="resource">Resource entity to add</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>The added resource</returns>
        Task<LectureResource> AddResourceAsync(LectureResource resource, CancellationToken cancellationToken = default);

        /// <summary>
        /// Deletes a resource by ID
        /// </summary>
        /// <param name="resourceId">Resource identifier</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>True if deleted successfully</returns>
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

        #region Section Operations

        /// <summary>
        /// Adds a new section to a course
        /// </summary>
        /// <param name="section">Section entity to add</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>The added section</returns>
        Task<Section> AddSectionAsync(Section section, CancellationToken cancellationToken = default);

        /// <summary>
        /// Updates an existing section
        /// </summary>
        /// <param name="section">Section entity with updated values</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>The updated section</returns>
        Task<Section> UpdateSectionAsync(Section section, CancellationToken cancellationToken = default);

        /// <summary>
        /// Deletes a section by ID
        /// </summary>
        /// <param name="sectionId">Section identifier</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>True if deleted successfully</returns>
        Task<bool> DeleteSectionAsync(int sectionId, CancellationToken cancellationToken = default);

        /// <summary>
        /// Reorders the sections of a course
        /// </summary>
        /// <param name="courseId">Course identifier</param>
        /// <param name="sectionIds">Section IDs in the desired order</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>True if reordering successful</returns>
        Task<bool> ReorderSectionsAsync(int courseId, List<int> sectionIds, CancellationToken cancellationToken = default);

        /// <summary>
        /// Gets a section by ID
        /// </summary>
        /// <param name="sectionId">Section identifier</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>The section entity</returns>
        Task<Section> GetSectionByIdAsync(int sectionId, CancellationToken cancellationToken = default);

        /// <summary>
        /// Clears the free-preview flag on all other sections of a course
        /// </summary>
        /// <param name="courseId">Course identifier</param>
        /// <param name="exceptSectionId">Section to keep as free preview</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Task representing the asynchronous operation</returns>
        Task UnsetFreePreviewForOtherSectionsAsync(int courseId, int exceptSectionId, CancellationToken cancellationToken = default);

        #endregion

        #region Lecture Operations

        /// <summary>
        /// Adds a new lecture to a section
        /// </summary>
        /// <param name="lecture">Lecture entity to add</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>The added lecture</returns>
        Task<Lecture> AddLectureAsync(Lecture lecture, CancellationToken cancellationToken = default);

        /// <summary>
        /// Updates an existing lecture
        /// </summary>
        /// <param name="lecture">Lecture entity with updated values</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>The updated lecture</returns>
        Task<Lecture> UpdateLectureAsync(Lecture lecture, CancellationToken cancellationToken = default);

        /// <summary>
        /// Deletes a lecture by ID
        /// </summary>
        /// <param name="lectureId">Lecture identifier</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>True if deleted successfully</returns>
        Task<bool> DeleteLectureAsync(int lectureId, CancellationToken cancellationToken = default);

        /// <summary>
        /// Reorders the lectures of a section
        /// </summary>
        /// <param name="sectionId">Section identifier</param>
        /// <param name="lectureIds">Lecture IDs in the desired order</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>True if reordering successful</returns>
        Task<bool> ReorderLecturesAsync(int sectionId, List<int> lectureIds, CancellationToken cancellationToken = default);

        /// <summary>
        /// Gets a lecture by ID
        /// </summary>
        /// <param name="lectureId">Lecture identifier</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>The lecture entity</returns>
        Task<Lecture> GetLectureByIdAsync(int lectureId, CancellationToken cancellationToken = default);

        /// <summary>
        /// Gets the course ID associated with a lecture
        /// </summary>
        /// <param name="lectureId">Lecture identifier</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Course ID or null</returns>
        Task<int?> GetCourseIdByLectureAsync(int lectureId, CancellationToken cancellationToken = default);

        /// <summary>
        /// Gets the course ID associated with a resource
        /// </summary>
        /// <param name="resourceId">Resource identifier</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Course ID or null</returns>
        Task<int?> GetCourseIdByResourceAsync(int resourceId, CancellationToken cancellationToken = default);

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
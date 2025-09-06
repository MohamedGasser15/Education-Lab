using AutoMapper;
using EduLab_Domain.Entities;
using EduLab_Domain.RepoInterfaces;
using EduLab_Infrastructure.DB;
using EduLab_Shared.DTOs.Course;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;

namespace EduLab_Infrastructure.Persistence.Repositories
{
    /// <summary>
    /// Repository implementation for Course entity operations
    /// </summary>
    public class CourseRepository : Repository<Course>, ICourseRepository
    {
        private readonly ApplicationDbContext _db;
        private readonly IMapper _mapper;
        private readonly ILogger<CourseRepository> _logger;

        /// <summary>
        /// Initializes a new instance of the CourseRepository class
        /// </summary>
        /// <param name="db">Application database context</param>
        /// <param name="mapper">AutoMapper instance</param>
        /// <param name="logger">Logger instance</param>
        public CourseRepository(ApplicationDbContext db, IMapper mapper, ILogger<CourseRepository> logger) : base(db, logger)
        {
            _db = db;
            _mapper = mapper;
            _logger = logger;
        }

        #region Course Operations

        /// <summary>
        /// Adds a new course with sections and lectures
        /// </summary>
        public async Task<Course> AddAsync(Course course, CancellationToken cancellationToken = default)
        {
            using var transaction = await _db.Database.BeginTransactionAsync(cancellationToken);

            try
            {
                _logger.LogInformation("Adding new course: {CourseTitle}", course.Title);

                course.CreatedAt = DateTime.UtcNow;

                if (course.Sections != null)
                {
                    foreach (var section in course.Sections)
                    {
                        section.Course = course;
                        if (section.Lectures != null)
                        {
                            foreach (var lecture in section.Lectures)
                            {
                                lecture.Section = section;
                            }
                        }
                    }
                }

                await _db.Courses.AddAsync(course, cancellationToken);
                await _db.SaveChangesAsync(cancellationToken);
                await transaction.CommitAsync(cancellationToken);

                _logger.LogInformation("Course added successfully. ID: {CourseId}, Title: {CourseTitle}", course.Id, course.Title);
                return course;
            }
            catch (Exception ex)
            {
                await transaction.RollbackAsync(cancellationToken);
                _logger.LogError(ex, "Error adding course: {CourseTitle}", course.Title);
                throw;
            }
        }

        /// <summary>
        /// Updates an existing course with sections and lectures
        /// </summary>
        public async Task<Course> UpdateAsync(Course course, CancellationToken cancellationToken = default)
        {
            using var transaction = await _db.Database.BeginTransactionAsync(cancellationToken);

            try
            {
                _logger.LogInformation("Updating course ID: {CourseId}", course.Id);

                var existingCourse = await _db.Courses
                    .Include(c => c.Sections)
                    .ThenInclude(s => s.Lectures)
                    .FirstOrDefaultAsync(c => c.Id == course.Id, cancellationToken);

                if (existingCourse == null)
                {
                    _logger.LogWarning("Course not found for update. ID: {CourseId}", course.Id);
                    return null;
                }

                // Update course properties
                _db.Entry(existingCourse).CurrentValues.SetValues(course);

                // Handle Sections
                await UpdateSectionsAsync(existingCourse, course, cancellationToken);

                await _db.SaveChangesAsync(cancellationToken);
                await transaction.CommitAsync(cancellationToken);

                _logger.LogInformation("Course updated successfully. ID: {CourseId}", course.Id);
                return existingCourse;
            }
            catch (Exception ex)
            {
                await transaction.RollbackAsync(cancellationToken);
                _logger.LogError(ex, "Error updating course ID: {CourseId}", course.Id);
                throw;
            }
        }

        /// <summary>
        /// Deletes a course by ID
        /// </summary>
        public async Task<bool> DeleteAsync(int id, CancellationToken cancellationToken = default)
        {
            using var transaction = await _db.Database.BeginTransactionAsync(cancellationToken);

            try
            {
                _logger.LogInformation("Deleting course ID: {CourseId}", id);

                var course = await _db.Courses
                    .Include(c => c.Sections)
                    .ThenInclude(s => s.Lectures)
                    .FirstOrDefaultAsync(c => c.Id == id, cancellationToken);

                if (course == null)
                {
                    _logger.LogWarning("Course not found for deletion. ID: {CourseId}", id);
                    return false;
                }

                _db.Courses.Remove(course);
                await _db.SaveChangesAsync(cancellationToken);
                await transaction.CommitAsync(cancellationToken);

                _logger.LogInformation("Course deleted successfully. ID: {CourseId}", id);
                return true;
            }
            catch (Exception ex)
            {
                await transaction.RollbackAsync(cancellationToken);
                _logger.LogError(ex, "Error deleting course ID: {CourseId}", id);
                throw;
            }
        }

        /// <summary>
        /// Gets courses by instructor ID
        /// </summary>
        public async Task<IEnumerable<Course>> GetCoursesByInstructorAsync(string instructorId, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogDebug("Getting courses for instructor ID: {InstructorId}", instructorId);

                return await _db.Courses
                    .Include(c => c.Category)
                    .Include(c => c.Sections)
                    .ThenInclude(s => s.Lectures)
                    .Where(c => c.InstructorId == instructorId)
                    .ToListAsync(cancellationToken);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting courses for instructor ID: {InstructorId}", instructorId);
                throw;
            }
        }

        /// <summary>
        /// Gets approved courses by instructor with count limit
        /// </summary>
        public async Task<IEnumerable<Course>> GetApprovedCoursesByInstructorAsync(string instructorId, int count, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogDebug("Getting {Count} approved courses for instructor ID: {InstructorId}", count, instructorId);

                return await _db.Courses
                    .Include(c => c.Category)
                    .Include(c => c.Instructor)
                    .Include(c => c.Sections)
                    .ThenInclude(s => s.Lectures)
                    .Where(c => c.InstructorId == instructorId && c.Status == Coursestatus.Approved)
                    .OrderByDescending(c => c.CreatedAt)
                    .Take(count)
                    .ToListAsync(cancellationToken);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting approved courses for instructor ID: {InstructorId}", instructorId);
                throw;
            }
        }

        /// <summary>
        /// Gets courses with category information
        /// </summary>
        public async Task<IEnumerable<Course>> GetCoursesWithCategoryAsync(int categoryId, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogDebug("Getting courses for category ID: {CategoryId}", categoryId);

                return await _db.Courses
                    .Include(c => c.Category)
                    .Include(c => c.Instructor)
                    .Include(c => c.Sections)
                    .ThenInclude(s => s.Lectures)
                    .Where(c => c.CategoryId == categoryId)
                    .ToListAsync(cancellationToken);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting courses for category ID: {CategoryId}", categoryId);
                throw;
            }
        }

        /// <summary>
        /// Gets course by ID with optional tracking
        /// </summary>
        public async Task<Course> GetCourseByIdAsync(int id, bool isTracking = false, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogDebug("Getting course by ID: {CourseId}, Tracking: {IsTracking}", id, isTracking);

                IQueryable<Course> query = isTracking ? _db.Courses : _db.Courses.AsNoTracking();

                return await query
                    .Include(c => c.Category)
                    .Include(c => c.Instructor)
                    .Include(c => c.Sections)
                    .ThenInclude(s => s.Lectures)
                    .FirstOrDefaultAsync(c => c.Id == id, cancellationToken);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting course by ID: {CourseId}", id);
                throw;
            }
        }

        #endregion

        #region Bulk Operations

        /// <summary>
        /// Bulk delete courses by IDs
        /// </summary>
        public async Task<bool> BulkDeleteAsync(List<int> ids, CancellationToken cancellationToken = default)
        {
            using var transaction = await _db.Database.BeginTransactionAsync(cancellationToken);

            try
            {
                _logger.LogInformation("Bulk deleting courses. Count: {Count}", ids.Count);

                var courses = await _db.Courses
                    .Where(c => ids.Contains(c.Id))
                    .ToListAsync(cancellationToken);

                if (!courses.Any())
                {
                    _logger.LogWarning("No courses found for bulk deletion");
                    return false;
                }

                _db.Courses.RemoveRange(courses);
                await _db.SaveChangesAsync(cancellationToken);
                await transaction.CommitAsync(cancellationToken);

                _logger.LogInformation("Bulk delete completed successfully. Count: {Count}", courses.Count);
                return true;
            }
            catch (Exception ex)
            {
                await transaction.RollbackAsync(cancellationToken);
                _logger.LogError(ex, "Error in bulk delete operation");
                throw;
            }
        }

        /// <summary>
        /// Bulk update course status
        /// </summary>
        public async Task<bool> BulkUpdateStatusAsync(List<int> ids, Coursestatus status, CancellationToken cancellationToken = default)
        {
            using var transaction = await _db.Database.BeginTransactionAsync(cancellationToken);

            try
            {
                _logger.LogInformation("Bulk updating course status. Count: {Count}, Status: {Status}", ids.Count, status);

                var courses = await _db.Courses
                    .Where(c => ids.Contains(c.Id))
                    .ToListAsync(cancellationToken);

                if (!courses.Any())
                {
                    _logger.LogWarning("No courses found for bulk status update");
                    return false;
                }

                foreach (var course in courses)
                {
                    course.Status = status;
                }

                await _db.SaveChangesAsync(cancellationToken);
                await transaction.CommitAsync(cancellationToken);

                _logger.LogInformation("Bulk status update completed successfully. Count: {Count}", courses.Count);
                return true;
            }
            catch (Exception ex)
            {
                await transaction.RollbackAsync(cancellationToken);
                _logger.LogError(ex, "Error in bulk status update operation");
                throw;
            }
        }

        /// <summary>
        /// Updates course status
        /// </summary>
        public async Task<bool> UpdateStatusAsync(int courseId, Coursestatus status, CancellationToken cancellationToken = default)
        {
            using var transaction = await _db.Database.BeginTransactionAsync(cancellationToken);

            try
            {
                _logger.LogInformation("Updating status for course ID: {CourseId} to {Status}", courseId, status);

                var course = await _db.Courses.FindAsync(new object[] { courseId }, cancellationToken);
                if (course == null)
                {
                    _logger.LogWarning("Course not found for status update. ID: {CourseId}", courseId);
                    return false;
                }

                course.Status = status;
                await _db.SaveChangesAsync(cancellationToken);
                await transaction.CommitAsync(cancellationToken);

                _logger.LogInformation("Status updated successfully for course ID: {CourseId}", courseId);
                return true;
            }
            catch (Exception ex)
            {
                await transaction.RollbackAsync(cancellationToken);
                _logger.LogError(ex, "Error updating status for course ID: {CourseId}", courseId);
                throw;
            }
        }

        #endregion

        #region Approved Courses Operations

        /// <summary>
        /// Gets approved courses by multiple categories
        /// </summary>
        public async Task<IEnumerable<Course>> GetApprovedCoursesByCategoriesAsync(List<int> categoryIds, int countPerCategory, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogDebug("Getting approved courses for {CategoryCount} categories, {CountPerCategory} per category",
                    categoryIds.Count, countPerCategory);

                var result = new List<Course>();

                foreach (var categoryId in categoryIds)
                {
                    var courses = await _db.Courses
                        .Include(c => c.Category)
                        .Include(c => c.Instructor)
                        .Include(c => c.Sections)
                        .ThenInclude(s => s.Lectures)
                        .Where(c => c.CategoryId == categoryId && c.Status == Coursestatus.Approved)
                        .OrderByDescending(c => c.CreatedAt)
                        .Take(countPerCategory)
                        .ToListAsync(cancellationToken);

                    result.AddRange(courses);
                }

                return result;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting approved courses by categories");
                throw;
            }
        }

        /// <summary>
        /// Gets approved courses by category
        /// </summary>
        public async Task<IEnumerable<Course>> GetApprovedCoursesByCategoryAsync(int categoryId, int count, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogDebug("Getting {Count} approved courses for category ID: {CategoryId}", count, categoryId);

                return await _db.Courses
                    .Include(c => c.Category)
                    .Include(c => c.Instructor)
                    .Include(c => c.Sections)
                    .ThenInclude(s => s.Lectures)
                    .Where(c => c.CategoryId == categoryId && c.Status == Coursestatus.Approved)
                    .OrderByDescending(c => c.CreatedAt)
                    .Take(count)
                    .ToListAsync(cancellationToken);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting approved courses for category ID: {CategoryId}", categoryId);
                throw;
            }
        }

        #endregion

        #region Private Helper Methods

        /// <summary>
        /// Updates sections for a course
        /// </summary>
        private async Task UpdateSectionsAsync(Course existingCourse, Course updatedCourse, CancellationToken cancellationToken)
        {
            var existingSectionIds = existingCourse.Sections.Select(s => s.Id).ToList();
            var newSectionIds = updatedCourse.Sections?.Where(s => s.Id > 0).Select(s => s.Id).ToList() ?? new List<int>();

            // Remove sections that are no longer present
            var sectionsToRemove = existingCourse.Sections.Where(s => s.Id > 0 && !newSectionIds.Contains(s.Id)).ToList();
            foreach (var section in sectionsToRemove)
            {
                _db.Sections.Remove(section);
            }

            if (updatedCourse.Sections != null)
            {
                foreach (var section in updatedCourse.Sections)
                {
                    var existingSection = existingCourse.Sections.FirstOrDefault(s => s.Id == section.Id);
                    if (existingSection != null)
                    {
                        // Update existing section
                        _db.Entry(existingSection).CurrentValues.SetValues(section);
                        await UpdateLecturesAsync(existingSection, section, cancellationToken);
                    }
                    else
                    {
                        // Add new section
                        section.CourseId = updatedCourse.Id;
                        existingCourse.Sections.Add(section);
                    }
                }
            }
        }

        /// <summary>
        /// Updates lectures for a section
        /// </summary>
        private async Task UpdateLecturesAsync(Section existingSection, Section updatedSection, CancellationToken cancellationToken)
        {
            var existingLectureIds = existingSection.Lectures?.Select(l => l.Id).ToList() ?? new List<int>();
            var newLectureIds = updatedSection.Lectures?.Where(l => l.Id > 0).Select(l => l.Id).ToList() ?? new List<int>();

            // Remove lectures that are no longer present
            var lecturesToRemove = existingSection.Lectures?.Where(l => l.Id > 0 && !newLectureIds.Contains(l.Id)).ToList() ?? new List<Lecture>();
            foreach (var lecture in lecturesToRemove)
            {
                _db.Lectures.Remove(lecture);
            }

            if (updatedSection.Lectures != null)
            {
                foreach (var lecture in updatedSection.Lectures)
                {
                    var existingLecture = existingSection.Lectures?.FirstOrDefault(l => l.Id == lecture.Id);
                    if (existingLecture != null)
                    {
                        // Update existing lecture
                        _db.Entry(existingLecture).CurrentValues.SetValues(lecture);
                    }
                    else
                    {
                        // Add new lecture
                        lecture.SectionId = existingSection.Id;
                        existingSection.Lectures.Add(lecture);
                    }
                }
            }
        }

        #endregion
    }
}
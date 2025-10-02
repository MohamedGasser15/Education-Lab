using EduLab_Domain.Entities;
using EduLab_Domain.RepoInterfaces;
using EduLab_Infrastructure.DB;
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
    /// Repository for managing course progress data operations
    /// Implements the <see cref="ICourseProgressRepository"/> interface
    /// </summary>
    public class CourseProgressRepository : ICourseProgressRepository
    {
        #region Private Fields

        private readonly ApplicationDbContext _context;
        private readonly ILogger<CourseProgressRepository> _logger;

        #endregion

        #region Constructor

        /// <summary>
        /// Initializes a new instance of the <see cref="CourseProgressRepository"/> class
        /// </summary>
        /// <param name="context">The database context</param>
        /// <param name="logger">The logger instance</param>
        /// <exception cref="ArgumentNullException">Thrown when context or logger is null</exception>
        public CourseProgressRepository(ApplicationDbContext context, ILogger<CourseProgressRepository> logger)
        {
            _context = context ?? throw new ArgumentNullException(nameof(context));
            _logger = logger ?? throw new ArgumentNullException(nameof(logger));
        }

        #endregion

        #region CRUD Operations

        /// <summary>
        /// Retrieves a specific course progress record by enrollment ID and lecture ID
        /// </summary>
        /// <param name="enrollmentId">The enrollment identifier</param>
        /// <param name="lectureId">The lecture identifier</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>
        /// A task that represents the asynchronous operation
        /// The task result contains the course progress record or null if not found
        /// </returns>
        public async Task<CourseProgress> GetProgressAsync(int enrollmentId, int lectureId, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Retrieving progress for enrollment {EnrollmentId} and lecture {LectureId}", enrollmentId, lectureId);

                return await _context.CourseProgresses
                    .AsNoTracking()
                    .FirstOrDefaultAsync(p => p.EnrollmentId == enrollmentId && p.LectureId == lectureId, cancellationToken);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting progress for enrollment {EnrollmentId} and lecture {LectureId}", enrollmentId, lectureId);
                throw;
            }
        }

        /// <summary>
        /// Creates a new course progress record
        /// </summary>
        /// <param name="progress">The course progress entity to create</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>
        /// A task that represents the asynchronous operation
        /// The task result contains the created course progress record
        /// </returns>
        public async Task<CourseProgress> CreateProgressAsync(CourseProgress progress, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Creating new progress record for enrollment {EnrollmentId} and lecture {LectureId}",
                    progress.EnrollmentId, progress.LectureId);

                _context.CourseProgresses.Add(progress);
                await _context.SaveChangesAsync(cancellationToken);

                _logger.LogInformation("Successfully created progress record with ID: {ProgressId}", progress.Id);
                return progress;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error creating progress record for enrollment {EnrollmentId} and lecture {LectureId}",
                    progress.EnrollmentId, progress.LectureId);
                throw;
            }
        }

        /// <summary>
        /// Updates an existing course progress record
        /// </summary>
        /// <param name="progress">The course progress entity to update</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>
        /// A task that represents the asynchronous operation
        /// The task result contains the updated course progress record
        /// </returns>
        public async Task<CourseProgress> UpdateProgressAsync(CourseProgress progress, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Updating progress record with ID: {ProgressId}", progress.Id);

                _context.CourseProgresses.Update(progress);
                await _context.SaveChangesAsync(cancellationToken);

                _logger.LogInformation("Successfully updated progress record with ID: {ProgressId}", progress.Id);
                return progress;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error updating progress record {ProgressId}", progress.Id);
                throw;
            }
        }

        /// <summary>
        /// Deletes a course progress record by its ID
        /// </summary>
        /// <param name="progressId">The progress record identifier</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>
        /// A task that represents the asynchronous operation
        /// The task result contains true if deletion was successful, false if record was not found
        /// </returns>
        public async Task<bool> DeleteProgressAsync(int progressId, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Deleting progress record with ID: {ProgressId}", progressId);

                var progress = await _context.CourseProgresses.FindAsync(new object[] { progressId }, cancellationToken);
                if (progress != null)
                {
                    _context.CourseProgresses.Remove(progress);
                    await _context.SaveChangesAsync(cancellationToken);

                    _logger.LogInformation("Successfully deleted progress record with ID: {ProgressId}", progressId);
                    return true;
                }

                _logger.LogWarning("Progress record not found with ID: {ProgressId}", progressId);
                return false;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error deleting progress record {ProgressId}", progressId);
                throw;
            }
        }

        #endregion

        #region Query Operations

        /// <summary>
        /// Retrieves all progress records for a specific enrollment
        /// </summary>
        /// <param name="enrollmentId">The enrollment identifier</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>
        /// A task that represents the asynchronous operation
        /// The task result contains a list of course progress records
        /// </returns>
        public async Task<List<CourseProgress>> GetProgressByEnrollmentAsync(int enrollmentId, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Retrieving all progress records for enrollment {EnrollmentId}", enrollmentId);

                return await _context.CourseProgresses
                    .AsNoTracking()
                    .Where(p => p.EnrollmentId == enrollmentId)
                    .Include(p => p.Lecture)
                    .ToListAsync(cancellationToken);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting progress for enrollment {EnrollmentId}", enrollmentId);
                throw;
            }
        }

        /// <summary>
        /// Gets the count of completed lectures for a specific enrollment
        /// </summary>
        /// <param name="enrollmentId">The enrollment identifier</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>
        /// A task that represents the asynchronous operation
        /// The task result contains the count of completed lectures
        /// </returns>
        public async Task<int> GetCompletedLecturesCountAsync(int enrollmentId, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Getting completed lectures count for enrollment {EnrollmentId}", enrollmentId);

                return await _context.CourseProgresses
                    .AsNoTracking()
                    .CountAsync(p => p.EnrollmentId == enrollmentId && p.IsCompleted, cancellationToken);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting completed lectures count for enrollment {EnrollmentId}", enrollmentId);
                throw;
            }
        }

        /// <summary>
        /// Checks if a specific lecture is completed for a given enrollment
        /// </summary>
        /// <param name="enrollmentId">The enrollment identifier</param>
        /// <param name="lectureId">The lecture identifier</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>
        /// A task that represents the asynchronous operation
        /// The task result contains true if the lecture is completed, false otherwise
        /// </returns>
        public async Task<bool> IsLectureCompletedAsync(int enrollmentId, int lectureId, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Checking if lecture {LectureId} is completed for enrollment {EnrollmentId}", lectureId, enrollmentId);

                return await _context.CourseProgresses
                    .AsNoTracking()
                    .AnyAsync(p => p.EnrollmentId == enrollmentId && p.LectureId == lectureId && p.IsCompleted, cancellationToken);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error checking if lecture {LectureId} is completed for enrollment {EnrollmentId}", lectureId, enrollmentId);
                throw;
            }
        }

        #endregion

        #region Progress Calculation Operations

        /// <summary>
        /// Calculates the course progress percentage for a specific enrollment
        /// </summary>
        /// <param name="enrollmentId">The enrollment identifier</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>
        /// A task that represents the asynchronous operation
        /// The task result contains the progress percentage (0-100)
        /// </returns>
        public async Task<decimal> GetCourseProgressPercentageAsync(int enrollmentId, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Calculating progress percentage for enrollment {EnrollmentId}", enrollmentId);

                var enrollment = await _context.Enrollments
                    .AsNoTracking()
                    .Include(e => e.Course)
                        .ThenInclude(c => c.Sections)
                        .ThenInclude(s => s.Lectures)
                    .FirstOrDefaultAsync(e => e.Id == enrollmentId, cancellationToken);

                if (enrollment?.Course?.Sections == null)
                {
                    _logger.LogWarning("Enrollment or course sections not found for enrollment ID: {EnrollmentId}", enrollmentId);
                    return 0;
                }

                var totalLectures = enrollment.Course.Sections.Sum(s => s.Lectures?.Count ?? 0);
                if (totalLectures == 0)
                {
                    _logger.LogWarning("No lectures found for course ID: {CourseId} in enrollment {EnrollmentId}",
                        enrollment.CourseId, enrollmentId);
                    return 0;
                }

                var completedLectures = await GetCompletedLecturesCountAsync(enrollmentId, cancellationToken);
                var percentage = (decimal)completedLectures / totalLectures * 100;

                _logger.LogInformation("Progress percentage for enrollment {EnrollmentId}: {Percentage}% ({Completed}/{Total})",
                    enrollmentId, percentage, completedLectures, totalLectures);

                return percentage;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error calculating progress percentage for enrollment {EnrollmentId}", enrollmentId);
                return 0;
            }
        }

        #endregion
    }
}
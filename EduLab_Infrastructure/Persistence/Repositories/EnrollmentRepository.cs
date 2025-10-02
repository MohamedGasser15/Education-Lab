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
    /// Repository for managing enrollment data operations
    /// Implements the <see cref="IEnrollmentRepository"/> interface
    /// </summary>
    public class EnrollmentRepository : IEnrollmentRepository
    {
        #region Private Fields

        private readonly ApplicationDbContext _context;
        private readonly ILogger<EnrollmentRepository> _logger;

        #endregion

        #region Constructor

        /// <summary>
        /// Initializes a new instance of the <see cref="EnrollmentRepository"/> class
        /// </summary>
        /// <param name="context">The database context</param>
        /// <param name="logger">The logger instance</param>
        /// <exception cref="ArgumentNullException">Thrown when context or logger is null</exception>
        public EnrollmentRepository(ApplicationDbContext context, ILogger<EnrollmentRepository> logger)
        {
            _context = context ?? throw new ArgumentNullException(nameof(context));
            _logger = logger ?? throw new ArgumentNullException(nameof(logger));
        }

        #endregion

        #region CRUD Operations

        /// <summary>
        /// Creates a new enrollment record
        /// </summary>
        /// <param name="enrollment">The enrollment entity to create</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>
        /// A task that represents the asynchronous operation
        /// The task result contains the created enrollment record
        /// </returns>
        public async Task<Enrollment> CreateEnrollmentAsync(Enrollment enrollment, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Creating enrollment for user ID: {UserId} in course ID: {CourseId}",
                    enrollment.UserId, enrollment.CourseId);

                _context.Enrollments.Add(enrollment);
                await _context.SaveChangesAsync(cancellationToken);

                _logger.LogInformation("Successfully created enrollment with ID: {EnrollmentId}", enrollment.Id);
                return enrollment;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error creating enrollment for user ID: {UserId} in course ID: {CourseId}",
                    enrollment.UserId, enrollment.CourseId);
                throw;
            }
        }

        /// <summary>
        /// Deletes an enrollment record by its ID
        /// </summary>
        /// <param name="enrollmentId">The enrollment identifier</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>
        /// A task that represents the asynchronous operation
        /// The task result contains true if deletion was successful, false if record was not found
        /// </returns>
        public async Task<bool> DeleteEnrollmentAsync(int enrollmentId, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Deleting enrollment with ID: {EnrollmentId}", enrollmentId);

                var enrollment = await _context.Enrollments.FindAsync(new object[] { enrollmentId }, cancellationToken);
                if (enrollment != null)
                {
                    _context.Enrollments.Remove(enrollment);
                    await _context.SaveChangesAsync(cancellationToken);

                    _logger.LogInformation("Successfully deleted enrollment with ID: {EnrollmentId}", enrollmentId);
                    return true;
                }

                _logger.LogWarning("Enrollment not found with ID: {EnrollmentId}", enrollmentId);
                return false;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error deleting enrollment with ID: {EnrollmentId}", enrollmentId);
                throw;
            }
        }

        #endregion

        #region Query Operations

        /// <summary>
        /// Retrieves an enrollment record by its ID
        /// </summary>
        /// <param name="enrollmentId">The enrollment identifier</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>
        /// A task that represents the asynchronous operation
        /// The task result contains the enrollment record or null if not found
        /// </returns>
        public async Task<Enrollment> GetEnrollmentByIdAsync(int enrollmentId, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Retrieving enrollment with ID: {EnrollmentId}", enrollmentId);

                return await _context.Enrollments
                    .AsNoTracking()
                    .Include(e => e.Course)
                    .Include(e => e.User)
                    .FirstOrDefaultAsync(e => e.Id == enrollmentId, cancellationToken);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error retrieving enrollment with ID: {EnrollmentId}", enrollmentId);
                throw;
            }
        }

        /// <summary>
        /// Retrieves all enrollments for a specific user
        /// </summary>
        /// <param name="userId">The user identifier</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>
        /// A task that represents the asynchronous operation
        /// The task result contains a collection of enrollment records
        /// </returns>
        public async Task<IEnumerable<Enrollment>> GetUserEnrollmentsAsync(string userId, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Retrieving enrollments for user ID: {UserId}", userId);

                return await _context.Enrollments
                    .AsNoTracking()
                    .Include(e => e.Course)
                        .ThenInclude(c => c.Instructor)
                    .Include(e => e.Course)
                        .ThenInclude(c => c.Category)
                    .Where(e => e.UserId == userId)
                    .OrderByDescending(e => e.EnrolledAt)
                    .ToListAsync(cancellationToken);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error retrieving enrollments for user ID: {UserId}", userId);
                throw;
            }
        }

        /// <summary>
        /// Retrieves a specific user's enrollment in a specific course
        /// </summary>
        /// <param name="userId">The user identifier</param>
        /// <param name="courseId">The course identifier</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>
        /// A task that represents the asynchronous operation
        /// The task result contains the enrollment record or null if not found
        /// </returns>
        public async Task<Enrollment> GetUserCourseEnrollmentAsync(string userId, int courseId, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Retrieving enrollment for user ID: {UserId} in course ID: {CourseId}", userId, courseId);

                return await _context.Enrollments
                    .AsNoTracking()
                    .Include(e => e.Course)
                    .Include(e => e.User)
                    .FirstOrDefaultAsync(e => e.UserId == userId && e.CourseId == courseId, cancellationToken);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error retrieving enrollment for user ID: {UserId} in course ID: {CourseId}", userId, courseId);
                throw;
            }
        }

        /// <summary>
        /// Checks if a user is enrolled in a specific course
        /// </summary>
        /// <param name="userId">The user identifier</param>
        /// <param name="courseId">The course identifier</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>
        /// A task that represents the asynchronous operation
        /// The task result contains true if the user is enrolled, false otherwise
        /// </returns>
        public async Task<bool> IsUserEnrolledInCourseAsync(string userId, int courseId, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Checking if user ID: {UserId} is enrolled in course ID: {CourseId}", userId, courseId);

                return await _context.Enrollments
                    .AsNoTracking()
                    .AnyAsync(e => e.UserId == userId && e.CourseId == courseId, cancellationToken);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error checking enrollment for user ID: {UserId} in course ID: {CourseId}", userId, courseId);
                throw;
            }
        }

        #endregion

        #region Bulk Operations

        /// <summary>
        /// Creates multiple enrollment records in a single operation
        /// </summary>
        /// <param name="enrollments">The collection of enrollment entities to create</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>
        /// A task that represents the asynchronous operation
        /// The task result contains the number of records created
        /// </returns>
        public async Task<int> CreateBulkEnrollmentsAsync(IEnumerable<Enrollment> enrollments, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Creating bulk enrollments for {Count} courses", enrollments.Count());

                await _context.Enrollments.AddRangeAsync(enrollments, cancellationToken);
                var result = await _context.SaveChangesAsync(cancellationToken);

                _logger.LogInformation("Successfully created {Count} enrollments", result);
                return result;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error creating bulk enrollments");
                throw;
            }
        }

        #endregion

        #region Analytics Operations

        /// <summary>
        /// Gets the total count of enrollments for a specific user
        /// </summary>
        /// <param name="userId">The user identifier</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>
        /// A task that represents the asynchronous operation
        /// The task result contains the count of user enrollments
        /// </returns>
        public async Task<int> GetUserEnrollmentsCountAsync(string userId, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Getting enrollments count for user ID: {UserId}", userId);

                return await _context.Enrollments
                    .AsNoTracking()
                    .Where(e => e.UserId == userId)
                    .CountAsync(cancellationToken);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting enrollments count for user ID: {UserId}", userId);
                throw;
            }
        }

        #endregion
    }
}
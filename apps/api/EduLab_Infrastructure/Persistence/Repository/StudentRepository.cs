using EduLab_Domain.Entities;
using EduLab_Domain.IRepository;
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
    #region Student Repository Class
    /// <summary>
    /// Repository implementation for student-related data operations
    /// </summary>
    public class StudentRepository : IStudentRepository
    {
        #region Private Fields
        private readonly ApplicationDbContext _context;
        private readonly ILogger<StudentRepository> _logger;
        #endregion

        #region Constructor
        /// <summary>
        /// Initializes a new instance of the StudentRepository class
        /// </summary>
        /// <param name="context">Application database context</param>
        /// <param name="logger">Logger instance for logging operations</param>
        /// <exception cref="ArgumentNullException">Thrown when context or logger is null</exception>
        public StudentRepository(ApplicationDbContext context, ILogger<StudentRepository> logger)
        {
            _context = context ?? throw new ArgumentNullException(nameof(context));
            _logger = logger ?? throw new ArgumentNullException(nameof(logger));
        }
        #endregion

        #region Notification Methods
        /// <summary>
        /// Retrieves students for notification purposes for a specific instructor (returns entities)
        /// </summary>
        /// <param name="instructorId">The unique identifier of the instructor</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>List of student entities</returns>
        public async Task<List<ApplicationUser>> GetStudentsForNotificationAsync(
            string instructorId,
            CancellationToken cancellationToken = default)
        {
            const string operationName = nameof(GetStudentsForNotificationAsync);

            try
            {
                _logger.LogInformation("Starting {OperationName} for instructor: {InstructorId}",
                    operationName, instructorId);

                if (string.IsNullOrWhiteSpace(instructorId))
                {
                    _logger.LogWarning("Invalid instructor ID provided in {OperationName}", operationName);
                    throw new ArgumentException("Instructor ID cannot be null or empty", nameof(instructorId));
                }

                var students = await _context.Enrollments
                    .Where(e => e.Course.InstructorId == instructorId)
                    .Select(e => e.User)
                    .Where(u => _context.UserRoles.Any(ur => ur.UserId == u.Id))
                    .Distinct()
                    .OrderBy(u => u.FullName)
                    .ToListAsync(cancellationToken);

                _logger.LogInformation("Successfully retrieved {Count} students for notification in {OperationName}",
                    students.Count, operationName);

                return students;
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {OperationName} was cancelled for instructor: {InstructorId}",
                    operationName, instructorId);
                throw;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred in {OperationName} for instructor: {InstructorId}",
                    operationName, instructorId);
                throw;
            }
        }

        /// <summary>
        /// Validates that the specified students belong to the given instructor
        /// </summary>
        /// <param name="instructorId">The unique identifier of the instructor</param>
        /// <param name="studentIds">List of student IDs to validate</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>True if all students belong to the instructor, otherwise false</returns>
        public async Task<bool> ValidateStudentsBelongToInstructorAsync(
            string instructorId,
            List<string> studentIds,
            CancellationToken cancellationToken = default)
        {
            const string operationName = nameof(ValidateStudentsBelongToInstructorAsync);

            try
            {
                if (string.IsNullOrWhiteSpace(instructorId))
                {
                    _logger.LogWarning("Invalid instructor ID provided in {OperationName}", operationName);
                    throw new ArgumentException("Instructor ID cannot be null or empty", nameof(instructorId));
                }

                if (studentIds == null || !studentIds.Any())
                {
                    _logger.LogInformation("No student IDs provided for validation in {OperationName}", operationName);
                    return true;
                }

                _logger.LogInformation("Validating {Count} students belong to instructor: {InstructorId}",
                    studentIds.Count, instructorId);

                var validStudentCount = await _context.Enrollments
                    .Where(e => e.Course.InstructorId == instructorId && studentIds.Contains(e.UserId))
                    .Select(e => e.UserId)
                    .Distinct()
                    .CountAsync(cancellationToken);

                var isValid = validStudentCount == studentIds.Count;

                _logger.LogInformation("Validation completed in {OperationName}. Result: {IsValid}",
                    operationName, isValid);

                return isValid;
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {OperationName} was cancelled for instructor: {InstructorId}",
                    operationName, instructorId);
                throw;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred in {OperationName} for instructor: {InstructorId}",
                    operationName, instructorId);
                throw;
            }
        }

        /// <summary>
        /// Gets total number of students for an instructor
        /// </summary>
        /// <param name="instructorId">The unique identifier of the instructor</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>Total count of distinct students</returns>
        public async Task<int> GetTotalStudentsByInstructorAsync(
            string instructorId,
            CancellationToken cancellationToken = default)
        {
            const string operationName = nameof(GetTotalStudentsByInstructorAsync);

            try
            {
                _logger.LogInformation("Starting {OperationName} for instructor: {InstructorId}",
                    operationName, instructorId);

                if (string.IsNullOrWhiteSpace(instructorId))
                {
                    _logger.LogWarning("Invalid instructor ID provided in {OperationName}", operationName);
                    throw new ArgumentException("Instructor ID cannot be null or empty", nameof(instructorId));
                }

                var totalStudents = await _context.Enrollments
                    .Where(e => e.Course.InstructorId == instructorId)
                    .Select(e => e.UserId)
                    .Distinct()
                    .CountAsync(cancellationToken);

                _logger.LogInformation("Total students for instructor {InstructorId}: {Count}",
                    instructorId, totalStudents);

                return totalStudents;
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {OperationName} was cancelled for instructor: {InstructorId}",
                    operationName, instructorId);
                throw;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred in {OperationName} for instructor: {InstructorId}",
                    operationName, instructorId);
                throw;
            }
        }
        #endregion

        #region Student Retrieval Methods
        /// <summary>
        /// Retrieves all students with basic information
        /// </summary>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>List of application users representing students</returns>
        public async Task<List<ApplicationUser>> GetStudentsAsync(CancellationToken cancellationToken = default)
        {
            const string operationName = nameof(GetStudentsAsync);

            try
            {
                _logger.LogInformation("Starting {OperationName}", operationName);

                var students = await _context.Users
                    .Where(u => _context.UserRoles.Any(ur => ur.UserId == u.Id))
                    .OrderByDescending(u => u.CreatedAt)
                    .ToListAsync(cancellationToken);

                _logger.LogInformation("Successfully retrieved {Count} students in {OperationName}",
                    students.Count, operationName);

                return students;
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {OperationName} was cancelled", operationName);
                throw;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred in {OperationName}", operationName);
                throw;
            }
        }

        /// <summary>
        /// Retrieves students by instructor ID
        /// </summary>
        /// <param name="instructorId">The unique identifier of the instructor</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>List of students associated with the instructor</returns>
        public async Task<List<ApplicationUser>> GetStudentsByInstructorAsync(
            string instructorId,
            CancellationToken cancellationToken = default)
        {
            const string operationName = nameof(GetStudentsByInstructorAsync);

            try
            {
                _logger.LogInformation("Starting {OperationName} for instructor: {InstructorId}",
                    operationName, instructorId);

                if (string.IsNullOrWhiteSpace(instructorId))
                {
                    _logger.LogWarning("Invalid instructor ID provided in {OperationName}", operationName);
                    throw new ArgumentException("Instructor ID cannot be null or empty", nameof(instructorId));
                }

                var students = await _context.Enrollments
                    .Where(e => e.Course.InstructorId == instructorId)
                    .Select(e => e.User)
                    .Where(u => _context.UserRoles.Any(ur => ur.UserId == u.Id))
                    .Distinct()
                    .OrderByDescending(u => u.CreatedAt)
                    .ToListAsync(cancellationToken);

                _logger.LogInformation("Successfully retrieved {Count} students for instructor: {InstructorId} in {OperationName}",
                    students.Count, instructorId, operationName);

                return students;
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {OperationName} was cancelled for instructor: {InstructorId}",
                    operationName, instructorId);
                throw;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred in {OperationName} for instructor: {InstructorId}",
                    operationName, instructorId);
                throw;
            }
        }

        /// <summary>
        /// Retrieves a student by their unique identifier
        /// </summary>
        /// <param name="studentId">The unique identifier of the student</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>The student entity if found, otherwise null</returns>
        public async Task<ApplicationUser> GetStudentByIdAsync(
            string studentId,
            CancellationToken cancellationToken = default)
        {
            const string operationName = nameof(GetStudentByIdAsync);

            try
            {
                _logger.LogInformation("Starting {OperationName} for student: {StudentId}",
                    operationName, studentId);

                if (string.IsNullOrWhiteSpace(studentId))
                {
                    _logger.LogWarning("Invalid student ID provided in {OperationName}", operationName);
                    throw new ArgumentException("Student ID cannot be null or empty", nameof(studentId));
                }

                var student = await _context.Users
                    .FirstOrDefaultAsync(u => u.Id == studentId, cancellationToken);

                if (student == null)
                {
                    _logger.LogWarning("Student not found with ID: {StudentId} in {OperationName}",
                        studentId, operationName);
                }
                else
                {
                    _logger.LogInformation("Successfully retrieved student with ID: {StudentId} in {OperationName}",
                        studentId, operationName);
                }

                return student;
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {OperationName} was cancelled for student: {StudentId}",
                    operationName, studentId);
                throw;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred in {OperationName} for student: {StudentId}",
                    operationName, studentId);
                throw;
            }
        }
        #endregion

        #region Enrollment and Progress Methods
        /// <summary>
        /// Retrieves student enrollments with all necessary related data (Course, Sections, Lectures, Instructor)
        /// </summary>
        /// <param name="studentId">The unique identifier of the student</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>List of Enrollment entities with includes</returns>
        public async Task<List<Enrollment>> GetStudentEnrollmentsWithDetailsAsync(
            string studentId,
            CancellationToken cancellationToken = default)
        {
            const string operationName = nameof(GetStudentEnrollmentsWithDetailsAsync);

            try
            {
                _logger.LogInformation("Starting {OperationName} for student: {StudentId}",
                    operationName, studentId);

                if (string.IsNullOrWhiteSpace(studentId))
                {
                    _logger.LogWarning("Invalid student ID provided in {OperationName}", operationName);
                    throw new ArgumentException("Student ID cannot be null or empty", nameof(studentId));
                }

                var enrollments = await _context.Enrollments
                    .Where(e => e.UserId == studentId)
                    .Include(e => e.Course)
                        .ThenInclude(c => c.Sections)
                        .ThenInclude(s => s.Lectures)
                    .Include(e => e.Course)
                        .ThenInclude(c => c.Instructor)
                    .ToListAsync(cancellationToken);

                _logger.LogInformation("Successfully retrieved {Count} enrollments for student: {StudentId} in {OperationName}",
                    enrollments.Count, studentId, operationName);

                return enrollments;
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {OperationName} was cancelled for student: {StudentId}",
                    operationName, studentId);
                throw;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred in {OperationName} for student: {StudentId}",
                    operationName, studentId);
                throw;
            }
        }

        /// <summary>
        /// Retrieves recent student enrollments to be used as activities
        /// </summary>
        /// <param name="studentId">The unique identifier of the student</param>
        /// <param name="count">Number of enrollments to retrieve</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>List of Enrollment entities with Course</returns>
        public async Task<List<Enrollment>> GetRecentStudentEnrollmentsAsync(
            string studentId,
            int count,
            CancellationToken cancellationToken = default)
        {
            const string operationName = nameof(GetRecentStudentEnrollmentsAsync);

            try
            {
                _logger.LogInformation("Starting {OperationName} for student: {StudentId}",
                    operationName, studentId);

                if (string.IsNullOrWhiteSpace(studentId))
                {
                    _logger.LogWarning("Invalid student ID provided in {OperationName}", operationName);
                    throw new ArgumentException("Student ID cannot be null or empty", nameof(studentId));
                }

                var recentEnrollments = await _context.Enrollments
                    .Where(e => e.UserId == studentId)
                    .Include(e => e.Course)
                    .OrderByDescending(e => e.EnrolledAt)
                    .Take(count)
                    .ToListAsync(cancellationToken);

                _logger.LogInformation("Successfully retrieved {Count} recent enrollments for student: {StudentId} in {OperationName}",
                    recentEnrollments.Count, studentId, operationName);

                return recentEnrollments;
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {OperationName} was cancelled for student: {StudentId}",
                    operationName, studentId);
                throw;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred in {OperationName} for student: {StudentId}",
                    operationName, studentId);
                throw;
            }
        }
        #endregion

        #region Summary and Progress Methods
        /// <summary>
        /// Retrieves summary statistics for an instructor
        /// </summary>
        /// <param name="instructorId">The unique identifier of the instructor</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>Tuple containing (TotalStudents, ActiveStudents, CompletedCourses, AverageCompletion)</returns>
        public async Task<(int TotalStudents, int ActiveStudents, int CompletedCourses, decimal AverageCompletion)> GetStudentsSummaryStatsByInstructorAsync(
            string instructorId,
            CancellationToken cancellationToken = default)
        {
            const string operationName = nameof(GetStudentsSummaryStatsByInstructorAsync);

            try
            {
                _logger.LogInformation("Starting {OperationName} for instructor: {InstructorId}",
                    operationName, instructorId);

                if (string.IsNullOrWhiteSpace(instructorId))
                {
                    _logger.LogWarning("Invalid instructor ID provided in {OperationName}", operationName);
                    throw new ArgumentException("Instructor ID cannot be null or empty", nameof(instructorId));
                }

                var enrollmentsQuery = _context.Enrollments
                    .Include(e => e.Course)
                    .Where(e => e.Course.InstructorId == instructorId)
                    .Include(e => e.User);

                var totalStudents = await enrollmentsQuery
                    .Select(e => e.UserId)
                    .Distinct()
                    .CountAsync(cancellationToken);

                if (totalStudents == 0)
                {
                    _logger.LogInformation("No students found for instructor: {InstructorId} in {OperationName}",
                        instructorId, operationName);

                    return (0, 0, 0, 0);
                }

                var enrollmentIds = await enrollmentsQuery.Select(e => e.Id).ToListAsync(cancellationToken);

                var courseProgressGroups = await _context.CourseProgresses
                    .Where(cp => enrollmentIds.Contains(cp.EnrollmentId))
                    .GroupBy(cp => cp.EnrollmentId)
                    .Select(g => new
                    {
                        EnrollmentId = g.Key,
                        TotalLectures = g.Count(),
                        CompletedLectures = g.Count(x => x.IsCompleted)
                    })
                    .ToListAsync(cancellationToken);

                var completionPercentages = courseProgressGroups
                    .Select(g => g.TotalLectures == 0 ? 0 : (decimal)g.CompletedLectures / g.TotalLectures * 100)
                    .ToList();

                var averageCompletion = completionPercentages.Any() ? completionPercentages.Average() : 0;

                var completedCourses = courseProgressGroups.Count(g => g.TotalLectures > 0 && g.CompletedLectures == g.TotalLectures);

                var activeStudents = await _context.CourseProgresses
                    .Where(cp => enrollmentIds.Contains(cp.EnrollmentId) && cp.Lecture != null)
                    .Select(cp => cp.Enrollment.UserId)
                    .Distinct()
                    .CountAsync(cancellationToken);

                _logger.LogInformation(
                    "Successfully retrieved students summary for instructor {InstructorId} in {OperationName}: Total={Total}, Active={Active}, Completed={Completed}, Avg={Avg}",
                    instructorId, operationName, totalStudents, activeStudents, completedCourses, averageCompletion);

                return (totalStudents, activeStudents, completedCourses, Math.Round(averageCompletion, 2));
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {OperationName} was cancelled for instructor: {InstructorId}",
                    operationName, instructorId);
                throw;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred in {OperationName} for instructor: {InstructorId}",
                    operationName, instructorId);
                throw;
            }
        }

        /// <summary>
        /// Retrieves progress details for multiple students (returns enrollments with related data)
        /// </summary>
        /// <param name="studentIds">List of student IDs to retrieve progress for</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>List of Enrollment entities with Course, Sections, Lectures (no CourseProgress)</returns>
        public async Task<List<Enrollment>> GetStudentsProgressEnrollmentsAsync(
            List<string> studentIds,
            CancellationToken cancellationToken = default)
        {
            const string operationName = nameof(GetStudentsProgressEnrollmentsAsync);

            try
            {
                if (studentIds == null || !studentIds.Any())
                {
                    _logger.LogWarning("No student IDs provided for progress retrieval in {OperationName}", operationName);
                    return new List<Enrollment>();
                }

                _logger.LogInformation("Starting {OperationName} for {Count} students",
                    operationName, studentIds.Count);

                var enrollments = await _context.Enrollments
                    .Where(e => studentIds.Contains(e.UserId))
                    .Include(e => e.Course)
                        .ThenInclude(c => c.Sections)
                        .ThenInclude(s => s.Lectures)
                    .ToListAsync(cancellationToken);

                _logger.LogInformation("Successfully retrieved {Count} enrollments for progress in {OperationName}",
                    enrollments.Count, operationName);

                return enrollments;
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {OperationName} was cancelled", operationName);
                throw;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred in {OperationName}", operationName);
                throw;
            }
        }
        #endregion
    }
    #endregion
}
using EduLab_Domain.Entities;
using EduLab_Domain.RepoInterfaces;
using EduLab_Infrastructure.DB;
using EduLab_Shared.DTOs.Student;
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
        /// Retrieves students for notification purposes for a specific instructor
        /// </summary>
        /// <param name="instructorId">The unique identifier of the instructor</param>
        /// <param name="selectedStudentIds">Optional list of pre-selected student IDs</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>List of student notification DTOs</returns>
        public async Task<List<StudentNotificationDto>> GetStudentsForNotificationAsync(
            string instructorId,
            List<string> selectedStudentIds = null,
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

                var query = _context.Enrollments
                    .Where(e => e.Course.InstructorId == instructorId)
                    .Select(e => e.User)
                    .Where(u => _context.UserRoles.Any(ur => ur.UserId == u.Id))
                    .Distinct();

                var students = await query
                    .Select(u => new StudentNotificationDto
                    {
                        StudentId = u.Id,
                        FullName = u.FullName,
                        Email = u.Email,
                        ProfileImageUrl = u.ProfileImageUrl,
                        IsSelected = selectedStudentIds != null && selectedStudentIds.Contains(u.Id)
                    })
                    .OrderBy(s => s.FullName)
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
        /// Retrieves notification summary for an instructor
        /// </summary>
        /// <param name="instructorId">The unique identifier of the instructor</param>
        /// <param name="selectedStudentIds">Optional list of selected student IDs</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>Instructor notification summary DTO</returns>
        public async Task<InstructorNotificationSummaryDto> GetNotificationSummaryAsync(
            string instructorId,
            List<string> selectedStudentIds = null,
            CancellationToken cancellationToken = default)
        {
            const string operationName = nameof(GetNotificationSummaryAsync);

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

                var summary = new InstructorNotificationSummaryDto
                {
                    TotalStudents = totalStudents,
                    SelectedStudents = selectedStudentIds?.Count ?? 0,
                    SendToAll = selectedStudentIds == null || !selectedStudentIds.Any()
                };

                _logger.LogInformation(
                    "Successfully retrieved notification summary in {OperationName}. Total: {Total}, Selected: {Selected}",
                    operationName, summary.TotalStudents, summary.SelectedStudents);

                return summary;
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
        /// Retrieves student enrollments with progress information
        /// </summary>
        /// <param name="studentId">The unique identifier of the student</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>List of student enrollment DTOs with progress details</returns>
        public async Task<List<StudentEnrollmentDto>> GetStudentEnrollmentsAsync(
            string studentId,
            CancellationToken cancellationToken = default)
        {
            const string operationName = nameof(GetStudentEnrollmentsAsync);

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

                var enrollmentIds = enrollments.Select(e => e.Id).ToList();

                var progressData = await _context.CourseProgresses
                    .Where(cp => enrollmentIds.Contains(cp.EnrollmentId))
                    .GroupBy(cp => cp.EnrollmentId)
                    .Select(g => new
                    {
                        EnrollmentId = g.Key,
                        CompletedLectures = g.Count(cp => cp.IsCompleted)
                    })
                    .ToListAsync(cancellationToken);

                var result = enrollments.Select(e =>
                {
                    var totalLectures = e.Course.Sections.Sum(s => s.Lectures.Count);
                    var completedLectures = progressData.FirstOrDefault(p => p.EnrollmentId == e.Id)?.CompletedLectures ?? 0;

                    var progress = totalLectures == 0 ? 0 : Math.Round((decimal)completedLectures / totalLectures * 100, 2);

                    string status = progress switch
                    {
                        100 => "Completed",
                        > 0 => "Active",
                        _ => "Inactive"
                    };

                    return new StudentEnrollmentDto
                    {
                        EnrollmentId = e.Id,
                        CourseId = e.CourseId,
                        CourseTitle = e.Course.Title,
                        CourseThumbnailUrl = e.Course.ThumbnailUrl,
                        EnrolledAt = e.EnrolledAt,
                        TotalLectures = totalLectures,
                        CompletedLectures = completedLectures,
                        ProgressPercentage = progress,
                        Status = status
                    };
                }).ToList();

                _logger.LogInformation("Successfully retrieved {Count} enrollments for student: {StudentId} in {OperationName}",
                    result.Count, studentId, operationName);

                return result;
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
        /// Retrieves student activities
        /// </summary>
        /// <param name="studentId">The unique identifier of the student</param>
        /// <param name="count">Number of activities to retrieve (default: 10)</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>List of student activity DTOs</returns>
        public async Task<List<StudentActivityDto>> GetStudentActivitiesAsync(
            string studentId,
            int count = 10,
            CancellationToken cancellationToken = default)
        {
            const string operationName = nameof(GetStudentActivitiesAsync);

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
                    .Select(e => new StudentActivityDto
                    {
                        Type = "Enrollment",
                        Description = $"تم التسجيل في دورة {e.Course.Title}",
                        ActivityDate = e.EnrolledAt,
                        CourseTitle = e.Course.Title,
                        CourseId = e.CourseId
                    })
                    .ToListAsync(cancellationToken);

                _logger.LogInformation("Successfully retrieved {Count} activities for student: {StudentId} in {OperationName}",
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
        /// Retrieves students summary for an instructor
        /// </summary>
        /// <param name="instructorId">The unique identifier of the instructor</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>Students summary DTO</returns>
        public async Task<StudentsSummaryDto> GetStudentsSummaryByInstructorAsync(
            string instructorId,
            CancellationToken cancellationToken = default)
        {
            const string operationName = nameof(GetStudentsSummaryByInstructorAsync);

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

                    return new StudentsSummaryDto
                    {
                        TotalStudents = 0,
                        ActiveStudents = 0,
                        CompletedCourses = 0,
                        AverageCompletion = 0
                    };
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

                var summary = new StudentsSummaryDto
                {
                    TotalStudents = totalStudents,
                    ActiveStudents = activeStudents,
                    CompletedCourses = completedCourses,
                    AverageCompletion = Math.Round(averageCompletion, 2)
                };

                _logger.LogInformation(
                    "Successfully retrieved students summary for instructor {InstructorId} in {OperationName}: {@Summary}",
                    instructorId, operationName, summary);

                return summary;
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
        /// Retrieves progress details for multiple students
        /// </summary>
        /// <param name="studentIds">List of student IDs to retrieve progress for</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>List of student progress DTOs</returns>
        public async Task<List<StudentProgressDto>> GetStudentsProgressAsync(
            List<string> studentIds,
            CancellationToken cancellationToken = default)
        {
            const string operationName = nameof(GetStudentsProgressAsync);

            try
            {
                if (studentIds == null || !studentIds.Any())
                {
                    _logger.LogWarning("No student IDs provided for progress retrieval in {OperationName}", operationName);
                    return new List<StudentProgressDto>();
                }

                _logger.LogInformation("Starting {OperationName} for {Count} students",
                    operationName, studentIds.Count);

                var enrollments = await _context.Enrollments
                    .Where(e => studentIds.Contains(e.UserId))
                    .Select(e => new
                    {
                        e.Id,
                        e.UserId,
                        e.CourseId,
                        CourseTitle = e.Course.Title,
                        TotalLectures = e.Course.Sections.Count
                    })
                    .ToListAsync(cancellationToken);

                var enrollmentIds = enrollments.Select(e => e.Id).ToList();

                var progressData = await _context.CourseProgresses
                    .Where(cp => enrollmentIds.Contains(cp.EnrollmentId))
                    .GroupBy(cp => cp.EnrollmentId)
                    .Select(g => new
                    {
                        EnrollmentId = g.Key,
                        CompletedLectures = g.Count(cp => cp.IsCompleted)
                    })
                    .ToListAsync(cancellationToken);

                var result = enrollments.Select(e =>
                {
                    var progress = progressData.FirstOrDefault(p => p.EnrollmentId == e.Id);
                    var completedLectures = progress?.CompletedLectures ?? 0;
                    var totalLectures = e.TotalLectures == 0 ? 1 : e.TotalLectures;

                    decimal percentage = Math.Round((decimal)completedLectures / totalLectures * 100, 2);

                    string status = percentage switch
                    {
                        100 => "Completed",
                        > 0 => "Active",
                        _ => "Not Started"
                    };

                    return new StudentProgressDto
                    {
                        EnrollmentId = e.Id,
                        CourseId = e.CourseId,
                        CourseTitle = e.CourseTitle,
                        CompletedLectures = completedLectures,
                        TotalLectures = totalLectures,
                        ProgressPercentage = percentage,
                        LastActivity = null,
                        Status = status
                    };
                }).ToList();

                _logger.LogInformation("Successfully retrieved progress for {Count} students in {OperationName}",
                    result.Count, operationName);

                return result;
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
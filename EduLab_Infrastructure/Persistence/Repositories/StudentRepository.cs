using EduLab_Domain.Entities;
using EduLab_Domain.RepoInterfaces;
using EduLab_Infrastructure.DB;
using EduLab_Shared.DTOs.Student;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_Infrastructure.Persistence.Repositories
{
    public class StudentRepository : IStudentRepository
    {
        private readonly ApplicationDbContext _context;
        private readonly ILogger<StudentRepository> _logger;

        public StudentRepository(ApplicationDbContext context, ILogger<StudentRepository> logger)
        {
            _context = context ?? throw new ArgumentNullException(nameof(context));
            _logger = logger ?? throw new ArgumentNullException(nameof(logger));
        }

        public async Task<List<ApplicationUser>> GetStudentsAsync(StudentFilterDto filter, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Getting students with filter: {@Filter}", filter);

                var query = _context.Users
                    .Where(u => _context.UserRoles.Any(ur => ur.UserId == u.Id));

                // Apply search filter
                if (!string.IsNullOrWhiteSpace(filter.Search))
                {
                    query = query.Where(u =>
                        u.FullName.Contains(filter.Search) ||
                        u.Email.Contains(filter.Search) ||
                        u.PhoneNumber.Contains(filter.Search));
                }

                // Apply course filter
                if (filter.CourseId.HasValue)
                {
                    query = query.Where(u =>
                        _context.Enrollments.Any(e => e.UserId == u.Id && e.CourseId == filter.CourseId.Value));
                }

                // Apply status filter
                if (!string.IsNullOrWhiteSpace(filter.Status) && filter.Status != "All")
                {
                    // This would need more complex logic based on activity
                    // For now, we'll filter by enrollment status
                }

                // Pagination
                var skipAmount = (filter.PageNumber - 1) * filter.PageSize;
                var students = await query
                    .OrderByDescending(u => u.CreatedAt)
                    .Skip(skipAmount)
                    .Take(filter.PageSize)
                    .ToListAsync(cancellationToken);

                _logger.LogInformation("Retrieved {Count} students", students.Count);
                return students;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting students with filter: {@Filter}", filter);
                throw;
            }
        }
        public async Task<List<ApplicationUser>> GetStudentsByInstructorAsync(string instructorId, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Getting students for instructor: {InstructorId}", instructorId);

                var students = await _context.Enrollments
                    .Where(e => e.Course.InstructorId == instructorId) 
                    .Select(e => e.User)
                    .Where(u => _context.UserRoles.Any(ur => ur.UserId == u.Id ))
                    .Distinct()
                    .OrderByDescending(u => u.CreatedAt)
                    .ToListAsync(cancellationToken);

                _logger.LogInformation("Retrieved {Count} students for instructor: {InstructorId}", students.Count, instructorId);
                return students;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting students for instructor: {InstructorId}", instructorId);
                throw;
            }
        }
        public async Task<ApplicationUser> GetStudentByIdAsync(string studentId, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Getting student by ID: {StudentId}", studentId);

                var student = await _context.Users
                    .FirstOrDefaultAsync(u => u.Id == studentId, cancellationToken);

                if (student == null)
                {
                    _logger.LogWarning("Student not found with ID: {StudentId}", studentId);
                }

                return student;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting student by ID: {StudentId}", studentId);
                throw;
            }
        }

        public async Task<List<StudentEnrollmentDto>> GetStudentEnrollmentsAsync(string studentId, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Getting enrollments for student: {StudentId}", studentId);

                var enrollments = await _context.Enrollments
                    .Where(e => e.UserId == studentId)
                    .Include(e => e.Course)
                        .ThenInclude(c => c.Sections)
                        .ThenInclude(s => s.Lectures)
                    .Include(e => e.Course)
                        .ThenInclude(c => c.Instructor)
                    .ToListAsync(cancellationToken);

                // Get progress data for all enrollments
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
                        _ => "inactive"
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

                _logger.LogInformation("Retrieved {Count} enrollments with progress for student: {StudentId}", result.Count, studentId);
                return result;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting enrollments with progress for student: {StudentId}", studentId);
                throw;
            }
        }


        public async Task<List<StudentActivityDto>> GetStudentActivitiesAsync(string studentId, int count = 10, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Getting activities for student: {StudentId}", studentId);

                // This is a simplified version - you'd need to track activities in your database
                var activities = new List<StudentActivityDto>();

                // Get recent enrollments as activities
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

                activities.AddRange(recentEnrollments);

                _logger.LogInformation("Retrieved {Count} activities for student: {StudentId}", activities.Count, studentId);
                return activities;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting activities for student: {StudentId}", studentId);
                throw;
            }
        }
        public async Task<StudentsSummaryDto> GetStudentsSummaryByInstructorAsync(string instructorId, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Getting students summary for instructor: {InstructorId}", instructorId);

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

                var activeThreshold = DateTime.UtcNow.AddDays(-30);
                var activeStudents = await _context.CourseProgresses
                    .Where(cp => enrollmentIds.Contains(cp.EnrollmentId)
                                 && cp.Lecture != null)
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

                _logger.LogInformation("Retrieved students summary for instructor {InstructorId}: {@Summary}", instructorId, summary);
                return summary;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting students summary for instructor: {InstructorId}", instructorId);
                throw;
            }
        }


        /// <summary>
        /// Retrieves progress details for a list of students based on their course enrollments.
        /// </summary>
        /// <param name="studentIds">A list of student IDs to retrieve progress for.</param>
        /// <param name="cancellationToken">Optional cancellation token.</param>
        /// <returns>
        /// A list of <see cref="StudentProgressDto"/> containing each student's course progress.
        /// </returns>
        /// <exception cref="ArgumentNullException">Thrown when <paramref name="studentIds"/> is null or empty.</exception>
        public async Task<List<StudentProgressDto>> GetStudentsProgressAsync(List<string> studentIds, CancellationToken cancellationToken = default)
        {
            if (studentIds == null || !studentIds.Any())
            {
                _logger.LogWarning("No student IDs were provided for progress retrieval.");
                throw new ArgumentNullException(nameof(studentIds), "Student IDs list cannot be null or empty.");
            }

            try
            {
                _logger.LogInformation("Fetching progress data for {Count} students...", studentIds.Count);

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

                _logger.LogInformation("Successfully retrieved progress for {Count} students.", result.Count);

                return result;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error retrieving students progress.");
                throw;
            }
        }

        public async Task<int> GetStudentsCountAsync(StudentFilterDto filter, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Getting students count with filter: {@Filter}", filter);

                var query = _context.Users
                    .Where(u => _context.UserRoles.Any(ur => ur.UserId == u.Id &&
                        _context.Roles.Any(r => r.Id == ur.RoleId && r.Name == "Student")));

                if (!string.IsNullOrWhiteSpace(filter.Search))
                {
                    query = query.Where(u =>
                        u.FullName.Contains(filter.Search) ||
                        u.Email.Contains(filter.Search));
                }

                if (filter.CourseId.HasValue)
                {
                    query = query.Where(u =>
                        _context.Enrollments.Any(e => e.UserId == u.Id && e.CourseId == filter.CourseId.Value));
                }

                var count = await query.CountAsync(cancellationToken);

                _logger.LogInformation("Retrieved students count: {Count}", count);
                return count;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting students count with filter: {@Filter}", filter);
                throw;
            }
        }
    }
}

using AutoMapper;
using EduLab_Application.ServiceInterfaces;
using EduLab_Domain.RepoInterfaces;
using EduLab_Shared.DTOs.Notification;
using EduLab_Shared.DTOs.Student;
using Microsoft.Extensions.Logging;

namespace EduLab_Application.Services
{
    public class StudentService : IStudentService
    {
        private readonly IStudentRepository _studentRepository;
        private readonly INotificationService _notificationService;
        private readonly IMapper _mapper;
        private readonly ILogger<StudentService> _logger;

        public StudentService(
            IStudentRepository studentRepository,
            IEnrollmentRepository enrollmentRepository,
            ICourseProgressRepository courseProgressRepository,
            INotificationService notificationService,
            IMapper mapper,
            ILogger<StudentService> logger)
        {
            _studentRepository = studentRepository ?? throw new ArgumentNullException(nameof(studentRepository));
            _notificationService = notificationService ?? throw new ArgumentNullException(nameof(notificationService));
            _mapper = mapper ?? throw new ArgumentNullException(nameof(mapper));
            _logger = logger ?? throw new ArgumentNullException(nameof(logger));
        }

        public async Task<List<StudentDto>> GetStudentsAsync(StudentFilterDto filter, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Getting students with filter: {@Filter}", filter);

                var students = await _studentRepository.GetStudentsAsync(filter, cancellationToken);
                var studentDtos = _mapper.Map<List<StudentDto>>(students);

                // Get progress for all students
                var studentIds = students.Select(s => s.Id).ToList();
                var progressList = await GetStudentsProgressAsync(studentIds, cancellationToken);

                // Enhance student data with progress information
                foreach (var student in studentDtos)
                {
                    var studentProgress = progressList.Where(p => p != null).ToList();
                    // You can add progress information to student DTO if needed
                }

                _logger.LogInformation("Retrieved {Count} students", studentDtos.Count);
                return studentDtos;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting students with filter: {@Filter}", filter);
                throw;
            }
        }
        // في StudentService
        public async Task<List<StudentDto>> GetStudentsByInstructorAsync(string instructorId, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Getting students for instructor: {InstructorId}", instructorId);

                var students = await _studentRepository.GetStudentsByInstructorAsync(instructorId, cancellationToken);
                var studentDtos = _mapper.Map<List<StudentDto>>(students);

                _logger.LogInformation("Retrieved {Count} students for instructor: {InstructorId}", studentDtos.Count, instructorId);
                return studentDtos;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting students for instructor: {InstructorId}", instructorId);
                throw;
            }
        }
        public async Task<StudentDetailsDto> GetStudentDetailsAsync(string studentId, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Getting details for student: {StudentId}", studentId);

                var student = await _studentRepository.GetStudentByIdAsync(studentId, cancellationToken);
                if (student == null)
                {
                    _logger.LogWarning("Student not found: {StudentId}", studentId);
                    return null;
                }

                var enrollments = await _studentRepository.GetStudentEnrollmentsAsync(studentId, cancellationToken);
                var activities = await _studentRepository.GetStudentActivitiesAsync(studentId, 10, cancellationToken);

                // Calculate statistics
                var statistics = new StudentStatisticsDto
                {
                    TotalEnrollments = enrollments.Count,
                    CompletedCourses = enrollments.Count(e => e.ProgressPercentage >= 95), // Consider 95%+ as completed
                    ActiveCourses = enrollments.Count(e => e.ProgressPercentage > 0 && e.ProgressPercentage < 95),
                    AverageProgress = enrollments.Any() ? enrollments.Average(e => e.ProgressPercentage) : 0,
                    TotalTimeSpent = 0, // This would need to be calculated
                    AverageGrade = 0 // This would need to be calculated
                };

                var studentDetails = new StudentDetailsDto
                {
                    Student = _mapper.Map<StudentDto>(student),
                    Enrollments = enrollments,
                    Statistics = statistics,
                    RecentActivities = activities
                };

                _logger.LogInformation("Retrieved details for student: {StudentId}", studentId);
                return studentDetails;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting details for student: {StudentId}", studentId);
                throw;
            }
        }

        public async Task<StudentsSummaryDto> GetStudentsSummaryByInstructorAsync(string instructorId, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Getting students summary for instructor: {InstructorId}", instructorId);

                var summary = await _studentRepository.GetStudentsSummaryByInstructorAsync(instructorId, cancellationToken);

                _logger.LogInformation("Retrieved students summary for instructor: {InstructorId}, {@Summary}", instructorId, summary);
                return summary;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting students summary for instructor: {InstructorId}", instructorId);
                throw;
            }
        }

        public async Task<bool> SendBulkMessageAsync(BulkMessageDto messageDto, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Sending bulk message to {Count} students", messageDto.StudentIds.Count);

                if (messageDto.SendNotification)
                {
                    foreach (var studentId in messageDto.StudentIds)
                    {
                        var notificationDto = new CreateNotificationDto
                        {
                            Title = messageDto.Subject,
                            Message = messageDto.Message,
                            Type = NotificationTypeDto.System,
                            UserId = studentId,
                            RelatedEntityType = "BulkMessage"
                        };

                        await _notificationService.CreateNotificationAsync(notificationDto);
                    }
                }

                if (messageDto.SendEmail)
                {
                    // Here you would integrate with your email service
                    // For now, we'll just log it
                    _logger.LogInformation("Would send email to {Count} students", messageDto.StudentIds.Count);
                }

                _logger.LogInformation("Successfully sent bulk message to {Count} students", messageDto.StudentIds.Count);
                return true;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error sending bulk message to students");
                return false;
            }
        }

        public async Task<List<StudentProgressDto>> GetStudentsProgressAsync(List<string> studentIds, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Getting progress for {Count} students", studentIds.Count);

                var progress = await _studentRepository.GetStudentsProgressAsync(studentIds, cancellationToken);

                _logger.LogInformation("Retrieved progress for {Count} students", progress.Count);
                return progress;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting students progress");
                throw;
            }
        }
    }
}

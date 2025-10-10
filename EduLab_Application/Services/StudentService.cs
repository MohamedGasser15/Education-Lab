using AutoMapper;
using EduLab_Application.ServiceInterfaces;
using EduLab_Domain.RepoInterfaces;
using EduLab_Shared.DTOs.Notification;
using EduLab_Shared.DTOs.Student;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;

namespace EduLab_Application.Services
{
    #region Student Service Class
    /// <summary>
    /// Service implementation for student-related business operations
    /// </summary>
    public class StudentService : IStudentService
    {
        #region Private Fields
        private readonly IStudentRepository _studentRepository;
        private readonly INotificationService _notificationService;
        private readonly IMapper _mapper;
        private readonly ILogger<StudentService> _logger;
        #endregion

        #region Constructor
        /// <summary>
        /// Initializes a new instance of the StudentService class
        /// </summary>
        /// <param name="studentRepository">Student repository instance</param>
        /// <param name="notificationService">Notification service instance</param>
        /// <param name="mapper">AutoMapper instance</param>
        /// <param name="logger">Logger instance</param>
        /// <exception cref="ArgumentNullException">Thrown when any dependency is null</exception>
        public StudentService(
            IStudentRepository studentRepository,
            INotificationService notificationService,
            IMapper mapper,
            ILogger<StudentService> logger)
        {
            _studentRepository = studentRepository ?? throw new ArgumentNullException(nameof(studentRepository));
            _notificationService = notificationService ?? throw new ArgumentNullException(nameof(notificationService));
            _mapper = mapper ?? throw new ArgumentNullException(nameof(mapper));
            _logger = logger ?? throw new ArgumentNullException(nameof(logger));
        }
        #endregion

        #region Student Retrieval Methods
        /// <summary>
        /// Retrieves all students
        /// </summary>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>List of student DTOs</returns>
        public async Task<List<StudentDto>> GetStudentsAsync(CancellationToken cancellationToken = default)
        {
            const string operationName = nameof(GetStudentsAsync);

            try
            {
                _logger.LogInformation("Starting {OperationName}", operationName);

                var students = await _studentRepository.GetStudentsAsync(cancellationToken);
                var studentDtos = _mapper.Map<List<StudentDto>>(students);

                _logger.LogInformation("Successfully retrieved {Count} students in {OperationName}",
                    studentDtos.Count, operationName);

                return studentDtos;
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
        /// <returns>List of student DTOs</returns>
        public async Task<List<StudentDto>> GetStudentsByInstructorAsync(
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

                var students = await _studentRepository.GetStudentsByInstructorAsync(instructorId, cancellationToken);
                var studentDtos = _mapper.Map<List<StudentDto>>(students);

                _logger.LogInformation("Successfully retrieved {Count} students for instructor: {InstructorId} in {OperationName}",
                    studentDtos.Count, instructorId, operationName);

                return studentDtos;
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
        /// Retrieves detailed information for a specific student
        /// </summary>
        /// <param name="studentId">The unique identifier of the student</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>Student details DTO</returns>
        public async Task<StudentDetailsDto> GetStudentDetailsAsync(
            string studentId,
            CancellationToken cancellationToken = default)
        {
            const string operationName = nameof(GetStudentDetailsAsync);

            try
            {
                _logger.LogInformation("Starting {OperationName} for student: {StudentId}",
                    operationName, studentId);

                if (string.IsNullOrWhiteSpace(studentId))
                {
                    _logger.LogWarning("Invalid student ID provided in {OperationName}", operationName);
                    throw new ArgumentException("Student ID cannot be null or empty", nameof(studentId));
                }

                var student = await _studentRepository.GetStudentByIdAsync(studentId, cancellationToken);
                if (student == null)
                {
                    _logger.LogWarning("Student not found with ID: {StudentId} in {OperationName}",
                        studentId, operationName);
                    return null;
                }

                var enrollments = await _studentRepository.GetStudentEnrollmentsAsync(studentId, cancellationToken);
                var activities = await _studentRepository.GetStudentActivitiesAsync(studentId, 10, cancellationToken);

                var statistics = new StudentStatisticsDto
                {
                    TotalEnrollments = enrollments.Count,
                    CompletedCourses = enrollments.Count(e => e.ProgressPercentage >= 95),
                    ActiveCourses = enrollments.Count(e => e.ProgressPercentage > 0 && e.ProgressPercentage < 95),
                    AverageProgress = enrollments.Any() ? enrollments.Average(e => e.ProgressPercentage) : 0,
                    TotalTimeSpent = 0,
                    AverageGrade = 0
                };

                var studentDetails = new StudentDetailsDto
                {
                    Student = _mapper.Map<StudentDto>(student),
                    Enrollments = enrollments,
                    Statistics = statistics,
                    RecentActivities = activities
                };

                _logger.LogInformation("Successfully retrieved student details for: {StudentId} in {OperationName}",
                    studentId, operationName);

                return studentDetails;
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

                var summary = await _studentRepository.GetStudentsSummaryByInstructorAsync(instructorId, cancellationToken);

                _logger.LogInformation("Successfully retrieved students summary for instructor: {InstructorId} in {OperationName}",
                    instructorId, operationName);

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
        /// Retrieves progress information for multiple students
        /// </summary>
        /// <param name="studentIds">List of student IDs</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>List of student progress DTOs</returns>
        public async Task<List<StudentProgressDto>> GetStudentsProgressAsync(
            List<string> studentIds,
            CancellationToken cancellationToken = default)
        {
            const string operationName = nameof(GetStudentsProgressAsync);

            try
            {
                _logger.LogInformation("Starting {OperationName} for {Count} students",
                    operationName, studentIds?.Count ?? 0);

                if (studentIds == null || !studentIds.Any())
                {
                    _logger.LogWarning("No student IDs provided in {OperationName}", operationName);
                    return new List<StudentProgressDto>();
                }

                var progress = await _studentRepository.GetStudentsProgressAsync(studentIds, cancellationToken);

                _logger.LogInformation("Successfully retrieved progress for {Count} students in {OperationName}",
                    progress.Count, operationName);

                return progress;
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

        #region Notification Methods
        /// <summary>
        /// Sends bulk messages to students
        /// </summary>
        /// <param name="messageDto">Bulk message DTO containing message details</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>True if message was sent successfully, otherwise false</returns>
        public async Task<bool> SendBulkMessageAsync(
            BulkMessageDto messageDto,
            CancellationToken cancellationToken = default)
        {
            const string operationName = nameof(SendBulkMessageAsync);

            try
            {
                _logger.LogInformation("Starting {OperationName} for {Count} students",
                    operationName, messageDto.StudentIds.Count);

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
                    _logger.LogInformation("Email sending would be implemented for {Count} students",
                        messageDto.StudentIds.Count);
                }

                _logger.LogInformation("Successfully sent bulk message to {Count} students in {OperationName}",
                    messageDto.StudentIds.Count, operationName);

                return true;
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {OperationName} was cancelled", operationName);
                throw;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred in {OperationName}", operationName);
                return false;
            }
        }
        #endregion
    }
    #endregion
}
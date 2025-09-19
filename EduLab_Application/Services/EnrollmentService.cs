using AutoMapper;
using EduLab_Application.ServiceInterfaces;
using EduLab_Domain.Entities;
using EduLab_Domain.RepoInterfaces;
using EduLab_Shared.DTOs.Enrollment;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;

namespace EduLab_Application.Services
{
    public class EnrollmentService : IEnrollmentService
    {
        private readonly IEnrollmentRepository _enrollmentRepository;
        private readonly ICourseRepository _courseRepository;
        private readonly IMapper _mapper;
        private readonly ILogger<EnrollmentService> _logger;

        public EnrollmentService(
            IEnrollmentRepository enrollmentRepository,
            ICourseRepository courseRepository,
            IMapper mapper,
            ILogger<EnrollmentService> logger)
        {
            _enrollmentRepository = enrollmentRepository ?? throw new ArgumentNullException(nameof(enrollmentRepository));
            _courseRepository = courseRepository ?? throw new ArgumentNullException(nameof(courseRepository));
            _mapper = mapper ?? throw new ArgumentNullException(nameof(mapper));
            _logger = logger ?? throw new ArgumentNullException(nameof(logger));
        }

        public async Task<EnrollmentDto> GetEnrollmentByIdAsync(int enrollmentId, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Getting enrollment by ID: {EnrollmentId}", enrollmentId);

                var enrollment = await _enrollmentRepository.GetEnrollmentByIdAsync(enrollmentId, cancellationToken);
                return _mapper.Map<EnrollmentDto>(enrollment);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting enrollment by ID: {EnrollmentId}", enrollmentId);
                throw;
            }
        }

        // تحديث دالة GetUserEnrollmentsAsync لتحسين الأداء
        public async Task<IEnumerable<EnrollmentDto>> GetUserEnrollmentsAsync(string userId, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Getting enrollments for user ID: {UserId}", userId);

                var enrollments = await _enrollmentRepository.GetUserEnrollmentsAsync(userId, cancellationToken);

                var enrollmentDtos = _mapper.Map<IEnumerable<EnrollmentDto>>(enrollments);

                foreach (var enrollmentDto in enrollmentDtos)
                {
                    enrollmentDto.ProgressPercentage = await CalculateProgressPercentage(enrollmentDto.CourseId, userId, cancellationToken);
                }

                return enrollmentDtos;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting enrollments for user ID: {UserId}", userId);
                throw;
            }
        }

        private async Task<int> CalculateProgressPercentage(int courseId, string userId, CancellationToken cancellationToken)
        {
            // يمكن تنفيذ منطق حساب نسبة التقدم هنا
            // حالياً نرجع قيمة افتراضية
            return 0;
        }

        public async Task<EnrollmentDto> GetUserCourseEnrollmentAsync(string userId, int courseId, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Getting enrollment for user ID: {UserId} in course ID: {CourseId}", userId, courseId);

                var enrollment = await _enrollmentRepository.GetUserCourseEnrollmentAsync(userId, courseId, cancellationToken);
                return _mapper.Map<EnrollmentDto>(enrollment);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting enrollment for user ID: {UserId} in course ID: {CourseId}", userId, courseId);
                throw;
            }
        }

        public async Task<bool> IsUserEnrolledInCourseAsync(string userId, int courseId, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Checking if user ID: {UserId} is enrolled in course ID: {CourseId}", userId, courseId);

                return await _enrollmentRepository.IsUserEnrolledInCourseAsync(userId, courseId, cancellationToken);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error checking enrollment for user ID: {UserId} in course ID: {CourseId}", userId, courseId);
                throw;
            }
        }

        public async Task<EnrollmentDto> CreateEnrollmentAsync(string userId, int courseId, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Creating enrollment for user ID: {UserId} in course ID: {CourseId}", userId, courseId);

                // Check if user is already enrolled
                var isEnrolled = await _enrollmentRepository.IsUserEnrolledInCourseAsync(userId, courseId, cancellationToken);
                if (isEnrolled)
                {
                    _logger.LogWarning("User ID: {UserId} is already enrolled in course ID: {CourseId}", userId, courseId);
                    throw new InvalidOperationException("User is already enrolled in this course");
                }

                // Check if course exists
                var course = await _courseRepository.GetCourseByIdAsync(courseId);
                if (course == null)
                {
                    _logger.LogWarning("Course not found with ID: {CourseId}", courseId);
                    throw new KeyNotFoundException("Course not found");
                }

                var enrollment = new Enrollment
                {
                    UserId = userId,
                    CourseId = courseId,
                    EnrolledAt = DateTime.UtcNow
                };

                var createdEnrollment = await _enrollmentRepository.CreateEnrollmentAsync(enrollment, cancellationToken);
                return _mapper.Map<EnrollmentDto>(createdEnrollment);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error creating enrollment for user ID: {UserId} in course ID: {CourseId}", userId, courseId);
                throw;
            }
        }

        public async Task<bool> DeleteEnrollmentAsync(int enrollmentId, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Deleting enrollment with ID: {EnrollmentId}", enrollmentId);

                return await _enrollmentRepository.DeleteEnrollmentAsync(enrollmentId, cancellationToken);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error deleting enrollment with ID: {EnrollmentId}", enrollmentId);
                throw;
            }
        }

        public async Task<int> CreateBulkEnrollmentsAsync(string userId, IEnumerable<int> courseIds, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Creating bulk enrollments for user ID: {UserId} in {Count} courses", userId, courseIds.Count());

                var enrollments = courseIds.Select(courseId => new Enrollment
                {
                    UserId = userId,
                    CourseId = courseId,
                    EnrolledAt = DateTime.UtcNow
                }).ToList();

                return await _enrollmentRepository.CreateBulkEnrollmentsAsync(enrollments, cancellationToken);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error creating bulk enrollments for user ID: {UserId}", userId);
                throw;
            }
        }

        public async Task<int> GetUserEnrollmentsCountAsync(string userId, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Getting enrollments count for user ID: {UserId}", userId);

                return await _enrollmentRepository.GetUserEnrollmentsCountAsync(userId, cancellationToken);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting enrollments count for user ID: {UserId}", userId);
                throw;
            }
        }
    }
}
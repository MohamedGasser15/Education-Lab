using AutoMapper;
using EduLab_Application.ServiceInterfaces;
using EduLab_Domain.Entities;
using EduLab_Domain.RepoInterfaces;
using EduLab_Shared.DTOs.CourseProgress;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;

namespace EduLab_Application.Services
{
    /// <summary>
    /// Service implementation for managing course progress operations
    /// Handles business logic for course progress tracking and analytics
    /// </summary>
    public class CourseProgressService : ICourseProgressService
    {
        #region Private Fields

        private readonly ICourseProgressRepository _progressRepository;
        private readonly IEnrollmentRepository _enrollmentRepository;
        private readonly IMapper _mapper;
        private readonly ILogger<CourseProgressService> _logger;

        #endregion

        #region Constructor

        /// <summary>
        /// Initializes a new instance of the <see cref="CourseProgressService"/> class
        /// </summary>
        /// <param name="progressRepository">The course progress repository</param>
        /// <param name="enrollmentRepository">The enrollment repository</param>
        /// <param name="mapper">The AutoMapper instance</param>
        /// <param name="logger">The logger instance</param>
        /// <exception cref="ArgumentNullException">Thrown when any dependency is null</exception>
        public CourseProgressService(
            ICourseProgressRepository progressRepository,
            IEnrollmentRepository enrollmentRepository,
            IMapper mapper,
            ILogger<CourseProgressService> logger)
        {
            _progressRepository = progressRepository ?? throw new ArgumentNullException(nameof(progressRepository));
            _enrollmentRepository = enrollmentRepository ?? throw new ArgumentNullException(nameof(enrollmentRepository));
            _mapper = mapper ?? throw new ArgumentNullException(nameof(mapper));
            _logger = logger ?? throw new ArgumentNullException(nameof(logger));
        }

        #endregion

        #region Progress Retrieval Operations

        /// <summary>
        /// Retrieves a specific course progress record by enrollment ID and lecture ID
        /// </summary>
        /// <param name="enrollmentId">The enrollment identifier</param>
        /// <param name="lectureId">The lecture identifier</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>
        /// A task that represents the asynchronous operation
        /// The task result contains the course progress DTO or null if not found
        /// </returns>
        public async Task<CourseProgressDto> GetProgressAsync(int enrollmentId, int lectureId, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Retrieving progress for enrollment {EnrollmentId} and lecture {LectureId}",
                    enrollmentId, lectureId);

                var progress = await _progressRepository.GetProgressAsync(enrollmentId, lectureId, cancellationToken);
                var result = _mapper.Map<CourseProgressDto>(progress);

                _logger.LogInformation("Successfully retrieved progress for enrollment {EnrollmentId} and lecture {LectureId}",
                    enrollmentId, lectureId);

                return result;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting progress for enrollment {EnrollmentId} and lecture {LectureId}",
                    enrollmentId, lectureId);
                throw;
            }
        }

        /// <summary>
        /// Retrieves all progress records for a specific enrollment
        /// </summary>
        /// <param name="enrollmentId">The enrollment identifier</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>
        /// A task that represents the asynchronous operation
        /// The task result contains a list of course progress DTOs
        /// </returns>
        public async Task<List<CourseProgressDto>> GetProgressByEnrollmentAsync(int enrollmentId, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Retrieving all progress records for enrollment {EnrollmentId}", enrollmentId);

                var progressList = await _progressRepository.GetProgressByEnrollmentAsync(enrollmentId, cancellationToken);
                var result = _mapper.Map<List<CourseProgressDto>>(progressList);

                _logger.LogInformation("Successfully retrieved {Count} progress records for enrollment {EnrollmentId}",
                    result.Count, enrollmentId);

                return result;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting progress for enrollment {EnrollmentId}", enrollmentId);
                throw;
            }
        }

        #endregion

        #region Progress Update Operations

        /// <summary>
        /// Marks a specific lecture as completed for an enrollment
        /// </summary>
        /// <param name="enrollmentId">The enrollment identifier</param>
        /// <param name="lectureId">The lecture identifier</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>
        /// A task that represents the asynchronous operation
        /// The task result contains the updated course progress DTO
        /// </returns>
        public async Task<CourseProgressDto> MarkLectureAsCompletedAsync(int enrollmentId, int lectureId, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Marking lecture {LectureId} as completed for enrollment {EnrollmentId}",
                    lectureId, enrollmentId);

                var existingProgress = await _progressRepository.GetProgressAsync(enrollmentId, lectureId, cancellationToken);

                if (existingProgress != null)
                {
                    _logger.LogInformation("Updating existing progress record for enrollment {EnrollmentId} and lecture {LectureId}",
                        enrollmentId, lectureId);

                    existingProgress.IsCompleted = true;
                    var updatedProgress = await _progressRepository.UpdateProgressAsync(existingProgress, cancellationToken);
                    var result = _mapper.Map<CourseProgressDto>(updatedProgress);

                    _logger.LogInformation("Successfully updated progress record for enrollment {EnrollmentId} and lecture {LectureId}",
                        enrollmentId, lectureId);

                    return result;
                }
                else
                {
                    _logger.LogInformation("Creating new progress record for enrollment {EnrollmentId} and lecture {LectureId}",
                        enrollmentId, lectureId);

                    var newProgress = new CourseProgress
                    {
                        EnrollmentId = enrollmentId,
                        LectureId = lectureId,
                        IsCompleted = true
                    };

                    var createdProgress = await _progressRepository.CreateProgressAsync(newProgress, cancellationToken);
                    var result = _mapper.Map<CourseProgressDto>(createdProgress);

                    _logger.LogInformation("Successfully created progress record for enrollment {EnrollmentId} and lecture {LectureId}",
                        enrollmentId, lectureId);

                    return result;
                }
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error marking lecture {LectureId} as completed for enrollment {EnrollmentId}",
                    lectureId, enrollmentId);
                throw;
            }
        }

        /// <summary>
        /// Marks a specific lecture as incomplete for an enrollment
        /// </summary>
        /// <param name="enrollmentId">The enrollment identifier</param>
        /// <param name="lectureId">The lecture identifier</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>
        /// A task that represents the asynchronous operation
        /// The task result contains the updated course progress DTO or null if record not found
        /// </returns>
        public async Task<CourseProgressDto> MarkLectureAsIncompleteAsync(int enrollmentId, int lectureId, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Marking lecture {LectureId} as incomplete for enrollment {EnrollmentId}",
                    lectureId, enrollmentId);

                var existingProgress = await _progressRepository.GetProgressAsync(enrollmentId, lectureId, cancellationToken);

                if (existingProgress != null)
                {
                    _logger.LogInformation("Updating existing progress record to mark as incomplete for enrollment {EnrollmentId} and lecture {LectureId}",
                        enrollmentId, lectureId);

                    existingProgress.IsCompleted = false;
                    var updatedProgress = await _progressRepository.UpdateProgressAsync(existingProgress, cancellationToken);
                    var result = _mapper.Map<CourseProgressDto>(updatedProgress);

                    _logger.LogInformation("Successfully marked lecture {LectureId} as incomplete for enrollment {EnrollmentId}",
                        lectureId, enrollmentId);

                    return result;
                }

                _logger.LogWarning("Progress record not found for enrollment {EnrollmentId} and lecture {LectureId}",
                    enrollmentId, lectureId);
                return null;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error marking lecture {LectureId} as incomplete for enrollment {EnrollmentId}",
                    lectureId, enrollmentId);
                throw;
            }
        }

        /// <summary>
        /// Updates an existing course progress record or creates a new one if it doesn't exist
        /// </summary>
        /// <param name="progressDto">The progress data transfer object containing update information</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>
        /// A task that represents the asynchronous operation
        /// The task result contains the updated or created course progress DTO
        /// </returns>
        public async Task<CourseProgressDto> UpdateProgressAsync(UpdateCourseProgressDto progressDto, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Updating progress for enrollment {EnrollmentId} and lecture {LectureId}",
                    progressDto.EnrollmentId, progressDto.LectureId);

                var existingProgress = await _progressRepository.GetProgressAsync(progressDto.EnrollmentId, progressDto.LectureId, cancellationToken);

                if (existingProgress != null)
                {
                    _logger.LogInformation("Updating existing progress record for enrollment {EnrollmentId} and lecture {LectureId}",
                        progressDto.EnrollmentId, progressDto.LectureId);

                    _mapper.Map(progressDto, existingProgress);
                    var updatedProgress = await _progressRepository.UpdateProgressAsync(existingProgress, cancellationToken);
                    var result = _mapper.Map<CourseProgressDto>(updatedProgress);

                    _logger.LogInformation("Successfully updated progress record for enrollment {EnrollmentId} and lecture {LectureId}",
                        progressDto.EnrollmentId, progressDto.LectureId);

                    return result;
                }
                else
                {
                    _logger.LogInformation("Creating new progress record for enrollment {EnrollmentId} and lecture {LectureId}",
                        progressDto.EnrollmentId, progressDto.LectureId);

                    var newProgress = _mapper.Map<CourseProgress>(progressDto);
                    var createdProgress = await _progressRepository.CreateProgressAsync(newProgress, cancellationToken);
                    var result = _mapper.Map<CourseProgressDto>(createdProgress);

                    _logger.LogInformation("Successfully created progress record for enrollment {EnrollmentId} and lecture {LectureId}",
                        progressDto.EnrollmentId, progressDto.LectureId);

                    return result;
                }
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error updating progress for enrollment {EnrollmentId} and lecture {LectureId}",
                    progressDto.EnrollmentId, progressDto.LectureId);
                throw;
            }
        }

        #endregion

        #region Progress Management Operations

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

                var result = await _progressRepository.DeleteProgressAsync(progressId, cancellationToken);

                if (result)
                {
                    _logger.LogInformation("Successfully deleted progress record with ID: {ProgressId}", progressId);
                }
                else
                {
                    _logger.LogWarning("Progress record not found with ID: {ProgressId}", progressId);
                }

                return result;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error deleting progress record {ProgressId}", progressId);
                throw;
            }
        }

        #endregion

        #region Progress Analytics Operations

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

                var result = await _progressRepository.GetCompletedLecturesCountAsync(enrollmentId, cancellationToken);

                _logger.LogInformation("Found {Count} completed lectures for enrollment {EnrollmentId}", result, enrollmentId);
                return result;
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
                _logger.LogInformation("Checking if lecture {LectureId} is completed for enrollment {EnrollmentId}",
                    lectureId, enrollmentId);

                var result = await _progressRepository.IsLectureCompletedAsync(enrollmentId, lectureId, cancellationToken);

                _logger.LogInformation("Lecture {LectureId} completion status for enrollment {EnrollmentId}: {IsCompleted}",
                    lectureId, enrollmentId, result);

                return result;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error checking if lecture {LectureId} is completed for enrollment {EnrollmentId}",
                    lectureId, enrollmentId);
                throw;
            }
        }

        /// <summary>
        /// Gets a comprehensive progress summary for a specific enrollment
        /// </summary>
        /// <param name="enrollmentId">The enrollment identifier</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>
        /// A task that represents the asynchronous operation
        /// The task result contains the course progress summary DTO
        /// </returns>
        public async Task<CourseProgressSummaryDto> GetCourseProgressSummaryAsync(int enrollmentId, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Getting progress summary for enrollment {EnrollmentId}", enrollmentId);

                var enrollment = await _enrollmentRepository.GetEnrollmentByIdAsync(enrollmentId, cancellationToken);
                if (enrollment == null)
                {
                    _logger.LogWarning("Enrollment not found with ID: {EnrollmentId}", enrollmentId);
                    return null;
                }

                var totalLectures = enrollment.Course?.Sections?.Sum(s => s.Lectures?.Count ?? 0) ?? 0;
                var completedLectures = await GetCompletedLecturesCountAsync(enrollmentId, cancellationToken);
                var progressPercentage = await GetCourseProgressPercentageAsync(enrollmentId, cancellationToken);

                var summary = new CourseProgressSummaryDto
                {
                    EnrollmentId = enrollmentId,
                    CourseId = enrollment.CourseId,
                    CourseTitle = enrollment.Course?.Title,
                    TotalLectures = totalLectures,
                    CompletedLectures = completedLectures,
                    ProgressPercentage = progressPercentage,
                };

                _logger.LogInformation("Successfully generated progress summary for enrollment {EnrollmentId}: {Completed}/{Total} lectures ({Percentage}%)",
                    enrollmentId, completedLectures, totalLectures, progressPercentage);

                return summary;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting progress summary for enrollment {EnrollmentId}", enrollmentId);
                throw;
            }
        }

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

                var percentage = await _progressRepository.GetCourseProgressPercentageAsync(enrollmentId, cancellationToken);

                _logger.LogInformation("Progress percentage for enrollment {EnrollmentId}: {Percentage}%", enrollmentId, percentage);
                return percentage;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting progress percentage for enrollment {EnrollmentId}", enrollmentId);
                return 0;
            }
        }

        #endregion
    }
}
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
    public class CourseProgressService : ICourseProgressService
    {
        private readonly ICourseProgressRepository _progressRepository;
        private readonly IEnrollmentRepository _enrollmentRepository;
        private readonly IMapper _mapper;
        private readonly ILogger<CourseProgressService> _logger;

        public CourseProgressService(
            ICourseProgressRepository progressRepository,
            IEnrollmentRepository enrollmentRepository,
            IMapper mapper,
            ILogger<CourseProgressService> logger)
        {
            _progressRepository = progressRepository;
            _enrollmentRepository = enrollmentRepository;
            _mapper = mapper;
            _logger = logger;
        }

        public async Task<CourseProgressDto> GetProgressAsync(int enrollmentId, int lectureId, CancellationToken cancellationToken = default)
        {
            try
            {
                var progress = await _progressRepository.GetProgressAsync(enrollmentId, lectureId, cancellationToken);
                return _mapper.Map<CourseProgressDto>(progress);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting progress for enrollment {EnrollmentId} and lecture {LectureId}", enrollmentId, lectureId);
                throw;
            }
        }

        public async Task<List<CourseProgressDto>> GetProgressByEnrollmentAsync(int enrollmentId, CancellationToken cancellationToken = default)
        {
            try
            {
                var progressList = await _progressRepository.GetProgressByEnrollmentAsync(enrollmentId, cancellationToken);
                return _mapper.Map<List<CourseProgressDto>>(progressList);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting progress for enrollment {EnrollmentId}", enrollmentId);
                throw;
            }
        }

        public async Task<CourseProgressDto> MarkLectureAsCompletedAsync(int enrollmentId, int lectureId, CancellationToken cancellationToken = default)
        {
            try
            {
                var existingProgress = await _progressRepository.GetProgressAsync(enrollmentId, lectureId, cancellationToken);

                if (existingProgress != null)
                {
                    existingProgress.IsCompleted = true;
                    var updatedProgress = await _progressRepository.UpdateProgressAsync(existingProgress, cancellationToken);
                    return _mapper.Map<CourseProgressDto>(updatedProgress);
                }
                else
                {
                    var newProgress = new CourseProgress
                    {
                        EnrollmentId = enrollmentId,
                        LectureId = lectureId,
                        IsCompleted = true
                    };

                    var createdProgress = await _progressRepository.CreateProgressAsync(newProgress, cancellationToken);
                    return _mapper.Map<CourseProgressDto>(createdProgress);
                }
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error marking lecture {LectureId} as completed for enrollment {EnrollmentId}", lectureId, enrollmentId);
                throw;
            }
        }

        public async Task<CourseProgressDto> MarkLectureAsIncompleteAsync(int enrollmentId, int lectureId, CancellationToken cancellationToken = default)
        {
            try
            {
                var existingProgress = await _progressRepository.GetProgressAsync(enrollmentId, lectureId, cancellationToken);

                if (existingProgress != null)
                {
                    existingProgress.IsCompleted = false;
                    var updatedProgress = await _progressRepository.UpdateProgressAsync(existingProgress, cancellationToken);
                    return _mapper.Map<CourseProgressDto>(updatedProgress);
                }

                return null;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error marking lecture {LectureId} as incomplete for enrollment {EnrollmentId}", lectureId, enrollmentId);
                throw;
            }
        }

        public async Task<CourseProgressDto> UpdateProgressAsync(UpdateCourseProgressDto progressDto, CancellationToken cancellationToken = default)
        {
            try
            {
                var existingProgress = await _progressRepository.GetProgressAsync(progressDto.EnrollmentId, progressDto.LectureId, cancellationToken);

                if (existingProgress != null)
                {
                    _mapper.Map(progressDto, existingProgress);
                    var updatedProgress = await _progressRepository.UpdateProgressAsync(existingProgress, cancellationToken);
                    return _mapper.Map<CourseProgressDto>(updatedProgress);
                }
                else
                {
                    var newProgress = _mapper.Map<CourseProgress>(progressDto);
                    var createdProgress = await _progressRepository.CreateProgressAsync(newProgress, cancellationToken);
                    return _mapper.Map<CourseProgressDto>(createdProgress);
                }
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error updating progress for enrollment {EnrollmentId} and lecture {LectureId}",
                    progressDto.EnrollmentId, progressDto.LectureId);
                throw;
            }
        }

        public async Task<bool> DeleteProgressAsync(int progressId, CancellationToken cancellationToken = default)
        {
            try
            {
                return await _progressRepository.DeleteProgressAsync(progressId, cancellationToken);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error deleting progress record {ProgressId}", progressId);
                throw;
            }
        }

        public async Task<int> GetCompletedLecturesCountAsync(int enrollmentId, CancellationToken cancellationToken = default)
        {
            try
            {
                return await _progressRepository.GetCompletedLecturesCountAsync(enrollmentId, cancellationToken);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting completed lectures count for enrollment {EnrollmentId}", enrollmentId);
                throw;
            }
        }

        public async Task<bool> IsLectureCompletedAsync(int enrollmentId, int lectureId, CancellationToken cancellationToken = default)
        {
            try
            {
                return await _progressRepository.IsLectureCompletedAsync(enrollmentId, lectureId, cancellationToken);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error checking if lecture {LectureId} is completed for enrollment {EnrollmentId}", lectureId, enrollmentId);
                throw;
            }
        }

        public async Task<CourseProgressSummaryDto> GetCourseProgressSummaryAsync(int enrollmentId, CancellationToken cancellationToken = default)
        {
            try
            {
                var enrollment = await _enrollmentRepository.GetEnrollmentByIdAsync(enrollmentId, cancellationToken);
                if (enrollment == null)
                    return null;

                var totalLectures = enrollment.Course?.Sections?.Sum(s => s.Lectures?.Count ?? 0) ?? 0;
                var completedLectures = await GetCompletedLecturesCountAsync(enrollmentId, cancellationToken);
                var progressPercentage = await GetCourseProgressPercentageAsync(enrollmentId, cancellationToken);

                return new CourseProgressSummaryDto
                {
                    EnrollmentId = enrollmentId,
                    CourseId = enrollment.CourseId,
                    CourseTitle = enrollment.Course?.Title,
                    TotalLectures = totalLectures,
                    CompletedLectures = completedLectures,
                    ProgressPercentage = progressPercentage,
                };
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting progress summary for enrollment {EnrollmentId}", enrollmentId);
                throw;
            }
        }

        public async Task<decimal> GetCourseProgressPercentageAsync(int enrollmentId, CancellationToken cancellationToken = default)
        {
            try
            {
                return await _progressRepository.GetCourseProgressPercentageAsync(enrollmentId, cancellationToken);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting progress percentage for enrollment {EnrollmentId}", enrollmentId);
                return 0;
            }
        }
    }
}
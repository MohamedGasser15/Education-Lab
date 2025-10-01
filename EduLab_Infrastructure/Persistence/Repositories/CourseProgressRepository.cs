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
    public class CourseProgressRepository : ICourseProgressRepository
    {
        private readonly ApplicationDbContext _context;
        private readonly ILogger<CourseProgressRepository> _logger;

        public CourseProgressRepository(ApplicationDbContext context, ILogger<CourseProgressRepository> logger)
        {
            _context = context;
            _logger = logger;
        }

        public async Task<CourseProgress> GetProgressAsync(int enrollmentId, int lectureId, CancellationToken cancellationToken = default)
        {
            try
            {
                return await _context.CourseProgresses
                    .FirstOrDefaultAsync(p => p.EnrollmentId == enrollmentId && p.LectureId == lectureId, cancellationToken);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting progress for enrollment {EnrollmentId} and lecture {LectureId}", enrollmentId, lectureId);
                throw;
            }
        }

        public async Task<List<CourseProgress>> GetProgressByEnrollmentAsync(int enrollmentId, CancellationToken cancellationToken = default)
        {
            try
            {
                return await _context.CourseProgresses
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

        public async Task<CourseProgress> CreateProgressAsync(CourseProgress progress, CancellationToken cancellationToken = default)
        {
            try
            {
                _context.CourseProgresses.Add(progress);
                await _context.SaveChangesAsync(cancellationToken);
                return progress;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error creating progress record");
                throw;
            }
        }


        public async Task<CourseProgress> UpdateProgressAsync(CourseProgress progress, CancellationToken cancellationToken = default)
        {
            try
            {
                _context.CourseProgresses.Update(progress);
                await _context.SaveChangesAsync(cancellationToken);
                return progress;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error updating progress record {ProgressId}", progress.Id);
                throw;
            }
        }

        public async Task<bool> DeleteProgressAsync(int progressId, CancellationToken cancellationToken = default)
        {
            try
            {
                var progress = await _context.CourseProgresses.FindAsync(progressId);
                if (progress != null)
                {
                    _context.CourseProgresses.Remove(progress);
                    await _context.SaveChangesAsync(cancellationToken);
                    return true;
                }
                return false;
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
                return await _context.CourseProgresses
                    .CountAsync(p => p.EnrollmentId == enrollmentId && p.IsCompleted, cancellationToken);
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
                return await _context.CourseProgresses
                    .AnyAsync(p => p.EnrollmentId == enrollmentId && p.LectureId == lectureId && p.IsCompleted, cancellationToken);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error checking if lecture {LectureId} is completed for enrollment {EnrollmentId}", lectureId, enrollmentId);
                throw;
            }
        }

        public async Task<decimal> GetCourseProgressPercentageAsync(int enrollmentId, CancellationToken cancellationToken = default)
        {
            try
            {
                var enrollment = await _context.Enrollments
                    .Include(e => e.Course)
                    .ThenInclude(c => c.Sections)
                    .ThenInclude(s => s.Lectures)
                    .FirstOrDefaultAsync(e => e.Id == enrollmentId, cancellationToken);

                if (enrollment?.Course?.Sections == null)
                    return 0;

                var totalLectures = enrollment.Course.Sections.Sum(s => s.Lectures?.Count ?? 0);
                if (totalLectures == 0)
                    return 0;

                var completedLectures = await GetCompletedLecturesCountAsync(enrollmentId, cancellationToken);
                return (decimal)completedLectures / totalLectures * 100;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error calculating progress percentage for enrollment {EnrollmentId}", enrollmentId);
                return 0;
            }
        }
    }
}
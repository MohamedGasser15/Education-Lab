using AutoMapper;
using EduLab_Application.ServiceInterfaces;
using EduLab_Domain.Entities;
using EduLab_Domain.RepoInterfaces;
using EduLab_Shared.DTOs.Course;
using EduLab_Shared.DTOs.Lecture;
using EduLab_Shared.DTOs.Section;
using Microsoft.AspNetCore.Identity;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;

namespace EduLab_Application.Services
{
    /// <summary>
    /// Service implementation for course operations
    /// </summary>
    public class CourseService : ICourseService
    {
        private readonly ICourseRepository _courseRepository;
        private readonly IVideoDurationService _videoDurationService;
        private readonly ICurrentUserService _currentUserService;
        private readonly IHistoryService _historyService;
        private readonly UserManager<ApplicationUser> _userManager;
        private readonly IMapper _mapper;
        private readonly ILogger<CourseService> _logger;

        /// <summary>
        /// Initializes a new instance of the CourseService class
        /// </summary>
        public CourseService(
            ICourseRepository courseRepository,
            IVideoDurationService videoDurationService,
            ICurrentUserService currentUserService,
            IHistoryService historyService,
            UserManager<ApplicationUser> userManager,
            IMapper mapper,
            ILogger<CourseService> logger)
        {
            _courseRepository = courseRepository;
            _videoDurationService = videoDurationService;
            _currentUserService = currentUserService;
            _historyService = historyService;
            _userManager = userManager;
            _mapper = mapper;
            _logger = logger;
        }

        #region Private Helper Methods

        /// <summary>
        /// Calculates total duration from sections
        /// </summary>
        private int CalculateTotalDuration(IEnumerable<Section> sections)
        {
            if (sections == null || !sections.Any())
                return 0;

            return sections
                .SelectMany(s => s.Lectures ?? new List<Lecture>())
                .Sum(l => l.Duration);
        }

        /// <summary>
        /// Calculates lectures duration asynchronously
        /// </summary>
        private async Task CalculateLecturesDurationAsync(IEnumerable<Lecture> lectures, CancellationToken cancellationToken = default)
        {
            if (lectures == null) return;

            foreach (var lecture in lectures)
            {
                if (!string.IsNullOrEmpty(lecture.VideoUrl) && lecture.Duration == 0)
                {
                    try
                    {
                        lecture.Duration = await _videoDurationService.GetVideoDurationFromUrlAsync(lecture.VideoUrl, cancellationToken);
                    }
                    catch (Exception ex)
                    {
                        _logger.LogWarning(ex, "Error calculating duration for lecture: {LectureTitle}", lecture.Title);
                    }
                }
            }
        }

        /// <summary>
        /// Maps Course entity to CourseDTO with instructor information
        /// </summary>
        private async Task<CourseDTO> MapToCourseDTOAsync(Course course, CancellationToken cancellationToken = default)
        {
            try
            {
                var instructor = await _userManager.FindByIdAsync(course.InstructorId);
                var totalDuration = CalculateTotalDuration(course.Sections);

                var courseDto = _mapper.Map<CourseDTO>(course);
                courseDto.Duration = totalDuration;
                courseDto.TotalLectures = course.Sections?.Sum(s => s.Lectures?.Count ?? 0) ?? 0;

                // Map instructor information
                if (instructor != null)
                {
                    courseDto.InstructorName = instructor.FullName ?? "غير متوفر";
                    courseDto.InstructorAbout = instructor.About ?? "غير متوفر";
                    courseDto.InstructorTitle = instructor.Title ?? "غير متوفر";
                    courseDto.InstructorSubjects = instructor.Subjects ?? new List<string> { "غير متوفر" };

                    var instructorImage = instructor.ProfileImageUrl;
                    if (!string.IsNullOrEmpty(instructorImage) && !instructorImage.StartsWith("https"))
                    {
                        instructorImage = "https://localhost:7292" + instructorImage;
                    }
                    courseDto.ProfileImageUrl = instructorImage;
                }

                // Map sections and lectures
                if (course.Sections != null)
                {
                    courseDto.Sections = _mapper.Map<List<SectionDTO>>(course.Sections);
                }

                return courseDto;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error mapping course to DTO. Course ID: {CourseId}", course.Id);
                throw;
            }
        }

        /// <summary>
        /// Maps CourseCreateDTO to Course entity
        /// </summary>
        private async Task<Course> MapToCourseEntityAsync(CourseCreateDTO courseDto, CancellationToken cancellationToken = default)
        {
            try
            {
                var course = _mapper.Map<Course>(courseDto);
                course.CreatedAt = DateTime.UtcNow;
                course.Status = Enum.Parse<Coursestatus>(courseDto.Status);

                // Handle thumbnail URL
                course.ThumbnailUrl = string.IsNullOrEmpty(courseDto.ThumbnailUrl)
                    ? "/images/Courses/default.jpg"
                    : courseDto.ThumbnailUrl;

                // Map sections and lectures
                if (courseDto.Sections != null)
                {
                    course.Sections = _mapper.Map<List<Section>>(courseDto.Sections);

                    // Calculate lectures duration
                    foreach (var section in course.Sections)
                    {
                        await CalculateLecturesDurationAsync(section.Lectures, cancellationToken);
                    }
                }

                // Calculate total duration
                course.Duration = CalculateTotalDuration(course.Sections);

                return course;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error mapping CourseCreateDTO to Course entity");
                throw;
            }
        }

        #endregion

        #region Course Retrieval

        /// <summary>
        /// Gets all courses
        /// </summary>
        public async Task<IEnumerable<CourseDTO>> GetAllCoursesAsync(CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Getting all courses");

                var courses = await _courseRepository.GetAllAsync(
                    null,
                    "Category,Sections.Lectures",
                    false,
                    cancellationToken: cancellationToken);

                var courseDTOs = new List<CourseDTO>();

                foreach (var course in courses)
                {
                    var courseDto = await MapToCourseDTOAsync(course, cancellationToken);
                    courseDTOs.Add(courseDto);
                }

                return courseDTOs;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting all courses");
                throw;
            }
        }

        /// <summary>
        /// Gets course by ID
        /// </summary>
        public async Task<CourseDTO> GetCourseByIdAsync(int id, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Getting course by ID: {CourseId}", id);

                var course = await _courseRepository.GetCourseByIdAsync(id, false, cancellationToken);
                if (course == null)
                {
                    _logger.LogWarning("Course not found. ID: {CourseId}", id);
                    return null;
                }

                return await MapToCourseDTOAsync(course, cancellationToken);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting course by ID: {CourseId}", id);
                throw;
            }
        }

        /// <summary>
        /// Gets instructor courses
        /// </summary>
        public async Task<IEnumerable<CourseDTO>> GetInstructorCoursesAsync(string instructorId, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Getting courses for instructor ID: {InstructorId}", instructorId);

                var courses = await _courseRepository.GetCoursesByInstructorAsync(instructorId, cancellationToken);
                var courseDTOs = new List<CourseDTO>();

                foreach (var course in courses)
                {
                    var courseDto = await MapToCourseDTOAsync(course, cancellationToken);
                    courseDTOs.Add(courseDto);
                }

                return courseDTOs;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting courses for instructor ID: {InstructorId}", instructorId);
                throw;
            }
        }

        /// <summary>
        /// Gets latest instructor courses
        /// </summary>
        public async Task<IEnumerable<CourseDTO>> GetLatestInstructorCoursesAsync(string instructorId, int? count = null, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Getting latest courses for instructor ID: {InstructorId}, Count: {Count}",
                    instructorId, count);

                var courses = await _courseRepository.GetAllAsync(
                    filter: c => c.InstructorId == instructorId && c.Status == Coursestatus.Approved,
                    includeProperties: "Category,Sections.Lectures",
                    orderBy: q => q.OrderByDescending(c => c.CreatedAt),
                    take: count,
                    cancellationToken: cancellationToken);

                return courses.Select(c => _mapper.Map<CourseDTO>(c)).ToList();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting latest courses for instructor ID: {InstructorId}", instructorId);
                throw;
            }
        }

        /// <summary>
        /// Gets courses with category
        /// </summary>
        public async Task<IEnumerable<CourseDTO>> GetCoursesWithCategoryAsync(int categoryId, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Getting courses for category ID: {CategoryId}", categoryId);

                var courses = await _courseRepository.GetCoursesWithCategoryAsync(categoryId, cancellationToken);
                return courses.Select(c => _mapper.Map<CourseDTO>(c)).ToList();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting courses for category ID: {CategoryId}", categoryId);
                throw;
            }
        }

        /// <summary>
        /// Gets approved courses by instructor
        /// </summary>
        public async Task<IEnumerable<CourseDTO>> GetApprovedCoursesByInstructorAsync(string instructorId, int count, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Getting {Count} approved courses for instructor ID: {InstructorId}",
                    count, instructorId);

                var courses = await _courseRepository.GetApprovedCoursesByInstructorAsync(instructorId, count, cancellationToken);
                return courses.Select(c => _mapper.Map<CourseDTO>(c)).ToList();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting approved courses for instructor ID: {InstructorId}", instructorId);
                throw;
            }
        }

        /// <summary>
        /// Gets approved courses by categories
        /// </summary>
        public async Task<IEnumerable<CourseDTO>> GetApprovedCoursesByCategoriesAsync(List<int> categoryIds, int countPerCategory, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Getting approved courses for {CategoryCount} categories", categoryIds.Count);

                var courses = await _courseRepository.GetApprovedCoursesByCategoriesAsync(categoryIds, countPerCategory, cancellationToken);
                var courseDTOs = new List<CourseDTO>();

                foreach (var course in courses)
                {
                    var courseDto = await MapToCourseDTOAsync(course, cancellationToken);
                    courseDTOs.Add(courseDto);
                }

                return courseDTOs;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting approved courses by categories");
                throw;
            }
        }

        /// <summary>
        /// Gets approved courses by category
        /// </summary>
        public async Task<IEnumerable<CourseDTO>> GetApprovedCoursesByCategoryAsync(int categoryId, int count, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Getting {Count} approved courses for category ID: {CategoryId}", count, categoryId);

                var courses = await _courseRepository.GetApprovedCoursesByCategoryAsync(categoryId, count, cancellationToken);
                var courseDTOs = new List<CourseDTO>();

                foreach (var course in courses)
                {
                    var courseDto = await MapToCourseDTOAsync(course, cancellationToken);
                    courseDTOs.Add(courseDto);
                }

                return courseDTOs;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting approved courses for category ID: {CategoryId}", categoryId);
                throw;
            }
        }

        #endregion

        #region Course Management

        /// <summary>
        /// Adds a new course
        /// </summary>
        public async Task<CourseDTO> AddCourseAsync(CourseCreateDTO courseDto, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Adding new course: {CourseTitle}", courseDto.Title);

                var course = await MapToCourseEntityAsync(courseDto, cancellationToken);
                var addedCourse = await _courseRepository.AddAsync(course, cancellationToken);

                // Log operation
                var currentUserId = await _currentUserService.GetUserIdAsync();
                if (!string.IsNullOrEmpty(currentUserId))
                {
                    await _historyService.LogOperationAsync(
                        currentUserId,
                        $"قام المستخدم بإضافة كورس جديد [ID: {addedCourse.Id}] بعنوان \"{addedCourse.Title}\".",
                        cancellationToken);
                }

                return await MapToCourseDTOAsync(addedCourse, cancellationToken);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error adding new course: {CourseTitle}", courseDto.Title);
                throw;
            }
        }

        /// <summary>
        /// Adds a new course as instructor
        /// </summary>
        public async Task<CourseDTO> AddCourseAsInstructorAsync(CourseCreateDTO courseDto, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Adding new course as instructor: {CourseTitle}", courseDto.Title);

                // Get current user ID
                var instructorId = await _currentUserService.GetUserIdAsync();
                if (string.IsNullOrEmpty(instructorId))
                {
                    throw new UnauthorizedAccessException("User is not authenticated");
                }

                var course = await MapToCourseEntityAsync(courseDto, cancellationToken);
                course.InstructorId = instructorId;

                var addedCourse = await _courseRepository.AddAsync(course, cancellationToken);

                // Log operation
                await _historyService.LogOperationAsync(
                    instructorId,
                    $"قام المستخدم بإضافة كورس جديد [ID: {addedCourse.Id}] بعنوان \"{addedCourse.Title}\".",
                    cancellationToken);

                return await MapToCourseDTOAsync(addedCourse, cancellationToken);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error adding new course as instructor: {CourseTitle}", courseDto.Title);
                throw;
            }
        }

        /// <summary>
        /// Updates an existing course
        /// </summary>
        public async Task<CourseDTO> UpdateCourseAsync(CourseUpdateDTO courseDto, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Updating course ID: {CourseId}", courseDto.Id);

                var existingCourse = await _courseRepository.GetCourseByIdAsync(courseDto.Id, true, cancellationToken);
                if (existingCourse == null)
                {
                    _logger.LogWarning("Course not found for update. ID: {CourseId}", courseDto.Id);
                    return null;
                }

                // Update course properties
                _mapper.Map(courseDto, existingCourse);

                // Update sections and lectures
                if (courseDto.Sections != null)
                {
                    existingCourse.Sections = _mapper.Map<List<Section>>(courseDto.Sections);

                    // Calculate lectures duration
                    foreach (var section in existingCourse.Sections)
                    {
                        await CalculateLecturesDurationAsync(section.Lectures, cancellationToken);
                    }
                }

                // Calculate total duration
                existingCourse.Duration = CalculateTotalDuration(existingCourse.Sections);

                var updatedCourse = await _courseRepository.UpdateAsync(existingCourse, cancellationToken);

                // Log operation
                var currentUserId = await _currentUserService.GetUserIdAsync();
                if (!string.IsNullOrEmpty(currentUserId))
                {
                    await _historyService.LogOperationAsync(
                        currentUserId,
                        $"قام المستخدم بتعديل الكورس [ID: {updatedCourse.Id}] بعنوان \"{updatedCourse.Title}\".",
                        cancellationToken);
                }

                return await MapToCourseDTOAsync(updatedCourse, cancellationToken);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error updating course ID: {CourseId}", courseDto.Id);
                throw;
            }
        }

        /// <summary>
        /// Updates an existing course as instructor
        /// </summary>
        public async Task<CourseDTO> UpdateCourseAsInstructorAsync(CourseUpdateDTO courseDto, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Updating course as instructor. ID: {CourseId}", courseDto.Id);

                // Get current user ID
                var instructorId = await _currentUserService.GetUserIdAsync();
                if (string.IsNullOrEmpty(instructorId))
                {
                    throw new UnauthorizedAccessException("المستخدم غير مسجل دخول");
                }

                var existingCourse = await _courseRepository.GetCourseByIdAsync(courseDto.Id, true, cancellationToken);
                if (existingCourse == null)
                {
                    _logger.LogWarning("Course not found for update. ID: {CourseId}", courseDto.Id);
                    return null;
                }

                // Verify ownership
                if (existingCourse.InstructorId != instructorId)
                {
                    throw new UnauthorizedAccessException("لا يمكن تعديل كورس لا يخصك");
                }

                // Update course properties
                _mapper.Map(courseDto, existingCourse);

                // Update sections and lectures
                if (courseDto.Sections != null)
                {
                    existingCourse.Sections = _mapper.Map<List<Section>>(courseDto.Sections);

                    // Calculate lectures duration
                    foreach (var section in existingCourse.Sections)
                    {
                        await CalculateLecturesDurationAsync(section.Lectures, cancellationToken);
                    }
                }

                // Calculate total duration
                existingCourse.Duration = CalculateTotalDuration(existingCourse.Sections);

                var updatedCourse = await _courseRepository.UpdateAsync(existingCourse, cancellationToken);

                // Log operation
                await _historyService.LogOperationAsync(
                    instructorId,
                    $"قام المستخدم بتعديل الكورس [ID: {updatedCourse.Id}] بعنوان \"{updatedCourse.Title}\".",
                    cancellationToken);

                return await MapToCourseDTOAsync(updatedCourse, cancellationToken);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error updating course as instructor. ID: {CourseId}", courseDto.Id);
                throw;
            }
        }

        /// <summary>
        /// Deletes a course
        /// </summary>
        public async Task<bool> DeleteCourseAsync(int id, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Deleting course ID: {CourseId}", id);

                var course = await _courseRepository.GetCourseByIdAsync(id, false, cancellationToken);
                var result = await _courseRepository.DeleteAsync(id, cancellationToken);

                if (result && course != null)
                {
                    // Log operation
                    var currentUserId = await _currentUserService.GetUserIdAsync();
                    if (!string.IsNullOrEmpty(currentUserId))
                    {
                        await _historyService.LogOperationAsync(
                            currentUserId,
                            $"قام المستخدم بحذف الكورس [ID: {course.Id}] بعنوان \"{course.Title}\".",
                            cancellationToken);
                    }
                }

                return result;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error deleting course ID: {CourseId}", id);
                throw;
            }
        }

        /// <summary>
        /// Deletes a course as instructor
        /// </summary>
        public async Task<bool> DeleteCourseAsInstructorAsync(int id, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Deleting course as instructor. ID: {CourseId}", id);

                var course = await _courseRepository.GetCourseByIdAsync(id, false, cancellationToken);
                if (course == null)
                {
                    _logger.LogWarning("Course not found for deletion. ID: {CourseId}", id);
                    return false;
                }

                // Get current user ID
                var instructorId = await _currentUserService.GetUserIdAsync();
                if (string.IsNullOrEmpty(instructorId))
                {
                    throw new UnauthorizedAccessException("المستخدم غير مسجل دخول");
                }

                // Verify ownership
                if (course.InstructorId != instructorId)
                {
                    throw new UnauthorizedAccessException("لا يمكن حذف كورس لا يخصك");
                }

                var result = await _courseRepository.DeleteAsync(id, cancellationToken);

                if (result)
                {
                    // Log operation
                    await _historyService.LogOperationAsync(
                        instructorId,
                        $"قام المستخدم بحذف الكورس [ID: {course.Id}] بعنوان \"{course.Title}\".",
                        cancellationToken);
                }

                return result;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error deleting course as instructor. ID: {CourseId}", id);
                throw;
            }
        }

        #endregion

        #region Bulk Operations

        /// <summary>
        /// Bulk delete courses
        /// </summary>
        public async Task<bool> BulkDeleteCoursesAsync(List<int> ids, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Bulk deleting courses. Count: {Count}", ids.Count);

                var courses = await _courseRepository.GetAllAsync(c => ids.Contains(c.Id), cancellationToken: cancellationToken);
                var result = await _courseRepository.BulkDeleteAsync(ids, cancellationToken);

                if (result && courses.Any())
                {
                    // Log operation
                    var currentUserId = await _currentUserService.GetUserIdAsync();
                    if (!string.IsNullOrEmpty(currentUserId))
                    {
                        var titles = string.Join(", ", courses.Select(c => c.Title));
                        await _historyService.LogOperationAsync(
                            currentUserId,
                            $"قام المستخدم بحذف الكورسات التالية: {titles}.",
                            cancellationToken);
                    }
                }

                return result;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error in bulk delete operation");
                throw;
            }
        }

        /// <summary>
        /// Bulk delete courses as instructor
        /// </summary>
        public async Task<bool> BulkDeleteCoursesAsInstructorAsync(List<int> ids, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Bulk deleting courses as instructor. Count: {Count}", ids.Count);

                // Get current user ID
                var instructorId = await _currentUserService.GetUserIdAsync();
                if (string.IsNullOrEmpty(instructorId))
                {
                    throw new UnauthorizedAccessException("المستخدم غير مسجل دخول");
                }

                var courses = await _courseRepository.GetAllAsync(
                    c => ids.Contains(c.Id) && c.InstructorId == instructorId,
                    cancellationToken: cancellationToken);

                if (!courses.Any())
                {
                    _logger.LogWarning("No courses found for bulk deletion by instructor");
                    return false;
                }

                var idsToDelete = courses.Select(c => c.Id).ToList();
                var result = await _courseRepository.BulkDeleteAsync(idsToDelete, cancellationToken);

                if (result)
                {
                    // Log operation
                    var titles = string.Join(", ", courses.Select(c => c.Title));
                    await _historyService.LogOperationAsync(
                        instructorId,
                        $"قام المستخدم بحذف الكورسات التالية: {titles}.",
                        cancellationToken);
                }

                return result;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error in bulk delete operation as instructor");
                throw;
            }
        }

        /// <summary>
        /// Bulk publish courses
        /// </summary>
        public async Task<bool> BulkPublishCoursesAsync(List<int> ids, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Bulk publishing courses. Count: {Count}", ids.Count);

                var courses = await _courseRepository.GetAllAsync(c => ids.Contains(c.Id), cancellationToken: cancellationToken);
                var result = await _courseRepository.BulkUpdateStatusAsync(ids, Coursestatus.Approved, cancellationToken);

                if (result && courses.Any())
                {
                    // Log operation
                    var currentUserId = await _currentUserService.GetUserIdAsync();
                    if (!string.IsNullOrEmpty(currentUserId))
                    {
                        var titles = string.Join(", ", courses.Select(c => c.Title));
                        await _historyService.LogOperationAsync(
                            currentUserId,
                            $"قام المستخدم بالموافقة على الكورسات التالية: {titles}.",
                            cancellationToken);
                    }
                }

                return result;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error in bulk publish operation");
                throw;
            }
        }

        /// <summary>
        /// Bulk unpublish courses
        /// </summary>
        public async Task<bool> BulkUnpublishCoursesAsync(List<int> ids, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Bulk unpublishing courses. Count: {Count}", ids.Count);

                var courses = await _courseRepository.GetAllAsync(c => ids.Contains(c.Id), cancellationToken: cancellationToken);
                var result = await _courseRepository.BulkUpdateStatusAsync(ids, Coursestatus.Rejected, cancellationToken);

                if (result && courses.Any())
                {
                    // Log operation
                    var currentUserId = await _currentUserService.GetUserIdAsync();
                    if (!string.IsNullOrEmpty(currentUserId))
                    {
                        var titles = string.Join(", ", courses.Select(c => c.Title));
                        await _historyService.LogOperationAsync(
                            currentUserId,
                            $"قام المستخدم برفض الكورسات التالية: {titles}.",
                            cancellationToken);
                    }
                }

                return result;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error in bulk unpublish operation");
                throw;
            }
        }

        #endregion

        #region Status Management

        /// <summary>
        /// Accepts a course
        /// </summary>
        public async Task<bool> AcceptCourseAsync(int id, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Accepting course ID: {CourseId}", id);

                var course = await _courseRepository.GetCourseByIdAsync(id, false, cancellationToken);
                var result = await _courseRepository.UpdateStatusAsync(id, Coursestatus.Approved, cancellationToken);

                if (result && course != null)
                {
                    // Log operation
                    var currentUserId = await _currentUserService.GetUserIdAsync();
                    if (!string.IsNullOrEmpty(currentUserId))
                    {
                        await _historyService.LogOperationAsync(
                            currentUserId,
                            $"قام المستخدم بالموافقة على الكورس [ID: {course.Id}] بعنوان \"{course.Title}\".",
                            cancellationToken);
                    }
                }

                return result;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error accepting course ID: {CourseId}", id);
                throw;
            }
        }

        /// <summary>
        /// Rejects a course
        /// </summary>
        public async Task<bool> RejectCourseAsync(int id, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Rejecting course ID: {CourseId}", id);

                var course = await _courseRepository.GetCourseByIdAsync(id, false, cancellationToken);
                var result = await _courseRepository.UpdateStatusAsync(id, Coursestatus.Rejected, cancellationToken);

                if (result && course != null)
                {
                    // Log operation
                    var currentUserId = await _currentUserService.GetUserIdAsync();
                    if (!string.IsNullOrEmpty(currentUserId))
                    {
                        await _historyService.LogOperationAsync(
                            currentUserId,
                            $"قام المستخدم برفض الكورس [ID: {course.Id}] بعنوان \"{course.Title}\".",
                            cancellationToken);
                    }
                }

                return result;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error rejecting course ID: {CourseId}", id);
                throw;
            }
        }

        #endregion
    }
}
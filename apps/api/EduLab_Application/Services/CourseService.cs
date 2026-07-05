using AutoMapper;
using EduLab_Application.ServiceInterfaces;
using EduLab_Domain.Entities;
using EduLab_Domain.IRepository;
using EduLab_Application.DTOs.Course;
using EduLab_Application.DTOs.Lecture;
using EduLab_Application.DTOs.Notification;
using EduLab_Application.DTOs.Section;
using Microsoft.AspNetCore.Http;
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
        private readonly IRatingService _ratingService;
        private readonly ICurrentUserService _currentUserService;
        private readonly IHistoryService _historyService;
        private readonly UserManager<ApplicationUser> _userManager;
        private readonly IMapper _mapper;
        private readonly ILogger<CourseService> _logger;
        private readonly IEmailTemplateService _emailTemplateService;
        private readonly IEmailSender _emailSender;
        private readonly IFileStorageService _fileStorageService;
        private readonly INotificationService _notificationService;
        private readonly IEnrollmentRepository _enrollmentRepository;
        /// <summary>
        /// Initializes a new instance of the CourseService class
        /// </summary>GetLectureResources
        public CourseService(
            ICourseRepository courseRepository,
            IVideoDurationService videoDurationService,
            ICurrentUserService currentUserService,
            IHistoryService historyService,
            UserManager<ApplicationUser> userManager,
            IMapper mapper,
            IEmailTemplateService emailTemplateService,
            IEmailSender emailSender,
            ILogger<CourseService> logger,
            IFileStorageService fileStorageService,
            IRatingService ratingService, INotificationService notificationService, // إضافة الـ notification service
            IEnrollmentRepository enrollmentRepository)
        {
            _courseRepository = courseRepository;
            _videoDurationService = videoDurationService;
            _currentUserService = currentUserService;
            _historyService = historyService;
            _userManager = userManager;
            _mapper = mapper;
            _logger = logger;
            _emailTemplateService = emailTemplateService;
            _emailSender = emailSender;
            _fileStorageService = fileStorageService;
            _ratingService = ratingService;
            _notificationService = notificationService;
            _enrollmentRepository = enrollmentRepository;
        }


        #region Course Retrieval
        /// <summary>
        /// Retrieves all resources for a specific lecture.
        /// </summary>
        public async Task<List<LectureResourceDTO>> GetLectureResourcesAsync(int lectureId, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Getting resources for lecture ID: {LectureId}", lectureId);

                var resources = await _courseRepository.GetLectureResourcesAsync(lectureId, cancellationToken);

                return _mapper.Map<List<LectureResourceDTO>>(resources);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting resources for lecture ID: {LectureId}", lectureId);
                throw; // نخلي الكنترولر يتعامل مع الخطأ ويرجع الاستجابة المناسبة
            }
        }
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
        #region Lecture Resources Operations

        /// <summary>
        /// Adds a resource to a lecture
        /// </summary>
        public async Task<LectureResourceDTO> AddResourceToLectureAsync(int lectureId, IFormFile resourceFile, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Adding resource to lecture ID: {LectureId}", lectureId);

                // التحقق من وجود المحاضرة
                var lecture = await _courseRepository.GetAsync(
                    l => l.Id == lectureId,
                    includeProperties: "Resources,Section",
                    isTracking: true,
                    cancellationToken: cancellationToken
                );

                if (lecture == null)
                    throw new ArgumentException("المحاضرة غير موجودة");

                // رفع الملف
                var fileUrl = await _fileStorageService.UploadFileAsync(resourceFile, "Resources/Lectures", cancellationToken);
                if (string.IsNullOrEmpty(fileUrl))
                    throw new InvalidOperationException("فشل رفع الملف، FileUrl رجع null");

                // إنشاء الـ Resource
                var resource = new LectureResource
                {
                    FileName = resourceFile.FileName,
                    FileUrl = fileUrl,
                    FileType = Path.GetExtension(resourceFile.FileName),
                    FileSize = resourceFile.Length,
                    LectureId = lectureId
                };

                var addedResource = await _courseRepository.AddResourceAsync(resource, cancellationToken);
                return _mapper.Map<LectureResourceDTO>(addedResource);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error adding resource to lecture ID: {LectureId}", lectureId);
                throw;
            }
        }

        /// <summary>
        /// Deletes a resource
        /// </summary>
        public async Task<bool> DeleteResourceAsync(int resourceId, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Deleting resource ID: {ResourceId}", resourceId);
                return await _courseRepository.DeleteResourceAsync(resourceId, cancellationToken);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error deleting resource ID: {ResourceId}", resourceId);
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

                // إنشاء إشعار للمدرس
                await CreateInstructorCourseNotificationAsync(addedCourse, instructorId, cancellationToken);

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

                // تحديث الخصائص الأساسية - بنفس طريقة الـ Add
                _mapper.Map(courseDto, existingCourse);

                // تحديث الـ Sections والـ Lectures - بنفس طريقة الـ Add
                if (courseDto.Sections != null)
                {
                    existingCourse.Sections = _mapper.Map<List<Section>>(courseDto.Sections);

                    // حساب مدة المحاضرات
                    foreach (var section in existingCourse.Sections)
                    {
                        await CalculateLecturesDurationAsync(section.Lectures, cancellationToken);
                    }
                }

                // حساب المدة الكلية
                existingCourse.Duration = CalculateTotalDuration(existingCourse.Sections);

                var updatedCourse = await _courseRepository.UpdateAsync(existingCourse, cancellationToken);

                // 🔔 إرسال إشعار للطلاب المسجلين في الكورس
                await NotifyEnrolledStudentsAboutCourseUpdateAsync(updatedCourse, cancellationToken);

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
                await NotifyEnrolledStudentsAboutCourseUpdateAsync(updatedCourse, cancellationToken);
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
                if (course == null)
                {
                    _logger.LogWarning("Course not found for deletion. ID: {CourseId}", id);
                    return false;
                }

                // Check for enrollments before deletion
                var enrollments = await _enrollmentRepository.GetAllAsync(e => e.CourseId == id, cancellationToken: cancellationToken);
                if (enrollments != null && enrollments.Any())
                {
                    _logger.LogWarning("Cannot delete course {CourseId} because it has {Count} enrolled students", id, enrollments.Count());
                    throw new InvalidOperationException($"لا يمكن حذف الكورس \"{course.Title}\" لوجود {enrollments.Count()} طلاب مسجلين به.");
                }

                await NotifyEnrolledStudentsAboutCourseDeletionAsync(course, cancellationToken);

                await _notificationService.CreateNotificationAsync(new CreateNotificationDto
                {
                    Title = "تم حذف أحد كورساتك",
                    Message = $"تم حذف الكورس '{course.Title}' من قبل الإدارة.",
                    Type = NotificationTypeDto.System,
                    UserId = course.InstructorId,
                    RelatedEntityId = course.Id.ToString(),
                    RelatedEntityType = "Course"
                });

                var result = await _courseRepository.DeleteAsync(id, cancellationToken);

                if (result)
                {
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
                    await NotifyEnrolledStudentsAboutCourseDeletionAsync(course, cancellationToken);

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

        #region Draft Course Operations

        public async Task<CourseDTO> CreateCourseDraftAsync(CourseDraftDTO draftDto, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Creating course draft: {CourseTitle}", draftDto.Title);

                var instructorId = await _currentUserService.GetUserIdAsync();
                if (string.IsNullOrEmpty(instructorId))
                    throw new UnauthorizedAccessException("User is not authenticated");

                var thumbnailUrl = "/images/Courses/default.jpg";
                if (draftDto.Image != null && draftDto.Image.Length > 0)
                {
                    thumbnailUrl = await _fileStorageService.UploadFileAsync(draftDto.Image, "Images/Courses", cancellationToken);
                }

                var course = new Course
                {
                    Title = draftDto.Title,
                    ShortDescription = draftDto.ShortDescription ?? "",
                    Description = draftDto.Description ?? "",
                    Price = draftDto.Price,
                    Discount = draftDto.Discount,
                    CategoryId = draftDto.CategoryId,
                    Level = draftDto.Level ?? "beginner",
                    Language = draftDto.Language ?? "ar",
                    HasCertificate = draftDto.HasCertificate,
                    TargetAudience = draftDto.TargetAudience ?? "",
                    Requirements = draftDto.Requirements ?? new List<string>(),
                    Learnings = draftDto.Learnings ?? new List<string>(),
                    InstructorId = instructorId,
                    Status = Coursestatus.Draft,
                    CreatedAt = DateTime.UtcNow,
                    Sections = new List<Section>(),
                    ThumbnailUrl = thumbnailUrl
                };

                var addedCourse = await _courseRepository.AddAsync(course, cancellationToken);

                await _historyService.LogOperationAsync(
                    instructorId,
                    $"قام المستخدم بإنشاء مسودة كورس [ID: {addedCourse.Id}] بعنوان \"{addedCourse.Title}\".",
                    cancellationToken);

                return await MapToCourseDTOAsync(addedCourse, cancellationToken);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error creating course draft: {CourseTitle}", draftDto.Title);
                throw;
            }
        }

        public async Task<CourseDTO> UpdateCourseDetailsAsync(int courseId, CourseUpdateDTO courseDto, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Updating course details. ID: {CourseId}", courseId);

                var instructorId = await _currentUserService.GetUserIdAsync();
                if (string.IsNullOrEmpty(instructorId))
                    throw new UnauthorizedAccessException("المستخدم غير مسجل دخول");

                var existingCourse = await _courseRepository.GetCourseByIdAsync(courseId, true, cancellationToken);
                if (existingCourse == null)
                {
                    _logger.LogWarning("Course not found for details update. ID: {CourseId}", courseId);
                    return null;
                }

                if (existingCourse.InstructorId != instructorId)
                    throw new UnauthorizedAccessException("لا يمكن تعديل كورس لا يخصك");

                if (existingCourse.Status != Coursestatus.Draft)
                    throw new InvalidOperationException("يمكن تعديل التفاصيل فقط للكورسات في حالة المسودة");

                existingCourse.Title = courseDto.Title ?? existingCourse.Title;
                existingCourse.ShortDescription = courseDto.ShortDescription ?? existingCourse.ShortDescription;
                existingCourse.Description = courseDto.Description ?? existingCourse.Description;
                existingCourse.Price = courseDto.Price;
                existingCourse.Discount = courseDto.Discount;
                existingCourse.CategoryId = courseDto.CategoryId;
                existingCourse.Level = courseDto.Level ?? existingCourse.Level;
                existingCourse.Language = courseDto.Language ?? existingCourse.Language;
                existingCourse.HasCertificate = courseDto.HasCertificate;
                existingCourse.Requirements = courseDto.Requirements ?? existingCourse.Requirements;
                existingCourse.Learnings = courseDto.Learnings ?? existingCourse.Learnings;
                existingCourse.TargetAudience = courseDto.TargetAudience ?? existingCourse.TargetAudience;

                if (!string.IsNullOrEmpty(courseDto.ThumbnailUrl))
                    existingCourse.ThumbnailUrl = courseDto.ThumbnailUrl;

                var updatedCourse = await _courseRepository.UpdateAsync(existingCourse, cancellationToken);

                await _historyService.LogOperationAsync(
                    instructorId,
                    $"قام المستخدم بتعديل تفاصيل الكورس [ID: {updatedCourse.Id}] بعنوان \"{updatedCourse.Title}\".",
                    cancellationToken);

                return await MapToCourseDTOAsync(updatedCourse, cancellationToken);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error updating course details. ID: {CourseId}", courseId);
                throw;
            }
        }

        #endregion

        #region Section Operations

        public async Task<SectionDTO> AddSectionAsync(SectionCreateDTO sectionDto, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Adding section: {SectionTitle} to course ID: {CourseId}", sectionDto.Title, sectionDto.CourseId);

                var course = await _courseRepository.GetCourseByIdAsync(sectionDto.CourseId, false, cancellationToken);
                if (course == null)
                    throw new ArgumentException("الكورس غير موجود");

                var section = new Section
                {
                    Title = sectionDto.Title,
                    CourseId = sectionDto.CourseId
                };

                var addedSection = await _courseRepository.AddSectionAsync(section, cancellationToken);
                return _mapper.Map<SectionDTO>(addedSection);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error adding section: {SectionTitle}", sectionDto.Title);
                throw;
            }
        }

        public async Task<SectionDTO> UpdateSectionAsync(int sectionId, SectionUpdateDTO sectionDto, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Updating section ID: {SectionId}", sectionId);

                var section = await _courseRepository.GetSectionByIdAsync(sectionId, cancellationToken);
                if (section == null)
                    throw new ArgumentException("القسم غير موجود");

                section.Title = sectionDto.Title;
                var updatedSection = await _courseRepository.UpdateSectionAsync(section, cancellationToken);
                return _mapper.Map<SectionDTO>(updatedSection);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error updating section ID: {SectionId}", sectionId);
                throw;
            }
        }

        public async Task<bool> DeleteSectionAsync(int sectionId, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Deleting section ID: {SectionId}", sectionId);
                return await _courseRepository.DeleteSectionAsync(sectionId, cancellationToken);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error deleting section ID: {SectionId}", sectionId);
                throw;
            }
        }

        public async Task<bool> ReorderSectionsAsync(int courseId, List<int> sectionIds, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Reordering sections for course ID: {CourseId}", courseId);
                return await _courseRepository.ReorderSectionsAsync(courseId, sectionIds, cancellationToken);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error reordering sections for course ID: {CourseId}", courseId);
                throw;
            }
        }

        public async Task<SectionDTO> GetSectionByIdAsync(int sectionId, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogDebug("Getting section by ID: {SectionId}", sectionId);

                var section = await _courseRepository.GetSectionByIdAsync(sectionId, cancellationToken);
                if (section == null) return null;

                return _mapper.Map<SectionDTO>(section);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting section by ID: {SectionId}", sectionId);
                throw;
            }
        }

        #endregion

        #region Lecture Operations

        public async Task<LectureDTO> AddLectureAsync(LectureCreateDTO lectureDto, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Adding lecture: {LectureTitle} to section ID: {SectionId}", lectureDto.Title, lectureDto.SectionId);

                var lecture = new Lecture
                {
                    Title = lectureDto.Title,
                    Description = lectureDto.Description,
                    ContentType = Enum.Parse<ContentType>(lectureDto.ContentType, true),
                    IsFreePreview = lectureDto.IsFreePreview,
                    SectionId = lectureDto.SectionId,
                    Duration = lectureDto.Duration
                };

                if (lectureDto.ContentType?.ToLower() == "video" && lectureDto.Video != null)
                {
                    lecture.VideoUrl = await _fileStorageService.UploadFileAsync(lectureDto.Video, "Videos/Courses", cancellationToken) ?? "";
                }
                else if (lectureDto.ContentType?.ToLower() != "video")
                {
                    lecture.VideoUrl = "";
                    lecture.ArticleContent = lectureDto.ArticleContent;
                }

                var addedLecture = await _courseRepository.AddLectureAsync(lecture, cancellationToken);

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

                return _mapper.Map<LectureDTO>(addedLecture);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error adding lecture: {LectureTitle}", lectureDto.Title);
                throw;
            }
        }

        public async Task<LectureDTO> UpdateLectureAsync(int lectureId, LectureUpdateDTO lectureDto, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Updating lecture ID: {LectureId}", lectureId);

                var existingLecture = await _courseRepository.GetLectureByIdAsync(lectureId, cancellationToken);
                if (existingLecture == null)
                    throw new ArgumentException("المحاضرة غير موجودة");

                existingLecture.Title = lectureDto.Title;
                existingLecture.Description = lectureDto.Description;
                existingLecture.ContentType = Enum.Parse<ContentType>(lectureDto.ContentType, true);
                existingLecture.IsFreePreview = lectureDto.IsFreePreview;
                existingLecture.Duration = lectureDto.Duration;
                existingLecture.ArticleContent = lectureDto.ArticleContent ?? existingLecture.ArticleContent;

                if (lectureDto.Video != null)
                {
                    if (!string.IsNullOrEmpty(existingLecture.VideoUrl))
                        _fileStorageService.DeleteVideoFileIfExists(existingLecture.VideoUrl);

                    existingLecture.VideoUrl = await _fileStorageService.UploadFileAsync(lectureDto.Video, "Videos/Courses", cancellationToken) ?? "";
                }

                var updatedLecture = await _courseRepository.UpdateLectureAsync(existingLecture, cancellationToken);
                return _mapper.Map<LectureDTO>(updatedLecture);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error updating lecture ID: {LectureId}", lectureId);
                throw;
            }
        }

        public async Task<bool> DeleteLectureAsync(int lectureId, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Deleting lecture ID: {LectureId}", lectureId);

                var lecture = await _courseRepository.GetLectureByIdAsync(lectureId, cancellationToken);
                if (lecture != null && !string.IsNullOrEmpty(lecture.VideoUrl))
                    _fileStorageService.DeleteVideoFileIfExists(lecture.VideoUrl);

                return await _courseRepository.DeleteLectureAsync(lectureId, cancellationToken);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error deleting lecture ID: {LectureId}", lectureId);
                throw;
            }
        }

        public async Task<bool> ReorderLecturesAsync(int sectionId, List<int> lectureIds, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Reordering lectures for section ID: {SectionId}", sectionId);
                return await _courseRepository.ReorderLecturesAsync(sectionId, lectureIds, cancellationToken);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error reordering lectures for section ID: {SectionId}", sectionId);
                throw;
            }
        }

        public async Task<LectureDTO> GetLectureByIdAsync(int lectureId, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogDebug("Getting lecture by ID: {LectureId}", lectureId);

                var lecture = await _courseRepository.GetLectureByIdAsync(lectureId, cancellationToken);
                if (lecture == null) return null;

                return _mapper.Map<LectureDTO>(lecture);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting lecture by ID: {LectureId}", lectureId);
                throw;
            }
        }

        #endregion

        #region Publish Operations

        public async Task<List<string>> ValidateCourseForPublishAsync(int courseId, CancellationToken cancellationToken = default)
        {
            var errors = new List<string>();

            try
            {
                var course = await _courseRepository.GetCourseByIdAsync(courseId, true, cancellationToken);
                if (course == null)
                {
                    errors.Add("الكورس غير موجود");
                    return errors;
                }

                _logger.LogInformation("Validating course {Id} for publish: Requirements={ReqCount}, Learnings={LearnCount}, Title='{Title}', Price={Price}, Thumbnail='{Thumb}'",
                    course.Id,
                    course.Requirements?.Count ?? 0,
                    course.Learnings?.Count ?? 0,
                    course.Title,
                    course.Price,
                    course.ThumbnailUrl);

                if (string.IsNullOrWhiteSpace(course.Title))
                    errors.Add("عنوان الكورس مطلوب");

                if (string.IsNullOrWhiteSpace(course.ShortDescription))
                    errors.Add("الوصف القصير للكورس مطلوب");

                if (course.CategoryId == 0)
                    errors.Add("التصنيف مطلوب");

                if (string.IsNullOrWhiteSpace(course.ThumbnailUrl))
                    errors.Add("صورة الكورس مطلوبة");

                if (course.Sections == null || !course.Sections.Any())
                {
                    errors.Add("يجب إضافة قسم واحد على الأقل");
                }
                else
                {
                    foreach (var section in course.Sections)
                    {
                        if (string.IsNullOrWhiteSpace(section.Title))
                            errors.Add($"القسم رقم {section.Order} يجب أن يكون له عنوان");

                        if (section.Lectures == null || !section.Lectures.Any())
                            errors.Add($"القسم \"{section.Title}\" يجب أن يحتوي على محاضرة واحدة على الأقل");
                        else
                        {
                            foreach (var lecture in section.Lectures)
                            {
                                if (string.IsNullOrWhiteSpace(lecture.Title))
                                    errors.Add($"محاضرة في القسم \"{section.Title}\" يجب أن يكون لها عنوان");
                            }
                        }
                    }
                }

                if (course.Requirements == null || course.Requirements.Count < 3)
                    errors.Add("يجب إضافة 3 متطلبات على الأقل");

                if (course.Learnings == null || course.Learnings.Count < 3)
                    errors.Add("يجب إضافة 3 مخرجات تعلم على الأقل");

                if (string.IsNullOrWhiteSpace(course.TargetAudience))
                    errors.Add("الجمهور المستهدف مطلوب");

                if (course.Price < 0)
                    errors.Add("السعر يجب أن يكون 0 أو أكثر");

                return errors;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error validating course for publish. ID: {CourseId}", courseId);
                throw;
            }
        }

        public async Task<PublishResultDTO> PublishCourseAsync(int courseId, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Publishing course ID: {CourseId}", courseId);

                var errors = await ValidateCourseForPublishAsync(courseId, cancellationToken);
                if (errors.Any())
                {
                    return new PublishResultDTO { Success = false, Errors = errors };
                }

                var instructorId = await _currentUserService.GetUserIdAsync();
                var course = await _courseRepository.GetCourseByIdAsync(courseId, true, cancellationToken);

                if (course.InstructorId != instructorId)
                    throw new UnauthorizedAccessException("لا يمكن نشر كورس لا يخصك");

                course.Status = Coursestatus.Pending;

                // Recalculate total duration
                course.Duration = CalculateTotalDuration(course.Sections);
                foreach (var section in course.Sections)
                {
                    await CalculateLecturesDurationAsync(section.Lectures, cancellationToken);
                }

                await _courseRepository.UpdateAsync(course, cancellationToken);

                await _historyService.LogOperationAsync(
                    instructorId,
                    $"قام المستخدم بنشر الكورس [ID: {course.Id}] بعنوان \"{course.Title}\" وهو الآن قيد المراجعة.",
                    cancellationToken);

                await CreateInstructorCourseNotificationAsync(course, instructorId, cancellationToken);

                _logger.LogInformation("Course published successfully. ID: {CourseId}", courseId);
                return new PublishResultDTO { Success = true };
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error publishing course ID: {CourseId}", courseId);
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
                
                // Check for enrollments in any of the courses
                foreach (var id in ids)
                {
                    var enrollments = await _enrollmentRepository.GetAllAsync(e => e.CourseId == id, cancellationToken: cancellationToken);
                    if (enrollments != null && enrollments.Any())
                    {
                        var courseTitle = courses.FirstOrDefault(c => c.Id == id)?.Title ?? id.ToString();
                        _logger.LogWarning("Cannot bulk delete courses because course {CourseId} has enrolled students", id);
                        throw new InvalidOperationException($"لا يمكن حذف الكورسات المحددة لوجود طلاب مسجلين في الكورس \"{courseTitle}\".");
                    }
                }

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
                if (course == null)
                {
                    _logger.LogWarning("Course not found for acceptance. ID: {CourseId}", id);
                    return false;
                }

                var result = await _courseRepository.UpdateStatusAsync(id, Coursestatus.Approved, cancellationToken);

                if (result)
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

                    // Send approval email to instructor
                    await SendCourseStatusEmailAsync(course, true, cancellationToken);

                    // إنشاء إشعار للمدرس بقبول الكورس
                    await CreateCourseApprovalNotificationAsync(course, cancellationToken);

                    await NotifyInstructorStudentsAboutNewCourseAsync(course, cancellationToken);
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
                if (course == null)
                {
                    _logger.LogWarning("Course not found for rejection. ID: {CourseId}", id);
                    return false;
                }

                var result = await _courseRepository.UpdateStatusAsync(id, Coursestatus.Rejected, cancellationToken);

                if (result)
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

                    // Send rejection email to instructor
                    await SendCourseStatusEmailAsync(course, false, cancellationToken);

                    await CreateCourseRejectionNotificationAsync(course, cancellationToken);
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

        #region Private Notification Methods

        /// <summary>
        /// إنشاء إشعار للمدرس عند إضافة كورس جديد
        /// </summary>
        private async Task CreateInstructorCourseNotificationAsync(Course course, string instructorId, CancellationToken cancellationToken = default)
        {
            try
            {
                var notificationDto = new CreateNotificationDto
                {
                    Title = "تم إضافة الكورس بنجاح",
                    Message = $"تم إضافة كورس '{course.Title}' بنجاح وهو الآن قيد المراجعة. سيتم إعلامك عند الموافقة عليه.",
                    Type = NotificationTypeDto.System,
                    UserId = instructorId,
                    RelatedEntityId = course.Id.ToString(),
                    RelatedEntityType = "Course"
                };

                await _notificationService.CreateNotificationAsync(notificationDto);
                _logger.LogInformation("Course creation notification sent to instructor {InstructorId}", instructorId);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error sending course creation notification to instructor {InstructorId}", instructorId);
            }
        }

        /// <summary>
        /// إنشاء إشعار للمدرس عند قبول الكورس
        /// </summary>
        private async Task CreateCourseApprovalNotificationAsync(Course course, CancellationToken cancellationToken = default)
        {
            try
            {
                var notificationDto = new CreateNotificationDto
                {
                    Title = "تم الموافقة على الكورس",
                    Message = $"تم الموافقة على كورسك '{course.Title}' وهو الآن متاح للطلاب.",
                    Type = NotificationTypeDto.System,
                    UserId = course.InstructorId,
                    RelatedEntityId = course.Id.ToString(),
                    RelatedEntityType = "Course"
                };

                await _notificationService.CreateNotificationAsync(notificationDto);
                _logger.LogInformation("Course approval notification sent to instructor {InstructorId}", course.InstructorId);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error sending course approval notification to instructor {InstructorId}", course.InstructorId);
            }
        }

        /// <summary>
        /// إنشاء إشعار للمدرس عند رفض الكورس
        /// </summary>
        private async Task CreateCourseRejectionNotificationAsync(Course course, CancellationToken cancellationToken = default)
        {
            try
            {
                var notificationDto = new CreateNotificationDto
                {
                    Title = "تم رفض الكورس",
                    Message = $"تم رفض كورس '{course.Title}'. يرجى مراجعة محتوى الكورس وتقديمه مرة أخرى.",
                    Type = NotificationTypeDto.System,
                    UserId = course.InstructorId,
                    RelatedEntityId = course.Id.ToString(),
                    RelatedEntityType = "Course"
                };

                await _notificationService.CreateNotificationAsync(notificationDto);
                _logger.LogInformation("Course rejection notification sent to instructor {InstructorId}", course.InstructorId);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error sending course rejection notification to instructor {InstructorId}", course.InstructorId);
            }
        }

        /// <summary>
        /// إرسال إشعارات لجميع الطلاب اللي اشتروا من الـ Instructor ده قبل كده
        /// </summary>
        private async Task NotifyInstructorStudentsAboutNewCourseAsync(Course newCourse, CancellationToken cancellationToken = default)
        {
            try
            {
                // جلب جميع الكورسات القديمة للـ Instructor
                var instructorCourses = await _courseRepository.GetAllAsync(
                    c => c.InstructorId == newCourse.InstructorId && c.Id != newCourse.Id && c.Status == Coursestatus.Approved,
                    cancellationToken: cancellationToken);

                if (!instructorCourses.Any())
                {
                    _logger.LogInformation("No previous courses found for instructor {InstructorId}", newCourse.InstructorId);
                    return;
                }

                // جلب جميع الـ enrollments للكورسات القديمة
                var courseIds = instructorCourses.Select(c => c.Id).ToList();
                var allEnrollments = await _enrollmentRepository.GetAllAsync(
                    e => courseIds.Contains(e.CourseId),
                    includeProperties: "User",
                    cancellationToken: cancellationToken);

                // تجميع الـ User IDs بدون تكرار
                var distinctUserIds = allEnrollments.Select(e => e.UserId).Distinct().ToList();

                _logger.LogInformation("Found {Count} unique students for instructor {InstructorId}", distinctUserIds.Count, newCourse.InstructorId);

                // إرسال إشعار لكل طالب
                foreach (var userId in distinctUserIds)
                {
                    var notificationDto = new CreateNotificationDto
                    {
                        Title = "كورس جديد من المدرس المفضل",
                        Message = $"المدرس الذي اشترت منه من قبل قد أضاف كورس جديد '{newCourse.Title}'. تحقق منه الآن!",
                        Type = NotificationTypeDto.Promotional,
                        UserId = userId,
                        RelatedEntityId = newCourse.Id.ToString(),
                        RelatedEntityType = "Course"
                    };

                    await _notificationService.CreateNotificationAsync(notificationDto);
                }

                _logger.LogInformation("New course notifications sent to {Count} students of instructor {InstructorId}",
                    distinctUserIds.Count, newCourse.InstructorId);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error sending new course notifications to instructor students for course {CourseId}", newCourse.Id);
            }
        }

        /// <summary>
        /// Sends notifications to all students enrolled in a specific course when the instructor updates it.
        /// </summary>
        private async Task NotifyEnrolledStudentsAboutCourseUpdateAsync(Course updatedCourse, CancellationToken cancellationToken = default)
        {
            try
            {
                var enrollments = await _enrollmentRepository.GetAllAsync(
                    e => e.CourseId == updatedCourse.Id,
                    includeProperties: "User",
                    cancellationToken: cancellationToken);

                if (enrollments == null || !enrollments.Any())
                {
                    _logger.LogInformation("No enrolled students found for course {CourseId}", updatedCourse.Id);
                    return;
                }

                var distinctUserIds = enrollments.Select(e => e.UserId).Distinct().ToList();

                _logger.LogInformation("Found {Count} students enrolled in course {CourseId}", distinctUserIds.Count, updatedCourse.Id);

                foreach (var userId in distinctUserIds)
                {
                    var notificationDto = new CreateNotificationDto
                    {
                        Title = "تحديث جديد على الكورس",
                        Message = $"تم تحديث محتوى الكورس '{updatedCourse.Title}' الذي أنت مسجل فيه. تحقق من التغييرات الآن!",
                        Type = NotificationTypeDto.Course,
                        UserId = userId,
                        RelatedEntityId = updatedCourse.Id.ToString(),
                        RelatedEntityType = "Course"
                    };

                    await _notificationService.CreateNotificationAsync(notificationDto);
                }

                _logger.LogInformation("Course update notifications sent to {Count} students for course {CourseId}", distinctUserIds.Count, updatedCourse.Id);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error sending course update notifications for course {CourseId}", updatedCourse.Id);
            }
        }

        /// <summary>
        /// Sends notifications to all students enrolled in a course when it gets deleted.
        /// </summary>
        private async Task NotifyEnrolledStudentsAboutCourseDeletionAsync(Course deletedCourse, CancellationToken cancellationToken = default)
        {
            try
            {
                // جلب كل الطلاب المسجلين في الكورس
                var enrollments = await _enrollmentRepository.GetAllAsync(
                    e => e.CourseId == deletedCourse.Id,
                    includeProperties: "User",
                    cancellationToken: cancellationToken);

                if (enrollments == null || !enrollments.Any())
                {
                    _logger.LogInformation("No enrolled students found for deleted course {CourseId}", deletedCourse.Id);
                    return;
                }

                // IDs بدون تكرار
                var distinctUserIds = enrollments.Select(e => e.UserId).Distinct().ToList();

                _logger.LogInformation("Found {Count} enrolled students for deleted course {CourseId}", distinctUserIds.Count, deletedCourse.Id);

                // إرسال إشعار لكل طالب
                foreach (var userId in distinctUserIds)
                {
                    var notificationDto = new CreateNotificationDto
                    {
                        Title = "تم حذف كورس مسجل فيه",
                        Message = $"تم حذف الكورس '{deletedCourse.Title}' الذي كنت مسجلًا فيه. يُرجى مراجعة لوحة التحكم الخاصة بك.",
                        Type = NotificationTypeDto.System,
                        UserId = userId,
                        RelatedEntityId = deletedCourse.Id.ToString(),
                        RelatedEntityType = "Course"
                    };

                    await _notificationService.CreateNotificationAsync(notificationDto);
                }

                _logger.LogInformation("Course deletion notifications sent to {Count} students for course {CourseId}", distinctUserIds.Count, deletedCourse.Id);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error sending course deletion notifications for course {CourseId}", deletedCourse.Id);
            }
        }

        #endregion


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

                // جلب بيانات التقييمات
                var ratingSummary = await _ratingService.GetCourseRatingSummaryAsync(course.Id);
                if (ratingSummary != null)
                {
                    courseDto.AverageRating = ratingSummary.AverageRating;
                    courseDto.TotalRatings = ratingSummary.TotalRatings;
                    courseDto.RatingDistribution = ratingSummary.RatingDistribution;
                }

                // جلب عدد الطلاب المسجلين
                var enrollments = await _enrollmentRepository.GetAllAsync(e => e.CourseId == course.Id, cancellationToken: cancellationToken);
                courseDto.EnrollmentCount = enrollments?.Count() ?? 0;

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

                    // إضافة الـ Resources لكل lecture
                    foreach (var sectionDto in courseDto.Sections)
                    {
                        foreach (var lectureDto in sectionDto.Lectures)
                        {
                            var resources = await _courseRepository.GetLectureResourcesAsync(lectureDto.Id, cancellationToken);
                            lectureDto.Resources = _mapper.Map<List<LectureResourceDTO>>(resources);
                        }
                    }
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

        /// <summary>
        /// Sends course status email to instructor (approval/rejection)
        /// </summary>
        private async Task SendCourseStatusEmailAsync(Course course, bool isApproved, CancellationToken cancellationToken = default)
        {
            try
            {
                // Get instructor information
                var instructor = await _userManager.FindByIdAsync(course.InstructorId);
                if (instructor == null || string.IsNullOrEmpty(instructor.Email))
                {
                    _logger.LogWarning("Instructor not found or email is empty for course ID: {CourseId}", course.Id);
                    return;
                }

                string emailSubject;
                string emailBody;

                // Generate course link (you might need to adjust this based on your routing)
                string courseLink = $"https://edulab.com/course/{course.Id}";

                if (isApproved)
                {
                    emailSubject = $"EduLab - تمت الموافقة على دورتك: {course.Title}";
                    emailBody = _emailTemplateService.GenerateCourseApprovalEmail(instructor, course.Title, courseLink);
                }
                else
                {
                    emailSubject = $"EduLab - قرار بشأن دورتك: {course.Title}";
                    emailBody = _emailTemplateService.GenerateCourseRejectionEmail(instructor, course.Title);
                }

                // Send email
                await _emailSender.SendEmailAsync(instructor.Email, emailSubject, emailBody);

                _logger.LogInformation("Course status email sent to instructor {InstructorEmail} for course {CourseId}",
                    instructor.Email, course.Id);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error sending course status email for course ID: {CourseId}", course.Id);
                // Don't throw the exception to avoid affecting the main operation
            }
        }
        #endregion
    }
}
using AutoMapper;
using EduLab_Application.ServiceInterfaces;
using EduLab_Domain.Entities;
using EduLab_Domain.RepoInterfaces;
using EduLab_Shared.DTOs.Course;
using EduLab_Shared.DTOs.Profile;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Logging;
using System;
using System.IO;
using System.Threading;
using System.Threading.Tasks;

namespace EduLab_Application.Services
{
    /// <summary>
    /// Service implementation for profile management operations
    /// </summary>
    public class ProfileService : IProfileService
    {
        #region Fields
        private readonly IProfileRepository _profileRepository;
        private readonly IMapper _mapper;
        private readonly IWebHostEnvironment _webHostEnvironment;
        private readonly ICourseService _courseService;
        private readonly ILogger<ProfileService> _logger;
        #endregion

        #region Constructor
        /// <summary>
        /// Initializes a new instance of the ProfileService class
        /// </summary>
        /// <param name="profileRepository">Profile repository instance</param>
        /// <param name="mapper">AutoMapper instance</param>
        /// <param name="webHostEnvironment">Web host environment instance</param>
        /// <param name="courseService">Course service instance</param>
        /// <param name="logger">Logger instance</param>
        public ProfileService(
            IProfileRepository profileRepository,
            IMapper mapper,
            IWebHostEnvironment webHostEnvironment,
            ICourseService courseService,
            ILogger<ProfileService> logger)
        {
            _profileRepository = profileRepository ?? throw new ArgumentNullException(nameof(profileRepository));
            _mapper = mapper ?? throw new ArgumentNullException(nameof(mapper));
            _webHostEnvironment = webHostEnvironment ?? throw new ArgumentNullException(nameof(webHostEnvironment));
            _courseService = courseService ?? throw new ArgumentNullException(nameof(courseService));
            _logger = logger ?? throw new ArgumentNullException(nameof(logger));
        }
        #endregion

        #region User Profile Operations
        /// <inheritdoc/>
        public async Task<ProfileDTO?> GetUserProfileAsync(string userId, CancellationToken cancellationToken = default)
        {
            const string operationName = nameof(GetUserProfileAsync);

            try
            {
                _logger.LogDebug("Starting {OperationName} for user ID: {UserId}", operationName, userId);

                if (string.IsNullOrEmpty(userId))
                {
                    _logger.LogWarning("User ID is null or empty in {OperationName}", operationName);
                    return null;
                }

                var user = await _profileRepository.GetUserProfileAsync(userId, cancellationToken);
                if (user == null)
                {
                    _logger.LogWarning("User not found with ID: {UserId} in {OperationName}", userId, operationName);
                    return null;
                }

                var profileDto = _mapper.Map<ProfileDTO>(user);

                // Set social links
                profileDto.SocialLinks = new SocialLinksDTO
                {
                    GitHub = user.GitHubUrl,
                    LinkedIn = user.LinkedInUrl,
                    Twitter = user.TwitterUrl,
                    Facebook = user.FacebookUrl
                };

                _logger.LogInformation("Successfully retrieved user profile for ID: {UserId}", userId);
                return profileDto;
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {OperationName} was cancelled for user ID: {UserId}", operationName, userId);
                throw;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred in {OperationName} for user ID: {UserId}", operationName, userId);
                throw;
            }
        }

        /// <inheritdoc/>
        public async Task<bool> UpdateUserProfileAsync(UpdateProfileDTO updateProfileDto, CancellationToken cancellationToken = default)
        {
            const string operationName = nameof(UpdateUserProfileAsync);

            try
            {
                _logger.LogDebug("Starting {OperationName} for user ID: {UserId}", operationName, updateProfileDto.Id);

                if (updateProfileDto == null)
                {
                    _logger.LogWarning("UpdateProfileDTO is null in {OperationName}", operationName);
                    return false;
                }

                var user = await _profileRepository.GetUserProfileAsync(updateProfileDto.Id, cancellationToken);
                if (user == null)
                {
                    _logger.LogWarning("User not found with ID: {UserId} in {OperationName}", updateProfileDto.Id, operationName);
                    return false;
                }

                // إنشاء كيان جديد بدلاً من تعديل الكيان المُتتبع
                var updatedUser = new ApplicationUser
                {
                    Id = user.Id,
                    FullName = updateProfileDto.FullName ?? user.FullName,
                    Title = updateProfileDto.Title ?? user.Title,
                    Location = updateProfileDto.Location ?? user.Location,
                    PhoneNumber = updateProfileDto.PhoneNumber ?? user.PhoneNumber,
                    About = updateProfileDto.About ?? user.About,
                    GitHubUrl = updateProfileDto.SocialLinks?.GitHub ?? user.GitHubUrl,
                    LinkedInUrl = updateProfileDto.SocialLinks?.LinkedIn ?? user.LinkedInUrl,
                    TwitterUrl = updateProfileDto.SocialLinks?.Twitter ?? user.TwitterUrl,
                    FacebookUrl = updateProfileDto.SocialLinks?.Facebook ?? user.FacebookUrl,
                    UserName = user.UserName,
                    Email = user.Email,
                    NormalizedUserName = user.NormalizedUserName,
                    NormalizedEmail = user.NormalizedEmail,
                    EmailConfirmed = user.EmailConfirmed,
                    PasswordHash = user.PasswordHash,
                    SecurityStamp = user.SecurityStamp,
                    ConcurrencyStamp = user.ConcurrencyStamp,
                    PhoneNumberConfirmed = user.PhoneNumberConfirmed,
                    TwoFactorEnabled = user.TwoFactorEnabled,
                    LockoutEnd = user.LockoutEnd,
                    LockoutEnabled = user.LockoutEnabled,
                    AccessFailedCount = user.AccessFailedCount,
                    ProfileImageUrl = user.ProfileImageUrl,
                    CreatedAt = user.CreatedAt,
                    Subjects = user.Subjects
                };

                var success = await _profileRepository.UpdateUserProfileAsync(updatedUser, cancellationToken);

                _logger.LogInformation("User profile update {Status} for user ID: {UserId}",
                    success ? "succeeded" : "failed", updateProfileDto.Id);

                return success;
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {OperationName} was cancelled for user ID: {UserId}", operationName, updateProfileDto.Id);
                throw;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred in {OperationName} for user ID: {UserId}", operationName, updateProfileDto.Id);
                throw;
            }
        }

        /// <inheritdoc/>
        public async Task<string?> UploadProfileImageAsync(ProfileImageDTO profileImageDto, CancellationToken cancellationToken = default)
        {
            const string operationName = nameof(UploadProfileImageAsync);

            try
            {
                _logger.LogDebug("Starting {OperationName} for user ID: {UserId}", operationName, profileImageDto.UserId);

                if (profileImageDto?.ImageFile == null || profileImageDto.ImageFile.Length == 0)
                {
                    _logger.LogWarning("No image file provided in {OperationName}", operationName);
                    throw new ArgumentException("لم يتم تحميل صورة");
                }

                // Create uploads directory if it doesn't exist
                var uploadsFolder = Path.Combine(_webHostEnvironment.WebRootPath, "Images", "profiles");
                if (!Directory.Exists(uploadsFolder))
                {
                    Directory.CreateDirectory(uploadsFolder);
                    _logger.LogDebug("Created uploads directory: {UploadsFolder}", uploadsFolder);
                }

                // Generate unique file name
                var uniqueFileName = $"{Guid.NewGuid()}_{profileImageDto.ImageFile.FileName}";
                var filePath = Path.Combine(uploadsFolder, uniqueFileName);

                // Save the file
                using (var stream = new FileStream(filePath, FileMode.Create))
                {
                    await profileImageDto.ImageFile.CopyToAsync(stream, cancellationToken);
                }

                // Create image URL
                var imageUrl = $"/Images/profiles/{uniqueFileName}";

                // Update profile image in database
                var success = await _profileRepository.UpdateProfileImageAsync(profileImageDto.UserId, imageUrl, cancellationToken);

                if (!success)
                {
                    _logger.LogError("Failed to update profile image in database for user ID: {UserId}", profileImageDto.UserId);
                    throw new Exception("فشل في تحديث صورة البروفايل");
                }

                _logger.LogInformation("Successfully uploaded profile image for user ID: {UserId}. Image URL: {ImageUrl}",
                    profileImageDto.UserId, imageUrl);

                return imageUrl;
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {OperationName} was cancelled for user ID: {UserId}", operationName, profileImageDto.UserId);
                throw;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred in {OperationName} for user ID: {UserId}", operationName, profileImageDto.UserId);
                throw;
            }
        }
        #endregion

        #region Instructor Profile Operations
        /// <inheritdoc/>
        public async Task<InstructorProfileDTO?> GetInstructorProfileAsync(string userId, int latestCoursesCount = 2, CancellationToken cancellationToken = default)
        {
            const string operationName = nameof(GetInstructorProfileAsync);

            try
            {
                _logger.LogDebug("Starting {OperationName} for user ID: {UserId}", operationName, userId);

                if (string.IsNullOrEmpty(userId))
                {
                    _logger.LogWarning("User ID is null or empty in {OperationName}", operationName);
                    return null;
                }

                var user = await _profileRepository.GetInstructorProfileAsync(userId, cancellationToken);
                if (user == null)
                {
                    _logger.LogWarning("Instructor not found with ID: {UserId} in {OperationName}", userId, operationName);
                    return null;
                }

                var profileDto = _mapper.Map<InstructorProfileDTO>(user);

                // Set social links
                profileDto.SocialLinks = new SocialLinksDTO
                {
                    GitHub = user.GitHubUrl,
                    LinkedIn = user.LinkedInUrl,
                    Twitter = user.TwitterUrl,
                    Facebook = user.FacebookUrl
                };

                // Set subjects and certificates
                profileDto.Subjects = user.Subjects ?? new List<string>();
                profileDto.Certificates = user.Certificates?
                    .Select(c => _mapper.Map<CertificateDTO>(c))
                    .ToList() ?? new List<CertificateDTO>();

                // Get latest courses
                var latestCourses = await _courseService.GetLatestInstructorCoursesAsync(user.Id, latestCoursesCount, cancellationToken);
                profileDto.Courses = latestCourses?.ToList() ?? new List<CourseDTO>();

                _logger.LogInformation("Successfully retrieved instructor profile for ID: {UserId}", userId);
                return profileDto;
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {OperationName} was cancelled for user ID: {UserId}", operationName, userId);
                throw;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred in {OperationName} for user ID: {UserId}", operationName, userId);
                throw;
            }
        }

        /// <inheritdoc/>
        public async Task<InstructorProfileDTO?> GetPublishInstructorProfileAsync(string userId, CancellationToken cancellationToken = default)
        {
            const string operationName = nameof(GetPublishInstructorProfileAsync);

            try
            {
                _logger.LogDebug("Starting {OperationName} for user ID: {UserId}", operationName, userId);

                if (string.IsNullOrEmpty(userId))
                {
                    _logger.LogWarning("User ID is null or empty in {OperationName}", operationName);
                    return null;
                }

                var user = await _profileRepository.GetInstructorProfileAsync(userId, cancellationToken);
                if (user == null)
                {
                    _logger.LogWarning("Instructor not found with ID: {UserId} in {OperationName}", userId, operationName);
                    return null;
                }

                var profileDto = _mapper.Map<InstructorProfileDTO>(user);

                // Set social links
                profileDto.SocialLinks = new SocialLinksDTO
                {
                    GitHub = user.GitHubUrl,
                    LinkedIn = user.LinkedInUrl,
                    Twitter = user.TwitterUrl,
                    Facebook = user.FacebookUrl
                };

                // Set subjects and certificates
                profileDto.Subjects = user.Subjects ?? new List<string>();
                profileDto.Certificates = user.Certificates?
                    .Select(c => _mapper.Map<CertificateDTO>(c))
                    .ToList() ?? new List<CertificateDTO>();

                // Get latest courses
                var latestCourses = await _courseService.GetLatestInstructorCoursesAsync(user.Id, cancellationToken: cancellationToken);
                profileDto.Courses = latestCourses?.ToList() ?? new List<CourseDTO>();

                _logger.LogInformation("Successfully retrieved public instructor profile for ID: {UserId}", userId);
                return profileDto;
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {OperationName} was cancelled for user ID: {UserId}", operationName, userId);
                throw;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred in {OperationName} for user ID: {UserId}", operationName, userId);
                throw;
            }
        }

        /// <inheritdoc/>
        public async Task<bool> UpdateInstructorProfileAsync(UpdateInstructorProfileDTO updateProfileDto, CancellationToken cancellationToken = default)
        {
            const string operationName = nameof(UpdateInstructorProfileAsync);

            try
            {
                _logger.LogDebug("Starting {OperationName} for user ID: {UserId}", operationName, updateProfileDto.Id);

                if (updateProfileDto == null)
                {
                    _logger.LogWarning("UpdateInstructorProfileDTO is null in {OperationName}", operationName);
                    return false;
                }

                var user = await _profileRepository.GetInstructorProfileAsync(updateProfileDto.Id, cancellationToken);
                if (user == null)
                {
                    _logger.LogWarning("Instructor not found with ID: {UserId} in {OperationName}", updateProfileDto.Id, operationName);
                    return false;
                }

                // إنشاء كيان جديد بدلاً من تعديل الكيان المُتتبع
                var updatedUser = new ApplicationUser
                {
                    Id = user.Id,
                    FullName = updateProfileDto.FullName ?? user.FullName,
                    Title = updateProfileDto.Title ?? user.Title,
                    Location = updateProfileDto.Location ?? user.Location,
                    PhoneNumber = updateProfileDto.PhoneNumber ?? user.PhoneNumber,
                    About = updateProfileDto.About ?? user.About,
                    GitHubUrl = updateProfileDto.SocialLinks?.GitHub ?? user.GitHubUrl,
                    LinkedInUrl = updateProfileDto.SocialLinks?.LinkedIn ?? user.LinkedInUrl,
                    TwitterUrl = updateProfileDto.SocialLinks?.Twitter ?? user.TwitterUrl,
                    FacebookUrl = updateProfileDto.SocialLinks?.Facebook ?? user.FacebookUrl,
                    Subjects = updateProfileDto.Subjects ?? user.Subjects,
                    // الحفاظ على القيم الأخرى
                    UserName = user.UserName,
                    Email = user.Email,
                    NormalizedUserName = user.NormalizedUserName,
                    NormalizedEmail = user.NormalizedEmail,
                    EmailConfirmed = user.EmailConfirmed,
                    PasswordHash = user.PasswordHash,
                    SecurityStamp = user.SecurityStamp,
                    ConcurrencyStamp = user.ConcurrencyStamp,
                    TwoFactorEnabled = user.TwoFactorEnabled,
                    LockoutEnd = user.LockoutEnd,
                    LockoutEnabled = user.LockoutEnabled,
                    AccessFailedCount = user.AccessFailedCount,
                    ProfileImageUrl = user.ProfileImageUrl,
                    CreatedAt = user.CreatedAt,
                    Certificates = user.Certificates
                };

                var success = await _profileRepository.UpdateInstructorProfileAsync(updatedUser, cancellationToken);

                _logger.LogInformation("Instructor profile update {Status} for user ID: {UserId}",
                    success ? "succeeded" : "failed", updateProfileDto.Id);

                return success;
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {OperationName} was cancelled for user ID: {UserId}", operationName, updateProfileDto.Id);
                throw;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred in {OperationName} for user ID: {UserId}", operationName, updateProfileDto.Id);
                throw;
            }
        }

        /// <inheritdoc/>
        public async Task<string?> UploadInstructorProfileImageAsync(ProfileImageDTO profileImageDto, CancellationToken cancellationToken = default)
        {
            const string operationName = nameof(UploadInstructorProfileImageAsync);

            try
            {
                _logger.LogDebug("Starting {OperationName} for user ID: {UserId}", operationName, profileImageDto.UserId);

                if (profileImageDto?.ImageFile == null || profileImageDto.ImageFile.Length == 0)
                {
                    _logger.LogWarning("No image file provided in {OperationName}", operationName);
                    throw new ArgumentException("لم يتم تحميل صورة");
                }

                // Create uploads directory if it doesn't exist
                var uploadsFolder = Path.Combine(_webHostEnvironment.WebRootPath, "Images", "instructor_profiles");
                if (!Directory.Exists(uploadsFolder))
                {
                    Directory.CreateDirectory(uploadsFolder);
                    _logger.LogDebug("Created uploads directory: {UploadsFolder}", uploadsFolder);
                }

                // Generate unique file name
                var uniqueFileName = $"{Guid.NewGuid()}_{profileImageDto.ImageFile.FileName}";
                var filePath = Path.Combine(uploadsFolder, uniqueFileName);

                // Save the file
                using (var stream = new FileStream(filePath, FileMode.Create))
                {
                    await profileImageDto.ImageFile.CopyToAsync(stream, cancellationToken);
                }

                // Create image URL
                var imageUrl = $"/Images/instructor_profiles/{uniqueFileName}";

                // Update profile image in database
                var success = await _profileRepository.UpdateInstructorProfileImageAsync(profileImageDto.UserId, imageUrl, cancellationToken);

                if (!success)
                {
                    _logger.LogError("Failed to update instructor profile image in database for user ID: {UserId}", profileImageDto.UserId);
                    throw new Exception("فشل في تحديث صورة البروفايل");
                }

                _logger.LogInformation("Successfully uploaded instructor profile image for user ID: {UserId}. Image URL: {ImageUrl}",
                    profileImageDto.UserId, imageUrl);

                return imageUrl;
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {OperationName} was cancelled for user ID: {UserId}", operationName, profileImageDto.UserId);
                throw;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred in {OperationName} for user ID: {UserId}", operationName, profileImageDto.UserId);
                throw;
            }
        }
        #endregion

        #region Certificate Operations
        /// <inheritdoc/>
        public async Task<CertificateDTO?> AddCertificateAsync(string userId, CertificateDTO certificateDto, CancellationToken cancellationToken = default)
        {
            const string operationName = nameof(AddCertificateAsync);

            try
            {
                _logger.LogDebug("Starting {OperationName} for user ID: {UserId}", operationName, userId);

                if (certificateDto == null)
                {
                    _logger.LogWarning("CertificateDTO is null in {OperationName}", operationName);
                    return null;
                }

                var certificate = _mapper.Map<Certificate>(certificateDto);
                certificate.UserId = userId;

                var addedCertificate = await _profileRepository.AddCertificateAsync(certificate, cancellationToken);
                if (addedCertificate == null)
                {
                    _logger.LogWarning("Failed to add certificate for user ID: {UserId}", userId);
                    return null;
                }

                var result = _mapper.Map<CertificateDTO>(addedCertificate);

                _logger.LogInformation("Successfully added certificate for user ID: {UserId}. Certificate ID: {CertificateId}",
                    userId, addedCertificate.Id);

                return result;
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {OperationName} was cancelled for user ID: {UserId}", operationName, userId);
                throw;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred in {OperationName} for user ID: {UserId}", operationName, userId);
                throw;
            }
        }

        /// <inheritdoc/>
        public async Task<bool> DeleteCertificateAsync(string userId, int certId, CancellationToken cancellationToken = default)
        {
            const string operationName = nameof(DeleteCertificateAsync);

            try
            {
                _logger.LogDebug("Starting {OperationName} for certificate ID: {CertificateId}, user ID: {UserId}",
                    operationName, certId, userId);

                var success = await _profileRepository.DeleteCertificateAsync(certId, userId, cancellationToken);

                _logger.LogInformation("Certificate deletion {Status} for certificate ID: {CertificateId}, user ID: {UserId}",
                    success ? "succeeded" : "failed", certId, userId);

                return success;
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {OperationName} was cancelled for certificate ID: {CertificateId}", operationName, certId);
                throw;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred in {OperationName} for certificate ID: {CertificateId}", operationName, certId);
                throw;
            }
        }
        #endregion
    }
}
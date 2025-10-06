using EduLab_Application.ServiceInterfaces;
using EduLab_Domain.Entities;
using EduLab_Domain.RepoInterfaces;
using EduLab_Shared.DTOs.Instructor;
using EduLab_Shared.DTOs.InstructorApplication;
using EduLab_Shared.DTOs.Notification;
using EduLab_Shared.Utitlites;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Identity;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;

namespace EduLab_Application.Services
{
    /// <summary>
    /// Service implementation for instructor application operations
    /// </summary>
    public class InstructorApplicationService : IInstructorApplicationService
    {
        private readonly UserManager<ApplicationUser> _userManager;
        private readonly IWebHostEnvironment _hostEnvironment;
        private readonly IInstructorApplicationRepository _applicationRepository;
        private readonly IEmailTemplateService _emailTemplateService;
        private readonly IEmailSender _emailSender;
        private readonly IHistoryService _historyService;
        private readonly RoleManager<IdentityRole> _roleManager;
        private readonly ICurrentUserService _currentUserService;
        private readonly ILogger<InstructorApplicationService> _logger;
        private readonly INotificationService _notificationService;

        /// <summary>
        /// Initializes a new instance of the InstructorApplicationService class
        /// </summary>
        /// <param name="userManager">User manager for user operations</param>
        /// <param name="hostEnvironment">Host environment for file operations</param>
        /// <param name="applicationRepository">Instructor application repository</param>
        /// <param name="roleManager">Role manager for role operations</param>
        /// <param name="emailTemplateService">Email template service</param>
        /// <param name="emailSender">Email sender service</param>
        /// <param name="historyService">History service for logging operations</param>
        /// <param name="currentUserService">Current user service</param>
        /// <param name="logger">Logger instance</param>
        public InstructorApplicationService(
            UserManager<ApplicationUser> userManager,
            IWebHostEnvironment hostEnvironment,
            IInstructorApplicationRepository applicationRepository,
            RoleManager<IdentityRole> roleManager,
            IEmailTemplateService emailTemplateService,
            IEmailSender emailSender,
            IHistoryService historyService,
            ICurrentUserService currentUserService,
            ILogger<InstructorApplicationService> logger,
            INotificationService notificationService)
        {
            _userManager = userManager;
            _hostEnvironment = hostEnvironment;
            _applicationRepository = applicationRepository;
            _roleManager = roleManager;
            _emailTemplateService = emailTemplateService;
            _emailSender = emailSender;
            _historyService = historyService;
            _currentUserService = currentUserService;
            _logger = logger;
            _notificationService = notificationService;
        }

        #region Public Methods

        /// <summary>
        /// Submits a new instructor application
        /// </summary>
        /// <param name="applicationDto">Application data</param>
        /// <param name="userId">User identifier</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Success status and message</returns>
        public async Task<(bool Success, string Message)> SubmitApplication(
            InstructorApplicationDTO applicationDto,
            string userId,
            CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Submitting instructor application for user {UserId}", userId);

                var user = await _userManager.FindByIdAsync(userId);
                if (user == null)
                {
                    _logger.LogWarning("User {UserId} not found", userId);
                    return (false, "المستخدم غير موجود");
                }

                // Check for existing pending or approved applications
                var existingApplication = (await _applicationRepository
                    .GetAllAsync(a => a.UserId == userId, cancellationToken: cancellationToken))
                    .OrderByDescending(a => a.AppliedDate)
                    .FirstOrDefault();

                if (existingApplication != null &&
                   (existingApplication.Status == "Pending" || existingApplication.Status == "Approved"))
                {
                    _logger.LogWarning("User {UserId} already has a pending or approved application", userId);
                    return (false, "لديك طلب سابق قيد المراجعة أو تم قبوله بالفعل");
                }

                // Update user basic information
                user.FullName = applicationDto.FullName;
                user.PhoneNumber = applicationDto.Phone;
                user.About = applicationDto.Bio;

                if (applicationDto.ProfileImage != null)
                {
                    user.ProfileImageUrl = await SaveFile(applicationDto.ProfileImage, "Images/profiles", cancellationToken);
                }

                var updateResult = await _userManager.UpdateAsync(user);
                if (!updateResult.Succeeded)
                {
                    _logger.LogError("Failed to update user {UserId}: {Errors}", userId, string.Join(", ", updateResult.Errors.Select(e => e.Description)));
                    return (false, "فشل في تحديث بيانات المستخدم");
                }

                // Remove current roles
                var currentRoles = await _userManager.GetRolesAsync(user);
                if (currentRoles.Any())
                {
                    var removeResult = await _userManager.RemoveFromRolesAsync(user, currentRoles);
                    if (!removeResult.Succeeded)
                    {
                        _logger.LogError("Failed to remove roles from user {UserId}: {Errors}", userId, string.Join(", ", removeResult.Errors.Select(e => e.Description)));
                        return (false, "فشل في تحديث أدوار المستخدم");
                    }
                }

                // Add Pending Instructor role
                if (!await _roleManager.RoleExistsAsync(SD.InstructorPending))
                {
                    await _roleManager.CreateAsync(new IdentityRole(SD.InstructorPending));
                }

                var addRoleResult = await _userManager.AddToRoleAsync(user, SD.InstructorPending);
                if (!addRoleResult.Succeeded)
                {
                    _logger.LogError("Failed to add role to user {UserId}: {Errors}", userId, string.Join(", ", addRoleResult.Errors.Select(e => e.Description)));
                    return (false, "فشل في إضافة دور المستخدم");
                }

                // Save CV
                string cvUrl = null;
                if (applicationDto.CvFile != null)
                {
                    cvUrl = await SaveFile(applicationDto.CvFile, "Images/cv-files", cancellationToken);
                }

                // Create new InstructorApplication
                var instructorApplication = new InstructorApplication
                {
                    Id = Guid.NewGuid(),
                    UserId = userId,
                    Specialization = applicationDto.Specialization,
                    Experience = applicationDto.Experience,
                    Skills = string.Join(",", applicationDto.Skills),
                    CvUrl = cvUrl,
                    Status = "Pending",
                    AppliedDate = DateTime.UtcNow
                };
                await _notificationService.CreateNotificationAsync(new CreateNotificationDto
                {
                    Title = "تم إرسال طلب الانضمام كمدرب",
                    Message = "تم استلام طلبك بنجاح وجاري مراجعته من قبل الإدارة. سيتم إشعارك عند اتخاذ القرار.",
                    Type = NotificationTypeDto.System,
                    UserId = userId,
                    RelatedEntityId = instructorApplication.Id.ToString(),
                    RelatedEntityType = "InstructorApplication"
                });

                await _applicationRepository.CreateAsync(instructorApplication, cancellationToken);

                _logger.LogInformation("Instructor application submitted successfully for user {UserId}", userId);
                return (true, "تم إرسال الطلب بنجاح وجاري مراجعته");
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation cancelled while submitting application for user {UserId}", userId);
                throw;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while submitting application for user {UserId}", userId);
                return (false, "حدث خطأ غير متوقع أثناء تقديم الطلب");
            }
        }

        /// <summary>
        /// Retrieves all applications for a user
        /// </summary>
        /// <param name="userId">User identifier</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>List of user applications</returns>
        public async Task<List<InstructorApplicationResponseDto>> GetUserApplications(
            string userId,
            CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogDebug("Getting applications for user {UserId}", userId);

                var applications = await _applicationRepository
                    .GetAllAsync(a => a.UserId == userId,
                                includeProperties: "User",
                                cancellationToken: cancellationToken);

                return applications.Select(app => new InstructorApplicationResponseDto
                {
                    Id = app.Id.ToString(),
                    FullName = app.User?.FullName,
                    Email = app.User?.Email,
                    Specialization = app.Specialization,
                    Status = app.Status,
                    AppliedDate = app.AppliedDate,
                    CvUrl = app.CvUrl,
                    Experience = app.Experience
                }).ToList();
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation cancelled while getting applications for user {UserId}", userId);
                throw;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while getting applications for user {UserId}", userId);
                throw;
            }
        }

        /// <summary>
        /// Retrieves application details for a specific user and application
        /// </summary>
        /// <param name="userId">User identifier</param>
        /// <param name="applicationId">Application identifier</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Application details or null if not found</returns>
        public async Task<InstructorApplicationResponseDto> GetApplicationDetails(
            string userId,
            string applicationId,
            CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogDebug("Getting application details for user {UserId}, application {ApplicationId}", userId, applicationId);

                var app = await _applicationRepository.GetAsync(
                    a => a.UserId == userId && a.Id.ToString() == applicationId,
                    includeProperties: "User",
                    cancellationToken: cancellationToken
                );

                if (app == null)
                {
                    _logger.LogWarning("Application {ApplicationId} not found for user {UserId}", applicationId, userId);
                    return null;
                }

                return new InstructorApplicationResponseDto
                {
                    Id = app.Id.ToString(),
                    FullName = app.User?.FullName,
                    Email = app.User?.Email,
                    Specialization = app.Specialization,
                    Status = app.Status,
                    AppliedDate = app.AppliedDate,
                    CvUrl = app.CvUrl,
                    Experience = app.Experience
                };
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation cancelled while getting application details for user {UserId}, application {ApplicationId}", userId, applicationId);
                throw;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while getting application details for user {UserId}, application {ApplicationId}", userId, applicationId);
                throw;
            }
        }

        /// <summary>
        /// Retrieves all applications for admin review
        /// </summary>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>List of all applications</returns>
        public async Task<List<AdminInstructorApplicationDto>> GetAllApplicationsForAdmin(
            CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogDebug("Getting all applications for admin");

                var applications = await _applicationRepository
                    .GetAllAsync(includeProperties: "User", cancellationToken: cancellationToken);

                return applications.Select(app => new AdminInstructorApplicationDto
                {
                    Id = app.Id.ToString(),
                    UserId = app.UserId,
                    FullName = app.User?.FullName,
                    Email = app.User?.Email,
                    Specialization = app.Specialization,
                    Experience = app.Experience,
                    Skills = app.Skills,
                    Status = app.Status,
                    AppliedDate = app.AppliedDate,
                    ReviewedDate = app.ReviewedDate,
                    ReviewedBy = app.ReviewedBy,
                    CvUrl = app.CvUrl,
                    ProfileImageUrl = app.User?.ProfileImageUrl
                }).ToList();
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation cancelled while getting all applications for admin");
                throw;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while getting all applications for admin");
                throw;
            }
        }

        /// <summary>
        /// Approves an instructor application
        /// </summary>
        /// <param name="applicationId">Application identifier</param>
        /// <param name="reviewedByUserId">User ID who reviewed the application</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Success status and message</returns>
        public async Task<(bool Success, string Message)> ApproveApplication(
            string applicationId,
            string reviewedByUserId,
            CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Approving application {ApplicationId} by user {ReviewedByUserId}", applicationId, reviewedByUserId);

                if (!Guid.TryParse(applicationId, out var appId))
                {
                    _logger.LogWarning("Invalid application ID format: {ApplicationId}", applicationId);
                    return (false, "معرف الطلب غير صالح");
                }

                var application = await _applicationRepository.GetAsync(a => a.Id == appId, cancellationToken: cancellationToken);
                if (application == null)
                {
                    _logger.LogWarning("Application {ApplicationId} not found", applicationId);
                    return (false, "الطلب غير موجود");
                }

                var user = await _userManager.FindByIdAsync(application.UserId);
                if (user == null)
                {
                    _logger.LogWarning("User {UserId} not found for application {ApplicationId}", application.UserId, applicationId);
                    return (false, "المستخدم غير موجود");
                }

                // Remove current roles
                var currentRoles = await _userManager.GetRolesAsync(user);
                if (currentRoles.Any())
                {
                    var removeResult = await _userManager.RemoveFromRolesAsync(user, currentRoles);
                    if (!removeResult.Succeeded)
                    {
                        _logger.LogError("Failed to remove roles from user {UserId}: {Errors}", user.Id, string.Join(", ", removeResult.Errors.Select(e => e.Description)));
                        return (false, "فشل في تحديث أدوار المستخدم");
                    }
                }

                // Add Instructor role
                if (!await _roleManager.RoleExistsAsync(SD.Instructor))
                {
                    await _roleManager.CreateAsync(new IdentityRole(SD.Instructor));
                }

                var addRoleResult = await _userManager.AddToRoleAsync(user, SD.Instructor);
                if (!addRoleResult.Succeeded)
                {
                    _logger.LogError("Failed to add instructor role to user {UserId}: {Errors}", user.Id, string.Join(", ", addRoleResult.Errors.Select(e => e.Description)));
                    return (false, "فشل في إضافة دور المدرب");
                }

                // Send approval email
                var approvalEmailContent = _emailTemplateService.GenerateInstructorApprovalEmail(user);
                await _emailSender.SendEmailAsync(user.Email, "مبروك! تم قبولك كمدرب في EduLab", approvalEmailContent);

                await _notificationService.CreateNotificationAsync(new CreateNotificationDto
                {
                    Title = "تم قبول طلبك كمدرب 🎉",
                    Message = "مبروك! تم قبول طلبك لتصبح مدربًا في منصة EduLab. يمكنك الآن إنشاء دوراتك ومشاركة خبراتك.",
                    Type = NotificationTypeDto.System,
                    UserId = user.Id,
                    RelatedEntityId = application.Id.ToString(),
                    RelatedEntityType = "InstructorApplication"
                });

                // Update application status
                await _applicationRepository.UpdateStatusAsync(appId, "Approved", reviewedByUserId, cancellationToken);

                // Add history log
                if (!string.IsNullOrEmpty(reviewedByUserId))
                {
                    await _historyService.LogOperationAsync(
                        reviewedByUserId,
                        $"قام المستخدم بالموافقة على طلب الانضمام كمدرب للعضو '{user.FullName}'.",
                        cancellationToken
                    );
                }

                _logger.LogInformation("Application {ApplicationId} approved successfully", applicationId);
                return (true, "تم قبول الطلب وتحويل المستخدم إلى مدرب");
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation cancelled while approving application {ApplicationId}", applicationId);
                throw;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while approving application {ApplicationId}", applicationId);
                return (false, "حدث خطأ غير متوقع أثناء قبول الطلب");
            }
        }

        /// <summary>
        /// Rejects an instructor application
        /// </summary>
        /// <param name="applicationId">Application identifier</param>
        /// <param name="reviewedByUserId">User ID who reviewed the application</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Success status and message</returns>
        public async Task<(bool Success, string Message)> RejectApplication(
            string applicationId,
            string reviewedByUserId,
            CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Rejecting application {ApplicationId} by user {ReviewedByUserId}", applicationId, reviewedByUserId);

                if (!Guid.TryParse(applicationId, out var appId))
                {
                    _logger.LogWarning("Invalid application ID format: {ApplicationId}", applicationId);
                    return (false, "معرف الطلب غير صالح");
                }

                var application = await _applicationRepository.GetAsync(a => a.Id == appId, cancellationToken: cancellationToken);
                if (application == null)
                {
                    _logger.LogWarning("Application {ApplicationId} not found", applicationId);
                    return (false, "الطلب غير موجود");
                }

                var user = await _userManager.FindByIdAsync(application.UserId);
                if (user == null)
                {
                    _logger.LogWarning("User {UserId} not found for application {ApplicationId}", application.UserId, applicationId);
                    return (false, "المستخدم غير موجود");
                }

                // Remove current roles
                var currentRoles = await _userManager.GetRolesAsync(user);
                if (currentRoles.Any())
                {
                    var removeResult = await _userManager.RemoveFromRolesAsync(user, currentRoles);
                    if (!removeResult.Succeeded)
                    {
                        _logger.LogError("Failed to remove roles from user {UserId}: {Errors}", user.Id, string.Join(", ", removeResult.Errors.Select(e => e.Description)));
                        return (false, "فشل في تحديث أدوار المستخدم");
                    }
                }

                // Add Student role
                if (!await _roleManager.RoleExistsAsync(SD.Student))
                {
                    await _roleManager.CreateAsync(new IdentityRole(SD.Student));
                }

                var addRoleResult = await _userManager.AddToRoleAsync(user, SD.Student);
                if (!addRoleResult.Succeeded)
                {
                    _logger.LogError("Failed to add student role to user {UserId}: {Errors}", user.Id, string.Join(", ", addRoleResult.Errors.Select(e => e.Description)));
                    return (false, "فشل في إضافة دور الطالب");
                }

                // Send rejection email
                var rejectionEmailContent = _emailTemplateService.GenerateInstructorRejectionEmail(user);
                await _emailSender.SendEmailAsync(user.Email, "قرار بشأن طلب الانضمام كمدرب", rejectionEmailContent);

                await _notificationService.CreateNotificationAsync(new CreateNotificationDto
                {
                    Title = "تم رفض طلب الانضمام كمدرب",
                    Message = "نأسف، تم رفض طلبك للانضمام كمدرب. يمكنك تعديل بياناتك وإعادة التقديم لاحقًا.",
                    Type = NotificationTypeDto.System,
                    UserId = user.Id,
                    RelatedEntityId = application.Id.ToString(),
                    RelatedEntityType = "InstructorApplication"
                });

                // Update application status
                await _applicationRepository.UpdateStatusAsync(appId, "Rejected", reviewedByUserId, cancellationToken);

                // Add history log
                if (!string.IsNullOrEmpty(reviewedByUserId))
                {
                    await _historyService.LogOperationAsync(
                        reviewedByUserId,
                        $"قام المستخدم برفض طلب الانضمام كمدرب للعضو '{user.FullName}'.",
                        cancellationToken
                    );
                }

                _logger.LogInformation("Application {ApplicationId} rejected successfully", applicationId);
                return (true, "تم رفض الطلب وإرجاع المستخدم إلى دوره الأساسي");
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation cancelled while rejecting application {ApplicationId}", applicationId);
                throw;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while rejecting application {ApplicationId}", applicationId);
                return (false, "حدث خطأ غير متوقع أثناء رفض الطلب");
            }
        }

        #endregion

        #region Private Methods

        /// <summary>
        /// Saves a file to the server
        /// </summary>
        /// <param name="file">File to save</param>
        /// <param name="folderName">Target folder name</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>File URL or null if file is empty</returns>
        private async Task<string> SaveFile(IFormFile file, string folderName, CancellationToken cancellationToken = default)
        {
            try
            {
                if (file == null || file.Length == 0)
                    return null;

                var uploadsFolder = Path.Combine(_hostEnvironment.WebRootPath, folderName);
                if (!Directory.Exists(uploadsFolder))
                    Directory.CreateDirectory(uploadsFolder);

                var uniqueFileName = Guid.NewGuid().ToString() + "_" + file.FileName;
                var filePath = Path.Combine(uploadsFolder, uniqueFileName);

                using (var fileStream = new FileStream(filePath, FileMode.Create))
                {
                    await file.CopyToAsync(fileStream, cancellationToken);
                }

                return $"/{folderName}/{uniqueFileName}";
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation cancelled while saving file to {FolderName}", folderName);
                throw;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while saving file to {FolderName}", folderName);
                throw;
            }
        }

        #endregion
    }
}
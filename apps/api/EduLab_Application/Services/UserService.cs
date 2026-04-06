using AutoMapper;
using EduLab_Application.Common;
using EduLab_Application.Common.Constants;
using EduLab_Application.DTOs.Auth;
using EduLab_Application.ServiceInterfaces;
using EduLab_Domain.Entities;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Caching.Memory;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Threading.Tasks;

namespace EduLab_Application.Services
{
    /// <summary>
    /// Service for managing user operations including registration, authentication, and user management
    /// </summary>
    public class UserService : IUserService
    {
        #region Dependencies

        private readonly UserManager<ApplicationUser> _userManager;
        private readonly RoleManager<IdentityRole> _roleManager;
        private readonly SignInManager<ApplicationUser> _signInManager;
        private readonly ITokenService _tokenService;
        private readonly IMapper _mapper;
        private readonly IMemoryCache _cache;
        private readonly IEmailSender _emailSender;
        private readonly IEmailTemplateService _emailTemplateService;
        private readonly IHistoryService _historyService;
        private readonly ICurrentUserService _currentUserService;
        private readonly ILogger<UserService> _logger;

        #endregion

        #region Constructor

        /// <summary>
        /// Initializes a new instance of the UserService class
        /// </summary>
        public UserService(
            UserManager<ApplicationUser> userManager,
            RoleManager<IdentityRole> roleManager,
            SignInManager<ApplicationUser> signInManager,
            ITokenService tokenService,
            IMapper mapper,
            IMemoryCache cache,
            IEmailSender emailSender,
            IEmailTemplateService emailTemplateService,
            IHistoryService historyService,
            ICurrentUserService currentUserService,
            ILogger<UserService> logger)
        {
            _userManager = userManager;
            _roleManager = roleManager;
            _signInManager = signInManager;
            _tokenService = tokenService;
            _mapper = mapper;
            _cache = cache;
            _emailSender = emailSender;
            _emailTemplateService = emailTemplateService;
            _historyService = historyService;
            _currentUserService = currentUserService;
            _logger = logger;
        }

        #endregion

        #region Authentication & Registration

        /// <summary>
        /// Initiates the forgot password process by sending a reset code
        /// </summary>
        public async Task<ApiResponse<object>> ForgotPasswordAsync(string email)
        {
            try
            {
                _logger.LogInformation("Forgot password request for email: {Email}", email);

                var user = await _userManager.FindByEmailAsync(email);
                if (user == null)
                {
                    // For security reasons, we don't reveal if the email exists or not
                    _logger.LogWarning("Forgot password attempt for non-existent email: {Email}", email);
                    return ApiResponse<object>.SuccessResponse(
                        "إذا كان البريد الإلكتروني مسجلاً لدينا، فسيتم إرسال رمز التحقق",
                        "Request processed"
                    );
                }

                var resetCode = GenerateRandomCode();
                _cache.Set($"passwordReset:{email}", resetCode, TimeSpan.FromMinutes(10));

                var emailBody = _emailTemplateService.GeneratePasswordResetEmail(resetCode);
                await _emailSender.SendEmailAsync(email, "استعادة كلمة المرور - EduLab", emailBody);

                _logger.LogInformation("Password reset code sent to email: {Email}", email);
                return ApiResponse<object>.SuccessResponse(
                    "إذا كان البريد الإلكتروني مسجلاً لدينا، فسيتم إرسال رمز التحقق",
                    "Reset code sent"
                );
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "حدث خطأ أثناء معالجة طلب استعادة كلمة المرور: {Email}", email);
                return ApiResponse<object>.FailResponse(
                    "حدث خطأ أثناء معالجة طلبك",
                    new List<string> { ex.Message }
                );
            }
        }

        /// <summary>
        /// Verifies the password reset code
        /// </summary>
        public async Task<ApiResponse<object>> VerifyResetCodeAsync(string email, string code)
        {
            try
            {
                _logger.LogInformation("Password reset code verification for email: {Email}", email);

                if (!_cache.TryGetValue($"passwordReset:{email}", out string cachedCode))
                {
                    return ApiResponse<object>.FailResponse(
                        "انتهت صلاحية الكود أو غير موجود",
                        new List<string> { "Invalid or expired code" }
                    );
                }

                if (cachedCode != code)
                {
                    return ApiResponse<object>.FailResponse(
                        "الكود غير صحيح",
                        new List<string> { "Code mismatch" }
                    );
                }

                _cache.Set($"passwordResetVerified:{email}", true, TimeSpan.FromMinutes(10));
                _cache.Remove($"passwordReset:{email}");

                return ApiResponse<object>.SuccessResponse("تم التحقق من الكود بنجاح", "Code verified");
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "حدث خطأ أثناء التحقق من كود استعادة كلمة المرور: {Email}", email);
                return ApiResponse<object>.FailResponse(
                    "حدث خطأ أثناء التحقق من الكود",
                    new List<string> { ex.Message }
                );
            }
        }

        /// <summary>
        /// Resets the user's password
        /// </summary>
        public async Task<ApiResponse<object>> ResetPasswordAsync(ResetPasswordDTO dto)
        {
            try
            {
                _logger.LogInformation("Password reset attempt for email: {Email}", dto.Email);

                if (!_cache.TryGetValue($"passwordResetVerified:{dto.Email}", out _))
                {
                    return ApiResponse<object>.FailResponse(
                        "يجب التحقق من الكود أولاً",
                        new List<string> { "Code not verified" }
                    );
                }

                var user = await _userManager.FindByEmailAsync(dto.Email);
                if (user == null)
                {
                    return ApiResponse<object>.FailResponse(
                        "المستخدم غير موجود",
                        new List<string> { "User not found" }
                    );
                }

                var resetToken = await _userManager.GeneratePasswordResetTokenAsync(user);
                var result = await _userManager.ResetPasswordAsync(user, resetToken, dto.NewPassword);

                if (result.Succeeded)
                {
                    _cache.Remove($"passwordResetVerified:{dto.Email}");

                    var emailBody = _emailTemplateService.GeneratePasswordResetConfirmationEmail();
                    await _emailSender.SendEmailAsync(dto.Email, "تم تغيير كلمة المرور - EduLab", emailBody);

                    _logger.LogInformation("Password reset successful for email: {Email}", dto.Email);
                    return ApiResponse<object>.SuccessResponse("تم تغيير كلمة المرور بنجاح", "Password reset");
                }

                var errors = result.Errors.Select(e => e.Description).ToList();
                _logger.LogWarning("Password reset failed for email: {Email}: {Errors}", dto.Email, string.Join(", ", errors));
                return ApiResponse<object>.FailResponse("فشل تغيير كلمة المرور", errors);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "حدث خطأ أثناء إعادة تعيين كلمة المرور: {Email}", dto.Email);
                return ApiResponse<object>.FailResponse(
                    "حدث خطأ أثناء إعادة تعيين كلمة المرور",
                    new List<string> { ex.Message }
                );
            }
        }

        /// <summary>
        /// Registers a new user in the system
        /// </summary>
        public async Task<ApiResponse<object>> Register(RegisterRequestDTO request)
        {
            try
            {
                if (!_cache.TryGetValue($"emailConfirmed:{request.Email}", out _))
                {
                    return ApiResponse<object>.FailResponse(
                        "يجب تأكيد البريد الإلكتروني أولاً قبل التسجيل.",
                        new List<string> { "Email not confirmed" }
                    );
                }

                if (await IsEmailExistsAsync(request.Email))
                {
                    return ApiResponse<object>.FailResponse(
                        "هذا البريد الإلكتروني مستخدم مسبقاً",
                        new List<string> { "Duplicate email" }
                    );
                }

                if (await IsFullNameExistsAsync(request.FullName))
                {
                    return ApiResponse<object>.FailResponse(
                        "هذا الاسم مستخدم مسبقاً",
                        new List<string> { "Duplicate full name" }
                    );
                }

                var user = new ApplicationUser
                {
                    UserName = request.Email,
                    Email = request.Email,
                    FullName = request.FullName,
                    EmailConfirmed = true
                };

                var result = await CreateUserAsync(user, request.Password);
                if (!result.Succeeded)
                {
                    return ApiResponse<object>.FailResponse(
                        "فشل إنشاء المستخدم",
                        result.Errors.Select(e => e.Description).ToList()
                    );
                }

                _cache.Remove($"emailConfirmed:{request.Email}");

                var userDto = _mapper.Map<UserDTO>(user);
                return ApiResponse<object>.SuccessResponse(userDto, "Registration successful");
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "حدث خطأ أثناء تسجيل المستخدم: {Email}", request.Email);
                return ApiResponse<object>.FailResponse(
                    "حدث خطأ غير متوقع أثناء التسجيل",
                    new List<string> { ex.Message }
                );
            }
        }

        /// <summary>
        /// Verifies email confirmation code
        /// </summary>
        public async Task<ApiResponse<object>> VerifyEmailCodeAsync(string email, string code)
        {
            try
            {
                if (!_cache.TryGetValue($"verify:{email}", out string cachedCode))
                {
                    return ApiResponse<object>.FailResponse(
                        "انتهت صلاحية الكود أو غير موجود",
                        new List<string> { "Code expired" }
                    );
                }

                if (cachedCode != code)
                {
                    return ApiResponse<object>.FailResponse(
                        "الكود غير صحيح",
                        new List<string> { "Invalid code" }
                    );
                }

                _cache.Set($"emailConfirmed:{email}", true, TimeSpan.FromMinutes(30));
                _cache.Remove($"verify:{email}");

                return ApiResponse<object>.SuccessResponse("تم تأكيد البريد الإلكتروني بنجاح", "Email confirmed");
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "حدث خطأ أثناء التحقق من كود البريد الإلكتروني: {Email}", email);
                return ApiResponse<object>.FailResponse(
                    "حدث خطأ غير متوقع أثناء التحقق من الكود",
                    new List<string> { ex.Message }
                );
            }
        }

        /// <summary>
        /// Sends verification code to user email
        /// </summary>
        public async Task<ApiResponse<object>> SendVerificationCodeAsync(string email)
        {
            try
            {
                if (await IsEmailExistsAsync(email))
                {
                    return ApiResponse<object>.FailResponse(
                        "هذا البريد الإلكتروني مستخدم مسبقاً",
                        new List<string> { "Email already exists" }
                    );
                }

                var code = GenerateRandomCode();
                _cache.Set($"verify:{email}", code, TimeSpan.FromMinutes(10));

                var emailBody = _emailTemplateService.GenerateVerificationEmail(code);
                await _emailSender.SendEmailAsync(email, "رمز تأكيد البريد الإلكتروني", emailBody);

                return ApiResponse<object>.SuccessResponse("تم إرسال كود التفعيل إلى بريدك الإلكتروني", "Code sent");
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "حدث خطأ أثناء إرسال كود التحقق: {Email}", email);
                return ApiResponse<object>.FailResponse(
                    "حدث خطأ غير متوقع أثناء إرسال كود التحقق",
                    new List<string> { ex.Message }
                );
            }
        }

        #endregion

        #region User Management

        /// <summary>
        /// Retrieves all users with their roles
        /// </summary>
        public async Task<List<UserDTO>> GetAllUsersWithRolesAsync()
        {
            try
            {
                const string cacheKey = "AllUsersWithRoles";
                if (_cache.TryGetValue(cacheKey, out List<UserDTO> cachedUsers))
                {
                    return cachedUsers;
                }

                var users = await _userManager.Users.AsNoTracking().ToListAsync();
                var userDtos = new List<UserDTO>(users.Count);

                foreach (var user in users)
                {
                    var roles = await _userManager.GetRolesAsync(user);
                    userDtos.Add(new UserDTO
                    {
                        Id = user.Id,
                        ProfileImageUrl = user.ProfileImageUrl,
                        FullName = user.FullName,
                        Email = user.Email,
                        Role = roles.Count > 0 ? string.Join(", ", roles) : "None",
                        IsLocked = user.IsLocked,
                        CreatedAt = user.CreatedAt
                    });
                }

                _cache.Set(cacheKey, userDtos, TimeSpan.FromMinutes(5));
                return userDtos;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "حدث خطأ أثناء جلب جميع المستخدمين مع أدوارهم");
                return new List<UserDTO>();
            }
        }

        /// <summary>
        /// Deletes a user by ID
        /// </summary>
        public async Task<ApiResponse<object>> DeleteUserAsync(string id)
        {
            try
            {
                var currentUserId = await _currentUserService.GetUserIdAsync();
                if (!string.IsNullOrEmpty(currentUserId) && currentUserId == id)
                {
                    _logger.LogWarning("فشل حذف المستخدم: لا يمكن للمستخدم حذف نفسه [ID: {UserId}]", id);
                    return ApiResponse<object>.FailResponse("لا يمكنك حذف حسابك الشخصي.");
                }

                var user = await _userManager.FindByIdAsync(id);
                if (user == null)
                {
                    _logger.LogWarning("فشل حذف المستخدم: المستخدم غير موجود [ID: {UserId}]", id);
                    return ApiResponse<object>.FailResponse("المستخدم غير موجود.");
                }

                if (user.CoursesCreated != null && user.CoursesCreated.Any())
                {
                    _logger.LogWarning("فشل حذف المستخدم [ID: {UserId}] لأنه مرتبط بكورسات.", id);
                    return ApiResponse<object>.FailResponse("لا يمكن حذف المستخدم لأنه مرتبط بكورسات.");
                }

                var result = await _userManager.DeleteAsync(user);
                if (result.Succeeded)
                {
                    _cache.Remove("AllUsersWithRoles");
                    if (!string.IsNullOrEmpty(currentUserId))
                    {
                        await _historyService.LogOperationAsync(
                            currentUserId,
                            $"قام المستخدم بحذف مستخدم [ID: {user.Id.Substring(0, 3)}...] باسم \"{user.FullName}\"."
                        );
                    }
                    _logger.LogInformation("تم حذف المستخدم بنجاح [ID: {UserId}]", id);
                    return ApiResponse<object>.SuccessResponse(null, "تم حذف المستخدم بنجاح");
                }

                var errors = string.Join(", ", result.Errors.Select(e => e.Description));
                _logger.LogWarning("فشل حذف المستخدم [ID: {UserId}]. الأخطاء: {Errors}", id, errors);
                return ApiResponse<object>.FailResponse("فشل حذف المستخدم بسبب خطأ داخلي.");
            }
            catch (DbUpdateException dbEx)
            {
                _logger.LogError(dbEx, "فشل حذف المستخدم {UserId} بسبب وجود بيانات مرتبطة", id);
                return ApiResponse<object>.FailResponse("لا يمكن حذف هذا المستخدم لأنه مرتبط بكورسات أو بيانات أخرى.");
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "حدث خطأ غير متوقع أثناء حذف المستخدم {UserId}", id);
                return ApiResponse<object>.FailResponse("حدث خطأ داخلي أثناء الحذف، برجاء المحاولة لاحقًا.");
            }
        }

        /// <summary>
        /// Deletes multiple users by their IDs
        /// </summary>
        public async Task<ApiResponse<object>> DeleteRangeUserAsync(List<string> userIds)
        {
            var failedUsers = new List<string>();
            try
            {
                var deletedUserNames = new List<string>();
                var currentUserId = await _currentUserService.GetUserIdAsync();

                foreach (var id in userIds)
                {
                    var user = await _userManager.FindByIdAsync(id);
                    if (user == null)
                    {
                        failedUsers.Add($"المستخدم {id} غير موجود.");
                        continue;
                    }

                    if (!string.IsNullOrEmpty(currentUserId) && currentUserId == id)
                    {
                        failedUsers.Add($"لا يمكنك حذف حسابك الشخصي ({user.FullName}).");
                        continue;
                    }

                    if (user.CoursesCreated != null && user.CoursesCreated.Any())
                    {
                        failedUsers.Add($"لا يمكن حذف المستخدم \"{user.FullName}\" لأنه مرتبط بكورسات.");
                        continue;
                    }

                    var result = await _userManager.DeleteAsync(user);
                    if (result.Succeeded)
                    {
                        deletedUserNames.Add(user.FullName);
                    }
                    else
                    {
                        failedUsers.Add($"فشل حذف المستخدم \"{user.FullName}\".");
                    }
                }

                if (deletedUserNames.Any())
                {
                    _cache.Remove("AllUsersWithRoles");
                    if (!string.IsNullOrEmpty(currentUserId))
                    {
                        var names = string.Join(", ", deletedUserNames);
                        await _historyService.LogOperationAsync(
                            currentUserId,
                            $"قام المستخدم بحذف مجموعة من المستخدمين ({names})."
                        );
                    }
                }

                if (failedUsers.Any())
                {
                    return ApiResponse<object>.FailResponse("بعض المستخدمين لم يتم حذفهم", failedUsers);
                }
                return ApiResponse<object>.SuccessResponse(null, "تم حذف جميع المستخدمين المحددين بنجاح");
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "حدث خطأ أثناء حذف مجموعة المستخدمين");
                return ApiResponse<object>.FailResponse("حدث خطأ غير متوقع أثناء الحذف.", new List<string> { ex.Message });
            }
        }

        /// <summary>
        /// Updates user information
        /// </summary>
        public async Task<ApiResponse<object>> UpdateUserAsync(UpdateUserDTO dto)
        {
            try
            {
                var existingUser = await _userManager.FindByIdAsync(dto.Id);
                if (existingUser == null)
                {
                    _logger.LogWarning("User not found for update: {UserId}", dto.Id);
                    return ApiResponse<object>.FailResponse("المستخدم غير موجود.");
                }

                if (!await _roleManager.RoleExistsAsync(dto.Role))
                {
                    _logger.LogWarning("Role does not exist: {Role}", dto.Role);
                    return ApiResponse<object>.FailResponse($"الدور {dto.Role} غير موجود.");
                }

                existingUser.FullName = dto.FullName;
                var updateResult = await _userManager.UpdateAsync(existingUser);
                if (!updateResult.Succeeded)
                {
                    var errors = updateResult.Errors.Select(e => e.Description).ToList();
                    _logger.LogError("Failed to update user: {Errors}", string.Join(", ", errors));
                    return ApiResponse<object>.FailResponse("فشل تحديث بيانات المستخدم", errors);
                }

                var currentRoles = await _userManager.GetRolesAsync(existingUser);
                if (currentRoles.Any() && !currentRoles.Contains(dto.Role))
                {
                    await _userManager.RemoveFromRolesAsync(existingUser, currentRoles);
                }
                if (!currentRoles.Contains(dto.Role))
                {
                    await _userManager.AddToRoleAsync(existingUser, dto.Role);
                }

                _cache.Remove("AllUsersWithRoles");
                _cache.Remove($"UserById:{dto.Id}");

                var currentUserId = await _currentUserService.GetUserIdAsync();
                if (!string.IsNullOrEmpty(currentUserId))
                {
                    await _historyService.LogOperationAsync(
                        currentUserId,
                        $"قام المستخدم بتحديث بيانات المستخدم [ID: {dto.Id.Substring(0, 3)}...] باسم \"{dto.FullName}\"."
                    );
                }

                return ApiResponse<object>.SuccessResponse(null, "تم تحديث المستخدم بنجاح");
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "حدث خطأ أثناء تحديث المستخدم: {UserId}", dto.Id);
                return ApiResponse<object>.FailResponse("حدث خطأ أثناء تحديث المستخدم", new List<string> { ex.Message });
            }
        }

        /// <summary>
        /// Retrieves user information by ID
        /// </summary>
        public async Task<UserInfoDTO?> GetUserByIdAsync(string id)
        {
            try
            {
                var cacheKey = $"UserById:{id}";
                if (_cache.TryGetValue(cacheKey, out UserInfoDTO cachedUser))
                {
                    return cachedUser;
                }

                var user = await _userManager.FindByIdAsync(id);
                if (user == null) return null;

                var roles = await _userManager.GetRolesAsync(user);
                var userInfo = new UserInfoDTO
                {
                    Id = user.Id,
                    FullName = user.FullName,
                    Email = user.Email,
                    PhoneNumber = user.PhoneNumber,
                    About = user.About,
                    ProfileImageUrl = user.ProfileImageUrl,
                    Role = roles.Count > 0 ? string.Join(", ", roles) : "None",
                    IsLocked = await _userManager.IsLockedOutAsync(user),
                    CreatedAt = user.CreatedAt
                };

                _cache.Set(cacheKey, userInfo, TimeSpan.FromMinutes(5));
                return userInfo;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "حدث خطأ أثناء جلب بيانات المستخدم: {UserId}", id);
                return null;
            }
        }

        #endregion

        #region Role-based User Retrieval

        /// <summary>
        /// Retrieves all instructors
        /// </summary>
        public async Task<List<UserDTO>> GetInstructorsAsync()
        {
            try
            {
                const string cacheKey = "AllInstructors";
                if (_cache.TryGetValue(cacheKey, out List<UserDTO> cachedInstructors))
                {
                    return cachedInstructors;
                }

                var usersInRole = await _userManager.GetUsersInRoleAsync(SD.Instructor);
                var instructorList = usersInRole.Select(user => new UserDTO
                {
                    Id = user.Id,
                    FullName = user.FullName,
                    ProfileImageUrl = user.ProfileImageUrl,
                    Email = user.Email,
                    Role = SD.Instructor,
                    IsLocked = user.IsLocked,
                    CreatedAt = user.CreatedAt
                }).ToList();

                _cache.Set(cacheKey, instructorList, TimeSpan.FromMinutes(5));
                return instructorList;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "حدث خطأ أثناء جلب المدربين");
                return new List<UserDTO>();
            }
        }

        /// <summary>
        /// Retrieves all administrators
        /// </summary>
        public async Task<List<UserDTO>> GetAdminsAsync()
        {
            try
            {
                const string cacheKey = "AllAdmins";
                if (_cache.TryGetValue(cacheKey, out List<UserDTO> cachedAdmins))
                {
                    return cachedAdmins;
                }

                var usersInRole = await _userManager.GetUsersInRoleAsync(SD.Admin);
                var adminList = usersInRole.Select(user => new UserDTO
                {
                    Id = user.Id,
                    FullName = user.FullName,
                    ProfileImageUrl = user.ProfileImageUrl,
                    Email = user.Email,
                    Role = SD.Admin,
                    IsLocked = user.IsLocked,
                    CreatedAt = user.CreatedAt
                }).ToList();

                _cache.Set(cacheKey, adminList, TimeSpan.FromMinutes(5));
                return adminList;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "حدث خطأ أثناء جلب المشرفين");
                return new List<UserDTO>();
            }
        }

        /// <summary>
        /// Retrieves an instructor with their courses
        /// </summary>
        public async Task<ApplicationUser?> GetInstructorWithCoursesAsync(string id)
        {
            try
            {
                var cacheKey = $"InstructorWithCourses:{id}";
                if (_cache.TryGetValue(cacheKey, out ApplicationUser cachedInstructor))
                {
                    return cachedInstructor;
                }

                var instructor = await _userManager.Users
                    .Include(u => u.CoursesCreated)
                    .AsNoTracking()
                    .FirstOrDefaultAsync(u => u.Id == id);

                if (instructor == null) return null;

                var roles = await _userManager.GetRolesAsync(instructor);
                if (!roles.Contains(SD.Instructor)) return null;

                _cache.Set(cacheKey, instructor, TimeSpan.FromMinutes(5));
                return instructor;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "حدث خطأ أثناء جلب المدرب مع دوراته: {UserId}", id);
                return null;
            }
        }

        /// <summary>
        /// Retrieves all instructors with their courses
        /// </summary>
        public async Task<List<ApplicationUser>> GetAllInstructorsWithCoursesAsync()
        {
            try
            {
                const string cacheKey = "AllInstructorsWithCourses";
                if (_cache.TryGetValue(cacheKey, out List<ApplicationUser> cachedInstructors))
                {
                    return cachedInstructors;
                }

                var usersInRole = await _userManager.GetUsersInRoleAsync(SD.Instructor);
                var userIds = usersInRole.Select(u => u.Id).ToList();

                var instructorsWithCourses = await _userManager.Users
                    .Where(u => userIds.Contains(u.Id))
                    .Include(u => u.CoursesCreated)
                    .AsNoTracking()
                    .ToListAsync();

                _cache.Set(cacheKey, instructorsWithCourses, TimeSpan.FromMinutes(5));
                return instructorsWithCourses;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "حدث خطأ أثناء جلب جميع المدربين مع دوراتهم");
                return new List<ApplicationUser>();
            }
        }

        #endregion

        #region Account Locking/Unlocking

        /// <summary>
        /// Locks user accounts for a specified duration
        /// </summary>
        public async Task<ApiResponse<object>> LockUsersAsync(List<string> userIds, int minutes)
        {
            var lockedUsers = new List<UserDTO>();
            try
            {
                var currentUserId = await _currentUserService.GetUserIdAsync();

                foreach (var userId in userIds)
                {
                    if (userId == currentUserId) continue;

                    var user = await _userManager.FindByIdAsync(userId);
                    if (user != null)
                    {
                        await _userManager.SetLockoutEnabledAsync(user, true);
                        await _userManager.SetLockoutEndDateAsync(user, DateTimeOffset.UtcNow.AddMinutes(minutes));
                        bool isLocked = await _userManager.IsLockedOutAsync(user);

                        lockedUsers.Add(new UserDTO
                        {
                            Id = user.Id,
                            FullName = user.FullName,
                            Email = user.Email,
                            IsLocked = isLocked
                        });
                    }
                }

                if (lockedUsers.Any())
                {
                    _cache.Remove("AllUsersWithRoles");
                    if (!string.IsNullOrEmpty(currentUserId))
                    {
                        var namesWithIds = string.Join(", ", lockedUsers.Select(u => $"[ID: {u.Id.Substring(0, 3)}...] {u.FullName}"));
                        await _historyService.LogOperationAsync(
                            currentUserId,
                            $"قام المستخدم بقفل حسابات المستخدمين التالية لمدة {minutes} دقيقة: {namesWithIds}."
                        );
                    }
                }
                return ApiResponse<object>.SuccessResponse(lockedUsers, "تم قفل الحسابات المحددة");
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "حدث خطأ أثناء قفل حسابات المستخدمين");
                return ApiResponse<object>.FailResponse("حدث خطأ أثناء قفل الحسابات", new List<string> { ex.Message });
            }
        }

        /// <summary>
        /// Unlocks user accounts
        /// </summary>
        public async Task<ApiResponse<object>> UnlockUsersAsync(List<string> userIds)
        {
            var unlockedUsers = new List<UserDTO>();
            try
            {
                foreach (var userId in userIds)
                {
                    var user = await _userManager.FindByIdAsync(userId);
                    if (user != null)
                    {
                        await _userManager.SetLockoutEndDateAsync(user, null);
                        await _userManager.SetLockoutEnabledAsync(user, false);
                        bool isLocked = await _userManager.IsLockedOutAsync(user);

                        unlockedUsers.Add(new UserDTO
                        {
                            Id = user.Id,
                            FullName = user.FullName,
                            Email = user.Email,
                            IsLocked = isLocked
                        });
                    }
                }

                if (unlockedUsers.Any())
                {
                    _cache.Remove("AllUsersWithRoles");
                    var currentUserId = await _currentUserService.GetUserIdAsync();
                    if (!string.IsNullOrEmpty(currentUserId))
                    {
                        var namesWithIds = string.Join(", ", unlockedUsers.Select(u => $"[ID: {u.Id.Substring(0, 3)}...] {u.FullName}"));
                        await _historyService.LogOperationAsync(
                            currentUserId,
                            $"قام المستخدم بفك قفل حسابات المستخدمين التالية: {namesWithIds}."
                        );
                    }
                }
                return ApiResponse<object>.SuccessResponse(unlockedUsers, "تم فك القفل عن الحسابات المحددة");
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "حدث خطأ أثناء فتح قفل حسابات المستخدمين");
                return ApiResponse<object>.FailResponse("حدث خطأ أثناء فك القفل", new List<string> { ex.Message });
            }
        }

        #endregion

        #region Helper Methods

        /// <summary>
        /// Creates a new user with the specified password
        /// </summary>
        private async Task<IdentityResult> CreateUserAsync(ApplicationUser user, string password)
        {
            try
            {
                var rolesToCreate = new[] { SD.Admin, SD.Instructor, SD.Student, SD.Support, SD.Moderator };
                foreach (var role in rolesToCreate)
                {
                    if (!await _roleManager.RoleExistsAsync(role))
                    {
                        await _roleManager.CreateAsync(new IdentityRole(role));
                    }
                }

                user.CreatedAt = DateTime.UtcNow;
                var result = await _userManager.CreateAsync(user, password);
                if (!result.Succeeded) return result;

                await _userManager.AddToRoleAsync(user, SD.Student);
                return IdentityResult.Success;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "حدث خطأ أثناء إنشاء المستخدم: {Email}", user.Email);
                return IdentityResult.Failed(new IdentityError
                {
                    Description = "حدث خطأ غير متوقع أثناء إنشاء المستخدم"
                });
            }
        }

        /// <summary>
        /// Checks if an email address already exists in the system
        /// </summary>
        private async Task<bool> IsEmailExistsAsync(string email)
        {
            try
            {
                var emailUser = await _userManager.FindByEmailAsync(email);
                return emailUser != null;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "حدث خطأ أثناء التحقق من وجود البريد الإلكتروني: {Email}", email);
                return false;
            }
        }

        /// <summary>
        /// Checks if a full name already exists in the system
        /// </summary>
        private async Task<bool> IsFullNameExistsAsync(string fullName)
        {
            try
            {
                var user = await _userManager.Users
                    .AsNoTracking()
                    .FirstOrDefaultAsync(u => u.FullName == fullName);
                return user != null;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "حدث خطأ أثناء التحقق من وجود الاسم: {FullName}", fullName);
                return false;
            }
        }

        /// <summary>
        /// Generates a random verification code
        /// </summary>
        private string GenerateRandomCode() => new Random().Next(100000, 999999).ToString();

        #endregion
    }
}
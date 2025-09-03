using AutoMapper;
using EduLab_Application.ServiceInterfaces;
using EduLab_Domain.Entities;
using EduLab_Shared.DTOs.Auth;
using EduLab_Shared.Utitlites;
using Microsoft.AspNetCore.Http;
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
        public readonly ITokenService _tokenService;
        private readonly IMapper _mapper;
        protected APIResponse _response;
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
            _response = new APIResponse();
        }

        #endregion

        #region Authentication & Registration

        /// <summary>
        /// Registers a new user in the system
        /// </summary>
        /// <param name="request">User registration data</param>
        /// <returns>API response indicating success or failure</returns>
        public async Task<APIResponse> Register(RegisterRequestDTO request)
        {
            try
            {
                if (!_cache.TryGetValue($"emailConfirmed:{request.Email}", out _))
                {
                    return new APIResponse
                    {
                        IsSuccess = false,
                        ErrorMessages = new List<string> { "يجب تأكيد البريد الإلكتروني أولاً قبل التسجيل." },
                        StatusCode = HttpStatusCode.BadRequest
                    };
                }

                if (await IsEmailExistsAsync(request.Email))
                {
                    return new APIResponse
                    {
                        IsSuccess = false,
                        ErrorMessages = new List<string> { "هذا البريد الإلكتروني مستخدم مسبقاً" },
                        StatusCode = HttpStatusCode.BadRequest
                    };
                }

                if (await IsFullNameExistsAsync(request.FullName))
                {
                    return new APIResponse
                    {
                        IsSuccess = false,
                        ErrorMessages = new List<string> { "هذا الاسم مستخدم مسبقاً" },
                        StatusCode = HttpStatusCode.BadRequest
                    };
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
                    return new APIResponse
                    {
                        IsSuccess = false,
                        ErrorMessages = result.Errors.Select(e => e.Description).ToList(),
                        StatusCode = HttpStatusCode.BadRequest
                    };
                }

                _cache.Remove($"emailConfirmed:{request.Email}");

                return new APIResponse
                {
                    IsSuccess = true,
                    Result = _mapper.Map<UserDTO>(user),
                    StatusCode = HttpStatusCode.OK
                };
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "حدث خطأ أثناء تسجيل المستخدم: {Email}", request.Email);
                return new APIResponse
                {
                    IsSuccess = false,
                    ErrorMessages = new List<string> { "حدث خطأ غير متوقع أثناء التسجيل" },
                    StatusCode = HttpStatusCode.InternalServerError
                };
            }
        }

        /// <summary>
        /// Verifies email confirmation code
        /// </summary>
        /// <param name="email">User email address</param>
        /// <param name="code">Verification code</param>
        /// <returns>API response indicating success or failure</returns>
        public async Task<APIResponse> VerifyEmailCodeAsync(string email, string code)
        {
            try
            {
                if (!_cache.TryGetValue($"verify:{email}", out string cachedCode))
                {
                    return new APIResponse
                    {
                        IsSuccess = false,
                        ErrorMessages = new List<string> { "انتهت صلاحية الكود أو غير موجود" },
                        StatusCode = HttpStatusCode.BadRequest
                    };
                }

                if (cachedCode != code)
                {
                    return new APIResponse
                    {
                        IsSuccess = false,
                        ErrorMessages = new List<string> { "الكود غير صحيح" },
                        StatusCode = HttpStatusCode.BadRequest
                    };
                }

                _cache.Set($"emailConfirmed:{email}", true, TimeSpan.FromMinutes(30));
                _cache.Remove($"verify:{email}");

                return new APIResponse
                {
                    IsSuccess = true,
                    StatusCode = HttpStatusCode.OK,
                    Result = "تم تأكيد البريد الإلكتروني بنجاح"
                };
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "حدث خطأ أثناء التحقق من كود البريد الإلكتروني: {Email}", email);
                return new APIResponse
                {
                    IsSuccess = false,
                    ErrorMessages = new List<string> { "حدث خطأ غير متوقع أثناء التحقق من الكود" },
                    StatusCode = HttpStatusCode.InternalServerError
                };
            }
        }

        /// <summary>
        /// Sends verification code to user email
        /// </summary>
        /// <param name="email">User email address</param>
        /// <returns>API response indicating success or failure</returns>
        public async Task<APIResponse> SendVerificationCodeAsync(string email)
        {
            try
            {
                if (await IsEmailExistsAsync(email))
                {
                    return new APIResponse
                    {
                        IsSuccess = false,
                        ErrorMessages = new List<string> { "هذا البريد الإلكتروني مستخدم مسبقاً" },
                        StatusCode = HttpStatusCode.BadRequest
                    };
                }

                var code = GenerateRandomCode();
                _cache.Set($"verify:{email}", code, TimeSpan.FromMinutes(10));

                var emailBody = _emailTemplateService.GenerateVerificationEmail(code);
                await _emailSender.SendEmailAsync(email, "رمز تأكيد البريد الإلكتروني", emailBody);

                return new APIResponse
                {
                    IsSuccess = true,
                    StatusCode = HttpStatusCode.OK,
                    Result = "تم إرسال كود التفعيل إلى بريدك الإلكتروني"
                };
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "حدث خطأ أثناء إرسال كود التحقق: {Email}", email);
                return new APIResponse
                {
                    IsSuccess = false,
                    ErrorMessages = new List<string> { "حدث خطأ غير متوقع أثناء إرسال كود التحقق" },
                    StatusCode = HttpStatusCode.InternalServerError
                };
            }
        }

        #endregion

        #region User Management

        /// <summary>
        /// Retrieves all users with their roles
        /// </summary>
        /// <returns>List of users with role information</returns>
        public async Task<List<UserDTO>> GetAllUsersWithRolesAsync()
        {
            try
            {
                const string cacheKey = "AllUsersWithRoles";
                if (_cache.TryGetValue(cacheKey, out List<UserDTO> cachedUsers))
                {
                    return cachedUsers;
                }

                var users = await _userManager.Users
                    .AsNoTracking()
                    .ToListAsync();

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
        /// <param name="id">User identifier</param>
        /// <returns>True if deletion was successful, otherwise false</returns>
        public async Task<string?> DeleteUserAsync(string id)
        {
            try
            {
                var currentUserId = await _currentUserService.GetUserIdAsync();

                // منع المستخدم من حذف نفسه
                if (!string.IsNullOrEmpty(currentUserId) && currentUserId == id)
                {
                    _logger.LogWarning("فشل حذف المستخدم: لا يمكن للمستخدم حذف نفسه [ID: {UserId}]", id);
                    return "لا يمكنك حذف حسابك الشخصي.";
                }

                var user = await _userManager.FindByIdAsync(id);
                if (user == null)
                {
                    _logger.LogWarning("فشل حذف المستخدم: المستخدم غير موجود [ID: {UserId}]", id);
                    return "المستخدم غير موجود.";
                }

                // ✅ تحقق من وجود كورسات مرتبطة بالمستخدم
                // نفترض عندك خاصية User.Courses أو تقدر تجيبها من Service خارجي
                if (user.CoursesCreated != null && user.CoursesCreated.Any())
                {
                    _logger.LogWarning("فشل حذف المستخدم [ID: {UserId}] لأنه مرتبط بكورسات.", id);
                    return "لا يمكن حذف المستخدم لأنه مرتبط بكورسات.";
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
                    return null; // ✅ نجاح
                }

                var errors = string.Join(", ", result.Errors.Select(e => e.Description));
                _logger.LogWarning("فشل حذف المستخدم [ID: {UserId}]. الأخطاء: {Errors}", id, errors);

                return "فشل حذف المستخدم بسبب خطأ داخلي.";
            }
            catch (DbUpdateException dbEx)
            {
                _logger.LogError(dbEx, "فشل حذف المستخدم {UserId} بسبب وجود بيانات مرتبطة", id);
                return "لا يمكن حذف هذا المستخدم لأنه مرتبط بكورسات أو بيانات أخرى.";
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "حدث خطأ غير متوقع أثناء حذف المستخدم {UserId}", id);
                return "حدث خطأ داخلي أثناء الحذف، برجاء المحاولة لاحقًا.";
            }
        }



        /// <summary>
        /// Deletes multiple users by their IDs
        /// </summary>
        /// <param name="userIds">List of user identifiers</param>
        /// <returns>True if all deletions were successful, otherwise false</returns>
        public async Task<List<string>> DeleteRangeUserAsync(List<string> userIds)
        {
            var failedUsers = new List<string>();

            try
            {
                var deletedUserNames = new List<string>();
                var currentUserId = await _currentUserService.GetUserIdAsync();

                foreach (var id in userIds)
                {
                    // نفس منطق الحذف العادي
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
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "حدث خطأ أثناء حذف مجموعة المستخدمين");
                failedUsers.Add("حدث خطأ غير متوقع أثناء الحذف.");
            }

            return failedUsers; // ✅ بيرجع قائمة باللي فشل حذفهم
        }


        /// <summary>
        /// Updates user information
        /// </summary>
        /// <param name="dto">User update data transfer object</param>
        /// <returns>True if update was successful, otherwise false</returns>
        /// <summary>
        /// Updates user information
        /// </summary>
        /// <param name="dto">User update data transfer object</param>
        /// <returns>True if update was successful, otherwise false</returns>
        public async Task<bool> UpdateUserAsync(UpdateUserDTO dto)
        {
            try
            {
                var existingUser = await _userManager.FindByIdAsync(dto.Id);
                if (existingUser == null)
                {
                    _logger.LogWarning("User not found for update: {UserId}", dto.Id);
                    return false;
                }

                // التحقق من وجود الدور المطلوب
                if (!await _roleManager.RoleExistsAsync(dto.Role))
                {
                    _logger.LogWarning("Role does not exist: {Role}", dto.Role);
                    return false;
                }

                // تحديث البيانات الأساسية
                existingUser.FullName = dto.FullName;

                var updateResult = await _userManager.UpdateAsync(existingUser);
                if (!updateResult.Succeeded)
                {
                    _logger.LogError("Failed to update user: {Errors}",
                        string.Join(", ", updateResult.Errors.Select(e => e.Description)));
                    return false;
                }

                // إدارة الأدوار
                var currentRoles = await _userManager.GetRolesAsync(existingUser);

                // إزالة الأدوار الحالية فقط إذا كانت مختلفة عن الدور الجديد
                if (currentRoles.Any() && !currentRoles.Contains(dto.Role))
                {
                    var removeResult = await _userManager.RemoveFromRolesAsync(existingUser, currentRoles);
                    if (!removeResult.Succeeded)
                    {
                        _logger.LogError("Failed to remove roles: {Errors}",
                            string.Join(", ", removeResult.Errors.Select(e => e.Description)));
                        return false;
                    }
                }

                // إضافة الدور الجديد فقط إذا لم يكن موجوداً
                if (!currentRoles.Contains(dto.Role))
                {
                    var addRoleResult = await _userManager.AddToRoleAsync(existingUser, dto.Role);
                    if (!addRoleResult.Succeeded)
                    {
                        _logger.LogError("Failed to add role: {Errors}",
                            string.Join(", ", addRoleResult.Errors.Select(e => e.Description)));
                        return false;
                    }
                }

                // تحديث الكاش
                _cache.Remove("AllUsersWithRoles");
                _cache.Remove($"UserById:{dto.Id}");

                // تسجيل العملية
                var currentUserId = await _currentUserService.GetUserIdAsync();
                if (!string.IsNullOrEmpty(currentUserId))
                {
                    await _historyService.LogOperationAsync(
                        currentUserId,
                        $"قام المستخدم بتحديث بيانات المستخدم [ID: {dto.Id.Substring(0, 3)}...] باسم \"{dto.FullName}\"."
                    );
                }

                return true;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "حدث خطأ أثناء تحديث المستخدم: {UserId}", dto.Id);
                return false;
            }
        }

        /// <summary>
        /// Retrieves user information by ID
        /// </summary>
        /// <param name="id">User identifier</param>
        /// <returns>User information if found, otherwise null</returns>
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
                if (user == null)
                    return null;

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
        /// <returns>List of instructors</returns>
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
        /// <returns>List of administrators</returns>
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
        /// <param name="id">Instructor identifier</param>
        /// <returns>Instructor with courses if found, otherwise null</returns>
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

                if (instructor == null)
                    return null;

                var roles = await _userManager.GetRolesAsync(instructor);
                if (!roles.Contains(SD.Instructor))
                    return null;

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
        /// <returns>List of instructors with courses</returns>
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
        /// <param name="userIds">List of user identifiers to lock</param>
        /// <param name="minutes">Duration of lock in minutes</param>
        /// <returns>Task representing the asynchronous operation</returns>
        public async Task<List<UserDTO>> LockUsersAsync(List<string> userIds, int minutes)
        {
            var lockedUsers = new List<UserDTO>();
            try
            {
                var currentUserId = await _currentUserService.GetUserIdAsync();

                foreach (var userId in userIds)
                {
                    // منع المستخدم من قفل نفسه
                    if (userId == currentUserId)
                        continue;

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
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "حدث خطأ أثناء قفل حسابات المستخدمين");
            }

            return lockedUsers;
        }



        /// <summary>
        /// Unlocks user accounts
        /// </summary>
        /// <param name="userIds">List of user identifiers to unlock</param>
        /// <returns>Task representing the asynchronous operation</returns>
        public async Task UnlockUsersAsync(List<string> userIds)
        {
            try
            {
                var unlockedUsers = new List<UserDTO>();

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
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "حدث خطأ أثناء فتح قفل حسابات المستخدمين");
            }
        }

        #endregion

        #region Helper Methods

        /// <summary>
        /// Creates a new user with the specified password
        /// </summary>
        /// <param name="user">User entity to create</param>
        /// <param name="password">User password</param>
        /// <returns>Identity result indicating success or failure</returns>
        private async Task<IdentityResult> CreateUserAsync(ApplicationUser user, string password)
        {
            try
            {
                // إنشاء الأدوار إذا لم تكن موجودة
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

                if (!result.Succeeded)
                {
                    return result;
                }

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
        /// <param name="email">Email address to check</param>
        /// <returns>True if email exists, otherwise false</returns>
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
        /// <param name="fullName">Full name to check</param>
        /// <returns>True if full name exists, otherwise false</returns>
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
        /// <returns>Random 6-digit code</returns>
        private string GenerateRandomCode()
        {
            return new Random().Next(100000, 999999).ToString();
        }

        #endregion
    }
}
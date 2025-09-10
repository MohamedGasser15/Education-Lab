using EduLab_MVC.Models.DTOs.Auth;
using EduLab_MVC.Services.ServiceInterfaces;
using EduLab_Shared.Utitlites;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;

namespace EduLab_MVC.Areas.Admin.Controllers
{
    [Area("Admin")]
    [Authorize(Roles = SD.Admin)]
    public class UserController : Controller
    {
        #region Dependency Injection and Constructor

        private readonly IUserService _userService;
        private readonly IRoleService _roleService;
        private readonly ILogger<UserController> _logger;

        /// <summary>
        /// Initializes a new instance of the UserController class
        /// </summary>
        /// <param name="userService">Service for user operations</param>
        /// <param name="roleService">Service for role operations</param>
        /// <param name="logger">Logger for error tracking and monitoring</param>
        public UserController(
            IUserService userService,
            IRoleService roleService,
            ILogger<UserController> logger)
        {
            _userService = userService ?? throw new ArgumentNullException(nameof(userService));
            _roleService = roleService ?? throw new ArgumentNullException(nameof(roleService));
            _logger = logger ?? throw new ArgumentNullException(nameof(logger));
        }

        #endregion

        #region User Management Views

        /// <summary>
        /// Displays the main users management page
        /// </summary>
        /// <returns>View with list of users and roles</returns>
        public async Task<IActionResult> Index()
        {
            try
            {
                _logger.LogInformation("تحميل صفحة إدارة المستخدمين - بدء العملية");

                var users = await _userService.GetAllUsersAsync();
                
                if (users == null)
                {
                    _logger.LogWarning("قائمة المستخدمين فارغة أو غير متوفرة");
                    TempData["Info"] = "لا يوجد مستخدمين في النظام حالياً";
                    return View(new List<UserDTO>());
                }

                if (!users.Any())
                {
                    _logger.LogInformation("لا يوجد مستخدمين مسجلين في النظام");
                    TempData["Info"] = "لا يوجد مستخدمين في النظام حالياً";
                    return View(users);
                }

                var roles = await _roleService.GetAllRolesAsync();
                
                if (roles == null || !roles.Any())
                {
                    _logger.LogWarning("قائمة الأدوار فارغة أو غير متوفرة");
                    ViewBag.Roles = new List<SelectListItem>();
                }
                else
                {
                    ViewBag.Roles = roles.Select(c => new SelectListItem
                    {
                        Value = c.Id.ToString(),
                        Text = c.Name
                    }).ToList();
                }

                _logger.LogInformation("تم تحميل {UserCount} مستخدم و {RoleCount} دور بنجاح", users.Count, roles?.Count ?? 0);
                return View(users);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "حدث خطأ غير متوقع أثناء تحميل صفحة إدارة المستخدمين");
                TempData["Error"] = "حدث خطأ غير متوقع أثناء تحميل بيانات المستخدمين";
                return View(new List<UserDTO>());
            }
        }

        #endregion

        #region User Operations (Single User)

        /// <summary>
        /// Deletes a single user by ID
        /// </summary>
        /// <param name="id">User identifier to delete</param>
        /// <returns>Redirects to users index page</returns>
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Delete(string id)
        {
            try
            {
                _logger.LogInformation("محاولة حذف المستخدم: {UserId}", id);

                var errorMessage = await _userService.DeleteUserAsync(id);

                if (errorMessage == null)
                {
                    _logger.LogInformation("تم حذف المستخدم بنجاح: {UserId}", id);
                    TempData["Success"] = "تم حذف المستخدم بنجاح";
                }
                else
                {
                    _logger.LogWarning("فشل في حذف المستخدم {UserId}: {ErrorMessage}", id, errorMessage);
                    TempData["Error"] = errorMessage;
                }
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "حدث خطأ غير متوقع أثناء محاولة حذف المستخدم: {UserId}", id);
                TempData["Error"] = "حدث خطأ غير متوقع أثناء محاولة الحذف";
            }

            return RedirectToAction(nameof(Index));
        }

        /// <summary>
        /// Updates user information
        /// </summary>
        /// <param name="dto">User update data transfer object</param>
        /// <returns>Redirects to users index page</returns>
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> UpdateUser(UpdateUserDTO dto)
        {
            try
            {
                _logger.LogInformation("محاولة تحديث بيانات المستخدم: {UserId}", dto?.Id);

                if (dto == null)
                {
                    _logger.LogWarning("بيانات التحديث فارغة");
                    TempData["Error"] = "بيانات المستخدم غير صحيحة";
                    return RedirectToAction(nameof(Index));
                }

                if (string.IsNullOrEmpty(dto.Id))
                {
                    _logger.LogWarning("معرف المستخدم فارغ أثناء التحديث");
                    TempData["Error"] = "معرف المستخدم مطلوب";
                    return RedirectToAction(nameof(Index));
                }

                if (string.IsNullOrEmpty(dto.FullName?.Trim()))
                {
                    _logger.LogWarning("اسم المستخدم فارغ أثناء التحديث: {UserId}", dto.Id);
                    TempData["Error"] = "اسم المستخدم مطلوب";
                    return RedirectToAction(nameof(Index));
                }

                if (string.IsNullOrEmpty(dto.Role))
                {
                    _logger.LogWarning("دور المستخدم فارغ أثناء التحديث: {UserId}", dto.Id);
                    TempData["Error"] = "دور المستخدم مطلوب";
                    return RedirectToAction(nameof(Index));
                }

                // تنظيف البيانات
                dto.FullName = dto.FullName.Trim();

                var result = await _userService.UpdateUserAsync(dto);

                if (result.Success)
                {
                    _logger.LogInformation("تم تحديث المستخدم بنجاح: {UserId}", dto.Id);
                    TempData["Success"] = result.Message;
                }
                else
                {
                    _logger.LogWarning("فشل في تحديث المستخدم: {UserId} - {Error}", dto.Id, result.Message);
                    TempData["Error"] = result.Message;
                }
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "حدث خطأ غير متوقع أثناء محاولة تحديث المستخدم: {UserId}", dto?.Id);
                TempData["Error"] = "حدث خطأ غير متوقع أثناء محاولة التحديث";
            }

            return RedirectToAction(nameof(Index));
        }

        /// <summary>
        /// Locks a single user account for specified duration
        /// </summary>
        /// <param name="id">User identifier to lock</param>
        /// <param name="minutes">Lock duration in minutes</param>
        /// <returns>Redirects to users index page</returns>
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Lock(string id, int minutes)
        {
            try
            {
                _logger.LogInformation("محاولة قفل المستخدم: {UserId} لمدة {Minutes} دقيقة", id, minutes);

                if (string.IsNullOrEmpty(id) || minutes <= 0)
                {
                    _logger.LogWarning("بيانات القفل غير صحيحة: UserId={UserId}, Minutes={Minutes}", id, minutes);
                    TempData["Error"] = "بيانات غير صحيحة لقفل المستخدم";
                    return RedirectToAction(nameof(Index));
                }

                await _userService.LockUsersAsync(new List<string> { id }, minutes);
                
                _logger.LogInformation("تم قفل المستخدم بنجاح: {UserId} لمدة {Minutes} دقيقة", id, minutes);
                TempData["Success"] = $"تم قفل المستخدم لمدة {minutes} دقيقة بنجاح";
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "حدث خطأ غير متوقع أثناء محاولة قفل المستخدم: {UserId}", id);
                TempData["Error"] = "حدث خطأ أثناء محاولة قفل المستخدم";
            }

            return RedirectToAction(nameof(Index));
        }

        /// <summary>
        /// Unlocks a single user account
        /// </summary>
        /// <param name="id">User identifier to unlock</param>
        /// <returns>Redirects to users index page</returns>
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Unlock(string id)
        {
            try
            {
                _logger.LogInformation("محاولة فتح قفل المستخدم: {UserId}", id);

                if (string.IsNullOrEmpty(id))
                {
                    _logger.LogWarning("معرف المستخدم فارغ أثناء محاولة فتح القفل");
                    TempData["Error"] = "معرف المستخدم لا يمكن أن يكون فارغًا";
                    return RedirectToAction(nameof(Index));
                }

                await _userService.UnlockUsersAsync(new List<string> { id });
                
                _logger.LogInformation("تم فتح قفل المستخدم بنجاح: {UserId}", id);
                TempData["Success"] = "تم فتح قفل المستخدم بنجاح";
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "حدث خطأ غير متوقع أثناء محاولة فتح قفل المستخدم: {UserId}", id);
                TempData["Error"] = "حدث خطأ أثناء محاولة فتح قفل المستخدم";
            }

            return RedirectToAction(nameof(Index));
        }

        #endregion

        #region Bulk User Operations

        /// <summary>
        /// Deletes multiple users by their IDs
        /// </summary>
        /// <param name="userIds">List of user identifiers to delete</param>
        /// <returns>Redirects to users index page</returns>
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeleteUsers(List<string> userIds)
        {
            try
            {
                _logger.LogInformation("محاولة حذف {UserCount} مستخدم", userIds?.Count ?? 0);

                var errorMessage = await _userService.DeleteRangeUsersAsync(userIds);

                if (errorMessage == null)
                {
                    _logger.LogInformation("تم حذف {UserCount} مستخدم بنجاح", userIds.Count);
                    TempData["Success"] = "تم حذف المستخدمين بنجاح";
                }
                else
                {
                    _logger.LogWarning("فشل في الحذف الجماعي: {ErrorMessage}", errorMessage);
                    TempData["Error"] = errorMessage;
                }
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "حدث خطأ غير متوقع أثناء محاولة الحذف الجماعي للمستخدمين");
                TempData["Error"] = "حدث خطأ غير متوقع أثناء محاولة الحذف";
            }

            return RedirectToAction(nameof(Index));
        }

        /// <summary>
        /// Locks multiple user accounts for specified duration
        /// </summary>
        /// <param name="userIds">List of user identifiers to lock</param>
        /// <param name="minutes">Lock duration in minutes</param>
        /// <returns>Redirects to users index page</returns>
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> LockUsers(List<string> userIds, int minutes)
        {
            try
            {
                _logger.LogInformation("محاولة قفل {UserCount} مستخدم لمدة {Minutes} دقيقة", userIds?.Count ?? 0, minutes);

                if (userIds == null || userIds.Count == 0 || minutes <= 0)
                {
                    _logger.LogWarning("بيانات القفل الجماعي غير صحيحة: UserCount={UserCount}, Minutes={Minutes}", 
                        userIds?.Count ?? 0, minutes);
                    TempData["Error"] = "بيانات غير صحيحة لقفل المستخدمين";
                    return RedirectToAction(nameof(Index));
                }

                await _userService.LockUsersAsync(userIds, minutes);
                
                _logger.LogInformation("تم قفل {UserCount} مستخدم بنجاح لمدة {Minutes} دقيقة", userIds.Count, minutes);
                TempData["Success"] = $"تم قفل {userIds.Count} مستخدمين لمدة {minutes} دقيقة بنجاح";
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "حدث خطأ غير متوقع أثناء محاولة القفل الجماعي للمستخدمين");
                TempData["Error"] = "حدث خطأ أثناء محاولة قفل المستخدمين";
            }

            return RedirectToAction(nameof(Index));
        }

        /// <summary>
        /// Unlocks multiple user accounts
        /// </summary>
        /// <param name="userIds">List of user identifiers to unlock</param>
        /// <returns>Redirects to users index page</returns>
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> UnlockUsers(List<string> userIds)
        {
            try
            {
                _logger.LogInformation("محاولة فتح قفل {UserCount} مستخدم", userIds?.Count ?? 0);

                if (userIds == null || userIds.Count == 0)
                {
                    _logger.LogWarning("قائمة معرفات المستخدمين فارغة أثناء محاولة فتح القفل الجماعي");
                    TempData["Error"] = "لا توجد معرفات مستخدمين لفتح القفل";
                    return RedirectToAction(nameof(Index));
                }

                await _userService.UnlockUsersAsync(userIds);
                
                _logger.LogInformation("تم فتح قفل {UserCount} مستخدم بنجاح", userIds.Count);
                TempData["Success"] = $"تم فتح قفل {userIds.Count} مستخدمين بنجاح";
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "حدث خطأ غير متوقع أثناء محاولة فتح القفل الجماعي للمستخدمين");
                TempData["Error"] = "حدث خطأ أثناء محاولة فتح قفل المستخدمين";
            }

            return RedirectToAction(nameof(Index));
        }

        #endregion
    }
}
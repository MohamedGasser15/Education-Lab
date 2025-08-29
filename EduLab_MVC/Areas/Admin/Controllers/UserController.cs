using EduLab_MVC.Models.DTOs.Auth;
using EduLab_MVC.Services;
using EduLab_Shared.Utitlites;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace EduLab_MVC.Areas.Admin.Controllers
{
    [Area("Admin")]
    [Authorize(Roles = SD.Admin)]
    public class UserController : Controller
    {
        private readonly UserService _userService;
        public UserController(UserService userService)
        {
            _userService = userService;
        }
        public async Task<IActionResult> Index()
        {
            var users = await _userService.GetAllUsersAsync();
            if (users == null)
            {
                return NotFound("No users found.");
            }
            return View(users);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]  // Important for security
        public async Task<IActionResult> Delete(string id)
        {
            if (string.IsNullOrEmpty(id))
            {
                TempData["Error"] = "معرف المستخدم لا يمكن أن يكون فارغًا";
                return RedirectToAction(nameof(Index));
            }

            try
            {
                var result = await _userService.DeleteUserAsync(id);
                if (result)
                {
                    TempData["Success"] = "تم حذف المستخدم بنجاح";
                }
                else
                {
                    TempData["Error"] = "لم يتم العثور على المستخدم أو تعذر الحذف";
                }
            }
            catch (Exception ex)
            {
                // Log the exception here
                TempData["Error"] = "حدث خطأ غير متوقع أثناء محاولة الحذف";
            }

            return RedirectToAction(nameof(Index));
        }
        [HttpPost]
        [ValidateAntiForgeryToken]  // Important for security
        public async Task<IActionResult> DeleteUsers(List<string> userIds)
        {
            if (userIds == null || userIds.Count == 0)
            {
                TempData["Error"] = "لا توجد معرفات مستخدمين للحذف";
                return RedirectToAction(nameof(Index));
            }
            try
            {
                var result = await _userService.DeleteRangeUsersAsync(userIds);
                if (result)
                {
                    TempData["Success"] = "تم حذف المستخدمين بنجاح";
                }
                else
                {
                    TempData["Error"] = "بعض المستخدمين لم يتم العثور عليهم أو تعذر حذفهم";
                }
            }
            catch (Exception ex)
            {
                // Log the exception here
                TempData["Error"] = "حدث خطأ غير متوقع أثناء محاولة الحذف";
            }
            return RedirectToAction(nameof(Index));
        }
        [HttpPost]
        [ValidateAntiForgeryToken]  // Important for security
        public async Task<IActionResult> UpdateUser(UpdateUserDTO dto)
        {
            if (string.IsNullOrEmpty(dto.Id) || string.IsNullOrEmpty(dto.FullName) || string.IsNullOrEmpty(dto.Role))
            {
                TempData["Error"] = "بيانات المستخدم غير صحيحة";
                return RedirectToAction(nameof(Index));
            }
            try
            {
                var result = await _userService.UpdateUserAsync(dto);
                if (result)
                {
                    TempData["Success"] = "تم تحديث المستخدم بنجاح";

                }
                else
                {
                    TempData["Error"] = "لم يتم العثور على المستخدم أو تعذر التحديث";
                }
            }
            catch (Exception ex)
            {
                // Log the exception here
                TempData["Error"] = "حدث خطأ غير متوقع أثناء محاولة التحديث";
            }
            return RedirectToAction(nameof(Index));
        }
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Lock(string id, int minutes)
        {
            if (string.IsNullOrEmpty(id) || minutes <= 0)
            {
                TempData["Error"] = "بيانات غير صحيحة لقفل المستخدم";
                return RedirectToAction(nameof(Index));
            }

            try
            {
                await _userService.LockUsersAsync(new List<string> { id }, minutes);
                TempData["Success"] = $"تم قفل المستخدم لمدة {minutes} دقيقة بنجاح";
            }
            catch (Exception ex)
            {
                TempData["Error"] = "حدث خطأ أثناء محاولة قفل المستخدم";
            }

            return RedirectToAction(nameof(Index));
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Unlock(string id)
        {
            if (string.IsNullOrEmpty(id))
            {
                TempData["Error"] = "معرف المستخدم لا يمكن أن يكون فارغًا";
                return RedirectToAction(nameof(Index));
            }

            try
            {
                await _userService.UnlockUsersAsync(new List<string> { id });
                TempData["Success"] = "تم فتح قفل المستخدم بنجاح";
            }
            catch (Exception ex)
            {
                TempData["Error"] = "حدث خطأ أثناء محاولة فتح قفل المستخدم";
            }

            return RedirectToAction(nameof(Index));
        }
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> LockUsers(List<string> userIds, int minutes)
        {
            if (userIds == null || userIds.Count == 0 || minutes <= 0)
            {
                TempData["Error"] = "بيانات غير صحيحة لقفل المستخدمين";
                return RedirectToAction(nameof(Index));
            }

            try
            {
                await _userService.LockUsersAsync(userIds, minutes);
                TempData["Success"] = $"تم قفل {userIds.Count} مستخدمين لمدة {minutes} دقيقة بنجاح";
            }
            catch (Exception ex)
            {
                TempData["Error"] = "حدث خطأ أثناء محاولة قفل المستخدمين";
            }

            return RedirectToAction(nameof(Index));
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> UnlockUsers(List<string> userIds)
        {
            if (userIds == null || userIds.Count == 0)
            {
                TempData["Error"] = "لا توجد معرفات مستخدمين لفتح القفل";
                return RedirectToAction(nameof(Index));
            }

            try
            {
                await _userService.UnlockUsersAsync(userIds);
                TempData["Success"] = $"تم فتح قفل {userIds.Count} مستخدمين بنجاح";
            }
            catch (Exception ex)
            {
                TempData["Error"] = "حدث خطأ أثناء محاولة فتح قفل المستخدمين";
            }

            return RedirectToAction(nameof(Index));
        }

    }
}

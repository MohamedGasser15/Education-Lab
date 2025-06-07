using EduLab_MVC.Models.DTOs.Auth;
using EduLab_MVC.Services;
using Microsoft.AspNetCore.Mvc;

namespace EduLab_MVC.Areas.Admin.Controllers
{
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
        public async Task<IActionResult> Instructors()
        {
            var instructors = await _userService.GetInstructorsAsync();
            if (instructors == null)
            {
                return NotFound("No instructors found.");
            }
            return View(instructors);
        }
        public async Task<IActionResult> Admins()
        {
            var admins = await _userService.GetAdminsAsync();
            if (admins == null)
            {
                return NotFound("No admins found.");
            }
            return View(admins);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]  // Important for security
        public async Task<IActionResult> Delete(string id)
        {
            if (string.IsNullOrEmpty(id))
            {
                TempData["ErrorMessage"] = "معرف المستخدم لا يمكن أن يكون فارغًا";
                return RedirectToAction(nameof(Index));
            }

            try
            {
                var result = await _userService.DeleteUserAsync(id);
                if (result)
                {
                    TempData["SuccessMessage"] = "تم حذف المستخدم بنجاح";
                }
                else
                {
                    TempData["ErrorMessage"] = "لم يتم العثور على المستخدم أو تعذر الحذف";
                }
            }
            catch (Exception ex)
            {
                // Log the exception here
                TempData["ErrorMessage"] = "حدث خطأ غير متوقع أثناء محاولة الحذف";
            }

            return RedirectToAction(nameof(Index));
        }
        [HttpPost]
        [ValidateAntiForgeryToken]  // Important for security
        public async Task<IActionResult> DeleteUsers(List<string> userIds)
        {
            if (userIds == null || userIds.Count == 0)
            {
                TempData["ErrorMessage"] = "لا توجد معرفات مستخدمين للحذف";
                return RedirectToAction(nameof(Index));
            }
            try
            {
                var result = await _userService.DeleteRangeUsersAsync(userIds);
                if (result)
                {
                    TempData["SuccessMessage"] = "تم حذف المستخدمين بنجاح";
                }
                else
                {
                    TempData["ErrorMessage"] = "بعض المستخدمين لم يتم العثور عليهم أو تعذر حذفهم";
                }
            }
            catch (Exception ex)
            {
                // Log the exception here
                TempData["ErrorMessage"] = "حدث خطأ غير متوقع أثناء محاولة الحذف";
            }
            return RedirectToAction(nameof(Index));
        }
        [HttpPost]
        [ValidateAntiForgeryToken]  // Important for security
        public async Task<IActionResult> UpdateUser(UpdateUserDTO dto)
        {
            if (string.IsNullOrEmpty(dto.Id) || string.IsNullOrEmpty(dto.FullName) || string.IsNullOrEmpty(dto.Role))
            {
                TempData["ErrorMessage"] = "بيانات المستخدم غير صحيحة";
                return RedirectToAction(nameof(Index));
            }
            try
            {
                var result = await _userService.UpdateUserAsync(dto);
                if (result)
                {
                    TempData["SuccessMessage"] = "تم تحديث المستخدم بنجاح";
                }
                else
                {
                    TempData["ErrorMessage"] = "لم يتم العثور على المستخدم أو تعذر التحديث";
                }
            }
            catch (Exception ex)
            {
                // Log the exception here
                TempData["ErrorMessage"] = "حدث خطأ غير متوقع أثناء محاولة التحديث";
            }
            return RedirectToAction(nameof(Index));
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> LockUsers(List<string> userIds, int minutes)
        {
            if (userIds == null || userIds.Count == 0 || minutes <= 0)
            {
                TempData["ErrorMessage"] = "بيانات غير صحيحة لقفل المستخدمين";
                return RedirectToAction(nameof(Index));
            }

            try
            {
                await _userService.LockUsersAsync(userIds, minutes);
                TempData["SuccessMessage"] = $"تم قفل {userIds.Count} مستخدمين لمدة {minutes} دقيقة بنجاح";
            }
            catch (Exception ex)
            {
                TempData["ErrorMessage"] = "حدث خطأ أثناء محاولة قفل المستخدمين";
            }

            return RedirectToAction(nameof(Index));
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> UnlockUsers(List<string> userIds)
        {
            if (userIds == null || userIds.Count == 0)
            {
                TempData["ErrorMessage"] = "لا توجد معرفات مستخدمين لفتح القفل";
                return RedirectToAction(nameof(Index));
            }

            try
            {
                await _userService.UnlockUsersAsync(userIds);
                TempData["SuccessMessage"] = $"تم فتح قفل {userIds.Count} مستخدمين بنجاح";
            }
            catch (Exception ex)
            {
                TempData["ErrorMessage"] = "حدث خطأ أثناء محاولة فتح قفل المستخدمين";
            }

            return RedirectToAction(nameof(Index));
        }

    }
}

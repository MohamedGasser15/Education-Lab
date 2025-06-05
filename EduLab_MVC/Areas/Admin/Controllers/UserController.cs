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
    }
}

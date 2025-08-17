using EduLab_MVC.Filters;
using EduLab_MVC.Models.DTOs.Roles;
using EduLab_MVC.Services;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;

namespace EduLab_MVC.Controllers
{
    [AdminOnly]
    [Area("Admin")]
    public class RoleController : Controller
    {
        private readonly RoleService _roleService;

        public RoleController(RoleService roleService)
        {
            _roleService = roleService;
        }

        // صفحة عرض كل الرُولات
        public async Task<IActionResult> Index()
        {
            var roles = await _roleService.GetAllRolesAsync();
            return View(roles);
        }

        // صفحة تفاصيل رُول
        public async Task<IActionResult> Details(string id)
        {
            if (string.IsNullOrEmpty(id)) return NotFound();

            var role = await _roleService.GetRoleByIdAsync(id);
            if (role == null) return NotFound();

            return View(role);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create(string roleName)
        {
            if (string.IsNullOrWhiteSpace(roleName))
            {
                TempData["Error"] = "اسم الدور مطلوب";
                return RedirectToAction(nameof(Index));
            }

            var result = await _roleService.CreateRoleAsync(roleName);
            if (!result.Succeeded)
            {
                if (result.Errors.Any(e => e.Code == "DuplicateRoleName"))
                    TempData["Error"] = "اسم الدور موجود بالفعل.";
                else
                    TempData["Error"] = string.Join(", ", result.Errors.Select(e => e.Description));

                return RedirectToAction(nameof(Index));
            }

            TempData["Success"] = "تم أضافه الدور بنجاح.";
            return RedirectToAction(nameof(Index));
        }



        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(string id, string roleName)
        {
            if (string.IsNullOrWhiteSpace(roleName))
            {
                ModelState.AddModelError("", "اسم الدور مطلوب");
                return View();
            }

            var result = await _roleService.UpdateRoleAsync(id, roleName);

            if (!result.Succeeded)
            {
                TempData["Error"] = "حدث خطأ غير متوقع أثناء محاولة تعديل الدور";
                ModelState.AddModelError("", string.Join(", ", result.Errors.Select(e => e.Description)));
                return View();
            }

            TempData["Success"] = "تم تعديل الدور بنجاح.";
            return RedirectToAction(nameof(Index));

        }

        // حذف رُول
        public async Task<IActionResult> Delete(string id)
        {
            if (string.IsNullOrEmpty(id)) return NotFound();

            var result = await _roleService.DeleteRoleAsync(id);
            if (!result.Succeeded)
            {
                TempData["Error"] = "حدث خطأ غير متوقع أثناء محاولة حذف الدور";
                TempData["Error"] = string.Join(", ", result.Errors.Select(e => e.Description));
                return RedirectToAction(nameof(Index));
            }
            TempData["Success"] = "تم حذف الدور بنجاح.";
            return RedirectToAction(nameof(Index));
        }
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> BulkDelete(string roleIds)
        {
            if (string.IsNullOrEmpty(roleIds))
            {
                TempData["Error"] = "لم يتم اختيار أي دور للحذف.";
                return RedirectToAction(nameof(Index));
            }

            // تحويل الـ string إلى List<string>
            var idsList = roleIds.Split(',').ToList();

            var result = await _roleService.BulkDeleteRolesAsync(idsList);

            if (!result.Succeeded)
            {
                TempData["Error"] = "حدث خطأ أثناء محاولة الحذف: " + string.Join(", ", result.Errors.Select(e => e.Description));
                return RedirectToAction(nameof(Index));
            }

            TempData["Success"] = "تم حذف الأدوار المحددة بنجاح.";
            return RedirectToAction(nameof(Index));
        }

        // عرض الـ claims الخاصة بالرُول
        public async Task<IActionResult> Claims(string id)
        {
            if (string.IsNullOrEmpty(id)) return NotFound();

            var roleClaims = await _roleService.GetRoleClaimsAsync(id);
            if (roleClaims == null) return NotFound();

            return View(roleClaims);
        }
        // إضافة هذا الإكشن لعرض صفحة إدارة الصلاحيات
        public async Task<IActionResult> ManagePermissions(string id)
        {
            if (string.IsNullOrEmpty(id))
                return NotFound();

            var role = await _roleService.GetRoleByIdAsync(id);
            if (role == null)
                return NotFound();

            ViewBag.RoleId = id;
            ViewBag.RoleName = role.Name;

            return View();
        }

        [HttpPost]
        public async Task<IActionResult> UpdateClaims(
            [FromBody] UpdateRoleClaimsModel model)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(new
                {
                    errors = ModelState.Values
                        .SelectMany(v => v.Errors)
                        .Select(e => e.ErrorMessage)
                });
            }

            var result = await _roleService.UpdateRoleClaimsAsync(model.RoleId, model.Claims);
            if (result.Succeeded)
            {
                TempData["Success"] = "تم تحديث ال claims بنجاح.";
                return Ok(new { success = true });
            }
            TempData["Error"] = "حدث خطأ غير متوقع أثناء محاولة حذف الدور";
            return BadRequest(new
            {

                errors = result.Errors.Select(e => e.Description)
            });
        }


        // عرض المستخدمين في رُول
        public async Task<IActionResult> UsersInRole(string roleName)
        {
            if (string.IsNullOrEmpty(roleName)) return NotFound();

            var users = await _roleService.GetUsersInRoleAsync(roleName);
            return View(users);
        }
        [HttpGet]
        public async Task<IActionResult> GetClaimsJson(string id)
        {
            if (string.IsNullOrEmpty(id))
                return BadRequest();

            var roleClaims = await _roleService.GetRoleClaimsAsync(id);
            if (roleClaims == null)
                return NotFound();

            return Json(roleClaims);
        }


    }
}

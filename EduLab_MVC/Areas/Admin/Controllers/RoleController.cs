using EduLab_MVC.Models.DTOs.Roles;
using EduLab_MVC.Services;
using EduLab_Shared.Utitlites;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;

namespace EduLab_MVC.Controllers
{
    [Area("Admin")]
    [Authorize(Roles = SD.Admin)]
    public class RoleController : Controller
    {
        private readonly RoleService _roleService;

        public RoleController(RoleService roleService)
        {
            _roleService = roleService;
        }

        public async Task<IActionResult> Index()
        {
            var roles = await _roleService.GetAllRolesAsync();
            return View(roles);
        }

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

            var success = await _roleService.CreateRoleAsync(roleName);
            if (!success)
            {
                TempData["Error"] = "حدث خطأ أثناء إنشاء الدور، ربما الدور موجود بالفعل.";
                return RedirectToAction(nameof(Index));
            }

            TempData["Success"] = "تم إضافة الدور بنجاح.";
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

            var success = await _roleService.UpdateRoleAsync(id, roleName);
            if (!success)
            {
                TempData["Error"] = "فشل تعديل الدور، ربما الدور غير موجود.";
                return View();
            }

            TempData["Success"] = "تم تعديل الدور بنجاح.";
            return RedirectToAction(nameof(Index));
        }

        public async Task<IActionResult> Delete(string id)
        {
            if (string.IsNullOrEmpty(id)) return NotFound();

            var success = await _roleService.DeleteRoleAsync(id);
            if (!success)
            {
                TempData["Error"] = "فشل حذف الدور، ربما يحتوي على مستخدمين أو غير موجود.";
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

            var idsList = roleIds.Split(',').ToList();
            var success = await _roleService.BulkDeleteRolesAsync(idsList);

            if (!success)
            {
                TempData["Error"] = "فشل حذف بعض الأدوار، ربما بعض الأدوار تحتوي على مستخدمين أو غير موجودة.";
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
        public async Task<IActionResult> UpdateClaims([FromBody] UpdateRoleClaimsModel model)
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

            var success = await _roleService.UpdateRoleClaimsAsync(model.RoleId, model.Claims);
            if (!success)
            {
                return BadRequest(new
                {
                    errors = new[] { "فشل تحديث الكليمات، ربما الدور غير موجود." }
                });
            }

            TempData["Success"] = "تم تحديث الكليمات بنجاح.";
            return Ok(new { success = true });
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

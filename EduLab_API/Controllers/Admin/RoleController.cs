using EduLab_Application.ServiceInterfaces;
using EduLab_Shared.DTOs.Role;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace EduLab_API.Controllers.Admin
{
    [Route("api/[controller]")]
    [ApiController]
    public class RoleController : ControllerBase
    {
        private readonly IRoleService _roleService;

        public RoleController(IRoleService roleService)
        {
            _roleService = roleService;
        }

        [HttpGet]
        public async Task<ActionResult<IEnumerable<RoleDto>>> GetAllRoles()
        {
            var roles = await _roleService.GetAllRolesAsync();
            return Ok(roles);
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<RoleDto>> GetRoleById(string id)
        {
            var role = await _roleService.GetRoleByIdAsync(id);
            if (role == null) return NotFound();
            return Ok(role);
        }

        [HttpPost]
        public async Task<IActionResult> CreateRole([FromBody] string roleName)
        {
            if (string.IsNullOrWhiteSpace(roleName))
                return BadRequest("اسم الدور مطلوب");

            var success = await _roleService.CreateRoleAsync(roleName);
            if (!success)
                return BadRequest("حدث خطأ أثناء إنشاء الدور، قد يكون موجود بالفعل.");

            return Ok("تم إضافة الدور بنجاح");
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> UpdateRole(string id, [FromBody] string roleName)
        {
            if (string.IsNullOrWhiteSpace(roleName))
                return BadRequest("اسم الدور مطلوب");

            var success = await _roleService.UpdateRoleAsync(id, roleName);
            if (!success)
                return BadRequest("فشل تحديث الدور، ربما الدور غير موجود.");

            return Ok("تم تحديث الدور بنجاح");
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteRole(string id)
        {
            var success = await _roleService.DeleteRoleAsync(id);
            if (!success)
                return BadRequest("فشل حذف الدور، ربما الدور غير موجود أو يحتوي على مستخدمين.");

            return Ok("تم حذف الدور بنجاح");
        }

        [HttpPost("bulk-delete")]
        public async Task<IActionResult> BulkDeleteRoles([FromBody] List<string> roleIds)
        {
            if (roleIds == null || !roleIds.Any())
                return BadRequest("لم يتم تقديم أي معرفات للأدوار");

            var success = await _roleService.BulkDeleteRolesAsync(roleIds);
            if (!success)
                return BadRequest("فشل حذف بعض الأدوار، ربما بعض الأدوار تحتوي على مستخدمين أو غير موجودة.");

            return Ok("تم حذف الأدوار بنجاح");
        }

        [HttpGet("statistics")]
        public async Task<IActionResult> GetRolesStatistics()
        {
            var stats = await _roleService.GetRolesStatisticsAsync();
            return Ok(new
            {
                TotalRoles = stats.TotalRoles,
                ActiveRoles = stats.ActiveRoles,
                SystemRoles = stats.SystemRoles,
                LatestRoleDate = stats.LatestRoleDate
            });
        }

        [HttpGet("{roleId}/claims")]
        public async Task<ActionResult<RoleClaimsDto>> GetRoleClaims(string roleId)
        {
            var roleClaims = await _roleService.GetRoleClaimsAsync(roleId);
            if (roleClaims == null) return NotFound();
            return Ok(roleClaims);
        }

        [HttpPost("{roleId}/claims")]
        public async Task<IActionResult> UpdateRoleClaims(
            string roleId,
            [FromBody] UpdateRoleClaimsRequest request)
        {
            var success = await _roleService.UpdateRoleClaimsAsync(roleId, request.Claims);
            if (!success)
                return BadRequest("فشل تحديث الكليمات، ربما الدور غير موجود.");

            return Ok("تم تحديث الكليمات بنجاح");
        }

        [HttpGet("{roleName}/users")]
        public async Task<ActionResult<List<UserRoleDto>>> GetUsersInRole(string roleName)
        {
            var users = await _roleService.GetUsersInRoleAsync(roleName);
            return Ok(users);
        }
    }
}

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
                return BadRequest("Role name cannot be empty");

            var result = await _roleService.CreateRoleAsync(roleName);
            if (!result.Succeeded)
                return BadRequest(result.Errors);

            return Ok();
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> UpdateRole(string id, [FromBody] string roleName)
        {
            if (string.IsNullOrWhiteSpace(roleName))
                return BadRequest("Role name cannot be empty");

            var result = await _roleService.UpdateRoleAsync(id, roleName);
            if (!result.Succeeded)
                return BadRequest(result.Errors);

            return Ok();
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteRole(string id)
        {
            var result = await _roleService.DeleteRoleAsync(id);
            if (!result.Succeeded)
                return BadRequest(result.Errors);

            return Ok();
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
            var result = await _roleService.UpdateRoleClaimsAsync(roleId, request.Claims);
            if (!result.Succeeded)
                return BadRequest(result.Errors);

            return Ok();
        }

        [HttpGet("{roleName}/users")]
        public async Task<ActionResult<List<UserRoleDto>>> GetUsersInRole(string roleName)
        {
            var users = await _roleService.GetUsersInRoleAsync(roleName);
            return Ok(users);
        }
    }
}

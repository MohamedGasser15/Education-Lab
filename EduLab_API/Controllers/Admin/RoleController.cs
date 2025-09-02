using EduLab_Application.ServiceInterfaces;
using EduLab_Shared.DTOs.Role;
using EduLab_Shared.Utitlites;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;

namespace EduLab_API.Controllers.Admin
{
    /// <summary>
    /// API controller for managing application roles
    /// </summary>
    [Route("api/[controller]")]
    [ApiController]
    [Authorize(Roles = SD.Admin)]
    public class RoleController : ControllerBase
    {
        private readonly IRoleService _roleService;
        private readonly ILogger<RoleController> _logger;

        /// <summary>
        /// Initializes a new instance of the RoleController class
        /// </summary>
        public RoleController(IRoleService roleService, ILogger<RoleController> logger)
        {
            _roleService = roleService;
            _logger = logger;
        }

        #region Role CRUD Operations

        /// <summary>
        /// Retrieves all roles in the system
        /// </summary>
        /// <param name="cancellationToken">Cancellation token for async operation</param>
        /// <returns>List of RoleDto objects</returns>
        [HttpGet]
        [ProducesResponseType(typeof(IEnumerable<RoleDto>), 200)] // OK
        [ProducesResponseType(499)] // Request cancelled
        [ProducesResponseType(500)] // Internal server error
        [ProducesResponseType(401)]
        public async Task<ActionResult<IEnumerable<RoleDto>>> GetAllRoles(CancellationToken cancellationToken = default)
        {
            _logger.LogInformation("API: Getting all roles");

            try
            {
                var roles = await _roleService.GetAllRolesAsync(cancellationToken);
                return Ok(roles);
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("API: Get all roles operation was cancelled");
                return StatusCode(499, "Request cancelled"); // Client closed request
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "API: Error occurred while getting all roles");
                return StatusCode(500, "An error occurred while retrieving roles");
            }
        }

        /// <summary>
        /// Retrieves a specific role by ID
        /// </summary>
        /// <param name="id">The role ID</param>
        /// <param name="cancellationToken">Cancellation token for async operation</param>
        /// <returns>RoleDto object or NotFound</returns>
        [HttpGet("{id}")]
        [ProducesResponseType(typeof(RoleDto), 200)] // OK
        [ProducesResponseType(400)] // Bad Request
        [ProducesResponseType(404)] // Not Found
        [ProducesResponseType(499)] // Cancelled
        [ProducesResponseType(401)]
        [ProducesResponseType(500)] // Server Error

        public async Task<ActionResult<RoleDto>> GetRoleById(string id, CancellationToken cancellationToken = default)
        {
            _logger.LogInformation("API: Getting role by ID: {RoleId}", id);

            if (string.IsNullOrEmpty(id))
            {
                _logger.LogWarning("API: Role ID cannot be null or empty");
                return BadRequest("Role ID is required");
            }

            try
            {
                var role = await _roleService.GetRoleByIdAsync(id, cancellationToken);
                if (role == null)
                {
                    _logger.LogWarning("API: Role with ID {RoleId} not found", id);
                    return NotFound();
                }

                return Ok(role);
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("API: Get role by ID operation was cancelled");
                return StatusCode(499, "Request cancelled");
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "API: Error occurred while getting role with ID: {RoleId}", id);
                return StatusCode(500, "An error occurred while retrieving the role");
            }
        }

        /// <summary>
        /// Creates a new role
        /// </summary>
        /// <param name="roleName">The name of the role to create</param>
        /// <param name="cancellationToken">Cancellation token for async operation</param>
        /// <returns>ActionResult with operation result</returns>
        [HttpPost]
        [Authorize(Roles = SD.Admin)]
        [ProducesResponseType(200)] // Success
        [ProducesResponseType(400)] // Bad Request
        [ProducesResponseType(401)] // Unauthorized
        [ProducesResponseType(403)] // Forbidden
        [ProducesResponseType(499)] // Cancelled
        [ProducesResponseType(500)] // Server Error
        public async Task<IActionResult> CreateRole([FromBody] string roleName, CancellationToken cancellationToken = default)
        {
            _logger.LogInformation("API: Creating new role: {RoleName}", roleName);

            if (string.IsNullOrWhiteSpace(roleName))
            {
                _logger.LogWarning("API: Role name cannot be null or empty");
                return BadRequest("Role name is required");
            }

            try
            {
                var success = await _roleService.CreateRoleAsync(roleName, cancellationToken);
                if (!success)
                {
                    _logger.LogWarning("API: Failed to create role: {RoleName}", roleName);
                    return BadRequest("Failed to create role. The role may already exist.");
                }

                _logger.LogInformation("API: Role created successfully: {RoleName}", roleName);
                return Ok("Role created successfully");
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("API: Create role operation was cancelled");
                return StatusCode(499, "Request cancelled");
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "API: Error occurred while creating role: {RoleName}", roleName);
                return StatusCode(500, "An error occurred while creating the role");
            }
        }

        /// <summary>
        /// Updates an existing role
        /// </summary>
        /// <param name="id">The role ID to update</param>
        /// <param name="roleName">The new role name</param>
        /// <param name="cancellationToken">Cancellation token for async operation</param>
        /// <returns>ActionResult with operation result</returns>
        [HttpPut("{id}")]
        [Authorize(Roles = SD.Admin)]
        [ProducesResponseType(200)]
        [ProducesResponseType(400)]
        [ProducesResponseType(401)]
        [ProducesResponseType(403)]
        [ProducesResponseType(499)]
        [ProducesResponseType(500)]
        public async Task<IActionResult> UpdateRole(string id, [FromBody] string roleName, CancellationToken cancellationToken = default)
        {
            _logger.LogInformation("API: Updating role with ID: {RoleId} to name: {NewRoleName}", id, roleName);

            if (string.IsNullOrEmpty(id) || string.IsNullOrWhiteSpace(roleName))
            {
                _logger.LogWarning("API: Role ID or name cannot be null or empty");
                return BadRequest("Role ID and name are required");
            }

            try
            {
                var success = await _roleService.UpdateRoleAsync(id, roleName, cancellationToken);
                if (!success)
                {
                    _logger.LogWarning("API: Failed to update role with ID: {RoleId}", id);
                    return BadRequest("Failed to update role. The role may not exist.");
                }

                _logger.LogInformation("API: Role updated successfully: {RoleName}", roleName);
                return Ok("Role updated successfully");
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("API: Update role operation was cancelled");
                return StatusCode(499, "Request cancelled");
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "API: Error occurred while updating role with ID: {RoleId}", id);
                return StatusCode(500, "An error occurred while updating the role");
            }
        }

        /// <summary>
        /// Deletes a role by ID
        /// </summary>
        /// <param name="id">The role ID to delete</param>
        /// <param name="cancellationToken">Cancellation token for async operation</param>
        /// <returns>ActionResult with operation result</returns>
        [HttpDelete("{id}")]
        [Authorize(Roles = SD.Admin)]
        [ProducesResponseType(200)]
        [ProducesResponseType(400)]
        [ProducesResponseType(401)]
        [ProducesResponseType(403)]
        [ProducesResponseType(499)]
        [ProducesResponseType(500)]
        public async Task<IActionResult> DeleteRole(string id, CancellationToken cancellationToken = default)
        {
            _logger.LogInformation("API: Deleting role with ID: {RoleId}", id);

            if (string.IsNullOrEmpty(id))
            {
                _logger.LogWarning("API: Role ID cannot be null or empty");
                return BadRequest("Role ID is required");
            }

            try
            {
                var success = await _roleService.DeleteRoleAsync(id, cancellationToken);
                if (!success)
                {
                    _logger.LogWarning("API: Failed to delete role with ID: {RoleId}", id);
                    return BadRequest("Failed to delete role. The role may not exist or may have users assigned.");
                }

                _logger.LogInformation("API: Role deleted successfully: {RoleId}", id);
                return Ok("Role deleted successfully");
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("API: Delete role operation was cancelled");
                return StatusCode(499, "Request cancelled");
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "API: Error occurred while deleting role with ID: {RoleId}", id);
                return StatusCode(500, "An error occurred while deleting the role");
            }
        }

        /// <summary>
        /// Deletes multiple roles in bulk
        /// </summary>
        /// <param name="roleIds">List of role IDs to delete</param>
        /// <param name="cancellationToken">Cancellation token for async operation</param>
        /// <returns>ActionResult with operation result</returns>
        [HttpPost("bulk-delete")]
        [Authorize(Roles = SD.Admin)]
        [ProducesResponseType(200)]
        [ProducesResponseType(400)]
        [ProducesResponseType(401)]
        [ProducesResponseType(403)]
        [ProducesResponseType(499)]
        [ProducesResponseType(500)]
        public async Task<IActionResult> BulkDeleteRoles([FromBody] List<string> roleIds, CancellationToken cancellationToken = default)
        {
            _logger.LogInformation("API: Bulk deleting {RoleCount} roles", roleIds?.Count ?? 0);

            if (roleIds == null || !roleIds.Any())
            {
                _logger.LogWarning("API: No role IDs provided for bulk delete");
                return BadRequest("No role IDs provided");
            }

            try
            {
                var success = await _roleService.BulkDeleteRolesAsync(roleIds, cancellationToken);
                if (!success)
                {
                    _logger.LogWarning("API: Failed to delete some roles in bulk operation");
                    return BadRequest("Failed to delete some roles. Some roles may have users assigned or may not exist.");
                }

                _logger.LogInformation("API: Bulk delete completed successfully for {RoleCount} roles", roleIds.Count);
                return Ok("Roles deleted successfully");
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("API: Bulk delete roles operation was cancelled");
                return StatusCode(499, "Request cancelled");
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "API: Error occurred during bulk delete of roles");
                return StatusCode(500, "An error occurred while deleting roles");
            }
        }

        #endregion

        #region Role Statistics

        /// <summary>
        /// Retrieves role statistics
        /// </summary>
        /// <param name="cancellationToken">Cancellation token for async operation</param>
        /// <returns>Role statistics data</returns>
        [HttpGet("statistics")]
        [ProducesResponseType(200)]
        [ProducesResponseType(401)]
        [ProducesResponseType(499)]
        [ProducesResponseType(500)]
        public async Task<IActionResult> GetRolesStatistics(CancellationToken cancellationToken = default)
        {
            _logger.LogInformation("API: Getting role statistics");

            try
            {
                var stats = await _roleService.GetRolesStatisticsAsync(cancellationToken);
                return Ok(new
                {
                    TotalRoles = stats.TotalRoles,
                    ActiveRoles = stats.ActiveRoles,
                    SystemRoles = stats.SystemRoles,
                    LatestRoleDate = stats.LatestRoleDate
                });
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("API: Get role statistics operation was cancelled");
                return StatusCode(499, "Request cancelled");
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "API: Error occurred while getting role statistics");
                return StatusCode(500, "An error occurred while retrieving role statistics");
            }
        }

        #endregion

        #region Role Claims Management

        /// <summary>
        /// Retrieves claims for a specific role
        /// </summary>
        /// <param name="roleId">The role ID</param>
        /// <param name="cancellationToken">Cancellation token for async operation</param>
        /// <returns>RoleClaimsDto object or NotFound</returns>
        [HttpGet("{roleId}/claims")]
        [ProducesResponseType(typeof(RoleClaimsDto), 200)]
        [ProducesResponseType(400)]
        [ProducesResponseType(401)]
        [ProducesResponseType(404)]
        [ProducesResponseType(499)]
        [ProducesResponseType(500)]
        public async Task<ActionResult<RoleClaimsDto>> GetRoleClaims(string roleId, CancellationToken cancellationToken = default)
        {
            _logger.LogInformation("API: Getting claims for role ID: {RoleId}", roleId);

            if (string.IsNullOrEmpty(roleId))
            {
                _logger.LogWarning("API: Role ID cannot be null or empty");
                return BadRequest("Role ID is required");
            }

            try
            {
                var roleClaims = await _roleService.GetRoleClaimsAsync(roleId, cancellationToken);
                if (roleClaims == null)
                {
                    _logger.LogWarning("API: Role with ID {RoleId} not found", roleId);
                    return NotFound();
                }

                return Ok(roleClaims);
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("API: Get role claims operation was cancelled");
                return StatusCode(499, "Request cancelled");
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "API: Error occurred while getting claims for role ID: {RoleId}", roleId);
                return StatusCode(500, "An error occurred while retrieving role claims");
            }
        }

        /// <summary>
        /// Updates claims for a specific role
        /// </summary>
        /// <param name="roleId">The role ID</param>
        /// <param name="request">Update role claims request</param>
        /// <param name="cancellationToken">Cancellation token for async operation</param>
        /// <returns>ActionResult with operation result</returns>
        [HttpPost("{roleId}/claims")]
        [Authorize(Roles = SD.Admin)]
        [ProducesResponseType(200)]
        [ProducesResponseType(400)]
        [ProducesResponseType(401)]
        [ProducesResponseType(403)]
        [ProducesResponseType(499)]
        [ProducesResponseType(500)]
        public async Task<IActionResult> UpdateRoleClaims(
            string roleId,
            [FromBody] UpdateRoleClaimsRequest request,
            CancellationToken cancellationToken = default)
        {
            _logger.LogInformation("API: Updating claims for role ID: {RoleId}", roleId);

            if (string.IsNullOrEmpty(roleId) || request == null || request.Claims == null)
            {
                _logger.LogWarning("API: Role ID or claims data cannot be null");
                return BadRequest("Role ID and claims data are required");
            }

            try
            {
                var success = await _roleService.UpdateRoleClaimsAsync(roleId, request.Claims, cancellationToken);
                if (!success)
                {
                    _logger.LogWarning("API: Failed to update claims for role ID: {RoleId}", roleId);
                    return BadRequest("Failed to update role claims. The role may not exist.");
                }

                _logger.LogInformation("API: Claims updated successfully for role ID: {RoleId}", roleId);
                return Ok("Role claims updated successfully");
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("API: Update role claims operation was cancelled");
                return StatusCode(499, "Request cancelled");
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "API: Error occurred while updating claims for role ID: {RoleId}", roleId);
                return StatusCode(500, "An error occurred while updating role claims");
            }
        }

        #endregion

        #region User Role Management

        /// <summary>
        /// Retrieves users in a specific role
        /// </summary>
        /// <param name="roleName">The role name</param>
        /// <param name="cancellationToken">Cancellation token for async operation</param>
        /// <returns>List of UserRoleDto objects</returns>
        [HttpGet("{roleName}/users")]
        [ProducesResponseType(typeof(List<UserRoleDto>), 200)]
        [ProducesResponseType(400)]
        [ProducesResponseType(401)]
        [ProducesResponseType(499)]
        [ProducesResponseType(500)]
        public async Task<ActionResult<List<UserRoleDto>>> GetUsersInRole(string roleName, CancellationToken cancellationToken = default)
        {
            _logger.LogInformation("API: Getting users in role: {RoleName}", roleName);

            if (string.IsNullOrEmpty(roleName))
            {
                _logger.LogWarning("API: Role name cannot be null or empty");
                return BadRequest("Role name is required");
            }

            try
            {
                var users = await _roleService.GetUsersInRoleAsync(roleName, cancellationToken);
                return Ok(users);
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("API: Get users in role operation was cancelled");
                return StatusCode(499, "Request cancelled");
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "API: Error occurred while getting users in role: {RoleName}", roleName);
                return StatusCode(500, "An error occurred while retrieving users in role");
            }
        }

        #endregion
    }
}
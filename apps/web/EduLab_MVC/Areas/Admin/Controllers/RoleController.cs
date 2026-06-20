using EduLab_MVC.Common;
using EduLab_MVC.Models.DTOs.Roles;
using EduLab_MVC.Resources;
using EduLab_MVC.Services.ServiceInterfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Localization;

namespace EduLab_MVC.Controllers
{
    /// <summary>
    /// MVC Controller for managing application roles
    /// </summary>
    [Area("Admin")]
    [Authorize(Roles = SD.Admin)]
    public class RoleController : Controller
    {
        private readonly IRoleService _roleService;
        private readonly ILogger<RoleController> _logger;
        private readonly IStringLocalizer<SharedResources> _localizer;

        /// <summary>
        /// Initializes a new instance of the RoleController class
        /// </summary>
        public RoleController(IRoleService roleService, ILogger<RoleController> logger, IStringLocalizer<SharedResources> localizer)
        {
            _roleService = roleService;
            _logger = logger;
            _localizer = localizer;
        }

        #region View Actions

        /// <summary>
        /// Displays the roles index page
        /// </summary>
        /// <param name="cancellationToken">Cancellation token for async operation</param>
        /// <returns>View with list of roles</returns>
        public async Task<IActionResult> Index(CancellationToken cancellationToken = default)
        {
            _logger.LogInformation("MVC Controller: Displaying roles index page");

            try
            {
                var roles = await _roleService.GetAllRolesAsync(cancellationToken);
                return View(roles);
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("MVC Controller: Roles index operation was cancelled");
                return RedirectToAction(nameof(Index));
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "MVC Controller: Error occurred while displaying roles index");
                TempData["Error"] = _localizer["RoleListLoadError"].Value;
                return View(new List<RoleDto>());
            }
        }

        /// <summary>
        /// Displays role details
        /// </summary>
        /// <param name="id">The role ID</param>
        /// <param name="cancellationToken">Cancellation token for async operation</param>
        /// <returns>View with role details</returns>
        public async Task<IActionResult> Details(string id, CancellationToken cancellationToken = default)
        {
            _logger.LogInformation("MVC Controller: Displaying details for role ID: {RoleId}", id);

            if (string.IsNullOrEmpty(id))
            {
                _logger.LogWarning("MVC Controller: Role ID cannot be null or empty");
                return NotFound();
            }

            try
            {
                var role = await _roleService.GetRoleByIdAsync(id, cancellationToken);
                if (role == null)
                {
                    _logger.LogWarning("MVC Controller: Role with ID {RoleId} not found", id);
                    return NotFound();
                }

                return View(role);
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("MVC Controller: Role details operation was cancelled");
                return RedirectToAction(nameof(Index));
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "MVC Controller: Error occurred while displaying role details for ID: {RoleId}", id);
                TempData["Error"] = _localizer["RoleDetailsLoadError"].Value;
                return RedirectToAction(nameof(Index));
            }
        }

        #endregion

        #region CRUD Operations

        /// <summary>
        /// Creates a new role
        /// </summary>
        /// <param name="roleName">The role name</param>
        /// <param name="cancellationToken">Cancellation token for async operation</param>
        /// <returns>Redirect to index with result message</returns>
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create(string roleName, CancellationToken cancellationToken = default)
        {
            _logger.LogInformation("MVC Controller: Creating new role: {RoleName}", roleName);

            if (string.IsNullOrWhiteSpace(roleName))
            {
                _logger.LogWarning("MVC Controller: Role name cannot be null or empty");
                TempData["Error"] = _localizer["RoleNameRequired"].Value;
                return RedirectToAction(nameof(Index));
            }

            try
            {
                var success = await _roleService.CreateRoleAsync(roleName, cancellationToken);
                if (!success)
                {
                    _logger.LogWarning("MVC Controller: Failed to create role: {RoleName}", roleName);
                    TempData["Error"] = _localizer["RoleCreateFailed"].Value;
                    return RedirectToAction(nameof(Index));
                }

                _logger.LogInformation("MVC Controller: Role created successfully: {RoleName}", roleName);
                TempData["Success"] = _localizer["RoleCreated"].Value;
                return RedirectToAction(nameof(Index));
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("MVC Controller: Create role operation was cancelled");
                TempData["Error"] = _localizer["RoleCreateCancelled"].Value;
                return RedirectToAction(nameof(Index));
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "MVC Controller: Error occurred while creating role: {RoleName}", roleName);
                TempData["Error"] = _localizer["RoleCreateError"].Value;
                return RedirectToAction(nameof(Index));
            }
        }

        /// <summary>
        /// Updates an existing role
        /// </summary>
        /// <param name="id">The role ID</param>
        /// <param name="roleName">The new role name</param>
        /// <param name="cancellationToken">Cancellation token for async operation</param>
        /// <returns>Redirect to index with result message</returns>
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(string id, string roleName, CancellationToken cancellationToken = default)
        {
            _logger.LogInformation("MVC Controller: Updating role with ID: {RoleId} to name: {NewRoleName}", id, roleName);

            if (string.IsNullOrWhiteSpace(roleName))
            {
                _logger.LogWarning("MVC Controller: Role name cannot be null or empty");
                ModelState.AddModelError("", _localizer["RoleNameRequired"]);
                return RedirectToAction(nameof(Index));
            }

            try
            {
                var success = await _roleService.UpdateRoleAsync(id, roleName, cancellationToken);
                if (!success)
                {
                    _logger.LogWarning("MVC Controller: Failed to update role with ID: {RoleId}", id);
                    TempData["Error"] = _localizer["RoleUpdateFailed"].Value;
                    return RedirectToAction(nameof(Index));
                }

                _logger.LogInformation("MVC Controller: Role updated successfully: {RoleName}", roleName);
                TempData["Success"] = _localizer["RoleUpdated"].Value;
                return RedirectToAction(nameof(Index));
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("MVC Controller: Update role operation was cancelled");
                TempData["Error"] = _localizer["RoleUpdateCancelled"].Value;
                return RedirectToAction(nameof(Index));
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "MVC Controller: Error occurred while updating role with ID: {RoleId}", id);
                TempData["Error"] = _localizer["RoleUpdateError"].Value;
                return RedirectToAction(nameof(Index));
            }
        }

        /// <summary>
        /// Deletes a role
        /// </summary>
        /// <param name="id">The role ID</param>
        /// <param name="cancellationToken">Cancellation token for async operation</param>
        /// <returns>Redirect to index with result message</returns>
        public async Task<IActionResult> Delete(string id, CancellationToken cancellationToken = default)
        {
            _logger.LogInformation("MVC Controller: Deleting role with ID: {RoleId}", id);

            if (string.IsNullOrEmpty(id))
            {
                _logger.LogWarning("MVC Controller: Role ID cannot be null or empty");
                return NotFound();
            }

            try
            {
                var success = await _roleService.DeleteRoleAsync(id, cancellationToken);
                if (!success)
                {
                    _logger.LogWarning("MVC Controller: Failed to delete role with ID: {RoleId}", id);
                    TempData["Error"] = _localizer["RoleDeleteFailedLinked"].Value;
                    return RedirectToAction(nameof(Index));
                }

                _logger.LogInformation("MVC Controller: Role deleted successfully: {RoleId}", id);
                TempData["Success"] = _localizer["RoleDeleted"].Value;
                return RedirectToAction(nameof(Index));
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("MVC Controller: Delete role operation was cancelled");
                TempData["Error"] = _localizer["RoleDeleteCancelled"].Value;
                return RedirectToAction(nameof(Index));
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "MVC Controller: Error occurred while deleting role with ID: {RoleId}", id);
                TempData["Error"] = _localizer["RoleDeleteError"].Value;
                return RedirectToAction(nameof(Index));
            }
        }

        /// <summary>
        /// Deletes multiple roles in bulk
        /// </summary>
        /// <param name="roleIds">Comma-separated role IDs</param>
        /// <param name="cancellationToken">Cancellation token for async operation</param>
        /// <returns>Redirect to index with result message</returns>
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> BulkDelete(string roleIds, CancellationToken cancellationToken = default)
        {
            _logger.LogInformation("MVC Controller: Bulk deleting roles: {RoleIds}", roleIds);

            if (string.IsNullOrEmpty(roleIds))
            {
                _logger.LogWarning("MVC Controller: No role IDs provided for bulk delete");
                TempData["Error"] = _localizer["NoRoleSelected"].Value;
                return RedirectToAction(nameof(Index));
            }

            try
            {
                var idsList = roleIds.Split(',').ToList();
                var success = await _roleService.BulkDeleteRolesAsync(idsList, cancellationToken);

                if (!success)
                {
                    _logger.LogWarning("MVC Controller: Failed to delete some roles in bulk");
                    TempData["Error"] = _localizer["RolesBulkDeleteFailed"].Value;
                    return RedirectToAction(nameof(Index));
                }

                _logger.LogInformation("MVC Controller: Bulk delete completed successfully for {RoleCount} roles", idsList.Count);
                TempData["Success"] = _localizer["RolesBulkDeleted"].Value;
                return RedirectToAction(nameof(Index));
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("MVC Controller: Bulk delete operation was cancelled");
                TempData["Error"] = _localizer["RolesBulkDeleteCancelled"].Value;
                return RedirectToAction(nameof(Index));
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "MVC Controller: Error occurred during bulk delete of roles");
                TempData["Error"] = _localizer["RolesBulkDeleteError"].Value;
                return RedirectToAction(nameof(Index));
            }
        }

        #endregion

        #region Role Claims Management

        /// <summary>
        /// Displays role claims
        /// </summary>
        /// <param name="id">The role ID</param>
        /// <param name="cancellationToken">Cancellation token for async operation</param>
        /// <returns>View with role claims</returns>
        public async Task<IActionResult> Claims(string id, CancellationToken cancellationToken = default)
        {
            _logger.LogInformation("MVC Controller: Displaying claims for role ID: {RoleId}", id);

            if (string.IsNullOrEmpty(id))
            {
                _logger.LogWarning("MVC Controller: Role ID cannot be null or empty");
                return NotFound();
            }

            try
            {
                var roleClaims = await _roleService.GetRoleClaimsAsync(id, cancellationToken);
                if (roleClaims == null)
                {
                    _logger.LogWarning("MVC Controller: Role with ID {RoleId} not found", id);
                    return NotFound();
                }

                return View(roleClaims);
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("MVC Controller: Role claims operation was cancelled");
                return RedirectToAction(nameof(Index));
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "MVC Controller: Error occurred while displaying claims for role ID: {RoleId}", id);
                TempData["Error"] = _localizer["PermissionsLoadError"].Value;
                return RedirectToAction(nameof(Index));
            }
        }

        /// <summary>
        /// Displays role permissions management page
        /// </summary>
        /// <param name="id">The role ID</param>
        /// <param name="cancellationToken">Cancellation token for async operation</param>
        /// <returns>View for managing permissions</returns>
        public async Task<IActionResult> ManagePermissions(string id, CancellationToken cancellationToken = default)
        {
            _logger.LogInformation("MVC Controller: Managing permissions for role ID: {RoleId}", id);

            if (string.IsNullOrEmpty(id))
            {
                _logger.LogWarning("MVC Controller: Role ID cannot be null or empty");
                return NotFound();
            }

            try
            {
                var role = await _roleService.GetRoleByIdAsync(id, cancellationToken);
                if (role == null)
                {
                    _logger.LogWarning("MVC Controller: Role with ID {RoleId} not found", id);
                    return NotFound();
                }

                ViewBag.RoleId = id;
                ViewBag.RoleName = role.Name;

                return View();
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("MVC Controller: Manage permissions operation was cancelled");
                return RedirectToAction(nameof(Index));
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "MVC Controller: Error occurred while managing permissions for role ID: {RoleId}", id);
                TempData["Error"] = _localizer["PermissionsPageLoadError"].Value;
                return RedirectToAction(nameof(Index));
            }
        }

        /// <summary>
        /// Updates role claims via AJAX
        /// </summary>
        /// <param name="model">Update role claims model</param>
        /// <param name="cancellationToken">Cancellation token for async operation</param>
        /// <returns>JSON result with operation status</returns>
        [HttpPost]
        public async Task<IActionResult> UpdateClaims([FromBody] ClaimsModel model, CancellationToken cancellationToken = default)
        {
            _logger.LogInformation("MVC Controller: Updating claims for role ID: {RoleId}", model?.RoleId);

            if (!ModelState.IsValid)
            {
                return BadRequest(new { errors = new[] { _localizer["InvalidData"] } });
            }

            try
            {
                var success = await _roleService.UpdateRoleClaimsCategorizedAsync(model.RoleId, model, cancellationToken);
                if (!success)
                {
                    _logger.LogWarning("MVC Controller: Failed to update claims for role ID: {RoleId}", model.RoleId);
                    return BadRequest(new
                    {
                        errors = new[] { _localizer["PermissionsUpdateFailed"] }
                    });
                }
                TempData["Success"] = _localizer["PermissionsUpdated"].Value;
                _logger.LogInformation("MVC Controller: Claims updated successfully for role ID: {RoleId}", model.RoleId);
                return Ok(new { success = true });
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("MVC Controller: Update claims operation was cancelled");
                return StatusCode(499, new { errors = new[] { _localizer["PermissionsUpdateCancelled"] } });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "MVC Controller: Error occurred while updating claims for role ID: {RoleId}", model.RoleId);
                return StatusCode(500, new { errors = new[] { _localizer["PermissionsUpdateError"] } });
            }
        }

        /// <summary>
        /// Retrieves role claims as JSON for AJAX requests
        /// </summary>
        /// <param name="id">The role ID</param>
        /// <param name="cancellationToken">Cancellation token for async operation</param>
        /// <returns>JSON with role claims data</returns>
        [HttpGet]
        public async Task<IActionResult> GetClaimsJson(string id, CancellationToken cancellationToken = default)
        {
            _logger.LogInformation("MVC Controller: Getting claims JSON for role ID: {RoleId}", id);

            if (string.IsNullOrEmpty(id))
            {
                _logger.LogWarning("MVC Controller: Role ID cannot be null or empty");
                return BadRequest();
            }

            try
            {
                var roleClaims = await _roleService.GetClaimsForRoleAsync(id, cancellationToken);
                if (roleClaims == null)
                {
                    _logger.LogWarning("MVC Controller: Role with ID {RoleId} not found", id);
                    return NotFound();
                }

                return Json(roleClaims);
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("MVC Controller: Get claims JSON operation was cancelled");
                return StatusCode(499);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "MVC Controller: Error occurred while getting claims JSON for role ID: {RoleId}", id);
                return StatusCode(500);
            }
        }

        #endregion

        #region User Role Management

        /// <summary>
        /// Displays users in a specific role
        /// </summary>
        /// <param name="roleName">The role name</param>
        /// <param name="cancellationToken">Cancellation token for async operation</param>
        /// <returns>View with users in role</returns>
        public async Task<IActionResult> UsersInRole(string roleName, CancellationToken cancellationToken = default)
        {
            _logger.LogInformation("MVC Controller: Displaying users in role: {RoleName}", roleName);

            if (string.IsNullOrEmpty(roleName))
            {
                _logger.LogWarning("MVC Controller: Role name cannot be null or empty");
                return NotFound();
            }

            try
            {
                var users = await _roleService.GetUsersInRoleAsync(roleName, cancellationToken);
                return View(users);
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("MVC Controller: Users in role operation was cancelled");
                return RedirectToAction(nameof(Index));
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "MVC Controller: Error occurred while displaying users in role: {RoleName}", roleName);
                TempData["Error"] = _localizer["UsersInRoleLoadError"].Value;
                return RedirectToAction(nameof(Index));
            }
        }

        #endregion
    }
}
using EduLab_Application.ServiceInterfaces;
using EduLab_Domain;
using EduLab_Domain.Entities;
using Microsoft.AspNetCore.Identity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Claims;
using System.Threading;
using System.Threading.Tasks;

namespace EduLab_Application.Services
{
    /// <summary>
    /// Service implementation for managing role claims
    /// </summary>
    public class RoleClaimsService : IRoleClaimsService
    {
        private readonly RoleManager<ApplicationRole> _roleManager;

        public RoleClaimsService(RoleManager<ApplicationRole> roleManager)
        {
            _roleManager = roleManager ?? throw new ArgumentNullException(nameof(roleManager));
        }

        /// <summary>
        /// Retrieves the claims configuration of a role
        /// </summary>
        /// <param name="roleId">Unique identifier of the role</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>The claims model or null if the role does not exist</returns>
        public async Task<ClaimsModel?> GetClaimsForRoleAsync(
            string roleId,
            CancellationToken cancellationToken = default)
        {
            if (string.IsNullOrEmpty(roleId))
                throw new ArgumentException("معرف الدور مطلوب", nameof(roleId));

            cancellationToken.ThrowIfCancellationRequested();

            var role = await _roleManager.FindByIdAsync(roleId.ToString());
            if (role == null) return null;

            var existingClaims = await _roleManager.GetClaimsAsync(role);

            return new ClaimsModel
            {
                RoleId = role.Id,

                // ================= Dashboard =================
                DashboardClaimList =
                    BuildClaimSelection(ClaimStore.DashboardClaims, existingClaims),

                // ================= Categories =================
                CategoryClaimList =
                    BuildClaimSelection(ClaimStore.CategoryClaims, existingClaims),

                // ================= Courses =================
                CourseClaimList =
                    BuildClaimSelection(ClaimStore.CourseClaims, existingClaims),

                // ================= Instructors =================
                InstructorClaimList =
                    BuildClaimSelection(ClaimStore.InstructorClaims, existingClaims),

                // ================= Users =================
                UserClaimList =
                    BuildClaimSelection(ClaimStore.UserClaims, existingClaims),

                // ================= Roles =================
                RoleClaimList =
                    BuildClaimSelection(ClaimStore.RoleClaims, existingClaims),

                // ================= History =================
                HistoryClaimList =
                    BuildClaimSelection(ClaimStore.HistoryClaims, existingClaims),

                // ================= Refunds =================
                RefundClaimList =
                    BuildClaimSelection(ClaimStore.RefundClaims, existingClaims),

                // ================= Notifications =================
                NotificationClaimList =
                    BuildClaimSelection(ClaimStore.NotificationClaims, existingClaims),

                // ================= Students =================
                StudentClaimList =
                    BuildClaimSelection(ClaimStore.StudentClaims, existingClaims),

                // ================= Site Settings =================
                SiteSettingClaimList =
                    BuildClaimSelection(ClaimStore.SiteSettingsClaims, existingClaims),

                // ================= Reports =================
                ReportClaimList =
                    BuildClaimSelection(ClaimStore.ReportClaims, existingClaims),

                // ================= Support =================
                SupportClaimList =
                    BuildClaimSelection(ClaimStore.SupportClaims, existingClaims),
            };
        }

        /// <summary>
        /// Replaces the claims of a role with the provided configuration
        /// </summary>
        /// <param name="roleId">Unique identifier of the role</param>
        /// <param name="model">The new claims configuration</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>True if the claims were updated, otherwise false</returns>
        public async Task<bool> UpdateRoleClaimsAsync(
            string roleId,
            ClaimsModel model,
            CancellationToken cancellationToken = default)
        {
            if (string.IsNullOrEmpty(roleId))
                throw new ArgumentException("معرف الدور مطلوب", nameof(roleId));

            if (model == null)
                throw new ArgumentNullException(nameof(model), "لا يمكن تحديث صلاحيات بدون بيانات.");

            cancellationToken.ThrowIfCancellationRequested();

            var role = await _roleManager.FindByIdAsync(roleId.ToString());
            if (role == null) return false;

            // Remove all the old claims
            var oldClaims = await _roleManager.GetClaimsAsync(role);
            foreach (var claim in oldClaims)
            {
                cancellationToken.ThrowIfCancellationRequested();
                await _roleManager.RemoveClaimAsync(role, claim);
            }

            // All the claim groups
            var allClaimGroups = new[]
            {
                model.DashboardClaimList,
                model.CategoryClaimList,
                model.CourseClaimList,
                model.InstructorClaimList,
                model.UserClaimList,
                model.RoleClaimList,
                model.HistoryClaimList,
                model.PaymentClaimList,
                model.RefundClaimList,
                model.NotificationClaimList,
                model.StudentClaimList,
                model.SiteSettingClaimList,
                model.ReportClaimList,
                model.SupportClaimList
            };

            foreach (var claimGroup in allClaimGroups)
            {
                if (claimGroup == null) continue;

                foreach (var claim in claimGroup)
                {
                    cancellationToken.ThrowIfCancellationRequested();

                    if (claim.IsSelected)
                    {
                        var result = await _roleManager.AddClaimAsync(
                            role,
                            new Claim(claim.ClaimType, "true")
                        );

                        if (!result.Succeeded)
                        {
                            var errors = string.Join(", ",
                                result.Errors.Select(e => e.Description));
                        }
                    }
                }
            }

            return true;
        }

        private List<ClaimSelection> BuildClaimSelection(
            List<Claim> availableClaims,
            IList<Claim> existingClaims)
        {
            if (availableClaims == null || existingClaims == null)
                return new List<ClaimSelection>();

            return availableClaims.Select(c => new ClaimSelection
            {
                ClaimType = c.Type,
                Label = c.Value,
                IsSelected = existingClaims.Any(ec => ec.Type == c.Type)
            }).ToList();
        }
    }
}
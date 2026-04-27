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
    public class RoleClaimsService : IRoleClaimsService
    {
        private readonly RoleManager<ApplicationRole> _roleManager;

        public RoleClaimsService(RoleManager<ApplicationRole> roleManager)
        {
            _roleManager = roleManager ?? throw new ArgumentNullException(nameof(roleManager));
        }

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

                // ================= Notifications =================
                NotificationClaimList =
                    BuildClaimSelection(ClaimStore.NotificationClaims, existingClaims),

                // ================= Students =================
                StudentClaimList =
                    BuildClaimSelection(ClaimStore.StudentClaims, existingClaims),
            };
        }

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

            // حذف كل الـ Claims القديمة
            var oldClaims = await _roleManager.GetClaimsAsync(role);
            foreach (var claim in oldClaims)
            {
                cancellationToken.ThrowIfCancellationRequested();
                await _roleManager.RemoveClaimAsync(role, claim);
            }

            // كل الجروبات
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
                model.NotificationClaimList,
                model.StudentClaimList
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
using EduLab_Domain.Entities;
using EduLab_Application.DTOs.Notification;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_Application.ServiceInterfaces
{
    public interface IEmailTemplateService
    {
        string GenerateLoginEmail(ApplicationUser user, string ipAddress, string deviceName, DateTime requestTime, string passwordResetLink, string language = "en");
        string GenerateVerificationEmail(string code, string language = "en");
        string GeneratePasswordChangeEmail(ApplicationUser user, string ipAddress, string deviceName, DateTime changeTime, string passwordResetLink, string language = "en");
        string GenerateEmailEnable2FA(ApplicationUser user, string code, string Enable2FALink, string language = "en");
        string GenerateInstructorApprovalEmail(ApplicationUser user, string language = "en");
        string GeneratePasswordResetEmail(string resetCode, string language = "en");
        string GeneratePasswordResetConfirmationEmail(string language = "en");
        string GenerateInstructorRejectionEmail(ApplicationUser user, string rejectionReason = "", string language = "en");
        string GenerateCourseApprovalEmail(ApplicationUser instructor, string courseName, string courseLink, string language = "en");
        string GenerateInstructorNotificationEmail(ApplicationUser student, InstructorNotificationRequestDto request, ApplicationUser instructor, string language = "en");
        string GenerateCourseRejectionEmail(ApplicationUser instructor, string courseName, string rejectionReason = "", string language = "en");
        string GeneratePaymentSuccessEmail(ApplicationUser user, List<Course> purchasedCourses,
    decimal totalAmount, string paymentMethod, DateTime paymentTime, string transactionId, string language = "en");
        string GenerateAdminNotificationEmail(ApplicationUser user, AdminNotificationRequestDto request, string language = "en");
        string GenerateAccountLockoutEmail(ApplicationUser user, DateTimeOffset? lockoutEnd, string language = "en");
        string GenerateAccountUnlockEmail(ApplicationUser user, string language = "en");
        string GenerateRefundConfirmationEmail(ApplicationUser user, Course course, decimal refundedAmount, DateTime refundTime, string refundId, string language = "en");
        string GenerateRefundRejectionEmail(ApplicationUser user, Course course, string rejectionReason, string language = "en");
        string GenerateCertificateEmail(ApplicationUser user, string courseTitle, string certificateCode, string verifyLink, string language = "en");

        string GetLocalizedText(string key, string language = "en");
        string GetFormattedText(string key, string language, params object[] args);
    }
}

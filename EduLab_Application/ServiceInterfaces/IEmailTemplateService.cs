using EduLab_Domain.Entities;
using EduLab_Shared.DTOs.Notification;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_Application.ServiceInterfaces
{
    public interface IEmailTemplateService
    {
        string GenerateLoginEmail(ApplicationUser user, string ipAddress, string deviceName, DateTime requestTime, string passwordResetLink);
        string GenerateVerificationEmail( string code);
        string GeneratePasswordChangeEmail(ApplicationUser user, string ipAddress, string deviceName, DateTime changeTime, string passwordResetLink);
        string GenerateEmailEnable2FA(ApplicationUser user, string code, string Enable2FALink);
        string GenerateInstructorApprovalEmail(ApplicationUser user);
        string GeneratePasswordResetEmail(string resetCode);
        string GeneratePasswordResetConfirmationEmail();
        string GenerateInstructorRejectionEmail(ApplicationUser user, string rejectionReason = "");
        string GenerateCourseApprovalEmail(ApplicationUser instructor, string courseName, string courseLink);
        string GenerateInstructorNotificationEmail(ApplicationUser student, InstructorNotificationRequestDto request, ApplicationUser instructor);
        string GenerateCourseRejectionEmail(ApplicationUser instructor, string courseName, string rejectionReason = "");
        string GeneratePaymentSuccessEmail(ApplicationUser user, List<Course> purchasedCourses,
    decimal totalAmount, string paymentMethod, DateTime paymentTime, string transactionId);
        string GenerateAdminNotificationEmail(ApplicationUser user, AdminNotificationRequestDto request);
    }
}

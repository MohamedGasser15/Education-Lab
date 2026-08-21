using EduLab_Domain.Entities;
using EduLab_Application.DTOs.Notification;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_Application.ServiceInterfaces
{
    /// <summary>
    /// Service interface for generating localized email templates
    /// </summary>
    public interface IEmailTemplateService
    {
        /// <summary>
        /// Generates the email template for a new login to the account
        /// </summary>
        /// <param name="user">The user who logged in</param>
        /// <param name="ipAddress">IP address of the login</param>
        /// <param name="deviceName">Device used for the login</param>
        /// <param name="requestTime">Time of the login request</param>
        /// <param name="passwordResetLink">Link to reset the password if needed</param>
        /// <param name="language">Language code for the template</param>
        /// <returns>The generated HTML email content</returns>
        string GenerateLoginEmail(ApplicationUser user, string ipAddress, string deviceName, DateTime requestTime, string passwordResetLink, string language = "en");

        /// <summary>
        /// Generates the email template for email verification
        /// </summary>
        /// <param name="code">Verification code</param>
        /// <param name="language">Language code for the template</param>
        /// <returns>The generated HTML email content</returns>
        string GenerateVerificationEmail(string code, string language = "en");

        /// <summary>
        /// Generates the email template for a password change notification
        /// </summary>
        /// <param name="user">The user whose password changed</param>
        /// <param name="ipAddress">IP address of the change</param>
        /// <param name="deviceName">Device used for the change</param>
        /// <param name="changeTime">Time of the change</param>
        /// <param name="passwordResetLink">Link to reset the password if needed</param>
        /// <param name="language">Language code for the template</param>
        /// <returns>The generated HTML email content</returns>
        string GeneratePasswordChangeEmail(ApplicationUser user, string ipAddress, string deviceName, DateTime changeTime, string passwordResetLink, string language = "en");

        /// <summary>
        /// Generates the email template for enabling two-factor authentication
        /// </summary>
        /// <param name="user">The user enabling 2FA</param>
        /// <param name="code">Two-factor setup code</param>
        /// <param name="Enable2FALink">Link to complete the 2FA setup</param>
        /// <param name="language">Language code for the template</param>
        /// <returns>The generated HTML email content</returns>
        string GenerateEmailEnable2FA(ApplicationUser user, string code, string Enable2FALink, string language = "en");

        /// <summary>
        /// Generates the email template for instructor approval
        /// </summary>
        /// <param name="user">The approved instructor</param>
        /// <param name="language">Language code for the template</param>
        /// <returns>The generated HTML email content</returns>
        string GenerateInstructorApprovalEmail(ApplicationUser user, string language = "en");

        /// <summary>
        /// Generates the email template for a password reset request
        /// </summary>
        /// <param name="resetCode">Password reset code</param>
        /// <param name="language">Language code for the template</param>
        /// <returns>The generated HTML email content</returns>
        string GeneratePasswordResetEmail(string resetCode, string language = "en");

        /// <summary>
        /// Generates the email template confirming a password reset
        /// </summary>
        /// <param name="language">Language code for the template</param>
        /// <returns>The generated HTML email content</returns>
        string GeneratePasswordResetConfirmationEmail(string language = "en");

        /// <summary>
        /// Generates the email template for instructor rejection
        /// </summary>
        /// <param name="user">The rejected instructor</param>
        /// <param name="rejectionReason">Reason for the rejection</param>
        /// <param name="language">Language code for the template</param>
        /// <returns>The generated HTML email content</returns>
        string GenerateInstructorRejectionEmail(ApplicationUser user, string rejectionReason = "", string language = "en");

        /// <summary>
        /// Generates the email template for course approval
        /// </summary>
        /// <param name="instructor">The course instructor</param>
        /// <param name="courseName">Name of the approved course</param>
        /// <param name="courseLink">Link to the approved course</param>
        /// <param name="language">Language code for the template</param>
        /// <returns>The generated HTML email content</returns>
        string GenerateCourseApprovalEmail(ApplicationUser instructor, string courseName, string courseLink, string language = "en");

        /// <summary>
        /// Generates the email template for a notification sent to students by an instructor
        /// </summary>
        /// <param name="student">The recipient student</param>
        /// <param name="request">The notification request details</param>
        /// <param name="instructor">The instructor who sent the notification</param>
        /// <param name="language">Language code for the template</param>
        /// <returns>The generated HTML email content</returns>
        string GenerateInstructorNotificationEmail(ApplicationUser student, InstructorNotificationRequestDto request, ApplicationUser instructor, string language = "en");

        /// <summary>
        /// Generates the email template for course rejection
        /// </summary>
        /// <param name="instructor">The course instructor</param>
        /// <param name="courseName">Name of the rejected course</param>
        /// <param name="rejectionReason">Reason for the rejection</param>
        /// <param name="language">Language code for the template</param>
        /// <returns>The generated HTML email content</returns>
        string GenerateCourseRejectionEmail(ApplicationUser instructor, string courseName, string rejectionReason = "", string language = "en");

        /// <summary>
        /// Generates the email template for a successful payment
        /// </summary>
        /// <param name="user">The purchasing user</param>
        /// <param name="purchasedCourses">List of purchased courses</param>
        /// <param name="totalAmount">Total paid amount</param>
        /// <param name="paymentMethod">Payment method used</param>
        /// <param name="paymentTime">Time of the payment</param>
        /// <param name="transactionId">Payment transaction identifier</param>
        /// <param name="language">Language code for the template</param>
        /// <returns>The generated HTML email content</returns>
        string GeneratePaymentSuccessEmail(ApplicationUser user, List<Course> purchasedCourses,
    decimal totalAmount, string paymentMethod, DateTime paymentTime, string transactionId, string language = "en");

        /// <summary>
        /// Generates the email template for an admin notification
        /// </summary>
        /// <param name="user">The recipient user</param>
        /// <param name="request">The admin notification request details</param>
        /// <param name="language">Language code for the template</param>
        /// <returns>The generated HTML email content</returns>
        string GenerateAdminNotificationEmail(ApplicationUser user, AdminNotificationRequestDto request, string language = "en");

        /// <summary>
        /// Generates the email template for an account lockout
        /// </summary>
        /// <param name="user">The locked user</param>
        /// <param name="lockoutEnd">End date of the lockout</param>
        /// <param name="language">Language code for the template</param>
        /// <returns>The generated HTML email content</returns>
        string GenerateAccountLockoutEmail(ApplicationUser user, DateTimeOffset? lockoutEnd, string language = "en");

        /// <summary>
        /// Generates the email template for an account unlock
        /// </summary>
        /// <param name="user">The unlocked user</param>
        /// <param name="language">Language code for the template</param>
        /// <returns>The generated HTML email content</returns>
        string GenerateAccountUnlockEmail(ApplicationUser user, string language = "en");

        /// <summary>
        /// Generates the email template confirming a refund
        /// </summary>
        /// <param name="user">The refunded user</param>
        /// <param name="course">The refunded course</param>
        /// <param name="refundedAmount">Amount refunded</param>
        /// <param name="refundTime">Time of the refund</param>
        /// <param name="refundId">Refund identifier</param>
        /// <param name="language">Language code for the template</param>
        /// <returns>The generated HTML email content</returns>
        string GenerateRefundConfirmationEmail(ApplicationUser user, Course course, decimal refundedAmount, DateTime refundTime, string refundId, string language = "en");

        /// <summary>
        /// Generates the email template for a rejected refund
        /// </summary>
        /// <param name="user">The refund requester</param>
        /// <param name="course">The course related to the refund</param>
        /// <param name="rejectionReason">Reason for the rejection</param>
        /// <param name="language">Language code for the template</param>
        /// <returns>The generated HTML email content</returns>
        string GenerateRefundRejectionEmail(ApplicationUser user, Course course, string rejectionReason, string language = "en");

        /// <summary>
        /// Generates the email template for certificate issuance
        /// </summary>
        /// <param name="user">The certificate recipient</param>
        /// <param name="courseTitle">Title of the completed course</param>
        /// <param name="certificateCode">Certificate verification code</param>
        /// <param name="verifyLink">Link to verify the certificate</param>
        /// <param name="language">Language code for the template</param>
        /// <returns>The generated HTML email content</returns>
        string GenerateCertificateEmail(ApplicationUser user, string courseTitle, string certificateCode, string verifyLink, string language = "en");

        /// <summary>
        /// Generates the email template for a report warning
        /// </summary>
        /// <param name="user">The warned user</param>
        /// <param name="reasonLabel">Label of the warning reason</param>
        /// <param name="targetSummary">Summary of the reported target</param>
        /// <param name="language">Language code for the template</param>
        /// <returns>The generated HTML email content</returns>
        string GenerateReportWarningEmail(ApplicationUser user, string reasonLabel, string targetSummary, string language = "en");

        /// <summary>
        /// Gets a localized text by its resource key
        /// </summary>
        /// <param name="key">Resource key of the text</param>
        /// <param name="language">Language code</param>
        /// <returns>The localized text</returns>
        string GetLocalizedText(string key, string language = "en");

        /// <summary>
        /// Gets a formatted localized text by its resource key
        /// </summary>
        /// <param name="key">Resource key of the text</param>
        /// <param name="language">Language code</param>
        /// <param name="args">Format arguments</param>
        /// <returns>The formatted localized text</returns>
        string GetFormattedText(string key, string language, params object[] args);
    }
}
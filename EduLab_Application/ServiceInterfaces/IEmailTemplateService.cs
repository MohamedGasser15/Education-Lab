using EduLab_Domain.Entities;
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
        string GenerateInstructorRejectionEmail(ApplicationUser user, string rejectionReason = "");
    }
}

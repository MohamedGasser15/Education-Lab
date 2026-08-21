using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_Application.ServiceInterfaces
{
    /// <summary>
    /// Service interface for building application links
    /// </summary>
    public interface ILinkBuilderService
    {
        /// <summary>
        /// Generates the password reset link for a user
        /// </summary>
        /// <param name="userId">Unique identifier of the user</param>
        /// <returns>The password reset link</returns>
        string GenerateResetPasswordLink(string userId);

        /// <summary>
        /// Generates the certificate verification link for a certificate code
        /// </summary>
        /// <param name="code">Verification code of the certificate</param>
        /// <returns>The certificate verification link</returns>
        string GenerateCertificateVerifyLink(string code);
    }
}
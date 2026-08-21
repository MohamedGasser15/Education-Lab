using EduLab_Application.ServiceInterfaces;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Routing;


namespace EduLab_Application.Services
{
    /// <summary>
    /// Service implementation for building application links
    /// </summary>
    public class LinkBuilderService : ILinkBuilderService
    {
        private readonly LinkGenerator _linkGenerator;
        private readonly IHttpContextAccessor _httpContextAccessor;

        public LinkBuilderService(LinkGenerator linkGenerator, IHttpContextAccessor httpContextAccessor)
        {
            _linkGenerator = linkGenerator;
            _httpContextAccessor = httpContextAccessor;
        }

        /// <summary>
        /// Generates the password reset link for a user
        /// </summary>
        /// <param name="userId">Unique identifier of the user</param>
        /// <returns>The password reset link</returns>
        public string GenerateResetPasswordLink(string userId)
        {
            return "https://edulab.runasp.net/Learner/Auth/ForgotPassword";
        }

        /// <summary>
        /// Generates the certificate verification link for a certificate code
        /// </summary>
        /// <param name="code">Verification code of the certificate</param>
        /// <returns>The certificate verification link</returns>
        public string GenerateCertificateVerifyLink(string code)
        {
            return $"https://edulab.runasp.net/Learner/Certificates/Verify/{code}";
        }
    }
}

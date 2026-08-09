using EduLab_Application.ServiceInterfaces;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Routing;


namespace EduLab_Application.Services
{
    public class LinkBuilderService : ILinkBuilderService
    {
        private readonly LinkGenerator _linkGenerator;
        private readonly IHttpContextAccessor _httpContextAccessor;

        public LinkBuilderService(LinkGenerator linkGenerator, IHttpContextAccessor httpContextAccessor)
        {
            _linkGenerator = linkGenerator;
            _httpContextAccessor = httpContextAccessor;
        }

        public string GenerateResetPasswordLink(string userId)
        {
            return "https://edulab.runasp.net/Learner/Auth/ForgotPassword";
        }

        public string GenerateCertificateVerifyLink(string code)
        {
            return $"https://edulab.runasp.net/Learner/Certificates/Verify/{code}";
        }
    }
}

using EduLab_MVC.Models.ViewModels;
using EduLab_MVC.Services.ServiceInterfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json;
using System;
using System.Threading;
using System.Threading.Tasks;

namespace EduLab_MVC.Areas.Learner.Controllers
{
    [Area("Learner")]
    public class CertificatesController : Controller
    {
        private readonly IAuthorizedHttpClientService _httpClientService;
        private readonly ILogger<CertificatesController> _logger;

        public CertificatesController(
            IAuthorizedHttpClientService httpClientService,
            ILogger<CertificatesController> logger)
        {
            _httpClientService = httpClientService;
            _logger = logger;
        }

        /// <summary>
        /// Public certificate verification page
        /// </summary>
        [HttpGet]
        [AllowAnonymous]
        public async Task<IActionResult> Verify(string id, CancellationToken cancellationToken = default)
        {
            var code = id;

            if (string.IsNullOrWhiteSpace(code))
            {
                return View(new CertificateVerifyViewModel { IsFound = false });
            }

            try
            {
                _logger.LogInformation("Verifying certificate {Code}", code);

                var client = _httpClientService.CreateClient();
                var response = await client.GetAsync($"certificates/verify/{Uri.EscapeDataString(code)}", cancellationToken);

                if (!response.IsSuccessStatusCode)
                {
                    return View(new CertificateVerifyViewModel { IsFound = false, Code = code });
                }

                var content = await response.Content.ReadAsStringAsync(cancellationToken);
                var data = JsonConvert.DeserializeObject<CertificateVerifyViewModel>(content);

                if (data == null || string.IsNullOrEmpty(data.StudentName))
                {
                    return View(new CertificateVerifyViewModel { IsFound = false, Code = code });
                }

                data.IsFound = true;
                data.Code = code;
                return View(data);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error verifying certificate {Code}", code);
                return View(new CertificateVerifyViewModel { IsFound = false, Code = code });
            }
        }
    }
}

using EduLab_Application.DTOs.Legal;
using EduLab_Application.Resources;
using EduLab_Application.ServiceInterfaces;
using Microsoft.Extensions.Localization;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Threading;
using System.Threading.Tasks;

namespace EduLab_Application.Services
{
    /// <summary>
    /// Service implementation for delivering localized platform information, privacy policy, and terms of service from SharedResources .resx files
    /// </summary>
    public class LegalService : ILegalService
    {
        private readonly IStringLocalizer<SharedResources> _localizer;
        private readonly ILogger<LegalService> _logger;

        private const string AppVersion = "1.0.0";
        private const string ContactEmail = "support@edulab.com";
        private const string WebsiteUrl = "https://edulabapi.runasp.net";

        private static readonly HashSet<string> SupportedLanguages = new(StringComparer.OrdinalIgnoreCase)
        {
            "ar", "en", "de", "es", "fr", "hi", "id", "it", "ja", "ko",
            "ms", "nl", "pl", "pt", "ru", "tr", "uk", "ur", "vi", "zh"
        };

        public LegalService(IStringLocalizer<SharedResources> localizer, ILogger<LegalService> logger)
        {
            _localizer = localizer ?? throw new ArgumentNullException(nameof(localizer));
            _logger = logger ?? throw new ArgumentNullException(nameof(logger));
        }

        public Task<LegalContentDto> GetAboutInfoAsync(string? language = null, CancellationToken cancellationToken = default)
        {
            var lang = NormalizeLanguage(language);
            SetCulture(lang);

            var dto = new LegalContentDto
            {
                Type = "about",
                Title = GetString("Legal_About_Title", "About EduLab"),
                Subtitle = GetString("Legal_About_Subtitle", "The premier learning platform for practical skill development and interactive education"),
                LastUpdated = GetString("Legal_About_LastUpdated", "September 2026"),
                AppVersion = AppVersion,
                ContactEmail = ContactEmail,
                WebsiteUrl = WebsiteUrl,
                Sections = new List<LegalSectionDto>
                {
                    new()
                    {
                        Title = GetString("Legal_About_Sec1_Title", "Who We Are"),
                        Content = GetString("Legal_About_Sec1_Content", "EduLab is a modern learning ecosystem designed to empower students, creators, and professionals worldwide with cutting-edge skills through engaging and practical courses."),
                        Icon = "info",
                        BulletPoints = BuildBulletList("Legal_About_Sec1_Bullet1", "Legal_About_Sec1_Bullet2", "Legal_About_Sec1_Bullet3")
                    },
                    new()
                    {
                        Title = GetString("Legal_About_Sec2_Title", "Our Vision & Mission"),
                        Content = GetString("Legal_About_Sec2_Content", "We believe quality education transforms careers and lives. We are dedicated to delivering smart, personalized, and certified learning experiences."),
                        Icon = "rocket",
                        BulletPoints = BuildBulletList("Legal_About_Sec2_Bullet1", "Legal_About_Sec2_Bullet2", "Legal_About_Sec2_Bullet3")
                    },
                    new()
                    {
                        Title = GetString("Legal_About_Sec3_Title", "Why Choose EduLab?"),
                        Content = GetString("Legal_About_Sec3_Content", "EduLab provides an all-in-one learning environment featuring:"),
                        Icon = "star",
                        BulletPoints = BuildBulletList("Legal_About_Sec3_Bullet1", "Legal_About_Sec3_Bullet2", "Legal_About_Sec3_Bullet3")
                    }
                }
            };

            return Task.FromResult(dto);
        }

        public Task<LegalContentDto> GetPrivacyPolicyAsync(string? language = null, CancellationToken cancellationToken = default)
        {
            var lang = NormalizeLanguage(language);
            SetCulture(lang);

            var dto = new LegalContentDto
            {
                Type = "privacy",
                Title = GetString("Legal_Privacy_Title", "Privacy Policy"),
                Subtitle = GetString("Legal_Privacy_Subtitle", "Committed to safeguarding your personal data with top-tier security standards"),
                LastUpdated = GetString("Legal_Privacy_LastUpdated", "September 2026"),
                AppVersion = AppVersion,
                ContactEmail = ContactEmail,
                WebsiteUrl = WebsiteUrl,
                Sections = new List<LegalSectionDto>
                {
                    new()
                    {
                        Title = GetString("Legal_Privacy_Sec1_Title", "Introduction & Commitment"),
                        Content = GetString("Legal_Privacy_Sec1_Content", "At EduLab, your privacy and data security are foundational priorities. This policy explains what information we collect and how we safeguard it."),
                        Icon = "shield"
                    },
                    new()
                    {
                        Title = GetString("Legal_Privacy_Sec2_Title", "Data We Collect"),
                        Content = GetString("Legal_Privacy_Sec2_Content", "We collect only essential data needed to provide a seamless learning experience:"),
                        Icon = "database",
                        BulletPoints = BuildBulletList("Legal_Privacy_Sec2_Bullet1", "Legal_Privacy_Sec2_Bullet2", "Legal_Privacy_Sec2_Bullet3")
                    },
                    new()
                    {
                        Title = GetString("Legal_Privacy_Sec3_Title", "Data Security & Encryption"),
                        Content = GetString("Legal_Privacy_Sec3_Content", "All data transmissions are protected using TLS/SSL encryption. Passwords and sensitive data are securely encrypted at rest."),
                        Icon = "lock"
                    }
                }
            };

            return Task.FromResult(dto);
        }

        public Task<LegalContentDto> GetTermsOfServiceAsync(string? language = null, CancellationToken cancellationToken = default)
        {
            var lang = NormalizeLanguage(language);
            SetCulture(lang);

            var dto = new LegalContentDto
            {
                Type = "terms",
                Title = GetString("Legal_Terms_Title", "Terms of Service"),
                Subtitle = GetString("Legal_Terms_Subtitle", "Terms and conditions governing the use of EduLab platform and educational services"),
                LastUpdated = GetString("Legal_Terms_LastUpdated", "September 2026"),
                AppVersion = AppVersion,
                ContactEmail = ContactEmail,
                WebsiteUrl = WebsiteUrl,
                Sections = new List<LegalSectionDto>
                {
                    new()
                    {
                        Title = GetString("Legal_Terms_Sec1_Title", "Acceptance of Terms"),
                        Content = GetString("Legal_Terms_Sec1_Content", "By accessing or using EduLab apps and services, you agree to comply with and be bound by these Terms of Service."),
                        Icon = "document"
                    },
                    new()
                    {
                        Title = GetString("Legal_Terms_Sec2_Title", "User Account & Security"),
                        Content = GetString("Legal_Terms_Sec2_Content", "You are responsible for maintaining the confidentiality of your credentials. Sharing accounts or redistributing course materials is prohibited."),
                        Icon = "user",
                        BulletPoints = BuildBulletList("Legal_Terms_Sec2_Bullet1", "Legal_Terms_Sec2_Bullet2")
                    },
                    new()
                    {
                        Title = GetString("Legal_Terms_Sec3_Title", "Intellectual Property"),
                        Content = GetString("Legal_Terms_Sec3_Content", "All course content, videos, assessments, and trademarks are protected by copyright and intellectual property laws."),
                        Icon = "copyright"
                    }
                }
            };

            return Task.FromResult(dto);
        }

        public async Task<Dictionary<string, LegalContentDto>> GetAllLegalInfoAsync(string? language = null, CancellationToken cancellationToken = default)
        {
            var about = await GetAboutInfoAsync(language, cancellationToken);
            var privacy = await GetPrivacyPolicyAsync(language, cancellationToken);
            var terms = await GetTermsOfServiceAsync(language, cancellationToken);

            return new Dictionary<string, LegalContentDto>(StringComparer.OrdinalIgnoreCase)
            {
                { "about", about },
                { "privacy", privacy },
                { "terms", terms }
            };
        }

        private static void SetCulture(string lang)
        {
            try
            {
                var culture = new CultureInfo(lang);
                CultureInfo.CurrentCulture = culture;
                CultureInfo.CurrentUICulture = culture;
            }
            catch
            {
                var fallback = new CultureInfo("en");
                CultureInfo.CurrentCulture = fallback;
                CultureInfo.CurrentUICulture = fallback;
            }
        }

        private string GetString(string key, string fallback)
        {
            try
            {
                var localized = _localizer[key];
                if (localized != null && !localized.ResourceNotFound && !string.IsNullOrWhiteSpace(localized.Value))
                {
                    return localized.Value;
                }
            }
            catch (Exception ex)
            {
                _logger.LogWarning(ex, "Failed to localize key {Key}", key);
            }
            return fallback;
        }

        private List<string> BuildBulletList(params string[] keys)
        {
            var list = new List<string>();
            foreach (var key in keys)
            {
                try
                {
                    var localized = _localizer[key];
                    if (localized != null && !localized.ResourceNotFound && !string.IsNullOrWhiteSpace(localized.Value))
                    {
                        list.Add(localized.Value);
                    }
                }
                catch
                {
                    // ignore missing individual bullet
                }
            }
            return list;
        }

        private static string NormalizeLanguage(string? language)
        {
            if (string.IsNullOrWhiteSpace(language)) return "en";

            var clean = language.Trim().ToLowerInvariant();
            if (clean.Contains(','))
            {
                clean = clean.Split(',')[0].Trim();
            }
            if (clean.Contains(';'))
            {
                clean = clean.Split(';')[0].Trim();
            }
            if (clean.Contains('-'))
            {
                clean = clean.Split('-')[0].Trim();
            }
            if (clean.Contains('_'))
            {
                clean = clean.Split('_')[0].Trim();
            }

            return SupportedLanguages.Contains(clean) ? clean : "en";
        }
    }
}

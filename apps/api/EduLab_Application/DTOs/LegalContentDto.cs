using System;
using System.Collections.Generic;

namespace EduLab_Application.DTOs.Legal
{
    /// <summary>
    /// DTO representing legal and platform documentation (About, Privacy Policy, Terms of Service)
    /// </summary>
    public class LegalContentDto
    {
        public string Type { get; set; } = string.Empty;
        public string Title { get; set; } = string.Empty;
        public string Subtitle { get; set; } = string.Empty;
        public string LastUpdated { get; set; } = string.Empty;
        public string AppVersion { get; set; } = "1.0.0";
        public string ContactEmail { get; set; } = "support@edulab.com";
        public string WebsiteUrl { get; set; } = "https://edulabapi.runasp.net";
        public List<LegalSectionDto> Sections { get; set; } = new();
    }

    /// <summary>
    /// Section within a legal or informational document
    /// </summary>
    public class LegalSectionDto
    {
        public string Title { get; set; } = string.Empty;
        public string Content { get; set; } = string.Empty;
        public string? Icon { get; set; }
        public List<string>? BulletPoints { get; set; }
    }
}

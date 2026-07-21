using System;
using System.ComponentModel.DataAnnotations;

namespace EduLab_Domain.Entities
{
    public class SiteSettings
    {
        [Key]
        public int Id { get; set; }
        public string SiteName { get; set; } = "EduLab";
        public string? SiteDescription { get; set; }
        public string DefaultLanguage { get; set; } = "en";
        public string Timezone { get; set; } = "UTC";
        public string PrimaryColor { get; set; } = "#2563eb";
        public string DefaultTheme { get; set; } = "system";
        public string? FaviconUrl { get; set; }
        public string? LogoUrl { get; set; }
        public string? MetaKeywords { get; set; }
        public string? MetaDescription { get; set; }
        public bool MaintenanceMode { get; set; }
        public string? MaintenanceMessage { get; set; }
        public DateTime UpdatedAt { get; set; } = DateTime.UtcNow;
        public string? UpdatedBy { get; set; }
    }
}

using System.ComponentModel.DataAnnotations;

namespace EduLab_MVC.Models.DTOs.Settings
{
    public class GeneralSettingsDTO
    {
        [EmailAddress]
        public string Email { get; set; }

        [Required]
        public string FullName { get; set; }

        [Phone]
        public string PhoneNumber { get; set; }
    }
}

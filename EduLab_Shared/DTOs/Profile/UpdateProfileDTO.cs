using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_Shared.DTOs.Profile
{
    /// <summary>
    /// Data Transfer Object for updating user profile
    /// </summary>
    public class UpdateProfileDTO
    {
        /// <summary>
        /// Gets or sets the user ID
        /// </summary>
        [Required(ErrorMessage = "معرف المستخدم مطلوب")]
        public string Id { get; set; }

        /// <summary>
        /// Gets or sets the full name
        /// </summary>
        [StringLength(100, ErrorMessage = "الاسم يجب ألا يتجاوز 100 حرف")]
        public string? FullName { get; set; }

        /// <summary>
        /// Gets or sets the title/position
        /// </summary>
        [StringLength(100, ErrorMessage = "المسمى الوظيفي يجب ألا يتجاوز 100 حرف")]
        public string? Title { get; set; }

        /// <summary>
        /// Gets or sets the location
        /// </summary>
        [StringLength(100, ErrorMessage = "الموقع يجب ألا يتجاوز 100 حرف")]
        public string? Location { get; set; }

        /// <summary>
        /// Gets or sets the phone number
        /// </summary>
        [Phone(ErrorMessage = "رقم الهاتف غير صحيح")]
        public string? PhoneNumber { get; set; }

        /// <summary>
        /// Gets or sets the about/bio information
        /// </summary>
        [StringLength(500, ErrorMessage = "النبذة يجب ألا تتجاوز 500 حرف")]
        public string? About { get; set; }

        /// <summary>
        /// Gets or sets the social links
        /// </summary>
        public SocialLinksDTO? SocialLinks { get; set; }
    }
}

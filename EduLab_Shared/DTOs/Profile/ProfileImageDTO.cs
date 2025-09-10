using Microsoft.AspNetCore.Http;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_Shared.DTOs.Profile
{
    /// <summary>
    /// Data Transfer Object for profile image upload
    /// </summary>
    public class ProfileImageDTO
    {
        /// <summary>
        /// Gets or sets the user ID
        /// </summary>
        [Required(ErrorMessage = "معرف المستخدم مطلوب")]
        public string UserId { get; set; }

        /// <summary>
        /// Gets or sets the image file
        /// </summary>
        [Required(ErrorMessage = "ملف الصورة مطلوب")]
        public IFormFile ImageFile { get; set; }
    }
}

using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_Shared.DTOs.Profile
{
    /// <summary>
    /// Data Transfer Object for social links
    /// </summary>
    public class SocialLinksDTO
    {
        /// <summary>
        /// Gets or sets the GitHub URL
        /// </summary>
        [Url(ErrorMessage = "رابط GitHub غير صحيح")]
        public string? GitHub { get; set; }

        /// <summary>
        /// Gets or sets the LinkedIn URL
        /// </summary>
        [Url(ErrorMessage = "رابط LinkedIn غير صحيح")]
        public string? LinkedIn { get; set; }

        /// <summary>
        /// Gets or sets the Twitter URL
        /// </summary>
        [Url(ErrorMessage = "رابط Twitter غير صحيح")]
        public string? Twitter { get; set; }

        /// <summary>
        /// Gets or sets the Facebook URL
        /// </summary>
        [Url(ErrorMessage = "رابط Facebook غير صحيح")]
        public string? Facebook { get; set; }
    }
}

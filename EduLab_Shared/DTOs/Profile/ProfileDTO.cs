using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_Shared.DTOs.Profile
{
    public class ProfileDTO
    {
        /// <summary>
        /// Gets or sets the user ID
        /// </summary>
        public string Id { get; set; }

        /// <summary>
        /// Gets or sets the full name of the user
        /// </summary>
        public string FullName { get; set; }

        /// <summary>
        /// Gets or sets the email address of the user
        /// </summary>
        public string Email { get; set; }

        /// <summary>
        /// Gets or sets the title/position of the user
        /// </summary>
        public string Title { get; set; }

        /// <summary>
        /// Gets or sets the location of the user
        /// </summary>
        public string Location { get; set; }

        /// <summary>
        /// Gets or sets the phone number of the user
        /// </summary>
        public string PhoneNumber { get; set; }

        /// <summary>
        /// Gets or sets the about/bio information of the user
        /// </summary>
        public string About { get; set; }

        /// <summary>
        /// Gets or sets the profile image URL
        /// </summary>
        public string ProfileImageUrl { get; set; }

        /// <summary>
        /// Gets or sets the creation date of the profile
        /// </summary>
        public DateTime CreatedAt { get; set; }

        /// <summary>
        /// Gets or sets the social links of the user
        /// </summary>
        public SocialLinksDTO SocialLinks { get; set; }
    }
}

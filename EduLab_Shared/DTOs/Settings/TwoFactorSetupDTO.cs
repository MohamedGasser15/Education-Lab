using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_Shared.DTOs.Settings
{
    /// <summary>
    /// Data Transfer Object for two-factor authentication setup information
    /// </summary>
    public class TwoFactorSetupDTO
    {
        /// <summary>
        /// Gets or sets the QR code URL for authenticator apps
        /// </summary>
        public string QrCodeUrl { get; set; }

        /// <summary>
        /// Gets or sets the secret key for manual setup
        /// </summary>
        public string Secret { get; set; }

        /// <summary>
        /// Gets or sets the list of recovery codes
        /// </summary>
        public List<string> RecoveryCodes { get; set; }
    }
}

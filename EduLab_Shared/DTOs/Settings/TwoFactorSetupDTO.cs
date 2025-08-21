using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_Shared.DTOs.Settings
{
    public class TwoFactorSetupDTO
    {
        public string QrCodeUrl { get; set; }
        public string Secret { get; set; }
        public List<string> RecoveryCodes { get; set; }
    }
}

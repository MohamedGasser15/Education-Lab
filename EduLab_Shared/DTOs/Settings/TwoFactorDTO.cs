using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_Shared.DTOs.Settings
{
    public class TwoFactorDTO
    {
        public bool Enable { get; set; }
        public string Code { get; set; }
    }
}

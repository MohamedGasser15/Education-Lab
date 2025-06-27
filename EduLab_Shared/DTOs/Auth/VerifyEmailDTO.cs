using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_Shared.DTOs.Auth
{
    public class VerifyEmailDTO
    {
        public string Email { get; set; }
        public string Code { get; set; }
    }
}

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_Shared.DTOs.Auth
{
    public class ExternalLoginCallbackResultDTO
    {
        public bool IsNewUser { get; set; }
        public string Email { get; set; }
        public string ReturnUrl { get; set; }
        public string Message { get; set; }
    }
}

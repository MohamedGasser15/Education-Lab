using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_Shared.DTOs.Auth
{
    public class LoginResponseDTO
    {
        public string Token { get; set; }
        public string Role { get; set; }
        public string Email { get; set; }
        public string UserId { get; set; }
    }
}
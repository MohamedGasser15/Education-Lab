using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_Shared.DTOs.Token
{
    public class RefreshTokenRequestDTO
    {
        public string AccessToken { get; set; }
        public string RefreshToken { get; set; }
    }
}

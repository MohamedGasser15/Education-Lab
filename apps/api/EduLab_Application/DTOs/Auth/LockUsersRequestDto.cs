using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_Application.DTOs.Auth
{
    public class LockUsersRequestDto
    {
        public List<string> UserIds { get; set; }
        public int Minutes { get; set; }
    }
}

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_Shared.DTOs.Auth
{
    public class UpdateUserDTO
    {
        public string Id { get; set; }
        public string FullName { get; set; }
        public string Role { get; set; }
    }
}

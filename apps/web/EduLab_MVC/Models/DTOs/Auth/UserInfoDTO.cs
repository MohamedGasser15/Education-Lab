using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_MVC.Models.DTOs.Auth
{
    /// <summary>
    /// Represents an user info data transfer object.
    /// </summary>
    public class UserInfoDTO : UserDTO
    {
        public string? PhoneNumber { get; set; }
        public string? About { get; set; }
        public List<string> Skills { get; set; } = new List<string>();
    }
}

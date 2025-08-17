using Microsoft.AspNetCore.Components.Authorization;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_Shared.DTOs.Role
{
    public class RoleClaimsDto
    {
        public string RoleId { get; set; }
        public string RoleName { get; set; }
        public List<ClaimDto> Claims { get; set; } = new List<ClaimDto>();
    }
}

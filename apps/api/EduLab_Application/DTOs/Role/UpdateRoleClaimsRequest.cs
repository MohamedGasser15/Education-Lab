using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_Application.DTOs.Role
{
    public class UpdateRoleClaimsRequest
    {
        public List<ClaimDto> Claims { get; set; }
    }
}

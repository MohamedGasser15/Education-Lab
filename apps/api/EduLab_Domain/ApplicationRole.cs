using Microsoft.AspNetCore.Identity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_Domain
{
    /// <summary>
    /// Represents an application role, extending the identity role with soft-delete support
    /// </summary>
    public class ApplicationRole : IdentityRole
    {
        public bool IsDeleted { get; set; } = false;
    }
}

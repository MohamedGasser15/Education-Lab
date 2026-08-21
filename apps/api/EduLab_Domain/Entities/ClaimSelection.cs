using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_Domain.Entities
{
    /// <summary>
    /// Represents a claim and whether it is selected for a role
    /// </summary>
    public class ClaimSelection
    {
        public string ClaimType { get; set; }
        public string? Label { get; set; }
        public bool IsSelected { get; set; }
    }
}

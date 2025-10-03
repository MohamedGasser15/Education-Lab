using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_Shared.DTOs.Rating
{
    public class CanRateResponseDto
    {
        public bool EligibleToRate { get; set; }
        public bool HasRated { get; set; } 
        public bool CanRate => EligibleToRate && !HasRated;
    }
}

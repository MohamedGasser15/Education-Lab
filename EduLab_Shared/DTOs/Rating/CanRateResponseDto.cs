using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_Shared.DTOs.Rating
{
    public class CanRateResponseDto
    {
        public bool EligibleToRate { get; set; }  // مؤهل (خلص 80%)
        public bool HasRated { get; set; }        // عنده تقييم بالفعل
        public bool CanRate => EligibleToRate && !HasRated; // يقدر يضيف تقييم جديد
    }
}

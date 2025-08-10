using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_Shared.DTOs.Auth
{
    public class ExternalLoginConfirmationDto
    {
        [Required(ErrorMessage = "الاسم مطلوب")]
        public string Name { get; set; }

        public string Email { get; set; }
    }
}

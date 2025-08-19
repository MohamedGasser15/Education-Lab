using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_Shared.DTOs.Profile
{
    public class SocialLinksDTO
    {
        [Url(ErrorMessage = "رابط GitHub غير صحيح")]
        public string? GitHub { get; set; }

        [Url(ErrorMessage = "رابط LinkedIn غير صحيح")]
        public string? LinkedIn { get; set; }

        [Url(ErrorMessage = "رابط Twitter غير صحيح")]
        public string? Twitter { get; set; }

        [Url(ErrorMessage = "رابط Facebook غير صحيح")]
        public string? Facebook { get; set; }
    }
}

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_Shared.DTOs.Profile
{
    public class CertificateDTO
    {
        public int? Id { get; set; }
        public string Name { get; set; }
        public string Issuer { get; set; }
        public int Year { get; set; }
    }
}

using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_Domain.Entities
{
    public class Certificate
    {
        public int Id { get; set; }
        public int EnrollmentId { get; set; }
        public string CertificateUrl { get; set; }
        public DateTime IssuedAt { get; set; }

        [ForeignKey("EnrollmentId")]
        public Enrollment Enrollment { get; set; }
    }
}

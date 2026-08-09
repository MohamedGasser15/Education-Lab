using System;
using System.ComponentModel.DataAnnotations.Schema;

namespace EduLab_Domain.Entities
{
    public class CourseCertificate
    {
        public int Id { get; set; }
        public int EnrollmentId { get; set; }
        public string CertificateCode { get; set; }
        public string PdfPath { get; set; }
        public DateTime IssuedDate { get; set; } = DateTime.UtcNow;

        [ForeignKey("EnrollmentId")]
        public Enrollment Enrollment { get; set; }
    }
}

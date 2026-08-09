using System;

namespace EduLab_Application.DTOs.Certificates
{
    public class CertificateDto
    {
        public int Id { get; set; }
        public int EnrollmentId { get; set; }
        public string CertificateCode { get; set; }
        public string PdfPath { get; set; }
        public DateTime IssuedDate { get; set; }
        public string StudentName { get; set; }
        public string CourseTitle { get; set; }
        public string VerifyUrl { get; set; }
    }
}

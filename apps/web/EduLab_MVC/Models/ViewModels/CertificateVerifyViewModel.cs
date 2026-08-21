using System;

namespace EduLab_MVC.Models.ViewModels
{
    /// <summary>
    /// View model that supplies data for the certificate verify view.
    /// </summary>
    public class CertificateVerifyViewModel
    {
        public bool Valid { get; set; }
        public bool IsFound { get; set; }
        public string Code { get; set; }
        public string StudentName { get; set; }
        public string CourseTitle { get; set; }
        public DateTime IssuedDate { get; set; }
        public string CertificateCode { get; set; }
    }
}

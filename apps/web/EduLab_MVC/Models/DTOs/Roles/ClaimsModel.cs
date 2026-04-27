using System.Collections.Generic;

namespace EduLab_MVC.Models.DTOs.Roles
{
    public class ClaimSelection
    {
        public string ClaimType { get; set; }
        public string Label { get; set; }
        public bool IsSelected { get; set; }
    }

    public class ClaimsModel
    {
        public string RoleId { get; set; }
        public List<ClaimSelection> DashboardClaimList { get; set; } = new();
        public List<ClaimSelection> CategoryClaimList { get; set; } = new();
        public List<ClaimSelection> CourseClaimList { get; set; } = new();
        public List<ClaimSelection> InstructorClaimList { get; set; } = new();
        public List<ClaimSelection> UserClaimList { get; set; } = new();
        public List<ClaimSelection> RoleClaimList { get; set; } = new();
        public List<ClaimSelection> HistoryClaimList { get; set; } = new();
        public List<ClaimSelection> PaymentClaimList { get; set; } = new();
        public List<ClaimSelection> NotificationClaimList { get; set; } = new();
        public List<ClaimSelection> StudentClaimList { get; set; } = new();
    }
}

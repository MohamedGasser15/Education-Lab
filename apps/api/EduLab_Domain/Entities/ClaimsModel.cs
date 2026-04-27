using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_Domain.Entities
{
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

        public ClaimsModel()
        {
            DashboardClaimList = new();
            CategoryClaimList = new();
            CourseClaimList = new();
            InstructorClaimList = new();
            UserClaimList = new();
            RoleClaimList = new();
            HistoryClaimList = new();
            PaymentClaimList = new();
            NotificationClaimList = new();
            StudentClaimList = new();
        }
    }
}

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_Application.Common.Constants
{
    public class SD
    {
        public const string Admin = "Admin";
        public const string Instructor = "Instructor";
        public const string InstructorPending = "InstructorPending";
        public const string Student = "Student";
        public const string Support = "Support";
        public const string Moderator = "Moderator ";
        public const string EduLabInstructorId = "edulab-instructor";

        public const string CourseStatusDraft = "Draft";
        public const string CourseStatusPending = "Pending";
        public const string CourseStatusApproved = "Approved";
        public const string CourseStatusRejected = "Rejected";

        public const string ApplicationStatusPending = "Pending";
        public const string ApplicationStatusApproved = "Approved";
        public const string ApplicationStatusRejected = "Rejected";

        public const string RefundStatusPending = "pending";
        public const string RefundStatusAccepted = "accepted";
        public const string RefundStatusRejected = "rejected";

        public const string PaymentStatusCompleted = "completed";
        public const string PaymentStatusRefunded = "refunded";
        public const string PaymentStatusSucceeded = "Succeeded";
        public const string PaymentStatusPaid = "Paid";
    }
}

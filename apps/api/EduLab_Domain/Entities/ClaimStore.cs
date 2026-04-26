using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Claims;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_Domain.Entities
{
    public static class ClaimStore
    {
        public static List<Claim> CategoryClaims = new List<Claim>
        {
            new Claim("ViewCategories", "عرض التصنيفات"),
            new Claim("CreateCategory", "إضافة تصنيف"),
            new Claim("EditCategory", "تعديل تصنيف"),
            new Claim("DeleteCategory", "حذف تصنيف"),
        };

        public static List<Claim> CourseClaims = new List<Claim>
        {
            new Claim("ViewCourses", "عرض الكورسات"),
            new Claim("CreateCourse", "إضافة كورس"),
            new Claim("EditCourse", "تعديل كورس"),
            new Claim("DeleteCourse", "حذف كورس"),
            new Claim("ApproveCourse", "اعتماد كورس"),
        };

        public static List<Claim> InstructorClaims = new List<Claim>
        {
            new Claim("ViewInstructorApplications", "عرض طلبات التدريس"),
            new Claim("ApproveInstructorApplication", "قبول مدرس"),
            new Claim("RejectInstructorApplication", "رفض مدرس"),
        };

        public static List<Claim> UserClaims = new List<Claim>
        {
            new Claim("ViewUsers", "عرض المستخدمين"),
            new Claim("EditUser", "تعديل مستخدم"),
            new Claim("DeleteUser", "حذف مستخدم"),
            new Claim("BlockUser", "حظر مستخدم"),
        };

        public static List<Claim> RoleClaims = new List<Claim>
        {
            new Claim("ViewRoles", "عرض الأدوار"),
            new Claim("CreateRole", "إضافة دور"),
            new Claim("EditRole", "تعديل دور"),
            new Claim("DeleteRole", "حذف دور"),
            new Claim("ManageRoleClaims", "إدارة صلاحيات الأدوار"),
        };

        public static List<Claim> HistoryClaims = new List<Claim>
        {
            new Claim("ViewHistory", "عرض سجل النشاطات"),
        };

        public static List<Claim> PaymentClaims = new List<Claim>
        {
            new Claim("ViewPayments", "عرض المدفوعات"),
            new Claim("RefundPayment", "استرجاع مبلغ"),
        };

        public static List<Claim> NotificationClaims = new List<Claim>
        {
            new Claim("ViewNotifications", "عرض التنبيهات"),
            new Claim("SendNotification", "إرسال تنبيه"),
        };

        public static List<Claim> StudentClaims = new List<Claim>
        {
            new Claim("ViewStudents", "عرض الطلاب"),
        };
    }
}

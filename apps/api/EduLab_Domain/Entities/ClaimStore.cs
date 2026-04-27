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
        public static List<Claim> DashboardClaims = new List<Claim>
        {
            new Claim("ViewDashboard", "عرض لوحة التحكم"),
        };

        public static List<Claim> CategoryClaims = new List<Claim>
        {
            new Claim("ViewCategories", "عرض التصنيفات"),
            new Claim("CreateCategory", "إضافة تصنيف جديد"),
            new Claim("EditCategory", "تعديل تصنيف"),
            new Claim("DeleteCategory", "حذف تصنيف"),
        };

        public static List<Claim> CourseClaims = new List<Claim>
        {
            new Claim("ViewCourses", "عرض قائمة الدورات"),
            new Claim("CreateCourse", "إنشاء دورة جديدة"),
            new Claim("EditCourse", "تعديل محتوى الدورة"),
            new Claim("DeleteCourse", "حذف دورة"),
            new Claim("ApproveCourses", "اعتماد وقبول الدورة"),
        };

        public static List<Claim> InstructorClaims = new List<Claim>
        {
            new Claim("ViewInstructorApplications", "عرض طلبات الانضمام للمدربين"),
            new Claim("HandleInstructorApplications", "اتخاذ قرار بشأن طلب المدرب (قبول/رفض)"),
            new Claim("DownloadInstructorCV", "تحميل السيرة الذاتية"),
        };

        public static List<Claim> UserClaims = new List<Claim>
        {
            new Claim("ViewUsers", "عرض قائمة المستخدمين"),
            new Claim("CreateUser", "إضافة مستخدم جديد"),
            new Claim("EditUser", "تعديل بيانات مستخدم"),
            new Claim("DeleteUser", "حذف مستخدم"),
            new Claim("BlockUser", "حظر/إلغاء حظر مستخدم"),
        };

        public static List<Claim> RoleClaims = new List<Claim>
        {
            new Claim("ViewRoles", "عرض قائمة الأدوار"),
            new Claim("CreateRole", "إضافة دور جديد"),
            new Claim("EditRole", "تعديل مسمى الدور"),
            new Claim("DeleteRole", "حذف دور"),
            new Claim("ManageRoleClaims", "إدارة صلاحيات الدور"),
        };

        public static List<Claim> StudentClaims = new List<Claim>
        {
            new Claim("ViewStudents", "عرض قائمة الطلاب"),
            new Claim("EditStudent", "تعديل بيانات طالب"),
            new Claim("DeleteStudent", "حذف طالب"),
        };

        public static List<Claim> HistoryClaims = new List<Claim>
        {
            new Claim("ViewSystemHistory", "عرض سجل العمليات"),
            new Claim("ClearHistory", "مسح السجل"),
        };

        public static List<Claim> ReportClaims = new List<Claim>
        {
            new Claim("ViewReports", "عرض التقارير المالية والإحصائية"),
            new Claim("ExportReports", "تصدير التقارير (Excel/PDF)"),
        };

        public static List<Claim> NotificationClaims = new List<Claim>
        {
            new Claim("ViewNotifications", "عرض التنبيهات"),
            new Claim("SendNotifications", "إرسال تنبيه جديد"),
            new Claim("DeleteNotification", "حذف تنبيه"),
        };

        public static List<Claim> AllClaims = DashboardClaims
            .Concat(CategoryClaims)
            .Concat(CourseClaims)
            .Concat(InstructorClaims)
            .Concat(UserClaims)
            .Concat(RoleClaims)
            .Concat(StudentClaims)
            .Concat(HistoryClaims)
            .Concat(ReportClaims)
            .Concat(NotificationClaims)
            .ToList();
    }
}

using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Claims;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_Domain.Entities
{
    /// <summary>
    /// Central registry of all application permission claims, grouped by feature area
    /// </summary>
    public static class ClaimStore
    {
        /// <summary>
        /// Claims for dashboard access
        /// </summary>
        public static List<Claim> DashboardClaims = new List<Claim>
        {
            new Claim("ViewDashboard", "عرض لوحة التحكم"),
        };

        /// <summary>
        /// Claims for category management
        /// </summary>
        public static List<Claim> CategoryClaims = new List<Claim>
        {
            new Claim("ViewCategories", "عرض التصنيفات"),
            new Claim("CreateCategory", "إضافة تصنيف جديد"),
            new Claim("EditCategory", "تعديل تصنيف"),
            new Claim("DeleteCategory", "حذف تصنيف"),
        };

        /// <summary>
        /// Claims for course management
        /// </summary>
        public static List<Claim> CourseClaims = new List<Claim>
        {
            new Claim("ViewCourses", "عرض قائمة الدورات"),
            new Claim("CreateCourse", "إنشاء دورة جديدة"),
            new Claim("EditCourse", "تعديل محتوى الدورة"),
            new Claim("DeleteCourse", "حذف دورة"),
            new Claim("ApproveCourses", "اعتماد وقبول الدورة"),
        };

        /// <summary>
        /// Claims for instructor application handling
        /// </summary>
        public static List<Claim> InstructorClaims = new List<Claim>
        {
            new Claim("ViewInstructorApplications", "عرض طلبات الانضمام للمدربين"),
            new Claim("HandleInstructorApplications", "اتخاذ قرار بشأن طلب المدرب (قبول/رفض)"),
            new Claim("DownloadInstructorCV", "تحميل السيرة الذاتية"),
        };

        /// <summary>
        /// Claims for user management
        /// </summary>
        public static List<Claim> UserClaims = new List<Claim>
        {
            new Claim("ViewUsers", "عرض قائمة المستخدمين"),
            new Claim("CreateUser", "إضافة مستخدم جديد"),
            new Claim("EditUser", "تعديل بيانات مستخدم"),
            new Claim("DeleteUser", "حذف مستخدم"),
            new Claim("BlockUser", "حظر/إلغاء حظر مستخدم"),
        };

        /// <summary>
        /// Claims for role management
        /// </summary>
        public static List<Claim> RoleClaims = new List<Claim>
        {
            new Claim("ViewRoles", "عرض قائمة الأدوار"),
            new Claim("CreateRole", "إضافة دور جديد"),
            new Claim("EditRole", "تعديل مسمى الدور"),
            new Claim("DeleteRole", "حذف دور"),
            new Claim("ManageRoleClaims", "إدارة صلاحيات الدور"),
        };

        /// <summary>
        /// Claims for student management
        /// </summary>
        public static List<Claim> StudentClaims = new List<Claim>
        {
            new Claim("ViewStudents", "عرض قائمة الطلاب"),
            new Claim("EditStudent", "تعديل بيانات طالب"),
            new Claim("DeleteStudent", "حذف طالب"),
        };

        /// <summary>
        /// Claims for system history viewing and clearing
        /// </summary>
        public static List<Claim> HistoryClaims = new List<Claim>
        {
            new Claim("ViewSystemHistory", "عرض سجل العمليات"),
            new Claim("ClearHistory", "مسح السجل"),
        };

        /// <summary>
        /// Claims for report viewing, exporting, and handling
        /// </summary>
        public static List<Claim> ReportClaims = new List<Claim>
        {
            new Claim("ViewReports", "عرض التقارير المالية والإحصائية"),
            new Claim("ExportReports", "تصدير التقارير (Excel/PDF)"),
            new Claim("HandleReports", "التعامل مع بلاغات المستخدمين (حل/رفض/حذف محتوى)"),
        };

        /// <summary>
        /// Claims for refund request management
        /// </summary>
        public static List<Claim> RefundClaims = new List<Claim>
        {
            new Claim("ViewRefunds", "عرض طلبات الاسترداد"),
            new Claim("ManageRefunds", "اتخاذ قرار بشأن طلب الاسترداد (قبول/رفض)"),
        };

        /// <summary>
        /// Claims for notification management
        /// </summary>
        public static List<Claim> NotificationClaims = new List<Claim>
        {
            new Claim("ViewNotifications", "عرض التنبيهات"),
            new Claim("SendNotifications", "إرسال تنبيه جديد"),
            new Claim("DeleteNotification", "حذف تنبيه"),
        };

        /// <summary>
        /// Claims for site settings management
        /// </summary>
        public static List<Claim> SiteSettingsClaims = new List<Claim>
        {
            new Claim("ViewSiteSettings", "عرض إعدادات الموقع"),
            new Claim("EditSiteSettings", "تعديل إعدادات الموقع"),
        };

        /// <summary>
        /// Claims for support ticket management
        /// </summary>
        public static List<Claim> SupportClaims = new List<Claim>
        {
            new Claim("ViewSupport", "عرض صندوق الدعم الفني"),
            new Claim("HandleSupport", "الرد على محادثات الدعم وإدارتها"),
        };

        /// <summary>
        /// Aggregates every claim from all feature areas into a single list
        /// </summary>
        public static List<Claim> AllClaims = DashboardClaims
            .Concat(CategoryClaims)
            .Concat(CourseClaims)
            .Concat(InstructorClaims)
            .Concat(UserClaims)
            .Concat(RoleClaims)
            .Concat(StudentClaims)
            .Concat(HistoryClaims)
            .Concat(ReportClaims)
            .Concat(RefundClaims)
            .Concat(NotificationClaims)
            .Concat(SiteSettingsClaims)
            .Concat(SupportClaims)
            .ToList();
    }
}

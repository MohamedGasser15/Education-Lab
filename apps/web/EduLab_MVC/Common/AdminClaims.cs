namespace EduLab_MVC.Common
{
    /// <summary>
    /// جميع صلاحيات (Claims) لوحة تحكم الـ Admin — امتلاك أي claim منها يسمح بدخول المنطقة
    /// </summary>
    public static class AdminClaims
    {
        public static readonly string[] All =
        {
            // Dashboard
            "ViewDashboard",
            // Users
            "ViewUsers", "EditUser", "BlockUser", "DeleteUser", "CreateUser",
            // Roles
            "ViewRoles", "CreateRole", "EditRole", "DeleteRole", "ManageRoleClaims",
            // Courses
            "ViewCourses", "CreateCourse", "EditCourse", "DeleteCourse", "ApproveCourses",
            // Categories
            "ViewCategories", "CreateCategory", "EditCategory", "DeleteCategory",
            // Instructor Applications
            "ViewInstructorApplications", "HandleInstructorApplications", "DownloadInstructorCV",
            // Refunds
            "ViewRefunds", "ManageRefunds",
            // Notifications
            "ViewNotifications", "SendNotifications", "DeleteNotification",
            // System
            "ViewSystemHistory", "ViewReports",
            // Site Settings
            "ViewSiteSettings", "EditSiteSettings",
            // Students
            "ViewStudents", "EditStudent", "DeleteStudent"
        };
    }
}

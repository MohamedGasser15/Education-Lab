namespace EduLab_MVC.Common
{
    /// <summary>
    /// Centralized API endpoint routes for the EduLab MVC application.
    /// Eliminates hardcoded magic strings and maintains architectural parity with client apps.
    /// </summary>
    public static class ApiEndpoints
    {
        public static class Auth
        {
            public const string Login = "Auth/Login";
            public const string Register = "Auth/Register";
            public const string Refresh = "Auth/refresh";
            public const string Revoke = "Auth/revoke";
            public const string ForgotPassword = "Auth/forgot-password";
            public const string VerifyResetCode = "Auth/verify-reset-code";
            public const string ResetPassword = "Auth/reset-password";
            public const string VerifyEmail = "Auth/verify-email";
            public const string SendCode = "Auth/send-code";
            public const string ExternalLoginConfirmation = "Auth/ExternalLoginConfirmation";
            public const string ExternalLoginCallback = "Auth/ExternalLoginCallback";
        }

        public static class Courses
        {
            public const string Base = "course";
            public const string BulkDelete = "course/BulkDelete";
            public const string CreateDraft = "course/create-draft";
            public const string ByInstructor = "course/instructor";
            public const string ByCategory = "course/category";
            public const string LectureResources = "course/lecture";
            public const string Resources = "course/resources";
            public const string Sections = "course/sections";
            public const string Lectures = "course/lectures";
        }

        public static class LearnerCourses
        {
            public const string Base = "LearnerCourse";
            public const string Featured = "LearnerCourse/featured";
            public const string New = "LearnerCourse/new";
            public const string Recommended = "LearnerCourse/recommended";
            public const string Approved = "LearnerCourse/approved";
            public const string ApprovedByInstructor = "LearnerCourse/approved/by-instructor";
            public const string ApprovedByCategory = "LearnerCourse/approved/by-category";
            public const string ApprovedByCategories = "LearnerCourse/approved/by-categories";
        }

        public static class InstructorCourses
        {
            public const string Base = "InstructorCourse";
            public const string Sections = "InstructorCourse/sections";
            public const string Lectures = "InstructorCourse/lectures";
            public const string InstructorCoursesList = "InstructorCourse/instructor-courses";
            public const string InstructorBase = "InstructorCourse/instructor";
            public const string BulkDelete = "InstructorCourse/instructor/BulkDelete";
        }

        public static class Categories
        {
            public const string Base = "Category";
            public const string Top = "Category/top";
            public const string BulkDelete = "Category/bulk";
        }

        public static class Cart
        {
            public const string Base = "Cart";
            public const string Migrate = "Cart/migrate";
            public const string Items = "Cart/items";
            public const string Clear = "Cart/clear";
        }

        public static class Coupon
        {
            public const string Base = "coupon";
            public const string Apply = "coupon/apply";
            public const string Remove = "coupon/remove";
            public static string ById(int id) => $"coupon/{id}";
            public static string Toggle(int id) => $"coupon/{id}/toggle";
        }

        public static class Wishlist
        {
            public const string Base = "Wishlist";
            public const string Check = "Wishlist/check";
        }

        public static class CourseProgress
        {
            public const string Base = "CourseProgress";
            public const string MarkCompleted = "CourseProgress/mark-completed";
            public const string MarkIncomplete = "CourseProgress/mark-incomplete";
            public const string LectureStatus = "CourseProgress/lecture";
            public const string CourseLectureStatuses = "CourseProgress/course";
        }

        public static class Comments
        {
            public const string Base = "Comments";
            public const string ByLecture = "Comments/lecture";
            public const string InstructorComments = "instructor/comments";
        }

        public static class Ratings
        {
            public const string Base = "ratings";
            public const string ByCourse = "ratings/course";
            public const string CanRate = "ratings/can-rate";
        }

        public static class Certificates
        {
            public const string Base = "Certificates";
            public const string MyCertificates = "Certificates/my";
            public const string Verify = "Certificates/verify";
            public const string Download = "Certificates/download";
        }

        public static class Enrollment
        {
            public const string Base = "enrollment";
            public const string Check = "enrollment/check";
            public const string Enroll = "enrollment/enroll";
            public const string Count = "enrollment/count";
        }

        public static class Profile
        {
            public const string Base = "profile";
            public const string UploadImage = "profile/upload-image";
            public const string Learner = "learner/profile";
            public const string InstructorProfile = "profile/instructor";
            public const string InstructorUploadImage = "profile/instructor/upload-image";
            public const string PublicInstructor = "profile/public/instructor";
            public const string Certificates = "profile/certificates";
        }

        public static class Settings
        {
            public const string Base = "settings";
            public const string General = "settings/general";
            public const string ChangePassword = "settings/change-password";
            public const string TwoFactorStatus = "settings/two-factor/status";
            public const string TwoFactorSetup = "settings/two-factor/setup";
            public const string TwoFactorEnable = "settings/two-factor/enable";
            public const string TwoFactorDisable = "settings/two-factor/disable";
            public const string TwoFactorVerify = "settings/two-factor/verify";
            public const string ActiveSessions = "settings/active-sessions";
            public const string ActiveSessionsRevoke = "settings/active-sessions/revoke";
            public const string RevokeSession = "settings/active-sessions/revoke";
            public const string RevokeAllSessions = "settings/active-sessions/revoke-all";
        }

        public static class Payment
        {
            public const string Base = "payment";
            public const string UserPayments = "payment/user-payments";
            public const string Refund = "payment/refund";
            public const string CreatePaymentIntent = "payment/create-payment-intent";
            public const string ConfirmPayment = "payment/confirm-payment";
            public const string CreateCheckoutSession = "payment/create-checkout-session";
            public const string PaymentUserData = "payment/user-data";
        }

        public static class Notifications
        {
            public const string Base = "Notifications";
            public const string Summary = "Notifications/summary";
            public const string MarkAsRead = "Notifications/mark-as-read";
            public const string MarkAllRead = "Notifications/mark-all-read";
            public const string UnreadCount = "Notifications/unread-count";
            public const string DeleteAll = "Notifications/delete-all";
            public const string SendBulk = "Notifications/send-bulk";
        }

        public static class Instructors
        {
            public const string Base = "Instructor";
            public const string Top = "Instructor/top";
            public const string Ratings = "instructor/ratings";
            public const string Applications = "InstructorApplication";
            public const string ApplicationApply = "InstructorApplication/apply";
            public const string ApplicationMyApplications = "InstructorApplication/my-applications";
            public const string ApplicationDetails = "InstructorApplication/application-details";
        }

        public static class InstructorApplications
        {
            public const string Base = "InstructorApplication";
            public const string Apply = "InstructorApplication/apply";
            public const string MyApplications = "InstructorApplication/my-applications";
            public const string Details = "InstructorApplication/application-details";
            public const string AdminAll = "InstructorApplications";
        }

        public static class Dashboard
        {
            public const string Base = "Dashboard";
            public const string Admin = "admin/dashboard";
            public const string Instructor = "instructor/dashboard";
            public const string InstructorRevenue = "instructor/dashboard/revenue";
            public const string PublicStats = "public/stats";
            public const string AdminStats = "Dashboard/admin/stats";
            public const string InstructorStats = "Dashboard/instructor/stats";
            public const string SalesAnalytics = "Dashboard/sales-analytics";
        }

        public static class Support
        {
            public const string Base = "Support";
            public const string Conversations = "support/conversations";
            public const string UnreadCount = "support/unread-count";
            public const string Messages = "Support/messages";
            public const string AdminConversations = "admin/support/conversations";
            public const string AdminUnreadCount = "admin/support/unread-count";
            public const string AdminMarkAllRead = "admin/support/mark-all-read";
        }

        public static class Reports
        {
            public const string Base = "reports";
            public const string AdminBase = "admin/reports";
            public const string PendingCount = "admin/reports/pending-count";
        }

        public static class RefundRequests
        {
            public const string Base = "admin/refunds";
        }

        public static class Roles
        {
            public const string Base = "role";
            public const string BulkDelete = "role/bulk-delete";
            public const string Statistics = "role/statistics";
        }

        public static class SiteSettings
        {
            public const string Base = "admin/settings";
        }

        public static class Students
        {
            public const string Base = "students";
            public const string ByInstructor = "students/by-instructor";
            public const string MyStudents = "students/my-students";
            public const string Summary = "students/summary";
            public const string SendNotification = "students/send-notification";
            public const string NotificationStudents = "students/notification-students";
            public const string NotificationSummary = "students/notification-summary";
        }

        public static class Users
        {
            public const string Base = "user";
            public const string Instructors = "user/instructors";
            public const string Admins = "user/admins";
            public const string Me = "user/me";
            public const string ByEduLabId = "user/by-edulab-id";
            public const string DeleteUsers = "user/DeleteUsers";
            public const string LockUsers = "user/LockUsers";
            public const string UnlockUsers = "user/UnlockUsers";
        }

        public static class History
        {
            public const string Base = "History";
            public const string Log = "History/log";
            public const string All = "History/all";
            public const string MyHistory = "History/MyHistory";
            public const string ByUser = "History/user";
        }
    }
}

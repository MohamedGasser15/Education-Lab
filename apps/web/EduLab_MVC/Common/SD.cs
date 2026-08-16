namespace EduLab_MVC.Common
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

        public static readonly string[] ProtectedRoles =
        {
            Admin, Instructor, InstructorPending, Student, Support
        };

        public static readonly string[] ProtectedCategories =
        {
            "Programming", "Web Development", "Mobile Development", "Game Development",
            "Software Engineering", "DevOps", "Data Science", "Data Analysis",
            "Machine Learning", "Artificial Intelligence", "Databases", "IT & Software",
            "Cyber Security", "Networking", "Cloud Computing", "Business",
            "Entrepreneurship", "Project Management", "Sales", "Marketing",
            "Digital Marketing", "Finance & Accounting", "Investing", "Office Productivity",
            "Personal Development", "Leadership", "Communication", "Negotiation",
            "Design", "Graphic Design", "UI/UX Design", "Design Tools",
            "Lifestyle", "Fashion", "Cooking", "Health & Fitness",
            "Nutrition", "Sports", "Photography & Video", "Music",
            "Teaching & Academics", "Engineering", "Math", "Physics",
            "Chemistry", "Medicine", "Law", "Psychology",
            "History", "Geography", "Languages", "English Language",
            "Arabic Language", "Content Writing", "Professional Training"
        };

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

        public const string ReportStatusPending = "pending";
        public const string ReportStatusResolved = "resolved";
        public const string ReportStatusDismissed = "dismissed";

        public const string ReportTypeCourse = "Course";
        public const string ReportTypeComment = "Comment";
        public const string ReportTypeReview = "Review";

        public const string ReportActionWarnedUser = "WarnedUser";
        public const string ReportActionRemovedContent = "RemovedContent";
        public const string ReportActionReviewedNoViolation = "ReviewedNoViolation";

        public const string ReportReasonCopyright = "Copyright";
        public const string ReportReasonPornographic = "Pornographic";
        public const string ReportReasonInappropriate = "Inappropriate";
        public const string ReportReasonHarassment = "Harassment";
        public const string ReportReasonHateSpeech = "HateSpeech";
        public const string ReportReasonFraud = "Fraud";
        public const string ReportReasonMisleadingInfo = "MisleadingInfo";
        public const string ReportReasonAdvertising = "Advertising";
        public const string ReportReasonSpam = "Spam";
        public const string ReportReasonOther = "Other";

        public static readonly string[] ReportReasonsCourse =
        {
            ReportReasonCopyright, ReportReasonPornographic, ReportReasonInappropriate,
            ReportReasonHateSpeech, ReportReasonFraud, ReportReasonMisleadingInfo,
            ReportReasonAdvertising, ReportReasonOther
        };

        public static readonly string[] ReportReasonsComment =
        {
            ReportReasonHarassment, ReportReasonHateSpeech, ReportReasonInappropriate,
            ReportReasonSpam, ReportReasonPornographic, ReportReasonOther
        };

        public static readonly string[] ReportReasonsReview =
        {
            ReportReasonHarassment, ReportReasonHateSpeech, ReportReasonInappropriate,
            ReportReasonSpam, ReportReasonPornographic, ReportReasonMisleadingInfo, ReportReasonOther
        };

        public static string[] GetReportReasons(string type)
        {
            return type switch
            {
                ReportTypeCourse => ReportReasonsCourse,
                ReportTypeComment => ReportReasonsComment,
                ReportTypeReview => ReportReasonsReview,
                _ => ReportReasonsCourse
            };
        }
    }
}

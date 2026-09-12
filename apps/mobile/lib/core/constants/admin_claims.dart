class AdminClaims {
  /// All admin panel claims — possessing any of these claims grants access to the admin area.
  /// Mirrored from EduLab_MVC.Common.AdminClaims and EduLab_Application.Common.Constants.AdminClaims.
  static const List<String> all = [
    // Dashboard
    'ViewDashboard',
    // Users
    'ViewUsers', 'EditUser', 'BlockUser', 'DeleteUser', 'CreateUser',
    // Roles
    'ViewRoles', 'CreateRole', 'EditRole', 'DeleteRole', 'ManageRoleClaims',
    // Courses
    'ViewCourses',
    'CreateCourse',
    'EditCourse',
    'DeleteCourse',
    'ApproveCourses',
    // Categories
    'ViewCategories', 'CreateCategory', 'EditCategory', 'DeleteCategory',
    // Instructor Applications
    'ViewInstructorApplications',
    'HandleInstructorApplications',
    'DownloadInstructorCV',
    // Refunds
    'ViewRefunds', 'ManageRefunds',
    // Notifications
    'ViewNotifications', 'SendNotifications', 'DeleteNotification',
    // System
    'ViewSystemHistory', 'ViewReports',
    // Reports
    'HandleReports',
    // Site Settings
    'ViewSiteSettings', 'EditSiteSettings',
    // Students
    'ViewStudents', 'EditStudent', 'DeleteStudent',
    // Support
    'ViewSupport', 'HandleSupport',
  ];

  /// Checks if any claim or role in [claims] matches any of the admin claims (case-insensitive).
  static bool hasAnyAdminClaim(Iterable<String> claims) {
    for (final claim in claims) {
      final clean = claim.trim().toLowerCase();
      if (clean.isEmpty) continue;
      for (final adminClaim in all) {
        if (adminClaim.toLowerCase() == clean) {
          return true;
        }
      }
    }
    return false;
  }
}

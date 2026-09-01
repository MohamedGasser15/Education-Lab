class ApiConstants {
  static const String baseUrl = "https://edulabapi.runasp.net/api/";

  static const String login = "auth/login";
  static const String register = "auth/Register";
  static const String refresh = "auth/refresh";
  static const String revoke = "auth/revoke";
  static const String sendCode = "auth/send-code";
  static const String verifyEmail = "auth/verify-email";
  static const String googleMobile = "auth/GoogleMobile";
  static const String externalLogin = "auth/ExternalLogin";

  static const String publicStats = "public/stats";
  static const String publicCategories = "public/categories";
  static const String publicCourses = "public/courses";

  static const String profile = "Profile";
  static const String learnerProfile = "learner/profile";
  static const String myCourses = "Enrollment";
  static const String enrollment = "Enrollment";
  static const String notifications = "learner/notifications";
  static const String cart = "learner/cart";
  static const String wishlist = "Wishlist";
  static const String courseProgress = "CourseProgress";

  static const String settings = "Settings";
  static const String changePassword = "Settings/change-password";
  static const String twoFactorStatus = "Settings/two-factor/status";
  static const String twoFactorSetup = "Settings/two-factor/setup";
  static const String twoFactorEnable = "Settings/two-factor/enable";
  static const String twoFactorDisable = "Settings/two-factor/disable";
  static const String activeSessions = "Settings/active-sessions";
  static const String revokeSession = "Settings/active-sessions/revoke";
  static const String revokeAllSessions = "Settings/active-sessions/revoke-all";
  static const String userPayments = "Payment/user-payments";
  static const String refund = "Payment/refund";
  static const String myCertificates = "Certificates/my";
  static const String verifyCertificate = "Certificates/verify";
  static const String downloadCertificate = "Certificates/download";
  static const String search = "learner/search";

  static String formatImageUrl(String? rawUrl) {
    if (rawUrl == null || rawUrl.trim().isEmpty) return '';
    final trimmed = rawUrl.trim();
    if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
      return trimmed;
    }
    final cleanBase = baseUrl.replaceAll('/api/', '').replaceAll('/api', '').replaceAll(RegExp(r'/+$'), '');
    final cleanPath = trimmed.replaceAll(RegExp(r'^/+'), '');
    return '$cleanBase/$cleanPath';
  }
}
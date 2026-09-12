class ApiConstants {
  static const String baseUrl = "https://edulabapi.runasp.net/api/";

  // --- Auth Endpoints ---
  static const String login = "auth/login";
  static const String register = "auth/Register";
  static const String refresh = "auth/refresh";
  static const String revoke = "auth/revoke";
  static const String sendCode = "auth/send-code";
  static const String verifyEmail = "auth/verify-email";
  static const String googleMobile = "auth/GoogleMobile";
  static const String externalLogin = "auth/ExternalLogin";

  // --- Public & Stats ---
  static const String publicStats = "public/stats";
  static const String publicCategories = "public/categories";
  static const String publicCourses = "public/courses";

  // --- Learner Courses & Catalog ---
  static const String learnerCourse = "LearnerCourse";
  static const String learnerCourseFeatured = "LearnerCourse/featured";
  static const String learnerCourseNew = "LearnerCourse/new";
  static const String learnerCourseRecommended = "LearnerCourse/recommended";
  static const String learnerCourseApproved = "LearnerCourse/approved";
  static const String learnerCourseApprovedByCategories = "LearnerCourse/approved/by-categories";
  static const String learnerCourseApprovedByCategory = "LearnerCourse/approved/by-category";
  static const String course = "Course";

  // --- Categories ---
  static const String category = "Category";
  static const String categoryTop = "Category/top";

  // --- Instructors ---
  static const String instructor = "Instructor";
  static const String instructorTop = "Instructor/top";

  // --- Course Progress ---
  static const String courseProgress = "CourseProgress";
  static const String courseProgressMarkCompleted = "CourseProgress/mark-completed";
  static const String courseProgressMarkIncomplete = "CourseProgress/mark-incomplete";
  static const String courseProgressLectureStatus = "CourseProgress/lecture";

  // --- Lecture Comments & Discussions ---
  static const String comments = "Comments";
  static const String commentsLecture = "Comments/lecture";

  // --- Course Ratings & Reviews ---
  static const String ratings = "Ratings";
  static const String ratingsCourse = "Ratings/course";
  static const String ratingsCanRate = "Ratings/can-rate";

  // --- Enrollment & Learning ---
  static const String enrollment = "Enrollment";
  static const String myCourses = "Enrollment";

  // --- Cart & Wishlist ---
  static const String cart = "Cart";
  static const String cartItems = "Cart/items";
  static const String cartClear = "Cart/clear";
  static const String wishlist = "Wishlist";
  static const String wishlistCheck = "Wishlist/check";

  // --- Certificates ---
  static const String certificates = "Certificates";
  static const String myCertificates = "Certificates/my";
  static const String verifyCertificate = "Certificates/verify";
  static const String downloadCertificate = "Certificates/download";

  // --- User Profile & Account Settings ---
  static const String profile = "Profile";
  static const String profileUploadImage = "Profile/upload-image";
  static const String learnerProfile = "learner/profile";
  static const String settings = "Settings";
  static const String changePassword = "Settings/change-password";
  static const String twoFactorStatus = "Settings/two-factor/status";
  static const String twoFactorSetup = "Settings/two-factor/setup";
  static const String twoFactorEnable = "Settings/two-factor/enable";
  static const String twoFactorDisable = "Settings/two-factor/disable";
  static const String activeSessions = "Settings/active-sessions";
  static const String revokeSession = "Settings/active-sessions/revoke";
  static const String revokeAllSessions = "Settings/active-sessions/revoke-all";

  // --- Payment & Refunds ---
  static const String payment = "Payment";
  static const String userPayments = "Payment/user-payments";
  static const String refund = "Payment/refund";
  static const String createPaymentIntent = "Payment/create-payment-intent";
  static const String confirmPayment = "Payment/confirm-payment";
  static const String createCheckoutSession = "Payment/create-checkout-session";
  static const String paymentUserData = "Payment/user-data";
  static const String stripePublishableKey = "pk_test_51S7GqdCqTufWux0JBFHAvznc9T07iHHyIUBOYl8FQoIkwp4WPj5jCP6uqt3ynHqqVGDjOt3NtDwFA1SpJ9iTcNYd00gSFPnDdc";

  // --- Notifications & Search ---
  static const String notifications = "Notifications";
  static const String notificationsSummary = "Notifications/summary";
  static const String notificationsUnreadCount = "Notifications/unread-count";
  static const String notificationsMarkAllRead = "Notifications/mark-all-read";
  static const String notificationsDeleteAll = "Notifications/delete-all";
  static const String notificationsDeviceToken = "Notifications/device-token";
  static const String notificationsTestPush = "Notifications/test-push";
  static const String search = "learner/search";

  // --- Support ---
  static const String supportConversations = "support/conversations";
  static const String supportUnreadCount = "support/unread-count";

  // --- Instructor Application ---
  static const String instructorApplication = "InstructorApplication";
  static const String instructorApplicationApply = "InstructorApplication/apply";
  static const String instructorApplicationMyApplications = "InstructorApplication/my-applications";
  static const String instructorApplicationDetails = "InstructorApplication/application-details";

  // --- Legal & About ---
  static const String legalAbout = "Legal/about";
  static const String legalPrivacy = "Legal/privacy-policy";
  static const String legalTerms = "Legal/terms";
  static const String legalAll = "Legal/all";

  // --- Dynamic Path Helpers ---
  static String courseDetailsPath(int courseId) => '$course/$courseId';
  static String categoryCoursesPath(int categoryId) => '$learnerCourseApprovedByCategory/$categoryId';
  static String topCategoriesPath(int count) => '$categoryTop?count=$count';
  static String topInstructorsPath(int count) => '$instructorTop/$count';

  static String courseProgressPath(int courseId) => '$courseProgress/course/$courseId/progress';
  static String lectureStatusesPath(int courseId) => '$courseProgress/course/$courseId/lecture-statuses';
  static String lectureStatusPath(int lectureId) => '$courseProgressLectureStatus/$lectureId/status';

  static String lectureCommentsPath(int lectureId) => '$commentsLecture/$lectureId';
  static String commentRepliesPath(int commentId) => '$comments/$commentId/reply';
  static String commentItemPath(int commentId) => '$comments/$commentId';

  static String ratingsCoursePath(int courseId) => '$ratingsCourse/$courseId';
  static String ratingsSummaryPath(int courseId) => '$ratingsCourse/$courseId/summary';
  static String ratingsMyRatingPath(int courseId) => '$ratingsCourse/$courseId/my-rating';
  static String ratingsCanRatePath(int courseId) => '$ratingsCanRate/$courseId';
  static String ratingItemPath(int ratingId) => '$ratings/$ratingId';

  static String enrollmentCoursePath(int courseId) => '$enrollment/course/$courseId';
  static String enrollmentCheckPath(int courseId) => '$enrollment/check/$courseId';

  static String cartItemPath(int cartItemId) => '$cartItems/$cartItemId';
  static String wishlistItemPath(int courseId) => '$wishlist/$courseId';
  static String wishlistCheckPath(int courseId) => '$wishlistCheck/$courseId';

  static String verifyCertificatePath(String code) => '$verifyCertificate/$code';
  static String downloadCertificatePath(String code) => '$downloadCertificate/$code';
  static String revokeSessionPath(String sessionId) => '$revokeSession/$sessionId';

  static String notificationMarkReadPath(int id) => '$notifications/$id/read';
  static String notificationItemPath(int id) => '$notifications/$id';

  static String supportConversationMessagesPath(int id) => 'support/conversations/$id/messages';
  static String supportConversationClosePath(int id) => 'support/conversations/$id/close';
  static String supportConversationReopenPath(int id) => 'support/conversations/$id/reopen';

  static String get supportHubUrl {
    final cleanBase = baseUrl.replaceAll('/api/', '').replaceAll('/api', '').replaceAll(RegExp(r'/+$'), '');
    return '$cleanBase/hubs/support';
  }

  /// Build a full absolute URL for a given relative endpoint path
  static String fullUrl(String path) {
    final cleanBase = baseUrl.endsWith('/') ? baseUrl : '$baseUrl/';
    final cleanPath = path.startsWith('/') ? path.substring(1) : path;
    return '$cleanBase$cleanPath';
  }

  /// Utility to normalize image URLs returned by the backend
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
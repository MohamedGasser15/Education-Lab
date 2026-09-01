// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get onboardingSkip => 'Skip';

  @override
  String get onboardingTitle1 => 'Welcome to EduLab';

  @override
  String get onboardingSubtitle1 =>
      'Your ideal platform for modern interactive learning and continuous professional growth.';

  @override
  String get onboardingTitle2 => 'Learn from Top Instructors';

  @override
  String get onboardingSubtitle2 =>
      'Thousands of professional courses in programming, design, business, and data science. High quality with a clear roadmap.';

  @override
  String get onboardingTitle3 => 'Certificates & Guaranteed Success';

  @override
  String get onboardingSubtitle3 =>
      'Track your progress, pass the tests, and earn recognized certificates that open your career doors.';

  @override
  String get onboardingNext => 'Next';

  @override
  String get onboardingStart => 'Get Started';

  @override
  String get splashAppName => 'Education Lab';

  @override
  String get splashTagline => 'Smart Learning Platform';

  @override
  String get loginTagline => 'Welcome to the smart learning platform';

  @override
  String get loginAppName => 'EduLab';

  @override
  String get loginTabLogin => 'Sign In';

  @override
  String get loginTabRegister => 'New Account';

  @override
  String get loginEmailLabel => 'Email';

  @override
  String get loginEmailHint => 'example@email.com';

  @override
  String get loginPasswordLabel => 'Password';

  @override
  String get loginPasswordHint => '••••••';

  @override
  String get loginForgotPassword => 'Forgot your password?';

  @override
  String get loginSubmit => 'Sign In';

  @override
  String get loginSubmitLoading => 'Signing in';

  @override
  String get loginGuest => 'Join as Guest';

  @override
  String get loginOr => 'or';

  @override
  String get loginEmailRequired => 'Email is required';

  @override
  String get loginEmailInvalid => 'Enter a valid email address';

  @override
  String get loginPasswordRequired => 'Password is required';

  @override
  String get registerStepEmail => 'Email';

  @override
  String get registerStepCode => 'Code';

  @override
  String get registerStepData => 'Details';

  @override
  String get registerSendCodeInfo =>
      'We\'ll send an activation code to this email';

  @override
  String get registerSendCode => 'Send Activation Code';

  @override
  String get registerVerifying => 'Verifying';

  @override
  String get registerCodeSentTo => 'Code sent to:';

  @override
  String get registerResendCode => 'Resend Code';

  @override
  String get registerBack => 'Back';

  @override
  String get registerVerifyCode => 'Verify Code';

  @override
  String get registerCodeIncomplete => 'Enter the complete 6-digit code';

  @override
  String get registerFullNameLabel => 'Full Name';

  @override
  String get registerFullNameHint => 'Your full name';

  @override
  String get registerPasswordHint =>
      'At least 8 characters, one uppercase and one number';

  @override
  String get registerConfirmLabel => 'Confirm Password';

  @override
  String get registerConfirmHint => 'Re-enter your password';

  @override
  String get registerSubmit => 'Create Account';

  @override
  String get registerSubmitLoading => 'Creating account';

  @override
  String get registerSuccess => 'Account created successfully';

  @override
  String get registerNameRequired => 'Full name is required';

  @override
  String get registerNameMinLength => 'Full name must be at least 6 characters';

  @override
  String get registerPasswordMinLength =>
      'Password must be at least 8 characters';

  @override
  String get registerPasswordUppercase =>
      'Password must contain at least one uppercase letter';

  @override
  String get registerPasswordNumber =>
      'Password must contain at least one number';

  @override
  String get registerConfirmRequired => 'Password confirmation is required';

  @override
  String get registerConfirmMismatch => 'Passwords do not match';

  @override
  String get networkError => 'Connection error, please try again';

  @override
  String homeGreeting(String name) {
    return 'Hello, $name!';
  }

  @override
  String get homeSubtitle => 'What do you want to learn today?';

  @override
  String get homeSearchHint => 'Search for a course or skill...';

  @override
  String get homeSectionContinue => 'Continue Learning';

  @override
  String get homeSectionRecommended => 'Recommended for You';

  @override
  String get homeSectionPopular => 'Most Popular';

  @override
  String get homeSectionTopRated => 'Top Rated';

  @override
  String get homeSectionByCategory => 'By Category';

  @override
  String get homeHeroTitle => 'Explore Offers Now';

  @override
  String get homeHeroSubtitle => 'Up to 70% off on premium courses';

  @override
  String get homeHeroButton => 'Discover Now';

  @override
  String get homeViewAll => 'View All';

  @override
  String get homeProgressLabel => 'Complete';

  @override
  String get exploreTitle => 'Explore Courses';

  @override
  String get exploreSearchHint => 'Search for a course, skill or instructor...';

  @override
  String get exploreAllCategories => 'All Categories';

  @override
  String get exploreFilter => 'Filter';

  @override
  String get exploreSort => 'Sort';

  @override
  String get exploreNoResults => 'No Results Found';

  @override
  String get exploreNoResultsHint =>
      'Try different keywords or change the filter';

  @override
  String exploreCoursesCount(int count) {
    return '$count courses';
  }

  @override
  String get exploreFilterTitle => 'Filter Results';

  @override
  String get exploreFilterApply => 'Apply Filter';

  @override
  String get exploreFilterReset => 'Reset';

  @override
  String get exploreFilterPrice => 'Price';

  @override
  String get exploreFilterLevel => 'Level';

  @override
  String get exploreFilterRating => 'Rating';

  @override
  String get exploreFilterDuration => 'Duration';

  @override
  String get exploreSortTitle => 'Sort By';

  @override
  String get exploreSortRelevance => 'Most Relevant';

  @override
  String get exploreSortNewest => 'Newest';

  @override
  String get exploreSortPopular => 'Most Popular';

  @override
  String get exploreSortRating => 'Highest Rated';

  @override
  String get exploreSortPriceLow => 'Price: Low to High';

  @override
  String get exploreSortPriceHigh => 'Price: High to Low';

  @override
  String get explorePriceFree => 'Free';

  @override
  String get exploreLevelBeginner => 'Beginner';

  @override
  String get exploreLevelIntermediate => 'Intermediate';

  @override
  String get exploreLevelAdvanced => 'Advanced';

  @override
  String get learningTitle => 'My Learning';

  @override
  String get learningTabInProgress => 'In Progress';

  @override
  String get learningTabCompleted => 'Completed';

  @override
  String get learningTabSaved => 'Saved';

  @override
  String get learningEmpty => 'No courses yet';

  @override
  String get learningEmptyHint => 'Start exploring courses now';

  @override
  String get learningExploreButton => 'Explore Courses';

  @override
  String learningProgress(int percent) {
    return '$percent% complete';
  }

  @override
  String get learningContinue => 'Continue';

  @override
  String get learningViewCertificate => 'View Certificate';

  @override
  String get learningReview => 'Rate Course';

  @override
  String get learningLesson => 'Lesson';

  @override
  String get learningLessons => 'Lessons';

  @override
  String get cartTitle => 'Cart';

  @override
  String get cartEmpty => 'Your cart is empty';

  @override
  String get cartEmptyHint => 'Add some courses to start your learning journey';

  @override
  String get cartExploreButton => 'Explore Courses';

  @override
  String get cartPromoPlaceholder => 'Enter promo code';

  @override
  String get cartPromoApply => 'Apply';

  @override
  String get cartPromoInvalid => 'Invalid promo code';

  @override
  String get cartSummary => 'Order Summary';

  @override
  String get cartSubtotal => 'Subtotal';

  @override
  String get cartDiscount => 'Discount';

  @override
  String get cartTotal => 'Total';

  @override
  String get cartCheckout => 'Checkout';

  @override
  String cartCourses(int count) {
    return '$count courses';
  }

  @override
  String get cartRemove => 'Remove';

  @override
  String get cartGuarantee => '30-Day Money-Back Guarantee';

  @override
  String get checkoutTitle => 'Checkout';

  @override
  String get checkoutStepPayment => 'Payment';

  @override
  String get checkoutStepReview => 'Review';

  @override
  String get checkoutStepConfirm => 'Confirm';

  @override
  String get checkoutOrderSummary => 'Order Summary';

  @override
  String get checkoutTotal => 'Total';

  @override
  String get checkoutPayNow => 'Pay Now';

  @override
  String get checkoutBack => 'Back';

  @override
  String get checkoutNext => 'Next';

  @override
  String get checkoutSecureSSL => 'Secure payment with 256-bit SSL encryption';

  @override
  String get checkoutSuccessTitle => 'Purchase Successful!';

  @override
  String get checkoutSuccessSubtitle => 'You can now access your course';

  @override
  String get checkoutGoToLearning => 'Go to My Courses';

  @override
  String get checkoutPaymentMethod => 'Payment Method';

  @override
  String get checkoutCardNumber => 'Card Number';

  @override
  String get checkoutCardName => 'Cardholder Name';

  @override
  String get checkoutCardExpiry => 'Expiry Date';

  @override
  String get checkoutCardCVV => 'CVV';

  @override
  String get courseDetailsEnroll => 'Enroll Now';

  @override
  String get courseDetailsBuyNow => 'Buy Now';

  @override
  String get courseDetailsAddToCart => 'Add to Cart';

  @override
  String get courseDetailsAddedToCart => 'Added to Cart';

  @override
  String get courseDetailsAlreadyEnrolled => 'Already Enrolled';

  @override
  String get courseDetailsGoToCourse => 'Go to Course';

  @override
  String get courseDetailsFree => 'Free';

  @override
  String courseDetailsStudents(String count) {
    return '$count students';
  }

  @override
  String get courseDetailsRating => 'Rating';

  @override
  String get courseDetailsReviews => 'Student Reviews';

  @override
  String get courseDetailsLastUpdated => 'Last Updated';

  @override
  String get courseDetailsCurriculum => 'Course Content';

  @override
  String get courseDetailsSection => 'section';

  @override
  String get courseDetailsLessons => 'lessons';

  @override
  String get courseDetailsInstructor => 'Instructor';

  @override
  String get courseDetailsStudentsLabel => 'Students';

  @override
  String get courseDetailsCoursesLabel => 'Courses';

  @override
  String get courseDetailsReviewsLabel => 'Reviews';

  @override
  String get courseDetailsReviewsTitle => 'Student Reviews';

  @override
  String get courseDetailsWhatLearn => 'What You\'ll Learn';

  @override
  String get courseDetailsRequirements => 'Requirements';

  @override
  String get courseDetailsDescription => 'Course Description';

  @override
  String get courseDetailsIncludesTitle => 'This Course Includes';

  @override
  String get courseDetailsHoursVideo => 'hours of video';

  @override
  String get courseDetailsArticles => 'articles';

  @override
  String get courseDetailsMobileAccess => 'Mobile access';

  @override
  String get courseDetailsCertificate => 'Certificate of completion';

  @override
  String get courseDetailsLifetimeAccess => 'Lifetime access';

  @override
  String get lessonPlayerNotes => 'My Notes';

  @override
  String get lessonPlayerResources => 'Resources';

  @override
  String get lessonPlayerDiscussion => 'Discussion';

  @override
  String get lessonPlayerPrev => 'Previous';

  @override
  String get lessonPlayerNext => 'Next';

  @override
  String get lessonPlayerSpeed => 'Speed';

  @override
  String get lessonPlayerQuality => 'Quality';

  @override
  String get lessonPlayerCompleted => 'Lesson Completed';

  @override
  String get certificateTitle => 'Certificate of Completion';

  @override
  String get certificatePresentedTo => 'Presented to';

  @override
  String get certificateCompletedCourse => 'for successfully completing';

  @override
  String get certificateIssuedOn => 'Issued on';

  @override
  String get certificateVerificationId => 'Verification ID';

  @override
  String get certificateDownloadPDF => 'Download PDF';

  @override
  String get certificateDownloadPNG => 'Download Image';

  @override
  String get certificateCopyLink => 'Copy Verification Link';

  @override
  String get certificateLinkCopied => 'Link copied';

  @override
  String get profileTitle => 'Profile';

  @override
  String get profileEditProfile => 'Edit Profile';

  @override
  String get profileCourses => 'My Courses';

  @override
  String get profileCertificates => 'Certificates';

  @override
  String get profilePoints => 'Points';

  @override
  String get profileFollowers => 'Followers';

  @override
  String get profileFollowing => 'Following';

  @override
  String get profileBio => 'Bio';

  @override
  String get profileInstructor => 'Instructor';

  @override
  String get profileStudent => 'Student';

  @override
  String get profileLevel => 'Level';

  @override
  String get profileJoined => 'Joined';

  @override
  String get profileShareProfile => 'Share Profile';

  @override
  String get profileMenuLearning => 'My Courses';

  @override
  String get profileMenuCertificates => 'My Certificates';

  @override
  String get profileMenuPurchaseHistory => 'Purchase History';

  @override
  String get profileMenuTeachApplication => 'Teach on EduLab';

  @override
  String get profileMenuAccountSecurity => 'Account Security';

  @override
  String get profileMenuNotifications => 'Notifications';

  @override
  String get profileMenuMessages => 'Messages';

  @override
  String get profileMenuSettings => 'Settings';

  @override
  String get profileMenuSchedule => 'My Schedule';

  @override
  String get profileMenuAssignments => 'Assignments';

  @override
  String get profileMenuQuiz => 'Quizzes';

  @override
  String get profileMenuLogout => 'Sign Out';

  @override
  String get profileLogoutConfirm => 'Are you sure you want to sign out?';

  @override
  String get profileLogoutYes => 'Yes, Sign Out';

  @override
  String get profileLogoutNo => 'Cancel';

  @override
  String get editProfileTitle => 'Edit Profile';

  @override
  String get editProfileSave => 'Save Changes';

  @override
  String get editProfileFullName => 'Full Name';

  @override
  String get editProfileBio => 'Bio';

  @override
  String get editProfileEmail => 'Email';

  @override
  String get editProfilePhone => 'Phone Number';

  @override
  String get editProfileWebsite => 'Website';

  @override
  String get editProfileSaved => 'Changes saved successfully';

  @override
  String get accountSecurityTitle => 'Account Security';

  @override
  String get accountSecurityChangePassword => 'Change Password';

  @override
  String get accountSecurityTwoFactor => 'Two-Factor Authentication';

  @override
  String get accountSecurityActiveSessions => 'Active Sessions';

  @override
  String get accountSecurityDeleteAccount => 'Delete Account';

  @override
  String get purchaseHistoryTitle => 'Purchase History';

  @override
  String get purchaseHistoryEmpty => 'No purchases yet';

  @override
  String get purchaseHistoryGuarantee => '30-Day Money-Back Guarantee';

  @override
  String get purchaseHistoryDate => 'Transaction Date';

  @override
  String get purchaseHistoryStatus => 'Status';

  @override
  String get purchaseHistoryAmount => 'Amount';

  @override
  String get purchaseHistoryCompleted => 'Completed';

  @override
  String get purchaseHistoryRefunded => 'Refunded';

  @override
  String get teachApplicationTitle => 'Teach on EduLab';

  @override
  String get teachApplicationSubmit => 'Submit Application';

  @override
  String get teachApplicationSent =>
      'Your application was submitted successfully';

  @override
  String get notificationsTitle => 'Notifications';

  @override
  String get notificationsMarkAllRead => 'Mark All as Read';

  @override
  String get notificationsMarkAllReadSnackbar =>
      'All notifications marked as read';

  @override
  String get notificationsEmpty => 'No notifications';

  @override
  String get notification1Title => 'Reminder: Continue Your Course';

  @override
  String get notification1Message =>
      'You have a new lesson in Flutter for Beginners';

  @override
  String get notification1Time => '5 minutes ago';

  @override
  String get notification1Action => 'Resume Course';

  @override
  String get notification2Title => 'Your Certificate is Ready!';

  @override
  String get notification2Message =>
      'You completed the UX/UI Design course. Your certificate is available';

  @override
  String get notification2Time => '2 hours ago';

  @override
  String get notification2Action => 'View Certificate';

  @override
  String get notification3Title => 'Exclusive Offer for You';

  @override
  String get notification3Message =>
      '70% off on programming courses for a limited time';

  @override
  String get notification3Time => '1 day ago';

  @override
  String get notification3Action => 'Explore Offer';

  @override
  String get notification4Title => 'New Reply to Your Question';

  @override
  String get notification4Message =>
      'The instructor replied to your question in the React Hooks lesson';

  @override
  String get notification4Time => '2 days ago';

  @override
  String get notification4Action => 'View Reply';

  @override
  String get notification5Title => 'Course Update';

  @override
  String get notification5Message =>
      'New content was added to the Advanced Python course';

  @override
  String get notification5Time => '3 days ago';

  @override
  String get messagesTitle => 'Messages';

  @override
  String get settingsTitle => 'Settings & Preferences';

  @override
  String get settingsVideoDownload => 'Video & Download';

  @override
  String get settingsDownloadQuality => 'Default Video Download Quality';

  @override
  String get settingsWifiOnly => 'Download via Wi-Fi Only';

  @override
  String get settingsNotifications => 'Notifications & Alerts';

  @override
  String get settingsCourseNotifications => 'Course & Message Notifications';

  @override
  String get settingsPromoNotifications => 'Exclusive Offers & Discounts';

  @override
  String get settingsAppearance => 'Appearance & Language';

  @override
  String get settingsDarkMode => 'Dark Mode';

  @override
  String get settingsDarkModeEnabled =>
      'Enabled (saves battery, easy on the eyes)';

  @override
  String get settingsDarkModeDisabled => 'Disabled (light mode)';

  @override
  String get settingsLanguage => 'App Language';

  @override
  String get settingsStorage => 'Storage & Cache';

  @override
  String get settingsClearCache => 'Clear Cache';

  @override
  String get settingsClearCacheSuccess => 'Cache cleared successfully';

  @override
  String get settingsHelp => 'Info & Policies';

  @override
  String get settingsHelpCenter => 'Help Center & FAQ';

  @override
  String get settingsTermsPrivacy => 'Terms of Use & Privacy Policy';

  @override
  String get settingsAbout => 'About EduLab';

  @override
  String get settingsVersion => 'Version v1.0.0';

  @override
  String get quizTitle => 'Quiz';

  @override
  String get quizNext => 'Next Question';

  @override
  String get quizSubmit => 'Submit Quiz';

  @override
  String get quizScore => 'Quiz Score';

  @override
  String get quizCorrectAnswers => 'Correct Answers';

  @override
  String get scheduleTitle => 'My Schedule';

  @override
  String get scheduleEmpty => 'No scheduled sessions';

  @override
  String get scheduleJoin => 'Join Session';

  @override
  String get scheduleReminder => 'Reminder';

  @override
  String get assignmentsTitle => 'Assignments';

  @override
  String get assignmentsEmpty => 'No assignments';

  @override
  String get assignmentsSubmit => 'Submit Assignment';

  @override
  String get assignmentsDue => 'Due Date';

  @override
  String get assignmentsSubmitted => 'Submitted';

  @override
  String get assignmentsPending => 'Pending';

  @override
  String get languageArabic => 'Arabic';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageDialogTitle => 'Select App Language';

  @override
  String get languageSelect => 'Select';

  @override
  String get generalCancel => 'Cancel';

  @override
  String get generalConfirm => 'Confirm';

  @override
  String get generalSave => 'Save';

  @override
  String get generalDelete => 'Delete';

  @override
  String get generalEdit => 'Edit';

  @override
  String get generalClose => 'Close';

  @override
  String get generalBack => 'Back';

  @override
  String get generalDone => 'Done';

  @override
  String get generalOk => 'OK';

  @override
  String get generalYes => 'Yes';

  @override
  String get generalNo => 'No';

  @override
  String get generalLoading => 'Loading...';

  @override
  String get generalError => 'An error occurred';

  @override
  String get generalRetry => 'Retry';

  @override
  String get generalNoInternet => 'No internet connection';

  @override
  String get generalFree => 'Free';

  @override
  String get generalRating => 'Rating';

  @override
  String get generalStudents => 'Students';

  @override
  String get generalHours => 'Hours';

  @override
  String get generalMinutes => 'Minutes';

  @override
  String get generalBy => 'By';

  @override
  String get navHome => 'Home';

  @override
  String get navExplore => 'Explore';

  @override
  String get navMyCourses => 'My Courses';

  @override
  String get navCart => 'Cart';

  @override
  String get navAccount => 'Account';

  @override
  String get homeSubGreeting => 'What do you want to learn today?';

  @override
  String get homeVisitor => 'Guest';

  @override
  String get homePromoTitle => 'Explore Offers Now';

  @override
  String get homePromoSubtitle => 'Up to 70% off on premium courses';

  @override
  String get homePromoButton => 'Discover Now';

  @override
  String get homePromoBadge => 'Exclusive Offer';

  @override
  String get homeContinueLearning => 'Continue Learning';

  @override
  String get homeMyCoursesLink => 'My Courses';

  @override
  String get homeLesson => 'Lesson';

  @override
  String homeStudentsCount(String count) {
    return '$count students';
  }

  @override
  String get homeRecommendedTitle => 'Recommended for You';

  @override
  String get homeRecommendedSubtitle => 'Personalized based on your interests';

  @override
  String get homeBestsellersTitle => 'Bestsellers';

  @override
  String get homeBestsellersSubtitle => 'Top-rated and most popular courses';

  @override
  String get homeNewCoursesTitle => 'New Courses';

  @override
  String get homeNewCoursesSubtitle => 'Fresh and updated content';

  @override
  String get homePopularTopicsTitle => 'Popular Topics';

  @override
  String get homePopularTopicsSubtitle =>
      'Start learning the most in-demand skills';

  @override
  String get homeTopInstructorsTitle => 'Top Instructors';

  @override
  String get homeTopInstructorsSubtitle => 'Learn from certified experts';

  @override
  String get homeExploreCategoriesTitle => 'Explore Categories';

  @override
  String get homeExploreCategoriesSubtitle => 'Find the right course for you';

  @override
  String get catAll => 'All';

  @override
  String get catWebDev => 'Web Development';

  @override
  String get catMobileApps => 'Mobile Apps';

  @override
  String get catDataScience => 'Data Science';

  @override
  String get catUIUX => 'UI/UX Design';

  @override
  String get catBusiness => 'Business';

  @override
  String get catAI => 'Artificial Intelligence';

  @override
  String get catCyberSecurity => 'Cybersecurity';

  @override
  String get exploreNoResultsTitle => 'No Results Found';

  @override
  String get exploreNoResultsSubtitle =>
      'Try different keywords or change the filter';

  @override
  String get exploreRecentSearches => 'Recent Searches';

  @override
  String get exploreTopSearches => 'Top Searches';

  @override
  String get exploreBrowseCategories => 'Browse Categories';

  @override
  String get exploreBrowseCategoriesSubtitle => 'Find the right course for you';

  @override
  String get exploreBackToAll => 'Back to All';

  @override
  String get exploreClearAll => 'Clear All';

  @override
  String get exploreAvailableResults => 'result available';

  @override
  String get exploreFilterBestseller => 'Bestseller';

  @override
  String get exploreFilterTopRated => 'Top Rated';

  @override
  String get exploreFilterUnder50 => 'Under \$50';

  @override
  String get learningHeroTitle => 'Continue Your Learning Journey';

  @override
  String get learningSearchHint => 'Search your courses...';

  @override
  String get learningFilterAll => 'All';

  @override
  String get learningFilterInProgress => 'In Progress';

  @override
  String get learningFilterCompleted => 'Completed';

  @override
  String get learningFilterDownloaded => 'Downloaded';

  @override
  String get learningEmptyTitle => 'No courses yet';

  @override
  String get learningEmptySubtitle => 'Start exploring courses now';

  @override
  String get learningEmptySearch => 'No results for your search';

  @override
  String get learningCompleted => 'Completed';

  @override
  String get learningCompletedBadge => 'Completed';

  @override
  String learningLecturesCount(int count) {
    return '$count lectures';
  }

  @override
  String get cartEmptyTitle => 'Your cart is empty';

  @override
  String get cartEmptySubtitle =>
      'Add some courses to start your learning journey';

  @override
  String get cartCouponHint => 'Enter promo code';

  @override
  String get cartCouponApply => 'Apply';

  @override
  String get cartCouponInvalid => 'Invalid promo code';

  @override
  String get cartCouponApplied => 'Promo code applied';

  @override
  String get cartCouponDiscount => 'Coupon discount';

  @override
  String get cartCouponsTitle => 'Coupons';

  @override
  String get cartOrderSummary => 'Order Summary';

  @override
  String get cartOriginalPrice => 'Original Price';

  @override
  String get cartPlatformDiscount => 'Platform Discount';

  @override
  String get cartFinalTotal => 'Total';

  @override
  String cartItemsCount(int count) {
    return '$count courses';
  }

  @override
  String get cartRemovedSnackbar => 'Course removed from cart';

  @override
  String get cartUndo => 'Undo';

  @override
  String get cartAddButton => 'Add to Cart';

  @override
  String get cartAddedSnackbar => 'Added to cart';

  @override
  String get cartAlreadyInCart => 'Already in Cart';

  @override
  String get cartCheckoutButton => 'Checkout';

  @override
  String get cartRecommendedTitle => 'You might also like';

  @override
  String get cartRecommendedSubtitle =>
      'Courses recommended based on your cart';

  @override
  String get checkoutCreditCard => 'Credit Card';

  @override
  String get checkoutSelectPayment => 'Select Payment Method';

  @override
  String get checkoutCardNumberLabel => 'Card Number';

  @override
  String get checkoutCardHolderLabel => 'Cardholder Name';

  @override
  String get checkoutExpiryLabel => 'Expiry Date';

  @override
  String get checkoutCVVLabel => 'CVV';

  @override
  String get checkoutPersonalInfoTitle => 'Personal Information';

  @override
  String get checkoutFullNameLabel => 'Full Name';

  @override
  String get checkoutFullNameHint => 'Your full name';

  @override
  String get checkoutFullNameRequired => 'Full name is required';

  @override
  String get checkoutPhoneLabel => 'Phone Number';

  @override
  String get checkoutPhoneRequired => 'Phone number is required';

  @override
  String get checkoutPostalLabel => 'Postal Code';

  @override
  String get checkoutPostalRequired => 'Postal code is required';

  @override
  String get checkoutBuyerInfo => 'Buyer Information';

  @override
  String get checkoutSaveInfo => 'Save info for next time';

  @override
  String get checkoutMoneyBackGuarantee => '30-Day Money-Back Guarantee';

  @override
  String get checkoutContinueToPayment => 'Continue to Payment';

  @override
  String get checkoutContinueToReview => 'Continue to Review';

  @override
  String get checkoutReviewConfirm => 'Review & Confirm';

  @override
  String get checkoutStartLearning => 'Start Learning';

  @override
  String get checkoutBackHome => 'Back to Home';

  @override
  String get courseDetailsTitle => 'Course Details';

  @override
  String get courseDetailsShare => 'Share';

  @override
  String get courseDetailsWhatYouWillLearn => 'What You\'ll Learn';

  @override
  String get courseDetailsLanguage => 'Language';

  @override
  String get courseDetailsCreatedBy => 'Created by';

  @override
  String get courseDetailsPreviewLesson => 'Preview Lesson';

  @override
  String get courseDetailsHoursOnDemand => 'hours on-demand video';

  @override
  String get courseDetailsFullLifetimeAccess => 'Full lifetime access';

  @override
  String get courseDetailsCertifiedCertificate => 'Certificate of completion';

  @override
  String get courseDetailsComprehensiveContent => 'Comprehensive content';

  @override
  String get certTitle => 'Certificate of Completion';

  @override
  String get certStudentNameLabel => 'Student';

  @override
  String get certCourseLabel => 'Course';

  @override
  String get certInstructorLabel => 'Instructor';

  @override
  String get certIssueDateLabel => 'Issue Date';

  @override
  String get certCodeLabel => 'Certificate ID';

  @override
  String get certVerifiedBadge => 'Verified';

  @override
  String get certDownloadPDF => 'Download PDF';

  @override
  String get certDownloadPNG => 'Download Image';

  @override
  String get certCopyVerifyLink => 'Copy Verification Link';

  @override
  String get certShare => 'Share Certificate';

  @override
  String get playerTabLessons => 'Lessons';

  @override
  String get playerTabOverview => 'Overview';

  @override
  String get playerTabNotes => 'My Notes';

  @override
  String get playerTabQnA => 'Q&A';

  @override
  String get playerNextLesson => 'Next Lesson';

  @override
  String get profileWelcome => 'Welcome';

  @override
  String get profileLoginPrompt => 'Sign in to access your profile';

  @override
  String get profileLoginOrRegister => 'Sign In / Create Account';

  @override
  String get profileVerifiedStudent => 'Verified Student';

  @override
  String get profileLogout => 'Sign Out';

  @override
  String get profileCancel => 'Cancel';

  @override
  String get profileLogoutConfirmTitle => 'Sign Out';

  @override
  String get profileLogoutConfirmMessage =>
      'Are you sure you want to sign out?';

  @override
  String get profileAccountSettings => 'Account Settings';

  @override
  String get profileEditProfileSubtitle => 'Edit your personal information';

  @override
  String get profileSecurity => 'Account Security';

  @override
  String get profileSecuritySubtitle => 'Password & verification';

  @override
  String get profilePurchaseHistory => 'Purchase History';

  @override
  String get profilePurchaseHistorySubtitle => 'View transaction history';

  @override
  String get profileCertificatesSubtitle => 'Your earned certificates';

  @override
  String get profileTeach => 'Teach on EduLab';

  @override
  String get profileTeachSubtitle => 'Share your expertise with others';

  @override
  String get profilePreferences => 'Preferences';

  @override
  String get profilePreferencesSubtitle => 'Settings & appearance';

  @override
  String get profileNotifications => 'Notifications';

  @override
  String get profileNotificationsSubtitle => 'Manage notifications & alerts';

  @override
  String get profileHelpSupport => 'Help & Support';

  @override
  String get profileTerms => 'Terms of Use';

  @override
  String get profilePrivacy => 'Privacy Policy';

  @override
  String get profileAboutEduLab => 'About EduLab';

  @override
  String get profileWishlist => 'Wishlist';

  @override
  String get securityTitle => 'Account Security';

  @override
  String get teachTitle => 'Teach on EduLab';

  @override
  String get notificationsTabAll => 'All';

  @override
  String get notificationsTabCourses => 'Courses';

  @override
  String get notificationsTabPromos => 'Offers';

  @override
  String get notificationsEmptyTitle => 'No notifications';

  @override
  String get notificationsUnread => 'Unread';

  @override
  String get wishlistTitle => 'Wishlist';

  @override
  String get wishlistEmptyTitle => 'Your wishlist is empty';

  @override
  String get wishlistEmptySubtitle => 'Save courses you\'re interested in';

  @override
  String get wishlistAddToCart => 'Add to Cart';

  @override
  String get wishlistRemovedSnackbar => 'Removed from wishlist';

  @override
  String get homeDefaultUser => 'Student';

  @override
  String get learningOf => 'of';

  @override
  String get cartInCartBadge => 'In Cart';

  @override
  String get homePromo1Badge => 'Big Sale • Limited Time';

  @override
  String get homePromo1Title => 'Start Learning at the Best Prices';

  @override
  String get homePromo1Subtitle =>
      'Up to 65% off on programming, design, and business courses.';

  @override
  String get homePromo1Button => 'Browse Deals';

  @override
  String get homePromo2Badge => 'Certified Career Tracks';

  @override
  String get homePromo2Title => 'Prepare for Your Dream Tech Career';

  @override
  String get homePromo2Subtitle =>
      'Complete zero-to-mastery courses with real-world projects and certificates.';

  @override
  String get homePromo2Button => 'Explore Tracks';

  @override
  String get homePromo3Badge => 'Top Industry Instructors';

  @override
  String get homePromo3Title => 'Learn Directly from Proven Experts';

  @override
  String get homePromo3Subtitle =>
      'Constantly updated high-quality content to keep you ahead in modern tech.';

  @override
  String get homePromo3Button => 'Start Learning Now';

  @override
  String get homeSearchFilter => 'Filter';

  @override
  String get securitySectionChangePassword => 'Change Password';

  @override
  String get securityCurrentPasswordLabel => 'Current Password *';

  @override
  String get securityCurrentPasswordError => 'Enter current password';

  @override
  String get securityNewPasswordLabel => 'New Password *';

  @override
  String get securityNewPasswordError => 'Must be at least 8 characters';

  @override
  String get securityConfirmPasswordLabel => 'Confirm New Password *';

  @override
  String get securityConfirmPasswordError => 'Passwords do not match';

  @override
  String get securityUpdatePasswordBtn => 'Update Password';

  @override
  String get securityPasswordUpdatedSuccess => 'Password changed successfully!';

  @override
  String get securitySection2FA => 'Two-Factor Authentication (2FA)';

  @override
  String get security2FATitle => 'Two-Factor Authentication';

  @override
  String get security2FAEnabledDesc =>
      'Enabled - Secures your account with a code';

  @override
  String get security2FADisabledDesc => 'Disabled (Recommended)';

  @override
  String get security2FASetupTitle => 'Enable Two-Factor Authentication';

  @override
  String get security2FASetupContent =>
      'A 6-digit verification code will be sent to your email on new logins.';

  @override
  String get security2FAEnableNow => 'Enable Now';

  @override
  String get security2FAEnabledSuccess =>
      'Two-Factor Authentication enabled successfully!';

  @override
  String get security2FADisabledSuccess => 'Two-Factor Authentication disabled';

  @override
  String get securitySectionSessions => 'Active Sessions & Devices';

  @override
  String get securityLogoutAllDevices => 'Log Out All Devices';

  @override
  String get securityThisDevice => 'This Device';

  @override
  String get securitySessionRevokedSuccess =>
      'Session ended and device logged out.';

  @override
  String get securityAllSessionsRevokedSuccess =>
      'Logged out from all other devices.';

  @override
  String get purchaseHistoryInvoiceCertified => 'Certified E-Invoice';

  @override
  String get purchaseHistoryInvoiceNumber => 'Invoice Number';

  @override
  String get purchaseHistoryCourse => 'Course';

  @override
  String get purchaseHistoryPaymentMethod => 'Payment Method';

  @override
  String get purchaseHistoryTotalAmount => 'Total Amount:';

  @override
  String get purchaseHistoryClose => 'Close';

  @override
  String get purchaseHistoryDownloadPdf => 'Download PDF';

  @override
  String get purchaseHistoryPdfDownloaded =>
      'Invoice PDF downloaded successfully';

  @override
  String get purchaseHistoryRefundRequestTitle => 'Request a Refund';

  @override
  String get purchaseHistoryRefundPolicy =>
      'According to EduLab\'s 30-day money-back guarantee, you can get a full refund to your original payment method.';

  @override
  String get purchaseHistoryRefundReasonHint =>
      'Reason for refund (optional)...';

  @override
  String get purchaseHistoryConfirmRefund => 'Confirm Refund';

  @override
  String get purchaseHistoryRefundSubmitted =>
      'Refund request submitted successfully (3-5 business days).';

  @override
  String get purchaseHistoryInstructor => 'Instructor';

  @override
  String get purchaseHistoryRequestRefundBtn => 'Request Refund';

  @override
  String get purchaseHistoryInvoiceBtn => 'Invoice';

  @override
  String get purchaseHistoryStatusCompleted => 'Completed';

  @override
  String get purchaseHistoryStatusRefunded => 'Refunded';

  @override
  String get purchaseHistoryStatusProcessingRefund => 'Processing Refund';

  @override
  String get editProfileSectionBasicInfo => 'Basic Information';

  @override
  String get editProfileFullNameLabel => 'Full Name *';

  @override
  String get editProfileFullNameHint => 'Enter full name';

  @override
  String get editProfileFullNameError => 'Please enter full name';

  @override
  String get editProfileHeadlineLabel => 'Professional Headline';

  @override
  String get editProfileHeadlineHint => 'e.g. Senior Flutter Developer';

  @override
  String get editProfileLocationLabel => 'City / Country';

  @override
  String get editProfileLocationHint => 'Riyadh, Saudi Arabia';

  @override
  String get editProfilePhoneLabel => 'Mobile Phone';

  @override
  String get editProfileBioLabel => 'About Me (Bio)';

  @override
  String get editProfileBioHint =>
      'Write a brief summary of your interests and experience...';

  @override
  String get editProfileSectionLinks => 'Links & Professional Networks';

  @override
  String get editProfileWebsiteLabel => 'Personal Website';

  @override
  String get editProfileSectionEmail => 'Registered Email';

  @override
  String get editProfileEmailDesc =>
      'Linked to your account for login and certificates';

  @override
  String get editProfileEmailVerified => 'Verified';

  @override
  String get editProfileSaveChangesBtn => 'Save & Update Profile';

  @override
  String get editProfileSavedSuccess => 'Profile updated successfully!';

  @override
  String get editProfileChangeAvatarTitle => 'Change Profile Picture';

  @override
  String get editProfileTakePhoto => 'Take photo with camera';

  @override
  String get editProfileChooseGallery => 'Choose from gallery';

  @override
  String get editProfilePhotoUpdatedSuccess =>
      'Profile picture updated successfully';

  @override
  String get teachJoinInstructorTitle => 'Join as an Instructor';

  @override
  String get teachJoinInstructorSubtitle =>
      'Publish courses and share your expertise with thousands of students.';

  @override
  String get teachStep1Title => 'Personal Info';

  @override
  String get teachStep2Title => 'Experience & Skills';

  @override
  String get teachStep3Title => 'Confirm Application';

  @override
  String get teachStep1Header => '1. Personal & Professional Info';

  @override
  String get teachFullNameArabicLabel => 'Full Name *';

  @override
  String get teachFullNameArabicHint => 'e.g. John Doe';

  @override
  String get teachHeadlineLabel => 'Professional Title *';

  @override
  String get teachHeadlineHint => 'e.g. Senior Software Architect';

  @override
  String get teachPhoneLabel => 'Contact Phone *';

  @override
  String get teachCountryLabel => 'Country of Residence *';

  @override
  String get teachBioLabel => 'Bio & Past Experience *';

  @override
  String get teachBioHint =>
      'Write a brief summary of your career and past projects...';

  @override
  String get teachNextStepSkills => 'Continue: Experience & Skills';

  @override
  String get teachStep2Header => '2. Course Content & Skills';

  @override
  String get teachTopicLabel => 'Proposed Course Topic *';

  @override
  String get teachTopicHint => 'e.g. Flutter Development from Scratch';

  @override
  String get teachYearsExperienceLabel => 'Years of Experience *';

  @override
  String get teachVideoLinkLabel => 'Sample Teaching Video Link *';

  @override
  String get teachTargetAudienceLabel => 'Target Audience *';

  @override
  String get teachAudienceBeginners => 'Complete Beginners';

  @override
  String get teachAudienceIntermediate => 'Beginner & Intermediate';

  @override
  String get teachAudienceAdvanced => 'Advanced & Professional';

  @override
  String get teachAudienceAll => 'All Levels';

  @override
  String get teachSkillsCoveredLabel => 'Skills & Technologies Covered *';

  @override
  String get teachAddSkillHint => 'Add skill (e.g. GraphQL)...';

  @override
  String get teachAddSkillBtn => 'Add';

  @override
  String get teachNextStepConfirm => 'Continue: Confirm Application';

  @override
  String get teachStep3Header => '3. Payout Details & Agreement';

  @override
  String get teachPayoutMethodLabel => 'Payout Method *';

  @override
  String get teachPayoutMethodBank => 'Direct Bank Transfer (IBAN)';

  @override
  String get teachPayoutMethodPaypal => 'Verified PayPal Account';

  @override
  String get teachPayoutMethodPayoneer => 'Payoneer Card';

  @override
  String get teachIbanDetailsLabel => 'Account Details / IBAN *';

  @override
  String get teachApplicationSummary => 'Application Summary:';

  @override
  String get teachApplicantName => 'Applicant';

  @override
  String get teachApplicantHeadline => 'Specialty';

  @override
  String get teachApplicantTopic => 'Course Topic';

  @override
  String get teachApplicantSkillsCount => 'Skills Count';

  @override
  String get teachSkillsUnit => 'skills';

  @override
  String get teachAgreeTermsLabel =>
      'I agree to EduLab\'s instructor terms, conditions, and intellectual property agreement.';

  @override
  String get teachSubmitApplicationBtn => 'Submit Instructor Application';

  @override
  String get teachPrevStepBtn => 'Previous';

  @override
  String get teachWhyEduLabTitle => 'Why Teach on EduLab?';

  @override
  String get teachProp1Title => 'Rewarding & Fair Revenue';

  @override
  String get teachProp1Desc =>
      'Earn up to 80% revenue share from your course sales with no hidden fees.';

  @override
  String get teachProp2Title => 'Reach Thousands of Students';

  @override
  String get teachProp2Desc =>
      'Market your course to a massive active learning community.';

  @override
  String get teachProp3Title => 'Full Production & Tech Support';

  @override
  String get teachProp3Desc =>
      'Our team helps you optimize audio, video quality, and curriculum design.';

  @override
  String get teachSuccessDialogTitle => 'Application Received Successfully!';

  @override
  String get teachSuccessDialogDesc =>
      'Thank you for joining EduLab instructors. Our academic review team will review your application and contact you within 48 hours.';

  @override
  String get teachSuccessDialogOk => 'OK';

  @override
  String get teachAddOneSkillError => 'Please add at least one skill';

  @override
  String get teachAgreeTermsError => 'Please agree to the instructor terms';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonClose => 'Close';
}

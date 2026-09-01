// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get onboardingSkip => 'تخطي';

  @override
  String get onboardingTitle1 => 'مرحبًا بك في EduLab';

  @override
  String get onboardingSubtitle1 =>
      'منصتك المثالية للتعلم التفاعلي الحديث والنمو المهني المستمر.';

  @override
  String get onboardingTitle2 => 'تعلّم من نخبة المدربين';

  @override
  String get onboardingSubtitle2 =>
      'آلاف الدورات الاحترافية في البرمجة والتصميم وإدارة الأعمال وعلوم البيانات، بجودة عالية وخطة واضحة.';

  @override
  String get onboardingTitle3 => 'شهادات ونجاح مضمون';

  @override
  String get onboardingSubtitle3 =>
      'تابع تقدمك، اجتز الاختبارات، واحصل على شهادات معتمدة تفتح لك أبواب المستقبل المهني.';

  @override
  String get onboardingNext => 'التالي';

  @override
  String get onboardingStart => 'ابدأ الآن';

  @override
  String get splashAppName => 'Education Lab';

  @override
  String get splashTagline => 'منصة التعلم الذكي';

  @override
  String get loginTagline => 'مرحباً بك في منصة التعلم الذكي';

  @override
  String get loginAppName => 'EduLab';

  @override
  String get loginTabLogin => 'دخول';

  @override
  String get loginTabRegister => 'حساب جديد';

  @override
  String get loginEmailLabel => 'البريد الإلكتروني';

  @override
  String get loginEmailHint => 'example@email.com';

  @override
  String get loginPasswordLabel => 'كلمة المرور';

  @override
  String get loginPasswordHint => '••••••';

  @override
  String get loginForgotPassword => 'نسيت كلمة المرور؟';

  @override
  String get loginSubmit => 'تسجيل الدخول';

  @override
  String get loginSubmitLoading => 'جاري تسجيل الدخول';

  @override
  String get loginGuest => 'الدخول كضيف';

  @override
  String get loginOr => 'أو';

  @override
  String get loginEmailRequired => 'البريد الإلكتروني مطلوب';

  @override
  String get loginEmailInvalid => 'أدخل بريدًا إلكترونيًا صالحًا';

  @override
  String get loginPasswordRequired => 'كلمة المرور مطلوبة';

  @override
  String get registerStepEmail => 'البريد';

  @override
  String get registerStepCode => 'الكود';

  @override
  String get registerStepData => 'البيانات';

  @override
  String get registerSendCodeInfo => 'هانبعتلك كود تفعيل على البريد ده';

  @override
  String get registerSendCode => 'إرسال كود التفعيل';

  @override
  String get registerVerifying => 'جاري التحقق';

  @override
  String get registerCodeSentTo => 'تم إرسال الكود إلى:';

  @override
  String get registerResendCode => 'إعادة إرسال الكود';

  @override
  String get registerBack => 'رجوع';

  @override
  String get registerVerifyCode => 'تأكيد الكود';

  @override
  String get registerCodeIncomplete => 'أدخل الكود المكون من 6 أرقام كاملًا';

  @override
  String get registerFullNameLabel => 'الاسم الكامل';

  @override
  String get registerFullNameHint => 'اسمك الكامل';

  @override
  String get registerPasswordHint => '8 أحرف على الأقل، حرف كبير ورقم';

  @override
  String get registerConfirmLabel => 'تأكيد كلمة المرور';

  @override
  String get registerConfirmHint => 'أعد كتابة كلمة المرور';

  @override
  String get registerSubmit => 'إنشاء الحساب';

  @override
  String get registerSubmitLoading => 'جاري إنشاء الحساب';

  @override
  String get registerSuccess => 'تم إنشاء الحساب بنجاح';

  @override
  String get registerNameRequired => 'الاسم الكامل مطلوب';

  @override
  String get registerNameMinLength =>
      'يجب أن يكون الاسم الكامل على الأقل 6 أحرف';

  @override
  String get registerPasswordMinLength =>
      'كلمة المرور يجب أن تكون 8 أحرف أو أكثر';

  @override
  String get registerPasswordUppercase =>
      'كلمة المرور يجب أن تحتوي على حرف كبير واحد على الأقل';

  @override
  String get registerPasswordNumber =>
      'كلمة المرور يجب أن تحتوي على رقم واحد على الأقل';

  @override
  String get registerConfirmRequired => 'تأكيد كلمة المرور مطلوب';

  @override
  String get registerConfirmMismatch => 'كلمة المرور وتأكيدها غير متطابقين';

  @override
  String get networkError => 'حدث خطأ في الاتصال، حاول مرة أخرى';

  @override
  String homeGreeting(String name) {
    return 'مرحباً، $name!';
  }

  @override
  String get homeSubtitle => 'ماذا تريد أن تتعلم اليوم؟';

  @override
  String get homeSearchHint => 'ابحث عن دورة أو مهارة...';

  @override
  String get homeSectionContinue => 'تابع التعلم';

  @override
  String get homeSectionRecommended => 'موصى بها لك';

  @override
  String get homeSectionPopular => 'الأكثر شعبية';

  @override
  String get homeSectionTopRated => 'الأعلى تقييمًا';

  @override
  String get homeSectionByCategory => 'حسب التصنيف';

  @override
  String get homeHeroTitle => 'استكشف العروض الآن';

  @override
  String get homeHeroSubtitle => 'خصومات حتى 70٪ على الدورات المميزة';

  @override
  String get homeHeroButton => 'اكتشف الآن';

  @override
  String get homeViewAll => 'عرض الكل';

  @override
  String get homeProgressLabel => 'مكتمل';

  @override
  String get exploreTitle => 'استكشاف الدورات';

  @override
  String get exploreSearchHint => 'ابحث عن دورة، مهارة أو مدرب...';

  @override
  String get exploreAllCategories => 'كل التصنيفات';

  @override
  String get exploreFilter => 'تصفية';

  @override
  String get exploreSort => 'ترتيب';

  @override
  String get exploreNoResults => 'لا توجد نتائج';

  @override
  String get exploreNoResultsHint => 'جرب كلمات بحث مختلفة أو غير التصفية';

  @override
  String exploreCoursesCount(int count) {
    return '$count دورة';
  }

  @override
  String get exploreFilterTitle => 'تصفية النتائج';

  @override
  String get exploreFilterApply => 'تطبيق التصفية';

  @override
  String get exploreFilterReset => 'إعادة الضبط';

  @override
  String get exploreFilterPrice => 'السعر';

  @override
  String get exploreFilterLevel => 'المستوى';

  @override
  String get exploreFilterRating => 'التقييم';

  @override
  String get exploreFilterDuration => 'المدة';

  @override
  String get exploreSortTitle => 'ترتيب حسب';

  @override
  String get exploreSortRelevance => 'الأكثر صلة';

  @override
  String get exploreSortNewest => 'الأحدث';

  @override
  String get exploreSortPopular => 'الأكثر شعبية';

  @override
  String get exploreSortRating => 'الأعلى تقييمًا';

  @override
  String get exploreSortPriceLow => 'السعر: من الأقل للأعلى';

  @override
  String get exploreSortPriceHigh => 'السعر: من الأعلى للأقل';

  @override
  String get explorePriceFree => 'مجاني';

  @override
  String get exploreLevelBeginner => 'مبتدئ';

  @override
  String get exploreLevelIntermediate => 'متوسط';

  @override
  String get exploreLevelAdvanced => 'متقدم';

  @override
  String get learningTitle => 'تعلمي';

  @override
  String get learningTabInProgress => 'قيد التعلم';

  @override
  String get learningTabCompleted => 'مكتملة';

  @override
  String get learningTabSaved => 'محفوظة';

  @override
  String get learningEmpty => 'لا توجد دورات بعد';

  @override
  String get learningEmptyHint => 'ابدأ باستكشاف الدورات الآن';

  @override
  String get learningExploreButton => 'استكشاف الدورات';

  @override
  String learningProgress(int percent) {
    return '$percent٪ مكتمل';
  }

  @override
  String get learningContinue => 'متابعة';

  @override
  String get learningViewCertificate => 'عرض الشهادة';

  @override
  String get learningReview => 'تقييم الدورة';

  @override
  String get learningLesson => 'درس';

  @override
  String get learningLessons => 'دروس';

  @override
  String get cartTitle => 'سلة الشراء';

  @override
  String get cartEmpty => 'السلة فارغة';

  @override
  String get cartEmptyHint => 'أضف بعض الدورات لتبدأ رحلة التعلم';

  @override
  String get cartExploreButton => 'استكشاف الدورات';

  @override
  String get cartPromoPlaceholder => 'أدخل كود الخصم';

  @override
  String get cartPromoApply => 'تطبيق';

  @override
  String get cartPromoInvalid => 'كود الخصم غير صالح';

  @override
  String get cartSummary => 'ملخص الطلب';

  @override
  String get cartSubtotal => 'المجموع الجزئي';

  @override
  String get cartDiscount => 'الخصم';

  @override
  String get cartTotal => 'الإجمالي';

  @override
  String get cartCheckout => 'إتمام الشراء';

  @override
  String cartCourses(int count) {
    return '$count دورة';
  }

  @override
  String get cartRemove => 'حذف';

  @override
  String get cartGuarantee => 'ضمان استرداد المال خلال 30 يومًا';

  @override
  String get checkoutTitle => 'إتمام الشراء';

  @override
  String get checkoutStepPayment => 'الدفع';

  @override
  String get checkoutStepReview => 'المراجعة';

  @override
  String get checkoutStepConfirm => 'التأكيد';

  @override
  String get checkoutOrderSummary => 'ملخص الطلب';

  @override
  String get checkoutTotal => 'الإجمالي';

  @override
  String get checkoutPayNow => 'ادفع الآن';

  @override
  String get checkoutBack => 'رجوع';

  @override
  String get checkoutNext => 'التالي';

  @override
  String get checkoutSecureSSL => 'دفع آمن بتشفير SSL 256-bit';

  @override
  String get checkoutSuccessTitle => 'تم الشراء بنجاح!';

  @override
  String get checkoutSuccessSubtitle => 'أصبح بإمكانك الوصول إلى الدورة الآن';

  @override
  String get checkoutGoToLearning => 'انتقل إلى دوراتي';

  @override
  String get checkoutPaymentMethod => 'طريقة الدفع';

  @override
  String get checkoutCardNumber => 'رقم البطاقة';

  @override
  String get checkoutCardName => 'اسم صاحب البطاقة';

  @override
  String get checkoutCardExpiry => 'تاريخ الانتهاء';

  @override
  String get checkoutCardCVV => 'CVV';

  @override
  String get courseDetailsEnroll => 'سجّل الآن';

  @override
  String get courseDetailsBuyNow => 'اشتري الآن';

  @override
  String get courseDetailsAddToCart => 'أضف إلى السلة';

  @override
  String get courseDetailsAddedToCart => 'تمت الإضافة إلى السلة';

  @override
  String get courseDetailsAlreadyEnrolled => 'مسجّل بالفعل';

  @override
  String get courseDetailsGoToCourse => 'انتقل للدورة';

  @override
  String get courseDetailsFree => 'مجاني';

  @override
  String courseDetailsStudents(String count) {
    return '$count طالب';
  }

  @override
  String get courseDetailsRating => 'التقييم';

  @override
  String get courseDetailsReviews => 'تقييمات الطلاب';

  @override
  String get courseDetailsLastUpdated => 'آخر تحديث';

  @override
  String get courseDetailsCurriculum => 'محتوى الدورة';

  @override
  String get courseDetailsSection => 'قسم';

  @override
  String get courseDetailsLessons => 'دروس';

  @override
  String get courseDetailsInstructor => 'المدرب';

  @override
  String get courseDetailsStudentsLabel => 'طالب';

  @override
  String get courseDetailsCoursesLabel => 'دورات';

  @override
  String get courseDetailsReviewsLabel => 'تقييمات';

  @override
  String get courseDetailsReviewsTitle => 'تقييمات الطلاب';

  @override
  String get courseDetailsWhatLearn => 'ماذا ستتعلم؟';

  @override
  String get courseDetailsRequirements => 'المتطلبات';

  @override
  String get courseDetailsDescription => 'وصف الدورة';

  @override
  String get courseDetailsIncludesTitle => 'تشمل هذه الدورة';

  @override
  String get courseDetailsHoursVideo => 'ساعات من الفيديو';

  @override
  String get courseDetailsArticles => 'مقالات';

  @override
  String get courseDetailsMobileAccess => 'وصول من الهاتف';

  @override
  String get courseDetailsCertificate => 'شهادة إتمام';

  @override
  String get courseDetailsLifetimeAccess => 'وصول مدى الحياة';

  @override
  String get lessonPlayerNotes => 'ملاحظاتي';

  @override
  String get lessonPlayerResources => 'الموارد';

  @override
  String get lessonPlayerDiscussion => 'النقاش';

  @override
  String get lessonPlayerPrev => 'السابق';

  @override
  String get lessonPlayerNext => 'التالي';

  @override
  String get lessonPlayerSpeed => 'السرعة';

  @override
  String get lessonPlayerQuality => 'الجودة';

  @override
  String get lessonPlayerCompleted => 'درس مكتمل';

  @override
  String get certificateTitle => 'شهادة إتمام الدورة';

  @override
  String get certificatePresentedTo => 'تُمنح إلى';

  @override
  String get certificateCompletedCourse => 'لإتمامه بنجاح دورة';

  @override
  String get certificateIssuedOn => 'تاريخ الإصدار';

  @override
  String get certificateVerificationId => 'رقم التحقق';

  @override
  String get certificateDownloadPDF => 'تحميل PDF';

  @override
  String get certificateDownloadPNG => 'تحميل صورة';

  @override
  String get certificateCopyLink => 'نسخ رابط التحقق';

  @override
  String get certificateLinkCopied => 'تم نسخ الرابط';

  @override
  String get profileTitle => 'الملف الشخصي';

  @override
  String get profileEditProfile => 'تعديل الملف الشخصي';

  @override
  String get profileCourses => 'دوراتي';

  @override
  String get profileCertificates => 'الشهادات';

  @override
  String get profilePoints => 'نقاط';

  @override
  String get profileFollowers => 'متابع';

  @override
  String get profileFollowing => 'متابَع';

  @override
  String get profileBio => 'نبذة تعريفية';

  @override
  String get profileInstructor => 'مدرب';

  @override
  String get profileStudent => 'طالب';

  @override
  String get profileLevel => 'المستوى';

  @override
  String get profileJoined => 'انضم في';

  @override
  String get profileShareProfile => 'مشاركة الملف';

  @override
  String get profileMenuLearning => 'دوراتي';

  @override
  String get profileMenuCertificates => 'شهاداتي';

  @override
  String get profileMenuPurchaseHistory => 'سجل المشتريات';

  @override
  String get profileMenuTeachApplication => 'طلب التدريس';

  @override
  String get profileMenuAccountSecurity => 'أمان الحساب';

  @override
  String get profileMenuNotifications => 'الإشعارات';

  @override
  String get profileMenuMessages => 'الرسائل';

  @override
  String get profileMenuSettings => 'الإعدادات';

  @override
  String get profileMenuSchedule => 'جدولي';

  @override
  String get profileMenuAssignments => 'واجباتي';

  @override
  String get profileMenuQuiz => 'الاختبارات';

  @override
  String get profileMenuLogout => 'تسجيل الخروج';

  @override
  String get profileLogoutConfirm => 'هل أنت متأكد من تسجيل الخروج؟';

  @override
  String get profileLogoutYes => 'نعم، خروج';

  @override
  String get profileLogoutNo => 'إلغاء';

  @override
  String get editProfileTitle => 'تعديل الملف الشخصي';

  @override
  String get editProfileSave => 'حفظ التغييرات';

  @override
  String get editProfileFullName => 'الاسم الكامل';

  @override
  String get editProfileBio => 'نبذة تعريفية';

  @override
  String get editProfileEmail => 'البريد الإلكتروني';

  @override
  String get editProfilePhone => 'رقم الهاتف';

  @override
  String get editProfileWebsite => 'الموقع الإلكتروني';

  @override
  String get editProfileSaved => 'تم حفظ التغييرات بنجاح';

  @override
  String get accountSecurityTitle => 'أمان الحساب';

  @override
  String get accountSecurityChangePassword => 'تغيير كلمة المرور';

  @override
  String get accountSecurityTwoFactor => 'التحقق بخطوتين';

  @override
  String get accountSecurityActiveSessions => 'الجلسات النشطة';

  @override
  String get accountSecurityDeleteAccount => 'حذف الحساب';

  @override
  String get purchaseHistoryTitle => 'سجل المشتريات';

  @override
  String get purchaseHistoryEmpty => 'لا توجد مشتريات بعد';

  @override
  String get purchaseHistoryGuarantee => 'ضمان استرداد المال خلال 30 يومًا';

  @override
  String get purchaseHistoryDate => 'تاريخ العملية';

  @override
  String get purchaseHistoryStatus => 'الحالة';

  @override
  String get purchaseHistoryAmount => 'المبلغ';

  @override
  String get purchaseHistoryCompleted => 'مكتمل';

  @override
  String get purchaseHistoryRefunded => 'مسترجع';

  @override
  String get teachApplicationTitle => 'طلب التدريس';

  @override
  String get teachApplicationSubmit => 'إرسال الطلب';

  @override
  String get teachApplicationSent => 'تم إرسال طلبك بنجاح';

  @override
  String get notificationsTitle => 'الإشعارات';

  @override
  String get notificationsMarkAllRead => 'تحديد الكل كمقروء';

  @override
  String get notificationsMarkAllReadSnackbar =>
      'تم تحديد كل الإشعارات كمقروءة';

  @override
  String get notificationsEmpty => 'لا توجد إشعارات';

  @override
  String get notification1Title => 'تذكير: تابع دورتك';

  @override
  String get notification1Message => 'لديك درس جديد في دورة Flutter للمبتدئين';

  @override
  String get notification1Time => 'منذ 5 دقائق';

  @override
  String get notification1Action => 'متابعة الدورة';

  @override
  String get notification2Title => 'شهادتك جاهزة!';

  @override
  String get notification2Message =>
      'أكملت دورة تصميم UX/UI بنجاح، شهادتك متاحة';

  @override
  String get notification2Time => 'منذ ساعتين';

  @override
  String get notification2Action => 'عرض الشهادة';

  @override
  String get notification3Title => 'عرض حصري لك';

  @override
  String get notification3Message => 'خصم 70٪ على دورات البرمجة لفترة محدودة';

  @override
  String get notification3Time => 'منذ يوم';

  @override
  String get notification3Action => 'استكشاف العرض';

  @override
  String get notification4Title => 'رد جديد على سؤالك';

  @override
  String get notification4Message => 'أجاب المدرب على سؤالك في درس React Hooks';

  @override
  String get notification4Time => 'منذ يومين';

  @override
  String get notification4Action => 'عرض الرد';

  @override
  String get notification5Title => 'تحديث في الدورة';

  @override
  String get notification5Message =>
      'تم إضافة محتوى جديد لدورة Python المتقدمة';

  @override
  String get notification5Time => 'منذ 3 أيام';

  @override
  String get messagesTitle => 'الرسائل الأخيرة';

  @override
  String get settingsTitle => 'الإعدادات والتفضيلات';

  @override
  String get settingsVideoDownload => 'الفيديو والتحميل';

  @override
  String get settingsDownloadQuality => 'جودة تنزيل الفيديو';

  @override
  String get settingsWifiOnly => 'التنزيل عبر Wi-Fi فقط';

  @override
  String get settingsNotifications => 'الإشعارات والتنبيهات';

  @override
  String get settingsCourseNotifications => 'إشعارات الدورات والرسائل';

  @override
  String get settingsPromoNotifications => 'العروض والخصومات الحصرية';

  @override
  String get settingsAppearance => 'المظهر واللغة';

  @override
  String get settingsDarkMode => 'الوضع الداكن';

  @override
  String get settingsDarkModeEnabled => 'مفعّل (توفير البطارية وراحة للعين)';

  @override
  String get settingsDarkModeDisabled => 'معطّل (الوضع الفاتح)';

  @override
  String get settingsLanguage => 'لغة التطبيق';

  @override
  String get settingsStorage => 'التخزين والذاكرة المؤقتة';

  @override
  String get settingsClearCache => 'تفريغ الذاكرة المؤقتة';

  @override
  String get settingsClearCacheSuccess => 'تم تفريغ الذاكرة المؤقتة بنجاح';

  @override
  String get settingsHelp => 'المعلومات والسياسات';

  @override
  String get settingsHelpCenter => 'مركز المساعدة والأسئلة الشائعة';

  @override
  String get settingsTermsPrivacy => 'شروط الاستخدام وسياسة الخصوصية';

  @override
  String get settingsAbout => 'عن منصة EduLab';

  @override
  String get settingsVersion => 'الإصدار v1.0.0';

  @override
  String get quizTitle => 'الاختبار';

  @override
  String get quizNext => 'السؤال التالي';

  @override
  String get quizSubmit => 'تسليم الاختبار';

  @override
  String get quizScore => 'درجة الاختبار';

  @override
  String get quizCorrectAnswers => 'إجابات صحيحة';

  @override
  String get scheduleTitle => 'الجدول الزمني';

  @override
  String get scheduleEmpty => 'لا توجد جلسات مجدولة';

  @override
  String get scheduleJoin => 'انضم للجلسة';

  @override
  String get scheduleReminder => 'تذكير';

  @override
  String get assignmentsTitle => 'الواجبات';

  @override
  String get assignmentsEmpty => 'لا توجد واجبات';

  @override
  String get assignmentsSubmit => 'تسليم الواجب';

  @override
  String get assignmentsDue => 'موعد التسليم';

  @override
  String get assignmentsSubmitted => 'تم التسليم';

  @override
  String get assignmentsPending => 'في الانتظار';

  @override
  String get languageArabic => 'العربية';

  @override
  String get languageEnglish => 'الإنجليزية';

  @override
  String get languageDialogTitle => 'اختر لغة التطبيق';

  @override
  String get languageSelect => 'اختر';

  @override
  String get generalCancel => 'إلغاء';

  @override
  String get generalConfirm => 'تأكيد';

  @override
  String get generalSave => 'حفظ';

  @override
  String get generalDelete => 'حذف';

  @override
  String get generalEdit => 'تعديل';

  @override
  String get generalClose => 'إغلاق';

  @override
  String get generalBack => 'رجوع';

  @override
  String get generalDone => 'تم';

  @override
  String get generalOk => 'حسناً';

  @override
  String get generalYes => 'نعم';

  @override
  String get generalNo => 'لا';

  @override
  String get generalLoading => 'جاري التحميل...';

  @override
  String get generalError => 'حدث خطأ';

  @override
  String get generalRetry => 'إعادة المحاولة';

  @override
  String get generalNoInternet => 'لا يوجد اتصال بالإنترنت';

  @override
  String get generalFree => 'مجاني';

  @override
  String get generalRating => 'التقييم';

  @override
  String get generalStudents => 'طلاب';

  @override
  String get generalHours => 'ساعات';

  @override
  String get generalMinutes => 'دقيقة';

  @override
  String get generalBy => 'بواسطة';

  @override
  String get navHome => 'الرئيسية';

  @override
  String get navExplore => 'استكشاف';

  @override
  String get navMyCourses => 'دوراتي';

  @override
  String get navCart => 'السلة';

  @override
  String get navAccount => 'حسابي';

  @override
  String get homeSubGreeting => 'ما الذي تريد تعلمه اليوم؟';

  @override
  String get homeVisitor => 'زائر';

  @override
  String get homePromoTitle => 'استكشف العروض الآن';

  @override
  String get homePromoSubtitle => 'خصومات حتى 70٪ على الدورات المميزة';

  @override
  String get homePromoButton => 'اكتشف الآن';

  @override
  String get homePromoBadge => 'عرض حصري';

  @override
  String get homeContinueLearning => 'تابع التعلم';

  @override
  String get homeMyCoursesLink => 'دوراتي';

  @override
  String get homeLesson => 'درس';

  @override
  String homeStudentsCount(String count) {
    return '$count طالب';
  }

  @override
  String get homeRecommendedTitle => 'موصى بها لك';

  @override
  String get homeRecommendedSubtitle => 'مخصصة بناءً على اهتماماتك';

  @override
  String get homeBestsellersTitle => 'الأكثر مبيعًا';

  @override
  String get homeBestsellersSubtitle => 'الدورات الأعلى تقييمًا والأكثر شهرة';

  @override
  String get homeNewCoursesTitle => 'أحدث الدورات';

  @override
  String get homeNewCoursesSubtitle => 'محتوى جديد ومحدّث';

  @override
  String get homePopularTopicsTitle => 'المواضيع الأكثر شعبية';

  @override
  String get homePopularTopicsSubtitle => 'ابدأ بتعلم المهارات الأكثر طلبًا';

  @override
  String get homeTopInstructorsTitle => 'أفضل المدربين';

  @override
  String get homeTopInstructorsSubtitle => 'تعلم من خبراء معتمدين';

  @override
  String get homeExploreCategoriesTitle => 'استكشف التصنيفات';

  @override
  String get homeExploreCategoriesSubtitle => 'اعثر على الدورة المناسبة لك';

  @override
  String get catAll => 'الكل';

  @override
  String get catWebDev => 'تطوير الويب';

  @override
  String get catMobileApps => 'تطبيقات الجوال';

  @override
  String get catDataScience => 'علوم البيانات';

  @override
  String get catUIUX => 'تصميم UI/UX';

  @override
  String get catBusiness => 'إدارة الأعمال';

  @override
  String get catAI => 'الذكاء الاصطناعي';

  @override
  String get catCyberSecurity => 'أمن المعلومات';

  @override
  String get exploreNoResultsTitle => 'لا توجد نتائج';

  @override
  String get exploreNoResultsSubtitle => 'جرب كلمات بحث مختلفة أو غير التصفية';

  @override
  String get exploreRecentSearches => 'عمليات البحث الأخيرة';

  @override
  String get exploreTopSearches => 'الأكثر بحثًا';

  @override
  String get exploreBrowseCategories => 'تصفح التصنيفات';

  @override
  String get exploreBrowseCategoriesSubtitle => 'اعثر على الدورة المناسبة لك';

  @override
  String get exploreBackToAll => 'العودة للكل';

  @override
  String get exploreClearAll => 'مسح الكل';

  @override
  String get exploreAvailableResults => 'نتيجة متاحة';

  @override
  String get exploreFilterBestseller => 'الأكثر مبيعًا';

  @override
  String get exploreFilterTopRated => 'الأعلى تقييمًا';

  @override
  String get exploreFilterUnder50 => 'أقل من 50 دولار';

  @override
  String get learningHeroTitle => 'استمر في رحلتك التعليمية';

  @override
  String get learningSearchHint => 'ابحث في دوراتك...';

  @override
  String get learningFilterAll => 'الكل';

  @override
  String get learningFilterInProgress => 'قيد التعلم';

  @override
  String get learningFilterCompleted => 'مكتملة';

  @override
  String get learningFilterDownloaded => 'محملة';

  @override
  String get learningEmptyTitle => 'لا توجد دورات بعد';

  @override
  String get learningEmptySubtitle => 'ابدأ باستكشاف الدورات الآن';

  @override
  String get learningEmptySearch => 'لا توجد نتائج لبحثك';

  @override
  String get learningCompleted => 'مكتملة';

  @override
  String get learningCompletedBadge => 'مكتمل';

  @override
  String learningLecturesCount(int count) {
    return '$count محاضرة';
  }

  @override
  String get cartEmptyTitle => 'السلة فارغة';

  @override
  String get cartEmptySubtitle => 'أضف بعض الدورات لتبدأ رحلة التعلم';

  @override
  String get cartCouponHint => 'أدخل كود الخصم';

  @override
  String get cartCouponApply => 'تطبيق';

  @override
  String get cartCouponInvalid => 'كود الخصم غير صالح';

  @override
  String get cartCouponApplied => 'تم تطبيق كود الخصم';

  @override
  String get cartCouponDiscount => 'خصم الكوبون';

  @override
  String get cartCouponsTitle => 'كوبونات الخصم';

  @override
  String get cartOrderSummary => 'ملخص الطلب';

  @override
  String get cartOriginalPrice => 'السعر الأصلي';

  @override
  String get cartPlatformDiscount => 'خصم المنصة';

  @override
  String get cartFinalTotal => 'الإجمالي النهائي';

  @override
  String cartItemsCount(int count) {
    return '$count دورة';
  }

  @override
  String get cartRemovedSnackbar => 'تم حذف الدورة من السلة';

  @override
  String get cartUndo => 'تراجع';

  @override
  String get cartAddButton => 'إضافة للسلة';

  @override
  String get cartAddedSnackbar => 'تمت الإضافة إلى السلة';

  @override
  String get cartAlreadyInCart => 'موجود في السلة';

  @override
  String get cartCheckoutButton => 'إتمام الشراء';

  @override
  String get cartRecommendedTitle => 'قد يعجبك أيضًا';

  @override
  String get cartRecommendedSubtitle => 'دورات موصى بها بناءً على سلتك';

  @override
  String get checkoutCreditCard => 'بطاقة ائتمانية';

  @override
  String get checkoutSelectPayment => 'اختر طريقة الدفع';

  @override
  String get checkoutCardNumberLabel => 'رقم البطاقة';

  @override
  String get checkoutCardHolderLabel => 'اسم صاحب البطاقة';

  @override
  String get checkoutExpiryLabel => 'تاريخ الانتهاء';

  @override
  String get checkoutCVVLabel => 'CVV';

  @override
  String get checkoutPersonalInfoTitle => 'البيانات الشخصية';

  @override
  String get checkoutFullNameLabel => 'الاسم الكامل';

  @override
  String get checkoutFullNameHint => 'اسمك الكامل';

  @override
  String get checkoutFullNameRequired => 'الاسم الكامل مطلوب';

  @override
  String get checkoutPhoneLabel => 'رقم الهاتف';

  @override
  String get checkoutPhoneRequired => 'رقم الهاتف مطلوب';

  @override
  String get checkoutPostalLabel => 'الرمز البريدي';

  @override
  String get checkoutPostalRequired => 'الرمز البريدي مطلوب';

  @override
  String get checkoutBuyerInfo => 'بيانات المشتري';

  @override
  String get checkoutSaveInfo => 'حفظ البيانات للمرة القادمة';

  @override
  String get checkoutMoneyBackGuarantee => 'ضمان استرداد المال خلال 30 يومًا';

  @override
  String get checkoutContinueToPayment => 'المتابعة للدفع';

  @override
  String get checkoutContinueToReview => 'المتابعة للمراجعة';

  @override
  String get checkoutReviewConfirm => 'مراجعة وتأكيد';

  @override
  String get checkoutStartLearning => 'ابدأ التعلم';

  @override
  String get checkoutBackHome => 'العودة للرئيسية';

  @override
  String get courseDetailsTitle => 'تفاصيل الدورة';

  @override
  String get courseDetailsShare => 'مشاركة';

  @override
  String get courseDetailsWhatYouWillLearn => 'ماذا ستتعلم؟';

  @override
  String get courseDetailsLanguage => 'اللغة';

  @override
  String get courseDetailsCreatedBy => 'بواسطة';

  @override
  String get courseDetailsPreviewLesson => 'معاينة الدرس';

  @override
  String get courseDetailsHoursOnDemand => 'ساعات فيديو عند الطلب';

  @override
  String get courseDetailsFullLifetimeAccess => 'وصول مدى الحياة';

  @override
  String get courseDetailsCertifiedCertificate => 'شهادة إتمام معتمدة';

  @override
  String get courseDetailsComprehensiveContent => 'محتوى شامل ومتكامل';

  @override
  String get certTitle => 'شهادة الإتمام';

  @override
  String get certStudentNameLabel => 'الطالب';

  @override
  String get certCourseLabel => 'الدورة';

  @override
  String get certInstructorLabel => 'المدرب';

  @override
  String get certIssueDateLabel => 'تاريخ الإصدار';

  @override
  String get certCodeLabel => 'رقم الشهادة';

  @override
  String get certVerifiedBadge => 'معتمدة';

  @override
  String get certDownloadPDF => 'تحميل PDF';

  @override
  String get certDownloadPNG => 'تحميل صورة';

  @override
  String get certCopyVerifyLink => 'نسخ رابط التحقق';

  @override
  String get certShare => 'مشاركة الشهادة';

  @override
  String get playerTabLessons => 'الدروس';

  @override
  String get playerTabOverview => 'نظرة عامة';

  @override
  String get playerTabNotes => 'ملاحظاتي';

  @override
  String get playerTabQnA => 'الأسئلة والأجوبة';

  @override
  String get playerNextLesson => 'الدرس التالي';

  @override
  String get profileWelcome => 'مرحباً بك';

  @override
  String get profileLoginPrompt => 'سجّل دخولك للوصول إلى ملفك الشخصي';

  @override
  String get profileLoginOrRegister => 'تسجيل الدخول / إنشاء حساب';

  @override
  String get profileVerifiedStudent => 'طالب معتمد';

  @override
  String get profileLogout => 'تسجيل الخروج';

  @override
  String get profileCancel => 'إلغاء';

  @override
  String get profileLogoutConfirmTitle => 'تسجيل الخروج';

  @override
  String get profileLogoutConfirmMessage => 'هل أنت متأكد من تسجيل الخروج؟';

  @override
  String get profileAccountSettings => 'إعدادات الحساب';

  @override
  String get profileEditProfileSubtitle => 'تعديل بياناتك الشخصية';

  @override
  String get profileSecurity => 'أمان الحساب';

  @override
  String get profileSecuritySubtitle => 'كلمة المرور والتحقق';

  @override
  String get profilePurchaseHistory => 'سجل المشتريات';

  @override
  String get profilePurchaseHistorySubtitle => 'عرض تاريخ المعاملات';

  @override
  String get profileCertificatesSubtitle => 'شهاداتك المعتمدة';

  @override
  String get profileTeach => 'التدريس على EduLab';

  @override
  String get profileTeachSubtitle => 'شارك خبرتك مع الآخرين';

  @override
  String get profilePreferences => 'التفضيلات';

  @override
  String get profilePreferencesSubtitle => 'الإعدادات والمظهر';

  @override
  String get profileNotifications => 'الإشعارات';

  @override
  String get profileNotificationsSubtitle => 'إدارة الإشعارات والتنبيهات';

  @override
  String get profileHelpSupport => 'المساعدة والدعم';

  @override
  String get profileTerms => 'شروط الاستخدام';

  @override
  String get profilePrivacy => 'سياسة الخصوصية';

  @override
  String get profileAboutEduLab => 'عن EduLab';

  @override
  String get profileWishlist => 'المفضلة';

  @override
  String get securityTitle => 'أمان الحساب';

  @override
  String get teachTitle => 'التدريس على EduLab';

  @override
  String get notificationsTabAll => 'الكل';

  @override
  String get notificationsTabCourses => 'الدورات';

  @override
  String get notificationsTabPromos => 'العروض';

  @override
  String get notificationsEmptyTitle => 'لا توجد إشعارات';

  @override
  String get notificationsUnread => 'غير مقروء';

  @override
  String get wishlistTitle => 'المفضلة';

  @override
  String get wishlistEmptyTitle => 'المفضلة فارغة';

  @override
  String get wishlistEmptySubtitle => 'أضف الدورات التي تهمك إلى المفضلة';

  @override
  String get wishlistAddToCart => 'أضف إلى السلة';

  @override
  String get wishlistRemovedSnackbar => 'تم الحذف من المفضلة';

  @override
  String get homeDefaultUser => 'طالب';

  @override
  String get learningOf => 'من';

  @override
  String get cartInCartBadge => 'في السلة';

  @override
  String get homePromo1Badge => 'تخفيضات كبرى • لفترة محدودة';

  @override
  String get homePromo1Title => 'ابدأ رحلتك التعليمية بأفضل الأسعار';

  @override
  String get homePromo1Subtitle =>
      'خصومات تصل إلى 65% على دورات البرمجة، التصميم وإدارة الأعمال.';

  @override
  String get homePromo1Button => 'تصفح العروض';

  @override
  String get homePromo2Badge => 'مسارات مهنية معتمدة';

  @override
  String get homePromo2Title => 'جهّز نفسك لوظيفة أحلامك في سوق العمل';

  @override
  String get homePromo2Subtitle =>
      'دورات متكاملة من الصفر للاحتراف مع مشاريع عملية وشهادات معتمدة.';

  @override
  String get homePromo2Button => 'استكشف المسارات';

  @override
  String get homePromo3Badge => 'نخبة المدربين والخبراء';

  @override
  String get homePromo3Title => 'تعلم مباشرة من المتخصصين في المجال';

  @override
  String get homePromo3Subtitle =>
      'محتوى عربي وإنجليزي احترافي يُحدّث باستمرار لتواكب أحدث التقنيات.';

  @override
  String get homePromo3Button => 'ابدأ التعلم الآن';

  @override
  String get homeSearchFilter => 'تصفية';

  @override
  String get securitySectionChangePassword => 'تغيير كلمة المرور';

  @override
  String get securityCurrentPasswordLabel => 'كلمة المرور الحالية *';

  @override
  String get securityCurrentPasswordError => 'أدخل كلمة المرور الحالية';

  @override
  String get securityNewPasswordLabel => 'كلمة المرور الجديدة *';

  @override
  String get securityNewPasswordError => 'يجب ألا تقل عن 8 أحرف وأرقام';

  @override
  String get securityConfirmPasswordLabel => 'تأكيد كلمة المرور الجديدة *';

  @override
  String get securityConfirmPasswordError => 'كلمة المرور غير متطابقة';

  @override
  String get securityUpdatePasswordBtn => 'تحديث كلمة المرور';

  @override
  String get securityPasswordUpdatedSuccess =>
      'تم تغيير وتحديث كلمة المرور بنجاح!';

  @override
  String get securitySection2FA => 'التحقق بخطوتين (2FA)';

  @override
  String get security2FATitle => 'المصادقة الثنائية (2FA)';

  @override
  String get security2FAEnabledDesc => 'مفعلة وتؤمن حسابك برمز إضافي';

  @override
  String get security2FADisabledDesc => 'غير مفعلة (يُنصح بتفعيلها)';

  @override
  String get security2FASetupTitle => 'تفعيل التحقق بخطوتين';

  @override
  String get security2FASetupContent =>
      'سيتم إرسال رمز تحقق مؤلف من 6 أرقام إلى بريدك الإلكتروني المسجل عند كل تسجيل دخول جديد لحماية حسابك.';

  @override
  String get security2FAEnableNow => 'تفعيل الآن';

  @override
  String get security2FAEnabledSuccess =>
      'تم تفعيل التحقق بخطوتين (2FA) بنجاح!';

  @override
  String get security2FADisabledSuccess => 'تم تعطيل التحقق بخطوتين (2FA)';

  @override
  String get securitySectionSessions => 'الأجهزة والجلسات المسجلة';

  @override
  String get securityLogoutAllDevices => 'تسجيل الخروج من الكل';

  @override
  String get securityThisDevice => 'هذا الجهاز';

  @override
  String get securitySessionRevokedSuccess =>
      'تم إنهاء الجلسة وتسجيل الخروج من هذا الجهاز بنجاح.';

  @override
  String get securityAllSessionsRevokedSuccess =>
      'تم تسجيل الخروج من كافة الأجهزة الأخرى بنجاح.';

  @override
  String get purchaseHistoryInvoiceCertified => 'فاتورة إلكترونية معتمدة';

  @override
  String get purchaseHistoryInvoiceNumber => 'رقم الفاتورة';

  @override
  String get purchaseHistoryCourse => 'الدورة';

  @override
  String get purchaseHistoryPaymentMethod => 'طريقة الدفع';

  @override
  String get purchaseHistoryTotalAmount => 'المبلغ الإجمالي:';

  @override
  String get purchaseHistoryClose => 'إغلاق';

  @override
  String get purchaseHistoryDownloadPdf => 'تحميل PDF';

  @override
  String get purchaseHistoryPdfDownloaded =>
      'تم تنزيل الفاتورة بصيغة PDF بنجاح';

  @override
  String get purchaseHistoryRefundRequestTitle =>
      'طلب استرداد الأموال (Refund)';

  @override
  String get purchaseHistoryRefundPolicy =>
      'وفقاً لسياسة منصة EduLab وضمان الـ 30 يوماً، يمكنك استرداد كامل المبلغ إلى وسيلة الدفع الأصلية.';

  @override
  String get purchaseHistoryRefundReasonHint =>
      'سبب طلب الاسترجاع (اختياري)...';

  @override
  String get purchaseHistoryConfirmRefund => 'تأكيد الاسترداد';

  @override
  String get purchaseHistoryRefundSubmitted =>
      'تم رفع طلب الاسترداد بنجاح وسيتم إيداع المبلغ خلال 3-5 أيام عمل.';

  @override
  String get purchaseHistoryInstructor => 'المحاضر';

  @override
  String get purchaseHistoryRequestRefundBtn => 'طلب استرجاع';

  @override
  String get purchaseHistoryInvoiceBtn => 'الفاتورة';

  @override
  String get purchaseHistoryStatusCompleted => 'مكتمل وناجح';

  @override
  String get purchaseHistoryStatusRefunded => 'تم الاسترداد';

  @override
  String get purchaseHistoryStatusProcessingRefund => 'قيد معالجة الاسترداد';

  @override
  String get editProfileSectionBasicInfo => 'البيانات الأساسية';

  @override
  String get editProfileFullNameLabel => 'الاسم الكامل *';

  @override
  String get editProfileFullNameHint => 'أدخل اسمك الثلاثي';

  @override
  String get editProfileFullNameError => 'يرجى إدخال الاسم كاملاً';

  @override
  String get editProfileHeadlineLabel => 'المسمى المهني / التخصص';

  @override
  String get editProfileHeadlineHint => 'مثال: مطور تطبيقات فلاتر';

  @override
  String get editProfileLocationLabel => 'المدينة / الدولة';

  @override
  String get editProfileLocationHint => 'الرياض، المملكة العربية السعودية';

  @override
  String get editProfilePhoneLabel => 'رقم الهاتف الجوال';

  @override
  String get editProfileBioLabel => 'نبذة عني (Bio)';

  @override
  String get editProfileBioHint => 'اكتب نبذة مختصرة عن اهتماماتك وخبراتك...';

  @override
  String get editProfileSectionLinks => 'الروابط والشبكات المهنية';

  @override
  String get editProfileWebsiteLabel => 'الموقع الشخصي';

  @override
  String get editProfileSectionEmail => 'البريد الإلكتروني المسجل';

  @override
  String get editProfileEmailDesc =>
      'مرتبط بحسابك لتسجيل الدخول واستلام الشهادات';

  @override
  String get editProfileEmailVerified => 'موثق';

  @override
  String get editProfileSaveChangesBtn => 'حفظ وتحديث البيانات';

  @override
  String get editProfileSavedSuccess =>
      'تم حفظ وتحديث بيانات الملف الشخصي بنجاح!';

  @override
  String get editProfileChangeAvatarTitle => 'تغيير الصورة الشخصية';

  @override
  String get editProfileTakePhoto => 'التقاط صورة بالكاميرا';

  @override
  String get editProfileChooseGallery => 'اختيار من معرض الصور';

  @override
  String get editProfilePhotoUpdatedSuccess => 'تم تحديث الصورة الشخصية بنجاح';

  @override
  String get teachJoinInstructorTitle => 'انضم كمدرب معتمد';

  @override
  String get teachJoinInstructorSubtitle =>
      'انشر دوراتك وشارك خبراتك مع آلاف الطلاب حول العالم.';

  @override
  String get teachStep1Title => 'البيانات الشخصية';

  @override
  String get teachStep2Title => 'الخبرات والمهارات';

  @override
  String get teachStep3Title => 'تأكيد الطلب';

  @override
  String get teachStep1Header => '1. البيانات الشخصية والمهنية';

  @override
  String get teachFullNameArabicLabel => 'الاسم الكامل *';

  @override
  String get teachFullNameArabicHint => 'مثال: محمد النجار';

  @override
  String get teachHeadlineLabel => 'المسمى المهني والتخصص *';

  @override
  String get teachHeadlineHint => 'مثال: مهندس برمجيات أول ومطور تطبيقات فلاتر';

  @override
  String get teachPhoneLabel => 'رقم الهاتف للتواصل *';

  @override
  String get teachCountryLabel => 'بلد الإقامة *';

  @override
  String get teachBioLabel => 'النبذة التعريفية والخبرات السابقة *';

  @override
  String get teachBioHint =>
      'اكتب نبذة مختصرة عن مسيرتك المهنية ومشاريعك السابقة...';

  @override
  String get teachNextStepSkills => 'متابعة: الخبرات والمهارات';

  @override
  String get teachStep2Header => '2. المحتوى التعليمي والمهارات';

  @override
  String get teachTopicLabel => 'موضوع أو مسار الدورة المقترحة *';

  @override
  String get teachTopicHint => 'مثال: تطوير تطبيقات Flutter من الصفر';

  @override
  String get teachYearsExperienceLabel => 'سنوات الخبرة في المجال *';

  @override
  String get teachVideoLinkLabel =>
      'رابط فيديو تجريبي لشرحك (YouTube/Drive/Loom) *';

  @override
  String get teachTargetAudienceLabel => 'الفئة المستهدفة للدورة *';

  @override
  String get teachAudienceBeginners => 'مبتدئين تماماً';

  @override
  String get teachAudienceIntermediate => 'مبتدئين ومتوسطين';

  @override
  String get teachAudienceAdvanced => 'مطورين متقدمين ومحترفين';

  @override
  String get teachAudienceAll => 'الجميع';

  @override
  String get teachSkillsCoveredLabel =>
      'المهارات والتقنيات التي ستغطيها الدورة *';

  @override
  String get teachAddSkillHint => 'أضف مهارة (مثال: GraphQL)...';

  @override
  String get teachAddSkillBtn => 'إضافة';

  @override
  String get teachNextStepConfirm => 'متابعة: تأكيد الطلب';

  @override
  String get teachStep3Header => '3. تفاصيل الأرباح وتأكيد الشروط';

  @override
  String get teachPayoutMethodLabel => 'طريقة استلام أرباح الدورات *';

  @override
  String get teachPayoutMethodBank => 'تحويل بنكي مباشر (IBAN)';

  @override
  String get teachPayoutMethodPaypal => 'حساب PayPal معتمد';

  @override
  String get teachPayoutMethodPayoneer => 'بطاقة Payoneer';

  @override
  String get teachIbanDetailsLabel => 'بيانات الحساب / الآيبان (IBAN) *';

  @override
  String get teachApplicationSummary => 'ملخص الطلب:';

  @override
  String get teachApplicantName => 'مقدم الطلب';

  @override
  String get teachApplicantHeadline => 'التخصص';

  @override
  String get teachApplicantTopic => 'موضوع الدورة';

  @override
  String get teachApplicantSkillsCount => 'عدد المهارات المضافة';

  @override
  String get teachSkillsUnit => 'مهارات';

  @override
  String get teachAgreeTermsLabel =>
      'أوافق على الشروط والأحكام الخاصة باتفاقية التدريس وحقوق الملكية الفكرية لمنصة EduLab.';

  @override
  String get teachSubmitApplicationBtn => 'إرسال طلب الانضمام كمدرب';

  @override
  String get teachPrevStepBtn => 'السابق';

  @override
  String get teachWhyEduLabTitle => 'لماذا تختار التدريس مع EduLab؟';

  @override
  String get teachProp1Title => 'أرباح مجزية وعادلة';

  @override
  String get teachProp1Desc =>
      'احصل على نسبة تصل إلى 80% من مبيعات دوراتك بدون رسوم خفية.';

  @override
  String get teachProp2Title => 'وصول إلى آلاف الطلاب';

  @override
  String get teachProp2Desc =>
      'سوق دورتك لأكبر مجتمع تقني وتعليمي في الوطن العربي والعالم.';

  @override
  String get teachProp3Title => 'دعم فني وإنتاجي كامل';

  @override
  String get teachProp3Desc =>
      'فريقنا يساعدك في تحسين جودة الصوت والفيديو والمنهج التعليمي.';

  @override
  String get teachSuccessDialogTitle => 'تم استلام طلبك بنجاح!';

  @override
  String get teachSuccessDialogDesc =>
      'شكراً لانضمامك إلى مجتمع مدربي EduLab. سيقوم فريق الجودة الأكاديمية بمراجعة طلبك والتواصل معك خلال 48 ساعة عبر بريدك المسجل.';

  @override
  String get teachSuccessDialogOk => 'حسناً';

  @override
  String get teachAddOneSkillError => 'يرجى إضافة مهارة واحدة على الأقل';

  @override
  String get teachAgreeTermsError => 'يرجى الموافقة على شروط واتفاقية التدريس';

  @override
  String get commonCancel => 'إلغاء';

  @override
  String get commonClose => 'إغلاق';

  @override
  String get myCertificatesBannerTitle => 'الشهادات المعتمدة';

  @override
  String get myCertificatesBannerSubtitle =>
      'جميع الشهادات معتمدة وموثقة برقم تحقق فريد من EduLab';

  @override
  String get certBadgeVerified100 => 'معتمدة 100%';

  @override
  String get certCodeCopied => 'تم نسخ كود الشهادة';

  @override
  String get certGrantedTo => 'الممنوحة لـ';

  @override
  String get certViewAndDownload => 'معاينة وتنزيل الشهادة';

  @override
  String get certIssuerLabel => 'الجهة المصدرة';

  @override
  String get certIssuerName => 'أكاديمية EduLab للتعليم التفاعلي';

  @override
  String get certEmptyTitle => 'لا توجد شهادات إتمام حتى الآن';

  @override
  String get certEmptyDesc =>
      'أكمل دراسة أي من دوراتك المسجلة بنسبة 100% واجتز كافة متطلباتها للحصول على شهادة إتمام معتمدة وموثقة برقم تحقق رسمي.';

  @override
  String get certEmptyAction => 'متابعة دوراتي التعليمية';

  @override
  String get certDetailsTitle => 'بيانات وتفاصيل الشهادة';

  @override
  String get certCopyLinkSuccess => 'تم نسخ رابط التحقق المباشر إلى الحافظة!';

  @override
  String get certShareSuccess => 'تم نسخ رابط وتفاصيل الشهادة للمشاركة!';

  @override
  String get purchaseHistoryTaxInvoiceCertified => 'فاتورة ضريبية رسمية وموثقة';

  @override
  String get purchaseHistoryInvoiceNumberLabel => 'رقم الطلب / الفاتورة';

  @override
  String get purchaseHistoryCourseNameLabel => 'اسم الكورس';

  @override
  String get purchaseHistoryPurchaseDateLabel => 'تاريخ الشراء';

  @override
  String get purchaseHistoryPaymentMethodLabel => 'طريقة الدفع';

  @override
  String get purchaseHistoryPaymentMethodValue =>
      'بطاقة بنكية / Stripe (إلكتروني)';

  @override
  String get purchaseHistoryOrderStatusLabel => 'حالة الطلب';

  @override
  String get purchaseHistoryStatusPendingReview => 'قيد مراجعة الاسترداد';

  @override
  String get purchaseHistoryCopyInvoiceBtn => 'نسخ رقم الفاتورة للرجوع إليها';

  @override
  String get purchaseHistoryRefundReasonLabel => 'سبب طلب الاسترداد:';

  @override
  String get purchaseHistoryRefundReasonEmptyError =>
      'يرجى كتابة سبب طلب الاسترداد';

  @override
  String get purchaseHistorySubmittingRefund => 'جاري إرسال الطلب';

  @override
  String get purchaseHistoryPaidDate => 'تاريخ الدفع';

  @override
  String get purchaseHistoryEmptyTitle => 'لا توجد مشتريات سابقة حتى الآن';

  @override
  String get purchaseHistoryEmptyDesc =>
      'لم تقم بشراء أي كورسات بعد.\nجميع عمليات الشراء والفواتير الخاصة بك ستظهر هنا فور إتمامها.';

  @override
  String get purchaseHistoryExploreCourses => 'استكشف الكورسات الآن';

  @override
  String get profileMyCourses => 'دوراتي التعليمية';

  @override
  String get profileMyCoursesSubtitle => 'متابعة تقدمك في الدورات المسجلة';

  @override
  String get profileWishlistSubtitle => 'الكورسات المحفوظة في قائمة الرغبات';

  @override
  String get navMyLearning => 'تعلمي';

  @override
  String get profileLogoutSafeNote =>
      'بياناتك، دوراتك، وشهاداتك محفوظة بالكامل، ويمكنك متابعة تعلمك في أي وقت بمجرد تسجيل الدخول مجدداً.';

  @override
  String learningRemainingHours(String hours) {
    return 'متبقي $hours ساعة';
  }

  @override
  String get learningCompletedFull => 'مكتملة بالكامل';

  @override
  String get learningFilterNotStarted => 'لم تبدأ بعد';

  @override
  String get wishlistTopRatedBadge => 'الأعلى تقييماً';

  @override
  String get wishlistFeaturedBadge => 'دورة مميزة';

  @override
  String wishlistDiscountBadge(String percent) {
    return 'خصم $percent%';
  }
}

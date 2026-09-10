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
  String get learningCompletedBadge => 'مكتمل بالكامل ✓';

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
  String get homePromoInstructorBadge => 'فرصة تدريبية • شارك خبرتك';

  @override
  String get homePromoInstructorTitle => 'انضم معنا كمدرب وشارك شغفك';

  @override
  String get homePromoInstructorSubtitle =>
      'انضم لنخبة المعلمين، أنشئ دوراتك الخاصة، واكسب دخلاً إضافياً مع آلاف الطلاب.';

  @override
  String get homePromoInstructorButton => 'قدّم طلبك الآن';

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

  @override
  String get courseFree => 'مجاناً';

  @override
  String get badgeBestseller => 'الأعلى مبيعاً';

  @override
  String get badgeTopRated => 'الأعلى تقييماً';

  @override
  String get badgeFeatured => 'مميز';

  @override
  String get badgeRecommended => 'موصى به لك';

  @override
  String get badgeNew => 'جديد';

  @override
  String get courseWord => 'دورة';

  @override
  String coursesCountText(String count) {
    return '$count+ دورة';
  }

  @override
  String studentsCountText(String count) {
    return '$count طالب';
  }

  @override
  String hoursCountText(String count) {
    return '$count ساعة';
  }

  @override
  String get certifiedInstructor => 'مدرب معتمد';

  @override
  String get expertCertifiedInstructor => 'خبير ومدرب معتمد';

  @override
  String get defaultCourseTitle => 'دورة تعليمية';

  @override
  String get categoryWord => 'تصنيف';

  @override
  String get previewCourseVideo => 'معاينة فيديو الدورة';

  @override
  String get freeSection => 'القسم المجاني';

  @override
  String get freeDemoVideo => 'فيديو تجريبي';

  @override
  String get articleLecture => 'مقالة تعليمية';

  @override
  String get articleViewer => 'عارض المقالات';

  @override
  String get courseVideoPlayer => 'مشغل فيديو الدورة';

  @override
  String get playingNow => 'مشغل الآن';

  @override
  String get readingNow => 'قراءة الآن';

  @override
  String get noLecturesInFreeSection => 'لا توجد دروس في القسم المجاني';

  @override
  String freeLecturesCount(String count) {
    return '$count دروس مجانية';
  }

  @override
  String get enrollInFullCourse => 'اشترك الآن في الدورة كاملة';

  @override
  String get articleWord => 'مقالة';

  @override
  String get videoWord => 'فيديو';

  @override
  String get quizWord => 'اختبار';

  @override
  String get courseShareCopied => 'تم نسخ رابط الدورة للمشاركة!';

  @override
  String get addedToCartSnackbar => 'تمت إضافة الدورة إلى السلة';

  @override
  String get viewCartAction => 'عرض السلة';

  @override
  String get inCartBadge => 'في السلة ✓';

  @override
  String get addToCartButton => 'أضف للسلة';

  @override
  String get wishlistAddedSnackbar =>
      'تمت إضافة الدورة إلى قائمة الرغبات بنجاح';

  @override
  String get wishlistRemovedSuccessSnackbar =>
      'تمت إزالة الدورة من قائمة الرغبات';

  @override
  String get lessonCompletedAll =>
      'تهانينا! لقد أنهيت جميع دروس هذه الدورة التدريبية.';

  @override
  String get noteAddedSuccess => 'تمت إضافة الملاحظة بنجاح';

  @override
  String get lessonAlreadyDownloaded =>
      'الدرس محفوظ بالفعل للمشاهدة دون إنترنت';

  @override
  String get lessonLinkCopied => 'تم نسخ رابط الدرس إلى الحافظة';

  @override
  String get contentReportThanks =>
      'شكراً لملاحظتك، سيتم فحص الدرس من قبل الفريق الفني';

  @override
  String get courseCompletionCertificate => 'شهادة إتمام الدورة';

  @override
  String get reportContentIssue => 'الإبلاغ عن مشكلة في المحتوى';

  @override
  String get loginOrSocial => 'أو الدخول بواسطة';

  @override
  String get loginSuccessSnackbar => 'تم تسجيل الدخول بنجاح';

  @override
  String get cartClearDialogTitle => 'تفريغ السلة';

  @override
  String get cartClearDialogMessage =>
      'هل أنت متأكد من رغبتك في حذف جميع الدورات من سلة الشراء؟';

  @override
  String get cartClearConfirmButton => 'تفريغ';

  @override
  String get guestWelcomeTitle => 'مرحباً بك في EduLab';

  @override
  String get guestWelcomeSubtitle => 'سجّل دخولك لمتابعة دوراتك وشهاداتك';

  @override
  String get securitySetup2FATitle => 'إعداد التحقق بخطوتين (2FA)';

  @override
  String get securityScanQRCode => 'قم بمسح رمز الـ QR بتطبيق المصادقة';

  @override
  String get securitySecretKeyManual => 'المفتاح السري (للإدخال اليدوي)';

  @override
  String get securitySecretKeyCopied => 'تم نسخ المفتاح السري';

  @override
  String get securityEnter6DigitCode => 'أدخل رمز التحقق (6 أرقام):';

  @override
  String get securityConfirmEnable2FABtn => 'تأكيد وتفعيل التحقق بخطوتين';

  @override
  String get securityEnter6DigitsError =>
      'يرجى إدخال رمز التحقق المكون من 6 أرقام';

  @override
  String get securityLogoutAllDevicesTitle => 'تسجيل الخروج من كافة الأجهزة';

  @override
  String get securityLogoutAllDevicesMessage =>
      'هل أنت متأكد من رغبتك في تسجيل الخروج وإنهاء جميع الجلسات المفتوحة على الهواتف والمتصفحات الأخرى؟\nستظل مسجلاً للدخول على هذا الجهاز فقط.';

  @override
  String get securityLogoutAllDevicesConfirmBtn => 'تأكيد تسجيل الخروج من الكل';

  @override
  String get securityDisable2FAModalTitle => 'تعطيل التحقق بخطوتين';

  @override
  String get securityDisable2FAModalMessage =>
      'تعطيل هذه الميزة سيقلل من مستوى حماية حسابك.\nهل أنت متأكد من رغبتك في المتابعة؟';

  @override
  String get securityDisable2FAConfirmBtn => 'تعطيل التحقق بخطوتين';

  @override
  String get securityNoOtherSessions => 'لا توجد جلسات أو أجهزة متصلة أخرى';

  @override
  String get securityCurrentDeviceOnly =>
      'أنت مسجل الدخول حالياً من هذا الجهاز فقط';

  @override
  String get securityShowLessDevices => 'عرض أجهزة أقل';

  @override
  String securityShowAllDevicesCount(String count) {
    return 'عرض كافة الأجهزة ($count)';
  }

  @override
  String get securityUpdatingPassword => 'جاري تحديث كلمة المرور...';

  @override
  String get editProfileTakePhotoDesc => 'التقاط صورة جديدة بواسطة الكاميرا';

  @override
  String get editProfileChooseGalleryDesc =>
      'اختيار صورة محفوظة من ألبوم الصور';

  @override
  String get editProfileHeadlineError => 'المسمى الوظيفي مطلوب';

  @override
  String get editProfileLocationError => 'الموقع مطلوب';

  @override
  String get editProfilePhoneError => 'رقم الهاتف مطلوب';

  @override
  String get editProfileBioError => 'النبذة التعريفية مطلوبة';

  @override
  String get editProfileSavingChanges => 'جاري حفظ التعديلات...';

  @override
  String get themeLight => 'فاتح';

  @override
  String get themeDark => 'داكن';

  @override
  String get themeSystem => 'تلقائي';

  @override
  String get teachFullNameRequired => 'أدخل الاسم كاملاً';

  @override
  String get teachHeadlineRequired => 'أدخل المسمى المهني';

  @override
  String get teachPhoneRequired => 'أدخل رقم الهاتف';

  @override
  String get teachCountryRequired => 'أدخل بلد الإقامة';

  @override
  String get teachBioMinLength => 'يرجى كتابة نبذة لا تقل عن 20 حرفاً';

  @override
  String get teachSubmittingApplication => 'جاري الإرسال...';

  @override
  String get wishlistFailedAddToCart => 'فشل إضافة الدورة إلى السلة';

  @override
  String get cartClearAllTitle => 'تفريغ سلة الشراء بالكامل؟';

  @override
  String cartClearAllMessage(String count) {
    return 'هل أنت متأكد من رغبتك في حذف جميع الدورات ($count) من سلة الشراء؟';
  }

  @override
  String get cartClearAllHint =>
      'سيتم تفريغ سلة الشراء بالكامل، ويمكنك إعادة إضافة أي دورة لاحقاً من قسم الدورات أو المفضلة.';

  @override
  String cartClearAllConfirm(String count) {
    return 'تفريغ الكل ($count)';
  }

  @override
  String get cartClearedSuccess => 'تم تفريغ سلة الشراء بنجاح';

  @override
  String get cartClearFailed => 'حدث خطأ أثناء تفريغ سلة الشراء';

  @override
  String cartViewWishlistCount(String count) {
    return 'عرض المحفوظات في قائمة الرغبات ($count)';
  }

  @override
  String get cartGoToWishlist => 'الانتقال إلى قائمة الرغبات';

  @override
  String get wishlistClearAllTitle => 'مسح جميع عناصر المفضلة؟';

  @override
  String wishlistClearAllMessage(String count) {
    return 'هل أنت متأكد من رغبتك في حذف جميع الدورات ($count) من قائمة المفضلة؟';
  }

  @override
  String get wishlistClearAllHint =>
      'سيتم حذف الدورات المحفوظة من قائمتك، ويمكنك إعادة إضافتها لاحقاً في أي وقت من قسم الاستكشاف.';

  @override
  String wishlistClearAllConfirm(String count) {
    return 'مسح الكل ($count)';
  }

  @override
  String get wishlistClearedSuccess => 'تم تفريغ قائمة المفضلة بنجاح';

  @override
  String get wishlistClearFailed => 'حدث خطأ أثناء تفريغ قائمة المفضلة';

  @override
  String get wishlistClearTooltip => 'مسح الكل';

  @override
  String wishlistViewCartCount(String count) {
    return 'عرض سلة المشتريات ($count)';
  }

  @override
  String get wishlistGoToCart => 'الانتقال إلى سلة المشتريات';

  @override
  String get checkoutCardNumberInvalid =>
      'يرجى إدخال رقم بطاقة صحيح مكون من 16 رقم';

  @override
  String get checkoutCardExpiryInvalidFormat =>
      'يرجى إدخال تاريخ انتهاء البطاقة بشكل صحيح (MM / YY)';

  @override
  String get checkoutCardExpiredDate => 'تاريخ انتهاء البطاقة غير صالح';

  @override
  String get checkoutCardCvcInvalid =>
      'يرجى إدخال رمز الأمان CVC المكون من 3 أو 4 أرقام';

  @override
  String get checkoutCardHolderNameRequired => 'يرجى إدخال اسم صاحب البطاقة';

  @override
  String get checkoutCartEmptySnackbar => 'سلة المشتريات فارغة';

  @override
  String get checkoutPaymentStartFailed => 'تعذر بدء عملية الدفع';

  @override
  String get checkoutClientSecretMissing =>
      'لم يتم استلام مفتاح الأمان من بوابة الدفع';

  @override
  String get checkoutCardVerificationFailed => 'فشل التحقق من بيانات البطاقة';

  @override
  String get checkoutStripeProcessingFailed => 'فشلت معالجة الدفع عبر Stripe';

  @override
  String get checkoutServerConfirmationFailed => 'فشل تأكيد العملية في السيرفر';

  @override
  String get checkoutEmptyCartTitle => 'سلة الشراء فارغة';

  @override
  String get checkoutEmptyCartDesc =>
      'لم تقم بإضافة أي دورات للسلة بعد. تصفح الكورسات وأضف ما يناسبك للمتابعة للدفع.';

  @override
  String get checkoutContinueFreeReview => 'المتابعة لتأكيد الطلب المجاني';

  @override
  String get checkoutFreeOrderBadge => 'طلب مجاني بالكامل (0.00 \$)';

  @override
  String get checkoutFreeOrderNotice =>
      'لا يتطلب هذا الطلب إدخال أي بيانات دفع أو بطاقة ائتمان. يمكنك المتابعة مباشرة لتأكيد التسجيل.';

  @override
  String get checkoutFreeCheckoutTitle => 'مجاني بالكامل (بدون رسوم)';

  @override
  String get checkoutConfirmFreeEnrollment => 'تأكيد التسجيل المجاني';

  @override
  String get checkoutFreePrice => 'مجاني';

  @override
  String get checkoutFreeZero => 'مجاني (zsh.00)';

  @override
  String checkoutCoursesCount(String count) {
    return '$count دورات';
  }

  @override
  String get notificationsClearAllTitle => 'مسح كافة الإشعارات؟';

  @override
  String notificationsClearAllMessage(String count) {
    return 'هل أنت متأكد من رغبتك في حذف جميع الإشعارات ($count)؟ لا يمكن التراجع عن هذا الإجراء.';
  }

  @override
  String get notificationsClearAllHint =>
      'سيتم حذف جميع إشعاراتك وسيبدأ صندوق الوارد نظيفاً من جديد.';

  @override
  String notificationsClearAllConfirm(String count) {
    return 'مسح الكل ($count)';
  }

  @override
  String get notificationsClearSuccess => 'تم مسح كافة الإشعارات بنجاح';

  @override
  String get notificationsClearFailed => 'فشل مسح الإشعارات';

  @override
  String get notificationsClearTooltip => 'مسح الكل';

  @override
  String get notificationsViewDetails => 'عرض التفاصيل';

  @override
  String get notificationsEmptyCategoryTitle =>
      'لا توجد إشعارات في هذا التصنيف';

  @override
  String get notificationsEmptyCategorySubtitle =>
      'جرب التبديل لتصنيف آخر أو تصفح كافة الإشعارات';

  @override
  String get notificationsEmptyAllSubtitle =>
      'سنوافيك فوراً بآخر التحديثات والتنبيهات المتعلقة بدوراتك وعروضك هنا';

  @override
  String get notificationsViewAll => 'عرض كافة الإشعارات';

  @override
  String get learningFilterAndSortTitle => 'تصفية وترتيب الدورات';

  @override
  String get learningFilterReset => 'إعادة ضبط';

  @override
  String get learningSortByTitle => 'ترتيب حسب';

  @override
  String get learningSortRecentActivity => 'النشاط الأخير';

  @override
  String get learningSortRecentEnrolled => 'أحدث التسجيلات';

  @override
  String get learningSortTitleAZ => 'العنوان (أ-ي)';

  @override
  String get learningSortProgress => 'نسبة الإنجاز';

  @override
  String get learningStatusTitle => 'حالة الدورة';

  @override
  String get learningStatusAll => 'جميع الدورات';

  @override
  String get learningStatusInProgress => 'قيد التعلم';

  @override
  String get learningStatusCompleted => 'مكتملة';

  @override
  String get learningStatusNotStarted => 'لم تبدأ بعد';

  @override
  String get learningFilterApply => 'تطبيق التصفية';

  @override
  String get learningSearchCoursesHint => 'ابحث في دوراتك...';

  @override
  String get learningSearchWishlistHint => 'ابحث في المفضلة...';

  @override
  String get learningSearchCertificatesHint => 'ابحث في الشهادات...';

  @override
  String get learningTabMyCourses => 'دوراتي';

  @override
  String get learningTabFavourite => 'المفضلة';

  @override
  String get learningTabCertificates => 'شهاداتي';

  @override
  String get learningNoCoursesTitle => 'لا توجد دورات مسجلة';

  @override
  String get learningNoCoursesSubtitle =>
      'استكشف آلاف الدورات المتميزة وابدأ مسيرتك التعليمية وتطوير مهاراتك اليوم';

  @override
  String get learningFilterButton => 'تصفية';

  @override
  String learningFilterAllCount(String count) {
    return 'الكل ($count)';
  }

  @override
  String get learningStatusNotStartedShort => 'لم تبدأ';

  @override
  String get learningNoMatchTitle => 'لا توجد نتائج تطابق بحثك';

  @override
  String learningNoMatchSubtitle(String query) {
    return 'لم نجد دورات تحتوي على \"$query\". جرب البحث بكلمات أخرى.';
  }

  @override
  String get learningNoInProgressTitle => 'لا توجد دورات قيد التعلم';

  @override
  String get learningNoInProgressSubtitle =>
      'ابدأ بمشاهدة الدروس في دوراتك المسجلة لتتابع تقدمك هنا بسهولة.';

  @override
  String get learningNoCompletedTitle => 'لم تكمل أي دورة بعد';

  @override
  String get learningNoCompletedSubtitle =>
      'واصل دراستك وأكمل الاختبارات لتشهد إنجازك وتظهر دوراتك المكتملة هنا.';

  @override
  String get learningNoUnstartedTitle => 'لا توجد دورات غير مبدوءة';

  @override
  String get learningNoUnstartedSubtitle =>
      'رائع! لقد بدأت التعلم بالفعل في جميع الدورات المسجلة لديك.';

  @override
  String get learningNoFilterMatchTitle => 'لا توجد دورات تطابق التصفية';

  @override
  String get learningNoFilterMatchSubtitle =>
      'قم بتغيير خيارات التصفية أو الفرز لعرض دوراتك.';

  @override
  String learningViewAllCoursesCount(String count) {
    return 'عرض جميع الدورات ($count)';
  }

  @override
  String learningSavedCoursesCount(String count) {
    return 'الدورات المفضلة ($count)';
  }

  @override
  String get learningClearAllSaved => 'مسح الكل';

  @override
  String get learningNoCertificatesTitle => 'لا توجد شهادات حتى الآن';

  @override
  String get learningNoCertificatesSubtitle =>
      'أكمل دوراتك التعليمية واجتز الاختبارات لتحصل على شهادات معتمدة توثق إنجازاتك';

  @override
  String get learningGoToCourses => 'متابعة دوراتي';

  @override
  String learningCertIssuedDate(String date) {
    return 'تاريخ الإصدار: $date';
  }

  @override
  String get learningCertView => 'عرض';

  @override
  String get learningResumeLesson => 'متابعة الدرس';

  @override
  String learningProgressPercentComplete(String percent) {
    return '$percent% مكتمل';
  }

  @override
  String learningViewCartCount(String count) {
    return 'عرض سلة المشتريات ($count)';
  }

  @override
  String get learningGoToCart => 'الانتقال إلى سلة المشتريات';

  @override
  String get playerLessonMarkedCompleted => 'تم تحديد الدرس كمكتمل ✓';

  @override
  String get playerLessonMarkedIncomplete => 'تم إلغاء اكتمال الدرس';

  @override
  String get playerCommentPostedSuccess => 'تمت إضافة سؤالك بنجاح';

  @override
  String get playerCommentPostFailed => 'تعذر إرسال التعليق';

  @override
  String get playerReplyPostedSuccess => 'تمت إضافة الرد بنجاح';

  @override
  String get playerReplyPostFailed => 'تعذر إرسال الرد';

  @override
  String get playerCourseNotFound => 'لم يتم العثور على الدورة التعليمية';

  @override
  String get playerCheckEnrollmentPrompt =>
      'يرجى التأكد من تسجيلك بالدورة أولاً';

  @override
  String get playerReturnToCourses => 'العودة للدورات';

  @override
  String get playerWatchLecture => 'مشاهدة المحاضرة';

  @override
  String get playerCertificateTooltip => 'شهادة الإتمام';

  @override
  String get playerRateCourseTooltip => 'تقييم الدورة';

  @override
  String get playerReadingArticleBadge => 'مقال تعليمي مقروء • 5 دقائق';

  @override
  String get playerReadFullTextBelow => 'محتوى الدرس متاح بالكامل في الأسفل ↓';

  @override
  String get playerTabReviews => 'التقييمات';

  @override
  String get playerNoSectionsAvailable => 'لا توجد أقسام تعليمية متاحة';

  @override
  String playerLessonsCount(String count) {
    return '$count دروس';
  }

  @override
  String get playerPlayingBadge => 'مشغل الآن';

  @override
  String get playerArticleBadge => 'مقال تعليمي';

  @override
  String get playerVideoBadge => 'فيديو';

  @override
  String get playerFullArticleContent => 'محتوى المقال الكامل';

  @override
  String get playerArticlePlaceholder =>
      'مرحباً بك في هذا الدرس المقروء.\n\nيتناول هذا الجزء المفاهيم الأساسية والخطوات العملية التي تحتاج إليها لإتقان المهارات المطلوبة في هذا الدرس.';

  @override
  String get playerAboutCourseTitle => 'عن هذه الدورة التدريبية';

  @override
  String get playerShowLess => 'عرض أقل';

  @override
  String get playerReadMore => 'قراءة المزيد';

  @override
  String get playerWhatYouWillLearn => 'ماذا ستتعلم في هذه الدورة';

  @override
  String get playerCourseInfoTitle => 'معلومات الدورة التدريبية';

  @override
  String get playerTotalDurationTitle => 'المدة الإجمالية';

  @override
  String get playerTotalLessonsTitle => 'المحاضرات';

  @override
  String playerLessonsNumber(String count) {
    return '$count محاضرة';
  }

  @override
  String get playerLevelTitle => 'المستوى';

  @override
  String get playerAllLevels => 'جميع المستويات';

  @override
  String get playerLanguageTitle => 'لغة الشرح';

  @override
  String get playerLanguageArabic => 'العربية';

  @override
  String get playerPrerequisitesTitle => 'المتطلبات المسبقة';

  @override
  String get playerCertificateCardTitle => 'شهادة الإتمام المعتمدة';

  @override
  String get playerCourseCompletedSuccess =>
      'تهانينا! تم إكمال جميع الدروس بنجاح';

  @override
  String get playerProgressLabel => 'التقدم';

  @override
  String get playerViewCertificateBtn => 'عرض الشهادة';

  @override
  String get playerCertifiedInstructor => 'مدرب معتمد لدى EduLab';

  @override
  String playerDiscussionsCount(String count) {
    return '$count أسئلة ومناقشات';
  }

  @override
  String get playerAskQuestionHint => 'اكتب سؤالك أو استفسارك هنا...';

  @override
  String get playerPostBtn => 'إرسال';

  @override
  String get playerNoDiscussionsTitle => 'لا توجد أسئلة أو مناقشات بعد';

  @override
  String get playerNoDiscussionsSubtitle =>
      'كن أول من يطرح سؤالاً في هذا الدرس!';

  @override
  String get playerInstructorBadge => 'المدرب';

  @override
  String get playerCancelReply => 'إلغاء';

  @override
  String get playerReplyAction => 'رد';

  @override
  String playerRepliesCount(String count) {
    return '$count ردود';
  }

  @override
  String get playerWriteReplyHint => 'اكتب ردك هنا...';

  @override
  String get playerSendReplyBtn => 'إرسال';

  @override
  String get playerCourseFeedbackTitle => 'تقييمات الدورة التدريبية';

  @override
  String get playerOutOf5 => 'من 5 نجوم';

  @override
  String playerRatingsFromEnrolledCount(String count) {
    return '$count تقييم من الطلاب المشتركين';
  }

  @override
  String get playerKeepLearningToRate => 'واصل التعلم لتقييم الدورة';

  @override
  String get playerRateAfter80Hint =>
      'يمكنك تقييم ومراجعة الدورة بعد إنجاز 80% من محتواها';

  @override
  String get playerCurrentProgressLabel => 'نسبة إنجازك الحالية:';

  @override
  String get playerYourCurrentRating => 'تقييمك الحالي للدورة';

  @override
  String get playerEditRating => 'تعديل التقييم';

  @override
  String get playerDeleteRatingTooltip => 'حذف التقييم';

  @override
  String get playerUpdateRatingTitle => 'تعديل تقييمك للدورة';

  @override
  String get playerRateCourseTitle => 'شاركنا تقييمك للدورة';

  @override
  String get playerWriteReviewHint =>
      'اكتب تعليقك وانطباعك عن جودة الشرح والمحتوى (اختياري)...';

  @override
  String get playerRatingSubmitSuccess => 'تم حفظ تقييمك بنجاح! شكراً لك';

  @override
  String get playerRatingSubmitFailed => 'تعذر حفظ التقييم';

  @override
  String get playerSaveChangesBtn => 'حفظ التعديلات';

  @override
  String get playerSubmitReviewBtn => 'إرسال التقييم';

  @override
  String get playerLearnerReviewsTitle => 'تقييمات وآراء الطلاب';

  @override
  String playerReviewsCount(String count) {
    return '$count مراجعة';
  }

  @override
  String get playerNoWrittenReviewsTitle => 'لا توجد تقييمات مكتوبة مضافة بعد';

  @override
  String get playerNoWrittenReviewsSubtitle =>
      'كن أول من يشارك انطباعه عن هذه الدورة!';

  @override
  String get playerRatingLabel5 => 'ممتاز جداً 🌟 (5/5)';

  @override
  String get playerRatingLabel4 => 'جيد جداً 👍 (4/5)';

  @override
  String get playerRatingLabel3 => 'متوسط 👌 (3/5)';

  @override
  String get playerRatingLabel2 => 'يحتاج تحسين 🤔 (2/5)';

  @override
  String get playerRatingLabel1 => 'ضعيف 👎 (1/5)';

  @override
  String get playerDeleteRatingDialogTitle => 'حذف التقييم';

  @override
  String get playerDeleteRatingDialogMessage =>
      'هل أنت متأكد من رغبتك في حذف تقييمك لهذه الدورة؟';

  @override
  String get playerDeleteConfirmBtn => 'حذف';

  @override
  String get playerRatingDeleteSuccess => 'تم حذف تقييمك بنجاح';

  @override
  String get playerPreviousLesson => 'الدرس السابق';

  @override
  String get playerExitFullscreenTooltip => 'الخروج من ملء الشاشة';

  @override
  String instructorsAvailableCount(String count) {
    return '$count مدرب متاح';
  }

  @override
  String get instructorsNotFound => 'لم يتم العثور على نتائج';

  @override
  String instructorsCoursesCount(String count) {
    return '$count دورات';
  }

  @override
  String get instructorsSearchHint => 'ابحث باسم المدرب أو التخصص...';

  @override
  String get instructorsSortAll => 'الكل';

  @override
  String get instructorsSortTopRated => 'الأعلى تقييماً';

  @override
  String get instructorsSortMostStudents => 'الأكثر طلاباً';

  @override
  String get instructorsSortMostCourses => 'الأكثر دورات';

  @override
  String get instructorsNotFoundSubtitle =>
      'جرب البحث باسم آخر أو إزالة التصفية';

  @override
  String get exploreCompleteCourse => 'دورة متكاملة';

  @override
  String get exploreGeneralCategory => 'عام';

  @override
  String courseShareMessage(String title, String url) {
    return 'شاهد دورة \"$title\" على تطبيق EduLab: $url';
  }

  @override
  String get courseDetailsDefaultTitle => 'تفاصيل الدورة';

  @override
  String get courseDetailsTooltipShare => 'مشاركة';

  @override
  String get courseDetailsTooltipWishlist => 'المفضلة';

  @override
  String get courseDetailsTooltipCart => 'السلة';

  @override
  String get courseDetailsNotFound => 'لم يتم العثور على الدورة';

  @override
  String get courseDetailsDefaultCategory => 'دورة تدريبية';

  @override
  String courseDetailsTotalRatingsCount(String count) {
    return '($count تقييم)';
  }

  @override
  String courseDetailsLecturesCount(String count) {
    return '$count درساً';
  }

  @override
  String get courseDetailsCertificateBadge => 'شهادة';

  @override
  String get courseDetailsTabOverview => 'نظرة عامة';

  @override
  String get courseDetailsTabCurriculum => 'محتوى الدورة';

  @override
  String get courseDetailsTabInstructor => 'عن المدرب';

  @override
  String get courseDetailsTabReviews => 'التقييمات';

  @override
  String get courseDetailsFullDescriptionTitle => 'الوصف الشامل للدورة';

  @override
  String get courseDetailsShowLess => 'عرض أقل';

  @override
  String get courseDetailsShowMore => 'عرض المزيد...';

  @override
  String courseDetailsCurriculumSectionsLectures(
    String sections,
    String lectures,
  ) {
    return '$sections أقسام • $lectures درساً';
  }

  @override
  String get courseDetailsCollapseAll => 'طي الكل';

  @override
  String get courseDetailsExpandAll => 'توسيع الكل';

  @override
  String get courseDetailsCurriculumComingSoon =>
      'سيتم إضافة محتوى الدروس قريباً';

  @override
  String courseDetailsSectionLecturesCount(String count) {
    return '$count دروس';
  }

  @override
  String get courseDetailsLecturePreviewBtn => 'معاينة';

  @override
  String get courseDetailsDefaultInstructorTitle => 'مدرب وخبير تقني معتمد';

  @override
  String get courseDetailsInstructorRatingLabel => 'تقييم الدورة';

  @override
  String get courseDetailsInstructorStudentsLabel => 'طالب';

  @override
  String get courseDetailsInstructorSectionsLabel => 'أقسام';

  @override
  String get courseDetailsAboutInstructorTitle => 'نبذة عن المدرب:';

  @override
  String get courseDetailsDefaultInstructorAbout =>
      'مدرب معتمد ذو خبرة عملية واسعة في تقديم المحتوى الأكاديمي والمهني لآلاف الطلاب والمهندسين حول العالم.';

  @override
  String courseDetailsStudentRatingsCount(String count) {
    return '$count تقييم من الطلاب';
  }

  @override
  String get courseDetailsNoWrittenReviews => 'لا توجد مراجعات مكتوبة بعد';

  @override
  String get courseDetailsRelatedCourses => 'دورات ذات صلة قد تعجبك';

  @override
  String courseDetailsDiscountPercent(String percent) {
    return 'خصم $percent%';
  }

  @override
  String get courseDetailsResumeCourse => 'متابعة الدورة';

  @override
  String get courseDetailsTryAgain => 'إعادة المحاولة';

  @override
  String get courseDetailsEstimatedReading => '📖 وقت القراءة المقدر: 4 دقائق';

  @override
  String get courseDetailsSampleArticleContent =>
      'مرحباً بك في هذا الدرس المقروء.\n\nيتناول هذا الجزء المفاهيم الأساسية والخطوات العملية التي تحتاج لمعرفتها لفهم الموضوع بعمق.\n\n• النقاط الجوهرية:\n1. استيعاب البنية الهيكلية وأهم المصطلحات.\n2. التطبيق العملي والتدريب المستمر.\n3. مراجعة المصادر والملاحظات المرفقة.\n\nنتمنى لك قراءة ممتعة وتعلماً مثمراً!';

  @override
  String certDownloadedSuccess(String course, String format) {
    return 'تم تنزيل شهادة \"$course\" بصيغة $format بنجاح!';
  }

  @override
  String certVerifiedFullRequirements(String code) {
    return 'رقم التحقق: $code • تم إكمال كافة المتطلبات 100%';
  }

  @override
  String get certCompletionTitle => 'شهادة إتمام';

  @override
  String get certCompletionSubtitle => 'شهادة إتمام دورة تدريبية';

  @override
  String get certAnnounceStudent =>
      'تعلن منصة EducationLab التعليمية بأن الطالب/طالبة:';

  @override
  String get certCompletionRequirementsMet =>
      'قد أتم بنجاح وكفاءة جميع متطلبات الدورة التدريبية:';

  @override
  String certIssueDateText(String date) {
    return 'تاريخ الإصدار: $date';
  }

  @override
  String certIdNumberText(String code) {
    return 'رقم الشهادة: $code';
  }

  @override
  String get certPlatformManagement => 'إدارة المنصة';

  @override
  String get certInstructorRoleTitle => 'المحاضر / المدرب';

  @override
  String get commonLoading => 'جاري التحميل...';

  @override
  String get homeGuestTagline => 'منصة التعلم الذكي وتطوير المهارات';

  @override
  String get catTagHighestDemand => 'الأعلى طلباً';

  @override
  String get catTagMostPopular => 'الأكثر شعبية';

  @override
  String get catTagTrending => 'شائع ومطلوب';

  @override
  String get catTagFastestGrowing => 'الأسرع نمواً';

  @override
  String get catTagHighDemand => 'مطلوب جداً';

  @override
  String get catTagTopRated => 'الأعلى تقييماً';

  @override
  String get catTagEssential => 'شديد الأهمية';

  @override
  String get catTagAdvanced => 'مستوى متقدم';

  @override
  String get catTagEntrepreneurs => 'رواد الأعمال';

  @override
  String get catTagSalesGrowth => 'نمو المبيعات';

  @override
  String get catDevTitle => 'البرمجة وتطوير البرمجيات';

  @override
  String get catDevSubtitle => 'تطوير البرمجيات والأنظمة والخوارزميات';

  @override
  String get catWebTitle => 'تطوير الويب';

  @override
  String get catWebSubtitle => 'تطوير الواجهات الأمامية والخلفية للمواقع';

  @override
  String get catMobileTitle => 'تطوير تطبيقات الموبايل';

  @override
  String get catMobileSubtitle =>
      'تطبيقات Flutter و iOS و Android الهجينة والأصلية';

  @override
  String get catAiTitle => 'الذكاء الاصطناعي';

  @override
  String get catAiSubtitle => 'تعلم الآلة والتعلم العميق وتطبيقات AI';

  @override
  String get catDataTitle => 'علوم البيانات وتحليلها';

  @override
  String get catDataSubtitle => 'تحليل البيانات، الإحصاء والبيانات الضخمة';

  @override
  String get catDesignTitle => 'تصميم واجهات المستخدم UI/UX';

  @override
  String get catDesignSubtitle =>
      'تصميم واجهات وتجربة المستخدم والنماذج الأولية';

  @override
  String get catSecurityTitle => 'أمن المعلومات والسيبراني';

  @override
  String get catSecuritySubtitle => 'أمن المعلومات والاختراق الأخلاقي والشبكات';

  @override
  String get catCloudTitle => 'الحوسبة السحابية و DevOps';

  @override
  String get catCloudSubtitle =>
      'البنية السحابية وإدارة النظم و DevOps و Docker';

  @override
  String get catBusinessTitle => 'إدارة الأعمال والمشاريع';

  @override
  String get catBusinessSubtitle => 'ريادة الأعمال وإدارة المشاريع والقيادة';

  @override
  String get catMarketingTitle => 'التسويق الرقمي';

  @override
  String get catMarketingSubtitle =>
      'التسويق الرقمي، محركات البحث وإعلانات النمو';

  @override
  String get timeJustNow => 'الآن';

  @override
  String timeMinutesAgo(String count) {
    return 'منذ $count دقيقة';
  }

  @override
  String timeHoursAgo(String count) {
    return 'منذ $count ساعة';
  }

  @override
  String timeDaysAgo(String count) {
    return 'منذ $count يوم';
  }

  @override
  String timeWeeksAgo(String count) {
    return 'منذ $count أسبوع';
  }

  @override
  String timeMonthsAgo(String count) {
    return 'منذ $count شهر';
  }

  @override
  String wishlistLecturesCount(String count) {
    return '$count محاضرة';
  }

  @override
  String get instructorProfileTitle => 'الملف التعريفي للمدرب';

  @override
  String instructorProfileLinkCopied(String name) {
    return 'تم نسخ رابط ملف $name';
  }

  @override
  String get instructorDefaultName => 'المدرب';

  @override
  String get instructorProfileBadge => 'المحاضر المعتمد';

  @override
  String get instructorProfileTotalStudents => 'إجمالي الطلاب';

  @override
  String get instructorProfileRating => 'تقييم المدرب';

  @override
  String get instructorProfileCourses => 'الدورات';

  @override
  String get instructorProfileShare => 'مشاركة الملف التعريفي';

  @override
  String get instructorProfileLinkOpenError =>
      'تعذر فتح الرابط، تم نسخه للحافظة';

  @override
  String get instructorProfileWebsite => 'الموقع الإلكتروني';

  @override
  String get instructorProfileAboutMe => 'عن المدرب';

  @override
  String get instructorProfileShowLess => 'عرض أقل';

  @override
  String get instructorProfileShowMore => 'عرض المزيد';

  @override
  String get instructorProfileExpertise => 'مجالات الخبرة والتخصص';

  @override
  String get instructorProfileSortAll => 'الكل';

  @override
  String get instructorProfileSortTopRated => 'الأعلى تقييماً';

  @override
  String get instructorProfileSortPopular => 'الأكثر شعبية';

  @override
  String get instructorProfileSortNewest => 'الأحدث';

  @override
  String get instructorProfileCoursesTitle => 'دورات المدرب';

  @override
  String get instructorProfileNoCoursesFilter =>
      'لا توجد دورات مطابقة للفلتر المحدد';

  @override
  String instructorProfileLoadMoreCourses(String count) {
    return 'عرض المزيد من الدورات ($count متبقية)';
  }

  @override
  String get instructorProfileLoadingMoreCourses =>
      'جاري تحميل المزيد من الدورات...';

  @override
  String instructorProfileAllCoursesLoaded(String count) {
    return 'تم عرض جميع الدورات ($count دورة)';
  }

  @override
  String get instructorProfileStudentFeedback => 'آراء وتقييمات الطلاب';

  @override
  String instructorProfileReviewsCount(String count) {
    return '$count تقييم';
  }

  @override
  String instructorProfileBasedOnReviews(String count) {
    return 'بناءً على $count تقييم';
  }

  @override
  String get instructorProfileRecentReviews => 'أحدث التقييمات والمراجعات';

  @override
  String instructorProfileLoadMoreReviews(String count) {
    return 'عرض المزيد من التقييمات ($count متبقية)';
  }

  @override
  String get instructorProfileLoadingMoreReviews =>
      'جاري تحميل المزيد من التقييمات...';

  @override
  String instructorProfileAllReviewsLoaded(String count) {
    return 'تم عرض جميع التقييمات ($count تقييم)';
  }

  @override
  String get instructorProfileNoReviewsYet => 'لا توجد تقييمات مكتوبة حتى الآن';

  @override
  String get instructorProfileRatingDesc =>
      'التقييم العام مبني على إجمالي آراء الطلاب في دورات هذا المدرب';

  @override
  String get instructorProfileLoadError =>
      'تعذر تحميل بيانات المدرب، يرجى المحاولة لاحقاً';

  @override
  String get instructorProfileDefaultStudentName => 'طالب';

  @override
  String get instructorProfileDefaultHeadline => 'خبير ومدرب معتمد';

  @override
  String get instructorProfileDefaultBio =>
      'مهندس برمجيات ومدرب تقني معتمد يتمتع بخبرة واسعة في بناء الأنظمة البرمجية القابلة للتطوير وتطبيقات الهاتف المحمول.\nقام بتدريب آلاف الطلاب والمهندسين حول العالم، وقدم محتوى احترافي يركز على الكود النظيف، البنية المعمارية النظيفة، والحلول الحديثة القابلة للتطوير.';

  @override
  String get supportNewChat => 'محادثة جديدة';

  @override
  String get supportNoChatsTitle => 'لا توجد محادثات دعم حتى الآن';

  @override
  String get supportNoChatsDesc =>
      'فريق الدعم الفني جاهز لمساعدتك والإجابة على كافة استفساراتك';

  @override
  String get supportStartNewConversation => 'بدء محادثة جديدة';

  @override
  String get supportNoMessagesYet => 'لا توجد رسائل بعد';

  @override
  String get supportRetry => 'إعادة المحاولة';

  @override
  String get supportOpenTicket => 'محادثة مفتوحة';

  @override
  String get supportClosedTicket => 'محادثة مغلقة';

  @override
  String get supportCloseAction => 'إغلاق';

  @override
  String get supportReopenAction => 'إعادة فتح';

  @override
  String get supportNoMessagesInChat => 'لا توجد رسائل في هذه المحادثة بعد';

  @override
  String get supportYou => 'أنت';

  @override
  String get supportTeam => 'فريق الدعم';

  @override
  String get supportTypeMessageHint => 'اكتب رسالتك هنا...';

  @override
  String get supportConversationClosedNotice => 'هذه المحادثة مغلقة حالياً.';

  @override
  String get supportCloseDialogTitle => 'إغلاق المحادثة؟';

  @override
  String get supportCloseDialogDesc =>
      'هل أنت متأكد من رغبتك في إغلاق هذه المحادثة؟ يمكنك دائماً إعادة فتحها وإرسال رسائل جديدة في أي وقت.';

  @override
  String get supportCancel => 'إلغاء';

  @override
  String get supportYesClose => 'نعم، إغلاق';

  @override
  String get supportNewChatTitle => 'محادثة جديدة مع الدعم';

  @override
  String get supportNewChatSubtitle => 'فريقنا متاح لمساعدتك في أي استفسار';

  @override
  String get supportSubjectLabel => 'الموضوع';

  @override
  String get supportSubjectHint => 'مثال: استفسار حول الدورة، الدفع...';

  @override
  String get supportMessageLabel => 'الرسالة';

  @override
  String get supportMessageHint =>
      'اشرح استفسارك بالتفصيل وسيقوم فريق الدعم بالرد عليك...';

  @override
  String get supportMessageRequired => 'يرجى كتابة نص الرسالة';

  @override
  String get supportStartConversationBtn => 'بدء المحادثة';

  @override
  String get supportCreateError =>
      'حدث خطأ أثناء إنشاء المحادثة، يرجى المحاولة لاحقاً';

  @override
  String get supportTopicCourse => 'استفسار عن دورة';

  @override
  String get supportTopicPayment => 'مشكلة بالدفع';

  @override
  String get supportTopicCertificates => 'الشهادات';

  @override
  String get supportTopicTech => 'مشكلة تقنية';

  @override
  String get supportTopicGeneral => 'استفسار عام';

  @override
  String get cartGuestTitle => 'سلة المشتريات تتطلب تسجيل الدخول';

  @override
  String get cartGuestSubtitle =>
      'يرجى تسجيل الدخول للوصول إلى سلة الشراء ومتابعة المقررات وحفظ تقدمك بكل سهولة';

  @override
  String get wishlistGuestTitle => 'قائمة الرغبات تتطلب تسجيل الدخول';

  @override
  String get wishlistGuestSubtitle =>
      'يرجى تسجيل الدخول للوصول إلى قائمتك المفضلة ومتابعة المقررات التي ترغب بدراستها في أي وقت';

  @override
  String get courseDetailsLoginRequiredTitle => 'تسجيل الدخول مطلوب';

  @override
  String get courseDetailsLoginRequiredDesc =>
      'يجب تسجيل الدخول أولاً لإتمام شراء هذا المقرر وحفظ تقدمك في حسابك الشخصي.';

  @override
  String get courseDetailsProceedToLogin => 'الانتقال لتسجيل الدخول';

  @override
  String get messagesGuestTitle => 'الرسائل تتطلب تسجيل الدخول';

  @override
  String get messagesGuestSubtitle =>
      'يرجى تسجيل الدخول للوصول إلى محادثات الدعم الفني والتواصل مع فريق المساعدة';

  @override
  String get notificationsGuestTitle => 'الإشعارات تتطلب تسجيل الدخول';

  @override
  String get notificationsGuestSubtitle =>
      'يرجى تسجيل الدخول لمتابعة آخر التحديثات والإشعارات الخاصة بحسابك ودوراتك';
}

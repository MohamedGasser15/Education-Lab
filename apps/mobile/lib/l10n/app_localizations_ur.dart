// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Urdu (`ur`).
class AppLocalizationsUr extends AppLocalizations {
  AppLocalizationsUr([String locale = 'ur']) : super(locale);

  @override
  String get onboardingSkip => 'چھوڑیں';

  @override
  String get onboardingTitle1 => 'EduLab میں خوش آمدید';

  @override
  String get onboardingSubtitle1 =>
      'جدید انٹرایکٹو سیکھنے اور مسلسل پیشہ ورانہ ترقی کے لیے آپ کا بہترین پلیٹ فارم۔';

  @override
  String get onboardingTitle2 => 'بہترین اساتذہ سے سیکھیں';

  @override
  String get onboardingSubtitle2 =>
      'پروگرامنگ، ڈیزائن، بزنس اور ڈیٹا سائنس میں ہزاروں پیشہ ورانہ کورسز۔';

  @override
  String get onboardingTitle3 => 'سرٹیفکیٹس اور یقینی کامیابی';

  @override
  String get onboardingSubtitle3 =>
      'اپنی پیش رفت دیکھیں، ٹیسٹ پاس کریں اور تسلیم شدہ سرٹیفکیٹ حاصل کریں۔';

  @override
  String get onboardingNext => 'اگلا';

  @override
  String get onboardingStart => 'ابھی شروع کریں';

  @override
  String get splashAppName => 'Education Lab';

  @override
  String get splashTagline => 'اسمارٹ لرننگ پلیٹ فارم';

  @override
  String get loginTagline => 'اسمارٹ لرننگ پلیٹ فارم میں خوش آمدید';

  @override
  String get loginAppName => 'EduLab';

  @override
  String get loginTabLogin => 'لاگ ان';

  @override
  String get loginTabRegister => 'نیا اکاؤنٹ';

  @override
  String get loginEmailLabel => 'ای میل';

  @override
  String get loginEmailHint => 'example@email.com';

  @override
  String get loginPasswordLabel => 'پاس ورڈ';

  @override
  String get loginPasswordHint => '••••••';

  @override
  String get loginForgotPassword => 'پاس ورڈ بھول گئے؟';

  @override
  String get loginSubmit => 'لاگ ان کریں';

  @override
  String get loginSubmitLoading => 'لاگ ان ہو رہا ہے';

  @override
  String get loginGuest => 'بطور مہمان شامل ہوں';

  @override
  String get loginOr => 'یا';

  @override
  String get loginEmailRequired => 'ای میل درکار ہے';

  @override
  String get loginEmailInvalid => 'درست ای میل درج کریں';

  @override
  String get loginPasswordRequired => 'پاس ورڈ درکار ہے';

  @override
  String get registerStepEmail => 'ای میل';

  @override
  String get registerStepCode => 'کوڈ';

  @override
  String get registerStepData => 'معلومات';

  @override
  String get registerSendCodeInfo => 'ہم اس ای میل پر ایکٹیویشن کوڈ بھیجیں گے';

  @override
  String get registerSendCode => 'ایکٹیویشن کوڈ بھیجیں';

  @override
  String get registerVerifying => 'تصدیق جاری ہے';

  @override
  String get registerCodeSentTo => 'کوڈ ارسال کیا گیا:';

  @override
  String get registerResendCode => 'کوڈ دوبارہ بھیجیں';

  @override
  String get registerBack => 'پیچھے';

  @override
  String get registerVerifyCode => 'کوڈ کی تصدیق کریں';

  @override
  String get registerCodeIncomplete => 'مکمل 6 ہندسوں کا کوڈ درج کریں';

  @override
  String get registerFullNameLabel => 'پورا نام';

  @override
  String get registerFullNameHint => 'آپ کا پورا نام';

  @override
  String get registerPasswordHint => 'کم از کم 8 حروف، ایک بڑا حرف اور ایک عدد';

  @override
  String get registerConfirmLabel => 'پاس ورڈ کی تصدیق';

  @override
  String get registerConfirmHint => 'پاس ورڈ دوبارہ درج کریں';

  @override
  String get registerSubmit => 'اکاؤنٹ بنائیں';

  @override
  String get registerSubmitLoading => 'اکاؤنٹ بنایا جا رہا ہے';

  @override
  String get registerSuccess => 'اکاؤنٹ کامیابی سے بن گیا';

  @override
  String get registerNameRequired => 'پورا نام درکار ہے';

  @override
  String get registerNameMinLength =>
      'پورا نام کم از کم 6 حروف پر مشتمل ہونا چاہیے';

  @override
  String get registerPasswordMinLength =>
      'پاس ورڈ کم از کم 8 حروف کا ہونا چاہیے';

  @override
  String get registerPasswordUppercase =>
      'پاس ورڈ میں کم از کم ایک بڑا حرف ہونا چاہیے';

  @override
  String get registerPasswordNumber =>
      'پاس ورڈ میں کم از کم ایک عدد ہونا چاہیے';

  @override
  String get registerConfirmRequired => 'پاس ورڈ کی تصدیق درکار ہے';

  @override
  String get registerConfirmMismatch => 'پاس ورڈ مماثل نہیں ہیں';

  @override
  String get networkError => 'کنکشن کی خرابی، دوبارہ کوشش کریں';

  @override
  String homeGreeting(String name) {
    return 'خوش آمدید، $name!';
  }

  @override
  String get homeSubtitle => 'آج آپ کیا سیکھنا چاہتے ہیں؟';

  @override
  String get homeSearchHint => 'کورس یا مہارت تلاش کریں...';

  @override
  String get homeSectionContinue => 'سیکھنا جاری رکھیں';

  @override
  String get homeSectionRecommended => 'آپ کے لیے تجویز کردہ';

  @override
  String get homeSectionPopular => 'انتہائی مقبول';

  @override
  String get homeSectionTopRated => 'سب سے زیادہ ریٹڈ';

  @override
  String get homeSectionByCategory => 'زمرہ کے لحاظ سے';

  @override
  String get homeHeroTitle => 'پیشکشیں دیکھیں';

  @override
  String get homeHeroSubtitle => 'پریمیم کورسز پر 70 فیصد تک رعایت';

  @override
  String get homeHeroButton => 'ابھی دریافت کریں';

  @override
  String get homeViewAll => 'سب دیکھیں';

  @override
  String get homeProgressLabel => 'مکمل';

  @override
  String get exploreTitle => 'کورسز دریافت کریں';

  @override
  String get exploreSearchHint => 'کورس، مہارت یا استاد تلاش کریں...';

  @override
  String get exploreAllCategories => 'تمام زمرے';

  @override
  String get exploreFilter => 'فلٹر';

  @override
  String get exploreSort => 'ترتیب دیں';

  @override
  String get exploreNoResults => 'کوئی نتیجہ نہیں ملا';

  @override
  String get exploreNoResultsHint => 'مختلف الفاظ آزمائیں یا فلٹر تبدیل کریں';

  @override
  String exploreCoursesCount(int count) {
    return '$count کورسز';
  }

  @override
  String get exploreFilterTitle => 'نتائج فلٹر کریں';

  @override
  String get exploreFilterApply => 'فلٹر لگائیں';

  @override
  String get exploreFilterReset => 'ری سیٹ';

  @override
  String get exploreFilterPrice => 'قیمت';

  @override
  String get exploreFilterLevel => 'سطح';

  @override
  String get exploreFilterRating => 'درجہ بندی';

  @override
  String get exploreFilterDuration => 'دورانیہ';

  @override
  String get exploreSortTitle => 'ترتیب دیں';

  @override
  String get exploreSortRelevance => 'سب سے موزوں';

  @override
  String get exploreSortNewest => 'تازہ ترین';

  @override
  String get exploreSortPopular => 'سب سے مقبول';

  @override
  String get exploreSortRating => 'اعلیٰ ریٹنگ';

  @override
  String get exploreSortPriceLow => 'قیمت: کم سے زیادہ';

  @override
  String get exploreSortPriceHigh => 'قیمت: زیادہ سے کم';

  @override
  String get explorePriceFree => 'مفت';

  @override
  String get exploreLevelBeginner => 'ابتدائی';

  @override
  String get exploreLevelIntermediate => 'درمیانی';

  @override
  String get exploreLevelAdvanced => 'اعلیٰ';

  @override
  String get learningTitle => 'میری تعلیم';

  @override
  String get learningTabInProgress => 'جاری ہے';

  @override
  String get learningTabCompleted => 'مکمل شدہ';

  @override
  String get learningTabSaved => 'محفوظ شدہ';

  @override
  String get learningEmpty => 'ابھی کوئی کورس نہیں ہے';

  @override
  String get learningEmptyHint => 'کورسز دریافت کرنا شروع کریں';

  @override
  String get learningExploreButton => 'کورسز تلاش کریں';

  @override
  String learningProgress(int percent) {
    return '$percent% مکمل';
  }

  @override
  String get learningContinue => 'جاری رکھیں';

  @override
  String get learningViewCertificate => 'سرٹیفکیٹ دیکھیں';

  @override
  String get learningReview => 'کورس کی درجہ بندی کریں';

  @override
  String get learningLesson => 'سبق';

  @override
  String get learningLessons => 'اسباق';

  @override
  String get cartTitle => 'کارٹ';

  @override
  String get cartEmpty => 'آپ کی کارٹ خالی ہے';

  @override
  String get cartEmptyHint => 'سیکھنا شروع کرنے کے لیے کورسز شامل کریں';

  @override
  String get cartExploreButton => 'کورسز دریافت کریں';

  @override
  String get cartPromoPlaceholder => 'ڈسکاؤنٹ کوڈ';

  @override
  String get cartPromoApply => 'لاگو کریں';

  @override
  String get cartPromoInvalid => 'غلط ڈسکاؤنٹ کوڈ';

  @override
  String get cartSummary => 'آرڈر کا خلاصہ';

  @override
  String get cartSubtotal => 'ذیلی کل';

  @override
  String get cartDiscount => 'رعایت';

  @override
  String get cartTotal => 'کل رقم';

  @override
  String get cartCheckout => 'چیک آؤٹ';

  @override
  String cartCourses(int count) {
    return '$count کورسز';
  }

  @override
  String get cartRemove => 'ہٹائیں';

  @override
  String get cartGuarantee => '30 دن کی رقم واپسی کی ضمانت';

  @override
  String get checkoutTitle => 'چیک آؤٹ';

  @override
  String get checkoutStepPayment => 'ادائیگی';

  @override
  String get checkoutStepReview => 'جائزہ';

  @override
  String get checkoutStepConfirm => 'تصدیق';

  @override
  String get checkoutOrderSummary => 'آرڈر کا خلاصہ';

  @override
  String get checkoutTotal => 'کل رقم';

  @override
  String get checkoutPayNow => 'ابھی ادا کریں';

  @override
  String get checkoutBack => 'پیچھے';

  @override
  String get checkoutNext => 'آگے';

  @override
  String get checkoutSecureSSL => '256-بٹ SSL اینکرپشن کے ساتھ محفوظ ادائیگی';

  @override
  String get checkoutSuccessTitle => 'خریداری کامیاب رہی!';

  @override
  String get checkoutSuccessSubtitle =>
      'اب آپ اپنے کورس تک رسائی حاصل کر سکتے ہیں';

  @override
  String get checkoutGoToLearning => 'میرے کورسز پر جائیں';

  @override
  String get checkoutPaymentMethod => 'ادائیگی کا طریقہ';

  @override
  String get checkoutCardNumber => 'کارڈ نمبر';

  @override
  String get checkoutCardName => 'کارڈ ہولڈر کا نام';

  @override
  String get checkoutCardExpiry => 'تاریخ تنسیخ';

  @override
  String get checkoutCardCVV => 'CVV';

  @override
  String get courseDetailsEnroll => 'ابھی داخلہ لیں';

  @override
  String get courseDetailsBuyNow => 'ابھی خریدیں';

  @override
  String get courseDetailsAddToCart => 'کارٹ میں شامل کریں';

  @override
  String get courseDetailsAddedToCart => 'کارٹ میں شامل کر دیا گیا';

  @override
  String get courseDetailsAlreadyEnrolled => 'پہلے سے داخلہ لیا ہوا ہے';

  @override
  String get courseDetailsGoToCourse => 'کورس پر جائیں';

  @override
  String get courseDetailsFree => 'مفت';

  @override
  String courseDetailsStudents(String count) {
    return '$count طلباء';
  }

  @override
  String get courseDetailsRating => 'ریٹنگ';

  @override
  String get courseDetailsReviews => 'تبصرے';

  @override
  String get courseDetailsLastUpdated => 'آخری اپ ڈیٹ';

  @override
  String get courseDetailsCurriculum => 'کورس کا نصاب';

  @override
  String get courseDetailsSection => 'حصہ';

  @override
  String get courseDetailsLessons => 'اسباق';

  @override
  String get courseDetailsInstructor => 'استاد';

  @override
  String get courseDetailsStudentsLabel => 'طلباء';

  @override
  String get courseDetailsCoursesLabel => 'کورسز';

  @override
  String get courseDetailsReviewsLabel => 'تبصرے';

  @override
  String get courseDetailsReviewsTitle => 'طلباء کے تبصرے';

  @override
  String get courseDetailsWhatLearn => 'آپ کیا سیکھیں گے';

  @override
  String get courseDetailsRequirements => 'ضروریات';

  @override
  String get courseDetailsDescription => 'کورس کی تفصیل';

  @override
  String get courseDetailsIncludesTitle => 'اس کورس میں شامل ہیں';

  @override
  String get courseDetailsHoursVideo => 'گھنٹے کی ویڈیو';

  @override
  String get courseDetailsArticles => 'مضامین';

  @override
  String get courseDetailsMobileAccess => 'موبائل پر رسائی';

  @override
  String get courseDetailsCertificate => 'تکمیلی سرٹیفکیٹ';

  @override
  String get courseDetailsLifetimeAccess => 'لائف ٹائم رسائی';

  @override
  String get lessonPlayerNotes => 'میرے نوٹس';

  @override
  String get lessonPlayerResources => 'وسائل';

  @override
  String get lessonPlayerDiscussion => 'گفتگو';

  @override
  String get lessonPlayerPrev => 'پچھلا';

  @override
  String get lessonPlayerNext => 'اگلا';

  @override
  String get lessonPlayerSpeed => 'رفتار';

  @override
  String get lessonPlayerQuality => 'معیار';

  @override
  String get lessonPlayerCompleted => 'سبق مکمل ہوا';

  @override
  String get certificateTitle => 'تکمیلی سرٹیفکیٹ';

  @override
  String get certificatePresentedTo => 'پیش کیا گیا برائے';

  @override
  String get certificateCompletedCourse => 'کورس کامیابی سے مکمل کرنے پر';

  @override
  String get certificateIssuedOn => 'تاریخ اجراء';

  @override
  String get certificateVerificationId => 'تصدیقی نمبر';

  @override
  String get certificateDownloadPDF => 'PDF ڈاؤن لوڈ کریں';

  @override
  String get certificateDownloadPNG => 'تصویر ڈاؤن لوڈ کریں';

  @override
  String get certificateCopyLink => 'لنک کاپی کریں';

  @override
  String get certificateLinkCopied => 'لنک کاپی ہو گیا';

  @override
  String get profileTitle => 'پروفائل';

  @override
  String get profileEditProfile => 'پروفائل تبدیل کریں';

  @override
  String get profileCourses => 'میرے کورسز';

  @override
  String get profileCertificates => 'سرٹیفکیٹس';

  @override
  String get profilePoints => 'پوائنٹس';

  @override
  String get profileFollowers => 'فالوورز';

  @override
  String get profileFollowing => 'فالوئنگ';

  @override
  String get profileBio => 'تعارف';

  @override
  String get profileInstructor => 'استاد';

  @override
  String get profileStudent => 'طالب علم';

  @override
  String get profileLevel => 'سطح';

  @override
  String get profileJoined => 'شامل ہوئے';

  @override
  String get profileShareProfile => 'پروفائل شیئر کریں';

  @override
  String get profileMenuLearning => 'میرے کورسز';

  @override
  String get profileMenuCertificates => 'میرے سرٹیفکیٹس';

  @override
  String get profileMenuPurchaseHistory => 'خریداری کی تاریخ';

  @override
  String get profileMenuTeachApplication => 'EduLab پر پڑھائیں';

  @override
  String get profileMenuAccountSecurity => 'اکاؤنٹ کی سیکیورٹی';

  @override
  String get profileMenuNotifications => 'اطلاعات';

  @override
  String get profileMenuMessages => 'پیغامات';

  @override
  String get profileMenuSettings => 'ترتیبات';

  @override
  String get profileMenuSchedule => 'میرا شیڈول';

  @override
  String get profileMenuAssignments => 'اسائنمنٹس';

  @override
  String get profileMenuQuiz => 'کوئز';

  @override
  String get profileMenuLogout => 'لاگ آؤٹ';

  @override
  String get profileLogoutConfirm => 'کیا آپ واقعی لاگ آؤٹ کرنا چاہتے ہیں؟';

  @override
  String get profileLogoutYes => 'ہاں، لاگ آؤٹ کریں';

  @override
  String get profileLogoutNo => 'منسوخ کریں';

  @override
  String get editProfileTitle => 'پروفائل تبدیل کریں';

  @override
  String get editProfileSave => 'تبدیلیاں محفوظ کریں';

  @override
  String get editProfileFullName => 'پورا نام';

  @override
  String get editProfileBio => 'تعارف';

  @override
  String get editProfileEmail => 'ای میل';

  @override
  String get editProfilePhone => 'فون نمبر';

  @override
  String get editProfileWebsite => 'ویب سائٹ';

  @override
  String get editProfileSaved => 'تبدیلیاں محفوظ ہو گئیں';

  @override
  String get accountSecurityTitle => 'اکاؤنٹ سیکیورٹی';

  @override
  String get accountSecurityChangePassword => 'پاس ورڈ تبدیل کریں';

  @override
  String get accountSecurityTwoFactor => 'ٹو فیکٹر توثیق';

  @override
  String get accountSecurityActiveSessions => 'فعال سیشنز';

  @override
  String get accountSecurityDeleteAccount => 'اکاؤنٹ ڈیلیٹ کریں';

  @override
  String get purchaseHistoryTitle => 'خریداری کی تاریخ';

  @override
  String get purchaseHistoryEmpty => 'ابھی کوئی خریداری نہیں ہے';

  @override
  String get purchaseHistoryGuarantee => '30 دن کی رقم واپسی کی ضمانت';

  @override
  String get purchaseHistoryDate => 'لین دین کی تاریخ';

  @override
  String get purchaseHistoryStatus => 'حیثیت';

  @override
  String get purchaseHistoryAmount => 'رقم';

  @override
  String get purchaseHistoryCompleted => 'مکمل ہوا';

  @override
  String get purchaseHistoryRefunded => 'واپس کر دیا گیا';

  @override
  String get teachApplicationTitle => 'EduLab پر پڑھائیں';

  @override
  String get teachApplicationSubmit => 'درخواست جمع کروائیں';

  @override
  String get teachApplicationSent => 'درخواست کامیابی سے جمع ہو گئی';

  @override
  String get notificationsTitle => 'اطلاعات';

  @override
  String get notificationsMarkAllRead => 'سب کو پڑھا ہوا نشان زد کریں';

  @override
  String get notificationsMarkAllReadSnackbar => 'تمام اطلاعات پڑھی گئیں';

  @override
  String get notificationsEmpty => 'کوئی اطلاع نہیں ہے';

  @override
  String get notification1Title => 'یاد دہانی: اپنا کورس جاری رکھیں';

  @override
  String get notification1Message => 'Flutter فار بیگنرز میں نیا سبق تیار ہے';

  @override
  String get notification1Time => '5 منٹ پہلے';

  @override
  String get notification1Action => 'کورس جاری رکھیں';

  @override
  String get notification2Title => 'آپ کا سرٹیفکیٹ تیار ہے!';

  @override
  String get notification2Message => 'آپ نے UI/UX ڈیزائن کورس مکمل کر لیا ہے۔';

  @override
  String get notification2Time => '2 گھنٹے پہلے';

  @override
  String get notification2Action => 'سرٹیفکیٹ دیکھیں';

  @override
  String get notification3Title => 'خصوصی پیشکش';

  @override
  String get notification3Message => 'پروگرامنگ کورسز پر 70% رعایت';

  @override
  String get notification3Time => '1 دن پہلے';

  @override
  String get notification3Action => 'پیشکش دیکھیں';

  @override
  String get notification4Title => 'آپ کے سوال کا جواب';

  @override
  String get notification4Message => 'استاد نے آپ کے سوال کا جواب دے دیا ہے';

  @override
  String get notification4Time => '2 دن پہلے';

  @override
  String get notification4Action => 'جواب دیکھیں';

  @override
  String get notification5Title => 'کورس اپ ڈیٹ';

  @override
  String get notification5Message => 'Python کورس میں نیا مواد شامل کیا گیا ہے';

  @override
  String get notification5Time => '3 دن پہلے';

  @override
  String get messagesTitle => 'پیغامات';

  @override
  String get settingsTitle => 'ترتیبات اور ترجیحات';

  @override
  String get settingsVideoDownload => 'ویڈیو اور ڈاؤن لوڈ';

  @override
  String get settingsDownloadQuality => 'ڈیفالٹ ڈاؤن لوڈ کوالٹی';

  @override
  String get settingsWifiOnly => 'صرف Wi-Fi پر ڈاؤن لوڈ کریں';

  @override
  String get settingsNotifications => 'اطلاعات اور انتباہات';

  @override
  String get settingsCourseNotifications => 'کورس اور پیغامات کی اطلاعات';

  @override
  String get settingsPromoNotifications => 'خصوصی پیشکشیں اور رعایتیں';

  @override
  String get settingsAppearance => 'ظاہری شکل اور زبان';

  @override
  String get settingsDarkMode => 'ڈارک موڈ';

  @override
  String get settingsDarkModeEnabled => 'فعال (بیٹری کی بچت)';

  @override
  String get settingsDarkModeDisabled => 'غیر فعال (لائٹ موڈ)';

  @override
  String get settingsLanguage => 'ایپ کی زبان';

  @override
  String get settingsStorage => 'اسٹوریج اور کیشے';

  @override
  String get settingsClearCache => 'کیشے صاف کریں';

  @override
  String get settingsClearCacheSuccess => 'کیشے کامیابی سے صاف ہو گیا';

  @override
  String get settingsHelp => 'معلومات اور پالیسیاں';

  @override
  String get settingsHelpCenter => 'ہیلپ سینٹر اور اکثر پوچھے گئے سوالات';

  @override
  String get settingsTermsPrivacy => 'استعمال کی شرائط اور رازداری';

  @override
  String get settingsAbout => 'EduLab کے بارے میں';

  @override
  String get settingsVersion => 'ورژن v1.0.0';

  @override
  String get quizTitle => 'کوئز';

  @override
  String get quizNext => 'اگلا سوال';

  @override
  String get quizSubmit => 'کوئز جمع کروائیں';

  @override
  String get quizScore => 'کوئز کا نتیجہ';

  @override
  String get quizCorrectAnswers => 'درست جوابات';

  @override
  String get scheduleTitle => 'میرا شیڈول';

  @override
  String get scheduleEmpty => 'کوئی سیشن شیڈول نہیں ہے';

  @override
  String get scheduleJoin => 'شامل ہوں';

  @override
  String get scheduleReminder => 'یاد دہانی';

  @override
  String get assignmentsTitle => 'اسائنمنٹس';

  @override
  String get assignmentsEmpty => 'کوئی اسائنمنٹ نہیں ہے';

  @override
  String get assignmentsSubmit => 'اسائنمنٹ جمع کروائیں';

  @override
  String get assignmentsDue => 'آخری تاریخ';

  @override
  String get assignmentsSubmitted => 'جمع کر دیا گیا';

  @override
  String get assignmentsPending => 'زیر التواء';

  @override
  String get languageArabic => 'عربی';

  @override
  String get languageEnglish => 'انگریزی';

  @override
  String get languageDialogTitle => 'ایپ کی زبان منتخب کریں';

  @override
  String get languageSelect => 'منتخب کریں';

  @override
  String get generalCancel => 'منسوخ کریں';

  @override
  String get generalConfirm => 'تصدیق کریں';

  @override
  String get generalSave => 'محفوظ کریں';

  @override
  String get generalDelete => 'ڈیلیٹ کریں';

  @override
  String get generalEdit => 'تبدیل کریں';

  @override
  String get generalClose => 'بند کریں';

  @override
  String get generalBack => 'پیچھے';

  @override
  String get generalDone => 'مکمل';

  @override
  String get generalOk => 'ٹھیک ہے';

  @override
  String get generalYes => 'ہاں';

  @override
  String get generalNo => 'نہیں';

  @override
  String get generalLoading => 'لوڈ ہو رہا ہے...';

  @override
  String get generalError => 'خرابی پیش آگئی';

  @override
  String get generalRetry => 'دوبارہ کوشش کریں';

  @override
  String get generalNoInternet => 'انٹرنیٹ کنکشن نہیں ہے';

  @override
  String get generalFree => 'مفت';

  @override
  String get generalRating => 'ریٹنگ';

  @override
  String get generalStudents => 'طلباء';

  @override
  String get generalHours => 'گھنٹے';

  @override
  String get generalMinutes => 'منٹ';

  @override
  String get generalBy => 'از';

  @override
  String get navHome => 'ہوم';

  @override
  String get navExplore => 'دریافت کریں';

  @override
  String get navMyCourses => 'میرے کورسز';

  @override
  String get navCart => 'کارٹ';

  @override
  String get navAccount => 'اکاؤنٹ';

  @override
  String get homeSubGreeting => 'آج آپ کیا سیکھنا چاہتے ہیں؟';

  @override
  String get homeVisitor => 'مہمان';

  @override
  String get homePromoTitle => 'پیشکشیں دیکھیں';

  @override
  String get homePromoSubtitle => 'پریمیم کورسز پر 70 فیصد تک رعایت';

  @override
  String get homePromoButton => 'ابھی دریافت کریں';

  @override
  String get homePromoBadge => 'خصوصی پیشکش';

  @override
  String get homeContinueLearning => 'سیکھنا جاری رکھیں';

  @override
  String get homeMyCoursesLink => 'میرے کورسز';

  @override
  String get homeLesson => 'سبق';

  @override
  String homeStudentsCount(String count) {
    return '$count طلباء';
  }

  @override
  String get homeRecommendedTitle => 'آپ کے لیے تجویز کردہ';

  @override
  String get homeRecommendedSubtitle => 'آپ کی دلچسپیوں کے مطابق';

  @override
  String get homeBestsellersTitle => 'بیسٹ سیلر';

  @override
  String get homeBestsellersSubtitle => 'اعلیٰ ریٹنگ والے اور مقبول کورسز';

  @override
  String get homeNewCoursesTitle => 'نئے کورسز';

  @override
  String get homeNewCoursesSubtitle => 'تازہ ترین مواد';

  @override
  String get homePopularTopicsTitle => 'مقبول موضوعات';

  @override
  String get homePopularTopicsSubtitle =>
      'سب سے زیادہ مانگ والی مہارتیں سیکھیں';

  @override
  String get homeTopInstructorsTitle => 'بہترین اساتذہ';

  @override
  String get homeTopInstructorsSubtitle => 'ماہرین سے سیکھیں';

  @override
  String get homeExploreCategoriesTitle => 'زمرہ جات دیکھیں';

  @override
  String get homeExploreCategoriesSubtitle => 'اپنے لیے بہترین کورس تلاش کریں';

  @override
  String get catAll => 'سب';

  @override
  String get catWebDev => 'ویب ڈویلپمنٹ';

  @override
  String get catMobileApps => 'موبائل ایپس';

  @override
  String get catDataScience => 'ڈیٹا سائنس';

  @override
  String get catUIUX => 'UI/UX ڈیزائن';

  @override
  String get catBusiness => 'بزنس اور مینجمنٹ';

  @override
  String get catAI => 'مصنوعی ذہانت';

  @override
  String get catCyberSecurity => 'سائبر سیکیورٹی';

  @override
  String get exploreNoResultsTitle => 'کوئی نتیجہ نہیں ملا';

  @override
  String get exploreNoResultsSubtitle =>
      'مختلف الفاظ آزمائیں یا فلٹر تبدیل کریں';

  @override
  String get exploreRecentSearches => 'حالیہ تلاشیں';

  @override
  String get exploreTopSearches => 'مقبول تلاشیں';

  @override
  String get exploreBrowseCategories => 'زمرہ جات دیکھیں';

  @override
  String get exploreBrowseCategoriesSubtitle => 'بہترین کورس تلاش کریں';

  @override
  String get exploreBackToAll => 'سب پر واپس جائیں';

  @override
  String get exploreClearAll => 'سب صاف کریں';

  @override
  String get exploreAvailableResults => 'نتائج دستیاب ہیں';

  @override
  String get exploreFilterBestseller => 'بیسٹ سیلر';

  @override
  String get exploreFilterTopRated => 'سب سے زیادہ ریٹڈ';

  @override
  String get exploreFilterUnder50 => '\$50 سے کم';

  @override
  String get learningHeroTitle => 'اپنا تعلیمی سفر جاری رکھیں';

  @override
  String get learningSearchHint => 'میرے کورسز میں تلاش کریں...';

  @override
  String get learningFilterAll => 'سب';

  @override
  String get learningFilterInProgress => 'جاری ہے';

  @override
  String get learningFilterCompleted => 'مکمل شدہ';

  @override
  String get learningFilterDownloaded => 'ڈاؤن لوڈ شدہ';

  @override
  String get learningEmptyTitle => 'ابھی کوئی کورس نہیں ہے';

  @override
  String get learningEmptySubtitle => 'کورسز دریافت کرنا شروع کریں';

  @override
  String get learningEmptySearch => 'کوئی نتیجہ نہیں ملا';

  @override
  String get learningCompleted => 'مکمل';

  @override
  String get learningCompletedBadge => 'مکمل';

  @override
  String learningLecturesCount(int count) {
    return '$count اسباق';
  }

  @override
  String get cartEmptyTitle => 'آپ کی کارٹ خالی ہے';

  @override
  String get cartEmptySubtitle => 'سیکھنا شروع کرنے کے لیے کورسز شامل کریں';

  @override
  String get cartCouponHint => 'کوپن کوڈ درج کریں';

  @override
  String get cartCouponApply => 'لاگو کریں';

  @override
  String get cartCouponInvalid => 'غلط کوڈ';

  @override
  String get cartCouponApplied => 'کوپن کوڈ لاگو ہو گیا';

  @override
  String get cartCouponDiscount => 'کوپن رعایت';

  @override
  String get cartCouponsTitle => 'کوپنز';

  @override
  String get cartOrderSummary => 'آرڈر کا خلاصہ';

  @override
  String get cartOriginalPrice => 'اصل قیمت';

  @override
  String get cartPlatformDiscount => 'پلیٹ فارم رعایت';

  @override
  String get cartFinalTotal => 'حتمی کل رقم';

  @override
  String cartItemsCount(int count) {
    return '$count کورسز';
  }

  @override
  String get cartRemovedSnackbar => 'کورس کارٹ سے ہٹا دیا گیا';

  @override
  String get cartUndo => 'کالعدم کریں';

  @override
  String get cartAddButton => 'کارٹ میں شامل کریں';

  @override
  String get cartAddedSnackbar => 'کارٹ میں شامل کر دیا گیا';

  @override
  String get cartAlreadyInCart => 'پہلے سے کارٹ میں ہے';

  @override
  String get cartCheckoutButton => 'ادائیگی کے لیے آگے بڑھیں';

  @override
  String get cartRecommendedTitle => 'آپ کو یہ بھی پسند آ سکتا ہے';

  @override
  String get cartRecommendedSubtitle => 'آپ کی کارٹ کی بنیاد پر تجویز کردہ';

  @override
  String get checkoutCreditCard => 'کریڈٹ کارڈ';

  @override
  String get checkoutSelectPayment => 'ادائیگی کا طریقہ منتخب کریں';

  @override
  String get checkoutCardNumberLabel => 'کارڈ نمبر';

  @override
  String get checkoutCardHolderLabel => 'کارڈ ہولڈر کا نام';

  @override
  String get checkoutExpiryLabel => 'تاریخ تنسیخ';

  @override
  String get checkoutCVVLabel => 'CVV';

  @override
  String get checkoutPersonalInfoTitle => 'ذاتی معلومات';

  @override
  String get checkoutFullNameLabel => 'پورا نام';

  @override
  String get checkoutFullNameHint => 'آپ کا پورا نام';

  @override
  String get checkoutFullNameRequired => 'پورا نام درکار ہے';

  @override
  String get checkoutPhoneLabel => 'فون نمبر';

  @override
  String get checkoutPhoneRequired => 'فون نمبر درکار ہے';

  @override
  String get checkoutPostalLabel => 'پوسٹل کوڈ';

  @override
  String get checkoutPostalRequired => 'پوسٹل کوڈ درکار ہے';

  @override
  String get checkoutBuyerInfo => 'خریدار کی معلومات';

  @override
  String get checkoutSaveInfo => 'اگلی بار کے لیے معلومات محفوظ کریں';

  @override
  String get checkoutMoneyBackGuarantee => '30 دن کی رقم واپسی کی ضمانت';

  @override
  String get checkoutContinueToPayment => 'ادائیگی جاری رکھیں';

  @override
  String get checkoutContinueToReview => 'جائزہ لیں';

  @override
  String get checkoutReviewConfirm => 'جائزہ اور تصدیق کریں';

  @override
  String get checkoutStartLearning => 'سیکھنا شروع کریں';

  @override
  String get checkoutBackHome => 'ہوم پر واپس جائیں';

  @override
  String get courseDetailsTitle => 'کورس کی تفصیلات';

  @override
  String get courseDetailsShare => 'شیئر کریں';

  @override
  String get courseDetailsWhatYouWillLearn => 'آپ کیا سیکھیں گے';

  @override
  String get courseDetailsLanguage => 'زبان';

  @override
  String get courseDetailsCreatedBy => 'تخلیق کار';

  @override
  String get courseDetailsPreviewLesson => 'سبق کا پیش نظارہ';

  @override
  String get courseDetailsHoursOnDemand => 'گھنٹے کی آن ڈیمانڈ ویڈیو';

  @override
  String get courseDetailsFullLifetimeAccess => 'مکمل لائف ٹائم رسائی';

  @override
  String get courseDetailsCertifiedCertificate => 'مصدقہ تکمیلی سرٹیفکیٹ';

  @override
  String get courseDetailsComprehensiveContent => 'جامع مواد';

  @override
  String get certTitle => 'تکمیلی سرٹیفکیٹ';

  @override
  String get certStudentNameLabel => 'طالب علم';

  @override
  String get certCourseLabel => 'کورس';

  @override
  String get certInstructorLabel => 'استاد';

  @override
  String get certIssueDateLabel => 'تاریخ اجراء';

  @override
  String get certCodeLabel => 'سرٹیفکیٹ نمبر';

  @override
  String get certVerifiedBadge => 'مصدقہ';

  @override
  String get certDownloadPDF => 'PDF ڈاؤن لوڈ کریں';

  @override
  String get certDownloadPNG => 'تصویر ڈاؤن لوڈ کریں';

  @override
  String get certCopyVerifyLink => 'تصدیقی لنک کاپی کریں';

  @override
  String get certShare => 'سرٹیفکیٹ شیئر کریں';

  @override
  String get playerTabLessons => 'اسباق';

  @override
  String get playerTabOverview => 'جائزہ';

  @override
  String get playerTabNotes => 'میرے نوٹس';

  @override
  String get playerTabQnA => 'سوالات و جوابات';

  @override
  String get playerNextLesson => 'اگلا سبق';

  @override
  String get profileWelcome => 'خوش آمدید';

  @override
  String get profileLoginPrompt => 'پروفائل تک رسائی کے لیے لاگ ان کریں';

  @override
  String get profileLoginOrRegister => 'لاگ ان / اکاؤنٹ بنائیں';

  @override
  String get profileVerifiedStudent => 'مصدقہ طالب علم';

  @override
  String get profileLogout => 'لاگ آؤٹ';

  @override
  String get profileCancel => 'منسوخ کریں';

  @override
  String get profileLogoutConfirmTitle => 'لاگ آؤٹ';

  @override
  String get profileLogoutConfirmMessage =>
      'کیا آپ واقعی لاگ آؤٹ کرنا چاہتے ہیں؟';

  @override
  String get profileAccountSettings => 'اکاؤنٹ کی ترتیبات';

  @override
  String get profileEditProfileSubtitle => 'ذاتی معلومات تبدیل کریں';

  @override
  String get profileSecurity => 'سیکیورٹی';

  @override
  String get profileSecuritySubtitle => 'پاس ورڈ اور تصدیق';

  @override
  String get profilePurchaseHistory => 'خریداری کی تاریخ';

  @override
  String get profilePurchaseHistorySubtitle => 'لین دین کی تفصیلات دیکھیں';

  @override
  String get profileCertificatesSubtitle => 'آپ کے سرٹیفکیٹس';

  @override
  String get profileTeach => 'EduLab پر پڑھائیں';

  @override
  String get profileTeachSubtitle => 'اپنا علم شیئر کریں';

  @override
  String get profilePreferences => 'ترجیحات';

  @override
  String get profilePreferencesSubtitle => 'ڈیزائن اور زبان';

  @override
  String get profileNotifications => 'اطلاعات';

  @override
  String get profileNotificationsSubtitle => 'اطلاعات کا انتظام کریں';

  @override
  String get profileHelpSupport => 'مدد اور تعاون';

  @override
  String get profileTerms => 'استعمال کی شرائط';

  @override
  String get profilePrivacy => 'رازداری کی پالیسی';

  @override
  String get profileAboutEduLab => 'EduLab کے بارے میں';

  @override
  String get profileWishlist => 'خواہشات کی فہرست';

  @override
  String get securityTitle => 'اکاؤنٹ سیکیورٹی';

  @override
  String get teachTitle => 'EduLab پر پڑھائیں';

  @override
  String get notificationsTabAll => 'سب';

  @override
  String get notificationsTabCourses => 'کورسز';

  @override
  String get notificationsTabPromos => 'پیشکشیں';

  @override
  String get notificationsEmptyTitle => 'کوئی اطلاع نہیں ہے';

  @override
  String get notificationsUnread => 'ان پڑھ';

  @override
  String get wishlistTitle => 'خواہشات کی فہرست';

  @override
  String get wishlistEmptyTitle => 'خواہشات کی فہرست خالی ہے';

  @override
  String get wishlistEmptySubtitle => 'پسندیدہ کورسز محفوظ کریں';

  @override
  String get wishlistAddToCart => 'کارٹ میں شامل کریں';

  @override
  String get wishlistRemovedSnackbar => 'خواہشات کی فہرست سے ہٹا دیا گیا';

  @override
  String get homeDefaultUser => 'طالب علم';

  @override
  String get learningOf => 'از';

  @override
  String get cartInCartBadge => 'کارٹ میں';

  @override
  String get homePromo1Badge => 'بڑی رعایت • محدود وقت';

  @override
  String get homePromo1Title => 'بہترین قیمتوں پر سیکھنا شروع کریں';

  @override
  String get homePromo1Subtitle =>
      'پروگرامنگ، ڈیزائن اور کاروباری کورسز پر 65% تک رعایت۔';

  @override
  String get homePromo1Button => 'آفرز دیکھیں';

  @override
  String get homePromo2Badge => 'تصدیق شدہ کیریئر ٹریکس';

  @override
  String get homePromo2Title => 'اپنے خوابوں کی نوکری کے لیے تیاری کریں';

  @override
  String get homePromo2Subtitle =>
      'عملی پروجیکٹس اور اسناد کے ساتھ مکمل کورسز۔';

  @override
  String get homePromo2Button => 'ٹریکس دیکھیں';

  @override
  String get homePromo3Badge => 'بہترین اساتذہ اور ماہرین';

  @override
  String get homePromo3Title => 'انڈسٹری کے ماہرین سے براہ راست سیکھیں';

  @override
  String get homePromo3Subtitle =>
      'جدید ترین ٹیکنالوجیز کے لیے مسلسل اپڈیٹ شدہ مواد۔';

  @override
  String get homePromo3Button => 'ابھی شروع کریں';

  @override
  String get homeSearchFilter => 'فلٹر';

  @override
  String get securitySectionChangePassword => 'پاس ورڈ تبدیل کریں';

  @override
  String get securityCurrentPasswordLabel => 'موجودہ پاس ورڈ *';

  @override
  String get securityCurrentPasswordError => 'موجودہ پاس ورڈ درج کریں';

  @override
  String get securityNewPasswordLabel => 'نیا پاس ورڈ *';

  @override
  String get securityNewPasswordError => 'کم از کم 8 حروف ہونے چاہئیں';

  @override
  String get securityConfirmPasswordLabel => 'نئے پاس ورڈ کی تصدیق کریں *';

  @override
  String get securityConfirmPasswordError => 'پاس ورڈ مماثل نہیں ہے';

  @override
  String get securityUpdatePasswordBtn => 'پاس ورڈ اپ ڈیٹ کریں';

  @override
  String get securityPasswordUpdatedSuccess =>
      'پاس ورڈ کامیابی سے تبدیل ہو گیا!';

  @override
  String get securitySection2FA => 'ٹو فیکٹر تصدیق (2FA)';

  @override
  String get security2FATitle => 'ٹو فیکٹر تصدیق';

  @override
  String get security2FAEnabledDesc =>
      'فعال - کوڈ کے ذریعے آپ کا اکاؤنٹ محفوظ کرتا ہے';

  @override
  String get security2FADisabledDesc =>
      'غیر فعال (فعال کرنے کی سفارش کی جاتی ہے)';

  @override
  String get security2FASetupTitle => 'ٹو فیکٹر تصدیق فعال کریں';

  @override
  String get security2FASetupContent =>
      'ہر نئے لاگ ان پر آپ کے رجسٹرڈ ای میل پر 6 ہندسوں کا تصدیقی کوڈ بھیجا جائے گا۔';

  @override
  String get security2FAEnableNow => 'ابھی فعال کریں';

  @override
  String get security2FAEnabledSuccess =>
      'ٹو فیکٹر تصدیق کامیابی سے فعال ہو گئی!';

  @override
  String get security2FADisabledSuccess => 'ٹو فیکٹر تصدیق غیر فعال کر دی گئی';

  @override
  String get securitySectionSessions => 'فعال سیشنز اور آلات';

  @override
  String get securityLogoutAllDevices => 'تمام آلات سے لاگ آؤٹ کریں';

  @override
  String get securityThisDevice => 'یہ آلہ';

  @override
  String get securitySessionRevokedSuccess =>
      'سیشن ختم کر دیا گیا اور اس آلے سے لاگ آؤٹ ہو گیا۔';

  @override
  String get securityAllSessionsRevokedSuccess =>
      'دیگر تمام آلات سے کامیابی سے لاگ آؤٹ ہو گیا۔';

  @override
  String get purchaseHistoryInvoiceCertified => 'تصدیق شدہ ای انوائس';

  @override
  String get purchaseHistoryInvoiceNumber => 'انوائس نمبر';

  @override
  String get purchaseHistoryCourse => 'کورس';

  @override
  String get purchaseHistoryPaymentMethod => 'ادائیگی کا طریقہ';

  @override
  String get purchaseHistoryTotalAmount => 'کل رقم:';

  @override
  String get purchaseHistoryClose => 'بند کریں';

  @override
  String get purchaseHistoryDownloadPdf => 'پی ڈی ایف ڈاؤن لوڈ کریں';

  @override
  String get purchaseHistoryPdfDownloaded =>
      'انوائس پی ڈی ایف کامیابی سے ڈاؤن لوڈ ہو گئی';

  @override
  String get purchaseHistoryRefundRequestTitle => 'رقم واپسی کی درخواست';

  @override
  String get purchaseHistoryRefundPolicy =>
      'ایڈیولائب کی 30 دن کی رقم واپسی گارنٹی کے مطابق، آپ مکمل رقم واپس حاصل کر سکتے ہیں۔';

  @override
  String get purchaseHistoryRefundReasonHint => 'رقم واپسی کی وجہ (اختیاری)...';

  @override
  String get purchaseHistoryConfirmRefund => 'رقم واپسی کی تصدیق کریں';

  @override
  String get purchaseHistoryRefundSubmitted =>
      'رقم واپسی کی درخواست کامیابی سے جمع ہو گئی (3-5 کام کے دن)۔';

  @override
  String get purchaseHistoryInstructor => 'انسٹرکٹر';

  @override
  String get purchaseHistoryRequestRefundBtn => 'رقم واپسی کی درخواست';

  @override
  String get purchaseHistoryInvoiceBtn => 'انوائس';

  @override
  String get purchaseHistoryStatusCompleted => 'مکمل';

  @override
  String get purchaseHistoryStatusRefunded => 'واپس کر دیا گیا';

  @override
  String get purchaseHistoryStatusProcessingRefund => 'رقم واپسی زیر کارروائی';

  @override
  String get editProfileSectionBasicInfo => 'بنیادی معلومات';

  @override
  String get editProfileFullNameLabel => 'پورا نام *';

  @override
  String get editProfileFullNameHint => 'اپنا پورا نام درج کریں';

  @override
  String get editProfileFullNameError => 'براہ کرم پورا نام درج کریں';

  @override
  String get editProfileHeadlineLabel => 'پیشہ ورانہ عنوان / تخصص';

  @override
  String get editProfileHeadlineHint => 'مثلاً: سینئر فلٹر ڈویلپر';

  @override
  String get editProfileLocationLabel => 'شہر / ملک';

  @override
  String get editProfileLocationHint => 'اسلام آباد، پاکستان';

  @override
  String get editProfilePhoneLabel => 'موبائل فون نمبر';

  @override
  String get editProfileBioLabel => 'میرے بارے میں (Bio)';

  @override
  String get editProfileBioHint =>
      'اپنی دلچسپیوں اور تجربے کے بارے میں مختصر خلاصہ لکھیں...';

  @override
  String get editProfileSectionLinks => 'روابط اور پیشہ ورانہ نیٹ ورکس';

  @override
  String get editProfileWebsiteLabel => 'ذاتی ویب سائٹ';

  @override
  String get editProfileSectionEmail => 'رجسٹرڈ ای میل';

  @override
  String get editProfileEmailDesc =>
      'لاگ ان اور سرٹیفکیٹ حاصل کرنے کے لیے اکاؤنٹ سے منسلک ہے';

  @override
  String get editProfileEmailVerified => 'تصدیق شدہ';

  @override
  String get editProfileSaveChangesBtn => 'معلومات محفوظ اور اپ ڈیٹ کریں';

  @override
  String get editProfileSavedSuccess => 'پروفائل کامیابی سے اپ ڈیٹ ہو گئی!';

  @override
  String get editProfileChangeAvatarTitle => 'پروفائل تصویر تبدیل کریں';

  @override
  String get editProfileTakePhoto => 'کیمرے سے تصویر لیں';

  @override
  String get editProfileChooseGallery => 'گیلری سے منتخب کریں';

  @override
  String get editProfilePhotoUpdatedSuccess =>
      'پروفائل تصویر کامیابی سے اپ ڈیٹ ہو گئی';

  @override
  String get teachJoinInstructorTitle => 'بطور انسٹرکٹر شامل ہوں';

  @override
  String get teachJoinInstructorSubtitle =>
      'اپنے کورسز شائع کریں اور ہزاروں طلباء کے ساتھ اپنا تجربہ شیئر کریں۔';

  @override
  String get teachStep1Title => 'ذاتی معلومات';

  @override
  String get teachStep2Title => 'تجربہ اور مہارتیں';

  @override
  String get teachStep3Title => 'درخواست کی تصدیق';

  @override
  String get teachStep1Header => '1. ذاتی اور پیشہ ورانہ معلومات';

  @override
  String get teachFullNameArabicLabel => 'پورا نام *';

  @override
  String get teachFullNameArabicHint => 'مثلاً: محمد علی';

  @override
  String get teachHeadlineLabel => 'پیشہ ورانہ عنوان اور تخصص *';

  @override
  String get teachHeadlineHint =>
      'مثلاً: سینئر سافٹ ویئر آرکیٹیکٹ اور فلٹر ٹرینر';

  @override
  String get teachPhoneLabel => 'رابطہ فون نمبر *';

  @override
  String get teachCountryLabel => 'رہائشی ملک *';

  @override
  String get teachBioLabel => 'تعارف اور سابقہ تجربہ *';

  @override
  String get teachBioHint =>
      'اپنے کیریئر اور سابقہ پروجیکٹس کا مختصر خلاصہ لکھیں...';

  @override
  String get teachNextStepSkills => 'جاری رکھیں: تجربہ اور مہارتیں';

  @override
  String get teachStep2Header => '2. کورس مواد اور مہارتیں';

  @override
  String get teachTopicLabel => 'مجوزہ کورس کا موضوع *';

  @override
  String get teachTopicHint => 'مثلاً: شروع سے فلٹر ایپ ڈویلپمنٹ';

  @override
  String get teachYearsExperienceLabel => 'شعبے میں تجربے کے سال *';

  @override
  String get teachVideoLinkLabel =>
      'نمونہ تدریسی ویڈیو لنک (YouTube/Drive/Loom) *';

  @override
  String get teachTargetAudienceLabel => 'کورس کے لیے ہدف طلباء *';

  @override
  String get teachAudienceBeginners => 'بالکل ابتدائی طلباء';

  @override
  String get teachAudienceIntermediate => 'ابتدائی اور درمیانی سطح';

  @override
  String get teachAudienceAdvanced => 'ایڈوانس اور پیشہ ور افراد';

  @override
  String get teachAudienceAll => 'تمام افراد';

  @override
  String get teachSkillsCoveredLabel =>
      'کورس میں شامل مہارتیں اور ٹیکنالوجیز *';

  @override
  String get teachAddSkillHint => 'مہارت شامل کریں (مثلاً: GraphQL)...';

  @override
  String get teachAddSkillBtn => 'شامل کریں';

  @override
  String get teachNextStepConfirm => 'جاری رکھیں: درخواست کی تصدیق';

  @override
  String get teachStep3Header => '3. منافع کی تفصیلات اور شرائط';

  @override
  String get teachPayoutMethodLabel => 'منافع وصول کرنے کا طریقہ *';

  @override
  String get teachPayoutMethodBank => 'براہ راست بینک ٹرانسفر (IBAN)';

  @override
  String get teachPayoutMethodPaypal => 'تصدیق شدہ پے پال اکاؤنٹ';

  @override
  String get teachPayoutMethodPayoneer => 'پایونیئر کارڈ';

  @override
  String get teachIbanDetailsLabel => 'اکاؤنٹ کی تفصیلات / IBAN *';

  @override
  String get teachApplicationSummary => 'درخواست کا خلاصہ:';

  @override
  String get teachApplicantName => 'درخواست دہندہ';

  @override
  String get teachApplicantHeadline => 'تخصص';

  @override
  String get teachApplicantTopic => 'کورس کا موضوع';

  @override
  String get teachApplicantSkillsCount => 'شامل کردہ مہارتوں کی تعداد';

  @override
  String get teachSkillsUnit => 'مہارتیں';

  @override
  String get teachAgreeTermsLabel =>
      'میں ایڈیولائب کے انسٹرکٹر کی شرائط، ضوابط اور دانشورانہ ملکیت کے معاہدے سے اتفاق کرتا ہوں۔';

  @override
  String get teachSubmitApplicationBtn => 'Submit Instructor Application';

  @override
  String get teachPrevStepBtn => 'پچھلا';

  @override
  String get teachWhyEduLabTitle => 'ایڈیولائب پر تدریس کیوں منتخب کریں؟';

  @override
  String get teachProp1Title => 'مناسب اور شاندار آمدنی';

  @override
  String get teachProp1Desc =>
      'بغیر کسی پوشیدہ فیس کے اپنے کورس کی فروخت سے 80% تک منافع حاصل کریں۔';

  @override
  String get teachProp2Title => 'ہزاروں طلباء تک رسائی';

  @override
  String get teachProp2Desc =>
      'ایک فعال اور وسیع تعلیمی کمیونٹی میں اپنے کورس کو فروغ دیں۔';

  @override
  String get teachProp3Title => 'مکمل تکنیکی اور پروڈکشن سپورٹ';

  @override
  String get teachProp3Desc =>
      'ہماری ٹیم آڈیو، ویڈیو کوالٹی اور نصاب کو بہتر بنانے میں آپ کی مدد کرتی ہے۔';

  @override
  String get teachSuccessDialogTitle => 'درخواست کامیابی سے موصول ہوئی!';

  @override
  String get teachSuccessDialogDesc =>
      'ایڈیولائب انسٹرکٹرز میں شامل ہونے کا شکریہ۔ ہماری ٹیم 48 گھنٹوں کے اندر جائزہ لے کر آپ سے رابطہ کرے گی۔';

  @override
  String get teachSuccessDialogOk => 'ٹھیک ہے';

  @override
  String get teachAddOneSkillError => 'براہ کرم کم از کم ایک مہارت شامل کریں';

  @override
  String get teachAgreeTermsError => 'براہ کرم انسٹرکٹر کی شرائط کو تسلیم کریں';

  @override
  String get commonCancel => 'منسوخ کریں';

  @override
  String get commonClose => 'بند کریں';

  @override
  String get myCertificatesBannerTitle => 'تسلیم شدہ اسناد';

  @override
  String get myCertificatesBannerSubtitle =>
      'تمام سرٹیفکیٹس EduLab کے منفرد شناختی کوڈ کے ساتھ تصدیق شدہ ہیں';

  @override
  String get certBadgeVerified100 => '100% تصدیق شدہ';

  @override
  String get certCodeCopied => 'سرٹیفکیٹ کوڈ کاپی ہو گیا';

  @override
  String get certGrantedTo => 'برائے';

  @override
  String get certViewAndDownload => 'سرٹیفکیٹ دیکھیں اور ڈاؤن لوڈ کریں';

  @override
  String get certIssuerLabel => 'جاری کنندہ ادارہ';

  @override
  String get certIssuerName => 'EduLab انٹرایکٹو لرننگ اکیڈمی';

  @override
  String get certEmptyTitle => 'ابھی تک کوئی سرٹیفکیٹ حاصل نہیں ہوا';

  @override
  String get certEmptyDesc =>
      'کسی بھی کورس کو 100% مکمل کریں اور باضابطہ تصدیقی شناختی کوڈ کے ساتھ سند حاصل کریں۔';

  @override
  String get certEmptyAction => 'میرے کورسز جاری رکھیں';

  @override
  String get certDetailsTitle => 'سرٹیفکیٹ کی تفصیلات';

  @override
  String get certCopyLinkSuccess =>
      'براہ راست تصدیقی لنک کلپ بورڈ پر کاپی ہو گیا!';

  @override
  String get certShareSuccess =>
      'سرٹیفکیٹ کی تفصیلات اور لنک شیئر کرنے کے لیے کاپی ہو گیا!';

  @override
  String get purchaseHistoryTaxInvoiceCertified =>
      'باضابطہ تصدیق شدہ ٹیکس انوائس';

  @override
  String get purchaseHistoryInvoiceNumberLabel => 'آرڈر / انوائس نمبر';

  @override
  String get purchaseHistoryCourseNameLabel => 'کورس کا نام';

  @override
  String get purchaseHistoryPurchaseDateLabel => 'خریداری کی تاریخ';

  @override
  String get purchaseHistoryPaymentMethodLabel => 'ادائیگی کا طریقہ';

  @override
  String get purchaseHistoryPaymentMethodValue =>
      'کریڈٹ کارڈ / Stripe (آن لائن)';

  @override
  String get purchaseHistoryOrderStatusLabel => 'آرڈر کی حیثیت';

  @override
  String get purchaseHistoryStatusPendingReview => 'واپسی کا جائزہ زیر التواء';

  @override
  String get purchaseHistoryCopyInvoiceBtn => 'انوائس نمبر کاپی کریں';

  @override
  String get purchaseHistoryRefundReasonLabel =>
      'رقم کی واپسی کی درخواست کی وجہ:';

  @override
  String get purchaseHistoryRefundReasonEmptyError =>
      'براہ کرم واپسی کی درخواست کی وجہ درج کریں';

  @override
  String get purchaseHistorySubmittingRefund => 'درخواست بھیجی جا رہی ہے...';

  @override
  String get purchaseHistoryPaidDate => 'ادائیگی کی تاریخ';

  @override
  String get purchaseHistoryEmptyTitle => 'ابھی تک کوئی خریداری نہیں ہوئی';

  @override
  String get purchaseHistoryEmptyDesc =>
      'آپ نے ابھی تک کوئی کورس نہیں خریدا ہے۔\nآپ کے آرڈرز اور انوائسز مکمل ہونے پر یہاں ظاہر ہوں گے۔';

  @override
  String get purchaseHistoryExploreCourses => 'ابھی کورسز دریافت کریں';

  @override
  String get profileMyCourses => 'میرے کورسز';

  @override
  String get profileMyCoursesSubtitle => 'اپنے کورسز میں پیش رفت دیکھیں';

  @override
  String get profileWishlistSubtitle => 'خواہشات کی فہرست میں محفوظ کورسز';

  @override
  String get navMyLearning => 'میری تعلیم';

  @override
  String get profileLogoutSafeNote =>
      'آپ کا ڈیٹا، کورسز اور اسناد مکمل طور پر محفوظ ہیں۔ آپ دوبارہ لاگ ان کر کے کسی بھی وقت اپنی تعلیم جاری رکھ سکتے ہیں۔';

  @override
  String learningRemainingHours(String hours) {
    return '$hours گھنٹے باقی';
  }

  @override
  String get learningCompletedFull => 'مکمل شدہ';

  @override
  String get learningFilterNotStarted => 'Not Started';

  @override
  String get wishlistTopRatedBadge => 'سب سے زیادہ درجہ بندی';

  @override
  String get wishlistFeaturedBadge => 'نمایاں';

  @override
  String wishlistDiscountBadge(String percent) {
    return '$percent% رعایت';
  }

  @override
  String get courseFree => 'مفت';

  @override
  String get badgeBestseller => 'سب سے زیادہ فروخت';

  @override
  String get badgeTopRated => 'سب سے زیادہ درجہ بندی';

  @override
  String get badgeFeatured => 'نمایاں';

  @override
  String get badgeRecommended => 'آپ کے لیے تجویز کردہ';

  @override
  String get badgeNew => 'نیا';

  @override
  String get courseWord => 'کورس';

  @override
  String coursesCountText(String count) {
    return '$count+ کورسز';
  }

  @override
  String studentsCountText(String count) {
    return '$count طلباء';
  }

  @override
  String hoursCountText(String count) {
    return '$count گھنٹے';
  }

  @override
  String get certifiedInstructor => 'تصدیق شدہ انسٹرکٹر';

  @override
  String get expertCertifiedInstructor => 'ماہر اور تصدیق شدہ انسٹرکٹر';

  @override
  String get defaultCourseTitle => 'تعلیمی کورس';

  @override
  String get categoryWord => 'زمرہ';

  @override
  String get previewCourseVideo => 'کورس ویڈیو پیش نظارہ';

  @override
  String get freeSection => 'مفت حصہ';

  @override
  String get freeDemoVideo => 'مفت ڈیمو ویڈیو';

  @override
  String get articleLecture => 'مضمون پر مبنی سبق';

  @override
  String get articleViewer => 'مضمون ویور';

  @override
  String get courseVideoPlayer => 'کورس ویڈیو پلیئر';

  @override
  String get playingNow => 'اب چل رہا ہے';

  @override
  String get readingNow => 'اب پڑھا جا رہا ہے';

  @override
  String get noLecturesInFreeSection => 'مفت حصے میں کوئی سبق موجود نہیں ہے';

  @override
  String freeLecturesCount(String count) {
    return '$count مفت اسباق';
  }

  @override
  String get enrollInFullCourse => 'مکمل کورس میں داخلہ لیں';

  @override
  String get articleWord => 'مضمون';

  @override
  String get videoWord => 'ویڈیو';

  @override
  String get quizWord => 'کوئز';

  @override
  String get courseShareCopied => 'کورس کا لنک کاپی ہو گیا!';

  @override
  String get addedToCartSnackbar => 'کارٹ میں شامل کر دیا گیا';

  @override
  String get viewCartAction => 'کارٹ دیکھیں';

  @override
  String get inCartBadge => 'کارٹ میں ہے ✓';

  @override
  String get addToCartButton => 'کارٹ میں شامل کریں';

  @override
  String get wishlistAddedSnackbar =>
      'کورس کو خواہشات کی فہرست میں شامل کر دیا گیا';

  @override
  String get wishlistRemovedSuccessSnackbar => 'کورس کو فہرست سے ہٹا دیا گیا';

  @override
  String get lessonCompletedAll =>
      'مبارک ہو! آپ نے اس کورس کے تمام اسباق مکمل کر لیے ہیں۔';

  @override
  String get noteAddedSuccess => 'نوٹ کامیابی سے شامل کر دیا گیا';

  @override
  String get lessonAlreadyDownloaded => 'سبق پہلے ہی آف لائن کے لیے محفوظ ہے';

  @override
  String get lessonLinkCopied => 'سبق کا لنک کاپی ہو گیا';

  @override
  String get contentReportThanks =>
      'آپ کی رائے کا شکریہ، سبق کا جائزہ لیا جائے گا';

  @override
  String get courseCompletionCertificate => 'کورس کی تکمیل کا سرٹیفکیٹ';

  @override
  String get reportContentIssue => 'مواد کے مسئلے کی اطلاع دیں';

  @override
  String get loginOrSocial => 'یا اس کے ذریعے سائن ان کریں';

  @override
  String get loginSuccessSnackbar => 'کامیابی سے سائن ان ہو گیا';

  @override
  String get cartClearDialogTitle => 'Clear Cart';

  @override
  String get cartClearDialogMessage =>
      'Are you sure you want to remove all courses from your shopping cart?';

  @override
  String get cartClearConfirmButton => 'Clear';

  @override
  String get guestWelcomeTitle => 'Welcome to EduLab';

  @override
  String get guestWelcomeSubtitle =>
      'Sign in to track your courses and certificates';

  @override
  String get securitySetup2FATitle => 'Two-Factor Authentication Setup (2FA)';

  @override
  String get securityScanQRCode =>
      'Scan the QR code with your authenticator app';

  @override
  String get securitySecretKeyManual => 'Secret key (for manual entry)';

  @override
  String get securitySecretKeyCopied => 'Secret key copied';

  @override
  String get securityEnter6DigitCode => 'Enter verification code (6 digits):';

  @override
  String get securityConfirmEnable2FABtn => 'Confirm & Enable 2FA';

  @override
  String get securityEnter6DigitsError =>
      'Please enter the 6-digit verification code';

  @override
  String get securityLogoutAllDevicesTitle => 'Sign Out from All Devices';

  @override
  String get securityLogoutAllDevicesMessage =>
      'Are you sure you want to sign out from all other devices?\nYou will remain signed in on this device only.';

  @override
  String get securityLogoutAllDevicesConfirmBtn => 'Sign Out All';

  @override
  String get securityDisable2FAModalTitle =>
      'Disable Two-Factor Authentication';

  @override
  String get securityDisable2FAModalMessage =>
      'Disabling this feature will reduce your account security.\nAre you sure you want to proceed?';

  @override
  String get securityDisable2FAConfirmBtn => 'Disable 2FA';

  @override
  String get securityNoOtherSessions => 'No other active sessions or devices';

  @override
  String get securityCurrentDeviceOnly =>
      'You are currently signed in on this device only';

  @override
  String get securityShowLessDevices => 'Show fewer devices';

  @override
  String securityShowAllDevicesCount(String count) {
    return 'Show all devices ($count)';
  }

  @override
  String get securityUpdatingPassword => 'Updating password...';

  @override
  String get editProfileTakePhotoDesc => 'Take a new photo with camera';

  @override
  String get editProfileChooseGalleryDesc =>
      'Choose a saved photo from gallery';

  @override
  String get editProfileHeadlineError => 'Headline is required';

  @override
  String get editProfileLocationError => 'Location is required';

  @override
  String get editProfilePhoneError => 'Phone number is required';

  @override
  String get editProfileBioError => 'Bio is required';

  @override
  String get editProfileSavingChanges => 'Saving changes...';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get themeSystem => 'System';

  @override
  String get teachFullNameRequired => 'Enter full name';

  @override
  String get teachHeadlineRequired => 'Enter professional headline';

  @override
  String get teachPhoneRequired => 'Enter phone number';

  @override
  String get teachCountryRequired => 'Enter country of residence';

  @override
  String get teachBioMinLength =>
      'Please write a bio of at least 20 characters';

  @override
  String get teachSubmittingApplication => 'Submitting...';

  @override
  String get wishlistFailedAddToCart => 'Failed to add course to cart';

  @override
  String get cartClearAllTitle => 'کارٹ کی تمام اشیاء صاف کریں؟';

  @override
  String cartClearAllMessage(String count) {
    return 'کیا آپ واقعی اپنے شاپنگ کارٹ سے تمام $count کورسز ہٹانا چاہتے ہیں؟';
  }

  @override
  String get cartClearAllHint =>
      'تمام کورسز آپ کے کارٹ سے ہٹا دیے جائیں گے۔ آپ انہیں کسی بھی وقت دوبارہ شامل کر سکتے ہیں۔';

  @override
  String cartClearAllConfirm(String count) {
    return 'سبھی صاف کریں ($count)';
  }

  @override
  String get cartClearedSuccess => 'کارٹ کامیابی کے ساتھ صاف کر دیا گیا';

  @override
  String get cartClearFailed => 'کارٹ صاف کرنے میں ناکامی';

  @override
  String cartViewWishlistCount(String count) {
    return 'خواہشات کی فہرست کی اشیاء دیکھیں ($count)';
  }

  @override
  String get cartGoToWishlist => 'خواہشات کی فہرست پر جائیں';

  @override
  String get wishlistClearAllTitle =>
      'خواہشات کی فہرست کی تمام اشیاء صاف کریں؟';

  @override
  String wishlistClearAllMessage(String count) {
    return 'کیا آپ واقعی اپنی خواہشات کی فہرست سے تمام $count کورسز ہٹانا چاہتے ہیں؟';
  }

  @override
  String get wishlistClearAllHint =>
      'تمام محفوظ کردہ کورسز صاف کر دیے جائیں گے۔ آپ انہیں کسی بھی وقت ایکسپلور سے دوبارہ شامل کر سکتے ہیں۔';

  @override
  String wishlistClearAllConfirm(String count) {
    return 'سبھی صاف کریں ($count)';
  }

  @override
  String get wishlistClearedSuccess =>
      'خواہشات کی فہرست کامیابی کے ساتھ صاف کر دی گئی';

  @override
  String get wishlistClearFailed => 'خواہشات کی فہرست صاف کرنے میں ناکامی';

  @override
  String get wishlistClearTooltip => 'سبھی صاف کریں';

  @override
  String wishlistViewCartCount(String count) {
    return 'کارٹ کی اشیاء دیکھیں ($count)';
  }

  @override
  String get wishlistGoToCart => 'کارٹ پر جائیں';

  @override
  String get checkoutCardNumberInvalid =>
      'براہ کرم 16 ہندسوں کا درست کارڈ نمبر درج کریں';

  @override
  String get checkoutCardExpiryInvalidFormat =>
      'براہ کرم کارڈ کی درست میعاد ختم ہونے کی تاریخ درج کریں (MM / YY)';

  @override
  String get checkoutCardExpiredDate =>
      'کارڈ کی میعاد ختم ہونے کی تاریخ غلط ہے';

  @override
  String get checkoutCardCvcInvalid =>
      'براہ کرم 3 یا 4 ہندسوں کا درست CVC کوڈ درج کریں';

  @override
  String get checkoutCardHolderNameRequired =>
      'براہ کرم کارڈ ہولڈر کا نام درج کریں';

  @override
  String get checkoutCartEmptySnackbar => 'شاپنگ کارٹ خالی ہے';

  @override
  String get checkoutPaymentStartFailed => 'ادائیگی شروع کرنے میں ناکامی';

  @override
  String get checkoutClientSecretMissing =>
      'پیمنٹ گیٹ وے سے سیکیورٹی کلید موصول نہیں ہوئی';

  @override
  String get checkoutCardVerificationFailed => 'کارڈ کی تصدیق ناکام ہو گئی';

  @override
  String get checkoutStripeProcessingFailed =>
      'سٹرائپ ادائیگی کی پروسیسنگ ناکام ہو گئی';

  @override
  String get checkoutServerConfirmationFailed =>
      'سرور کی ادائیگی کی تصدیق ناکام ہو گئی';

  @override
  String get checkoutEmptyCartTitle => 'آپ کا کارٹ خالی ہے';

  @override
  String get checkoutEmptyCartDesc =>
      'آپ نے ابھی تک اپنے کارٹ میں کوئی کورس شامل نہیں کیا ہے۔ ہمارے کورسز دریافت کریں اور سیکھنا شروع کریں!';

  @override
  String get checkoutContinueFreeReview => 'مفت جائزے کے لیے آگے بڑھیں';

  @override
  String get checkoutFreeOrderBadge => '100% مفت آرڈر (zsh.00)';

  @override
  String get checkoutFreeOrderNotice =>
      'اس آرڈر کے لیے کسی ادائیگی کی معلومات کی ضرورت نہیں ہے۔ آپ اندراج کی تصدیق کے لیے براہ راست آگے بڑھ سکتے ہیں۔';

  @override
  String get checkoutFreeCheckoutTitle => '100% مفت چیک آؤٹ';

  @override
  String get checkoutConfirmFreeEnrollment => 'مفت اندراج کی تصدیق کریں';

  @override
  String get checkoutFreePrice => 'مفت';

  @override
  String get checkoutFreeZero => 'مفت (zsh.00)';

  @override
  String checkoutCoursesCount(String count) {
    return '$count کورسز';
  }

  @override
  String get notificationsClearAllTitle => 'تمام اطلاعات صاف کریں؟';

  @override
  String notificationsClearAllMessage(String count) {
    return 'کیا آپ واقعی تمام $count اطلاعات کو حذف کرنا چاہتے ہیں؟ اس عمل کو واپس نہیں لایا جا سکتا۔';
  }

  @override
  String get notificationsClearAllHint =>
      'آپ کی تمام اطلاعات حذف کر دی جائیں گی اور آپ کا ان باکس بالکل نیا ہو جائے گا۔';

  @override
  String notificationsClearAllConfirm(String count) {
    return 'سبھی صاف کریں ($count)';
  }

  @override
  String get notificationsClearSuccess =>
      'تمام اطلاعات کامیابی کے ساتھ صاف کر دی گئیں';

  @override
  String get notificationsClearFailed => 'اطلاعات صاف کرنے میں ناکامی';

  @override
  String get notificationsClearTooltip => 'سبھی صاف کریں';

  @override
  String get notificationsViewDetails => 'تفصیلات دیکھیں';

  @override
  String get notificationsEmptyCategoryTitle =>
      'اس زمرے میں کوئی اطلاع نہیں ہے';

  @override
  String get notificationsEmptyCategorySubtitle =>
      'کسی دوسرے زمرے میں تبدیل کرنے کی کوشش کریں یا تمام اطلاعات کو براؤز کریں';

  @override
  String get notificationsEmptyAllSubtitle =>
      'ہم آپ کو یہاں تازہ ترین اپ ڈیٹس اور الرٹس سے باخبر رکھیں گے';

  @override
  String get notificationsViewAll => 'تمام اطلاعات دیکھیں';

  @override
  String get learningFilterAndSortTitle => 'کورسز کو فلٹر اور ترتیب دیں';

  @override
  String get learningFilterReset => 'ری سیٹ';

  @override
  String get learningSortByTitle => 'ترتیب دیں بلحاظ';

  @override
  String get learningSortRecentActivity => 'حال ہی میں دیکھا گیا';

  @override
  String get learningSortRecentEnrolled => 'حال ہی میں شامل شدہ';

  @override
  String get learningSortTitleAZ => 'عنوان (A-Z)';

  @override
  String get learningSortProgress => 'پیشرفت %';

  @override
  String get learningStatusTitle => 'کورس کی حیثیت';

  @override
  String get learningStatusAll => 'تمام کورسز';

  @override
  String get learningStatusInProgress => 'جاری ہے';

  @override
  String get learningStatusCompleted => 'مکمل';

  @override
  String get learningStatusNotStarted => 'شروع نہیں ہوا۔';

  @override
  String get learningFilterApply => 'فلٹرز لگائیں۔';

  @override
  String get learningSearchCoursesHint => 'اپنے کورسز تلاش کریں...';

  @override
  String get learningSearchWishlistHint => 'خواہش کی فہرست تلاش کریں...';

  @override
  String get learningSearchCertificatesHint => 'سرٹیفکیٹ تلاش کریں...';

  @override
  String get learningTabMyCourses => 'میرے کورسز';

  @override
  String get learningTabFavourite => 'میرا پسندیدہ';

  @override
  String get learningTabCertificates => 'میرے سرٹیفکیٹس';

  @override
  String get learningNoCoursesTitle => 'ابھی تک کوئی کورسز نہیں ہیں۔';

  @override
  String get learningNoCoursesSubtitle =>
      'ہزاروں پریمیم کورسز دریافت کریں اور آج ہی اپنا سیکھنے کا سفر شروع کریں۔';

  @override
  String get learningFilterButton => 'فلٹر';

  @override
  String learningFilterAllCount(String count) {
    return 'تمام ($count)';
  }

  @override
  String get learningStatusNotStartedShort => 'شروع نہیں ہوا۔';

  @override
  String get learningNoMatchTitle => 'کوئی مماثل کورسز نہیں ہیں۔';

  @override
  String learningNoMatchSubtitle(String query) {
    return '\"$query\" پر مشتمل کوئی کورس نہیں ملا۔ مختلف اصطلاحات کے ساتھ تلاش کرنے کی کوشش کریں۔';
  }

  @override
  String get learningNoInProgressTitle => 'کوئی کورس جاری نہیں ہے۔';

  @override
  String get learningNoInProgressSubtitle =>
      'یہاں اپنی پیشرفت کو ٹریک کرنے کے لیے اپنے اندراج شدہ کورسز میں اسباق دیکھنا شروع کریں۔';

  @override
  String get learningNoCompletedTitle => 'ابھی تک کوئی مکمل کورس نہیں ہوا۔';

  @override
  String get learningNoCompletedSubtitle =>
      'اپنی ترقی کا جشن منانے کے لیے اپنی پڑھائی جاری رکھیں اور مکمل شدہ کورسز یہاں دیکھیں۔';

  @override
  String get learningNoUnstartedTitle => 'کوئی غیر شروع شدہ کورسز';

  @override
  String get learningNoUnstartedSubtitle =>
      'بہت اچھے! آپ نے پہلے ہی اپنے اندراج شدہ تمام کورسز میں سیکھنا شروع کر دیا ہے۔';

  @override
  String get learningNoFilterMatchTitle =>
      'کوئی کورس اس فلٹر سے مماثل نہیں ہے۔';

  @override
  String get learningNoFilterMatchSubtitle =>
      'اپنے کورسز کو دکھانے کے لیے فلٹر یا ترتیب کے اختیارات تبدیل کریں۔';

  @override
  String learningViewAllCoursesCount(String count) {
    return 'تمام کورسز دیکھیں ($count)';
  }

  @override
  String learningSavedCoursesCount(String count) {
    return 'محفوظ کردہ کورسز ($count)';
  }

  @override
  String get learningClearAllSaved => 'تمام صاف کریں۔';

  @override
  String get learningNoCertificatesTitle => 'ابھی تک کوئی سرٹیفکیٹ نہیں ہے۔';

  @override
  String get learningNoCertificatesSubtitle =>
      'تسلیم شدہ سرٹیفکیٹ حاصل کرنے کے لیے اپنے کورسز مکمل کریں جو آپ کی کامیابیوں کی تصدیق کرتے ہیں۔';

  @override
  String get learningGoToCourses => 'میرے کورسز پر جائیں۔';

  @override
  String learningCertIssuedDate(String date) {
    return 'جاری کردہ: $date';
  }

  @override
  String get learningCertView => 'دیکھیں';

  @override
  String get learningResumeLesson => 'سبق دوبارہ شروع کریں۔';

  @override
  String learningProgressPercentComplete(String percent) {
    return '$percent% مکمل';
  }

  @override
  String learningViewCartCount(String count) {
    return 'کارٹ آئٹمز دیکھیں ($count)';
  }

  @override
  String get learningGoToCart => 'کارٹ پر جائیں۔';

  @override
  String get playerLessonMarkedCompleted =>
      'اسباق کو مکمل کے بطور نشان زد کیا گیا ✓';

  @override
  String get playerLessonMarkedIncomplete =>
      'اسباق کو نامکمل کے بطور نشان زد کیا گیا ہے۔';

  @override
  String get playerCommentPostedSuccess =>
      'تبصرہ کامیابی کے ساتھ پوسٹ کیا گیا۔';

  @override
  String get playerCommentPostFailed => 'تبصرہ پوسٹ کرنے میں ناکام';

  @override
  String get playerReplyPostedSuccess => 'جواب کامیابی کے ساتھ پوسٹ کیا گیا۔';

  @override
  String get playerReplyPostFailed => 'جواب پوسٹ کرنے میں ناکام';

  @override
  String get playerCourseNotFound => 'کورس نہیں ملا';

  @override
  String get playerCheckEnrollmentPrompt =>
      'براہ کرم پہلے اپنے کورس کے اندراج کی تصدیق کریں۔';

  @override
  String get playerReturnToCourses => 'میری تعلیم';

  @override
  String get playerWatchLecture => 'کورس لیکچر';

  @override
  String get playerCertificateTooltip => 'سرٹیفکیٹ';

  @override
  String get playerRateCourseTooltip => 'شرح کورس';

  @override
  String get playerReadingArticleBadge => 'مضمون پڑھنا • 5 منٹ';

  @override
  String get playerReadFullTextBelow => 'نیچے مکمل متن پڑھیں ↓';

  @override
  String get playerTabReviews => 'جائزے';

  @override
  String get playerNoSectionsAvailable => 'کوئی سیکشن دستیاب نہیں ہے۔';

  @override
  String playerLessonsCount(String count) {
    return '$count اسباق';
  }

  @override
  String get playerPlayingBadge => 'کھیل رہا ہے۔';

  @override
  String get playerArticleBadge => 'مضمون';

  @override
  String get playerVideoBadge => 'ویڈیو';

  @override
  String get playerFullArticleContent => 'مکمل مضمون کا مواد';

  @override
  String get playerArticlePlaceholder =>
      'پڑھنے کے اس سبق میں خوش آمدید۔\n\nاس سیکشن میں بنیادی تصورات اور عملی اقدامات کا احاطہ کیا گیا ہے جن کی آپ کو اس سبق میں مہارت حاصل کرنے کی ضرورت ہے۔';

  @override
  String get playerAboutCourseTitle => 'اس کورس کے بارے میں';

  @override
  String get playerShowLess => 'کم دکھائیں۔';

  @override
  String get playerReadMore => 'مزید پڑھیں';

  @override
  String get playerWhatYouWillLearn => 'آپ کیا سیکھیں گے';

  @override
  String get playerCourseInfoTitle => 'کورس کی تفصیلات';

  @override
  String get playerTotalDurationTitle => 'کل مدت';

  @override
  String get playerTotalLessonsTitle => 'کل اسباق';

  @override
  String playerLessonsNumber(String count) {
    return '$count اسباق';
  }

  @override
  String get playerLevelTitle => 'سطح';

  @override
  String get playerAllLevels => 'تمام سطحیں';

  @override
  String get playerLanguageTitle => 'زبان';

  @override
  String get playerLanguageArabic => 'عربی';

  @override
  String get playerPrerequisitesTitle => 'کورس کی شرائط';

  @override
  String get playerCertificateCardTitle => 'کورس سرٹیفکیٹ';

  @override
  String get playerCourseCompletedSuccess => 'مبارک ہو! کورس مکمل ہو گیا';

  @override
  String get playerProgressLabel => 'پیش رفت';

  @override
  String get playerViewCertificateBtn => 'سرٹیفکیٹ دیکھیں';

  @override
  String get playerCertifiedInstructor => 'مصدقہ انسٹرکٹر';

  @override
  String playerDiscussionsCount(String count) {
    return '$count سوالات اور مباحثے';
  }

  @override
  String get playerAskQuestionHint => 'اپنا سوال یا استفسار یہاں ٹائپ کریں...';

  @override
  String get playerPostBtn => 'پوسٹ کریں';

  @override
  String get playerNoDiscussionsTitle => 'ابھی تک کوئی مباحثہ نہیں ہے';

  @override
  String get playerNoDiscussionsSubtitle => 'سب سے پہلے سوال پوچھیں!';

  @override
  String get playerInstructorBadge => 'انسٹرکٹر';

  @override
  String get playerCancelReply => 'منسوخ کریں';

  @override
  String get playerReplyAction => 'جواب دیں';

  @override
  String playerRepliesCount(String count) {
    return '$count جوابات';
  }

  @override
  String get playerWriteReplyHint => 'اپنا جواب لکھیں...';

  @override
  String get playerSendReplyBtn => 'جواب دیں';

  @override
  String get playerCourseFeedbackTitle => 'کورس کی درجہ بندی اور آراء';

  @override
  String get playerOutOf5 => '5 میں سے';

  @override
  String playerRatingsFromEnrolledCount(String count) {
    return 'اندراج شدہ طلباء کی جانب سے $count درجہ بندیاں';
  }

  @override
  String get playerKeepLearningToRate =>
      'درجہ بندی دینے کے لیے سیکھنا جاری رکھیں';

  @override
  String get playerRateAfter80Hint =>
      'آپ اس کورس کا 80% مواد مکمل کرنے کے بعد اس کا جائزہ اور درجہ بندی دے سکتے ہیں';

  @override
  String get playerCurrentProgressLabel => 'آپ کی پیش رفت:';

  @override
  String get playerYourCurrentRating => 'آپ کی درجہ بندی';

  @override
  String get playerEditRating => 'درجہ بندی میں ترمیم کریں';

  @override
  String get playerDeleteRatingTooltip => 'درجہ بندی حذف کریں';

  @override
  String get playerUpdateRatingTitle => 'اپنی درجہ بندی اپ ڈیٹ کریں';

  @override
  String get playerRateCourseTitle => 'اس کورس کی درجہ بندی کریں';

  @override
  String get playerWriteReviewHint =>
      'مواد کے معیار کے بارے میں اپنی رائے اور تاثرات لکھیں (اختیاری)...';

  @override
  String get playerRatingSubmitSuccess =>
      'درجہ بندی کامیابی کے ساتھ جمع ہو گئی!';

  @override
  String get playerRatingSubmitFailed => 'درجہ بندی جمع کرنے میں ناکام';

  @override
  String get playerSaveChangesBtn => 'تبدیلیاں محفوظ کریں';

  @override
  String get playerSubmitReviewBtn => 'جائزہ جمع کریں';

  @override
  String get playerLearnerReviewsTitle => 'سیکھنے والوں کے جائزے';

  @override
  String playerReviewsCount(String count) {
    return '$count جائزے';
  }

  @override
  String get playerNoWrittenReviewsTitle => 'ابھی تک کوئی تحریری جائزہ نہیں ہے';

  @override
  String get playerNoWrittenReviewsSubtitle =>
      'سب سے پہلے اپنی رائے کا اظہار کریں!';

  @override
  String get playerRatingLabel5 => 'بہترین 🌟 (5/5)';

  @override
  String get playerRatingLabel4 => 'بہت اچھا 👍 (4/5)';

  @override
  String get playerRatingLabel3 => 'اوسط 👌 (3/5)';

  @override
  String get playerRatingLabel2 => 'بہتری کی ضرورت ہے 🤔 (2/5)';

  @override
  String get playerRatingLabel1 => 'ناقص 👎 (1/5)';

  @override
  String get playerDeleteRatingDialogTitle => 'درجہ بندی حذف کریں';

  @override
  String get playerDeleteRatingDialogMessage =>
      'کیا آپ واقعی اس کورس کے لیے اپنا جائزہ حذف کرنا چاہتے ہیں؟';

  @override
  String get playerDeleteConfirmBtn => 'حذف کریں';

  @override
  String get playerRatingDeleteSuccess =>
      'درجہ بندی کامیابی کے ساتھ حذف ہو گئی';

  @override
  String get playerPreviousLesson => 'پچھلا سبق';

  @override
  String get playerExitFullscreenTooltip => 'فل اسکرین سے باہر نکلیں';

  @override
  String instructorsAvailableCount(String count) {
    return '$count انسٹرکٹرز دستیاب ہیں';
  }

  @override
  String get instructorsNotFound => 'کوئی انسٹرکٹر نہیں ملا';

  @override
  String instructorsCoursesCount(String count) {
    return '$count کورسز';
  }

  @override
  String get instructorsSearchHint =>
      'انسٹرکٹر کے نام یا خاصیت سے تلاش کریں...';

  @override
  String get instructorsSortAll => 'تمام';

  @override
  String get instructorsSortTopRated => 'ٹاپ ریٹیڈ';

  @override
  String get instructorsSortMostStudents => 'زیادہ تر طلباء';

  @override
  String get instructorsSortMostCourses => 'زیادہ تر کورسز';

  @override
  String get instructorsNotFoundSubtitle =>
      'کسی مختلف نام یا صاف فلٹرز سے تلاش کرنے کی کوشش کریں۔';

  @override
  String get exploreCompleteCourse => 'جامع کورس';

  @override
  String get exploreGeneralCategory => 'جنرل';

  @override
  String courseShareMessage(String title, String url) {
    return 'EduLab پر \"$title\" کورس دیکھیں: $url';
  }

  @override
  String get courseDetailsDefaultTitle => 'کورس کی تفصیلات';

  @override
  String get courseDetailsTooltipShare => 'شیئر کریں۔';

  @override
  String get courseDetailsTooltipWishlist => 'خواہش کی فہرست';

  @override
  String get courseDetailsTooltipCart => 'ٹوکری';

  @override
  String get courseDetailsNotFound => 'کورس نہیں ملا';

  @override
  String get courseDetailsDefaultCategory => 'کورس';

  @override
  String courseDetailsTotalRatingsCount(String count) {
    return '($count درجہ بندی)';
  }

  @override
  String courseDetailsLecturesCount(String count) {
    return '$count لیکچرز';
  }

  @override
  String get courseDetailsCertificateBadge => 'سرٹیفکیٹ';

  @override
  String get courseDetailsTabOverview => 'جائزہ';

  @override
  String get courseDetailsTabCurriculum => 'نصاب';

  @override
  String get courseDetailsTabInstructor => 'انسٹرکٹر';

  @override
  String get courseDetailsTabReviews => 'جائزے';

  @override
  String get courseDetailsFullDescriptionTitle => 'تفصیل';

  @override
  String get courseDetailsShowLess => 'کم دکھائیں۔';

  @override
  String get courseDetailsShowMore => 'مزید دکھائیں...';

  @override
  String courseDetailsCurriculumSectionsLectures(
    String sections,
    String lectures,
  ) {
    return '$sections حصے • $lectures لیکچرز';
  }

  @override
  String get courseDetailsCollapseAll => 'سب کو سمیٹیں۔';

  @override
  String get courseDetailsExpandAll => 'سبھی کو پھیلائیں۔';

  @override
  String get courseDetailsCurriculumComingSoon =>
      'نصاب کی تفصیلات جلد آرہی ہیں۔';

  @override
  String courseDetailsSectionLecturesCount(String count) {
    return '$count لیکچرز';
  }

  @override
  String get courseDetailsLecturePreviewBtn => 'پیش نظارہ';

  @override
  String get courseDetailsDefaultInstructorTitle =>
      'سینئر انسٹرکٹر اور مصدقہ ماہر';

  @override
  String get courseDetailsInstructorRatingLabel => 'درجہ بندی';

  @override
  String get courseDetailsInstructorStudentsLabel => 'طلباء';

  @override
  String get courseDetailsInstructorSectionsLabel => 'سیکشنز';

  @override
  String get courseDetailsAboutInstructorTitle => 'انسٹرکٹر کے بارے میں:';

  @override
  String get courseDetailsDefaultInstructorAbout =>
      'دنیا بھر کے ہزاروں طلباء کو پیشہ ورانہ تعلیم فراہم کرنے کے وسیع تجربے کے ساتھ مصدقہ انسٹرکٹر۔';

  @override
  String courseDetailsStudentRatingsCount(String count) {
    return '$count طالب علم کی درجہ بندی';
  }

  @override
  String get courseDetailsNoWrittenReviews =>
      'ابھی تک کوئی تحریری جائزے نہیں ہیں۔';

  @override
  String get courseDetailsRelatedCourses =>
      'متعلقہ کورسز جو آپ پسند کر سکتے ہیں۔';

  @override
  String courseDetailsDiscountPercent(String percent) {
    return '$percent% چھوٹ';
  }

  @override
  String get courseDetailsResumeCourse => 'کورس دوبارہ شروع کریں۔';

  @override
  String get courseDetailsTryAgain => 'دوبارہ کوشش کریں۔';

  @override
  String get courseDetailsEstimatedReading => '📖 تخمینی پڑھنا: 4 منٹ';

  @override
  String get courseDetailsSampleArticleContent =>
      'اس مضمون کے لیکچر میں خوش آمدید۔\n\nیہ سیکشن کلیدی نظریاتی تصورات اور موضوع پر عبور حاصل کرنے کے لیے عملی اقدامات کا احاطہ کرتا ہے۔\n\n• اہم ٹیک وے:\n1. بنیادی اصطلاحات اور تعمیراتی نمونوں کو سمجھیں۔\n2. ہینڈ آن مشقیں اور مسلسل مشق۔\n3. ضمنی نوٹس اور اسائنمنٹس کا حوالہ دیں۔\n\nپڑھنے کا لطف اٹھائیں!';

  @override
  String certDownloadedSuccess(String course, String format) {
    return '\"$course\" کا سرٹیفکیٹ $format فارمیٹ میں کامیابی کے ساتھ ڈاؤن لوڈ ہو گیا!';
  }

  @override
  String certVerifiedFullRequirements(String code) {
    return 'تصدیقی ID: $code • 100% تقاضے مکمل ہو گئے۔';
  }

  @override
  String get certCompletionTitle => 'تکمیل کا سرٹیفکیٹ';

  @override
  String get certCompletionSubtitle => 'کورس کی تکمیل کا سرٹیفکیٹ';

  @override
  String get certAnnounceStudent =>
      'ایجوکیشن لیب لرننگ اکیڈمی اس بات کی تصدیق کرتی ہے کہ:';

  @override
  String get certCompletionRequirementsMet =>
      'تربیتی کورس کی تمام ضروریات کو کامیابی سے مکمل کر لیا ہے:';

  @override
  String certIssueDateText(String date) {
    return 'جاری ہونے کی تاریخ: $date';
  }

  @override
  String certIdNumberText(String code) {
    return 'سرٹیفکیٹ ID: $code';
  }

  @override
  String get certPlatformManagement => 'پلیٹ فارم مینجمنٹ';

  @override
  String get certInstructorRoleTitle => 'کورس انسٹرکٹر';

  @override
  String get commonLoading => 'لوڈ ہو رہا ہے...';

  @override
  String get homeGuestTagline => 'سمارٹ لرننگ اور سکل بلڈنگ پلیٹ فارم';

  @override
  String get catTagHighestDemand => 'سب سے زیادہ مانگ';

  @override
  String get catTagMostPopular => 'سب سے زیادہ مقبول';

  @override
  String get catTagTrending => 'ٹرینڈنگ';

  @override
  String get catTagFastestGrowing => 'تیزی سے ابھرتا ہوا';

  @override
  String get catTagHighDemand => 'بہت زیادہ مانگ';

  @override
  String get catTagTopRated => 'اعلیٰ ترین ریٹنگ';

  @override
  String get catTagEssential => 'انتہائی اہم';

  @override
  String get catTagAdvanced => 'اعلیٰ سطح';

  @override
  String get catTagEntrepreneurs => 'کاروباری افراد';

  @override
  String get catTagSalesGrowth => 'سیلز میں اضافہ';

  @override
  String get catDevTitle => 'پروگرامنگ اور سافٹ ویئر ڈویلپمنٹ';

  @override
  String get catDevSubtitle => 'سافٹ ویئر انجینئرنگ، سسٹمز اور الگورتھمز';

  @override
  String get catWebTitle => 'ویب ڈویلپمنٹ';

  @override
  String get catWebSubtitle => 'فرنٹ اینڈ، بیک اینڈ اور فل اسٹیک ویب';

  @override
  String get catMobileTitle => 'موبائل ایپ ڈویلپمنٹ';

  @override
  String get catMobileSubtitle => 'Flutter، iOS اور Android ایپس';

  @override
  String get catAiTitle => 'مصنوعی ذہانت';

  @override
  String get catAiSubtitle => 'مشین لرننگ، ڈیپ لرننگ اور AI';

  @override
  String get catDataTitle => 'ڈیٹا سائنس اور اینالیٹکس';

  @override
  String get catDataSubtitle => 'ڈیٹا کا تجزیہ، شماریات اور بگ ڈیٹا';

  @override
  String get catDesignTitle => 'UI/UX اور پروڈکٹ ڈیزائن';

  @override
  String get catDesignSubtitle => 'UI/UX، پروٹو ٹائپنگ اور پروڈکٹ ڈیزائن';

  @override
  String get catSecurityTitle => 'سائبر سیکیورٹی اور نیٹ ورکنگ';

  @override
  String get catSecuritySubtitle =>
      'سائبر سیکیورٹی، ایتھیکل ہیکنگ اور نیٹ ورکس';

  @override
  String get catCloudTitle => 'کلاؤڈ کمپیوٹنگ اور DevOps';

  @override
  String get catCloudSubtitle => 'کلاؤڈ انفراسٹرکچر، DevOps اور CI/CD';

  @override
  String get catBusinessTitle => 'بزنس اور پروجیکٹ مینجمنٹ';

  @override
  String get catBusinessSubtitle => 'کاروبار، ایجائل اور قیادت';

  @override
  String get catMarketingTitle => 'ڈیجیٹل مارکیٹنگ';

  @override
  String get catMarketingSubtitle =>
      'ڈیجیٹل مارکیٹنگ، SEO اور ترقیاتی حکمت عملیاں';

  @override
  String get timeJustNow => 'ابھی';

  @override
  String timeMinutesAgo(String count) {
    return '$count منٹ پہلے';
  }

  @override
  String timeHoursAgo(String count) {
    return '$count گھنٹے پہلے';
  }

  @override
  String timeDaysAgo(String count) {
    return '$count دن پہلے';
  }

  @override
  String timeWeeksAgo(String count) {
    return '$count ہفتے پہلے';
  }

  @override
  String timeMonthsAgo(String count) {
    return '$count ماہ پہلے';
  }

  @override
  String wishlistLecturesCount(String count) {
    return '$count اسباق';
  }

  @override
  String get instructorProfileTitle => 'انسٹرکٹر پروفائل';

  @override
  String instructorProfileLinkCopied(String name) {
    return '$name کا لنک کلپ بورڈ پر کاپی ہو گیا';
  }

  @override
  String get instructorDefaultName => 'انسٹرکٹر';

  @override
  String get instructorProfileBadge => 'انسٹرکٹر';

  @override
  String get instructorProfileTotalStudents => 'کل طلباء';

  @override
  String get instructorProfileRating => 'انسٹرکٹر ریٹنگ';

  @override
  String get instructorProfileCourses => 'کورسز';

  @override
  String get instructorProfileShare => 'پروفائل شیئر کریں';

  @override
  String get instructorProfileLinkOpenError =>
      'لنک نہیں کھولا جا سکا، کلپ بورڈ پر کاپی کر دیا گیا';

  @override
  String get instructorProfileWebsite => 'ویب سائٹ';

  @override
  String get instructorProfileAboutMe => 'میرے بارے میں';

  @override
  String get instructorProfileShowLess => 'کم دکھائیں';

  @override
  String get instructorProfileShowMore => 'مزید دکھائیں';

  @override
  String get instructorProfileExpertise => 'مہارت کے شعبے';

  @override
  String get instructorProfileSortAll => 'تمام';

  @override
  String get instructorProfileSortTopRated => 'ٹاپ ریٹیڈ';

  @override
  String get instructorProfileSortPopular => 'مقبول';

  @override
  String get instructorProfileSortNewest => 'جدید ترین';

  @override
  String get instructorProfileCoursesTitle => 'انسٹرکٹر کے کورسز';

  @override
  String get instructorProfileNoCoursesFilter =>
      'اس فلٹر کے لیے کوئی کورس نہیں ملا';

  @override
  String instructorProfileLoadMoreCourses(String count) {
    return 'مزید کورسز لوڈ کریں ($count باقی ہیں)';
  }

  @override
  String get instructorProfileLoadingMoreCourses =>
      'مزید کورسز لوڈ ہو رہے ہیں...';

  @override
  String instructorProfileAllCoursesLoaded(String count) {
    return 'تمام $count کورسز لوڈ ہو چکے ہیں';
  }

  @override
  String get instructorProfileStudentFeedback => 'طلباء کے تاثرات';

  @override
  String instructorProfileReviewsCount(String count) {
    return '$count جائزے';
  }

  @override
  String instructorProfileBasedOnReviews(String count) {
    return '$count جائزوں پر مبنی';
  }

  @override
  String get instructorProfileRecentReviews => 'حالیہ جائزے';

  @override
  String instructorProfileLoadMoreReviews(String count) {
    return 'مزید جائزے لوڈ کریں ($count باقی ہیں)';
  }

  @override
  String get instructorProfileLoadingMoreReviews =>
      'مزید جائزے لوڈ ہو رہے ہیں...';

  @override
  String instructorProfileAllReviewsLoaded(String count) {
    return 'تمام $count جائزے لوڈ ہو چکے ہیں';
  }

  @override
  String get instructorProfileNoReviewsYet =>
      'ابھی تک کوئی تحریری جائزہ نہیں ہے';

  @override
  String get instructorProfileRatingDesc =>
      'ریٹنگ انسٹرکٹر کے تمام کورسز میں طلباء کی مجموعی ریٹنگ پر مبنی ہے';

  @override
  String get instructorProfileLoadError =>
      'انسٹرکٹر کی تفصیلات لوڈ کرنے میں ناکامی، براہ کرم بعد میں دوبارہ کوشش کریں';

  @override
  String get instructorProfileDefaultStudentName => 'طالب علم';

  @override
  String get instructorProfileDefaultBio =>
      'اسکیل ایبل سافٹ ویئر سسٹمز اور موبائل ایپلیکیشنز کی تیاری میں وسیع تجربے کے حامل مصدقہ سافٹ ویئر انجینئر اور تکنیکی انسٹرکٹر۔\nدنیا بھر کے ہزاروں طلباء اور انجینئرز کو تربیت دی ہے، اور کلین کوڈ، کلین آرکیٹیکچر اور جدید اسکیل ایبل حلوں پر مشتمل پیشہ ورانہ مواد پیش کیا ہے۔';

  @override
  String get instructorProfileDefaultHeadline =>
      'سینئر انسٹرکٹر اور مصدقہ ماہر';
}

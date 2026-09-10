// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get onboardingSkip => 'छोड़ें';

  @override
  String get onboardingTitle1 => 'EduLab में आपका स्वागत है';

  @override
  String get onboardingSubtitle1 =>
      'आधुनिक इंटरैक्टिव सीखने और करियर विकास के लिए आपका आदर्श मंच।';

  @override
  String get onboardingTitle2 => 'शीर्ष शिक्षकों से सीखें';

  @override
  String get onboardingSubtitle2 =>
      'प्रोग्रामिंग, डिज़ाइन, बिज़नेस और डेटा साइंस में हज़ारों पेशेवर कोर्स।';

  @override
  String get onboardingTitle3 => 'प्रमाणपत्र और निश्चित सफलता';

  @override
  String get onboardingSubtitle3 =>
      'अपनी प्रगति ट्रैक करें, टेस्ट पास करें और मान्यता प्राप्त प्रमाणपत्र प्राप्त करें।';

  @override
  String get onboardingNext => 'आगे बढ़ें';

  @override
  String get onboardingStart => 'शुरू करें';

  @override
  String get splashAppName => 'Education Lab';

  @override
  String get splashTagline => 'स्मार्ट लर्निंग प्लेटफॉर्म';

  @override
  String get loginTagline => 'स्मार्ट लर्निंग प्लेटफॉर्म में आपका स्वागत है';

  @override
  String get loginAppName => 'EduLab';

  @override
  String get loginTabLogin => 'लॉग इन';

  @override
  String get loginTabRegister => 'नया खाता';

  @override
  String get loginEmailLabel => 'ईमेल';

  @override
  String get loginEmailHint => 'example@email.com';

  @override
  String get loginPasswordLabel => 'पासवर्ड';

  @override
  String get loginPasswordHint => '••••••';

  @override
  String get loginForgotPassword => 'पासवर्ड भूल गए?';

  @override
  String get loginSubmit => 'लॉग इन करें';

  @override
  String get loginSubmitLoading => 'लॉग इन हो रहा है';

  @override
  String get loginGuest => 'अतिथि के रूप में जुड़ें';

  @override
  String get loginOr => 'या';

  @override
  String get loginEmailRequired => 'ईमेल आवश्यक है';

  @override
  String get loginEmailInvalid => 'मान्य ईमेल दर्ज करें';

  @override
  String get loginPasswordRequired => 'पासवर्ड आवश्यक है';

  @override
  String get registerStepEmail => 'ईमेल';

  @override
  String get registerStepCode => 'कोड';

  @override
  String get registerStepData => 'विवरण';

  @override
  String get registerSendCodeInfo => 'हम इस ईमेल पर एक सक्रियण कोड भेजेंगे';

  @override
  String get registerSendCode => 'सक्रियण कोड भेजें';

  @override
  String get registerVerifying => 'सत्यापन जारी';

  @override
  String get registerCodeSentTo => 'कोड भेजा गया:';

  @override
  String get registerResendCode => 'कोड पुनः भेजें';

  @override
  String get registerBack => 'वापस';

  @override
  String get registerVerifyCode => 'कोड सत्यापित करें';

  @override
  String get registerCodeIncomplete => 'पूरा 6-अंकों का कोड दर्ज करें';

  @override
  String get registerFullNameLabel => 'पूरा नाम';

  @override
  String get registerFullNameHint => 'आपका पूरा नाम';

  @override
  String get registerPasswordHint =>
      'कम से कम 8 अक्षर, एक बड़ा अक्षर और एक संख्या';

  @override
  String get registerConfirmLabel => 'पासवर्ड की पुष्टि करें';

  @override
  String get registerConfirmHint => 'पासवर्ड पुनः दर्ज करें';

  @override
  String get registerSubmit => 'खाता बनाएं';

  @override
  String get registerSubmitLoading => 'खाता बनाया जा रहा है';

  @override
  String get registerSuccess => 'खाता सफलतापूर्वक बनाया गया';

  @override
  String get registerNameRequired => 'पूरा नाम आवश्यक है';

  @override
  String get registerNameMinLength =>
      'पूरा नाम कम से कम 6 अक्षरों का होना चाहिए';

  @override
  String get registerPasswordMinLength =>
      'पासवर्ड कम से कम 8 अक्षरों का होना चाहिए';

  @override
  String get registerPasswordUppercase =>
      'पासवर्ड में कम से कम एक बड़ा अक्षर होना चाहिए';

  @override
  String get registerPasswordNumber =>
      'पासवर्ड में कम से कम एक संख्या होनी चाहिए';

  @override
  String get registerConfirmRequired => 'पासवर्ड की पुष्टि आवश्यक है';

  @override
  String get registerConfirmMismatch => 'पासवर्ड मेल नहीं खाते';

  @override
  String get networkError => 'कनेक्शन त्रुटि, कृपया पुनः प्रयास करें';

  @override
  String homeGreeting(String name) {
    return 'नमस्ते, $name!';
  }

  @override
  String get homeSubtitle => 'आज आप क्या सीखना चाहते हैं?';

  @override
  String get homeSearchHint => 'कोर्स या कौशल खोजें...';

  @override
  String get homeSectionContinue => 'सीखना जारी रखें';

  @override
  String get homeSectionRecommended => 'आपके लिए अनुशंसित';

  @override
  String get homeSectionPopular => 'सबसे लोकप्रिय';

  @override
  String get homeSectionTopRated => 'उच्चतम रेटेड';

  @override
  String get homeSectionByCategory => 'श्रेणी के अनुसार';

  @override
  String get homeHeroTitle => 'ऑफ़र देखें';

  @override
  String get homeHeroSubtitle => 'प्रीमियम पाठ्यक्रमों पर 70% तक की छूट';

  @override
  String get homeHeroButton => 'अभी जानें';

  @override
  String get homeViewAll => 'सभी देखें';

  @override
  String get homeProgressLabel => 'पूर्ण';

  @override
  String get exploreTitle => 'कोर्स खोजें';

  @override
  String get exploreSearchHint => 'कोर्स, कौशल या शिक्षक खोजें...';

  @override
  String get exploreAllCategories => 'सभी श्रेणियां';

  @override
  String get exploreFilter => 'फ़िल्टर';

  @override
  String get exploreSort => 'क्रमबद्ध करें';

  @override
  String get exploreNoResults => 'कोई परिणाम नहीं मिला';

  @override
  String get exploreNoResultsHint => 'अलग कीवर्ड आज़माएं या फ़िल्टर बदलें';

  @override
  String exploreCoursesCount(int count) {
    return '$count कोर्स';
  }

  @override
  String get exploreFilterTitle => 'फ़िल्टर परिणाम';

  @override
  String get exploreFilterApply => 'फ़िल्टर लागू करें';

  @override
  String get exploreFilterReset => 'रीसेट करें';

  @override
  String get exploreFilterPrice => 'मूल्य';

  @override
  String get exploreFilterLevel => 'स्तर';

  @override
  String get exploreFilterRating => 'रेटिंग';

  @override
  String get exploreFilterDuration => 'अवधि';

  @override
  String get exploreSortTitle => 'क्रमबद्ध करें';

  @override
  String get exploreSortRelevance => 'सबसे प्रासंगिक';

  @override
  String get exploreSortNewest => 'नवीनतम';

  @override
  String get exploreSortPopular => 'सबसे लोकप्रिय';

  @override
  String get exploreSortRating => 'उच्चतम रेटिंग';

  @override
  String get exploreSortPriceLow => 'मूल्य: कम से अधिक';

  @override
  String get exploreSortPriceHigh => 'मूल्य: अधिक से कम';

  @override
  String get explorePriceFree => 'मुफ़्त';

  @override
  String get exploreLevelBeginner => 'शुरुआती';

  @override
  String get exploreLevelIntermediate => 'मध्यम';

  @override
  String get exploreLevelAdvanced => 'उन्नत';

  @override
  String get learningTitle => 'मेरा अध्ययन';

  @override
  String get learningTabInProgress => 'प्रगति पर';

  @override
  String get learningTabCompleted => 'पूर्ण';

  @override
  String get learningTabSaved => 'सहेजे गए';

  @override
  String get learningEmpty => 'अभी कोई कोर्स नहीं है';

  @override
  String get learningEmptyHint => 'कोर्स तलाशना शुरू करें';

  @override
  String get learningExploreButton => 'कोर्स खोजें';

  @override
  String learningProgress(int percent) {
    return '$percent% पूर्ण';
  }

  @override
  String get learningContinue => 'जारी रखें';

  @override
  String get learningViewCertificate => 'प्रमाणपत्र देखें';

  @override
  String get learningReview => 'कोर्स की समीक्षा करें';

  @override
  String get learningLesson => 'पाठ';

  @override
  String get learningLessons => 'पाठ';

  @override
  String get cartTitle => 'कार्ट';

  @override
  String get cartEmpty => 'आपकी कार्ट खाली है';

  @override
  String get cartEmptyHint => 'सीखना शुरू करने के लिए कोर्स जोड़ें';

  @override
  String get cartExploreButton => 'कोर्स खोजें';

  @override
  String get cartPromoPlaceholder => 'प्रोमो कोड';

  @override
  String get cartPromoApply => 'लागू करें';

  @override
  String get cartPromoInvalid => 'अमान्य प्रोमो कोड';

  @override
  String get cartSummary => 'ऑर्डर सारांश';

  @override
  String get cartSubtotal => 'उप-कुल';

  @override
  String get cartDiscount => 'छूट';

  @override
  String get cartTotal => 'कुल';

  @override
  String get cartCheckout => 'चेकआउट';

  @override
  String cartCourses(int count) {
    return '$count कोर्स';
  }

  @override
  String get cartRemove => 'हटाएं';

  @override
  String get cartGuarantee => '30 दिन की पैसे वापसी की गारंटी';

  @override
  String get checkoutTitle => 'चेकआउट';

  @override
  String get checkoutStepPayment => 'भुगतान';

  @override
  String get checkoutStepReview => 'समीक्षा';

  @override
  String get checkoutStepConfirm => 'पुष्टि';

  @override
  String get checkoutOrderSummary => 'ऑर्डर सारांश';

  @override
  String get checkoutTotal => 'कुल';

  @override
  String get checkoutPayNow => 'अभी भुगतान करें';

  @override
  String get checkoutBack => 'वापस';

  @override
  String get checkoutNext => 'आगे';

  @override
  String get checkoutSecureSSL =>
      '256-बिट एसएसएल एन्क्रिप्शन के साथ सुरक्षित भुगतान';

  @override
  String get checkoutSuccessTitle => 'खरीदारी सफल!';

  @override
  String get checkoutSuccessSubtitle => 'अब आप अपने कोर्स तक पहुँच सकते हैं';

  @override
  String get checkoutGoToLearning => 'मेरे कोर्स पर जाएं';

  @override
  String get checkoutPaymentMethod => 'भुगतान विधि';

  @override
  String get checkoutCardNumber => 'कार्ड संख्या';

  @override
  String get checkoutCardName => 'कार्डधारक का नाम';

  @override
  String get checkoutCardExpiry => 'समाप्ति तिथि';

  @override
  String get checkoutCardCVV => 'CVV';

  @override
  String get courseDetailsEnroll => 'अभी नामांकन करें';

  @override
  String get courseDetailsBuyNow => 'अभी खरीदें';

  @override
  String get courseDetailsAddToCart => 'कार्ट में जोड़ें';

  @override
  String get courseDetailsAddedToCart => 'कार्ट में जोड़ा गया';

  @override
  String get courseDetailsAlreadyEnrolled => 'पहले से नामांकित';

  @override
  String get courseDetailsGoToCourse => 'कोर्स पर जाएं';

  @override
  String get courseDetailsFree => 'मुफ़्त';

  @override
  String courseDetailsStudents(String count) {
    return '$count विद्यार्थी';
  }

  @override
  String get courseDetailsRating => 'रेटिंग';

  @override
  String get courseDetailsReviews => 'समीक्षाएं';

  @override
  String get courseDetailsLastUpdated => 'अंतिम अपडेट';

  @override
  String get courseDetailsCurriculum => 'कोर्स सामग्री';

  @override
  String get courseDetailsSection => 'अनुभाग';

  @override
  String get courseDetailsLessons => 'पाठ';

  @override
  String get courseDetailsInstructor => 'शिक्षक';

  @override
  String get courseDetailsStudentsLabel => 'विद्यार्थी';

  @override
  String get courseDetailsCoursesLabel => 'कोर्स';

  @override
  String get courseDetailsReviewsLabel => 'समीक्षाएं';

  @override
  String get courseDetailsReviewsTitle => 'विद्यार्थी समीक्षाएं';

  @override
  String get courseDetailsWhatLearn => 'आप क्या सीखेंगे';

  @override
  String get courseDetailsRequirements => 'आवश्यकताएं';

  @override
  String get courseDetailsDescription => 'कोर्स का विवरण';

  @override
  String get courseDetailsIncludesTitle => 'इस कोर्स में शामिल हैं';

  @override
  String get courseDetailsHoursVideo => 'घंटे का वीडियो';

  @override
  String get courseDetailsArticles => 'लेख';

  @override
  String get courseDetailsMobileAccess => 'मोबाइल और टीवी पर पहुंच';

  @override
  String get courseDetailsCertificate => 'समापन प्रमाणपत्र';

  @override
  String get courseDetailsLifetimeAccess => 'आजीवन पहुंच';

  @override
  String get lessonPlayerNotes => 'मेरे नोट्स';

  @override
  String get lessonPlayerResources => 'संसाधन';

  @override
  String get lessonPlayerDiscussion => 'चर्चा';

  @override
  String get lessonPlayerPrev => 'पिछला';

  @override
  String get lessonPlayerNext => 'अगला';

  @override
  String get lessonPlayerSpeed => 'गति';

  @override
  String get lessonPlayerQuality => 'गुणवत्ता';

  @override
  String get lessonPlayerCompleted => 'पाठ पूर्ण हुआ';

  @override
  String get certificateTitle => 'समापन प्रमाणपत्र';

  @override
  String get certificatePresentedTo => 'को प्रदान किया गया';

  @override
  String get certificateCompletedCourse => 'सफलतापूर्वक पूरा करने के लिए';

  @override
  String get certificateIssuedOn => 'जारी करने की तिथि';

  @override
  String get certificateVerificationId => 'सत्यापन संख्या';

  @override
  String get certificateDownloadPDF => 'PDF डाउनलोड करें';

  @override
  String get certificateDownloadPNG => 'छवि डाउनलोड करें';

  @override
  String get certificateCopyLink => 'लिंक कॉपी करें';

  @override
  String get certificateLinkCopied => 'लिंक कॉपी किया गया';

  @override
  String get profileTitle => 'प्रोफ़ाइल';

  @override
  String get profileEditProfile => 'प्रोफ़ाइल संपादित करें';

  @override
  String get profileCourses => 'मेरे कोर्स';

  @override
  String get profileCertificates => 'प्रमाणपत्र';

  @override
  String get profilePoints => 'अंक';

  @override
  String get profileFollowers => 'फॉलोअर्स';

  @override
  String get profileFollowing => 'फॉलोइंग';

  @override
  String get profileBio => 'बायो';

  @override
  String get profileInstructor => 'शिक्षक';

  @override
  String get profileStudent => 'विद्यार्थी';

  @override
  String get profileLevel => 'स्तर';

  @override
  String get profileJoined => 'शामिल हुए';

  @override
  String get profileShareProfile => 'प्रोफ़ाइल शेयर करें';

  @override
  String get profileMenuLearning => 'मेरे कोर्स';

  @override
  String get profileMenuCertificates => 'मेरे प्रमाणपत्र';

  @override
  String get profileMenuPurchaseHistory => 'खरीदारी का इतिहास';

  @override
  String get profileMenuTeachApplication => 'EduLab पर पढ़ाएं';

  @override
  String get profileMenuAccountSecurity => 'खाता सुरक्षा';

  @override
  String get profileMenuNotifications => 'सूचनाएं';

  @override
  String get profileMenuMessages => 'संदेश';

  @override
  String get profileMenuSettings => 'सेटिंग्स';

  @override
  String get profileMenuSchedule => 'मेरा शेड्यूल';

  @override
  String get profileMenuAssignments => 'असाइनमेंट';

  @override
  String get profileMenuQuiz => 'क्विज़';

  @override
  String get profileMenuLogout => 'लॉग आउट';

  @override
  String get profileLogoutConfirm => 'क्या आप वाकई लॉग आउट करना चाहते हैं?';

  @override
  String get profileLogoutYes => 'हाँ, लॉग आउट करें';

  @override
  String get profileLogoutNo => 'रद्द करें';

  @override
  String get editProfileTitle => 'प्रोफ़ाइल संपादित करें';

  @override
  String get editProfileSave => 'परिवर्तन सहेजें';

  @override
  String get editProfileFullName => 'पूरा नाम';

  @override
  String get editProfileBio => 'बायो';

  @override
  String get editProfileEmail => 'ईमेल';

  @override
  String get editProfilePhone => 'फ़ोन नंबर';

  @override
  String get editProfileWebsite => 'वेबसाइट';

  @override
  String get editProfileSaved => 'परिवर्तन सफलतापूर्वक सहेजे गए';

  @override
  String get accountSecurityTitle => 'खाता सुरक्षा';

  @override
  String get accountSecurityChangePassword => 'पासवर्ड बदलें';

  @override
  String get accountSecurityTwoFactor => 'दो-चरणीय सत्यापन';

  @override
  String get accountSecurityActiveSessions => 'सक्रिय सत्र';

  @override
  String get accountSecurityDeleteAccount => 'खाता हटाएं';

  @override
  String get purchaseHistoryTitle => 'खरीदारी का इतिहास';

  @override
  String get purchaseHistoryEmpty => 'अभी कोई खरीदारी नहीं है';

  @override
  String get purchaseHistoryGuarantee => '30 दिन की पैसे वापसी की गारंटी';

  @override
  String get purchaseHistoryDate => 'लेनदेन की तिथि';

  @override
  String get purchaseHistoryStatus => 'स्थिति';

  @override
  String get purchaseHistoryAmount => 'राशि';

  @override
  String get purchaseHistoryCompleted => 'पूर्ण हुआ';

  @override
  String get purchaseHistoryRefunded => 'वापस किया गया';

  @override
  String get teachApplicationTitle => 'EduLab पर पढ़ाएं';

  @override
  String get teachApplicationSubmit => 'आवेदन जमा करें';

  @override
  String get teachApplicationSent => 'आपका आवेदन सफलतापूर्वक भेजा गया';

  @override
  String get notificationsTitle => 'सूचनाएं';

  @override
  String get notificationsMarkAllRead => 'सभी को पढ़ा हुआ चिह्नित करें';

  @override
  String get notificationsMarkAllReadSnackbar => 'सभी सूचनाएं पढ़ी गईं';

  @override
  String get notificationsEmpty => 'कोई सूचना नहीं है';

  @override
  String get notification1Title => 'याद दिलाना: अपना कोर्स जारी रखें';

  @override
  String get notification1Message => 'शुरुआती फ़्लटर में आपका नया पाठ तैयार है';

  @override
  String get notification1Time => '5 मिनट पहले';

  @override
  String get notification1Action => 'कोर्स जारी रखें';

  @override
  String get notification2Title => 'आपका प्रमाणपत्र तैयार है!';

  @override
  String get notification2Message =>
      'आपने UI/UX डिज़ाइन कोर्स पूरा कर लिया है।';

  @override
  String get notification2Time => '2 घंटे पहले';

  @override
  String get notification2Action => 'प्रमाणपत्र देखें';

  @override
  String get notification3Title => 'आपके लिए विशेष ऑफ़र';

  @override
  String get notification3Message => 'प्रोग्रामिंग कोर्स पर 70% की छूट';

  @override
  String get notification3Time => '1 दिन पहले';

  @override
  String get notification3Action => 'ऑफ़र देखें';

  @override
  String get notification4Title => 'आपके प्रश्न का उत्तर';

  @override
  String get notification4Message => 'शिक्षक ने आपके प्रश्न का उत्तर दिया है';

  @override
  String get notification4Time => '2 दिन पहले';

  @override
  String get notification4Action => 'उत्तर देखें';

  @override
  String get notification5Title => 'कोर्स अपडेट';

  @override
  String get notification5Message => 'पायथन कोर्स में नई सामग्री जोड़ी गई है';

  @override
  String get notification5Time => '3 दिन पहले';

  @override
  String get messagesTitle => 'संदेश';

  @override
  String get settingsTitle => 'सेटिंग्स और प्राथमिकताएं';

  @override
  String get settingsVideoDownload => 'वीडियो और डाउनलोड';

  @override
  String get settingsDownloadQuality => 'डिफ़ॉल्ट डाउनलोड गुणवत्ता';

  @override
  String get settingsWifiOnly => 'केवल वाई-फ़ाई पर डाउनलोड करें';

  @override
  String get settingsNotifications => 'सूचनाएं और अलर्ट';

  @override
  String get settingsCourseNotifications => 'कोर्स और संदेश सूचनाएं';

  @override
  String get settingsPromoNotifications => 'विशेष ऑफ़र और छूट';

  @override
  String get settingsAppearance => 'दिखावट और भाषा';

  @override
  String get settingsDarkMode => 'डार्क मोड';

  @override
  String get settingsDarkModeEnabled => 'सक्रिय (बैटरी बचाता है)';

  @override
  String get settingsDarkModeDisabled => 'निष्क्रिय (लाइट मोड)';

  @override
  String get settingsLanguage => 'ऐप की भाषा';

  @override
  String get settingsStorage => 'स्टोरेज और कैश';

  @override
  String get settingsClearCache => 'कैश साफ़ करें';

  @override
  String get settingsClearCacheSuccess => 'कैश सफलतापूर्वक साफ़ किया गया';

  @override
  String get settingsHelp => 'जानकारी और नीतियां';

  @override
  String get settingsHelpCenter =>
      'सहायता केंद्र और अक्सर पूछे जाने वाले प्रश्न';

  @override
  String get settingsTermsPrivacy => 'उपयोग की शर्तें और गोपनीयता';

  @override
  String get settingsAbout => 'EduLab के बारे में';

  @override
  String get settingsVersion => 'संस्करण v1.0.0';

  @override
  String get quizTitle => 'क्विज़';

  @override
  String get quizNext => 'अगला प्रश्न';

  @override
  String get quizSubmit => 'क्विज़ सबमिट करें';

  @override
  String get quizScore => 'क्विज़ स्कोर';

  @override
  String get quizCorrectAnswers => 'सही उत्तर';

  @override
  String get scheduleTitle => 'मेरा शेड्यूल';

  @override
  String get scheduleEmpty => 'कोई सत्र निर्धारित नहीं है';

  @override
  String get scheduleJoin => 'सत्र में शामिल हों';

  @override
  String get scheduleReminder => 'याद दिलाएं';

  @override
  String get assignmentsTitle => 'असाइनमेंट';

  @override
  String get assignmentsEmpty => 'कोई असाइनमेंट नहीं है';

  @override
  String get assignmentsSubmit => 'असाइनमेंट सबमिट करें';

  @override
  String get assignmentsDue => 'अंतिम तिथि';

  @override
  String get assignmentsSubmitted => 'सबमिट किया गया';

  @override
  String get assignmentsPending => 'लंबित';

  @override
  String get languageArabic => 'अरबी';

  @override
  String get languageEnglish => 'अंग्रेज़ी';

  @override
  String get languageDialogTitle => 'ऐप की भाषा चुनें';

  @override
  String get languageSelect => 'चुनें';

  @override
  String get generalCancel => 'रद्द करें';

  @override
  String get generalConfirm => 'पुष्टि करें';

  @override
  String get generalSave => 'सहेजें';

  @override
  String get generalDelete => 'हटाएं';

  @override
  String get generalEdit => 'संपादित करें';

  @override
  String get generalClose => 'बंद करें';

  @override
  String get generalBack => 'वापस';

  @override
  String get generalDone => 'पूर्ण';

  @override
  String get generalOk => 'ठीक है';

  @override
  String get generalYes => 'हाँ';

  @override
  String get generalNo => 'नहीं';

  @override
  String get generalLoading => 'लोड हो रहा है...';

  @override
  String get generalError => 'त्रुटि उत्पन्न हुई';

  @override
  String get generalRetry => 'पुनः प्रयास करें';

  @override
  String get generalNoInternet => 'कोई इंटरनेट कनेक्शन नहीं है';

  @override
  String get generalFree => 'मुफ़्त';

  @override
  String get generalRating => 'रेटिंग';

  @override
  String get generalStudents => 'विद्यार्थी';

  @override
  String get generalHours => 'घंटे';

  @override
  String get generalMinutes => 'मिनट';

  @override
  String get generalBy => 'द्वारा';

  @override
  String get navHome => 'होम';

  @override
  String get navExplore => 'खोजें';

  @override
  String get navMyCourses => 'मेरे कोर्स';

  @override
  String get navCart => 'कार्ट';

  @override
  String get navAccount => 'खाता';

  @override
  String get homeSubGreeting => 'आज आप क्या सीखना चाहते हैं?';

  @override
  String get homeVisitor => 'अतिथि';

  @override
  String get homePromoTitle => 'ऑफ़र देखें';

  @override
  String get homePromoSubtitle => 'प्रीमियम पाठ्यक्रमों पर 70% तक की छूट';

  @override
  String get homePromoButton => 'अभी जानें';

  @override
  String get homePromoBadge => 'विशेष ऑफ़र';

  @override
  String get homeContinueLearning => 'सीखना जारी रखें';

  @override
  String get homeMyCoursesLink => 'मेरे कोर्स';

  @override
  String get homeLesson => 'पाठ';

  @override
  String homeStudentsCount(String count) {
    return '$count विद्यार्थी';
  }

  @override
  String get homeRecommendedTitle => 'आपके लिए अनुशंसित';

  @override
  String get homeRecommendedSubtitle => 'आपकी रुचियों के आधार पर';

  @override
  String get homeBestsellersTitle => 'बेस्टसेलर';

  @override
  String get homeBestsellersSubtitle => 'शीर्ष रेटेड और लोकप्रिय कोर्स';

  @override
  String get homeNewCoursesTitle => 'नए कोर्स';

  @override
  String get homeNewCoursesSubtitle => 'ताज़ा और अद्यतन सामग्री';

  @override
  String get homePopularTopicsTitle => 'लोकप्रिय विषय';

  @override
  String get homePopularTopicsSubtitle => 'सबसे अधिक मांग वाले कौशल सीखें';

  @override
  String get homeTopInstructorsTitle => 'शीर्ष शिक्षक';

  @override
  String get homeTopInstructorsSubtitle => 'प्रमाणित विशेषज्ञों से सीखें';

  @override
  String get homeExploreCategoriesTitle => 'श्रेणियां देखें';

  @override
  String get homeExploreCategoriesSubtitle => 'अपने लिए सही कोर्स चुनें';

  @override
  String get catAll => 'सभी';

  @override
  String get catWebDev => 'वेब डेवलपमेंट';

  @override
  String get catMobileApps => 'मोबाइल ऐप्स';

  @override
  String get catDataScience => 'डेटा साइंस';

  @override
  String get catUIUX => 'UI/UX डिज़ाइन';

  @override
  String get catBusiness => 'व्यापार और प्रबंधन';

  @override
  String get catAI => 'आर्टिफिशियल इंटेलिजेंस';

  @override
  String get catCyberSecurity => 'साइबर सुरक्षा';

  @override
  String get exploreNoResultsTitle => 'कोई परिणाम नहीं मिला';

  @override
  String get exploreNoResultsSubtitle => 'अलग कीवर्ड आज़माएं या फ़िल्टर बदलें';

  @override
  String get exploreRecentSearches => 'हाल की खोजें';

  @override
  String get exploreTopSearches => 'लोकप्रिय खोजें';

  @override
  String get exploreBrowseCategories => 'श्रेणियां ब्राउज़ करें';

  @override
  String get exploreBrowseCategoriesSubtitle => 'सही कोर्स खोजें';

  @override
  String get exploreBackToAll => 'सभी पर वापस जाएं';

  @override
  String get exploreClearAll => 'सभी साफ़ करें';

  @override
  String get exploreAvailableResults => 'परिणाम उपलब्ध हैं';

  @override
  String get exploreFilterBestseller => 'बेस्टसेलर';

  @override
  String get exploreFilterTopRated => 'शीर्ष रेटेड';

  @override
  String get exploreFilterUnder50 => '\$50 से कम';

  @override
  String get learningHeroTitle => 'अपनी सीखने की यात्रा जारी रखें';

  @override
  String get learningSearchHint => 'मेरे कोर्स खोजें...';

  @override
  String get learningFilterAll => 'सभी';

  @override
  String get learningFilterInProgress => 'प्रगति पर';

  @override
  String get learningFilterCompleted => 'पूर्ण';

  @override
  String get learningFilterDownloaded => 'डाउनलोड किए गए';

  @override
  String get learningEmptyTitle => 'अभी कोई कोर्स नहीं है';

  @override
  String get learningEmptySubtitle => 'कोर्स तलाशना शुरू करें';

  @override
  String get learningEmptySearch => 'आपकी खोज के लिए कोई परिणाम नहीं';

  @override
  String get learningCompleted => 'पूर्ण';

  @override
  String get learningCompletedBadge => 'पूर्ण';

  @override
  String learningLecturesCount(int count) {
    return '$count पाठ';
  }

  @override
  String get cartEmptyTitle => 'आपकी कार्ट खाली है';

  @override
  String get cartEmptySubtitle => 'सीखना शुरू करने के लिए कोर्स जोड़ें';

  @override
  String get cartCouponHint => 'प्रोमो कोड दर्ज करें';

  @override
  String get cartCouponApply => 'लागू करें';

  @override
  String get cartCouponInvalid => 'अमान्य कोड';

  @override
  String get cartCouponApplied => 'कूपन कोड लागू हो गया';

  @override
  String get cartCouponDiscount => 'कूपन छूट';

  @override
  String get cartCouponsTitle => 'कूपन';

  @override
  String get cartOrderSummary => 'ऑर्डर सारांश';

  @override
  String get cartOriginalPrice => 'मूल मूल्य';

  @override
  String get cartPlatformDiscount => 'प्लेटफ़ॉर्म छूट';

  @override
  String get cartFinalTotal => 'अंतिम कुल';

  @override
  String cartItemsCount(int count) {
    return '$count कोर्स';
  }

  @override
  String get cartRemovedSnackbar => 'कोर्स कार्ट से हटा दिया गया';

  @override
  String get cartUndo => 'पूर्ववत करें';

  @override
  String get cartAddButton => 'कार्ट में जोड़ें';

  @override
  String get cartAddedSnackbar => 'कार्ट में जोड़ा गया';

  @override
  String get cartAlreadyInCart => 'पहले से कार्ट में है';

  @override
  String get cartCheckoutButton => 'भुगतान के लिए आगे बढ़ें';

  @override
  String get cartRecommendedTitle => 'आपको यह भी पसंद आ सकता है';

  @override
  String get cartRecommendedSubtitle => 'आपकी कार्ट के आधार पर अनुशंसित';

  @override
  String get checkoutCreditCard => 'क्रेडिट / डेबिट कार्ड';

  @override
  String get checkoutSelectPayment => 'भुगतान विधि चुनें';

  @override
  String get checkoutCardNumberLabel => 'कार्ड संख्या';

  @override
  String get checkoutCardHolderLabel => 'कार्डधारक का नाम';

  @override
  String get checkoutExpiryLabel => 'समाप्ति तिथि';

  @override
  String get checkoutCVVLabel => 'CVV';

  @override
  String get checkoutPersonalInfoTitle => 'व्यक्तिगत जानकारी';

  @override
  String get checkoutFullNameLabel => 'पूरा नाम';

  @override
  String get checkoutFullNameHint => 'आपका पूरा नाम';

  @override
  String get checkoutFullNameRequired => 'पूरा नाम आवश्यक है';

  @override
  String get checkoutPhoneLabel => 'फ़ोन नंबर';

  @override
  String get checkoutPhoneRequired => 'फ़ोन नंबर आवश्यक है';

  @override
  String get checkoutPostalLabel => 'पिन कोड';

  @override
  String get checkoutPostalRequired => 'पिन कोड आवश्यक है';

  @override
  String get checkoutBuyerInfo => 'खरीदार की जानकारी';

  @override
  String get checkoutSaveInfo => 'अगली बार के लिए जानकारी सहेजें';

  @override
  String get checkoutMoneyBackGuarantee => '30 दिन की पैसे वापसी की गारंटी';

  @override
  String get checkoutContinueToPayment => 'भुगतान जारी रखें';

  @override
  String get checkoutContinueToReview => 'समीक्षा जारी रखें';

  @override
  String get checkoutReviewConfirm => 'समीक्षा और पुष्टि करें';

  @override
  String get checkoutStartLearning => 'सीखना शुरू करें';

  @override
  String get checkoutBackHome => 'होम पर वापस जाएं';

  @override
  String get courseDetailsTitle => 'कोर्स का विवरण';

  @override
  String get courseDetailsShare => 'शेयर करें';

  @override
  String get courseDetailsWhatYouWillLearn => 'आप क्या सीखेंगे';

  @override
  String get courseDetailsLanguage => 'भाषा';

  @override
  String get courseDetailsCreatedBy => 'निर्माता';

  @override
  String get courseDetailsPreviewLesson => 'पाठ का पूर्वावलोकन';

  @override
  String get courseDetailsHoursOnDemand => 'घंटे का ऑन-डिमांड वीडियो';

  @override
  String get courseDetailsFullLifetimeAccess => 'पूर्ण आजीवन पहुंच';

  @override
  String get courseDetailsCertifiedCertificate => 'प्रमाणित समापन प्रमाणपत्र';

  @override
  String get courseDetailsComprehensiveContent => 'व्यापक सामग्री';

  @override
  String get certTitle => 'समापन प्रमाणपत्र';

  @override
  String get certStudentNameLabel => 'विद्यार्थी';

  @override
  String get certCourseLabel => 'कोर्स';

  @override
  String get certInstructorLabel => 'शिक्षक';

  @override
  String get certIssueDateLabel => 'जारी करने की तिथि';

  @override
  String get certCodeLabel => 'प्रमाणपत्र संख्या';

  @override
  String get certVerifiedBadge => 'सत्यापित';

  @override
  String get certDownloadPDF => 'PDF डाउनलोड करें';

  @override
  String get certDownloadPNG => 'छवि डाउनलोड करें';

  @override
  String get certCopyVerifyLink => 'सत्यापन लिंक कॉपी करें';

  @override
  String get certShare => 'प्रमाणपत्र शेयर करें';

  @override
  String get playerTabLessons => 'पाठ';

  @override
  String get playerTabOverview => 'अवलोकन';

  @override
  String get playerTabNotes => 'मेरे नोट्स';

  @override
  String get playerTabQnA => 'प्रश्न और उत्तर';

  @override
  String get playerNextLesson => 'अगला पाठ';

  @override
  String get profileWelcome => 'स्वागत है';

  @override
  String get profileLoginPrompt => 'अपनी प्रोफ़ाइल देखने के लिए लॉग इन करें';

  @override
  String get profileLoginOrRegister => 'लॉग इन / खाता बनाएं';

  @override
  String get profileVerifiedStudent => 'सत्यापित विद्यार्थी';

  @override
  String get profileLogout => 'लॉग आउट';

  @override
  String get profileCancel => 'रद्द करें';

  @override
  String get profileLogoutConfirmTitle => 'लॉग आउट';

  @override
  String get profileLogoutConfirmMessage =>
      'क्या आप वाकई लॉग आउट करना चाहते हैं?';

  @override
  String get profileAccountSettings => 'खाता सेटिंग्स';

  @override
  String get profileEditProfileSubtitle => 'व्यक्तिगत जानकारी संपादित करें';

  @override
  String get profileSecurity => 'खाता सुरक्षा';

  @override
  String get profileSecuritySubtitle => 'पासवर्ड और सत्यापन';

  @override
  String get profilePurchaseHistory => 'खरीदारी का इतिहास';

  @override
  String get profilePurchaseHistorySubtitle => 'लेनदेन का इतिहास देखें';

  @override
  String get profileCertificatesSubtitle => 'आपके अर्जित प्रमाणपत्र';

  @override
  String get profileTeach => 'EduLab पर पढ़ाएं';

  @override
  String get profileTeachSubtitle => 'अपना ज्ञान साझा करें';

  @override
  String get profilePreferences => 'प्राथमिकताएं';

  @override
  String get profilePreferencesSubtitle => 'सेटिंग्स और दिखावट';

  @override
  String get profileNotifications => 'सूचनाएं';

  @override
  String get profileNotificationsSubtitle => 'सूचनाएं प्रबंधित करें';

  @override
  String get profileHelpSupport => 'सहायता और समर्थन';

  @override
  String get profileTerms => 'उपयोग की शर्तें';

  @override
  String get profilePrivacy => 'गोपनीयता नीति';

  @override
  String get profileAboutEduLab => 'EduLab के बारे में';

  @override
  String get profileWishlist => 'इच्छा सूची';

  @override
  String get securityTitle => 'खाता सुरक्षा';

  @override
  String get teachTitle => 'EduLab पर पढ़ाएं';

  @override
  String get notificationsTabAll => 'सभी';

  @override
  String get notificationsTabCourses => 'कोर्स';

  @override
  String get notificationsTabPromos => 'ऑफ़र';

  @override
  String get notificationsEmptyTitle => 'कोई सूचना नहीं है';

  @override
  String get notificationsUnread => 'अपठित';

  @override
  String get wishlistTitle => 'इच्छा सूची';

  @override
  String get wishlistEmptyTitle => 'आपकी इच्छा सूची खाली है';

  @override
  String get wishlistEmptySubtitle => 'अपनी पसंद के कोर्स सहेजें';

  @override
  String get wishlistAddToCart => 'कार्ट में जोड़ें';

  @override
  String get wishlistRemovedSnackbar => 'इच्छा सूची से हटा दिया गया';

  @override
  String get homeDefaultUser => 'विद्यार्थी';

  @override
  String get learningOf => 'का';

  @override
  String get cartInCartBadge => 'कार्ट में';

  @override
  String get homePromo1Badge => 'बड़ी छूट • सीमित समय';

  @override
  String get homePromo1Title => 'सर्वोत्तम कीमतों पर सीखना शुरू करें';

  @override
  String get homePromo1Subtitle =>
      'प्रोग्रामिंग, डिज़ाइन और व्यावसायिक पाठ्यक्रमों पर 65% तक की छूट।';

  @override
  String get homePromo1Button => 'ऑफ़र देखें';

  @override
  String get homePromo2Badge => 'प्रमाणित करियर ट्रैक';

  @override
  String get homePromo2Title => 'अपने सपनों के करियर के लिए तैयार हों';

  @override
  String get homePromo2Subtitle =>
      'व्यावहारिक परियोजनाओं और प्रमाणपत्रों के साथ शुरुआती से विशेषज्ञ पाठ्यक्रम।';

  @override
  String get homePromo2Button => 'ट्रैक देखें';

  @override
  String get homePromo3Badge => 'शीर्ष प्रशिक्षक और विशेषज्ञ';

  @override
  String get homePromo3Title => 'उद्योग के विशेषज्ञों से सीधे सीखें';

  @override
  String get homePromo3Subtitle =>
      'आधुनिक तकनीकों के साथ आगे रहने के लिए हमेशा अपडेटेड सामग्री।';

  @override
  String get homePromo3Button => 'अभी शुरू करें';

  @override
  String get homePromoInstructorBadge => 'EduLab पर सिखाएं • ज्ञान साझा करें';

  @override
  String get homePromoInstructorTitle => 'आज ही शिक्षक बनें';

  @override
  String get homePromoInstructorSubtitle =>
      'दुनिया भर के छात्रों को प्रेरित करें, कोर्स बनाएं और अपनी पसंदीदा चीज़ सिखाकर कमाई करें।';

  @override
  String get homePromoInstructorButton => 'अभी आवेदन करें';

  @override
  String get homeSearchFilter => 'फ़िल्टर';

  @override
  String get securitySectionChangePassword => 'पासवर्ड बदलें';

  @override
  String get securityCurrentPasswordLabel => 'वर्तमान पासवर्ड *';

  @override
  String get securityCurrentPasswordError => 'वर्तमान पासवर्ड दर्ज करें';

  @override
  String get securityNewPasswordLabel => 'नया पासवर्ड *';

  @override
  String get securityNewPasswordError => 'कम से कम 8 अक्षर होने चाहिए';

  @override
  String get securityConfirmPasswordLabel => 'नए पासवर्ड की पुष्टि करें *';

  @override
  String get securityConfirmPasswordError => 'पासवर्ड मेल नहीं खाते';

  @override
  String get securityUpdatePasswordBtn => 'पासवर्ड अपडेट करें';

  @override
  String get securityPasswordUpdatedSuccess =>
      'पासवर्ड सफलतापूर्वक बदल दिया गया!';

  @override
  String get securitySection2FA => 'दो-चरणीय प्रमाणीकरण (2FA)';

  @override
  String get security2FATitle => 'दो-चरणीय प्रमाणीकरण';

  @override
  String get security2FAEnabledDesc =>
      'सक्रिय - कोड द्वारा आपके खाते को सुरक्षित करता है';

  @override
  String get security2FADisabledDesc =>
      'निष्क्रिय (सक्रिय करने की सलाह दी जाती है)';

  @override
  String get security2FASetupTitle => 'दो-चरणीय प्रमाणीकरण सक्रिय करें';

  @override
  String get security2FASetupContent =>
      'हर नए लॉगिन पर आपके पंजीकृत ईमेल पर 6 अंकों का सत्यापन कोड भेजा जाएगा।';

  @override
  String get security2FAEnableNow => 'अभी सक्रिय करें';

  @override
  String get security2FAEnabledSuccess =>
      'दो-चरणीय प्रमाणीकरण सफलतापूर्वक सक्रिय हुआ!';

  @override
  String get security2FADisabledSuccess =>
      'दो-चरणीय प्रमाणीकरण निष्क्रिय किया गया';

  @override
  String get securitySectionSessions => 'सक्रिय सत्र और उपकरण';

  @override
  String get securityLogoutAllDevices => 'सभी उपकरणों से लॉग आउट करें';

  @override
  String get securityThisDevice => 'यह उपकरण';

  @override
  String get securitySessionRevokedSuccess =>
      'सत्र समाप्त हुआ और उपकरण से लॉग आउट कर दिया गया।';

  @override
  String get securityAllSessionsRevokedSuccess =>
      'अन्य सभी उपकरणों से सफलतापूर्वक लॉग आउट कर दिया गया।';

  @override
  String get purchaseHistoryInvoiceCertified => 'प्रमाणित ई-चालान';

  @override
  String get purchaseHistoryInvoiceNumber => 'चालान संख्या';

  @override
  String get purchaseHistoryCourse => 'पाठ्यक्रम';

  @override
  String get purchaseHistoryPaymentMethod => 'भुगतान विधि';

  @override
  String get purchaseHistoryTotalAmount => 'कुल राशि:';

  @override
  String get purchaseHistoryClose => 'बंद करें';

  @override
  String get purchaseHistoryDownloadPdf => 'PDF डाउनलोड करें';

  @override
  String get purchaseHistoryPdfDownloaded =>
      'चालान PDF सफलतापूर्वक डाउनलोड हुआ';

  @override
  String get purchaseHistoryRefundRequestTitle => 'धनवापसी का अनुरोध करें';

  @override
  String get purchaseHistoryRefundPolicy =>
      'EduLab की 30-दिन मनी-बैक गारंटी के अनुसार, आप पूर्ण धनवापसी प्राप्त कर सकते हैं।';

  @override
  String get purchaseHistoryRefundReasonHint => 'धनवापसी का कारण (वैकल्पिक)...';

  @override
  String get purchaseHistoryConfirmRefund => 'धनवापसी की पुष्टि करें';

  @override
  String get purchaseHistoryRefundSubmitted =>
      'धनवापसी अनुरोध सफलतापूर्वक जमा किया गया (3-5 कार्य दिवस)।';

  @override
  String get purchaseHistoryInstructor => 'प्रशिक्षक';

  @override
  String get purchaseHistoryRequestRefundBtn => 'रिफंड मांगें';

  @override
  String get purchaseHistoryInvoiceBtn => 'चालान';

  @override
  String get purchaseHistoryStatusCompleted => 'पूर्ण हुआ';

  @override
  String get purchaseHistoryStatusRefunded => 'वापस किया गया';

  @override
  String get purchaseHistoryStatusProcessingRefund => 'रिफंड प्रक्रिया में है';

  @override
  String get editProfileSectionBasicInfo => 'मूलभूत जानकारी';

  @override
  String get editProfileFullNameLabel => 'पूरा नाम *';

  @override
  String get editProfileFullNameHint => 'अपना पूरा नाम दर्ज करें';

  @override
  String get editProfileFullNameError => 'कृपया पूरा नाम दर्ज करें';

  @override
  String get editProfileHeadlineLabel => 'पेशेवर शीर्षक';

  @override
  String get editProfileHeadlineHint => 'उदा. सीनियर फ्लटर डेवलपर';

  @override
  String get editProfileLocationLabel => 'शहर / देश';

  @override
  String get editProfileLocationHint => 'नई दिल्ली, भारत';

  @override
  String get editProfilePhoneLabel => 'मोबाइल फोन नंबर';

  @override
  String get editProfileBioLabel => 'मेरे बारे में (Bio)';

  @override
  String get editProfileBioHint =>
      'अपनी रुचियों और अनुभव का संक्षिप्त विवरण लिखें...';

  @override
  String get editProfileSectionLinks => 'लिंक और पेशेवर नेटवर्क';

  @override
  String get editProfileWebsiteLabel => 'व्यक्तिगत वेबसाइट';

  @override
  String get editProfileSectionEmail => 'पंजीकृत ईमेल';

  @override
  String get editProfileEmailDesc =>
      'लॉगिन और प्रमाणपत्र प्राप्त करने के लिए खाते से लिंक है';

  @override
  String get editProfileEmailVerified => 'सत्यापित';

  @override
  String get editProfileSaveChangesBtn => 'जानकारी सहेजें और अपडेट करें';

  @override
  String get editProfileSavedSuccess => 'प्रोफ़ाइल सफलतापूर्वक अपडेट की गई!';

  @override
  String get editProfileChangeAvatarTitle => 'प्रोफ़ाइल फ़ोटो बदलें';

  @override
  String get editProfileTakePhoto => 'कैमरे से फ़ोटो लें';

  @override
  String get editProfileChooseGallery => 'गैलरी से चुनें';

  @override
  String get editProfilePhotoUpdatedSuccess =>
      'प्रोफ़ाइल फ़ोटो सफलतापूर्वक अपडेट हुई';

  @override
  String get teachJoinInstructorTitle => 'प्रशिक्षक के रूप में जुड़ें';

  @override
  String get teachJoinInstructorSubtitle =>
      'अपने पाठ्यक्रम प्रकाशित करें और हजारों छात्रों के साथ अपना ज्ञान साझा करें।';

  @override
  String get teachStep1Title => 'व्यक्तिगत जानकारी';

  @override
  String get teachStep2Title => 'अनुभव और कौशल';

  @override
  String get teachStep3Title => 'आवेदन की पुष्टि';

  @override
  String get teachStep1Header => '1. व्यक्तिगत और पेशेवर जानकारी';

  @override
  String get teachFullNameArabicLabel => 'पूरा नाम *';

  @override
  String get teachFullNameArabicHint => 'उदा. राहुल शर्मा';

  @override
  String get teachHeadlineLabel => 'पेशेवर शीर्षक और विशेषज्ञता *';

  @override
  String get teachHeadlineHint =>
      'उदा. सीनियर सॉफ्टवेयर आर्किटेक्ट और फ्लटर ट्रेनर';

  @override
  String get teachPhoneLabel => 'संपर्क फोन नंबर *';

  @override
  String get teachCountryLabel => 'निवास का देश *';

  @override
  String get teachBioLabel => 'परिचय और पूर्व अनुभव *';

  @override
  String get teachBioHint =>
      'अपने करियर और पिछली परियोजनाओं का संक्षिप्त विवरण लिखें...';

  @override
  String get teachNextStepSkills => 'आगे बढ़ें: अनुभव और कौशल';

  @override
  String get teachStep2Header => '2. पाठ्यक्रम सामग्री और कौशल';

  @override
  String get teachTopicLabel => 'प्रस्तावित पाठ्यक्रम का विषय *';

  @override
  String get teachTopicHint => 'उदा. शुरुआत से फ्लटर ऐप डेवलपमेंट';

  @override
  String get teachYearsExperienceLabel => 'क्षेत्र में अनुभव के वर्ष *';

  @override
  String get teachVideoLinkLabel =>
      'नमूना शिक्षण वीडियो लिंक (YouTube/Drive/Loom) *';

  @override
  String get teachTargetAudienceLabel => 'पाठ्यक्रम के लक्षित छात्र *';

  @override
  String get teachAudienceBeginners => 'बिल्कुल नए शिक्षार्थी';

  @override
  String get teachAudienceIntermediate => 'शुरुआती और मध्यम स्तर';

  @override
  String get teachAudienceAdvanced => 'उन्नत और पेशेवर';

  @override
  String get teachAudienceAll => 'सभी स्तर';

  @override
  String get teachSkillsCoveredLabel => 'पाठ्यक्रम में शामिल कौशल और तकनीकें *';

  @override
  String get teachAddSkillHint => 'कौशल जोड़ें (उदा. GraphQL)...';

  @override
  String get teachAddSkillBtn => 'जोड़ें';

  @override
  String get teachNextStepConfirm => 'आगे बढ़ें: आवेदन की पुष्टि करें';

  @override
  String get teachStep3Header => '3. भुगतान विवरण और नियम';

  @override
  String get teachPayoutMethodLabel => 'कमाई प्राप्त करने की विधि *';

  @override
  String get teachPayoutMethodBank => 'सीधा बैंक ट्रांसफर (IBAN)';

  @override
  String get teachPayoutMethodPaypal => 'सत्यापित PayPal खाता';

  @override
  String get teachPayoutMethodPayoneer => 'Payoneer कार्ड';

  @override
  String get teachIbanDetailsLabel => 'खाता विवरण / IBAN *';

  @override
  String get teachApplicationSummary => 'आवेदन सारांश:';

  @override
  String get teachApplicantName => 'आवेदक';

  @override
  String get teachApplicantHeadline => 'विशेषज्ञता';

  @override
  String get teachApplicantTopic => 'पाठ्यक्रम का विषय';

  @override
  String get teachApplicantSkillsCount => 'जोड़े गए कौशलों की संख्या';

  @override
  String get teachSkillsUnit => 'कौशल';

  @override
  String get teachAgreeTermsLabel =>
      'मैं EduLab की प्रशिक्षक शर्तों और बौद्धिक संपदा समझौते से सहमत हूं।';

  @override
  String get teachSubmitApplicationBtn => 'Submit Instructor Application';

  @override
  String get teachPrevStepBtn => 'पिछला';

  @override
  String get teachWhyEduLabTitle => 'EduLab पर क्यों पढ़ाएं?';

  @override
  String get teachProp1Title => 'उचित और आकर्षक आय';

  @override
  String get teachProp1Desc =>
      'बिना किसी छिपे शुल्क के अपने पाठ्यक्रम की बिक्री से 80% तक आय प्राप्त करें।';

  @override
  String get teachProp2Title => 'हजारों छात्रों तक पहुंच';

  @override
  String get teachProp2Desc =>
      'एक बड़े और सक्रिय शिक्षण समुदाय में अपने पाठ्यक्रम का प्रचार करें।';

  @override
  String get teachProp3Title => 'पूर्ण तकनीकी और उत्पादन सहायता';

  @override
  String get teachProp3Desc =>
      'हमारी टीम ऑडियो, वीडियो गुणवत्ता और पाठ्यक्रम डिजाइन को बेहतर बनाने में मदद करती है।';

  @override
  String get teachSuccessDialogTitle => 'आवेदन सफलतापूर्वक प्राप्त हुआ!';

  @override
  String get teachSuccessDialogDesc =>
      'EduLab प्रशिक्षकों में शामिल होने के लिए धन्यवाद। हमारी टीम 48 घंटों के भीतर समीक्षा कर आपसे संपर्क करेगी।';

  @override
  String get teachSuccessDialogOk => 'ठीक है';

  @override
  String get teachAddOneSkillError => 'कृपया कम से कम एक कौशल जोड़ें';

  @override
  String get teachAgreeTermsError => 'कृपया प्रशिक्षक की शर्तों से सहमत हों';

  @override
  String get commonCancel => 'रद्द करें';

  @override
  String get commonClose => 'बंद करें';

  @override
  String get myCertificatesBannerTitle => 'मान्यता प्राप्त प्रमाणपत्र';

  @override
  String get myCertificatesBannerSubtitle =>
      'सभी प्रमाणपत्र EduLab से एक विशिष्ट आईडी के साथ मान्यता प्राप्त और सत्यापित हैं';

  @override
  String get certBadgeVerified100 => '100% मान्यता प्राप्त';

  @override
  String get certCodeCopied => 'प्रमाणपत्र कोड कॉपी किया गया';

  @override
  String get certGrantedTo => 'प्रदान किया गया';

  @override
  String get certViewAndDownload => 'प्रमाणपत्र देखें और डाउनलोड करें';

  @override
  String get certIssuerLabel => 'जारीकर्ता प्राधिकरण';

  @override
  String get certIssuerName => 'EduLab इंटरएक्टिव लर्निंग अकादमी';

  @override
  String get certEmptyTitle => 'अभी तक कोई प्रमाणपत्र अर्जित नहीं किया गया';

  @override
  String get certEmptyDesc =>
      'किसी भी नामांकित पाठ्यक्रम को 100% पूरा करें और आधिकारिक सत्यापन आईडी के साथ मान्यता प्राप्त प्रमाणपत्र प्राप्त करें।';

  @override
  String get certEmptyAction => 'मेरे पाठ्यक्रम जारी रखें';

  @override
  String get certDetailsTitle => 'प्रमाणपत्र विवरण और जानकारी';

  @override
  String get certCopyLinkSuccess =>
      'सीधा सत्यापन लिंक क्लिपबोर्ड पर कॉपी किया गया!';

  @override
  String get certShareSuccess =>
      'साझा करने के लिए प्रमाणपत्र विवरण और लिंक कॉपी किया गया!';

  @override
  String get purchaseHistoryTaxInvoiceCertified => 'आधिकारिक प्रमाणित कर चालान';

  @override
  String get purchaseHistoryInvoiceNumberLabel => 'ऑर्डर / चालान संख्या';

  @override
  String get purchaseHistoryCourseNameLabel => 'पाठ्यक्रम का नाम';

  @override
  String get purchaseHistoryPurchaseDateLabel => 'खरीद की तारीख';

  @override
  String get purchaseHistoryPaymentMethodLabel => 'भुगतान विधि';

  @override
  String get purchaseHistoryPaymentMethodValue =>
      'क्रेडिट कार्ड / Stripe (ऑनलाइन)';

  @override
  String get purchaseHistoryOrderStatusLabel => 'ऑर्डर की स्थिति';

  @override
  String get purchaseHistoryStatusPendingReview => 'रिफंड समीक्षा लंबित';

  @override
  String get purchaseHistoryCopyInvoiceBtn => 'चालान संख्या कॉपी करें';

  @override
  String get purchaseHistoryRefundReasonLabel => 'रिफंड अनुरोध का कारण:';

  @override
  String get purchaseHistoryRefundReasonEmptyError =>
      'कृपया अपने रिफंड अनुरोध का कारण दर्ज करें';

  @override
  String get purchaseHistorySubmittingRefund => 'अनुरोध भेजा जा रहा है...';

  @override
  String get purchaseHistoryPaidDate => 'भुगतान की तारीख';

  @override
  String get purchaseHistoryEmptyTitle => 'अभी तक कोई खरीद इतिहास नहीं है';

  @override
  String get purchaseHistoryEmptyDesc =>
      'आपने अभी तक कोई पाठ्यक्रम नहीं खरीदा है।\nपूरा होने पर आपके ऑर्डर और चालान यहां दिखाई देंगे।';

  @override
  String get purchaseHistoryExploreCourses => 'अब पाठ्यक्रम देखें';

  @override
  String get profileMyCourses => 'मेरे पाठ्यक्रम';

  @override
  String get profileMyCoursesSubtitle =>
      'अपने नामांकित पाठ्यक्रमों में प्रगति ट्रैक करें';

  @override
  String get profileWishlistSubtitle => 'आपकी विशलिस्ट में सहेजे गए पाठ्यक्रम';

  @override
  String get navMyLearning => 'मेरी शिक्षा';

  @override
  String get profileLogoutSafeNote =>
      'आपका डेटा, पाठ्यक्रम और प्रमाणपत्र पूरी तरह से सुरक्षित हैं। आप दोबारा लॉग इन करके कभी भी अपनी पढ़ाई जारी रख सकते हैं।';

  @override
  String learningRemainingHours(String hours) {
    return '$hours घंटे शेष';
  }

  @override
  String get learningCompletedFull => 'पूरी तरह पूर्ण';

  @override
  String get learningFilterNotStarted => 'शुरू नहीं हुआ';

  @override
  String get wishlistTopRatedBadge => 'शीर्ष रेटेड';

  @override
  String get wishlistFeaturedBadge => 'विशेष रुप से प्रदर्शित';

  @override
  String wishlistDiscountBadge(String percent) {
    return '$percent% छूट';
  }

  @override
  String get courseFree => 'निःशुल्क';

  @override
  String get badgeBestseller => 'बेस्टसेलर';

  @override
  String get badgeTopRated => 'शीर्ष रेटेड';

  @override
  String get badgeFeatured => 'विशेष रुप से प्रदर्शित';

  @override
  String get badgeRecommended => 'आपके लिए अनुशंसित';

  @override
  String get badgeNew => 'नया';

  @override
  String get courseWord => 'पाठ्यक्रम';

  @override
  String coursesCountText(String count) {
    return '$count+ पाठ्यक्रम';
  }

  @override
  String studentsCountText(String count) {
    return '$count छात्र';
  }

  @override
  String hoursCountText(String count) {
    return '$count घंटे';
  }

  @override
  String get certifiedInstructor => 'प्रमाणित प्रशिक्षक';

  @override
  String get expertCertifiedInstructor => 'विशेषज्ञ और प्रमाणित प्रशिक्षक';

  @override
  String get defaultCourseTitle => 'शैक्षणिक पाठ्यक्रम';

  @override
  String get categoryWord => 'श्रेणी';

  @override
  String get previewCourseVideo => 'पाठ्यक्रम वीडियो पूर्वावलोकन';

  @override
  String get freeSection => 'निःशुल्क अनुभाग';

  @override
  String get freeDemoVideo => 'निःशुल्क डेमो वीडियो';

  @override
  String get articleLecture => 'लेख पाठ';

  @override
  String get articleViewer => 'लेख दर्शक';

  @override
  String get courseVideoPlayer => 'पाठ्यक्रम वीडियो प्लेयर';

  @override
  String get playingNow => 'अभी चल रहा है';

  @override
  String get readingNow => 'अभी पढ़ रहे हैं';

  @override
  String get noLecturesInFreeSection => 'निःशुल्क अनुभाग में कोई पाठ नहीं है';

  @override
  String freeLecturesCount(String count) {
    return '$count निःशुल्क पाठ';
  }

  @override
  String get enrollInFullCourse => 'पूरे पाठ्यक्रम में नामांकन करें';

  @override
  String get articleWord => 'लेख';

  @override
  String get videoWord => 'वीडियो';

  @override
  String get quizWord => 'प्रश्नोत्तरी';

  @override
  String get courseShareCopied => 'पाठ्यक्रम लिंक कॉपी किया गया!';

  @override
  String get addedToCartSnackbar => 'कार्ट में जोड़ा गया';

  @override
  String get viewCartAction => 'कार्ट देखें';

  @override
  String get inCartBadge => 'कार्ट में है ✓';

  @override
  String get addToCartButton => 'कार्ट में जोड़ें';

  @override
  String get wishlistAddedSnackbar => 'पाठ्यक्रम विशलिस्ट में जोड़ा गया';

  @override
  String get wishlistRemovedSuccessSnackbar =>
      'पाठ्यक्रम विशलिस्ट से हटाया गया';

  @override
  String get lessonCompletedAll =>
      'बधाई हो! आपने इस पाठ्यक्रम के सभी पाठ पूरे कर लिए हैं।';

  @override
  String get noteAddedSuccess => 'नोट सफलतापूर्वक जोड़ा गया';

  @override
  String get lessonAlreadyDownloaded =>
      'पाठ पहले से ऑफ़लाइन देखने के लिए सहेजा गया है';

  @override
  String get lessonLinkCopied => 'पाठ का लिंक क्लिपबोर्ड पर कॉपी किया गया';

  @override
  String get contentReportThanks =>
      'आपकी प्रतिक्रिया के लिए धन्यवाद, हमारी टीम इसकी समीक्षा करेगी';

  @override
  String get courseCompletionCertificate => 'पाठ्यक्रम पूर्णता प्रमाणपत्र';

  @override
  String get reportContentIssue => 'सामग्री की समस्या की रिपोर्ट करें';

  @override
  String get loginOrSocial => 'या इसके साथ साइन इन करें';

  @override
  String get loginSuccessSnackbar => 'सफलतापूर्वक साइन इन किया गया';

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
  String get cartClearAllTitle => 'कार्ट की सभी वस्तुएँ हटाएं?';

  @override
  String cartClearAllMessage(String count) {
    return 'क्या आप वाकई अपने शॉपिंग कार्ट से सभी $count पाठ्यक्रम हटाना चाहते हैं?';
  }

  @override
  String get cartClearAllHint =>
      'सभी पाठ्यक्रम आपके कार्ट से हटा दिए जाएंगे। आप उन्हें कभी भी वापस जोड़ सकते हैं।';

  @override
  String cartClearAllConfirm(String count) {
    return 'सभी हटाएं ($count)';
  }

  @override
  String get cartClearedSuccess => 'कार्ट सफलतापूर्वक खाली कर दिया गया';

  @override
  String get cartClearFailed => 'कार्ट खाली करने में विफल';

  @override
  String cartViewWishlistCount(String count) {
    return 'विशलिस्ट की वस्तुएं देखें ($count)';
  }

  @override
  String get cartGoToWishlist => 'विशलिस्ट पर जाएं';

  @override
  String get wishlistClearAllTitle => 'विशलिस्ट की सभी वस्तुएं हटाएं?';

  @override
  String wishlistClearAllMessage(String count) {
    return 'क्या आप वाकई अपनी विशलिस्ट से सभी $count पाठ्यक्रम हटाना चाहते हैं?';
  }

  @override
  String get wishlistClearAllHint =>
      'सभी सहेजे गए पाठ्यक्रम हटा दिए जाएंगे। आप उन्हें एक्सप्लोर से कभी भी वापस जोड़ सकते हैं।';

  @override
  String wishlistClearAllConfirm(String count) {
    return 'सभी हटाएं ($count)';
  }

  @override
  String get wishlistClearedSuccess => 'विशलिस्ट सफलतापूर्वक खाली कर दी गई';

  @override
  String get wishlistClearFailed => 'विशलिस्ट खाली करने में विफल';

  @override
  String get wishlistClearTooltip => 'सभी हटाएं';

  @override
  String wishlistViewCartCount(String count) {
    return 'कार्ट की वस्तुएं देखें ($count)';
  }

  @override
  String get wishlistGoToCart => 'कार्ट पर जाएं';

  @override
  String get checkoutCardNumberInvalid =>
      'कृपया एक मान्य 16 अंकों का कार्ड नंबर दर्ज करें';

  @override
  String get checkoutCardExpiryInvalidFormat =>
      'कृपया कार्ड की समाप्ति की मान्य तिथि दर्ज करें (MM / YY)';

  @override
  String get checkoutCardExpiredDate => 'कार्ड की समाप्ति तिथि अमान्य है';

  @override
  String get checkoutCardCvcInvalid =>
      'कृपया 3 या 4 अंकों का मान्य CVC कोड दर्ज करें';

  @override
  String get checkoutCardHolderNameRequired =>
      'कृपया कार्डधारक का नाम दर्ज करें';

  @override
  String get checkoutCartEmptySnackbar => 'शॉपिंग कार्ट खाली है';

  @override
  String get checkoutPaymentStartFailed => 'भुगतान शुरू करने में विफल';

  @override
  String get checkoutClientSecretMissing =>
      'पेमेंट गेटवे से सुरक्षा कुंजी प्राप्त नहीं हुई';

  @override
  String get checkoutCardVerificationFailed => 'कार्ड सत्यापन विफल रहा';

  @override
  String get checkoutStripeProcessingFailed =>
      'स्ट्राइप भुगतान प्रक्रिया विफल रही';

  @override
  String get checkoutServerConfirmationFailed => 'सर्वर भुगतान पुष्टि विफल रही';

  @override
  String get checkoutEmptyCartTitle => 'आपकी कार्ट खाली है';

  @override
  String get checkoutEmptyCartDesc =>
      'आपने अभी तक अपनी कार्ट में कोई पाठ्यक्रम नहीं जोड़ा है। हमारे पाठ्यक्रम देखें और सीखना शुरू करें!';

  @override
  String get checkoutContinueFreeReview => 'मुफ्त समीक्षा जारी रखें';

  @override
  String get checkoutFreeOrderBadge => '100% मुफ्त ऑर्डर (zsh.00)';

  @override
  String get checkoutFreeOrderNotice =>
      'इस ऑर्डर के लिए किसी भुगतान जानकारी की आवश्यकता नहीं है। आप सीधे नामांकन की पुष्टि कर सकते हैं।';

  @override
  String get checkoutFreeCheckoutTitle => '100% मुफ्त चेकआउट';

  @override
  String get checkoutConfirmFreeEnrollment => 'मुफ्त नामांकन की पुष्टि करें';

  @override
  String get checkoutFreePrice => 'मुफ्त';

  @override
  String get checkoutFreeZero => 'मुफ्त (zsh.00)';

  @override
  String checkoutCoursesCount(String count) {
    return '$count पाठ्यक्रम';
  }

  @override
  String get notificationsClearAllTitle => 'सभी सूचनाएं हटाएं?';

  @override
  String notificationsClearAllMessage(String count) {
    return 'क्या आप वाकई सभी $count सूचनाएं हटाना चाहते हैं? यह क्रिया पूर्ववत नहीं की जा सकती।';
  }

  @override
  String get notificationsClearAllHint =>
      'आपकी सभी सूचनाएं हटा दी जाएंगी और आपका इनबॉक्स खाली हो जाएगा।';

  @override
  String notificationsClearAllConfirm(String count) {
    return 'सभी हटाएं ($count)';
  }

  @override
  String get notificationsClearSuccess => 'सभी सूचनाएं सफलतापूर्वक हटा दी गईं';

  @override
  String get notificationsClearFailed => 'सूचनाएं हटाने में विफल';

  @override
  String get notificationsClearTooltip => 'सभी हटाएं';

  @override
  String get notificationsViewDetails => 'विवरण देखें';

  @override
  String get notificationsEmptyCategoryTitle =>
      'इस श्रेणी में कोई सूचना नहीं है';

  @override
  String get notificationsEmptyCategorySubtitle =>
      'किसी अन्य श्रेणी में जाकर देखें या सभी सूचनाएं ब्राउज़ करें';

  @override
  String get notificationsEmptyAllSubtitle =>
      'हम आपको नवीनतम अपडेट और अलर्ट यहां भेजते रहेंगे';

  @override
  String get notificationsViewAll => 'सभी सूचनाएं देखें';

  @override
  String get learningFilterAndSortTitle => 'फ़िल्टर और क्रमबद्ध करें';

  @override
  String get learningFilterReset => 'रीसेट करें';

  @override
  String get learningSortByTitle => 'क्रमबद्ध करें';

  @override
  String get learningSortRecentActivity => 'हाल ही में एक्सेस किए गए';

  @override
  String get learningSortRecentEnrolled => 'हाल ही में नामांकित';

  @override
  String get learningSortTitleAZ => 'शीर्षक (A-Z)';

  @override
  String get learningSortProgress => 'प्रगति %';

  @override
  String get learningStatusTitle => 'पाठ्यक्रम की स्थिति';

  @override
  String get learningStatusAll => 'सभी पाठ्यक्रम';

  @override
  String get learningStatusInProgress => 'प्रगति पर है';

  @override
  String get learningStatusCompleted => 'पुरा होना।';

  @override
  String get learningStatusNotStarted => 'शुरू नहीं';

  @override
  String get learningFilterApply => 'फ़िल्टर लागू करें';

  @override
  String get learningSearchCoursesHint => 'अपने पाठ्यक्रम खोजें...';

  @override
  String get learningSearchWishlistHint => 'इच्छा सूची खोजें...';

  @override
  String get learningSearchCertificatesHint => 'प्रमाणपत्र खोजें...';

  @override
  String get learningTabMyCourses => 'मेरे पाठ्यक्रम';

  @override
  String get learningTabFavourite => 'मेरा पसंदीदा';

  @override
  String get learningTabCertificates => 'मेरे प्रमाणपत्र';

  @override
  String get learningNoCoursesTitle => 'अभी तक कोई पाठ्यक्रम नहीं';

  @override
  String get learningNoCoursesSubtitle =>
      'हजारों प्रीमियम पाठ्यक्रमों का अन्वेषण करें और आज ही अपनी सीखने की यात्रा शुरू करें';

  @override
  String get learningFilterButton => 'फ़िल्टर';

  @override
  String learningFilterAllCount(String count) {
    return 'सभी ($count)';
  }

  @override
  String get learningStatusNotStartedShort => 'शुरू नहीं';

  @override
  String get learningNoMatchTitle => 'कोई मेल खाता पाठ्यक्रम नहीं';

  @override
  String learningNoMatchSubtitle(String query) {
    return '\"$query\" वाला कोई पाठ्यक्रम नहीं मिला। विभिन्न शब्दों के साथ खोजने का प्रयास करें.';
  }

  @override
  String get learningNoInProgressTitle => 'कोई पाठ्यक्रम प्रगति पर नहीं है';

  @override
  String get learningNoInProgressSubtitle =>
      'यहां अपनी प्रगति को ट्रैक करने के लिए अपने नामांकित पाठ्यक्रमों में पाठ देखना शुरू करें।';

  @override
  String get learningNoCompletedTitle => 'अभी तक कोई पाठ्यक्रम पूरा नहीं हुआ';

  @override
  String get learningNoCompletedSubtitle =>
      'अपनी प्रगति का जश्न मनाने के लिए अपनी पढ़ाई जारी रखें और पूर्ण पाठ्यक्रम यहां देखें।';

  @override
  String get learningNoUnstartedTitle => 'कोई प्रारंभ नहीं किया गया पाठ्यक्रम';

  @override
  String get learningNoUnstartedSubtitle =>
      'बहुत बढ़िया! आपने अपने सभी नामांकित पाठ्यक्रमों में सीखना शुरू कर दिया है।';

  @override
  String get learningNoFilterMatchTitle =>
      'कोई भी पाठ्यक्रम इस फ़िल्टर से मेल नहीं खाता';

  @override
  String get learningNoFilterMatchSubtitle =>
      'अपने पाठ्यक्रम प्रदर्शित करने के लिए फ़िल्टर या सॉर्ट विकल्प बदलें।';

  @override
  String learningViewAllCoursesCount(String count) {
    return 'सभी पाठ्यक्रम देखें ($count)';
  }

  @override
  String learningSavedCoursesCount(String count) {
    return 'सहेजे गए पाठ्यक्रम ($count)';
  }

  @override
  String get learningClearAllSaved => 'सभी साफ करें';

  @override
  String get learningNoCertificatesTitle => 'अभी तक कोई प्रमाणपत्र नहीं';

  @override
  String get learningNoCertificatesSubtitle =>
      'आपकी उपलब्धियों को सत्यापित करने वाले मान्यता प्राप्त प्रमाणपत्र अर्जित करने के लिए अपने पाठ्यक्रम पूरे करें';

  @override
  String get learningGoToCourses => 'मेरे पाठ्यक्रम पर जाएँ';

  @override
  String learningCertIssuedDate(String date) {
    return 'जारी: $date';
  }

  @override
  String get learningCertView => 'देखना';

  @override
  String get learningResumeLesson => 'पाठ फिर से शुरू करें';

  @override
  String learningProgressPercentComplete(String percent) {
    return '$percent% पूर्ण';
  }

  @override
  String learningViewCartCount(String count) {
    return 'कार्ट आइटम देखें ($count)';
  }

  @override
  String get learningGoToCart => 'गाड़ी पर जाना';

  @override
  String get playerLessonMarkedCompleted =>
      'पाठ को पूर्ण के रूप में चिह्नित किया गया ✓';

  @override
  String get playerLessonMarkedIncomplete =>
      'पाठ को अपूर्ण के रूप में चिह्नित किया गया';

  @override
  String get playerCommentPostedSuccess => 'टिप्पणी सफलतापूर्वक पोस्ट की गई';

  @override
  String get playerCommentPostFailed => 'टिप्पणी पोस्ट करने में विफल';

  @override
  String get playerReplyPostedSuccess => 'उत्तर सफलतापूर्वक पोस्ट किया गया';

  @override
  String get playerReplyPostFailed => 'उत्तर पोस्ट करने में विफल';

  @override
  String get playerCourseNotFound => 'पाठ्यक्रम नहीं मिला';

  @override
  String get playerCheckEnrollmentPrompt =>
      'कृपया पहले अपना पाठ्यक्रम नामांकन सत्यापित करें';

  @override
  String get playerReturnToCourses => 'मेरी सीख';

  @override
  String get playerWatchLecture => 'पाठ्यक्रम व्याख्यान';

  @override
  String get playerCertificateTooltip => 'प्रमाणपत्र';

  @override
  String get playerRateCourseTooltip => 'दर पाठ्यक्रम';

  @override
  String get playerReadingArticleBadge => 'लेख पढ़ना • 5 मिनट';

  @override
  String get playerReadFullTextBelow => 'पूरा पाठ नीचे पढ़ें ↓';

  @override
  String get playerTabReviews => 'समीक्षा';

  @override
  String get playerNoSectionsAvailable => 'कोई अनुभाग उपलब्ध नहीं है';

  @override
  String playerLessonsCount(String count) {
    return '$count पाठ';
  }

  @override
  String get playerPlayingBadge => 'खेलना';

  @override
  String get playerArticleBadge => 'लेख';

  @override
  String get playerVideoBadge => 'वीडियो';

  @override
  String get playerFullArticleContent => 'पूर्ण लेख सामग्री';

  @override
  String get playerArticlePlaceholder =>
      'इस पाठन पाठ में आपका स्वागत है।\n\nयह खंड उन मूल अवधारणाओं और व्यावहारिक चरणों को शामिल करता है जिनकी आपको इस पाठ में कौशल में महारत हासिल करने के लिए आवश्यकता है।';

  @override
  String get playerAboutCourseTitle => 'इस कोर्स के बारे में';

  @override
  String get playerShowLess => 'कम दिखाएँ';

  @override
  String get playerReadMore => 'और पढ़ें';

  @override
  String get playerWhatYouWillLearn => 'आप क्या सीखेंगे';

  @override
  String get playerCourseInfoTitle => 'कोर्स विवरण';

  @override
  String get playerTotalDurationTitle => 'कुल अवधि';

  @override
  String get playerTotalLessonsTitle => 'कुल पाठ';

  @override
  String playerLessonsNumber(String count) {
    return '$count पाठ';
  }

  @override
  String get playerLevelTitle => 'स्तर';

  @override
  String get playerAllLevels => 'सभी स्तर';

  @override
  String get playerLanguageTitle => 'भाषा';

  @override
  String get playerLanguageArabic => 'अरबी';

  @override
  String get playerPrerequisitesTitle => 'कोर्स आवश्यकताएं';

  @override
  String get playerCertificateCardTitle => 'कोर्स प्रमाणपत्र';

  @override
  String get playerCourseCompletedSuccess => 'बधाई हो! कोर्स पूरा हुआ';

  @override
  String get playerProgressLabel => 'प्रगति';

  @override
  String get playerViewCertificateBtn => 'प्रमाणपत्र देखें';

  @override
  String get playerCertifiedInstructor => 'प्रमाणित प्रशिक्षक';

  @override
  String playerDiscussionsCount(String count) {
    return '$count प्रश्न और चर्चाएं';
  }

  @override
  String get playerAskQuestionHint => 'अपना प्रश्न या सवाल यहाँ लिखें...';

  @override
  String get playerPostBtn => 'पोस्ट करें';

  @override
  String get playerNoDiscussionsTitle => 'अभी तक कोई चर्चा नहीं है';

  @override
  String get playerNoDiscussionsSubtitle =>
      'प्रश्न पूछने वाले पहले व्यक्ति बनें!';

  @override
  String get playerInstructorBadge => 'प्रशिक्षक';

  @override
  String get playerCancelReply => 'रद्द करें';

  @override
  String get playerReplyAction => 'उत्तर दें';

  @override
  String playerRepliesCount(String count) {
    return '$count उत्तर';
  }

  @override
  String get playerWriteReplyHint => 'अपना उत्तर लिखें...';

  @override
  String get playerSendReplyBtn => 'उत्तर दें';

  @override
  String get playerCourseFeedbackTitle => 'कोर्स रेटिंग और प्रतिक्रिया';

  @override
  String get playerOutOf5 => '5 में से';

  @override
  String playerRatingsFromEnrolledCount(String count) {
    return 'नामांकित छात्रों से $count रेटिंग्स';
  }

  @override
  String get playerKeepLearningToRate => 'रेटिंग देने के लिए सीखते रहें';

  @override
  String get playerRateAfter80Hint =>
      'आप इस कोर्स की सामग्री का 80% पूरा करने के बाद इसकी समीक्षा और रेटिंग कर सकते हैं';

  @override
  String get playerCurrentProgressLabel => 'आपकी प्रगति:';

  @override
  String get playerYourCurrentRating => 'आपकी रेटिंग';

  @override
  String get playerEditRating => 'रेटिंग संपादित करें';

  @override
  String get playerDeleteRatingTooltip => 'रेटिंग हटाएं';

  @override
  String get playerUpdateRatingTitle => 'अपनी रेटिंग अपडेट करें';

  @override
  String get playerRateCourseTitle => 'इस कोर्स को रेट करें';

  @override
  String get playerWriteReviewHint =>
      'सामग्री की गुणवत्ता के बारे में अपनी प्रतिक्रिया और विचार लिखें (वैकल्पिक)...';

  @override
  String get playerRatingSubmitSuccess => 'रेटिंग सफलतापूर्वक सबमिट की गई!';

  @override
  String get playerRatingSubmitFailed => 'रेटिंग सबमिट करने में विफल';

  @override
  String get playerSaveChangesBtn => 'परिवर्तन सहेजें';

  @override
  String get playerSubmitReviewBtn => 'समीक्षा सबमिट करें';

  @override
  String get playerLearnerReviewsTitle => 'शिक्षार्थियों की समीक्षाएं';

  @override
  String playerReviewsCount(String count) {
    return '$count समीक्षाएं';
  }

  @override
  String get playerNoWrittenReviewsTitle => 'अभी तक कोई लिखित समीक्षा नहीं है';

  @override
  String get playerNoWrittenReviewsSubtitle =>
      'अपने विचार साझा करने वाले पहले व्यक्ति बनें!';

  @override
  String get playerRatingLabel5 => 'उत्कृष्ट 🌟 (5/5)';

  @override
  String get playerRatingLabel4 => 'बहुत अच्छा 👍 (4/5)';

  @override
  String get playerRatingLabel3 => 'औसत 👌 (3/5)';

  @override
  String get playerRatingLabel2 => 'सुधार की आवश्यकता है 🤔 (2/5)';

  @override
  String get playerRatingLabel1 => 'खराब 👎 (1/5)';

  @override
  String get playerDeleteRatingDialogTitle => 'रेटिंग हटाएं';

  @override
  String get playerDeleteRatingDialogMessage =>
      'क्या आप वाकई इस कोर्स के लिए अपनी समीक्षा हटाना चाहते हैं?';

  @override
  String get playerDeleteConfirmBtn => 'हटाएं';

  @override
  String get playerRatingDeleteSuccess => 'रेटिंग सफलतापूर्वक हटा दी गई';

  @override
  String get playerPreviousLesson => 'पिछला पाठ';

  @override
  String get playerExitFullscreenTooltip => 'पूर्ण स्क्रीन से बाहर निकलें';

  @override
  String instructorsAvailableCount(String count) {
    return '$count प्रशिक्षक उपलब्ध हैं';
  }

  @override
  String get instructorsNotFound => 'कोई प्रशिक्षक नहीं मिला';

  @override
  String instructorsCoursesCount(String count) {
    return '$count कोर्स';
  }

  @override
  String get instructorsSearchHint => 'प्रशिक्षक का नाम या विशेषता से खोजें...';

  @override
  String get instructorsSortAll => 'सभी';

  @override
  String get instructorsSortTopRated => 'सर्वोच्च रेटेड';

  @override
  String get instructorsSortMostStudents => 'सर्वाधिक छात्र';

  @override
  String get instructorsSortMostCourses => 'सर्वाधिक कोर्स';

  @override
  String get instructorsNotFoundSubtitle =>
      'किसी अन्य नाम से खोजने का प्रयास करें या फ़िल्टर साफ़ करें';

  @override
  String get exploreCompleteCourse => 'व्यापक कोर्स';

  @override
  String get exploreGeneralCategory => 'सामान्य';

  @override
  String courseShareMessage(String title, String url) {
    return 'EduLab पर \"$title\" कोर्स देखें: $url';
  }

  @override
  String get courseDetailsDefaultTitle => 'कोर्स का विवरण';

  @override
  String get courseDetailsTooltipShare => 'शेयर करें';

  @override
  String get courseDetailsTooltipWishlist => 'इच्छा सूची';

  @override
  String get courseDetailsTooltipCart => 'कार्ट';

  @override
  String get courseDetailsNotFound => 'कोर्स नहीं मिला';

  @override
  String get courseDetailsDefaultCategory => 'कोर्स';

  @override
  String courseDetailsTotalRatingsCount(String count) {
    return '($count रेटिंग)';
  }

  @override
  String courseDetailsLecturesCount(String count) {
    return '$count व्याख्यान';
  }

  @override
  String get courseDetailsCertificateBadge => 'प्रमाणपत्र';

  @override
  String get courseDetailsTabOverview => 'अवलोकन';

  @override
  String get courseDetailsTabCurriculum => 'पाठ्यक्रम';

  @override
  String get courseDetailsTabInstructor => 'प्रशिक्षक';

  @override
  String get courseDetailsTabReviews => 'समीक्षाएं';

  @override
  String get courseDetailsFullDescriptionTitle => 'विवरण';

  @override
  String get courseDetailsShowLess => 'कम दिखाएं';

  @override
  String get courseDetailsShowMore => 'और दिखाएं...';

  @override
  String courseDetailsCurriculumSectionsLectures(
    String sections,
    String lectures,
  ) {
    return '$sections अनुभाग • $lectures व्याख्यान';
  }

  @override
  String get courseDetailsCollapseAll => 'सभी संक्षिप्त करें';

  @override
  String get courseDetailsExpandAll => 'सभी विस्तृत करें';

  @override
  String get courseDetailsCurriculumComingSoon =>
      'पाठ्यक्रम का विवरण जल्द ही आ रहा है';

  @override
  String courseDetailsSectionLecturesCount(String count) {
    return '$count व्याख्यान';
  }

  @override
  String get courseDetailsLecturePreviewBtn => 'पूर्वावलोकन';

  @override
  String get courseDetailsDefaultInstructorTitle =>
      'वरिष्ठ प्रशिक्षक और प्रमाणित विशेषज्ञ';

  @override
  String get courseDetailsInstructorRatingLabel => 'रेटिंग';

  @override
  String get courseDetailsInstructorStudentsLabel => 'छात्र';

  @override
  String get courseDetailsInstructorSectionsLabel => 'अनुभाग';

  @override
  String get courseDetailsAboutInstructorTitle => 'प्रशिक्षक के बारे में:';

  @override
  String get courseDetailsDefaultInstructorAbout =>
      'प्रमाणित प्रशिक्षक, जिन्हें दुनिया भर के हजारों छात्रों को व्यावसायिक शिक्षा प्रदान करने का व्यापक अनुभव है।';

  @override
  String courseDetailsStudentRatingsCount(String count) {
    return '$count छात्र रेटिंग';
  }

  @override
  String get courseDetailsNoWrittenReviews =>
      'अभी तक कोई लिखित समीक्षा नहीं है';

  @override
  String get courseDetailsRelatedCourses =>
      'संबंधित कोर्स जो आपको पसंद आ सकते हैं';

  @override
  String courseDetailsDiscountPercent(String percent) {
    return '$percent% छूट';
  }

  @override
  String get courseDetailsResumeCourse => 'कोर्स जारी रखें';

  @override
  String get courseDetailsTryAgain => 'पुनः प्रयास करें';

  @override
  String get courseDetailsEstimatedReading => '📖 अनुमानित पठन समय: 4 मिनट';

  @override
  String get courseDetailsSampleArticleContent =>
      'इस लेख व्याख्यान में आपका स्वागत है।\n\nयह अनुभाग विषय में महारत हासिल करने के लिए प्रमुख सैद्धांतिक अवधारणाओं और व्यावहारिक चरणों को शामिल करता है।\n\n• मुख्य बिंदु:\n1. मूल शब्दावली और वास्तुशिल्प पैटर्न को समझें।\n2. व्यावहारिक अभ्यास और निरंतर अभ्यास।\n3. पूरक नोट्स और असाइनमेंट देखें।\n\nपढ़ने का आनंद लें!';

  @override
  String certDownloadedSuccess(String course, String format) {
    return '\"$course\" का प्रमाणपत्र $format प्रारूप में सफलतापूर्वक डाउनलोड किया गया!';
  }

  @override
  String certVerifiedFullRequirements(String code) {
    return 'सत्यापन आईडी: $code • 100% आवश्यकताएं पूर्ण';
  }

  @override
  String get certCompletionTitle => 'पूर्णता प्रमाणपत्र';

  @override
  String get certCompletionSubtitle => 'कोर्स पूर्णता प्रमाणपत्र';

  @override
  String get certAnnounceStudent =>
      'EducationLab लर्निंग अकादमी एतद्द्वारा प्रमाणित करती है कि:';

  @override
  String get certCompletionRequirementsMet =>
      'ने प्रशिक्षण कोर्स की सभी आवश्यकताओं को सफलतापूर्वक पूरा कर लिया है:';

  @override
  String certIssueDateText(String date) {
    return 'जारी करने की तिथि: $date';
  }

  @override
  String certIdNumberText(String code) {
    return 'प्रमाणपत्र आईडी: $code';
  }

  @override
  String get certPlatformManagement => 'प्लेटफ़ॉर्म प्रबंधन';

  @override
  String get certInstructorRoleTitle => 'कोर्स प्रशिक्षक';

  @override
  String get commonLoading => 'लोड हो रहा है...';

  @override
  String get homeGuestTagline => 'स्मार्ट शिक्षण और कौशल विकास मंच';

  @override
  String get catTagHighestDemand => 'सर्वाधिक मांग';

  @override
  String get catTagMostPopular => 'सबसे लोकप्रिय';

  @override
  String get catTagTrending => 'ट्रेंडिंग';

  @override
  String get catTagFastestGrowing => 'सबसे तेजी से बढ़ता';

  @override
  String get catTagHighDemand => 'उच्च मांग';

  @override
  String get catTagTopRated => 'सर्वोच्च रेटेड';

  @override
  String get catTagEssential => 'अति आवश्यक';

  @override
  String get catTagAdvanced => 'उन्नत स्तर';

  @override
  String get catTagEntrepreneurs => 'उद्यमी';

  @override
  String get catTagSalesGrowth => 'बिक्री वृद्धि';

  @override
  String get catDevTitle => 'प्रोग्रामिंग और सॉफ्टवेयर विकास';

  @override
  String get catDevSubtitle => 'सॉफ्टवेयर इंजीनियरिंग, सिस्टम और एल्गोरिदम';

  @override
  String get catWebTitle => 'वेब विकास';

  @override
  String get catWebSubtitle => 'फ्रंटएंड, बैकएंड और फुलस्टैक वेब';

  @override
  String get catMobileTitle => 'मोबाइल ऐप विकास';

  @override
  String get catMobileSubtitle => 'Flutter, iOS और Android मोबाइल ऐप्स';

  @override
  String get catAiTitle => 'आर्टिफिशियल इंटेलिजेंस';

  @override
  String get catAiSubtitle => 'मशीन लर्निंग, डीप लर्निंग और एआई';

  @override
  String get catDataTitle => 'डेटा साइंस और एनालिटिक्स';

  @override
  String get catDataSubtitle => 'डेटा विश्लेषण, सांख्यिकी और बिग डेटा';

  @override
  String get catDesignTitle => 'UI/UX और उत्पाद डिज़ाइन';

  @override
  String get catDesignSubtitle => 'UI/UX, प्रोटोटाइपिंग और प्रोडक्ट डिज़ाइन';

  @override
  String get catSecurityTitle => 'साइबर सुरक्षा और नेटवर्किंग';

  @override
  String get catSecuritySubtitle => 'साइबर सुरक्षा, एथिकल हैकिंग और नेटवर्क';

  @override
  String get catCloudTitle => 'क्लाउड कंप्यूटिंग और DevOps';

  @override
  String get catCloudSubtitle => 'क्लाउड इन्फ्रास्ट्रक्चर, DevOps और CI/CD';

  @override
  String get catBusinessTitle => 'व्यवसाय और परियोजना प्रबंधन';

  @override
  String get catBusinessSubtitle => 'उद्यमिता, एजाइल और नेतृत्व';

  @override
  String get catMarketingTitle => 'डिजिटल मार्केटिंग';

  @override
  String get catMarketingSubtitle =>
      'डिजिटल मार्केटिंग, SEO और विकास रणनीतियाँ';

  @override
  String get timeJustNow => 'अभी-अभी';

  @override
  String timeMinutesAgo(String count) {
    return '$count मिनट पहले';
  }

  @override
  String timeHoursAgo(String count) {
    return '$count घंटे पहले';
  }

  @override
  String timeDaysAgo(String count) {
    return '$count दिन पहले';
  }

  @override
  String timeWeeksAgo(String count) {
    return '$count सप्ताह पहले';
  }

  @override
  String timeMonthsAgo(String count) {
    return '$count महीने पहले';
  }

  @override
  String wishlistLecturesCount(String count) {
    return '$count व्याख्यान';
  }

  @override
  String get instructorProfileTitle => 'प्रशिक्षक प्रोफ़ाइल';

  @override
  String instructorProfileLinkCopied(String name) {
    return '$name का लिंक क्लिपबोर्ड पर कॉपी हो गया';
  }

  @override
  String get instructorDefaultName => 'प्रशिक्षक';

  @override
  String get instructorProfileBadge => 'प्रशिक्षक';

  @override
  String get instructorProfileTotalStudents => 'कुल छात्र';

  @override
  String get instructorProfileRating => 'प्रशिक्षक रेटिंग';

  @override
  String get instructorProfileCourses => 'कोर्स';

  @override
  String get instructorProfileShare => 'प्रोफ़ाइल साझा करें';

  @override
  String get instructorProfileLinkOpenError =>
      'लिंक नहीं खोला जा सका, क्लिपबोर्ड पर कॉपी कर दिया गया';

  @override
  String get instructorProfileWebsite => 'वेबसाइट';

  @override
  String get instructorProfileAboutMe => 'मेरे बारे में';

  @override
  String get instructorProfileShowLess => 'कम दिखाएं';

  @override
  String get instructorProfileShowMore => 'और दिखाएं';

  @override
  String get instructorProfileExpertise => 'विशेषज्ञता के क्षेत्र';

  @override
  String get instructorProfileSortAll => 'सभी';

  @override
  String get instructorProfileSortTopRated => 'सर्वोच्च रेटेड';

  @override
  String get instructorProfileSortPopular => 'लोकप्रिय';

  @override
  String get instructorProfileSortNewest => 'नवीनतम';

  @override
  String get instructorProfileCoursesTitle => 'प्रशिक्षक के कोर्स';

  @override
  String get instructorProfileNoCoursesFilter =>
      'इस फ़िल्टर के लिए कोई कोर्स नहीं मिला';

  @override
  String instructorProfileLoadMoreCourses(String count) {
    return 'और कोर्स लोड करें ($count शेष)';
  }

  @override
  String get instructorProfileLoadingMoreCourses =>
      'और कोर्स लोड हो रहे हैं...';

  @override
  String instructorProfileAllCoursesLoaded(String count) {
    return 'सभी $count कोर्स लोड हो चुके हैं';
  }

  @override
  String get instructorProfileStudentFeedback => 'छात्रों की प्रतिक्रिया';

  @override
  String instructorProfileReviewsCount(String count) {
    return '$count समीक्षाएं';
  }

  @override
  String instructorProfileBasedOnReviews(String count) {
    return '$count समीक्षाओं पर आधारित';
  }

  @override
  String get instructorProfileRecentReviews => 'हाल की समीक्षाएं';

  @override
  String instructorProfileLoadMoreReviews(String count) {
    return 'और समीक्षाएं लोड करें ($count शेष)';
  }

  @override
  String get instructorProfileLoadingMoreReviews =>
      'और समीक्षाएं लोड हो रही हैं...';

  @override
  String instructorProfileAllReviewsLoaded(String count) {
    return 'सभी $count समीक्षाएं लोड हो चुकी हैं';
  }

  @override
  String get instructorProfileNoReviewsYet =>
      'अभी तक कोई लिखित समीक्षा नहीं है';

  @override
  String get instructorProfileRatingDesc =>
      'रेटिंग प्रशिक्षक के सभी कोर्स में छात्रों की समग्र रेटिंग पर आधारित है';

  @override
  String get instructorProfileLoadError =>
      'प्रशिक्षक का विवरण लोड करने में विफल, कृपया बाद में पुनः प्रयास करें';

  @override
  String get instructorProfileDefaultStudentName => 'छात्र';

  @override
  String get instructorProfileDefaultHeadline =>
      'वरिष्ठ प्रशिक्षक और प्रमाणित विशेषज्ञ';

  @override
  String get instructorProfileDefaultBio =>
      'स्केलेबल सॉफ़्टवेयर सिस्टम और मोबाइल एप्लिकेशन बनाने के व्यापक अनुभव के साथ प्रमाणित सॉफ़्टवेयर इंजीनियर और तकनीकी प्रशिक्षक।\nदुनिया भर में हज़ारों छात्रों और इंजीनियरों को प्रशिक्षित किया है, और क्लीन कोड, क्लीन आर्किटेक्चर व आधुनिक स्केलेबल समाधानों पर केंद्रित पेशेवर सामग्री प्रदान की है।';

  @override
  String get supportNewChat => 'नई चैट';

  @override
  String get supportNoChatsTitle => 'अभी तक कोई सहायता चैट नहीं';

  @override
  String get supportNoChatsDesc =>
      'हमारी सहायता टीम आपकी मदद और सवालों के जवाब देने के लिए 24/7 तैयार है';

  @override
  String get supportStartNewConversation => 'नई बातचीत शुरू करें';

  @override
  String get supportNoMessagesYet => 'अभी तक कोई संदेश नहीं';

  @override
  String get supportRetry => 'पुनः प्रयास करें';

  @override
  String get supportOpenTicket => 'खुला टिकट';

  @override
  String get supportClosedTicket => 'बंद टिकट';

  @override
  String get supportCloseAction => 'बंद करें';

  @override
  String get supportReopenAction => 'फिर से खोलें';

  @override
  String get supportNoMessagesInChat => 'इस चैट में अभी तक कोई संदेश नहीं है';

  @override
  String get supportYou => 'आप';

  @override
  String get supportTeam => 'सहायता टीम';

  @override
  String get supportTypeMessageHint => 'अपना संदेश यहाँ लिखें...';

  @override
  String get supportConversationClosedNotice => 'यह बातचीत वर्तमान में बंद है।';

  @override
  String get supportCloseDialogTitle => 'बातचीत बंद करें?';

  @override
  String get supportCloseDialogDesc =>
      'क्या आप वाकई इस चैट को बंद करना चाहते हैं? बातचीत जारी रखने के लिए आप इसे किसी भी समय फिर से खोल सकते हैं।';

  @override
  String get supportCancel => 'रद्द करें';

  @override
  String get supportYesClose => 'हाँ, बंद करें';

  @override
  String get supportNewChatTitle => 'नई सहायता चैट';

  @override
  String get supportNewChatSubtitle => 'हमारी टीम आपकी सहायता के लिए यहाँ है';

  @override
  String get supportSubjectLabel => 'विषय';

  @override
  String get supportSubjectHint => 'उदा. पाठ्यक्रम पूछताछ, भुगतान समस्या...';

  @override
  String get supportMessageLabel => 'संदेश';

  @override
  String get supportMessageHint =>
      'अपनी समस्या या प्रश्न का विस्तार से वर्णन करें...';

  @override
  String get supportMessageRequired => 'कृपया एक संदेश दर्ज करें';

  @override
  String get supportStartConversationBtn => 'बातचीत शुरू करें';

  @override
  String get supportCreateError =>
      'बातचीत बनाने में विफल, कृपया बाद में पुनः प्रयास करें';

  @override
  String get supportTopicCourse => 'पाठ्यक्रम पूछताछ';

  @override
  String get supportTopicPayment => 'भुगतान समस्या';

  @override
  String get supportTopicCertificates => 'प्रमाणपत्र';

  @override
  String get supportTopicTech => 'तकनीकी समस्या';

  @override
  String get supportTopicGeneral => 'सामान्य पूछताछ';
}

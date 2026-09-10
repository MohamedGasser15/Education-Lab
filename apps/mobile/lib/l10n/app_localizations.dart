import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_id.dart';
import 'app_localizations_it.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_ms.dart';
import 'app_localizations_nl.dart';
import 'app_localizations_pl.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_tr.dart';
import 'app_localizations_uk.dart';
import 'app_localizations_ur.dart';
import 'app_localizations_vi.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('hi'),
    Locale('id'),
    Locale('it'),
    Locale('ja'),
    Locale('ko'),
    Locale('ms'),
    Locale('nl'),
    Locale('pl'),
    Locale('pt'),
    Locale('ru'),
    Locale('tr'),
    Locale('uk'),
    Locale('ur'),
    Locale('vi'),
    Locale('zh'),
  ];

  /// No description provided for @onboardingSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get onboardingSkip;

  /// No description provided for @onboardingTitle1.
  ///
  /// In en, this message translates to:
  /// **'Welcome to EduLab'**
  String get onboardingTitle1;

  /// No description provided for @onboardingSubtitle1.
  ///
  /// In en, this message translates to:
  /// **'Your ideal platform for modern interactive learning and continuous professional growth.'**
  String get onboardingSubtitle1;

  /// No description provided for @onboardingTitle2.
  ///
  /// In en, this message translates to:
  /// **'Learn from Top Instructors'**
  String get onboardingTitle2;

  /// No description provided for @onboardingSubtitle2.
  ///
  /// In en, this message translates to:
  /// **'Thousands of professional courses in programming, design, business, and data science. High quality with a clear roadmap.'**
  String get onboardingSubtitle2;

  /// No description provided for @onboardingTitle3.
  ///
  /// In en, this message translates to:
  /// **'Certificates & Guaranteed Success'**
  String get onboardingTitle3;

  /// No description provided for @onboardingSubtitle3.
  ///
  /// In en, this message translates to:
  /// **'Track your progress, pass the tests, and earn recognized certificates that open your career doors.'**
  String get onboardingSubtitle3;

  /// No description provided for @onboardingNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get onboardingNext;

  /// No description provided for @onboardingStart.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get onboardingStart;

  /// No description provided for @splashAppName.
  ///
  /// In en, this message translates to:
  /// **'Education Lab'**
  String get splashAppName;

  /// No description provided for @splashTagline.
  ///
  /// In en, this message translates to:
  /// **'Smart Learning Platform'**
  String get splashTagline;

  /// No description provided for @loginTagline.
  ///
  /// In en, this message translates to:
  /// **'Welcome to the smart learning platform'**
  String get loginTagline;

  /// No description provided for @loginAppName.
  ///
  /// In en, this message translates to:
  /// **'EduLab'**
  String get loginAppName;

  /// No description provided for @loginTabLogin.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get loginTabLogin;

  /// No description provided for @loginTabRegister.
  ///
  /// In en, this message translates to:
  /// **'New Account'**
  String get loginTabRegister;

  /// No description provided for @loginEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get loginEmailLabel;

  /// No description provided for @loginEmailHint.
  ///
  /// In en, this message translates to:
  /// **'example@email.com'**
  String get loginEmailHint;

  /// No description provided for @loginPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get loginPasswordLabel;

  /// No description provided for @loginPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'••••••'**
  String get loginPasswordHint;

  /// No description provided for @loginForgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot your password?'**
  String get loginForgotPassword;

  /// No description provided for @loginSubmit.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get loginSubmit;

  /// No description provided for @loginSubmitLoading.
  ///
  /// In en, this message translates to:
  /// **'Signing in'**
  String get loginSubmitLoading;

  /// No description provided for @loginGuest.
  ///
  /// In en, this message translates to:
  /// **'Join as Guest'**
  String get loginGuest;

  /// No description provided for @loginOr.
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get loginOr;

  /// No description provided for @loginEmailRequired.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get loginEmailRequired;

  /// No description provided for @loginEmailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address'**
  String get loginEmailInvalid;

  /// No description provided for @loginPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get loginPasswordRequired;

  /// No description provided for @registerStepEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get registerStepEmail;

  /// No description provided for @registerStepCode.
  ///
  /// In en, this message translates to:
  /// **'Code'**
  String get registerStepCode;

  /// No description provided for @registerStepData.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get registerStepData;

  /// No description provided for @registerSendCodeInfo.
  ///
  /// In en, this message translates to:
  /// **'We\'ll send an activation code to this email'**
  String get registerSendCodeInfo;

  /// No description provided for @registerSendCode.
  ///
  /// In en, this message translates to:
  /// **'Send Activation Code'**
  String get registerSendCode;

  /// No description provided for @registerVerifying.
  ///
  /// In en, this message translates to:
  /// **'Verifying'**
  String get registerVerifying;

  /// No description provided for @registerCodeSentTo.
  ///
  /// In en, this message translates to:
  /// **'Code sent to:'**
  String get registerCodeSentTo;

  /// No description provided for @registerResendCode.
  ///
  /// In en, this message translates to:
  /// **'Resend Code'**
  String get registerResendCode;

  /// No description provided for @registerBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get registerBack;

  /// No description provided for @registerVerifyCode.
  ///
  /// In en, this message translates to:
  /// **'Verify Code'**
  String get registerVerifyCode;

  /// No description provided for @registerCodeIncomplete.
  ///
  /// In en, this message translates to:
  /// **'Enter the complete 6-digit code'**
  String get registerCodeIncomplete;

  /// No description provided for @registerFullNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get registerFullNameLabel;

  /// No description provided for @registerFullNameHint.
  ///
  /// In en, this message translates to:
  /// **'Your full name'**
  String get registerFullNameHint;

  /// No description provided for @registerPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'At least 8 characters, one uppercase and one number'**
  String get registerPasswordHint;

  /// No description provided for @registerConfirmLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get registerConfirmLabel;

  /// No description provided for @registerConfirmHint.
  ///
  /// In en, this message translates to:
  /// **'Re-enter your password'**
  String get registerConfirmHint;

  /// No description provided for @registerSubmit.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get registerSubmit;

  /// No description provided for @registerSubmitLoading.
  ///
  /// In en, this message translates to:
  /// **'Creating account'**
  String get registerSubmitLoading;

  /// No description provided for @registerSuccess.
  ///
  /// In en, this message translates to:
  /// **'Account created successfully'**
  String get registerSuccess;

  /// No description provided for @registerNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Full name is required'**
  String get registerNameRequired;

  /// No description provided for @registerNameMinLength.
  ///
  /// In en, this message translates to:
  /// **'Full name must be at least 6 characters'**
  String get registerNameMinLength;

  /// No description provided for @registerPasswordMinLength.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters'**
  String get registerPasswordMinLength;

  /// No description provided for @registerPasswordUppercase.
  ///
  /// In en, this message translates to:
  /// **'Password must contain at least one uppercase letter'**
  String get registerPasswordUppercase;

  /// No description provided for @registerPasswordNumber.
  ///
  /// In en, this message translates to:
  /// **'Password must contain at least one number'**
  String get registerPasswordNumber;

  /// No description provided for @registerConfirmRequired.
  ///
  /// In en, this message translates to:
  /// **'Password confirmation is required'**
  String get registerConfirmRequired;

  /// No description provided for @registerConfirmMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get registerConfirmMismatch;

  /// No description provided for @networkError.
  ///
  /// In en, this message translates to:
  /// **'Connection error, please try again'**
  String get networkError;

  /// No description provided for @homeGreeting.
  ///
  /// In en, this message translates to:
  /// **'Hello, {name}!'**
  String homeGreeting(String name);

  /// No description provided for @homeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'What do you want to learn today?'**
  String get homeSubtitle;

  /// No description provided for @homeSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search for a course or skill...'**
  String get homeSearchHint;

  /// No description provided for @homeSectionContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue Learning'**
  String get homeSectionContinue;

  /// No description provided for @homeSectionRecommended.
  ///
  /// In en, this message translates to:
  /// **'Recommended for You'**
  String get homeSectionRecommended;

  /// No description provided for @homeSectionPopular.
  ///
  /// In en, this message translates to:
  /// **'Most Popular'**
  String get homeSectionPopular;

  /// No description provided for @homeSectionTopRated.
  ///
  /// In en, this message translates to:
  /// **'Top Rated'**
  String get homeSectionTopRated;

  /// No description provided for @homeSectionByCategory.
  ///
  /// In en, this message translates to:
  /// **'By Category'**
  String get homeSectionByCategory;

  /// No description provided for @homeHeroTitle.
  ///
  /// In en, this message translates to:
  /// **'Explore Offers Now'**
  String get homeHeroTitle;

  /// No description provided for @homeHeroSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Up to 70% off on premium courses'**
  String get homeHeroSubtitle;

  /// No description provided for @homeHeroButton.
  ///
  /// In en, this message translates to:
  /// **'Discover Now'**
  String get homeHeroButton;

  /// No description provided for @homeViewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get homeViewAll;

  /// No description provided for @homeProgressLabel.
  ///
  /// In en, this message translates to:
  /// **'Complete'**
  String get homeProgressLabel;

  /// No description provided for @exploreTitle.
  ///
  /// In en, this message translates to:
  /// **'Explore Courses'**
  String get exploreTitle;

  /// No description provided for @exploreSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search for a course, skill or instructor...'**
  String get exploreSearchHint;

  /// No description provided for @exploreAllCategories.
  ///
  /// In en, this message translates to:
  /// **'All Categories'**
  String get exploreAllCategories;

  /// No description provided for @exploreFilter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get exploreFilter;

  /// No description provided for @exploreSort.
  ///
  /// In en, this message translates to:
  /// **'Sort'**
  String get exploreSort;

  /// No description provided for @exploreNoResults.
  ///
  /// In en, this message translates to:
  /// **'No Results Found'**
  String get exploreNoResults;

  /// No description provided for @exploreNoResultsHint.
  ///
  /// In en, this message translates to:
  /// **'Try different keywords or change the filter'**
  String get exploreNoResultsHint;

  /// No description provided for @exploreCoursesCount.
  ///
  /// In en, this message translates to:
  /// **'{count} courses'**
  String exploreCoursesCount(int count);

  /// No description provided for @exploreFilterTitle.
  ///
  /// In en, this message translates to:
  /// **'Filter Results'**
  String get exploreFilterTitle;

  /// No description provided for @exploreFilterApply.
  ///
  /// In en, this message translates to:
  /// **'Apply Filter'**
  String get exploreFilterApply;

  /// No description provided for @exploreFilterReset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get exploreFilterReset;

  /// No description provided for @exploreFilterPrice.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get exploreFilterPrice;

  /// No description provided for @exploreFilterLevel.
  ///
  /// In en, this message translates to:
  /// **'Level'**
  String get exploreFilterLevel;

  /// No description provided for @exploreFilterRating.
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get exploreFilterRating;

  /// No description provided for @exploreFilterDuration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get exploreFilterDuration;

  /// No description provided for @exploreSortTitle.
  ///
  /// In en, this message translates to:
  /// **'Sort By'**
  String get exploreSortTitle;

  /// No description provided for @exploreSortRelevance.
  ///
  /// In en, this message translates to:
  /// **'Most Relevant'**
  String get exploreSortRelevance;

  /// No description provided for @exploreSortNewest.
  ///
  /// In en, this message translates to:
  /// **'Newest'**
  String get exploreSortNewest;

  /// No description provided for @exploreSortPopular.
  ///
  /// In en, this message translates to:
  /// **'Most Popular'**
  String get exploreSortPopular;

  /// No description provided for @exploreSortRating.
  ///
  /// In en, this message translates to:
  /// **'Highest Rated'**
  String get exploreSortRating;

  /// No description provided for @exploreSortPriceLow.
  ///
  /// In en, this message translates to:
  /// **'Price: Low to High'**
  String get exploreSortPriceLow;

  /// No description provided for @exploreSortPriceHigh.
  ///
  /// In en, this message translates to:
  /// **'Price: High to Low'**
  String get exploreSortPriceHigh;

  /// No description provided for @explorePriceFree.
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get explorePriceFree;

  /// No description provided for @exploreLevelBeginner.
  ///
  /// In en, this message translates to:
  /// **'Beginner'**
  String get exploreLevelBeginner;

  /// No description provided for @exploreLevelIntermediate.
  ///
  /// In en, this message translates to:
  /// **'Intermediate'**
  String get exploreLevelIntermediate;

  /// No description provided for @exploreLevelAdvanced.
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get exploreLevelAdvanced;

  /// No description provided for @learningTitle.
  ///
  /// In en, this message translates to:
  /// **'My Learning'**
  String get learningTitle;

  /// No description provided for @learningTabInProgress.
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get learningTabInProgress;

  /// No description provided for @learningTabCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get learningTabCompleted;

  /// No description provided for @learningTabSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get learningTabSaved;

  /// No description provided for @learningEmpty.
  ///
  /// In en, this message translates to:
  /// **'No courses yet'**
  String get learningEmpty;

  /// No description provided for @learningEmptyHint.
  ///
  /// In en, this message translates to:
  /// **'Start exploring courses now'**
  String get learningEmptyHint;

  /// No description provided for @learningExploreButton.
  ///
  /// In en, this message translates to:
  /// **'Explore Courses'**
  String get learningExploreButton;

  /// No description provided for @learningProgress.
  ///
  /// In en, this message translates to:
  /// **'{percent}% complete'**
  String learningProgress(int percent);

  /// No description provided for @learningContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get learningContinue;

  /// No description provided for @learningViewCertificate.
  ///
  /// In en, this message translates to:
  /// **'View Certificate'**
  String get learningViewCertificate;

  /// No description provided for @learningReview.
  ///
  /// In en, this message translates to:
  /// **'Rate Course'**
  String get learningReview;

  /// No description provided for @learningLesson.
  ///
  /// In en, this message translates to:
  /// **'Lesson'**
  String get learningLesson;

  /// No description provided for @learningLessons.
  ///
  /// In en, this message translates to:
  /// **'Lessons'**
  String get learningLessons;

  /// No description provided for @cartTitle.
  ///
  /// In en, this message translates to:
  /// **'Cart'**
  String get cartTitle;

  /// No description provided for @cartEmpty.
  ///
  /// In en, this message translates to:
  /// **'Your cart is empty'**
  String get cartEmpty;

  /// No description provided for @cartEmptyHint.
  ///
  /// In en, this message translates to:
  /// **'Add some courses to start your learning journey'**
  String get cartEmptyHint;

  /// No description provided for @cartExploreButton.
  ///
  /// In en, this message translates to:
  /// **'Explore Courses'**
  String get cartExploreButton;

  /// No description provided for @cartPromoPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Enter promo code'**
  String get cartPromoPlaceholder;

  /// No description provided for @cartPromoApply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get cartPromoApply;

  /// No description provided for @cartPromoInvalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid promo code'**
  String get cartPromoInvalid;

  /// No description provided for @cartSummary.
  ///
  /// In en, this message translates to:
  /// **'Order Summary'**
  String get cartSummary;

  /// No description provided for @cartSubtotal.
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get cartSubtotal;

  /// No description provided for @cartDiscount.
  ///
  /// In en, this message translates to:
  /// **'Discount'**
  String get cartDiscount;

  /// No description provided for @cartTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get cartTotal;

  /// No description provided for @cartCheckout.
  ///
  /// In en, this message translates to:
  /// **'Checkout'**
  String get cartCheckout;

  /// No description provided for @cartCourses.
  ///
  /// In en, this message translates to:
  /// **'{count} courses'**
  String cartCourses(int count);

  /// No description provided for @cartRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get cartRemove;

  /// No description provided for @cartGuarantee.
  ///
  /// In en, this message translates to:
  /// **'30-Day Money-Back Guarantee'**
  String get cartGuarantee;

  /// No description provided for @checkoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Checkout'**
  String get checkoutTitle;

  /// No description provided for @checkoutStepPayment.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get checkoutStepPayment;

  /// No description provided for @checkoutStepReview.
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get checkoutStepReview;

  /// No description provided for @checkoutStepConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get checkoutStepConfirm;

  /// No description provided for @checkoutOrderSummary.
  ///
  /// In en, this message translates to:
  /// **'Order Summary'**
  String get checkoutOrderSummary;

  /// No description provided for @checkoutTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get checkoutTotal;

  /// No description provided for @checkoutPayNow.
  ///
  /// In en, this message translates to:
  /// **'Pay Now'**
  String get checkoutPayNow;

  /// No description provided for @checkoutBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get checkoutBack;

  /// No description provided for @checkoutNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get checkoutNext;

  /// No description provided for @checkoutSecureSSL.
  ///
  /// In en, this message translates to:
  /// **'Secure payment with 256-bit SSL encryption'**
  String get checkoutSecureSSL;

  /// No description provided for @checkoutSuccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Purchase Successful!'**
  String get checkoutSuccessTitle;

  /// No description provided for @checkoutSuccessSubtitle.
  ///
  /// In en, this message translates to:
  /// **'You can now access your course'**
  String get checkoutSuccessSubtitle;

  /// No description provided for @checkoutGoToLearning.
  ///
  /// In en, this message translates to:
  /// **'Go to My Courses'**
  String get checkoutGoToLearning;

  /// No description provided for @checkoutPaymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Payment Method'**
  String get checkoutPaymentMethod;

  /// No description provided for @checkoutCardNumber.
  ///
  /// In en, this message translates to:
  /// **'Card Number'**
  String get checkoutCardNumber;

  /// No description provided for @checkoutCardName.
  ///
  /// In en, this message translates to:
  /// **'Cardholder Name'**
  String get checkoutCardName;

  /// No description provided for @checkoutCardExpiry.
  ///
  /// In en, this message translates to:
  /// **'Expiry Date'**
  String get checkoutCardExpiry;

  /// No description provided for @checkoutCardCVV.
  ///
  /// In en, this message translates to:
  /// **'CVV'**
  String get checkoutCardCVV;

  /// No description provided for @courseDetailsEnroll.
  ///
  /// In en, this message translates to:
  /// **'Enroll Now'**
  String get courseDetailsEnroll;

  /// No description provided for @courseDetailsBuyNow.
  ///
  /// In en, this message translates to:
  /// **'Buy Now'**
  String get courseDetailsBuyNow;

  /// No description provided for @courseDetailsAddToCart.
  ///
  /// In en, this message translates to:
  /// **'Add to Cart'**
  String get courseDetailsAddToCart;

  /// No description provided for @courseDetailsAddedToCart.
  ///
  /// In en, this message translates to:
  /// **'Added to Cart'**
  String get courseDetailsAddedToCart;

  /// No description provided for @courseDetailsAlreadyEnrolled.
  ///
  /// In en, this message translates to:
  /// **'Already Enrolled'**
  String get courseDetailsAlreadyEnrolled;

  /// No description provided for @courseDetailsGoToCourse.
  ///
  /// In en, this message translates to:
  /// **'Go to Course'**
  String get courseDetailsGoToCourse;

  /// No description provided for @courseDetailsFree.
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get courseDetailsFree;

  /// No description provided for @courseDetailsStudents.
  ///
  /// In en, this message translates to:
  /// **'{count} students'**
  String courseDetailsStudents(String count);

  /// No description provided for @courseDetailsRating.
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get courseDetailsRating;

  /// No description provided for @courseDetailsReviews.
  ///
  /// In en, this message translates to:
  /// **'Student Reviews'**
  String get courseDetailsReviews;

  /// No description provided for @courseDetailsLastUpdated.
  ///
  /// In en, this message translates to:
  /// **'Last Updated'**
  String get courseDetailsLastUpdated;

  /// No description provided for @courseDetailsCurriculum.
  ///
  /// In en, this message translates to:
  /// **'Course Content'**
  String get courseDetailsCurriculum;

  /// No description provided for @courseDetailsSection.
  ///
  /// In en, this message translates to:
  /// **'section'**
  String get courseDetailsSection;

  /// No description provided for @courseDetailsLessons.
  ///
  /// In en, this message translates to:
  /// **'lessons'**
  String get courseDetailsLessons;

  /// No description provided for @courseDetailsInstructor.
  ///
  /// In en, this message translates to:
  /// **'Instructor'**
  String get courseDetailsInstructor;

  /// No description provided for @courseDetailsStudentsLabel.
  ///
  /// In en, this message translates to:
  /// **'Students'**
  String get courseDetailsStudentsLabel;

  /// No description provided for @courseDetailsCoursesLabel.
  ///
  /// In en, this message translates to:
  /// **'Courses'**
  String get courseDetailsCoursesLabel;

  /// No description provided for @courseDetailsReviewsLabel.
  ///
  /// In en, this message translates to:
  /// **'Reviews'**
  String get courseDetailsReviewsLabel;

  /// No description provided for @courseDetailsReviewsTitle.
  ///
  /// In en, this message translates to:
  /// **'Student Reviews'**
  String get courseDetailsReviewsTitle;

  /// No description provided for @courseDetailsWhatLearn.
  ///
  /// In en, this message translates to:
  /// **'What You\'ll Learn'**
  String get courseDetailsWhatLearn;

  /// No description provided for @courseDetailsRequirements.
  ///
  /// In en, this message translates to:
  /// **'Requirements'**
  String get courseDetailsRequirements;

  /// No description provided for @courseDetailsDescription.
  ///
  /// In en, this message translates to:
  /// **'Course Description'**
  String get courseDetailsDescription;

  /// No description provided for @courseDetailsIncludesTitle.
  ///
  /// In en, this message translates to:
  /// **'This Course Includes'**
  String get courseDetailsIncludesTitle;

  /// No description provided for @courseDetailsHoursVideo.
  ///
  /// In en, this message translates to:
  /// **'hours of video'**
  String get courseDetailsHoursVideo;

  /// No description provided for @courseDetailsArticles.
  ///
  /// In en, this message translates to:
  /// **'articles'**
  String get courseDetailsArticles;

  /// No description provided for @courseDetailsMobileAccess.
  ///
  /// In en, this message translates to:
  /// **'Mobile access'**
  String get courseDetailsMobileAccess;

  /// No description provided for @courseDetailsCertificate.
  ///
  /// In en, this message translates to:
  /// **'Certificate of completion'**
  String get courseDetailsCertificate;

  /// No description provided for @courseDetailsLifetimeAccess.
  ///
  /// In en, this message translates to:
  /// **'Lifetime access'**
  String get courseDetailsLifetimeAccess;

  /// No description provided for @lessonPlayerNotes.
  ///
  /// In en, this message translates to:
  /// **'My Notes'**
  String get lessonPlayerNotes;

  /// No description provided for @lessonPlayerResources.
  ///
  /// In en, this message translates to:
  /// **'Resources'**
  String get lessonPlayerResources;

  /// No description provided for @lessonPlayerDiscussion.
  ///
  /// In en, this message translates to:
  /// **'Discussion'**
  String get lessonPlayerDiscussion;

  /// No description provided for @lessonPlayerPrev.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get lessonPlayerPrev;

  /// No description provided for @lessonPlayerNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get lessonPlayerNext;

  /// No description provided for @lessonPlayerSpeed.
  ///
  /// In en, this message translates to:
  /// **'Speed'**
  String get lessonPlayerSpeed;

  /// No description provided for @lessonPlayerQuality.
  ///
  /// In en, this message translates to:
  /// **'Quality'**
  String get lessonPlayerQuality;

  /// No description provided for @lessonPlayerCompleted.
  ///
  /// In en, this message translates to:
  /// **'Lesson Completed'**
  String get lessonPlayerCompleted;

  /// No description provided for @certificateTitle.
  ///
  /// In en, this message translates to:
  /// **'Certificate of Completion'**
  String get certificateTitle;

  /// No description provided for @certificatePresentedTo.
  ///
  /// In en, this message translates to:
  /// **'Presented to'**
  String get certificatePresentedTo;

  /// No description provided for @certificateCompletedCourse.
  ///
  /// In en, this message translates to:
  /// **'for successfully completing'**
  String get certificateCompletedCourse;

  /// No description provided for @certificateIssuedOn.
  ///
  /// In en, this message translates to:
  /// **'Issued on'**
  String get certificateIssuedOn;

  /// No description provided for @certificateVerificationId.
  ///
  /// In en, this message translates to:
  /// **'Verification ID'**
  String get certificateVerificationId;

  /// No description provided for @certificateDownloadPDF.
  ///
  /// In en, this message translates to:
  /// **'Download PDF'**
  String get certificateDownloadPDF;

  /// No description provided for @certificateDownloadPNG.
  ///
  /// In en, this message translates to:
  /// **'Download Image'**
  String get certificateDownloadPNG;

  /// No description provided for @certificateCopyLink.
  ///
  /// In en, this message translates to:
  /// **'Copy Verification Link'**
  String get certificateCopyLink;

  /// No description provided for @certificateLinkCopied.
  ///
  /// In en, this message translates to:
  /// **'Link copied'**
  String get certificateLinkCopied;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @profileEditProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get profileEditProfile;

  /// No description provided for @profileCourses.
  ///
  /// In en, this message translates to:
  /// **'My Courses'**
  String get profileCourses;

  /// No description provided for @profileCertificates.
  ///
  /// In en, this message translates to:
  /// **'Certificates'**
  String get profileCertificates;

  /// No description provided for @profilePoints.
  ///
  /// In en, this message translates to:
  /// **'Points'**
  String get profilePoints;

  /// No description provided for @profileFollowers.
  ///
  /// In en, this message translates to:
  /// **'Followers'**
  String get profileFollowers;

  /// No description provided for @profileFollowing.
  ///
  /// In en, this message translates to:
  /// **'Following'**
  String get profileFollowing;

  /// No description provided for @profileBio.
  ///
  /// In en, this message translates to:
  /// **'Bio'**
  String get profileBio;

  /// No description provided for @profileInstructor.
  ///
  /// In en, this message translates to:
  /// **'Instructor'**
  String get profileInstructor;

  /// No description provided for @profileStudent.
  ///
  /// In en, this message translates to:
  /// **'Student'**
  String get profileStudent;

  /// No description provided for @profileLevel.
  ///
  /// In en, this message translates to:
  /// **'Level'**
  String get profileLevel;

  /// No description provided for @profileJoined.
  ///
  /// In en, this message translates to:
  /// **'Joined'**
  String get profileJoined;

  /// No description provided for @profileShareProfile.
  ///
  /// In en, this message translates to:
  /// **'Share Profile'**
  String get profileShareProfile;

  /// No description provided for @profileMenuLearning.
  ///
  /// In en, this message translates to:
  /// **'My Courses'**
  String get profileMenuLearning;

  /// No description provided for @profileMenuCertificates.
  ///
  /// In en, this message translates to:
  /// **'My Certificates'**
  String get profileMenuCertificates;

  /// No description provided for @profileMenuPurchaseHistory.
  ///
  /// In en, this message translates to:
  /// **'Purchase History'**
  String get profileMenuPurchaseHistory;

  /// No description provided for @profileMenuTeachApplication.
  ///
  /// In en, this message translates to:
  /// **'Teach on EduLab'**
  String get profileMenuTeachApplication;

  /// No description provided for @profileMenuAccountSecurity.
  ///
  /// In en, this message translates to:
  /// **'Account Security'**
  String get profileMenuAccountSecurity;

  /// No description provided for @profileMenuNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get profileMenuNotifications;

  /// No description provided for @profileMenuMessages.
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get profileMenuMessages;

  /// No description provided for @profileMenuSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get profileMenuSettings;

  /// No description provided for @profileMenuSchedule.
  ///
  /// In en, this message translates to:
  /// **'My Schedule'**
  String get profileMenuSchedule;

  /// No description provided for @profileMenuAssignments.
  ///
  /// In en, this message translates to:
  /// **'Assignments'**
  String get profileMenuAssignments;

  /// No description provided for @profileMenuQuiz.
  ///
  /// In en, this message translates to:
  /// **'Quizzes'**
  String get profileMenuQuiz;

  /// No description provided for @profileMenuLogout.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get profileMenuLogout;

  /// No description provided for @profileLogoutConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to sign out?'**
  String get profileLogoutConfirm;

  /// No description provided for @profileLogoutYes.
  ///
  /// In en, this message translates to:
  /// **'Yes, Sign Out'**
  String get profileLogoutYes;

  /// No description provided for @profileLogoutNo.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get profileLogoutNo;

  /// No description provided for @editProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfileTitle;

  /// No description provided for @editProfileSave.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get editProfileSave;

  /// No description provided for @editProfileFullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get editProfileFullName;

  /// No description provided for @editProfileBio.
  ///
  /// In en, this message translates to:
  /// **'Bio'**
  String get editProfileBio;

  /// No description provided for @editProfileEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get editProfileEmail;

  /// No description provided for @editProfilePhone.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get editProfilePhone;

  /// No description provided for @editProfileWebsite.
  ///
  /// In en, this message translates to:
  /// **'Website'**
  String get editProfileWebsite;

  /// No description provided for @editProfileSaved.
  ///
  /// In en, this message translates to:
  /// **'Changes saved successfully'**
  String get editProfileSaved;

  /// No description provided for @accountSecurityTitle.
  ///
  /// In en, this message translates to:
  /// **'Account Security'**
  String get accountSecurityTitle;

  /// No description provided for @accountSecurityChangePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get accountSecurityChangePassword;

  /// No description provided for @accountSecurityTwoFactor.
  ///
  /// In en, this message translates to:
  /// **'Two-Factor Authentication'**
  String get accountSecurityTwoFactor;

  /// No description provided for @accountSecurityActiveSessions.
  ///
  /// In en, this message translates to:
  /// **'Active Sessions'**
  String get accountSecurityActiveSessions;

  /// No description provided for @accountSecurityDeleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get accountSecurityDeleteAccount;

  /// No description provided for @purchaseHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Purchase History'**
  String get purchaseHistoryTitle;

  /// No description provided for @purchaseHistoryEmpty.
  ///
  /// In en, this message translates to:
  /// **'No purchases yet'**
  String get purchaseHistoryEmpty;

  /// No description provided for @purchaseHistoryGuarantee.
  ///
  /// In en, this message translates to:
  /// **'30-Day Money-Back Guarantee'**
  String get purchaseHistoryGuarantee;

  /// No description provided for @purchaseHistoryDate.
  ///
  /// In en, this message translates to:
  /// **'Transaction Date'**
  String get purchaseHistoryDate;

  /// No description provided for @purchaseHistoryStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get purchaseHistoryStatus;

  /// No description provided for @purchaseHistoryAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get purchaseHistoryAmount;

  /// No description provided for @purchaseHistoryCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get purchaseHistoryCompleted;

  /// No description provided for @purchaseHistoryRefunded.
  ///
  /// In en, this message translates to:
  /// **'Refunded'**
  String get purchaseHistoryRefunded;

  /// No description provided for @teachApplicationTitle.
  ///
  /// In en, this message translates to:
  /// **'Teach on EduLab'**
  String get teachApplicationTitle;

  /// No description provided for @teachApplicationSubmit.
  ///
  /// In en, this message translates to:
  /// **'Submit Application'**
  String get teachApplicationSubmit;

  /// No description provided for @teachApplicationSent.
  ///
  /// In en, this message translates to:
  /// **'Your application was submitted successfully'**
  String get teachApplicationSent;

  /// No description provided for @notificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsTitle;

  /// No description provided for @notificationsMarkAllRead.
  ///
  /// In en, this message translates to:
  /// **'Mark All as Read'**
  String get notificationsMarkAllRead;

  /// No description provided for @notificationsMarkAllReadSnackbar.
  ///
  /// In en, this message translates to:
  /// **'All notifications marked as read'**
  String get notificationsMarkAllReadSnackbar;

  /// No description provided for @notificationsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No notifications'**
  String get notificationsEmpty;

  /// No description provided for @notification1Title.
  ///
  /// In en, this message translates to:
  /// **'Reminder: Continue Your Course'**
  String get notification1Title;

  /// No description provided for @notification1Message.
  ///
  /// In en, this message translates to:
  /// **'You have a new lesson in Flutter for Beginners'**
  String get notification1Message;

  /// No description provided for @notification1Time.
  ///
  /// In en, this message translates to:
  /// **'5 minutes ago'**
  String get notification1Time;

  /// No description provided for @notification1Action.
  ///
  /// In en, this message translates to:
  /// **'Resume Course'**
  String get notification1Action;

  /// No description provided for @notification2Title.
  ///
  /// In en, this message translates to:
  /// **'Your Certificate is Ready!'**
  String get notification2Title;

  /// No description provided for @notification2Message.
  ///
  /// In en, this message translates to:
  /// **'You completed the UX/UI Design course. Your certificate is available'**
  String get notification2Message;

  /// No description provided for @notification2Time.
  ///
  /// In en, this message translates to:
  /// **'2 hours ago'**
  String get notification2Time;

  /// No description provided for @notification2Action.
  ///
  /// In en, this message translates to:
  /// **'View Certificate'**
  String get notification2Action;

  /// No description provided for @notification3Title.
  ///
  /// In en, this message translates to:
  /// **'Exclusive Offer for You'**
  String get notification3Title;

  /// No description provided for @notification3Message.
  ///
  /// In en, this message translates to:
  /// **'70% off on programming courses for a limited time'**
  String get notification3Message;

  /// No description provided for @notification3Time.
  ///
  /// In en, this message translates to:
  /// **'1 day ago'**
  String get notification3Time;

  /// No description provided for @notification3Action.
  ///
  /// In en, this message translates to:
  /// **'Explore Offer'**
  String get notification3Action;

  /// No description provided for @notification4Title.
  ///
  /// In en, this message translates to:
  /// **'New Reply to Your Question'**
  String get notification4Title;

  /// No description provided for @notification4Message.
  ///
  /// In en, this message translates to:
  /// **'The instructor replied to your question in the React Hooks lesson'**
  String get notification4Message;

  /// No description provided for @notification4Time.
  ///
  /// In en, this message translates to:
  /// **'2 days ago'**
  String get notification4Time;

  /// No description provided for @notification4Action.
  ///
  /// In en, this message translates to:
  /// **'View Reply'**
  String get notification4Action;

  /// No description provided for @notification5Title.
  ///
  /// In en, this message translates to:
  /// **'Course Update'**
  String get notification5Title;

  /// No description provided for @notification5Message.
  ///
  /// In en, this message translates to:
  /// **'New content was added to the Advanced Python course'**
  String get notification5Message;

  /// No description provided for @notification5Time.
  ///
  /// In en, this message translates to:
  /// **'3 days ago'**
  String get notification5Time;

  /// No description provided for @messagesTitle.
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get messagesTitle;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings & Preferences'**
  String get settingsTitle;

  /// No description provided for @settingsVideoDownload.
  ///
  /// In en, this message translates to:
  /// **'Video & Download'**
  String get settingsVideoDownload;

  /// No description provided for @settingsDownloadQuality.
  ///
  /// In en, this message translates to:
  /// **'Default Video Download Quality'**
  String get settingsDownloadQuality;

  /// No description provided for @settingsWifiOnly.
  ///
  /// In en, this message translates to:
  /// **'Download via Wi-Fi Only'**
  String get settingsWifiOnly;

  /// No description provided for @settingsNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications & Alerts'**
  String get settingsNotifications;

  /// No description provided for @settingsCourseNotifications.
  ///
  /// In en, this message translates to:
  /// **'Course & Message Notifications'**
  String get settingsCourseNotifications;

  /// No description provided for @settingsPromoNotifications.
  ///
  /// In en, this message translates to:
  /// **'Exclusive Offers & Discounts'**
  String get settingsPromoNotifications;

  /// No description provided for @settingsAppearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance & Language'**
  String get settingsAppearance;

  /// No description provided for @settingsDarkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get settingsDarkMode;

  /// No description provided for @settingsDarkModeEnabled.
  ///
  /// In en, this message translates to:
  /// **'Enabled (saves battery, easy on the eyes)'**
  String get settingsDarkModeEnabled;

  /// No description provided for @settingsDarkModeDisabled.
  ///
  /// In en, this message translates to:
  /// **'Disabled (light mode)'**
  String get settingsDarkModeDisabled;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'App Language'**
  String get settingsLanguage;

  /// No description provided for @settingsStorage.
  ///
  /// In en, this message translates to:
  /// **'Storage & Cache'**
  String get settingsStorage;

  /// No description provided for @settingsClearCache.
  ///
  /// In en, this message translates to:
  /// **'Clear Cache'**
  String get settingsClearCache;

  /// No description provided for @settingsClearCacheSuccess.
  ///
  /// In en, this message translates to:
  /// **'Cache cleared successfully'**
  String get settingsClearCacheSuccess;

  /// No description provided for @settingsHelp.
  ///
  /// In en, this message translates to:
  /// **'Info & Policies'**
  String get settingsHelp;

  /// No description provided for @settingsHelpCenter.
  ///
  /// In en, this message translates to:
  /// **'Help Center & FAQ'**
  String get settingsHelpCenter;

  /// No description provided for @settingsTermsPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Terms of Use & Privacy Policy'**
  String get settingsTermsPrivacy;

  /// No description provided for @settingsAbout.
  ///
  /// In en, this message translates to:
  /// **'About EduLab'**
  String get settingsAbout;

  /// No description provided for @settingsVersion.
  ///
  /// In en, this message translates to:
  /// **'Version v1.0.0'**
  String get settingsVersion;

  /// No description provided for @quizTitle.
  ///
  /// In en, this message translates to:
  /// **'Quiz'**
  String get quizTitle;

  /// No description provided for @quizNext.
  ///
  /// In en, this message translates to:
  /// **'Next Question'**
  String get quizNext;

  /// No description provided for @quizSubmit.
  ///
  /// In en, this message translates to:
  /// **'Submit Quiz'**
  String get quizSubmit;

  /// No description provided for @quizScore.
  ///
  /// In en, this message translates to:
  /// **'Quiz Score'**
  String get quizScore;

  /// No description provided for @quizCorrectAnswers.
  ///
  /// In en, this message translates to:
  /// **'Correct Answers'**
  String get quizCorrectAnswers;

  /// No description provided for @scheduleTitle.
  ///
  /// In en, this message translates to:
  /// **'My Schedule'**
  String get scheduleTitle;

  /// No description provided for @scheduleEmpty.
  ///
  /// In en, this message translates to:
  /// **'No scheduled sessions'**
  String get scheduleEmpty;

  /// No description provided for @scheduleJoin.
  ///
  /// In en, this message translates to:
  /// **'Join Session'**
  String get scheduleJoin;

  /// No description provided for @scheduleReminder.
  ///
  /// In en, this message translates to:
  /// **'Reminder'**
  String get scheduleReminder;

  /// No description provided for @assignmentsTitle.
  ///
  /// In en, this message translates to:
  /// **'Assignments'**
  String get assignmentsTitle;

  /// No description provided for @assignmentsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No assignments'**
  String get assignmentsEmpty;

  /// No description provided for @assignmentsSubmit.
  ///
  /// In en, this message translates to:
  /// **'Submit Assignment'**
  String get assignmentsSubmit;

  /// No description provided for @assignmentsDue.
  ///
  /// In en, this message translates to:
  /// **'Due Date'**
  String get assignmentsDue;

  /// No description provided for @assignmentsSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Submitted'**
  String get assignmentsSubmitted;

  /// No description provided for @assignmentsPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get assignmentsPending;

  /// No description provided for @languageArabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get languageArabic;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Select App Language'**
  String get languageDialogTitle;

  /// No description provided for @languageSelect.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get languageSelect;

  /// No description provided for @generalCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get generalCancel;

  /// No description provided for @generalConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get generalConfirm;

  /// No description provided for @generalSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get generalSave;

  /// No description provided for @generalDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get generalDelete;

  /// No description provided for @generalEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get generalEdit;

  /// No description provided for @generalClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get generalClose;

  /// No description provided for @generalBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get generalBack;

  /// No description provided for @generalDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get generalDone;

  /// No description provided for @generalOk.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get generalOk;

  /// No description provided for @generalYes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get generalYes;

  /// No description provided for @generalNo.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get generalNo;

  /// No description provided for @generalLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get generalLoading;

  /// No description provided for @generalError.
  ///
  /// In en, this message translates to:
  /// **'An error occurred'**
  String get generalError;

  /// No description provided for @generalRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get generalRetry;

  /// No description provided for @generalNoInternet.
  ///
  /// In en, this message translates to:
  /// **'No internet connection'**
  String get generalNoInternet;

  /// No description provided for @generalFree.
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get generalFree;

  /// No description provided for @generalRating.
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get generalRating;

  /// No description provided for @generalStudents.
  ///
  /// In en, this message translates to:
  /// **'Students'**
  String get generalStudents;

  /// No description provided for @generalHours.
  ///
  /// In en, this message translates to:
  /// **'Hours'**
  String get generalHours;

  /// No description provided for @generalMinutes.
  ///
  /// In en, this message translates to:
  /// **'Minutes'**
  String get generalMinutes;

  /// No description provided for @generalBy.
  ///
  /// In en, this message translates to:
  /// **'By'**
  String get generalBy;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navExplore.
  ///
  /// In en, this message translates to:
  /// **'Explore'**
  String get navExplore;

  /// No description provided for @navMyCourses.
  ///
  /// In en, this message translates to:
  /// **'My Courses'**
  String get navMyCourses;

  /// No description provided for @navCart.
  ///
  /// In en, this message translates to:
  /// **'Cart'**
  String get navCart;

  /// No description provided for @navAccount.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get navAccount;

  /// No description provided for @homeSubGreeting.
  ///
  /// In en, this message translates to:
  /// **'What do you want to learn today?'**
  String get homeSubGreeting;

  /// No description provided for @homeVisitor.
  ///
  /// In en, this message translates to:
  /// **'Guest'**
  String get homeVisitor;

  /// No description provided for @homePromoTitle.
  ///
  /// In en, this message translates to:
  /// **'Explore Offers Now'**
  String get homePromoTitle;

  /// No description provided for @homePromoSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Up to 70% off on premium courses'**
  String get homePromoSubtitle;

  /// No description provided for @homePromoButton.
  ///
  /// In en, this message translates to:
  /// **'Discover Now'**
  String get homePromoButton;

  /// No description provided for @homePromoBadge.
  ///
  /// In en, this message translates to:
  /// **'Exclusive Offer'**
  String get homePromoBadge;

  /// No description provided for @homeContinueLearning.
  ///
  /// In en, this message translates to:
  /// **'Continue Learning'**
  String get homeContinueLearning;

  /// No description provided for @homeMyCoursesLink.
  ///
  /// In en, this message translates to:
  /// **'My Courses'**
  String get homeMyCoursesLink;

  /// No description provided for @homeLesson.
  ///
  /// In en, this message translates to:
  /// **'Lesson'**
  String get homeLesson;

  /// No description provided for @homeStudentsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} students'**
  String homeStudentsCount(String count);

  /// No description provided for @homeRecommendedTitle.
  ///
  /// In en, this message translates to:
  /// **'Recommended for You'**
  String get homeRecommendedTitle;

  /// No description provided for @homeRecommendedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Personalized based on your interests'**
  String get homeRecommendedSubtitle;

  /// No description provided for @homeBestsellersTitle.
  ///
  /// In en, this message translates to:
  /// **'Bestsellers'**
  String get homeBestsellersTitle;

  /// No description provided for @homeBestsellersSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Top-rated and most popular courses'**
  String get homeBestsellersSubtitle;

  /// No description provided for @homeNewCoursesTitle.
  ///
  /// In en, this message translates to:
  /// **'New Courses'**
  String get homeNewCoursesTitle;

  /// No description provided for @homeNewCoursesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Fresh and updated content'**
  String get homeNewCoursesSubtitle;

  /// No description provided for @homePopularTopicsTitle.
  ///
  /// In en, this message translates to:
  /// **'Popular Topics'**
  String get homePopularTopicsTitle;

  /// No description provided for @homePopularTopicsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Start learning the most in-demand skills'**
  String get homePopularTopicsSubtitle;

  /// No description provided for @homeTopInstructorsTitle.
  ///
  /// In en, this message translates to:
  /// **'Top Instructors'**
  String get homeTopInstructorsTitle;

  /// No description provided for @homeTopInstructorsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Learn from certified experts'**
  String get homeTopInstructorsSubtitle;

  /// No description provided for @homeExploreCategoriesTitle.
  ///
  /// In en, this message translates to:
  /// **'Explore Categories'**
  String get homeExploreCategoriesTitle;

  /// No description provided for @homeExploreCategoriesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Find the right course for you'**
  String get homeExploreCategoriesSubtitle;

  /// No description provided for @catAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get catAll;

  /// No description provided for @catWebDev.
  ///
  /// In en, this message translates to:
  /// **'Web Development'**
  String get catWebDev;

  /// No description provided for @catMobileApps.
  ///
  /// In en, this message translates to:
  /// **'Mobile Apps'**
  String get catMobileApps;

  /// No description provided for @catDataScience.
  ///
  /// In en, this message translates to:
  /// **'Data Science'**
  String get catDataScience;

  /// No description provided for @catUIUX.
  ///
  /// In en, this message translates to:
  /// **'UI/UX Design'**
  String get catUIUX;

  /// No description provided for @catBusiness.
  ///
  /// In en, this message translates to:
  /// **'Business'**
  String get catBusiness;

  /// No description provided for @catAI.
  ///
  /// In en, this message translates to:
  /// **'Artificial Intelligence'**
  String get catAI;

  /// No description provided for @catCyberSecurity.
  ///
  /// In en, this message translates to:
  /// **'Cybersecurity'**
  String get catCyberSecurity;

  /// No description provided for @exploreNoResultsTitle.
  ///
  /// In en, this message translates to:
  /// **'No Results Found'**
  String get exploreNoResultsTitle;

  /// No description provided for @exploreNoResultsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Try different keywords or change the filter'**
  String get exploreNoResultsSubtitle;

  /// No description provided for @exploreRecentSearches.
  ///
  /// In en, this message translates to:
  /// **'Recent Searches'**
  String get exploreRecentSearches;

  /// No description provided for @exploreTopSearches.
  ///
  /// In en, this message translates to:
  /// **'Top Searches'**
  String get exploreTopSearches;

  /// No description provided for @exploreBrowseCategories.
  ///
  /// In en, this message translates to:
  /// **'Browse Categories'**
  String get exploreBrowseCategories;

  /// No description provided for @exploreBrowseCategoriesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Find the right course for you'**
  String get exploreBrowseCategoriesSubtitle;

  /// No description provided for @exploreBackToAll.
  ///
  /// In en, this message translates to:
  /// **'Back to All'**
  String get exploreBackToAll;

  /// No description provided for @exploreClearAll.
  ///
  /// In en, this message translates to:
  /// **'Clear All'**
  String get exploreClearAll;

  /// No description provided for @exploreAvailableResults.
  ///
  /// In en, this message translates to:
  /// **'result available'**
  String get exploreAvailableResults;

  /// No description provided for @exploreFilterBestseller.
  ///
  /// In en, this message translates to:
  /// **'Bestseller'**
  String get exploreFilterBestseller;

  /// No description provided for @exploreFilterTopRated.
  ///
  /// In en, this message translates to:
  /// **'Top Rated'**
  String get exploreFilterTopRated;

  /// No description provided for @exploreFilterUnder50.
  ///
  /// In en, this message translates to:
  /// **'Under \$50'**
  String get exploreFilterUnder50;

  /// No description provided for @learningHeroTitle.
  ///
  /// In en, this message translates to:
  /// **'Continue Your Learning Journey'**
  String get learningHeroTitle;

  /// No description provided for @learningSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search your courses...'**
  String get learningSearchHint;

  /// No description provided for @learningFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get learningFilterAll;

  /// No description provided for @learningFilterInProgress.
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get learningFilterInProgress;

  /// No description provided for @learningFilterCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get learningFilterCompleted;

  /// No description provided for @learningFilterDownloaded.
  ///
  /// In en, this message translates to:
  /// **'Downloaded'**
  String get learningFilterDownloaded;

  /// No description provided for @learningEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No courses yet'**
  String get learningEmptyTitle;

  /// No description provided for @learningEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Start exploring courses now'**
  String get learningEmptySubtitle;

  /// No description provided for @learningEmptySearch.
  ///
  /// In en, this message translates to:
  /// **'No results for your search'**
  String get learningEmptySearch;

  /// No description provided for @learningCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get learningCompleted;

  /// No description provided for @learningCompletedBadge.
  ///
  /// In en, this message translates to:
  /// **'Completed ✓'**
  String get learningCompletedBadge;

  /// No description provided for @learningLecturesCount.
  ///
  /// In en, this message translates to:
  /// **'{count} lectures'**
  String learningLecturesCount(int count);

  /// No description provided for @cartEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Your cart is empty'**
  String get cartEmptyTitle;

  /// No description provided for @cartEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add some courses to start your learning journey'**
  String get cartEmptySubtitle;

  /// No description provided for @cartCouponHint.
  ///
  /// In en, this message translates to:
  /// **'Enter promo code'**
  String get cartCouponHint;

  /// No description provided for @cartCouponApply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get cartCouponApply;

  /// No description provided for @cartCouponInvalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid promo code'**
  String get cartCouponInvalid;

  /// No description provided for @cartCouponApplied.
  ///
  /// In en, this message translates to:
  /// **'Promo code applied'**
  String get cartCouponApplied;

  /// No description provided for @cartCouponDiscount.
  ///
  /// In en, this message translates to:
  /// **'Coupon discount'**
  String get cartCouponDiscount;

  /// No description provided for @cartCouponsTitle.
  ///
  /// In en, this message translates to:
  /// **'Coupons'**
  String get cartCouponsTitle;

  /// No description provided for @cartOrderSummary.
  ///
  /// In en, this message translates to:
  /// **'Order Summary'**
  String get cartOrderSummary;

  /// No description provided for @cartOriginalPrice.
  ///
  /// In en, this message translates to:
  /// **'Original Price'**
  String get cartOriginalPrice;

  /// No description provided for @cartPlatformDiscount.
  ///
  /// In en, this message translates to:
  /// **'Platform Discount'**
  String get cartPlatformDiscount;

  /// No description provided for @cartFinalTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get cartFinalTotal;

  /// No description provided for @cartItemsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} courses'**
  String cartItemsCount(int count);

  /// No description provided for @cartRemovedSnackbar.
  ///
  /// In en, this message translates to:
  /// **'Course removed from cart'**
  String get cartRemovedSnackbar;

  /// No description provided for @cartUndo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get cartUndo;

  /// No description provided for @cartAddButton.
  ///
  /// In en, this message translates to:
  /// **'Add to Cart'**
  String get cartAddButton;

  /// No description provided for @cartAddedSnackbar.
  ///
  /// In en, this message translates to:
  /// **'Added to cart'**
  String get cartAddedSnackbar;

  /// No description provided for @cartAlreadyInCart.
  ///
  /// In en, this message translates to:
  /// **'Already in Cart'**
  String get cartAlreadyInCart;

  /// No description provided for @cartCheckoutButton.
  ///
  /// In en, this message translates to:
  /// **'Checkout'**
  String get cartCheckoutButton;

  /// No description provided for @cartRecommendedTitle.
  ///
  /// In en, this message translates to:
  /// **'You might also like'**
  String get cartRecommendedTitle;

  /// No description provided for @cartRecommendedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Courses recommended based on your cart'**
  String get cartRecommendedSubtitle;

  /// No description provided for @checkoutCreditCard.
  ///
  /// In en, this message translates to:
  /// **'Credit Card'**
  String get checkoutCreditCard;

  /// No description provided for @checkoutSelectPayment.
  ///
  /// In en, this message translates to:
  /// **'Select Payment Method'**
  String get checkoutSelectPayment;

  /// No description provided for @checkoutCardNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Card Number'**
  String get checkoutCardNumberLabel;

  /// No description provided for @checkoutCardHolderLabel.
  ///
  /// In en, this message translates to:
  /// **'Cardholder Name'**
  String get checkoutCardHolderLabel;

  /// No description provided for @checkoutExpiryLabel.
  ///
  /// In en, this message translates to:
  /// **'Expiry Date'**
  String get checkoutExpiryLabel;

  /// No description provided for @checkoutCVVLabel.
  ///
  /// In en, this message translates to:
  /// **'CVV'**
  String get checkoutCVVLabel;

  /// No description provided for @checkoutPersonalInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get checkoutPersonalInfoTitle;

  /// No description provided for @checkoutFullNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get checkoutFullNameLabel;

  /// No description provided for @checkoutFullNameHint.
  ///
  /// In en, this message translates to:
  /// **'Your full name'**
  String get checkoutFullNameHint;

  /// No description provided for @checkoutFullNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Full name is required'**
  String get checkoutFullNameRequired;

  /// No description provided for @checkoutPhoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get checkoutPhoneLabel;

  /// No description provided for @checkoutPhoneRequired.
  ///
  /// In en, this message translates to:
  /// **'Phone number is required'**
  String get checkoutPhoneRequired;

  /// No description provided for @checkoutPostalLabel.
  ///
  /// In en, this message translates to:
  /// **'Postal Code'**
  String get checkoutPostalLabel;

  /// No description provided for @checkoutPostalRequired.
  ///
  /// In en, this message translates to:
  /// **'Postal code is required'**
  String get checkoutPostalRequired;

  /// No description provided for @checkoutBuyerInfo.
  ///
  /// In en, this message translates to:
  /// **'Buyer Information'**
  String get checkoutBuyerInfo;

  /// No description provided for @checkoutSaveInfo.
  ///
  /// In en, this message translates to:
  /// **'Save info for next time'**
  String get checkoutSaveInfo;

  /// No description provided for @checkoutMoneyBackGuarantee.
  ///
  /// In en, this message translates to:
  /// **'30-Day Money-Back Guarantee'**
  String get checkoutMoneyBackGuarantee;

  /// No description provided for @checkoutContinueToPayment.
  ///
  /// In en, this message translates to:
  /// **'Continue to Payment'**
  String get checkoutContinueToPayment;

  /// No description provided for @checkoutContinueToReview.
  ///
  /// In en, this message translates to:
  /// **'Continue to Review'**
  String get checkoutContinueToReview;

  /// No description provided for @checkoutReviewConfirm.
  ///
  /// In en, this message translates to:
  /// **'Review & Confirm'**
  String get checkoutReviewConfirm;

  /// No description provided for @checkoutStartLearning.
  ///
  /// In en, this message translates to:
  /// **'Start Learning'**
  String get checkoutStartLearning;

  /// No description provided for @checkoutBackHome.
  ///
  /// In en, this message translates to:
  /// **'Back to Home'**
  String get checkoutBackHome;

  /// No description provided for @courseDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Course Details'**
  String get courseDetailsTitle;

  /// No description provided for @courseDetailsShare.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get courseDetailsShare;

  /// No description provided for @courseDetailsWhatYouWillLearn.
  ///
  /// In en, this message translates to:
  /// **'What You\'ll Learn'**
  String get courseDetailsWhatYouWillLearn;

  /// No description provided for @courseDetailsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get courseDetailsLanguage;

  /// No description provided for @courseDetailsCreatedBy.
  ///
  /// In en, this message translates to:
  /// **'Created by'**
  String get courseDetailsCreatedBy;

  /// No description provided for @courseDetailsPreviewLesson.
  ///
  /// In en, this message translates to:
  /// **'Preview Lesson'**
  String get courseDetailsPreviewLesson;

  /// No description provided for @courseDetailsHoursOnDemand.
  ///
  /// In en, this message translates to:
  /// **'hours on-demand video'**
  String get courseDetailsHoursOnDemand;

  /// No description provided for @courseDetailsFullLifetimeAccess.
  ///
  /// In en, this message translates to:
  /// **'Full lifetime access'**
  String get courseDetailsFullLifetimeAccess;

  /// No description provided for @courseDetailsCertifiedCertificate.
  ///
  /// In en, this message translates to:
  /// **'Certificate of completion'**
  String get courseDetailsCertifiedCertificate;

  /// No description provided for @courseDetailsComprehensiveContent.
  ///
  /// In en, this message translates to:
  /// **'Comprehensive content'**
  String get courseDetailsComprehensiveContent;

  /// No description provided for @certTitle.
  ///
  /// In en, this message translates to:
  /// **'Certificate of Completion'**
  String get certTitle;

  /// No description provided for @certStudentNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Student'**
  String get certStudentNameLabel;

  /// No description provided for @certCourseLabel.
  ///
  /// In en, this message translates to:
  /// **'Course'**
  String get certCourseLabel;

  /// No description provided for @certInstructorLabel.
  ///
  /// In en, this message translates to:
  /// **'Instructor'**
  String get certInstructorLabel;

  /// No description provided for @certIssueDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Issue Date'**
  String get certIssueDateLabel;

  /// No description provided for @certCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Certificate ID'**
  String get certCodeLabel;

  /// No description provided for @certVerifiedBadge.
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get certVerifiedBadge;

  /// No description provided for @certDownloadPDF.
  ///
  /// In en, this message translates to:
  /// **'Download PDF'**
  String get certDownloadPDF;

  /// No description provided for @certDownloadPNG.
  ///
  /// In en, this message translates to:
  /// **'Download Image'**
  String get certDownloadPNG;

  /// No description provided for @certCopyVerifyLink.
  ///
  /// In en, this message translates to:
  /// **'Copy Verification Link'**
  String get certCopyVerifyLink;

  /// No description provided for @certShare.
  ///
  /// In en, this message translates to:
  /// **'Share Certificate'**
  String get certShare;

  /// No description provided for @playerTabLessons.
  ///
  /// In en, this message translates to:
  /// **'Lessons'**
  String get playerTabLessons;

  /// No description provided for @playerTabOverview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get playerTabOverview;

  /// No description provided for @playerTabNotes.
  ///
  /// In en, this message translates to:
  /// **'My Notes'**
  String get playerTabNotes;

  /// No description provided for @playerTabQnA.
  ///
  /// In en, this message translates to:
  /// **'Q&A'**
  String get playerTabQnA;

  /// No description provided for @playerNextLesson.
  ///
  /// In en, this message translates to:
  /// **'Next Lesson'**
  String get playerNextLesson;

  /// No description provided for @profileWelcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get profileWelcome;

  /// No description provided for @profileLoginPrompt.
  ///
  /// In en, this message translates to:
  /// **'Sign in to access your profile'**
  String get profileLoginPrompt;

  /// No description provided for @profileLoginOrRegister.
  ///
  /// In en, this message translates to:
  /// **'Sign In / Create Account'**
  String get profileLoginOrRegister;

  /// No description provided for @profileVerifiedStudent.
  ///
  /// In en, this message translates to:
  /// **'Verified Student'**
  String get profileVerifiedStudent;

  /// No description provided for @profileLogout.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get profileLogout;

  /// No description provided for @profileCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get profileCancel;

  /// No description provided for @profileLogoutConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get profileLogoutConfirmTitle;

  /// No description provided for @profileLogoutConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to sign out?'**
  String get profileLogoutConfirmMessage;

  /// No description provided for @profileAccountSettings.
  ///
  /// In en, this message translates to:
  /// **'Account Settings'**
  String get profileAccountSettings;

  /// No description provided for @profileEditProfileSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Edit your personal information'**
  String get profileEditProfileSubtitle;

  /// No description provided for @profileSecurity.
  ///
  /// In en, this message translates to:
  /// **'Account Security'**
  String get profileSecurity;

  /// No description provided for @profileSecuritySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Password & verification'**
  String get profileSecuritySubtitle;

  /// No description provided for @profilePurchaseHistory.
  ///
  /// In en, this message translates to:
  /// **'Purchase History'**
  String get profilePurchaseHistory;

  /// No description provided for @profilePurchaseHistorySubtitle.
  ///
  /// In en, this message translates to:
  /// **'View transaction history'**
  String get profilePurchaseHistorySubtitle;

  /// No description provided for @profileCertificatesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your earned certificates'**
  String get profileCertificatesSubtitle;

  /// No description provided for @profileTeach.
  ///
  /// In en, this message translates to:
  /// **'Teach on EduLab'**
  String get profileTeach;

  /// No description provided for @profileTeachSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Share your expertise with others'**
  String get profileTeachSubtitle;

  /// No description provided for @profilePreferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get profilePreferences;

  /// No description provided for @profilePreferencesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Settings & appearance'**
  String get profilePreferencesSubtitle;

  /// No description provided for @profileNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get profileNotifications;

  /// No description provided for @profileNotificationsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage notifications & alerts'**
  String get profileNotificationsSubtitle;

  /// No description provided for @profileHelpSupport.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get profileHelpSupport;

  /// No description provided for @profileTerms.
  ///
  /// In en, this message translates to:
  /// **'Terms of Use'**
  String get profileTerms;

  /// No description provided for @profilePrivacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get profilePrivacy;

  /// No description provided for @profileAboutEduLab.
  ///
  /// In en, this message translates to:
  /// **'About EduLab'**
  String get profileAboutEduLab;

  /// No description provided for @profileWishlist.
  ///
  /// In en, this message translates to:
  /// **'Wishlist'**
  String get profileWishlist;

  /// No description provided for @securityTitle.
  ///
  /// In en, this message translates to:
  /// **'Account Security'**
  String get securityTitle;

  /// No description provided for @teachTitle.
  ///
  /// In en, this message translates to:
  /// **'Teach on EduLab'**
  String get teachTitle;

  /// No description provided for @notificationsTabAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get notificationsTabAll;

  /// No description provided for @notificationsTabCourses.
  ///
  /// In en, this message translates to:
  /// **'Courses'**
  String get notificationsTabCourses;

  /// No description provided for @notificationsTabPromos.
  ///
  /// In en, this message translates to:
  /// **'Offers'**
  String get notificationsTabPromos;

  /// No description provided for @notificationsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No notifications'**
  String get notificationsEmptyTitle;

  /// No description provided for @notificationsUnread.
  ///
  /// In en, this message translates to:
  /// **'Unread'**
  String get notificationsUnread;

  /// No description provided for @wishlistTitle.
  ///
  /// In en, this message translates to:
  /// **'Wishlist'**
  String get wishlistTitle;

  /// No description provided for @wishlistEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Your wishlist is empty'**
  String get wishlistEmptyTitle;

  /// No description provided for @wishlistEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Save courses you\'re interested in'**
  String get wishlistEmptySubtitle;

  /// No description provided for @wishlistAddToCart.
  ///
  /// In en, this message translates to:
  /// **'Add to Cart'**
  String get wishlistAddToCart;

  /// No description provided for @wishlistRemovedSnackbar.
  ///
  /// In en, this message translates to:
  /// **'Removed from wishlist'**
  String get wishlistRemovedSnackbar;

  /// No description provided for @homeDefaultUser.
  ///
  /// In en, this message translates to:
  /// **'Student'**
  String get homeDefaultUser;

  /// No description provided for @learningOf.
  ///
  /// In en, this message translates to:
  /// **'of'**
  String get learningOf;

  /// No description provided for @cartInCartBadge.
  ///
  /// In en, this message translates to:
  /// **'In Cart'**
  String get cartInCartBadge;

  /// No description provided for @homePromo1Badge.
  ///
  /// In en, this message translates to:
  /// **'Big Sale • Limited Time'**
  String get homePromo1Badge;

  /// No description provided for @homePromo1Title.
  ///
  /// In en, this message translates to:
  /// **'Start Learning at the Best Prices'**
  String get homePromo1Title;

  /// No description provided for @homePromo1Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Up to 65% off on programming, design, and business courses.'**
  String get homePromo1Subtitle;

  /// No description provided for @homePromo1Button.
  ///
  /// In en, this message translates to:
  /// **'Browse Deals'**
  String get homePromo1Button;

  /// No description provided for @homePromo2Badge.
  ///
  /// In en, this message translates to:
  /// **'Certified Career Tracks'**
  String get homePromo2Badge;

  /// No description provided for @homePromo2Title.
  ///
  /// In en, this message translates to:
  /// **'Prepare for Your Dream Tech Career'**
  String get homePromo2Title;

  /// No description provided for @homePromo2Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Complete zero-to-mastery courses with real-world projects and certificates.'**
  String get homePromo2Subtitle;

  /// No description provided for @homePromo2Button.
  ///
  /// In en, this message translates to:
  /// **'Explore Tracks'**
  String get homePromo2Button;

  /// No description provided for @homePromo3Badge.
  ///
  /// In en, this message translates to:
  /// **'Top Industry Instructors'**
  String get homePromo3Badge;

  /// No description provided for @homePromo3Title.
  ///
  /// In en, this message translates to:
  /// **'Learn Directly from Proven Experts'**
  String get homePromo3Title;

  /// No description provided for @homePromo3Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Constantly updated high-quality content to keep you ahead in modern tech.'**
  String get homePromo3Subtitle;

  /// No description provided for @homePromo3Button.
  ///
  /// In en, this message translates to:
  /// **'Start Learning Now'**
  String get homePromo3Button;

  /// No description provided for @homePromoInstructorBadge.
  ///
  /// In en, this message translates to:
  /// **'Teach on EduLab • Share Knowledge'**
  String get homePromoInstructorBadge;

  /// No description provided for @homePromoInstructorTitle.
  ///
  /// In en, this message translates to:
  /// **'Become an Instructor Today'**
  String get homePromoInstructorTitle;

  /// No description provided for @homePromoInstructorSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Inspire learners worldwide, create courses, and earn income teaching what you love.'**
  String get homePromoInstructorSubtitle;

  /// No description provided for @homePromoInstructorButton.
  ///
  /// In en, this message translates to:
  /// **'Apply Now'**
  String get homePromoInstructorButton;

  /// No description provided for @homeSearchFilter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get homeSearchFilter;

  /// No description provided for @securitySectionChangePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get securitySectionChangePassword;

  /// No description provided for @securityCurrentPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Current Password *'**
  String get securityCurrentPasswordLabel;

  /// No description provided for @securityCurrentPasswordError.
  ///
  /// In en, this message translates to:
  /// **'Enter current password'**
  String get securityCurrentPasswordError;

  /// No description provided for @securityNewPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'New Password *'**
  String get securityNewPasswordLabel;

  /// No description provided for @securityNewPasswordError.
  ///
  /// In en, this message translates to:
  /// **'Must be at least 8 characters'**
  String get securityNewPasswordError;

  /// No description provided for @securityConfirmPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm New Password *'**
  String get securityConfirmPasswordLabel;

  /// No description provided for @securityConfirmPasswordError.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get securityConfirmPasswordError;

  /// No description provided for @securityUpdatePasswordBtn.
  ///
  /// In en, this message translates to:
  /// **'Update Password'**
  String get securityUpdatePasswordBtn;

  /// No description provided for @securityPasswordUpdatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Password changed successfully!'**
  String get securityPasswordUpdatedSuccess;

  /// No description provided for @securitySection2FA.
  ///
  /// In en, this message translates to:
  /// **'Two-Factor Authentication (2FA)'**
  String get securitySection2FA;

  /// No description provided for @security2FATitle.
  ///
  /// In en, this message translates to:
  /// **'Two-Factor Authentication'**
  String get security2FATitle;

  /// No description provided for @security2FAEnabledDesc.
  ///
  /// In en, this message translates to:
  /// **'Enabled - Secures your account with a code'**
  String get security2FAEnabledDesc;

  /// No description provided for @security2FADisabledDesc.
  ///
  /// In en, this message translates to:
  /// **'Disabled (Recommended)'**
  String get security2FADisabledDesc;

  /// No description provided for @security2FASetupTitle.
  ///
  /// In en, this message translates to:
  /// **'Enable Two-Factor Authentication'**
  String get security2FASetupTitle;

  /// No description provided for @security2FASetupContent.
  ///
  /// In en, this message translates to:
  /// **'A 6-digit verification code will be sent to your email on new logins.'**
  String get security2FASetupContent;

  /// No description provided for @security2FAEnableNow.
  ///
  /// In en, this message translates to:
  /// **'Enable Now'**
  String get security2FAEnableNow;

  /// No description provided for @security2FAEnabledSuccess.
  ///
  /// In en, this message translates to:
  /// **'Two-Factor Authentication enabled successfully!'**
  String get security2FAEnabledSuccess;

  /// No description provided for @security2FADisabledSuccess.
  ///
  /// In en, this message translates to:
  /// **'Two-Factor Authentication disabled'**
  String get security2FADisabledSuccess;

  /// No description provided for @securitySectionSessions.
  ///
  /// In en, this message translates to:
  /// **'Active Sessions & Devices'**
  String get securitySectionSessions;

  /// No description provided for @securityLogoutAllDevices.
  ///
  /// In en, this message translates to:
  /// **'Log Out All Devices'**
  String get securityLogoutAllDevices;

  /// No description provided for @securityThisDevice.
  ///
  /// In en, this message translates to:
  /// **'This Device'**
  String get securityThisDevice;

  /// No description provided for @securitySessionRevokedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Session ended and device logged out.'**
  String get securitySessionRevokedSuccess;

  /// No description provided for @securityAllSessionsRevokedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Logged out from all other devices.'**
  String get securityAllSessionsRevokedSuccess;

  /// No description provided for @purchaseHistoryInvoiceCertified.
  ///
  /// In en, this message translates to:
  /// **'Certified E-Invoice'**
  String get purchaseHistoryInvoiceCertified;

  /// No description provided for @purchaseHistoryInvoiceNumber.
  ///
  /// In en, this message translates to:
  /// **'Invoice Number'**
  String get purchaseHistoryInvoiceNumber;

  /// No description provided for @purchaseHistoryCourse.
  ///
  /// In en, this message translates to:
  /// **'Course'**
  String get purchaseHistoryCourse;

  /// No description provided for @purchaseHistoryPaymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Payment Method'**
  String get purchaseHistoryPaymentMethod;

  /// No description provided for @purchaseHistoryTotalAmount.
  ///
  /// In en, this message translates to:
  /// **'Total Amount:'**
  String get purchaseHistoryTotalAmount;

  /// No description provided for @purchaseHistoryClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get purchaseHistoryClose;

  /// No description provided for @purchaseHistoryDownloadPdf.
  ///
  /// In en, this message translates to:
  /// **'Download PDF'**
  String get purchaseHistoryDownloadPdf;

  /// No description provided for @purchaseHistoryPdfDownloaded.
  ///
  /// In en, this message translates to:
  /// **'Invoice PDF downloaded successfully'**
  String get purchaseHistoryPdfDownloaded;

  /// No description provided for @purchaseHistoryRefundRequestTitle.
  ///
  /// In en, this message translates to:
  /// **'Request a Refund'**
  String get purchaseHistoryRefundRequestTitle;

  /// No description provided for @purchaseHistoryRefundPolicy.
  ///
  /// In en, this message translates to:
  /// **'According to EduLab\'s 30-day money-back guarantee, you can get a full refund to your original payment method.'**
  String get purchaseHistoryRefundPolicy;

  /// No description provided for @purchaseHistoryRefundReasonHint.
  ///
  /// In en, this message translates to:
  /// **'Reason for refund (optional)...'**
  String get purchaseHistoryRefundReasonHint;

  /// No description provided for @purchaseHistoryConfirmRefund.
  ///
  /// In en, this message translates to:
  /// **'Confirm Refund'**
  String get purchaseHistoryConfirmRefund;

  /// No description provided for @purchaseHistoryRefundSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Refund request submitted successfully (3-5 business days).'**
  String get purchaseHistoryRefundSubmitted;

  /// No description provided for @purchaseHistoryInstructor.
  ///
  /// In en, this message translates to:
  /// **'Instructor'**
  String get purchaseHistoryInstructor;

  /// No description provided for @purchaseHistoryRequestRefundBtn.
  ///
  /// In en, this message translates to:
  /// **'Request Refund'**
  String get purchaseHistoryRequestRefundBtn;

  /// No description provided for @purchaseHistoryInvoiceBtn.
  ///
  /// In en, this message translates to:
  /// **'Invoice'**
  String get purchaseHistoryInvoiceBtn;

  /// No description provided for @purchaseHistoryStatusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get purchaseHistoryStatusCompleted;

  /// No description provided for @purchaseHistoryStatusRefunded.
  ///
  /// In en, this message translates to:
  /// **'Refunded'**
  String get purchaseHistoryStatusRefunded;

  /// No description provided for @purchaseHistoryStatusProcessingRefund.
  ///
  /// In en, this message translates to:
  /// **'Processing Refund'**
  String get purchaseHistoryStatusProcessingRefund;

  /// No description provided for @editProfileSectionBasicInfo.
  ///
  /// In en, this message translates to:
  /// **'Basic Information'**
  String get editProfileSectionBasicInfo;

  /// No description provided for @editProfileFullNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Full Name *'**
  String get editProfileFullNameLabel;

  /// No description provided for @editProfileFullNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter full name'**
  String get editProfileFullNameHint;

  /// No description provided for @editProfileFullNameError.
  ///
  /// In en, this message translates to:
  /// **'Please enter full name'**
  String get editProfileFullNameError;

  /// No description provided for @editProfileHeadlineLabel.
  ///
  /// In en, this message translates to:
  /// **'Professional Headline'**
  String get editProfileHeadlineLabel;

  /// No description provided for @editProfileHeadlineHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Senior Flutter Developer'**
  String get editProfileHeadlineHint;

  /// No description provided for @editProfileLocationLabel.
  ///
  /// In en, this message translates to:
  /// **'City / Country'**
  String get editProfileLocationLabel;

  /// No description provided for @editProfileLocationHint.
  ///
  /// In en, this message translates to:
  /// **'Riyadh, Saudi Arabia'**
  String get editProfileLocationHint;

  /// No description provided for @editProfilePhoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Mobile Phone'**
  String get editProfilePhoneLabel;

  /// No description provided for @editProfileBioLabel.
  ///
  /// In en, this message translates to:
  /// **'About Me (Bio)'**
  String get editProfileBioLabel;

  /// No description provided for @editProfileBioHint.
  ///
  /// In en, this message translates to:
  /// **'Write a brief summary of your interests and experience...'**
  String get editProfileBioHint;

  /// No description provided for @editProfileSectionLinks.
  ///
  /// In en, this message translates to:
  /// **'Links & Professional Networks'**
  String get editProfileSectionLinks;

  /// No description provided for @editProfileWebsiteLabel.
  ///
  /// In en, this message translates to:
  /// **'Personal Website'**
  String get editProfileWebsiteLabel;

  /// No description provided for @editProfileSectionEmail.
  ///
  /// In en, this message translates to:
  /// **'Registered Email'**
  String get editProfileSectionEmail;

  /// No description provided for @editProfileEmailDesc.
  ///
  /// In en, this message translates to:
  /// **'Linked to your account for login and certificates'**
  String get editProfileEmailDesc;

  /// No description provided for @editProfileEmailVerified.
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get editProfileEmailVerified;

  /// No description provided for @editProfileSaveChangesBtn.
  ///
  /// In en, this message translates to:
  /// **'Save & Update Profile'**
  String get editProfileSaveChangesBtn;

  /// No description provided for @editProfileSavedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully!'**
  String get editProfileSavedSuccess;

  /// No description provided for @editProfileChangeAvatarTitle.
  ///
  /// In en, this message translates to:
  /// **'Change Profile Picture'**
  String get editProfileChangeAvatarTitle;

  /// No description provided for @editProfileTakePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take photo with camera'**
  String get editProfileTakePhoto;

  /// No description provided for @editProfileChooseGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from gallery'**
  String get editProfileChooseGallery;

  /// No description provided for @editProfilePhotoUpdatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Profile picture updated successfully'**
  String get editProfilePhotoUpdatedSuccess;

  /// No description provided for @teachJoinInstructorTitle.
  ///
  /// In en, this message translates to:
  /// **'Join as an Instructor'**
  String get teachJoinInstructorTitle;

  /// No description provided for @teachJoinInstructorSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Publish courses and share your expertise with thousands of students.'**
  String get teachJoinInstructorSubtitle;

  /// No description provided for @teachStep1Title.
  ///
  /// In en, this message translates to:
  /// **'Personal Info'**
  String get teachStep1Title;

  /// No description provided for @teachStep2Title.
  ///
  /// In en, this message translates to:
  /// **'Experience & Skills'**
  String get teachStep2Title;

  /// No description provided for @teachStep3Title.
  ///
  /// In en, this message translates to:
  /// **'Confirm Application'**
  String get teachStep3Title;

  /// No description provided for @teachStep1Header.
  ///
  /// In en, this message translates to:
  /// **'1. Personal & Professional Info'**
  String get teachStep1Header;

  /// No description provided for @teachFullNameArabicLabel.
  ///
  /// In en, this message translates to:
  /// **'Full Name *'**
  String get teachFullNameArabicLabel;

  /// No description provided for @teachFullNameArabicHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. John Doe'**
  String get teachFullNameArabicHint;

  /// No description provided for @teachHeadlineLabel.
  ///
  /// In en, this message translates to:
  /// **'Professional Title *'**
  String get teachHeadlineLabel;

  /// No description provided for @teachHeadlineHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Senior Software Architect'**
  String get teachHeadlineHint;

  /// No description provided for @teachPhoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Contact Phone *'**
  String get teachPhoneLabel;

  /// No description provided for @teachCountryLabel.
  ///
  /// In en, this message translates to:
  /// **'Country of Residence *'**
  String get teachCountryLabel;

  /// No description provided for @teachBioLabel.
  ///
  /// In en, this message translates to:
  /// **'Bio & Past Experience *'**
  String get teachBioLabel;

  /// No description provided for @teachBioHint.
  ///
  /// In en, this message translates to:
  /// **'Write a brief summary of your career and past projects...'**
  String get teachBioHint;

  /// No description provided for @teachNextStepSkills.
  ///
  /// In en, this message translates to:
  /// **'Continue: Experience & Skills'**
  String get teachNextStepSkills;

  /// No description provided for @teachStep2Header.
  ///
  /// In en, this message translates to:
  /// **'2. Course Content & Skills'**
  String get teachStep2Header;

  /// No description provided for @teachTopicLabel.
  ///
  /// In en, this message translates to:
  /// **'Proposed Course Topic *'**
  String get teachTopicLabel;

  /// No description provided for @teachTopicHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Flutter Development from Scratch'**
  String get teachTopicHint;

  /// No description provided for @teachYearsExperienceLabel.
  ///
  /// In en, this message translates to:
  /// **'Years of Experience *'**
  String get teachYearsExperienceLabel;

  /// No description provided for @teachVideoLinkLabel.
  ///
  /// In en, this message translates to:
  /// **'Sample Teaching Video Link *'**
  String get teachVideoLinkLabel;

  /// No description provided for @teachTargetAudienceLabel.
  ///
  /// In en, this message translates to:
  /// **'Target Audience *'**
  String get teachTargetAudienceLabel;

  /// No description provided for @teachAudienceBeginners.
  ///
  /// In en, this message translates to:
  /// **'Complete Beginners'**
  String get teachAudienceBeginners;

  /// No description provided for @teachAudienceIntermediate.
  ///
  /// In en, this message translates to:
  /// **'Beginner & Intermediate'**
  String get teachAudienceIntermediate;

  /// No description provided for @teachAudienceAdvanced.
  ///
  /// In en, this message translates to:
  /// **'Advanced & Professional'**
  String get teachAudienceAdvanced;

  /// No description provided for @teachAudienceAll.
  ///
  /// In en, this message translates to:
  /// **'All Levels'**
  String get teachAudienceAll;

  /// No description provided for @teachSkillsCoveredLabel.
  ///
  /// In en, this message translates to:
  /// **'Skills & Technologies Covered *'**
  String get teachSkillsCoveredLabel;

  /// No description provided for @teachAddSkillHint.
  ///
  /// In en, this message translates to:
  /// **'Add skill (e.g. GraphQL)...'**
  String get teachAddSkillHint;

  /// No description provided for @teachAddSkillBtn.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get teachAddSkillBtn;

  /// No description provided for @teachNextStepConfirm.
  ///
  /// In en, this message translates to:
  /// **'Continue: Confirm Application'**
  String get teachNextStepConfirm;

  /// No description provided for @teachStep3Header.
  ///
  /// In en, this message translates to:
  /// **'3. Payout Details & Agreement'**
  String get teachStep3Header;

  /// No description provided for @teachPayoutMethodLabel.
  ///
  /// In en, this message translates to:
  /// **'Payout Method *'**
  String get teachPayoutMethodLabel;

  /// No description provided for @teachPayoutMethodBank.
  ///
  /// In en, this message translates to:
  /// **'Direct Bank Transfer (IBAN)'**
  String get teachPayoutMethodBank;

  /// No description provided for @teachPayoutMethodPaypal.
  ///
  /// In en, this message translates to:
  /// **'Verified PayPal Account'**
  String get teachPayoutMethodPaypal;

  /// No description provided for @teachPayoutMethodPayoneer.
  ///
  /// In en, this message translates to:
  /// **'Payoneer Card'**
  String get teachPayoutMethodPayoneer;

  /// No description provided for @teachIbanDetailsLabel.
  ///
  /// In en, this message translates to:
  /// **'Account Details / IBAN *'**
  String get teachIbanDetailsLabel;

  /// No description provided for @teachApplicationSummary.
  ///
  /// In en, this message translates to:
  /// **'Application Summary:'**
  String get teachApplicationSummary;

  /// No description provided for @teachApplicantName.
  ///
  /// In en, this message translates to:
  /// **'Applicant'**
  String get teachApplicantName;

  /// No description provided for @teachApplicantHeadline.
  ///
  /// In en, this message translates to:
  /// **'Specialty'**
  String get teachApplicantHeadline;

  /// No description provided for @teachApplicantTopic.
  ///
  /// In en, this message translates to:
  /// **'Course Topic'**
  String get teachApplicantTopic;

  /// No description provided for @teachApplicantSkillsCount.
  ///
  /// In en, this message translates to:
  /// **'Skills Count'**
  String get teachApplicantSkillsCount;

  /// No description provided for @teachSkillsUnit.
  ///
  /// In en, this message translates to:
  /// **'skills'**
  String get teachSkillsUnit;

  /// No description provided for @teachAgreeTermsLabel.
  ///
  /// In en, this message translates to:
  /// **'I agree to EduLab\'s instructor terms, conditions, and intellectual property agreement.'**
  String get teachAgreeTermsLabel;

  /// No description provided for @teachSubmitApplicationBtn.
  ///
  /// In en, this message translates to:
  /// **'Submit Instructor Application'**
  String get teachSubmitApplicationBtn;

  /// No description provided for @teachPrevStepBtn.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get teachPrevStepBtn;

  /// No description provided for @teachWhyEduLabTitle.
  ///
  /// In en, this message translates to:
  /// **'Why Teach on EduLab?'**
  String get teachWhyEduLabTitle;

  /// No description provided for @teachProp1Title.
  ///
  /// In en, this message translates to:
  /// **'Rewarding & Fair Revenue'**
  String get teachProp1Title;

  /// No description provided for @teachProp1Desc.
  ///
  /// In en, this message translates to:
  /// **'Earn up to 80% revenue share from your course sales with no hidden fees.'**
  String get teachProp1Desc;

  /// No description provided for @teachProp2Title.
  ///
  /// In en, this message translates to:
  /// **'Reach Thousands of Students'**
  String get teachProp2Title;

  /// No description provided for @teachProp2Desc.
  ///
  /// In en, this message translates to:
  /// **'Market your course to a massive active learning community.'**
  String get teachProp2Desc;

  /// No description provided for @teachProp3Title.
  ///
  /// In en, this message translates to:
  /// **'Full Production & Tech Support'**
  String get teachProp3Title;

  /// No description provided for @teachProp3Desc.
  ///
  /// In en, this message translates to:
  /// **'Our team helps you optimize audio, video quality, and curriculum design.'**
  String get teachProp3Desc;

  /// No description provided for @teachSuccessDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Application Received Successfully!'**
  String get teachSuccessDialogTitle;

  /// No description provided for @teachSuccessDialogDesc.
  ///
  /// In en, this message translates to:
  /// **'Thank you for joining EduLab instructors. Our academic review team will review your application and contact you within 48 hours.'**
  String get teachSuccessDialogDesc;

  /// No description provided for @teachSuccessDialogOk.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get teachSuccessDialogOk;

  /// No description provided for @teachAddOneSkillError.
  ///
  /// In en, this message translates to:
  /// **'Please add at least one skill'**
  String get teachAddOneSkillError;

  /// No description provided for @teachAgreeTermsError.
  ///
  /// In en, this message translates to:
  /// **'Please agree to the instructor terms'**
  String get teachAgreeTermsError;

  /// No description provided for @commonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// No description provided for @commonClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get commonClose;

  /// No description provided for @myCertificatesBannerTitle.
  ///
  /// In en, this message translates to:
  /// **'Accredited Certificates'**
  String get myCertificatesBannerTitle;

  /// No description provided for @myCertificatesBannerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'All certificates are accredited and verified with a unique ID from EduLab'**
  String get myCertificatesBannerSubtitle;

  /// No description provided for @certBadgeVerified100.
  ///
  /// In en, this message translates to:
  /// **'100% Accredited'**
  String get certBadgeVerified100;

  /// No description provided for @certCodeCopied.
  ///
  /// In en, this message translates to:
  /// **'Certificate code copied'**
  String get certCodeCopied;

  /// No description provided for @certGrantedTo.
  ///
  /// In en, this message translates to:
  /// **'Granted to'**
  String get certGrantedTo;

  /// No description provided for @certViewAndDownload.
  ///
  /// In en, this message translates to:
  /// **'View & Download Certificate'**
  String get certViewAndDownload;

  /// No description provided for @certIssuerLabel.
  ///
  /// In en, this message translates to:
  /// **'Issuing Authority'**
  String get certIssuerLabel;

  /// No description provided for @certIssuerName.
  ///
  /// In en, this message translates to:
  /// **'EduLab Interactive Learning Academy'**
  String get certIssuerName;

  /// No description provided for @certEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No certificates earned yet'**
  String get certEmptyTitle;

  /// No description provided for @certEmptyDesc.
  ///
  /// In en, this message translates to:
  /// **'Complete 100% of any enrolled course and pass all requirements to receive an accredited certificate with an official verification ID.'**
  String get certEmptyDesc;

  /// No description provided for @certEmptyAction.
  ///
  /// In en, this message translates to:
  /// **'Continue My Courses'**
  String get certEmptyAction;

  /// No description provided for @certDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Certificate Details & Information'**
  String get certDetailsTitle;

  /// No description provided for @certCopyLinkSuccess.
  ///
  /// In en, this message translates to:
  /// **'Direct verification link copied to clipboard!'**
  String get certCopyLinkSuccess;

  /// No description provided for @certShareSuccess.
  ///
  /// In en, this message translates to:
  /// **'Certificate details and link copied for sharing!'**
  String get certShareSuccess;

  /// No description provided for @purchaseHistoryTaxInvoiceCertified.
  ///
  /// In en, this message translates to:
  /// **'Official Certified Tax Invoice'**
  String get purchaseHistoryTaxInvoiceCertified;

  /// No description provided for @purchaseHistoryInvoiceNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Order / Invoice ID'**
  String get purchaseHistoryInvoiceNumberLabel;

  /// No description provided for @purchaseHistoryCourseNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Course Name'**
  String get purchaseHistoryCourseNameLabel;

  /// No description provided for @purchaseHistoryPurchaseDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Purchase Date'**
  String get purchaseHistoryPurchaseDateLabel;

  /// No description provided for @purchaseHistoryPaymentMethodLabel.
  ///
  /// In en, this message translates to:
  /// **'Payment Method'**
  String get purchaseHistoryPaymentMethodLabel;

  /// No description provided for @purchaseHistoryPaymentMethodValue.
  ///
  /// In en, this message translates to:
  /// **'Credit Card / Stripe (Online)'**
  String get purchaseHistoryPaymentMethodValue;

  /// No description provided for @purchaseHistoryOrderStatusLabel.
  ///
  /// In en, this message translates to:
  /// **'Order Status'**
  String get purchaseHistoryOrderStatusLabel;

  /// No description provided for @purchaseHistoryStatusPendingReview.
  ///
  /// In en, this message translates to:
  /// **'Pending Refund Review'**
  String get purchaseHistoryStatusPendingReview;

  /// No description provided for @purchaseHistoryCopyInvoiceBtn.
  ///
  /// In en, this message translates to:
  /// **'Copy Invoice Number'**
  String get purchaseHistoryCopyInvoiceBtn;

  /// No description provided for @purchaseHistoryRefundReasonLabel.
  ///
  /// In en, this message translates to:
  /// **'Refund Request Reason:'**
  String get purchaseHistoryRefundReasonLabel;

  /// No description provided for @purchaseHistoryRefundReasonEmptyError.
  ///
  /// In en, this message translates to:
  /// **'Please enter a reason for your refund request'**
  String get purchaseHistoryRefundReasonEmptyError;

  /// No description provided for @purchaseHistorySubmittingRefund.
  ///
  /// In en, this message translates to:
  /// **'Submitting request...'**
  String get purchaseHistorySubmittingRefund;

  /// No description provided for @purchaseHistoryPaidDate.
  ///
  /// In en, this message translates to:
  /// **'Payment Date'**
  String get purchaseHistoryPaidDate;

  /// No description provided for @purchaseHistoryEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No purchase history yet'**
  String get purchaseHistoryEmptyTitle;

  /// No description provided for @purchaseHistoryEmptyDesc.
  ///
  /// In en, this message translates to:
  /// **'You haven\'t purchased any courses yet.\nYour orders and invoices will appear here once completed.'**
  String get purchaseHistoryEmptyDesc;

  /// No description provided for @purchaseHistoryExploreCourses.
  ///
  /// In en, this message translates to:
  /// **'Explore Courses Now'**
  String get purchaseHistoryExploreCourses;

  /// No description provided for @profileMyCourses.
  ///
  /// In en, this message translates to:
  /// **'My Courses'**
  String get profileMyCourses;

  /// No description provided for @profileMyCoursesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Track progress in your enrolled courses'**
  String get profileMyCoursesSubtitle;

  /// No description provided for @profileWishlistSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Courses saved in your wishlist'**
  String get profileWishlistSubtitle;

  /// No description provided for @navMyLearning.
  ///
  /// In en, this message translates to:
  /// **'My Learning'**
  String get navMyLearning;

  /// No description provided for @profileLogoutSafeNote.
  ///
  /// In en, this message translates to:
  /// **'Your data, courses, and certificates are completely safe. You can continue learning anytime by logging back in.'**
  String get profileLogoutSafeNote;

  /// No description provided for @learningRemainingHours.
  ///
  /// In en, this message translates to:
  /// **'{hours} hours left'**
  String learningRemainingHours(String hours);

  /// No description provided for @learningCompletedFull.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get learningCompletedFull;

  /// No description provided for @learningFilterNotStarted.
  ///
  /// In en, this message translates to:
  /// **'Not Started'**
  String get learningFilterNotStarted;

  /// No description provided for @wishlistTopRatedBadge.
  ///
  /// In en, this message translates to:
  /// **'Top Rated'**
  String get wishlistTopRatedBadge;

  /// No description provided for @wishlistFeaturedBadge.
  ///
  /// In en, this message translates to:
  /// **'Featured'**
  String get wishlistFeaturedBadge;

  /// Wishlist discount badge
  ///
  /// In en, this message translates to:
  /// **'{percent}% OFF'**
  String wishlistDiscountBadge(String percent);

  /// No description provided for @courseFree.
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get courseFree;

  /// No description provided for @badgeBestseller.
  ///
  /// In en, this message translates to:
  /// **'Bestseller'**
  String get badgeBestseller;

  /// No description provided for @badgeTopRated.
  ///
  /// In en, this message translates to:
  /// **'Top Rated'**
  String get badgeTopRated;

  /// No description provided for @badgeFeatured.
  ///
  /// In en, this message translates to:
  /// **'Featured'**
  String get badgeFeatured;

  /// No description provided for @badgeRecommended.
  ///
  /// In en, this message translates to:
  /// **'Recommended for you'**
  String get badgeRecommended;

  /// No description provided for @badgeNew.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get badgeNew;

  /// No description provided for @courseWord.
  ///
  /// In en, this message translates to:
  /// **'Course'**
  String get courseWord;

  /// No description provided for @coursesCountText.
  ///
  /// In en, this message translates to:
  /// **'{count}+ Courses'**
  String coursesCountText(String count);

  /// No description provided for @studentsCountText.
  ///
  /// In en, this message translates to:
  /// **'{count} Students'**
  String studentsCountText(String count);

  /// No description provided for @hoursCountText.
  ///
  /// In en, this message translates to:
  /// **'{count} Hours'**
  String hoursCountText(String count);

  /// No description provided for @certifiedInstructor.
  ///
  /// In en, this message translates to:
  /// **'Certified Instructor'**
  String get certifiedInstructor;

  /// No description provided for @expertCertifiedInstructor.
  ///
  /// In en, this message translates to:
  /// **'Expert & Certified Instructor'**
  String get expertCertifiedInstructor;

  /// No description provided for @defaultCourseTitle.
  ///
  /// In en, this message translates to:
  /// **'Educational Course'**
  String get defaultCourseTitle;

  /// No description provided for @categoryWord.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get categoryWord;

  /// No description provided for @previewCourseVideo.
  ///
  /// In en, this message translates to:
  /// **'Preview Course Video'**
  String get previewCourseVideo;

  /// No description provided for @freeSection.
  ///
  /// In en, this message translates to:
  /// **'Free Section'**
  String get freeSection;

  /// No description provided for @freeDemoVideo.
  ///
  /// In en, this message translates to:
  /// **'Free Demo Video'**
  String get freeDemoVideo;

  /// No description provided for @articleLecture.
  ///
  /// In en, this message translates to:
  /// **'Article Lecture'**
  String get articleLecture;

  /// No description provided for @articleViewer.
  ///
  /// In en, this message translates to:
  /// **'Article Viewer'**
  String get articleViewer;

  /// No description provided for @courseVideoPlayer.
  ///
  /// In en, this message translates to:
  /// **'Course Video Player'**
  String get courseVideoPlayer;

  /// No description provided for @playingNow.
  ///
  /// In en, this message translates to:
  /// **'Playing Now'**
  String get playingNow;

  /// No description provided for @readingNow.
  ///
  /// In en, this message translates to:
  /// **'Reading Now'**
  String get readingNow;

  /// No description provided for @noLecturesInFreeSection.
  ///
  /// In en, this message translates to:
  /// **'No lectures in free section'**
  String get noLecturesInFreeSection;

  /// No description provided for @freeLecturesCount.
  ///
  /// In en, this message translates to:
  /// **'{count} free lectures'**
  String freeLecturesCount(String count);

  /// No description provided for @enrollInFullCourse.
  ///
  /// In en, this message translates to:
  /// **'Enroll in Full Course'**
  String get enrollInFullCourse;

  /// No description provided for @articleWord.
  ///
  /// In en, this message translates to:
  /// **'Article'**
  String get articleWord;

  /// No description provided for @videoWord.
  ///
  /// In en, this message translates to:
  /// **'Video'**
  String get videoWord;

  /// No description provided for @quizWord.
  ///
  /// In en, this message translates to:
  /// **'Quiz'**
  String get quizWord;

  /// No description provided for @courseShareCopied.
  ///
  /// In en, this message translates to:
  /// **'Course link copied to clipboard!'**
  String get courseShareCopied;

  /// No description provided for @addedToCartSnackbar.
  ///
  /// In en, this message translates to:
  /// **'Added to cart'**
  String get addedToCartSnackbar;

  /// No description provided for @viewCartAction.
  ///
  /// In en, this message translates to:
  /// **'View Cart'**
  String get viewCartAction;

  /// No description provided for @inCartBadge.
  ///
  /// In en, this message translates to:
  /// **'In Cart ✓'**
  String get inCartBadge;

  /// No description provided for @addToCartButton.
  ///
  /// In en, this message translates to:
  /// **'Add to Cart'**
  String get addToCartButton;

  /// No description provided for @wishlistAddedSnackbar.
  ///
  /// In en, this message translates to:
  /// **'Course added to wishlist successfully'**
  String get wishlistAddedSnackbar;

  /// No description provided for @wishlistRemovedSuccessSnackbar.
  ///
  /// In en, this message translates to:
  /// **'Course removed from wishlist'**
  String get wishlistRemovedSuccessSnackbar;

  /// No description provided for @lessonCompletedAll.
  ///
  /// In en, this message translates to:
  /// **'Congratulations! You have completed all lessons in this course.'**
  String get lessonCompletedAll;

  /// No description provided for @noteAddedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Note added successfully'**
  String get noteAddedSuccess;

  /// No description provided for @lessonAlreadyDownloaded.
  ///
  /// In en, this message translates to:
  /// **'Lesson is already saved for offline viewing'**
  String get lessonAlreadyDownloaded;

  /// No description provided for @lessonLinkCopied.
  ///
  /// In en, this message translates to:
  /// **'Lesson link copied to clipboard'**
  String get lessonLinkCopied;

  /// No description provided for @contentReportThanks.
  ///
  /// In en, this message translates to:
  /// **'Thank you for your feedback, the lesson will be reviewed by our team'**
  String get contentReportThanks;

  /// No description provided for @courseCompletionCertificate.
  ///
  /// In en, this message translates to:
  /// **'Course Completion Certificate'**
  String get courseCompletionCertificate;

  /// No description provided for @reportContentIssue.
  ///
  /// In en, this message translates to:
  /// **'Report an issue with content'**
  String get reportContentIssue;

  /// No description provided for @loginOrSocial.
  ///
  /// In en, this message translates to:
  /// **'Or sign in with'**
  String get loginOrSocial;

  /// No description provided for @loginSuccessSnackbar.
  ///
  /// In en, this message translates to:
  /// **'Signed in successfully'**
  String get loginSuccessSnackbar;

  /// No description provided for @cartClearDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Clear Cart'**
  String get cartClearDialogTitle;

  /// No description provided for @cartClearDialogMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove all courses from your shopping cart?'**
  String get cartClearDialogMessage;

  /// No description provided for @cartClearConfirmButton.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get cartClearConfirmButton;

  /// No description provided for @guestWelcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to EduLab'**
  String get guestWelcomeTitle;

  /// No description provided for @guestWelcomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to track your courses and certificates'**
  String get guestWelcomeSubtitle;

  /// No description provided for @securitySetup2FATitle.
  ///
  /// In en, this message translates to:
  /// **'Two-Factor Authentication Setup (2FA)'**
  String get securitySetup2FATitle;

  /// No description provided for @securityScanQRCode.
  ///
  /// In en, this message translates to:
  /// **'Scan the QR code with your authenticator app'**
  String get securityScanQRCode;

  /// No description provided for @securitySecretKeyManual.
  ///
  /// In en, this message translates to:
  /// **'Secret key (for manual entry)'**
  String get securitySecretKeyManual;

  /// No description provided for @securitySecretKeyCopied.
  ///
  /// In en, this message translates to:
  /// **'Secret key copied'**
  String get securitySecretKeyCopied;

  /// No description provided for @securityEnter6DigitCode.
  ///
  /// In en, this message translates to:
  /// **'Enter verification code (6 digits):'**
  String get securityEnter6DigitCode;

  /// No description provided for @securityConfirmEnable2FABtn.
  ///
  /// In en, this message translates to:
  /// **'Confirm & Enable 2FA'**
  String get securityConfirmEnable2FABtn;

  /// No description provided for @securityEnter6DigitsError.
  ///
  /// In en, this message translates to:
  /// **'Please enter the 6-digit verification code'**
  String get securityEnter6DigitsError;

  /// No description provided for @securityLogoutAllDevicesTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign Out from All Devices'**
  String get securityLogoutAllDevicesTitle;

  /// No description provided for @securityLogoutAllDevicesMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to sign out from all other devices?\nYou will remain signed in on this device only.'**
  String get securityLogoutAllDevicesMessage;

  /// No description provided for @securityLogoutAllDevicesConfirmBtn.
  ///
  /// In en, this message translates to:
  /// **'Sign Out All'**
  String get securityLogoutAllDevicesConfirmBtn;

  /// No description provided for @securityDisable2FAModalTitle.
  ///
  /// In en, this message translates to:
  /// **'Disable Two-Factor Authentication'**
  String get securityDisable2FAModalTitle;

  /// No description provided for @securityDisable2FAModalMessage.
  ///
  /// In en, this message translates to:
  /// **'Disabling this feature will reduce your account security.\nAre you sure you want to proceed?'**
  String get securityDisable2FAModalMessage;

  /// No description provided for @securityDisable2FAConfirmBtn.
  ///
  /// In en, this message translates to:
  /// **'Disable 2FA'**
  String get securityDisable2FAConfirmBtn;

  /// No description provided for @securityNoOtherSessions.
  ///
  /// In en, this message translates to:
  /// **'No other active sessions or devices'**
  String get securityNoOtherSessions;

  /// No description provided for @securityCurrentDeviceOnly.
  ///
  /// In en, this message translates to:
  /// **'You are currently signed in on this device only'**
  String get securityCurrentDeviceOnly;

  /// No description provided for @securityShowLessDevices.
  ///
  /// In en, this message translates to:
  /// **'Show fewer devices'**
  String get securityShowLessDevices;

  /// No description provided for @securityShowAllDevicesCount.
  ///
  /// In en, this message translates to:
  /// **'Show all devices ({count})'**
  String securityShowAllDevicesCount(String count);

  /// No description provided for @securityUpdatingPassword.
  ///
  /// In en, this message translates to:
  /// **'Updating password...'**
  String get securityUpdatingPassword;

  /// No description provided for @editProfileTakePhotoDesc.
  ///
  /// In en, this message translates to:
  /// **'Take a new photo with camera'**
  String get editProfileTakePhotoDesc;

  /// No description provided for @editProfileChooseGalleryDesc.
  ///
  /// In en, this message translates to:
  /// **'Choose a saved photo from gallery'**
  String get editProfileChooseGalleryDesc;

  /// No description provided for @editProfileHeadlineError.
  ///
  /// In en, this message translates to:
  /// **'Headline is required'**
  String get editProfileHeadlineError;

  /// No description provided for @editProfileLocationError.
  ///
  /// In en, this message translates to:
  /// **'Location is required'**
  String get editProfileLocationError;

  /// No description provided for @editProfilePhoneError.
  ///
  /// In en, this message translates to:
  /// **'Phone number is required'**
  String get editProfilePhoneError;

  /// No description provided for @editProfileBioError.
  ///
  /// In en, this message translates to:
  /// **'Bio is required'**
  String get editProfileBioError;

  /// No description provided for @editProfileSavingChanges.
  ///
  /// In en, this message translates to:
  /// **'Saving changes...'**
  String get editProfileSavingChanges;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// No description provided for @teachFullNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter full name'**
  String get teachFullNameRequired;

  /// No description provided for @teachHeadlineRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter professional headline'**
  String get teachHeadlineRequired;

  /// No description provided for @teachPhoneRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter phone number'**
  String get teachPhoneRequired;

  /// No description provided for @teachCountryRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter country of residence'**
  String get teachCountryRequired;

  /// No description provided for @teachBioMinLength.
  ///
  /// In en, this message translates to:
  /// **'Please write a bio of at least 20 characters'**
  String get teachBioMinLength;

  /// No description provided for @teachSubmittingApplication.
  ///
  /// In en, this message translates to:
  /// **'Submitting...'**
  String get teachSubmittingApplication;

  /// No description provided for @wishlistFailedAddToCart.
  ///
  /// In en, this message translates to:
  /// **'Failed to add course to cart'**
  String get wishlistFailedAddToCart;

  /// No description provided for @cartClearAllTitle.
  ///
  /// In en, this message translates to:
  /// **'Clear All Cart Items?'**
  String get cartClearAllTitle;

  /// No description provided for @cartClearAllMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove all {count} courses from your shopping cart?'**
  String cartClearAllMessage(String count);

  /// No description provided for @cartClearAllHint.
  ///
  /// In en, this message translates to:
  /// **'All courses will be removed from your cart. You can add them back anytime.'**
  String get cartClearAllHint;

  /// No description provided for @cartClearAllConfirm.
  ///
  /// In en, this message translates to:
  /// **'Clear All ({count})'**
  String cartClearAllConfirm(String count);

  /// No description provided for @cartClearedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Cart cleared successfully'**
  String get cartClearedSuccess;

  /// No description provided for @cartClearFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to clear cart'**
  String get cartClearFailed;

  /// No description provided for @cartViewWishlistCount.
  ///
  /// In en, this message translates to:
  /// **'View Wishlist Items ({count})'**
  String cartViewWishlistCount(String count);

  /// No description provided for @cartGoToWishlist.
  ///
  /// In en, this message translates to:
  /// **'Go to Wishlist'**
  String get cartGoToWishlist;

  /// No description provided for @wishlistClearAllTitle.
  ///
  /// In en, this message translates to:
  /// **'Clear All Wishlist Items?'**
  String get wishlistClearAllTitle;

  /// No description provided for @wishlistClearAllMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove all {count} courses from your wishlist?'**
  String wishlistClearAllMessage(String count);

  /// No description provided for @wishlistClearAllHint.
  ///
  /// In en, this message translates to:
  /// **'All saved courses will be cleared. You can add them back anytime from Explore.'**
  String get wishlistClearAllHint;

  /// No description provided for @wishlistClearAllConfirm.
  ///
  /// In en, this message translates to:
  /// **'Clear All ({count})'**
  String wishlistClearAllConfirm(String count);

  /// No description provided for @wishlistClearedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Wishlist cleared successfully'**
  String get wishlistClearedSuccess;

  /// No description provided for @wishlistClearFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to clear wishlist'**
  String get wishlistClearFailed;

  /// No description provided for @wishlistClearTooltip.
  ///
  /// In en, this message translates to:
  /// **'Clear All'**
  String get wishlistClearTooltip;

  /// No description provided for @wishlistViewCartCount.
  ///
  /// In en, this message translates to:
  /// **'View Cart Items ({count})'**
  String wishlistViewCartCount(String count);

  /// No description provided for @wishlistGoToCart.
  ///
  /// In en, this message translates to:
  /// **'Go to Cart'**
  String get wishlistGoToCart;

  /// No description provided for @checkoutCardNumberInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid 16-digit card number'**
  String get checkoutCardNumberInvalid;

  /// No description provided for @checkoutCardExpiryInvalidFormat.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid card expiry date (MM / YY)'**
  String get checkoutCardExpiryInvalidFormat;

  /// No description provided for @checkoutCardExpiredDate.
  ///
  /// In en, this message translates to:
  /// **'Card expiration date is invalid'**
  String get checkoutCardExpiredDate;

  /// No description provided for @checkoutCardCvcInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid 3 or 4-digit CVC code'**
  String get checkoutCardCvcInvalid;

  /// No description provided for @checkoutCardHolderNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter the cardholder name'**
  String get checkoutCardHolderNameRequired;

  /// No description provided for @checkoutCartEmptySnackbar.
  ///
  /// In en, this message translates to:
  /// **'Shopping cart is empty'**
  String get checkoutCartEmptySnackbar;

  /// No description provided for @checkoutPaymentStartFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to initiate payment'**
  String get checkoutPaymentStartFailed;

  /// No description provided for @checkoutClientSecretMissing.
  ///
  /// In en, this message translates to:
  /// **'Security key was not received from payment gateway'**
  String get checkoutClientSecretMissing;

  /// No description provided for @checkoutCardVerificationFailed.
  ///
  /// In en, this message translates to:
  /// **'Card verification failed'**
  String get checkoutCardVerificationFailed;

  /// No description provided for @checkoutStripeProcessingFailed.
  ///
  /// In en, this message translates to:
  /// **'Stripe payment processing failed'**
  String get checkoutStripeProcessingFailed;

  /// No description provided for @checkoutServerConfirmationFailed.
  ///
  /// In en, this message translates to:
  /// **'Server payment confirmation failed'**
  String get checkoutServerConfirmationFailed;

  /// No description provided for @checkoutEmptyCartTitle.
  ///
  /// In en, this message translates to:
  /// **'Your cart is empty'**
  String get checkoutEmptyCartTitle;

  /// No description provided for @checkoutEmptyCartDesc.
  ///
  /// In en, this message translates to:
  /// **'You have not added any courses to your cart yet. Explore our courses and start learning!'**
  String get checkoutEmptyCartDesc;

  /// No description provided for @checkoutContinueFreeReview.
  ///
  /// In en, this message translates to:
  /// **'Continue to Free Review'**
  String get checkoutContinueFreeReview;

  /// No description provided for @checkoutFreeOrderBadge.
  ///
  /// In en, this message translates to:
  /// **'100% Free Order (zsh.00)'**
  String get checkoutFreeOrderBadge;

  /// No description provided for @checkoutFreeOrderNotice.
  ///
  /// In en, this message translates to:
  /// **'This order does not require any payment information. You can proceed directly to confirm enrollment.'**
  String get checkoutFreeOrderNotice;

  /// No description provided for @checkoutFreeCheckoutTitle.
  ///
  /// In en, this message translates to:
  /// **'100% Free Checkout'**
  String get checkoutFreeCheckoutTitle;

  /// No description provided for @checkoutConfirmFreeEnrollment.
  ///
  /// In en, this message translates to:
  /// **'Confirm Free Enrollment'**
  String get checkoutConfirmFreeEnrollment;

  /// No description provided for @checkoutFreePrice.
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get checkoutFreePrice;

  /// No description provided for @checkoutFreeZero.
  ///
  /// In en, this message translates to:
  /// **'Free (zsh.00)'**
  String get checkoutFreeZero;

  /// No description provided for @checkoutCoursesCount.
  ///
  /// In en, this message translates to:
  /// **'{count} courses'**
  String checkoutCoursesCount(String count);

  /// No description provided for @notificationsClearAllTitle.
  ///
  /// In en, this message translates to:
  /// **'Clear All Notifications?'**
  String get notificationsClearAllTitle;

  /// No description provided for @notificationsClearAllMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete all {count} notifications? This action cannot be undone.'**
  String notificationsClearAllMessage(String count);

  /// No description provided for @notificationsClearAllHint.
  ///
  /// In en, this message translates to:
  /// **'All your notifications will be deleted and your inbox will start fresh.'**
  String get notificationsClearAllHint;

  /// No description provided for @notificationsClearAllConfirm.
  ///
  /// In en, this message translates to:
  /// **'Clear All ({count})'**
  String notificationsClearAllConfirm(String count);

  /// No description provided for @notificationsClearSuccess.
  ///
  /// In en, this message translates to:
  /// **'All notifications cleared successfully'**
  String get notificationsClearSuccess;

  /// No description provided for @notificationsClearFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to clear notifications'**
  String get notificationsClearFailed;

  /// No description provided for @notificationsClearTooltip.
  ///
  /// In en, this message translates to:
  /// **'Clear All'**
  String get notificationsClearTooltip;

  /// No description provided for @notificationsViewDetails.
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get notificationsViewDetails;

  /// No description provided for @notificationsEmptyCategoryTitle.
  ///
  /// In en, this message translates to:
  /// **'No notifications in this category'**
  String get notificationsEmptyCategoryTitle;

  /// No description provided for @notificationsEmptyCategorySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Try switching to another category or browse all notifications'**
  String get notificationsEmptyCategorySubtitle;

  /// No description provided for @notificationsEmptyAllSubtitle.
  ///
  /// In en, this message translates to:
  /// **'We will keep you posted with the latest updates and alerts here'**
  String get notificationsEmptyAllSubtitle;

  /// No description provided for @notificationsViewAll.
  ///
  /// In en, this message translates to:
  /// **'View All Notifications'**
  String get notificationsViewAll;

  /// No description provided for @learningFilterAndSortTitle.
  ///
  /// In en, this message translates to:
  /// **'Filter & Sort Courses'**
  String get learningFilterAndSortTitle;

  /// No description provided for @learningFilterReset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get learningFilterReset;

  /// No description provided for @learningSortByTitle.
  ///
  /// In en, this message translates to:
  /// **'Sort by'**
  String get learningSortByTitle;

  /// No description provided for @learningSortRecentActivity.
  ///
  /// In en, this message translates to:
  /// **'Recently Accessed'**
  String get learningSortRecentActivity;

  /// No description provided for @learningSortRecentEnrolled.
  ///
  /// In en, this message translates to:
  /// **'Recently Enrolled'**
  String get learningSortRecentEnrolled;

  /// No description provided for @learningSortTitleAZ.
  ///
  /// In en, this message translates to:
  /// **'Title (A-Z)'**
  String get learningSortTitleAZ;

  /// No description provided for @learningSortProgress.
  ///
  /// In en, this message translates to:
  /// **'Progress %'**
  String get learningSortProgress;

  /// No description provided for @learningStatusTitle.
  ///
  /// In en, this message translates to:
  /// **'Course Status'**
  String get learningStatusTitle;

  /// No description provided for @learningStatusAll.
  ///
  /// In en, this message translates to:
  /// **'All Courses'**
  String get learningStatusAll;

  /// No description provided for @learningStatusInProgress.
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get learningStatusInProgress;

  /// No description provided for @learningStatusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get learningStatusCompleted;

  /// No description provided for @learningStatusNotStarted.
  ///
  /// In en, this message translates to:
  /// **'Not Started'**
  String get learningStatusNotStarted;

  /// No description provided for @learningFilterApply.
  ///
  /// In en, this message translates to:
  /// **'Apply Filters'**
  String get learningFilterApply;

  /// No description provided for @learningSearchCoursesHint.
  ///
  /// In en, this message translates to:
  /// **'Search your courses...'**
  String get learningSearchCoursesHint;

  /// No description provided for @learningSearchWishlistHint.
  ///
  /// In en, this message translates to:
  /// **'Search wishlist...'**
  String get learningSearchWishlistHint;

  /// No description provided for @learningSearchCertificatesHint.
  ///
  /// In en, this message translates to:
  /// **'Search certificates...'**
  String get learningSearchCertificatesHint;

  /// No description provided for @learningTabMyCourses.
  ///
  /// In en, this message translates to:
  /// **'My Courses'**
  String get learningTabMyCourses;

  /// No description provided for @learningTabFavourite.
  ///
  /// In en, this message translates to:
  /// **'My Favourite'**
  String get learningTabFavourite;

  /// No description provided for @learningTabCertificates.
  ///
  /// In en, this message translates to:
  /// **'My Certificates'**
  String get learningTabCertificates;

  /// No description provided for @learningNoCoursesTitle.
  ///
  /// In en, this message translates to:
  /// **'No courses yet'**
  String get learningNoCoursesTitle;

  /// No description provided for @learningNoCoursesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Explore thousands of premium courses and start your learning journey today'**
  String get learningNoCoursesSubtitle;

  /// No description provided for @learningFilterButton.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get learningFilterButton;

  /// No description provided for @learningFilterAllCount.
  ///
  /// In en, this message translates to:
  /// **'All ({count})'**
  String learningFilterAllCount(String count);

  /// No description provided for @learningStatusNotStartedShort.
  ///
  /// In en, this message translates to:
  /// **'Not Started'**
  String get learningStatusNotStartedShort;

  /// No description provided for @learningNoMatchTitle.
  ///
  /// In en, this message translates to:
  /// **'No matching courses'**
  String get learningNoMatchTitle;

  /// No description provided for @learningNoMatchSubtitle.
  ///
  /// In en, this message translates to:
  /// **'No courses found containing \"{query}\". Try searching with different terms.'**
  String learningNoMatchSubtitle(String query);

  /// No description provided for @learningNoInProgressTitle.
  ///
  /// In en, this message translates to:
  /// **'No courses in progress'**
  String get learningNoInProgressTitle;

  /// No description provided for @learningNoInProgressSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Start watching lessons in your enrolled courses to track your progress here.'**
  String get learningNoInProgressSubtitle;

  /// No description provided for @learningNoCompletedTitle.
  ///
  /// In en, this message translates to:
  /// **'No completed courses yet'**
  String get learningNoCompletedTitle;

  /// No description provided for @learningNoCompletedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Continue your studies to celebrate your progress and see completed courses here.'**
  String get learningNoCompletedSubtitle;

  /// No description provided for @learningNoUnstartedTitle.
  ///
  /// In en, this message translates to:
  /// **'No unstarted courses'**
  String get learningNoUnstartedTitle;

  /// No description provided for @learningNoUnstartedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Awesome! You have already started learning in all your enrolled courses.'**
  String get learningNoUnstartedSubtitle;

  /// No description provided for @learningNoFilterMatchTitle.
  ///
  /// In en, this message translates to:
  /// **'No courses match this filter'**
  String get learningNoFilterMatchTitle;

  /// No description provided for @learningNoFilterMatchSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Change filter or sort options to display your courses.'**
  String get learningNoFilterMatchSubtitle;

  /// No description provided for @learningViewAllCoursesCount.
  ///
  /// In en, this message translates to:
  /// **'View all courses ({count})'**
  String learningViewAllCoursesCount(String count);

  /// No description provided for @learningSavedCoursesCount.
  ///
  /// In en, this message translates to:
  /// **'Saved Courses ({count})'**
  String learningSavedCoursesCount(String count);

  /// No description provided for @learningClearAllSaved.
  ///
  /// In en, this message translates to:
  /// **'Clear All'**
  String get learningClearAllSaved;

  /// No description provided for @learningNoCertificatesTitle.
  ///
  /// In en, this message translates to:
  /// **'No certificates yet'**
  String get learningNoCertificatesTitle;

  /// No description provided for @learningNoCertificatesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Complete your courses to earn accredited certificates that verify your achievements'**
  String get learningNoCertificatesSubtitle;

  /// No description provided for @learningGoToCourses.
  ///
  /// In en, this message translates to:
  /// **'Go to My Courses'**
  String get learningGoToCourses;

  /// No description provided for @learningCertIssuedDate.
  ///
  /// In en, this message translates to:
  /// **'Issued: {date}'**
  String learningCertIssuedDate(String date);

  /// No description provided for @learningCertView.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get learningCertView;

  /// No description provided for @learningResumeLesson.
  ///
  /// In en, this message translates to:
  /// **'Resume Lesson'**
  String get learningResumeLesson;

  /// No description provided for @learningProgressPercentComplete.
  ///
  /// In en, this message translates to:
  /// **'{percent}% complete'**
  String learningProgressPercentComplete(String percent);

  /// No description provided for @learningViewCartCount.
  ///
  /// In en, this message translates to:
  /// **'View Cart Items ({count})'**
  String learningViewCartCount(String count);

  /// No description provided for @learningGoToCart.
  ///
  /// In en, this message translates to:
  /// **'Go to Cart'**
  String get learningGoToCart;

  /// No description provided for @playerLessonMarkedCompleted.
  ///
  /// In en, this message translates to:
  /// **'Lesson marked as completed ✓'**
  String get playerLessonMarkedCompleted;

  /// No description provided for @playerLessonMarkedIncomplete.
  ///
  /// In en, this message translates to:
  /// **'Lesson marked as incomplete'**
  String get playerLessonMarkedIncomplete;

  /// No description provided for @playerCommentPostedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Comment posted successfully'**
  String get playerCommentPostedSuccess;

  /// No description provided for @playerCommentPostFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to post comment'**
  String get playerCommentPostFailed;

  /// No description provided for @playerReplyPostedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Reply posted successfully'**
  String get playerReplyPostedSuccess;

  /// No description provided for @playerReplyPostFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to post reply'**
  String get playerReplyPostFailed;

  /// No description provided for @playerCourseNotFound.
  ///
  /// In en, this message translates to:
  /// **'Course not found'**
  String get playerCourseNotFound;

  /// No description provided for @playerCheckEnrollmentPrompt.
  ///
  /// In en, this message translates to:
  /// **'Please verify your course enrollment first'**
  String get playerCheckEnrollmentPrompt;

  /// No description provided for @playerReturnToCourses.
  ///
  /// In en, this message translates to:
  /// **'My Learning'**
  String get playerReturnToCourses;

  /// No description provided for @playerWatchLecture.
  ///
  /// In en, this message translates to:
  /// **'Course Lecture'**
  String get playerWatchLecture;

  /// No description provided for @playerCertificateTooltip.
  ///
  /// In en, this message translates to:
  /// **'Certificate'**
  String get playerCertificateTooltip;

  /// No description provided for @playerRateCourseTooltip.
  ///
  /// In en, this message translates to:
  /// **'Rate Course'**
  String get playerRateCourseTooltip;

  /// No description provided for @playerReadingArticleBadge.
  ///
  /// In en, this message translates to:
  /// **'Reading Article • 5 mins'**
  String get playerReadingArticleBadge;

  /// No description provided for @playerReadFullTextBelow.
  ///
  /// In en, this message translates to:
  /// **'Read full text below ↓'**
  String get playerReadFullTextBelow;

  /// No description provided for @playerTabReviews.
  ///
  /// In en, this message translates to:
  /// **'Reviews'**
  String get playerTabReviews;

  /// No description provided for @playerNoSectionsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No sections available'**
  String get playerNoSectionsAvailable;

  /// No description provided for @playerLessonsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} lessons'**
  String playerLessonsCount(String count);

  /// No description provided for @playerPlayingBadge.
  ///
  /// In en, this message translates to:
  /// **'Playing'**
  String get playerPlayingBadge;

  /// No description provided for @playerArticleBadge.
  ///
  /// In en, this message translates to:
  /// **'Article'**
  String get playerArticleBadge;

  /// No description provided for @playerVideoBadge.
  ///
  /// In en, this message translates to:
  /// **'Video'**
  String get playerVideoBadge;

  /// No description provided for @playerFullArticleContent.
  ///
  /// In en, this message translates to:
  /// **'Full Article Content'**
  String get playerFullArticleContent;

  /// No description provided for @playerArticlePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Welcome to this reading lesson.\n\nThis section covers the core concepts and practical steps you need to master the skills in this lesson.'**
  String get playerArticlePlaceholder;

  /// No description provided for @playerAboutCourseTitle.
  ///
  /// In en, this message translates to:
  /// **'About this Course'**
  String get playerAboutCourseTitle;

  /// No description provided for @playerShowLess.
  ///
  /// In en, this message translates to:
  /// **'Show Less'**
  String get playerShowLess;

  /// No description provided for @playerReadMore.
  ///
  /// In en, this message translates to:
  /// **'Read More'**
  String get playerReadMore;

  /// No description provided for @playerWhatYouWillLearn.
  ///
  /// In en, this message translates to:
  /// **'What You\'ll Learn'**
  String get playerWhatYouWillLearn;

  /// No description provided for @playerCourseInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'Course Details'**
  String get playerCourseInfoTitle;

  /// No description provided for @playerTotalDurationTitle.
  ///
  /// In en, this message translates to:
  /// **'Total Duration'**
  String get playerTotalDurationTitle;

  /// No description provided for @playerTotalLessonsTitle.
  ///
  /// In en, this message translates to:
  /// **'Total Lessons'**
  String get playerTotalLessonsTitle;

  /// No description provided for @playerLessonsNumber.
  ///
  /// In en, this message translates to:
  /// **'{count} lessons'**
  String playerLessonsNumber(String count);

  /// No description provided for @playerLevelTitle.
  ///
  /// In en, this message translates to:
  /// **'Level'**
  String get playerLevelTitle;

  /// No description provided for @playerAllLevels.
  ///
  /// In en, this message translates to:
  /// **'All Levels'**
  String get playerAllLevels;

  /// No description provided for @playerLanguageTitle.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get playerLanguageTitle;

  /// No description provided for @playerLanguageArabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get playerLanguageArabic;

  /// No description provided for @playerPrerequisitesTitle.
  ///
  /// In en, this message translates to:
  /// **'Course Requirements'**
  String get playerPrerequisitesTitle;

  /// No description provided for @playerCertificateCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Course Certificate'**
  String get playerCertificateCardTitle;

  /// No description provided for @playerCourseCompletedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Congratulations! Course completed'**
  String get playerCourseCompletedSuccess;

  /// No description provided for @playerProgressLabel.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get playerProgressLabel;

  /// No description provided for @playerViewCertificateBtn.
  ///
  /// In en, this message translates to:
  /// **'View Certificate'**
  String get playerViewCertificateBtn;

  /// No description provided for @playerCertifiedInstructor.
  ///
  /// In en, this message translates to:
  /// **'Certified Instructor'**
  String get playerCertifiedInstructor;

  /// No description provided for @playerDiscussionsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} questions & discussions'**
  String playerDiscussionsCount(String count);

  /// No description provided for @playerAskQuestionHint.
  ///
  /// In en, this message translates to:
  /// **'Type your question or query here...'**
  String get playerAskQuestionHint;

  /// No description provided for @playerPostBtn.
  ///
  /// In en, this message translates to:
  /// **'Post'**
  String get playerPostBtn;

  /// No description provided for @playerNoDiscussionsTitle.
  ///
  /// In en, this message translates to:
  /// **'No discussions yet'**
  String get playerNoDiscussionsTitle;

  /// No description provided for @playerNoDiscussionsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Be the first to ask a question!'**
  String get playerNoDiscussionsSubtitle;

  /// No description provided for @playerInstructorBadge.
  ///
  /// In en, this message translates to:
  /// **'Instructor'**
  String get playerInstructorBadge;

  /// No description provided for @playerCancelReply.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get playerCancelReply;

  /// No description provided for @playerReplyAction.
  ///
  /// In en, this message translates to:
  /// **'Reply'**
  String get playerReplyAction;

  /// No description provided for @playerRepliesCount.
  ///
  /// In en, this message translates to:
  /// **'{count} replies'**
  String playerRepliesCount(String count);

  /// No description provided for @playerWriteReplyHint.
  ///
  /// In en, this message translates to:
  /// **'Write your reply...'**
  String get playerWriteReplyHint;

  /// No description provided for @playerSendReplyBtn.
  ///
  /// In en, this message translates to:
  /// **'Reply'**
  String get playerSendReplyBtn;

  /// No description provided for @playerCourseFeedbackTitle.
  ///
  /// In en, this message translates to:
  /// **'Course Rating & Feedback'**
  String get playerCourseFeedbackTitle;

  /// No description provided for @playerOutOf5.
  ///
  /// In en, this message translates to:
  /// **'out of 5'**
  String get playerOutOf5;

  /// No description provided for @playerRatingsFromEnrolledCount.
  ///
  /// In en, this message translates to:
  /// **'{count} ratings from enrolled students'**
  String playerRatingsFromEnrolledCount(String count);

  /// No description provided for @playerKeepLearningToRate.
  ///
  /// In en, this message translates to:
  /// **'Keep learning to rate'**
  String get playerKeepLearningToRate;

  /// No description provided for @playerRateAfter80Hint.
  ///
  /// In en, this message translates to:
  /// **'You can review and rate this course after completing 80% of its content'**
  String get playerRateAfter80Hint;

  /// No description provided for @playerCurrentProgressLabel.
  ///
  /// In en, this message translates to:
  /// **'Your Progress:'**
  String get playerCurrentProgressLabel;

  /// No description provided for @playerYourCurrentRating.
  ///
  /// In en, this message translates to:
  /// **'Your Rating'**
  String get playerYourCurrentRating;

  /// No description provided for @playerEditRating.
  ///
  /// In en, this message translates to:
  /// **'Edit Rating'**
  String get playerEditRating;

  /// No description provided for @playerDeleteRatingTooltip.
  ///
  /// In en, this message translates to:
  /// **'Delete Rating'**
  String get playerDeleteRatingTooltip;

  /// No description provided for @playerUpdateRatingTitle.
  ///
  /// In en, this message translates to:
  /// **'Update Your Rating'**
  String get playerUpdateRatingTitle;

  /// No description provided for @playerRateCourseTitle.
  ///
  /// In en, this message translates to:
  /// **'Rate this Course'**
  String get playerRateCourseTitle;

  /// No description provided for @playerWriteReviewHint.
  ///
  /// In en, this message translates to:
  /// **'Write your feedback and thoughts about content quality (optional)...'**
  String get playerWriteReviewHint;

  /// No description provided for @playerRatingSubmitSuccess.
  ///
  /// In en, this message translates to:
  /// **'Rating submitted successfully!'**
  String get playerRatingSubmitSuccess;

  /// No description provided for @playerRatingSubmitFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to submit rating'**
  String get playerRatingSubmitFailed;

  /// No description provided for @playerSaveChangesBtn.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get playerSaveChangesBtn;

  /// No description provided for @playerSubmitReviewBtn.
  ///
  /// In en, this message translates to:
  /// **'Submit Review'**
  String get playerSubmitReviewBtn;

  /// No description provided for @playerLearnerReviewsTitle.
  ///
  /// In en, this message translates to:
  /// **'Learner Reviews'**
  String get playerLearnerReviewsTitle;

  /// No description provided for @playerReviewsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} reviews'**
  String playerReviewsCount(String count);

  /// No description provided for @playerNoWrittenReviewsTitle.
  ///
  /// In en, this message translates to:
  /// **'No written reviews yet'**
  String get playerNoWrittenReviewsTitle;

  /// No description provided for @playerNoWrittenReviewsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Be the first to share your thoughts!'**
  String get playerNoWrittenReviewsSubtitle;

  /// No description provided for @playerRatingLabel5.
  ///
  /// In en, this message translates to:
  /// **'Excellent 🌟 (5/5)'**
  String get playerRatingLabel5;

  /// No description provided for @playerRatingLabel4.
  ///
  /// In en, this message translates to:
  /// **'Very Good 👍 (4/5)'**
  String get playerRatingLabel4;

  /// No description provided for @playerRatingLabel3.
  ///
  /// In en, this message translates to:
  /// **'Average 👌 (3/5)'**
  String get playerRatingLabel3;

  /// No description provided for @playerRatingLabel2.
  ///
  /// In en, this message translates to:
  /// **'Needs Improvement 🤔 (2/5)'**
  String get playerRatingLabel2;

  /// No description provided for @playerRatingLabel1.
  ///
  /// In en, this message translates to:
  /// **'Poor 👎 (1/5)'**
  String get playerRatingLabel1;

  /// No description provided for @playerDeleteRatingDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Rating'**
  String get playerDeleteRatingDialogTitle;

  /// No description provided for @playerDeleteRatingDialogMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete your review for this course?'**
  String get playerDeleteRatingDialogMessage;

  /// No description provided for @playerDeleteConfirmBtn.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get playerDeleteConfirmBtn;

  /// No description provided for @playerRatingDeleteSuccess.
  ///
  /// In en, this message translates to:
  /// **'Rating deleted successfully'**
  String get playerRatingDeleteSuccess;

  /// No description provided for @playerPreviousLesson.
  ///
  /// In en, this message translates to:
  /// **'Previous Lesson'**
  String get playerPreviousLesson;

  /// No description provided for @playerExitFullscreenTooltip.
  ///
  /// In en, this message translates to:
  /// **'Exit Fullscreen'**
  String get playerExitFullscreenTooltip;

  /// No description provided for @instructorsAvailableCount.
  ///
  /// In en, this message translates to:
  /// **'{count} instructors available'**
  String instructorsAvailableCount(String count);

  /// No description provided for @instructorsNotFound.
  ///
  /// In en, this message translates to:
  /// **'No instructors found'**
  String get instructorsNotFound;

  /// No description provided for @instructorsCoursesCount.
  ///
  /// In en, this message translates to:
  /// **'{count} courses'**
  String instructorsCoursesCount(String count);

  /// No description provided for @instructorsSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search by instructor name or specialty...'**
  String get instructorsSearchHint;

  /// No description provided for @instructorsSortAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get instructorsSortAll;

  /// No description provided for @instructorsSortTopRated.
  ///
  /// In en, this message translates to:
  /// **'Top Rated'**
  String get instructorsSortTopRated;

  /// No description provided for @instructorsSortMostStudents.
  ///
  /// In en, this message translates to:
  /// **'Most Students'**
  String get instructorsSortMostStudents;

  /// No description provided for @instructorsSortMostCourses.
  ///
  /// In en, this message translates to:
  /// **'Most Courses'**
  String get instructorsSortMostCourses;

  /// No description provided for @instructorsNotFoundSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Try searching with a different name or clear filters'**
  String get instructorsNotFoundSubtitle;

  /// No description provided for @exploreCompleteCourse.
  ///
  /// In en, this message translates to:
  /// **'Comprehensive Course'**
  String get exploreCompleteCourse;

  /// No description provided for @exploreGeneralCategory.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get exploreGeneralCategory;

  /// No description provided for @courseShareMessage.
  ///
  /// In en, this message translates to:
  /// **'Check out the course \"{title}\" on EduLab: {url}'**
  String courseShareMessage(String title, String url);

  /// No description provided for @courseDetailsDefaultTitle.
  ///
  /// In en, this message translates to:
  /// **'Course Details'**
  String get courseDetailsDefaultTitle;

  /// No description provided for @courseDetailsTooltipShare.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get courseDetailsTooltipShare;

  /// No description provided for @courseDetailsTooltipWishlist.
  ///
  /// In en, this message translates to:
  /// **'Wishlist'**
  String get courseDetailsTooltipWishlist;

  /// No description provided for @courseDetailsTooltipCart.
  ///
  /// In en, this message translates to:
  /// **'Cart'**
  String get courseDetailsTooltipCart;

  /// No description provided for @courseDetailsNotFound.
  ///
  /// In en, this message translates to:
  /// **'Course not found'**
  String get courseDetailsNotFound;

  /// No description provided for @courseDetailsDefaultCategory.
  ///
  /// In en, this message translates to:
  /// **'Course'**
  String get courseDetailsDefaultCategory;

  /// No description provided for @courseDetailsTotalRatingsCount.
  ///
  /// In en, this message translates to:
  /// **'({count} ratings)'**
  String courseDetailsTotalRatingsCount(String count);

  /// No description provided for @courseDetailsLecturesCount.
  ///
  /// In en, this message translates to:
  /// **'{count} lectures'**
  String courseDetailsLecturesCount(String count);

  /// No description provided for @courseDetailsCertificateBadge.
  ///
  /// In en, this message translates to:
  /// **'Certificate'**
  String get courseDetailsCertificateBadge;

  /// No description provided for @courseDetailsTabOverview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get courseDetailsTabOverview;

  /// No description provided for @courseDetailsTabCurriculum.
  ///
  /// In en, this message translates to:
  /// **'Curriculum'**
  String get courseDetailsTabCurriculum;

  /// No description provided for @courseDetailsTabInstructor.
  ///
  /// In en, this message translates to:
  /// **'Instructor'**
  String get courseDetailsTabInstructor;

  /// No description provided for @courseDetailsTabReviews.
  ///
  /// In en, this message translates to:
  /// **'Reviews'**
  String get courseDetailsTabReviews;

  /// No description provided for @courseDetailsFullDescriptionTitle.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get courseDetailsFullDescriptionTitle;

  /// No description provided for @courseDetailsShowLess.
  ///
  /// In en, this message translates to:
  /// **'Show less'**
  String get courseDetailsShowLess;

  /// No description provided for @courseDetailsShowMore.
  ///
  /// In en, this message translates to:
  /// **'Show more...'**
  String get courseDetailsShowMore;

  /// No description provided for @courseDetailsCurriculumSectionsLectures.
  ///
  /// In en, this message translates to:
  /// **'{sections} sections • {lectures} lectures'**
  String courseDetailsCurriculumSectionsLectures(
    String sections,
    String lectures,
  );

  /// No description provided for @courseDetailsCollapseAll.
  ///
  /// In en, this message translates to:
  /// **'Collapse all'**
  String get courseDetailsCollapseAll;

  /// No description provided for @courseDetailsExpandAll.
  ///
  /// In en, this message translates to:
  /// **'Expand all'**
  String get courseDetailsExpandAll;

  /// No description provided for @courseDetailsCurriculumComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Curriculum details coming soon'**
  String get courseDetailsCurriculumComingSoon;

  /// No description provided for @courseDetailsSectionLecturesCount.
  ///
  /// In en, this message translates to:
  /// **'{count} lectures'**
  String courseDetailsSectionLecturesCount(String count);

  /// No description provided for @courseDetailsLecturePreviewBtn.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get courseDetailsLecturePreviewBtn;

  /// No description provided for @courseDetailsDefaultInstructorTitle.
  ///
  /// In en, this message translates to:
  /// **'Senior Instructor & Certified Expert'**
  String get courseDetailsDefaultInstructorTitle;

  /// No description provided for @courseDetailsInstructorRatingLabel.
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get courseDetailsInstructorRatingLabel;

  /// No description provided for @courseDetailsInstructorStudentsLabel.
  ///
  /// In en, this message translates to:
  /// **'Students'**
  String get courseDetailsInstructorStudentsLabel;

  /// No description provided for @courseDetailsInstructorSectionsLabel.
  ///
  /// In en, this message translates to:
  /// **'Sections'**
  String get courseDetailsInstructorSectionsLabel;

  /// No description provided for @courseDetailsAboutInstructorTitle.
  ///
  /// In en, this message translates to:
  /// **'About Instructor:'**
  String get courseDetailsAboutInstructorTitle;

  /// No description provided for @courseDetailsDefaultInstructorAbout.
  ///
  /// In en, this message translates to:
  /// **'Certified instructor with extensive experience in delivering professional education to thousands of students worldwide.'**
  String get courseDetailsDefaultInstructorAbout;

  /// No description provided for @courseDetailsStudentRatingsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} student ratings'**
  String courseDetailsStudentRatingsCount(String count);

  /// No description provided for @courseDetailsNoWrittenReviews.
  ///
  /// In en, this message translates to:
  /// **'No written reviews yet'**
  String get courseDetailsNoWrittenReviews;

  /// No description provided for @courseDetailsRelatedCourses.
  ///
  /// In en, this message translates to:
  /// **'Related Courses You May Like'**
  String get courseDetailsRelatedCourses;

  /// No description provided for @courseDetailsDiscountPercent.
  ///
  /// In en, this message translates to:
  /// **'{percent}% OFF'**
  String courseDetailsDiscountPercent(String percent);

  /// No description provided for @courseDetailsResumeCourse.
  ///
  /// In en, this message translates to:
  /// **'Resume Course'**
  String get courseDetailsResumeCourse;

  /// No description provided for @courseDetailsTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get courseDetailsTryAgain;

  /// No description provided for @courseDetailsEstimatedReading.
  ///
  /// In en, this message translates to:
  /// **'📖 Estimated reading: 4 mins'**
  String get courseDetailsEstimatedReading;

  /// No description provided for @courseDetailsSampleArticleContent.
  ///
  /// In en, this message translates to:
  /// **'Welcome to this article lecture.\n\nThis section covers key theoretical concepts and practical steps to master the subject.\n\n• Key Takeaways:\n1. Grasp core terminology and architectural patterns.\n2. Hands-on exercises and continuous practice.\n3. Reference supplementary notes and assignments.\n\nEnjoy reading!'**
  String get courseDetailsSampleArticleContent;

  /// No description provided for @certDownloadedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Certificate for \"{course}\" downloaded in {format} format successfully!'**
  String certDownloadedSuccess(String course, String format);

  /// No description provided for @certVerifiedFullRequirements.
  ///
  /// In en, this message translates to:
  /// **'Verification ID: {code} • 100% Requirements Completed'**
  String certVerifiedFullRequirements(String code);

  /// No description provided for @certCompletionTitle.
  ///
  /// In en, this message translates to:
  /// **'Certificate of Completion'**
  String get certCompletionTitle;

  /// No description provided for @certCompletionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Course Completion Certificate'**
  String get certCompletionSubtitle;

  /// No description provided for @certAnnounceStudent.
  ///
  /// In en, this message translates to:
  /// **'EducationLab Learning Academy hereby certifies that:'**
  String get certAnnounceStudent;

  /// No description provided for @certCompletionRequirementsMet.
  ///
  /// In en, this message translates to:
  /// **'Has successfully completed all requirements of the training course:'**
  String get certCompletionRequirementsMet;

  /// No description provided for @certIssueDateText.
  ///
  /// In en, this message translates to:
  /// **'Issue Date: {date}'**
  String certIssueDateText(String date);

  /// No description provided for @certIdNumberText.
  ///
  /// In en, this message translates to:
  /// **'Certificate ID: {code}'**
  String certIdNumberText(String code);

  /// No description provided for @certPlatformManagement.
  ///
  /// In en, this message translates to:
  /// **'Platform Management'**
  String get certPlatformManagement;

  /// No description provided for @certInstructorRoleTitle.
  ///
  /// In en, this message translates to:
  /// **'Course Instructor'**
  String get certInstructorRoleTitle;

  /// No description provided for @commonLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get commonLoading;

  /// No description provided for @homeGuestTagline.
  ///
  /// In en, this message translates to:
  /// **'Smart learning & skill building platform'**
  String get homeGuestTagline;

  /// No description provided for @catTagHighestDemand.
  ///
  /// In en, this message translates to:
  /// **'Highest Demand'**
  String get catTagHighestDemand;

  /// No description provided for @catTagMostPopular.
  ///
  /// In en, this message translates to:
  /// **'Most Popular'**
  String get catTagMostPopular;

  /// No description provided for @catTagTrending.
  ///
  /// In en, this message translates to:
  /// **'Trending'**
  String get catTagTrending;

  /// No description provided for @catTagFastestGrowing.
  ///
  /// In en, this message translates to:
  /// **'Fastest Growing'**
  String get catTagFastestGrowing;

  /// No description provided for @catTagHighDemand.
  ///
  /// In en, this message translates to:
  /// **'High Demand'**
  String get catTagHighDemand;

  /// No description provided for @catTagTopRated.
  ///
  /// In en, this message translates to:
  /// **'Top Rated'**
  String get catTagTopRated;

  /// No description provided for @catTagEssential.
  ///
  /// In en, this message translates to:
  /// **'Essential'**
  String get catTagEssential;

  /// No description provided for @catTagAdvanced.
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get catTagAdvanced;

  /// No description provided for @catTagEntrepreneurs.
  ///
  /// In en, this message translates to:
  /// **'Entrepreneurs'**
  String get catTagEntrepreneurs;

  /// No description provided for @catTagSalesGrowth.
  ///
  /// In en, this message translates to:
  /// **'Sales Growth'**
  String get catTagSalesGrowth;

  /// No description provided for @catDevTitle.
  ///
  /// In en, this message translates to:
  /// **'Programming & Software Development'**
  String get catDevTitle;

  /// No description provided for @catDevSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Software Engineering, Systems & Algorithms'**
  String get catDevSubtitle;

  /// No description provided for @catWebTitle.
  ///
  /// In en, this message translates to:
  /// **'Web Development'**
  String get catWebTitle;

  /// No description provided for @catWebSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Frontend, Backend & Fullstack Web'**
  String get catWebSubtitle;

  /// No description provided for @catMobileTitle.
  ///
  /// In en, this message translates to:
  /// **'Mobile App Development'**
  String get catMobileTitle;

  /// No description provided for @catMobileSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Flutter, iOS & Android Mobile Apps'**
  String get catMobileSubtitle;

  /// No description provided for @catAiTitle.
  ///
  /// In en, this message translates to:
  /// **'Artificial Intelligence'**
  String get catAiTitle;

  /// No description provided for @catAiSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Machine Learning, Deep Learning & AI'**
  String get catAiSubtitle;

  /// No description provided for @catDataTitle.
  ///
  /// In en, this message translates to:
  /// **'Data Science & Analytics'**
  String get catDataTitle;

  /// No description provided for @catDataSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Data Analysis, Statistics & Big Data'**
  String get catDataSubtitle;

  /// No description provided for @catDesignTitle.
  ///
  /// In en, this message translates to:
  /// **'UI/UX & Product Design'**
  String get catDesignTitle;

  /// No description provided for @catDesignSubtitle.
  ///
  /// In en, this message translates to:
  /// **'UI/UX, Prototyping & Product Design'**
  String get catDesignSubtitle;

  /// No description provided for @catSecurityTitle.
  ///
  /// In en, this message translates to:
  /// **'Cyber Security & Networks'**
  String get catSecurityTitle;

  /// No description provided for @catSecuritySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Cybersecurity, Ethical Hacking & Networks'**
  String get catSecuritySubtitle;

  /// No description provided for @catCloudTitle.
  ///
  /// In en, this message translates to:
  /// **'Cloud Computing & DevOps'**
  String get catCloudTitle;

  /// No description provided for @catCloudSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Cloud Infrastructure, DevOps & CI/CD'**
  String get catCloudSubtitle;

  /// No description provided for @catBusinessTitle.
  ///
  /// In en, this message translates to:
  /// **'Business & Project Management'**
  String get catBusinessTitle;

  /// No description provided for @catBusinessSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Business Management, Agile & Leadership'**
  String get catBusinessSubtitle;

  /// No description provided for @catMarketingTitle.
  ///
  /// In en, this message translates to:
  /// **'Digital Marketing'**
  String get catMarketingTitle;

  /// No description provided for @catMarketingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Digital Marketing, SEO & Growth Strategies'**
  String get catMarketingSubtitle;

  /// No description provided for @timeJustNow.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get timeJustNow;

  /// No description provided for @timeMinutesAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} min ago'**
  String timeMinutesAgo(String count);

  /// No description provided for @timeHoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} hr ago'**
  String timeHoursAgo(String count);

  /// No description provided for @timeDaysAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} days ago'**
  String timeDaysAgo(String count);

  /// No description provided for @timeWeeksAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} weeks ago'**
  String timeWeeksAgo(String count);

  /// No description provided for @timeMonthsAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} months ago'**
  String timeMonthsAgo(String count);

  /// No description provided for @wishlistLecturesCount.
  ///
  /// In en, this message translates to:
  /// **'{count} lectures'**
  String wishlistLecturesCount(String count);

  /// No description provided for @instructorProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Instructor Profile'**
  String get instructorProfileTitle;

  /// No description provided for @instructorProfileLinkCopied.
  ///
  /// In en, this message translates to:
  /// **'Link for {name} copied to clipboard'**
  String instructorProfileLinkCopied(String name);

  /// No description provided for @instructorDefaultName.
  ///
  /// In en, this message translates to:
  /// **'Instructor'**
  String get instructorDefaultName;

  /// No description provided for @instructorProfileBadge.
  ///
  /// In en, this message translates to:
  /// **'INSTRUCTOR'**
  String get instructorProfileBadge;

  /// No description provided for @instructorProfileTotalStudents.
  ///
  /// In en, this message translates to:
  /// **'Total Students'**
  String get instructorProfileTotalStudents;

  /// No description provided for @instructorProfileRating.
  ///
  /// In en, this message translates to:
  /// **'Instructor Rating'**
  String get instructorProfileRating;

  /// No description provided for @instructorProfileCourses.
  ///
  /// In en, this message translates to:
  /// **'Courses'**
  String get instructorProfileCourses;

  /// No description provided for @instructorProfileShare.
  ///
  /// In en, this message translates to:
  /// **'Share Profile'**
  String get instructorProfileShare;

  /// No description provided for @instructorProfileLinkOpenError.
  ///
  /// In en, this message translates to:
  /// **'Could not open link, copied to clipboard'**
  String get instructorProfileLinkOpenError;

  /// No description provided for @instructorProfileWebsite.
  ///
  /// In en, this message translates to:
  /// **'Website'**
  String get instructorProfileWebsite;

  /// No description provided for @instructorProfileAboutMe.
  ///
  /// In en, this message translates to:
  /// **'About Me'**
  String get instructorProfileAboutMe;

  /// No description provided for @instructorProfileShowLess.
  ///
  /// In en, this message translates to:
  /// **'Show less'**
  String get instructorProfileShowLess;

  /// No description provided for @instructorProfileShowMore.
  ///
  /// In en, this message translates to:
  /// **'Show more'**
  String get instructorProfileShowMore;

  /// No description provided for @instructorProfileExpertise.
  ///
  /// In en, this message translates to:
  /// **'Areas of Expertise'**
  String get instructorProfileExpertise;

  /// No description provided for @instructorProfileSortAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get instructorProfileSortAll;

  /// No description provided for @instructorProfileSortTopRated.
  ///
  /// In en, this message translates to:
  /// **'Top Rated'**
  String get instructorProfileSortTopRated;

  /// No description provided for @instructorProfileSortPopular.
  ///
  /// In en, this message translates to:
  /// **'Popular'**
  String get instructorProfileSortPopular;

  /// No description provided for @instructorProfileSortNewest.
  ///
  /// In en, this message translates to:
  /// **'Newest'**
  String get instructorProfileSortNewest;

  /// No description provided for @instructorProfileCoursesTitle.
  ///
  /// In en, this message translates to:
  /// **'Instructor Courses'**
  String get instructorProfileCoursesTitle;

  /// No description provided for @instructorProfileNoCoursesFilter.
  ///
  /// In en, this message translates to:
  /// **'No courses found for this filter'**
  String get instructorProfileNoCoursesFilter;

  /// No description provided for @instructorProfileLoadMoreCourses.
  ///
  /// In en, this message translates to:
  /// **'Load More Courses ({count} remaining)'**
  String instructorProfileLoadMoreCourses(String count);

  /// No description provided for @instructorProfileLoadingMoreCourses.
  ///
  /// In en, this message translates to:
  /// **'Loading more courses...'**
  String get instructorProfileLoadingMoreCourses;

  /// No description provided for @instructorProfileAllCoursesLoaded.
  ///
  /// In en, this message translates to:
  /// **'All {count} courses loaded'**
  String instructorProfileAllCoursesLoaded(String count);

  /// No description provided for @instructorProfileStudentFeedback.
  ///
  /// In en, this message translates to:
  /// **'Student Feedback'**
  String get instructorProfileStudentFeedback;

  /// No description provided for @instructorProfileReviewsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} reviews'**
  String instructorProfileReviewsCount(String count);

  /// No description provided for @instructorProfileBasedOnReviews.
  ///
  /// In en, this message translates to:
  /// **'Based on {count} reviews'**
  String instructorProfileBasedOnReviews(String count);

  /// No description provided for @instructorProfileRecentReviews.
  ///
  /// In en, this message translates to:
  /// **'Recent Reviews'**
  String get instructorProfileRecentReviews;

  /// No description provided for @instructorProfileLoadMoreReviews.
  ///
  /// In en, this message translates to:
  /// **'Load More Reviews ({count} remaining)'**
  String instructorProfileLoadMoreReviews(String count);

  /// No description provided for @instructorProfileLoadingMoreReviews.
  ///
  /// In en, this message translates to:
  /// **'Loading more reviews...'**
  String get instructorProfileLoadingMoreReviews;

  /// No description provided for @instructorProfileAllReviewsLoaded.
  ///
  /// In en, this message translates to:
  /// **'All {count} reviews loaded'**
  String instructorProfileAllReviewsLoaded(String count);

  /// No description provided for @instructorProfileNoReviewsYet.
  ///
  /// In en, this message translates to:
  /// **'No written reviews yet'**
  String get instructorProfileNoReviewsYet;

  /// No description provided for @instructorProfileRatingDesc.
  ///
  /// In en, this message translates to:
  /// **'Rating is based on overall student ratings across instructor courses'**
  String get instructorProfileRatingDesc;

  /// No description provided for @instructorProfileLoadError.
  ///
  /// In en, this message translates to:
  /// **'Failed to load instructor details, please try again later'**
  String get instructorProfileLoadError;

  /// No description provided for @instructorProfileDefaultStudentName.
  ///
  /// In en, this message translates to:
  /// **'Student'**
  String get instructorProfileDefaultStudentName;

  /// No description provided for @instructorProfileDefaultHeadline.
  ///
  /// In en, this message translates to:
  /// **'Senior Instructor & Certified Expert'**
  String get instructorProfileDefaultHeadline;

  /// No description provided for @instructorProfileDefaultBio.
  ///
  /// In en, this message translates to:
  /// **'Certified software engineer and technical instructor with extensive experience building scalable software systems and mobile applications.\nTrained thousands of students and engineers worldwide, providing professional content focused on Clean Code, Clean Architecture, and modern scalable solutions.'**
  String get instructorProfileDefaultBio;

  /// No description provided for @supportNewChat.
  ///
  /// In en, this message translates to:
  /// **'New Chat'**
  String get supportNewChat;

  /// No description provided for @supportNoChatsTitle.
  ///
  /// In en, this message translates to:
  /// **'No Support Chats Yet'**
  String get supportNoChatsTitle;

  /// No description provided for @supportNoChatsDesc.
  ///
  /// In en, this message translates to:
  /// **'Our support team is ready 24/7 to help and answer all your questions'**
  String get supportNoChatsDesc;

  /// No description provided for @supportStartNewConversation.
  ///
  /// In en, this message translates to:
  /// **'Start New Conversation'**
  String get supportStartNewConversation;

  /// No description provided for @supportNoMessagesYet.
  ///
  /// In en, this message translates to:
  /// **'No messages yet'**
  String get supportNoMessagesYet;

  /// No description provided for @supportRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get supportRetry;

  /// No description provided for @supportOpenTicket.
  ///
  /// In en, this message translates to:
  /// **'Open Ticket'**
  String get supportOpenTicket;

  /// No description provided for @supportClosedTicket.
  ///
  /// In en, this message translates to:
  /// **'Closed Ticket'**
  String get supportClosedTicket;

  /// No description provided for @supportCloseAction.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get supportCloseAction;

  /// No description provided for @supportReopenAction.
  ///
  /// In en, this message translates to:
  /// **'Reopen'**
  String get supportReopenAction;

  /// No description provided for @supportNoMessagesInChat.
  ///
  /// In en, this message translates to:
  /// **'No messages in this chat yet'**
  String get supportNoMessagesInChat;

  /// No description provided for @supportYou.
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get supportYou;

  /// No description provided for @supportTeam.
  ///
  /// In en, this message translates to:
  /// **'Support Team'**
  String get supportTeam;

  /// No description provided for @supportTypeMessageHint.
  ///
  /// In en, this message translates to:
  /// **'Type your message here...'**
  String get supportTypeMessageHint;

  /// No description provided for @supportConversationClosedNotice.
  ///
  /// In en, this message translates to:
  /// **'This conversation is currently closed.'**
  String get supportConversationClosedNotice;

  /// No description provided for @supportCloseDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Close Conversation?'**
  String get supportCloseDialogTitle;

  /// No description provided for @supportCloseDialogDesc.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to close this chat? You can reopen it at any time to resume messaging.'**
  String get supportCloseDialogDesc;

  /// No description provided for @supportCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get supportCancel;

  /// No description provided for @supportYesClose.
  ///
  /// In en, this message translates to:
  /// **'Yes, Close'**
  String get supportYesClose;

  /// No description provided for @supportNewChatTitle.
  ///
  /// In en, this message translates to:
  /// **'New Support Chat'**
  String get supportNewChatTitle;

  /// No description provided for @supportNewChatSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Our team is here to help you'**
  String get supportNewChatSubtitle;

  /// No description provided for @supportSubjectLabel.
  ///
  /// In en, this message translates to:
  /// **'Subject'**
  String get supportSubjectLabel;

  /// No description provided for @supportSubjectHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Course inquiry, Payment issue...'**
  String get supportSubjectHint;

  /// No description provided for @supportMessageLabel.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get supportMessageLabel;

  /// No description provided for @supportMessageHint.
  ///
  /// In en, this message translates to:
  /// **'Describe your issue or question in detail...'**
  String get supportMessageHint;

  /// No description provided for @supportMessageRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter a message'**
  String get supportMessageRequired;

  /// No description provided for @supportStartConversationBtn.
  ///
  /// In en, this message translates to:
  /// **'Start Conversation'**
  String get supportStartConversationBtn;

  /// No description provided for @supportCreateError.
  ///
  /// In en, this message translates to:
  /// **'Failed to create conversation, please try again later'**
  String get supportCreateError;

  /// No description provided for @supportTopicCourse.
  ///
  /// In en, this message translates to:
  /// **'Course Inquiry'**
  String get supportTopicCourse;

  /// No description provided for @supportTopicPayment.
  ///
  /// In en, this message translates to:
  /// **'Payment Issue'**
  String get supportTopicPayment;

  /// No description provided for @supportTopicCertificates.
  ///
  /// In en, this message translates to:
  /// **'Certificates'**
  String get supportTopicCertificates;

  /// No description provided for @supportTopicTech.
  ///
  /// In en, this message translates to:
  /// **'Technical Issue'**
  String get supportTopicTech;

  /// No description provided for @supportTopicGeneral.
  ///
  /// In en, this message translates to:
  /// **'General Inquiry'**
  String get supportTopicGeneral;

  /// No description provided for @cartGuestTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to view your cart'**
  String get cartGuestTitle;

  /// No description provided for @cartGuestSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Please sign in to access your cart, track courses, and proceed to checkout smoothly.'**
  String get cartGuestSubtitle;

  /// No description provided for @wishlistGuestTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to view your wishlist'**
  String get wishlistGuestTitle;

  /// No description provided for @wishlistGuestSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Please sign in to access your wishlist and track the courses you love anytime.'**
  String get wishlistGuestSubtitle;

  /// No description provided for @courseDetailsLoginRequiredTitle.
  ///
  /// In en, this message translates to:
  /// **'Login Required'**
  String get courseDetailsLoginRequiredTitle;

  /// No description provided for @courseDetailsLoginRequiredDesc.
  ///
  /// In en, this message translates to:
  /// **'You must log in first to purchase this course and track your learning progress.'**
  String get courseDetailsLoginRequiredDesc;

  /// No description provided for @courseDetailsProceedToLogin.
  ///
  /// In en, this message translates to:
  /// **'Proceed to Sign In'**
  String get courseDetailsProceedToLogin;

  /// No description provided for @messagesGuestTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to view messages'**
  String get messagesGuestTitle;

  /// No description provided for @messagesGuestSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Please sign in to access support conversations and communicate with our help team.'**
  String get messagesGuestSubtitle;

  /// No description provided for @notificationsGuestTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to view notifications'**
  String get notificationsGuestTitle;

  /// No description provided for @notificationsGuestSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Please sign in to view the latest updates and notifications for your account and courses.'**
  String get notificationsGuestSubtitle;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'ar',
    'de',
    'en',
    'es',
    'fr',
    'hi',
    'id',
    'it',
    'ja',
    'ko',
    'ms',
    'nl',
    'pl',
    'pt',
    'ru',
    'tr',
    'uk',
    'ur',
    'vi',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'hi':
      return AppLocalizationsHi();
    case 'id':
      return AppLocalizationsId();
    case 'it':
      return AppLocalizationsIt();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
    case 'ms':
      return AppLocalizationsMs();
    case 'nl':
      return AppLocalizationsNl();
    case 'pl':
      return AppLocalizationsPl();
    case 'pt':
      return AppLocalizationsPt();
    case 'ru':
      return AppLocalizationsRu();
    case 'tr':
      return AppLocalizationsTr();
    case 'uk':
      return AppLocalizationsUk();
    case 'ur':
      return AppLocalizationsUr();
    case 'vi':
      return AppLocalizationsVi();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}

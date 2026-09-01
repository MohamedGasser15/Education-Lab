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
  /// **'Completed'**
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

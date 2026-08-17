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
}

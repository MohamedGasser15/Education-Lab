// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Ukrainian (`uk`).
class AppLocalizationsUk extends AppLocalizations {
  AppLocalizationsUk([String locale = 'uk']) : super(locale);

  @override
  String get onboardingSkip => 'Пропустити';

  @override
  String get onboardingTitle1 => 'Ласкаво просимо до EduLab';

  @override
  String get onboardingSubtitle1 =>
      'Ваша ідеальна платформа для сучасного інтерактивного навчання та постійного професійного зростання.';

  @override
  String get onboardingTitle2 => 'Навчайтеся у найкращих інструкторів';

  @override
  String get onboardingSubtitle2 =>
      'Тисячі професійних курсів з програмування, дизайну, бізнесу та аналізу даних. Висока якість із чітким планом розвитку.';

  @override
  String get onboardingTitle3 => 'Сертифікати та гарантований успіх';

  @override
  String get onboardingSubtitle3 =>
      'Відстежуйте свій прогрес, проходьте тести та отримуйте визнані сертифікати, які відкривають двері вашої кар\'єри.';

  @override
  String get onboardingNext => 'Далі';

  @override
  String get onboardingStart => 'Почати';

  @override
  String get splashAppName => 'Education Lab';

  @override
  String get splashTagline => 'Розумна платформа навчання';

  @override
  String get loginTagline => 'Ласкаво просимо на розумну платформу навчання';

  @override
  String get loginAppName => 'EduLab';

  @override
  String get loginTabLogin => 'Увійти';

  @override
  String get loginTabRegister => 'Новий обліковий запис';

  @override
  String get loginEmailLabel => 'Електронна пошта';

  @override
  String get loginEmailHint => 'example@email.com';

  @override
  String get loginPasswordLabel => 'Пароль';

  @override
  String get loginPasswordHint => '••••••';

  @override
  String get loginForgotPassword => 'Забули пароль?';

  @override
  String get loginSubmit => 'Увійти';

  @override
  String get loginSubmitLoading => 'Вхід';

  @override
  String get loginGuest => 'Увійти як гість';

  @override
  String get loginOr => 'або';

  @override
  String get loginEmailRequired => 'Електронна пошта обов\'язкова';

  @override
  String get loginEmailInvalid => 'Введіть дійсну адресу електронної пошти';

  @override
  String get loginPasswordRequired => 'Пароль обов\'язковий';

  @override
  String get registerStepEmail => 'Пошта';

  @override
  String get registerStepCode => 'Код';

  @override
  String get registerStepData => 'Дані';

  @override
  String get registerSendCodeInfo => 'Ми надішлемо код активації на цю пошту';

  @override
  String get registerSendCode => 'Надіслати код активації';

  @override
  String get registerVerifying => 'Перевірка';

  @override
  String get registerCodeSentTo => 'Код надіслано на:';

  @override
  String get registerResendCode => 'Надіслати код повторно';

  @override
  String get registerBack => 'Назад';

  @override
  String get registerVerifyCode => 'Підтвердити код';

  @override
  String get registerCodeIncomplete => 'Введіть повний 6-значний код';

  @override
  String get registerFullNameLabel => 'Повне ім\'я';

  @override
  String get registerFullNameHint => 'Ваше повне ім\'я';

  @override
  String get registerPasswordHint =>
      'Щонайменше 8 символів, одна велика літера та одна цифра';

  @override
  String get registerConfirmLabel => 'Підтвердження пароля';

  @override
  String get registerConfirmHint => 'Введіть пароль ще раз';

  @override
  String get registerSubmit => 'Створити обліковий запис';

  @override
  String get registerSubmitLoading => 'Створення облікового запису';

  @override
  String get registerSuccess => 'Обліковий запис успішно створено';

  @override
  String get registerNameRequired => 'Повне ім\'я обов\'язкове';

  @override
  String get registerNameMinLength =>
      'Повне ім\'я має містити щонайменше 6 символів';

  @override
  String get registerPasswordMinLength =>
      'Пароль має містити щонайменше 8 символів';

  @override
  String get registerPasswordUppercase =>
      'Пароль має містити щонайменше одну велику літеру';

  @override
  String get registerPasswordNumber =>
      'Пароль має містити щонайменше одну цифру';

  @override
  String get registerConfirmRequired => 'Підтвердження пароля обов\'язкове';

  @override
  String get registerConfirmMismatch => 'Паролі не збігаються';

  @override
  String get networkError => 'Помилка з\'єднання, спробуйте ще раз';
}

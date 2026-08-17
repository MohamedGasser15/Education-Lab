// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get onboardingSkip => 'Пропустить';

  @override
  String get onboardingTitle1 => 'Добро пожаловать в EduLab';

  @override
  String get onboardingSubtitle1 =>
      'Ваша идеальная платформа для современного интерактивного обучения и постоянного профессионального роста.';

  @override
  String get onboardingTitle2 => 'Учитесь у лучших преподавателей';

  @override
  String get onboardingSubtitle2 =>
      'Тысячи профессиональных курсов по программированию, дизайну, бизнесу и науке о данных. Высокое качество с чётким планом развития.';

  @override
  String get onboardingTitle3 => 'Сертификаты и гарантированный успех';

  @override
  String get onboardingSubtitle3 =>
      'Отслеживайте прогресс, проходите тесты и получайте признанные сертификаты, которые открывают двери в карьере.';

  @override
  String get onboardingNext => 'Далее';

  @override
  String get onboardingStart => 'Начать';

  @override
  String get splashAppName => 'Education Lab';

  @override
  String get splashTagline => 'Умная платформа обучения';

  @override
  String get loginTagline => 'Добро пожаловать на умную платформу обучения';

  @override
  String get loginAppName => 'EduLab';

  @override
  String get loginTabLogin => 'Войти';

  @override
  String get loginTabRegister => 'Новый аккаунт';

  @override
  String get loginEmailLabel => 'Электронная почта';

  @override
  String get loginEmailHint => 'example@email.com';

  @override
  String get loginPasswordLabel => 'Пароль';

  @override
  String get loginPasswordHint => '••••••';

  @override
  String get loginForgotPassword => 'Забыли пароль?';

  @override
  String get loginSubmit => 'Войти';

  @override
  String get loginSubmitLoading => 'Вход...';

  @override
  String get loginGuest => 'Войти как гость';

  @override
  String get loginOr => 'или';

  @override
  String get loginEmailRequired => 'Электронная почта обязательна';

  @override
  String get loginEmailInvalid =>
      'Введите действительный адрес электронной почты';

  @override
  String get loginPasswordRequired => 'Пароль обязателен';

  @override
  String get registerStepEmail => 'Почта';

  @override
  String get registerStepCode => 'Код';

  @override
  String get registerStepData => 'Данные';

  @override
  String get registerSendCodeInfo => 'Мы отправим код активации на эту почту';

  @override
  String get registerSendCode => 'Отправить код активации';

  @override
  String get registerVerifying => 'Проверка';

  @override
  String get registerCodeSentTo => 'Код отправлен на:';

  @override
  String get registerResendCode => 'Отправить код повторно';

  @override
  String get registerBack => 'Назад';

  @override
  String get registerVerifyCode => 'Подтвердить код';

  @override
  String get registerCodeIncomplete => 'Введите полный 6-значный код';

  @override
  String get registerFullNameLabel => 'Полное имя';

  @override
  String get registerFullNameHint => 'Ваше полное имя';

  @override
  String get registerPasswordHint =>
      'Минимум 8 символов, одна заглавная буква и одна цифра';

  @override
  String get registerConfirmLabel => 'Подтверждение пароля';

  @override
  String get registerConfirmHint => 'Введите пароль ещё раз';

  @override
  String get registerSubmit => 'Создать аккаунт';

  @override
  String get registerSubmitLoading => 'Создание аккаунта';

  @override
  String get registerSuccess => 'Аккаунт успешно создан';

  @override
  String get registerNameRequired => 'Полное имя обязательно';

  @override
  String get registerNameMinLength =>
      'Полное имя должно содержать минимум 6 символов';

  @override
  String get registerPasswordMinLength =>
      'Пароль должен содержать минимум 8 символов';

  @override
  String get registerPasswordUppercase =>
      'Пароль должен содержать минимум одну заглавную букву';

  @override
  String get registerPasswordNumber =>
      'Пароль должен содержать минимум одну цифру';

  @override
  String get registerConfirmRequired => 'Подтверждение пароля обязательно';

  @override
  String get registerConfirmMismatch => 'Пароли не совпадают';

  @override
  String get networkError => 'Ошибка соединения, попробуйте ещё раз';
}

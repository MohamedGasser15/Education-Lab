// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get onboardingSkip => 'Saltar';

  @override
  String get onboardingTitle1 => 'Bienvenido a EduLab';

  @override
  String get onboardingSubtitle1 =>
      'Tu plataforma ideal para el aprendizaje interactivo moderno y el crecimiento profesional continuo.';

  @override
  String get onboardingTitle2 => 'Aprende de los mejores instructores';

  @override
  String get onboardingSubtitle2 =>
      'Miles de cursos profesionales en programación, diseño, negocios y ciencia de datos. Alta calidad con una hoja de ruta clara.';

  @override
  String get onboardingTitle3 => 'Certificados y éxito garantizado';

  @override
  String get onboardingSubtitle3 =>
      'Sigue tu progreso, aprueba los exámenes y obtén certificados reconocidos que abren las puertas de tu carrera.';

  @override
  String get onboardingNext => 'Siguiente';

  @override
  String get onboardingStart => 'Comenzar';

  @override
  String get splashAppName => 'Education Lab';

  @override
  String get splashTagline => 'Plataforma de aprendizaje inteligente';

  @override
  String get loginTagline =>
      'Bienvenido a la plataforma de aprendizaje inteligente';

  @override
  String get loginAppName => 'EduLab';

  @override
  String get loginTabLogin => 'Iniciar sesión';

  @override
  String get loginTabRegister => 'Nueva cuenta';

  @override
  String get loginEmailLabel => 'Correo electrónico';

  @override
  String get loginEmailHint => 'example@email.com';

  @override
  String get loginPasswordLabel => 'Contraseña';

  @override
  String get loginPasswordHint => '••••••';

  @override
  String get loginForgotPassword => '¿Olvidaste tu contraseña?';

  @override
  String get loginSubmit => 'Iniciar sesión';

  @override
  String get loginSubmitLoading => 'Iniciando sesión';

  @override
  String get loginGuest => 'Entrar como invitado';

  @override
  String get loginOr => 'o';

  @override
  String get loginEmailRequired => 'El correo electrónico es obligatorio';

  @override
  String get loginEmailInvalid => 'Ingresa una dirección de correo válida';

  @override
  String get loginPasswordRequired => 'La contraseña es obligatoria';

  @override
  String get registerStepEmail => 'Correo';

  @override
  String get registerStepCode => 'Código';

  @override
  String get registerStepData => 'Detalles';

  @override
  String get registerSendCodeInfo =>
      'Enviaremos un código de activación a este correo';

  @override
  String get registerSendCode => 'Enviar código de activación';

  @override
  String get registerVerifying => 'Verificando';

  @override
  String get registerCodeSentTo => 'Código enviado a:';

  @override
  String get registerResendCode => 'Reenviar código';

  @override
  String get registerBack => 'Atrás';

  @override
  String get registerVerifyCode => 'Verificar código';

  @override
  String get registerCodeIncomplete =>
      'Ingresa el código completo de 6 dígitos';

  @override
  String get registerFullNameLabel => 'Nombre completo';

  @override
  String get registerFullNameHint => 'Tu nombre completo';

  @override
  String get registerPasswordHint =>
      'Al menos 8 caracteres, una mayúscula y un número';

  @override
  String get registerConfirmLabel => 'Confirmar contraseña';

  @override
  String get registerConfirmHint => 'Vuelve a ingresar tu contraseña';

  @override
  String get registerSubmit => 'Crear cuenta';

  @override
  String get registerSubmitLoading => 'Creando cuenta';

  @override
  String get registerSuccess => 'Cuenta creada con éxito';

  @override
  String get registerNameRequired => 'El nombre completo es obligatorio';

  @override
  String get registerNameMinLength =>
      'El nombre completo debe tener al menos 6 caracteres';

  @override
  String get registerPasswordMinLength =>
      'La contraseña debe tener al menos 8 caracteres';

  @override
  String get registerPasswordUppercase =>
      'La contraseña debe contener al menos una letra mayúscula';

  @override
  String get registerPasswordNumber =>
      'La contraseña debe contener al menos un número';

  @override
  String get registerConfirmRequired =>
      'La confirmación de la contraseña es obligatoria';

  @override
  String get registerConfirmMismatch => 'Las contraseñas no coinciden';

  @override
  String get networkError => 'Error de conexión, inténtalo de nuevo';
}

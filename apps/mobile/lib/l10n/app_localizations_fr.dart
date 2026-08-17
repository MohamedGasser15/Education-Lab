// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get onboardingSkip => 'Ignorer';

  @override
  String get onboardingTitle1 => 'Bienvenue sur EduLab';

  @override
  String get onboardingSubtitle1 =>
      'Votre plateforme idéale pour un apprentissage interactif moderne et une croissance professionnelle continue.';

  @override
  String get onboardingTitle2 => 'Apprenez auprès des meilleurs formateurs';

  @override
  String get onboardingSubtitle2 =>
      'Des milliers de cours professionnels en programmation, design, business et data science. Une haute qualité avec une feuille de route claire.';

  @override
  String get onboardingTitle3 => 'Certificats et réussite garantie';

  @override
  String get onboardingSubtitle3 =>
      'Suivez vos progrès, réussissez les tests et obtenez des certificats reconnus qui ouvrent les portes de votre carrière.';

  @override
  String get onboardingNext => 'Suivant';

  @override
  String get onboardingStart => 'Commencer';

  @override
  String get splashAppName => 'Education Lab';

  @override
  String get splashTagline => 'Plateforme d\'apprentissage intelligente';

  @override
  String get loginTagline =>
      'Bienvenue sur la plateforme d\'apprentissage intelligente';

  @override
  String get loginAppName => 'EduLab';

  @override
  String get loginTabLogin => 'Se connecter';

  @override
  String get loginTabRegister => 'Nouveau compte';

  @override
  String get loginEmailLabel => 'E-mail';

  @override
  String get loginEmailHint => 'example@email.com';

  @override
  String get loginPasswordLabel => 'Mot de passe';

  @override
  String get loginPasswordHint => '••••••';

  @override
  String get loginForgotPassword => 'Mot de passe oublié ?';

  @override
  String get loginSubmit => 'Se connecter';

  @override
  String get loginSubmitLoading => 'Connexion en cours';

  @override
  String get loginGuest => 'Rejoindre en tant qu\'invité';

  @override
  String get loginOr => 'ou';

  @override
  String get loginEmailRequired => 'L\'e-mail est requis';

  @override
  String get loginEmailInvalid => 'Saisissez une adresse e-mail valide';

  @override
  String get loginPasswordRequired => 'Le mot de passe est requis';

  @override
  String get registerStepEmail => 'E-mail';

  @override
  String get registerStepCode => 'Code';

  @override
  String get registerStepData => 'Détails';

  @override
  String get registerSendCodeInfo =>
      'Nous enverrons un code d\'activation à cet e-mail';

  @override
  String get registerSendCode => 'Envoyer le code d\'activation';

  @override
  String get registerVerifying => 'Vérification';

  @override
  String get registerCodeSentTo => 'Code envoyé à :';

  @override
  String get registerResendCode => 'Renvoyer le code';

  @override
  String get registerBack => 'Retour';

  @override
  String get registerVerifyCode => 'Vérifier le code';

  @override
  String get registerCodeIncomplete => 'Saisissez le code complet à 6 chiffres';

  @override
  String get registerFullNameLabel => 'Nom complet';

  @override
  String get registerFullNameHint => 'Votre nom complet';

  @override
  String get registerPasswordHint =>
      'Au moins 8 caractères, une majuscule et un chiffre';

  @override
  String get registerConfirmLabel => 'Confirmer le mot de passe';

  @override
  String get registerConfirmHint => 'Saisissez à nouveau votre mot de passe';

  @override
  String get registerSubmit => 'Créer un compte';

  @override
  String get registerSubmitLoading => 'Création du compte';

  @override
  String get registerSuccess => 'Compte créé avec succès';

  @override
  String get registerNameRequired => 'Le nom complet est requis';

  @override
  String get registerNameMinLength =>
      'Le nom complet doit contenir au moins 6 caractères';

  @override
  String get registerPasswordMinLength =>
      'Le mot de passe doit contenir au moins 8 caractères';

  @override
  String get registerPasswordUppercase =>
      'Le mot de passe doit contenir au moins une lettre majuscule';

  @override
  String get registerPasswordNumber =>
      'Le mot de passe doit contenir au moins un chiffre';

  @override
  String get registerConfirmRequired =>
      'La confirmation du mot de passe est requise';

  @override
  String get registerConfirmMismatch =>
      'Les mots de passe ne correspondent pas';

  @override
  String get networkError => 'Erreur de connexion, veuillez réessayer';
}

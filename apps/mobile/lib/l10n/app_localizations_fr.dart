// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get onboardingSkip => 'Passer';

  @override
  String get onboardingTitle1 => 'Bienvenue sur EduLab';

  @override
  String get onboardingSubtitle1 =>
      'Votre plateforme idéale pour un apprentissage interactif moderne et une évolution professionnelle.';

  @override
  String get onboardingTitle2 => 'Apprenez avec les meilleurs instructeurs';

  @override
  String get onboardingSubtitle2 =>
      'Des milliers de cours professionnels en programmation, design, business et science des données.';

  @override
  String get onboardingTitle3 => 'Certificats et succès garanti';

  @override
  String get onboardingSubtitle3 =>
      'Suivez vos progrès, réussissez vos tests et obtenez des certificats reconnus.';

  @override
  String get onboardingNext => 'Suivant';

  @override
  String get onboardingStart => 'Commencer';

  @override
  String get splashAppName => 'Education Lab';

  @override
  String get splashTagline => 'Plateforme d\'Apprentissage Intelligent';

  @override
  String get loginTagline =>
      'Bienvenue sur la plateforme d\'apprentissage intelligent';

  @override
  String get loginAppName => 'EduLab';

  @override
  String get loginTabLogin => 'Connexion';

  @override
  String get loginTabRegister => 'Créer un compte';

  @override
  String get loginEmailLabel => 'E-mail';

  @override
  String get loginEmailHint => 'exemple@email.com';

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
  String get loginGuest => 'Continuer en invité';

  @override
  String get loginOr => 'ou';

  @override
  String get loginEmailRequired => 'L\'e-mail est requis';

  @override
  String get loginEmailInvalid => 'Entrez un e-mail valide';

  @override
  String get loginPasswordRequired => 'Le mot de passe est requis';

  @override
  String get registerStepEmail => 'E-mail';

  @override
  String get registerStepCode => 'Code';

  @override
  String get registerStepData => 'Informations';

  @override
  String get registerSendCodeInfo =>
      'Nous vous enverrons un code d\'activation par e-mail';

  @override
  String get registerSendCode => 'Envoyer le code';

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
  String get registerCodeIncomplete => 'Entrez le code complet à 6 chiffres';

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
  String get registerConfirmHint => 'Confirmez votre mot de passe';

  @override
  String get registerSubmit => 'Créer le compte';

  @override
  String get registerSubmitLoading => 'Création du compte';

  @override
  String get registerSuccess => 'Compte créé avec succès';

  @override
  String get registerNameRequired => 'Le nom complet est requis';

  @override
  String get registerNameMinLength =>
      'Le nom complet doit comporter au moins 6 caractères';

  @override
  String get registerPasswordMinLength =>
      'Le mot de passe doit comporter au moins 8 caractères';

  @override
  String get registerPasswordUppercase =>
      'Le mot de passe doit contenir au moins une majuscule';

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

  @override
  String homeGreeting(String name) {
    return 'Bonjour, $name !';
  }

  @override
  String get homeSubtitle => 'Que voulez-vous apprendre aujourd\'hui ?';

  @override
  String get homeSearchHint => 'Rechercher un cours, une compétence...';

  @override
  String get homeSectionContinue => 'Reprendre l\'apprentissage';

  @override
  String get homeSectionRecommended => 'Recommandé pour vous';

  @override
  String get homeSectionPopular => 'Les plus populaires';

  @override
  String get homeSectionTopRated => 'Les mieux notés';

  @override
  String get homeSectionByCategory => 'Par catégorie';

  @override
  String get homeHeroTitle => 'Découvrez les offres maintenant';

  @override
  String get homeHeroSubtitle =>
      'Jusqu\'à 70% de réduction sur les cours phares';

  @override
  String get homeHeroButton => 'Découvrir';

  @override
  String get homeViewAll => 'Voir tout';

  @override
  String get homeProgressLabel => 'Terminé';

  @override
  String get exploreTitle => 'Explorer les cours';

  @override
  String get exploreSearchHint =>
      'Rechercher un cours, une compétence ou un formateur...';

  @override
  String get exploreAllCategories => 'Toutes les catégories';

  @override
  String get exploreFilter => 'Filtrer';

  @override
  String get exploreSort => 'Trier';

  @override
  String get exploreNoResults => 'Aucun résultat trouvé';

  @override
  String get exploreNoResultsHint =>
      'Essayez d\'autres mots-clés ou modifiez vos filtres';

  @override
  String exploreCoursesCount(int count) {
    return '$count cours';
  }

  @override
  String get exploreFilterTitle => 'Filtrer les résultats';

  @override
  String get exploreFilterApply => 'Appliquer';

  @override
  String get exploreFilterReset => 'Réinitialiser';

  @override
  String get exploreFilterPrice => 'Prix';

  @override
  String get exploreFilterLevel => 'Niveau';

  @override
  String get exploreFilterRating => 'Note';

  @override
  String get exploreFilterDuration => 'Durée';

  @override
  String get exploreSortTitle => 'Trier par';

  @override
  String get exploreSortRelevance => 'Pertinence';

  @override
  String get exploreSortNewest => 'Plus récent';

  @override
  String get exploreSortPopular => 'Plus populaire';

  @override
  String get exploreSortRating => 'Mieux noté';

  @override
  String get exploreSortPriceLow => 'Prix : croissant';

  @override
  String get exploreSortPriceHigh => 'Prix : décroissant';

  @override
  String get explorePriceFree => 'Gratuit';

  @override
  String get exploreLevelBeginner => 'Débutant';

  @override
  String get exploreLevelIntermediate => 'Intermédiaire';

  @override
  String get exploreLevelAdvanced => 'Avancé';

  @override
  String get learningTitle => 'Mon Apprentissage';

  @override
  String get learningTabInProgress => 'En cours';

  @override
  String get learningTabCompleted => 'Terminé';

  @override
  String get learningTabSaved => 'Enregistré';

  @override
  String get learningEmpty => 'Aucun cours pour le moment';

  @override
  String get learningEmptyHint =>
      'Commencez à explorer les cours dès maintenant';

  @override
  String get learningExploreButton => 'Explorer les cours';

  @override
  String learningProgress(int percent) {
    return '$percent% terminé';
  }

  @override
  String get learningContinue => 'Continuer';

  @override
  String get learningViewCertificate => 'Voir le certificat';

  @override
  String get learningReview => 'Évaluer le cours';

  @override
  String get learningLesson => 'Leçon';

  @override
  String get learningLessons => 'Leçons';

  @override
  String get cartTitle => 'Panier';

  @override
  String get cartEmpty => 'Votre panier est vide';

  @override
  String get cartEmptyHint => 'Ajoutez des cours pour commencer à apprendre';

  @override
  String get cartExploreButton => 'Explorer les cours';

  @override
  String get cartPromoPlaceholder => 'Code promo';

  @override
  String get cartPromoApply => 'Appliquer';

  @override
  String get cartPromoInvalid => 'Code promo invalide';

  @override
  String get cartSummary => 'Récapitulatif';

  @override
  String get cartSubtotal => 'Sous-total';

  @override
  String get cartDiscount => 'Remise';

  @override
  String get cartTotal => 'Total';

  @override
  String get cartCheckout => 'Passer commande';

  @override
  String cartCourses(int count) {
    return '$count cours';
  }

  @override
  String get cartRemove => 'Supprimer';

  @override
  String get cartGuarantee => 'Garantie satisfait ou remboursé de 30 jours';

  @override
  String get checkoutTitle => 'Paiement';

  @override
  String get checkoutStepPayment => 'Paiement';

  @override
  String get checkoutStepReview => 'Vérification';

  @override
  String get checkoutStepConfirm => 'Confirmation';

  @override
  String get checkoutOrderSummary => 'Récapitulatif';

  @override
  String get checkoutTotal => 'Total';

  @override
  String get checkoutPayNow => 'Payer maintenant';

  @override
  String get checkoutBack => 'Retour';

  @override
  String get checkoutNext => 'Suivant';

  @override
  String get checkoutSecureSSL =>
      'Paiement sécurisé avec cryptage SSL 256 bits';

  @override
  String get checkoutSuccessTitle => 'Achat réussi !';

  @override
  String get checkoutSuccessSubtitle =>
      'Vous pouvez maintenant accéder à votre cours';

  @override
  String get checkoutGoToLearning => 'Accéder à mes cours';

  @override
  String get checkoutPaymentMethod => 'Moyen de paiement';

  @override
  String get checkoutCardNumber => 'Numéro de carte';

  @override
  String get checkoutCardName => 'Nom sur la carte';

  @override
  String get checkoutCardExpiry => 'Date d\'expiration';

  @override
  String get checkoutCardCVV => 'CVV';

  @override
  String get courseDetailsEnroll => 'S\'inscrire';

  @override
  String get courseDetailsBuyNow => 'Acheter maintenant';

  @override
  String get courseDetailsAddToCart => 'Ajouter au panier';

  @override
  String get courseDetailsAddedToCart => 'Ajouté au panier';

  @override
  String get courseDetailsAlreadyEnrolled => 'Déjà inscrit';

  @override
  String get courseDetailsGoToCourse => 'Accéder au cours';

  @override
  String get courseDetailsFree => 'Gratuit';

  @override
  String courseDetailsStudents(String count) {
    return '$count étudiants';
  }

  @override
  String get courseDetailsRating => 'Note';

  @override
  String get courseDetailsReviews => 'avis';

  @override
  String get courseDetailsLastUpdated => 'Dernière mise à jour';

  @override
  String get courseDetailsCurriculum => 'Programme du cours';

  @override
  String get courseDetailsSection => 'section';

  @override
  String get courseDetailsLessons => 'leçons';

  @override
  String get courseDetailsInstructor => 'Formateur';

  @override
  String get courseDetailsStudentsLabel => 'Étudiants';

  @override
  String get courseDetailsCoursesLabel => 'Cours';

  @override
  String get courseDetailsReviewsLabel => 'Avis';

  @override
  String get courseDetailsReviewsTitle => 'Avis des étudiants';

  @override
  String get courseDetailsWhatLearn => 'Ce que vous allez apprendre';

  @override
  String get courseDetailsRequirements => 'Prérequis';

  @override
  String get courseDetailsDescription => 'Description du cours';

  @override
  String get courseDetailsIncludesTitle => 'Ce cours comprend';

  @override
  String get courseDetailsHoursVideo => 'heures de vidéo';

  @override
  String get courseDetailsArticles => 'articles';

  @override
  String get courseDetailsMobileAccess => 'Accès mobile et tablette';

  @override
  String get courseDetailsCertificate => 'Certificat de fin de formation';

  @override
  String get courseDetailsLifetimeAccess => 'Accès à vie';

  @override
  String get lessonPlayerNotes => 'Mes notes';

  @override
  String get lessonPlayerResources => 'Ressources';

  @override
  String get lessonPlayerDiscussion => 'Discussion';

  @override
  String get lessonPlayerPrev => 'Précédent';

  @override
  String get lessonPlayerNext => 'Suivant';

  @override
  String get lessonPlayerSpeed => 'Vitesse';

  @override
  String get lessonPlayerQuality => 'Qualité';

  @override
  String get lessonPlayerCompleted => 'Leçon terminée';

  @override
  String get certificateTitle => 'Certificat de Réussite';

  @override
  String get certificatePresentedTo => 'Décerné à';

  @override
  String get certificateCompletedCourse => 'pour avoir complété avec succès';

  @override
  String get certificateIssuedOn => 'Délivré le';

  @override
  String get certificateVerificationId => 'Identifiant de vérification';

  @override
  String get certificateDownloadPDF => 'Télécharger en PDF';

  @override
  String get certificateDownloadPNG => 'Télécharger l\'image';

  @override
  String get certificateCopyLink => 'Copier le lien';

  @override
  String get certificateLinkCopied => 'Lien copié';

  @override
  String get profileTitle => 'Profil';

  @override
  String get profileEditProfile => 'Modifier le profil';

  @override
  String get profileCourses => 'Mes Cours';

  @override
  String get profileCertificates => 'Certificats';

  @override
  String get profilePoints => 'Points';

  @override
  String get profileFollowers => 'Abonnés';

  @override
  String get profileFollowing => 'Abonnements';

  @override
  String get profileBio => 'Biographie';

  @override
  String get profileInstructor => 'Formateur';

  @override
  String get profileStudent => 'Étudiant';

  @override
  String get profileLevel => 'Niveau';

  @override
  String get profileJoined => 'Inscrit en';

  @override
  String get profileShareProfile => 'Partager le profil';

  @override
  String get profileMenuLearning => 'Mes Cours';

  @override
  String get profileMenuCertificates => 'Mes Certificats';

  @override
  String get profileMenuPurchaseHistory => 'Historique des Achats';

  @override
  String get profileMenuTeachApplication => 'Enseigner sur EduLab';

  @override
  String get profileMenuAccountSecurity => 'Sécurité du Compte';

  @override
  String get profileMenuNotifications => 'Notifications';

  @override
  String get profileMenuMessages => 'Messages';

  @override
  String get profileMenuSettings => 'Paramètres';

  @override
  String get profileMenuSchedule => 'Mon Emploi du Temps';

  @override
  String get profileMenuAssignments => 'Devoirs';

  @override
  String get profileMenuQuiz => 'Quiz';

  @override
  String get profileMenuLogout => 'Se Déconnecter';

  @override
  String get profileLogoutConfirm =>
      'Êtes-vous sûr de vouloir vous déconnecter ?';

  @override
  String get profileLogoutYes => 'Oui, déconnexion';

  @override
  String get profileLogoutNo => 'Annuler';

  @override
  String get editProfileTitle => 'Modifier le Profil';

  @override
  String get editProfileSave => 'Enregistrer';

  @override
  String get editProfileFullName => 'Nom complet';

  @override
  String get editProfileBio => 'Biographie';

  @override
  String get editProfileEmail => 'E-mail';

  @override
  String get editProfilePhone => 'Téléphone';

  @override
  String get editProfileWebsite => 'Site web';

  @override
  String get editProfileSaved => 'Modifications enregistrées';

  @override
  String get accountSecurityTitle => 'Sécurité du Compte';

  @override
  String get accountSecurityChangePassword => 'Changer le mot de passe';

  @override
  String get accountSecurityTwoFactor => 'Authentification à deux facteurs';

  @override
  String get accountSecurityActiveSessions => 'Sessions actives';

  @override
  String get accountSecurityDeleteAccount => 'Supprimer le compte';

  @override
  String get purchaseHistoryTitle => 'Historique des Achats';

  @override
  String get purchaseHistoryEmpty => 'Aucun achat pour le moment';

  @override
  String get purchaseHistoryGuarantee =>
      'Garantie satisfait ou remboursé de 30 jours';

  @override
  String get purchaseHistoryDate => 'Date de la transaction';

  @override
  String get purchaseHistoryStatus => 'Statut';

  @override
  String get purchaseHistoryAmount => 'Montant';

  @override
  String get purchaseHistoryCompleted => 'Terminé';

  @override
  String get purchaseHistoryRefunded => 'Remboursé';

  @override
  String get teachApplicationTitle => 'Enseigner sur EduLab';

  @override
  String get teachApplicationSubmit => 'Envoyer ma candidature';

  @override
  String get teachApplicationSent => 'Votre candidature a été envoyée';

  @override
  String get notificationsTitle => 'Notifications';

  @override
  String get notificationsMarkAllRead => 'Tout marquer comme lu';

  @override
  String get notificationsMarkAllReadSnackbar =>
      'Toutes les notifications marquées comme lues';

  @override
  String get notificationsEmpty => 'Aucune notification';

  @override
  String get notification1Title => 'Rappel : Continuez votre cours';

  @override
  String get notification1Message =>
      'Vous avez une nouvelle leçon dans Flutter pour Débutants';

  @override
  String get notification1Time => 'Il y a 5 minutes';

  @override
  String get notification1Action => 'Reprendre le cours';

  @override
  String get notification2Title => 'Votre certificat est prêt !';

  @override
  String get notification2Message => 'Vous avez terminé la formation UI/UX.';

  @override
  String get notification2Time => 'Il y a 2 heures';

  @override
  String get notification2Action => 'Voir le certificat';

  @override
  String get notification3Title => 'Offre exclusive';

  @override
  String get notification3Message => '70% de remise sur les cours de code';

  @override
  String get notification3Time => 'Il y a 1 jour';

  @override
  String get notification3Action => 'Découvrir l\'offre';

  @override
  String get notification4Title => 'Nouvelle réponse';

  @override
  String get notification4Message => 'Le formateur a répondu à votre question';

  @override
  String get notification4Time => 'Il y a 2 jours';

  @override
  String get notification4Action => 'Voir la réponse';

  @override
  String get notification5Title => 'Mise à jour du cours';

  @override
  String get notification5Message => 'Nouveau contenu ajouté au cours Python';

  @override
  String get notification5Time => 'Il y a 3 jours';

  @override
  String get messagesTitle => 'Messages';

  @override
  String get settingsTitle => 'Paramètres & Préférences';

  @override
  String get settingsVideoDownload => 'Vidéo & Téléchargement';

  @override
  String get settingsDownloadQuality => 'Qualité de téléchargement par défaut';

  @override
  String get settingsWifiOnly => 'Télécharger en Wi-Fi uniquement';

  @override
  String get settingsNotifications => 'Notifications & Alertes';

  @override
  String get settingsCourseNotifications =>
      'Notifications des cours et messages';

  @override
  String get settingsPromoNotifications => 'Offres et promotions exclusives';

  @override
  String get settingsAppearance => 'Apparence & Langue';

  @override
  String get settingsDarkMode => 'Mode Sombre';

  @override
  String get settingsDarkModeEnabled => 'Activé (économise la batterie)';

  @override
  String get settingsDarkModeDisabled => 'Désactivé (mode clair)';

  @override
  String get settingsLanguage => 'Langue de l\'application';

  @override
  String get settingsStorage => 'Stockage & Cache';

  @override
  String get settingsClearCache => 'Vider le cache';

  @override
  String get settingsClearCacheSuccess => 'Cache vidé avec succès';

  @override
  String get settingsHelp => 'Informations & Politiques';

  @override
  String get settingsHelpCenter => 'Centre d\'aide et FAQ';

  @override
  String get settingsTermsPrivacy => 'Conditions & Confidentialité';

  @override
  String get settingsAbout => 'À propos d\'EduLab';

  @override
  String get settingsVersion => 'Version v1.0.0';

  @override
  String get quizTitle => 'Quiz';

  @override
  String get quizNext => 'Question suivante';

  @override
  String get quizSubmit => 'Soumettre le quiz';

  @override
  String get quizScore => 'Résultat du quiz';

  @override
  String get quizCorrectAnswers => 'Bonnes réponses';

  @override
  String get scheduleTitle => 'Mon Emploi du Temps';

  @override
  String get scheduleEmpty => 'Aucune session programmée';

  @override
  String get scheduleJoin => 'Rejoindre la session';

  @override
  String get scheduleReminder => 'Rappel';

  @override
  String get assignmentsTitle => 'Devoirs';

  @override
  String get assignmentsEmpty => 'Aucun devoir';

  @override
  String get assignmentsSubmit => 'Rendre le devoir';

  @override
  String get assignmentsDue => 'Date limite';

  @override
  String get assignmentsSubmitted => 'Rendu';

  @override
  String get assignmentsPending => 'En attente';

  @override
  String get languageArabic => 'Arabe';

  @override
  String get languageEnglish => 'Anglais';

  @override
  String get languageDialogTitle => 'Choisir la langue';

  @override
  String get languageSelect => 'Sélectionner';

  @override
  String get generalCancel => 'Annuler';

  @override
  String get generalConfirm => 'Confirmer';

  @override
  String get generalSave => 'Enregistrer';

  @override
  String get generalDelete => 'Supprimer';

  @override
  String get generalEdit => 'Modifier';

  @override
  String get generalClose => 'Fermer';

  @override
  String get generalBack => 'Retour';

  @override
  String get generalDone => 'Terminé';

  @override
  String get generalOk => 'OK';

  @override
  String get generalYes => 'Oui';

  @override
  String get generalNo => 'Non';

  @override
  String get generalLoading => 'Chargement...';

  @override
  String get generalError => 'Une erreur est survenue';

  @override
  String get generalRetry => 'Réessayer';

  @override
  String get generalNoInternet => 'Pas de connexion internet';

  @override
  String get generalFree => 'Gratuit';

  @override
  String get generalRating => 'Note';

  @override
  String get generalStudents => 'Étudiants';

  @override
  String get generalHours => 'Heures';

  @override
  String get generalMinutes => 'Minutes';

  @override
  String get generalBy => 'Par';

  @override
  String get navHome => 'Accueil';

  @override
  String get navExplore => 'Explorer';

  @override
  String get navMyCourses => 'Mes Cours';

  @override
  String get navCart => 'Panier';

  @override
  String get navAccount => 'Compte';

  @override
  String get homeSubGreeting => 'Que souhaitez-vous apprendre aujourd\'hui ?';

  @override
  String get homeVisitor => 'Invité';

  @override
  String get homePromoTitle => 'Découvrez les offres maintenant';

  @override
  String get homePromoSubtitle =>
      'Jusqu\'à 70% de réduction sur les cours phares';

  @override
  String get homePromoButton => 'Découvrir';

  @override
  String get homePromoBadge => 'Offre exclusive';

  @override
  String get homeContinueLearning => 'Continuer à apprendre';

  @override
  String get homeMyCoursesLink => 'Mes cours';

  @override
  String get homeLesson => 'leçon';

  @override
  String homeStudentsCount(String count) {
    return '$count étudiants';
  }

  @override
  String get homeRecommendedTitle => 'Recommandé pour vous';

  @override
  String get homeRecommendedSubtitle => 'Personnalisé selon vos intérêts';

  @override
  String get homeBestsellersTitle => 'Meilleures ventes';

  @override
  String get homeBestsellersSubtitle =>
      'Les cours les plus populaires et les mieux notés';

  @override
  String get homeNewCoursesTitle => 'Nouveaux cours';

  @override
  String get homeNewCoursesSubtitle => 'Contenu récent et actualisé';

  @override
  String get homePopularTopicsTitle => 'Sujets populaires';

  @override
  String get homePopularTopicsSubtitle =>
      'Apprenez les compétences les plus recherchées';

  @override
  String get homeTopInstructorsTitle => 'Meilleurs instructeurs';

  @override
  String get homeTopInstructorsSubtitle =>
      'Apprenez avec des experts certifiés';

  @override
  String get homeExploreCategoriesTitle => 'Explorer les catégories';

  @override
  String get homeExploreCategoriesSubtitle => 'Trouvez le cours idéal';

  @override
  String get catAll => 'Tous';

  @override
  String get catWebDev => 'Développement Web';

  @override
  String get catMobileApps => 'Applications Mobiles';

  @override
  String get catDataScience => 'Science des Données';

  @override
  String get catUIUX => 'Design UI/UX';

  @override
  String get catBusiness => 'Business & Gestion';

  @override
  String get catAI => 'Intelligence Artificielle';

  @override
  String get catCyberSecurity => 'Cybersécurité';

  @override
  String get exploreNoResultsTitle => 'Aucun résultat trouvé';

  @override
  String get exploreNoResultsSubtitle =>
      'Essayez d\'autres mots-clés ou modifiez vos filtres';

  @override
  String get exploreRecentSearches => 'Recherches récentes';

  @override
  String get exploreTopSearches => 'Tendances de recherche';

  @override
  String get exploreBrowseCategories => 'Parcourir les catégories';

  @override
  String get exploreBrowseCategoriesSubtitle => 'Trouvez le cours idéal';

  @override
  String get exploreBackToAll => 'Retour à tout';

  @override
  String get exploreClearAll => 'Tout effacer';

  @override
  String get exploreAvailableResults => 'résultats disponibles';

  @override
  String get exploreFilterBestseller => 'Meilleure vente';

  @override
  String get exploreFilterTopRated => 'Mieux noté';

  @override
  String get exploreFilterUnder50 => 'Moins de 50 \$';

  @override
  String get learningHeroTitle => 'Poursuivez votre formation';

  @override
  String get learningSearchHint => 'Rechercher dans mes cours...';

  @override
  String get learningFilterAll => 'Tous';

  @override
  String get learningFilterInProgress => 'En cours';

  @override
  String get learningFilterCompleted => 'Terminés';

  @override
  String get learningFilterDownloaded => 'Téléchargés';

  @override
  String get learningEmptyTitle => 'Aucun cours pour le moment';

  @override
  String get learningEmptySubtitle =>
      'Commencez à explorer les cours dès maintenant';

  @override
  String get learningEmptySearch => 'Aucun résultat pour votre recherche';

  @override
  String get learningCompleted => 'Terminé';

  @override
  String get learningCompletedBadge => 'Terminé';

  @override
  String learningLecturesCount(int count) {
    return '$count leçons';
  }

  @override
  String get cartEmptyTitle => 'Votre panier est vide';

  @override
  String get cartEmptySubtitle =>
      'Ajoutez des cours pour commencer à apprendre';

  @override
  String get cartCouponHint => 'Entrez le code promo';

  @override
  String get cartCouponApply => 'Appliquer';

  @override
  String get cartCouponInvalid => 'Code invalide';

  @override
  String get cartCouponApplied => 'Code promo appliqué';

  @override
  String get cartCouponDiscount => 'Remise du code';

  @override
  String get cartCouponsTitle => 'Codes promo';

  @override
  String get cartOrderSummary => 'Récapitulatif de la commande';

  @override
  String get cartOriginalPrice => 'Prix d\'origine';

  @override
  String get cartPlatformDiscount => 'Remise de la plateforme';

  @override
  String get cartFinalTotal => 'Total final';

  @override
  String cartItemsCount(int count) {
    return '$count cours';
  }

  @override
  String get cartRemovedSnackbar => 'Cours retiré du panier';

  @override
  String get cartUndo => 'Annuler';

  @override
  String get cartAddButton => 'Ajouter au panier';

  @override
  String get cartAddedSnackbar => 'Ajouté au panier';

  @override
  String get cartAlreadyInCart => 'Déjà dans le panier';

  @override
  String get cartCheckoutButton => 'Passer à la caisse';

  @override
  String get cartRecommendedTitle => 'Vous pourriez aussi aimer';

  @override
  String get cartRecommendedSubtitle => 'Cours recommandés selon votre panier';

  @override
  String get checkoutCreditCard => 'Carte bancaire';

  @override
  String get checkoutSelectPayment => 'Sélectionnez le mode de paiement';

  @override
  String get checkoutCardNumberLabel => 'Numéro de carte';

  @override
  String get checkoutCardHolderLabel => 'Nom du titulaire';

  @override
  String get checkoutExpiryLabel => 'Date d\'expiration';

  @override
  String get checkoutCVVLabel => 'CVV';

  @override
  String get checkoutPersonalInfoTitle => 'Informations personnelles';

  @override
  String get checkoutFullNameLabel => 'Nom complet';

  @override
  String get checkoutFullNameHint => 'Votre nom complet';

  @override
  String get checkoutFullNameRequired => 'Le nom complet est requis';

  @override
  String get checkoutPhoneLabel => 'Téléphone';

  @override
  String get checkoutPhoneRequired => 'Le numéro de téléphone est requis';

  @override
  String get checkoutPostalLabel => 'Code postal';

  @override
  String get checkoutPostalRequired => 'Le code postal est requis';

  @override
  String get checkoutBuyerInfo => 'Informations de l\'acheteur';

  @override
  String get checkoutSaveInfo => 'Enregistrer mes informations';

  @override
  String get checkoutMoneyBackGuarantee =>
      'Garantie satisfait ou remboursé de 30 jours';

  @override
  String get checkoutContinueToPayment => 'Continuer vers le paiement';

  @override
  String get checkoutContinueToReview => 'Continuer vers la vérification';

  @override
  String get checkoutReviewConfirm => 'Vérifier et confirmer';

  @override
  String get checkoutStartLearning => 'Commencer à apprendre';

  @override
  String get checkoutBackHome => 'Retour à l\'accueil';

  @override
  String get courseDetailsTitle => 'Détails du cours';

  @override
  String get courseDetailsShare => 'Partager';

  @override
  String get courseDetailsWhatYouWillLearn => 'Ce que vous allez apprendre';

  @override
  String get courseDetailsLanguage => 'Langue';

  @override
  String get courseDetailsCreatedBy => 'Créé par';

  @override
  String get courseDetailsPreviewLesson => 'Aperçu de la leçon';

  @override
  String get courseDetailsHoursOnDemand => 'heures de vidéo à la demande';

  @override
  String get courseDetailsFullLifetimeAccess => 'Accès complet à vie';

  @override
  String get courseDetailsCertifiedCertificate =>
      'Certificat de réussite certifié';

  @override
  String get courseDetailsComprehensiveContent => 'Contenu complet';

  @override
  String get certTitle => 'Certificat de Réussite';

  @override
  String get certStudentNameLabel => 'Étudiant';

  @override
  String get certCourseLabel => 'Cours';

  @override
  String get certInstructorLabel => 'Formateur';

  @override
  String get certIssueDateLabel => 'Date d\'émission';

  @override
  String get certCodeLabel => 'Numéro de certificat';

  @override
  String get certVerifiedBadge => 'Certifié';

  @override
  String get certDownloadPDF => 'Télécharger en PDF';

  @override
  String get certDownloadPNG => 'Télécharger l\'image';

  @override
  String get certCopyVerifyLink => 'Copier le lien de vérification';

  @override
  String get certShare => 'Partager le certificat';

  @override
  String get playerTabLessons => 'Leçons';

  @override
  String get playerTabOverview => 'Aperçu';

  @override
  String get playerTabNotes => 'Mes notes';

  @override
  String get playerTabQnA => 'Questions-réponses';

  @override
  String get playerNextLesson => 'Leçon suivante';

  @override
  String get profileWelcome => 'Bienvenue';

  @override
  String get profileLoginPrompt => 'Connectez-vous pour accéder à votre profil';

  @override
  String get profileLoginOrRegister => 'Connexion / Créer un compte';

  @override
  String get profileVerifiedStudent => 'Étudiant vérifié';

  @override
  String get profileLogout => 'Déconnexion';

  @override
  String get profileCancel => 'Annuler';

  @override
  String get profileLogoutConfirmTitle => 'Déconnexion';

  @override
  String get profileLogoutConfirmMessage =>
      'Êtes-vous sûr de vouloir vous déconnecter ?';

  @override
  String get profileAccountSettings => 'Paramètres du compte';

  @override
  String get profileEditProfileSubtitle => 'Modifiez vos informations';

  @override
  String get profileSecurity => 'Sécurité du compte';

  @override
  String get profileSecuritySubtitle => 'Mot de passe et authentification';

  @override
  String get profilePurchaseHistory => 'Historique d\'achat';

  @override
  String get profilePurchaseHistorySubtitle => 'Consulter vos commandes';

  @override
  String get profileCertificatesSubtitle => 'Vos certificats obtenus';

  @override
  String get profileTeach => 'Enseigner sur EduLab';

  @override
  String get profileTeachSubtitle => 'Partagez votre expertise';

  @override
  String get profilePreferences => 'Préférences';

  @override
  String get profilePreferencesSubtitle => 'Paramètres et affichage';

  @override
  String get profileNotifications => 'Notifications';

  @override
  String get profileNotificationsSubtitle => 'Gérer les alertes';

  @override
  String get profileHelpSupport => 'Aide & Support';

  @override
  String get profileTerms => 'Conditions d\'utilisation';

  @override
  String get profilePrivacy => 'Politique de confidentialité';

  @override
  String get profileAboutEduLab => 'À propos d\'EduLab';

  @override
  String get profileWishlist => 'Favoris';

  @override
  String get securityTitle => 'Sécurité du Compte';

  @override
  String get teachTitle => 'Enseigner sur EduLab';

  @override
  String get notificationsTabAll => 'Toutes';

  @override
  String get notificationsTabCourses => 'Cours';

  @override
  String get notificationsTabPromos => 'Offres';

  @override
  String get notificationsEmptyTitle => 'Aucune notification';

  @override
  String get notificationsUnread => 'Non lues';

  @override
  String get wishlistTitle => 'Favoris';

  @override
  String get wishlistEmptyTitle => 'Votre liste de favoris est vide';

  @override
  String get wishlistEmptySubtitle =>
      'Enregistrez les cours qui vous intéressent';

  @override
  String get wishlistAddToCart => 'Ajouter au panier';

  @override
  String get wishlistRemovedSnackbar => 'Retiré des favoris';

  @override
  String get homeDefaultUser => 'Étudiant';

  @override
  String get learningOf => 'sur';

  @override
  String get cartInCartBadge => 'Dans le panier';

  @override
  String get homePromo1Badge => 'Grande promo • Durée limitée';

  @override
  String get homePromo1Title => 'Apprenez aux meilleurs prix';

  @override
  String get homePromo1Subtitle =>
      'Jusqu\'à 65% de réduction sur les cours de programmation, design et business.';

  @override
  String get homePromo1Button => 'Voir les offres';

  @override
  String get homePromo2Badge => 'Parcours certifiés';

  @override
  String get homePromo2Title => 'Préparez la carrière de vos rêves';

  @override
  String get homePromo2Subtitle =>
      'Des formations complètes avec projets pratiques et certificats reconnus.';

  @override
  String get homePromo2Button => 'Explorer les parcours';

  @override
  String get homePromo3Badge => 'Experts et formateurs d\'élite';

  @override
  String get homePromo3Title => 'Apprenez auprès des meilleurs spécialistes';

  @override
  String get homePromo3Subtitle =>
      'Contenu régulièrement mis à jour pour maîtriser les technologies actuelles.';

  @override
  String get homePromo3Button => 'Commencer maintenant';

  @override
  String get homePromoInstructorBadge =>
      'Enseigner sur EduLab • Partager le savoir';

  @override
  String get homePromoInstructorTitle => 'Devenez formateur dès aujourd\'hui';

  @override
  String get homePromoInstructorSubtitle =>
      'Inspirez des apprenants du monde entier, créez des cours et gagnez des revenus en enseignant ce que vous aimez.';

  @override
  String get homePromoInstructorButton => 'Postuler';

  @override
  String get homeSearchFilter => 'Filtrer';

  @override
  String get securitySectionChangePassword => 'Changer le mot de passe';

  @override
  String get securityCurrentPasswordLabel => 'Mot de passe actuel *';

  @override
  String get securityCurrentPasswordError => 'Entrez le mot de passe actuel';

  @override
  String get securityNewPasswordLabel => 'Nouveau mot de passe *';

  @override
  String get securityNewPasswordError => 'Doit comporter au moins 8 caractères';

  @override
  String get securityConfirmPasswordLabel =>
      'Confirmer le nouveau mot de passe *';

  @override
  String get securityConfirmPasswordError =>
      'Les mots de passe ne correspondent pas';

  @override
  String get securityUpdatePasswordBtn => 'Mettre à jour le mot de passe';

  @override
  String get securityPasswordUpdatedSuccess =>
      'Mot de passe modifié avec succès !';

  @override
  String get securitySection2FA => 'Authentification à deux facteurs (2FA)';

  @override
  String get security2FATitle => 'Authentification à deux facteurs';

  @override
  String get security2FAEnabledDesc =>
      'Activée - Sécurise votre compte avec un code';

  @override
  String get security2FADisabledDesc => 'Désactivée (Recommandé)';

  @override
  String get security2FASetupTitle =>
      'Activer l\'authentification à deux facteurs';

  @override
  String get security2FASetupContent =>
      'Un code de vérification à 6 chiffres sera envoyé à votre adresse e-mail lors de chaque nouvelle connexion.';

  @override
  String get security2FAEnableNow => 'Activer maintenant';

  @override
  String get security2FAEnabledSuccess =>
      'Authentification à deux facteurs activée avec succès !';

  @override
  String get security2FADisabledSuccess =>
      'Authentification à deux facteurs désactivée';

  @override
  String get securitySectionSessions => 'Sessions et appareils actifs';

  @override
  String get securityLogoutAllDevices => 'Déconnecter tous les appareils';

  @override
  String get securityThisDevice => 'Cet appareil';

  @override
  String get securitySessionRevokedSuccess =>
      'Session terminée et appareil déconnecté.';

  @override
  String get securityAllSessionsRevokedSuccess =>
      'Déconnecté de tous les autres appareils.';

  @override
  String get purchaseHistoryInvoiceCertified =>
      'Facture électronique certifiée';

  @override
  String get purchaseHistoryInvoiceNumber => 'Numéro de facture';

  @override
  String get purchaseHistoryCourse => 'Cours';

  @override
  String get purchaseHistoryPaymentMethod => 'Moyen de paiement';

  @override
  String get purchaseHistoryTotalAmount => 'Montant total :';

  @override
  String get purchaseHistoryClose => 'Fermer';

  @override
  String get purchaseHistoryDownloadPdf => 'Télécharger le PDF';

  @override
  String get purchaseHistoryPdfDownloaded =>
      'Facture PDF téléchargée avec succès';

  @override
  String get purchaseHistoryRefundRequestTitle => 'Demande de remboursement';

  @override
  String get purchaseHistoryRefundPolicy =>
      'Conformément à la garantie satisfait ou remboursé de 30 jours d\'EduLab, vous pouvez obtenir un remboursement complet.';

  @override
  String get purchaseHistoryRefundReasonHint =>
      'Raison du remboursement (facultatif)...';

  @override
  String get purchaseHistoryConfirmRefund => 'Confirmer le remboursement';

  @override
  String get purchaseHistoryRefundSubmitted =>
      'Demande de remboursement envoyée (délai : 3-5 jours ouvrés).';

  @override
  String get purchaseHistoryInstructor => 'Instructeur';

  @override
  String get purchaseHistoryRequestRefundBtn => 'Demander un remboursement';

  @override
  String get purchaseHistoryInvoiceBtn => 'Facture';

  @override
  String get purchaseHistoryStatusCompleted => 'Terminé';

  @override
  String get purchaseHistoryStatusRefunded => 'Remboursé';

  @override
  String get purchaseHistoryStatusProcessingRefund => 'Remboursement en cours';

  @override
  String get editProfileSectionBasicInfo => 'Informations de base';

  @override
  String get editProfileFullNameLabel => 'Nom complet *';

  @override
  String get editProfileFullNameHint => 'Entrez votre nom complet';

  @override
  String get editProfileFullNameError => 'Veuillez entrer votre nom complet';

  @override
  String get editProfileHeadlineLabel => 'Titre professionnel';

  @override
  String get editProfileHeadlineHint => 'ex. Développeur Flutter Senior';

  @override
  String get editProfileLocationLabel => 'Ville / Pays';

  @override
  String get editProfileLocationHint => 'Paris, France';

  @override
  String get editProfilePhoneLabel => 'Téléphone portable';

  @override
  String get editProfileBioLabel => 'À propos de moi (Bio)';

  @override
  String get editProfileBioHint =>
      'Rédigez un bref résumé de vos centres d\'intérêt et expériences...';

  @override
  String get editProfileSectionLinks => 'Liens et réseaux professionnels';

  @override
  String get editProfileWebsiteLabel => 'Site web personnel';

  @override
  String get editProfileSectionEmail => 'Adresse e-mail enregistrée';

  @override
  String get editProfileEmailDesc =>
      'Liée à votre compte pour la connexion et l\'obtention des certificats';

  @override
  String get editProfileEmailVerified => 'Vérifié';

  @override
  String get editProfileSaveChangesBtn => 'Enregistrer les modifications';

  @override
  String get editProfileSavedSuccess => 'Profil mis à jour avec succès !';

  @override
  String get editProfileChangeAvatarTitle => 'Changer la photo de profil';

  @override
  String get editProfileTakePhoto => 'Prendre une photo';

  @override
  String get editProfileChooseGallery => 'Choisir dans la galerie';

  @override
  String get editProfilePhotoUpdatedSuccess =>
      'Photo de profil mise à jour avec succès';

  @override
  String get teachJoinInstructorTitle => 'Devenir formateur certifié';

  @override
  String get teachJoinInstructorSubtitle =>
      'Publiez vos cours et partagez votre expertise avec des milliers d\'étudiants.';

  @override
  String get teachStep1Title => 'Informations personnelles';

  @override
  String get teachStep2Title => 'Expérience et compétences';

  @override
  String get teachStep3Title => 'Confirmation';

  @override
  String get teachStep1Header =>
      '1. Informations personnelles et professionnelles';

  @override
  String get teachFullNameArabicLabel => 'Nom complet *';

  @override
  String get teachFullNameArabicHint => 'ex. Jean Dupont';

  @override
  String get teachHeadlineLabel => 'Titre professionnel et spécialité *';

  @override
  String get teachHeadlineHint =>
      'ex. Architecte logiciel senior et formateur Flutter';

  @override
  String get teachPhoneLabel => 'Numéro de téléphone *';

  @override
  String get teachCountryLabel => 'Pays de résidence *';

  @override
  String get teachBioLabel => 'Présentation et expérience passée *';

  @override
  String get teachBioHint =>
      'Rédigez un court résumé de votre parcours et de vos réalisations...';

  @override
  String get teachNextStepSkills => 'Continuer : Expérience et compétences';

  @override
  String get teachStep2Header => '2. Contenu du cours et compétences';

  @override
  String get teachTopicLabel => 'Sujet ou parcours du cours proposé *';

  @override
  String get teachTopicHint => 'ex. Développement Flutter de zéro à héros';

  @override
  String get teachYearsExperienceLabel =>
      'Années d\'expérience dans le domaine *';

  @override
  String get teachVideoLinkLabel =>
      'Lien vers une vidéo de démonstration (YouTube/Drive/Loom) *';

  @override
  String get teachTargetAudienceLabel => 'Public cible du cours *';

  @override
  String get teachAudienceBeginners => 'Débutants complets';

  @override
  String get teachAudienceIntermediate => 'Débutants et intermédiaires';

  @override
  String get teachAudienceAdvanced => 'Développeurs avancés et professionnels';

  @override
  String get teachAudienceAll => 'Tous niveaux';

  @override
  String get teachSkillsCoveredLabel =>
      'Compétences et technologies couvertes par le cours *';

  @override
  String get teachAddSkillHint => 'Ajouter une compétence (ex. GraphQL)...';

  @override
  String get teachAddSkillBtn => 'Ajouter';

  @override
  String get teachNextStepConfirm => 'Continuer : Confirmer la candidature';

  @override
  String get teachStep3Header => '3. Modalités de paiement et accord';

  @override
  String get teachPayoutMethodLabel => 'Moyen de réception des gains *';

  @override
  String get teachPayoutMethodBank => 'Virement bancaire direct (IBAN)';

  @override
  String get teachPayoutMethodPaypal => 'Compte PayPal vérifié';

  @override
  String get teachPayoutMethodPayoneer => 'Carte Payoneer';

  @override
  String get teachIbanDetailsLabel => 'Détails du compte / IBAN *';

  @override
  String get teachApplicationSummary => 'Résumé de la candidature :';

  @override
  String get teachApplicantName => 'Candidat';

  @override
  String get teachApplicantHeadline => 'Spécialité';

  @override
  String get teachApplicantTopic => 'Sujet du cours';

  @override
  String get teachApplicantSkillsCount => 'Nombre de compétences';

  @override
  String get teachSkillsUnit => 'compétences';

  @override
  String get teachAgreeTermsLabel =>
      'J\'accepte les conditions générales et l\'accord de propriété intellectuelle d\'EduLab.';

  @override
  String get teachSubmitApplicationBtn => 'Soumettre la candidature';

  @override
  String get teachPrevStepBtn => 'Précédent';

  @override
  String get teachWhyEduLabTitle => 'Pourquoi enseigner avec EduLab ?';

  @override
  String get teachProp1Title => 'Revenus attractifs et équitables';

  @override
  String get teachProp1Desc =>
      'Gagnez jusqu\'à 80 % sur les ventes de vos cours sans frais cachés.';

  @override
  String get teachProp2Title => 'Accès à des milliers d\'étudiants';

  @override
  String get teachProp2Desc =>
      'Faites la promotion de vos cours auprès d\'une large communauté d\'apprentissage.';

  @override
  String get teachProp3Title => 'Support technique et de production complet';

  @override
  String get teachProp3Desc =>
      'Notre équipe vous aide à optimiser la qualité audio, vidéo et la structure du cours.';

  @override
  String get teachSuccessDialogTitle => 'Candidature reçue avec succès !';

  @override
  String get teachSuccessDialogDesc =>
      'Merci de rejoindre la communauté des formateurs EduLab. Notre équipe académique examinera votre candidature et vous contactera sous 48 heures.';

  @override
  String get teachSuccessDialogOk => 'D\'accord';

  @override
  String get teachAddOneSkillError =>
      'Veuillez ajouter au moins une compétence';

  @override
  String get teachAgreeTermsError =>
      'Veuillez accepter les conditions générales de formateur';

  @override
  String get commonCancel => 'Annuler';

  @override
  String get commonClose => 'Fermer';

  @override
  String get myCertificatesBannerTitle => 'Certificats Agréés';

  @override
  String get myCertificatesBannerSubtitle =>
      'Tous les certificats sont accrédités et vérifiés avec un identifiant unique d\'EduLab';

  @override
  String get certBadgeVerified100 => '100% Accrédité';

  @override
  String get certCodeCopied => 'Code du certificat copié';

  @override
  String get certGrantedTo => 'Décerné à';

  @override
  String get certViewAndDownload => 'Voir et télécharger le certificat';

  @override
  String get certIssuerLabel => 'Autorité émettrice';

  @override
  String get certIssuerName => 'Académie d\'Apprentissage Interactif EduLab';

  @override
  String get certEmptyTitle => 'Aucun certificat obtenu pour le moment';

  @override
  String get certEmptyDesc =>
      'Complétez 100% d\'un cours inscrit pour recevoir un certificat accrédité avec un identifiant de vérification officiel.';

  @override
  String get certEmptyAction => 'Continuer mes cours';

  @override
  String get certDetailsTitle => 'Détails et informations du certificat';

  @override
  String get certCopyLinkSuccess =>
      'Lien de vérification directe copié dans le presse-papiers !';

  @override
  String get certShareSuccess =>
      'Détails et lien du certificat copiés pour le partage !';

  @override
  String get purchaseHistoryTaxInvoiceCertified =>
      'Facture fiscale officielle certifiée';

  @override
  String get purchaseHistoryInvoiceNumberLabel => 'N° de commande / facture';

  @override
  String get purchaseHistoryCourseNameLabel => 'Nom du cours';

  @override
  String get purchaseHistoryPurchaseDateLabel => 'Date d\'achat';

  @override
  String get purchaseHistoryPaymentMethodLabel => 'Moyen de paiement';

  @override
  String get purchaseHistoryPaymentMethodValue =>
      'Carte bancaire / Stripe (En ligne)';

  @override
  String get purchaseHistoryOrderStatusLabel => 'Statut de la commande';

  @override
  String get purchaseHistoryStatusPendingReview =>
      'Remboursement en cours d\'examen';

  @override
  String get purchaseHistoryCopyInvoiceBtn => 'Copier le numéro de facture';

  @override
  String get purchaseHistoryRefundReasonLabel =>
      'Motif de la demande de remboursement :';

  @override
  String get purchaseHistoryRefundReasonEmptyError =>
      'Veuillez indiquer le motif de votre demande de remboursement';

  @override
  String get purchaseHistorySubmittingRefund => 'Envoi de la demande...';

  @override
  String get purchaseHistoryPaidDate => 'Date de paiement';

  @override
  String get purchaseHistoryEmptyTitle =>
      'Aucun historique d\'achat pour le moment';

  @override
  String get purchaseHistoryEmptyDesc =>
      'Vous n\'avez pas encore acheté de cours.\nVos commandes et factures apparaîtront ici une fois terminées.';

  @override
  String get purchaseHistoryExploreCourses => 'Explorer les cours maintenant';

  @override
  String get profileMyCourses => 'Mes Cours';

  @override
  String get profileMyCoursesSubtitle =>
      'Suivre votre progression dans vos cours';

  @override
  String get profileWishlistSubtitle =>
      'Cours enregistrés dans votre liste de souhaits';

  @override
  String get navMyLearning => 'Mon Apprentissage';

  @override
  String get profileLogoutSafeNote =>
      'Vos données, cours et certificats sont entièrement sécurisés. Vous pouvez reprendre vos cours à tout moment en vous reconnectant.';

  @override
  String learningRemainingHours(String hours) {
    return '$hours heures restantes';
  }

  @override
  String get learningCompletedFull => 'Terminé';

  @override
  String get learningFilterNotStarted => 'Non Commencé';

  @override
  String get wishlistTopRatedBadge => 'Mieux noté';

  @override
  String get wishlistFeaturedBadge => 'En vedette';

  @override
  String wishlistDiscountBadge(String percent) {
    return '$percent% de réduction';
  }

  @override
  String get courseFree => 'Gratuit';

  @override
  String get badgeBestseller => 'Meilleure vente';

  @override
  String get badgeTopRated => 'Mieux noté';

  @override
  String get badgeFeatured => 'En vedette';

  @override
  String get badgeRecommended => 'Recommandé pour vous';

  @override
  String get badgeNew => 'Nouveau';

  @override
  String get courseWord => 'Cours';

  @override
  String coursesCountText(String count) {
    return '$count+ Cours';
  }

  @override
  String studentsCountText(String count) {
    return '$count Étudiants';
  }

  @override
  String hoursCountText(String count) {
    return '$count Heures';
  }

  @override
  String get certifiedInstructor => 'Formateur Certifié';

  @override
  String get expertCertifiedInstructor => 'Expert et Formateur Certifié';

  @override
  String get defaultCourseTitle => 'Cours Éducatif';

  @override
  String get categoryWord => 'Catégorie';

  @override
  String get previewCourseVideo => 'Aperçu de la vidéo du cours';

  @override
  String get freeSection => 'Section Gratuite';

  @override
  String get freeDemoVideo => 'Vidéo Démo Gratuite';

  @override
  String get articleLecture => 'Leçon sous forme d\'article';

  @override
  String get articleViewer => 'Lecteur d\'Articles';

  @override
  String get courseVideoPlayer => 'Lecteur Vidéo du Cours';

  @override
  String get playingNow => 'En lecture';

  @override
  String get readingNow => 'En lecture';

  @override
  String get noLecturesInFreeSection => 'Aucune leçon dans la section gratuite';

  @override
  String freeLecturesCount(String count) {
    return '$count leçons gratuites';
  }

  @override
  String get enrollInFullCourse => 'S\'inscrire au cours complet';

  @override
  String get articleWord => 'Article';

  @override
  String get videoWord => 'Vidéo';

  @override
  String get quizWord => 'Quiz';

  @override
  String get courseShareCopied =>
      'Lien du cours copié dans le presse-papiers !';

  @override
  String get addedToCartSnackbar => 'Ajouté au panier';

  @override
  String get viewCartAction => 'Voir le Panier';

  @override
  String get inCartBadge => 'Dans le Panier ✓';

  @override
  String get addToCartButton => 'Ajouter au Panier';

  @override
  String get wishlistAddedSnackbar => 'Cours ajouté à la liste d\'envies';

  @override
  String get wishlistRemovedSuccessSnackbar =>
      'Cours retiré de la liste d\'envies';

  @override
  String get lessonCompletedAll =>
      'Félicitations ! Vous avez terminé toutes les leçons.';

  @override
  String get noteAddedSuccess => 'Note ajoutée avec succès';

  @override
  String get lessonAlreadyDownloaded =>
      'La leçon est déjà enregistrée hors ligne';

  @override
  String get lessonLinkCopied => 'Lien de la leçon copié';

  @override
  String get contentReportThanks =>
      'Merci pour vos retours, nous allons examiner la leçon.';

  @override
  String get courseCompletionCertificate => 'Certificat de Réussite';

  @override
  String get reportContentIssue => 'Signaler un problème de contenu';

  @override
  String get loginOrSocial => 'Ou se connecter avec';

  @override
  String get loginSuccessSnackbar => 'Connexion réussie';

  @override
  String get cartClearDialogTitle => 'Vider le panier';

  @override
  String get cartClearDialogMessage =>
      'Voulez-vous vraiment supprimer tous les cours du panier ?';

  @override
  String get cartClearConfirmButton => 'Vider';

  @override
  String get guestWelcomeTitle => 'Bienvenue sur EduLab';

  @override
  String get guestWelcomeSubtitle =>
      'Connectez-vous pour suivre vos cours et certificats';

  @override
  String get securitySetup2FATitle => 'Configuration 2FA';

  @override
  String get securityScanQRCode =>
      'Scannez le code QR avec votre application d\'authentification';

  @override
  String get securitySecretKeyManual => 'Clé secrète (saisie manuelle)';

  @override
  String get securitySecretKeyCopied => 'Clé secrète copiée';

  @override
  String get securityEnter6DigitCode => 'Entrez le code à 6 chiffres :';

  @override
  String get securityConfirmEnable2FABtn => 'Confirmer et activer 2FA';

  @override
  String get securityEnter6DigitsError =>
      'Veuillez saisir le code à 6 chiffres';

  @override
  String get securityLogoutAllDevicesTitle =>
      'Déconnexion de tous les appareils';

  @override
  String get securityLogoutAllDevicesMessage =>
      'Êtes-vous sûr de vouloir vous déconnecter de tous les autres appareils ?';

  @override
  String get securityLogoutAllDevicesConfirmBtn => 'Tout déconnecter';

  @override
  String get securityDisable2FAModalTitle => 'Désactiver 2FA';

  @override
  String get securityDisable2FAModalMessage =>
      'Désactiver 2FA réduira la sécurité. Continuer ?';

  @override
  String get securityDisable2FAConfirmBtn => 'Désactiver 2FA';

  @override
  String get securityNoOtherSessions => 'Aucune autre session active';

  @override
  String get securityCurrentDeviceOnly =>
      'Connecté uniquement sur cet appareil';

  @override
  String get securityShowLessDevices => 'Afficher moins';

  @override
  String securityShowAllDevicesCount(String count) {
    return 'Tous les appareils ($count)';
  }

  @override
  String get securityUpdatingPassword => 'Mise à jour du mot de passe...';

  @override
  String get editProfileTakePhotoDesc => 'Prendre une photo avec l\'appareil';

  @override
  String get editProfileChooseGalleryDesc => 'Choisir depuis la galerie';

  @override
  String get editProfileHeadlineError => 'Titre professionnel requis';

  @override
  String get editProfileLocationError => 'Emplacement requis';

  @override
  String get editProfilePhoneError => 'Numéro de téléphone requis';

  @override
  String get editProfileBioError => 'Biographie requise';

  @override
  String get editProfileSavingChanges => 'Enregistrement...';

  @override
  String get themeLight => 'Clair';

  @override
  String get themeDark => 'Sombre';

  @override
  String get themeSystem => 'Système';

  @override
  String get teachFullNameRequired => 'Nom complet requis';

  @override
  String get teachHeadlineRequired => 'Titre professionnel requis';

  @override
  String get teachPhoneRequired => 'Numéro de téléphone requis';

  @override
  String get teachCountryRequired => 'Pays de résidence requis';

  @override
  String get teachBioMinLength =>
      'Biographie d\'au moins 20 caractères requise';

  @override
  String get teachSubmittingApplication => 'Envoi en cours...';

  @override
  String get wishlistFailedAddToCart => 'Échec de l\'ajout au panier';

  @override
  String get cartClearAllTitle => 'Effacer tous les articles du panier ?';

  @override
  String cartClearAllMessage(String count) {
    return 'Êtes-vous sûr de vouloir supprimer tous les $count cours de votre panier ?';
  }

  @override
  String get cartClearAllHint =>
      'Tous les cours seront supprimés de votre panier. Vous pouvez les rajouter à tout moment.';

  @override
  String cartClearAllConfirm(String count) {
    return 'Effacer tout ($count)';
  }

  @override
  String get cartClearedSuccess => 'Panier effacé avec succès';

  @override
  String get cartClearFailed => 'Échec de la suppression du panier';

  @override
  String cartViewWishlistCount(String count) {
    return 'Afficher les articles de la liste de souhaits ($count)';
  }

  @override
  String get cartGoToWishlist => 'Aller à la liste de souhaits';

  @override
  String get wishlistClearAllTitle =>
      'Effacer tous les éléments de la liste de souhaits ?';

  @override
  String wishlistClearAllMessage(String count) {
    return 'Êtes-vous sûr de vouloir supprimer tous les cours $count de votre liste de souhaits ?';
  }

  @override
  String get wishlistClearAllHint =>
      'Tous les cours enregistrés seront effacés. Vous pouvez les rajouter à tout moment depuis Explore.';

  @override
  String wishlistClearAllConfirm(String count) {
    return 'Effacer tout ($count)';
  }

  @override
  String get wishlistClearedSuccess =>
      'La liste de souhaits a été effacée avec succès';

  @override
  String get wishlistClearFailed =>
      'Impossible d\'effacer la liste de souhaits';

  @override
  String get wishlistClearTooltip => 'Tout effacer';

  @override
  String wishlistViewCartCount(String count) {
    return 'Voir les articles du panier ($count)';
  }

  @override
  String get wishlistGoToCart => 'Aller au panier';

  @override
  String get checkoutCardNumberInvalid =>
      'Veuillez saisir un numéro de carte valide à 16 chiffres';

  @override
  String get checkoutCardExpiryInvalidFormat =>
      'Veuillez saisir une date d\'expiration de carte valide (MM/AA)';

  @override
  String get checkoutCardExpiredDate =>
      'La date d\'expiration de la carte n\'est pas valide';

  @override
  String get checkoutCardCvcInvalid =>
      'Veuillez saisir un code CVC valide à 3 ou 4 chiffres';

  @override
  String get checkoutCardHolderNameRequired =>
      'Veuillez saisir le nom du titulaire de la carte';

  @override
  String get checkoutCartEmptySnackbar => 'Le panier est vide';

  @override
  String get checkoutPaymentStartFailed => 'Échec de l\'initiation du paiement';

  @override
  String get checkoutClientSecretMissing =>
      'La clé de sécurité n\'a pas été reçue de la passerelle de paiement';

  @override
  String get checkoutCardVerificationFailed =>
      'La vérification de la carte a échoué';

  @override
  String get checkoutStripeProcessingFailed =>
      'Échec du traitement du paiement Stripe';

  @override
  String get checkoutServerConfirmationFailed =>
      'La confirmation du paiement du serveur a échoué';

  @override
  String get checkoutEmptyCartTitle => 'Votre panier est vide';

  @override
  String get checkoutEmptyCartDesc =>
      'Vous n\'avez pas encore ajouté de cours à votre panier. Explorez nos cours et commencez à apprendre !';

  @override
  String get checkoutContinueFreeReview =>
      'Continuer vers la révision gratuite';

  @override
  String get checkoutFreeOrderBadge => 'Commande 100% gratuite (zsh.00)';

  @override
  String get checkoutFreeOrderNotice =>
      'Cette commande ne nécessite aucune information de paiement. Vous pouvez procéder directement à la confirmation de votre inscription.';

  @override
  String get checkoutFreeCheckoutTitle => 'Paiement 100% gratuit';

  @override
  String get checkoutConfirmFreeEnrollment =>
      'Confirmer l\'inscription gratuite';

  @override
  String get checkoutFreePrice => 'Gratuit';

  @override
  String get checkoutFreeZero => 'Gratuit (zsh.00)';

  @override
  String checkoutCoursesCount(String count) {
    return '$count cours';
  }

  @override
  String get notificationsClearAllTitle => 'Effacer toutes les notifications ?';

  @override
  String notificationsClearAllMessage(String count) {
    return 'Voulez-vous vraiment supprimer toutes les notifications $count ? Cette action ne peut pas être annulée.';
  }

  @override
  String get notificationsClearAllHint =>
      'Toutes vos notifications seront supprimées et votre boîte de réception repartira à zéro.';

  @override
  String notificationsClearAllConfirm(String count) {
    return 'Effacer tout ($count)';
  }

  @override
  String get notificationsClearSuccess =>
      'Toutes les notifications ont été effacées avec succès';

  @override
  String get notificationsClearFailed =>
      'Échec de l\'effacement des notifications';

  @override
  String get notificationsClearTooltip => 'Tout effacer';

  @override
  String get notificationsViewDetails => 'Afficher les détails';

  @override
  String get notificationsEmptyCategoryTitle =>
      'Aucune notification dans cette catégorie';

  @override
  String get notificationsEmptyCategorySubtitle =>
      'Essayez de passer à une autre catégorie ou parcourez toutes les notifications';

  @override
  String get notificationsEmptyAllSubtitle =>
      'Nous vous tiendrons au courant des dernières mises à jour et alertes ici';

  @override
  String get notificationsViewAll => 'Afficher toutes les notifications';

  @override
  String get learningFilterAndSortTitle => 'Filtrer et trier les cours';

  @override
  String get learningFilterReset => 'Réinitialiser';

  @override
  String get learningSortByTitle => 'Trier par';

  @override
  String get learningSortRecentActivity => 'Consulté récemment';

  @override
  String get learningSortRecentEnrolled => 'Récemment inscrit';

  @override
  String get learningSortTitleAZ => 'Titre (A-Z)';

  @override
  String get learningSortProgress => 'Progrès %';

  @override
  String get learningStatusTitle => 'Statut du cours';

  @override
  String get learningStatusAll => 'Tous les cours';

  @override
  String get learningStatusInProgress => 'En cours';

  @override
  String get learningStatusCompleted => 'Terminé';

  @override
  String get learningStatusNotStarted => 'Non commencé';

  @override
  String get learningFilterApply => 'Appliquer les filtres';

  @override
  String get learningSearchCoursesHint => 'Rechercher dans vos cours...';

  @override
  String get learningSearchWishlistHint =>
      'Rechercher dans la liste d\'envies...';

  @override
  String get learningSearchCertificatesHint => 'Rechercher des certificats...';

  @override
  String get learningTabMyCourses => 'Mes cours';

  @override
  String get learningTabFavourite => 'Mes favoris';

  @override
  String get learningTabCertificates => 'Mes certificats';

  @override
  String get learningNoCoursesTitle => 'Aucun cours pour le moment';

  @override
  String get learningNoCoursesSubtitle =>
      'Explorez des milliers de cours de qualité et commencez votre apprentissage dès aujourd\'hui';

  @override
  String get learningFilterButton => 'Filtrer';

  @override
  String learningFilterAllCount(String count) {
    return 'Tous ($count)';
  }

  @override
  String get learningStatusNotStartedShort => 'Non commencé';

  @override
  String get learningNoMatchTitle => 'Aucun cours correspondant';

  @override
  String learningNoMatchSubtitle(String query) {
    return 'Aucun cours contenant « $query » n\'a été trouvé. Essayez avec d\'autres termes.';
  }

  @override
  String get learningNoInProgressTitle => 'Aucun cours en cours';

  @override
  String get learningNoInProgressSubtitle =>
      'Commencez à regarder des leçons dans vos cours inscrits pour suivre vos progrès ici.';

  @override
  String get learningNoCompletedTitle => 'Aucun cours terminé pour le moment';

  @override
  String get learningNoCompletedSubtitle =>
      'Poursuivez vos études pour célébrer vos progrès et voir vos cours terminés ici.';

  @override
  String get learningNoUnstartedTitle => 'Aucun cours non commencé';

  @override
  String get learningNoUnstartedSubtitle =>
      'Super ! Vous avez déjà commencé à apprendre dans tous vos cours inscrits.';

  @override
  String get learningNoFilterMatchTitle =>
      'Aucun cours ne correspond à ce filtre';

  @override
  String get learningNoFilterMatchSubtitle =>
      'Modifiez les filtres ou les options de tri pour afficher vos cours.';

  @override
  String learningViewAllCoursesCount(String count) {
    return 'Voir tous les cours ($count)';
  }

  @override
  String learningSavedCoursesCount(String count) {
    return 'Cours enregistrés ($count)';
  }

  @override
  String get learningClearAllSaved => 'Tout effacer';

  @override
  String get learningNoCertificatesTitle => 'Aucun certificat pour le moment';

  @override
  String get learningNoCertificatesSubtitle =>
      'Terminez vos cours pour obtenir des certificats accrédités qui valident vos réussites';

  @override
  String get learningGoToCourses => 'Aller à mes cours';

  @override
  String learningCertIssuedDate(String date) {
    return 'Délivré le : $date';
  }

  @override
  String get learningCertView => 'Voir';

  @override
  String get learningResumeLesson => 'Reprendre la leçon';

  @override
  String learningProgressPercentComplete(String percent) {
    return '$percent% terminé';
  }

  @override
  String learningViewCartCount(String count) {
    return 'Voir les articles du panier ($count)';
  }

  @override
  String get learningGoToCart => 'Aller au panier';

  @override
  String get playerLessonMarkedCompleted => 'Leçon marquée comme terminée ✓';

  @override
  String get playerLessonMarkedIncomplete => 'Leçon marquée comme non terminée';

  @override
  String get playerCommentPostedSuccess => 'Commentaire publié avec succès';

  @override
  String get playerCommentPostFailed =>
      'Échec de la publication du commentaire';

  @override
  String get playerReplyPostedSuccess => 'Réponse publiée avec succès';

  @override
  String get playerReplyPostFailed => 'Échec de la publication de la réponse';

  @override
  String get playerCourseNotFound => 'Cours introuvable';

  @override
  String get playerCheckEnrollmentPrompt =>
      'Veuillez d\'abord vérifier votre inscription au cours';

  @override
  String get playerReturnToCourses => 'Mon apprentissage';

  @override
  String get playerWatchLecture => 'Session de cours';

  @override
  String get playerCertificateTooltip => 'Certificat';

  @override
  String get playerRateCourseTooltip => 'Évaluer le cours';

  @override
  String get playerReadingArticleBadge => 'Article de lecture • 5 min';

  @override
  String get playerReadFullTextBelow => 'Lire le texte complet ci-dessous ↓';

  @override
  String get playerTabReviews => 'Avis';

  @override
  String get playerNoSectionsAvailable => 'Aucune section disponible';

  @override
  String playerLessonsCount(String count) {
    return '$count leçons';
  }

  @override
  String get playerPlayingBadge => 'En lecture';

  @override
  String get playerArticleBadge => 'Article';

  @override
  String get playerVideoBadge => 'Vidéo';

  @override
  String get playerFullArticleContent => 'Contenu intégral de l\'article';

  @override
  String get playerArticlePlaceholder =>
      'Bienvenue dans cette leçon de lecture.\n\nCette section couvre les concepts fondamentaux et les étapes pratiques nécessaires pour maîtriser les compétences de cette leçon.';

  @override
  String get playerAboutCourseTitle => 'À propos de ce cours';

  @override
  String get playerShowLess => 'Afficher moins';

  @override
  String get playerReadMore => 'En savoir plus';

  @override
  String get playerWhatYouWillLearn => 'Ce que vous allez apprendre';

  @override
  String get playerCourseInfoTitle => 'Détails du cours';

  @override
  String get playerTotalDurationTitle => 'Durée totale';

  @override
  String get playerTotalLessonsTitle => 'Total des leçons';

  @override
  String playerLessonsNumber(String count) {
    return '$count leçons';
  }

  @override
  String get playerLevelTitle => 'Niveau';

  @override
  String get playerAllLevels => 'Tous niveaux';

  @override
  String get playerLanguageTitle => 'Langue';

  @override
  String get playerLanguageArabic => 'Arabe';

  @override
  String get playerPrerequisitesTitle => 'Prérequis du cours';

  @override
  String get playerCertificateCardTitle => 'Certificat du cours';

  @override
  String get playerCourseCompletedSuccess => 'Félicitations ! Cours terminé';

  @override
  String get playerProgressLabel => 'Progression';

  @override
  String get playerViewCertificateBtn => 'Voir le certificat';

  @override
  String get playerCertifiedInstructor => 'Formateur certifié';

  @override
  String playerDiscussionsCount(String count) {
    return '$count questions et discussions';
  }

  @override
  String get playerAskQuestionHint => 'Posez votre question ou requête ici...';

  @override
  String get playerPostBtn => 'Publier';

  @override
  String get playerNoDiscussionsTitle => 'Aucune discussion pour le moment';

  @override
  String get playerNoDiscussionsSubtitle =>
      'Soyez le premier à poser une question !';

  @override
  String get playerInstructorBadge => 'Formateur';

  @override
  String get playerCancelReply => 'Annuler';

  @override
  String get playerReplyAction => 'Répondre';

  @override
  String playerRepliesCount(String count) {
    return '$count réponses';
  }

  @override
  String get playerWriteReplyHint => 'Écrivez votre réponse...';

  @override
  String get playerSendReplyBtn => 'Répondre';

  @override
  String get playerCourseFeedbackTitle => 'Avis et évaluations du cours';

  @override
  String get playerOutOf5 => 'sur 5';

  @override
  String playerRatingsFromEnrolledCount(String count) {
    return '$count évaluations d\'étudiants inscrits';
  }

  @override
  String get playerKeepLearningToRate => 'Continuez à apprendre pour évaluer';

  @override
  String get playerRateAfter80Hint =>
      'Vous pourrez évaluer ce cours après avoir terminé 80 % de son contenu';

  @override
  String get playerCurrentProgressLabel => 'Votre progression :';

  @override
  String get playerYourCurrentRating => 'Votre évaluation';

  @override
  String get playerEditRating => 'Modifier l\'évaluation';

  @override
  String get playerDeleteRatingTooltip => 'Supprimer l\'évaluation';

  @override
  String get playerUpdateRatingTitle => 'Modifier votre évaluation';

  @override
  String get playerRateCourseTitle => 'Évaluer ce cours';

  @override
  String get playerWriteReviewHint =>
      'Donnez votre avis sur la qualité du contenu (facultatif)...';

  @override
  String get playerRatingSubmitSuccess => 'Évaluation envoyée avec succès !';

  @override
  String get playerRatingSubmitFailed => 'Échec de l\'envoi de l\'évaluation';

  @override
  String get playerSaveChangesBtn => 'Enregistrer les modifications';

  @override
  String get playerSubmitReviewBtn => 'Envoyer l\'avis';

  @override
  String get playerLearnerReviewsTitle => 'Avis des apprenants';

  @override
  String playerReviewsCount(String count) {
    return '$count avis';
  }

  @override
  String get playerNoWrittenReviewsTitle => 'Aucun avis rédigé pour le moment';

  @override
  String get playerNoWrittenReviewsSubtitle =>
      'Soyez le premier à partager votre avis !';

  @override
  String get playerRatingLabel5 => 'Excellent 🌟 (5/5)';

  @override
  String get playerRatingLabel4 => 'Très bon 👍 (4/5)';

  @override
  String get playerRatingLabel3 => 'Moyen 👌 (3/5)';

  @override
  String get playerRatingLabel2 => 'À améliorer 🤔 (2/5)';

  @override
  String get playerRatingLabel1 => 'Médiocre 👎 (1/5)';

  @override
  String get playerDeleteRatingDialogTitle => 'Supprimer l\'évaluation';

  @override
  String get playerDeleteRatingDialogMessage =>
      'Voulez-vous vraiment supprimer votre avis sur ce cours ?';

  @override
  String get playerDeleteConfirmBtn => 'Supprimer';

  @override
  String get playerRatingDeleteSuccess => 'Évaluation supprimée avec succès';

  @override
  String get playerPreviousLesson => 'Leçon précédente';

  @override
  String get playerExitFullscreenTooltip => 'Quitter le plein écran';

  @override
  String instructorsAvailableCount(String count) {
    return '$count formateurs disponibles';
  }

  @override
  String get instructorsNotFound => 'Aucun formateur trouvé';

  @override
  String instructorsCoursesCount(String count) {
    return '$count cours';
  }

  @override
  String get instructorsSearchHint =>
      'Rechercher par nom d\'instructeur ou spécialité...';

  @override
  String get instructorsSortAll => 'Tous';

  @override
  String get instructorsSortTopRated => 'Les mieux notés';

  @override
  String get instructorsSortMostStudents => 'Plus grand nombre d\'étudiants';

  @override
  String get instructorsSortMostCourses => 'Plus grand nombre de cours';

  @override
  String get instructorsNotFoundSubtitle =>
      'Essayez de rechercher avec un autre nom ou effacez les filtres';

  @override
  String get exploreCompleteCourse => 'Cours complet';

  @override
  String get exploreGeneralCategory => 'Général';

  @override
  String courseShareMessage(String title, String url) {
    return 'Découvrez le cours \"$title\" sur EduLab : $url';
  }

  @override
  String get courseDetailsDefaultTitle => 'Détails du cours';

  @override
  String get courseDetailsTooltipShare => 'Partager';

  @override
  String get courseDetailsTooltipWishlist => 'Liste d\'envies';

  @override
  String get courseDetailsTooltipCart => 'Panier';

  @override
  String get courseDetailsNotFound => 'Cours introuvable';

  @override
  String get courseDetailsDefaultCategory => 'Cours';

  @override
  String courseDetailsTotalRatingsCount(String count) {
    return '($count avis)';
  }

  @override
  String courseDetailsLecturesCount(String count) {
    return '$count leçons';
  }

  @override
  String get courseDetailsCertificateBadge => 'Certificat';

  @override
  String get courseDetailsTabOverview => 'Aperçu';

  @override
  String get courseDetailsTabCurriculum => 'Programme';

  @override
  String get courseDetailsTabInstructor => 'Instructeur';

  @override
  String get courseDetailsTabReviews => 'Avis';

  @override
  String get courseDetailsFullDescriptionTitle => 'Description';

  @override
  String get courseDetailsShowLess => 'Afficher moins';

  @override
  String get courseDetailsShowMore => 'Afficher plus...';

  @override
  String courseDetailsCurriculumSectionsLectures(
    String sections,
    String lectures,
  ) {
    return '$sections sections • $lectures leçons';
  }

  @override
  String get courseDetailsCollapseAll => 'Tout réduire';

  @override
  String get courseDetailsExpandAll => 'Tout développer';

  @override
  String get courseDetailsCurriculumComingSoon =>
      'Détails du programme bientôt disponibles';

  @override
  String courseDetailsSectionLecturesCount(String count) {
    return '$count leçons';
  }

  @override
  String get courseDetailsLecturePreviewBtn => 'Aperçu';

  @override
  String get courseDetailsDefaultInstructorTitle =>
      'Instructeur senior et expert certifié';

  @override
  String get courseDetailsInstructorRatingLabel => 'Note';

  @override
  String get courseDetailsInstructorStudentsLabel => 'Étudiants';

  @override
  String get courseDetailsInstructorSectionsLabel => 'Sections';

  @override
  String get courseDetailsAboutInstructorTitle =>
      'À propos de l\'instructeur :';

  @override
  String get courseDetailsDefaultInstructorAbout =>
      'Instructeur certifié avec une vaste expérience dans l\'enseignement professionnel dispensé à des milliers d\'étudiants à travers le monde.';

  @override
  String courseDetailsStudentRatingsCount(String count) {
    return '$count avis d\'étudiants';
  }

  @override
  String get courseDetailsNoWrittenReviews => 'Aucun avis écrit pour le moment';

  @override
  String get courseDetailsRelatedCourses =>
      'Cours similaires susceptibles de vous plaire';

  @override
  String courseDetailsDiscountPercent(String percent) {
    return '$percent % DE RÉDUCTION';
  }

  @override
  String get courseDetailsResumeCourse => 'Reprendre le cours';

  @override
  String get courseDetailsTryAgain => 'Réessayer';

  @override
  String get courseDetailsEstimatedReading =>
      '📖 Temps de lecture estimé : 4 min';

  @override
  String get courseDetailsSampleArticleContent =>
      'Bienvenue dans cette leçon au format article.\n\nCette section couvre les concepts théoriques clés et les étapes pratiques pour maîtriser le sujet.\n\n• Points clés à retenir :\n1. Comprendre la terminologie de base et les modèles architecturaux.\n2. Exercices pratiques et entraînement régulier.\n3. Consulter les notes complémentaires et les devoirs.\n\nBonne lecture !';

  @override
  String certDownloadedSuccess(String course, String format) {
    return 'Certificat pour \"$course\" téléchargé avec succès au format $format !';
  }

  @override
  String certVerifiedFullRequirements(String code) {
    return 'ID de vérification : $code • Exigences remplies à 100 %';
  }

  @override
  String get certCompletionTitle => 'Certificat de réussite';

  @override
  String get certCompletionSubtitle => 'Certificat de fin de formation';

  @override
  String get certAnnounceStudent =>
      'EducationLab Learning Academy certifie par la présente que :';

  @override
  String get certCompletionRequirementsMet =>
      'A rempli avec succès toutes les exigences du cours de formation :';

  @override
  String certIssueDateText(String date) {
    return 'Date d\'émission : $date';
  }

  @override
  String certIdNumberText(String code) {
    return 'ID de certificat : $code';
  }

  @override
  String get certPlatformManagement => 'Direction de la plateforme';

  @override
  String get certInstructorRoleTitle => 'Instructeur du cours';

  @override
  String get commonLoading => 'Chargement...';

  @override
  String get homeGuestTagline =>
      'Plateforme d\'apprentissage intelligent et de développement des compétences';

  @override
  String get catTagHighestDemand => 'Forte demande';

  @override
  String get catTagMostPopular => 'Les plus populaires';

  @override
  String get catTagTrending => 'Tendance';

  @override
  String get catTagFastestGrowing => 'Croissance rapide';

  @override
  String get catTagHighDemand => 'Très demandé';

  @override
  String get catTagTopRated => 'Mieux notés';

  @override
  String get catTagEssential => 'Indispensable';

  @override
  String get catTagAdvanced => 'Niveau avancé';

  @override
  String get catTagEntrepreneurs => 'Entrepreneurs';

  @override
  String get catTagSalesGrowth => 'Croissance des ventes';

  @override
  String get catDevTitle => 'Programmation et développement logiciel';

  @override
  String get catDevSubtitle => 'Génie logiciel, systèmes et algorithmes';

  @override
  String get catWebTitle => 'Développement Web';

  @override
  String get catWebSubtitle => 'Web Frontend, Backend et Fullstack';

  @override
  String get catMobileTitle => 'Développement d\'applications mobiles';

  @override
  String get catMobileSubtitle => 'Applications Flutter, iOS et Android';

  @override
  String get catAiTitle => 'Intelligence artificielle';

  @override
  String get catAiSubtitle => 'Apprentissage automatique, Deep Learning et IA';

  @override
  String get catDataTitle => 'Science des données et analyse';

  @override
  String get catDataSubtitle => 'Analyse de données, statistiques et Big Data';

  @override
  String get catDesignTitle => 'Design UI/UX et produit';

  @override
  String get catDesignSubtitle => 'UI/UX, prototypage et design produit';

  @override
  String get catSecurityTitle => 'Cybersécurité et réseaux';

  @override
  String get catSecuritySubtitle =>
      'Cybersécurité, piratage éthique et réseaux';

  @override
  String get catCloudTitle => 'Cloud Computing et DevOps';

  @override
  String get catCloudSubtitle => 'Infrastructure cloud, DevOps et CI/CD';

  @override
  String get catBusinessTitle => 'Gestion d\'entreprise et de projets';

  @override
  String get catBusinessSubtitle => 'Entrepreneuriat, Agile et leadership';

  @override
  String get catMarketingTitle => 'Marketing digital';

  @override
  String get catMarketingSubtitle => 'Marketing digital, SEO et croissance';

  @override
  String get timeJustNow => 'À l\'instant';

  @override
  String timeMinutesAgo(String count) {
    return 'il y a $count min';
  }

  @override
  String timeHoursAgo(String count) {
    return 'il y a $count h';
  }

  @override
  String timeDaysAgo(String count) {
    return 'il y a $count jours';
  }

  @override
  String timeWeeksAgo(String count) {
    return 'il y a $count semaines';
  }

  @override
  String timeMonthsAgo(String count) {
    return 'il y a $count mois';
  }

  @override
  String wishlistLecturesCount(String count) {
    return '$count leçons';
  }

  @override
  String get instructorProfileTitle => 'Profil de l\'instructeur';

  @override
  String instructorProfileLinkCopied(String name) {
    return 'Lien pour $name copié dans le presse-papiers';
  }

  @override
  String get instructorDefaultName => 'Instructeur';

  @override
  String get instructorProfileBadge => 'INSTRUCTEUR';

  @override
  String get instructorProfileTotalStudents => 'Total des étudiants';

  @override
  String get instructorProfileRating => 'Évaluation de l\'instructeur';

  @override
  String get instructorProfileCourses => 'Cours';

  @override
  String get instructorProfileShare => 'Partager le profil';

  @override
  String get instructorProfileLinkOpenError =>
      'Impossible d\'ouvrir le lien, copié dans le presse-papiers';

  @override
  String get instructorProfileWebsite => 'Site web';

  @override
  String get instructorProfileAboutMe => 'À propos de moi';

  @override
  String get instructorProfileShowLess => 'Afficher moins';

  @override
  String get instructorProfileShowMore => 'Afficher plus';

  @override
  String get instructorProfileExpertise => 'Domaines d\'expertise';

  @override
  String get instructorProfileSortAll => 'Tous';

  @override
  String get instructorProfileSortTopRated => 'Les mieux notés';

  @override
  String get instructorProfileSortPopular => 'Populaires';

  @override
  String get instructorProfileSortNewest => 'Plus récents';

  @override
  String get instructorProfileCoursesTitle => 'Cours de l\'instructeur';

  @override
  String get instructorProfileNoCoursesFilter =>
      'Aucun cours trouvé pour ce filtre';

  @override
  String instructorProfileLoadMoreCourses(String count) {
    return 'Charger plus de cours ($count restants)';
  }

  @override
  String get instructorProfileLoadingMoreCourses =>
      'Chargement de cours supplémentaires...';

  @override
  String instructorProfileAllCoursesLoaded(String count) {
    return 'Tous les $count cours ont été chargés';
  }

  @override
  String get instructorProfileStudentFeedback => 'Avis des étudiants';

  @override
  String instructorProfileReviewsCount(String count) {
    return '$count avis';
  }

  @override
  String instructorProfileBasedOnReviews(String count) {
    return 'Basé sur $count avis';
  }

  @override
  String get instructorProfileRecentReviews => 'Avis récents';

  @override
  String instructorProfileLoadMoreReviews(String count) {
    return 'Charger plus d\'avis ($count restants)';
  }

  @override
  String get instructorProfileLoadingMoreReviews =>
      'Chargement d\'avis supplémentaires...';

  @override
  String instructorProfileAllReviewsLoaded(String count) {
    return 'Tous les $count avis ont été chargés';
  }

  @override
  String get instructorProfileNoReviewsYet => 'Aucun avis écrit pour le moment';

  @override
  String get instructorProfileRatingDesc =>
      'L\'évaluation est basée sur la moyenne des notes attribuées par les étudiants pour l\'ensemble des cours de l\'instructeur';

  @override
  String get instructorProfileLoadError =>
      'Échec du chargement des détails de l\'instructeur, veuillez réessayer plus tard';

  @override
  String get instructorProfileDefaultStudentName => 'Étudiant';

  @override
  String get instructorProfileDefaultHeadline =>
      'Instructeur senior & expert certifié';

  @override
  String get instructorProfileDefaultBio =>
      'Ingénieur logiciel certifié et formateur technique bénéficiant d\'une vaste expérience dans la conception de systèmes logiciels évolutifs et d\'applications mobiles.\nA formé des milliers d\'étudiants et d\'ingénieurs à travers le monde, proposant un contenu professionnel axé sur le Clean Code, la Clean Architecture et les solutions modernes et évolutives.';

  @override
  String get supportNewChat => 'Nouveau chat';

  @override
  String get supportNoChatsTitle =>
      'Aucune discussion de support pour le moment';

  @override
  String get supportNoChatsDesc =>
      'Notre équipe d\'assistance est disponible 24h/24 et 7j/7 pour répondre à toutes vos questions';

  @override
  String get supportStartNewConversation => 'Démarrer une conversation';

  @override
  String get supportNoMessagesYet => 'Aucun message pour le moment';

  @override
  String get supportRetry => 'Réessayer';

  @override
  String get supportOpenTicket => 'Ticket ouvert';

  @override
  String get supportClosedTicket => 'Ticket fermé';

  @override
  String get supportCloseAction => 'Fermer';

  @override
  String get supportReopenAction => 'Rouvrir';

  @override
  String get supportNoMessagesInChat =>
      'Aucun message dans ce chat pour le moment';

  @override
  String get supportYou => 'Vous';

  @override
  String get supportTeam => 'Équipe d\'assistance';

  @override
  String get supportTypeMessageHint => 'Écrivez votre message ici...';

  @override
  String get supportConversationClosedNotice =>
      'Cette conversation est actuellement fermée.';

  @override
  String get supportCloseDialogTitle => 'Fermer la conversation ?';

  @override
  String get supportCloseDialogDesc =>
      'Êtes-vous sûr de vouloir fermer ce chat ? Vous pouvez le rouvrir à tout moment pour reprendre la discussion.';

  @override
  String get supportCancel => 'Annuler';

  @override
  String get supportYesClose => 'Oui, fermer';

  @override
  String get supportNewChatTitle => 'Nouveau chat d\'assistance';

  @override
  String get supportNewChatSubtitle => 'Notre équipe est là pour vous aider';

  @override
  String get supportSubjectLabel => 'Objet';

  @override
  String get supportSubjectHint =>
      'ex. Question sur un cours, Problème de paiement...';

  @override
  String get supportMessageLabel => 'Message';

  @override
  String get supportMessageHint =>
      'Décrivez votre problème ou votre question en détail...';

  @override
  String get supportMessageRequired => 'Veuillez entrer un message';

  @override
  String get supportStartConversationBtn => 'Démarrer la conversation';

  @override
  String get supportCreateError =>
      'Échec de création de la conversation, veuillez réessayer plus tard';

  @override
  String get supportTopicCourse => 'Question sur le cours';

  @override
  String get supportTopicPayment => 'Problème de paiement';

  @override
  String get supportTopicCertificates => 'Certificats';

  @override
  String get supportTopicTech => 'Problème technique';

  @override
  String get supportTopicGeneral => 'Demande générale';

  @override
  String get cartGuestTitle => 'Connectez-vous pour voir votre panier';

  @override
  String get cartGuestSubtitle =>
      'Veuillez vous connecter pour accéder à votre panier et poursuivre vos achats.';

  @override
  String get wishlistGuestTitle =>
      'Connectez-vous pour voir votre liste d\'envies';

  @override
  String get wishlistGuestSubtitle =>
      'Veuillez vous connecter pour retrouver vos cours enregistrés à tout moment.';

  @override
  String get courseDetailsLoginRequiredTitle => 'Connexion requise';

  @override
  String get courseDetailsLoginRequiredDesc =>
      'Vous devez vous connecter d\'abord pour acheter ce cours et suivre votre progression.';

  @override
  String get courseDetailsProceedToLogin => 'Aller à la connexion';

  @override
  String get messagesGuestTitle => 'Connectez-vous pour voir les messages';

  @override
  String get messagesGuestSubtitle =>
      'Veuillez vous connecter pour accéder aux échanges avec le support.';

  @override
  String get notificationsGuestTitle =>
      'Connectez-vous pour voir les notifications';

  @override
  String get notificationsGuestSubtitle =>
      'Veuillez vous connecter pour consulter les dernières notifications de votre compte.';

  @override
  String get legalTitle => 'À propos & Mentions légales';

  @override
  String get legalTabAbout => 'À propos d\'EduLab';

  @override
  String get legalTabPrivacy => 'Confidentialité';

  @override
  String get legalTabTerms => 'Conditions';

  @override
  String get legalUpdated => 'Mis à jour :';

  @override
  String get legalNeedHelpTitle => 'Besoin d\'aide ou des questions ?';

  @override
  String get legalNeedHelpDesc =>
      'L\'équipe d\'assistance EduLab est disponible 24h/24 et 7j/7. Contactez-nous directement par e-mail.';

  @override
  String get legalEmailCopied =>
      'E-mail d\'assistance copié dans le presse-papiers';

  @override
  String get legalNoContent => 'Aucun contenu disponible';

  @override
  String get checkoutDigitalReceipt => 'Reçu Numérique';

  @override
  String get checkoutTransactionDate => 'Date de Transaction';

  @override
  String get checkoutFreeEnrollment => 'Inscription Gratuite';

  @override
  String get checkoutEnrolledCourses => 'Cours Inscrits';

  @override
  String get checkoutTransactionStatus => 'Statut';

  @override
  String get checkoutStatusSuccess => 'Complété avec Succès';

  @override
  String get checkoutTotalPaid => 'Montant Total Payé';

  @override
  String get checkoutCopied => 'Copié !';

  @override
  String get checkoutCardHolderHint =>
      'Nom complet tel qu\'il apparaît sur la carte';
}

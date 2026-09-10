// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Dutch Flemish (`nl`).
class AppLocalizationsNl extends AppLocalizations {
  AppLocalizationsNl([String locale = 'nl']) : super(locale);

  @override
  String get onboardingSkip => 'Overslaan';

  @override
  String get onboardingTitle1 => 'Welkom bij EduLab';

  @override
  String get onboardingSubtitle1 =>
      'Jouw ideale platform voor modern interactief leren en professionele groei.';

  @override
  String get onboardingTitle2 => 'Leer van topdocenten';

  @override
  String get onboardingSubtitle2 =>
      'Duizenden professionele cursussen in programmeren, design, business en data science.';

  @override
  String get onboardingTitle3 => 'Certificaten & gegarandeerd succes';

  @override
  String get onboardingSubtitle3 =>
      'Volg je voortgang, slaag voor tests en behaal erkende certificaten.';

  @override
  String get onboardingNext => 'Volgende';

  @override
  String get onboardingStart => 'Aan de slag';

  @override
  String get splashAppName => 'Education Lab';

  @override
  String get splashTagline => 'Slim Leerplatform';

  @override
  String get loginTagline => 'Welkom op het slimme leerplatform';

  @override
  String get loginAppName => 'EduLab';

  @override
  String get loginTabLogin => 'Inloggen';

  @override
  String get loginTabRegister => 'Registreren';

  @override
  String get loginEmailLabel => 'E-mailadres';

  @override
  String get loginEmailHint => 'voorbeeld@email.nl';

  @override
  String get loginPasswordLabel => 'Wachtwoord';

  @override
  String get loginPasswordHint => '••••••';

  @override
  String get loginForgotPassword => 'Wachtwoord vergeten?';

  @override
  String get loginSubmit => 'Inloggen';

  @override
  String get loginSubmitLoading => 'Bezig met inloggen';

  @override
  String get loginGuest => 'Verder als gast';

  @override
  String get loginOr => 'of';

  @override
  String get loginEmailRequired => 'E-mail is verplicht';

  @override
  String get loginEmailInvalid => 'Voer een geldig e-mailadres in';

  @override
  String get loginPasswordRequired => 'Wachtwoord is verplicht';

  @override
  String get registerStepEmail => 'E-mail';

  @override
  String get registerStepCode => 'Code';

  @override
  String get registerStepData => 'Gegevens';

  @override
  String get registerSendCodeInfo =>
      'We sturen een activatiecode naar dit e-mailadres';

  @override
  String get registerSendCode => 'Activatiecode verzenden';

  @override
  String get registerVerifying => 'Controleren';

  @override
  String get registerCodeSentTo => 'Code verzonden naar:';

  @override
  String get registerResendCode => 'Code opnieuw verzenden';

  @override
  String get registerBack => 'Terug';

  @override
  String get registerVerifyCode => 'Code verifiëren';

  @override
  String get registerCodeIncomplete => 'Voer de volledige 6-cijferige code in';

  @override
  String get registerFullNameLabel => 'Volledige naam';

  @override
  String get registerFullNameHint => 'Je volledige naam';

  @override
  String get registerPasswordHint =>
      'Minimaal 8 tekens, een hoofdletter en een cijfer';

  @override
  String get registerConfirmLabel => 'Wachtwoord bevestigen';

  @override
  String get registerConfirmHint => 'Voer wachtwoord opnieuw in';

  @override
  String get registerSubmit => 'Account aanmaken';

  @override
  String get registerSubmitLoading => 'Account wordt aangemaakt';

  @override
  String get registerSuccess => 'Account succesvol aangemaakt';

  @override
  String get registerNameRequired => 'Volledige naam is verplicht';

  @override
  String get registerNameMinLength => 'Naam moet minimaal 6 tekens bevatten';

  @override
  String get registerPasswordMinLength =>
      'Wachtwoord moet minimaal 8 tekens bevatten';

  @override
  String get registerPasswordUppercase =>
      'Wachtwoord moet minimaal één hoofdletter bevatten';

  @override
  String get registerPasswordNumber =>
      'Wachtwoord moet minimaal één cijfer bevatten';

  @override
  String get registerConfirmRequired => 'Wachtwoordbevestiging is verplicht';

  @override
  String get registerConfirmMismatch => 'Wachtwoorden komen niet overeen';

  @override
  String get networkError => 'Verbindingsfout, probeer opnieuw';

  @override
  String homeGreeting(String name) {
    return 'Hallo, $name!';
  }

  @override
  String get homeSubtitle => 'Wat wil je vandaag leren?';

  @override
  String get homeSearchHint => 'Zoek cursus of vaardigheid...';

  @override
  String get homeSectionContinue => 'Verder leren';

  @override
  String get homeSectionRecommended => 'Aanbevolen voor jou';

  @override
  String get homeSectionPopular => 'Populairste cursussen';

  @override
  String get homeSectionTopRated => 'Hoogst beoordeeld';

  @override
  String get homeSectionByCategory => 'Per categorie';

  @override
  String get homeHeroTitle => 'Ontdek nu aanbiedingen';

  @override
  String get homeHeroSubtitle => 'Tot 70% korting op premium cursussen';

  @override
  String get homeHeroButton => 'Nu ontdekken';

  @override
  String get homeViewAll => 'Alles bekijken';

  @override
  String get homeProgressLabel => 'Voltooid';

  @override
  String get exploreTitle => 'Cursussen Verkennen';

  @override
  String get exploreSearchHint => 'Zoek op cursus, vaardigheid of docent...';

  @override
  String get exploreAllCategories => 'Alle categorieën';

  @override
  String get exploreFilter => 'Filteren';

  @override
  String get exploreSort => 'Sorteren';

  @override
  String get exploreNoResults => 'Geen resultaten gevonden';

  @override
  String get exploreNoResultsHint => 'Probeer andere zoektermen of filters';

  @override
  String exploreCoursesCount(int count) {
    return '$count cursussen';
  }

  @override
  String get exploreFilterTitle => 'Resultaten filteren';

  @override
  String get exploreFilterApply => 'Filter toepassen';

  @override
  String get exploreFilterReset => 'Herstellen';

  @override
  String get exploreFilterPrice => 'Prijs';

  @override
  String get exploreFilterLevel => 'Niveau';

  @override
  String get exploreFilterRating => 'Beoordeling';

  @override
  String get exploreFilterDuration => 'Duur';

  @override
  String get exploreSortTitle => 'Sorteren op';

  @override
  String get exploreSortRelevance => 'Relevantie';

  @override
  String get exploreSortNewest => 'Nieuwste';

  @override
  String get exploreSortPopular => 'Populairste';

  @override
  String get exploreSortRating => 'Hoogste beoordeling';

  @override
  String get exploreSortPriceLow => 'Prijs: laag naar hoog';

  @override
  String get exploreSortPriceHigh => 'Prijs: hoog naar laag';

  @override
  String get explorePriceFree => 'Gratis';

  @override
  String get exploreLevelBeginner => 'Beginner';

  @override
  String get exploreLevelIntermediate => 'Gemiddeld';

  @override
  String get exploreLevelAdvanced => 'Gevorderd';

  @override
  String get learningTitle => 'Mijn Cursussen';

  @override
  String get learningTabInProgress => 'Bezig';

  @override
  String get learningTabCompleted => 'Voltooid';

  @override
  String get learningTabSaved => 'Opgeslagen';

  @override
  String get learningEmpty => 'Nog geen cursussen';

  @override
  String get learningEmptyHint => 'Begin nu met het verkennen van cursussen';

  @override
  String get learningExploreButton => 'Cursussen Verkennen';

  @override
  String learningProgress(int percent) {
    return '$percent% voltooid';
  }

  @override
  String get learningContinue => 'Doorgaan';

  @override
  String get learningViewCertificate => 'Certificaat bekijken';

  @override
  String get learningReview => 'Cursus beoordelen';

  @override
  String get learningLesson => 'Les';

  @override
  String get learningLessons => 'Lessen';

  @override
  String get cartTitle => 'Winkelwagen';

  @override
  String get cartEmpty => 'Je winkelwagen is leeg';

  @override
  String get cartEmptyHint => 'Voeg cursussen toe om te beginnen';

  @override
  String get cartExploreButton => 'Cursussen Verkennen';

  @override
  String get cartPromoPlaceholder => 'Kortingscode';

  @override
  String get cartPromoApply => 'Toepassen';

  @override
  String get cartPromoInvalid => 'Ongeldige kortingscode';

  @override
  String get cartSummary => 'Besteloverzicht';

  @override
  String get cartSubtotal => 'Subtotaal';

  @override
  String get cartDiscount => 'Korting';

  @override
  String get cartTotal => 'Totaal';

  @override
  String get cartCheckout => 'Afrekenen';

  @override
  String cartCourses(int count) {
    return '$count cursussen';
  }

  @override
  String get cartRemove => 'Verwijderen';

  @override
  String get cartGuarantee => '30 dagen niet-goed-geld-terug-garantie';

  @override
  String get checkoutTitle => 'Afrekenen';

  @override
  String get checkoutStepPayment => 'Betaling';

  @override
  String get checkoutStepReview => 'Overzicht';

  @override
  String get checkoutStepConfirm => 'Bevestiging';

  @override
  String get checkoutOrderSummary => 'Besteloverzicht';

  @override
  String get checkoutTotal => 'Totaal';

  @override
  String get checkoutPayNow => 'Nu betalen';

  @override
  String get checkoutBack => 'Terug';

  @override
  String get checkoutNext => 'Volgende';

  @override
  String get checkoutSecureSSL =>
      'Veilige betaling met 256-bit SSL-versleuteling';

  @override
  String get checkoutSuccessTitle => 'Aankoop geslaagd!';

  @override
  String get checkoutSuccessSubtitle => 'Je hebt nu toegang tot je cursus';

  @override
  String get checkoutGoToLearning => 'Naar Mijn Cursussen';

  @override
  String get checkoutPaymentMethod => 'Betaalmethode';

  @override
  String get checkoutCardNumber => 'Kaartnummer';

  @override
  String get checkoutCardName => 'Naam op kaart';

  @override
  String get checkoutCardExpiry => 'Vervaldatum';

  @override
  String get checkoutCardCVV => 'CVV';

  @override
  String get courseDetailsEnroll => 'Nu inschrijven';

  @override
  String get courseDetailsBuyNow => 'Nu kopen';

  @override
  String get courseDetailsAddToCart => 'Aan winkelwagen toevoegen';

  @override
  String get courseDetailsAddedToCart => 'Toegevoegd aan winkelwagen';

  @override
  String get courseDetailsAlreadyEnrolled => 'Al ingeschreven';

  @override
  String get courseDetailsGoToCourse => 'Naar cursus';

  @override
  String get courseDetailsFree => 'Gratis';

  @override
  String courseDetailsStudents(String count) {
    return '$count studenten';
  }

  @override
  String get courseDetailsRating => 'Beoordeling';

  @override
  String get courseDetailsReviews => 'beoordelingen';

  @override
  String get courseDetailsLastUpdated => 'Laatst bijgewerkt';

  @override
  String get courseDetailsCurriculum => 'Cursusinhoud';

  @override
  String get courseDetailsSection => 'sectie';

  @override
  String get courseDetailsLessons => 'lessen';

  @override
  String get courseDetailsInstructor => 'Docent';

  @override
  String get courseDetailsStudentsLabel => 'Studenten';

  @override
  String get courseDetailsCoursesLabel => 'Cursussen';

  @override
  String get courseDetailsReviewsLabel => 'Beoordelingen';

  @override
  String get courseDetailsReviewsTitle => 'Studentenbeoordelingen';

  @override
  String get courseDetailsWhatLearn => 'Wat je zult leren';

  @override
  String get courseDetailsRequirements => 'Vereisten';

  @override
  String get courseDetailsDescription => 'Cursusbeschrijving';

  @override
  String get courseDetailsIncludesTitle => 'Deze cursus bevat';

  @override
  String get courseDetailsHoursVideo => 'uur aan video';

  @override
  String get courseDetailsArticles => 'artikelen';

  @override
  String get courseDetailsMobileAccess => 'Mobiele toegang';

  @override
  String get courseDetailsCertificate => 'Certificaat van voltooiing';

  @override
  String get courseDetailsLifetimeAccess => 'Levenslange toegang';

  @override
  String get lessonPlayerNotes => 'Mijn notities';

  @override
  String get lessonPlayerResources => 'Lesmateriaal';

  @override
  String get lessonPlayerDiscussion => 'Discussie';

  @override
  String get lessonPlayerPrev => 'Vorige';

  @override
  String get lessonPlayerNext => 'Volgende';

  @override
  String get lessonPlayerSpeed => 'Snelheid';

  @override
  String get lessonPlayerQuality => 'Kwaliteit';

  @override
  String get lessonPlayerCompleted => 'Les voltooid';

  @override
  String get certificateTitle => 'Certificaat van Voltooiing';

  @override
  String get certificatePresentedTo => 'Uitgereikt aan';

  @override
  String get certificateCompletedCourse => 'voor het succesvol afronden van';

  @override
  String get certificateIssuedOn => 'Uitgiftedatum';

  @override
  String get certificateVerificationId => 'Verificatie-ID';

  @override
  String get certificateDownloadPDF => 'PDF downloaden';

  @override
  String get certificateDownloadPNG => 'Afbeelding downloaden';

  @override
  String get certificateCopyLink => 'Link kopiëren';

  @override
  String get certificateLinkCopied => 'Link gekopieerd';

  @override
  String get profileTitle => 'Profiel';

  @override
  String get profileEditProfile => 'Profiel bewerken';

  @override
  String get profileCourses => 'Mijn Cursussen';

  @override
  String get profileCertificates => 'Certificaten';

  @override
  String get profilePoints => 'Punten';

  @override
  String get profileFollowers => 'Volgers';

  @override
  String get profileFollowing => 'Volgend';

  @override
  String get profileBio => 'Biografie';

  @override
  String get profileInstructor => 'Docent';

  @override
  String get profileStudent => 'Student';

  @override
  String get profileLevel => 'Niveau';

  @override
  String get profileJoined => 'Lid sinds';

  @override
  String get profileShareProfile => 'Profiel delen';

  @override
  String get profileMenuLearning => 'Mijn Cursussen';

  @override
  String get profileMenuCertificates => 'Mijn Certificaten';

  @override
  String get profileMenuPurchaseHistory => 'Aankoopgeschiedenis';

  @override
  String get profileMenuTeachApplication => 'Lesgeven op EduLab';

  @override
  String get profileMenuAccountSecurity => 'Accountbeveiliging';

  @override
  String get profileMenuNotifications => 'Meldingen';

  @override
  String get profileMenuMessages => 'Berichten';

  @override
  String get profileMenuSettings => 'Instellingen';

  @override
  String get profileMenuSchedule => 'Mijn Rooster';

  @override
  String get profileMenuAssignments => 'Opdrachten';

  @override
  String get profileMenuQuiz => 'Quizzen';

  @override
  String get profileMenuLogout => 'Uitloggen';

  @override
  String get profileLogoutConfirm => 'Weet je zeker dat je wilt uitloggen?';

  @override
  String get profileLogoutYes => 'Ja, uitloggen';

  @override
  String get profileLogoutNo => 'Annuleren';

  @override
  String get editProfileTitle => 'Profiel Bewerken';

  @override
  String get editProfileSave => 'Wijzigingen opslaan';

  @override
  String get editProfileFullName => 'Volledige naam';

  @override
  String get editProfileBio => 'Biografie';

  @override
  String get editProfileEmail => 'E-mailadres';

  @override
  String get editProfilePhone => 'Telefoonnummer';

  @override
  String get editProfileWebsite => 'Website';

  @override
  String get editProfileSaved => 'Wijzigingen succesvol opgeslagen';

  @override
  String get accountSecurityTitle => 'Accountbeveiliging';

  @override
  String get accountSecurityChangePassword => 'Wachtwoord wijzigen';

  @override
  String get accountSecurityTwoFactor => 'Tweestapsverificatie';

  @override
  String get accountSecurityActiveSessions => 'Actieve sessies';

  @override
  String get accountSecurityDeleteAccount => 'Account verwijderen';

  @override
  String get purchaseHistoryTitle => 'Aankoopgeschiedenis';

  @override
  String get purchaseHistoryEmpty => 'Nog geen aankopen';

  @override
  String get purchaseHistoryGuarantee =>
      '30 dagen niet-goed-geld-terug-garantie';

  @override
  String get purchaseHistoryDate => 'Transactiedatum';

  @override
  String get purchaseHistoryStatus => 'Status';

  @override
  String get purchaseHistoryAmount => 'Bedrag';

  @override
  String get purchaseHistoryCompleted => 'Voltooid';

  @override
  String get purchaseHistoryRefunded => 'Terugbetaald';

  @override
  String get teachApplicationTitle => 'Lesgeven op EduLab';

  @override
  String get teachApplicationSubmit => 'Aanvraag indienen';

  @override
  String get teachApplicationSent => 'Je aanvraag is succesvol verzonden';

  @override
  String get notificationsTitle => 'Meldingen';

  @override
  String get notificationsMarkAllRead => 'Alles als gelezen markeren';

  @override
  String get notificationsMarkAllReadSnackbar =>
      'Alle meldingen gemarkeerd als gelezen';

  @override
  String get notificationsEmpty => 'Geen meldingen';

  @override
  String get notification1Title => 'Herinnering: Ga verder met je cursus';

  @override
  String get notification1Message =>
      'Er staat een nieuwe les klaar in Flutter voor Beginners';

  @override
  String get notification1Time => '5 minuten geleden';

  @override
  String get notification1Action => 'Cursus hervatten';

  @override
  String get notification2Title => 'Je certificaat staat klaar!';

  @override
  String get notification2Message =>
      'Je hebt de UI/UX cursus succesvol afgerond.';

  @override
  String get notification2Time => '2 uur geleden';

  @override
  String get notification2Action => 'Certificaat bekijken';

  @override
  String get notification3Title => 'Exclusieve aanbieding';

  @override
  String get notification3Message => '70% korting op programmeercursussen';

  @override
  String get notification3Time => '1 dag geleden';

  @override
  String get notification3Action => 'Aanbieding bekijken';

  @override
  String get notification4Title => 'Nieuw antwoord op je vraag';

  @override
  String get notification4Message => 'De docent heeft gereageerd op je vraag';

  @override
  String get notification4Time => '2 dagen geleden';

  @override
  String get notification4Action => 'Antwoord bekijken';

  @override
  String get notification5Title => 'Cursusupdate';

  @override
  String get notification5Message => 'Nieuwe content toegevoegd aan Python';

  @override
  String get notification5Time => '3 dagen geleden';

  @override
  String get messagesTitle => 'Berichten';

  @override
  String get settingsTitle => 'Instellingen & Voorkeuren';

  @override
  String get settingsVideoDownload => 'Video & Downloaden';

  @override
  String get settingsDownloadQuality => 'Standaard videokwaliteit';

  @override
  String get settingsWifiOnly => 'Alleen via Wi-Fi downloaden';

  @override
  String get settingsNotifications => 'Meldingen & Waarschuwingen';

  @override
  String get settingsCourseNotifications => 'Cursus- en berichtmeldingen';

  @override
  String get settingsPromoNotifications =>
      'Exclusieve aanbiedingen en kortingen';

  @override
  String get settingsAppearance => 'Weergave & Taal';

  @override
  String get settingsDarkMode => 'Donkere Modus';

  @override
  String get settingsDarkModeEnabled => 'Ingeschakeld (bespaart batterij)';

  @override
  String get settingsDarkModeDisabled => 'Uitgeschakeld (lichte modus)';

  @override
  String get settingsLanguage => 'App-taal';

  @override
  String get settingsStorage => 'Opslag & Cache';

  @override
  String get settingsClearCache => 'Cache wissen';

  @override
  String get settingsClearCacheSuccess => 'Cache succesvol gewist';

  @override
  String get settingsHelp => 'Info & Beleid';

  @override
  String get settingsHelpCenter => 'Helpcentrum & FAQ';

  @override
  String get settingsTermsPrivacy => 'Gebruiksvoorwaarden & Privacy';

  @override
  String get settingsAbout => 'Over EduLab';

  @override
  String get settingsVersion => 'Versie v1.0.0';

  @override
  String get quizTitle => 'Quiz';

  @override
  String get quizNext => 'Volgende vraag';

  @override
  String get quizSubmit => 'Quiz inleveren';

  @override
  String get quizScore => 'Quizscore';

  @override
  String get quizCorrectAnswers => 'Juiste antwoorden';

  @override
  String get scheduleTitle => 'Mijn Rooster';

  @override
  String get scheduleEmpty => 'Geen geplande sessies';

  @override
  String get scheduleJoin => 'Deelnemen aan sessie';

  @override
  String get scheduleReminder => 'Herinnering';

  @override
  String get assignmentsTitle => 'Opdrachten';

  @override
  String get assignmentsEmpty => 'Geen opdrachten';

  @override
  String get assignmentsSubmit => 'Opdracht inleveren';

  @override
  String get assignmentsDue => 'Inleverdatum';

  @override
  String get assignmentsSubmitted => 'Ingeleverd';

  @override
  String get assignmentsPending => 'In behandeling';

  @override
  String get languageArabic => 'Arabisch';

  @override
  String get languageEnglish => 'Engels';

  @override
  String get languageDialogTitle => 'App-taal selecteren';

  @override
  String get languageSelect => 'Selecteren';

  @override
  String get generalCancel => 'Annuleren';

  @override
  String get generalConfirm => 'Bevestigen';

  @override
  String get generalSave => 'Opslaan';

  @override
  String get generalDelete => 'Verwijderen';

  @override
  String get generalEdit => 'Bewerken';

  @override
  String get generalClose => 'Sluiten';

  @override
  String get generalBack => 'Terug';

  @override
  String get generalDone => 'Klaar';

  @override
  String get generalOk => 'OK';

  @override
  String get generalYes => 'Ja';

  @override
  String get generalNo => 'Nee';

  @override
  String get generalLoading => 'Laden...';

  @override
  String get generalError => 'Er is een fout opgetreden';

  @override
  String get generalRetry => 'Opnieuw proberen';

  @override
  String get generalNoInternet => 'Geen internetverbinding';

  @override
  String get generalFree => 'Gratis';

  @override
  String get generalRating => 'Beoordeling';

  @override
  String get generalStudents => 'Studenten';

  @override
  String get generalHours => 'Uur';

  @override
  String get generalMinutes => 'Minuten';

  @override
  String get generalBy => 'Door';

  @override
  String get navHome => 'Home';

  @override
  String get navExplore => 'Verkennen';

  @override
  String get navMyCourses => 'Mijn Cursussen';

  @override
  String get navCart => 'Winkelwagen';

  @override
  String get navAccount => 'Account';

  @override
  String get homeSubGreeting => 'Wat wil je vandaag leren?';

  @override
  String get homeVisitor => 'Gast';

  @override
  String get homePromoTitle => 'Ontdek nu aanbiedingen';

  @override
  String get homePromoSubtitle => 'Tot 70% korting op premium cursussen';

  @override
  String get homePromoButton => 'Nu ontdekken';

  @override
  String get homePromoBadge => 'Exclusieve aanbieding';

  @override
  String get homeContinueLearning => 'Verder leren';

  @override
  String get homeMyCoursesLink => 'Mijn cursussen';

  @override
  String get homeLesson => 'les';

  @override
  String homeStudentsCount(String count) {
    return '$count studenten';
  }

  @override
  String get homeRecommendedTitle => 'Aanbevolen voor jou';

  @override
  String get homeRecommendedSubtitle =>
      'Gepersonaliseerd op basis van jouw interesses';

  @override
  String get homeBestsellersTitle => 'Bestsellers';

  @override
  String get homeBestsellersSubtitle =>
      'Best beoordeelde en populairste cursussen';

  @override
  String get homeNewCoursesTitle => 'Nieuwe cursussen';

  @override
  String get homeNewCoursesSubtitle => 'Nieuwe en actuele content';

  @override
  String get homePopularTopicsTitle => 'Populaire onderwerpen';

  @override
  String get homePopularTopicsSubtitle =>
      'Leer de meest gevraagde vaardigheden';

  @override
  String get homeTopInstructorsTitle => 'Topdocenten';

  @override
  String get homeTopInstructorsSubtitle => 'Leer van gecertificeerde experts';

  @override
  String get homeExploreCategoriesTitle => 'Categorieën verkennen';

  @override
  String get homeExploreCategoriesSubtitle => 'Vind de juiste cursus voor jou';

  @override
  String get catAll => 'Alle';

  @override
  String get catWebDev => 'Webontwikkeling';

  @override
  String get catMobileApps => 'Mobiele Apps';

  @override
  String get catDataScience => 'Data Science';

  @override
  String get catUIUX => 'UI/UX Design';

  @override
  String get catBusiness => 'Zakelijk';

  @override
  String get catAI => 'Kunstmatige Intelligentie';

  @override
  String get catCyberSecurity => 'Cybersecurity';

  @override
  String get exploreNoResultsTitle => 'Geen resultaten gevonden';

  @override
  String get exploreNoResultsSubtitle => 'Probeer andere zoektermen of filters';

  @override
  String get exploreRecentSearches => 'Recente zoekopdrachten';

  @override
  String get exploreTopSearches => 'Veelgezocht';

  @override
  String get exploreBrowseCategories => 'Categorieën bladeren';

  @override
  String get exploreBrowseCategoriesSubtitle =>
      'Vind de juiste cursus voor jou';

  @override
  String get exploreBackToAll => 'Terug naar alles';

  @override
  String get exploreClearAll => 'Alles wissen';

  @override
  String get exploreAvailableResults => 'resultaten beschikbaar';

  @override
  String get exploreFilterBestseller => 'Bestseller';

  @override
  String get exploreFilterTopRated => 'Hoogst beoordeeld';

  @override
  String get exploreFilterUnder50 => 'Onder €50';

  @override
  String get learningHeroTitle => 'Vervolg je leertraject';

  @override
  String get learningSearchHint => 'Zoek in mijn cursussen...';

  @override
  String get learningFilterAll => 'Alle';

  @override
  String get learningFilterInProgress => 'Bezig';

  @override
  String get learningFilterCompleted => 'Voltooid';

  @override
  String get learningFilterDownloaded => 'Gedownload';

  @override
  String get learningEmptyTitle => 'Nog geen cursussen';

  @override
  String get learningEmptySubtitle =>
      'Begin nu met het verkennen van cursussen';

  @override
  String get learningEmptySearch => 'Geen resultaten voor je zoekopdracht';

  @override
  String get learningCompleted => 'Voltooid';

  @override
  String get learningCompletedBadge => 'Voltooid';

  @override
  String learningLecturesCount(int count) {
    return '$count lessen';
  }

  @override
  String get cartEmptyTitle => 'Je winkelwagen is leeg';

  @override
  String get cartEmptySubtitle => 'Voeg cursussen toe om te beginnen';

  @override
  String get cartCouponHint => 'Kortingscode invoeren';

  @override
  String get cartCouponApply => 'Toepassen';

  @override
  String get cartCouponInvalid => 'Ongeldige code';

  @override
  String get cartCouponApplied => 'Kortingscode toegepast';

  @override
  String get cartCouponDiscount => 'Korting';

  @override
  String get cartCouponsTitle => 'Kortingsbonnen';

  @override
  String get cartOrderSummary => 'Besteloverzicht';

  @override
  String get cartOriginalPrice => 'Oorspronkelijke prijs';

  @override
  String get cartPlatformDiscount => 'Platformkorting';

  @override
  String get cartFinalTotal => 'Eindtotaal';

  @override
  String cartItemsCount(int count) {
    return '$count cursussen';
  }

  @override
  String get cartRemovedSnackbar => 'Cursus verwijderd uit winkelwagen';

  @override
  String get cartUndo => 'Ongedaan maken';

  @override
  String get cartAddButton => 'Aan winkelwagen toevoegen';

  @override
  String get cartAddedSnackbar => 'Toegevoegd aan winkelwagen';

  @override
  String get cartAlreadyInCart => 'Al in winkelwagen';

  @override
  String get cartCheckoutButton => 'Doorgaan naar afrekenen';

  @override
  String get cartRecommendedTitle => 'Misschien vind je dit ook leuk';

  @override
  String get cartRecommendedSubtitle =>
      'Aanbevolen cursussen op basis van je winkelwagen';

  @override
  String get checkoutCreditCard => 'Creditcard';

  @override
  String get checkoutSelectPayment => 'Kies betaalmethode';

  @override
  String get checkoutCardNumberLabel => 'Kaartnummer';

  @override
  String get checkoutCardHolderLabel => 'Naam kaarthouder';

  @override
  String get checkoutExpiryLabel => 'Vervaldatum';

  @override
  String get checkoutCVVLabel => 'CVV';

  @override
  String get checkoutPersonalInfoTitle => 'Persoonlijke gegevens';

  @override
  String get checkoutFullNameLabel => 'Volledige naam';

  @override
  String get checkoutFullNameHint => 'Je volledige naam';

  @override
  String get checkoutFullNameRequired => 'Volledige naam is verplicht';

  @override
  String get checkoutPhoneLabel => 'Telefoonnummer';

  @override
  String get checkoutPhoneRequired => 'Telefoonnummer is verplicht';

  @override
  String get checkoutPostalLabel => 'Postcode';

  @override
  String get checkoutPostalRequired => 'Postcode is verplicht';

  @override
  String get checkoutBuyerInfo => 'Kopersinformatie';

  @override
  String get checkoutSaveInfo => 'Gegevens opslaan voor de volgende keer';

  @override
  String get checkoutMoneyBackGuarantee => '30 dagen geld-terug-garantie';

  @override
  String get checkoutContinueToPayment => 'Doorgaan naar betaling';

  @override
  String get checkoutContinueToReview => 'Doorgaan naar overzicht';

  @override
  String get checkoutReviewConfirm => 'Controleren & Bevestigen';

  @override
  String get checkoutStartLearning => 'Start met leren';

  @override
  String get checkoutBackHome => 'Terug naar startpagina';

  @override
  String get courseDetailsTitle => 'Cursusdetails';

  @override
  String get courseDetailsShare => 'Delen';

  @override
  String get courseDetailsWhatYouWillLearn => 'Wat je zult leren';

  @override
  String get courseDetailsLanguage => 'Taal';

  @override
  String get courseDetailsCreatedBy => 'Gemaakt door';

  @override
  String get courseDetailsPreviewLesson => 'Voorbeeldles';

  @override
  String get courseDetailsHoursOnDemand => 'uur on-demand video';

  @override
  String get courseDetailsFullLifetimeAccess => 'Volledige levenslange toegang';

  @override
  String get courseDetailsCertifiedCertificate => 'Erkend certificaat';

  @override
  String get courseDetailsComprehensiveContent => 'Volledige inhoud';

  @override
  String get certTitle => 'Certificaat van Voltooiing';

  @override
  String get certStudentNameLabel => 'Student';

  @override
  String get certCourseLabel => 'Cursus';

  @override
  String get certInstructorLabel => 'Docent';

  @override
  String get certIssueDateLabel => 'Uitgiftedatum';

  @override
  String get certCodeLabel => 'Certificaat-ID';

  @override
  String get certVerifiedBadge => 'Geverifieerd';

  @override
  String get certDownloadPDF => 'PDF downloaden';

  @override
  String get certDownloadPNG => 'Afbeelding downloaden';

  @override
  String get certCopyVerifyLink => 'Verificatielink kopiëren';

  @override
  String get certShare => 'Certificaat delen';

  @override
  String get playerTabLessons => 'Lessen';

  @override
  String get playerTabOverview => 'Overzicht';

  @override
  String get playerTabNotes => 'Mijn notities';

  @override
  String get playerTabQnA => 'Vragen & Antwoorden';

  @override
  String get playerNextLesson => 'Volgende les';

  @override
  String get profileWelcome => 'Welkom';

  @override
  String get profileLoginPrompt => 'Log in om je profiel te bekijken';

  @override
  String get profileLoginOrRegister => 'Inloggen / Registreren';

  @override
  String get profileVerifiedStudent => 'Geverifieerde student';

  @override
  String get profileLogout => 'Uitloggen';

  @override
  String get profileCancel => 'Annuleren';

  @override
  String get profileLogoutConfirmTitle => 'Uitloggen';

  @override
  String get profileLogoutConfirmMessage =>
      'Weet je zeker dat je wilt uitloggen?';

  @override
  String get profileAccountSettings => 'Accountinstellingen';

  @override
  String get profileEditProfileSubtitle => 'Bewerk je persoonlijke gegevens';

  @override
  String get profileSecurity => 'Accountbeveiliging';

  @override
  String get profileSecuritySubtitle => 'Wachtwoord & verificatie';

  @override
  String get profilePurchaseHistory => 'Aankoopgeschiedenis';

  @override
  String get profilePurchaseHistorySubtitle => 'Bekijk eerdere transacties';

  @override
  String get profileCertificatesSubtitle => 'Jouw behaalde certificaten';

  @override
  String get profileTeach => 'Lesgeven op EduLab';

  @override
  String get profileTeachSubtitle => 'Deel je kennis met anderen';

  @override
  String get profilePreferences => 'Voorkeuren';

  @override
  String get profilePreferencesSubtitle => 'Instellingen & weergave';

  @override
  String get profileNotifications => 'Meldingen';

  @override
  String get profileNotificationsSubtitle => 'Beheer je meldingen';

  @override
  String get profileHelpSupport => 'Hulp & Ondersteuning';

  @override
  String get profileTerms => 'Gebruiksvoorwaarden';

  @override
  String get profilePrivacy => 'Privacybeleid';

  @override
  String get profileAboutEduLab => 'Over EduLab';

  @override
  String get profileWishlist => 'Verlanglijst';

  @override
  String get securityTitle => 'Accountbeveiliging';

  @override
  String get teachTitle => 'Lesgeven op EduLab';

  @override
  String get notificationsTabAll => 'Alle';

  @override
  String get notificationsTabCourses => 'Cursussen';

  @override
  String get notificationsTabPromos => 'Aanbiedingen';

  @override
  String get notificationsEmptyTitle => 'Geen meldingen';

  @override
  String get notificationsUnread => 'Ongelezen';

  @override
  String get wishlistTitle => 'Verlanglijst';

  @override
  String get wishlistEmptyTitle => 'Je verlanglijst is leeg';

  @override
  String get wishlistEmptySubtitle => 'Sla cursussen op die je interesseren';

  @override
  String get wishlistAddToCart => 'Aan winkelwagen toevoegen';

  @override
  String get wishlistRemovedSnackbar => 'Verwijderd uit verlanglijst';

  @override
  String get homeDefaultUser => 'Student';

  @override
  String get learningOf => 'van';

  @override
  String get cartInCartBadge => 'In winkelwagen';

  @override
  String get homePromo1Badge => 'Grote korting • Beperkte tijd';

  @override
  String get homePromo1Title => 'Begin met leren tegen de beste prijzen';

  @override
  String get homePromo1Subtitle =>
      'Tot 65% korting op cursussen in programmeren, design en business.';

  @override
  String get homePromo1Button => 'Bekijk aanbiedingen';

  @override
  String get homePromo2Badge => 'Gecertificeerde leertrajecten';

  @override
  String get homePromo2Title => 'Bereid je voor op je droombaan';

  @override
  String get homePromo2Subtitle =>
      'Complete cursussen van beginner tot pro met echte projecten en certificaten.';

  @override
  String get homePromo2Button => 'Verken trajecten';

  @override
  String get homePromo3Badge => 'Topdocenten & experts';

  @override
  String get homePromo3Title => 'Leer rechtstreeks van professionals';

  @override
  String get homePromo3Subtitle =>
      'Voortdurend bijgewerkte content om de nieuwste technologieën te beheersen.';

  @override
  String get homePromo3Button => 'Nu beginnen';

  @override
  String get homePromoInstructorBadge => 'Lesgeven op EduLab • Kennis delen';

  @override
  String get homePromoInstructorTitle => 'Word vandaag nog instructeur';

  @override
  String get homePromoInstructorSubtitle =>
      'Inspireer leerlingen wereldwijd, maak cursussen en verdien een inkomen door les te geven in waar je van houdt.';

  @override
  String get homePromoInstructorButton => 'Nu aanmelden';

  @override
  String get homeSearchFilter => 'Filteren';

  @override
  String get securitySectionChangePassword => 'Wachtwoord wijzigen';

  @override
  String get securityCurrentPasswordLabel => 'Huidig wachtwoord *';

  @override
  String get securityCurrentPasswordError => 'Voer huidig wachtwoord in';

  @override
  String get securityNewPasswordLabel => 'Nieuw wachtwoord *';

  @override
  String get securityNewPasswordError => 'Moet minimaal 8 tekens bevatten';

  @override
  String get securityConfirmPasswordLabel => 'Nieuw wachtwoord bevestigen *';

  @override
  String get securityConfirmPasswordError => 'Wachtwoorden komen niet overeen';

  @override
  String get securityUpdatePasswordBtn => 'Wachtwoord bijwerken';

  @override
  String get securityPasswordUpdatedSuccess =>
      'Wachtwoord succesvol gewijzigd!';

  @override
  String get securitySection2FA => 'Tweestapsverificatie (2FA)';

  @override
  String get security2FATitle => 'Tweestapsverificatie';

  @override
  String get security2FAEnabledDesc =>
      'Ingeschakeld - Beveiligd met verificatiecode';

  @override
  String get security2FADisabledDesc => 'Uitgeschakeld (Aanbevolen)';

  @override
  String get security2FASetupTitle => 'Tweestapsverificatie inschakelen';

  @override
  String get security2FASetupContent =>
      'Er wordt bij elke nieuwe aanmelding een 6-cijferige verificatiecode naar uw e-mail verzonden.';

  @override
  String get security2FAEnableNow => 'Nu inschakelen';

  @override
  String get security2FAEnabledSuccess =>
      'Tweestapsverificatie succesvol ingeschakeld!';

  @override
  String get security2FADisabledSuccess => 'Tweestapsverificatie uitgeschakeld';

  @override
  String get securitySectionSessions => 'Actieve sessies & apparaten';

  @override
  String get securityLogoutAllDevices => 'Overal uitloggen';

  @override
  String get securityThisDevice => 'Dit apparaat';

  @override
  String get securitySessionRevokedSuccess =>
      'Sessie beëindigd en apparaat uitgelogd.';

  @override
  String get securityAllSessionsRevokedSuccess =>
      'Uitgelogd op alle andere apparaten.';

  @override
  String get purchaseHistoryInvoiceCertified => 'Gecertificeerde E-factuur';

  @override
  String get purchaseHistoryInvoiceNumber => 'Factuurnummer';

  @override
  String get purchaseHistoryCourse => 'Cursus';

  @override
  String get purchaseHistoryPaymentMethod => 'Betaalmethode';

  @override
  String get purchaseHistoryTotalAmount => 'Totaalbedrag:';

  @override
  String get purchaseHistoryClose => 'Sluiten';

  @override
  String get purchaseHistoryDownloadPdf => 'PDF downloaden';

  @override
  String get purchaseHistoryPdfDownloaded => 'Factuur-PDF succesvol gedownload';

  @override
  String get purchaseHistoryRefundRequestTitle => 'Terugbetaling aanvragen';

  @override
  String get purchaseHistoryRefundPolicy =>
      'Volgens de 30-dagen geld-terug-garantie van EduLab kunt u een volledige terugbetaling krijgen.';

  @override
  String get purchaseHistoryRefundReasonHint =>
      'Reden van terugbetaling (optioneel)...';

  @override
  String get purchaseHistoryConfirmRefund => 'Terugbetaling bevestigen';

  @override
  String get purchaseHistoryRefundSubmitted =>
      'Terugbetalingsverzoek ingediend (3-5 werkdagen).';

  @override
  String get purchaseHistoryInstructor => 'Instructeur';

  @override
  String get purchaseHistoryRequestRefundBtn => 'Terugbetaling vragen';

  @override
  String get purchaseHistoryInvoiceBtn => 'Factuur';

  @override
  String get purchaseHistoryStatusCompleted => 'Voltooid';

  @override
  String get purchaseHistoryStatusRefunded => 'Terugbetaald';

  @override
  String get purchaseHistoryStatusProcessingRefund =>
      'Terugbetaling in behandeling';

  @override
  String get editProfileSectionBasicInfo => 'Basisinformatie';

  @override
  String get editProfileFullNameLabel => 'Volledige naam *';

  @override
  String get editProfileFullNameHint => 'Voer uw volledige naam in';

  @override
  String get editProfileFullNameError => 'Voer uw volledige naam in';

  @override
  String get editProfileHeadlineLabel => 'Professionele titel';

  @override
  String get editProfileHeadlineHint => 'bijv. Senior Flutter-ontwikkelaar';

  @override
  String get editProfileLocationLabel => 'Stad / Land';

  @override
  String get editProfileLocationHint => 'Amsterdam, Nederland';

  @override
  String get editProfilePhoneLabel => 'Mobiel telefoonnummer';

  @override
  String get editProfileBioLabel => 'Over mij (Bio)';

  @override
  String get editProfileBioHint =>
      'Schrijf een korte samenvatting over uw interesses en ervaring...';

  @override
  String get editProfileSectionLinks => 'Links & professionele netwerken';

  @override
  String get editProfileWebsiteLabel => 'Persoonlijke website';

  @override
  String get editProfileSectionEmail => 'Geregistreerd e-mailadres';

  @override
  String get editProfileEmailDesc =>
      'Gekoppeld aan uw account voor inloggen en certificaten';

  @override
  String get editProfileEmailVerified => 'Geverifieerd';

  @override
  String get editProfileSaveChangesBtn => 'Wijzigingen opslaan';

  @override
  String get editProfileSavedSuccess => 'Profiel succesvol bijgewerkt!';

  @override
  String get editProfileChangeAvatarTitle => 'Profielfoto wijzigen';

  @override
  String get editProfileTakePhoto => 'Foto maken met camera';

  @override
  String get editProfileChooseGallery => 'Kiezen uit galerij';

  @override
  String get editProfilePhotoUpdatedSuccess =>
      'Profielfoto succesvol bijgewerkt';

  @override
  String get teachJoinInstructorTitle => 'Word gecertificeerd instructeur';

  @override
  String get teachJoinInstructorSubtitle =>
      'Publiceer cursussen en deel uw expertise met duizenden studenten.';

  @override
  String get teachStep1Title => 'Persoonlijke info';

  @override
  String get teachStep2Title => 'Ervaring & vaardigheden';

  @override
  String get teachStep3Title => 'Bevestiging';

  @override
  String get teachStep1Header => '1. Persoonlijke & professionele info';

  @override
  String get teachFullNameArabicLabel => 'Volledige naam *';

  @override
  String get teachFullNameArabicHint => 'bijv. Jan de Vries';

  @override
  String get teachHeadlineLabel => 'Functietitel & specialiteit *';

  @override
  String get teachHeadlineHint =>
      'bijv. Senior Software Architect & Flutter Trainer';

  @override
  String get teachPhoneLabel => 'Telefoonnummer *';

  @override
  String get teachCountryLabel => 'Land van verblijf *';

  @override
  String get teachBioLabel => 'Bio & eerdere ervaring *';

  @override
  String get teachBioHint =>
      'Schrijf een korte samenvatting van uw loopbaan en eerdere projecten...';

  @override
  String get teachNextStepSkills => 'Volgende: Ervaring & vaardigheden';

  @override
  String get teachStep2Header => '2. Cursusinhoud & vaardigheden';

  @override
  String get teachTopicLabel => 'Onderwerp of traject van de cursus *';

  @override
  String get teachTopicHint => 'bijv. Flutter app-ontwikkeling vanaf nul';

  @override
  String get teachYearsExperienceLabel => 'Jaren ervaring in het vakgebied *';

  @override
  String get teachVideoLinkLabel =>
      'Link naar proefvideo (YouTube/Drive/Loom) *';

  @override
  String get teachTargetAudienceLabel => 'Doelgroep voor de cursus *';

  @override
  String get teachAudienceBeginners => 'Volledige beginners';

  @override
  String get teachAudienceIntermediate => 'Beginners & gevorderden';

  @override
  String get teachAudienceAdvanced => 'Gevorderden & professionals';

  @override
  String get teachAudienceAll => 'Alle niveaus';

  @override
  String get teachSkillsCoveredLabel =>
      'Vaardigheden & technologieën in de cursus *';

  @override
  String get teachAddSkillHint => 'Vaardigheid toevoegen (bijv. GraphQL)...';

  @override
  String get teachAddSkillBtn => 'Toevoegen';

  @override
  String get teachNextStepConfirm => 'Volgende: Aanvraag bevestigen';

  @override
  String get teachStep3Header => '3. Uitbetalingsgegevens & voorwaarden';

  @override
  String get teachPayoutMethodLabel => 'Uitbetalingsmethode *';

  @override
  String get teachPayoutMethodBank => 'Directe bankoverschrijving (IBAN)';

  @override
  String get teachPayoutMethodPaypal => 'Geverifieerde PayPal-account';

  @override
  String get teachPayoutMethodPayoneer => 'Payoneer-kaart';

  @override
  String get teachIbanDetailsLabel => 'Accountgegevens / IBAN *';

  @override
  String get teachApplicationSummary => 'Aanvraagoverzicht:';

  @override
  String get teachApplicantName => 'Aanvrager';

  @override
  String get teachApplicantHeadline => 'Specialiteit';

  @override
  String get teachApplicantTopic => 'Cursusonderwerp';

  @override
  String get teachApplicantSkillsCount => 'Aantal vaardigheden';

  @override
  String get teachSkillsUnit => 'vaardigheden';

  @override
  String get teachAgreeTermsLabel =>
      'Ik ga akkoord met de instructeursvoorwaarden en intellectuele eigendomsrechten van EduLab.';

  @override
  String get teachSubmitApplicationBtn => 'Submit Instructor Application';

  @override
  String get teachPrevStepBtn => 'Vorige';

  @override
  String get teachWhyEduLabTitle => 'Waarom lesgeven bij EduLab?';

  @override
  String get teachProp1Title => 'Aantrekkelijke & eerlijke inkomsten';

  @override
  String get teachProp1Desc =>
      'Verdien tot 80% op de verkoop van uw cursussen zonder verborgen kosten.';

  @override
  String get teachProp2Title => 'Bereik duizenden studenten';

  @override
  String get teachProp2Desc =>
      'Promoot uw cursus aan een grote en actieve leergemeenschap.';

  @override
  String get teachProp3Title => 'Volledige technische & productieondersteuning';

  @override
  String get teachProp3Desc =>
      'Ons team helpt u met het optimaliseren van audio, video en lesprogramma.';

  @override
  String get teachSuccessDialogTitle => 'Aanvraag succesvol ontvangen!';

  @override
  String get teachSuccessDialogDesc =>
      'Bedankt voor uw aanmelding bij EduLab. Ons team beoordeelt uw aanvraag binnen 48 uur.';

  @override
  String get teachSuccessDialogOk => 'Begrepen';

  @override
  String get teachAddOneSkillError => 'Voeg minimaal één vaardigheid toe';

  @override
  String get teachAgreeTermsError =>
      'Ga akkoord met de instructeursvoorwaarden';

  @override
  String get commonCancel => 'Annuleren';

  @override
  String get commonClose => 'Sluiten';

  @override
  String get myCertificatesBannerTitle => 'Geaccrediteerde Certificaten';

  @override
  String get myCertificatesBannerSubtitle =>
      'Alle certificaten zijn geaccrediteerd en geverifieerd met een unieke ID van EduLab';

  @override
  String get certBadgeVerified100 => '100% Geaccrediteerd';

  @override
  String get certCodeCopied => 'Certificaatcode gekopieerd';

  @override
  String get certGrantedTo => 'Toegekend aan';

  @override
  String get certViewAndDownload => 'Certificaat bekijken en downloaden';

  @override
  String get certIssuerLabel => 'Uitgevende instantie';

  @override
  String get certIssuerName => 'EduLab Interactieve Leeracademie';

  @override
  String get certEmptyTitle => 'Nog geen certificaten behaald';

  @override
  String get certEmptyDesc =>
      'Voltooi 100% van een ingeschreven cursus om een geaccrediteerd certificaat met officiële verificatie-ID te ontvangen.';

  @override
  String get certEmptyAction => 'Mijn cursussen voortzetten';

  @override
  String get certDetailsTitle => 'Certificaatdetails & informatie';

  @override
  String get certCopyLinkSuccess =>
      'Directe verificatielink gekopieerd naar klembord!';

  @override
  String get certShareSuccess =>
      'Certificaatdetails en link gekopieerd om te delen!';

  @override
  String get purchaseHistoryTaxInvoiceCertified =>
      'Officiële gecertificeerde belastingfactuur';

  @override
  String get purchaseHistoryInvoiceNumberLabel => 'Bestel- / Factuurnummer';

  @override
  String get purchaseHistoryCourseNameLabel => 'Cursusnaam';

  @override
  String get purchaseHistoryPurchaseDateLabel => 'Aankoopdatum';

  @override
  String get purchaseHistoryPaymentMethodLabel => 'Betaalmethode';

  @override
  String get purchaseHistoryPaymentMethodValue =>
      'Creditcard / Stripe (Online)';

  @override
  String get purchaseHistoryOrderStatusLabel => 'Bestelstatus';

  @override
  String get purchaseHistoryStatusPendingReview =>
      'Terugbetalingsbeoordeling in behandeling';

  @override
  String get purchaseHistoryCopyInvoiceBtn => 'Factuurnummer kopiëren';

  @override
  String get purchaseHistoryRefundReasonLabel =>
      'Reden voor terugbetalingsverzoek:';

  @override
  String get purchaseHistoryRefundReasonEmptyError =>
      'Voer een reden in voor uw terugbetalingsverzoek';

  @override
  String get purchaseHistorySubmittingRefund => 'Verzoek wordt verzonden...';

  @override
  String get purchaseHistoryPaidDate => 'Betaaldatum';

  @override
  String get purchaseHistoryEmptyTitle => 'Nog geen aankoopgeschiedenis';

  @override
  String get purchaseHistoryEmptyDesc =>
      'U heeft nog geen cursussen gekocht.\nUw bestellingen en facturen verschijnen hier zodra ze zijn voltooid.';

  @override
  String get purchaseHistoryExploreCourses => 'Cursussen nu verkennen';

  @override
  String get profileMyCourses => 'Mijn Cursussen';

  @override
  String get profileMyCoursesSubtitle =>
      'Voortgang in uw ingeschreven cursussen volgen';

  @override
  String get profileWishlistSubtitle =>
      'Cursussen opgeslagen in uw verlanglijst';

  @override
  String get navMyLearning => 'Mijn Leren';

  @override
  String get profileLogoutSafeNote =>
      'Uw gegevens, cursussen en certificaten zijn volkomen veilig. U kunt op elk moment verder leren door opnieuw in te loggen.';

  @override
  String learningRemainingHours(String hours) {
    return 'Nog $hours uur';
  }

  @override
  String get learningCompletedFull => 'Voltooid';

  @override
  String get learningFilterNotStarted => 'Niet Gestart';

  @override
  String get wishlistTopRatedBadge => 'Hoogst beoordeeld';

  @override
  String get wishlistFeaturedBadge => 'Uitgelicht';

  @override
  String wishlistDiscountBadge(String percent) {
    return '$percent% korting';
  }

  @override
  String get courseFree => 'Gratis';

  @override
  String get badgeBestseller => 'Bestseller';

  @override
  String get badgeTopRated => 'Hoogst beoordeeld';

  @override
  String get badgeFeatured => 'Uitgelicht';

  @override
  String get badgeRecommended => 'Aanbevolen voor jou';

  @override
  String get badgeNew => 'Nieuw';

  @override
  String get courseWord => 'Cursus';

  @override
  String coursesCountText(String count) {
    return '$count+ Cursussen';
  }

  @override
  String studentsCountText(String count) {
    return '$count Studenten';
  }

  @override
  String hoursCountText(String count) {
    return '$count Uur';
  }

  @override
  String get certifiedInstructor => 'Gecertificeerde Instructeur';

  @override
  String get expertCertifiedInstructor =>
      'Expert & Gecertificeerde Instructeur';

  @override
  String get defaultCourseTitle => 'Educatieve Cursus';

  @override
  String get categoryWord => 'Categorie';

  @override
  String get previewCourseVideo => 'Voorbeeld Cursusvideo';

  @override
  String get freeSection => 'Gratis Deel';

  @override
  String get freeDemoVideo => 'Gratis Demovideo';

  @override
  String get articleLecture => 'Artikel Les';

  @override
  String get articleViewer => 'Artikel Lezer';

  @override
  String get courseVideoPlayer => 'Cursus Videospeler';

  @override
  String get playingNow => 'Nu afspelen';

  @override
  String get readingNow => 'Nu lezen';

  @override
  String get noLecturesInFreeSection => 'Geen lessen in het gratis deel';

  @override
  String freeLecturesCount(String count) {
    return '$count gratis lessen';
  }

  @override
  String get enrollInFullCourse => 'Inschrijven voor volledige cursus';

  @override
  String get articleWord => 'Artikel';

  @override
  String get videoWord => 'Video';

  @override
  String get quizWord => 'Quiz';

  @override
  String get courseShareCopied => 'Cursuslink gekopieerd naar klembord!';

  @override
  String get addedToCartSnackbar => 'Toegevoegd aan winkelwagen';

  @override
  String get viewCartAction => 'Winkelwagen bekijken';

  @override
  String get inCartBadge => 'In winkelwagen ✓';

  @override
  String get addToCartButton => 'Aan winkelwagen toevoegen';

  @override
  String get wishlistAddedSnackbar => 'Cursus toegevoegd aan verlanglijst';

  @override
  String get wishlistRemovedSuccessSnackbar =>
      'Cursus verwijderd van verlanglijst';

  @override
  String get lessonCompletedAll =>
      'Gefeliciteerd! U heeft alle lessen van deze cursus voltooid.';

  @override
  String get noteAddedSuccess => 'Notitie succesvol toegevoegd';

  @override
  String get lessonAlreadyDownloaded =>
      'Les is al opgeslagen voor offline gebruik';

  @override
  String get lessonLinkCopied => 'Leslink gekopieerd';

  @override
  String get contentReportThanks =>
      'Bedankt voor uw feedback, we bekijken de les.';

  @override
  String get courseCompletionCertificate => 'Certificaat van Voltooiing';

  @override
  String get reportContentIssue => 'Probleem met inhoud melden';

  @override
  String get loginOrSocial => 'Of log in met';

  @override
  String get loginSuccessSnackbar => 'Succesvol ingelogd';

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
  String get cartClearAllTitle => 'Alle winkelwagenitems wissen?';

  @override
  String cartClearAllMessage(String count) {
    return 'Weet je zeker dat je alle $count cursussen uit je winkelwagen wilt verwijderen?';
  }

  @override
  String get cartClearAllHint =>
      'Alle cursussen worden uit uw winkelwagen verwijderd. Je kunt ze op elk gewenst moment weer toevoegen.';

  @override
  String cartClearAllConfirm(String count) {
    return 'Alles wissen ($count)';
  }

  @override
  String get cartClearedSuccess => 'Winkelwagen is succesvol gewist';

  @override
  String get cartClearFailed => 'Kan het winkelwagentje niet wissen';

  @override
  String cartViewWishlistCount(String count) {
    return 'Bekijk verlanglijstitems ($count)';
  }

  @override
  String get cartGoToWishlist => 'Ga naar verlanglijst';

  @override
  String get wishlistClearAllTitle => 'Alle verlanglijstitems wissen?';

  @override
  String wishlistClearAllMessage(String count) {
    return 'Weet je zeker dat je alle $count cursussen van je verlanglijst wilt verwijderen?';
  }

  @override
  String get wishlistClearAllHint =>
      'Alle opgeslagen cursussen worden gewist. Je kunt ze op elk gewenst moment weer toevoegen vanuit Verkennen.';

  @override
  String wishlistClearAllConfirm(String count) {
    return 'Alles wissen ($count)';
  }

  @override
  String get wishlistClearedSuccess => 'Verlanglijst is succesvol gewist';

  @override
  String get wishlistClearFailed => 'Kan verlanglijst niet wissen';

  @override
  String get wishlistClearTooltip => 'Alles wissen';

  @override
  String wishlistViewCartCount(String count) {
    return 'Bekijk winkelwagenitems ($count)';
  }

  @override
  String get wishlistGoToCart => 'Ga naar winkelwagen';

  @override
  String get checkoutCardNumberInvalid =>
      'Voer een geldig kaartnummer van 16 cijfers in';

  @override
  String get checkoutCardExpiryInvalidFormat =>
      'Voer een geldige vervaldatum van de kaart in (MM / JJ)';

  @override
  String get checkoutCardExpiredDate =>
      'De vervaldatum van de kaart is ongeldig';

  @override
  String get checkoutCardCvcInvalid =>
      'Voer een geldige CVC-code van 3 of 4 cijfers in';

  @override
  String get checkoutCardHolderNameRequired =>
      'Voer de naam van de kaarthouder in';

  @override
  String get checkoutCartEmptySnackbar => 'Winkelwagen is leeg';

  @override
  String get checkoutPaymentStartFailed => 'Kan de betaling niet starten';

  @override
  String get checkoutClientSecretMissing =>
      'Er is geen beveiligingssleutel ontvangen van de betalingsgateway';

  @override
  String get checkoutCardVerificationFailed => 'Kaartverificatie mislukt';

  @override
  String get checkoutStripeProcessingFailed =>
      'Stripe-betalingsverwerking mislukt';

  @override
  String get checkoutServerConfirmationFailed =>
      'Bevestiging van serverbetaling mislukt';

  @override
  String get checkoutEmptyCartTitle => 'Uw winkelwagen is leeg';

  @override
  String get checkoutEmptyCartDesc =>
      'Je hebt nog geen cursussen aan je winkelwagen toegevoegd. Ontdek onze cursussen en begin met leren!';

  @override
  String get checkoutContinueFreeReview => 'Ga verder naar Gratis recensie';

  @override
  String get checkoutFreeOrderBadge => '100% gratis bestelling (zsh.00)';

  @override
  String get checkoutFreeOrderNotice =>
      'Voor deze bestelling zijn geen betalingsgegevens vereist. U kunt direct doorgaan om de inschrijving te bevestigen.';

  @override
  String get checkoutFreeCheckoutTitle => '100% gratis afrekenen';

  @override
  String get checkoutConfirmFreeEnrollment => 'Bevestig gratis inschrijving';

  @override
  String get checkoutFreePrice => 'Vrij';

  @override
  String get checkoutFreeZero => 'Gratis (zsh.00)';

  @override
  String checkoutCoursesCount(String count) {
    return '$count cursussen';
  }

  @override
  String get notificationsClearAllTitle => 'Alle meldingen wissen?';

  @override
  String notificationsClearAllMessage(String count) {
    return 'Weet je zeker dat je alle $count meldingen wilt verwijderen? Deze actie kan niet ongedaan worden gemaakt.';
  }

  @override
  String get notificationsClearAllHint =>
      'Al uw meldingen worden verwijderd en uw inbox wordt opnieuw gestart.';

  @override
  String notificationsClearAllConfirm(String count) {
    return 'Alles wissen ($count)';
  }

  @override
  String get notificationsClearSuccess =>
      'Alle meldingen zijn succesvol gewist';

  @override
  String get notificationsClearFailed => 'Kan meldingen niet wissen';

  @override
  String get notificationsClearTooltip => 'Alles wissen';

  @override
  String get notificationsViewDetails => 'Details bekijken';

  @override
  String get notificationsEmptyCategoryTitle =>
      'Geen meldingen in deze categorie';

  @override
  String get notificationsEmptyCategorySubtitle =>
      'Probeer over te schakelen naar een andere categorie of blader door alle meldingen';

  @override
  String get notificationsEmptyAllSubtitle =>
      'Wij houden u hier op de hoogte van de laatste updates en waarschuwingen';

  @override
  String get notificationsViewAll => 'Bekijk alle meldingen';

  @override
  String get learningFilterAndSortTitle => 'Cursussen filteren en sorteren';

  @override
  String get learningFilterReset => 'Opnieuw instellen';

  @override
  String get learningSortByTitle => 'Sorteer op';

  @override
  String get learningSortRecentActivity => 'Onlangs geopend';

  @override
  String get learningSortRecentEnrolled => 'Onlangs ingeschreven';

  @override
  String get learningSortTitleAZ => 'Titel (A-Z)';

  @override
  String get learningSortProgress => 'Voortgang %';

  @override
  String get learningStatusTitle => 'Cursusstatus';

  @override
  String get learningStatusAll => 'Alle cursussen';

  @override
  String get learningStatusInProgress => 'In uitvoering';

  @override
  String get learningStatusCompleted => 'Voltooid';

  @override
  String get learningStatusNotStarted => 'Niet gestart';

  @override
  String get learningFilterApply => 'Filters toepassen';

  @override
  String get learningSearchCoursesHint => 'Zoek in je cursussen...';

  @override
  String get learningSearchWishlistHint => 'Zoek in verlanglijst...';

  @override
  String get learningSearchCertificatesHint => 'Zoek certificaten...';

  @override
  String get learningTabMyCourses => 'Mijn cursussen';

  @override
  String get learningTabFavourite => 'Mijn favorieten';

  @override
  String get learningTabCertificates => 'Mijn certificaten';

  @override
  String get learningNoCoursesTitle => 'Nog geen cursussen';

  @override
  String get learningNoCoursesSubtitle =>
      'Ontdek duizenden premium cursussen en begin vandaag nog aan je leertraject';

  @override
  String get learningFilterButton => 'Filter';

  @override
  String learningFilterAllCount(String count) {
    return 'Alles ($count)';
  }

  @override
  String get learningStatusNotStartedShort => 'Niet gestart';

  @override
  String get learningNoMatchTitle => 'Geen overeenkomende cursussen';

  @override
  String learningNoMatchSubtitle(String query) {
    return 'Geen cursussen gevonden met \"$query\". Probeer te zoeken met andere termen.';
  }

  @override
  String get learningNoInProgressTitle => 'Geen cursussen bezig';

  @override
  String get learningNoInProgressSubtitle =>
      'Begin met het bekijken van lessen in je ingeschreven cursussen om je voortgang hier bij te houden.';

  @override
  String get learningNoCompletedTitle => 'Nog geen voltooide cursussen';

  @override
  String get learningNoCompletedSubtitle =>
      'Ga door met studeren om je voortgang te vieren en voltooide cursussen hier te zien.';

  @override
  String get learningNoUnstartedTitle => 'Geen niet-gestarte cursussen';

  @override
  String get learningNoUnstartedSubtitle =>
      'Geweldig! Je bent al begonnen met leren in al je ingeschreven cursussen.';

  @override
  String get learningNoFilterMatchTitle =>
      'Geen cursussen voldoen aan dit filter';

  @override
  String get learningNoFilterMatchSubtitle =>
      'Wijzig filter- of sorteeropties om je cursussen weer te geven.';

  @override
  String learningViewAllCoursesCount(String count) {
    return 'Alle cursussen bekijken ($count)';
  }

  @override
  String learningSavedCoursesCount(String count) {
    return 'Opgeslagen cursussen ($count)';
  }

  @override
  String get learningClearAllSaved => 'Alles wissen';

  @override
  String get learningNoCertificatesTitle => 'Nog geen certificaten';

  @override
  String get learningNoCertificatesSubtitle =>
      'Voltooi je cursussen om geaccrediteerde certificaten te behalen die je prestaties bevestigen';

  @override
  String get learningGoToCourses => 'Ga naar Mijn cursussen';

  @override
  String learningCertIssuedDate(String date) {
    return 'Uitgegeven: $date';
  }

  @override
  String get learningCertView => 'Bekijken';

  @override
  String get learningResumeLesson => 'Les hervatten';

  @override
  String learningProgressPercentComplete(String percent) {
    return '$percent% voltooid';
  }

  @override
  String learningViewCartCount(String count) {
    return 'Winkelwagenitems bekijken ($count)';
  }

  @override
  String get learningGoToCart => 'Ga naar winkelwagen';

  @override
  String get playerLessonMarkedCompleted => 'Les gemarkeerd als voltooid ✓';

  @override
  String get playerLessonMarkedIncomplete => 'Les gemarkeerd als niet voltooid';

  @override
  String get playerCommentPostedSuccess => 'Reactie succesvol geplaatst';

  @override
  String get playerCommentPostFailed => 'Kan reactie niet plaatsen';

  @override
  String get playerReplyPostedSuccess => 'Antwoord succesvol geplaatst';

  @override
  String get playerReplyPostFailed => 'Kan antwoord niet plaatsen';

  @override
  String get playerCourseNotFound => 'Cursus niet gevonden';

  @override
  String get playerCheckEnrollmentPrompt =>
      'Controleer eerst je inschrijving voor de cursus';

  @override
  String get playerReturnToCourses => 'Mijn Leren';

  @override
  String get playerWatchLecture => 'Cursusles';

  @override
  String get playerCertificateTooltip => 'Certificaat';

  @override
  String get playerRateCourseTooltip => 'Cursus beoordelen';

  @override
  String get playerReadingArticleBadge => 'Artikel lezen • 5 min';

  @override
  String get playerReadFullTextBelow => 'Lees de volledige tekst hieronder ↓';

  @override
  String get playerTabReviews => 'Beoordelingen';

  @override
  String get playerNoSectionsAvailable => 'Geen secties beschikbaar';

  @override
  String playerLessonsCount(String count) {
    return '$count lessen';
  }

  @override
  String get playerPlayingBadge => 'Wordt afgespeeld';

  @override
  String get playerArticleBadge => 'Artikel';

  @override
  String get playerVideoBadge => 'Video';

  @override
  String get playerFullArticleContent => 'Volledige inhoud van het artikel';

  @override
  String get playerArticlePlaceholder =>
      'Welkom bij deze leesles.\n\nDit onderdeel behandelt de kernconcepten en praktische stappen die je nodig hebt om de vaardigheden in deze les onder de knie te krijgen.';

  @override
  String get playerAboutCourseTitle => 'Over deze cursus';

  @override
  String get playerShowLess => 'Minder weergeven';

  @override
  String get playerReadMore => 'Lees meer';

  @override
  String get playerWhatYouWillLearn => 'Wat je leert';

  @override
  String get playerCourseInfoTitle => 'Cursusdetails';

  @override
  String get playerTotalDurationTitle => 'Totale duur';

  @override
  String get playerTotalLessonsTitle => 'Totaal aantal lessen';

  @override
  String playerLessonsNumber(String count) {
    return '$count lessen';
  }

  @override
  String get playerLevelTitle => 'Niveau';

  @override
  String get playerAllLevels => 'Alle niveaus';

  @override
  String get playerLanguageTitle => 'Taal';

  @override
  String get playerLanguageArabic => 'Arabisch';

  @override
  String get playerPrerequisitesTitle => 'Cursusvereisten';

  @override
  String get playerCertificateCardTitle => 'Cursuscertificaat';

  @override
  String get playerCourseCompletedSuccess => 'Gefeliciteerd! Cursus voltooid';

  @override
  String get playerProgressLabel => 'Voortgang';

  @override
  String get playerViewCertificateBtn => 'Certificaat bekijken';

  @override
  String get playerCertifiedInstructor => 'Gecertificeerde instructeur';

  @override
  String playerDiscussionsCount(String count) {
    return '$count vragen en discussies';
  }

  @override
  String get playerAskQuestionHint => 'Typ hier je vraag of opmerking...';

  @override
  String get playerPostBtn => 'Plaatsen';

  @override
  String get playerNoDiscussionsTitle => 'Nog geen discussies';

  @override
  String get playerNoDiscussionsSubtitle =>
      'Wees de eerste die een vraag stelt!';

  @override
  String get playerInstructorBadge => 'Instructeur';

  @override
  String get playerCancelReply => 'Annuleren';

  @override
  String get playerReplyAction => 'Beantwoorden';

  @override
  String playerRepliesCount(String count) {
    return '$count reacties';
  }

  @override
  String get playerWriteReplyHint => 'Schrijf je reactie...';

  @override
  String get playerSendReplyBtn => 'Beantwoorden';

  @override
  String get playerCourseFeedbackTitle => 'Cursusbeoordeling en feedback';

  @override
  String get playerOutOf5 => 'van de 5';

  @override
  String playerRatingsFromEnrolledCount(String count) {
    return '$count beoordelingen van ingeschreven studenten';
  }

  @override
  String get playerKeepLearningToRate => 'Blijf leren om te beoordelen';

  @override
  String get playerRateAfter80Hint =>
      'Je kunt deze cursus beoordelen na het voltooien van 80% van de inhoud';

  @override
  String get playerCurrentProgressLabel => 'Je voortgang:';

  @override
  String get playerYourCurrentRating => 'Jouw beoordeling';

  @override
  String get playerEditRating => 'Beoordeling bewerken';

  @override
  String get playerDeleteRatingTooltip => 'Beoordeling verwijderen';

  @override
  String get playerUpdateRatingTitle => 'Beoordeling bijwerken';

  @override
  String get playerRateCourseTitle => 'Beoordeel deze cursus';

  @override
  String get playerWriteReviewHint =>
      'Schrijf je feedback en mening over de kwaliteit van de inhoud (optioneel)...';

  @override
  String get playerRatingSubmitSuccess => 'Beoordeling succesvol verzonden!';

  @override
  String get playerRatingSubmitFailed => 'Kan beoordeling niet verzenden';

  @override
  String get playerSaveChangesBtn => 'Wijzigingen opslaan';

  @override
  String get playerSubmitReviewBtn => 'Beoordeling indienen';

  @override
  String get playerLearnerReviewsTitle => 'Beoordelingen van studenten';

  @override
  String playerReviewsCount(String count) {
    return '$count beoordelingen';
  }

  @override
  String get playerNoWrittenReviewsTitle => 'Nog geen geschreven beoordelingen';

  @override
  String get playerNoWrittenReviewsSubtitle => 'Deel als eerste je ervaring!';

  @override
  String get playerRatingLabel5 => 'Uitstekend 🌟 (5/5)';

  @override
  String get playerRatingLabel4 => 'Zeer goed 👍 (4/5)';

  @override
  String get playerRatingLabel3 => 'Gemiddeld 👌 (3/5)';

  @override
  String get playerRatingLabel2 => 'Kan beter 🤔 (2/5)';

  @override
  String get playerRatingLabel1 => 'Slecht 👎 (1/5)';

  @override
  String get playerDeleteRatingDialogTitle => 'Beoordeling verwijderen';

  @override
  String get playerDeleteRatingDialogMessage =>
      'Weet je zeker dat je je beoordeling voor deze cursus wilt verwijderen?';

  @override
  String get playerDeleteConfirmBtn => 'Verwijderen';

  @override
  String get playerRatingDeleteSuccess => 'Beoordeling succesvol verwijderd';

  @override
  String get playerPreviousLesson => 'Vorige les';

  @override
  String get playerExitFullscreenTooltip => 'Volledig scherm afsluiten';

  @override
  String instructorsAvailableCount(String count) {
    return '$count instructeurs beschikbaar';
  }

  @override
  String get instructorsNotFound => 'Geen instructeurs gevonden';

  @override
  String instructorsCoursesCount(String count) {
    return '$count cursussen';
  }

  @override
  String get instructorsSearchHint =>
      'Zoek op instructeursnaam of specialiteit...';

  @override
  String get instructorsSortAll => 'Alle';

  @override
  String get instructorsSortTopRated => 'Hoogst gewaardeerd';

  @override
  String get instructorsSortMostStudents => 'De meeste studenten';

  @override
  String get instructorsSortMostCourses => 'De meeste cursussen';

  @override
  String get instructorsNotFoundSubtitle =>
      'Probeer te zoeken met een andere naam of wis de filters';

  @override
  String get exploreCompleteCourse => 'Uitgebreide cursus';

  @override
  String get exploreGeneralCategory => 'Algemeen';

  @override
  String courseShareMessage(String title, String url) {
    return 'Bekijk de cursus \"$title\" op EduLab: $url';
  }

  @override
  String get courseDetailsDefaultTitle => 'Cursusdetails';

  @override
  String get courseDetailsTooltipShare => 'Deel';

  @override
  String get courseDetailsTooltipWishlist => 'Verlanglijst';

  @override
  String get courseDetailsTooltipCart => 'Winkelwagen';

  @override
  String get courseDetailsNotFound => 'Cursus niet gevonden';

  @override
  String get courseDetailsDefaultCategory => 'Cursus';

  @override
  String courseDetailsTotalRatingsCount(String count) {
    return '($count beoordelingen)';
  }

  @override
  String courseDetailsLecturesCount(String count) {
    return '$count lezingen';
  }

  @override
  String get courseDetailsCertificateBadge => 'Certificaat';

  @override
  String get courseDetailsTabOverview => 'Overzicht';

  @override
  String get courseDetailsTabCurriculum => 'Leerplan';

  @override
  String get courseDetailsTabInstructor => 'Instructeur';

  @override
  String get courseDetailsTabReviews => 'Recensies';

  @override
  String get courseDetailsFullDescriptionTitle => 'Beschrijving';

  @override
  String get courseDetailsShowLess => 'Laat minder zien';

  @override
  String get courseDetailsShowMore => 'Toon meer...';

  @override
  String courseDetailsCurriculumSectionsLectures(
    String sections,
    String lectures,
  ) {
    return '$sections secties • $lectures lezingen';
  }

  @override
  String get courseDetailsCollapseAll => 'Alles samenvouwen';

  @override
  String get courseDetailsExpandAll => 'Alles uitvouwen';

  @override
  String get courseDetailsCurriculumComingSoon =>
      'Curriculumdetails volgen binnenkort';

  @override
  String courseDetailsSectionLecturesCount(String count) {
    return '$count lezingen';
  }

  @override
  String get courseDetailsLecturePreviewBtn => 'Voorbeeld';

  @override
  String get courseDetailsDefaultInstructorTitle =>
      'Senior instructeur en gecertificeerd expert';

  @override
  String get courseDetailsInstructorRatingLabel => 'Beoordeling';

  @override
  String get courseDetailsInstructorStudentsLabel => 'Studenten';

  @override
  String get courseDetailsInstructorSectionsLabel => 'Secties';

  @override
  String get courseDetailsAboutInstructorTitle => 'Over instructeur:';

  @override
  String get courseDetailsDefaultInstructorAbout =>
      'Gecertificeerde instructeur met uitgebreide ervaring in het geven van professioneel onderwijs aan duizenden studenten over de hele wereld.';

  @override
  String courseDetailsStudentRatingsCount(String count) {
    return '$count studentenbeoordelingen';
  }

  @override
  String get courseDetailsNoWrittenReviews =>
      'Nog geen schriftelijke beoordelingen';

  @override
  String get courseDetailsRelatedCourses =>
      'Gerelateerde cursussen die u misschien leuk vindt';

  @override
  String courseDetailsDiscountPercent(String percent) {
    return '$percent% KORTING';
  }

  @override
  String get courseDetailsResumeCourse => 'Cursus hervatten';

  @override
  String get courseDetailsTryAgain => 'Probeer het opnieuw';

  @override
  String get courseDetailsEstimatedReading =>
      '📖 Geschatte leestijd: 4 minuten';

  @override
  String get courseDetailsSampleArticleContent =>
      'Welkom bij deze artikellezing.\n\nIn dit gedeelte worden de belangrijkste theoretische concepten en praktische stappen behandeld om het onderwerp onder de knie te krijgen.\n\n• Belangrijkste punten:\n1. Begrijp de kernterminologie en architecturale patronen.\n2. Praktische oefeningen en voortdurende oefening.\n3. Referentie aanvullende aantekeningen en opdrachten.\n\nVeel leesplezier!';

  @override
  String certDownloadedSuccess(String course, String format) {
    return 'Certificaat voor \"$course\" gedownload in $format formaat succesvol!';
  }

  @override
  String certVerifiedFullRequirements(String code) {
    return 'Verificatie-ID: $code • 100% vereisten voltooid';
  }

  @override
  String get certCompletionTitle => 'Certificaat van voltooiing';

  @override
  String get certCompletionSubtitle =>
      'Certificaat van voltooiing van de cursus';

  @override
  String get certAnnounceStudent =>
      'EducationLab Learning Academy verklaart hierbij dat:';

  @override
  String get certCompletionRequirementsMet =>
      'Heeft met succes alle eisen van de opleiding afgerond:';

  @override
  String certIssueDateText(String date) {
    return 'Uitgiftedatum: $date';
  }

  @override
  String certIdNumberText(String code) {
    return 'Certificaat-ID: $code';
  }

  @override
  String get certPlatformManagement => 'Platformbeheer';

  @override
  String get certInstructorRoleTitle => 'Cursus Instructeur';

  @override
  String get commonLoading => 'Laden...';

  @override
  String get homeGuestTagline => 'Slim leer- en vaardighedenopbouwplatform';

  @override
  String get catTagHighestDemand => 'Grootste vraag';

  @override
  String get catTagMostPopular => 'Meest populair';

  @override
  String get catTagTrending => 'Trending';

  @override
  String get catTagFastestGrowing => 'Snelst groeiend';

  @override
  String get catTagHighDemand => 'Veelgevraagd';

  @override
  String get catTagTopRated => 'Hoogst beoordeeld';

  @override
  String get catTagEssential => 'Essentieel';

  @override
  String get catTagAdvanced => 'Gevorderd niveau';

  @override
  String get catTagEntrepreneurs => 'Ondernemers';

  @override
  String get catTagSalesGrowth => 'Verkoopgroei';

  @override
  String get catDevTitle => 'Programmeren & Softwareontwikkeling';

  @override
  String get catDevSubtitle => 'Software-engineering, systemen & algoritmen';

  @override
  String get catWebTitle => 'Webontwikkeling';

  @override
  String get catWebSubtitle => 'Frontend, Backend & Fullstack Web';

  @override
  String get catMobileTitle => 'Mobiele app-ontwikkeling';

  @override
  String get catMobileSubtitle => 'Flutter, iOS & Android mobiele apps';

  @override
  String get catAiTitle => 'Kunstmatige Intelligentie';

  @override
  String get catAiSubtitle => 'Machine learning, deep learning & AI';

  @override
  String get catDataTitle => 'Datawetenschap & Analyse';

  @override
  String get catDataSubtitle => 'Data-analyse, statistiek & Big Data';

  @override
  String get catDesignTitle => 'UI/UX & Productontwerp';

  @override
  String get catDesignSubtitle => 'UI/UX, prototyping & productdesign';

  @override
  String get catSecurityTitle => 'Cyberveiligheid & Netwerken';

  @override
  String get catSecuritySubtitle => 'Cybersecurity, ethisch hacken & netwerken';

  @override
  String get catCloudTitle => 'Cloud Computing & DevOps';

  @override
  String get catCloudSubtitle => 'Cloudinfrastructuur, DevOps & CI/CD';

  @override
  String get catBusinessTitle => 'Bedrijfsvoering & Projectmanagement';

  @override
  String get catBusinessSubtitle => 'Ondernemerschap, Agile & leiderschap';

  @override
  String get catMarketingTitle => 'Digitale Marketing';

  @override
  String get catMarketingSubtitle =>
      'Digitale marketing, SEO & groeistrategieën';

  @override
  String get timeJustNow => 'Zojuist';

  @override
  String timeMinutesAgo(String count) {
    return '$count min geleden';
  }

  @override
  String timeHoursAgo(String count) {
    return '$count uur geleden';
  }

  @override
  String timeDaysAgo(String count) {
    return '$count dagen geleden';
  }

  @override
  String timeWeeksAgo(String count) {
    return '$count weken geleden';
  }

  @override
  String timeMonthsAgo(String count) {
    return '$count maanden geleden';
  }

  @override
  String wishlistLecturesCount(String count) {
    return '$count lessen';
  }

  @override
  String get instructorProfileTitle => 'Instructeursprofiel';

  @override
  String instructorProfileLinkCopied(String name) {
    return 'Link voor $name gekopieerd naar klembord';
  }

  @override
  String get instructorDefaultName => 'Instructeur';

  @override
  String get instructorProfileBadge => 'INSTRUCTEUR';

  @override
  String get instructorProfileTotalStudents => 'Totaal aantal studenten';

  @override
  String get instructorProfileRating => 'Instructeursbeoordeling';

  @override
  String get instructorProfileCourses => 'Cursussen';

  @override
  String get instructorProfileShare => 'Profiel delen';

  @override
  String get instructorProfileLinkOpenError =>
      'Kon link niet openen, gekopieerd naar klembord';

  @override
  String get instructorProfileWebsite => 'Website';

  @override
  String get instructorProfileAboutMe => 'Over mij';

  @override
  String get instructorProfileShowLess => 'Minder weergeven';

  @override
  String get instructorProfileShowMore => 'Meer weergeven';

  @override
  String get instructorProfileExpertise => 'Expertisegebieden';

  @override
  String get instructorProfileSortAll => 'Alle';

  @override
  String get instructorProfileSortTopRated => 'Hoogst gewaardeerd';

  @override
  String get instructorProfileSortPopular => 'Populair';

  @override
  String get instructorProfileSortNewest => 'Nieuwste';

  @override
  String get instructorProfileCoursesTitle => 'Cursussen van de instructeur';

  @override
  String get instructorProfileNoCoursesFilter =>
      'Geen cursussen gevonden voor dit filter';

  @override
  String instructorProfileLoadMoreCourses(String count) {
    return 'Meer cursussen laden (nog $count)';
  }

  @override
  String get instructorProfileLoadingMoreCourses => 'Meer cursussen laden...';

  @override
  String instructorProfileAllCoursesLoaded(String count) {
    return 'Alle $count cursussen geladen';
  }

  @override
  String get instructorProfileStudentFeedback => 'Feedback van studenten';

  @override
  String instructorProfileReviewsCount(String count) {
    return '$count beoordelingen';
  }

  @override
  String instructorProfileBasedOnReviews(String count) {
    return 'Gebaseerd op $count beoordelingen';
  }

  @override
  String get instructorProfileRecentReviews => 'Recente beoordelingen';

  @override
  String instructorProfileLoadMoreReviews(String count) {
    return 'Meer beoordelingen laden (nog $count)';
  }

  @override
  String get instructorProfileLoadingMoreReviews =>
      'Meer beoordelingen laden...';

  @override
  String instructorProfileAllReviewsLoaded(String count) {
    return 'Alle $count beoordelingen geladen';
  }

  @override
  String get instructorProfileNoReviewsYet =>
      'Nog geen schriftelijke beoordelingen';

  @override
  String get instructorProfileRatingDesc =>
      'De beoordeling is gebaseerd op de algemene studentenbeoordelingen van alle cursussen van de instructeur';

  @override
  String get instructorProfileLoadError =>
      'Kan gegevens van instructeur niet laden, probeer het later opnieuw';

  @override
  String get instructorProfileDefaultStudentName => 'Student';

  @override
  String get instructorProfileDefaultHeadline =>
      'Senior instructeur en gecertificeerd expert';

  @override
  String get instructorProfileDefaultBio =>
      'Gecertificeerd software engineer en technisch instructeur met ruime ervaring in het bouwen van schaalbare softwaresystemen en mobiele applicaties.\nHeeft duizenden studenten en technici wereldwijd opgeleid en biedt professionele content gericht op schone code, schone architectuur en moderne, schaalbare oplossingen.';

  @override
  String get supportNewChat => 'Nieuwe chat';

  @override
  String get supportNoChatsTitle => 'Nog geen supportchats';

  @override
  String get supportNoChatsDesc =>
      'Ons ondersteuningsteam staat 24/7 klaar om u te helpen en al uw vragen te beantwoorden';

  @override
  String get supportStartNewConversation => 'Nieuw gesprek starten';

  @override
  String get supportNoMessagesYet => 'Nog geen berichten';

  @override
  String get supportRetry => 'Opnieuw proberen';

  @override
  String get supportOpenTicket => 'Open ticket';

  @override
  String get supportClosedTicket => 'Gesloten ticket';

  @override
  String get supportCloseAction => 'Sluiten';

  @override
  String get supportReopenAction => 'Heropenen';

  @override
  String get supportNoMessagesInChat => 'Nog geen berichten in deze chat';

  @override
  String get supportYou => 'U';

  @override
  String get supportTeam => 'Ondersteuningsteam';

  @override
  String get supportTypeMessageHint => 'Typ hier uw bericht...';

  @override
  String get supportConversationClosedNotice =>
      'Dit gesprek is momenteel gesloten.';

  @override
  String get supportCloseDialogTitle => 'Gesprek sluiten?';

  @override
  String get supportCloseDialogDesc =>
      'Weet u zeker dat u deze chat wilt sluiten? U kunt deze op elk moment heropenen om verder te praten.';

  @override
  String get supportCancel => 'Annuleren';

  @override
  String get supportYesClose => 'Ja, sluiten';

  @override
  String get supportNewChatTitle => 'Nieuwe supportchat';

  @override
  String get supportNewChatSubtitle => 'Ons team staat klaar om u te helpen';

  @override
  String get supportSubjectLabel => 'Onderwerp';

  @override
  String get supportSubjectHint =>
      'bijv. Vraag over cursus, Betalingsprobleem...';

  @override
  String get supportMessageLabel => 'Bericht';

  @override
  String get supportMessageHint =>
      'Beschrijf uw vraag of probleem in detail...';

  @override
  String get supportMessageRequired => 'Voer een bericht in';

  @override
  String get supportStartConversationBtn => 'Gesprek starten';

  @override
  String get supportCreateError =>
      'Kan gesprek niet aanmaken, probeer het later opnieuw';

  @override
  String get supportTopicCourse => 'Cursusinformatie';

  @override
  String get supportTopicPayment => 'Betalingsprobleem';

  @override
  String get supportTopicCertificates => 'Certificaten';

  @override
  String get supportTopicTech => 'Technisch probleem';

  @override
  String get supportTopicGeneral => 'Algemene vraag';
}

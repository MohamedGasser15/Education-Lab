// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get onboardingSkip => 'Überspringen';

  @override
  String get onboardingTitle1 => 'Willkommen bei EduLab';

  @override
  String get onboardingSubtitle1 =>
      'Ihre ideale Plattform für modernes interaktives Lernen und kontinuierliches berufliches Wachstum.';

  @override
  String get onboardingTitle2 => 'Lernen Sie von Top-Dozenten';

  @override
  String get onboardingSubtitle2 =>
      'Tausende professionelle Kurse in Programmierung, Design, Wirtschaft und Data Science.';

  @override
  String get onboardingTitle3 => 'Zertifikate & garantierter Erfolg';

  @override
  String get onboardingSubtitle3 =>
      'Verfolgen Sie Ihren Fortschritt, bestehen Sie Tests und erhalten Sie anerkannte Zertifikate.';

  @override
  String get onboardingNext => 'Weiter';

  @override
  String get onboardingStart => 'Jetzt starten';

  @override
  String get splashAppName => 'Education Lab';

  @override
  String get splashTagline => 'Smarte Lernplattform';

  @override
  String get loginTagline => 'Willkommen auf der smarten Lernplattform';

  @override
  String get loginAppName => 'EduLab';

  @override
  String get loginTabLogin => 'Anmelden';

  @override
  String get loginTabRegister => 'Registrieren';

  @override
  String get loginEmailLabel => 'E-Mail-Adresse';

  @override
  String get loginEmailHint => 'beispiel@email.de';

  @override
  String get loginPasswordLabel => 'Passwort';

  @override
  String get loginPasswordHint => '••••••';

  @override
  String get loginForgotPassword => 'Passwort vergessen?';

  @override
  String get loginSubmit => 'Anmelden';

  @override
  String get loginSubmitLoading => 'Anmeldung läuft';

  @override
  String get loginGuest => 'Als Gast fortfahren';

  @override
  String get loginOr => 'oder';

  @override
  String get loginEmailRequired => 'E-Mail ist erforderlich';

  @override
  String get loginEmailInvalid => 'Bitte gültige E-Mail eingeben';

  @override
  String get loginPasswordRequired => 'Passwort ist erforderlich';

  @override
  String get registerStepEmail => 'E-Mail';

  @override
  String get registerStepCode => 'Code';

  @override
  String get registerStepData => 'Daten';

  @override
  String get registerSendCodeInfo =>
      'Wir senden Ihnen einen Aktivierungscode per E-Mail';

  @override
  String get registerSendCode => 'Aktivierungscode senden';

  @override
  String get registerVerifying => 'Wird überprüft';

  @override
  String get registerCodeSentTo => 'Code gesendet an:';

  @override
  String get registerResendCode => 'Code erneut senden';

  @override
  String get registerBack => 'Zurück';

  @override
  String get registerVerifyCode => 'Code bestätigen';

  @override
  String get registerCodeIncomplete =>
      'Bitte vollständigen 6-stelligen Code eingeben';

  @override
  String get registerFullNameLabel => 'Vollständiger Name';

  @override
  String get registerFullNameHint => 'Ihr vollständiger Name';

  @override
  String get registerPasswordHint =>
      'Mindestens 8 Zeichen, ein Großbuchstabe und eine Zahl';

  @override
  String get registerConfirmLabel => 'Passwort bestätigen';

  @override
  String get registerConfirmHint => 'Passwort wiederholen';

  @override
  String get registerSubmit => 'Konto erstellen';

  @override
  String get registerSubmitLoading => 'Konto wird erstellt';

  @override
  String get registerSuccess => 'Konto erfolgreich erstellt';

  @override
  String get registerNameRequired => 'Vollständiger Name ist erforderlich';

  @override
  String get registerNameMinLength =>
      'Name muss mindestens 6 Zeichen lang sein';

  @override
  String get registerPasswordMinLength =>
      'Passwort muss mindestens 8 Zeichen lang sein';

  @override
  String get registerPasswordUppercase =>
      'Passwort muss mindestens einen Großbuchstaben enthalten';

  @override
  String get registerPasswordNumber =>
      'Passwort muss mindestens eine Zahl enthalten';

  @override
  String get registerConfirmRequired => 'Passwortbestätigung ist erforderlich';

  @override
  String get registerConfirmMismatch => 'Passwörter stimmen nicht überein';

  @override
  String get networkError => 'Verbindungsfehler, bitte erneut versuchen';

  @override
  String homeGreeting(String name) {
    return 'Hallo, $name!';
  }

  @override
  String get homeSubtitle => 'Was möchten Sie heute lernen?';

  @override
  String get homeSearchHint => 'Kurs oder Fähigkeit suchen...';

  @override
  String get homeSectionContinue => 'Weiterlernen';

  @override
  String get homeSectionRecommended => 'Für Sie empfohlen';

  @override
  String get homeSectionPopular => 'Beliebteste Kurse';

  @override
  String get homeSectionTopRated => 'Bestbewertet';

  @override
  String get homeSectionByCategory => 'Nach Kategorie';

  @override
  String get homeHeroTitle => 'Jetzt Angebote entdecken';

  @override
  String get homeHeroSubtitle => 'Bis zu 70% Rabatt auf Premium-Kurse';

  @override
  String get homeHeroButton => 'Jetzt entdecken';

  @override
  String get homeViewAll => 'Alle anzeigen';

  @override
  String get homeProgressLabel => 'Abgeschlossen';

  @override
  String get exploreTitle => 'Kurse entdecken';

  @override
  String get exploreSearchHint => 'Nach Kurs, Thema oder Dozent suchen...';

  @override
  String get exploreAllCategories => 'Alle Kategorien';

  @override
  String get exploreFilter => 'Filtern';

  @override
  String get exploreSort => 'Sortieren';

  @override
  String get exploreNoResults => 'Keine Ergebnisse gefunden';

  @override
  String get exploreNoResultsHint =>
      'Versuchen Sie andere Suchbegriffe oder Filter';

  @override
  String exploreCoursesCount(int count) {
    return '$count Kurse';
  }

  @override
  String get exploreFilterTitle => 'Ergebnisse filtern';

  @override
  String get exploreFilterApply => 'Filter anwenden';

  @override
  String get exploreFilterReset => 'Zurücksetzen';

  @override
  String get exploreFilterPrice => 'Preis';

  @override
  String get exploreFilterLevel => 'Niveau';

  @override
  String get exploreFilterRating => 'Bewertung';

  @override
  String get exploreFilterDuration => 'Dauer';

  @override
  String get exploreSortTitle => 'Sortieren nach';

  @override
  String get exploreSortRelevance => 'Relevanz';

  @override
  String get exploreSortNewest => 'Neueste';

  @override
  String get exploreSortPopular => 'Beliebteste';

  @override
  String get exploreSortRating => 'Beste Bewertung';

  @override
  String get exploreSortPriceLow => 'Preis: aufsteigend';

  @override
  String get exploreSortPriceHigh => 'Preis: absteigend';

  @override
  String get explorePriceFree => 'Kostenlos';

  @override
  String get exploreLevelBeginner => 'Anfänger';

  @override
  String get exploreLevelIntermediate => 'Fortgeschritten';

  @override
  String get exploreLevelAdvanced => 'Experte';

  @override
  String get learningTitle => 'Mein Lernen';

  @override
  String get learningTabInProgress => 'In Bearbeitung';

  @override
  String get learningTabCompleted => 'Abgeschlossen';

  @override
  String get learningTabSaved => 'Gespeichert';

  @override
  String get learningEmpty => 'Noch keine Kurse vorhanden';

  @override
  String get learningEmptyHint => 'Entdecken Sie jetzt neue Kurse';

  @override
  String get learningExploreButton => 'Kurse entdecken';

  @override
  String learningProgress(int percent) {
    return '$percent% abgeschlossen';
  }

  @override
  String get learningContinue => 'Fortsetzen';

  @override
  String get learningViewCertificate => 'Zertifikat anzeigen';

  @override
  String get learningReview => 'Kurs bewerten';

  @override
  String get learningLesson => 'Lektion';

  @override
  String get learningLessons => 'Lektionen';

  @override
  String get cartTitle => 'Warenkorb';

  @override
  String get cartEmpty => 'Ihr Warenkorb ist leer';

  @override
  String get cartEmptyHint => 'Fügen Sie Kurse hinzu, um zu starten';

  @override
  String get cartExploreButton => 'Kurse entdecken';

  @override
  String get cartPromoPlaceholder => 'Gutscheincode eingeben';

  @override
  String get cartPromoApply => 'Anwenden';

  @override
  String get cartPromoInvalid => 'Ungültiger Gutscheincode';

  @override
  String get cartSummary => 'Bestellübersicht';

  @override
  String get cartSubtotal => 'Zwischensumme';

  @override
  String get cartDiscount => 'Rabatt';

  @override
  String get cartTotal => 'Gesamtsumme';

  @override
  String get cartCheckout => 'Zur Kasse';

  @override
  String cartCourses(int count) {
    return '$count Kurse';
  }

  @override
  String get cartRemove => 'Entfernen';

  @override
  String get cartGuarantee => '30 Tage Geld-zurück-Garantie';

  @override
  String get checkoutTitle => 'Kasse & Zahlung';

  @override
  String get checkoutStepPayment => 'Zahlung';

  @override
  String get checkoutStepReview => 'Überprüfung';

  @override
  String get checkoutStepConfirm => 'Bestätigung';

  @override
  String get checkoutOrderSummary => 'Bestellübersicht';

  @override
  String get checkoutTotal => 'Gesamt';

  @override
  String get checkoutPayNow => 'Jetzt bezahlen';

  @override
  String get checkoutBack => 'Zurück';

  @override
  String get checkoutNext => 'Weiter';

  @override
  String get checkoutSecureSSL =>
      'Sichere Zahlung mit 256-Bit SSL-Verschlüsselung';

  @override
  String get checkoutSuccessTitle => 'Kauf erfolgreich!';

  @override
  String get checkoutSuccessSubtitle =>
      'Sie haben jetzt Zugriff auf Ihren Kurs';

  @override
  String get checkoutGoToLearning => 'Zu meinen Kursen';

  @override
  String get checkoutPaymentMethod => 'Zahlungsart';

  @override
  String get checkoutCardNumber => 'Kartennummer';

  @override
  String get checkoutCardName => 'Name des Karteninhabers';

  @override
  String get checkoutCardExpiry => 'Ablaufdatum';

  @override
  String get checkoutCardCVV => 'CVV';

  @override
  String get courseDetailsEnroll => 'Jetzt einschreiben';

  @override
  String get courseDetailsBuyNow => 'Jetzt kaufen';

  @override
  String get courseDetailsAddToCart => 'In den Warenkorb';

  @override
  String get courseDetailsAddedToCart => 'Zum Warenkorb hinzugefügt';

  @override
  String get courseDetailsAlreadyEnrolled => 'Bereits eingeschrieben';

  @override
  String get courseDetailsGoToCourse => 'Zum Kurs';

  @override
  String get courseDetailsFree => 'Kostenlos';

  @override
  String courseDetailsStudents(String count) {
    return '$count Teilnehmer';
  }

  @override
  String get courseDetailsRating => 'Bewertung';

  @override
  String get courseDetailsReviews => 'Bewertungen';

  @override
  String get courseDetailsLastUpdated => 'Zuletzt aktualisiert';

  @override
  String get courseDetailsCurriculum => 'Kursinhalt';

  @override
  String get courseDetailsSection => 'Abschnitt';

  @override
  String get courseDetailsLessons => 'Lektionen';

  @override
  String get courseDetailsInstructor => 'Dozent';

  @override
  String get courseDetailsStudentsLabel => 'Teilnehmer';

  @override
  String get courseDetailsCoursesLabel => 'Kurse';

  @override
  String get courseDetailsReviewsLabel => 'Bewertungen';

  @override
  String get courseDetailsReviewsTitle => 'Teilnehmerbewertungen';

  @override
  String get courseDetailsWhatLearn => 'Was Sie lernen werden';

  @override
  String get courseDetailsRequirements => 'Anforderungen';

  @override
  String get courseDetailsDescription => 'Kursbeschreibung';

  @override
  String get courseDetailsIncludesTitle => 'Dieser Kurs beinhaltet';

  @override
  String get courseDetailsHoursVideo => 'Stunden On-Demand-Video';

  @override
  String get courseDetailsArticles => 'Artikel';

  @override
  String get courseDetailsMobileAccess => 'Zugriff über Smartphone & Tablet';

  @override
  String get courseDetailsCertificate => 'Abschlusszertifikat';

  @override
  String get courseDetailsLifetimeAccess => 'Lebenslanger Zugriff';

  @override
  String get lessonPlayerNotes => 'Meine Notizen';

  @override
  String get lessonPlayerResources => 'Ressourcen';

  @override
  String get lessonPlayerDiscussion => 'Diskussion';

  @override
  String get lessonPlayerPrev => 'Vorherige';

  @override
  String get lessonPlayerNext => 'Nächste';

  @override
  String get lessonPlayerSpeed => 'Geschwindigkeit';

  @override
  String get lessonPlayerQuality => 'Qualität';

  @override
  String get lessonPlayerCompleted => 'Lektion abgeschlossen';

  @override
  String get certificateTitle => 'Abschlusszertifikat';

  @override
  String get certificatePresentedTo => 'Verliehen an';

  @override
  String get certificateCompletedCourse =>
      'für den erfolgreichen Abschluss von';

  @override
  String get certificateIssuedOn => 'Ausstellungsdatum';

  @override
  String get certificateVerificationId => 'Zertifikats-ID';

  @override
  String get certificateDownloadPDF => 'PDF herunterladen';

  @override
  String get certificateDownloadPNG => 'Bild herunterladen';

  @override
  String get certificateCopyLink => 'Link kopieren';

  @override
  String get certificateLinkCopied => 'Link kopiert';

  @override
  String get profileTitle => 'Profil';

  @override
  String get profileEditProfile => 'Profil bearbeiten';

  @override
  String get profileCourses => 'Meine Kurse';

  @override
  String get profileCertificates => 'Zertifikate';

  @override
  String get profilePoints => 'Punkte';

  @override
  String get profileFollowers => 'Follower';

  @override
  String get profileFollowing => 'Gefolgt';

  @override
  String get profileBio => 'Biografie';

  @override
  String get profileInstructor => 'Dozent';

  @override
  String get profileStudent => 'Student';

  @override
  String get profileLevel => 'Niveau';

  @override
  String get profileJoined => 'Mitglied seit';

  @override
  String get profileShareProfile => 'Profil teilen';

  @override
  String get profileMenuLearning => 'Meine Kurse';

  @override
  String get profileMenuCertificates => 'Meine Zertifikate';

  @override
  String get profileMenuPurchaseHistory => 'Bestellhistorie';

  @override
  String get profileMenuTeachApplication => 'Auf EduLab unterrichten';

  @override
  String get profileMenuAccountSecurity => 'Kontosicherheit';

  @override
  String get profileMenuNotifications => 'Benachrichtigungen';

  @override
  String get profileMenuMessages => 'Nachrichten';

  @override
  String get profileMenuSettings => 'Einstellungen';

  @override
  String get profileMenuSchedule => 'Mein Zeitplan';

  @override
  String get profileMenuAssignments => 'Aufgaben';

  @override
  String get profileMenuQuiz => 'Quizze';

  @override
  String get profileMenuLogout => 'Abmelden';

  @override
  String get profileLogoutConfirm => 'Möchten Sie sich wirklich abmelden?';

  @override
  String get profileLogoutYes => 'Ja, abmelden';

  @override
  String get profileLogoutNo => 'Abbrechen';

  @override
  String get editProfileTitle => 'Profil bearbeiten';

  @override
  String get editProfileSave => 'Änderungen speichern';

  @override
  String get editProfileFullName => 'Vollständiger Name';

  @override
  String get editProfileBio => 'Biografie';

  @override
  String get editProfileEmail => 'E-Mail-Adresse';

  @override
  String get editProfilePhone => 'Telefonnummer';

  @override
  String get editProfileWebsite => 'Webseite';

  @override
  String get editProfileSaved => 'Änderungen erfolgreich gespeichert';

  @override
  String get accountSecurityTitle => 'Kontosicherheit';

  @override
  String get accountSecurityChangePassword => 'Passwort ändern';

  @override
  String get accountSecurityTwoFactor => 'Zwei-Faktor-Authentifizierung';

  @override
  String get accountSecurityActiveSessions => 'Aktive Sitzungen';

  @override
  String get accountSecurityDeleteAccount => 'Konto löschen';

  @override
  String get purchaseHistoryTitle => 'Bestellhistorie';

  @override
  String get purchaseHistoryEmpty => 'Noch keine Einkäufe';

  @override
  String get purchaseHistoryGuarantee => '30 Tage Geld-zurück-Garantie';

  @override
  String get purchaseHistoryDate => 'Transaktionsdatum';

  @override
  String get purchaseHistoryStatus => 'Status';

  @override
  String get purchaseHistoryAmount => 'Betrag';

  @override
  String get purchaseHistoryCompleted => 'Abgeschlossen';

  @override
  String get purchaseHistoryRefunded => 'Erstattet';

  @override
  String get teachApplicationTitle => 'Auf EduLab unterrichten';

  @override
  String get teachApplicationSubmit => 'Bewerbung absenden';

  @override
  String get teachApplicationSent =>
      'Ihre Bewerbung wurde erfolgreich gesendet';

  @override
  String get notificationsTitle => 'Benachrichtigungen';

  @override
  String get notificationsMarkAllRead => 'Alle als gelesen markieren';

  @override
  String get notificationsMarkAllReadSnackbar =>
      'Alle Benachrichtigungen als gelesen markiert';

  @override
  String get notificationsEmpty => 'Keine Benachrichtigungen';

  @override
  String get notification1Title => 'Erinnerung: Kurs fortsetzen';

  @override
  String get notification1Message =>
      'Sie haben eine neue Lektion in Flutter für Anfänger';

  @override
  String get notification1Time => 'Vor 5 Minuten';

  @override
  String get notification1Action => 'Kurs fortsetzen';

  @override
  String get notification2Title => 'Ihr Zertifikat ist bereit!';

  @override
  String get notification2Message =>
      'Sie haben den UI/UX Design Kurs erfolgreich beendet.';

  @override
  String get notification2Time => 'Vor 2 Stunden';

  @override
  String get notification2Action => 'Zertifikat anzeigen';

  @override
  String get notification3Title => 'Exklusives Angebot';

  @override
  String get notification3Message => '70% Rabatt auf Programmierkurse';

  @override
  String get notification3Time => 'Vor 1 Tag';

  @override
  String get notification3Action => 'Angebot ansehen';

  @override
  String get notification4Title => 'Neue Antwort auf Ihre Frage';

  @override
  String get notification4Message =>
      'Der Dozent hat auf Ihre Frage geantwortet';

  @override
  String get notification4Time => 'Vor 2 Tagen';

  @override
  String get notification4Action => 'Antwort anzeigen';

  @override
  String get notification5Title => 'Kursaktualisierung';

  @override
  String get notification5Message =>
      'Neue Inhalte wurden zu Python hinzugefügt';

  @override
  String get notification5Time => 'Vor 3 Tagen';

  @override
  String get messagesTitle => 'Nachrichten';

  @override
  String get settingsTitle => 'Einstellungen & Optionen';

  @override
  String get settingsVideoDownload => 'Video & Download';

  @override
  String get settingsDownloadQuality => 'Standard-Videoqualität';

  @override
  String get settingsWifiOnly => 'Download nur über WLAN';

  @override
  String get settingsNotifications => 'Benachrichtigungen & Töne';

  @override
  String get settingsCourseNotifications => 'Kurs- und Nachrichten-Updates';

  @override
  String get settingsPromoNotifications => 'Exklusive Angebote & Rabatte';

  @override
  String get settingsAppearance => 'Erscheinungsbild & Sprache';

  @override
  String get settingsDarkMode => 'Dunkelmodus';

  @override
  String get settingsDarkModeEnabled => 'Aktiviert (schont Akku & Augen)';

  @override
  String get settingsDarkModeDisabled => 'Deaktiviert (Hellmodus)';

  @override
  String get settingsLanguage => 'App-Sprache';

  @override
  String get settingsStorage => 'Speicher & Cache';

  @override
  String get settingsClearCache => 'Cache leeren';

  @override
  String get settingsClearCacheSuccess => 'Cache erfolgreich geleert';

  @override
  String get settingsHelp => 'Info & Richtlinien';

  @override
  String get settingsHelpCenter => 'Hilfebereich & FAQ';

  @override
  String get settingsTermsPrivacy => 'Nutzungsbedingungen & Datenschutz';

  @override
  String get settingsAbout => 'Über EduLab';

  @override
  String get settingsVersion => 'Version v1.0.0';

  @override
  String get quizTitle => 'Quiz';

  @override
  String get quizNext => 'Nächste Frage';

  @override
  String get quizSubmit => 'Quiz abgeben';

  @override
  String get quizScore => 'Testergebnis';

  @override
  String get quizCorrectAnswers => 'Richtige Antworten';

  @override
  String get scheduleTitle => 'Mein Zeitplan';

  @override
  String get scheduleEmpty => 'Keine Termine geplant';

  @override
  String get scheduleJoin => 'Teilnehmen';

  @override
  String get scheduleReminder => 'Erinnerung';

  @override
  String get assignmentsTitle => 'Aufgaben';

  @override
  String get assignmentsEmpty => 'Keine Aufgaben vorhanden';

  @override
  String get assignmentsSubmit => 'Aufgabe einreichen';

  @override
  String get assignmentsDue => 'Fälligkeitsdatum';

  @override
  String get assignmentsSubmitted => 'Eingereicht';

  @override
  String get assignmentsPending => 'Ausstehend';

  @override
  String get languageArabic => 'Arabisch';

  @override
  String get languageEnglish => 'Englisch';

  @override
  String get languageDialogTitle => 'App-Sprache auswählen';

  @override
  String get languageSelect => 'Auswählen';

  @override
  String get generalCancel => 'Abbrechen';

  @override
  String get generalConfirm => 'Bestätigen';

  @override
  String get generalSave => 'Speichern';

  @override
  String get generalDelete => 'Löschen';

  @override
  String get generalEdit => 'Bearbeiten';

  @override
  String get generalClose => 'Schließen';

  @override
  String get generalBack => 'Zurück';

  @override
  String get generalDone => 'Fertig';

  @override
  String get generalOk => 'OK';

  @override
  String get generalYes => 'Ja';

  @override
  String get generalNo => 'Nein';

  @override
  String get generalLoading => 'Wird geladen...';

  @override
  String get generalError => 'Ein Fehler ist aufgetreten';

  @override
  String get generalRetry => 'Wiederholen';

  @override
  String get generalNoInternet => 'Keine Internetverbindung';

  @override
  String get generalFree => 'Kostenlos';

  @override
  String get generalRating => 'Bewertung';

  @override
  String get generalStudents => 'Teilnehmer';

  @override
  String get generalHours => 'Stunden';

  @override
  String get generalMinutes => 'Minuten';

  @override
  String get generalBy => 'Von';

  @override
  String get navHome => 'Startseite';

  @override
  String get navExplore => 'Entdecken';

  @override
  String get navMyCourses => 'Meine Kurse';

  @override
  String get navCart => 'Warenkorb';

  @override
  String get navAccount => 'Konto';

  @override
  String get homeSubGreeting => 'Was möchten Sie heute lernen?';

  @override
  String get homeVisitor => 'Gast';

  @override
  String get homePromoTitle => 'Jetzt Angebote entdecken';

  @override
  String get homePromoSubtitle => 'Bis zu 70% Rabatt auf Premium-Kurse';

  @override
  String get homePromoButton => 'Jetzt entdecken';

  @override
  String get homePromoBadge => 'Exklusives Angebot';

  @override
  String get homeContinueLearning => 'Weiterlernen';

  @override
  String get homeMyCoursesLink => 'Meine Kurse';

  @override
  String get homeLesson => 'Lektion';

  @override
  String homeStudentsCount(String count) {
    return '$count Teilnehmer';
  }

  @override
  String get homeRecommendedTitle => 'Für Sie empfohlen';

  @override
  String get homeRecommendedSubtitle => 'Personalisiert nach Ihren Interessen';

  @override
  String get homeBestsellersTitle => 'Bestseller';

  @override
  String get homeBestsellersSubtitle => 'Bestbewertete und beliebteste Kurse';

  @override
  String get homeNewCoursesTitle => 'Neue Kurse';

  @override
  String get homeNewCoursesSubtitle => 'Frische und aktuelle Inhalte';

  @override
  String get homePopularTopicsTitle => 'Beliebte Themen';

  @override
  String get homePopularTopicsSubtitle =>
      'Lernen Sie die gefragtesten Fähigkeiten';

  @override
  String get homeTopInstructorsTitle => 'Top-Dozenten';

  @override
  String get homeTopInstructorsSubtitle =>
      'Lernen Sie von zertifizierten Experten';

  @override
  String get homeExploreCategoriesTitle => 'Kategorien entdecken';

  @override
  String get homeExploreCategoriesSubtitle => 'Finden Sie den passenden Kurs';

  @override
  String get catAll => 'Alle';

  @override
  String get catWebDev => 'Webentwicklung';

  @override
  String get catMobileApps => 'Mobile Apps';

  @override
  String get catDataScience => 'Data Science';

  @override
  String get catUIUX => 'UI/UX Design';

  @override
  String get catBusiness => 'Wirtschaft & Management';

  @override
  String get catAI => 'Künstliche Intelligenz';

  @override
  String get catCyberSecurity => 'Cybersicherheit';

  @override
  String get exploreNoResultsTitle => 'Keine Ergebnisse gefunden';

  @override
  String get exploreNoResultsSubtitle =>
      'Versuchen Sie andere Suchbegriffe oder Filter';

  @override
  String get exploreRecentSearches => 'Letzte Suchanfragen';

  @override
  String get exploreTopSearches => 'Beliebte Suchanfragen';

  @override
  String get exploreBrowseCategories => 'Kategorien durchsuchen';

  @override
  String get exploreBrowseCategoriesSubtitle => 'Finden Sie den passenden Kurs';

  @override
  String get exploreBackToAll => 'Zurück zu Allen';

  @override
  String get exploreClearAll => 'Alles löschen';

  @override
  String get exploreAvailableResults => 'Ergebnisse verfügbar';

  @override
  String get exploreFilterBestseller => 'Bestseller';

  @override
  String get exploreFilterTopRated => 'Bestbewertet';

  @override
  String get exploreFilterUnder50 => 'Unter 50 €';

  @override
  String get learningHeroTitle => 'Setzen Sie Ihre Lernreise fort';

  @override
  String get learningSearchHint => 'In meinen Kursen suchen...';

  @override
  String get learningFilterAll => 'Alle';

  @override
  String get learningFilterInProgress => 'In Bearbeitung';

  @override
  String get learningFilterCompleted => 'Abgeschlossen';

  @override
  String get learningFilterDownloaded => 'Heruntergeladen';

  @override
  String get learningEmptyTitle => 'Noch keine Kurse vorhanden';

  @override
  String get learningEmptySubtitle => 'Entdecken Sie jetzt neue Kurse';

  @override
  String get learningEmptySearch => 'Keine Ergebnisse für Ihre Suche';

  @override
  String get learningCompleted => 'Abgeschlossen';

  @override
  String get learningCompletedBadge => 'Abgeschlossen';

  @override
  String learningLecturesCount(int count) {
    return '$count Lektionen';
  }

  @override
  String get cartEmptyTitle => 'Ihr Warenkorb ist leer';

  @override
  String get cartEmptySubtitle => 'Fügen Sie Kurse hinzu, um zu starten';

  @override
  String get cartCouponHint => 'Gutscheincode eingeben';

  @override
  String get cartCouponApply => 'Anwenden';

  @override
  String get cartCouponInvalid => 'Ungültiger Code';

  @override
  String get cartCouponApplied => 'Gutschein angewendet';

  @override
  String get cartCouponDiscount => 'Gutscheinrabatt';

  @override
  String get cartCouponsTitle => 'Gutscheine';

  @override
  String get cartOrderSummary => 'Bestellübersicht';

  @override
  String get cartOriginalPrice => 'Ursprünglicher Preis';

  @override
  String get cartPlatformDiscount => 'Plattformrabatt';

  @override
  String get cartFinalTotal => 'Gesamtsumme';

  @override
  String cartItemsCount(int count) {
    return '$count Kurse';
  }

  @override
  String get cartRemovedSnackbar => 'Kurs aus dem Warenkorb entfernt';

  @override
  String get cartUndo => 'Rückgängig';

  @override
  String get cartAddButton => 'In den Warenkorb';

  @override
  String get cartAddedSnackbar => 'Zum Warenkorb hinzugefügt';

  @override
  String get cartAlreadyInCart => 'Bereits im Warenkorb';

  @override
  String get cartCheckoutButton => 'Zur Kasse gehen';

  @override
  String get cartRecommendedTitle => 'Das könnte Ihnen auch gefallen';

  @override
  String get cartRecommendedSubtitle =>
      'Empfohlene Kurse basierend auf Ihrem Warenkorb';

  @override
  String get checkoutCreditCard => 'Kreditkarte';

  @override
  String get checkoutSelectPayment => 'Zahlungsart auswählen';

  @override
  String get checkoutCardNumberLabel => 'Kartennummer';

  @override
  String get checkoutCardHolderLabel => 'Karteninhaber';

  @override
  String get checkoutExpiryLabel => 'Gültig bis';

  @override
  String get checkoutCVVLabel => 'CVV';

  @override
  String get checkoutPersonalInfoTitle => 'Persönliche Daten';

  @override
  String get checkoutFullNameLabel => 'Vollständiger Name';

  @override
  String get checkoutFullNameHint => 'Ihr vollständiger Name';

  @override
  String get checkoutFullNameRequired => 'Name ist erforderlich';

  @override
  String get checkoutPhoneLabel => 'Telefonnummer';

  @override
  String get checkoutPhoneRequired => 'Telefonnummer ist erforderlich';

  @override
  String get checkoutPostalLabel => 'Postleitzahl';

  @override
  String get checkoutPostalRequired => 'Postleitzahl ist erforderlich';

  @override
  String get checkoutBuyerInfo => 'Käuferinformationen';

  @override
  String get checkoutSaveInfo => 'Daten für das nächste Mal speichern';

  @override
  String get checkoutMoneyBackGuarantee => '30 Tage Geld-zurück-Garantie';

  @override
  String get checkoutContinueToPayment => 'Weiter zur Zahlung';

  @override
  String get checkoutContinueToReview => 'Weiter zur Überprüfung';

  @override
  String get checkoutReviewConfirm => 'Prüfen & Bestätigen';

  @override
  String get checkoutStartLearning => 'Lernen starten';

  @override
  String get checkoutBackHome => 'Zurück zur Startseite';

  @override
  String get courseDetailsTitle => 'Kursdetails';

  @override
  String get courseDetailsShare => 'Teilen';

  @override
  String get courseDetailsWhatYouWillLearn => 'Was Sie lernen werden';

  @override
  String get courseDetailsLanguage => 'Sprache';

  @override
  String get courseDetailsCreatedBy => 'Erstellt von';

  @override
  String get courseDetailsPreviewLesson => 'Vorschau';

  @override
  String get courseDetailsHoursOnDemand => 'Stunden On-Demand-Video';

  @override
  String get courseDetailsFullLifetimeAccess =>
      'Vollständiger lebenslanger Zugriff';

  @override
  String get courseDetailsCertifiedCertificate =>
      'Zertifiziertes Abschlusszertifikat';

  @override
  String get courseDetailsComprehensiveContent => 'Umfassender Inhalt';

  @override
  String get certTitle => 'Abschlusszertifikat';

  @override
  String get certStudentNameLabel => 'Teilnehmer';

  @override
  String get certCourseLabel => 'Kurs';

  @override
  String get certInstructorLabel => 'Dozent';

  @override
  String get certIssueDateLabel => 'Ausstellungsdatum';

  @override
  String get certCodeLabel => 'Zertifikats-ID';

  @override
  String get certVerifiedBadge => 'Verifiziert';

  @override
  String get certDownloadPDF => 'PDF herunterladen';

  @override
  String get certDownloadPNG => 'Bild herunterladen';

  @override
  String get certCopyVerifyLink => 'Verifizierungslink kopieren';

  @override
  String get certShare => 'Zertifikat teilen';

  @override
  String get playerTabLessons => 'Lektionen';

  @override
  String get playerTabOverview => 'Übersicht';

  @override
  String get playerTabNotes => 'Meine Notizen';

  @override
  String get playerTabQnA => 'Fragen & Antworten';

  @override
  String get playerNextLesson => 'Nächste Lektion';

  @override
  String get profileWelcome => 'Willkommen';

  @override
  String get profileLoginPrompt => 'Melden Sie sich an, um Ihr Profil zu sehen';

  @override
  String get profileLoginOrRegister => 'Anmelden / Registrieren';

  @override
  String get profileVerifiedStudent => 'Verifizierter Student';

  @override
  String get profileLogout => 'Abmelden';

  @override
  String get profileCancel => 'Abbrechen';

  @override
  String get profileLogoutConfirmTitle => 'Abmelden';

  @override
  String get profileLogoutConfirmMessage =>
      'Möchten Sie sich wirklich abmelden?';

  @override
  String get profileAccountSettings => 'Kontoeinstellungen';

  @override
  String get profileEditProfileSubtitle => 'Persönliche Daten bearbeiten';

  @override
  String get profileSecurity => 'Kontosicherheit';

  @override
  String get profileSecuritySubtitle => 'Passwort & Authentifizierung';

  @override
  String get profilePurchaseHistory => 'Bestellhistorie';

  @override
  String get profilePurchaseHistorySubtitle => 'Transaktionen anzeigen';

  @override
  String get profileCertificatesSubtitle => 'Ihre erworbenen Zertifikate';

  @override
  String get profileTeach => 'Auf EduLab unterrichten';

  @override
  String get profileTeachSubtitle => 'Teilen Sie Ihr Wissen';

  @override
  String get profilePreferences => 'Einstellungen';

  @override
  String get profilePreferencesSubtitle => 'Erscheinungsbild & Optionen';

  @override
  String get profileNotifications => 'Benachrichtigungen';

  @override
  String get profileNotificationsSubtitle => 'Mitteilungen verwalten';

  @override
  String get profileHelpSupport => 'Hilfe & Support';

  @override
  String get profileTerms => 'Nutzungsbedingungen';

  @override
  String get profilePrivacy => 'Datenschutzerklärung';

  @override
  String get profileAboutEduLab => 'Über EduLab';

  @override
  String get profileWishlist => 'Wunschliste';

  @override
  String get securityTitle => 'Kontosicherheit';

  @override
  String get teachTitle => 'Auf EduLab unterrichten';

  @override
  String get notificationsTabAll => 'Alle';

  @override
  String get notificationsTabCourses => 'Kurse';

  @override
  String get notificationsTabPromos => 'Angebote';

  @override
  String get notificationsEmptyTitle => 'Keine Benachrichtigungen';

  @override
  String get notificationsUnread => 'Ungelesen';

  @override
  String get wishlistTitle => 'Wunschliste';

  @override
  String get wishlistEmptyTitle => 'Ihre Wunschliste ist leer';

  @override
  String get wishlistEmptySubtitle => 'Speichern Sie interessante Kurse';

  @override
  String get wishlistAddToCart => 'In den Warenkorb';

  @override
  String get wishlistRemovedSnackbar => 'Aus Wunschliste entfernt';

  @override
  String get homeDefaultUser => 'Student';

  @override
  String get learningOf => 'von';

  @override
  String get cartInCartBadge => 'Im Warenkorb';

  @override
  String get homePromo1Badge => 'Großer Sale • Zeitlich begrenzt';

  @override
  String get homePromo1Title => 'Lernen zu den besten Preisen';

  @override
  String get homePromo1Subtitle =>
      'Bis zu 65% Rabatt auf Kurse in Programmierung, Design und Wirtschaft.';

  @override
  String get homePromo1Button => 'Angebote ansehen';

  @override
  String get homePromo2Badge => 'Zertifizierte Karrierepfade';

  @override
  String get homePromo2Title => 'Bereite dich auf deinen Traumjob vor';

  @override
  String get homePromo2Subtitle =>
      'Komplette Praxiskurse von Null bis zum Profi mit Zertifikaten.';

  @override
  String get homePromo2Button => 'Pfade erkunden';

  @override
  String get homePromo3Badge => 'Top-Dozenten & Experten';

  @override
  String get homePromo3Title => 'Lerne direkt von Branchenexperten';

  @override
  String get homePromo3Subtitle =>
      'Stets aktuelle Inhalte für modernste Technologien.';

  @override
  String get homePromo3Button => 'Jetzt starten';

  @override
  String get homeSearchFilter => 'Filtern';

  @override
  String get securitySectionChangePassword => 'Passwort ändern';

  @override
  String get securityCurrentPasswordLabel => 'Aktuelles Passwort *';

  @override
  String get securityCurrentPasswordError => 'Aktuelles Passwort eingeben';

  @override
  String get securityNewPasswordLabel => 'Neues Passwort *';

  @override
  String get securityNewPasswordError => 'Muss mindestens 8 Zeichen lang sein';

  @override
  String get securityConfirmPasswordLabel => 'Neues Passwort bestätigen *';

  @override
  String get securityConfirmPasswordError => 'Passwörter stimmen nicht überein';

  @override
  String get securityUpdatePasswordBtn => 'Passwort aktualisieren';

  @override
  String get securityPasswordUpdatedSuccess => 'Passwort erfolgreich geändert!';

  @override
  String get securitySection2FA => 'Zwei-Faktor-Authentifizierung (2FA)';

  @override
  String get security2FATitle => 'Zwei-Faktor-Authentifizierung';

  @override
  String get security2FAEnabledDesc =>
      'Aktiviert - Schützt Ihr Konto mit einem Code';

  @override
  String get security2FADisabledDesc => 'Deaktiviert (Empfohlen)';

  @override
  String get security2FASetupTitle =>
      'Zwei-Faktor-Authentifizierung aktivieren';

  @override
  String get security2FASetupContent =>
      'Bei jeder neuen Anmeldung wird ein 6-stelliger Bestätigungscode an Ihre E-Mail-Adresse gesendet.';

  @override
  String get security2FAEnableNow => 'Jetzt aktivieren';

  @override
  String get security2FAEnabledSuccess =>
      'Zwei-Faktor-Authentifizierung erfolgreich aktiviert!';

  @override
  String get security2FADisabledSuccess =>
      'Zwei-Faktor-Authentifizierung deaktiviert';

  @override
  String get securitySectionSessions => 'Aktive Sitzungen & Geräte';

  @override
  String get securityLogoutAllDevices => 'Von allen Geräten abmelden';

  @override
  String get securityThisDevice => 'Dieses Gerät';

  @override
  String get securitySessionRevokedSuccess =>
      'Sitzung beendet und Gerät abgemeldet.';

  @override
  String get securityAllSessionsRevokedSuccess =>
      'Von allen anderen Geräten abgemeldet.';

  @override
  String get purchaseHistoryInvoiceCertified => 'Zertifizierte E-Rechnung';

  @override
  String get purchaseHistoryInvoiceNumber => 'Rechnungsnummer';

  @override
  String get purchaseHistoryCourse => 'Kurs';

  @override
  String get purchaseHistoryPaymentMethod => 'Zahlungsmethode';

  @override
  String get purchaseHistoryTotalAmount => 'Gesamtbetrag:';

  @override
  String get purchaseHistoryClose => 'Schließen';

  @override
  String get purchaseHistoryDownloadPdf => 'PDF herunterladen';

  @override
  String get purchaseHistoryPdfDownloaded =>
      'Rechnungs-PDF erfolgreich heruntergeladen';

  @override
  String get purchaseHistoryRefundRequestTitle => 'Rückerstattung anfordern';

  @override
  String get purchaseHistoryRefundPolicy =>
      'Gemäß der 30-Tage-Geld-zurück-Garantie von EduLab erhalten Sie eine volle Rückerstattung.';

  @override
  String get purchaseHistoryRefundReasonHint =>
      'Grund für die Rückerstattung (optional)...';

  @override
  String get purchaseHistoryConfirmRefund => 'Rückerstattung bestätigen';

  @override
  String get purchaseHistoryRefundSubmitted =>
      'Rückerstattungsantrag erfolgreich übermittelt (3-5 Werktage).';

  @override
  String get purchaseHistoryInstructor => 'Dozent';

  @override
  String get purchaseHistoryRequestRefundBtn => 'Rückerstattung anfordern';

  @override
  String get purchaseHistoryInvoiceBtn => 'Rechnung';

  @override
  String get purchaseHistoryStatusCompleted => 'Abgeschlossen';

  @override
  String get purchaseHistoryStatusRefunded => 'Zurückerstattet';

  @override
  String get purchaseHistoryStatusProcessingRefund =>
      'Rückerstattung in Bearbeitung';

  @override
  String get editProfileSectionBasicInfo => 'Grundlegende Informationen';

  @override
  String get editProfileFullNameLabel => 'Vollständiger Name *';

  @override
  String get editProfileFullNameHint =>
      'Geben Sie Ihren vollständigen Namen ein';

  @override
  String get editProfileFullNameError =>
      'Bitte geben Sie Ihren vollständigen Namen ein';

  @override
  String get editProfileHeadlineLabel => 'Berufliche Bezeichnung';

  @override
  String get editProfileHeadlineHint => 'z. B. Senior Flutter-Entwickler';

  @override
  String get editProfileLocationLabel => 'Stadt / Land';

  @override
  String get editProfileLocationHint => 'Berlin, Deutschland';

  @override
  String get editProfilePhoneLabel => 'Mobiltelefon';

  @override
  String get editProfileBioLabel => 'Über mich (Biografie)';

  @override
  String get editProfileBioHint =>
      'Schreiben Sie eine kurze Zusammenfassung Ihrer Interessen und Erfahrungen...';

  @override
  String get editProfileSectionLinks => 'Links & berufliche Netzwerke';

  @override
  String get editProfileWebsiteLabel => 'Persönliche Website';

  @override
  String get editProfileSectionEmail => 'Registrierte E-Mail-Adresse';

  @override
  String get editProfileEmailDesc =>
      'Mit Ihrem Konto für Anmeldung und Zertifikate verknüpft';

  @override
  String get editProfileEmailVerified => 'Verifiziert';

  @override
  String get editProfileSaveChangesBtn => 'Änderungen speichern';

  @override
  String get editProfileSavedSuccess => 'Profil erfolgreich aktualisiert!';

  @override
  String get editProfileChangeAvatarTitle => 'Profilbild ändern';

  @override
  String get editProfileTakePhoto => 'Foto aufnehmen';

  @override
  String get editProfileChooseGallery => 'Aus Galerie wählen';

  @override
  String get editProfilePhotoUpdatedSuccess =>
      'Profilbild erfolgreich aktualisiert';

  @override
  String get teachJoinInstructorTitle => 'Als Dozent beitreten';

  @override
  String get teachJoinInstructorSubtitle =>
      'Veröffentlichen Sie Kurse und teilen Sie Ihr Wissen mit Tausenden von Lernenden.';

  @override
  String get teachStep1Title => 'Persönliche Daten';

  @override
  String get teachStep2Title => 'Erfahrung & Fähigkeiten';

  @override
  String get teachStep3Title => 'Bestätigung';

  @override
  String get teachStep1Header => '1. Persönliche und berufliche Informationen';

  @override
  String get teachFullNameArabicLabel => 'Vollständiger Name *';

  @override
  String get teachFullNameArabicHint => 'z. B. Max Mustermann';

  @override
  String get teachHeadlineLabel => 'Berufsbezeichnung & Fachgebiet *';

  @override
  String get teachHeadlineHint =>
      'z. B. Senior Software Architect & Flutter Trainer';

  @override
  String get teachPhoneLabel => 'Telefonnummer *';

  @override
  String get teachCountryLabel => 'Wohnsitzland *';

  @override
  String get teachBioLabel => 'Überblick & bisherige Erfahrung *';

  @override
  String get teachBioHint =>
      'Schreiben Sie eine kurze Zusammenfassung Ihres Werdegangs und Ihrer Projekte...';

  @override
  String get teachNextStepSkills => 'Weiter: Erfahrung & Fähigkeiten';

  @override
  String get teachStep2Header => '2. Kursinhalt & Fähigkeiten';

  @override
  String get teachTopicLabel =>
      'Thema oder Fachbereich des vorgeschlagenen Kurses *';

  @override
  String get teachTopicHint => 'z. B. Flutter-App-Entwicklung von Grund auf';

  @override
  String get teachYearsExperienceLabel => 'Jahre Berufserfahrung *';

  @override
  String get teachVideoLinkLabel =>
      'Link zu einem Probevideo (YouTube/Drive/Loom) *';

  @override
  String get teachTargetAudienceLabel => 'Zielgruppe des Kurses *';

  @override
  String get teachAudienceBeginners => 'Absolute Anfänger';

  @override
  String get teachAudienceIntermediate => 'Anfänger & Fortgeschrittene';

  @override
  String get teachAudienceAdvanced => 'Profis & Experten';

  @override
  String get teachAudienceAll => 'Alle Niveaus';

  @override
  String get teachSkillsCoveredLabel =>
      'Im Kurs vermittelte Fähigkeiten & Technologien *';

  @override
  String get teachAddSkillHint => 'Fähigkeit hinzufügen (z. B. GraphQL)...';

  @override
  String get teachAddSkillBtn => 'Hinzufügen';

  @override
  String get teachNextStepConfirm => 'Weiter: Bewerbung bestätigen';

  @override
  String get teachStep3Header => '3. Auszahlungsdetails & Bedingungen';

  @override
  String get teachPayoutMethodLabel => 'Auszahlungsmethode *';

  @override
  String get teachPayoutMethodBank => 'Direkte Banküberweisung (IBAN)';

  @override
  String get teachPayoutMethodPaypal => 'Verifiziertes PayPal-Konto';

  @override
  String get teachPayoutMethodPayoneer => 'Payoneer-Karte';

  @override
  String get teachIbanDetailsLabel => 'Kontodaten / IBAN *';

  @override
  String get teachApplicationSummary => 'Bewerbungsübersicht:';

  @override
  String get teachApplicantName => 'Bewerber';

  @override
  String get teachApplicantHeadline => 'Fachgebiet';

  @override
  String get teachApplicantTopic => 'Kursthema';

  @override
  String get teachApplicantSkillsCount => 'Anzahl der Fähigkeiten';

  @override
  String get teachSkillsUnit => 'Fähigkeiten';

  @override
  String get teachAgreeTermsLabel =>
      'Ich akzeptiere die Bedingungen und die Vereinbarung zum geistigen Eigentum von EduLab.';

  @override
  String get teachSubmitApplicationBtn => 'Dozentenbewerbung einreichen';

  @override
  String get teachPrevStepBtn => 'Zurück';

  @override
  String get teachWhyEduLabTitle => 'Warum bei EduLab unterrichten?';

  @override
  String get teachProp1Title => 'Faire & lukrative Vergütung';

  @override
  String get teachProp1Desc =>
      'Verdienen Sie bis zu 80 % an Kursverkäufen ohne versteckte Gebühren.';

  @override
  String get teachProp2Title => 'Erreichen Sie Tausende Lernende';

  @override
  String get teachProp2Desc =>
      'Vermarkten Sie Ihren Kurs an eine riesige, aktive Lerngemeinschaft.';

  @override
  String get teachProp3Title => 'Kompletter technischer & Produktions-Support';

  @override
  String get teachProp3Desc =>
      'Unser Team hilft Ihnen bei Audio-, Videoqualität und Lehrplangestaltung.';

  @override
  String get teachSuccessDialogTitle => 'Bewerbung erfolgreich erhalten!';

  @override
  String get teachSuccessDialogDesc =>
      'Vielen Dank für Ihre Bewerbung bei EduLab. Unser Team wird Ihre Angaben prüfen und sich innerhalb von 48 Stunden bei Ihnen melden.';

  @override
  String get teachSuccessDialogOk => 'Verstanden';

  @override
  String get teachAddOneSkillError =>
      'Bitte mindestens eine Fähigkeit hinzufügen';

  @override
  String get teachAgreeTermsError =>
      'Bitte stimmen Sie den Dozentenbedingungen zu';

  @override
  String get commonCancel => 'Abbrechen';

  @override
  String get commonClose => 'Schließen';

  @override
  String get myCertificatesBannerTitle => 'Akkreditierte Zertifikate';

  @override
  String get myCertificatesBannerSubtitle =>
      'Alle Zertifikate sind akkreditiert und mit einer eindeutigen ID von EduLab verifiziert';

  @override
  String get certBadgeVerified100 => '100% Akkreditiert';

  @override
  String get certCodeCopied => 'Zertifikatscode kopiert';

  @override
  String get certGrantedTo => 'Verliehen an';

  @override
  String get certViewAndDownload => 'Zertifikat anzeigen & herunterladen';

  @override
  String get certIssuerLabel => 'Ausstellende Behörde';

  @override
  String get certIssuerName => 'EduLab Akademie für interaktives Lernen';

  @override
  String get certEmptyTitle => 'Noch keine Zertifikate erworben';

  @override
  String get certEmptyDesc =>
      'Schließen Sie 100% eines eingeschriebenen Kurses ab, um ein akkreditiertes Zertifikat mit offizieller Verifizierungs-ID zu erhalten.';

  @override
  String get certEmptyAction => 'Meine Kurse fortsetzen';

  @override
  String get certDetailsTitle => 'Zertifikatsdetails & Informationen';

  @override
  String get certCopyLinkSuccess =>
      'Direkter Verifizierungslink in die Zwischenablage kopiert!';

  @override
  String get certShareSuccess =>
      'Zertifikatsdetails und Link zum Teilen kopiert!';

  @override
  String get purchaseHistoryTaxInvoiceCertified =>
      'Offizielle zertifizierte Steuerrechnung';

  @override
  String get purchaseHistoryInvoiceNumberLabel => 'Bestell- / Rechnungsnummer';

  @override
  String get purchaseHistoryCourseNameLabel => 'Kursname';

  @override
  String get purchaseHistoryPurchaseDateLabel => 'Kaufdatum';

  @override
  String get purchaseHistoryPaymentMethodLabel => 'Zahlungsmethode';

  @override
  String get purchaseHistoryPaymentMethodValue =>
      'Kreditkarte / Stripe (Online)';

  @override
  String get purchaseHistoryOrderStatusLabel => 'Bestellstatus';

  @override
  String get purchaseHistoryStatusPendingReview =>
      'Rückerstattungsprüfung ausstehend';

  @override
  String get purchaseHistoryCopyInvoiceBtn => 'Rechnungsnummer kopieren';

  @override
  String get purchaseHistoryRefundReasonLabel =>
      'Grund für den Rückerstattungsantrag:';

  @override
  String get purchaseHistoryRefundReasonEmptyError =>
      'Bitte geben Sie einen Grund für Ihren Rückerstattungsantrag an';

  @override
  String get purchaseHistorySubmittingRefund => 'Anfrage wird gesendet...';

  @override
  String get purchaseHistoryPaidDate => 'Zahlungsdatum';

  @override
  String get purchaseHistoryEmptyTitle => 'Noch keine Kaufhistorie vorhanden';

  @override
  String get purchaseHistoryEmptyDesc =>
      'Sie haben noch keine Kurse gekauft.\nIhre Bestellungen und Rechnungen werden hier nach Abschluss angezeigt.';

  @override
  String get purchaseHistoryExploreCourses => 'Jetzt Kurse erkunden';

  @override
  String get profileMyCourses => 'Meine Kurse';

  @override
  String get profileMyCoursesSubtitle =>
      'Fortschritt in Ihren eingeschriebenen Kursen verfolgen';

  @override
  String get profileWishlistSubtitle =>
      'Auf Ihrer Wunschliste gespeicherte Kurse';

  @override
  String get navMyLearning => 'Mein Lernen';

  @override
  String get profileLogoutSafeNote =>
      'Ihre Daten, Kurse und Zertifikate sind vollkommen sicher. Sie können jederzeit nach dem erneuten Anmelden weiterlernen.';

  @override
  String learningRemainingHours(String hours) {
    return 'Noch $hours Std.';
  }

  @override
  String get learningCompletedFull => 'Vollständig abgeschlossen';

  @override
  String get learningFilterNotStarted => 'Nicht Begonnen';

  @override
  String get wishlistTopRatedBadge => 'Top-Bewertet';

  @override
  String get wishlistFeaturedBadge => 'Empfohlen';

  @override
  String wishlistDiscountBadge(String percent) {
    return '$percent% Rabatt';
  }
}

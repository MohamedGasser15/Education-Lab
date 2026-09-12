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
  String get homePromoInstructorBadge =>
      'Unterrichten auf EduLab • Wissen teilen';

  @override
  String get homePromoInstructorTitle => 'Werden Sie noch heute Dozent';

  @override
  String get homePromoInstructorSubtitle =>
      'Inspirieren Sie Lernende weltweit, erstellen Sie Kurse und verdienen Sie Geld mit dem, was Sie lieben.';

  @override
  String get homePromoInstructorButton => 'Jetzt bewerben';

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
  String get teachSubmitApplicationBtn => 'Dozentenantrag einreichen';

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

  @override
  String get courseFree => 'Kostenlos';

  @override
  String get badgeBestseller => 'Bestseller';

  @override
  String get badgeTopRated => 'Top-Bewertet';

  @override
  String get badgeFeatured => 'Hervorgehoben';

  @override
  String get badgeRecommended => 'Für dich empfohlen';

  @override
  String get badgeNew => 'Neu';

  @override
  String get courseWord => 'Kurs';

  @override
  String coursesCountText(String count) {
    return '$count+ Kurse';
  }

  @override
  String studentsCountText(String count) {
    return '$count Teilnehmer';
  }

  @override
  String hoursCountText(String count) {
    return '$count Std.';
  }

  @override
  String get certifiedInstructor => 'Zertifizierter Dozent';

  @override
  String get expertCertifiedInstructor => 'Experte & zertifizierter Dozent';

  @override
  String get defaultCourseTitle => 'Lehrgang';

  @override
  String get categoryWord => 'Kategorie';

  @override
  String get previewCourseVideo => 'Kursvideo-Vorschau';

  @override
  String get freeSection => 'Kostenloser Abschnitt';

  @override
  String get freeDemoVideo => 'Kostenloses Demovideo';

  @override
  String get articleLecture => 'Artikel-Lektion';

  @override
  String get articleViewer => 'Artikel-Betrachter';

  @override
  String get courseVideoPlayer => 'Kurs-Videoplayer';

  @override
  String get playingNow => 'Wird abgespielt';

  @override
  String get readingNow => 'Wird gelesen';

  @override
  String get noLecturesInFreeSection =>
      'Keine Lektionen im kostenlosen Bereich';

  @override
  String freeLecturesCount(String count) {
    return '$count kostenlose Lektionen';
  }

  @override
  String get enrollInFullCourse => 'Gesamten Kurs buchen';

  @override
  String get articleWord => 'Artikel';

  @override
  String get videoWord => 'Video';

  @override
  String get quizWord => 'Quiz';

  @override
  String get courseShareCopied => 'Kurslink in die Zwischenablage kopiert!';

  @override
  String get addedToCartSnackbar => 'Zum Warenkorb hinzugefügt';

  @override
  String get viewCartAction => 'Warenkorb ansehen';

  @override
  String get inCartBadge => 'Im Warenkorb ✓';

  @override
  String get addToCartButton => 'In den Warenkorb';

  @override
  String get wishlistAddedSnackbar =>
      'Kurs erfolgreich zur Wunschliste hinzugefügt';

  @override
  String get wishlistRemovedSuccessSnackbar =>
      'Kurs aus der Wunschliste entfernt';

  @override
  String get lessonCompletedAll =>
      'Herzlichen Glückwunsch! Sie haben alle Lektionen abgeschlossen.';

  @override
  String get noteAddedSuccess => 'Notiz erfolgreich hinzugefügt';

  @override
  String get lessonAlreadyDownloaded => 'Lektion ist bereits offline verfügbar';

  @override
  String get lessonLinkCopied => 'Lektionslink kopiert';

  @override
  String get contentReportThanks =>
      'Vielen Dank! Unser Team wird die Lektion prüfen.';

  @override
  String get courseCompletionCertificate => 'Kursabschlusszertifikat';

  @override
  String get reportContentIssue => 'Inhaltliches Problem melden';

  @override
  String get loginOrSocial => 'Oder anmelden mit';

  @override
  String get loginSuccessSnackbar => 'Erfolgreich angemeldet';

  @override
  String get cartClearDialogTitle => 'Warenkorb leeren';

  @override
  String get cartClearDialogMessage =>
      'Möchten Sie wirklich alle Kurse aus dem Warenkorb entfernen?';

  @override
  String get cartClearConfirmButton => 'Leeren';

  @override
  String get guestWelcomeTitle => 'Willkommen bei EduLab';

  @override
  String get guestWelcomeSubtitle =>
      'Melden Sie sich an, um Ihre Kurse und Zertifikate zu sehen';

  @override
  String get securitySetup2FATitle =>
      'Zwei-Faktor-Authentifizierung einrichten (2FA)';

  @override
  String get securityScanQRCode =>
      'Scannen Sie den QR-Code mit Ihrer Authentifikator-App';

  @override
  String get securitySecretKeyManual => 'Geheimschlüssel (manuelle Eingabe)';

  @override
  String get securitySecretKeyCopied => 'Geheimschlüssel kopiert';

  @override
  String get securityEnter6DigitCode =>
      'Bestätigungscode eingeben (6 Ziffern):';

  @override
  String get securityConfirmEnable2FABtn => 'Bestätigen & 2FA aktivieren';

  @override
  String get securityEnter6DigitsError =>
      'Bitte geben Sie den 6-stelligen Bestätigungscode ein';

  @override
  String get securityLogoutAllDevicesTitle => 'Von allen Geräten abmelden';

  @override
  String get securityLogoutAllDevicesMessage =>
      'Möchten Sie sich wirklich von allen anderen Geräten abmelden?';

  @override
  String get securityLogoutAllDevicesConfirmBtn => 'Alle abmelden';

  @override
  String get securityDisable2FAModalTitle =>
      'Zwei-Faktor-Authentifizierung deaktivieren';

  @override
  String get securityDisable2FAModalMessage =>
      'Das Deaktivieren verringert die Kontosicherheit. Fortfahren?';

  @override
  String get securityDisable2FAConfirmBtn => '2FA deaktivieren';

  @override
  String get securityNoOtherSessions => 'Keine weiteren aktiven Sitzungen';

  @override
  String get securityCurrentDeviceOnly =>
      'Sie sind derzeit nur auf diesem Gerät angemeldet';

  @override
  String get securityShowLessDevices => 'Weniger Geräte anzeigen';

  @override
  String securityShowAllDevicesCount(String count) {
    return 'Alle Geräte anzeigen ($count)';
  }

  @override
  String get securityUpdatingPassword => 'Passwort wird aktualisiert...';

  @override
  String get editProfileTakePhotoDesc => 'Neues Foto mit der Kamera aufnehmen';

  @override
  String get editProfileChooseGalleryDesc => 'Foto aus der Galerie auswählen';

  @override
  String get editProfileHeadlineError => 'Titel ist erforderlich';

  @override
  String get editProfileLocationError => 'Standort ist erforderlich';

  @override
  String get editProfilePhoneError => 'Telefonnummer ist erforderlich';

  @override
  String get editProfileBioError => 'Biografie ist erforderlich';

  @override
  String get editProfileSavingChanges => 'Änderungen werden gespeichert...';

  @override
  String get themeLight => 'Hell';

  @override
  String get themeDark => 'Dunkel';

  @override
  String get themeSystem => 'System';

  @override
  String get teachFullNameRequired => 'Vollständigen Namen eingeben';

  @override
  String get teachHeadlineRequired => 'Berufsbezeichnung eingeben';

  @override
  String get teachPhoneRequired => 'Telefonnummer eingeben';

  @override
  String get teachCountryRequired => 'Wohnsitzland eingeben';

  @override
  String get teachBioMinLength =>
      'Biografie muss mindestens 20 Zeichen lang sein';

  @override
  String get teachSubmittingApplication => 'Wird eingereicht...';

  @override
  String get wishlistFailedAddToCart =>
      'Kurs konnte nicht zum Warenkorb hinzugefügt werden';

  @override
  String get cartClearAllTitle => 'Alle Artikel im Warenkorb löschen?';

  @override
  String cartClearAllMessage(String count) {
    return 'Sind Sie sicher, dass Sie alle $count Kurse aus Ihrem Warenkorb entfernen möchten?';
  }

  @override
  String get cartClearAllHint =>
      'Alle Kurse werden aus Ihrem Warenkorb entfernt. Sie können sie jederzeit wieder hinzufügen.';

  @override
  String cartClearAllConfirm(String count) {
    return 'Alles löschen ($count)';
  }

  @override
  String get cartClearedSuccess => 'Warenkorb erfolgreich geleert';

  @override
  String get cartClearFailed => 'Der Warenkorb konnte nicht geleert werden';

  @override
  String cartViewWishlistCount(String count) {
    return 'Wunschliste-Artikel anzeigen ($count)';
  }

  @override
  String get cartGoToWishlist => 'Gehen Sie zur Wunschliste';

  @override
  String get wishlistClearAllTitle => 'Alle Wunschliste-Artikel löschen?';

  @override
  String wishlistClearAllMessage(String count) {
    return 'Sind Sie sicher, dass Sie alle $count Kurse von Ihrer Wunschliste entfernen möchten?';
  }

  @override
  String get wishlistClearAllHint =>
      'Alle gespeicherten Kurse werden gelöscht. Sie können sie jederzeit über Explore wieder hinzufügen.';

  @override
  String wishlistClearAllConfirm(String count) {
    return 'Alles löschen ($count)';
  }

  @override
  String get wishlistClearedSuccess => 'Wunschliste erfolgreich gelöscht';

  @override
  String get wishlistClearFailed => 'Wunschliste konnte nicht gelöscht werden';

  @override
  String get wishlistClearTooltip => 'Alles löschen';

  @override
  String wishlistViewCartCount(String count) {
    return 'Warenkorbartikel anzeigen ($count)';
  }

  @override
  String get wishlistGoToCart => 'Gehen Sie zum Warenkorb';

  @override
  String get checkoutCardNumberInvalid =>
      'Bitte geben Sie eine gültige 16-stellige Kartennummer ein';

  @override
  String get checkoutCardExpiryInvalidFormat =>
      'Bitte geben Sie ein gültiges Ablaufdatum der Karte ein (MM/JJ)';

  @override
  String get checkoutCardExpiredDate =>
      'Das Ablaufdatum der Karte ist ungültig';

  @override
  String get checkoutCardCvcInvalid =>
      'Bitte geben Sie einen gültigen 3- oder 4-stelligen CVC-Code ein';

  @override
  String get checkoutCardHolderNameRequired =>
      'Bitte geben Sie den Namen des Karteninhabers ein';

  @override
  String get checkoutCartEmptySnackbar => 'Der Warenkorb ist leer';

  @override
  String get checkoutPaymentStartFailed =>
      'Die Zahlung konnte nicht eingeleitet werden';

  @override
  String get checkoutClientSecretMissing =>
      'Der Sicherheitsschlüssel wurde vom Zahlungsgateway nicht empfangen';

  @override
  String get checkoutCardVerificationFailed =>
      'Die Kartenbestätigung ist fehlgeschlagen';

  @override
  String get checkoutStripeProcessingFailed =>
      'Die Stripe-Zahlungsverarbeitung ist fehlgeschlagen';

  @override
  String get checkoutServerConfirmationFailed =>
      'Die Bestätigung der Serverzahlung ist fehlgeschlagen';

  @override
  String get checkoutEmptyCartTitle => 'Ihr Warenkorb ist leer';

  @override
  String get checkoutEmptyCartDesc =>
      'Sie haben Ihrem Warenkorb noch keine Kurse hinzugefügt. Entdecken Sie unsere Kurse und beginnen Sie zu lernen!';

  @override
  String get checkoutContinueFreeReview => 'Weiter zur kostenlosen Rezension';

  @override
  String get checkoutFreeOrderBadge => '100 % kostenlose Bestellung (zsh.00)';

  @override
  String get checkoutFreeOrderNotice =>
      'Für diese Bestellung sind keine Zahlungsinformationen erforderlich. Sie können direkt mit der Bestätigung der Anmeldung fortfahren.';

  @override
  String get checkoutFreeCheckoutTitle => '100 % kostenloser Checkout';

  @override
  String get checkoutConfirmFreeEnrollment =>
      'Bestätigen Sie die kostenlose Registrierung';

  @override
  String get checkoutFreePrice => 'Frei';

  @override
  String get checkoutFreeZero => 'Kostenlos (zsh.00)';

  @override
  String checkoutCoursesCount(String count) {
    return '$count Kurse';
  }

  @override
  String get notificationsClearAllTitle => 'Alle Benachrichtigungen löschen?';

  @override
  String notificationsClearAllMessage(String count) {
    return 'Sind Sie sicher, dass Sie alle $count-Benachrichtigungen löschen möchten? Diese Aktion kann nicht rückgängig gemacht werden.';
  }

  @override
  String get notificationsClearAllHint =>
      'Alle Ihre Benachrichtigungen werden gelöscht und Ihr Posteingang beginnt neu.';

  @override
  String notificationsClearAllConfirm(String count) {
    return 'Alles löschen ($count)';
  }

  @override
  String get notificationsClearSuccess =>
      'Alle Benachrichtigungen wurden erfolgreich gelöscht';

  @override
  String get notificationsClearFailed =>
      'Benachrichtigungen konnten nicht gelöscht werden';

  @override
  String get notificationsClearTooltip => 'Alles löschen';

  @override
  String get notificationsViewDetails => 'Details anzeigen';

  @override
  String get notificationsEmptyCategoryTitle =>
      'Keine Benachrichtigungen in dieser Kategorie';

  @override
  String get notificationsEmptyCategorySubtitle =>
      'Wechseln Sie zu einer anderen Kategorie oder durchsuchen Sie alle Benachrichtigungen';

  @override
  String get notificationsEmptyAllSubtitle =>
      'Wir halten Sie hier über die neuesten Updates und Warnungen auf dem Laufenden';

  @override
  String get notificationsViewAll => 'Alle Benachrichtigungen anzeigen';

  @override
  String get learningFilterAndSortTitle => 'Kurse filtern und sortieren';

  @override
  String get learningFilterReset => 'Zurücksetzen';

  @override
  String get learningSortByTitle => 'Sortieren nach';

  @override
  String get learningSortRecentActivity => 'Kürzlich aufgerufen';

  @override
  String get learningSortRecentEnrolled => 'Kürzlich eingeschrieben';

  @override
  String get learningSortTitleAZ => 'Titel (A-Z)';

  @override
  String get learningSortProgress => 'Fortschritt %';

  @override
  String get learningStatusTitle => 'Kursstatus';

  @override
  String get learningStatusAll => 'Alle Kurse';

  @override
  String get learningStatusInProgress => 'Im Gange';

  @override
  String get learningStatusCompleted => 'Abgeschlossen';

  @override
  String get learningStatusNotStarted => 'Nicht begonnen';

  @override
  String get learningFilterApply => 'Filter anwenden';

  @override
  String get learningSearchCoursesHint => 'Kurse durchsuchen...';

  @override
  String get learningSearchWishlistHint => 'Wunschliste durchsuchen...';

  @override
  String get learningSearchCertificatesHint => 'Zertifikate durchsuchen...';

  @override
  String get learningTabMyCourses => 'Meine Kurse';

  @override
  String get learningTabFavourite => 'Meine Favoriten';

  @override
  String get learningTabCertificates => 'Meine Zertifikate';

  @override
  String get learningNoCoursesTitle => 'Noch keine Kurse';

  @override
  String get learningNoCoursesSubtitle =>
      'Entdecken Sie Tausende von Premium-Kursen und beginnen Sie noch heute Ihre Lernreise';

  @override
  String get learningFilterButton => 'Filter';

  @override
  String learningFilterAllCount(String count) {
    return 'Alle ($count)';
  }

  @override
  String get learningStatusNotStartedShort => 'Nicht begonnen';

  @override
  String get learningNoMatchTitle => 'Keine passenden Kurse';

  @override
  String learningNoMatchSubtitle(String query) {
    return 'Keine Kurse gefunden, die „$query“ enthalten. Versuchen Sie es mit anderen Begriffen.';
  }

  @override
  String get learningNoInProgressTitle => 'Keine laufenden Kurse';

  @override
  String get learningNoInProgressSubtitle =>
      'Starten Sie Lektionen in Ihren eingeschriebenen Kursen, um Ihren Fortschritt hier zu verfolgen.';

  @override
  String get learningNoCompletedTitle => 'Noch keine abgeschlossenen Kurse';

  @override
  String get learningNoCompletedSubtitle =>
      'Setzen Sie Ihr Lernen fort, um Ihre Erfolge zu feiern und abgeschlossene Kurse hier zu sehen.';

  @override
  String get learningNoUnstartedTitle => 'Keine unbegonnenen Kurse';

  @override
  String get learningNoUnstartedSubtitle =>
      'Großartig! Sie haben bereits in allen Ihren eingeschriebenen Kursen mit dem Lernen begonnen.';

  @override
  String get learningNoFilterMatchTitle =>
      'Keine Kurse entsprechen diesem Filter';

  @override
  String get learningNoFilterMatchSubtitle =>
      'Ändern Sie Filter- oder Sortieroptionen, um Ihre Kurse anzuzeigen.';

  @override
  String learningViewAllCoursesCount(String count) {
    return 'Alle Kurse anzeigen ($count)';
  }

  @override
  String learningSavedCoursesCount(String count) {
    return 'Gespeicherte Kurse ($count)';
  }

  @override
  String get learningClearAllSaved => 'Alle löschen';

  @override
  String get learningNoCertificatesTitle => 'Noch keine Zertifikate';

  @override
  String get learningNoCertificatesSubtitle =>
      'Schließen Sie Ihre Kurse ab, um anerkannte Zertifikate zu erhalten, die Ihre Erfolge bestätigen';

  @override
  String get learningGoToCourses => 'Zu meinen Kursen';

  @override
  String learningCertIssuedDate(String date) {
    return 'Ausgestellt: $date';
  }

  @override
  String get learningCertView => 'Anzeigen';

  @override
  String get learningResumeLesson => 'Lektion fortsetzen';

  @override
  String learningProgressPercentComplete(String percent) {
    return '$percent% abgeschlossen';
  }

  @override
  String learningViewCartCount(String count) {
    return 'Warenkorb anzeigen ($count)';
  }

  @override
  String get learningGoToCart => 'Zum Warenkorb';

  @override
  String get playerLessonMarkedCompleted =>
      'Lektion als abgeschlossen markiert ✓';

  @override
  String get playerLessonMarkedIncomplete =>
      'Lektion als unvollständig markiert';

  @override
  String get playerCommentPostedSuccess =>
      'Kommentar erfolgreich veröffentlicht';

  @override
  String get playerCommentPostFailed =>
      'Kommentar konnte nicht veröffentlicht werden';

  @override
  String get playerReplyPostedSuccess => 'Antwort erfolgreich veröffentlicht';

  @override
  String get playerReplyPostFailed =>
      'Antwort konnte nicht veröffentlicht werden';

  @override
  String get playerCourseNotFound => 'Kurs nicht gefunden';

  @override
  String get playerCheckEnrollmentPrompt =>
      'Bitte überprüfen Sie zuerst Ihre Kurseinschreibung';

  @override
  String get playerReturnToCourses => 'Mein Lernen';

  @override
  String get playerWatchLecture => 'Kurslektion';

  @override
  String get playerCertificateTooltip => 'Zertifikat';

  @override
  String get playerRateCourseTooltip => 'Kurs bewerten';

  @override
  String get playerReadingArticleBadge => 'Leseartikel • 5 Min.';

  @override
  String get playerReadFullTextBelow => 'Vollständigen Text unten lesen ↓';

  @override
  String get playerTabReviews => 'Bewertungen';

  @override
  String get playerNoSectionsAvailable => 'Keine Abschnitte verfügbar';

  @override
  String playerLessonsCount(String count) {
    return '$count Lektionen';
  }

  @override
  String get playerPlayingBadge => 'Wiedergabe';

  @override
  String get playerArticleBadge => 'Artikel';

  @override
  String get playerVideoBadge => 'Video';

  @override
  String get playerFullArticleContent => 'Vollständiger Artikelinhalt';

  @override
  String get playerArticlePlaceholder =>
      'Willkommen zu dieser Lese-Lektion.\n\nDieser Abschnitt behandelt die Kernkonzepte und praktischen Schritte, die Sie zur Beherrschung der Fähigkeiten in dieser Lektion benötigen.';

  @override
  String get playerAboutCourseTitle => 'Über diesen Kurs';

  @override
  String get playerShowLess => 'Weniger anzeigen';

  @override
  String get playerReadMore => 'Mehr anzeigen';

  @override
  String get playerWhatYouWillLearn => 'Was Sie lernen werden';

  @override
  String get playerCourseInfoTitle => 'Kursdetails';

  @override
  String get playerTotalDurationTitle => 'Gesamtdauer';

  @override
  String get playerTotalLessonsTitle => 'Lektionen insgesamt';

  @override
  String playerLessonsNumber(String count) {
    return '$count Lektionen';
  }

  @override
  String get playerLevelTitle => 'Niveau';

  @override
  String get playerAllLevels => 'Alle Niveaus';

  @override
  String get playerLanguageTitle => 'Sprache';

  @override
  String get playerLanguageArabic => 'Arabisch';

  @override
  String get playerPrerequisitesTitle => 'Kursanforderungen';

  @override
  String get playerCertificateCardTitle => 'Kurszertifikat';

  @override
  String get playerCourseCompletedSuccess =>
      'Herzlichen Glückwunsch! Kurs abgeschlossen';

  @override
  String get playerProgressLabel => 'Fortschritt';

  @override
  String get playerViewCertificateBtn => 'Zertifikat anzeigen';

  @override
  String get playerCertifiedInstructor => 'Zertifizierter Kursleiter';

  @override
  String playerDiscussionsCount(String count) {
    return '$count Fragen & Diskussionen';
  }

  @override
  String get playerAskQuestionHint =>
      'Geben Sie hier Ihre Frage oder Anmerkung ein...';

  @override
  String get playerPostBtn => 'Veröffentlichen';

  @override
  String get playerNoDiscussionsTitle => 'Noch keine Diskussionen';

  @override
  String get playerNoDiscussionsSubtitle =>
      'Stellen Sie als Erste/r eine Frage!';

  @override
  String get playerInstructorBadge => 'Kursleiter';

  @override
  String get playerCancelReply => 'Abbrechen';

  @override
  String get playerReplyAction => 'Antworten';

  @override
  String playerRepliesCount(String count) {
    return '$count Antworten';
  }

  @override
  String get playerWriteReplyHint => 'Schreiben Sie eine Antwort...';

  @override
  String get playerSendReplyBtn => 'Antworten';

  @override
  String get playerCourseFeedbackTitle => 'Kursbewertung & Feedback';

  @override
  String get playerOutOf5 => 'von 5';

  @override
  String playerRatingsFromEnrolledCount(String count) {
    return '$count Bewertungen von eingeschriebenen Teilnehmern';
  }

  @override
  String get playerKeepLearningToRate => 'Lernen Sie weiter, um zu bewerten';

  @override
  String get playerRateAfter80Hint =>
      'Sie können diesen Kurs bewerten, sobald Sie 80 % der Inhalte abgeschlossen haben';

  @override
  String get playerCurrentProgressLabel => 'Ihr Fortschritt:';

  @override
  String get playerYourCurrentRating => 'Ihre Bewertung';

  @override
  String get playerEditRating => 'Bewertung bearbeiten';

  @override
  String get playerDeleteRatingTooltip => 'Bewertung löschen';

  @override
  String get playerUpdateRatingTitle => 'Bewertung aktualisieren';

  @override
  String get playerRateCourseTitle => 'Diesen Kurs bewerten';

  @override
  String get playerWriteReviewHint =>
      'Schreiben Sie Ihr Feedback zur Inhaltsqualität (optional)...';

  @override
  String get playerRatingSubmitSuccess => 'Bewertung erfolgreich übermittelt!';

  @override
  String get playerRatingSubmitFailed =>
      'Bewertung konnte nicht übermittelt werden';

  @override
  String get playerSaveChangesBtn => 'Änderungen speichern';

  @override
  String get playerSubmitReviewBtn => 'Bewertung absenden';

  @override
  String get playerLearnerReviewsTitle => 'Bewertungen von Lernenden';

  @override
  String playerReviewsCount(String count) {
    return '$count Bewertungen';
  }

  @override
  String get playerNoWrittenReviewsTitle =>
      'Noch keine schriftlichen Bewertungen';

  @override
  String get playerNoWrittenReviewsSubtitle =>
      'Teilen Sie als Erste/r Ihre Meinung mit!';

  @override
  String get playerRatingLabel5 => 'Hervorragend 🌟 (5/5)';

  @override
  String get playerRatingLabel4 => 'Sehr gut 👍 (4/5)';

  @override
  String get playerRatingLabel3 => 'Durchschnittlich 👌 (3/5)';

  @override
  String get playerRatingLabel2 => 'Verbesserungswürdig 🤔 (2/5)';

  @override
  String get playerRatingLabel1 => 'Schlecht 👎 (1/5)';

  @override
  String get playerDeleteRatingDialogTitle => 'Bewertung löschen';

  @override
  String get playerDeleteRatingDialogMessage =>
      'Möchten Sie Ihre Bewertung für diesen Kurs wirklich löschen?';

  @override
  String get playerDeleteConfirmBtn => 'Löschen';

  @override
  String get playerRatingDeleteSuccess => 'Bewertung erfolgreich gelöscht';

  @override
  String get playerPreviousLesson => 'Vorherige Lektion';

  @override
  String get playerExitFullscreenTooltip => 'Vollbild beenden';

  @override
  String instructorsAvailableCount(String count) {
    return '$count Kursleiter verfügbar';
  }

  @override
  String get instructorsNotFound => 'Keine Kursleiter gefunden';

  @override
  String instructorsCoursesCount(String count) {
    return '$count Kurse';
  }

  @override
  String get instructorsSearchHint =>
      'Nach Dozentenname oder Fachgebiet suchen...';

  @override
  String get instructorsSortAll => 'Alle';

  @override
  String get instructorsSortTopRated => 'Bestbewertet';

  @override
  String get instructorsSortMostStudents => 'Meiste Teilnehmer';

  @override
  String get instructorsSortMostCourses => 'Meiste Kurse';

  @override
  String get instructorsNotFoundSubtitle =>
      'Versuchen Sie es mit einem anderen Namen oder setzen Sie die Filter zurück';

  @override
  String get exploreCompleteCourse => 'Umfassender Kurs';

  @override
  String get exploreGeneralCategory => 'Allgemein';

  @override
  String courseShareMessage(String title, String url) {
    return 'Schau dir den Kurs \"$title\" auf EduLab an: $url';
  }

  @override
  String get courseDetailsDefaultTitle => 'Kursdetails';

  @override
  String get courseDetailsTooltipShare => 'Teilen';

  @override
  String get courseDetailsTooltipWishlist => 'Wunschliste';

  @override
  String get courseDetailsTooltipCart => 'Warenkorb';

  @override
  String get courseDetailsNotFound => 'Kurs nicht gefunden';

  @override
  String get courseDetailsDefaultCategory => 'Kurs';

  @override
  String courseDetailsTotalRatingsCount(String count) {
    return '($count Bewertungen)';
  }

  @override
  String courseDetailsLecturesCount(String count) {
    return '$count Lektionen';
  }

  @override
  String get courseDetailsCertificateBadge => 'Zertifikat';

  @override
  String get courseDetailsTabOverview => 'Übersicht';

  @override
  String get courseDetailsTabCurriculum => 'Lehrplan';

  @override
  String get courseDetailsTabInstructor => 'Dozent';

  @override
  String get courseDetailsTabReviews => 'Bewertungen';

  @override
  String get courseDetailsFullDescriptionTitle => 'Beschreibung';

  @override
  String get courseDetailsShowLess => 'Weniger anzeigen';

  @override
  String get courseDetailsShowMore => 'Mehr anzeigen...';

  @override
  String courseDetailsCurriculumSectionsLectures(
    String sections,
    String lectures,
  ) {
    return '$sections Abschnitte • $lectures Lektionen';
  }

  @override
  String get courseDetailsCollapseAll => 'Alle einklappen';

  @override
  String get courseDetailsExpandAll => 'Alle ausklappen';

  @override
  String get courseDetailsCurriculumComingSoon =>
      'Lehrplandetails folgen in Kürze';

  @override
  String courseDetailsSectionLecturesCount(String count) {
    return '$count Lektionen';
  }

  @override
  String get courseDetailsLecturePreviewBtn => 'Vorschau';

  @override
  String get courseDetailsDefaultInstructorTitle =>
      'Leitender Dozent & Zertifizierter Experte';

  @override
  String get courseDetailsInstructorRatingLabel => 'Bewertung';

  @override
  String get courseDetailsInstructorStudentsLabel => 'Teilnehmer';

  @override
  String get courseDetailsInstructorSectionsLabel => 'Abschnitte';

  @override
  String get courseDetailsAboutInstructorTitle => 'Über den Dozenten:';

  @override
  String get courseDetailsDefaultInstructorAbout =>
      'Zertifizierter Dozent mit langjähriger Erfahrung in der professionellen Ausbildung von Tausenden Studenten weltweit.';

  @override
  String courseDetailsStudentRatingsCount(String count) {
    return '$count Teilnehmerbewertungen';
  }

  @override
  String get courseDetailsNoWrittenReviews =>
      'Noch keine schriftlichen Bewertungen';

  @override
  String get courseDetailsRelatedCourses =>
      'Ähnliche Kurse, die dir gefallen könnten';

  @override
  String courseDetailsDiscountPercent(String percent) {
    return '$percent% RABATT';
  }

  @override
  String get courseDetailsResumeCourse => 'Kurs fortsetzen';

  @override
  String get courseDetailsTryAgain => 'Erneut versuchen';

  @override
  String get courseDetailsEstimatedReading => '📖 Geschätzte Lesezeit: 4 Min.';

  @override
  String get courseDetailsSampleArticleContent =>
      'Willkommen zu dieser Textlektion.\n\nDieser Abschnitt behandelt wichtige theoretische Konzepte und praktische Schritte zur Beherrschung des Themas.\n\n• Wichtigste Erkenntnisse:\n1. Grundlegende Begriffe und Architekturmuster verstehen.\n2. Praktische Übungen und kontinuierliches Anwenden.\n3. Ergänzende Notizen und Aufgaben beachten.\n\nViel Spaß beim Lesen!';

  @override
  String certDownloadedSuccess(String course, String format) {
    return 'Zertifikat für \"$course\" erfolgreich im $format-Format heruntergeladen!';
  }

  @override
  String certVerifiedFullRequirements(String code) {
    return 'Verifizierungs-ID: $code • 100 % der Anforderungen erfüllt';
  }

  @override
  String get certCompletionTitle => 'Abschlusszertifikat';

  @override
  String get certCompletionSubtitle => 'Kursabschlusszertifikat';

  @override
  String get certAnnounceStudent =>
      'EducationLab Learning Academy bestätigt hiermit, dass:';

  @override
  String get certCompletionRequirementsMet =>
      'alle Anforderungen des Schulungskurses erfolgreich erfüllt hat:';

  @override
  String certIssueDateText(String date) {
    return 'Ausstellungsdatum: $date';
  }

  @override
  String certIdNumberText(String code) {
    return 'Zertifikats-ID: $code';
  }

  @override
  String get certPlatformManagement => 'Plattformverwaltung';

  @override
  String get certInstructorRoleTitle => 'Kursdozent';

  @override
  String get commonLoading => 'Wird geladen...';

  @override
  String get homeGuestTagline =>
      'Intelligente Lern- und Weiterbildungsplattform';

  @override
  String get catTagHighestDemand => 'Höchste Nachfrage';

  @override
  String get catTagMostPopular => 'Beliebteste';

  @override
  String get catTagTrending => 'Im Trend';

  @override
  String get catTagFastestGrowing => 'Am schnellsten wachsend';

  @override
  String get catTagHighDemand => 'Sehr gefragt';

  @override
  String get catTagTopRated => 'Bestbewertet';

  @override
  String get catTagEssential => 'Sehr wichtig';

  @override
  String get catTagAdvanced => 'Fortgeschritten';

  @override
  String get catTagEntrepreneurs => 'Unternehmer';

  @override
  String get catTagSalesGrowth => 'Umsatzwachstum';

  @override
  String get catDevTitle => 'Programmierung & Softwareentwicklung';

  @override
  String get catDevSubtitle => 'Software-Engineering, Systeme & Algorithmen';

  @override
  String get catWebTitle => 'Webentwicklung';

  @override
  String get catWebSubtitle => 'Frontend-, Backend- & Fullstack-Web';

  @override
  String get catMobileTitle => 'Mobile App-Entwicklung';

  @override
  String get catMobileSubtitle => 'Flutter-, iOS- & Android-Apps';

  @override
  String get catAiTitle => 'Künstliche Intelligenz';

  @override
  String get catAiSubtitle => 'Maschinelles Lernen, Deep Learning & KI';

  @override
  String get catDataTitle => 'Datenwissenschaft & Analytik';

  @override
  String get catDataSubtitle => 'Datenanalyse, Statistik & Big Data';

  @override
  String get catDesignTitle => 'UI/UX- & Produktdesign';

  @override
  String get catDesignSubtitle => 'UI/UX, Prototyping & Produktdesign';

  @override
  String get catSecurityTitle => 'Cybersicherheit & Netzwerke';

  @override
  String get catSecuritySubtitle =>
      'Cybersicherheit, Ethical Hacking & Netzwerke';

  @override
  String get catCloudTitle => 'Cloud Computing & DevOps';

  @override
  String get catCloudSubtitle => 'Cloud-Infrastruktur, DevOps & CI/CD';

  @override
  String get catBusinessTitle => 'Betriebswirtschaft & Projektmanagement';

  @override
  String get catBusinessSubtitle => 'Unternehmertum, Agile & Führung';

  @override
  String get catMarketingTitle => 'Digitales Marketing';

  @override
  String get catMarketingSubtitle =>
      'Digitales Marketing, SEO & Wachstumsstrategien';

  @override
  String get timeJustNow => 'Gerade eben';

  @override
  String timeMinutesAgo(String count) {
    return 'vor $count Min.';
  }

  @override
  String timeHoursAgo(String count) {
    return 'vor $count Std.';
  }

  @override
  String timeDaysAgo(String count) {
    return 'vor $count Tagen';
  }

  @override
  String timeWeeksAgo(String count) {
    return 'vor $count Wochen';
  }

  @override
  String timeMonthsAgo(String count) {
    return 'vor $count Monaten';
  }

  @override
  String wishlistLecturesCount(String count) {
    return '$count Lektionen';
  }

  @override
  String get instructorProfileTitle => 'Dozentenprofil';

  @override
  String instructorProfileLinkCopied(String name) {
    return 'Link für $name in die Zwischenablage kopiert';
  }

  @override
  String get instructorDefaultName => 'Dozent';

  @override
  String get instructorProfileBadge => 'DOZENT';

  @override
  String get instructorProfileTotalStudents => 'Teilnehmer insgesamt';

  @override
  String get instructorProfileRating => 'Dozentenbewertung';

  @override
  String get instructorProfileCourses => 'Kurse';

  @override
  String get instructorProfileShare => 'Profil teilen';

  @override
  String get instructorProfileLinkOpenError =>
      'Link konnte nicht geöffnet werden, in die Zwischenablage kopiert';

  @override
  String get instructorProfileWebsite => 'Webseite';

  @override
  String get instructorProfileAboutMe => 'Über mich';

  @override
  String get instructorProfileShowLess => 'Weniger anzeigen';

  @override
  String get instructorProfileShowMore => 'Mehr anzeigen';

  @override
  String get instructorProfileExpertise => 'Fachgebiete';

  @override
  String get instructorProfileSortAll => 'Alle';

  @override
  String get instructorProfileSortTopRated => 'Bestbewertet';

  @override
  String get instructorProfileSortPopular => 'Beliebt';

  @override
  String get instructorProfileSortNewest => 'Neueste';

  @override
  String get instructorProfileCoursesTitle => 'Kurse des Dozenten';

  @override
  String get instructorProfileNoCoursesFilter =>
      'Keine Kurse für diesen Filter gefunden';

  @override
  String instructorProfileLoadMoreCourses(String count) {
    return 'Weitere Kurse laden (noch $count)';
  }

  @override
  String get instructorProfileLoadingMoreCourses =>
      'Weitere Kurse werden geladen...';

  @override
  String instructorProfileAllCoursesLoaded(String count) {
    return 'Alle $count Kurse geladen';
  }

  @override
  String get instructorProfileStudentFeedback => 'Feedback der Teilnehmer';

  @override
  String instructorProfileReviewsCount(String count) {
    return '$count Bewertungen';
  }

  @override
  String instructorProfileBasedOnReviews(String count) {
    return 'Basierend auf $count Bewertungen';
  }

  @override
  String get instructorProfileRecentReviews => 'Aktuelle Bewertungen';

  @override
  String instructorProfileLoadMoreReviews(String count) {
    return 'Weitere Bewertungen laden (noch $count)';
  }

  @override
  String get instructorProfileLoadingMoreReviews =>
      'Weitere Bewertungen werden geladen...';

  @override
  String instructorProfileAllReviewsLoaded(String count) {
    return 'Alle $count Bewertungen geladen';
  }

  @override
  String get instructorProfileNoReviewsYet =>
      'Noch keine schriftlichen Bewertungen';

  @override
  String get instructorProfileRatingDesc =>
      'Die Bewertung basiert auf den Gesamtbewertungen der Teilnehmer aller Dozentenkurse';

  @override
  String get instructorProfileLoadError =>
      'Fehler beim Laden der Dozentendetails, bitte versuchen Sie es später erneut';

  @override
  String get instructorProfileDefaultStudentName => 'Teilnehmer';

  @override
  String get instructorProfileDefaultHeadline =>
      'Senior-Dozent & zertifizierter Experte';

  @override
  String get instructorProfileDefaultBio =>
      'Zertifizierter Software-Ingenieur und Fachdozent mit umfassender Erfahrung in der Entwicklung skalierbarer Softwaresysteme und mobiler Anwendungen.\nHat weltweit Tausende von Studenten und Ingenieuren ausgebildet und vermittelt professionelle Inhalte mit Fokus auf Clean Code, Clean Architecture und moderne, skalierbare Lösungen.';

  @override
  String get supportNewChat => 'Neuer Chat';

  @override
  String get supportNoChatsTitle => 'Noch keine Support-Chats';

  @override
  String get supportNoChatsDesc =>
      'Unser Support-Team steht rund um die Uhr bereit, um Ihnen bei allen Fragen zu helfen';

  @override
  String get supportStartNewConversation => 'Neue Unterhaltung beginnen';

  @override
  String get supportNoMessagesYet => 'Noch keine Nachrichten';

  @override
  String get supportRetry => 'Erneut versuchen';

  @override
  String get supportOpenTicket => 'Offenes Ticket';

  @override
  String get supportClosedTicket => 'Geschlossenes Ticket';

  @override
  String get supportCloseAction => 'Schließen';

  @override
  String get supportReopenAction => 'Wiedereröffnen';

  @override
  String get supportNoMessagesInChat => 'Noch keine Nachrichten in diesem Chat';

  @override
  String get supportYou => 'Sie';

  @override
  String get supportTeam => 'Support-Team';

  @override
  String get supportTypeMessageHint => 'Schreiben Sie Ihre Nachricht hier...';

  @override
  String get supportConversationClosedNotice =>
      'Diese Unterhaltung ist derzeit geschlossen.';

  @override
  String get supportCloseDialogTitle => 'Unterhaltung schließen?';

  @override
  String get supportCloseDialogDesc =>
      'Möchten Sie diesen Chat wirklich schließen? Sie können ihn jederzeit wieder öffnen, um weiterzuschreiben.';

  @override
  String get supportCancel => 'Abbrechen';

  @override
  String get supportYesClose => 'Ja, schließen';

  @override
  String get supportNewChatTitle => 'Neuer Support-Chat';

  @override
  String get supportNewChatSubtitle => 'Unser Team ist für Sie da';

  @override
  String get supportSubjectLabel => 'Betreff';

  @override
  String get supportSubjectHint => 'z.B. Kursanfrage, Zahlungsproblem...';

  @override
  String get supportMessageLabel => 'Nachricht';

  @override
  String get supportMessageHint =>
      'Beschreiben Sie Ihr Anliegen ausführlich...';

  @override
  String get supportMessageRequired => 'Bitte geben Sie eine Nachricht ein';

  @override
  String get supportStartConversationBtn => 'Unterhaltung beginnen';

  @override
  String get supportCreateError =>
      'Fehler beim Erstellen der Unterhaltung, bitte versuchen Sie es später erneut';

  @override
  String get supportTopicCourse => 'Kursanfrage';

  @override
  String get supportTopicPayment => 'Zahlungsproblem';

  @override
  String get supportTopicCertificates => 'Zertifikate';

  @override
  String get supportTopicTech => 'Technisches Problem';

  @override
  String get supportTopicGeneral => 'Allgemeine Anfrage';

  @override
  String get cartGuestTitle => 'Anmelden, um den Warenkorb anzuzeigen';

  @override
  String get cartGuestSubtitle =>
      'Bitte melden Sie sich an, um auf Ihren Warenkorb zuzugreifen und Kurse zu kaufen.';

  @override
  String get wishlistGuestTitle => 'Anmelden, um die Wunschliste anzuzeigen';

  @override
  String get wishlistGuestSubtitle =>
      'Bitte melden Sie sich an, um Ihre Wunschliste zu verwalten und gespeicherte Kurse zu sehen.';

  @override
  String get courseDetailsLoginRequiredTitle => 'Anmeldung erforderlich';

  @override
  String get courseDetailsLoginRequiredDesc =>
      'Sie müssen sich zuerst anmelden, um diesen Kurs zu kaufen und Ihren Lernfortschritt zu speichern.';

  @override
  String get courseDetailsProceedToLogin => 'Zur Anmeldung';

  @override
  String get messagesGuestTitle => 'Anmelden, um Nachrichten anzuzeigen';

  @override
  String get messagesGuestSubtitle =>
      'Bitte melden Sie sich an, um auf Support-Nachrichten zuzugreifen.';

  @override
  String get notificationsGuestTitle =>
      'Anmelden, um Benachrichtigungen anzuzeigen';

  @override
  String get notificationsGuestSubtitle =>
      'Bitte melden Sie sich an, um Benachrichtigungen zu Ihrem Konto und Ihren Kursen zu sehen.';

  @override
  String get legalTitle => 'Über uns & Rechtliches';

  @override
  String get legalTabAbout => 'Über EduLab';

  @override
  String get legalTabPrivacy => 'Datenschutz';

  @override
  String get legalTabTerms => 'AGB';

  @override
  String get legalUpdated => 'Aktualisiert:';

  @override
  String get legalNeedHelpTitle => 'Brauchen Sie Hilfe oder haben Sie Fragen?';

  @override
  String get legalNeedHelpDesc =>
      'Das EduLab-Supportteam ist rund um die Uhr für Sie da. Kontaktieren Sie uns direkt per E-Mail.';

  @override
  String get legalEmailCopied => 'Support-E-Mail in die Zwischenablage kopiert';

  @override
  String get legalNoContent => 'Derzeit kein Inhalt verfügbar';
}

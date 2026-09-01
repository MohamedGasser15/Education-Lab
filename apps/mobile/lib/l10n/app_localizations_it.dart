// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get onboardingSkip => 'Salta';

  @override
  String get onboardingTitle1 => 'Benvenuto su EduLab';

  @override
  String get onboardingSubtitle1 =>
      'La tua piattaforma ideale per l\'apprendimento interattivo e la crescita professionale.';

  @override
  String get onboardingTitle2 => 'Impara dai migliori docenti';

  @override
  String get onboardingSubtitle2 =>
      'Migliaia di corsi professionali in programmazione, design, business e data science.';

  @override
  String get onboardingTitle3 => 'Certificati e successo garantito';

  @override
  String get onboardingSubtitle3 =>
      'Traccia i tuoi progressi, supera i test e ottieni certificati riconosciuti.';

  @override
  String get onboardingNext => 'Avanti';

  @override
  String get onboardingStart => 'Inizia ora';

  @override
  String get splashAppName => 'Education Lab';

  @override
  String get splashTagline => 'Piattaforma di Apprendimento Intelligente';

  @override
  String get loginTagline =>
      'Benvenuto sulla piattaforma di apprendimento intelligente';

  @override
  String get loginAppName => 'EduLab';

  @override
  String get loginTabLogin => 'Accedi';

  @override
  String get loginTabRegister => 'Registrati';

  @override
  String get loginEmailLabel => 'Email';

  @override
  String get loginEmailHint => 'esempio@email.it';

  @override
  String get loginPasswordLabel => 'Password';

  @override
  String get loginPasswordHint => '••••••';

  @override
  String get loginForgotPassword => 'Password dimenticata?';

  @override
  String get loginSubmit => 'Accedi';

  @override
  String get loginSubmitLoading => 'Accesso in corso';

  @override
  String get loginGuest => 'Continua come ospite';

  @override
  String get loginOr => 'oppure';

  @override
  String get loginEmailRequired => 'L\'email è obbligatoria';

  @override
  String get loginEmailInvalid => 'Inserisci un\'email valida';

  @override
  String get loginPasswordRequired => 'La password è obbligatoria';

  @override
  String get registerStepEmail => 'Email';

  @override
  String get registerStepCode => 'Codice';

  @override
  String get registerStepData => 'Dati';

  @override
  String get registerSendCodeInfo =>
      'Ti invieremo un codice di attivazione via email';

  @override
  String get registerSendCode => 'Invia codice di attivazione';

  @override
  String get registerVerifying => 'Verifica in corso';

  @override
  String get registerCodeSentTo => 'Codice inviato a:';

  @override
  String get registerResendCode => 'Reinvia codice';

  @override
  String get registerBack => 'Indietro';

  @override
  String get registerVerifyCode => 'Verifica codice';

  @override
  String get registerCodeIncomplete => 'Inserisci il codice completo a 6 cifre';

  @override
  String get registerFullNameLabel => 'Nome completo';

  @override
  String get registerFullNameHint => 'Il tuo nome completo';

  @override
  String get registerPasswordHint =>
      'Almeno 8 caratteri, una maiuscola e un numero';

  @override
  String get registerConfirmLabel => 'Conferma password';

  @override
  String get registerConfirmHint => 'Ripeti la password';

  @override
  String get registerSubmit => 'Crea account';

  @override
  String get registerSubmitLoading => 'Creazione account';

  @override
  String get registerSuccess => 'Account creato con successo';

  @override
  String get registerNameRequired => 'Il nome completo è obbligatorio';

  @override
  String get registerNameMinLength => 'Il nome deve avere almeno 6 caratteri';

  @override
  String get registerPasswordMinLength =>
      'La password deve avere almeno 8 caratteri';

  @override
  String get registerPasswordUppercase =>
      'La password deve contenere almeno una maiuscola';

  @override
  String get registerPasswordNumber =>
      'La password deve contenere almeno un numero';

  @override
  String get registerConfirmRequired =>
      'La conferma della password è obbligatoria';

  @override
  String get registerConfirmMismatch => 'Le password non corrispondono';

  @override
  String get networkError => 'Errore di connessione, riprova';

  @override
  String homeGreeting(String name) {
    return 'Ciao, $name!';
  }

  @override
  String get homeSubtitle => 'Cosa vuoi imparare oggi?';

  @override
  String get homeSearchHint => 'Cerca un corso o una competenza...';

  @override
  String get homeSectionContinue => 'Continua a imparare';

  @override
  String get homeSectionRecommended => 'Consigliati per te';

  @override
  String get homeSectionPopular => 'I più popolari';

  @override
  String get homeSectionTopRated => 'I più votati';

  @override
  String get homeSectionByCategory => 'Per categoria';

  @override
  String get homeHeroTitle => 'Scopri le offerte ora';

  @override
  String get homeHeroSubtitle => 'Fino al 70% di sconto sui corsi principali';

  @override
  String get homeHeroButton => 'Scopri ora';

  @override
  String get homeViewAll => 'Vedi tutti';

  @override
  String get homeProgressLabel => 'Completato';

  @override
  String get exploreTitle => 'Esplora Corsi';

  @override
  String get exploreSearchHint => 'Cerca corso, competenza o docente...';

  @override
  String get exploreAllCategories => 'Tutte le categorie';

  @override
  String get exploreFilter => 'Filtra';

  @override
  String get exploreSort => 'Ordina';

  @override
  String get exploreNoResults => 'Nessun risultato trovato';

  @override
  String get exploreNoResultsHint => 'Prova con altre parole chiave o filtri';

  @override
  String exploreCoursesCount(int count) {
    return '$count corsi';
  }

  @override
  String get exploreFilterTitle => 'Filtra risultati';

  @override
  String get exploreFilterApply => 'Applica filtro';

  @override
  String get exploreFilterReset => 'Reimposta';

  @override
  String get exploreFilterPrice => 'Prezzo';

  @override
  String get exploreFilterLevel => 'Livello';

  @override
  String get exploreFilterRating => 'Valutazione';

  @override
  String get exploreFilterDuration => 'Durata';

  @override
  String get exploreSortTitle => 'Ordina per';

  @override
  String get exploreSortRelevance => 'Rilevanza';

  @override
  String get exploreSortNewest => 'Più recenti';

  @override
  String get exploreSortPopular => 'Più popolari';

  @override
  String get exploreSortRating => 'Miglior valutazione';

  @override
  String get exploreSortPriceLow => 'Prezzo: dal più basso';

  @override
  String get exploreSortPriceHigh => 'Prezzo: dal più alto';

  @override
  String get explorePriceFree => 'Gratis';

  @override
  String get exploreLevelBeginner => 'Principiante';

  @override
  String get exploreLevelIntermediate => 'Intermedio';

  @override
  String get exploreLevelAdvanced => 'Avanzato';

  @override
  String get learningTitle => 'I Miei Corsi';

  @override
  String get learningTabInProgress => 'In corso';

  @override
  String get learningTabCompleted => 'Completati';

  @override
  String get learningTabSaved => 'Salvati';

  @override
  String get learningEmpty => 'Nessun corso presente';

  @override
  String get learningEmptyHint => 'Inizia a esplorare i corsi adesso';

  @override
  String get learningExploreButton => 'Esplora Corsi';

  @override
  String learningProgress(int percent) {
    return '$percent% completato';
  }

  @override
  String get learningContinue => 'Continua';

  @override
  String get learningViewCertificate => 'Vedi Certificato';

  @override
  String get learningReview => 'Valuta corso';

  @override
  String get learningLesson => 'Lezione';

  @override
  String get learningLessons => 'Lezioni';

  @override
  String get cartTitle => 'Carrello';

  @override
  String get cartEmpty => 'Il tuo carrello è vuoto';

  @override
  String get cartEmptyHint => 'Aggiungi corsi per iniziare a imparare';

  @override
  String get cartExploreButton => 'Esplora Corsi';

  @override
  String get cartPromoPlaceholder => 'Codice promozionale';

  @override
  String get cartPromoApply => 'Applica';

  @override
  String get cartPromoInvalid => 'Codice promozionale non valido';

  @override
  String get cartSummary => 'Riepilogo ordine';

  @override
  String get cartSubtotal => 'Subtotale';

  @override
  String get cartDiscount => 'Sconto';

  @override
  String get cartTotal => 'Totale';

  @override
  String get cartCheckout => 'Vai alla cassa';

  @override
  String cartCourses(int count) {
    return '$count corsi';
  }

  @override
  String get cartRemove => 'Rimuovi';

  @override
  String get cartGuarantee => 'Garanzia soddisfatti o rimborsati di 30 giorni';

  @override
  String get checkoutTitle => 'Cassa & Pagamento';

  @override
  String get checkoutStepPayment => 'Pagamento';

  @override
  String get checkoutStepReview => 'Riepilogo';

  @override
  String get checkoutStepConfirm => 'Conferma';

  @override
  String get checkoutOrderSummary => 'Riepilogo ordine';

  @override
  String get checkoutTotal => 'Totale';

  @override
  String get checkoutPayNow => 'Paga ora';

  @override
  String get checkoutBack => 'Indietro';

  @override
  String get checkoutNext => 'Avanti';

  @override
  String get checkoutSecureSSL =>
      'Pagamento sicuro con crittografia SSL a 256 bit';

  @override
  String get checkoutSuccessTitle => 'Acquisto completato!';

  @override
  String get checkoutSuccessSubtitle => 'Ora puoi accedere al tuo corso';

  @override
  String get checkoutGoToLearning => 'Vai ai miei corsi';

  @override
  String get checkoutPaymentMethod => 'Metodo di pagamento';

  @override
  String get checkoutCardNumber => 'Numero di carta';

  @override
  String get checkoutCardName => 'Titolare della carta';

  @override
  String get checkoutCardExpiry => 'Data di scadenza';

  @override
  String get checkoutCardCVV => 'CVV';

  @override
  String get courseDetailsEnroll => 'Iscriviti ora';

  @override
  String get courseDetailsBuyNow => 'Acquista ora';

  @override
  String get courseDetailsAddToCart => 'Aggiungi al carrello';

  @override
  String get courseDetailsAddedToCart => 'Aggiunto al carrello';

  @override
  String get courseDetailsAlreadyEnrolled => 'Già iscritto';

  @override
  String get courseDetailsGoToCourse => 'Vai al corso';

  @override
  String get courseDetailsFree => 'Gratis';

  @override
  String courseDetailsStudents(String count) {
    return '$count studenti';
  }

  @override
  String get courseDetailsRating => 'Valutazione';

  @override
  String get courseDetailsReviews => 'recensioni';

  @override
  String get courseDetailsLastUpdated => 'Ultimo aggiornamento';

  @override
  String get courseDetailsCurriculum => 'Contenuto del corso';

  @override
  String get courseDetailsSection => 'sezione';

  @override
  String get courseDetailsLessons => 'lezioni';

  @override
  String get courseDetailsInstructor => 'Docente';

  @override
  String get courseDetailsStudentsLabel => 'Studenti';

  @override
  String get courseDetailsCoursesLabel => 'Corsi';

  @override
  String get courseDetailsReviewsLabel => 'Recensioni';

  @override
  String get courseDetailsReviewsTitle => 'Recensioni degli studenti';

  @override
  String get courseDetailsWhatLearn => 'Cosa imparerai';

  @override
  String get courseDetailsRequirements => 'Requisiti';

  @override
  String get courseDetailsDescription => 'Descrizione del corso';

  @override
  String get courseDetailsIncludesTitle => 'Questo corso include';

  @override
  String get courseDetailsHoursVideo => 'ore di video';

  @override
  String get courseDetailsArticles => 'articoli';

  @override
  String get courseDetailsMobileAccess => 'Accesso su dispositivi mobili';

  @override
  String get courseDetailsCertificate => 'Certificato di completamento';

  @override
  String get courseDetailsLifetimeAccess => 'Accesso a vita';

  @override
  String get lessonPlayerNotes => 'Le mie note';

  @override
  String get lessonPlayerResources => 'Risorse';

  @override
  String get lessonPlayerDiscussion => 'Discussione';

  @override
  String get lessonPlayerPrev => 'Precedente';

  @override
  String get lessonPlayerNext => 'Successivo';

  @override
  String get lessonPlayerSpeed => 'Velocità';

  @override
  String get lessonPlayerQuality => 'Qualità';

  @override
  String get lessonPlayerCompleted => 'Lezione completata';

  @override
  String get certificateTitle => 'Certificato di Completamento';

  @override
  String get certificatePresentedTo => 'Conferito a';

  @override
  String get certificateCompletedCourse => 'per aver completato con successo';

  @override
  String get certificateIssuedOn => 'Data di rilascio';

  @override
  String get certificateVerificationId => 'ID di verifica';

  @override
  String get certificateDownloadPDF => 'Scarica PDF';

  @override
  String get certificateDownloadPNG => 'Scarica immagine';

  @override
  String get certificateCopyLink => 'Copia link di verifica';

  @override
  String get certificateLinkCopied => 'Link copiato';

  @override
  String get profileTitle => 'Profilo';

  @override
  String get profileEditProfile => 'Modifica Profilo';

  @override
  String get profileCourses => 'I miei Corsi';

  @override
  String get profileCertificates => 'Certificati';

  @override
  String get profilePoints => 'Punti';

  @override
  String get profileFollowers => 'Follower';

  @override
  String get profileFollowing => 'Seguiti';

  @override
  String get profileBio => 'Biografia';

  @override
  String get profileInstructor => 'Docente';

  @override
  String get profileStudent => 'Studente';

  @override
  String get profileLevel => 'Livello';

  @override
  String get profileJoined => 'Iscritto dal';

  @override
  String get profileShareProfile => 'Condividi profilo';

  @override
  String get profileMenuLearning => 'I miei Corsi';

  @override
  String get profileMenuCertificates => 'I miei Certificati';

  @override
  String get profileMenuPurchaseHistory => 'Cronologia Acquisti';

  @override
  String get profileMenuTeachApplication => 'Insegna su EduLab';

  @override
  String get profileMenuAccountSecurity => 'Sicurezza Account';

  @override
  String get profileMenuNotifications => 'Notifiche';

  @override
  String get profileMenuMessages => 'Messaggi';

  @override
  String get profileMenuSettings => 'Impostazioni';

  @override
  String get profileMenuSchedule => 'Il mio Calendario';

  @override
  String get profileMenuAssignments => 'Compiti';

  @override
  String get profileMenuQuiz => 'Quiz';

  @override
  String get profileMenuLogout => 'Esci';

  @override
  String get profileLogoutConfirm => 'Sei sicuro di voler uscire?';

  @override
  String get profileLogoutYes => 'Sì, esci';

  @override
  String get profileLogoutNo => 'Annulla';

  @override
  String get editProfileTitle => 'Modifica Profilo';

  @override
  String get editProfileSave => 'Salva modifiche';

  @override
  String get editProfileFullName => 'Nome completo';

  @override
  String get editProfileBio => 'Biografia';

  @override
  String get editProfileEmail => 'Email';

  @override
  String get editProfilePhone => 'Telefono';

  @override
  String get editProfileWebsite => 'Sito web';

  @override
  String get editProfileSaved => 'Modifiche salvate con successo';

  @override
  String get accountSecurityTitle => 'Sicurezza Account';

  @override
  String get accountSecurityChangePassword => 'Cambia password';

  @override
  String get accountSecurityTwoFactor => 'Autenticazione a due fattori';

  @override
  String get accountSecurityActiveSessions => 'Sessioni attive';

  @override
  String get accountSecurityDeleteAccount => 'Elimina account';

  @override
  String get purchaseHistoryTitle => 'Cronologia Acquisti';

  @override
  String get purchaseHistoryEmpty => 'Nessun acquisto effettuato';

  @override
  String get purchaseHistoryGuarantee => 'Garanzia di rimborso entro 30 giorni';

  @override
  String get purchaseHistoryDate => 'Data transazione';

  @override
  String get purchaseHistoryStatus => 'Stato';

  @override
  String get purchaseHistoryAmount => 'Importo';

  @override
  String get purchaseHistoryCompleted => 'Completato';

  @override
  String get purchaseHistoryRefunded => 'Rimborsato';

  @override
  String get teachApplicationTitle => 'Insegna su EduLab';

  @override
  String get teachApplicationSubmit => 'Invia candidatura';

  @override
  String get teachApplicationSent =>
      'La tua candidatura è stata inviata con successo';

  @override
  String get notificationsTitle => 'Notifiche';

  @override
  String get notificationsMarkAllRead => 'Segna tutte come lette';

  @override
  String get notificationsMarkAllReadSnackbar =>
      'Tutte le notifiche sono state lette';

  @override
  String get notificationsEmpty => 'Nessuna notifica';

  @override
  String get notification1Title => 'Promemoria: Continua il corso';

  @override
  String get notification1Message =>
      'Hai una nuova lezione in Flutter per Principianti';

  @override
  String get notification1Time => '5 minuti fa';

  @override
  String get notification1Action => 'Riprendi corso';

  @override
  String get notification2Title => 'Il tuo certificato è pronto!';

  @override
  String get notification2Message => 'Hai completato il corso di Design UI/UX.';

  @override
  String get notification2Time => '2 ore fa';

  @override
  String get notification2Action => 'Vedi certificato';

  @override
  String get notification3Title => 'Offerta esclusiva per te';

  @override
  String get notification3Message =>
      '70% di sconto sui corsi di programmazione';

  @override
  String get notification3Time => '1 giorno fa';

  @override
  String get notification3Action => 'Scopri offerta';

  @override
  String get notification4Title => 'Nuova risposta alla tua domanda';

  @override
  String get notification4Message => 'Il docente ha risposto alla tua domanda';

  @override
  String get notification4Time => '2 giorni fa';

  @override
  String get notification4Action => 'Vedi risposta';

  @override
  String get notification5Title => 'Aggiornamento corso';

  @override
  String get notification5Message => 'Nuovi contenuti aggiunti a Python';

  @override
  String get notification5Time => '3 giorni fa';

  @override
  String get messagesTitle => 'Messaggi';

  @override
  String get settingsTitle => 'Impostazioni e Preferenze';

  @override
  String get settingsVideoDownload => 'Video e Download';

  @override
  String get settingsDownloadQuality => 'Qualità video predefinita';

  @override
  String get settingsWifiOnly => 'Scarica solo con Wi-Fi';

  @override
  String get settingsNotifications => 'Notifiche e Avvisi';

  @override
  String get settingsCourseNotifications => 'Notifiche su corsi e messaggi';

  @override
  String get settingsPromoNotifications => 'Offerte e sconti esclusivi';

  @override
  String get settingsAppearance => 'Aspetto e Lingua';

  @override
  String get settingsDarkMode => 'Tema Scuro';

  @override
  String get settingsDarkModeEnabled => 'Attivo (risparmio batteria)';

  @override
  String get settingsDarkModeDisabled => 'Disattivato (tema chiaro)';

  @override
  String get settingsLanguage => 'Lingua dell\'app';

  @override
  String get settingsStorage => 'Archiviazione e Cache';

  @override
  String get settingsClearCache => 'Svuota cache';

  @override
  String get settingsClearCacheSuccess => 'Cache svuotata con successo';

  @override
  String get settingsHelp => 'Info e Regolamenti';

  @override
  String get settingsHelpCenter => 'Centro assistenza e FAQ';

  @override
  String get settingsTermsPrivacy => 'Termini di servizio e Privacy';

  @override
  String get settingsAbout => 'Informazioni su EduLab';

  @override
  String get settingsVersion => 'Versione v1.0.0';

  @override
  String get quizTitle => 'Quiz';

  @override
  String get quizNext => 'Prossima domanda';

  @override
  String get quizSubmit => 'Invia quiz';

  @override
  String get quizScore => 'Punteggio quiz';

  @override
  String get quizCorrectAnswers => 'Risposte corrette';

  @override
  String get scheduleTitle => 'Il mio Calendario';

  @override
  String get scheduleEmpty => 'Nessuna sessione programmata';

  @override
  String get scheduleJoin => 'Partecipa alla sessione';

  @override
  String get scheduleReminder => 'Promemoria';

  @override
  String get assignmentsTitle => 'Compiti';

  @override
  String get assignmentsEmpty => 'Nessun compito presente';

  @override
  String get assignmentsSubmit => 'Invia compito';

  @override
  String get assignmentsDue => 'Scadenza';

  @override
  String get assignmentsSubmitted => 'Inviato';

  @override
  String get assignmentsPending => 'In attesa';

  @override
  String get languageArabic => 'Arabo';

  @override
  String get languageEnglish => 'Inglese';

  @override
  String get languageDialogTitle => 'Seleziona lingua';

  @override
  String get languageSelect => 'Seleziona';

  @override
  String get generalCancel => 'Annulla';

  @override
  String get generalConfirm => 'Conferma';

  @override
  String get generalSave => 'Salva';

  @override
  String get generalDelete => 'Elimina';

  @override
  String get generalEdit => 'Modifica';

  @override
  String get generalClose => 'Chiudi';

  @override
  String get generalBack => 'Indietro';

  @override
  String get generalDone => 'Fatto';

  @override
  String get generalOk => 'OK';

  @override
  String get generalYes => 'Sì';

  @override
  String get generalNo => 'No';

  @override
  String get generalLoading => 'Caricamento...';

  @override
  String get generalError => 'Si è verificato un errore';

  @override
  String get generalRetry => 'Riprova';

  @override
  String get generalNoInternet => 'Nessuna connessione internet';

  @override
  String get generalFree => 'Gratis';

  @override
  String get generalRating => 'Valutazione';

  @override
  String get generalStudents => 'Studenti';

  @override
  String get generalHours => 'Ore';

  @override
  String get generalMinutes => 'Minuti';

  @override
  String get generalBy => 'Di';

  @override
  String get navHome => 'Home';

  @override
  String get navExplore => 'Esplora';

  @override
  String get navMyCourses => 'I miei Corsi';

  @override
  String get navCart => 'Carrello';

  @override
  String get navAccount => 'Account';

  @override
  String get homeSubGreeting => 'Cosa desideri imparare oggi?';

  @override
  String get homeVisitor => 'Ospite';

  @override
  String get homePromoTitle => 'Scopri le offerte ora';

  @override
  String get homePromoSubtitle => 'Fino al 70% di sconto sui corsi principali';

  @override
  String get homePromoButton => 'Scopri ora';

  @override
  String get homePromoBadge => 'Offerta esclusiva';

  @override
  String get homeContinueLearning => 'Continua a imparare';

  @override
  String get homeMyCoursesLink => 'I miei corsi';

  @override
  String get homeLesson => 'lezione';

  @override
  String homeStudentsCount(String count) {
    return '$count studenti';
  }

  @override
  String get homeRecommendedTitle => 'Consigliati per te';

  @override
  String get homeRecommendedSubtitle => 'Personalizzati sui tuoi interessi';

  @override
  String get homeBestsellersTitle => 'I più venduti';

  @override
  String get homeBestsellersSubtitle => 'I corsi più popolari e apprezzati';

  @override
  String get homeNewCoursesTitle => 'Nuovi corsi';

  @override
  String get homeNewCoursesSubtitle => 'Contenuti freschi e aggiornati';

  @override
  String get homePopularTopicsTitle => 'Argomenti popolari';

  @override
  String get homePopularTopicsSubtitle =>
      'Inizia a imparare le competenze più richieste';

  @override
  String get homeTopInstructorsTitle => 'Migliori docenti';

  @override
  String get homeTopInstructorsSubtitle => 'Impara da esperti certificati';

  @override
  String get homeExploreCategoriesTitle => 'Esplora categorie';

  @override
  String get homeExploreCategoriesSubtitle => 'Trova il corso perfetto per te';

  @override
  String get catAll => 'Tutti';

  @override
  String get catWebDev => 'Sviluppo Web';

  @override
  String get catMobileApps => 'Applicazioni Mobili';

  @override
  String get catDataScience => 'Data Science';

  @override
  String get catUIUX => 'Design UI/UX';

  @override
  String get catBusiness => 'Business';

  @override
  String get catAI => 'Intelligenza Artificiale';

  @override
  String get catCyberSecurity => 'Sicurezza Informatica';

  @override
  String get exploreNoResultsTitle => 'Nessun risultato trovato';

  @override
  String get exploreNoResultsSubtitle =>
      'Prova con altre parole chiave o filtri';

  @override
  String get exploreRecentSearches => 'Ricerche recenti';

  @override
  String get exploreTopSearches => 'Più cercati';

  @override
  String get exploreBrowseCategories => 'Sfoglia categorie';

  @override
  String get exploreBrowseCategoriesSubtitle => 'Trova il corso adatto a te';

  @override
  String get exploreBackToAll => 'Torna a tutti';

  @override
  String get exploreClearAll => 'Cancella tutto';

  @override
  String get exploreAvailableResults => 'risultati disponibili';

  @override
  String get exploreFilterBestseller => 'Bestseller';

  @override
  String get exploreFilterTopRated => 'Più votati';

  @override
  String get exploreFilterUnder50 => 'Meno di 50€';

  @override
  String get learningHeroTitle => 'Continua il tuo percorso di apprendimento';

  @override
  String get learningSearchHint => 'Cerca tra i tuoi corsi...';

  @override
  String get learningFilterAll => 'Tutti';

  @override
  String get learningFilterInProgress => 'In corso';

  @override
  String get learningFilterCompleted => 'Completati';

  @override
  String get learningFilterDownloaded => 'Scaricati';

  @override
  String get learningEmptyTitle => 'Nessun corso presente';

  @override
  String get learningEmptySubtitle => 'Inizia a esplorare i corsi adesso';

  @override
  String get learningEmptySearch => 'Nessun risultato per la ricerca';

  @override
  String get learningCompleted => 'Completato';

  @override
  String get learningCompletedBadge => 'Completato';

  @override
  String learningLecturesCount(int count) {
    return '$count lezioni';
  }

  @override
  String get cartEmptyTitle => 'Il tuo carrello è vuoto';

  @override
  String get cartEmptySubtitle => 'Aggiungi corsi per iniziare a imparare';

  @override
  String get cartCouponHint => 'Inserisci codice sconto';

  @override
  String get cartCouponApply => 'Applica';

  @override
  String get cartCouponInvalid => 'Codice non valido';

  @override
  String get cartCouponApplied => 'Codice promozionale applicato';

  @override
  String get cartCouponDiscount => 'Sconto codice';

  @override
  String get cartCouponsTitle => 'Buoni sconto';

  @override
  String get cartOrderSummary => 'Riepilogo ordine';

  @override
  String get cartOriginalPrice => 'Prezzo originale';

  @override
  String get cartPlatformDiscount => 'Sconto piattaforma';

  @override
  String get cartFinalTotal => 'Totale finale';

  @override
  String cartItemsCount(int count) {
    return '$count corsi';
  }

  @override
  String get cartRemovedSnackbar => 'Corso rimosso dal carrello';

  @override
  String get cartUndo => 'Annulla';

  @override
  String get cartAddButton => 'Aggiungi al carrello';

  @override
  String get cartAddedSnackbar => 'Aggiunto al carrello';

  @override
  String get cartAlreadyInCart => 'Già nel carrello';

  @override
  String get cartCheckoutButton => 'Procedi all\'acquisto';

  @override
  String get cartRecommendedTitle => 'Potrebbe piacerti anche';

  @override
  String get cartRecommendedSubtitle => 'Corsi consigliati in base al carrello';

  @override
  String get checkoutCreditCard => 'Carta di credito';

  @override
  String get checkoutSelectPayment => 'Seleziona metodo di pagamento';

  @override
  String get checkoutCardNumberLabel => 'Numero di carta';

  @override
  String get checkoutCardHolderLabel => 'Nome del titolare';

  @override
  String get checkoutExpiryLabel => 'Scadenza';

  @override
  String get checkoutCVVLabel => 'CVV';

  @override
  String get checkoutPersonalInfoTitle => 'Dati personali';

  @override
  String get checkoutFullNameLabel => 'Nome completo';

  @override
  String get checkoutFullNameHint => 'Il tuo nome completo';

  @override
  String get checkoutFullNameRequired => 'Il nome completo è obbligatorio';

  @override
  String get checkoutPhoneLabel => 'Telefono';

  @override
  String get checkoutPhoneRequired => 'Il telefono è obbligatorio';

  @override
  String get checkoutPostalLabel => 'CAP';

  @override
  String get checkoutPostalRequired => 'Il CAP è obbligatorio';

  @override
  String get checkoutBuyerInfo => 'Dati acquirente';

  @override
  String get checkoutSaveInfo => 'Salva dati per la prossima volta';

  @override
  String get checkoutMoneyBackGuarantee =>
      'Garanzia di rimborso entro 30 giorni';

  @override
  String get checkoutContinueToPayment => 'Continua al pagamento';

  @override
  String get checkoutContinueToReview => 'Continua al riepilogo';

  @override
  String get checkoutReviewConfirm => 'Verifica e conferma';

  @override
  String get checkoutStartLearning => 'Inizia a imparare';

  @override
  String get checkoutBackHome => 'Torna alla Home';

  @override
  String get courseDetailsTitle => 'Dettagli Corso';

  @override
  String get courseDetailsShare => 'Condividi';

  @override
  String get courseDetailsWhatYouWillLearn => 'Cosa imparerai';

  @override
  String get courseDetailsLanguage => 'Lingua';

  @override
  String get courseDetailsCreatedBy => 'Creato da';

  @override
  String get courseDetailsPreviewLesson => 'Anteprima lezione';

  @override
  String get courseDetailsHoursOnDemand => 'ore di video on demand';

  @override
  String get courseDetailsFullLifetimeAccess => 'Accesso completo a vita';

  @override
  String get courseDetailsCertifiedCertificate =>
      'Certificato di completamento ufficiale';

  @override
  String get courseDetailsComprehensiveContent => 'Contenuto completo';

  @override
  String get certTitle => 'Certificato di Completamento';

  @override
  String get certStudentNameLabel => 'Studente';

  @override
  String get certCourseLabel => 'Corso';

  @override
  String get certInstructorLabel => 'Docente';

  @override
  String get certIssueDateLabel => 'Data di emissione';

  @override
  String get certCodeLabel => 'ID certificato';

  @override
  String get certVerifiedBadge => 'Verificato';

  @override
  String get certDownloadPDF => 'Scarica PDF';

  @override
  String get certDownloadPNG => 'Scarica immagine';

  @override
  String get certCopyVerifyLink => 'Copia link di verifica';

  @override
  String get certShare => 'Condividi certificato';

  @override
  String get playerTabLessons => 'Lezioni';

  @override
  String get playerTabOverview => 'Panoramica';

  @override
  String get playerTabNotes => 'Le mie note';

  @override
  String get playerTabQnA => 'Domande e risposte';

  @override
  String get playerNextLesson => 'Lezione successiva';

  @override
  String get profileWelcome => 'Benvenuto';

  @override
  String get profileLoginPrompt => 'Accedi per visualizzare il tuo profilo';

  @override
  String get profileLoginOrRegister => 'Accedi / Registrati';

  @override
  String get profileVerifiedStudent => 'Studente verificato';

  @override
  String get profileLogout => 'Esci';

  @override
  String get profileCancel => 'Annulla';

  @override
  String get profileLogoutConfirmTitle => 'Disconnessione';

  @override
  String get profileLogoutConfirmMessage => 'Sei sicuro di voler uscire?';

  @override
  String get profileAccountSettings => 'Impostazioni account';

  @override
  String get profileEditProfileSubtitle => 'Modifica i tuoi dati';

  @override
  String get profileSecurity => 'Sicurezza account';

  @override
  String get profileSecuritySubtitle => 'Password e sicurezza';

  @override
  String get profilePurchaseHistory => 'Cronologia acquisti';

  @override
  String get profilePurchaseHistorySubtitle => 'Visualizza transazioni';

  @override
  String get profileCertificatesSubtitle => 'I tuoi certificati ottenuti';

  @override
  String get profileTeach => 'Insegna su EduLab';

  @override
  String get profileTeachSubtitle => 'Condividi le tue competenze';

  @override
  String get profilePreferences => 'Preferenze';

  @override
  String get profilePreferencesSubtitle => 'Impostazioni e aspetto';

  @override
  String get profileNotifications => 'Notifiche';

  @override
  String get profileNotificationsSubtitle => 'Gestisci avvisi';

  @override
  String get profileHelpSupport => 'Aiuto e Supporto';

  @override
  String get profileTerms => 'Termini di Servizio';

  @override
  String get profilePrivacy => 'Informativa sulla Privacy';

  @override
  String get profileAboutEduLab => 'Informazioni su EduLab';

  @override
  String get profileWishlist => 'Lista desideri';

  @override
  String get securityTitle => 'Sicurezza Account';

  @override
  String get teachTitle => 'Insegna su EduLab';

  @override
  String get notificationsTabAll => 'Tutte';

  @override
  String get notificationsTabCourses => 'Corsi';

  @override
  String get notificationsTabPromos => 'Offerte';

  @override
  String get notificationsEmptyTitle => 'Nessuna notifica';

  @override
  String get notificationsUnread => 'Non lette';

  @override
  String get wishlistTitle => 'Lista Desideri';

  @override
  String get wishlistEmptyTitle => 'La tua lista desideri è vuota';

  @override
  String get wishlistEmptySubtitle => 'Salva i corsi che ti interessano';

  @override
  String get wishlistAddToCart => 'Aggiungi al carrello';

  @override
  String get wishlistRemovedSnackbar => 'Rimosso dai desideri';

  @override
  String get homeDefaultUser => 'Studente';

  @override
  String get learningOf => 'di';

  @override
  String get cartInCartBadge => 'Nel carrello';

  @override
  String get homePromo1Badge => 'Grandi sconti • Tempo limitato';

  @override
  String get homePromo1Title => 'Inizia a imparare ai prezzi migliori';

  @override
  String get homePromo1Subtitle =>
      'Fino al 65% di sconto su corsi di programmazione, design e business.';

  @override
  String get homePromo1Button => 'Sfoglia offerte';

  @override
  String get homePromo2Badge => 'Percorsi professionali certificati';

  @override
  String get homePromo2Title => 'Preparati per il lavoro dei tuoi sogni';

  @override
  String get homePromo2Subtitle =>
      'Corsi completi da zero a esperto con progetti reali e certificazioni.';

  @override
  String get homePromo2Button => 'Esplora percorsi';

  @override
  String get homePromo3Badge => 'Istruttori ed esperti top';

  @override
  String get homePromo3Title =>
      'Impara direttamente dai professionisti del settore';

  @override
  String get homePromo3Subtitle =>
      'Contenuti sempre aggiornati sulle ultime tecnologie.';

  @override
  String get homePromo3Button => 'Inizia ora';

  @override
  String get homeSearchFilter => 'Filtra';

  @override
  String get securitySectionChangePassword => 'Cambia password';

  @override
  String get securityCurrentPasswordLabel => 'Password attuale *';

  @override
  String get securityCurrentPasswordError => 'Inserisci la password attuale';

  @override
  String get securityNewPasswordLabel => 'Nuova password *';

  @override
  String get securityNewPasswordError => 'Deve contenere almeno 8 caratteri';

  @override
  String get securityConfirmPasswordLabel => 'Conferma nuova password *';

  @override
  String get securityConfirmPasswordError => 'Le password non corrispondono';

  @override
  String get securityUpdatePasswordBtn => 'Aggiorna password';

  @override
  String get securityPasswordUpdatedSuccess =>
      'Password modificata con successo!';

  @override
  String get securitySection2FA => 'Autenticazione a due fattori (2FA)';

  @override
  String get security2FATitle => 'Autenticazione a due fattori';

  @override
  String get security2FAEnabledDesc =>
      'Abilitata - Protegge il tuo account con un codice';

  @override
  String get security2FADisabledDesc => 'Disabilitata (Consigliato)';

  @override
  String get security2FASetupTitle => 'Abilita autenticazione a due fattori';

  @override
  String get security2FASetupContent =>
      'Un codice di verifica a 6 cifre verrà inviato alla tua email a ogni nuovo accesso.';

  @override
  String get security2FAEnableNow => 'Abilita ora';

  @override
  String get security2FAEnabledSuccess =>
      'Autenticazione a due fattori abilitata con successo!';

  @override
  String get security2FADisabledSuccess =>
      'Autenticazione a due fattori disabilitata';

  @override
  String get securitySectionSessions => 'Sessioni e dispositivi attivi';

  @override
  String get securityLogoutAllDevices => 'Disconnetti tutti i dispositivi';

  @override
  String get securityThisDevice => 'Questo dispositivo';

  @override
  String get securitySessionRevokedSuccess =>
      'Sessione terminata e dispositivo disconnesso.';

  @override
  String get securityAllSessionsRevokedSuccess =>
      'Disconnesso da tutti gli altri dispositivi.';

  @override
  String get purchaseHistoryInvoiceCertified =>
      'Fattura elettronica certificata';

  @override
  String get purchaseHistoryInvoiceNumber => 'Numero fattura';

  @override
  String get purchaseHistoryCourse => 'Corso';

  @override
  String get purchaseHistoryPaymentMethod => 'Metodo di pagamento';

  @override
  String get purchaseHistoryTotalAmount => 'Importo totale:';

  @override
  String get purchaseHistoryClose => 'Chiudi';

  @override
  String get purchaseHistoryDownloadPdf => 'Scarica PDF';

  @override
  String get purchaseHistoryPdfDownloaded =>
      'Fattura PDF scaricata con successo';

  @override
  String get purchaseHistoryRefundRequestTitle => 'Richiesta di rimborso';

  @override
  String get purchaseHistoryRefundPolicy =>
      'In conformità con la garanzia di 30 giorni di EduLab, puoi ricevere un rimborso completo.';

  @override
  String get purchaseHistoryRefundReasonHint =>
      'Motivo del rimborso (opzionale)...';

  @override
  String get purchaseHistoryConfirmRefund => 'Conferma rimborso';

  @override
  String get purchaseHistoryRefundSubmitted =>
      'Richiesta di rimborso inviata con successo (3-5 giorni lavorativi).';

  @override
  String get purchaseHistoryInstructor => 'Istruttore';

  @override
  String get purchaseHistoryRequestRefundBtn => 'Richiedi rimborso';

  @override
  String get purchaseHistoryInvoiceBtn => 'Fattura';

  @override
  String get purchaseHistoryStatusCompleted => 'Completato';

  @override
  String get purchaseHistoryStatusRefunded => 'Rimborsato';

  @override
  String get purchaseHistoryStatusProcessingRefund => 'Elaborazione rimborso';

  @override
  String get editProfileSectionBasicInfo => 'Informazioni di base';

  @override
  String get editProfileFullNameLabel => 'Nome completo *';

  @override
  String get editProfileFullNameHint => 'Inserisci il tuo nome completo';

  @override
  String get editProfileFullNameError => 'Inserisci il tuo nome completo';

  @override
  String get editProfileHeadlineLabel => 'Titolo professionale';

  @override
  String get editProfileHeadlineHint => 'es. Sviluppatore Flutter Senior';

  @override
  String get editProfileLocationLabel => 'Città / Paese';

  @override
  String get editProfileLocationHint => 'Roma, Italia';

  @override
  String get editProfilePhoneLabel => 'Telefono cellulare';

  @override
  String get editProfileBioLabel => 'Su di me (Bio)';

  @override
  String get editProfileBioHint =>
      'Scrivi un breve riassunto dei tuoi interessi ed esperienze...';

  @override
  String get editProfileSectionLinks => 'Link e reti professionali';

  @override
  String get editProfileWebsiteLabel => 'Sito web personale';

  @override
  String get editProfileSectionEmail => 'Email registrata';

  @override
  String get editProfileEmailDesc =>
      'Collegata al tuo account per l\'accesso e la ricezione dei certificati';

  @override
  String get editProfileEmailVerified => 'Verificato';

  @override
  String get editProfileSaveChangesBtn => 'Salva modifiche';

  @override
  String get editProfileSavedSuccess => 'Profilo aggiornato con successo!';

  @override
  String get editProfileChangeAvatarTitle => 'Cambia foto del profilo';

  @override
  String get editProfileTakePhoto => 'Scatta una foto';

  @override
  String get editProfileChooseGallery => 'Scegli dalla galleria';

  @override
  String get editProfilePhotoUpdatedSuccess =>
      'Foto del profilo aggiornata con successo';

  @override
  String get teachJoinInstructorTitle => 'Diventa un istruttore';

  @override
  String get teachJoinInstructorSubtitle =>
      'Pubblica i tuoi corsi e condividi le tue competenze con migliaia di studenti.';

  @override
  String get teachStep1Title => 'Dati personali';

  @override
  String get teachStep2Title => 'Esperienza e competenze';

  @override
  String get teachStep3Title => 'Conferma';

  @override
  String get teachStep1Header => '1. Informazioni personali e professionali';

  @override
  String get teachFullNameArabicLabel => 'Nome completo *';

  @override
  String get teachFullNameArabicHint => 'es. Mario Rossi';

  @override
  String get teachHeadlineLabel => 'Titolo professionale e specializzazione *';

  @override
  String get teachHeadlineHint =>
      'es. Senior Software Architect e formatore Flutter';

  @override
  String get teachPhoneLabel => 'Numero di telefono *';

  @override
  String get teachCountryLabel => 'Paese di residenza *';

  @override
  String get teachBioLabel => 'Bio ed esperienze passate *';

  @override
  String get teachBioHint =>
      'Scrivi un breve riassunto del tuo percorso e dei tuoi progetti...';

  @override
  String get teachNextStepSkills => 'Continua: Esperienza e competenze';

  @override
  String get teachStep2Header => '2. Contenuto del corso e competenze';

  @override
  String get teachTopicLabel => 'Argomento o percorso del corso proposto *';

  @override
  String get teachTopicHint => 'es. Sviluppo Flutter da zero';

  @override
  String get teachYearsExperienceLabel => 'Anni di esperienza nel settore *';

  @override
  String get teachVideoLinkLabel =>
      'Link a un video di prova (YouTube/Drive/Loom) *';

  @override
  String get teachTargetAudienceLabel => 'Destinatari del corso *';

  @override
  String get teachAudienceBeginners => 'Principianti assoluti';

  @override
  String get teachAudienceIntermediate => 'Principianti e intermedi';

  @override
  String get teachAudienceAdvanced => 'Avanzati e professionisti';

  @override
  String get teachAudienceAll => 'Tutti i livelli';

  @override
  String get teachSkillsCoveredLabel =>
      'Competenze e tecnologie trattate nel corso *';

  @override
  String get teachAddSkillHint => 'Aggiungi competenza (es. GraphQL)...';

  @override
  String get teachAddSkillBtn => 'Aggiungi';

  @override
  String get teachNextStepConfirm => 'Continua: Conferma candidatura';

  @override
  String get teachStep3Header => '3. Dettagli di pagamento e termini';

  @override
  String get teachPayoutMethodLabel => 'Metodo di ricezione dei guadagni *';

  @override
  String get teachPayoutMethodBank => 'Bonifico bancario diretto (IBAN)';

  @override
  String get teachPayoutMethodPaypal => 'Conto PayPal verificato';

  @override
  String get teachPayoutMethodPayoneer => 'Carta Payoneer';

  @override
  String get teachIbanDetailsLabel => 'Dati del conto / IBAN *';

  @override
  String get teachApplicationSummary => 'Riepilogo della candidatura:';

  @override
  String get teachApplicantName => 'Candidato';

  @override
  String get teachApplicantHeadline => 'Specializzazione';

  @override
  String get teachApplicantTopic => 'Argomento del corso';

  @override
  String get teachApplicantSkillsCount => 'Competenze aggiunte';

  @override
  String get teachSkillsUnit => 'competenze';

  @override
  String get teachAgreeTermsLabel =>
      'Accetto i termini, le condizioni e l\'accordo di proprietà intellettuale di EduLab.';

  @override
  String get teachSubmitApplicationBtn => 'Invia candidatura come istruttore';

  @override
  String get teachPrevStepBtn => 'Precedente';

  @override
  String get teachWhyEduLabTitle => 'Perché insegnare con EduLab?';

  @override
  String get teachProp1Title => 'Guadagni equi e remunerativi';

  @override
  String get teachProp1Desc =>
      'Guadagna fino all\'80% dalle vendite dei tuoi corsi senza costi nascosti.';

  @override
  String get teachProp2Title => 'Raggiungi migliaia di studenti';

  @override
  String get teachProp2Desc =>
      'Promuovi il tuo corso a una vasta comunità di apprendimento attiva.';

  @override
  String get teachProp3Title => 'Supporto tecnico e di produzione completo';

  @override
  String get teachProp3Desc =>
      'Il nostro team ti aiuta a ottimizzare la qualità audio, video e il piano di studi.';

  @override
  String get teachSuccessDialogTitle => 'Candidatura ricevuta con successo!';

  @override
  String get teachSuccessDialogDesc =>
      'Grazie per esserti unito alla community di istruttori EduLab. Il nostro team esaminerà la candidatura e ti contatterà entro 48 ore.';

  @override
  String get teachSuccessDialogOk => 'Capito';

  @override
  String get teachAddOneSkillError => 'Aggiungi almeno una competenza';

  @override
  String get teachAgreeTermsError =>
      'Accetta i termini e le condizioni per gli istruttori';

  @override
  String get commonCancel => 'Annulla';

  @override
  String get commonClose => 'Chiudi';

  @override
  String get myCertificatesBannerTitle => 'Certificati Accreditati';

  @override
  String get myCertificatesBannerSubtitle =>
      'Tutti i certificati sono accreditati e verificati con un ID univoco da EduLab';

  @override
  String get certBadgeVerified100 => '100% Accreditato';

  @override
  String get certCodeCopied => 'Codice del certificato copiato';

  @override
  String get certGrantedTo => 'Concesso a';

  @override
  String get certViewAndDownload => 'Visualizza e scarica il certificato';

  @override
  String get certIssuerLabel => 'Autorità emittente';

  @override
  String get certIssuerName => 'Accademia di Apprendimento Interattivo EduLab';

  @override
  String get certEmptyTitle => 'Nessun certificato ancora ottenuto';

  @override
  String get certEmptyDesc =>
      'Completa il 100% di qualsiasi corso iscritto per ricevere un certificato accreditato con ID di verifica ufficiale.';

  @override
  String get certEmptyAction => 'Continua i miei corsi';

  @override
  String get certDetailsTitle => 'Dettagli e informazioni sul certificato';

  @override
  String get certCopyLinkSuccess =>
      'Link di verifica diretta copiato negli appunti!';

  @override
  String get certShareSuccess =>
      'Dettagli del certificato e link copiati per la condivisione!';

  @override
  String get purchaseHistoryTaxInvoiceCertified =>
      'Fattura fiscale ufficiale certificata';

  @override
  String get purchaseHistoryInvoiceNumberLabel => 'N. ordine / fattura';

  @override
  String get purchaseHistoryCourseNameLabel => 'Nome del corso';

  @override
  String get purchaseHistoryPurchaseDateLabel => 'Data di acquisto';

  @override
  String get purchaseHistoryPaymentMethodLabel => 'Metodo di pagamento';

  @override
  String get purchaseHistoryPaymentMethodValue =>
      'Carta di credito / Stripe (Online)';

  @override
  String get purchaseHistoryOrderStatusLabel => 'Stato dell\'ordine';

  @override
  String get purchaseHistoryStatusPendingReview =>
      'Rimborso in attesa di revisione';

  @override
  String get purchaseHistoryCopyInvoiceBtn => 'Copia numero fattura';

  @override
  String get purchaseHistoryRefundReasonLabel =>
      'Motivo della richiesta di rimborso:';

  @override
  String get purchaseHistoryRefundReasonEmptyError =>
      'Inserisci il motivo della tua richiesta di rimborso';

  @override
  String get purchaseHistorySubmittingRefund => 'Invio richiesta...';

  @override
  String get purchaseHistoryPaidDate => 'Data di pagamento';

  @override
  String get purchaseHistoryEmptyTitle => 'Nessuna cronologia acquisti';

  @override
  String get purchaseHistoryEmptyDesc =>
      'Non hai ancora acquistato alcun corso.\nI tuoi ordini e le fatture appariranno qui una volta completati.';

  @override
  String get purchaseHistoryExploreCourses => 'Esplora i corsi ora';

  @override
  String get profileMyCourses => 'I Miei Corsi';

  @override
  String get profileMyCoursesSubtitle =>
      'Traccia i progressi nei tuoi corsi iscritti';

  @override
  String get profileWishlistSubtitle =>
      'Corsi salvati nella tua lista dei desideri';

  @override
  String get navMyLearning => 'Il Mio Apprendimento';

  @override
  String get profileLogoutSafeNote =>
      'I tuoi dati, corsi e certificati sono al sicuro. Puoi continuare a studiare in qualsiasi momento effettuando nuovamente l\'accesso.';

  @override
  String learningRemainingHours(String hours) {
    return '$hours ore rimanenti';
  }

  @override
  String get learningCompletedFull => 'Completato';

  @override
  String get learningFilterNotStarted => 'Non Iniziato';

  @override
  String get wishlistTopRatedBadge => 'Più votati';

  @override
  String get wishlistFeaturedBadge => 'In evidenza';

  @override
  String wishlistDiscountBadge(String percent) {
    return '$percent% di sconto';
  }
}

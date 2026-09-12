// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get onboardingSkip => 'Pomiń';

  @override
  String get onboardingTitle1 => 'Witamy w EduLab';

  @override
  String get onboardingSubtitle1 =>
      'Twoja idealna platforma do nowoczesnej, interaktywnej nauki i rozwoju zawodowego.';

  @override
  String get onboardingTitle2 => 'Ucz się od najlepszych instruktorów';

  @override
  String get onboardingSubtitle2 =>
      'Tysiące profesjonalnych kursów z programowania, designu, biznesu i data science.';

  @override
  String get onboardingTitle3 => 'Certyfikaty i gwarantowany sukces';

  @override
  String get onboardingSubtitle3 =>
      'Śledź swoje postępy, zdawaj testy i zdobywaj uznawane certyfikaty.';

  @override
  String get onboardingNext => 'Dalej';

  @override
  String get onboardingStart => 'Rozpocznij teraz';

  @override
  String get splashAppName => 'Education Lab';

  @override
  String get splashTagline => 'Inteligentna Platforma Edukacyjna';

  @override
  String get loginTagline => 'Witamy na inteligentnej platformie edukacyjnej';

  @override
  String get loginAppName => 'EduLab';

  @override
  String get loginTabLogin => 'Zaloguj się';

  @override
  String get loginTabRegister => 'Rejestracja';

  @override
  String get loginEmailLabel => 'Adres e-mail';

  @override
  String get loginEmailHint => 'przyklad@email.pl';

  @override
  String get loginPasswordLabel => 'Hasło';

  @override
  String get loginPasswordHint => '••••••';

  @override
  String get loginForgotPassword => 'Nie pamiętasz hasła?';

  @override
  String get loginSubmit => 'Zaloguj się';

  @override
  String get loginSubmitLoading => 'Logowanie...';

  @override
  String get loginGuest => 'Kontynuuj jako gość';

  @override
  String get loginOr => 'lub';

  @override
  String get loginEmailRequired => 'E-mail jest wymagany';

  @override
  String get loginEmailInvalid => 'Wpisz poprawny adres e-mail';

  @override
  String get loginPasswordRequired => 'Hasło jest wymagane';

  @override
  String get registerStepEmail => 'E-mail';

  @override
  String get registerStepCode => 'Kod';

  @override
  String get registerStepData => 'Dane';

  @override
  String get registerSendCodeInfo =>
      'Wyślemy kod aktywacyjny na ten adres e-mail';

  @override
  String get registerSendCode => 'Wyślij kod aktywacyjny';

  @override
  String get registerVerifying => 'Weryfikacja';

  @override
  String get registerCodeSentTo => 'Kod wysłany na:';

  @override
  String get registerResendCode => 'Wyślij kod ponownie';

  @override
  String get registerBack => 'Wstecz';

  @override
  String get registerVerifyCode => 'Zweryfikuj kod';

  @override
  String get registerCodeIncomplete => 'Wpisz pełny 6-cyfrowy kod';

  @override
  String get registerFullNameLabel => 'Imię i nazwisko';

  @override
  String get registerFullNameHint => 'Twoje imię i nazwisko';

  @override
  String get registerPasswordHint => 'Minimum 8 znaków, wielka litera i cyfra';

  @override
  String get registerConfirmLabel => 'Potwierdź hasło';

  @override
  String get registerConfirmHint => 'Wpisz hasło ponownie';

  @override
  String get registerSubmit => 'Załóż konto';

  @override
  String get registerSubmitLoading => 'Tworzenie konta...';

  @override
  String get registerSuccess => 'Konto utworzone pomyślnie';

  @override
  String get registerNameRequired => 'Imię i nazwisko jest wymagane';

  @override
  String get registerNameMinLength => 'Imię musi mieć co najmniej 6 znaków';

  @override
  String get registerPasswordMinLength =>
      'Hasło musi mieć co najmniej 8 znaków';

  @override
  String get registerPasswordUppercase =>
      'Hasło musi zawierać co najmniej jedną wielką literę';

  @override
  String get registerPasswordNumber =>
      'Hasło musi zawierać co najmniej jedną cyfrę';

  @override
  String get registerConfirmRequired => 'Potwierdzenie hasła jest wymagane';

  @override
  String get registerConfirmMismatch => 'Hasła nie są identyczne';

  @override
  String get networkError => 'Błąd połączenia, spróbuj ponownie';

  @override
  String homeGreeting(String name) {
    return 'Witaj, $name!';
  }

  @override
  String get homeSubtitle => 'Czego chcesz się dzisiaj nauczyć?';

  @override
  String get homeSearchHint => 'Szukaj kursu lub umiejętności...';

  @override
  String get homeSectionContinue => 'Kontynuuj naukę';

  @override
  String get homeSectionRecommended => 'Polecane dla Ciebie';

  @override
  String get homeSectionPopular => 'Najpopularniejsze';

  @override
  String get homeSectionTopRated => 'Najwyżej oceniane';

  @override
  String get homeSectionByCategory => 'Według kategorii';

  @override
  String get homeHeroTitle => 'Odkryj oferty teraz';

  @override
  String get homeHeroSubtitle => 'Do 70% zniżki na wybrane kursy';

  @override
  String get homeHeroButton => 'Odkryj teraz';

  @override
  String get homeViewAll => 'Zobacz wszystko';

  @override
  String get homeProgressLabel => 'Ukończono';

  @override
  String get exploreTitle => 'Przeglądaj kursy';

  @override
  String get exploreSearchHint => 'Szukaj kursu, tematu lub instruktora...';

  @override
  String get exploreAllCategories => 'Wszystkie kategorie';

  @override
  String get exploreFilter => 'Filtruj';

  @override
  String get exploreSort => 'Sortuj';

  @override
  String get exploreNoResults => 'Brak wyników';

  @override
  String get exploreNoResultsHint =>
      'Spróbuj innych słów kluczowych lub zmień filtry';

  @override
  String exploreCoursesCount(int count) {
    return '$count kursów';
  }

  @override
  String get exploreFilterTitle => 'Filtruj wyniki';

  @override
  String get exploreFilterApply => 'Zastosuj filtry';

  @override
  String get exploreFilterReset => 'Zresetuj';

  @override
  String get exploreFilterPrice => 'Cena';

  @override
  String get exploreFilterLevel => 'Poziom';

  @override
  String get exploreFilterRating => 'Ocena';

  @override
  String get exploreFilterDuration => 'Czas trwania';

  @override
  String get exploreSortTitle => 'Sortuj według';

  @override
  String get exploreSortRelevance => 'Trafności';

  @override
  String get exploreSortNewest => 'Najnowsze';

  @override
  String get exploreSortPopular => 'Najpopularniejsze';

  @override
  String get exploreSortRating => 'Najwyżej oceniane';

  @override
  String get exploreSortPriceLow => 'Cena: od najniższej';

  @override
  String get exploreSortPriceHigh => 'Cena: od najwyższej';

  @override
  String get explorePriceFree => 'Darmowe';

  @override
  String get exploreLevelBeginner => 'Początkujący';

  @override
  String get exploreLevelIntermediate => 'Średniozaawansowany';

  @override
  String get exploreLevelAdvanced => 'Zaawansowany';

  @override
  String get learningTitle => 'Moja Nauka';

  @override
  String get learningTabInProgress => 'W trakcie';

  @override
  String get learningTabCompleted => 'Ukończone';

  @override
  String get learningTabSaved => 'Zapisane';

  @override
  String get learningEmpty => 'Brak kursów';

  @override
  String get learningEmptyHint => 'Zacznij przeglądać kursy już teraz';

  @override
  String get learningExploreButton => 'Przeglądaj kursy';

  @override
  String learningProgress(int percent) {
    return '$percent% ukończono';
  }

  @override
  String get learningContinue => 'Kontynuuj';

  @override
  String get learningViewCertificate => 'Zobacz certyfikat';

  @override
  String get learningReview => 'Oceń kurs';

  @override
  String get learningLesson => 'Lekcja';

  @override
  String get learningLessons => 'Lekcje';

  @override
  String get cartTitle => 'Koszyk';

  @override
  String get cartEmpty => 'Twój koszyk jest pusty';

  @override
  String get cartEmptyHint => 'Dodaj kursy, aby rozpocząć naukę';

  @override
  String get cartExploreButton => 'Przeglądaj kursy';

  @override
  String get cartPromoPlaceholder => 'Kod rabatowy';

  @override
  String get cartPromoApply => 'Zastosuj';

  @override
  String get cartPromoInvalid => 'Nieprawidłowy kod rabatowy';

  @override
  String get cartSummary => 'Podsumowanie zamówienia';

  @override
  String get cartSubtotal => 'Suma częściowa';

  @override
  String get cartDiscount => 'Rabat';

  @override
  String get cartTotal => 'Łącznie';

  @override
  String get cartCheckout => 'Do kasy';

  @override
  String cartCourses(int count) {
    return '$count kursów';
  }

  @override
  String get cartRemove => 'Usuń';

  @override
  String get cartGuarantee => '30-dniowa gwarancja zwrotu pieniędzy';

  @override
  String get checkoutTitle => 'Płatność';

  @override
  String get checkoutStepPayment => 'Płatność';

  @override
  String get checkoutStepReview => 'Podsumowanie';

  @override
  String get checkoutStepConfirm => 'Potwierdzenie';

  @override
  String get checkoutOrderSummary => 'Podsumowanie zamówienia';

  @override
  String get checkoutTotal => 'Łącznie';

  @override
  String get checkoutPayNow => 'Zapłać teraz';

  @override
  String get checkoutBack => 'Wstecz';

  @override
  String get checkoutNext => 'Dalej';

  @override
  String get checkoutSecureSSL =>
      'Bezpieczna płatność z 256-bitowym szyfrowaniem SSL';

  @override
  String get checkoutSuccessTitle => 'Zakup zakończony sukcesem!';

  @override
  String get checkoutSuccessSubtitle => 'Masz teraz dostęp do swojego kursu';

  @override
  String get checkoutGoToLearning => 'Do moich kursów';

  @override
  String get checkoutPaymentMethod => 'Metoda płatności';

  @override
  String get checkoutCardNumber => 'Numer karty';

  @override
  String get checkoutCardName => 'Imię i nazwisko na karcie';

  @override
  String get checkoutCardExpiry => 'Data ważności';

  @override
  String get checkoutCardCVV => 'CVV';

  @override
  String get courseDetailsEnroll => 'Zapisz się teraz';

  @override
  String get courseDetailsBuyNow => 'Kup teraz';

  @override
  String get courseDetailsAddToCart => 'Dodaj do koszyka';

  @override
  String get courseDetailsAddedToCart => 'Dodano do koszyka';

  @override
  String get courseDetailsAlreadyEnrolled => 'Już zapisany';

  @override
  String get courseDetailsGoToCourse => 'Przejdź do kursu';

  @override
  String get courseDetailsFree => 'Darmowy';

  @override
  String courseDetailsStudents(String count) {
    return '$count studentów';
  }

  @override
  String get courseDetailsRating => 'Ocena';

  @override
  String get courseDetailsReviews => 'opinii';

  @override
  String get courseDetailsLastUpdated => 'Ostatnia aktualizacja';

  @override
  String get courseDetailsCurriculum => 'Program kursu';

  @override
  String get courseDetailsSection => 'sekcja';

  @override
  String get courseDetailsLessons => 'lekcji';

  @override
  String get courseDetailsInstructor => 'Instruktor';

  @override
  String get courseDetailsStudentsLabel => 'Studenci';

  @override
  String get courseDetailsCoursesLabel => 'Kursy';

  @override
  String get courseDetailsReviewsLabel => 'Opinie';

  @override
  String get courseDetailsReviewsTitle => 'Opinie studentów';

  @override
  String get courseDetailsWhatLearn => 'Czego się nauczysz';

  @override
  String get courseDetailsRequirements => 'Wymagania';

  @override
  String get courseDetailsDescription => 'Opis kursu';

  @override
  String get courseDetailsIncludesTitle => 'Ten kurs obejmuje';

  @override
  String get courseDetailsHoursVideo => 'godzin wideo';

  @override
  String get courseDetailsArticles => 'artykułów';

  @override
  String get courseDetailsMobileAccess => 'Dostęp na urządzeniach mobilnych';

  @override
  String get courseDetailsCertificate => 'Certyfikat ukończenia';

  @override
  String get courseDetailsLifetimeAccess => 'Dożywotni dostęp';

  @override
  String get lessonPlayerNotes => 'Moje notatki';

  @override
  String get lessonPlayerResources => 'Materiały';

  @override
  String get lessonPlayerDiscussion => 'Dyskusja';

  @override
  String get lessonPlayerPrev => 'Poprzednia';

  @override
  String get lessonPlayerNext => 'Następna';

  @override
  String get lessonPlayerSpeed => 'Prędkość';

  @override
  String get lessonPlayerQuality => 'Jakość';

  @override
  String get lessonPlayerCompleted => 'Lekcja ukończona';

  @override
  String get certificateTitle => 'Certyfikat Ukończenia';

  @override
  String get certificatePresentedTo => 'Przyznany dla';

  @override
  String get certificateCompletedCourse => 'za pomyślne ukończenie kursu';

  @override
  String get certificateIssuedOn => 'Data wydania';

  @override
  String get certificateVerificationId => 'Numer certyfikatu';

  @override
  String get certificateDownloadPDF => 'Pobierz PDF';

  @override
  String get certificateDownloadPNG => 'Pobierz obraz';

  @override
  String get certificateCopyLink => 'Kopiuj link do weryfikacji';

  @override
  String get certificateLinkCopied => 'Link skopiowany';

  @override
  String get profileTitle => 'Profil';

  @override
  String get profileEditProfile => 'Edytuj profil';

  @override
  String get profileCourses => 'Moje kursy';

  @override
  String get profileCertificates => 'Certyfikaty';

  @override
  String get profilePoints => 'Punkty';

  @override
  String get profileFollowers => 'Obserwujący';

  @override
  String get profileFollowing => 'Obserwowani';

  @override
  String get profileBio => 'O mnie';

  @override
  String get profileInstructor => 'Instruktor';

  @override
  String get profileStudent => 'Student';

  @override
  String get profileLevel => 'Poziom';

  @override
  String get profileJoined => 'Dołączył';

  @override
  String get profileShareProfile => 'Udostępnij profil';

  @override
  String get profileMenuLearning => 'Moje kursy';

  @override
  String get profileMenuCertificates => 'Moje certyfikaty';

  @override
  String get profileMenuPurchaseHistory => 'Historia zakupów';

  @override
  String get profileMenuTeachApplication => 'Nauczaj w EduLab';

  @override
  String get profileMenuAccountSecurity => 'Bezpieczeństwo konta';

  @override
  String get profileMenuNotifications => 'Powiadomienia';

  @override
  String get profileMenuMessages => 'Wiadomości';

  @override
  String get profileMenuSettings => 'Ustawienia';

  @override
  String get profileMenuSchedule => 'Mój grafik';

  @override
  String get profileMenuAssignments => 'Zadania';

  @override
  String get profileMenuQuiz => 'Quizy';

  @override
  String get profileMenuLogout => 'Wyloguj się';

  @override
  String get profileLogoutConfirm => 'Czy na pewno chcesz się wylogować?';

  @override
  String get profileLogoutYes => 'Tak, wyloguj';

  @override
  String get profileLogoutNo => 'Anuluj';

  @override
  String get editProfileTitle => 'Edytuj Profil';

  @override
  String get editProfileSave => 'Zapisz zmiany';

  @override
  String get editProfileFullName => 'Imię i nazwisko';

  @override
  String get editProfileBio => 'O mnie';

  @override
  String get editProfileEmail => 'Adres e-mail';

  @override
  String get editProfilePhone => 'Numer telefonu';

  @override
  String get editProfileWebsite => 'Strona WWW';

  @override
  String get editProfileSaved => 'Zmiany zostały zapisane pomyślnie';

  @override
  String get accountSecurityTitle => 'Bezpieczeństwo Konta';

  @override
  String get accountSecurityChangePassword => 'Zmień hasło';

  @override
  String get accountSecurityTwoFactor => 'Weryfikacja dwuetapowa';

  @override
  String get accountSecurityActiveSessions => 'Aktywne sesje';

  @override
  String get accountSecurityDeleteAccount => 'Usuń konto';

  @override
  String get purchaseHistoryTitle => 'Historia Zakupów';

  @override
  String get purchaseHistoryEmpty => 'Brak zakupów';

  @override
  String get purchaseHistoryGuarantee => '30-dniowa gwarancja zwrotu pieniędzy';

  @override
  String get purchaseHistoryDate => 'Data transakcji';

  @override
  String get purchaseHistoryStatus => 'Status';

  @override
  String get purchaseHistoryAmount => 'Kwota';

  @override
  String get purchaseHistoryCompleted => 'Ukończono';

  @override
  String get purchaseHistoryRefunded => 'Zwrócono';

  @override
  String get teachApplicationTitle => 'Nauczaj w EduLab';

  @override
  String get teachApplicationSubmit => 'Wyślij zgłoszenie';

  @override
  String get teachApplicationSent => 'Twoje zgłoszenie zostało wysłane';

  @override
  String get notificationsTitle => 'Powiadomienia';

  @override
  String get notificationsMarkAllRead => 'Oznacz wszystkie jako przeczytane';

  @override
  String get notificationsMarkAllReadSnackbar =>
      'Wszystkie powiadomienia oznaczone jako przeczytane';

  @override
  String get notificationsEmpty => 'Brak powiadomień';

  @override
  String get notification1Title => 'Przypomnienie: Kontynuuj kurs';

  @override
  String get notification1Message =>
      'Czeka na Ciebie nowa lekcja we Flutter dla Początkujących';

  @override
  String get notification1Time => '5 minut temu';

  @override
  String get notification1Action => 'Kontynuuj kurs';

  @override
  String get notification2Title => 'Twój certyfikat jest gotowy!';

  @override
  String get notification2Message => 'Ukończyłeś kurs UI/UX Design.';

  @override
  String get notification2Time => '2 godziny temu';

  @override
  String get notification2Action => 'Zobacz certyfikat';

  @override
  String get notification3Title => 'Specjalna oferta dla Ciebie';

  @override
  String get notification3Message => '70% zniżki na kursy programowania';

  @override
  String get notification3Time => '1 dzień temu';

  @override
  String get notification3Action => 'Sprawdź ofertę';

  @override
  String get notification4Title => 'Nowa odpowiedź na Twoje pytanie';

  @override
  String get notification4Message => 'Instruktor odpowiedział na Twoje pytanie';

  @override
  String get notification4Time => '2 dni temu';

  @override
  String get notification4Action => 'Zobacz odpowiedź';

  @override
  String get notification5Title => 'Aktualizacja kursu';

  @override
  String get notification5Message => 'Dodano nowe materiały do kursu Python';

  @override
  String get notification5Time => '3 dni temu';

  @override
  String get messagesTitle => 'Wiadomości';

  @override
  String get settingsTitle => 'Ustawienia i Preferencje';

  @override
  String get settingsVideoDownload => 'Wideo i Pobieranie';

  @override
  String get settingsDownloadQuality => 'Domyślna jakość pobierania';

  @override
  String get settingsWifiOnly => 'Pobieraj tylko przez Wi-Fi';

  @override
  String get settingsNotifications => 'Powiadomienia i Alerty';

  @override
  String get settingsCourseNotifications =>
      'Powiadomienia o kursach i wiadomościach';

  @override
  String get settingsPromoNotifications => 'Ekskluzywne oferty i rabaty';

  @override
  String get settingsAppearance => 'Wygląd i Język';

  @override
  String get settingsDarkMode => 'Tryb Ciemny';

  @override
  String get settingsDarkModeEnabled => 'Włączony (oszczędza baterię)';

  @override
  String get settingsDarkModeDisabled => 'Wyłączony (jasny motyw)';

  @override
  String get settingsLanguage => 'Język aplikacji';

  @override
  String get settingsStorage => 'Pamięć i Pamięć podręczna';

  @override
  String get settingsClearCache => 'Wyczyść pamięć podręczną';

  @override
  String get settingsClearCacheSuccess =>
      'Pamięć podręczna wyczyszczona pomyślnie';

  @override
  String get settingsHelp => 'Informacje i Zasady';

  @override
  String get settingsHelpCenter => 'Centrum pomocy i FAQ';

  @override
  String get settingsTermsPrivacy => 'Regulamin i Prywatność';

  @override
  String get settingsAbout => 'O EduLab';

  @override
  String get settingsVersion => 'Wersja v1.0.0';

  @override
  String get quizTitle => 'Quiz';

  @override
  String get quizNext => 'Następne pytanie';

  @override
  String get quizSubmit => 'Zakończ quiz';

  @override
  String get quizScore => 'Wynik quizu';

  @override
  String get quizCorrectAnswers => 'Prawidłowe odpowiedzi';

  @override
  String get scheduleTitle => 'Mój Grafik';

  @override
  String get scheduleEmpty => 'Brak zaplanowanych sesji';

  @override
  String get scheduleJoin => 'Dołącz do sesji';

  @override
  String get scheduleReminder => 'Przypomnienie';

  @override
  String get assignmentsTitle => 'Zadania';

  @override
  String get assignmentsEmpty => 'Brak zadań';

  @override
  String get assignmentsSubmit => 'Oddaj zadanie';

  @override
  String get assignmentsDue => 'Termin oddania';

  @override
  String get assignmentsSubmitted => 'Oddano';

  @override
  String get assignmentsPending => 'W trakcie sprawdzania';

  @override
  String get languageArabic => 'Arabski';

  @override
  String get languageEnglish => 'Angielski';

  @override
  String get languageDialogTitle => 'Wybierz język';

  @override
  String get languageSelect => 'Wybierz';

  @override
  String get generalCancel => 'Anuluj';

  @override
  String get generalConfirm => 'Potwierdź';

  @override
  String get generalSave => 'Zapisz';

  @override
  String get generalDelete => 'Usuń';

  @override
  String get generalEdit => 'Edytuj';

  @override
  String get generalClose => 'Zamknij';

  @override
  String get generalBack => 'Wstecz';

  @override
  String get generalDone => 'Gotowe';

  @override
  String get generalOk => 'OK';

  @override
  String get generalYes => 'Tak';

  @override
  String get generalNo => 'Nie';

  @override
  String get generalLoading => 'Ładowanie...';

  @override
  String get generalError => 'Wystąpił błąd';

  @override
  String get generalRetry => 'Spróbuj ponownie';

  @override
  String get generalNoInternet => 'Brak połączenia z internetem';

  @override
  String get generalFree => 'Darmowy';

  @override
  String get generalRating => 'Ocena';

  @override
  String get generalStudents => 'Studenci';

  @override
  String get generalHours => 'Godzin';

  @override
  String get generalMinutes => 'Minut';

  @override
  String get generalBy => 'Autor';

  @override
  String get navHome => 'Główna';

  @override
  String get navExplore => 'Przeglądaj';

  @override
  String get navMyCourses => 'Moje kursy';

  @override
  String get navCart => 'Koszyk';

  @override
  String get navAccount => 'Konto';

  @override
  String get homeSubGreeting => 'Czego chciałbyś się dziś nauczyć?';

  @override
  String get homeVisitor => 'Gość';

  @override
  String get homePromoTitle => 'Odkryj oferty teraz';

  @override
  String get homePromoSubtitle => 'Do 70% zniżki na wybrane kursy';

  @override
  String get homePromoButton => 'Odkryj teraz';

  @override
  String get homePromoBadge => 'Oferta specjalna';

  @override
  String get homeContinueLearning => 'Kontynuuj naukę';

  @override
  String get homeMyCoursesLink => 'Moje kursy';

  @override
  String get homeLesson => 'lekcja';

  @override
  String homeStudentsCount(String count) {
    return '$count studentów';
  }

  @override
  String get homeRecommendedTitle => 'Polecane dla Ciebie';

  @override
  String get homeRecommendedSubtitle => 'Dopasowane do Twoich zainteresowań';

  @override
  String get homeBestsellersTitle => 'Bestsellery';

  @override
  String get homeBestsellersSubtitle =>
      'Najwyżej oceniane i najpopularniejsze kursy';

  @override
  String get homeNewCoursesTitle => 'Nowe kursy';

  @override
  String get homeNewCoursesSubtitle => 'Świeże i aktualne materiały';

  @override
  String get homePopularTopicsTitle => 'Popularne tematy';

  @override
  String get homePopularTopicsSubtitle =>
      'Zdobądź najbardziej poszukiwane umiejętności';

  @override
  String get homeTopInstructorsTitle => 'Najlepsi instruktorzy';

  @override
  String get homeTopInstructorsSubtitle =>
      'Ucz się od certyfikowanych ekspertów';

  @override
  String get homeExploreCategoriesTitle => 'Przeglądaj kategorie';

  @override
  String get homeExploreCategoriesSubtitle => 'Znajdź kurs idealny dla siebie';

  @override
  String get catAll => 'Wszystkie';

  @override
  String get catWebDev => 'Tworzenie stron WWW';

  @override
  String get catMobileApps => 'Aplikacje mobilne';

  @override
  String get catDataScience => 'Data Science';

  @override
  String get catUIUX => 'UI/UX Design';

  @override
  String get catBusiness => 'Biznes i zarządzanie';

  @override
  String get catAI => 'Sztuczna inteligencja';

  @override
  String get catCyberSecurity => 'Cyberbezpieczeństwo';

  @override
  String get exploreNoResultsTitle => 'Brak wyników';

  @override
  String get exploreNoResultsSubtitle =>
      'Spróbuj innych słów kluczowych lub zmień filtry';

  @override
  String get exploreRecentSearches => 'Ostatnie wyszukiwania';

  @override
  String get exploreTopSearches => 'Popularne wyszukiwania';

  @override
  String get exploreBrowseCategories => 'Przeglądaj kategorie';

  @override
  String get exploreBrowseCategoriesSubtitle =>
      'Znajdź kurs idealny dla siebie';

  @override
  String get exploreBackToAll => 'Wróć do wszystkich';

  @override
  String get exploreClearAll => 'Wyczyść wszystko';

  @override
  String get exploreAvailableResults => 'dostępnych wyników';

  @override
  String get exploreFilterBestseller => 'Bestseller';

  @override
  String get exploreFilterTopRated => 'Najwyżej oceniane';

  @override
  String get exploreFilterUnder50 => 'Poniżej 50 zł';

  @override
  String get learningHeroTitle => 'Kontynuuj swoją ścieżkę edukacyjną';

  @override
  String get learningSearchHint => 'Szukaj w moich kursach...';

  @override
  String get learningFilterAll => 'Wszystkie';

  @override
  String get learningFilterInProgress => 'W trakcie';

  @override
  String get learningFilterCompleted => 'Ukończone';

  @override
  String get learningFilterDownloaded => 'Pobrane';

  @override
  String get learningEmptyTitle => 'Brak kursów';

  @override
  String get learningEmptySubtitle => 'Zacznij przeglądać kursy już teraz';

  @override
  String get learningEmptySearch => 'Brak wyników wyszukiwania';

  @override
  String get learningCompleted => 'Ukończono';

  @override
  String get learningCompletedBadge => 'Ukończono';

  @override
  String learningLecturesCount(int count) {
    return '$count lekcji';
  }

  @override
  String get cartEmptyTitle => 'Twój koszyk jest pusty';

  @override
  String get cartEmptySubtitle => 'Dodaj kursy, aby rozpocząć naukę';

  @override
  String get cartCouponHint => 'Wpisz kod rabatowy';

  @override
  String get cartCouponApply => 'Zastosuj';

  @override
  String get cartCouponInvalid => 'Nieprawidłowy kod';

  @override
  String get cartCouponApplied => 'Kod rabatowy zastosowany';

  @override
  String get cartCouponDiscount => 'Zniżka z kuponu';

  @override
  String get cartCouponsTitle => 'Kupony';

  @override
  String get cartOrderSummary => 'Podsumowanie zamówienia';

  @override
  String get cartOriginalPrice => 'Cena pierwotna';

  @override
  String get cartPlatformDiscount => 'Rabat platformy';

  @override
  String get cartFinalTotal => 'Suma całkowita';

  @override
  String cartItemsCount(int count) {
    return '$count kursów';
  }

  @override
  String get cartRemovedSnackbar => 'Kurs usunięty z koszyka';

  @override
  String get cartUndo => 'Cofnij';

  @override
  String get cartAddButton => 'Dodaj do koszyka';

  @override
  String get cartAddedSnackbar => 'Dodano do koszyka';

  @override
  String get cartAlreadyInCart => 'Już w koszyku';

  @override
  String get cartCheckoutButton => 'Przejdź do kasy';

  @override
  String get cartRecommendedTitle => 'Może Ci się spodobać';

  @override
  String get cartRecommendedSubtitle =>
      'Kursy polecane na podstawie Twojego koszyka';

  @override
  String get checkoutCreditCard => 'Karta płatnicza';

  @override
  String get checkoutSelectPayment => 'Wybierz metodę płatności';

  @override
  String get checkoutCardNumberLabel => 'Numer karty';

  @override
  String get checkoutCardHolderLabel => 'Posiadacz karty';

  @override
  String get checkoutExpiryLabel => 'Data ważności';

  @override
  String get checkoutCVVLabel => 'CVV';

  @override
  String get checkoutPersonalInfoTitle => 'Dane osobowe';

  @override
  String get checkoutFullNameLabel => 'Imię i nazwisko';

  @override
  String get checkoutFullNameHint => 'Twoje imię i nazwisko';

  @override
  String get checkoutFullNameRequired => 'Imię i nazwisko jest wymagane';

  @override
  String get checkoutPhoneLabel => 'Numer telefonu';

  @override
  String get checkoutPhoneRequired => 'Numer telefonu jest wymagany';

  @override
  String get checkoutPostalLabel => 'Kod pocztowy';

  @override
  String get checkoutPostalRequired => 'Kod pocztowy jest wymagany';

  @override
  String get checkoutBuyerInfo => 'Dane kupującego';

  @override
  String get checkoutSaveInfo => 'Zapisz dane na przyszłość';

  @override
  String get checkoutMoneyBackGuarantee =>
      '30-dniowa gwarancja zwrotu pieniędzy';

  @override
  String get checkoutContinueToPayment => 'Przejdź do płatności';

  @override
  String get checkoutContinueToReview => 'Przejdź do podsumowania';

  @override
  String get checkoutReviewConfirm => 'Sprawdź i potwierdź';

  @override
  String get checkoutStartLearning => 'Zacznij naukę';

  @override
  String get checkoutBackHome => 'Powrót do strony głównej';

  @override
  String get courseDetailsTitle => 'Szczegóły kursu';

  @override
  String get courseDetailsShare => 'Udostępnij';

  @override
  String get courseDetailsWhatYouWillLearn => 'Czego się nauczysz';

  @override
  String get courseDetailsLanguage => 'Język';

  @override
  String get courseDetailsCreatedBy => 'Autor';

  @override
  String get courseDetailsPreviewLesson => 'Lekcja próbna';

  @override
  String get courseDetailsHoursOnDemand => 'godzin wideo na żądanie';

  @override
  String get courseDetailsFullLifetimeAccess => 'Pełny, dożywotni dostęp';

  @override
  String get courseDetailsCertifiedCertificate => 'Certyfikat ukończenia kursu';

  @override
  String get courseDetailsComprehensiveContent => 'Kompleksowa treść';

  @override
  String get certTitle => 'Certyfikat Ukończenia';

  @override
  String get certStudentNameLabel => 'Student';

  @override
  String get certCourseLabel => 'Kurs';

  @override
  String get certInstructorLabel => 'Instruktor';

  @override
  String get certIssueDateLabel => 'Data wydania';

  @override
  String get certCodeLabel => 'ID certyfikatu';

  @override
  String get certVerifiedBadge => 'Zweryfikowany';

  @override
  String get certDownloadPDF => 'Pobierz PDF';

  @override
  String get certDownloadPNG => 'Pobierz obraz';

  @override
  String get certCopyVerifyLink => 'Kopiuj link do weryfikacji';

  @override
  String get certShare => 'Udostępnij certyfikat';

  @override
  String get playerTabLessons => 'Lekcje';

  @override
  String get playerTabOverview => 'Przegląd';

  @override
  String get playerTabNotes => 'Moje notatki';

  @override
  String get playerTabQnA => 'Pytania i odpowiedzi';

  @override
  String get playerNextLesson => 'Następna lekcja';

  @override
  String get profileWelcome => 'Witaj';

  @override
  String get profileLoginPrompt => 'Zaloguj się, aby uzyskać dostęp do profilu';

  @override
  String get profileLoginOrRegister => 'Zaloguj się / Zarejestruj';

  @override
  String get profileVerifiedStudent => 'Zweryfikowany student';

  @override
  String get profileLogout => 'Wyloguj się';

  @override
  String get profileCancel => 'Anuluj';

  @override
  String get profileLogoutConfirmTitle => 'Wylogowanie';

  @override
  String get profileLogoutConfirmMessage =>
      'Czy na pewno chcesz się wylogować?';

  @override
  String get profileAccountSettings => 'Ustawienia konta';

  @override
  String get profileEditProfileSubtitle => 'Edytuj dane osobowe';

  @override
  String get profileSecurity => 'Bezpieczeństwo konta';

  @override
  String get profileSecuritySubtitle => 'Hasło i uwierzytelnianie';

  @override
  String get profilePurchaseHistory => 'Historia zakupów';

  @override
  String get profilePurchaseHistorySubtitle => 'Zobacz historię transakcji';

  @override
  String get profileCertificatesSubtitle => 'Twoje certyfikaty';

  @override
  String get profileTeach => 'Nauczaj w EduLab';

  @override
  String get profileTeachSubtitle => 'Dziel się wiedzą z innymi';

  @override
  String get profilePreferences => 'Preferencje';

  @override
  String get profilePreferencesSubtitle => 'Ustawienia i wygląd';

  @override
  String get profileNotifications => 'Powiadomienia';

  @override
  String get profileNotificationsSubtitle => 'Zarządzaj alertami';

  @override
  String get profileHelpSupport => 'Pomoc i wsparcie';

  @override
  String get profileTerms => 'Regulamin';

  @override
  String get profilePrivacy => 'Polityka prywatności';

  @override
  String get profileAboutEduLab => 'O EduLab';

  @override
  String get profileWishlist => 'Lista życzeń';

  @override
  String get securityTitle => 'Bezpieczeństwo Konta';

  @override
  String get teachTitle => 'Nauczaj w EduLab';

  @override
  String get notificationsTabAll => 'Wszystkie';

  @override
  String get notificationsTabCourses => 'Kursy';

  @override
  String get notificationsTabPromos => 'Oferty';

  @override
  String get notificationsEmptyTitle => 'Brak powiadomień';

  @override
  String get notificationsUnread => 'Nieprzeczytane';

  @override
  String get wishlistTitle => 'Lista Życzeń';

  @override
  String get wishlistEmptyTitle => 'Twoja lista życzeń jest pusta';

  @override
  String get wishlistEmptySubtitle => 'Zapisz interesujące Cię kursy';

  @override
  String get wishlistAddToCart => 'Dodaj do koszyka';

  @override
  String get wishlistRemovedSnackbar => 'Usunięto z listy życzeń';

  @override
  String get homeDefaultUser => 'Student';

  @override
  String get learningOf => 'z';

  @override
  String get cartInCartBadge => 'W koszyku';

  @override
  String get homePromo1Badge => 'Wielka promocja • Ograniczony czas';

  @override
  String get homePromo1Title => 'Rozpocznij naukę w najlepszych cenach';

  @override
  String get homePromo1Subtitle =>
      'Do 65% zniżki na kursy programowania, designu i biznesu.';

  @override
  String get homePromo1Button => 'Zobacz oferty';

  @override
  String get homePromo2Badge => 'Certyfikowane ścieżki kariery';

  @override
  String get homePromo2Title => 'Przygotuj się do wymarzonej pracy';

  @override
  String get homePromo2Subtitle =>
      'Kompleksowe kursy od zera do mistrza z projektami i certyfikatami.';

  @override
  String get homePromo2Button => 'Przeglądaj ścieżki';

  @override
  String get homePromo3Badge => 'Najlepsi instruktorzy i eksperci';

  @override
  String get homePromo3Title => 'Ucz się bezpośrednio od profesjonalistów';

  @override
  String get homePromo3Subtitle =>
      'Stale aktualizowane materiały z najnowszych technologii.';

  @override
  String get homePromo3Button => 'Zacznij teraz';

  @override
  String get homePromoInstructorBadge => 'Nauczaj na EduLab • Dziel się wiedzą';

  @override
  String get homePromoInstructorTitle => 'Zostań instruktorem już dziś';

  @override
  String get homePromoInstructorSubtitle =>
      'Inspiruj uczniów na całym świecie, twórz kursy i zarabiaj na nauczaniu tego, co kochasz.';

  @override
  String get homePromoInstructorButton => 'Aplikuj teraz';

  @override
  String get homeSearchFilter => 'Filtruj';

  @override
  String get securitySectionChangePassword => 'Zmień hasło';

  @override
  String get securityCurrentPasswordLabel => 'Aktualne hasło *';

  @override
  String get securityCurrentPasswordError => 'Wprowadź aktualne hasło';

  @override
  String get securityNewPasswordLabel => 'Nowe hasło *';

  @override
  String get securityNewPasswordError => 'Musi mieć co najmniej 8 znaków';

  @override
  String get securityConfirmPasswordLabel => 'Potwierdź nowe hasło *';

  @override
  String get securityConfirmPasswordError => 'Hasła nie są zgodne';

  @override
  String get securityUpdatePasswordBtn => 'Zaktualizuj hasło';

  @override
  String get securityPasswordUpdatedSuccess =>
      'Hasło zostało pomyślnie zmienione!';

  @override
  String get securitySection2FA => 'Weryfikacja dwuetapowa (2FA)';

  @override
  String get security2FATitle => 'Uwierzytelnianie dwuskładnikowe';

  @override
  String get security2FAEnabledDesc => 'Włączone - Zabezpiecza konto kodem';

  @override
  String get security2FADisabledDesc => 'Wyłączone (Zalecane)';

  @override
  String get security2FASetupTitle => 'Włącz weryfikację dwuetapową';

  @override
  String get security2FASetupContent =>
      'Przy każdym nowym logowaniu na Twój adres e-mail zostanie wysłany 6-cyfrowy kod weryfikacyjny.';

  @override
  String get security2FAEnableNow => 'Włącz teraz';

  @override
  String get security2FAEnabledSuccess =>
      'Weryfikacja dwuetapowa została włączona!';

  @override
  String get security2FADisabledSuccess =>
      'Weryfikacja dwuetapowa została wyłączona';

  @override
  String get securitySectionSessions => 'Aktywne sesje i urządzenia';

  @override
  String get securityLogoutAllDevices => 'Wyloguj ze wszystkich';

  @override
  String get securityThisDevice => 'To urządzenie';

  @override
  String get securitySessionRevokedSuccess =>
      'Sesja zakończona, wylogowano urządzenie.';

  @override
  String get securityAllSessionsRevokedSuccess =>
      'Wylogowano ze wszystkich pozostałych urządzeń.';

  @override
  String get purchaseHistoryInvoiceCertified => 'Certyfikowana e-faktura';

  @override
  String get purchaseHistoryInvoiceNumber => 'Numer faktury';

  @override
  String get purchaseHistoryCourse => 'Kurs';

  @override
  String get purchaseHistoryPaymentMethod => 'Metoda płatności';

  @override
  String get purchaseHistoryTotalAmount => 'Łączna kwota:';

  @override
  String get purchaseHistoryClose => 'Zamknij';

  @override
  String get purchaseHistoryDownloadPdf => 'Pobierz PDF';

  @override
  String get purchaseHistoryPdfDownloaded => 'Pobrano fakturę w formacie PDF';

  @override
  String get purchaseHistoryRefundRequestTitle => 'Wniosek o zwrot środków';

  @override
  String get purchaseHistoryRefundPolicy =>
      'Zgodnie z 30-dniową gwarancją zwrotu pieniędzy EduLab możesz otrzymać pełny zwrot.';

  @override
  String get purchaseHistoryRefundReasonHint => 'Powód zwrotu (opcjonalnie)...';

  @override
  String get purchaseHistoryConfirmRefund => 'Potwierdź zwrot';

  @override
  String get purchaseHistoryRefundSubmitted =>
      'Wniosek o zwrot przesłany (3-5 dni roboczych).';

  @override
  String get purchaseHistoryInstructor => 'Instruktor';

  @override
  String get purchaseHistoryRequestRefundBtn => 'Poproś o zwrot';

  @override
  String get purchaseHistoryInvoiceBtn => 'Faktura';

  @override
  String get purchaseHistoryStatusCompleted => 'Zakończono';

  @override
  String get purchaseHistoryStatusRefunded => 'Zwrócono';

  @override
  String get purchaseHistoryStatusProcessingRefund => 'Przetwarzanie zwrotu';

  @override
  String get editProfileSectionBasicInfo => 'Podstawowe informacje';

  @override
  String get editProfileFullNameLabel => 'Imię i nazwisko *';

  @override
  String get editProfileFullNameHint => 'Wpisz imię i nazwisko';

  @override
  String get editProfileFullNameError => 'Proszę wpisać pełne imię i nazwisko';

  @override
  String get editProfileHeadlineLabel => 'Tytuł zawodowy';

  @override
  String get editProfileHeadlineHint => 'np. Senior Flutter Developer';

  @override
  String get editProfileLocationLabel => 'Miasto / Kraj';

  @override
  String get editProfileLocationHint => 'Warszawa, Polska';

  @override
  String get editProfilePhoneLabel => 'Numer telefonu';

  @override
  String get editProfileBioLabel => 'O mnie (Bio)';

  @override
  String get editProfileBioHint =>
      'Napisz krótkie podsumowanie swoich zainteresowań i doświadczenia...';

  @override
  String get editProfileSectionLinks => 'Linki i sieci zawodowe';

  @override
  String get editProfileWebsiteLabel => 'Strona internetowa';

  @override
  String get editProfileSectionEmail => 'Zarejestrowany e-mail';

  @override
  String get editProfileEmailDesc =>
      'Połączony z kontem do logowania i certyfikatów';

  @override
  String get editProfileEmailVerified => 'Zweryfikowano';

  @override
  String get editProfileSaveChangesBtn => 'Zapisz zmiany';

  @override
  String get editProfileSavedSuccess =>
      'Profil został pomyślnie zaktualizowany!';

  @override
  String get editProfileChangeAvatarTitle => 'Zmień zdjęcie profilowe';

  @override
  String get editProfileTakePhoto => 'Zrób zdjęcie';

  @override
  String get editProfileChooseGallery => 'Wybierz z galerii';

  @override
  String get editProfilePhotoUpdatedSuccess =>
      'Zdjęcie profilowe zostało zaktualizowane';

  @override
  String get teachJoinInstructorTitle => 'Dołącz jako instruktor';

  @override
  String get teachJoinInstructorSubtitle =>
      'Publikuj kursy i dziel się wiedzą z tysiącami studentów.';

  @override
  String get teachStep1Title => 'Dane osobowe';

  @override
  String get teachStep2Title => 'Doświadczenie i umiejętności';

  @override
  String get teachStep3Title => 'Potwierdzenie';

  @override
  String get teachStep1Header => '1. Informacje osobiste i zawodowe';

  @override
  String get teachFullNameArabicLabel => 'Imię i nazwisko *';

  @override
  String get teachFullNameArabicHint => 'np. Jan Kowalski';

  @override
  String get teachHeadlineLabel => 'Tytuł zawodowy i specjalizacja *';

  @override
  String get teachHeadlineHint =>
      'np. Senior Software Architect i trener Flutter';

  @override
  String get teachPhoneLabel => 'Numer telefonu *';

  @override
  String get teachCountryLabel => 'Kraj zamieszkania *';

  @override
  String get teachBioLabel => 'Bio i dotychczasowe doświadczenie *';

  @override
  String get teachBioHint =>
      'Napisz krótkie podsumowanie swojej kariery i projektów...';

  @override
  String get teachNextStepSkills => 'Dalej: Doświadczenie i umiejętności';

  @override
  String get teachStep2Header => '2. Treść kursu i umiejętności';

  @override
  String get teachTopicLabel => 'Temat lub ścieżka proponowanego kursu *';

  @override
  String get teachTopicHint => 'np. Tworzenie aplikacji Flutter od podstaw';

  @override
  String get teachYearsExperienceLabel => 'Lata doświadczenia w branży *';

  @override
  String get teachVideoLinkLabel =>
      'Link do próbnego wideo (YouTube/Drive/Loom) *';

  @override
  String get teachTargetAudienceLabel => 'Grupa docelowa kursu *';

  @override
  String get teachAudienceBeginners => 'Początkujący';

  @override
  String get teachAudienceIntermediate => 'Początkujący i średniozaawansowani';

  @override
  String get teachAudienceAdvanced => 'Zaawansowani i profesjonaliści';

  @override
  String get teachAudienceAll => 'Wszyscy';

  @override
  String get teachSkillsCoveredLabel =>
      'Umiejętności i technologie omawiane w kursie *';

  @override
  String get teachAddSkillHint => 'Dodaj umiejętność (np. GraphQL)...';

  @override
  String get teachAddSkillBtn => 'Dodaj';

  @override
  String get teachNextStepConfirm => 'Dalej: Potwierdź zgłoszenie';

  @override
  String get teachStep3Header => '3. Szczegóły wypłat i warunki';

  @override
  String get teachPayoutMethodLabel => 'Metoda wypłaty zarobków *';

  @override
  String get teachPayoutMethodBank => 'Przelew bankowy (IBAN)';

  @override
  String get teachPayoutMethodPaypal => 'Zweryfikowane konto PayPal';

  @override
  String get teachPayoutMethodPayoneer => 'Karta Payoneer';

  @override
  String get teachIbanDetailsLabel => 'Dane konta / IBAN *';

  @override
  String get teachApplicationSummary => 'Podsumowanie zgłoszenia:';

  @override
  String get teachApplicantName => 'Aplikant';

  @override
  String get teachApplicantHeadline => 'Specjalizacja';

  @override
  String get teachApplicantTopic => 'Temat kursu';

  @override
  String get teachApplicantSkillsCount => 'Liczba umiejętności';

  @override
  String get teachSkillsUnit => 'umiejętności';

  @override
  String get teachAgreeTermsLabel =>
      'Akceptuję warunki instruktorskie oraz umowę o prawach autorskich platformy EduLab.';

  @override
  String get teachSubmitApplicationBtn => 'Submit Instructor Application';

  @override
  String get teachPrevStepBtn => 'Wstecz';

  @override
  String get teachWhyEduLabTitle => 'Dlaczego warto uczyć w EduLab?';

  @override
  String get teachProp1Title => 'Uczciwe i wysokie zarobki';

  @override
  String get teachProp1Desc =>
      'Zarabiaj do 80% ze sprzedaży swoich kursów bez ukrytych opłat.';

  @override
  String get teachProp2Title => 'Dotrzyj do tysięcy studentów';

  @override
  String get teachProp2Desc =>
      'Promuj swój kurs wśród ogromnej społeczności uczących się.';

  @override
  String get teachProp3Title => 'Pełne wsparcie techniczne i produkcyjne';

  @override
  String get teachProp3Desc =>
      'Nasz zespół pomoże zoptymalizować jakość dźwięku, wideo i program nauczania.';

  @override
  String get teachSuccessDialogTitle => 'Zgłoszenie zostało przyjęte!';

  @override
  String get teachSuccessDialogDesc =>
      'Dziękujemy za dołączenie do EduLab. Nasz zespół przejrzy zgłoszenie i skontaktuje się w ciągu 48 godzin.';

  @override
  String get teachSuccessDialogOk => 'Rozumiem';

  @override
  String get teachAddOneSkillError => 'Dodaj co najmniej jedną umiejętność';

  @override
  String get teachAgreeTermsError => 'Zaakceptuj warunki instruktorskie';

  @override
  String get commonCancel => 'Anuluj';

  @override
  String get commonClose => 'Zamknij';

  @override
  String get myCertificatesBannerTitle => 'Akredytowane Certyfikaty';

  @override
  String get myCertificatesBannerSubtitle =>
      'Wszystkie certyfikaty są akredytowane i zweryfikowane unikalnym identyfikatorem EduLab';

  @override
  String get certBadgeVerified100 => '100% Akredytowany';

  @override
  String get certCodeCopied => 'Skopiowano kod certyfikatu';

  @override
  String get certGrantedTo => 'Przyznane dla';

  @override
  String get certViewAndDownload => 'Zobacz i pobierz certyfikat';

  @override
  String get certIssuerLabel => 'Organ wydający';

  @override
  String get certIssuerName => 'Akademia Interaktywnej Nauki EduLab';

  @override
  String get certEmptyTitle => 'Brak jeszcze zdobytych certyfikatów';

  @override
  String get certEmptyDesc =>
      'Ukończ 100% zapisanego kursu, aby otrzymać akredytowany certyfikat z oficjalnym identyfikatorem weryfikacji.';

  @override
  String get certEmptyAction => 'Kontynuuj moje kursy';

  @override
  String get certDetailsTitle => 'Szczegóły i informacje o certyfikacie';

  @override
  String get certCopyLinkSuccess =>
      'Bezpośredni link weryfikacyjny skopiowany do schowka!';

  @override
  String get certShareSuccess =>
      'Szczegóły certyfikatu i link skopiowane do udostępnienia!';

  @override
  String get purchaseHistoryTaxInvoiceCertified =>
      'Oficjalna certyfikowana faktura VAT';

  @override
  String get purchaseHistoryInvoiceNumberLabel => 'Nr zamówienia / faktury';

  @override
  String get purchaseHistoryCourseNameLabel => 'Nazwa kursu';

  @override
  String get purchaseHistoryPurchaseDateLabel => 'Data zakupu';

  @override
  String get purchaseHistoryPaymentMethodLabel => 'Metoda płatności';

  @override
  String get purchaseHistoryPaymentMethodValue =>
      'Karta kredytowa / Stripe (Online)';

  @override
  String get purchaseHistoryOrderStatusLabel => 'Status zamówienia';

  @override
  String get purchaseHistoryStatusPendingReview =>
      'Oczekiwanie na rozpatrzenie zwrotu';

  @override
  String get purchaseHistoryCopyInvoiceBtn => 'Kopiuj numer faktury';

  @override
  String get purchaseHistoryRefundReasonLabel => 'Powód wniosku o zwrot:';

  @override
  String get purchaseHistoryRefundReasonEmptyError =>
      'Podaj powód wniosku o zwrot';

  @override
  String get purchaseHistorySubmittingRefund => 'Wysyłanie wniosku...';

  @override
  String get purchaseHistoryPaidDate => 'Data płatności';

  @override
  String get purchaseHistoryEmptyTitle => 'Brak historii zakupów';

  @override
  String get purchaseHistoryEmptyDesc =>
      'Nie kupiłeś jeszcze żadnego kursu.\nTwoje zamówienia i faktury pojawią się tutaj po zakończeniu.';

  @override
  String get purchaseHistoryExploreCourses => 'Przeglądaj kursy teraz';

  @override
  String get profileMyCourses => 'Moje Kursy';

  @override
  String get profileMyCoursesSubtitle => 'Śledź postępy w zapisanych kursach';

  @override
  String get profileWishlistSubtitle => 'Kursy zapisane na liście życzeń';

  @override
  String get navMyLearning => 'Moja Nauka';

  @override
  String get profileLogoutSafeNote =>
      'Twoje dane, kursy i certyfikaty są w pełni bezpieczne. Możesz kontynuować naukę w dowolnym momencie, logując się ponownie.';

  @override
  String learningRemainingHours(String hours) {
    return 'Pozostało $hours godz.';
  }

  @override
  String get learningCompletedFull => 'Ukończono';

  @override
  String get learningFilterNotStarted => 'Nierozpoczęte';

  @override
  String get wishlistTopRatedBadge => 'Najwyżej oceniane';

  @override
  String get wishlistFeaturedBadge => 'Wyróżnione';

  @override
  String wishlistDiscountBadge(String percent) {
    return '$percent% zniżki';
  }

  @override
  String get courseFree => 'Darmowy';

  @override
  String get badgeBestseller => 'Bestseller';

  @override
  String get badgeTopRated => 'Najwyżej oceniane';

  @override
  String get badgeFeatured => 'Wyróżnione';

  @override
  String get badgeRecommended => 'Polecane dla Ciebie';

  @override
  String get badgeNew => 'Nowość';

  @override
  String get courseWord => 'Kurs';

  @override
  String coursesCountText(String count) {
    return '$count+ Kursów';
  }

  @override
  String studentsCountText(String count) {
    return '$count Kursantów';
  }

  @override
  String hoursCountText(String count) {
    return '$count Godz.';
  }

  @override
  String get certifiedInstructor => 'Certyfikowany Instruktor';

  @override
  String get expertCertifiedInstructor => 'Ekspert i Certyfikowany Instruktor';

  @override
  String get defaultCourseTitle => 'Kurs Edukacyjny';

  @override
  String get categoryWord => 'Kategoria';

  @override
  String get previewCourseVideo => 'Podgląd wideo kursu';

  @override
  String get freeSection => 'Darmowa Sekcja';

  @override
  String get freeDemoVideo => 'Darmowe Wideo Demo';

  @override
  String get articleLecture => 'Lekcja Artykułowa';

  @override
  String get articleViewer => 'Czytnik Artykułów';

  @override
  String get courseVideoPlayer => 'Odtwarzacz Wideo Kursu';

  @override
  String get playingNow => 'Odtwarzanie';

  @override
  String get readingNow => 'Czytanie';

  @override
  String get noLecturesInFreeSection => 'Brak lekcji w darmowej sekcji';

  @override
  String freeLecturesCount(String count) {
    return '$count darmowych lekcji';
  }

  @override
  String get enrollInFullCourse => 'Zapisz się na pełny kurs';

  @override
  String get articleWord => 'Artykuł';

  @override
  String get videoWord => 'Wideo';

  @override
  String get quizWord => 'Quiz';

  @override
  String get courseShareCopied => 'Link do kursu skopiowany do schowka!';

  @override
  String get addedToCartSnackbar => 'Dodano do koszyka';

  @override
  String get viewCartAction => 'Zobacz Koszyk';

  @override
  String get inCartBadge => 'W koszyku ✓';

  @override
  String get addToCartButton => 'Dodaj do koszyka';

  @override
  String get wishlistAddedSnackbar => 'Dodano kurs do listy życzeń';

  @override
  String get wishlistRemovedSuccessSnackbar => 'Usunięto kurs z listy życzeń';

  @override
  String get lessonCompletedAll =>
      'Gratulacje! Ukończyłeś wszystkie lekcje w tym kursie.';

  @override
  String get noteAddedSuccess => 'Notatka została pomyślnie dodana';

  @override
  String get lessonAlreadyDownloaded => 'Lekcja jest już zapisana offline';

  @override
  String get lessonLinkCopied => 'Skopiowano link do lekcji';

  @override
  String get contentReportThanks =>
      'Dziękujemy za opinię, sprawdzimy tę lekcję.';

  @override
  String get courseCompletionCertificate => 'Certyfikat Ukończenia Kursu';

  @override
  String get reportContentIssue => 'Zgłoś problem z treścią';

  @override
  String get loginOrSocial => 'Lub zaloguj się przez';

  @override
  String get loginSuccessSnackbar => 'Zalogowano pomyślnie';

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
  String get cartClearAllTitle => 'Wyczyścić wszystkie pozycje koszyka?';

  @override
  String cartClearAllMessage(String count) {
    return 'Czy na pewno chcesz usunąć wszystkie $count kursy ze swojego koszyka?';
  }

  @override
  String get cartClearAllHint =>
      'Wszystkie kursy zostaną usunięte z Twojego koszyka. Możesz je dodać ponownie w dowolnym momencie.';

  @override
  String cartClearAllConfirm(String count) {
    return 'Wyczyść wszystko ($count)';
  }

  @override
  String get cartClearedSuccess => 'Koszyk został pomyślnie wyczyszczony';

  @override
  String get cartClearFailed => 'Nie udało się wyczyścić koszyka';

  @override
  String cartViewWishlistCount(String count) {
    return 'Wyświetl pozycje listy życzeń ($count)';
  }

  @override
  String get cartGoToWishlist => 'Przejdź do listy życzeń';

  @override
  String get wishlistClearAllTitle =>
      'Wyczyścić wszystkie pozycje z listy życzeń?';

  @override
  String wishlistClearAllMessage(String count) {
    return 'Czy na pewno chcesz usunąć wszystkie $count kursy ze swojej listy życzeń?';
  }

  @override
  String get wishlistClearAllHint =>
      'Wszystkie zapisane kursy zostaną usunięte. Możesz je dodać ponownie w dowolnym momencie w Eksploruj.';

  @override
  String wishlistClearAllConfirm(String count) {
    return 'Wyczyść wszystko ($count)';
  }

  @override
  String get wishlistClearedSuccess =>
      'Lista życzeń została pomyślnie wyczyszczona';

  @override
  String get wishlistClearFailed => 'Nie udało się wyczyścić listy życzeń';

  @override
  String get wishlistClearTooltip => 'Wyczyść wszystko';

  @override
  String wishlistViewCartCount(String count) {
    return 'Wyświetl pozycje w koszyku ($count)';
  }

  @override
  String get wishlistGoToCart => 'Przejdź do koszyka';

  @override
  String get checkoutCardNumberInvalid =>
      'Proszę wprowadzić prawidłowy 16-cyfrowy numer karty';

  @override
  String get checkoutCardExpiryInvalidFormat =>
      'Proszę podać prawidłową datę ważności karty (MM/RR)';

  @override
  String get checkoutCardExpiredDate =>
      'Data ważności karty jest nieprawidłowa';

  @override
  String get checkoutCardCvcInvalid =>
      'Proszę wprowadzić ważny 3 lub 4-cyfrowy kod CVC';

  @override
  String get checkoutCardHolderNameRequired =>
      'Proszę podać imię i nazwisko posiadacza karty';

  @override
  String get checkoutCartEmptySnackbar => 'Koszyk jest pusty';

  @override
  String get checkoutPaymentStartFailed =>
      'Nie udało się zainicjować płatności';

  @override
  String get checkoutClientSecretMissing =>
      'Klucz bezpieczeństwa nie został odebrany z bramki płatniczej';

  @override
  String get checkoutCardVerificationFailed =>
      'Weryfikacja karty nie powiodła się';

  @override
  String get checkoutStripeProcessingFailed =>
      'Przetworzenie płatności Stripe nie powiodło się';

  @override
  String get checkoutServerConfirmationFailed =>
      'Potwierdzenie płatności za serwer nie powiodło się';

  @override
  String get checkoutEmptyCartTitle => 'Twój koszyk jest pusty';

  @override
  String get checkoutEmptyCartDesc =>
      'Nie dodałeś jeszcze żadnych kursów do koszyka. Poznaj nasze kursy i rozpocznij naukę!';

  @override
  String get checkoutContinueFreeReview => 'Przejdź do bezpłatnej recenzji';

  @override
  String get checkoutFreeOrderBadge => '100% darmowe zamówienie (zsh.00)';

  @override
  String get checkoutFreeOrderNotice =>
      'To zamówienie nie wymaga żadnych informacji o płatności. Możesz przejść bezpośrednio do potwierdzenia rejestracji.';

  @override
  String get checkoutFreeCheckoutTitle => '100% darmowa płatność';

  @override
  String get checkoutConfirmFreeEnrollment => 'Potwierdź bezpłatną rejestrację';

  @override
  String get checkoutFreePrice => 'Bezpłatny';

  @override
  String get checkoutFreeZero => 'Bezpłatny (zsh.00)';

  @override
  String checkoutCoursesCount(String count) {
    return '$count kursów';
  }

  @override
  String get notificationsClearAllTitle => 'Wyczyścić wszystkie powiadomienia?';

  @override
  String notificationsClearAllMessage(String count) {
    return 'Czy na pewno chcesz usunąć wszystkie powiadomienia $count? Tej akcji nie można cofnąć.';
  }

  @override
  String get notificationsClearAllHint =>
      'Wszystkie Twoje powiadomienia zostaną usunięte, a Twoja skrzynka odbiorcza zacznie się od nowa.';

  @override
  String notificationsClearAllConfirm(String count) {
    return 'Wyczyść wszystko ($count)';
  }

  @override
  String get notificationsClearSuccess =>
      'Wszystkie powiadomienia zostały pomyślnie usunięte';

  @override
  String get notificationsClearFailed => 'Nie udało się wyczyścić powiadomień';

  @override
  String get notificationsClearTooltip => 'Wyczyść wszystko';

  @override
  String get notificationsViewDetails => 'Zobacz szczegóły';

  @override
  String get notificationsEmptyCategoryTitle =>
      'Brak powiadomień w tej kategorii';

  @override
  String get notificationsEmptyCategorySubtitle =>
      'Spróbuj przejść do innej kategorii lub przejrzyj wszystkie powiadomienia';

  @override
  String get notificationsEmptyAllSubtitle =>
      'Tutaj będziemy na bieżąco informować Cię o najnowszych aktualizacjach i alertach';

  @override
  String get notificationsViewAll => 'Wyświetl wszystkie powiadomienia';

  @override
  String get learningFilterAndSortTitle => 'Filtruj i sortuj kursy';

  @override
  String get learningFilterReset => 'Nastawić';

  @override
  String get learningSortByTitle => 'Sortuj według';

  @override
  String get learningSortRecentActivity => 'Ostatnio dostępny';

  @override
  String get learningSortRecentEnrolled => 'Ostatnio zarejestrowany';

  @override
  String get learningSortTitleAZ => 'Tytuł (A-Z)';

  @override
  String get learningSortProgress => 'Postęp%';

  @override
  String get learningStatusTitle => 'Stan kursu';

  @override
  String get learningStatusAll => 'Wszystkie kursy';

  @override
  String get learningStatusInProgress => 'W toku';

  @override
  String get learningStatusCompleted => 'Zakończony';

  @override
  String get learningStatusNotStarted => 'Nie rozpoczęte';

  @override
  String get learningFilterApply => 'Zastosuj filtry';

  @override
  String get learningSearchCoursesHint => 'Przeszukaj swoje kursy...';

  @override
  String get learningSearchWishlistHint => 'Przeszukaj listę życzeń...';

  @override
  String get learningSearchCertificatesHint => 'Wyszukaj certyfikaty...';

  @override
  String get learningTabMyCourses => 'Moje kursy';

  @override
  String get learningTabFavourite => 'Mój ulubiony';

  @override
  String get learningTabCertificates => 'Moje certyfikaty';

  @override
  String get learningNoCoursesTitle => 'Nie ma jeszcze żadnych kursów';

  @override
  String get learningNoCoursesSubtitle =>
      'Przeglądaj tysiące kursów premium i rozpocznij swoją podróż edukacyjną już dziś';

  @override
  String get learningFilterButton => 'Filtr';

  @override
  String learningFilterAllCount(String count) {
    return 'Wszystko ($count)';
  }

  @override
  String get learningStatusNotStartedShort => 'Nie rozpoczęte';

  @override
  String get learningNoMatchTitle => 'Brak pasujących kursów';

  @override
  String learningNoMatchSubtitle(String query) {
    return 'Nie znaleziono kursów zawierających „$query”. Spróbuj wyszukać za pomocą różnych terminów.';
  }

  @override
  String get learningNoInProgressTitle => 'Brak trwających kursów';

  @override
  String get learningNoInProgressSubtitle =>
      'Zacznij oglądać lekcje w ramach zapisanych kursów, aby śledzić swoje postępy tutaj.';

  @override
  String get learningNoCompletedTitle => 'Nie ma jeszcze ukończonych kursów';

  @override
  String get learningNoCompletedSubtitle =>
      'Kontynuuj naukę, aby uczcić swoje postępy i zobaczyć ukończone kursy tutaj.';

  @override
  String get learningNoUnstartedTitle => 'Żadnych nierozpoczętych kursów';

  @override
  String get learningNoUnstartedSubtitle =>
      'Wspaniały! Rozpocząłeś już naukę na wszystkich zapisanych kursach.';

  @override
  String get learningNoFilterMatchTitle =>
      'Żaden kurs nie pasuje do tego filtra';

  @override
  String get learningNoFilterMatchSubtitle =>
      'Zmień opcje filtrowania lub sortowania, aby wyświetlić swoje kursy.';

  @override
  String learningViewAllCoursesCount(String count) {
    return 'Wyświetl wszystkie kursy ($count)';
  }

  @override
  String learningSavedCoursesCount(String count) {
    return 'Zapisane kursy ($count)';
  }

  @override
  String get learningClearAllSaved => 'Wyczyść wszystko';

  @override
  String get learningNoCertificatesTitle =>
      'Nie ma jeszcze żadnych certyfikatów';

  @override
  String get learningNoCertificatesSubtitle =>
      'Ukończ kursy, aby zdobyć akredytowane certyfikaty weryfikujące Twoje osiągnięcia';

  @override
  String get learningGoToCourses => 'Przejdź do Moich kursów';

  @override
  String learningCertIssuedDate(String date) {
    return 'Wydano: $date';
  }

  @override
  String get learningCertView => 'Pogląd';

  @override
  String get learningResumeLesson => 'Wznów lekcję';

  @override
  String learningProgressPercentComplete(String percent) {
    return '$percent% ukończono';
  }

  @override
  String learningViewCartCount(String count) {
    return 'Wyświetl pozycje w koszyku ($count)';
  }

  @override
  String get learningGoToCart => 'Przejdź do koszyka';

  @override
  String get playerLessonMarkedCompleted => 'Lekcja oznaczona jako ukończona ✓';

  @override
  String get playerLessonMarkedIncomplete =>
      'Lekcja oznaczona jako niekompletna';

  @override
  String get playerCommentPostedSuccess => 'Komentarz został wysłany pomyślnie';

  @override
  String get playerCommentPostFailed => 'Nie udało się opublikować komentarza';

  @override
  String get playerReplyPostedSuccess => 'Odpowiedź została wysłana pomyślnie';

  @override
  String get playerReplyPostFailed => 'Nie udało się opublikować odpowiedzi';

  @override
  String get playerCourseNotFound => 'Nie znaleziono kursu';

  @override
  String get playerCheckEnrollmentPrompt =>
      'Najpierw sprawdź swoje zapisy na kurs';

  @override
  String get playerReturnToCourses => 'Moja nauka';

  @override
  String get playerWatchLecture => 'Wykład kursowy';

  @override
  String get playerCertificateTooltip => 'Certyfikat';

  @override
  String get playerRateCourseTooltip => 'Kurs kursu';

  @override
  String get playerReadingArticleBadge => 'Czytanie artykułu • 5 minut';

  @override
  String get playerReadFullTextBelow => 'Przeczytaj pełny tekst poniżej ↓';

  @override
  String get playerTabReviews => 'Recenzje';

  @override
  String get playerNoSectionsAvailable => 'Brak dostępnych sekcji';

  @override
  String playerLessonsCount(String count) {
    return '$count lekcje';
  }

  @override
  String get playerPlayingBadge => 'Gra';

  @override
  String get playerArticleBadge => 'Artykuł';

  @override
  String get playerVideoBadge => 'Wideo';

  @override
  String get playerFullArticleContent => 'Pełna treść artykułu';

  @override
  String get playerArticlePlaceholder =>
      'Witamy na tej lekcji czytania.\n\nW tej części omówiono podstawowe pojęcia i praktyczne kroki potrzebne do opanowania umiejętności przedstawionych w tej lekcji.';

  @override
  String get playerAboutCourseTitle => 'O tym kursie';

  @override
  String get playerShowLess => 'Pokaż mniej';

  @override
  String get playerReadMore => 'Czytaj więcej';

  @override
  String get playerWhatYouWillLearn => 'Czego się nauczysz';

  @override
  String get playerCourseInfoTitle => 'Szczegóły kursu';

  @override
  String get playerTotalDurationTitle => 'Łączny czas';

  @override
  String get playerTotalLessonsTitle => 'Liczba lekcji';

  @override
  String playerLessonsNumber(String count) {
    return '$count lekcji';
  }

  @override
  String get playerLevelTitle => 'Poziom';

  @override
  String get playerAllLevels => 'Wszystkie poziomy';

  @override
  String get playerLanguageTitle => 'Język';

  @override
  String get playerLanguageArabic => 'Arabski';

  @override
  String get playerPrerequisitesTitle => 'Wymagania kursu';

  @override
  String get playerCertificateCardTitle => 'Certyfikat ukończenia';

  @override
  String get playerCourseCompletedSuccess => 'Gratulacje! Kurs ukończony';

  @override
  String get playerProgressLabel => 'Postęp';

  @override
  String get playerViewCertificateBtn => 'Zobacz certyfikat';

  @override
  String get playerCertifiedInstructor => 'Certyfikowany instruktor';

  @override
  String playerDiscussionsCount(String count) {
    return '$count pytań i dyskusji';
  }

  @override
  String get playerAskQuestionHint =>
      'Wpisz swoje pytanie lub zapytanie tutaj...';

  @override
  String get playerPostBtn => 'Opublikuj';

  @override
  String get playerNoDiscussionsTitle => 'Brak dyskusji';

  @override
  String get playerNoDiscussionsSubtitle =>
      'Bądź pierwszą osobą, która zada pytanie!';

  @override
  String get playerInstructorBadge => 'Instruktor';

  @override
  String get playerCancelReply => 'Anuluj';

  @override
  String get playerReplyAction => 'Odpowiedz';

  @override
  String playerRepliesCount(String count) {
    return '$count odpowiedzi';
  }

  @override
  String get playerWriteReplyHint => 'Napisz odpowiedź...';

  @override
  String get playerSendReplyBtn => 'Odpowiedz';

  @override
  String get playerCourseFeedbackTitle => 'Oceny i opinie o kursie';

  @override
  String get playerOutOf5 => 'z 5';

  @override
  String playerRatingsFromEnrolledCount(String count) {
    return '$count ocen od zapisanych uczestników';
  }

  @override
  String get playerKeepLearningToRate => 'Ucz się dalej, aby wystawić ocenę';

  @override
  String get playerRateAfter80Hint =>
      'Możesz ocenić ten kurs po ukończeniu 80% materiału';

  @override
  String get playerCurrentProgressLabel => 'Twój postęp:';

  @override
  String get playerYourCurrentRating => 'Twoja ocena';

  @override
  String get playerEditRating => 'Edytuj ocenę';

  @override
  String get playerDeleteRatingTooltip => 'Usuń ocenę';

  @override
  String get playerUpdateRatingTitle => 'Zaktualizuj ocenę';

  @override
  String get playerRateCourseTitle => 'Oceń ten kurs';

  @override
  String get playerWriteReviewHint =>
      'Napisz swoją opinię o jakości materiałów (opcjonalnie)...';

  @override
  String get playerRatingSubmitSuccess => 'Ocena została pomyślnie przesłana!';

  @override
  String get playerRatingSubmitFailed => 'Nie udało się przesłać oceny';

  @override
  String get playerSaveChangesBtn => 'Zapisz zmiany';

  @override
  String get playerSubmitReviewBtn => 'Prześlij opinię';

  @override
  String get playerLearnerReviewsTitle => 'Opinie uczestników';

  @override
  String playerReviewsCount(String count) {
    return '$count opinii';
  }

  @override
  String get playerNoWrittenReviewsTitle => 'Brak pisemnych opinii';

  @override
  String get playerNoWrittenReviewsSubtitle =>
      'Bądź pierwszą osobą, która podzieli się opinią!';

  @override
  String get playerRatingLabel5 => 'Doskonale 🌟 (5/5)';

  @override
  String get playerRatingLabel4 => 'Bardzo dobrze 👍 (4/5)';

  @override
  String get playerRatingLabel3 => 'Przeciętnie 👌 (3/5)';

  @override
  String get playerRatingLabel2 => 'Wymaga poprawy 🤔 (2/5)';

  @override
  String get playerRatingLabel1 => 'Słabo 👎 (1/5)';

  @override
  String get playerDeleteRatingDialogTitle => 'Usuń ocenę';

  @override
  String get playerDeleteRatingDialogMessage =>
      'Czy na pewno chcesz usunąć swoją opinię o tym kursie?';

  @override
  String get playerDeleteConfirmBtn => 'Usuń';

  @override
  String get playerRatingDeleteSuccess => 'Ocena została pomyślnie usunięta';

  @override
  String get playerPreviousLesson => 'Poprzednia lekcja';

  @override
  String get playerExitFullscreenTooltip => 'Zamknij pełny ekran';

  @override
  String instructorsAvailableCount(String count) {
    return '$count dostępnych instruktorów';
  }

  @override
  String get instructorsNotFound => 'Nie znaleziono instruktorów';

  @override
  String instructorsCoursesCount(String count) {
    return '$count kursów';
  }

  @override
  String get instructorsSearchHint =>
      'Szukaj według nazwiska instruktora lub specjalności...';

  @override
  String get instructorsSortAll => 'Wszystko';

  @override
  String get instructorsSortTopRated => 'Najwyżej oceniane';

  @override
  String get instructorsSortMostStudents => 'Większość studentów';

  @override
  String get instructorsSortMostCourses => 'Większość kursów';

  @override
  String get instructorsNotFoundSubtitle =>
      'Spróbuj wyszukać pod inną nazwą lub wyczyść filtry';

  @override
  String get exploreCompleteCourse => 'Kurs kompleksowy';

  @override
  String get exploreGeneralCategory => 'Ogólny';

  @override
  String courseShareMessage(String title, String url) {
    return 'Sprawdź kurs \"$title\" na EduLab: $url';
  }

  @override
  String get courseDetailsDefaultTitle => 'Szczegóły kursu';

  @override
  String get courseDetailsTooltipShare => 'Udział';

  @override
  String get courseDetailsTooltipWishlist => 'Lista życzeń';

  @override
  String get courseDetailsTooltipCart => 'Wózek';

  @override
  String get courseDetailsNotFound => 'Nie znaleziono kursu';

  @override
  String get courseDetailsDefaultCategory => 'Kurs';

  @override
  String courseDetailsTotalRatingsCount(String count) {
    return '($count oceny)';
  }

  @override
  String courseDetailsLecturesCount(String count) {
    return '$count wykłady';
  }

  @override
  String get courseDetailsCertificateBadge => 'Certyfikat';

  @override
  String get courseDetailsTabOverview => 'Przegląd';

  @override
  String get courseDetailsTabCurriculum => 'Program';

  @override
  String get courseDetailsTabInstructor => 'Instruktor';

  @override
  String get courseDetailsTabReviews => 'Recenzje';

  @override
  String get courseDetailsFullDescriptionTitle => 'Opis';

  @override
  String get courseDetailsShowLess => 'Pokaż mniej';

  @override
  String get courseDetailsShowMore => 'Pokaż więcej...';

  @override
  String courseDetailsCurriculumSectionsLectures(
    String sections,
    String lectures,
  ) {
    return '$sections sekcje • $lectures wykłady';
  }

  @override
  String get courseDetailsCollapseAll => 'Zwiń wszystko';

  @override
  String get courseDetailsExpandAll => 'Rozwiń wszystko';

  @override
  String get courseDetailsCurriculumComingSoon => 'Szczegóły zajęć już wkrótce';

  @override
  String courseDetailsSectionLecturesCount(String count) {
    return '$count wykłady';
  }

  @override
  String get courseDetailsLecturePreviewBtn => 'Zapowiedź';

  @override
  String get courseDetailsDefaultInstructorTitle =>
      'Starszy Instruktor i Certyfikowany Ekspert';

  @override
  String get courseDetailsInstructorRatingLabel => 'Ocena';

  @override
  String get courseDetailsInstructorStudentsLabel => 'Studenci';

  @override
  String get courseDetailsInstructorSectionsLabel => 'Sekcje';

  @override
  String get courseDetailsAboutInstructorTitle => 'O instruktorze:';

  @override
  String get courseDetailsDefaultInstructorAbout =>
      'Certyfikowany instruktor z dużym doświadczeniem w dostarczaniu profesjonalnej edukacji tysiącom studentów na całym świecie.';

  @override
  String courseDetailsStudentRatingsCount(String count) {
    return '$count oceny uczniów';
  }

  @override
  String get courseDetailsNoWrittenReviews =>
      'Nie ma jeszcze żadnych pisemnych recenzji';

  @override
  String get courseDetailsRelatedCourses =>
      'Powiązane kursy, które mogą Ci się spodobać';

  @override
  String courseDetailsDiscountPercent(String percent) {
    return '$percent% ZNIŻKI';
  }

  @override
  String get courseDetailsResumeCourse => 'Wznów kurs';

  @override
  String get courseDetailsTryAgain => 'Spróbuj ponownie';

  @override
  String get courseDetailsEstimatedReading =>
      '📖 Szacowany czas czytania: 4 minuty';

  @override
  String get courseDetailsSampleArticleContent =>
      'Witamy w tym artykule na wykładzie.\n\nW tej części omówiono kluczowe koncepcje teoretyczne i praktyczne kroki prowadzące do opanowania tematu.\n\n• Kluczowe wnioski:\n1. Zrozumieć podstawową terminologię i wzorce architektoniczne.\n2. Ćwiczenia praktyczne i ciągła praktyka.\n3. Odniesienia do dodatkowych notatek i zadań.\n\nMiłej lektury!';

  @override
  String certDownloadedSuccess(String course, String format) {
    return 'Certyfikat dla „$course” pobrany pomyślnie w formacie $format!';
  }

  @override
  String certVerifiedFullRequirements(String code) {
    return 'Identyfikator weryfikacji: $code • Spełniono wymagania w 100%.';
  }

  @override
  String get certCompletionTitle => 'Świadectwo ukończenia';

  @override
  String get certCompletionSubtitle => 'Certyfikat ukończenia kursu';

  @override
  String get certAnnounceStudent =>
      'EducationLab Learning Academy niniejszym zaświadcza, że:';

  @override
  String get certCompletionRequirementsMet =>
      'Pomyślnie ukończył wszystkie wymagania kursu szkoleniowego:';

  @override
  String certIssueDateText(String date) {
    return 'Data wydania: $date';
  }

  @override
  String certIdNumberText(String code) {
    return 'Identyfikator certyfikatu: $code';
  }

  @override
  String get certPlatformManagement => 'Zarządzanie platformą';

  @override
  String get certInstructorRoleTitle => 'Instruktor kursu';

  @override
  String get commonLoading => 'Załadunek...';

  @override
  String get homeGuestTagline =>
      'Inteligentna platforma do nauki i budowania umiejętności';

  @override
  String get catTagHighestDemand => 'Najbardziej poszukiwane';

  @override
  String get catTagMostPopular => 'Najpopularniejsze';

  @override
  String get catTagTrending => 'Na czasie';

  @override
  String get catTagFastestGrowing => 'Najszybciej rosnące';

  @override
  String get catTagHighDemand => 'Duży popyt';

  @override
  String get catTagTopRated => 'Najwyżej oceniane';

  @override
  String get catTagEssential => 'Kluczowe';

  @override
  String get catTagAdvanced => 'Poziom zaawansowany';

  @override
  String get catTagEntrepreneurs => 'Przedsiębiorcy';

  @override
  String get catTagSalesGrowth => 'Wzrost sprzedaży';

  @override
  String get catDevTitle => 'Programowanie i tworzenie oprogramowania';

  @override
  String get catDevSubtitle => 'Inżynieria oprogramowania, systemy i algorytmy';

  @override
  String get catWebTitle => 'Tworzenie stron internetowych';

  @override
  String get catWebSubtitle => 'Frontend, Backend i Fullstack Web';

  @override
  String get catMobileTitle => 'Tworzenie aplikacji mobilnych';

  @override
  String get catMobileSubtitle => 'Aplikacje Flutter, iOS i Android';

  @override
  String get catAiTitle => 'Sztuczna inteligencja';

  @override
  String get catAiSubtitle => 'Uczenie maszynowe, Deep Learning i AI';

  @override
  String get catDataTitle => 'Data Science i analityka';

  @override
  String get catDataSubtitle => 'Analiza danych, statystyka i Big Data';

  @override
  String get catDesignTitle => 'Projektowanie UI/UX i produktu';

  @override
  String get catDesignSubtitle => 'UI/UX, prototypowanie i design produktu';

  @override
  String get catSecurityTitle => 'Cyberbezpieczeństwo i sieci';

  @override
  String get catSecuritySubtitle =>
      'Cyberbezpieczeństwo, etyczny hacking i sieci';

  @override
  String get catCloudTitle => 'Cloud Computing i DevOps';

  @override
  String get catCloudSubtitle => 'Infrastruktura chmurowa, DevOps i CI/CD';

  @override
  String get catBusinessTitle => 'Zarządzanie biznesem i projektami';

  @override
  String get catBusinessSubtitle => 'Przedsiębiorczość, Agile i przywództwo';

  @override
  String get catMarketingTitle => 'Marketing cyfrowy';

  @override
  String get catMarketingSubtitle =>
      'Marketing cyfrowy, SEO i strategie wzrostu';

  @override
  String get timeJustNow => 'Przed chwilą';

  @override
  String timeMinutesAgo(String count) {
    return '$count min temu';
  }

  @override
  String timeHoursAgo(String count) {
    return '$count godz. temu';
  }

  @override
  String timeDaysAgo(String count) {
    return '$count dni temu';
  }

  @override
  String timeWeeksAgo(String count) {
    return '$count tyg. temu';
  }

  @override
  String timeMonthsAgo(String count) {
    return '$count mies. temu';
  }

  @override
  String wishlistLecturesCount(String count) {
    return '$count lekcji';
  }

  @override
  String get instructorProfileTitle => 'Profil instruktora';

  @override
  String instructorProfileLinkCopied(String name) {
    return 'Link dla $name skopiowany do schowka';
  }

  @override
  String get instructorDefaultName => 'Instruktor';

  @override
  String get instructorProfileBadge => 'INSTRUKTOR';

  @override
  String get instructorProfileTotalStudents => 'Łącznie studentów';

  @override
  String get instructorProfileRating => 'Ocena instruktora';

  @override
  String get instructorProfileCourses => 'Kursy';

  @override
  String get instructorProfileShare => 'Udostępnij profil';

  @override
  String get instructorProfileLinkOpenError =>
      'Nie udało się otworzyć linku, skopiowano do schowka';

  @override
  String get instructorProfileWebsite => 'Strona internetowa';

  @override
  String get instructorProfileAboutMe => 'O mnie';

  @override
  String get instructorProfileShowLess => 'Pokaż mniej';

  @override
  String get instructorProfileShowMore => 'Pokaż więcej';

  @override
  String get instructorProfileExpertise => 'Obszary specjalizacji';

  @override
  String get instructorProfileSortAll => 'Wszystkie';

  @override
  String get instructorProfileSortTopRated => 'Najwyżej oceniane';

  @override
  String get instructorProfileSortPopular => 'Popularne';

  @override
  String get instructorProfileSortNewest => 'Najnowsze';

  @override
  String get instructorProfileCoursesTitle => 'Kursy instruktora';

  @override
  String get instructorProfileNoCoursesFilter => 'Brak kursów dla tego filtra';

  @override
  String instructorProfileLoadMoreCourses(String count) {
    return 'Załaduj więcej kursów (pozostało: $count)';
  }

  @override
  String get instructorProfileLoadingMoreCourses =>
      'Ładowanie kolejnych kursów...';

  @override
  String instructorProfileAllCoursesLoaded(String count) {
    return 'Wszystkie kursy ($count) zostały załadowane';
  }

  @override
  String get instructorProfileStudentFeedback => 'Opinie studentów';

  @override
  String instructorProfileReviewsCount(String count) {
    return '$count opinii';
  }

  @override
  String instructorProfileBasedOnReviews(String count) {
    return 'Na podstawie $count opinii';
  }

  @override
  String get instructorProfileRecentReviews => 'Ostatnie opinie';

  @override
  String instructorProfileLoadMoreReviews(String count) {
    return 'Załaduj więcej opinii (pozostało: $count)';
  }

  @override
  String get instructorProfileLoadingMoreReviews =>
      'Ładowanie kolejnych opinii...';

  @override
  String instructorProfileAllReviewsLoaded(String count) {
    return 'Wszystkie opinie ($count) zostały załadowane';
  }

  @override
  String get instructorProfileNoReviewsYet => 'Brak pisemnych opinii';

  @override
  String get instructorProfileRatingDesc =>
      'Ocena opiera się na ogólnych ocenach studentów ze wszystkich kursów instruktora';

  @override
  String get instructorProfileLoadError =>
      'Nie udało się załadować danych instruktora, spróbuj ponownie później';

  @override
  String get instructorProfileDefaultStudentName => 'Student';

  @override
  String get instructorProfileDefaultHeadline =>
      'Starszy Instruktor i Certyfikowany Ekspert';

  @override
  String get instructorProfileDefaultBio =>
      'Certyfikowany inżynier oprogramowania i instruktor techniczny z dużym doświadczeniem w tworzeniu skalowalnych systemów oprogramowania oraz aplikacji mobilnych.\nPrzeszkolił tysiące studentów i inżynierów na całym świecie, dostarczając profesjonalne treści skoncentrowane na czystym kodzie, czystej architekturze i nowoczesnych skalowalnych rozwiązaniach.';

  @override
  String get supportNewChat => 'Nowy czat';

  @override
  String get supportNoChatsTitle => 'Brak czatów pomocy';

  @override
  String get supportNoChatsDesc =>
      'Nasz zespół wsparcia jest dostępny 24/7, aby pomóc i odpowiedzieć na wszystkie Twoje pytania';

  @override
  String get supportStartNewConversation => 'Rozpocznij nową rozmowę';

  @override
  String get supportNoMessagesYet => 'Brak wiadomości';

  @override
  String get supportRetry => 'Spróbuj ponownie';

  @override
  String get supportOpenTicket => 'Otwarte zgłoszenie';

  @override
  String get supportClosedTicket => 'Zamknięte zgłoszenie';

  @override
  String get supportCloseAction => 'Zamknij';

  @override
  String get supportReopenAction => 'Otwórz ponownie';

  @override
  String get supportNoMessagesInChat => 'Brak wiadomości w tym czacie';

  @override
  String get supportYou => 'Ty';

  @override
  String get supportTeam => 'Zespół wsparcia';

  @override
  String get supportTypeMessageHint => 'Napisz wiadomość tutaj...';

  @override
  String get supportConversationClosedNotice =>
      'Ta rozmowa jest obecnie zamknięta.';

  @override
  String get supportCloseDialogTitle => 'Zamknąć rozmowę?';

  @override
  String get supportCloseDialogDesc =>
      'Czy na pewno chcesz zamknąć ten czat? Możesz go ponownie otworzyć w dowolnym momencie, aby kontynuować.';

  @override
  String get supportCancel => 'Anuluj';

  @override
  String get supportYesClose => 'Tak, zamknij';

  @override
  String get supportNewChatTitle => 'Nowy czat pomocy';

  @override
  String get supportNewChatSubtitle => 'Nasz zespół chętnie Ci pomoże';

  @override
  String get supportSubjectLabel => 'Temat';

  @override
  String get supportSubjectHint =>
      'np. Pytanie o kurs, Problem z płatnością...';

  @override
  String get supportMessageLabel => 'Wiadomość';

  @override
  String get supportMessageHint =>
      'Opisz szczegółowo swój problem lub pytanie...';

  @override
  String get supportMessageRequired => 'Wprowadź wiadomość';

  @override
  String get supportStartConversationBtn => 'Rozpocznij rozmowę';

  @override
  String get supportCreateError =>
      'Nie udało się utworzyć rozmowy, spróbuj ponownie później';

  @override
  String get supportTopicCourse => 'Pytanie o kurs';

  @override
  String get supportTopicPayment => 'Problem z płatnością';

  @override
  String get supportTopicCertificates => 'Certyfikaty';

  @override
  String get supportTopicTech => 'Problem techniczny';

  @override
  String get supportTopicGeneral => 'Zapytanie ogólne';

  @override
  String get cartGuestTitle => 'Zaloguj się, aby wyświetlić koszyk';

  @override
  String get cartGuestSubtitle =>
      'Zaloguj się, aby uzyskać dostęp do koszyka i kontynuować zakup kursów.';

  @override
  String get wishlistGuestTitle => 'Zaloguj się, aby wyświetlić listę życzeń';

  @override
  String get wishlistGuestSubtitle =>
      'Zaloguj się, aby w dowolnym momencie uzyskać dostęp do zapisanych kursów.';

  @override
  String get courseDetailsLoginRequiredTitle => 'Wymagane logowanie';

  @override
  String get courseDetailsLoginRequiredDesc =>
      'Musisz się najpierw zalogować, aby kupić ten kurs i zapisać swoje postępy.';

  @override
  String get courseDetailsProceedToLogin => 'Przejdź do logowania';

  @override
  String get messagesGuestTitle => 'Zaloguj się, aby wyświetlić wiadomości';

  @override
  String get messagesGuestSubtitle =>
      'Zaloguj się, aby uzyskać dostęp do rozmów z pomocą techniczną.';

  @override
  String get notificationsGuestTitle =>
      'Zaloguj się, aby wyświetlić powiadomienia';

  @override
  String get notificationsGuestSubtitle =>
      'Zaloguj się, aby zobaczyć najnowsze powiadomienia dotyczące konta i kursów.';

  @override
  String get legalTitle => 'O nas i Informacje prawne';

  @override
  String get legalTabAbout => 'O EduLab';

  @override
  String get legalTabPrivacy => 'Prywatność';

  @override
  String get legalTabTerms => 'Regulamin';

  @override
  String get legalUpdated => 'Zaktualizowano:';

  @override
  String get legalNeedHelpTitle => 'Potrzebujesz pomocy lub masz pytania?';

  @override
  String get legalNeedHelpDesc =>
      'Zespół wsparcia EduLab jest do Twojej dyspozycji 24/7. Skontaktuj się z nami bezpośrednio przez e-mail.';

  @override
  String get legalEmailCopied => 'E-mail wsparcia skopiowany do schowka';

  @override
  String get legalNoContent => 'Brak dostępnej zawartości';

  @override
  String get checkoutDigitalReceipt => 'Cyfrowy Paragon';

  @override
  String get checkoutTransactionDate => 'Data Transakcji';

  @override
  String get checkoutFreeEnrollment => 'Bezpłatna Rejestracja';

  @override
  String get checkoutEnrolledCourses => 'Zapisane Kursy';

  @override
  String get checkoutTransactionStatus => 'Status';

  @override
  String get checkoutStatusSuccess => 'Zakończono Pomyślnie';

  @override
  String get checkoutTotalPaid => 'Łączna Zapłacona Kwota';

  @override
  String get checkoutCopied => 'Skopiowano!';

  @override
  String get checkoutCardHolderHint => 'Pełne imię i nazwisko jak na karcie';

  @override
  String get teachUploadProfilePhoto => 'Prześlij zdjęcie profilowe';

  @override
  String get teachAttachCV => 'Załącz CV';

  @override
  String get teachChooseClearPhotoForAccount =>
      'Wybierz wyraźne zdjęcie dla swojego konta trenera';

  @override
  String get teachChooseClearDocForCV =>
      'Wybierz wyraźny dokument lub zdjęcie swojego CV';

  @override
  String get teachTakePhoto => 'Zrób zdjęcie';

  @override
  String get teachTakePhotoSubtitle => 'Użyj aparatu, aby zrobić nowe zdjęcie';

  @override
  String get teachChooseFromGallery => 'Wybierz z galerii';

  @override
  String get teachChooseFromGallerySubtitle => 'Wybierz plik z urządzenia';

  @override
  String get teachAddOneSkillRequired => 'Dodaj co najmniej jedną umiejętność';

  @override
  String get teachAgreeTermsRequired =>
      'Proszę zaakceptować warunki nauczania, aby kontynuować';

  @override
  String get teachApplicationReceivedTitle =>
      'Twoja aplikacja została pomyślnie odebrana!';

  @override
  String get teachApplicationReceivedDesc =>
      'Dziękujemy za dołączenie do społeczności instruktorów EduLab. Nasz zespół ds. oceny akademickiej przeanalizuje Twoją aplikację, a Ty zostaniesz powiadomiony o decyzji.';

  @override
  String get teachTrackApplicationStatus => 'Śledź status aplikacji';

  @override
  String get teachRefreshTooltip => 'Odśwież';

  @override
  String get teachVerifyingApplicationData => 'Weryfikacja danych aplikacji...';

  @override
  String get teachAlreadyInstructor => 'Jesteś już zatwierdzonym instruktorem!';

  @override
  String get teachAlreadyInstructorDesc =>
      'Twoje konto posiada pełne uprawnienia instruktora. Możesz zarządzać swoimi kursami i publikować nowe treści z panelu instruktora.';

  @override
  String get teachBackToHome => 'Powrót do strony głównej';

  @override
  String get teachStatusApproved =>
      'Twoja aplikacja instruktorska została zatwierdzona';

  @override
  String get teachStatusRejected => 'Twoja aplikacja została odrzucona';

  @override
  String get teachStatusPending => 'Twoja aplikacja jest obecnie rozpatrywana';

  @override
  String get teachApplicationDetails => 'Szczegóły aplikacji';

  @override
  String get teachApplicationNumber => 'Numer aplikacji';

  @override
  String get teachApplicationDate => 'Data aplikacji';

  @override
  String get teachApplicant => 'Wnioskodawca';

  @override
  String get teachApplicantEmail => 'E-mail';

  @override
  String get teachSpecialization => 'Specjalizacja';

  @override
  String get teachExperienceYears => 'Lata doświadczenia';

  @override
  String get teachCVLabel => 'CV / Życiorys';

  @override
  String get teachCVAttached => 'Załączono ✓';

  @override
  String get teachReapply => 'Złóż nową aplikację';

  @override
  String get teachRefreshing => 'Odświeżanie...';

  @override
  String get teachRefreshStatus => 'Odśwież status aplikacji';

  @override
  String get teachApprovedMessage =>
      'Gratulacje! Możesz teraz rozpocząć przesyłanie i udostępnianie swoich kursów szkoleniowych.';

  @override
  String teachRejectionReason(String reason) {
    return 'Powód odrzucenia: $reason';
  }

  @override
  String get teachRejectedDefault =>
      'Niestety aplikacja nie spełniła obecnych wymagań. Możesz przejrzeć swoje dane i złożyć aplikację ponownie.';

  @override
  String get teachPendingMessage =>
      'Twoja aplikacja została odebrana i jest obecnie sprawdzana przez administrację platformy. Zostaniesz powiadomiony o decyzji.';

  @override
  String get teachStepPersonalData => 'Dane osobowe';

  @override
  String get teachStepExperienceSkills => 'Doświadczenie i umiejętności';

  @override
  String get teachStepReviewApplication => 'Przejrzyj aplikację';

  @override
  String get teachStep1HeaderTitle => '1. Informacje osobiste i zawodowe';

  @override
  String get teachFullNameLabel => 'Pełne imię i nazwisko *';

  @override
  String get teachFullNameHintAr => 'np. Jan Kowalski';

  @override
  String get teachFullNameValidation => 'Wprowadź poprawne imię i nazwisko';

  @override
  String get teachEmailReadonly => 'E-mail (Zarejestrowane konto)';

  @override
  String get teachPhoneLabelContact => 'Telefon kontaktowy *';

  @override
  String get teachPhoneValidation => 'Wprowadź poprawny numer telefonu';

  @override
  String get teachBioLabelWithAsterisk => 'Biografia *';

  @override
  String teachBioCharCount(String count) {
    return '$count / 200 znaków';
  }

  @override
  String get teachBioHintDetail =>
      'Napisz krótkie podsumowanie swojej kariery i specjalizacji (maks. 200 znaków)...';

  @override
  String get teachBioMinLengthValidation =>
      'Biografia musi mieć co najmniej 10 znaków';

  @override
  String get teachBioMaxLengthValidation =>
      'Biografia nie może przekraczać 200 znaków';

  @override
  String get teachProfilePhotoOptional =>
      'Zdjęcie profilowe instruktora (Opcjonalne)';

  @override
  String get teachNextExperienceSkills =>
      'Kontynuuj: Doświadczenie i umiejętności';

  @override
  String get teachStep2HeaderTitle =>
      '2. Doświadczenie akademickie i umiejętności';

  @override
  String get teachSpecializationLabel => 'Specjalizacja *';

  @override
  String get teachSpecializationHint => 'Wybierz specjalizację';

  @override
  String get teachExperienceLabel => 'Lata doświadczenia *';

  @override
  String get teachExperience0to2 => 'Mniej niż 2 lata (0 - 2)';

  @override
  String get teachExperience2to5 => 'Od 2 do 5 lat (2 - 5)';

  @override
  String get teachExperience5to10 => 'Od 5 do 10 lat (5 - 10)';

  @override
  String get teachExperience10plus => 'Powyżej 10 lat (10+)';

  @override
  String get teachSkillsLabel => 'Umiejętności i technologie *';

  @override
  String get teachSkillHint =>
      'Dodaj umiejętność (np. Flutter, Dart, UI/UX)...';

  @override
  String get teachSkillAddButton => 'Dodaj';

  @override
  String get teachSkillMinRequired => '* Dodaj co najmniej jedną umiejętność';

  @override
  String get teachCVFileLabel => 'Plik CV';

  @override
  String get teachPrevButton => 'Wstecz';

  @override
  String get teachNextReviewApplication => 'Kontynuuj: Przejrzyj aplikację';

  @override
  String get teachStep3HeaderTitle =>
      '3. Przejrzyj aplikację i potwierdź warunki';

  @override
  String get teachReviewBanner =>
      'Przed przesłaniem dokładnie sprawdź wszystkie wprowadzone dane. Po przesłaniu status Twojego konta zostanie zaktualizowany na \'instruktor oczekujący na sprawdzenie\'.';

  @override
  String get teachSummaryFullName => 'Pełne imię i nazwisko';

  @override
  String get teachSummaryEmail => 'E-mail';

  @override
  String get teachSummaryPhone => 'Numer telefonu';

  @override
  String get teachSummarySpecialization => 'Specjalizacja akademicka';

  @override
  String get teachSummaryExperience => 'Lata doświadczenia';

  @override
  String teachSummarySkillsCount(String count, String skills) {
    return '$count umiejętności ($skills)';
  }

  @override
  String get teachSummaryProfilePhoto => 'Zdjęcie profilowe';

  @override
  String get teachSummaryPhotoSelected => 'Wybrano ✓';

  @override
  String get teachSummaryPhotoNotSelected => 'Nie wybrano';

  @override
  String get teachSummaryCVFile => 'CV (Życiorys)';

  @override
  String get teachSummaryCVAttached => 'Załączono ✓';

  @override
  String get teachSummaryCVNotAttached => 'Nie załączono';

  @override
  String get teachTermsAgreement =>
      'Zgadzam się na warunki nauczania, zasady oraz umowę o własności intelektualnej EduLab.';

  @override
  String get teachSubmitButton => 'Prześlij aplikację instruktorską';

  @override
  String get teachPhotoSelectedSuccess => 'Zdjęcie zostało pomyślnie wybrane';

  @override
  String get teachChoosePhotoFromDevice =>
      'Wybierz zdjęcie profilowe z urządzenia';

  @override
  String get teachCVAttachedSuccess => 'CV zostało pomyślnie załączone';

  @override
  String get teachAttachCVFileOrPhoto => 'Załącz CV (plik lub zdjęcie)';

  @override
  String get teachSummarySkillsLabel => 'Dodane umiejętności';
}

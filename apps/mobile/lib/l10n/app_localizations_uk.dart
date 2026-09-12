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
      'Ваша ідеальна платформа для сучасного інтерактивного навчання та кар\'єрного зростання.';

  @override
  String get onboardingTitle2 => 'Навчайтеся у провідних викладачів';

  @override
  String get onboardingSubtitle2 =>
      'Тисячі професійних курсів з програмування, дизайну, бізнесу та науки про дані.';

  @override
  String get onboardingTitle3 => 'Сертифікати та гарантований успіх';

  @override
  String get onboardingSubtitle3 =>
      'Слідкуйте за прогресом, складайте тести та отримуйте визнані сертифікати.';

  @override
  String get onboardingNext => 'Далі';

  @override
  String get onboardingStart => 'Розпочати';

  @override
  String get splashAppName => 'Education Lab';

  @override
  String get splashTagline => 'Розумна освітня платформа';

  @override
  String get loginTagline => 'Ласкаво просимо на розумну платформу навчання';

  @override
  String get loginAppName => 'EduLab';

  @override
  String get loginTabLogin => 'Вхід';

  @override
  String get loginTabRegister => 'Реєстрація';

  @override
  String get loginEmailLabel => 'Електронна пошта';

  @override
  String get loginEmailHint => 'example@email.ua';

  @override
  String get loginPasswordLabel => 'Пароль';

  @override
  String get loginPasswordHint => '••••••';

  @override
  String get loginForgotPassword => 'Забули пароль?';

  @override
  String get loginSubmit => 'Увійти';

  @override
  String get loginSubmitLoading => 'Виконується вхід';

  @override
  String get loginGuest => 'Увійти як гість';

  @override
  String get loginOr => 'або';

  @override
  String get loginEmailRequired => 'Введіть адресу електронної пошти';

  @override
  String get loginEmailInvalid => 'Введіть коректну електронну пошту';

  @override
  String get loginPasswordRequired => 'Введіть пароль';

  @override
  String get registerStepEmail => 'Пошта';

  @override
  String get registerStepCode => 'Код';

  @override
  String get registerStepData => 'Дані';

  @override
  String get registerSendCodeInfo =>
      'Ми надішлемо код активації на цю електронну адресу';

  @override
  String get registerSendCode => 'Надіслати код';

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
      'Не менше 8 символів, велика літера та цифра';

  @override
  String get registerConfirmLabel => 'Підтвердження пароля';

  @override
  String get registerConfirmHint => 'Повторіть пароль';

  @override
  String get registerSubmit => 'Створити акаунт';

  @override
  String get registerSubmitLoading => 'Створення акаунту';

  @override
  String get registerSuccess => 'Акаунт успішно створено';

  @override
  String get registerNameRequired => 'Введіть повне ім\'я';

  @override
  String get registerNameMinLength => 'Ім\'я має містити щонайменше 6 символів';

  @override
  String get registerPasswordMinLength =>
      'Пароль має містити щонайменше 8 символів';

  @override
  String get registerPasswordUppercase =>
      'Пароль має містити хоча б одну велику літеру';

  @override
  String get registerPasswordNumber => 'Пароль має містити хоча б одну цифру';

  @override
  String get registerConfirmRequired => 'Підтвердіть пароль';

  @override
  String get registerConfirmMismatch => 'Паролі не збігаються';

  @override
  String get networkError => 'Помилка з\'єднання, спробуйте ще раз';

  @override
  String homeGreeting(String name) {
    return 'Вітаємо, $name!';
  }

  @override
  String get homeSubtitle => 'Чого ви бажаєте навчитися сьогодні?';

  @override
  String get homeSearchHint => 'Пошук курсу або навички...';

  @override
  String get homeSectionContinue => 'Продовжити навчання';

  @override
  String get homeSectionRecommended => 'Рекомендовано для вас';

  @override
  String get homeSectionPopular => 'Найпопулярніші';

  @override
  String get homeSectionTopRated => 'Найвищий рейтинг';

  @override
  String get homeSectionByCategory => 'За категоріями';

  @override
  String get homeHeroTitle => 'Спеціальні пропозиції';

  @override
  String get homeHeroSubtitle => 'Знижки до 70% на популярні курси';

  @override
  String get homeHeroButton => 'Дізнатися більше';

  @override
  String get homeViewAll => 'Усі';

  @override
  String get homeProgressLabel => 'Завершено';

  @override
  String get exploreTitle => 'Каталог курсів';

  @override
  String get exploreSearchHint => 'Пошук курсу, навички або викладача...';

  @override
  String get exploreAllCategories => 'Усі категорії';

  @override
  String get exploreFilter => 'Фільтри';

  @override
  String get exploreSort => 'Сортування';

  @override
  String get exploreNoResults => 'Нічого не знайдено';

  @override
  String get exploreNoResultsHint =>
      'Спробуйте змінити пошуковий запит або фільтри';

  @override
  String exploreCoursesCount(int count) {
    return '$count курсів';
  }

  @override
  String get exploreFilterTitle => 'Фільтри';

  @override
  String get exploreFilterApply => 'Застосувати';

  @override
  String get exploreFilterReset => 'Скинути';

  @override
  String get exploreFilterPrice => 'Ціна';

  @override
  String get exploreFilterLevel => 'Рівень';

  @override
  String get exploreFilterRating => 'Рейтинг';

  @override
  String get exploreFilterDuration => 'Тривалість';

  @override
  String get exploreSortTitle => 'Сортувати за';

  @override
  String get exploreSortRelevance => 'Релевантністю';

  @override
  String get exploreSortNewest => 'Спочатку нові';

  @override
  String get exploreSortPopular => 'Популярністю';

  @override
  String get exploreSortRating => 'Рейтингом';

  @override
  String get exploreSortPriceLow => 'Спочатку дешевші';

  @override
  String get exploreSortPriceHigh => 'Спочатку дорожчі';

  @override
  String get explorePriceFree => 'Безкоштовно';

  @override
  String get exploreLevelBeginner => 'Початковий';

  @override
  String get exploreLevelIntermediate => 'Середній';

  @override
  String get exploreLevelAdvanced => 'Просунутий';

  @override
  String get learningTitle => 'Моє навчання';

  @override
  String get learningTabInProgress => 'У процесі';

  @override
  String get learningTabCompleted => 'Завершені';

  @override
  String get learningTabSaved => 'Збережені';

  @override
  String get learningEmpty => 'Курсів ще немає';

  @override
  String get learningEmptyHint => 'Оберіть цікаві курси в каталозі';

  @override
  String get learningExploreButton => 'Перейти до каталогу';

  @override
  String learningProgress(int percent) {
    return '$percent% завершено';
  }

  @override
  String get learningContinue => 'Продовжити';

  @override
  String get learningViewCertificate => 'Сертифікат';

  @override
  String get learningReview => 'Оцінити курс';

  @override
  String get learningLesson => 'Урок';

  @override
  String get learningLessons => 'Уроки';

  @override
  String get cartTitle => 'Кошик';

  @override
  String get cartEmpty => 'Ваш кошик порожній';

  @override
  String get cartEmptyHint => 'Додайте курси, щоб розпочати навчання';

  @override
  String get cartExploreButton => 'Перейти до каталогу';

  @override
  String get cartPromoPlaceholder => 'Промокод';

  @override
  String get cartPromoApply => 'Застосувати';

  @override
  String get cartPromoInvalid => 'Недійсний промокод';

  @override
  String get cartSummary => 'Деталі замовлення';

  @override
  String get cartSubtotal => 'Проміжний підсумок';

  @override
  String get cartDiscount => 'Знижка';

  @override
  String get cartTotal => 'Всього';

  @override
  String get cartCheckout => 'Оформити замовлення';

  @override
  String cartCourses(int count) {
    return '$count курсів';
  }

  @override
  String get cartRemove => 'Видалити';

  @override
  String get cartGuarantee => '30 днів гарантії повернення коштів';

  @override
  String get checkoutTitle => 'Оплата';

  @override
  String get checkoutStepPayment => 'Оплата';

  @override
  String get checkoutStepReview => 'Перевірка';

  @override
  String get checkoutStepConfirm => 'Підтвердження';

  @override
  String get checkoutOrderSummary => 'Деталі замовлення';

  @override
  String get checkoutTotal => 'Всього';

  @override
  String get checkoutPayNow => 'Сплатити зараз';

  @override
  String get checkoutBack => 'Назад';

  @override
  String get checkoutNext => 'Далі';

  @override
  String get checkoutSecureSSL =>
      'Безпечна оплата з 256-бітним SSL-шифруванням';

  @override
  String get checkoutSuccessTitle => 'Оплата успішна!';

  @override
  String get checkoutSuccessSubtitle =>
      'Курс вже доступний у вашому особистому кабінеті';

  @override
  String get checkoutGoToLearning => 'До моїх курсів';

  @override
  String get checkoutPaymentMethod => 'Спосіб оплати';

  @override
  String get checkoutCardNumber => 'Номер картки';

  @override
  String get checkoutCardName => 'Ім\'я на картці';

  @override
  String get checkoutCardExpiry => 'Термін дії';

  @override
  String get checkoutCardCVV => 'CVV';

  @override
  String get courseDetailsEnroll => 'Записатися на курс';

  @override
  String get courseDetailsBuyNow => 'Купити зараз';

  @override
  String get courseDetailsAddToCart => 'До кошика';

  @override
  String get courseDetailsAddedToCart => 'Додано до кошика';

  @override
  String get courseDetailsAlreadyEnrolled => 'Ви вже записані';

  @override
  String get courseDetailsGoToCourse => 'Перейти до уроків';

  @override
  String get courseDetailsFree => 'Безкоштовно';

  @override
  String courseDetailsStudents(String count) {
    return '$count студентів';
  }

  @override
  String get courseDetailsRating => 'Рейтинг';

  @override
  String get courseDetailsReviews => 'відгуків';

  @override
  String get courseDetailsLastUpdated => 'Оновлено';

  @override
  String get courseDetailsCurriculum => 'Програма курсу';

  @override
  String get courseDetailsSection => 'розділ';

  @override
  String get courseDetailsLessons => 'уроків';

  @override
  String get courseDetailsInstructor => 'Викладач';

  @override
  String get courseDetailsStudentsLabel => 'Студенти';

  @override
  String get courseDetailsCoursesLabel => 'Курси';

  @override
  String get courseDetailsReviewsLabel => 'Відгуки';

  @override
  String get courseDetailsReviewsTitle => 'Відгуки студентів';

  @override
  String get courseDetailsWhatLearn => 'Чого ви навчитеся';

  @override
  String get courseDetailsRequirements => 'Вимоги';

  @override
  String get courseDetailsDescription => 'Опис курсу';

  @override
  String get courseDetailsIncludesTitle => 'До курсу входить';

  @override
  String get courseDetailsHoursVideo => 'годин відео';

  @override
  String get courseDetailsArticles => 'статей';

  @override
  String get courseDetailsMobileAccess => 'Доступ з мобільних пристроїв';

  @override
  String get courseDetailsCertificate => 'Сертифікат про закінчення';

  @override
  String get courseDetailsLifetimeAccess => 'Довічний доступ';

  @override
  String get lessonPlayerNotes => 'Нотатки';

  @override
  String get lessonPlayerResources => 'Матеріали';

  @override
  String get lessonPlayerDiscussion => 'Обговорення';

  @override
  String get lessonPlayerPrev => 'Попередній';

  @override
  String get lessonPlayerNext => 'Наступний';

  @override
  String get lessonPlayerSpeed => 'Швидкість';

  @override
  String get lessonPlayerQuality => 'Якість';

  @override
  String get lessonPlayerCompleted => 'Урок пройдено';

  @override
  String get certificateTitle => 'Сертифікат про закінчення';

  @override
  String get certificatePresentedTo => 'Видано';

  @override
  String get certificateCompletedCourse => 'за успішне завершення курсу';

  @override
  String get certificateIssuedOn => 'Дата видачі';

  @override
  String get certificateVerificationId => 'Номер сертифіката';

  @override
  String get certificateDownloadPDF => 'Завантажити PDF';

  @override
  String get certificateDownloadPNG => 'Завантажити зображення';

  @override
  String get certificateCopyLink => 'Скопіювати посилання';

  @override
  String get certificateLinkCopied => 'Посилання скопійовано';

  @override
  String get profileTitle => 'Профіль';

  @override
  String get profileEditProfile => 'Редагувати профіль';

  @override
  String get profileCourses => 'Мої курси';

  @override
  String get profileCertificates => 'Сертифікати';

  @override
  String get profilePoints => 'Бали';

  @override
  String get profileFollowers => 'Підписники';

  @override
  String get profileFollowing => 'Підписки';

  @override
  String get profileBio => 'Про себе';

  @override
  String get profileInstructor => 'Викладач';

  @override
  String get profileStudent => 'Студент';

  @override
  String get profileLevel => 'Рівень';

  @override
  String get profileJoined => 'З нами з';

  @override
  String get profileShareProfile => 'Поділитися профілем';

  @override
  String get profileMenuLearning => 'Мої курси';

  @override
  String get profileMenuCertificates => 'Мої сертифікати';

  @override
  String get profileMenuPurchaseHistory => 'Історія покупок';

  @override
  String get profileMenuTeachApplication => 'Викладати на EduLab';

  @override
  String get profileMenuAccountSecurity => 'Безпека акаунту';

  @override
  String get profileMenuNotifications => 'Сповіщення';

  @override
  String get profileMenuMessages => 'Повідомлення';

  @override
  String get profileMenuSettings => 'Налаштування';

  @override
  String get profileMenuSchedule => 'Мій розклад';

  @override
  String get profileMenuAssignments => 'Завдання';

  @override
  String get profileMenuQuiz => 'Тести';

  @override
  String get profileMenuLogout => 'Вийти';

  @override
  String get profileLogoutConfirm => 'Ви впевнені, що бажаєте вийти?';

  @override
  String get profileLogoutYes => 'Так, вийти';

  @override
  String get profileLogoutNo => 'Скасувати';

  @override
  String get editProfileTitle => 'Редагування профілю';

  @override
  String get editProfileSave => 'Зберегти';

  @override
  String get editProfileFullName => 'Повне ім\'я';

  @override
  String get editProfileBio => 'Про себе';

  @override
  String get editProfileEmail => 'Електронна пошта';

  @override
  String get editProfilePhone => 'Номер телефону';

  @override
  String get editProfileWebsite => 'Веб-сайт';

  @override
  String get editProfileSaved => 'Зміни успішно збережено';

  @override
  String get accountSecurityTitle => 'Безпека';

  @override
  String get accountSecurityChangePassword => 'Змінити пароль';

  @override
  String get accountSecurityTwoFactor => 'Двофакторна автентифікація';

  @override
  String get accountSecurityActiveSessions => 'Активні сеанси';

  @override
  String get accountSecurityDeleteAccount => 'Видалити акаунт';

  @override
  String get purchaseHistoryTitle => 'Історія покупок';

  @override
  String get purchaseHistoryEmpty => 'Покупок ще немає';

  @override
  String get purchaseHistoryGuarantee => '30-денна гарантія повернення коштів';

  @override
  String get purchaseHistoryDate => 'Дата транзакції';

  @override
  String get purchaseHistoryStatus => 'Статус';

  @override
  String get purchaseHistoryAmount => 'Сума';

  @override
  String get purchaseHistoryCompleted => 'Оплачено';

  @override
  String get purchaseHistoryRefunded => 'Повернення';

  @override
  String get teachApplicationTitle => 'Викладати на EduLab';

  @override
  String get teachApplicationSubmit => 'Надіслати заявку';

  @override
  String get teachApplicationSent => 'Заявку успішно надіслано';

  @override
  String get notificationsTitle => 'Сповіщення';

  @override
  String get notificationsMarkAllRead => 'Прочитати все';

  @override
  String get notificationsMarkAllReadSnackbar =>
      'Усі сповіщення позначено як прочитані';

  @override
  String get notificationsEmpty => 'Немає сповіщень';

  @override
  String get notification1Title => 'Нагадування: продовжіть курс';

  @override
  String get notification1Message =>
      'На вас чекає новий урок у курсі Flutter для початківців';

  @override
  String get notification1Time => '5 хвилин тому';

  @override
  String get notification1Action => 'Продовжити курс';

  @override
  String get notification2Title => 'Ваш сертифікат готовий!';

  @override
  String get notification2Message => 'Ви успішно завершили курс UI/UX дизайну.';

  @override
  String get notification2Time => '2 години тому';

  @override
  String get notification2Action => 'Дивитися сертифікат';

  @override
  String get notification3Title => 'Ексклюзивна пропозиція';

  @override
  String get notification3Message => 'Знижка 70% на курси програмування';

  @override
  String get notification3Time => '1 день тому';

  @override
  String get notification3Action => 'Переглянути';

  @override
  String get notification4Title => 'Нова відповідь на ваше запитання';

  @override
  String get notification4Message =>
      'Викладач відповів на ваше запитання до уроку';

  @override
  String get notification4Time => '2 дні тому';

  @override
  String get notification4Action => 'Дивитися відповідь';

  @override
  String get notification5Title => 'Оновлення курсу';

  @override
  String get notification5Message => 'Додано нові матеріали до курсу Python';

  @override
  String get notification5Time => '3 дні тому';

  @override
  String get messagesTitle => 'Повідомлення';

  @override
  String get settingsTitle => 'Налаштування додатка';

  @override
  String get settingsVideoDownload => 'Відео та завантаження';

  @override
  String get settingsDownloadQuality => 'Якість відео за замовчуванням';

  @override
  String get settingsWifiOnly => 'Завантажувати лише через Wi-Fi';

  @override
  String get settingsNotifications => 'Сповіщення та звуки';

  @override
  String get settingsCourseNotifications =>
      'Сповіщення про курси та повідомлення';

  @override
  String get settingsPromoNotifications => 'Знижки та спеціальні акції';

  @override
  String get settingsAppearance => 'Зовнішній вигляд та мова';

  @override
  String get settingsDarkMode => 'Темна тема';

  @override
  String get settingsDarkModeEnabled => 'Увімкнено (економить заряд батареї)';

  @override
  String get settingsDarkModeDisabled => 'Вимкнено (світла тема)';

  @override
  String get settingsLanguage => 'Мова інтерфейсу';

  @override
  String get settingsStorage => 'Пам\'ять та кеш';

  @override
  String get settingsClearCache => 'Очистити кеш';

  @override
  String get settingsClearCacheSuccess => 'Кеш успішно очищено';

  @override
  String get settingsHelp => 'Інформація та правила';

  @override
  String get settingsHelpCenter => 'Центр допомоги та FAQ';

  @override
  String get settingsTermsPrivacy => 'Умови та конфіденційність';

  @override
  String get settingsAbout => 'Про проєкт EduLab';

  @override
  String get settingsVersion => 'Версія v1.0.0';

  @override
  String get quizTitle => 'Тестування';

  @override
  String get quizNext => 'Наступне питання';

  @override
  String get quizSubmit => 'Завершити тест';

  @override
  String get quizScore => 'Результат';

  @override
  String get quizCorrectAnswers => 'Правильних відповідей';

  @override
  String get scheduleTitle => 'Мій розклад';

  @override
  String get scheduleEmpty => 'Занять не заплановано';

  @override
  String get scheduleJoin => 'Приєднатися';

  @override
  String get scheduleReminder => 'Нагадати';

  @override
  String get assignmentsTitle => 'Домашні завдання';

  @override
  String get assignmentsEmpty => 'Завдань ще немає';

  @override
  String get assignmentsSubmit => 'Здати завдання';

  @override
  String get assignmentsDue => 'Термін здачі';

  @override
  String get assignmentsSubmitted => 'Здано';

  @override
  String get assignmentsPending => 'На перевірці';

  @override
  String get languageArabic => 'Арабська';

  @override
  String get languageEnglish => 'Англійська';

  @override
  String get languageDialogTitle => 'Вибір мови';

  @override
  String get languageSelect => 'Обрати';

  @override
  String get generalCancel => 'Скасувати';

  @override
  String get generalConfirm => 'Підтвердити';

  @override
  String get generalSave => 'Зберегти';

  @override
  String get generalDelete => 'Видалити';

  @override
  String get generalEdit => 'Редагувати';

  @override
  String get generalClose => 'Закрити';

  @override
  String get generalBack => 'Назад';

  @override
  String get generalDone => 'Готово';

  @override
  String get generalOk => 'ОК';

  @override
  String get generalYes => 'Так';

  @override
  String get generalNo => 'Ні';

  @override
  String get generalLoading => 'Завантаження...';

  @override
  String get generalError => 'Сталася помилка';

  @override
  String get generalRetry => 'Повторити';

  @override
  String get generalNoInternet => 'Немає підключення до інтернету';

  @override
  String get generalFree => 'Безкоштовно';

  @override
  String get generalRating => 'Рейтинг';

  @override
  String get generalStudents => 'Студенти';

  @override
  String get generalHours => 'Годин';

  @override
  String get generalMinutes => 'Хвилин';

  @override
  String get generalBy => 'Автор';

  @override
  String get navHome => 'Головна';

  @override
  String get navExplore => 'Каталог';

  @override
  String get navMyCourses => 'Мої курси';

  @override
  String get navCart => 'Кошик';

  @override
  String get navAccount => 'Профіль';

  @override
  String get homeSubGreeting => 'Що ви хочете вивчити сьогодні?';

  @override
  String get homeVisitor => 'Гість';

  @override
  String get homePromoTitle => 'Спеціальні пропозиції';

  @override
  String get homePromoSubtitle => 'Знижки до 70% на популярні курси';

  @override
  String get homePromoButton => 'Дізнатися більше';

  @override
  String get homePromoBadge => 'Ексклюзив';

  @override
  String get homeContinueLearning => 'Продовжити навчання';

  @override
  String get homeMyCoursesLink => 'Мої курси';

  @override
  String get homeLesson => 'урок';

  @override
  String homeStudentsCount(String count) {
    return '$count студентів';
  }

  @override
  String get homeRecommendedTitle => 'Рекомендовано для вас';

  @override
  String get homeRecommendedSubtitle => 'Підібрано на основі ваших інтересів';

  @override
  String get homeBestsellersTitle => 'Хіти продажів';

  @override
  String get homeBestsellersSubtitle =>
      'Найпопулярніші курси з високим рейтингом';

  @override
  String get homeNewCoursesTitle => 'Нові курси';

  @override
  String get homeNewCoursesSubtitle => 'Свіжі та актуальні матеріали';

  @override
  String get homePopularTopicsTitle => 'Популярні теми';

  @override
  String get homePopularTopicsSubtitle =>
      'Вивчайте найбільш затребувані навички';

  @override
  String get homeTopInstructorsTitle => 'Провідні викладачі';

  @override
  String get homeTopInstructorsSubtitle =>
      'Навчайтеся у сертифікованих експертів';

  @override
  String get homeExploreCategoriesTitle => 'Категорії курсів';

  @override
  String get homeExploreCategoriesSubtitle =>
      'Знайдіть ідеальний курс для себе';

  @override
  String get catAll => 'Усі';

  @override
  String get catWebDev => 'Веб-розробка';

  @override
  String get catMobileApps => 'Мобільні додатки';

  @override
  String get catDataScience => 'Наука про дані';

  @override
  String get catUIUX => 'UI/UX Дизайн';

  @override
  String get catBusiness => 'Бізнес та менеджмент';

  @override
  String get catAI => 'Штучний інтелект';

  @override
  String get catCyberSecurity => 'Кібербезпека';

  @override
  String get exploreNoResultsTitle => 'Нічого не знайдено';

  @override
  String get exploreNoResultsSubtitle =>
      'Спробуйте змінити пошуковий запит або фільтри';

  @override
  String get exploreRecentSearches => 'Недавні пошуки';

  @override
  String get exploreTopSearches => 'Популярні запити';

  @override
  String get exploreBrowseCategories => 'Категорії';

  @override
  String get exploreBrowseCategoriesSubtitle => 'Знайдіть ідеальний курс';

  @override
  String get exploreBackToAll => 'До всіх курсів';

  @override
  String get exploreClearAll => 'Очистити все';

  @override
  String get exploreAvailableResults => 'знайдено курсів';

  @override
  String get exploreFilterBestseller => 'Бестселер';

  @override
  String get exploreFilterTopRated => 'Найвищий рейтинг';

  @override
  String get exploreFilterUnder50 => 'До \$50';

  @override
  String get learningHeroTitle => 'Продовжуйте свій шлях до успіху';

  @override
  String get learningSearchHint => 'Пошук серед моїх курсів...';

  @override
  String get learningFilterAll => 'Усі';

  @override
  String get learningFilterInProgress => 'У процесі';

  @override
  String get learningFilterCompleted => 'Завершені';

  @override
  String get learningFilterDownloaded => 'Завантажені';

  @override
  String get learningEmptyTitle => 'Курсів ще немає';

  @override
  String get learningEmptySubtitle => 'Оберіть цікаві курси в каталозі';

  @override
  String get learningEmptySearch => 'Нічого не знайдено';

  @override
  String get learningCompleted => 'Завершено';

  @override
  String get learningCompletedBadge => 'Завершено';

  @override
  String learningLecturesCount(int count) {
    return '$count лекцій';
  }

  @override
  String get cartEmptyTitle => 'Ваш кошик порожній';

  @override
  String get cartEmptySubtitle => 'Додайте курси, щоб розпочати навчання';

  @override
  String get cartCouponHint => 'Введіть промокод';

  @override
  String get cartCouponApply => 'Застосувати';

  @override
  String get cartCouponInvalid => 'Недійсний промокод';

  @override
  String get cartCouponApplied => 'Промокод застосовано';

  @override
  String get cartCouponDiscount => 'Знижка за промокодом';

  @override
  String get cartCouponsTitle => 'Промокоди';

  @override
  String get cartOrderSummary => 'Деталі замовлення';

  @override
  String get cartOriginalPrice => 'Початкова ціна';

  @override
  String get cartPlatformDiscount => 'Знижка платформи';

  @override
  String get cartFinalTotal => 'Всього до сплати';

  @override
  String cartItemsCount(int count) {
    return '$count курсів';
  }

  @override
  String get cartRemovedSnackbar => 'Курс видалено з кошика';

  @override
  String get cartUndo => 'Скасувати';

  @override
  String get cartAddButton => 'До кошика';

  @override
  String get cartAddedSnackbar => 'Додано до кошика';

  @override
  String get cartAlreadyInCart => 'Вже у кошику';

  @override
  String get cartCheckoutButton => 'Перейти до оплати';

  @override
  String get cartRecommendedTitle => 'Вам також може сподобатися';

  @override
  String get cartRecommendedSubtitle =>
      'Курси, підібрані на основі вашого кошика';

  @override
  String get checkoutCreditCard => 'Банківська картка';

  @override
  String get checkoutSelectPayment => 'Оберіть спосіб оплати';

  @override
  String get checkoutCardNumberLabel => 'Номер картки';

  @override
  String get checkoutCardHolderLabel => 'Власник картки';

  @override
  String get checkoutExpiryLabel => 'Термін дії';

  @override
  String get checkoutCVVLabel => 'CVV';

  @override
  String get checkoutPersonalInfoTitle => 'Особисті дані';

  @override
  String get checkoutFullNameLabel => 'Повне ім\'я';

  @override
  String get checkoutFullNameHint => 'Ваше повне ім\'я';

  @override
  String get checkoutFullNameRequired => 'Введіть повне ім\'я';

  @override
  String get checkoutPhoneLabel => 'Номер телефону';

  @override
  String get checkoutPhoneRequired => 'Введіть номер телефону';

  @override
  String get checkoutPostalLabel => 'Поштовий індекс';

  @override
  String get checkoutPostalRequired => 'Введіть поштовий індекс';

  @override
  String get checkoutBuyerInfo => 'Дані покупця';

  @override
  String get checkoutSaveInfo => 'Зберегти дані для майбутніх покупок';

  @override
  String get checkoutMoneyBackGuarantee =>
      '30-денна гарантія повернення коштів';

  @override
  String get checkoutContinueToPayment => 'Перейти до оплати';

  @override
  String get checkoutContinueToReview => 'Перейти до перевірки';

  @override
  String get checkoutReviewConfirm => 'Перевірити та підтвердити';

  @override
  String get checkoutStartLearning => 'Почати навчання';

  @override
  String get checkoutBackHome => 'На головну';

  @override
  String get courseDetailsTitle => 'Про курс';

  @override
  String get courseDetailsShare => 'Поділитися';

  @override
  String get courseDetailsWhatYouWillLearn => 'Чого ви навчитеся';

  @override
  String get courseDetailsLanguage => 'Мова';

  @override
  String get courseDetailsCreatedBy => 'Автор курсу';

  @override
  String get courseDetailsPreviewLesson => 'Пробний урок';

  @override
  String get courseDetailsHoursOnDemand => 'годин відео на вимогу';

  @override
  String get courseDetailsFullLifetimeAccess => 'Повний довічний доступ';

  @override
  String get courseDetailsCertifiedCertificate =>
      'Сертифікований диплом про закінчення';

  @override
  String get courseDetailsComprehensiveContent => 'Повний обсяг матеріалів';

  @override
  String get certTitle => 'Сертифікат про закінчення';

  @override
  String get certStudentNameLabel => 'Студент';

  @override
  String get certCourseLabel => 'Курс';

  @override
  String get certInstructorLabel => 'Викладач';

  @override
  String get certIssueDateLabel => 'Дата видачі';

  @override
  String get certCodeLabel => 'ID сертифіката';

  @override
  String get certVerifiedBadge => 'Підтверджено';

  @override
  String get certDownloadPDF => 'Завантажити PDF';

  @override
  String get certDownloadPNG => 'Завантажити зображення';

  @override
  String get certCopyVerifyLink => 'Скопіювати посилання для перевірки';

  @override
  String get certShare => 'Поділитися сертифікатом';

  @override
  String get playerTabLessons => 'Уроки';

  @override
  String get playerTabOverview => 'Огляд';

  @override
  String get playerTabNotes => 'Нотатки';

  @override
  String get playerTabQnA => 'Питання та відповіді';

  @override
  String get playerNextLesson => 'Наступний урок';

  @override
  String get profileWelcome => 'Ласкаво просимо';

  @override
  String get profileLoginPrompt => 'Увійдіть, щоб переглянути профіль';

  @override
  String get profileLoginOrRegister => 'Увійти / Зареєструватися';

  @override
  String get profileVerifiedStudent => 'Підтверджений студент';

  @override
  String get profileLogout => 'Вийти';

  @override
  String get profileCancel => 'Скасувати';

  @override
  String get profileLogoutConfirmTitle => 'Вихід з акаунту';

  @override
  String get profileLogoutConfirmMessage =>
      'Ви впевнені, що бажаєте вийти з акаунту?';

  @override
  String get profileAccountSettings => 'Налаштування акаунту';

  @override
  String get profileEditProfileSubtitle => 'Змінити особисті дані';

  @override
  String get profileSecurity => 'Безпека';

  @override
  String get profileSecuritySubtitle => 'Пароль та двоетапний захист';

  @override
  String get profilePurchaseHistory => 'Історія покупок';

  @override
  String get profilePurchaseHistorySubtitle => 'Перегляд платежів та чеків';

  @override
  String get profileCertificatesSubtitle => 'Ваші отримані сертифікати';

  @override
  String get profileTeach => 'Викладати на EduLab';

  @override
  String get profileTeachSubtitle => 'Діліться знаннями та заробляйте';

  @override
  String get profilePreferences => 'Параметри';

  @override
  String get profilePreferencesSubtitle => 'Оформлення та мова';

  @override
  String get profileNotifications => 'Сповіщення';

  @override
  String get profileNotificationsSubtitle => 'Налаштування сповіщень';

  @override
  String get profileHelpSupport => 'Допомога та підтримка';

  @override
  String get profileTerms => 'Умови використання';

  @override
  String get profilePrivacy => 'Політика конфіденційності';

  @override
  String get profileAboutEduLab => 'Про платформу EduLab';

  @override
  String get profileWishlist => 'Список бажань';

  @override
  String get securityTitle => 'Безпека акаунту';

  @override
  String get teachTitle => 'Викладати на EduLab';

  @override
  String get notificationsTabAll => 'Усі';

  @override
  String get notificationsTabCourses => 'Курси';

  @override
  String get notificationsTabPromos => 'Акції';

  @override
  String get notificationsEmptyTitle => 'Немає сповіщень';

  @override
  String get notificationsUnread => 'Нові';

  @override
  String get wishlistTitle => 'Список бажань';

  @override
  String get wishlistEmptyTitle => 'Список бажань порожній';

  @override
  String get wishlistEmptySubtitle => 'Зберігайте цікаві курси';

  @override
  String get wishlistAddToCart => 'До кошика';

  @override
  String get wishlistRemovedSnackbar => 'Видалено зі списку бажань';

  @override
  String get homeDefaultUser => 'Студент';

  @override
  String get learningOf => 'з';

  @override
  String get cartInCartBadge => 'У кошику';

  @override
  String get homePromo1Badge => 'Великий розпродаж • Обмежений час';

  @override
  String get homePromo1Title => 'Почніть навчання за найкращими цінами';

  @override
  String get homePromo1Subtitle =>
      'Знижки до 65% на курси програмування, дизайну та бізнесу.';

  @override
  String get homePromo1Button => 'Переглянути знижки';

  @override
  String get homePromo2Badge => 'Сертифіковані кар\'єрні шляхи';

  @override
  String get homePromo2Title => 'Підготуйтеся до кар\'єри своєї мрії';

  @override
  String get homePromo2Subtitle =>
      'Комплексні курси від нуля до профі з реальними проєктами та сертифікатами.';

  @override
  String get homePromo2Button => 'Дослідити шляхи';

  @override
  String get homePromo3Badge => 'Провідні викладачі та експерти';

  @override
  String get homePromo3Title => 'Навчайтеся безпосередньо у практиків ринку';

  @override
  String get homePromo3Subtitle =>
      'Постійно оновлюваний контент для опанування найновіших технологій.';

  @override
  String get homePromo3Button => 'Почати зараз';

  @override
  String get homePromoInstructorBadge =>
      'Викладайте на EduLab • Діліться знаннями';

  @override
  String get homePromoInstructorTitle => 'Станьте викладачем вже сьогодні';

  @override
  String get homePromoInstructorSubtitle =>
      'Надихайте учнів по всьому світу, створюйте курси та заробляйте, навчаючи тому, що любите.';

  @override
  String get homePromoInstructorButton => 'Подати заявку';

  @override
  String get homeSearchFilter => 'Фільтр';

  @override
  String get securitySectionChangePassword => 'Змінити пароль';

  @override
  String get securityCurrentPasswordLabel => 'Поточний пароль *';

  @override
  String get securityCurrentPasswordError => 'Введіть поточний пароль';

  @override
  String get securityNewPasswordLabel => 'Новий пароль *';

  @override
  String get securityNewPasswordError => 'Має містити щонайменше 8 символів';

  @override
  String get securityConfirmPasswordLabel => 'Підтвердіть новий пароль *';

  @override
  String get securityConfirmPasswordError => 'Паролі не збігаються';

  @override
  String get securityUpdatePasswordBtn => 'Оновити пароль';

  @override
  String get securityPasswordUpdatedSuccess => 'Пароль успішно змінено!';

  @override
  String get securitySection2FA => 'Двофакторна автентифікація (2FA)';

  @override
  String get security2FATitle => 'Двофакторна автентифікація';

  @override
  String get security2FAEnabledDesc => 'Увімкнено - Захищає акаунт кодом';

  @override
  String get security2FADisabledDesc => 'Вимкнено (Рекомендовано)';

  @override
  String get security2FASetupTitle => 'Увімкнути двофакторну автентифікацію';

  @override
  String get security2FASetupContent =>
      'Під час кожного нового входу на вашу пошту надсилатиметься 6-значний код перевірки.';

  @override
  String get security2FAEnableNow => 'Увімкнути зараз';

  @override
  String get security2FAEnabledSuccess =>
      'Двофакторну автентифікацію успішно увімкнено!';

  @override
  String get security2FADisabledSuccess =>
      'Двофакторну автентифікацію вимкнено';

  @override
  String get securitySectionSessions => 'Активні сесії та пристрої';

  @override
  String get securityLogoutAllDevices => 'Вийти з усіх пристроїв';

  @override
  String get securityThisDevice => 'Цей пристрій';

  @override
  String get securitySessionRevokedSuccess =>
      'Сесію завершено, виконано вихід із пристрою.';

  @override
  String get securityAllSessionsRevokedSuccess =>
      'Виконано вихід з усіх інших пристроїв.';

  @override
  String get purchaseHistoryInvoiceCertified =>
      'Сертифікований електронний рахунок';

  @override
  String get purchaseHistoryInvoiceNumber => 'Номер рахунку';

  @override
  String get purchaseHistoryCourse => 'Курс';

  @override
  String get purchaseHistoryPaymentMethod => 'Спосіб оплати';

  @override
  String get purchaseHistoryTotalAmount => 'Загальна сума:';

  @override
  String get purchaseHistoryClose => 'Закрити';

  @override
  String get purchaseHistoryDownloadPdf => 'Завантажити PDF';

  @override
  String get purchaseHistoryPdfDownloaded =>
      'Рахунок у форматі PDF успішно завантажено';

  @override
  String get purchaseHistoryRefundRequestTitle => 'Запит на повернення коштів';

  @override
  String get purchaseHistoryRefundPolicy =>
      'Згідно з 30-денною гарантією EduLab ви можете отримати повне повернення коштів.';

  @override
  String get purchaseHistoryRefundReasonHint =>
      'Причина повернення (необов\'язково)...';

  @override
  String get purchaseHistoryConfirmRefund => 'Підтвердити повернення';

  @override
  String get purchaseHistoryRefundSubmitted =>
      'Запит на повернення надіслано (3-5 робочих днів).';

  @override
  String get purchaseHistoryInstructor => 'Викладач';

  @override
  String get purchaseHistoryRequestRefundBtn => 'Запитати повернення';

  @override
  String get purchaseHistoryInvoiceBtn => 'Рахунок';

  @override
  String get purchaseHistoryStatusCompleted => 'Завершено';

  @override
  String get purchaseHistoryStatusRefunded => 'Повернено';

  @override
  String get purchaseHistoryStatusProcessingRefund => 'Обробка повернення';

  @override
  String get editProfileSectionBasicInfo => 'Основна інформація';

  @override
  String get editProfileFullNameLabel => 'Повне ім\'я *';

  @override
  String get editProfileFullNameHint => 'Введіть ваше повне ім\'я';

  @override
  String get editProfileFullNameError => 'Будь ласка, введіть повне ім\'я';

  @override
  String get editProfileHeadlineLabel => 'Професійний заголовок';

  @override
  String get editProfileHeadlineHint => 'наприклад, Senior Flutter розробник';

  @override
  String get editProfileLocationLabel => 'Місто / Країна';

  @override
  String get editProfileLocationHint => 'Київ, Україна';

  @override
  String get editProfilePhoneLabel => 'Номер телефону';

  @override
  String get editProfileBioLabel => 'Про себе (Біо)';

  @override
  String get editProfileBioHint =>
      'Напишіть коротко про ваші інтереси та досвід...';

  @override
  String get editProfileSectionLinks => 'Посилання та професійні мережі';

  @override
  String get editProfileWebsiteLabel => 'Особистий веб-сайт';

  @override
  String get editProfileSectionEmail => 'Зареєстрований e-mail';

  @override
  String get editProfileEmailDesc =>
      'Прив\'язаний до акаунту для входу та сертифікатів';

  @override
  String get editProfileEmailVerified => 'Підтверджено';

  @override
  String get editProfileSaveChangesBtn => 'Зберегти зміни';

  @override
  String get editProfileSavedSuccess => 'Профіль успішно оновлено!';

  @override
  String get editProfileChangeAvatarTitle => 'Змінити фото профілю';

  @override
  String get editProfileTakePhoto => 'Зробити знімок';

  @override
  String get editProfileChooseGallery => 'Обрати з галереї';

  @override
  String get editProfilePhotoUpdatedSuccess => 'Фото профілю успішно оновлено';

  @override
  String get teachJoinInstructorTitle => 'Станьте викладачем';

  @override
  String get teachJoinInstructorSubtitle =>
      'Публікуйте курси та діліться досвідом із тисячами студентів.';

  @override
  String get teachStep1Title => 'Особисті дані';

  @override
  String get teachStep2Title => 'Досвід та навички';

  @override
  String get teachStep3Title => 'Підтвердження';

  @override
  String get teachStep1Header => '1. Особиста та професійна інформація';

  @override
  String get teachFullNameArabicLabel => 'Повне ім\'я *';

  @override
  String get teachFullNameArabicHint => 'наприклад, Іван Іваненко';

  @override
  String get teachHeadlineLabel => 'Посада та спеціалізація *';

  @override
  String get teachHeadlineHint =>
      'наприклад, Senior Software Architect & Flutter Trainer';

  @override
  String get teachPhoneLabel => 'Контактний телефон *';

  @override
  String get teachCountryLabel => 'Країна проживання *';

  @override
  String get teachBioLabel => 'Про себе та попередній досвід *';

  @override
  String get teachBioHint =>
      'Коротко розкажіть про вашу кар\'єру та проєкти...';

  @override
  String get teachNextStepSkills => 'Далі: Досвід та навички';

  @override
  String get teachStep2Header => '2. Зміст курсу та навички';

  @override
  String get teachTopicLabel => 'Тема або напрямок курсу *';

  @override
  String get teachTopicHint => 'наприклад, Розробка на Flutter з нуля';

  @override
  String get teachYearsExperienceLabel => 'Років досвіду у сфері *';

  @override
  String get teachVideoLinkLabel =>
      'Посилання на пробне відео (YouTube/Drive/Loom) *';

  @override
  String get teachTargetAudienceLabel => 'Цільова аудиторія курсу *';

  @override
  String get teachAudienceBeginners => 'Початківці';

  @override
  String get teachAudienceIntermediate => 'Початківці та середній рівень';

  @override
  String get teachAudienceAdvanced => 'Просунуті та професіонали';

  @override
  String get teachAudienceAll => 'Усі рівні';

  @override
  String get teachSkillsCoveredLabel => 'Навички та технології в курсі *';

  @override
  String get teachAddSkillHint => 'Додати навичку (напр. GraphQL)...';

  @override
  String get teachAddSkillBtn => 'Додати';

  @override
  String get teachNextStepConfirm => 'Далі: Підтвердити заявку';

  @override
  String get teachStep3Header => '3. Виплати та умови';

  @override
  String get teachPayoutMethodLabel => 'Спосіб отримання виплат *';

  @override
  String get teachPayoutMethodBank => 'Банківський переказ (IBAN)';

  @override
  String get teachPayoutMethodPaypal => 'Підтверджений акаунт PayPal';

  @override
  String get teachPayoutMethodPayoneer => 'Картка Payoneer';

  @override
  String get teachIbanDetailsLabel => 'Реквізити рахунку / IBAN *';

  @override
  String get teachApplicationSummary => 'Підсумок заявки:';

  @override
  String get teachApplicantName => 'Заявник';

  @override
  String get teachApplicantHeadline => 'Спеціальність';

  @override
  String get teachApplicantTopic => 'Тема курсу';

  @override
  String get teachApplicantSkillsCount => 'Кількість навичок';

  @override
  String get teachSkillsUnit => 'навичок';

  @override
  String get teachAgreeTermsLabel =>
      'Я погоджуюся з умовами для викладачів та угодою про інтелектуальну власність EduLab.';

  @override
  String get teachSubmitApplicationBtn => 'Submit Instructor Application';

  @override
  String get teachPrevStepBtn => 'Назад';

  @override
  String get teachWhyEduLabTitle => 'Чому варто викладати в EduLab?';

  @override
  String get teachProp1Title => 'Справедливий та високий дохід';

  @override
  String get teachProp1Desc =>
      'Отримуйте до 80% від продажів курсів без прихованих комісій.';

  @override
  String get teachProp2Title => 'Доступ до тисяч студентів';

  @override
  String get teachProp2Desc =>
      'Просувайте свій курс серед величезної активної спільноти.';

  @override
  String get teachProp3Title => 'Повна технічна та продакшн-підтримка';

  @override
  String get teachProp3Desc =>
      'Наша команда допоможе покращити якість звуку, відео та структуру курсу.';

  @override
  String get teachSuccessDialogTitle => 'Заявку успішно прийнято!';

  @override
  String get teachSuccessDialogDesc =>
      'Дякуємо за інтерес до EduLab. Наша команда розгляне заявку та зв\'яжеться з вами протягом 48 годин.';

  @override
  String get teachSuccessDialogOk => 'Зрозуміло';

  @override
  String get teachAddOneSkillError => 'Будь ласка, додайте хоча б одну навичку';

  @override
  String get teachAgreeTermsError => 'Будь ласка, підтвердьте згоду з умовами';

  @override
  String get commonCancel => 'Скасувати';

  @override
  String get commonClose => 'Закрити';

  @override
  String get myCertificatesBannerTitle => 'Акредитовані сертифікати';

  @override
  String get myCertificatesBannerSubtitle =>
      'Усі сертифікати акредитовані та перевірені унікальним ідентифікатором EduLab';

  @override
  String get certBadgeVerified100 => '100% Акредитовано';

  @override
  String get certCodeCopied => 'Код сертифіката скопійовано';

  @override
  String get certGrantedTo => 'Видано';

  @override
  String get certViewAndDownload => 'Переглянути та завантажити сертифікат';

  @override
  String get certIssuerLabel => 'Орган видачі';

  @override
  String get certIssuerName => 'Академія інтерактивного навчання EduLab';

  @override
  String get certEmptyTitle => 'Сертифікатів ще не отримано';

  @override
  String get certEmptyDesc =>
      'Пройдіть 100% будь-якого курсу, щоб отримати акредитований сертифікат з офіційним ідентифікатором перевірки.';

  @override
  String get certEmptyAction => 'Продовжити мої курси';

  @override
  String get certDetailsTitle => 'Деталі та інформація про сертифікат';

  @override
  String get certCopyLinkSuccess =>
      'Пряме посилання на перевірку скопійовано в буфер обміну!';

  @override
  String get certShareSuccess =>
      'Деталі сертифіката та посилання скопійовано для поширення!';

  @override
  String get purchaseHistoryTaxInvoiceCertified =>
      'Офіційний сертифікований податковий рахунок';

  @override
  String get purchaseHistoryInvoiceNumberLabel => 'Номер замовлення / рахунку';

  @override
  String get purchaseHistoryCourseNameLabel => 'Назва курсу';

  @override
  String get purchaseHistoryPurchaseDateLabel => 'Дата покупки';

  @override
  String get purchaseHistoryPaymentMethodLabel => 'Спосіб оплати';

  @override
  String get purchaseHistoryPaymentMethodValue =>
      'Банківська картка / Stripe (Онлайн)';

  @override
  String get purchaseHistoryOrderStatusLabel => 'Статус замовлення';

  @override
  String get purchaseHistoryStatusPendingReview => 'На розгляді повернення';

  @override
  String get purchaseHistoryCopyInvoiceBtn => 'Скопіювати номер рахунку';

  @override
  String get purchaseHistoryRefundReasonLabel =>
      'Причина запиту на повернення:';

  @override
  String get purchaseHistoryRefundReasonEmptyError =>
      'Будь ласка, вкажіть причину запиту на повернення';

  @override
  String get purchaseHistorySubmittingRefund => 'Надсилання запиту...';

  @override
  String get purchaseHistoryPaidDate => 'Дата оплати';

  @override
  String get purchaseHistoryEmptyTitle => 'Історія покупок поки що порожня';

  @override
  String get purchaseHistoryEmptyDesc =>
      'Ви ще не придбали жодного курсу.\nВаші замовлення та рахунки з\'являться тут після оформлення.';

  @override
  String get purchaseHistoryExploreCourses => 'Переглянути курси';

  @override
  String get profileMyCourses => 'Мої курси';

  @override
  String get profileMyCoursesSubtitle =>
      'Відстежуйте прогрес у записаних курсах';

  @override
  String get profileWishlistSubtitle => 'Курси, збережені у списку бажань';

  @override
  String get navMyLearning => 'Моє навчання';

  @override
  String get profileLogoutSafeNote =>
      'Ваші дані, курси та сертифікати у повній безпеці. Ви можете продовжити навчання у будь-який момент, увійшовши знову.';

  @override
  String learningRemainingHours(String hours) {
    return 'Залишилося $hours год.';
  }

  @override
  String get learningCompletedFull => 'Завершено';

  @override
  String get learningFilterNotStarted => 'Не розпочато';

  @override
  String get wishlistTopRatedBadge => 'Найвища оцінка';

  @override
  String get wishlistFeaturedBadge => 'Рекомендоване';

  @override
  String wishlistDiscountBadge(String percent) {
    return 'Знижка $percent%';
  }

  @override
  String get courseFree => 'Безкоштовно';

  @override
  String get badgeBestseller => 'Бестселер';

  @override
  String get badgeTopRated => 'Найвища оцінка';

  @override
  String get badgeFeatured => 'Рекомендоване';

  @override
  String get badgeRecommended => 'Рекомендовано для вас';

  @override
  String get badgeNew => 'Нове';

  @override
  String get courseWord => 'Курс';

  @override
  String coursesCountText(String count) {
    return '$count+ Курсів';
  }

  @override
  String studentsCountText(String count) {
    return '$count Студентів';
  }

  @override
  String hoursCountText(String count) {
    return '$count Год.';
  }

  @override
  String get certifiedInstructor => 'Сертифікований викладач';

  @override
  String get expertCertifiedInstructor => 'Експерт і сертифікований викладач';

  @override
  String get defaultCourseTitle => 'Навчальний курс';

  @override
  String get categoryWord => 'Категорія';

  @override
  String get previewCourseVideo => 'Попередній перегляд відео курсу';

  @override
  String get freeSection => 'Безкоштовний розділ';

  @override
  String get freeDemoVideo => 'Безкоштовне демо-відео';

  @override
  String get articleLecture => 'Лекція-стаття';

  @override
  String get articleViewer => 'Переглядач статей';

  @override
  String get courseVideoPlayer => 'Відеоплеєр курсу';

  @override
  String get playingNow => 'Зараз відтворюється';

  @override
  String get readingNow => 'Зараз читається';

  @override
  String get noLecturesInFreeSection => 'У безкоштовному розділі немає уроків';

  @override
  String freeLecturesCount(String count) {
    return '$count безкоштовних уроків';
  }

  @override
  String get enrollInFullCourse => 'Записатися на повний курс';

  @override
  String get articleWord => 'Стаття';

  @override
  String get videoWord => 'Відео';

  @override
  String get quizWord => 'Тест';

  @override
  String get courseShareCopied => 'Посилання на курс скопійовано!';

  @override
  String get addedToCartSnackbar => 'Додано до кошика';

  @override
  String get viewCartAction => 'Переглянути кошик';

  @override
  String get inCartBadge => 'У кошику ✓';

  @override
  String get addToCartButton => 'Додати до кошика';

  @override
  String get wishlistAddedSnackbar => 'Курс додано до списку бажань';

  @override
  String get wishlistRemovedSuccessSnackbar => 'Курс видалено зі списку бажань';

  @override
  String get lessonCompletedAll => 'Вітаємо! Ви пройшли всі уроки цього курсу.';

  @override
  String get noteAddedSuccess => 'Нотатку успішно додано';

  @override
  String get lessonAlreadyDownloaded =>
      'Урок уже збережено для офлайн-перегляду';

  @override
  String get lessonLinkCopied => 'Посилання на урок скопійовано';

  @override
  String get contentReportThanks =>
      'Дякуємо за відгук! Наша команда перевірить урок.';

  @override
  String get courseCompletionCertificate => 'Сертифікат про закінчення курсу';

  @override
  String get reportContentIssue => 'Повідомити про проблему з контентом';

  @override
  String get loginOrSocial => 'Або увійдіть за допомогою';

  @override
  String get loginSuccessSnackbar => 'Успішний вхід';

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
  String get cartClearAllTitle => 'Очистити всі елементи кошика?';

  @override
  String cartClearAllMessage(String count) {
    return 'Ви впевнені, що бажаєте видалити всі курси $count зі свого кошика?';
  }

  @override
  String get cartClearAllHint =>
      'Усі курси будуть видалені з вашого кошика. Ви можете будь-коли додати їх назад.';

  @override
  String cartClearAllConfirm(String count) {
    return 'Очистити все ($count)';
  }

  @override
  String get cartClearedSuccess => 'Кошик успішно очищено';

  @override
  String get cartClearFailed => 'Не вдалося очистити кошик';

  @override
  String cartViewWishlistCount(String count) {
    return 'Переглянути елементи списку бажань ($count)';
  }

  @override
  String get cartGoToWishlist => 'Перейти до списку бажань';

  @override
  String get wishlistClearAllTitle => 'Очистити всі елементи списку бажань?';

  @override
  String wishlistClearAllMessage(String count) {
    return 'Ви впевнені, що хочете видалити всі $count курси зі свого списку бажань?';
  }

  @override
  String get wishlistClearAllHint =>
      'Усі збережені курси буде видалено. Ви можете будь-коли додати їх назад із Explore.';

  @override
  String wishlistClearAllConfirm(String count) {
    return 'Очистити все ($count)';
  }

  @override
  String get wishlistClearedSuccess => 'Список бажань успішно очищено';

  @override
  String get wishlistClearFailed => 'Не вдалося очистити список бажань';

  @override
  String get wishlistClearTooltip => 'Очистити все';

  @override
  String wishlistViewCartCount(String count) {
    return 'Переглянути елементи кошика ($count)';
  }

  @override
  String get wishlistGoToCart => 'Перейти до кошика';

  @override
  String get checkoutCardNumberInvalid =>
      'Введіть дійсний 16-значний номер картки';

  @override
  String get checkoutCardExpiryInvalidFormat =>
      'Будь ласка, введіть дійсну дату закінчення терміну дії картки (MM / YY)';

  @override
  String get checkoutCardExpiredDate => 'Термін дії картки недійсний';

  @override
  String get checkoutCardCvcInvalid =>
      'Будь ласка, введіть дійсний 3 або 4-значний код CVC';

  @override
  String get checkoutCardHolderNameRequired =>
      'Будь ласка, введіть ім\'я власника картки';

  @override
  String get checkoutCartEmptySnackbar => 'Кошик порожній';

  @override
  String get checkoutPaymentStartFailed => 'Не вдалося ініціювати платіж';

  @override
  String get checkoutClientSecretMissing =>
      'Ключ безпеки не отримано від платіжного шлюзу';

  @override
  String get checkoutCardVerificationFailed => 'Не вдалося перевірити картку';

  @override
  String get checkoutStripeProcessingFailed =>
      'Не вдалося обробити платіж Stripe';

  @override
  String get checkoutServerConfirmationFailed =>
      'Помилка підтвердження платежу на сервері';

  @override
  String get checkoutEmptyCartTitle => 'Ваш кошик порожній';

  @override
  String get checkoutEmptyCartDesc =>
      'Ви ще не додали жодного курсу у свій кошик. Перегляньте наші курси та почніть навчатися!';

  @override
  String get checkoutContinueFreeReview => 'Перейти до безкоштовного перегляду';

  @override
  String get checkoutFreeOrderBadge => '100% безкоштовне замовлення (zsh.00)';

  @override
  String get checkoutFreeOrderNotice =>
      'Для цього замовлення не потрібна платіжна інформація. Ви можете переходити безпосередньо до підтвердження реєстрації.';

  @override
  String get checkoutFreeCheckoutTitle => '100% безкоштовна оплата';

  @override
  String get checkoutConfirmFreeEnrollment =>
      'Підтвердити безкоштовну реєстрацію';

  @override
  String get checkoutFreePrice => 'безкоштовно';

  @override
  String get checkoutFreeZero => 'Безкоштовно (zsh.00)';

  @override
  String checkoutCoursesCount(String count) {
    return '$count курсів';
  }

  @override
  String get notificationsClearAllTitle => 'Очистити всі сповіщення?';

  @override
  String notificationsClearAllMessage(String count) {
    return 'Ви впевнені, що хочете видалити всі сповіщення $count? Цю дію не можна скасувати.';
  }

  @override
  String get notificationsClearAllHint =>
      'Усі ваші сповіщення буде видалено, а папка \"Вхідні\" відновиться.';

  @override
  String notificationsClearAllConfirm(String count) {
    return 'Очистити все ($count)';
  }

  @override
  String get notificationsClearSuccess => 'Усі сповіщення успішно видалено';

  @override
  String get notificationsClearFailed => 'Не вдалося очистити сповіщення';

  @override
  String get notificationsClearTooltip => 'Очистити все';

  @override
  String get notificationsViewDetails => 'Переглянути деталі';

  @override
  String get notificationsEmptyCategoryTitle =>
      'У цій категорії немає повідомлень';

  @override
  String get notificationsEmptyCategorySubtitle =>
      'Спробуйте перейти до іншої категорії або перегляньте всі сповіщення';

  @override
  String get notificationsEmptyAllSubtitle =>
      'Ми будемо тримати вас в курсі останніх оновлень і сповіщень тут';

  @override
  String get notificationsViewAll => 'Переглянути всі сповіщення';

  @override
  String get learningFilterAndSortTitle => 'Фільтрувати та сортувати курси';

  @override
  String get learningFilterReset => 'Скинути';

  @override
  String get learningSortByTitle => 'Сортувати за';

  @override
  String get learningSortRecentActivity => 'Нещодавно доступні';

  @override
  String get learningSortRecentEnrolled => 'Нещодавно зареєстрований';

  @override
  String get learningSortTitleAZ => 'Назва (A-Z)';

  @override
  String get learningSortProgress => 'прогрес %';

  @override
  String get learningStatusTitle => 'Статус курсу';

  @override
  String get learningStatusAll => 'Усі курси';

  @override
  String get learningStatusInProgress => 'В роботі';

  @override
  String get learningStatusCompleted => 'Виконано';

  @override
  String get learningStatusNotStarted => 'Не розпочато';

  @override
  String get learningFilterApply => 'Застосувати фільтри';

  @override
  String get learningSearchCoursesHint => 'Шукайте свої курси...';

  @override
  String get learningSearchWishlistHint => 'Пошук у списку бажань...';

  @override
  String get learningSearchCertificatesHint => 'Пошук сертифікатів...';

  @override
  String get learningTabMyCourses => 'Мої курси';

  @override
  String get learningTabFavourite => 'Мій улюблений';

  @override
  String get learningTabCertificates => 'Мої сертифікати';

  @override
  String get learningNoCoursesTitle => 'Курсів ще немає';

  @override
  String get learningNoCoursesSubtitle =>
      'Ознайомтеся з тисячами преміум-курсів і почніть навчання вже сьогодні';

  @override
  String get learningFilterButton => 'фільтр';

  @override
  String learningFilterAllCount(String count) {
    return 'Усі ($count)';
  }

  @override
  String get learningStatusNotStartedShort => 'Не розпочато';

  @override
  String get learningNoMatchTitle => 'Немає відповідних курсів';

  @override
  String learningNoMatchSubtitle(String query) {
    return 'Не знайдено курсів, які містять \"$query\". Спробуйте шукати за іншими термінами.';
  }

  @override
  String get learningNoInProgressTitle => 'Немає курсів';

  @override
  String get learningNoInProgressSubtitle =>
      'Почніть переглядати уроки на курсах, на які ви зареєструвалися, щоб відстежувати свій прогрес тут.';

  @override
  String get learningNoCompletedTitle => 'Ще немає завершених курсів';

  @override
  String get learningNoCompletedSubtitle =>
      'Продовжуйте навчання, щоб відзначити свій прогрес і переглянути завершені курси тут.';

  @override
  String get learningNoUnstartedTitle => 'Немає непочатих курсів';

  @override
  String get learningNoUnstartedSubtitle =>
      'Чудово! Ви вже почали навчання на всіх курсах, на які ви зареєструвалися.';

  @override
  String get learningNoFilterMatchTitle =>
      'Жоден курс не відповідає цьому фільтру';

  @override
  String get learningNoFilterMatchSubtitle =>
      'Змініть параметри фільтрування або сортування, щоб відобразити свої курси.';

  @override
  String learningViewAllCoursesCount(String count) {
    return 'Переглянути всі курси ($count)';
  }

  @override
  String learningSavedCoursesCount(String count) {
    return 'Збережені курси ($count)';
  }

  @override
  String get learningClearAllSaved => 'Очистити все';

  @override
  String get learningNoCertificatesTitle => 'Ще немає сертифікатів';

  @override
  String get learningNoCertificatesSubtitle =>
      'Пройдіть курси, щоб отримати акредитовані сертифікати, які підтверджують ваші досягнення';

  @override
  String get learningGoToCourses => 'Перейти до моїх курсів';

  @override
  String learningCertIssuedDate(String date) {
    return 'Видано: $date';
  }

  @override
  String get learningCertView => 'Переглянути';

  @override
  String get learningResumeLesson => 'Підсумок уроку';

  @override
  String learningProgressPercentComplete(String percent) {
    return 'Виконано $percent%.';
  }

  @override
  String learningViewCartCount(String count) {
    return 'Переглянути елементи кошика ($count)';
  }

  @override
  String get learningGoToCart => 'Перейти до кошика';

  @override
  String get playerLessonMarkedCompleted => 'Урок позначено як завершений ✓';

  @override
  String get playerLessonMarkedIncomplete => 'Урок позначено як незавершений';

  @override
  String get playerCommentPostedSuccess => 'Коментар успішно опубліковано';

  @override
  String get playerCommentPostFailed => 'Не вдалося опублікувати коментар';

  @override
  String get playerReplyPostedSuccess => 'Відповідь успішно опубліковано';

  @override
  String get playerReplyPostFailed => 'Не вдалося опублікувати відповідь';

  @override
  String get playerCourseNotFound => 'Курс не знайдено';

  @override
  String get playerCheckEnrollmentPrompt =>
      'Спочатку підтвердьте свою реєстрацію на курс';

  @override
  String get playerReturnToCourses => 'Моє навчання';

  @override
  String get playerWatchLecture => 'Курсова лекція';

  @override
  String get playerCertificateTooltip => 'Сертифікат';

  @override
  String get playerRateCourseTooltip => 'Оцініть курс';

  @override
  String get playerReadingArticleBadge => 'Читання статті • 5 хв';

  @override
  String get playerReadFullTextBelow => 'Читайте повний текст нижче ↓';

  @override
  String get playerTabReviews => 'Відгуки';

  @override
  String get playerNoSectionsAvailable => 'Немає доступних розділів';

  @override
  String playerLessonsCount(String count) {
    return '$count уроків';
  }

  @override
  String get playerPlayingBadge => 'Граючи';

  @override
  String get playerArticleBadge => 'ст';

  @override
  String get playerVideoBadge => 'відео';

  @override
  String get playerFullArticleContent => 'Повний вміст статті';

  @override
  String get playerArticlePlaceholder =>
      'Ласкаво просимо на цей урок читання.\n\nЦей розділ охоплює основні поняття та практичні кроки, необхідні для оволодіння навичками цього уроку.';

  @override
  String get playerAboutCourseTitle => 'Про цей курс';

  @override
  String get playerShowLess => 'Показати менше';

  @override
  String get playerReadMore => 'Читати далі';

  @override
  String get playerWhatYouWillLearn => 'Чого ви навчитеся';

  @override
  String get playerCourseInfoTitle => 'Деталі курсу';

  @override
  String get playerTotalDurationTitle => 'Загальна тривалість';

  @override
  String get playerTotalLessonsTitle => 'Усього уроків';

  @override
  String playerLessonsNumber(String count) {
    return '$count уроків';
  }

  @override
  String get playerLevelTitle => 'Рівень';

  @override
  String get playerAllLevels => 'Усі рівні';

  @override
  String get playerLanguageTitle => 'Мова';

  @override
  String get playerLanguageArabic => 'Арабська';

  @override
  String get playerPrerequisitesTitle => 'Вимоги до курсу';

  @override
  String get playerCertificateCardTitle => 'Сертифікат курсу';

  @override
  String get playerCourseCompletedSuccess => 'Вітаємо! Курс завершено';

  @override
  String get playerProgressLabel => 'Прогрес';

  @override
  String get playerViewCertificateBtn => 'Переглянути сертифікат';

  @override
  String get playerCertifiedInstructor => 'Сертифікований викладач';

  @override
  String playerDiscussionsCount(String count) {
    return '$count запитань та обговорень';
  }

  @override
  String get playerAskQuestionHint => 'Введіть своє запитання тут...';

  @override
  String get playerPostBtn => 'Опублікувати';

  @override
  String get playerNoDiscussionsTitle => 'Обговорень ще немає';

  @override
  String get playerNoDiscussionsSubtitle => 'Поставте запитання першим!';

  @override
  String get playerInstructorBadge => 'Викладач';

  @override
  String get playerCancelReply => 'Скасувати';

  @override
  String get playerReplyAction => 'Відповісти';

  @override
  String playerRepliesCount(String count) {
    return '$count відповідей';
  }

  @override
  String get playerWriteReplyHint => 'Напишіть відповідь...';

  @override
  String get playerSendReplyBtn => 'Відповісти';

  @override
  String get playerCourseFeedbackTitle => 'Оцінка та відгуки про курс';

  @override
  String get playerOutOf5 => 'з 5';

  @override
  String playerRatingsFromEnrolledCount(String count) {
    return '$count оцінок від зареєстрованих студентів';
  }

  @override
  String get playerKeepLearningToRate => 'Продовжуйте навчання, щоб оцінити';

  @override
  String get playerRateAfter80Hint =>
      'Ви зможете оцінити цей курс після проходження 80% матеріалу';

  @override
  String get playerCurrentProgressLabel => 'Ваш прогрес:';

  @override
  String get playerYourCurrentRating => 'Ваша оцінка';

  @override
  String get playerEditRating => 'Редагувати оцінку';

  @override
  String get playerDeleteRatingTooltip => 'Видалити оцінку';

  @override
  String get playerUpdateRatingTitle => 'Оновити оцінку';

  @override
  String get playerRateCourseTitle => 'Оцінити цей курс';

  @override
  String get playerWriteReviewHint =>
      'Поділіться відгуком про якість матеріалів (необов\'язково)...';

  @override
  String get playerRatingSubmitSuccess => 'Оцінку успішно надіслано!';

  @override
  String get playerRatingSubmitFailed => 'Не вдалося надіслати оцінку';

  @override
  String get playerSaveChangesBtn => 'Зберегти зміни';

  @override
  String get playerSubmitReviewBtn => 'Надіслати відгук';

  @override
  String get playerLearnerReviewsTitle => 'Відгуки студентів';

  @override
  String playerReviewsCount(String count) {
    return '$count відгуків';
  }

  @override
  String get playerNoWrittenReviewsTitle => 'Письмових відгуків ще немає';

  @override
  String get playerNoWrittenReviewsSubtitle => 'Поділіться враженнями першим!';

  @override
  String get playerRatingLabel5 => 'Відмінно 🌟 (5/5)';

  @override
  String get playerRatingLabel4 => 'Дуже добре 👍 (4/5)';

  @override
  String get playerRatingLabel3 => 'Середньо 👌 (3/5)';

  @override
  String get playerRatingLabel2 => 'Потребує покращення 🤔 (2/5)';

  @override
  String get playerRatingLabel1 => 'Погано 👎 (1/5)';

  @override
  String get playerDeleteRatingDialogTitle => 'Видалити оцінку';

  @override
  String get playerDeleteRatingDialogMessage =>
      'Ви впевнені, що хочете видалити свій відгук про цей курс?';

  @override
  String get playerDeleteConfirmBtn => 'Видалити';

  @override
  String get playerRatingDeleteSuccess => 'Оцінку успішно видалено';

  @override
  String get playerPreviousLesson => 'Попередній урок';

  @override
  String get playerExitFullscreenTooltip => 'Вийти з повноекранного режиму';

  @override
  String instructorsAvailableCount(String count) {
    return '$count викладачів доступно';
  }

  @override
  String get instructorsNotFound => 'Викладачів не знайдено';

  @override
  String instructorsCoursesCount(String count) {
    return '$count курсів';
  }

  @override
  String get instructorsSearchHint =>
      'Пошук за іменем інструктора або спеціальністю...';

  @override
  String get instructorsSortAll => 'все';

  @override
  String get instructorsSortTopRated => 'Найвищий рейтинг';

  @override
  String get instructorsSortMostStudents => 'Більшість студентів';

  @override
  String get instructorsSortMostCourses => 'Більшість курсів';

  @override
  String get instructorsNotFoundSubtitle =>
      'Спробуйте виконати пошук під іншою назвою або очистіть фільтри';

  @override
  String get exploreCompleteCourse => 'Комплексний курс';

  @override
  String get exploreGeneralCategory => 'Загальний';

  @override
  String courseShareMessage(String title, String url) {
    return 'Перегляньте курс \"$title\" на EduLab: $url';
  }

  @override
  String get courseDetailsDefaultTitle => 'Деталі курсу';

  @override
  String get courseDetailsTooltipShare => 'Поділіться';

  @override
  String get courseDetailsTooltipWishlist => 'Список бажань';

  @override
  String get courseDetailsTooltipCart => 'Візок';

  @override
  String get courseDetailsNotFound => 'Курс не знайдено';

  @override
  String get courseDetailsDefaultCategory => 'курс';

  @override
  String courseDetailsTotalRatingsCount(String count) {
    return '($count оцінок)';
  }

  @override
  String courseDetailsLecturesCount(String count) {
    return '$count лекцій';
  }

  @override
  String get courseDetailsCertificateBadge => 'Сертифікат';

  @override
  String get courseDetailsTabOverview => 'Огляд';

  @override
  String get courseDetailsTabCurriculum => 'навчальний план';

  @override
  String get courseDetailsTabInstructor => 'Інструктор';

  @override
  String get courseDetailsTabReviews => 'Відгуки';

  @override
  String get courseDetailsFullDescriptionTitle => 'опис';

  @override
  String get courseDetailsShowLess => 'Показувати менше';

  @override
  String get courseDetailsShowMore => 'Показати більше...';

  @override
  String courseDetailsCurriculumSectionsLectures(
    String sections,
    String lectures,
  ) {
    return '$sections розділів • $lectures лекцій';
  }

  @override
  String get courseDetailsCollapseAll => 'Згорнути все';

  @override
  String get courseDetailsExpandAll => 'Розгорнути все';

  @override
  String get courseDetailsCurriculumComingSoon =>
      'Деталі навчальної програми незабаром';

  @override
  String courseDetailsSectionLecturesCount(String count) {
    return '$count лекцій';
  }

  @override
  String get courseDetailsLecturePreviewBtn => 'Попередній перегляд';

  @override
  String get courseDetailsDefaultInstructorTitle =>
      'Старший інструктор та сертифікований експерт';

  @override
  String get courseDetailsInstructorRatingLabel => 'Рейтинг';

  @override
  String get courseDetailsInstructorStudentsLabel => 'Студенти';

  @override
  String get courseDetailsInstructorSectionsLabel => 'Розділи';

  @override
  String get courseDetailsAboutInstructorTitle => 'Про інструктора:';

  @override
  String get courseDetailsDefaultInstructorAbout =>
      'Сертифікований інструктор із великим досвідом надання професійної освіти тисячам студентів у всьому світі.';

  @override
  String courseDetailsStudentRatingsCount(String count) {
    return '$count оцінки студентів';
  }

  @override
  String get courseDetailsNoWrittenReviews => 'Ще немає письмових відгуків';

  @override
  String get courseDetailsRelatedCourses =>
      'Схожі курси, які вам можуть сподобатися';

  @override
  String courseDetailsDiscountPercent(String percent) {
    return 'ЗНИЖКА $percent%.';
  }

  @override
  String get courseDetailsResumeCourse => 'Відновити курс';

  @override
  String get courseDetailsTryAgain => 'Спробуйте знову';

  @override
  String get courseDetailsEstimatedReading => '📖 Приблизний час читання: 4 хв';

  @override
  String get courseDetailsSampleArticleContent =>
      'Ласкаво просимо на лекцію цієї статті.\n\nЦей розділ охоплює основні теоретичні концепції та практичні кроки для опанування предмету.\n\n• Ключові висновки:\n1. Зрозумійте основну термінологію та архітектурні моделі.\n2. Практичні вправи та постійна практика.\n3. Опорні довідки та завдання.\n\nПриємного читання!';

  @override
  String certDownloadedSuccess(String course, String format) {
    return 'Сертифікат для \"$course\" успішно завантажено у форматі $format!';
  }

  @override
  String certVerifiedFullRequirements(String code) {
    return 'Ідентифікатор перевірки: $code • Вимоги виконано на 100%.';
  }

  @override
  String get certCompletionTitle => 'Сертифікат про закінчення';

  @override
  String get certCompletionSubtitle => 'Сертифікат про закінчення курсу';

  @override
  String get certAnnounceStudent =>
      'Навчальна академія EducationLab цим засвідчує, що:';

  @override
  String get certCompletionRequirementsMet =>
      'Успішно пройшов усі вимоги курсу навчання:';

  @override
  String certIssueDateText(String date) {
    return 'Дата випуску: $date';
  }

  @override
  String certIdNumberText(String code) {
    return 'Ідентифікатор сертифіката: $code';
  }

  @override
  String get certPlatformManagement => 'Управління платформою';

  @override
  String get certInstructorRoleTitle => 'Викладач курсу';

  @override
  String get commonLoading => 'Завантаження...';

  @override
  String get homeGuestTagline =>
      'Розумна платформа для навчання та розвитку навичок';

  @override
  String get catTagHighestDemand => 'Найвищий попит';

  @override
  String get catTagMostPopular => 'Найпопулярніші';

  @override
  String get catTagTrending => 'У тренді';

  @override
  String get catTagFastestGrowing => 'Найшвидше зростання';

  @override
  String get catTagHighDemand => 'Високий попит';

  @override
  String get catTagTopRated => 'Найвищий рейтинг';

  @override
  String get catTagEssential => 'Дуже важливо';

  @override
  String get catTagAdvanced => 'Просунутий рівень';

  @override
  String get catTagEntrepreneurs => 'Підприємці';

  @override
  String get catTagSalesGrowth => 'Зростання продажів';

  @override
  String get catDevTitle => 'Програмування та розробка ПЗ';

  @override
  String get catDevSubtitle => 'Інженерія ПЗ, архітектура систем та алгоритми';

  @override
  String get catWebTitle => 'Веброзробка';

  @override
  String get catWebSubtitle => 'Frontend, Backend та Fullstack розробка';

  @override
  String get catMobileTitle => 'Розробка мобільних додатків';

  @override
  String get catMobileSubtitle => 'Додатки на Flutter, iOS та Android';

  @override
  String get catAiTitle => 'Штучний інтелект';

  @override
  String get catAiSubtitle => 'Машинне навчання, Deep Learning та AI';

  @override
  String get catDataTitle => 'Наука про дані та аналітика';

  @override
  String get catDataSubtitle => 'Аналіз даних, статистика та Big Data';

  @override
  String get catDesignTitle => 'UI/UX та дизайн продуктів';

  @override
  String get catDesignSubtitle => 'UI/UX, прототипування та дизайн продукту';

  @override
  String get catSecurityTitle => 'Кібербезпека та мережі';

  @override
  String get catSecuritySubtitle => 'Кібербезпека, етичний хакінг та мережі';

  @override
  String get catCloudTitle => 'Хмарні технології та DevOps';

  @override
  String get catCloudSubtitle => 'Хмарна інфраструктура, DevOps та CI/CD';

  @override
  String get catBusinessTitle => 'Бізнес та управління проектами';

  @override
  String get catBusinessSubtitle => 'Підприємництво, Agile та лідерство';

  @override
  String get catMarketingTitle => 'Цифровий маркетинг';

  @override
  String get catMarketingSubtitle =>
      'Digital-маркетинг, SEO та стратегії зростання';

  @override
  String get timeJustNow => 'Щойно';

  @override
  String timeMinutesAgo(String count) {
    return '$count хв тому';
  }

  @override
  String timeHoursAgo(String count) {
    return '$count год тому';
  }

  @override
  String timeDaysAgo(String count) {
    return '$count дн тому';
  }

  @override
  String timeWeeksAgo(String count) {
    return '$count тиж тому';
  }

  @override
  String timeMonthsAgo(String count) {
    return '$count міс тому';
  }

  @override
  String wishlistLecturesCount(String count) {
    return '$count лекцій';
  }

  @override
  String get instructorProfileTitle => 'Профіль інструктора';

  @override
  String instructorProfileLinkCopied(String name) {
    return 'Посилання для $name скопійовано в буфер обміну';
  }

  @override
  String get instructorDefaultName => 'Інструктор';

  @override
  String get instructorProfileBadge => 'ІНСТРУКТОР';

  @override
  String get instructorProfileTotalStudents => 'Всього студентів';

  @override
  String get instructorProfileRating => 'Рейтинг інструктора';

  @override
  String get instructorProfileCourses => 'Курси';

  @override
  String get instructorProfileShare => 'Поділитися профілем';

  @override
  String get instructorProfileLinkOpenError =>
      'Не вдалося відкрити посилання, скопійовано в буфер обміну';

  @override
  String get instructorProfileWebsite => 'Веб-сайт';

  @override
  String get instructorProfileAboutMe => 'Про себе';

  @override
  String get instructorProfileShowLess => 'Показати менше';

  @override
  String get instructorProfileShowMore => 'Показати більше';

  @override
  String get instructorProfileExpertise => 'Сфери експертизи';

  @override
  String get instructorProfileSortAll => 'Усі';

  @override
  String get instructorProfileSortTopRated => 'Найвищий рейтинг';

  @override
  String get instructorProfileSortPopular => 'Популярні';

  @override
  String get instructorProfileSortNewest => 'Найновіші';

  @override
  String get instructorProfileCoursesTitle => 'Курси інструктора';

  @override
  String get instructorProfileNoCoursesFilter =>
      'Для цього фільтра не знайдено курсів';

  @override
  String instructorProfileLoadMoreCourses(String count) {
    return 'Завантажити ще курси (залишилося $count)';
  }

  @override
  String get instructorProfileLoadingMoreCourses =>
      'Завантаження додаткових курсів...';

  @override
  String instructorProfileAllCoursesLoaded(String count) {
    return 'Всі курси ($count) завантажено';
  }

  @override
  String get instructorProfileStudentFeedback => 'Відгуки студентів';

  @override
  String instructorProfileReviewsCount(String count) {
    return '$count відгуків';
  }

  @override
  String instructorProfileBasedOnReviews(String count) {
    return 'На основі $count відгуків';
  }

  @override
  String get instructorProfileRecentReviews => 'Останні відгуки';

  @override
  String instructorProfileLoadMoreReviews(String count) {
    return 'Завантажити ще відгуки (залишилося $count)';
  }

  @override
  String get instructorProfileLoadingMoreReviews =>
      'Завантаження додаткових відгуків...';

  @override
  String instructorProfileAllReviewsLoaded(String count) {
    return 'Всі відгуки ($count) завантажено';
  }

  @override
  String get instructorProfileNoReviewsYet => 'Письмових відгуків ще немає';

  @override
  String get instructorProfileRatingDesc =>
      'Рейтинг базується на загальних оцінках студентів за всіма курсами інструктора';

  @override
  String get instructorProfileLoadError =>
      'Не вдалося завантажити дані інструктора, спробуйте пізніше';

  @override
  String get instructorProfileDefaultStudentName => 'Студент';

  @override
  String get instructorProfileDefaultHeadline =>
      'Старший інструктор та сертифікований експерт';

  @override
  String get instructorProfileDefaultBio =>
      'Сертифікований інженер-програміст і технічний інструктор із багатим досвідом розробки масштабованих програмних систем і мобільних додатків.\nНавчив тисячі студентів та інженерів по всьому світу, створюючи професійний контент, присвячений чистому коду, чистій архітектурі та сучасним масштабованим рішенням.';

  @override
  String get supportNewChat => 'Новий чат';

  @override
  String get supportNoChatsTitle => 'Поки що немає звернень до підтримки';

  @override
  String get supportNoChatsDesc =>
      'Наша служба підтримки готова цілодобово допомогти та відповісти на всі ваші запитання';

  @override
  String get supportStartNewConversation => 'Почати нову розмову';

  @override
  String get supportNoMessagesYet => 'Повідомлень поки що немає';

  @override
  String get supportRetry => 'Спробувати знову';

  @override
  String get supportOpenTicket => 'Відкритий тікет';

  @override
  String get supportClosedTicket => 'Закритий тікет';

  @override
  String get supportCloseAction => 'Закрити';

  @override
  String get supportReopenAction => 'Відкрити знову';

  @override
  String get supportNoMessagesInChat =>
      'У цьому чаті поки що немає повідомлень';

  @override
  String get supportYou => 'Ви';

  @override
  String get supportTeam => 'Служба підтримки';

  @override
  String get supportTypeMessageHint => 'Введіть повідомлення...';

  @override
  String get supportConversationClosedNotice => 'Ця розмова наразі закрита.';

  @override
  String get supportCloseDialogTitle => 'Закрити розмову?';

  @override
  String get supportCloseDialogDesc =>
      'Ви впевнені, що хочете закрити цей чат? Ви можете відкрити його знову в будь-який момент, щоб продовжити спілкування.';

  @override
  String get supportCancel => 'Скасувати';

  @override
  String get supportYesClose => 'Так, закрити';

  @override
  String get supportNewChatTitle => 'Новий чат із підтримкою';

  @override
  String get supportNewChatSubtitle => 'Наша команда готова вам допомогти';

  @override
  String get supportSubjectLabel => 'Тема';

  @override
  String get supportSubjectHint =>
      'напр., Питання щодо курсу, Проблема з оплатою...';

  @override
  String get supportMessageLabel => 'Повідомлення';

  @override
  String get supportMessageHint =>
      'Опишіть вашу проблему або запитання детально...';

  @override
  String get supportMessageRequired => 'Будь ласка, введіть повідомлення';

  @override
  String get supportStartConversationBtn => 'Почати розмову';

  @override
  String get supportCreateError =>
      'Не вдалося створити розмову, будь ласка, спробуйте пізніше';

  @override
  String get supportTopicCourse => 'Питання щодо курсу';

  @override
  String get supportTopicPayment => 'Проблема з оплатою';

  @override
  String get supportTopicCertificates => 'Сертифікати';

  @override
  String get supportTopicTech => 'Технічна проблема';

  @override
  String get supportTopicGeneral => 'Загальний запит';

  @override
  String get cartGuestTitle => 'Увійдіть, щоб переглянути кошик';

  @override
  String get cartGuestSubtitle =>
      'Будь ласка, увійдіть, щоб отримати доступ до кошика та придбати курси.';

  @override
  String get wishlistGuestTitle => 'Увійдіть, щоб переглянути список бажань';

  @override
  String get wishlistGuestSubtitle =>
      'Будь ласка, увійдіть, щоб мати доступ до збережених курсів у будь-який час.';

  @override
  String get courseDetailsLoginRequiredTitle => 'Потрібно увійти';

  @override
  String get courseDetailsLoginRequiredDesc =>
      'Спершу необхідно увійти, щоб придбати цей курс та зберегти свій прогрес.';

  @override
  String get courseDetailsProceedToLogin => 'Перейти до входу';

  @override
  String get messagesGuestTitle => 'Увійдіть, щоб переглянути повідомлення';

  @override
  String get messagesGuestSubtitle =>
      'Будь ласка, увійдіть, щоб отримати доступ до листування з підтримкою.';

  @override
  String get notificationsGuestTitle => 'Увійдіть, щоб переглянути сповіщення';

  @override
  String get notificationsGuestSubtitle =>
      'Будь ласка, увійдіть, щоб переглядати останні сповіщення щодо вашого облікового запису та курсів.';

  @override
  String get legalTitle => 'Про нас та юридична інформація';

  @override
  String get legalTabAbout => 'Про EduLab';

  @override
  String get legalTabPrivacy => 'Конфіденційність';

  @override
  String get legalTabTerms => 'Умови';

  @override
  String get legalUpdated => 'Оновлено:';

  @override
  String get legalNeedHelpTitle => 'Потрібна допомога чи маєте запитання?';

  @override
  String get legalNeedHelpDesc =>
      'Команда підтримки EduLab готова допомогти вам цілодобово. Зв\'яжіться з нами електронною поштою.';

  @override
  String get legalEmailCopied => 'Email підтримки скопійовано в буфер обміну';

  @override
  String get legalNoContent => 'Наразі вміст недоступний';

  @override
  String get checkoutDigitalReceipt => 'Електронний чек';

  @override
  String get checkoutTransactionDate => 'Дата транзакції';

  @override
  String get checkoutFreeEnrollment => 'Безкоштовний запис';

  @override
  String get checkoutEnrolledCourses => 'Придбані курси';

  @override
  String get checkoutTransactionStatus => 'Статус';

  @override
  String get checkoutStatusSuccess => 'Успішно завершено';

  @override
  String get checkoutTotalPaid => 'Всього сплачено';

  @override
  String get checkoutCopied => 'Скопійовано!';

  @override
  String get checkoutCardHolderHint => 'Повне ім\'я як на картці';
}

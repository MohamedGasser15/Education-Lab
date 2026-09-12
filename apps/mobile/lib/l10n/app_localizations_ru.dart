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
      'Ваша идеальная платформа для современного интерактивного обучения и профессионального роста.';

  @override
  String get onboardingTitle2 => 'Учитесь у лучших преподавателей';

  @override
  String get onboardingSubtitle2 =>
      'Тысячи профессиональных курсов по программированию, дизайну, бизнесу и науке о данных.';

  @override
  String get onboardingTitle3 => 'Сертификаты и гарантированный успех';

  @override
  String get onboardingSubtitle3 =>
      'Отслеживайте свой прогресс, сдавайте тесты и получайте признанные сертификаты.';

  @override
  String get onboardingNext => 'Далее';

  @override
  String get onboardingStart => 'Начать сейчас';

  @override
  String get splashAppName => 'Education Lab';

  @override
  String get splashTagline => 'Умная образовательная платформа';

  @override
  String get loginTagline => 'Добро пожаловать на умную платформу обучения';

  @override
  String get loginAppName => 'EduLab';

  @override
  String get loginTabLogin => 'Вход';

  @override
  String get loginTabRegister => 'Регистрация';

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
  String get loginSubmitLoading => 'Выполняется вход';

  @override
  String get loginGuest => 'Войти как гость';

  @override
  String get loginOr => 'или';

  @override
  String get loginEmailRequired => 'Введите адрес электронной почты';

  @override
  String get loginEmailInvalid => 'Введите корректный адрес почты';

  @override
  String get loginPasswordRequired => 'Введите пароль';

  @override
  String get registerStepEmail => 'Почта';

  @override
  String get registerStepCode => 'Код';

  @override
  String get registerStepData => 'Данные';

  @override
  String get registerSendCodeInfo =>
      'Мы отправим код подтверждения на этот адрес';

  @override
  String get registerSendCode => 'Отправить код';

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
      'Не менее 8 символов, заглавная буква и цифра';

  @override
  String get registerConfirmLabel => 'Подтвердите пароль';

  @override
  String get registerConfirmHint => 'Повторите пароль';

  @override
  String get registerSubmit => 'Создать аккаунт';

  @override
  String get registerSubmitLoading => 'Создание аккаунта';

  @override
  String get registerSuccess => 'Аккаунт успешно создан';

  @override
  String get registerNameRequired => 'Введите полное имя';

  @override
  String get registerNameMinLength =>
      'Имя должно содержать не менее 6 символов';

  @override
  String get registerPasswordMinLength =>
      'Пароль должен содержать не менее 8 символов';

  @override
  String get registerPasswordUppercase =>
      'Пароль должен содержать хотя бы одну заглавную букву';

  @override
  String get registerPasswordNumber =>
      'Пароль должен содержать хотя бы одну цифру';

  @override
  String get registerConfirmRequired => 'Подтвердите пароль';

  @override
  String get registerConfirmMismatch => 'Пароли не совпадают';

  @override
  String get networkError => 'Ошибка подключения, попробуйте снова';

  @override
  String homeGreeting(String name) {
    return 'Здравствуйте, $name!';
  }

  @override
  String get homeSubtitle => 'Чему вы хотите научиться сегодня?';

  @override
  String get homeSearchHint => 'Поиск курсов или навыков...';

  @override
  String get homeSectionContinue => 'Продолжить обучение';

  @override
  String get homeSectionRecommended => 'Рекомендовано вам';

  @override
  String get homeSectionPopular => 'Самые популярные';

  @override
  String get homeSectionTopRated => 'С лучшими оценками';

  @override
  String get homeSectionByCategory => 'По категориям';

  @override
  String get homeHeroTitle => 'Специальные предложения';

  @override
  String get homeHeroSubtitle => 'Скидки до 70% на популярные курсы';

  @override
  String get homeHeroButton => 'Узнать больше';

  @override
  String get homeViewAll => 'Все';

  @override
  String get homeProgressLabel => 'Завершено';

  @override
  String get exploreTitle => 'Каталог курсов';

  @override
  String get exploreSearchHint => 'Поиск по курсу, навыку или преподавателю...';

  @override
  String get exploreAllCategories => 'Все категории';

  @override
  String get exploreFilter => 'Фильтры';

  @override
  String get exploreSort => 'Сортировка';

  @override
  String get exploreNoResults => 'Ничего не найдено';

  @override
  String get exploreNoResultsHint =>
      'Попробуйте изменить запрос или параметры фильтра';

  @override
  String exploreCoursesCount(int count) {
    return '$count курсов';
  }

  @override
  String get exploreFilterTitle => 'Фильтры';

  @override
  String get exploreFilterApply => 'Применить';

  @override
  String get exploreFilterReset => 'Сбросить';

  @override
  String get exploreFilterPrice => 'Цена';

  @override
  String get exploreFilterLevel => 'Уровень';

  @override
  String get exploreFilterRating => 'Рейтинг';

  @override
  String get exploreFilterDuration => 'Длительность';

  @override
  String get exploreSortTitle => 'Сортировка';

  @override
  String get exploreSortRelevance => 'По релевантности';

  @override
  String get exploreSortNewest => 'Сначала новые';

  @override
  String get exploreSortPopular => 'По популярности';

  @override
  String get exploreSortRating => 'По рейтингу';

  @override
  String get exploreSortPriceLow => 'Сначала дешевле';

  @override
  String get exploreSortPriceHigh => 'Сначала дороже';

  @override
  String get explorePriceFree => 'Бесплатно';

  @override
  String get exploreLevelBeginner => 'Начальный';

  @override
  String get exploreLevelIntermediate => 'Средний';

  @override
  String get exploreLevelAdvanced => 'Продвинутый';

  @override
  String get learningTitle => 'Мое обучение';

  @override
  String get learningTabInProgress => 'В процессе';

  @override
  String get learningTabCompleted => 'Завершенные';

  @override
  String get learningTabSaved => 'Сохраненные';

  @override
  String get learningEmpty => 'Курсов пока нет';

  @override
  String get learningEmptyHint => 'Выберите интересные курсы в каталоге';

  @override
  String get learningExploreButton => 'Перейти в каталог';

  @override
  String learningProgress(int percent) {
    return '$percent% завершено';
  }

  @override
  String get learningContinue => 'Продолжить';

  @override
  String get learningViewCertificate => 'Сертификат';

  @override
  String get learningReview => 'Оценить курс';

  @override
  String get learningLesson => 'Урок';

  @override
  String get learningLessons => 'Уроки';

  @override
  String get cartTitle => 'Корзина';

  @override
  String get cartEmpty => 'Ваша корзина пуста';

  @override
  String get cartEmptyHint => 'Добавьте курсы для начала обучения';

  @override
  String get cartExploreButton => 'Перейти в каталог';

  @override
  String get cartPromoPlaceholder => 'Промокод';

  @override
  String get cartPromoApply => 'Применить';

  @override
  String get cartPromoInvalid => 'Неверный промокод';

  @override
  String get cartSummary => 'Детали заказа';

  @override
  String get cartSubtotal => 'Подытог';

  @override
  String get cartDiscount => 'Скидка';

  @override
  String get cartTotal => 'Итого';

  @override
  String get cartCheckout => 'Оформить заказ';

  @override
  String cartCourses(int count) {
    return '$count курсов';
  }

  @override
  String get cartRemove => 'Удалить';

  @override
  String get cartGuarantee => '30 дней гарантии возврата средств';

  @override
  String get checkoutTitle => 'Оплата';

  @override
  String get checkoutStepPayment => 'Оплата';

  @override
  String get checkoutStepReview => 'Проверка';

  @override
  String get checkoutStepConfirm => 'Подтверждение';

  @override
  String get checkoutOrderSummary => 'Детали заказа';

  @override
  String get checkoutTotal => 'Итого';

  @override
  String get checkoutPayNow => 'Оплатить сейчас';

  @override
  String get checkoutBack => 'Назад';

  @override
  String get checkoutNext => 'Далее';

  @override
  String get checkoutSecureSSL =>
      'Безопасная оплата с 256-битным SSL-шифрованием';

  @override
  String get checkoutSuccessTitle => 'Оплата прошла успешно!';

  @override
  String get checkoutSuccessSubtitle =>
      'Курс уже доступен в вашем личном кабинете';

  @override
  String get checkoutGoToLearning => 'К моим курсам';

  @override
  String get checkoutPaymentMethod => 'Способ оплаты';

  @override
  String get checkoutCardNumber => 'Номер карты';

  @override
  String get checkoutCardName => 'Имя на карте';

  @override
  String get checkoutCardExpiry => 'Срок действия';

  @override
  String get checkoutCardCVV => 'CVV';

  @override
  String get courseDetailsEnroll => 'Записаться на курс';

  @override
  String get courseDetailsBuyNow => 'Купить сейчас';

  @override
  String get courseDetailsAddToCart => 'В корзину';

  @override
  String get courseDetailsAddedToCart => 'Добавлено в корзину';

  @override
  String get courseDetailsAlreadyEnrolled => 'Вы уже записаны';

  @override
  String get courseDetailsGoToCourse => 'Перейти к урокам';

  @override
  String get courseDetailsFree => 'Бесплатно';

  @override
  String courseDetailsStudents(String count) {
    return '$count студентов';
  }

  @override
  String get courseDetailsRating => 'Рейтинг';

  @override
  String get courseDetailsReviews => 'отзывов';

  @override
  String get courseDetailsLastUpdated => 'Обновлено';

  @override
  String get courseDetailsCurriculum => 'Программа курса';

  @override
  String get courseDetailsSection => 'раздел';

  @override
  String get courseDetailsLessons => 'уроков';

  @override
  String get courseDetailsInstructor => 'Преподаватель';

  @override
  String get courseDetailsStudentsLabel => 'Студенты';

  @override
  String get courseDetailsCoursesLabel => 'Курсы';

  @override
  String get courseDetailsReviewsLabel => 'Отзывы';

  @override
  String get courseDetailsReviewsTitle => 'Отзывы студентов';

  @override
  String get courseDetailsWhatLearn => 'Чему вы научитесь';

  @override
  String get courseDetailsRequirements => 'Требования';

  @override
  String get courseDetailsDescription => 'Описание курса';

  @override
  String get courseDetailsIncludesTitle => 'В курс входит';

  @override
  String get courseDetailsHoursVideo => 'часов видео';

  @override
  String get courseDetailsArticles => 'статей';

  @override
  String get courseDetailsMobileAccess => 'Доступ с мобильных устройств';

  @override
  String get courseDetailsCertificate => 'Сертификат об окончании';

  @override
  String get courseDetailsLifetimeAccess => 'Бессрочный доступ';

  @override
  String get lessonPlayerNotes => 'Заметки';

  @override
  String get lessonPlayerResources => 'Материалы';

  @override
  String get lessonPlayerDiscussion => 'Обсуждение';

  @override
  String get lessonPlayerPrev => 'Предыдущий';

  @override
  String get lessonPlayerNext => 'Следующий';

  @override
  String get lessonPlayerSpeed => 'Скорость';

  @override
  String get lessonPlayerQuality => 'Качество';

  @override
  String get lessonPlayerCompleted => 'Урок пройден';

  @override
  String get certificateTitle => 'Сертификат об окончании';

  @override
  String get certificatePresentedTo => 'Выдан';

  @override
  String get certificateCompletedCourse => 'за успешное прохождение курса';

  @override
  String get certificateIssuedOn => 'Дата выдачи';

  @override
  String get certificateVerificationId => 'Номер сертификата';

  @override
  String get certificateDownloadPDF => 'Скачать PDF';

  @override
  String get certificateDownloadPNG => 'Скачать изображение';

  @override
  String get certificateCopyLink => 'Скопировать ссылку';

  @override
  String get certificateLinkCopied => 'Ссылка скопирована';

  @override
  String get profileTitle => 'Профиль';

  @override
  String get profileEditProfile => 'Редактировать профиль';

  @override
  String get profileCourses => 'Мои курсы';

  @override
  String get profileCertificates => 'Сертификаты';

  @override
  String get profilePoints => 'Баллы';

  @override
  String get profileFollowers => 'Подписчики';

  @override
  String get profileFollowing => 'Подписки';

  @override
  String get profileBio => 'О себе';

  @override
  String get profileInstructor => 'Преподаватель';

  @override
  String get profileStudent => 'Студент';

  @override
  String get profileLevel => 'Уровень';

  @override
  String get profileJoined => 'С нами с';

  @override
  String get profileShareProfile => 'Поделиться профилем';

  @override
  String get profileMenuLearning => 'Мои курсы';

  @override
  String get profileMenuCertificates => 'Мои сертификаты';

  @override
  String get profileMenuPurchaseHistory => 'История покупок';

  @override
  String get profileMenuTeachApplication => 'Преподавать на EduLab';

  @override
  String get profileMenuAccountSecurity => 'Безопасность аккаунта';

  @override
  String get profileMenuNotifications => 'Уведомления';

  @override
  String get profileMenuMessages => 'Сообщения';

  @override
  String get profileMenuSettings => 'Настройки';

  @override
  String get profileMenuSchedule => 'Мое расписание';

  @override
  String get profileMenuAssignments => 'Задания';

  @override
  String get profileMenuQuiz => 'Тесты';

  @override
  String get profileMenuLogout => 'Выйти';

  @override
  String get profileLogoutConfirm => 'Вы уверены, что хотите выйти?';

  @override
  String get profileLogoutYes => 'Да, выйти';

  @override
  String get profileLogoutNo => 'Отмена';

  @override
  String get editProfileTitle => 'Редактирование профиля';

  @override
  String get editProfileSave => 'Сохранить';

  @override
  String get editProfileFullName => 'Полное имя';

  @override
  String get editProfileBio => 'О себе';

  @override
  String get editProfileEmail => 'Электронная почта';

  @override
  String get editProfilePhone => 'Номер телефона';

  @override
  String get editProfileWebsite => 'Веб-сайт';

  @override
  String get editProfileSaved => 'Изменения успешно сохранены';

  @override
  String get accountSecurityTitle => 'Безопасность';

  @override
  String get accountSecurityChangePassword => 'Сменить пароль';

  @override
  String get accountSecurityTwoFactor => 'Двухфакторная аутентификация';

  @override
  String get accountSecurityActiveSessions => 'Активные сеансы';

  @override
  String get accountSecurityDeleteAccount => 'Удалить аккаунт';

  @override
  String get purchaseHistoryTitle => 'История покупок';

  @override
  String get purchaseHistoryEmpty => 'Покупок пока нет';

  @override
  String get purchaseHistoryGuarantee => '30-дневная гарантия возврата денег';

  @override
  String get purchaseHistoryDate => 'Дата транзакции';

  @override
  String get purchaseHistoryStatus => 'Статус';

  @override
  String get purchaseHistoryAmount => 'Сумма';

  @override
  String get purchaseHistoryCompleted => 'Оплачено';

  @override
  String get purchaseHistoryRefunded => 'Возврат';

  @override
  String get teachApplicationTitle => 'Преподавать на EduLab';

  @override
  String get teachApplicationSubmit => 'Отправить заявку';

  @override
  String get teachApplicationSent => 'Заявка успешно отправлена';

  @override
  String get notificationsTitle => 'Уведомления';

  @override
  String get notificationsMarkAllRead => 'Прочитать все';

  @override
  String get notificationsMarkAllReadSnackbar =>
      'Все уведомления отмечены как прочитанные';

  @override
  String get notificationsEmpty => 'Нет уведомлений';

  @override
  String get notification1Title => 'Напоминание: продолжите курс';

  @override
  String get notification1Message =>
      'Вас ждет новый урок в курсе Flutter для начинающих';

  @override
  String get notification1Time => '5 минут назад';

  @override
  String get notification1Action => 'Продолжить курс';

  @override
  String get notification2Title => 'Ваш сертификат готов!';

  @override
  String get notification2Message => 'Вы успешно завершили курс UI/UX дизайна.';

  @override
  String get notification2Time => '2 часа назад';

  @override
  String get notification2Action => 'Смотреть сертификат';

  @override
  String get notification3Title => 'Эксклюзивное предложение';

  @override
  String get notification3Message => 'Скидка 70% на курсы программирования';

  @override
  String get notification3Time => '1 день назад';

  @override
  String get notification3Action => 'Посмотреть';

  @override
  String get notification4Title => 'Новый ответ на ваш вопрос';

  @override
  String get notification4Message =>
      'Преподаватель ответил на ваш вопрос к уроку';

  @override
  String get notification4Time => '2 дня назад';

  @override
  String get notification4Action => 'Смотреть ответ';

  @override
  String get notification5Title => 'Обновление курса';

  @override
  String get notification5Message => 'Добавлены новые материалы в курс Python';

  @override
  String get notification5Time => '3 дня назад';

  @override
  String get messagesTitle => 'Сообщения';

  @override
  String get settingsTitle => 'Настройки приложения';

  @override
  String get settingsVideoDownload => 'Видео и загрузки';

  @override
  String get settingsDownloadQuality => 'Качество видео по умолчанию';

  @override
  String get settingsWifiOnly => 'Скачивать только по Wi-Fi';

  @override
  String get settingsNotifications => 'Уведомления и звуки';

  @override
  String get settingsCourseNotifications => 'Уведомления о курсах и сообщениях';

  @override
  String get settingsPromoNotifications => 'Скидки и специальные акции';

  @override
  String get settingsAppearance => 'Внешний вид и язык';

  @override
  String get settingsDarkMode => 'Темная тема';

  @override
  String get settingsDarkModeEnabled => 'Включена (экономит заряд батареи)';

  @override
  String get settingsDarkModeDisabled => 'Выключена (светлая тема)';

  @override
  String get settingsLanguage => 'Язык интерфейса';

  @override
  String get settingsStorage => 'Память и кэш';

  @override
  String get settingsClearCache => 'Очистить кэш';

  @override
  String get settingsClearCacheSuccess => 'Кэш успешно очищен';

  @override
  String get settingsHelp => 'Информация и правила';

  @override
  String get settingsHelpCenter => 'Центр помощи и FAQ';

  @override
  String get settingsTermsPrivacy => 'Условия и конфиденциальность';

  @override
  String get settingsAbout => 'О проекте EduLab';

  @override
  String get settingsVersion => 'Версия v1.0.0';

  @override
  String get quizTitle => 'Тестирование';

  @override
  String get quizNext => 'Следующий вопрос';

  @override
  String get quizSubmit => 'Завершить тест';

  @override
  String get quizScore => 'Результат';

  @override
  String get quizCorrectAnswers => 'Правильных ответов';

  @override
  String get scheduleTitle => 'Мое расписание';

  @override
  String get scheduleEmpty => 'Занятий не запланировано';

  @override
  String get scheduleJoin => 'Присоединиться';

  @override
  String get scheduleReminder => 'Напомнить';

  @override
  String get assignmentsTitle => 'Домашние задания';

  @override
  String get assignmentsEmpty => 'Заданий пока нет';

  @override
  String get assignmentsSubmit => 'Сдать задание';

  @override
  String get assignmentsDue => 'Срок сдачи';

  @override
  String get assignmentsSubmitted => 'Сдано';

  @override
  String get assignmentsPending => 'На проверке';

  @override
  String get languageArabic => 'Арабский';

  @override
  String get languageEnglish => 'Английский';

  @override
  String get languageDialogTitle => 'Выбор языка';

  @override
  String get languageSelect => 'Выбрать';

  @override
  String get generalCancel => 'Отмена';

  @override
  String get generalConfirm => 'Подтвердить';

  @override
  String get generalSave => 'Сохранить';

  @override
  String get generalDelete => 'Удалить';

  @override
  String get generalEdit => 'Редактировать';

  @override
  String get generalClose => 'Закрыть';

  @override
  String get generalBack => 'Назад';

  @override
  String get generalDone => 'Готово';

  @override
  String get generalOk => 'ОК';

  @override
  String get generalYes => 'Да';

  @override
  String get generalNo => 'Нет';

  @override
  String get generalLoading => 'Загрузка...';

  @override
  String get generalError => 'Произошла ошибка';

  @override
  String get generalRetry => 'Повторить';

  @override
  String get generalNoInternet => 'Нет подключения к интернету';

  @override
  String get generalFree => 'Бесплатно';

  @override
  String get generalRating => 'Рейтинг';

  @override
  String get generalStudents => 'Студенты';

  @override
  String get generalHours => 'Часов';

  @override
  String get generalMinutes => 'Минут';

  @override
  String get generalBy => 'Автор';

  @override
  String get navHome => 'Главная';

  @override
  String get navExplore => 'Каталог';

  @override
  String get navMyCourses => 'Мои курсы';

  @override
  String get navCart => 'Корзина';

  @override
  String get navAccount => 'Профиль';

  @override
  String get homeSubGreeting => 'Что вы хотите изучить сегодня?';

  @override
  String get homeVisitor => 'Гость';

  @override
  String get homePromoTitle => 'Специальные предложения';

  @override
  String get homePromoSubtitle => 'Скидки до 70% на популярные курсы';

  @override
  String get homePromoButton => 'Узнать больше';

  @override
  String get homePromoBadge => 'Эксклюзив';

  @override
  String get homeContinueLearning => 'Продолжить обучение';

  @override
  String get homeMyCoursesLink => 'Мои курсы';

  @override
  String get homeLesson => 'урок';

  @override
  String homeStudentsCount(String count) {
    return '$count студентов';
  }

  @override
  String get homeRecommendedTitle => 'Рекомендовано вам';

  @override
  String get homeRecommendedSubtitle => 'Подобрано на основе ваших интересов';

  @override
  String get homeBestsellersTitle => 'Хиты продаж';

  @override
  String get homeBestsellersSubtitle =>
      'Самые популярные курсы с высоким рейтингом';

  @override
  String get homeNewCoursesTitle => 'Новые курсы';

  @override
  String get homeNewCoursesSubtitle => 'Свежие и актуальные материалы';

  @override
  String get homePopularTopicsTitle => 'Популярные темы';

  @override
  String get homePopularTopicsSubtitle =>
      'Изучайте самые востребованные навыки';

  @override
  String get homeTopInstructorsTitle => 'Лучшие преподаватели';

  @override
  String get homeTopInstructorsSubtitle =>
      'Обучайтесь у сертифицированных экспертов';

  @override
  String get homeExploreCategoriesTitle => 'Категории курсов';

  @override
  String get homeExploreCategoriesSubtitle => 'Найдите подходящий курс';

  @override
  String get catAll => 'Все';

  @override
  String get catWebDev => 'Веб-разработка';

  @override
  String get catMobileApps => 'Мобильные приложения';

  @override
  String get catDataScience => 'Наука о данных';

  @override
  String get catUIUX => 'UI/UX Дизайн';

  @override
  String get catBusiness => 'Бизнес и управление';

  @override
  String get catAI => 'Искусственный интеллект';

  @override
  String get catCyberSecurity => 'Кибербезопасность';

  @override
  String get exploreNoResultsTitle => 'Ничего не найдено';

  @override
  String get exploreNoResultsSubtitle =>
      'Попробуйте изменить запрос или параметры фильтра';

  @override
  String get exploreRecentSearches => 'Недавние поиски';

  @override
  String get exploreTopSearches => 'Популярные запросы';

  @override
  String get exploreBrowseCategories => 'Категории';

  @override
  String get exploreBrowseCategoriesSubtitle => 'Найдите подходящий курс';

  @override
  String get exploreBackToAll => 'Ко всем курсам';

  @override
  String get exploreClearAll => 'Очистить все';

  @override
  String get exploreAvailableResults => 'найдено курсов';

  @override
  String get exploreFilterBestseller => 'Бестселлер';

  @override
  String get exploreFilterTopRated => 'Высокий рейтинг';

  @override
  String get exploreFilterUnder50 => 'До \$50';

  @override
  String get learningHeroTitle => 'Продолжайте путь к знаниям';

  @override
  String get learningSearchHint => 'Поиск среди моих курсов...';

  @override
  String get learningFilterAll => 'Все';

  @override
  String get learningFilterInProgress => 'В процессе';

  @override
  String get learningFilterCompleted => 'Завершенные';

  @override
  String get learningFilterDownloaded => 'Скачанные';

  @override
  String get learningEmptyTitle => 'Курсов пока нет';

  @override
  String get learningEmptySubtitle => 'Выберите интересные курсы в каталоге';

  @override
  String get learningEmptySearch => 'Ничего не найдено';

  @override
  String get learningCompleted => 'Завершено';

  @override
  String get learningCompletedBadge => 'Завершено';

  @override
  String learningLecturesCount(int count) {
    return '$count лекций';
  }

  @override
  String get cartEmptyTitle => 'Ваша корзина пуста';

  @override
  String get cartEmptySubtitle => 'Добавьте курсы для начала обучения';

  @override
  String get cartCouponHint => 'Введите промокод';

  @override
  String get cartCouponApply => 'Применить';

  @override
  String get cartCouponInvalid => 'Недействительный промокод';

  @override
  String get cartCouponApplied => 'Промокод применен';

  @override
  String get cartCouponDiscount => 'Скидка по промокоду';

  @override
  String get cartCouponsTitle => 'Промокоды';

  @override
  String get cartOrderSummary => 'Детали заказа';

  @override
  String get cartOriginalPrice => 'Первоначальная цена';

  @override
  String get cartPlatformDiscount => 'Скидка платформы';

  @override
  String get cartFinalTotal => 'Итого к оплате';

  @override
  String cartItemsCount(int count) {
    return '$count курсов';
  }

  @override
  String get cartRemovedSnackbar => 'Курс удален из корзины';

  @override
  String get cartUndo => 'Отменить';

  @override
  String get cartAddButton => 'В корзину';

  @override
  String get cartAddedSnackbar => 'Добавлено в корзину';

  @override
  String get cartAlreadyInCart => 'Уже в корзине';

  @override
  String get cartCheckoutButton => 'Перейти к оформлению';

  @override
  String get cartRecommendedTitle => 'Вам может понравиться';

  @override
  String get cartRecommendedSubtitle =>
      'Курсы, подобранные на основе вашей корзины';

  @override
  String get checkoutCreditCard => 'Банковская карта';

  @override
  String get checkoutSelectPayment => 'Выберите способ оплаты';

  @override
  String get checkoutCardNumberLabel => 'Номер карты';

  @override
  String get checkoutCardHolderLabel => 'Владелец карты';

  @override
  String get checkoutExpiryLabel => 'Срок действия';

  @override
  String get checkoutCVVLabel => 'CVV';

  @override
  String get checkoutPersonalInfoTitle => 'Личные данные';

  @override
  String get checkoutFullNameLabel => 'Полное имя';

  @override
  String get checkoutFullNameHint => 'Ваше полное имя';

  @override
  String get checkoutFullNameRequired => 'Введите полное имя';

  @override
  String get checkoutPhoneLabel => 'Номер телефона';

  @override
  String get checkoutPhoneRequired => 'Введите номер телефона';

  @override
  String get checkoutPostalLabel => 'Почтовый индекс';

  @override
  String get checkoutPostalRequired => 'Введите почтовый индекс';

  @override
  String get checkoutBuyerInfo => 'Данные покупателя';

  @override
  String get checkoutSaveInfo => 'Сохранить данные для будущих покупок';

  @override
  String get checkoutMoneyBackGuarantee => '30-дневная гарантия возврата денег';

  @override
  String get checkoutContinueToPayment => 'Перейти к оплате';

  @override
  String get checkoutContinueToReview => 'Перейти к проверке';

  @override
  String get checkoutReviewConfirm => 'Проверить и подтвердить';

  @override
  String get checkoutStartLearning => 'Начать обучение';

  @override
  String get checkoutBackHome => 'На главную';

  @override
  String get courseDetailsTitle => 'О курсе';

  @override
  String get courseDetailsShare => 'Поделиться';

  @override
  String get courseDetailsWhatYouWillLearn => 'Чему вы научитесь';

  @override
  String get courseDetailsLanguage => 'Язык';

  @override
  String get courseDetailsCreatedBy => 'Автор курса';

  @override
  String get courseDetailsPreviewLesson => 'Пробный урок';

  @override
  String get courseDetailsHoursOnDemand => 'часов видео по запросу';

  @override
  String get courseDetailsFullLifetimeAccess => 'Полный бессрочный доступ';

  @override
  String get courseDetailsCertifiedCertificate =>
      'Сертифицированный диплом об окончании';

  @override
  String get courseDetailsComprehensiveContent => 'Полный объем материалов';

  @override
  String get certTitle => 'Сертификат об окончании';

  @override
  String get certStudentNameLabel => 'Студент';

  @override
  String get certCourseLabel => 'Курс';

  @override
  String get certInstructorLabel => 'Преподаватель';

  @override
  String get certIssueDateLabel => 'Дата выдачи';

  @override
  String get certCodeLabel => 'ID сертификата';

  @override
  String get certVerifiedBadge => 'Подтвержден';

  @override
  String get certDownloadPDF => 'Скачать PDF';

  @override
  String get certDownloadPNG => 'Скачать изображение';

  @override
  String get certCopyVerifyLink => 'Скопировать ссылку на проверку';

  @override
  String get certShare => 'Поделиться сертификатом';

  @override
  String get playerTabLessons => 'Уроки';

  @override
  String get playerTabOverview => 'Обзор';

  @override
  String get playerTabNotes => 'Заметки';

  @override
  String get playerTabQnA => 'Вопросы и ответы';

  @override
  String get playerNextLesson => 'Следующий урок';

  @override
  String get profileWelcome => 'Добро пожаловать';

  @override
  String get profileLoginPrompt => 'Войдите, чтобы просмотреть профиль';

  @override
  String get profileLoginOrRegister => 'Войти / Зарегистрироваться';

  @override
  String get profileVerifiedStudent => 'Подтвержденный студент';

  @override
  String get profileLogout => 'Выйти';

  @override
  String get profileCancel => 'Отмена';

  @override
  String get profileLogoutConfirmTitle => 'Выход из аккаунта';

  @override
  String get profileLogoutConfirmMessage =>
      'Вы уверены, что хотите выйти из аккаунта?';

  @override
  String get profileAccountSettings => 'Настройки аккаунта';

  @override
  String get profileEditProfileSubtitle => 'Изменить личные данные';

  @override
  String get profileSecurity => 'Безопасность';

  @override
  String get profileSecuritySubtitle => 'Пароль и двухфакторная защита';

  @override
  String get profilePurchaseHistory => 'История покупок';

  @override
  String get profilePurchaseHistorySubtitle => 'Просмотр платежей и чеков';

  @override
  String get profileCertificatesSubtitle => 'Ваши полученные сертификаты';

  @override
  String get profileTeach => 'Преподавать на EduLab';

  @override
  String get profileTeachSubtitle => 'Делитесь знаниями и зарабатывайте';

  @override
  String get profilePreferences => 'Параметры';

  @override
  String get profilePreferencesSubtitle => 'Оформление и язык';

  @override
  String get profileNotifications => 'Уведомления';

  @override
  String get profileNotificationsSubtitle => 'Настройка оповещений';

  @override
  String get profileHelpSupport => 'Справка и поддержка';

  @override
  String get profileTerms => 'Условия использования';

  @override
  String get profilePrivacy => 'Политика конфиденциальности';

  @override
  String get profileAboutEduLab => 'О платформе EduLab';

  @override
  String get profileWishlist => 'Список желаний';

  @override
  String get securityTitle => 'Безопасность аккаунта';

  @override
  String get teachTitle => 'Преподавать на EduLab';

  @override
  String get notificationsTabAll => 'Все';

  @override
  String get notificationsTabCourses => 'Курсы';

  @override
  String get notificationsTabPromos => 'Акции';

  @override
  String get notificationsEmptyTitle => 'Нет уведомлений';

  @override
  String get notificationsUnread => 'Новые';

  @override
  String get wishlistTitle => 'Список желаний';

  @override
  String get wishlistEmptyTitle => 'Список желаний пуст';

  @override
  String get wishlistEmptySubtitle => 'Сохраняйте интересные курсы';

  @override
  String get wishlistAddToCart => 'В корзину';

  @override
  String get wishlistRemovedSnackbar => 'Удалено из списка желаний';

  @override
  String get homeDefaultUser => 'Студент';

  @override
  String get learningOf => 'из';

  @override
  String get cartInCartBadge => 'В корзине';

  @override
  String get homePromo1Badge => 'Большая распродажа • Ограничено';

  @override
  String get homePromo1Title => 'Начните обучение по лучшим ценам';

  @override
  String get homePromo1Subtitle =>
      'Скидки до 65% на курсы программирования, дизайна и бизнеса.';

  @override
  String get homePromo1Button => 'Смотреть скидки';

  @override
  String get homePromo2Badge => 'Сертифицированные программы';

  @override
  String get homePromo2Title => 'Подготовьтесь к работе мечты';

  @override
  String get homePromo2Subtitle =>
      'Курсы от нуля до профи с практическими проектами и сертификатами.';

  @override
  String get homePromo2Button => 'Все программы';

  @override
  String get homePromo3Badge => 'Лучшие преподаватели и эксперты';

  @override
  String get homePromo3Title => 'Учитесь напрямую у ведущих специалистов';

  @override
  String get homePromo3Subtitle =>
      'Постоянно обновляемый контент по новейшим технологиям.';

  @override
  String get homePromo3Button => 'Начать сейчас';

  @override
  String get homePromoInstructorBadge =>
      'Преподавайте на EduLab • Делитесь знаниями';

  @override
  String get homePromoInstructorTitle => 'Станьте преподавателем сегодня';

  @override
  String get homePromoInstructorSubtitle =>
      'Вдохновляйте студентов по всему миру, создавайте курсы и зарабатывайте, обучая любимому делу.';

  @override
  String get homePromoInstructorButton => 'Подать заявку';

  @override
  String get homeSearchFilter => 'Фильтр';

  @override
  String get securitySectionChangePassword => 'Изменить пароль';

  @override
  String get securityCurrentPasswordLabel => 'Текущий пароль *';

  @override
  String get securityCurrentPasswordError => 'Введите текущий пароль';

  @override
  String get securityNewPasswordLabel => 'Новый пароль *';

  @override
  String get securityNewPasswordError => 'Должен содержать не менее 8 символов';

  @override
  String get securityConfirmPasswordLabel => 'Подтвердите новый пароль *';

  @override
  String get securityConfirmPasswordError => 'Пароли не совпадают';

  @override
  String get securityUpdatePasswordBtn => 'Обновить пароль';

  @override
  String get securityPasswordUpdatedSuccess => 'Пароль успешно изменен!';

  @override
  String get securitySection2FA => 'Двухфакторная аутентификация (2FA)';

  @override
  String get security2FATitle => 'Двухфакторная аутентификация';

  @override
  String get security2FAEnabledDesc => 'Включено - Защищает аккаунт кодом';

  @override
  String get security2FADisabledDesc => 'Отключено (Рекомендуется)';

  @override
  String get security2FASetupTitle => 'Включить двухфакторную аутентификацию';

  @override
  String get security2FASetupContent =>
      'При каждом новом входе на вашу почту будет отправляться 6-значный проверочный код.';

  @override
  String get security2FAEnableNow => 'Включить сейчас';

  @override
  String get security2FAEnabledSuccess =>
      'Двухфакторная аутентификация успешно включена!';

  @override
  String get security2FADisabledSuccess =>
      'Двухфакторная аутентификация отключена';

  @override
  String get securitySectionSessions => 'Активные сессии и устройства';

  @override
  String get securityLogoutAllDevices => 'Выйти со всех устройств';

  @override
  String get securityThisDevice => 'Это устройство';

  @override
  String get securitySessionRevokedSuccess =>
      'Сессия завершена, выполнен выход с устройства.';

  @override
  String get securityAllSessionsRevokedSuccess =>
      'Выполнен выход со всех остальных устройств.';

  @override
  String get purchaseHistoryInvoiceCertified =>
      'Сертифицированный электронный счет';

  @override
  String get purchaseHistoryInvoiceNumber => 'Номер счета';

  @override
  String get purchaseHistoryCourse => 'Курс';

  @override
  String get purchaseHistoryPaymentMethod => 'Способ оплаты';

  @override
  String get purchaseHistoryTotalAmount => 'Итоговая сумма:';

  @override
  String get purchaseHistoryClose => 'Закрыть';

  @override
  String get purchaseHistoryDownloadPdf => 'Скачать PDF';

  @override
  String get purchaseHistoryPdfDownloaded => 'PDF счета успешно загружен';

  @override
  String get purchaseHistoryRefundRequestTitle => 'Запрос на возврат средств';

  @override
  String get purchaseHistoryRefundPolicy =>
      'В соответствии с 30-дневной гарантией EduLab вы можете получить полный возврат средств.';

  @override
  String get purchaseHistoryRefundReasonHint =>
      'Причина возврата (необязательно)...';

  @override
  String get purchaseHistoryConfirmRefund => 'Подтвердить возврат';

  @override
  String get purchaseHistoryRefundSubmitted =>
      'Запрос на возврат отправлен (3-5 рабочих дней).';

  @override
  String get purchaseHistoryInstructor => 'Преподаватель';

  @override
  String get purchaseHistoryRequestRefundBtn => 'Запросить возврат';

  @override
  String get purchaseHistoryInvoiceBtn => 'Счет';

  @override
  String get purchaseHistoryStatusCompleted => 'Завершено';

  @override
  String get purchaseHistoryStatusRefunded => 'Возвращено';

  @override
  String get purchaseHistoryStatusProcessingRefund => 'Обработка возврата';

  @override
  String get editProfileSectionBasicInfo => 'Основная информация';

  @override
  String get editProfileFullNameLabel => 'Полное имя *';

  @override
  String get editProfileFullNameHint => 'Введите ваше полное имя';

  @override
  String get editProfileFullNameError => 'Пожалуйста, укажите полное имя';

  @override
  String get editProfileHeadlineLabel => 'Профессиональный заголовок';

  @override
  String get editProfileHeadlineHint => 'например, Senior Flutter разработчик';

  @override
  String get editProfileLocationLabel => 'Город / Страна';

  @override
  String get editProfileLocationHint => 'Москва, Россия';

  @override
  String get editProfilePhoneLabel => 'Номер телефона';

  @override
  String get editProfileBioLabel => 'О себе (Био)';

  @override
  String get editProfileBioHint =>
      'Напишите краткую информацию о ваших интересах и опыте...';

  @override
  String get editProfileSectionLinks => 'Ссылки и соцсети';

  @override
  String get editProfileWebsiteLabel => 'Личный веб-сайт';

  @override
  String get editProfileSectionEmail => 'Зарегистрированный e-mail';

  @override
  String get editProfileEmailDesc =>
      'Привязан к аккаунту для входа и получения сертификатов';

  @override
  String get editProfileEmailVerified => 'Подтвержден';

  @override
  String get editProfileSaveChangesBtn => 'Сохранить изменения';

  @override
  String get editProfileSavedSuccess => 'Профиль успешно обновлен!';

  @override
  String get editProfileChangeAvatarTitle => 'Изменить фото профиля';

  @override
  String get editProfileTakePhoto => 'Сделать снимок';

  @override
  String get editProfileChooseGallery => 'Выбрать из галереи';

  @override
  String get editProfilePhotoUpdatedSuccess => 'Фото профиля успешно обновлено';

  @override
  String get teachJoinInstructorTitle => 'Станьте преподавателем';

  @override
  String get teachJoinInstructorSubtitle =>
      'Публикуйте курсы и делитесь знаниями с тысячами студентов.';

  @override
  String get teachStep1Title => 'Личные данные';

  @override
  String get teachStep2Title => 'Опыт и навыки';

  @override
  String get teachStep3Title => 'Подтверждение';

  @override
  String get teachStep1Header => '1. Личная и профессиональная информация';

  @override
  String get teachFullNameArabicLabel => 'Полное имя *';

  @override
  String get teachFullNameArabicHint => 'например, Иван Иванов';

  @override
  String get teachHeadlineLabel => 'Должность и специализация *';

  @override
  String get teachHeadlineHint =>
      'например, Senior Software Architect & Flutter Trainer';

  @override
  String get teachPhoneLabel => 'Контактный телефон *';

  @override
  String get teachCountryLabel => 'Страна проживания *';

  @override
  String get teachBioLabel => 'О себе и опыт работы *';

  @override
  String get teachBioHint =>
      'Напишите кратко о вашей карьере и прошлых проектах...';

  @override
  String get teachNextStepSkills => 'Далее: Опыт и навыки';

  @override
  String get teachStep2Header => '2. Содержание курса и навыки';

  @override
  String get teachTopicLabel => 'Тема или направление курса *';

  @override
  String get teachTopicHint => 'например, Разработка на Flutter с нуля';

  @override
  String get teachYearsExperienceLabel => 'Лет опыта в сфере *';

  @override
  String get teachVideoLinkLabel =>
      'Ссылка на пробное видео (YouTube/Drive/Loom) *';

  @override
  String get teachTargetAudienceLabel => 'Целевая аудитория курса *';

  @override
  String get teachAudienceBeginners => 'Новички';

  @override
  String get teachAudienceIntermediate => 'Начинающие и продолжающие';

  @override
  String get teachAudienceAdvanced => 'Продвинутые и профессионалы';

  @override
  String get teachAudienceAll => 'Все уровни';

  @override
  String get teachSkillsCoveredLabel => 'Навыки и технологии в курсе *';

  @override
  String get teachAddSkillHint => 'Добавить навык (напр. GraphQL)...';

  @override
  String get teachAddSkillBtn => 'Добавить';

  @override
  String get teachNextStepConfirm => 'Далее: Подтверждение заявки';

  @override
  String get teachStep3Header => '3. Выплаты и условия';

  @override
  String get teachPayoutMethodLabel => 'Способ получения выплат *';

  @override
  String get teachPayoutMethodBank => 'Банковский перевод (IBAN)';

  @override
  String get teachPayoutMethodPaypal => 'Подтвержденный аккаунт PayPal';

  @override
  String get teachPayoutMethodPayoneer => 'Карта Payoneer';

  @override
  String get teachIbanDetailsLabel => 'Реквизиты счета / IBAN *';

  @override
  String get teachApplicationSummary => 'Сводка заявки:';

  @override
  String get teachApplicantName => 'Заявитель';

  @override
  String get teachApplicantHeadline => 'Специальность';

  @override
  String get teachApplicantTopic => 'Тема курса';

  @override
  String get teachApplicantSkillsCount => 'Количество навыков';

  @override
  String get teachSkillsUnit => 'навыков';

  @override
  String get teachAgreeTermsLabel =>
      'Я согласен с условиями для преподавателей и соглашением об интеллектуальной собственности EduLab.';

  @override
  String get teachSubmitApplicationBtn => 'Submit Instructor Application';

  @override
  String get teachPrevStepBtn => 'Назад';

  @override
  String get teachWhyEduLabTitle => 'Почему стоит преподавать в EduLab?';

  @override
  String get teachProp1Title => 'Справедливый и высокий доход';

  @override
  String get teachProp1Desc =>
      'Получайте до 80% от продаж курсов без скрытых комиссий.';

  @override
  String get teachProp2Title => 'Доступ к тысячам студентов';

  @override
  String get teachProp2Desc =>
      'Продвигайте свой курс среди огромного сообщества студентов.';

  @override
  String get teachProp3Title => 'Полная техническая и продакшн-поддержка';

  @override
  String get teachProp3Desc =>
      'Наша команда поможет улучшить качество звука, видео и структуру курса.';

  @override
  String get teachSuccessDialogTitle => 'Заявка успешно принята!';

  @override
  String get teachSuccessDialogDesc =>
      'Спасибо за интерес к EduLab. Наша команда рассмотрит заявку и свяжется с вами в течение 48 часов.';

  @override
  String get teachSuccessDialogOk => 'Понятно';

  @override
  String get teachAddOneSkillError => 'Пожалуйста, добавьте хотя бы один навык';

  @override
  String get teachAgreeTermsError =>
      'Пожалуйста, подтвердите согласие с условиями';

  @override
  String get commonCancel => 'Отмена';

  @override
  String get commonClose => 'Закрыть';

  @override
  String get myCertificatesBannerTitle => 'Аккредитованные сертификаты';

  @override
  String get myCertificatesBannerSubtitle =>
      'Все сертификаты аккредитованы и проверены с уникальным идентификатором EduLab';

  @override
  String get certBadgeVerified100 => '100% Аккредитовано';

  @override
  String get certCodeCopied => 'Код сертификата скопирован';

  @override
  String get certGrantedTo => 'Выдано';

  @override
  String get certViewAndDownload => 'Просмотреть и скачать сертификат';

  @override
  String get certIssuerLabel => 'Орган выдачи';

  @override
  String get certIssuerName => 'Академия интерактивного обучения EduLab';

  @override
  String get certEmptyTitle => 'Сертификаты пока не получены';

  @override
  String get certEmptyDesc =>
      'Завершите 100% любого курса, чтобы получить аккредитованный сертификат с официальным идентификатором проверки.';

  @override
  String get certEmptyAction => 'Продолжить мои курсы';

  @override
  String get certDetailsTitle => 'Детали и информация о сертификате';

  @override
  String get certCopyLinkSuccess =>
      'Прямая ссылка для проверки скопирована в буфер обмена!';

  @override
  String get certShareSuccess =>
      'Сведения о сертификате и ссылка скопированы для публикации!';

  @override
  String get purchaseHistoryTaxInvoiceCertified =>
      'Официальный сертифицированный налоговый счет';

  @override
  String get purchaseHistoryInvoiceNumberLabel => 'Номер заказа / счета';

  @override
  String get purchaseHistoryCourseNameLabel => 'Название курса';

  @override
  String get purchaseHistoryPurchaseDateLabel => 'Дата покупки';

  @override
  String get purchaseHistoryPaymentMethodLabel => 'Способ оплаты';

  @override
  String get purchaseHistoryPaymentMethodValue =>
      'Банковская карта / Stripe (Онлайн)';

  @override
  String get purchaseHistoryOrderStatusLabel => 'Статус заказа';

  @override
  String get purchaseHistoryStatusPendingReview => 'На рассмотрении возврата';

  @override
  String get purchaseHistoryCopyInvoiceBtn => 'Скопировать номер счета';

  @override
  String get purchaseHistoryRefundReasonLabel => 'Причина запроса на возврат:';

  @override
  String get purchaseHistoryRefundReasonEmptyError =>
      'Пожалуйста, укажите причину запроса на возврат';

  @override
  String get purchaseHistorySubmittingRefund => 'Отправка запроса...';

  @override
  String get purchaseHistoryPaidDate => 'Дата оплаты';

  @override
  String get purchaseHistoryEmptyTitle => 'История покупок пока пуста';

  @override
  String get purchaseHistoryEmptyDesc =>
      'Вы еще не приобрели ни одного курса.\nВаши заказы и счета появятся здесь после оформления.';

  @override
  String get purchaseHistoryExploreCourses => 'Смотреть курсы';

  @override
  String get profileMyCourses => 'Мои курсы';

  @override
  String get profileMyCoursesSubtitle => 'Отслеживать прогресс в курсах';

  @override
  String get profileWishlistSubtitle => 'Курсы, сохраненные в списке желаний';

  @override
  String get navMyLearning => 'Мое обучение';

  @override
  String get profileLogoutSafeNote =>
      'Ваши данные, курсы и сертификаты в полной безопасности. Вы сможете продолжить обучение в любой момент, выполнив вход снова.';

  @override
  String learningRemainingHours(String hours) {
    return 'Осталось $hours ч.';
  }

  @override
  String get learningCompletedFull => 'Завершено';

  @override
  String get learningFilterNotStarted => 'Не начато';

  @override
  String get wishlistTopRatedBadge => 'Лучшие отзывы';

  @override
  String get wishlistFeaturedBadge => 'Рекомендуемое';

  @override
  String wishlistDiscountBadge(String percent) {
    return 'Скидка $percent%';
  }

  @override
  String get courseFree => 'Бесплатно';

  @override
  String get badgeBestseller => 'Бестселлер';

  @override
  String get badgeTopRated => 'Лучшие отзывы';

  @override
  String get badgeFeatured => 'Рекомендуемое';

  @override
  String get badgeRecommended => 'Рекомендовано вам';

  @override
  String get badgeNew => 'Новое';

  @override
  String get courseWord => 'Курс';

  @override
  String coursesCountText(String count) {
    return '$count+ Курсов';
  }

  @override
  String studentsCountText(String count) {
    return '$count Студентов';
  }

  @override
  String hoursCountText(String count) {
    return '$count Ч.';
  }

  @override
  String get certifiedInstructor => 'Сертифицированный преподаватель';

  @override
  String get expertCertifiedInstructor =>
      'Эксперт и сертифицированный преподаватель';

  @override
  String get defaultCourseTitle => 'Обучающий курс';

  @override
  String get categoryWord => 'Категория';

  @override
  String get previewCourseVideo => 'Превью видео курса';

  @override
  String get freeSection => 'Бесплатный раздел';

  @override
  String get freeDemoVideo => 'Бесплатное демо-видео';

  @override
  String get articleLecture => 'Лекция-статья';

  @override
  String get articleViewer => 'Просмотр статей';

  @override
  String get courseVideoPlayer => 'Видеоплеер курса';

  @override
  String get playingNow => 'Сейчас воспроизводится';

  @override
  String get readingNow => 'Сейчас читается';

  @override
  String get noLecturesInFreeSection => 'В бесплатном разделе нет уроков';

  @override
  String freeLecturesCount(String count) {
    return '$count бесплатных уроков';
  }

  @override
  String get enrollInFullCourse => 'Записаться на полный курс';

  @override
  String get articleWord => 'Статья';

  @override
  String get videoWord => 'Видео';

  @override
  String get quizWord => 'Тест';

  @override
  String get courseShareCopied => 'Ссылка на курс скопирована в буфер обмена!';

  @override
  String get addedToCartSnackbar => 'Добавлено в корзину';

  @override
  String get viewCartAction => 'Перейти в корзину';

  @override
  String get inCartBadge => 'В корзине ✓';

  @override
  String get addToCartButton => 'В корзину';

  @override
  String get wishlistAddedSnackbar =>
      'Курс успешно добавлен в список желаемого';

  @override
  String get wishlistRemovedSuccessSnackbar =>
      'Курс удален из списка желаемого';

  @override
  String get lessonCompletedAll =>
      'Поздравляем! Вы завершили все уроки этого курса.';

  @override
  String get noteAddedSuccess => 'Заметка успешно сохранена';

  @override
  String get lessonAlreadyDownloaded =>
      'Урок уже сохранен для офлайн-просмотра';

  @override
  String get lessonLinkCopied => 'Ссылка на урок скопирована';

  @override
  String get contentReportThanks =>
      'Спасибо за отзыв! Наша команда проверит урок.';

  @override
  String get courseCompletionCertificate => 'Сертификат об окончании курса';

  @override
  String get reportContentIssue => 'Сообщить о проблеме с контентом';

  @override
  String get loginOrSocial => 'Или войти через';

  @override
  String get loginSuccessSnackbar => 'Успешный вход в систему';

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
  String get cartClearAllTitle => 'Очистить все товары в корзине?';

  @override
  String cartClearAllMessage(String count) {
    return 'Вы уверены, что хотите удалить все курсы $count из корзины покупок?';
  }

  @override
  String get cartClearAllHint =>
      'Все курсы будут удалены из вашей корзины. Вы можете добавить их обратно в любое время.';

  @override
  String cartClearAllConfirm(String count) {
    return 'Очистить все ($count)';
  }

  @override
  String get cartClearedSuccess => 'Корзина успешно очищена';

  @override
  String get cartClearFailed => 'Не удалось очистить корзину';

  @override
  String cartViewWishlistCount(String count) {
    return 'Посмотреть элементы списка желаний ($count)';
  }

  @override
  String get cartGoToWishlist => 'Перейти в список желаний';

  @override
  String get wishlistClearAllTitle => 'Очистить все элементы списка желаний?';

  @override
  String wishlistClearAllMessage(String count) {
    return 'Вы уверены, что хотите удалить все курсы $count из своего списка желаний?';
  }

  @override
  String get wishlistClearAllHint =>
      'Все сохраненные курсы будут удалены. Вы можете добавить их обратно в любое время из Explore.';

  @override
  String wishlistClearAllConfirm(String count) {
    return 'Очистить все ($count)';
  }

  @override
  String get wishlistClearedSuccess => 'Список желаний успешно очищен';

  @override
  String get wishlistClearFailed => 'Не удалось очистить список желаний.';

  @override
  String get wishlistClearTooltip => 'Очистить все';

  @override
  String wishlistViewCartCount(String count) {
    return 'Просмотреть товары корзины ($count)';
  }

  @override
  String get wishlistGoToCart => 'Перейти в корзину';

  @override
  String get checkoutCardNumberInvalid =>
      'Пожалуйста, введите действительный 16-значный номер карты.';

  @override
  String get checkoutCardExpiryInvalidFormat =>
      'Пожалуйста, введите действительную дату истечения срока действия карты (ММ / ГГ)';

  @override
  String get checkoutCardExpiredDate => 'Срок действия карты недействителен.';

  @override
  String get checkoutCardCvcInvalid =>
      'Пожалуйста, введите действительный 3- или 4-значный CVC-код.';

  @override
  String get checkoutCardHolderNameRequired =>
      'Пожалуйста, введите имя владельца карты';

  @override
  String get checkoutCartEmptySnackbar => 'Корзина пуста';

  @override
  String get checkoutPaymentStartFailed => 'Не удалось инициировать платеж';

  @override
  String get checkoutClientSecretMissing =>
      'Ключ безопасности не был получен от платежного шлюза';

  @override
  String get checkoutCardVerificationFailed => 'Проверка карты не удалась';

  @override
  String get checkoutStripeProcessingFailed =>
      'Не удалось обработать платеж Stripe';

  @override
  String get checkoutServerConfirmationFailed =>
      'Не удалось подтвердить оплату сервера';

  @override
  String get checkoutEmptyCartTitle => 'Ваша корзина пуста';

  @override
  String get checkoutEmptyCartDesc =>
      'Вы еще не добавили ни одного курса в корзину. Изучите наши курсы и начните учиться!';

  @override
  String get checkoutContinueFreeReview => 'Продолжить бесплатный обзор';

  @override
  String get checkoutFreeOrderBadge => '100% бесплатный заказ (zsh.00)';

  @override
  String get checkoutFreeOrderNotice =>
      'Для этого заказа не требуется никакой платежной информации. Вы можете перейти непосредственно к подтверждению регистрации.';

  @override
  String get checkoutFreeCheckoutTitle => '100% бесплатная проверка';

  @override
  String get checkoutConfirmFreeEnrollment =>
      'Подтвердить бесплатную регистрацию';

  @override
  String get checkoutFreePrice => 'Бесплатно';

  @override
  String get checkoutFreeZero => 'Бесплатно (зш.00)';

  @override
  String checkoutCoursesCount(String count) {
    return '$count курсов';
  }

  @override
  String get notificationsClearAllTitle => 'Очистить все уведомления?';

  @override
  String notificationsClearAllMessage(String count) {
    return 'Вы уверены, что хотите удалить все уведомления $count? Это действие невозможно отменить.';
  }

  @override
  String get notificationsClearAllHint =>
      'Все ваши уведомления будут удалены, и ваш почтовый ящик обновится.';

  @override
  String notificationsClearAllConfirm(String count) {
    return 'Очистить все ($count)';
  }

  @override
  String get notificationsClearSuccess => 'Все уведомления успешно удалены';

  @override
  String get notificationsClearFailed => 'Не удалось очистить уведомления.';

  @override
  String get notificationsClearTooltip => 'Очистить все';

  @override
  String get notificationsViewDetails => 'Посмотреть детали';

  @override
  String get notificationsEmptyCategoryTitle =>
      'В этой категории нет уведомлений';

  @override
  String get notificationsEmptyCategorySubtitle =>
      'Попробуйте переключиться на другую категорию или просмотреть все уведомления.';

  @override
  String get notificationsEmptyAllSubtitle =>
      'Мы будем держать вас в курсе последних обновлений и оповещений здесь.';

  @override
  String get notificationsViewAll => 'Просмотреть все уведомления';

  @override
  String get learningFilterAndSortTitle => 'Фильтровать и сортировать курсы';

  @override
  String get learningFilterReset => 'Перезагрузить';

  @override
  String get learningSortByTitle => 'Сортировать по';

  @override
  String get learningSortRecentActivity => 'Недавно просмотренные';

  @override
  String get learningSortRecentEnrolled => 'Недавно зарегистрировался';

  @override
  String get learningSortTitleAZ => 'Название (А-Я)';

  @override
  String get learningSortProgress => 'Прогресс %';

  @override
  String get learningStatusTitle => 'Статус курса';

  @override
  String get learningStatusAll => 'Все курсы';

  @override
  String get learningStatusInProgress => 'В ходе выполнения';

  @override
  String get learningStatusCompleted => 'Завершено';

  @override
  String get learningStatusNotStarted => 'Не начато';

  @override
  String get learningFilterApply => 'Применить фильтры';

  @override
  String get learningSearchCoursesHint => 'Поиск по вашим курсам...';

  @override
  String get learningSearchWishlistHint => 'Поиск по списку желаний...';

  @override
  String get learningSearchCertificatesHint => 'Поиск сертификатов...';

  @override
  String get learningTabMyCourses => 'Мои курсы';

  @override
  String get learningTabFavourite => 'Избранное';

  @override
  String get learningTabCertificates => 'Мои сертификаты';

  @override
  String get learningNoCoursesTitle => 'Пока нет курсов';

  @override
  String get learningNoCoursesSubtitle =>
      'Исследуйте тысячи премиум-курсов и начните обучение уже сегодня';

  @override
  String get learningFilterButton => 'Фильтр';

  @override
  String learningFilterAllCount(String count) {
    return 'Все ($count)';
  }

  @override
  String get learningStatusNotStartedShort => 'Не начато';

  @override
  String get learningNoMatchTitle => 'Курсы не найдены';

  @override
  String learningNoMatchSubtitle(String query) {
    return 'Не найдено курсов, содержащих \"$query\". Попробуйте использовать другие поисковые запросы.';
  }

  @override
  String get learningNoInProgressTitle => 'Нет курсов в процессе обучения';

  @override
  String get learningNoInProgressSubtitle =>
      'Начните смотреть уроки на курсах, на которые вы записаны, чтобы отслеживать свой прогресс здесь.';

  @override
  String get learningNoCompletedTitle => 'Пока нет завершенных курсов';

  @override
  String get learningNoCompletedSubtitle =>
      'Продолжайте обучение, чтобы отмечать свои достижения и видеть завершенные курсы здесь.';

  @override
  String get learningNoUnstartedTitle => 'Нет неначатых курсов';

  @override
  String get learningNoUnstartedSubtitle =>
      'Отлично! Вы уже начали обучение во всех курсах, на которые записаны.';

  @override
  String get learningNoFilterMatchTitle =>
      'Нет курсов, соответствующих этому фильтру';

  @override
  String get learningNoFilterMatchSubtitle =>
      'Измените параметры фильтрации или сортировки, чтобы отобразить курсы.';

  @override
  String learningViewAllCoursesCount(String count) {
    return 'Посмотреть все курсы ($count)';
  }

  @override
  String learningSavedCoursesCount(String count) {
    return 'Сохраненные курсы ($count)';
  }

  @override
  String get learningClearAllSaved => 'Очистить все';

  @override
  String get learningNoCertificatesTitle => 'Пока нет сертификатов';

  @override
  String get learningNoCertificatesSubtitle =>
      'Завершите курсы, чтобы получить официальные сертификаты, подтверждающие ваши достижения';

  @override
  String get learningGoToCourses => 'Перейти в Мои курсы';

  @override
  String learningCertIssuedDate(String date) {
    return 'Выдан: $date';
  }

  @override
  String get learningCertView => 'Просмотр';

  @override
  String get learningResumeLesson => 'Продолжить урок';

  @override
  String learningProgressPercentComplete(String percent) {
    return '$percent% завершено';
  }

  @override
  String learningViewCartCount(String count) {
    return 'Товары в корзине ($count)';
  }

  @override
  String get learningGoToCart => 'Перейти в корзину';

  @override
  String get playerLessonMarkedCompleted => 'Урок отмечен как завершенный ✓';

  @override
  String get playerLessonMarkedIncomplete => 'Урок отмечен как незавершенный';

  @override
  String get playerCommentPostedSuccess => 'Комментарий успешно опубликован';

  @override
  String get playerCommentPostFailed => 'Не удалось опубликовать комментарий';

  @override
  String get playerReplyPostedSuccess => 'Ответ успешно опубликован';

  @override
  String get playerReplyPostFailed => 'Не удалось опубликовать ответ';

  @override
  String get playerCourseNotFound => 'Курс не найден';

  @override
  String get playerCheckEnrollmentPrompt =>
      'Пожалуйста, сначала подтвердите запись на курс';

  @override
  String get playerReturnToCourses => 'Мое обучение';

  @override
  String get playerWatchLecture => 'Лекция курса';

  @override
  String get playerCertificateTooltip => 'Сертификат';

  @override
  String get playerRateCourseTooltip => 'Оценить курс';

  @override
  String get playerReadingArticleBadge => 'Чтение статьи • 5 мин';

  @override
  String get playerReadFullTextBelow => 'Читать полный текст ниже ↓';

  @override
  String get playerTabReviews => 'Отзывы';

  @override
  String get playerNoSectionsAvailable => 'Нет доступных разделов';

  @override
  String playerLessonsCount(String count) {
    return '$count уроков';
  }

  @override
  String get playerPlayingBadge => 'Воспроизводится';

  @override
  String get playerArticleBadge => 'Статья';

  @override
  String get playerVideoBadge => 'Видео';

  @override
  String get playerFullArticleContent => 'Полное содержание статьи';

  @override
  String get playerArticlePlaceholder =>
      'Добро пожаловать на этот урок чтения.\n\nВ этом разделе рассматриваются ключевые концепции и практические шаги, необходимые для освоения навыков этого урока.';

  @override
  String get playerAboutCourseTitle => 'Об этом курсе';

  @override
  String get playerShowLess => 'Показать меньше';

  @override
  String get playerReadMore => 'Читать далее';

  @override
  String get playerWhatYouWillLearn => 'Чему вы научитесь';

  @override
  String get playerCourseInfoTitle => 'О курсе';

  @override
  String get playerTotalDurationTitle => 'Общая продолжительность';

  @override
  String get playerTotalLessonsTitle => 'Всего уроков';

  @override
  String playerLessonsNumber(String count) {
    return '$count уроков';
  }

  @override
  String get playerLevelTitle => 'Уровень';

  @override
  String get playerAllLevels => 'Все уровни';

  @override
  String get playerLanguageTitle => 'Язык';

  @override
  String get playerLanguageArabic => 'Арабский';

  @override
  String get playerPrerequisitesTitle => 'Требования к курсу';

  @override
  String get playerCertificateCardTitle => 'Сертификат курса';

  @override
  String get playerCourseCompletedSuccess => 'Поздравляем! Курс завершён';

  @override
  String get playerProgressLabel => 'Прогресс';

  @override
  String get playerViewCertificateBtn => 'Посмотреть сертификат';

  @override
  String get playerCertifiedInstructor => 'Сертифицированный преподаватель';

  @override
  String playerDiscussionsCount(String count) {
    return '$count вопросов и обсуждений';
  }

  @override
  String get playerAskQuestionHint => 'Введите ваш вопрос здесь...';

  @override
  String get playerPostBtn => 'Опубликовать';

  @override
  String get playerNoDiscussionsTitle => 'Обсуждений пока нет';

  @override
  String get playerNoDiscussionsSubtitle => 'Задайте вопрос первым!';

  @override
  String get playerInstructorBadge => 'Преподаватель';

  @override
  String get playerCancelReply => 'Отмена';

  @override
  String get playerReplyAction => 'Ответить';

  @override
  String playerRepliesCount(String count) {
    return '$count ответов';
  }

  @override
  String get playerWriteReplyHint => 'Напишите ответ...';

  @override
  String get playerSendReplyBtn => 'Ответить';

  @override
  String get playerCourseFeedbackTitle => 'Рейтинг и отзывы о курсе';

  @override
  String get playerOutOf5 => 'из 5';

  @override
  String playerRatingsFromEnrolledCount(String count) {
    return '$count оценок от студентов курса';
  }

  @override
  String get playerKeepLearningToRate => 'Продолжайте обучение, чтобы оценить';

  @override
  String get playerRateAfter80Hint =>
      'Вы сможете оценить курс после прохождения 80% материала';

  @override
  String get playerCurrentProgressLabel => 'Ваш прогресс:';

  @override
  String get playerYourCurrentRating => 'Ваша оценка';

  @override
  String get playerEditRating => 'Изменить оценку';

  @override
  String get playerDeleteRatingTooltip => 'Удалить оценку';

  @override
  String get playerUpdateRatingTitle => 'Обновить оценку';

  @override
  String get playerRateCourseTitle => 'Оценить этот курс';

  @override
  String get playerWriteReviewHint =>
      'Поделитесь впечатлениями о качестве курса (необязательно)...';

  @override
  String get playerRatingSubmitSuccess => 'Оценка успешно отправлена!';

  @override
  String get playerRatingSubmitFailed => 'Не удалось отправить оценку';

  @override
  String get playerSaveChangesBtn => 'Сохранить изменения';

  @override
  String get playerSubmitReviewBtn => 'Отправить отзыв';

  @override
  String get playerLearnerReviewsTitle => 'Отзывы студентов';

  @override
  String playerReviewsCount(String count) {
    return '$count отзывов';
  }

  @override
  String get playerNoWrittenReviewsTitle => 'Письменных отзывов пока нет';

  @override
  String get playerNoWrittenReviewsSubtitle =>
      'Поделитесь своими впечатлениями первым!';

  @override
  String get playerRatingLabel5 => 'Отлично 🌟 (5/5)';

  @override
  String get playerRatingLabel4 => 'Очень хорошо 👍 (4/5)';

  @override
  String get playerRatingLabel3 => 'Средне 👌 (3/5)';

  @override
  String get playerRatingLabel2 => 'Требует улучшения 🤔 (2/5)';

  @override
  String get playerRatingLabel1 => 'Плохо 👎 (1/5)';

  @override
  String get playerDeleteRatingDialogTitle => 'Удалить оценку';

  @override
  String get playerDeleteRatingDialogMessage =>
      'Вы уверены, что хотите удалить свой отзыв к этому курсу?';

  @override
  String get playerDeleteConfirmBtn => 'Удалить';

  @override
  String get playerRatingDeleteSuccess => 'Оценка успешно удалена';

  @override
  String get playerPreviousLesson => 'Предыдущий урок';

  @override
  String get playerExitFullscreenTooltip => 'Выйти из полноэкранного режима';

  @override
  String instructorsAvailableCount(String count) {
    return '$count доступных преподавателей';
  }

  @override
  String get instructorsNotFound => 'Преподаватели не найдены';

  @override
  String instructorsCoursesCount(String count) {
    return '$count курсов';
  }

  @override
  String get instructorsSearchHint =>
      'Поиск по имени инструктора или специальности...';

  @override
  String get instructorsSortAll => 'Все';

  @override
  String get instructorsSortTopRated => 'С самым высоким рейтингом';

  @override
  String get instructorsSortMostStudents => 'Большинство студентов';

  @override
  String get instructorsSortMostCourses => 'Большинство курсов';

  @override
  String get instructorsNotFoundSubtitle =>
      'Попробуйте выполнить поиск с другим именем или очистите фильтры.';

  @override
  String get exploreCompleteCourse => 'Комплексный курс';

  @override
  String get exploreGeneralCategory => 'Общий';

  @override
  String courseShareMessage(String title, String url) {
    return 'Ознакомьтесь с курсом «$title» на EduLab: $url.';
  }

  @override
  String get courseDetailsDefaultTitle => 'Детали курса';

  @override
  String get courseDetailsTooltipShare => 'Делиться';

  @override
  String get courseDetailsTooltipWishlist => 'Список желаний';

  @override
  String get courseDetailsTooltipCart => 'Корзина';

  @override
  String get courseDetailsNotFound => 'Курс не найден';

  @override
  String get courseDetailsDefaultCategory => 'Курс';

  @override
  String courseDetailsTotalRatingsCount(String count) {
    return '(оценок $count)';
  }

  @override
  String courseDetailsLecturesCount(String count) {
    return '$count лекций';
  }

  @override
  String get courseDetailsCertificateBadge => 'Сертификат';

  @override
  String get courseDetailsTabOverview => 'Обзор';

  @override
  String get courseDetailsTabCurriculum => 'Учебный план';

  @override
  String get courseDetailsTabInstructor => 'Инструктор';

  @override
  String get courseDetailsTabReviews => 'Отзывы';

  @override
  String get courseDetailsFullDescriptionTitle => 'Описание';

  @override
  String get courseDetailsShowLess => 'Показать меньше';

  @override
  String get courseDetailsShowMore => 'Показать больше...';

  @override
  String courseDetailsCurriculumSectionsLectures(
    String sections,
    String lectures,
  ) {
    return '$sections разделов • $lectures лекций';
  }

  @override
  String get courseDetailsCollapseAll => 'Свернуть все';

  @override
  String get courseDetailsExpandAll => 'Развернуть все';

  @override
  String get courseDetailsCurriculumComingSoon =>
      'Подробности обучения скоро появятся';

  @override
  String courseDetailsSectionLecturesCount(String count) {
    return '$count лекций';
  }

  @override
  String get courseDetailsLecturePreviewBtn => 'Предварительный просмотр';

  @override
  String get courseDetailsDefaultInstructorTitle =>
      'Старший инструктор и сертифицированный эксперт';

  @override
  String get courseDetailsInstructorRatingLabel => 'Рейтинг';

  @override
  String get courseDetailsInstructorStudentsLabel => 'Студенты';

  @override
  String get courseDetailsInstructorSectionsLabel => 'Разделы';

  @override
  String get courseDetailsAboutInstructorTitle => 'Об инструкторе:';

  @override
  String get courseDetailsDefaultInstructorAbout =>
      'Сертифицированный инструктор с обширным опытом предоставления профессионального образования тысячам студентов по всему миру.';

  @override
  String courseDetailsStudentRatingsCount(String count) {
    return '$count оценок студентов';
  }

  @override
  String get courseDetailsNoWrittenReviews => 'Письменных отзывов пока нет';

  @override
  String get courseDetailsRelatedCourses =>
      'Похожие курсы, которые могут вам понравиться';

  @override
  String courseDetailsDiscountPercent(String percent) {
    return '$percent% СКИДКА';
  }

  @override
  String get courseDetailsResumeCourse => 'Возобновить курс';

  @override
  String get courseDetailsTryAgain => 'Попробуйте еще раз';

  @override
  String get courseDetailsEstimatedReading =>
      '📖 Примерное время прочтения: 4 минуты.';

  @override
  String get courseDetailsSampleArticleContent =>
      'Добро пожаловать на лекцию по этой статье.\n\nВ этом разделе рассматриваются ключевые теоретические концепции и практические шаги по освоению предмета.\n\n• Основные выводы:\n1. Освоить основную терминологию и архитектурные шаблоны.\n2. Практические упражнения и постоянная практика.\n3. Справочные дополнительные примечания и задания.\n\nПриятного чтения!';

  @override
  String certDownloadedSuccess(String course, String format) {
    return 'Сертификат для «$course» успешно загружен в формате $format!';
  }

  @override
  String certVerifiedFullRequirements(String code) {
    return 'Идентификатор проверки: $code • Требования выполнены на 100 %.';
  }

  @override
  String get certCompletionTitle => 'Сертификат об окончании';

  @override
  String get certCompletionSubtitle => 'Сертификат об окончании курса';

  @override
  String get certAnnounceStudent =>
      'EducationLab Learning Academy настоящим подтверждает, что:';

  @override
  String get certCompletionRequirementsMet =>
      'Успешно выполнил все требования курса обучения:';

  @override
  String certIssueDateText(String date) {
    return 'Дата выпуска: $date';
  }

  @override
  String certIdNumberText(String code) {
    return 'Идентификатор сертификата: $code';
  }

  @override
  String get certPlatformManagement => 'Управление платформой';

  @override
  String get certInstructorRoleTitle => 'Инструктор курса';

  @override
  String get commonLoading => 'Загрузка...';

  @override
  String get homeGuestTagline => 'Умная платформа обучения и развития навыков';

  @override
  String get catTagHighestDemand => 'Самые востребованные';

  @override
  String get catTagMostPopular => 'Самые популярные';

  @override
  String get catTagTrending => 'В тренде';

  @override
  String get catTagFastestGrowing => 'Быстрорастущие';

  @override
  String get catTagHighDemand => 'Высокий спрос';

  @override
  String get catTagTopRated => 'Высокий рейтинг';

  @override
  String get catTagEssential => 'Очень важно';

  @override
  String get catTagAdvanced => 'Продвинутый уровень';

  @override
  String get catTagEntrepreneurs => 'Для предпринимателей';

  @override
  String get catTagSalesGrowth => 'Рост продаж';

  @override
  String get catDevTitle => 'Программирование и разработка ПО';

  @override
  String get catDevSubtitle => 'Инженерия ПО, архитектура систем и алгоритмы';

  @override
  String get catWebTitle => 'Веб-разработка';

  @override
  String get catWebSubtitle => 'Frontend, Backend и Fullstack веб';

  @override
  String get catMobileTitle => 'Мобильная разработка';

  @override
  String get catMobileSubtitle => 'Приложения Flutter, iOS и Android';

  @override
  String get catAiTitle => 'Искусственный интеллект';

  @override
  String get catAiSubtitle => 'Машинное обучение, нейросети и AI';

  @override
  String get catDataTitle => 'Наука о данных и аналитика';

  @override
  String get catDataSubtitle => 'Анализ данных, статистика и Big Data';

  @override
  String get catDesignTitle => 'UI/UX и дизайн продуктов';

  @override
  String get catDesignSubtitle => 'UI/UX, прототипирование и дизайн';

  @override
  String get catSecurityTitle => 'Кибербезопасность и сети';

  @override
  String get catSecuritySubtitle => 'Кибербезопасность, этичный хакинг и сети';

  @override
  String get catCloudTitle => 'Облачные технологии и DevOps';

  @override
  String get catCloudSubtitle => 'Облачная инфраструктура, DevOps и CI/CD';

  @override
  String get catBusinessTitle => 'Бизнес и управление проектами';

  @override
  String get catBusinessSubtitle => 'Предпринимательство, Agile и лидерство';

  @override
  String get catMarketingTitle => 'Цифровой маркетинг';

  @override
  String get catMarketingSubtitle => 'Digital-маркетинг, SEO и стратегии роста';

  @override
  String get timeJustNow => 'Только что';

  @override
  String timeMinutesAgo(String count) {
    return '$count мин. назад';
  }

  @override
  String timeHoursAgo(String count) {
    return '$count ч. назад';
  }

  @override
  String timeDaysAgo(String count) {
    return '$count дн. назад';
  }

  @override
  String timeWeeksAgo(String count) {
    return '$count нед. назад';
  }

  @override
  String timeMonthsAgo(String count) {
    return '$count мес. назад';
  }

  @override
  String wishlistLecturesCount(String count) {
    return '$count лекций';
  }

  @override
  String get instructorProfileTitle => 'Профиль инструктора';

  @override
  String instructorProfileLinkCopied(String name) {
    return 'Ссылка на профиль $name скопирована в буфер обмена';
  }

  @override
  String get instructorDefaultName => 'Инструктор';

  @override
  String get instructorProfileBadge => 'ИНСТРУКТОР';

  @override
  String get instructorProfileTotalStudents => 'Всего студентов';

  @override
  String get instructorProfileRating => 'Рейтинг инструктора';

  @override
  String get instructorProfileCourses => 'Курсы';

  @override
  String get instructorProfileShare => 'Поделиться профилем';

  @override
  String get instructorProfileLinkOpenError =>
      'Не удалось открыть ссылку, скопирована в буфер обмена';

  @override
  String get instructorProfileWebsite => 'Веб-сайт';

  @override
  String get instructorProfileAboutMe => 'О себе';

  @override
  String get instructorProfileShowLess => 'Показать меньше';

  @override
  String get instructorProfileShowMore => 'Показать больше';

  @override
  String get instructorProfileExpertise => 'Области специализации';

  @override
  String get instructorProfileSortAll => 'Все';

  @override
  String get instructorProfileSortTopRated => 'С самым высоким рейтингом';

  @override
  String get instructorProfileSortPopular => 'Популярные';

  @override
  String get instructorProfileSortNewest => 'Новые';

  @override
  String get instructorProfileCoursesTitle => 'Курсы инструктора';

  @override
  String get instructorProfileNoCoursesFilter =>
      'Для этого фильтра не найдено курсов';

  @override
  String instructorProfileLoadMoreCourses(String count) {
    return 'Загрузить ещё курсы (осталось $count)';
  }

  @override
  String get instructorProfileLoadingMoreCourses => 'Загрузка курсов...';

  @override
  String instructorProfileAllCoursesLoaded(String count) {
    return 'Все курсы ($count) загружены';
  }

  @override
  String get instructorProfileStudentFeedback => 'Отзывы студентов';

  @override
  String instructorProfileReviewsCount(String count) {
    return '$count отзывов';
  }

  @override
  String instructorProfileBasedOnReviews(String count) {
    return 'На основе $count отзывов';
  }

  @override
  String get instructorProfileRecentReviews => 'Последние отзывы';

  @override
  String instructorProfileLoadMoreReviews(String count) {
    return 'Загрузить ещё отзывы (осталось $count)';
  }

  @override
  String get instructorProfileLoadingMoreReviews => 'Загрузка отзывов...';

  @override
  String instructorProfileAllReviewsLoaded(String count) {
    return 'Все отзывы ($count) загружены';
  }

  @override
  String get instructorProfileNoReviewsYet => 'Письменных отзывов пока нет';

  @override
  String get instructorProfileRatingDesc =>
      'Рейтинг основан на общих оценках студентов по всем курсам инструктора';

  @override
  String get instructorProfileLoadError =>
      'Не удалось загрузить данные инструктора, повторите попытку позже';

  @override
  String get instructorProfileDefaultStudentName => 'Студент';

  @override
  String get instructorProfileDefaultHeadline =>
      'Старший инструктор и сертифицированный эксперт';

  @override
  String get instructorProfileDefaultBio =>
      'Сертифицированный инженер-программист и технический инструктор с большим опытом создания масштабируемых программных систем и мобильных приложений.\nОбучил тысячи студентов и инженеров по всему миру, создавая профессиональный контент, посвященный чистому коду, чистой архитектуре и современным масштабируемым решениям.';

  @override
  String get supportNewChat => 'Новый чат';

  @override
  String get supportNoChatsTitle => 'Пока нет обращений в поддержку';

  @override
  String get supportNoChatsDesc =>
      'Наша служба поддержки готова круглосуточно помочь и ответить на все ваши вопросы';

  @override
  String get supportStartNewConversation => 'Начать новый диалог';

  @override
  String get supportNoMessagesYet => 'Сообщений пока нет';

  @override
  String get supportRetry => 'Повторить';

  @override
  String get supportOpenTicket => 'Открытый тикет';

  @override
  String get supportClosedTicket => 'Закрытый тикет';

  @override
  String get supportCloseAction => 'Закрыть';

  @override
  String get supportReopenAction => 'Открыть снова';

  @override
  String get supportNoMessagesInChat => 'В этом чате пока нет сообщений';

  @override
  String get supportYou => 'Вы';

  @override
  String get supportTeam => 'Служба поддержки';

  @override
  String get supportTypeMessageHint => 'Введите сообщение...';

  @override
  String get supportConversationClosedNotice =>
      'Этот диалог в настоящее время закрыт.';

  @override
  String get supportCloseDialogTitle => 'Закрыть диалог?';

  @override
  String get supportCloseDialogDesc =>
      'Вы уверены, что хотите закрыть этот чат? Вы можете открыть его снова в любое время, чтобы продолжить переписку.';

  @override
  String get supportCancel => 'Отмена';

  @override
  String get supportYesClose => 'Да, закрыть';

  @override
  String get supportNewChatTitle => 'Новый чат с поддержкой';

  @override
  String get supportNewChatSubtitle => 'Наша команда готова вам помочь';

  @override
  String get supportSubjectLabel => 'Тема';

  @override
  String get supportSubjectHint =>
      'напр., Вопрос по курсу, Проблема с оплатой...';

  @override
  String get supportMessageLabel => 'Сообщение';

  @override
  String get supportMessageHint =>
      'Опишите подробно вашу проблему или вопрос...';

  @override
  String get supportMessageRequired => 'Пожалуйста, введите сообщение';

  @override
  String get supportStartConversationBtn => 'Начать диалог';

  @override
  String get supportCreateError =>
      'Не удалось создать диалог, повторите попытку позже';

  @override
  String get supportTopicCourse => 'Вопрос по курсу';

  @override
  String get supportTopicPayment => 'Проблема с оплатой';

  @override
  String get supportTopicCertificates => 'Сертификаты';

  @override
  String get supportTopicTech => 'Техническая проблема';

  @override
  String get supportTopicGeneral => 'Общий вопрос';

  @override
  String get cartGuestTitle => 'Войдите, чтобы просмотреть корзину';

  @override
  String get cartGuestSubtitle =>
      'Пожалуйста, войдите, чтобы получить доступ к корзине и продолжить покупку курсов.';

  @override
  String get wishlistGuestTitle => 'Войдите, чтобы просмотреть список желаний';

  @override
  String get wishlistGuestSubtitle =>
      'Пожалуйста, войдите, чтобы в любое время вернуться к сохраненным курсам.';

  @override
  String get courseDetailsLoginRequiredTitle => 'Требуется вход в аккаунт';

  @override
  String get courseDetailsLoginRequiredDesc =>
      'Сначала необходимо войти в систему, чтобы приобрести этот курс и сохранить прогресс.';

  @override
  String get courseDetailsProceedToLogin => 'Перейти ко входу';

  @override
  String get messagesGuestTitle => 'Войдите, чтобы просмотреть сообщения';

  @override
  String get messagesGuestSubtitle =>
      'Пожалуйста, войдите, чтобы получить доступ к переписке со службой поддержки.';

  @override
  String get notificationsGuestTitle =>
      'Войдите, чтобы просмотреть уведомления';

  @override
  String get notificationsGuestSubtitle =>
      'Пожалуйста, войдите, чтобы просматривать последние уведомления о вашем аккаунте и курсах.';

  @override
  String get legalTitle => 'О нас и правовая информация';

  @override
  String get legalTabAbout => 'О EduLab';

  @override
  String get legalTabPrivacy => 'Конфиденциальность';

  @override
  String get legalTabTerms => 'Условия';

  @override
  String get legalUpdated => 'Обновлено:';

  @override
  String get legalNeedHelpTitle => 'Нужна помощь или есть вопросы?';

  @override
  String get legalNeedHelpDesc =>
      'Служба поддержки EduLab готова помочь вам круглосуточно. Свяжитесь с нами по электронной почте.';

  @override
  String get legalEmailCopied => 'Email поддержки скопирован в буфер обмена';

  @override
  String get legalNoContent => 'В настоящее время контент отсутствует';

  @override
  String get checkoutDigitalReceipt => 'Электронный чек';

  @override
  String get checkoutTransactionDate => 'Дата транзакции';

  @override
  String get checkoutFreeEnrollment => 'Бесплатная запись';

  @override
  String get checkoutEnrolledCourses => 'Приобретенные курсы';

  @override
  String get checkoutTransactionStatus => 'Статус';

  @override
  String get checkoutStatusSuccess => 'Успешно завершено';

  @override
  String get checkoutTotalPaid => 'Итого оплачено';

  @override
  String get checkoutCopied => 'Скопировано!';

  @override
  String get checkoutCardHolderHint => 'Полное имя как на карте';

  @override
  String get teachUploadProfilePhoto => 'Загрузить фото профиля';

  @override
  String get teachAttachCV => 'Прикрепить резюме';

  @override
  String get teachChooseClearPhotoForAccount =>
      'Выберите четкое фото для вашего профиля';

  @override
  String get teachChooseClearDocForCV =>
      'Выберите четкий документ или фото вашего резюме';

  @override
  String get teachTakePhoto => 'Сделать снимок';

  @override
  String get teachTakePhotoSubtitle => 'Сделать новое фото с помощью камеры';

  @override
  String get teachChooseFromGallery => 'Выбрать из галереи';

  @override
  String get teachChooseFromGallerySubtitle => 'Выбрать файл на устройстве';

  @override
  String get teachAddOneSkillRequired =>
      'Пожалуйста, добавьте хотя бы один навык';

  @override
  String get teachAgreeTermsRequired =>
      'Пожалуйста, согласитесь с условиями для преподавателей, чтобы продолжить';

  @override
  String get teachApplicationReceivedTitle => 'Ваша заявка успешно получена!';

  @override
  String get teachApplicationReceivedDesc =>
      'Спасибо за присоединение к сообществу преподавателей EduLab. Наша академическая группа рассмотрит вашу заявку, и вы будете уведомлены о решении.';

  @override
  String get teachTrackApplicationStatus => 'Отследить статус заявки';

  @override
  String get teachRefreshTooltip => 'Обновить';

  @override
  String get teachVerifyingApplicationData => 'Проверка данных заявки...';

  @override
  String get teachAlreadyInstructor =>
      'Вы уже являетесь утвержденным преподавателем!';

  @override
  String get teachAlreadyInstructorDesc =>
      'Ваш аккаунт имеет полные права преподавателя. Вы можете управлять своими курсами и публиковать новые материалы в панели преподавателя.';

  @override
  String get teachBackToHome => 'На главную';

  @override
  String get teachStatusApproved => 'Ваша заявка преподавателя была одобрена';

  @override
  String get teachStatusRejected => 'Ваша заявка была отклонена';

  @override
  String get teachStatusPending =>
      'Ваша заявка в настоящее время находится на рассмотрении';

  @override
  String get teachApplicationDetails => 'Детали заявки';

  @override
  String get teachApplicationNumber => 'Номер заявки';

  @override
  String get teachApplicationDate => 'Дата заявки';

  @override
  String get teachApplicant => 'Заявитель';

  @override
  String get teachApplicantEmail => 'Эл. почта';

  @override
  String get teachSpecialization => 'Специализация';

  @override
  String get teachExperienceYears => 'Опыт работы';

  @override
  String get teachCVLabel => 'Резюме / CV';

  @override
  String get teachCVAttached => 'Прикреплено ✓';

  @override
  String get teachReapply => 'Подать новую заявку';

  @override
  String get teachRefreshing => 'Обновление...';

  @override
  String get teachRefreshStatus => 'Обновить статус заявки';

  @override
  String get teachApprovedMessage =>
      'Поздравляем! Теперь вы можете начать загружать и делиться своими учебными курсами.';

  @override
  String teachRejectionReason(String reason) {
    return 'Причина отказа: $reason';
  }

  @override
  String get teachRejectedDefault =>
      'К сожалению, заявка не соответствует текущим требованиям. Вы можете проверить свои данные и подать заявку снова.';

  @override
  String get teachPendingMessage =>
      'Ваша заявка получена и в настоящее время рассматривается администрацией платформы. Вы будете уведомлены о решении.';

  @override
  String get teachStepPersonalData => 'Личные данные';

  @override
  String get teachStepExperienceSkills => 'Опыт и навыки';

  @override
  String get teachStepReviewApplication => 'Проверка заявки';

  @override
  String get teachStep1HeaderTitle => '1. Личная и профессиональная информация';

  @override
  String get teachFullNameLabel => 'Полное имя *';

  @override
  String get teachFullNameHintAr => 'например, Иван Иванов';

  @override
  String get teachFullNameValidation => 'Пожалуйста, введите корректное имя';

  @override
  String get teachEmailReadonly => 'Эл. почта (Зарегистрированный аккаунт)';

  @override
  String get teachPhoneLabelContact => 'Контактный телефон *';

  @override
  String get teachPhoneValidation =>
      'Пожалуйста, введите корректный номер телефона';

  @override
  String get teachBioLabelWithAsterisk => 'О себе *';

  @override
  String teachBioCharCount(String count) {
    return '$count / 200 символов';
  }

  @override
  String get teachBioHintDetail =>
      'Кратко опишите свою карьеру и специализацию (макс. 200 символов)...';

  @override
  String get teachBioMinLengthValidation =>
      'Раздел \'О себе\' должен содержать не менее 10 символов';

  @override
  String get teachBioMaxLengthValidation =>
      'Раздел \'О себе\' не должен превышать 200 символов';

  @override
  String get teachProfilePhotoOptional =>
      'Фото профиля преподавателя (необязательно)';

  @override
  String get teachNextExperienceSkills => 'Продолжить: Опыт и навыки';

  @override
  String get teachStep2HeaderTitle => '2. Академический опыт и навыки';

  @override
  String get teachSpecializationLabel => 'Специализация *';

  @override
  String get teachSpecializationHint => 'Выберите специализацию';

  @override
  String get teachExperienceLabel => 'Опыт работы *';

  @override
  String get teachExperience0to2 => 'Менее 2 лет (0 - 2)';

  @override
  String get teachExperience2to5 => 'От 2 до 5 лет (2 - 5)';

  @override
  String get teachExperience5to10 => 'От 5 до 10 лет (5 - 10)';

  @override
  String get teachExperience10plus => 'Более 10 лет (10+)';

  @override
  String get teachSkillsLabel => 'Навыки и технологии *';

  @override
  String get teachSkillHint =>
      'Добавить навык (например, Flutter, Dart, UI/UX)...';

  @override
  String get teachSkillAddButton => 'Добавить';

  @override
  String get teachSkillMinRequired =>
      '* Пожалуйста, добавьте хотя бы один навык';

  @override
  String get teachCVFileLabel => 'Файл резюме (CV)';

  @override
  String get teachPrevButton => 'Назад';

  @override
  String get teachNextReviewApplication => 'Продолжить: Проверка заявки';

  @override
  String get teachStep3HeaderTitle =>
      '3. Проверка заявки и подтверждение условий';

  @override
  String get teachReviewBanner =>
      'Пожалуйста, внимательно проверьте все введенные данные перед отправкой. После отправки статус вашего аккаунта будет изменен на \'преподаватель - на рассмотрении\'.';

  @override
  String get teachSummaryFullName => 'Полное имя';

  @override
  String get teachSummaryEmail => 'Эл. почта';

  @override
  String get teachSummaryPhone => 'Номер телефона';

  @override
  String get teachSummarySpecialization => 'Академическая специализация';

  @override
  String get teachSummaryExperience => 'Опыт работы';

  @override
  String teachSummarySkillsCount(String count, String skills) {
    return '$count навыков ($skills)';
  }

  @override
  String get teachSummaryProfilePhoto => 'Фото профиля';

  @override
  String get teachSummaryPhotoSelected => 'Выбрано ✓';

  @override
  String get teachSummaryPhotoNotSelected => 'Не выбрано';

  @override
  String get teachSummaryCVFile => 'Резюме (CV)';

  @override
  String get teachSummaryCVAttached => 'Прикреплено ✓';

  @override
  String get teachSummaryCVNotAttached => 'Не прикреплено';

  @override
  String get teachTermsAgreement =>
      'Я согласен с условиями для преподавателей и соглашением об интеллектуальной собственности EduLab.';

  @override
  String get teachSubmitButton => 'Отправить заявку преподавателя';

  @override
  String get teachPhotoSelectedSuccess => 'Фото успешно выбрано';

  @override
  String get teachChoosePhotoFromDevice =>
      'Выберите фото профиля на вашем устройстве';

  @override
  String get teachCVAttachedSuccess => 'Резюме успешно прикреплено';

  @override
  String get teachAttachCVFileOrPhoto => 'Прикрепить резюме (файл или фото)';

  @override
  String get teachSummarySkillsLabel => 'Добавленные навыки';
}

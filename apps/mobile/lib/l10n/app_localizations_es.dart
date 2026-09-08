// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get onboardingSkip => 'Omitir';

  @override
  String get onboardingTitle1 => 'Bienvenido a EduLab';

  @override
  String get onboardingSubtitle1 =>
      'Tu plataforma ideal para el aprendizaje interactivo moderno y el crecimiento profesional continuo.';

  @override
  String get onboardingTitle2 => 'Aprende de los mejores instructores';

  @override
  String get onboardingSubtitle2 =>
      'Miles de cursos profesionales en programación, diseño, negocios y ciencia de datos.';

  @override
  String get onboardingTitle3 => 'Certificados y éxito garantizado';

  @override
  String get onboardingSubtitle3 =>
      'Sigue tu progreso, aprueba exámenes y obtén certificados reconocidos.';

  @override
  String get onboardingNext => 'Siguiente';

  @override
  String get onboardingStart => 'Comenzar';

  @override
  String get splashAppName => 'Education Lab';

  @override
  String get splashTagline => 'Plataforma de Aprendizaje Inteligente';

  @override
  String get loginTagline =>
      'Bienvenido a la plataforma de aprendizaje inteligente';

  @override
  String get loginAppName => 'EduLab';

  @override
  String get loginTabLogin => 'Iniciar Sesión';

  @override
  String get loginTabRegister => 'Nueva Cuenta';

  @override
  String get loginEmailLabel => 'Correo electrónico';

  @override
  String get loginEmailHint => 'ejemplo@correo.com';

  @override
  String get loginPasswordLabel => 'Contraseña';

  @override
  String get loginPasswordHint => '••••••';

  @override
  String get loginForgotPassword => '¿Olvidaste tu contraseña?';

  @override
  String get loginSubmit => 'Iniciar Sesión';

  @override
  String get loginSubmitLoading => 'Iniciando sesión';

  @override
  String get loginGuest => 'Entrar como invitado';

  @override
  String get loginOr => 'o';

  @override
  String get loginEmailRequired => 'El correo es obligatorio';

  @override
  String get loginEmailInvalid => 'Introduce un correo válido';

  @override
  String get loginPasswordRequired => 'La contraseña es obligatoria';

  @override
  String get registerStepEmail => 'Correo';

  @override
  String get registerStepCode => 'Código';

  @override
  String get registerStepData => 'Datos';

  @override
  String get registerSendCodeInfo =>
      'Te enviaremos un código de activación a este correo';

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
      'Introduce el código completo de 6 dígitos';

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
  String get registerConfirmHint => 'Vuelve a escribir la contraseña';

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
      'El nombre debe tener al menos 6 caracteres';

  @override
  String get registerPasswordMinLength =>
      'La contraseña debe tener al menos 8 caracteres';

  @override
  String get registerPasswordUppercase =>
      'La contraseña debe contener al menos una mayúscula';

  @override
  String get registerPasswordNumber =>
      'La contraseña debe contener al menos un número';

  @override
  String get registerConfirmRequired =>
      'La confirmación de contraseña es obligatoria';

  @override
  String get registerConfirmMismatch => 'Las contraseñas no coinciden';

  @override
  String get networkError => 'Error de conexión, inténtalo de nuevo';

  @override
  String homeGreeting(String name) {
    return '¡Hola, $name!';
  }

  @override
  String get homeSubtitle => '¿Qué quieres aprender hoy?';

  @override
  String get homeSearchHint => 'Buscar un curso o habilidad...';

  @override
  String get homeSectionContinue => 'Continuar aprendiendo';

  @override
  String get homeSectionRecommended => 'Recomendado para ti';

  @override
  String get homeSectionPopular => 'Más populares';

  @override
  String get homeSectionTopRated => 'Mejor valorados';

  @override
  String get homeSectionByCategory => 'Por categoría';

  @override
  String get homeHeroTitle => 'Explora las ofertas ahora';

  @override
  String get homeHeroSubtitle =>
      'Hasta un 70% de descuento en cursos destacados';

  @override
  String get homeHeroButton => 'Descubrir ahora';

  @override
  String get homeViewAll => 'Ver todo';

  @override
  String get homeProgressLabel => 'Completado';

  @override
  String get exploreTitle => 'Explorar Cursos';

  @override
  String get exploreSearchHint => 'Buscar un curso, habilidad o instructor...';

  @override
  String get exploreAllCategories => 'Todas las categorías';

  @override
  String get exploreFilter => 'Filtrar';

  @override
  String get exploreSort => 'Ordenar';

  @override
  String get exploreNoResults => 'No se encontraron resultados';

  @override
  String get exploreNoResultsHint =>
      'Prueba con diferentes palabras clave o cambia el filtro';

  @override
  String exploreCoursesCount(int count) {
    return '$count cursos';
  }

  @override
  String get exploreFilterTitle => 'Filtrar resultados';

  @override
  String get exploreFilterApply => 'Aplicar filtro';

  @override
  String get exploreFilterReset => 'Restablecer';

  @override
  String get exploreFilterPrice => 'Precio';

  @override
  String get exploreFilterLevel => 'Nivel';

  @override
  String get exploreFilterRating => 'Calificación';

  @override
  String get exploreFilterDuration => 'Duración';

  @override
  String get exploreSortTitle => 'Ordenar por';

  @override
  String get exploreSortRelevance => 'Más relevante';

  @override
  String get exploreSortNewest => 'Más reciente';

  @override
  String get exploreSortPopular => 'Más popular';

  @override
  String get exploreSortRating => 'Mejor calificación';

  @override
  String get exploreSortPriceLow => 'Precio: menor a mayor';

  @override
  String get exploreSortPriceHigh => 'Precio: mayor a menor';

  @override
  String get explorePriceFree => 'Gratis';

  @override
  String get exploreLevelBeginner => 'Principiante';

  @override
  String get exploreLevelIntermediate => 'Intermedio';

  @override
  String get exploreLevelAdvanced => 'Avanzado';

  @override
  String get learningTitle => 'Mi Aprendizaje';

  @override
  String get learningTabInProgress => 'En progreso';

  @override
  String get learningTabCompleted => 'Completado';

  @override
  String get learningTabSaved => 'Guardado';

  @override
  String get learningEmpty => 'No hay cursos todavía';

  @override
  String get learningEmptyHint => 'Comienza a explorar cursos ahora';

  @override
  String get learningExploreButton => 'Explorar Cursos';

  @override
  String learningProgress(int percent) {
    return '$percent% completado';
  }

  @override
  String get learningContinue => 'Continuar';

  @override
  String get learningViewCertificate => 'Ver Certificado';

  @override
  String get learningReview => 'Calificar curso';

  @override
  String get learningLesson => 'Lección';

  @override
  String get learningLessons => 'Lecciones';

  @override
  String get cartTitle => 'Carrito';

  @override
  String get cartEmpty => 'Tu carrito está vacío';

  @override
  String get cartEmptyHint => 'Añade cursos para comenzar tu aprendizaje';

  @override
  String get cartExploreButton => 'Explorar Cursos';

  @override
  String get cartPromoPlaceholder => 'Introduce código promocional';

  @override
  String get cartPromoApply => 'Aplicar';

  @override
  String get cartPromoInvalid => 'Código promocional no válido';

  @override
  String get cartSummary => 'Resumen del pedido';

  @override
  String get cartSubtotal => 'Subtotal';

  @override
  String get cartDiscount => 'Descuento';

  @override
  String get cartTotal => 'Total';

  @override
  String get cartCheckout => 'Pagar';

  @override
  String cartCourses(int count) {
    return '$count cursos';
  }

  @override
  String get cartRemove => 'Eliminar';

  @override
  String get cartGuarantee => 'Garantía de devolución de 30 días';

  @override
  String get checkoutTitle => 'Finalizar Compra';

  @override
  String get checkoutStepPayment => 'Pago';

  @override
  String get checkoutStepReview => 'Revisión';

  @override
  String get checkoutStepConfirm => 'Confirmación';

  @override
  String get checkoutOrderSummary => 'Resumen del pedido';

  @override
  String get checkoutTotal => 'Total';

  @override
  String get checkoutPayNow => 'Pagar ahora';

  @override
  String get checkoutBack => 'Atrás';

  @override
  String get checkoutNext => 'Siguiente';

  @override
  String get checkoutSecureSSL => 'Pago seguro con cifrado SSL de 256 bits';

  @override
  String get checkoutSuccessTitle => '¡Compra Exitosa!';

  @override
  String get checkoutSuccessSubtitle => 'Ya puedes acceder a tu curso';

  @override
  String get checkoutGoToLearning => 'Ir a Mis Cursos';

  @override
  String get checkoutPaymentMethod => 'Método de Pago';

  @override
  String get checkoutCardNumber => 'Número de tarjeta';

  @override
  String get checkoutCardName => 'Nombre del titular';

  @override
  String get checkoutCardExpiry => 'Fecha de vencimiento';

  @override
  String get checkoutCardCVV => 'CVV';

  @override
  String get courseDetailsEnroll => 'Inscribirse ahora';

  @override
  String get courseDetailsBuyNow => 'Comprar ahora';

  @override
  String get courseDetailsAddToCart => 'Añadir al carrito';

  @override
  String get courseDetailsAddedToCart => 'Añadido al carrito';

  @override
  String get courseDetailsAlreadyEnrolled => 'Ya inscrito';

  @override
  String get courseDetailsGoToCourse => 'Ir al curso';

  @override
  String get courseDetailsFree => 'Gratis';

  @override
  String courseDetailsStudents(String count) {
    return '$count estudiantes';
  }

  @override
  String get courseDetailsRating => 'Calificación';

  @override
  String get courseDetailsReviews => 'reseñas';

  @override
  String get courseDetailsLastUpdated => 'Última actualización';

  @override
  String get courseDetailsCurriculum => 'Contenido del curso';

  @override
  String get courseDetailsSection => 'sección';

  @override
  String get courseDetailsLessons => 'lecciones';

  @override
  String get courseDetailsInstructor => 'Instructor';

  @override
  String get courseDetailsStudentsLabel => 'Estudiantes';

  @override
  String get courseDetailsCoursesLabel => 'Cursos';

  @override
  String get courseDetailsReviewsLabel => 'Reseñas';

  @override
  String get courseDetailsReviewsTitle => 'Reseñas de estudiantes';

  @override
  String get courseDetailsWhatLearn => '¿Qué aprenderás?';

  @override
  String get courseDetailsRequirements => 'Requisitos';

  @override
  String get courseDetailsDescription => 'Descripción del curso';

  @override
  String get courseDetailsIncludesTitle => 'Este curso incluye';

  @override
  String get courseDetailsHoursVideo => 'horas de video';

  @override
  String get courseDetailsArticles => 'artículos';

  @override
  String get courseDetailsMobileAccess => 'Acceso en dispositivos móviles';

  @override
  String get courseDetailsCertificate => 'Certificado de finalización';

  @override
  String get courseDetailsLifetimeAccess => 'Acceso de por vida';

  @override
  String get lessonPlayerNotes => 'Mis notas';

  @override
  String get lessonPlayerResources => 'Recursos';

  @override
  String get lessonPlayerDiscussion => 'Discusión';

  @override
  String get lessonPlayerPrev => 'Anterior';

  @override
  String get lessonPlayerNext => 'Siguiente';

  @override
  String get lessonPlayerSpeed => 'Velocidad';

  @override
  String get lessonPlayerQuality => 'Calidad';

  @override
  String get lessonPlayerCompleted => 'Lección completada';

  @override
  String get certificateTitle => 'Certificado de Finalización';

  @override
  String get certificatePresentedTo => 'Otorgado a';

  @override
  String get certificateCompletedCourse => 'por completar con éxito';

  @override
  String get certificateIssuedOn => 'Fecha de emisión';

  @override
  String get certificateVerificationId => 'ID de verificación';

  @override
  String get certificateDownloadPDF => 'Descargar PDF';

  @override
  String get certificateDownloadPNG => 'Descargar imagen';

  @override
  String get certificateCopyLink => 'Copiar enlace de verificación';

  @override
  String get certificateLinkCopied => 'Enlace copiado';

  @override
  String get profileTitle => 'Perfil';

  @override
  String get profileEditProfile => 'Editar Perfil';

  @override
  String get profileCourses => 'Mis Cursos';

  @override
  String get profileCertificates => 'Certificados';

  @override
  String get profilePoints => 'Puntos';

  @override
  String get profileFollowers => 'Seguidores';

  @override
  String get profileFollowing => 'Siguiendo';

  @override
  String get profileBio => 'Biografía';

  @override
  String get profileInstructor => 'Instructor';

  @override
  String get profileStudent => 'Estudiante';

  @override
  String get profileLevel => 'Nivel';

  @override
  String get profileJoined => 'Se unió en';

  @override
  String get profileShareProfile => 'Compartir perfil';

  @override
  String get profileMenuLearning => 'Mis Cursos';

  @override
  String get profileMenuCertificates => 'Mis Certificados';

  @override
  String get profileMenuPurchaseHistory => 'Historial de Compras';

  @override
  String get profileMenuTeachApplication => 'Enseñar en EduLab';

  @override
  String get profileMenuAccountSecurity => 'Seguridad de la Cuenta';

  @override
  String get profileMenuNotifications => 'Notificaciones';

  @override
  String get profileMenuMessages => 'Mensajes';

  @override
  String get profileMenuSettings => 'Configuración';

  @override
  String get profileMenuSchedule => 'Mi Horario';

  @override
  String get profileMenuAssignments => 'Tareas';

  @override
  String get profileMenuQuiz => 'Cuestionarios';

  @override
  String get profileMenuLogout => 'Cerrar Sesión';

  @override
  String get profileLogoutConfirm =>
      '¿Estás seguro de que deseas cerrar sesión?';

  @override
  String get profileLogoutYes => 'Sí, cerrar sesión';

  @override
  String get profileLogoutNo => 'Cancelar';

  @override
  String get editProfileTitle => 'Editar Perfil';

  @override
  String get editProfileSave => 'Guardar cambios';

  @override
  String get editProfileFullName => 'Nombre completo';

  @override
  String get editProfileBio => 'Biografía';

  @override
  String get editProfileEmail => 'Correo electrónico';

  @override
  String get editProfilePhone => 'Teléfono';

  @override
  String get editProfileWebsite => 'Sitio web';

  @override
  String get editProfileSaved => 'Cambios guardados con éxito';

  @override
  String get accountSecurityTitle => 'Seguridad de la Cuenta';

  @override
  String get accountSecurityChangePassword => 'Cambiar contraseña';

  @override
  String get accountSecurityTwoFactor => 'Autenticación en dos pasos';

  @override
  String get accountSecurityActiveSessions => 'Sesiones activas';

  @override
  String get accountSecurityDeleteAccount => 'Eliminar cuenta';

  @override
  String get purchaseHistoryTitle => 'Historial de Compras';

  @override
  String get purchaseHistoryEmpty => 'No hay compras todavía';

  @override
  String get purchaseHistoryGuarantee => 'Garantía de reembolso de 30 días';

  @override
  String get purchaseHistoryDate => 'Fecha de la transacción';

  @override
  String get purchaseHistoryStatus => 'Estado';

  @override
  String get purchaseHistoryAmount => 'Monto';

  @override
  String get purchaseHistoryCompleted => 'Completado';

  @override
  String get purchaseHistoryRefunded => 'Reembolsado';

  @override
  String get teachApplicationTitle => 'Enseñar en EduLab';

  @override
  String get teachApplicationSubmit => 'Enviar solicitud';

  @override
  String get teachApplicationSent => 'Tu solicitud fue enviada con éxito';

  @override
  String get notificationsTitle => 'Notificaciones';

  @override
  String get notificationsMarkAllRead => 'Marcar todo como leído';

  @override
  String get notificationsMarkAllReadSnackbar =>
      'Todas las notificaciones marcadas como leídas';

  @override
  String get notificationsEmpty => 'Sin notificaciones';

  @override
  String get notification1Title => 'Recordatorio: Continúa tu curso';

  @override
  String get notification1Message =>
      'Tienes una nueva lección en Flutter para principiantes';

  @override
  String get notification1Time => 'Hace 5 minutos';

  @override
  String get notification1Action => 'Continuar curso';

  @override
  String get notification2Title => '¡Tu certificado está listo!';

  @override
  String get notification2Message => 'Completaste el curso de Diseño UI/UX.';

  @override
  String get notification2Time => 'Hace 2 horas';

  @override
  String get notification2Action => 'Ver certificado';

  @override
  String get notification3Title => 'Oferta exclusiva para ti';

  @override
  String get notification3Message =>
      '70% de descuento en cursos de programación';

  @override
  String get notification3Time => 'Hace 1 día';

  @override
  String get notification3Action => 'Explorar oferta';

  @override
  String get notification4Title => 'Nueva respuesta a tu pregunta';

  @override
  String get notification4Message =>
      'El instructor respondió a tu pregunta en React Hooks';

  @override
  String get notification4Time => 'Hace 2 días';

  @override
  String get notification4Action => 'Ver respuesta';

  @override
  String get notification5Title => 'Actualización del curso';

  @override
  String get notification5Message =>
      'Se añadió nuevo contenido al curso de Python Avanzado';

  @override
  String get notification5Time => 'Hace 3 días';

  @override
  String get messagesTitle => 'Mensajes';

  @override
  String get settingsTitle => 'Configuración y Preferencias';

  @override
  String get settingsVideoDownload => 'Video y Descarga';

  @override
  String get settingsDownloadQuality => 'Calidad de descarga de video';

  @override
  String get settingsWifiOnly => 'Descargar solo con Wi-Fi';

  @override
  String get settingsNotifications => 'Notificaciones y Alertas';

  @override
  String get settingsCourseNotifications =>
      'Notificaciones de cursos y mensajes';

  @override
  String get settingsPromoNotifications => 'Ofertas y descuentos exclusivos';

  @override
  String get settingsAppearance => 'Apariencia e Idioma';

  @override
  String get settingsDarkMode => 'Modo Oscuro';

  @override
  String get settingsDarkModeEnabled => 'Activado (ahorra batería)';

  @override
  String get settingsDarkModeDisabled => 'Desactivado (modo claro)';

  @override
  String get settingsLanguage => 'Idioma de la aplicación';

  @override
  String get settingsStorage => 'Almacenamiento y Caché';

  @override
  String get settingsClearCache => 'Borrar caché';

  @override
  String get settingsClearCacheSuccess => 'Caché borrado con éxito';

  @override
  String get settingsHelp => 'Información y Políticas';

  @override
  String get settingsHelpCenter => 'Centro de ayuda y preguntas frecuentes';

  @override
  String get settingsTermsPrivacy => 'Términos de uso y Privacidad';

  @override
  String get settingsAbout => 'Acerca de EduLab';

  @override
  String get settingsVersion => 'Versión v1.0.0';

  @override
  String get quizTitle => 'Cuestionario';

  @override
  String get quizNext => 'Siguiente pregunta';

  @override
  String get quizSubmit => 'Enviar cuestionario';

  @override
  String get quizScore => 'Puntuación';

  @override
  String get quizCorrectAnswers => 'Respuestas correctas';

  @override
  String get scheduleTitle => 'Mi Horario';

  @override
  String get scheduleEmpty => 'No hay sesiones programadas';

  @override
  String get scheduleJoin => 'Unirse a la sesión';

  @override
  String get scheduleReminder => 'Recordatorio';

  @override
  String get assignmentsTitle => 'Tareas';

  @override
  String get assignmentsEmpty => 'No hay tareas';

  @override
  String get assignmentsSubmit => 'Entregar tarea';

  @override
  String get assignmentsDue => 'Fecha límite';

  @override
  String get assignmentsSubmitted => 'Entregado';

  @override
  String get assignmentsPending => 'Pendiente';

  @override
  String get languageArabic => 'Árabe';

  @override
  String get languageEnglish => 'Inglés';

  @override
  String get languageDialogTitle => 'Seleccionar idioma';

  @override
  String get languageSelect => 'Seleccionar';

  @override
  String get generalCancel => 'Cancelar';

  @override
  String get generalConfirm => 'Confirmar';

  @override
  String get generalSave => 'Guardar';

  @override
  String get generalDelete => 'Eliminar';

  @override
  String get generalEdit => 'Editar';

  @override
  String get generalClose => 'Cerrar';

  @override
  String get generalBack => 'Atrás';

  @override
  String get generalDone => 'Listo';

  @override
  String get generalOk => 'Aceptar';

  @override
  String get generalYes => 'Sí';

  @override
  String get generalNo => 'No';

  @override
  String get generalLoading => 'Cargando...';

  @override
  String get generalError => 'Ocurrió un error';

  @override
  String get generalRetry => 'Reintentar';

  @override
  String get generalNoInternet => 'Sin conexión a internet';

  @override
  String get generalFree => 'Gratis';

  @override
  String get generalRating => 'Calificación';

  @override
  String get generalStudents => 'Estudiantes';

  @override
  String get generalHours => 'Horas';

  @override
  String get generalMinutes => 'Minutos';

  @override
  String get generalBy => 'Por';

  @override
  String get navHome => 'Inicio';

  @override
  String get navExplore => 'Explorar';

  @override
  String get navMyCourses => 'Mis Cursos';

  @override
  String get navCart => 'Carrito';

  @override
  String get navAccount => 'Cuenta';

  @override
  String get homeSubGreeting => '¿Qué te gustaría aprender hoy?';

  @override
  String get homeVisitor => 'Invitado';

  @override
  String get homePromoTitle => 'Explora las ofertas ahora';

  @override
  String get homePromoSubtitle =>
      'Hasta un 70% de descuento en cursos destacados';

  @override
  String get homePromoButton => 'Descubrir ahora';

  @override
  String get homePromoBadge => 'Oferta exclusiva';

  @override
  String get homeContinueLearning => 'Continuar aprendiendo';

  @override
  String get homeMyCoursesLink => 'Mis cursos';

  @override
  String get homeLesson => 'lección';

  @override
  String homeStudentsCount(String count) {
    return '$count estudiantes';
  }

  @override
  String get homeRecommendedTitle => 'Recomendado para ti';

  @override
  String get homeRecommendedSubtitle => 'Personalizado según tus intereses';

  @override
  String get homeBestsellersTitle => 'Más vendidos';

  @override
  String get homeBestsellersSubtitle =>
      'Cursos mejor valorados y más populares';

  @override
  String get homeNewCoursesTitle => 'Nuevos cursos';

  @override
  String get homeNewCoursesSubtitle => 'Contenido fresco y actualizado';

  @override
  String get homePopularTopicsTitle => 'Temas populares';

  @override
  String get homePopularTopicsSubtitle =>
      'Comienza a aprender las habilidades más demandadas';

  @override
  String get homeTopInstructorsTitle => 'Mejores instructores';

  @override
  String get homeTopInstructorsSubtitle => 'Aprende de expertos certificados';

  @override
  String get homeExploreCategoriesTitle => 'Explorar categorías';

  @override
  String get homeExploreCategoriesSubtitle =>
      'Encuentra el curso adecuado para ti';

  @override
  String get catAll => 'Todos';

  @override
  String get catWebDev => 'Desarrollo Web';

  @override
  String get catMobileApps => 'Aplicaciones Móviles';

  @override
  String get catDataScience => 'Ciencia de Datos';

  @override
  String get catUIUX => 'Diseño UI/UX';

  @override
  String get catBusiness => 'Negocios';

  @override
  String get catAI => 'Inteligencia Artificial';

  @override
  String get catCyberSecurity => 'Ciberseguridad';

  @override
  String get exploreNoResultsTitle => 'No se encontraron resultados';

  @override
  String get exploreNoResultsSubtitle =>
      'Prueba con diferentes palabras clave o cambia el filtro';

  @override
  String get exploreRecentSearches => 'Búsquedas recientes';

  @override
  String get exploreTopSearches => 'Más buscados';

  @override
  String get exploreBrowseCategories => 'Explorar categorías';

  @override
  String get exploreBrowseCategoriesSubtitle =>
      'Encuentra el curso adecuado para ti';

  @override
  String get exploreBackToAll => 'Volver a todos';

  @override
  String get exploreClearAll => 'Borrar todo';

  @override
  String get exploreAvailableResults => 'resultados disponibles';

  @override
  String get exploreFilterBestseller => 'Más vendido';

  @override
  String get exploreFilterTopRated => 'Mejor valorado';

  @override
  String get exploreFilterUnder50 => 'Menos de \$50';

  @override
  String get learningHeroTitle => 'Continúa tu viaje de aprendizaje';

  @override
  String get learningSearchHint => 'Buscar en tus cursos...';

  @override
  String get learningFilterAll => 'Todos';

  @override
  String get learningFilterInProgress => 'En progreso';

  @override
  String get learningFilterCompleted => 'Completados';

  @override
  String get learningFilterDownloaded => 'Descargados';

  @override
  String get learningEmptyTitle => 'No hay cursos todavía';

  @override
  String get learningEmptySubtitle => 'Comienza a explorar cursos ahora';

  @override
  String get learningEmptySearch => 'Sin resultados para tu búsqueda';

  @override
  String get learningCompleted => 'Completado';

  @override
  String get learningCompletedBadge => 'Completado';

  @override
  String learningLecturesCount(int count) {
    return '$count lecciones';
  }

  @override
  String get cartEmptyTitle => 'Tu carrito está vacío';

  @override
  String get cartEmptySubtitle => 'Añade cursos para comenzar tu aprendizaje';

  @override
  String get cartCouponHint => 'Introduce código promocional';

  @override
  String get cartCouponApply => 'Aplicar';

  @override
  String get cartCouponInvalid => 'Código no válido';

  @override
  String get cartCouponApplied => 'Cupón aplicado';

  @override
  String get cartCouponDiscount => 'Descuento de cupón';

  @override
  String get cartCouponsTitle => 'Cupones';

  @override
  String get cartOrderSummary => 'Resumen del pedido';

  @override
  String get cartOriginalPrice => 'Precio original';

  @override
  String get cartPlatformDiscount => 'Descuento de plataforma';

  @override
  String get cartFinalTotal => 'Total';

  @override
  String cartItemsCount(int count) {
    return '$count cursos';
  }

  @override
  String get cartRemovedSnackbar => 'Curso eliminado del carrito';

  @override
  String get cartUndo => 'Deshacer';

  @override
  String get cartAddButton => 'Añadir al carrito';

  @override
  String get cartAddedSnackbar => 'Añadido al carrito';

  @override
  String get cartAlreadyInCart => 'Ya en el carrito';

  @override
  String get cartCheckoutButton => 'Proceder al pago';

  @override
  String get cartRecommendedTitle => 'También te puede gustar';

  @override
  String get cartRecommendedSubtitle => 'Cursos recomendados según tu carrito';

  @override
  String get checkoutCreditCard => 'Tarjeta de crédito';

  @override
  String get checkoutSelectPayment => 'Seleccionar método de pago';

  @override
  String get checkoutCardNumberLabel => 'Número de tarjeta';

  @override
  String get checkoutCardHolderLabel => 'Nombre del titular';

  @override
  String get checkoutExpiryLabel => 'Fecha de vencimiento';

  @override
  String get checkoutCVVLabel => 'CVV';

  @override
  String get checkoutPersonalInfoTitle => 'Información Personal';

  @override
  String get checkoutFullNameLabel => 'Nombre completo';

  @override
  String get checkoutFullNameHint => 'Tu nombre completo';

  @override
  String get checkoutFullNameRequired => 'El nombre completo es obligatorio';

  @override
  String get checkoutPhoneLabel => 'Teléfono';

  @override
  String get checkoutPhoneRequired => 'El teléfono es obligatorio';

  @override
  String get checkoutPostalLabel => 'Código Postal';

  @override
  String get checkoutPostalRequired => 'El código postal es obligatorio';

  @override
  String get checkoutBuyerInfo => 'Información del comprador';

  @override
  String get checkoutSaveInfo => 'Guardar información para la próxima vez';

  @override
  String get checkoutMoneyBackGuarantee => 'Garantía de reembolso de 30 días';

  @override
  String get checkoutContinueToPayment => 'Continuar al pago';

  @override
  String get checkoutContinueToReview => 'Continuar a la revisión';

  @override
  String get checkoutReviewConfirm => 'Revisar y confirmar';

  @override
  String get checkoutStartLearning => 'Empezar a aprender';

  @override
  String get checkoutBackHome => 'Volver al inicio';

  @override
  String get courseDetailsTitle => 'Detalles del Curso';

  @override
  String get courseDetailsShare => 'Compartir';

  @override
  String get courseDetailsWhatYouWillLearn => '¿Qué aprenderás?';

  @override
  String get courseDetailsLanguage => 'Idioma';

  @override
  String get courseDetailsCreatedBy => 'Creado por';

  @override
  String get courseDetailsPreviewLesson => 'Vista previa';

  @override
  String get courseDetailsHoursOnDemand => 'horas de video bajo demanda';

  @override
  String get courseDetailsFullLifetimeAccess => 'Acceso completo de por vida';

  @override
  String get courseDetailsCertifiedCertificate => 'Certificado de finalización';

  @override
  String get courseDetailsComprehensiveContent => 'Contenido completo';

  @override
  String get certTitle => 'Certificado de Finalización';

  @override
  String get certStudentNameLabel => 'Estudiante';

  @override
  String get certCourseLabel => 'Curso';

  @override
  String get certInstructorLabel => 'Instructor';

  @override
  String get certIssueDateLabel => 'Fecha de emisión';

  @override
  String get certCodeLabel => 'ID de certificado';

  @override
  String get certVerifiedBadge => 'Verificado';

  @override
  String get certDownloadPDF => 'Descargar PDF';

  @override
  String get certDownloadPNG => 'Descargar imagen';

  @override
  String get certCopyVerifyLink => 'Copiar enlace de verificación';

  @override
  String get certShare => 'Compartir certificado';

  @override
  String get playerTabLessons => 'Lecciones';

  @override
  String get playerTabOverview => 'Descripción general';

  @override
  String get playerTabNotes => 'Mis notas';

  @override
  String get playerTabQnA => 'Preguntas y respuestas';

  @override
  String get playerNextLesson => 'Siguiente lección';

  @override
  String get profileWelcome => 'Bienvenido';

  @override
  String get profileLoginPrompt => 'Inicia sesión para acceder a tu perfil';

  @override
  String get profileLoginOrRegister => 'Iniciar Sesión / Crear Cuenta';

  @override
  String get profileVerifiedStudent => 'Estudiante verificado';

  @override
  String get profileLogout => 'Cerrar Sesión';

  @override
  String get profileCancel => 'Cancelar';

  @override
  String get profileLogoutConfirmTitle => 'Cerrar Sesión';

  @override
  String get profileLogoutConfirmMessage =>
      '¿Estás seguro de que deseas cerrar sesión?';

  @override
  String get profileAccountSettings => 'Configuración de la cuenta';

  @override
  String get profileEditProfileSubtitle => 'Edita tu información personal';

  @override
  String get profileSecurity => 'Seguridad de la cuenta';

  @override
  String get profileSecuritySubtitle => 'Contraseña y verificación';

  @override
  String get profilePurchaseHistory => 'Historial de compras';

  @override
  String get profilePurchaseHistorySubtitle => 'Ver historial de transacciones';

  @override
  String get profileCertificatesSubtitle => 'Tus certificados obtenidos';

  @override
  String get profileTeach => 'Enseñar en EduLab';

  @override
  String get profileTeachSubtitle => 'Comparte tu experiencia con otros';

  @override
  String get profilePreferences => 'Preferencias';

  @override
  String get profilePreferencesSubtitle => 'Configuración y apariencia';

  @override
  String get profileNotifications => 'Notificaciones';

  @override
  String get profileNotificationsSubtitle => 'Gestionar notificaciones';

  @override
  String get profileHelpSupport => 'Ayuda y Soporte';

  @override
  String get profileTerms => 'Términos de Uso';

  @override
  String get profilePrivacy => 'Política de Privacidad';

  @override
  String get profileAboutEduLab => 'Acerca de EduLab';

  @override
  String get profileWishlist => 'Lista de deseos';

  @override
  String get securityTitle => 'Seguridad de la Cuenta';

  @override
  String get teachTitle => 'Enseñar en EduLab';

  @override
  String get notificationsTabAll => 'Todas';

  @override
  String get notificationsTabCourses => 'Cursos';

  @override
  String get notificationsTabPromos => 'Ofertas';

  @override
  String get notificationsEmptyTitle => 'Sin notificaciones';

  @override
  String get notificationsUnread => 'No leído';

  @override
  String get wishlistTitle => 'Lista de Deseos';

  @override
  String get wishlistEmptyTitle => 'Tu lista de deseos está vacía';

  @override
  String get wishlistEmptySubtitle => 'Guarda los cursos que te interesen';

  @override
  String get wishlistAddToCart => 'Añadir al carrito';

  @override
  String get wishlistRemovedSnackbar => 'Eliminado de la lista de deseos';

  @override
  String get homeDefaultUser => 'Estudiante';

  @override
  String get learningOf => 'de';

  @override
  String get cartInCartBadge => 'En el carrito';

  @override
  String get homePromo1Badge => 'Gran oferta • Tiempo limitado';

  @override
  String get homePromo1Title => 'Comienza a aprender a los mejores precios';

  @override
  String get homePromo1Subtitle =>
      'Hasta un 65% de descuento en cursos de programación, diseño y negocios.';

  @override
  String get homePromo1Button => 'Ver ofertas';

  @override
  String get homePromo2Badge => 'Rutas profesionales certificadas';

  @override
  String get homePromo2Title => 'Prepárate para la carrera de tus sueños';

  @override
  String get homePromo2Subtitle =>
      'Cursos de cero a experto con proyectos reales y certificaciones.';

  @override
  String get homePromo2Button => 'Explorar rutas';

  @override
  String get homePromo3Badge => 'Instructores expertos';

  @override
  String get homePromo3Title => 'Aprende directamente de profesionales';

  @override
  String get homePromo3Subtitle =>
      'Contenido actualizado continuamente para dominar las últimas tecnologías.';

  @override
  String get homePromo3Button => 'Empezar ahora';

  @override
  String get homeSearchFilter => 'Filtrar';

  @override
  String get securitySectionChangePassword => 'Cambiar contraseña';

  @override
  String get securityCurrentPasswordLabel => 'Contraseña actual *';

  @override
  String get securityCurrentPasswordError => 'Introduce la contraseña actual';

  @override
  String get securityNewPasswordLabel => 'Nueva contraseña *';

  @override
  String get securityNewPasswordError => 'Debe tener al menos 8 caracteres';

  @override
  String get securityConfirmPasswordLabel => 'Confirmar nueva contraseña *';

  @override
  String get securityConfirmPasswordError => 'Las contraseñas no coinciden';

  @override
  String get securityUpdatePasswordBtn => 'Actualizar contraseña';

  @override
  String get securityPasswordUpdatedSuccess =>
      '¡Contraseña cambiada con éxito!';

  @override
  String get securitySection2FA => 'Autenticación de dos factores (2FA)';

  @override
  String get security2FATitle => 'Autenticación de dos factores';

  @override
  String get security2FAEnabledDesc =>
      'Activada - Protege tu cuenta con un código';

  @override
  String get security2FADisabledDesc => 'Desactivada (Recomendado)';

  @override
  String get security2FASetupTitle => 'Activar autenticación de dos factores';

  @override
  String get security2FASetupContent =>
      'Se enviará un código de verificación de 6 dígitos a tu correo electrónico en cada nuevo inicio de sesión.';

  @override
  String get security2FAEnableNow => 'Activar ahora';

  @override
  String get security2FAEnabledSuccess =>
      '¡Autenticación de dos factores activada con éxito!';

  @override
  String get security2FADisabledSuccess =>
      'Autenticación de dos factores desactivada';

  @override
  String get securitySectionSessions => 'Sesiones y dispositivos activos';

  @override
  String get securityLogoutAllDevices =>
      'Cerrar sesión en todos los dispositivos';

  @override
  String get securityThisDevice => 'Este dispositivo';

  @override
  String get securitySessionRevokedSuccess =>
      'Sesión finalizada y dispositivo desconectado.';

  @override
  String get securityAllSessionsRevokedSuccess =>
      'Sesión cerrada en todos los demás dispositivos.';

  @override
  String get purchaseHistoryInvoiceCertified =>
      'Factura electrónica certificada';

  @override
  String get purchaseHistoryInvoiceNumber => 'Número de factura';

  @override
  String get purchaseHistoryCourse => 'Curso';

  @override
  String get purchaseHistoryPaymentMethod => 'Método de pago';

  @override
  String get purchaseHistoryTotalAmount => 'Monto total:';

  @override
  String get purchaseHistoryClose => 'Cerrar';

  @override
  String get purchaseHistoryDownloadPdf => 'Descargar PDF';

  @override
  String get purchaseHistoryPdfDownloaded =>
      'Factura en PDF descargada con éxito';

  @override
  String get purchaseHistoryRefundRequestTitle => 'Solicitud de reembolso';

  @override
  String get purchaseHistoryRefundPolicy =>
      'De acuerdo con la garantía de 30 días de EduLab, puedes obtener un reembolso completo.';

  @override
  String get purchaseHistoryRefundReasonHint =>
      'Motivo del reembolso (opcional)...';

  @override
  String get purchaseHistoryConfirmRefund => 'Confirmar reembolso';

  @override
  String get purchaseHistoryRefundSubmitted =>
      'Solicitud de reembolso enviada con éxito (3-5 días laborables).';

  @override
  String get purchaseHistoryInstructor => 'Instructor';

  @override
  String get purchaseHistoryRequestRefundBtn => 'Solicitar reembolso';

  @override
  String get purchaseHistoryInvoiceBtn => 'Factura';

  @override
  String get purchaseHistoryStatusCompleted => 'Completado';

  @override
  String get purchaseHistoryStatusRefunded => 'Reembolsado';

  @override
  String get purchaseHistoryStatusProcessingRefund => 'Procesando reembolso';

  @override
  String get editProfileSectionBasicInfo => 'Información básica';

  @override
  String get editProfileFullNameLabel => 'Nombre completo *';

  @override
  String get editProfileFullNameHint => 'Introduce tu nombre completo';

  @override
  String get editProfileFullNameError =>
      'Por favor, introduce tu nombre completo';

  @override
  String get editProfileHeadlineLabel => 'Título profesional';

  @override
  String get editProfileHeadlineHint => 'ej. Desarrollador Flutter Senior';

  @override
  String get editProfileLocationLabel => 'Ciudad / País';

  @override
  String get editProfileLocationHint => 'Madrid, España';

  @override
  String get editProfilePhoneLabel => 'Teléfono móvil';

  @override
  String get editProfileBioLabel => 'Sobre mí (Biografía)';

  @override
  String get editProfileBioHint =>
      'Escribe un breve resumen de tus intereses y experiencia...';

  @override
  String get editProfileSectionLinks => 'Enlaces y redes profesionales';

  @override
  String get editProfileWebsiteLabel => 'Sitio web personal';

  @override
  String get editProfileSectionEmail => 'Correo electrónico registrado';

  @override
  String get editProfileEmailDesc =>
      'Vinculado a tu cuenta para iniciar sesión y recibir certificados';

  @override
  String get editProfileEmailVerified => 'Verificado';

  @override
  String get editProfileSaveChangesBtn => 'Guardar cambios';

  @override
  String get editProfileSavedSuccess => '¡Perfil actualizado con éxito!';

  @override
  String get editProfileChangeAvatarTitle => 'Cambiar foto de perfil';

  @override
  String get editProfileTakePhoto => 'Hacer una foto';

  @override
  String get editProfileChooseGallery => 'Elegir de la galería';

  @override
  String get editProfilePhotoUpdatedSuccess =>
      'Foto de perfil actualizada con éxito';

  @override
  String get teachJoinInstructorTitle => 'Únete como instructor';

  @override
  String get teachJoinInstructorSubtitle =>
      'Publica tus cursos y comparte tu experiencia con miles de estudiantes.';

  @override
  String get teachStep1Title => 'Datos personales';

  @override
  String get teachStep2Title => 'Experiencia y habilidades';

  @override
  String get teachStep3Title => 'Confirmación';

  @override
  String get teachStep1Header => '1. Información personal y profesional';

  @override
  String get teachFullNameArabicLabel => 'Nombre completo *';

  @override
  String get teachFullNameArabicHint => 'ej. Juan Pérez';

  @override
  String get teachHeadlineLabel => 'Título profesional y especialidad *';

  @override
  String get teachHeadlineHint =>
      'ej. Arquitecto de software senior e instructor Flutter';

  @override
  String get teachPhoneLabel => 'Número de teléfono *';

  @override
  String get teachCountryLabel => 'País de residencia *';

  @override
  String get teachBioLabel => 'Presentación y experiencia previa *';

  @override
  String get teachBioHint =>
      'Escribe un breve resumen de tu trayectoria y proyectos...';

  @override
  String get teachNextStepSkills => 'Continuar: Experiencia y habilidades';

  @override
  String get teachStep2Header => '2. Contenido del curso y habilidades';

  @override
  String get teachTopicLabel => 'Tema o ruta del curso propuesto *';

  @override
  String get teachTopicHint => 'ej. Desarrollo Flutter desde cero';

  @override
  String get teachYearsExperienceLabel => 'Años de experiencia en el sector *';

  @override
  String get teachVideoLinkLabel =>
      'Enlace a video de muestra (YouTube/Drive/Loom) *';

  @override
  String get teachTargetAudienceLabel => 'Público objetivo del curso *';

  @override
  String get teachAudienceBeginners => 'Principiantes absolutos';

  @override
  String get teachAudienceIntermediate => 'Principiantes e intermedios';

  @override
  String get teachAudienceAdvanced => 'Avanzados y profesionales';

  @override
  String get teachAudienceAll => 'Todos los niveles';

  @override
  String get teachSkillsCoveredLabel =>
      'Habilidades y tecnologías que cubrirá el curso *';

  @override
  String get teachAddSkillHint => 'Añadir habilidad (ej. GraphQL)...';

  @override
  String get teachAddSkillBtn => 'Añadir';

  @override
  String get teachNextStepConfirm => 'Continuar: Confirmar solicitud';

  @override
  String get teachStep3Header => '3. Detalles de pago y términos';

  @override
  String get teachPayoutMethodLabel => 'Método para recibir ingresos *';

  @override
  String get teachPayoutMethodBank => 'Transferencia bancaria directa (IBAN)';

  @override
  String get teachPayoutMethodPaypal => 'Cuenta de PayPal verificada';

  @override
  String get teachPayoutMethodPayoneer => 'Tarjeta Payoneer';

  @override
  String get teachIbanDetailsLabel => 'Datos de cuenta / IBAN *';

  @override
  String get teachApplicationSummary => 'Resumen de la solicitud:';

  @override
  String get teachApplicantName => 'Candidato';

  @override
  String get teachApplicantHeadline => 'Especialidad';

  @override
  String get teachApplicantTopic => 'Tema del curso';

  @override
  String get teachApplicantSkillsCount => 'Habilidades añadidas';

  @override
  String get teachSkillsUnit => 'habilidades';

  @override
  String get teachAgreeTermsLabel =>
      'Acepto los términos, condiciones y acuerdo de propiedad intelectual de EduLab.';

  @override
  String get teachSubmitApplicationBtn => 'Enviar solicitud de instructor';

  @override
  String get teachPrevStepBtn => 'Anterior';

  @override
  String get teachWhyEduLabTitle => '¿Por qué enseñar con EduLab?';

  @override
  String get teachProp1Title => 'Ingresos justos y atractivos';

  @override
  String get teachProp1Desc =>
      'Obtén hasta un 80% de las ventas de tus cursos sin tarifas ocultas.';

  @override
  String get teachProp2Title => 'Llega a miles de estudiantes';

  @override
  String get teachProp2Desc =>
      'Promociona tu curso ante una gran comunidad educativa activa.';

  @override
  String get teachProp3Title => 'Soporte técnico y de producción completo';

  @override
  String get teachProp3Desc =>
      'Nuestro equipo te ayuda a optimizar audio, video y diseño curricular.';

  @override
  String get teachSuccessDialogTitle => '¡Solicitud recibida con éxito!';

  @override
  String get teachSuccessDialogDesc =>
      'Gracias por unirte a la comunidad de instructores de EduLab. Nuestro equipo revisará tu solicitud y se pondrá en contacto en 48 horas.';

  @override
  String get teachSuccessDialogOk => 'Entendido';

  @override
  String get teachAddOneSkillError => 'Por favor, añade al menos una habilidad';

  @override
  String get teachAgreeTermsError =>
      'Debes aceptar los términos y condiciones de instructor';

  @override
  String get commonCancel => 'Cancelar';

  @override
  String get commonClose => 'Cerrar';

  @override
  String get myCertificatesBannerTitle => 'Certificados Acreditados';

  @override
  String get myCertificatesBannerSubtitle =>
      'Todos los certificados están acreditados y verificados con una identificación única de EduLab';

  @override
  String get certBadgeVerified100 => '100% Acreditado';

  @override
  String get certCodeCopied => 'Código de certificado copiado';

  @override
  String get certGrantedTo => 'Otorgado a';

  @override
  String get certViewAndDownload => 'Ver y descargar certificado';

  @override
  String get certIssuerLabel => 'Autoridad emisora';

  @override
  String get certIssuerName => 'Academia de Aprendizaje Interactivo EduLab';

  @override
  String get certEmptyTitle => 'Aún no has obtenido certificados';

  @override
  String get certEmptyDesc =>
      'Completa el 100% de cualquier curso inscrito para recibir un certificado acreditado con un ID de verificación oficial.';

  @override
  String get certEmptyAction => 'Continuar mis cursos';

  @override
  String get certDetailsTitle => 'Detalles e información del certificado';

  @override
  String get certCopyLinkSuccess =>
      '¡Enlace de verificación directa copiado al portapapeles!';

  @override
  String get certShareSuccess =>
      '¡Detalles del certificado y enlace copiados para compartir!';

  @override
  String get purchaseHistoryTaxInvoiceCertified =>
      'Factura fiscal oficial certificada';

  @override
  String get purchaseHistoryInvoiceNumberLabel => 'N.º de pedido / factura';

  @override
  String get purchaseHistoryCourseNameLabel => 'Nombre del curso';

  @override
  String get purchaseHistoryPurchaseDateLabel => 'Fecha de compra';

  @override
  String get purchaseHistoryPaymentMethodLabel => 'Método de pago';

  @override
  String get purchaseHistoryPaymentMethodValue =>
      'Tarjeta de crédito / Stripe (Online)';

  @override
  String get purchaseHistoryOrderStatusLabel => 'Estado del pedido';

  @override
  String get purchaseHistoryStatusPendingReview => 'Reembolso en revisión';

  @override
  String get purchaseHistoryCopyInvoiceBtn => 'Copiar número de factura';

  @override
  String get purchaseHistoryRefundReasonLabel =>
      'Motivo de la solicitud de reembolso:';

  @override
  String get purchaseHistoryRefundReasonEmptyError =>
      'Por favor, introduce el motivo de tu solicitud de reembolso';

  @override
  String get purchaseHistorySubmittingRefund => 'Enviando solicitud...';

  @override
  String get purchaseHistoryPaidDate => 'Fecha de pago';

  @override
  String get purchaseHistoryEmptyTitle => 'Aún no tienes historial de compras';

  @override
  String get purchaseHistoryEmptyDesc =>
      'Aún no has comprado ningún curso.\nTus pedidos y facturas aparecerán aquí una vez completados.';

  @override
  String get purchaseHistoryExploreCourses => 'Explorar cursos ahora';

  @override
  String get profileMyCourses => 'Mis Cursos';

  @override
  String get profileMyCoursesSubtitle =>
      'Seguir el progreso de tus cursos inscritos';

  @override
  String get profileWishlistSubtitle =>
      'Cursos guardados en tu lista de deseos';

  @override
  String get navMyLearning => 'Mi Aprendizaje';

  @override
  String get profileLogoutSafeNote =>
      'Tus datos, cursos y certificados están totalmente a salvo. Puedes continuar aprendiendo en cualquier momento volviendo a iniciar sesión.';

  @override
  String learningRemainingHours(String hours) {
    return '$hours horas restantes';
  }

  @override
  String get learningCompletedFull => 'Completado';

  @override
  String get learningFilterNotStarted => 'No Iniciado';

  @override
  String get wishlistTopRatedBadge => 'Mejor valorado';

  @override
  String get wishlistFeaturedBadge => 'Destacado';

  @override
  String wishlistDiscountBadge(String percent) {
    return '$percent% de descuento';
  }

  @override
  String get courseFree => 'Gratis';

  @override
  String get badgeBestseller => 'Más vendido';

  @override
  String get badgeTopRated => 'Mejor valorado';

  @override
  String get badgeFeatured => 'Destacado';

  @override
  String get badgeRecommended => 'Recomendado para ti';

  @override
  String get badgeNew => 'Nuevo';

  @override
  String get courseWord => 'Curso';

  @override
  String coursesCountText(String count) {
    return '$count+ Cursos';
  }

  @override
  String studentsCountText(String count) {
    return '$count Estudiantes';
  }

  @override
  String hoursCountText(String count) {
    return '$count Horas';
  }

  @override
  String get certifiedInstructor => 'Instructor Certificado';

  @override
  String get expertCertifiedInstructor => 'Experto e Instructor Certificado';

  @override
  String get defaultCourseTitle => 'Curso Educativo';

  @override
  String get categoryWord => 'Categoría';

  @override
  String get previewCourseVideo => 'Vista previa del video';

  @override
  String get freeSection => 'Sección Gratuita';

  @override
  String get freeDemoVideo => 'Video de Demostración';

  @override
  String get articleLecture => 'Lección de Artículo';

  @override
  String get articleViewer => 'Lector de Artículos';

  @override
  String get courseVideoPlayer => 'Reproductor de Video';

  @override
  String get playingNow => 'Reproduciendo ahora';

  @override
  String get readingNow => 'Leyendo ahora';

  @override
  String get noLecturesInFreeSection =>
      'No hay lecciones en la sección gratuita';

  @override
  String freeLecturesCount(String count) {
    return '$count lecciones gratuitas';
  }

  @override
  String get enrollInFullCourse => 'Inscribirse en el curso completo';

  @override
  String get articleWord => 'Artículo';

  @override
  String get videoWord => 'Video';

  @override
  String get quizWord => 'Cuestionario';

  @override
  String get courseShareCopied => '¡Enlace del curso copiado al portapapeles!';

  @override
  String get addedToCartSnackbar => 'Añadido al carrito';

  @override
  String get viewCartAction => 'Ver Carrito';

  @override
  String get inCartBadge => 'En el Carrito ✓';

  @override
  String get addToCartButton => 'Añadir al Carrito';

  @override
  String get wishlistAddedSnackbar => 'Curso añadido a la lista de deseos';

  @override
  String get wishlistRemovedSuccessSnackbar =>
      'Curso eliminado de la lista de deseos';

  @override
  String get lessonCompletedAll =>
      '¡Felicidades! Has completado todas las lecciones del curso.';

  @override
  String get noteAddedSuccess => 'Nota guardada con éxito';

  @override
  String get lessonAlreadyDownloaded =>
      'La lección ya está guardada sin conexión';

  @override
  String get lessonLinkCopied => 'Enlace de la lección copiado';

  @override
  String get contentReportThanks =>
      'Gracias por tus comentarios, revisaremos la lección.';

  @override
  String get courseCompletionCertificate => 'Certificado de Finalización';

  @override
  String get reportContentIssue => 'Reportar problema de contenido';

  @override
  String get loginOrSocial => 'O iniciar sesión con';

  @override
  String get loginSuccessSnackbar => 'Sesión iniciada con éxito';

  @override
  String get cartClearDialogTitle => 'Vaciar carrito';

  @override
  String get cartClearDialogMessage =>
      '¿Seguro que deseas eliminar todos los cursos del carrito?';

  @override
  String get cartClearConfirmButton => 'Vaciar';

  @override
  String get guestWelcomeTitle => 'Bienvenido a EduLab';

  @override
  String get guestWelcomeSubtitle =>
      'Inicia sesión para ver tus cursos y certificados';

  @override
  String get securitySetup2FATitle =>
      'Configuración de autenticación en dos pasos (2FA)';

  @override
  String get securityScanQRCode =>
      'Escanea el código QR con tu app de autenticación';

  @override
  String get securitySecretKeyManual => 'Clave secreta (entrada manual)';

  @override
  String get securitySecretKeyCopied => 'Clave secreta copiada';

  @override
  String get securityEnter6DigitCode => 'Ingresa el código de 6 dígitos:';

  @override
  String get securityConfirmEnable2FABtn => 'Confirmar y activar 2FA';

  @override
  String get securityEnter6DigitsError =>
      'Por favor ingresa el código de 6 dígitos';

  @override
  String get securityLogoutAllDevicesTitle =>
      'Cerrar sesión en todos los dispositivos';

  @override
  String get securityLogoutAllDevicesMessage =>
      '¿Seguro que deseas cerrar sesión en todos los demás dispositivos?';

  @override
  String get securityLogoutAllDevicesConfirmBtn => 'Cerrar todo';

  @override
  String get securityDisable2FAModalTitle => 'Desactivar 2FA';

  @override
  String get securityDisable2FAModalMessage =>
      'Desactivar esto reducirá la seguridad. ¿Continuar?';

  @override
  String get securityDisable2FAConfirmBtn => 'Desactivar 2FA';

  @override
  String get securityNoOtherSessions => 'No hay otras sesiones activas';

  @override
  String get securityCurrentDeviceOnly =>
      'Sesión iniciada solo en este dispositivo';

  @override
  String get securityShowLessDevices => 'Mostrar menos';

  @override
  String securityShowAllDevicesCount(String count) {
    return 'Mostrar todos ($count)';
  }

  @override
  String get securityUpdatingPassword => 'Actualizando contraseña...';

  @override
  String get editProfileTakePhotoDesc => 'Tomar foto con la cámara';

  @override
  String get editProfileChooseGalleryDesc => 'Elegir foto de la galería';

  @override
  String get editProfileHeadlineError => 'El titular es obligatorio';

  @override
  String get editProfileLocationError => 'La ubicación es obligatoria';

  @override
  String get editProfilePhoneError => 'El teléfono es obligatorio';

  @override
  String get editProfileBioError => 'La biografía es obligatoria';

  @override
  String get editProfileSavingChanges => 'Guardando cambios...';

  @override
  String get themeLight => 'Claro';

  @override
  String get themeDark => 'Oscuro';

  @override
  String get themeSystem => 'Sistema';

  @override
  String get teachFullNameRequired => 'Ingresa tu nombre completo';

  @override
  String get teachHeadlineRequired => 'Ingresa tu título profesional';

  @override
  String get teachPhoneRequired => 'Ingresa tu teléfono';

  @override
  String get teachCountryRequired => 'Ingresa tu país';

  @override
  String get teachBioMinLength =>
      'La biografía debe tener al menos 20 caracteres';

  @override
  String get teachSubmittingApplication => 'Enviando...';

  @override
  String get wishlistFailedAddToCart => 'No se pudo añadir al carrito';

  @override
  String get cartClearAllTitle => '¿Borrar todos los artículos del carrito?';

  @override
  String cartClearAllMessage(String count) {
    return '¿Está seguro de que desea eliminar todos los $count cursos de su carrito de compras?';
  }

  @override
  String get cartClearAllHint =>
      'Todos los cursos serán eliminados de su carrito. Puedes volver a agregarlos en cualquier momento.';

  @override
  String cartClearAllConfirm(String count) {
    return 'Borrar todo ($count)';
  }

  @override
  String get cartClearedSuccess => 'Carrito borrado exitosamente';

  @override
  String get cartClearFailed => 'No se pudo borrar el carrito';

  @override
  String cartViewWishlistCount(String count) {
    return 'Ver artículos de la lista de deseos ($count)';
  }

  @override
  String get cartGoToWishlist => 'Ir a la lista de deseos';

  @override
  String get wishlistClearAllTitle =>
      '¿Borrar todos los artículos de la lista de deseos?';

  @override
  String wishlistClearAllMessage(String count) {
    return '¿Está seguro de que desea eliminar todos los $count cursos de su lista de deseos?';
  }

  @override
  String get wishlistClearAllHint =>
      'Se borrarán todos los cursos guardados. Puedes volver a agregarlos en cualquier momento desde Explorar.';

  @override
  String wishlistClearAllConfirm(String count) {
    return 'Borrar todo ($count)';
  }

  @override
  String get wishlistClearedSuccess => 'Lista de deseos borrada exitosamente';

  @override
  String get wishlistClearFailed => 'No se pudo borrar la lista de deseos';

  @override
  String get wishlistClearTooltip => 'Borrar todo';

  @override
  String wishlistViewCartCount(String count) {
    return 'Ver artículos del carrito ($count)';
  }

  @override
  String get wishlistGoToCart => 'Ir al carrito';

  @override
  String get checkoutCardNumberInvalid =>
      'Por favor ingrese un número de tarjeta válido de 16 dígitos';

  @override
  String get checkoutCardExpiryInvalidFormat =>
      'Ingrese una fecha de vencimiento de tarjeta válida (MM / AA)';

  @override
  String get checkoutCardExpiredDate =>
      'La fecha de vencimiento de la tarjeta no es válida';

  @override
  String get checkoutCardCvcInvalid =>
      'Ingrese un código CVC válido de 3 o 4 dígitos';

  @override
  String get checkoutCardHolderNameRequired =>
      'Por favor ingrese el nombre del titular de la tarjeta';

  @override
  String get checkoutCartEmptySnackbar => 'El carrito de compras está vacío.';

  @override
  String get checkoutPaymentStartFailed => 'No se pudo iniciar el pago';

  @override
  String get checkoutClientSecretMissing =>
      'No se recibió la clave de seguridad de la pasarela de pago';

  @override
  String get checkoutCardVerificationFailed =>
      'Error en la verificación de la tarjeta';

  @override
  String get checkoutStripeProcessingFailed =>
      'Error al procesar el pago de Stripe';

  @override
  String get checkoutServerConfirmationFailed =>
      'Error en la confirmación del pago del servidor';

  @override
  String get checkoutEmptyCartTitle => 'Tu carrito está vacío';

  @override
  String get checkoutEmptyCartDesc =>
      'Aún no has agregado ningún curso a tu carrito. ¡Explora nuestros cursos y comienza a aprender!';

  @override
  String get checkoutContinueFreeReview => 'Continuar a la revisión gratuita';

  @override
  String get checkoutFreeOrderBadge => 'Pedido 100% gratuito (zsh.00)';

  @override
  String get checkoutFreeOrderNotice =>
      'Este pedido no requiere ninguna información de pago. Puede proceder directamente para confirmar la inscripción.';

  @override
  String get checkoutFreeCheckoutTitle => 'Pago 100% gratuito';

  @override
  String get checkoutConfirmFreeEnrollment => 'Confirmar inscripción gratuita';

  @override
  String get checkoutFreePrice => 'Gratis';

  @override
  String get checkoutFreeZero => 'Gratis (zsh.00)';

  @override
  String checkoutCoursesCount(String count) {
    return '$count cursos';
  }

  @override
  String get notificationsClearAllTitle => '¿Borrar todas las notificaciones?';

  @override
  String notificationsClearAllMessage(String count) {
    return '¿Está seguro de que desea eliminar todas las $count notificaciones? Esta acción no se puede deshacer.';
  }

  @override
  String get notificationsClearAllHint =>
      'Todas tus notificaciones se eliminarán y tu bandeja de entrada comenzará de nuevo.';

  @override
  String notificationsClearAllConfirm(String count) {
    return 'Borrar todo ($count)';
  }

  @override
  String get notificationsClearSuccess =>
      'Todas las notificaciones se borraron correctamente';

  @override
  String get notificationsClearFailed =>
      'No se pudieron borrar las notificaciones';

  @override
  String get notificationsClearTooltip => 'Borrar todo';

  @override
  String get notificationsViewDetails => 'Ver detalles';

  @override
  String get notificationsEmptyCategoryTitle =>
      'No hay notificaciones en esta categoría.';

  @override
  String get notificationsEmptyCategorySubtitle =>
      'Intente cambiar a otra categoría o explore todas las notificaciones';

  @override
  String get notificationsEmptyAllSubtitle =>
      'Lo mantendremos informado con las últimas actualizaciones y alertas aquí.';

  @override
  String get notificationsViewAll => 'Ver todas las notificaciones';

  @override
  String get learningFilterAndSortTitle => 'Filtrar y ordenar cursos';

  @override
  String get learningFilterReset => 'Reiniciar';

  @override
  String get learningSortByTitle => 'Ordenar por';

  @override
  String get learningSortRecentActivity => 'Accedido recientemente';

  @override
  String get learningSortRecentEnrolled => 'Inscrito recientemente';

  @override
  String get learningSortTitleAZ => 'Título (A-Z)';

  @override
  String get learningSortProgress => 'Progreso %';

  @override
  String get learningStatusTitle => 'Estado del curso';

  @override
  String get learningStatusAll => 'Todos los cursos';

  @override
  String get learningStatusInProgress => 'En curso';

  @override
  String get learningStatusCompleted => 'Completado';

  @override
  String get learningStatusNotStarted => 'No iniciado';

  @override
  String get learningFilterApply => 'Aplicar filtros';

  @override
  String get learningSearchCoursesHint => 'Buscar en tus cursos...';

  @override
  String get learningSearchWishlistHint => 'Buscar en lista de deseos...';

  @override
  String get learningSearchCertificatesHint => 'Buscar certificados...';

  @override
  String get learningTabMyCourses => 'Mis cursos';

  @override
  String get learningTabFavourite => 'Mis favoritos';

  @override
  String get learningTabCertificates => 'Mis certificados';

  @override
  String get learningNoCoursesTitle => 'Aún no hay cursos';

  @override
  String get learningNoCoursesSubtitle =>
      'Explora miles de cursos premium y comienza tu viaje de aprendizaje hoy mismo';

  @override
  String get learningFilterButton => 'Filtrar';

  @override
  String learningFilterAllCount(String count) {
    return 'Todos ($count)';
  }

  @override
  String get learningStatusNotStartedShort => 'No iniciado';

  @override
  String get learningNoMatchTitle => 'No hay cursos que coincidan';

  @override
  String learningNoMatchSubtitle(String query) {
    return 'No se encontraron cursos que contengan \"$query\". Intenta buscar con otros términos.';
  }

  @override
  String get learningNoInProgressTitle => 'No hay cursos en progreso';

  @override
  String get learningNoInProgressSubtitle =>
      'Comienza a ver lecciones en tus cursos inscritos para seguir tu progreso aquí.';

  @override
  String get learningNoCompletedTitle => 'Aún no hay cursos completados';

  @override
  String get learningNoCompletedSubtitle =>
      'Continúa tus estudios para celebrar tu progreso y ver los cursos completados aquí.';

  @override
  String get learningNoUnstartedTitle => 'No hay cursos sin iniciar';

  @override
  String get learningNoUnstartedSubtitle =>
      '¡Excelente! Ya has comenzado a aprender en todos tus cursos inscritos.';

  @override
  String get learningNoFilterMatchTitle =>
      'Ningún curso coincide con este filtro';

  @override
  String get learningNoFilterMatchSubtitle =>
      'Cambia las opciones de filtro o de ordenación para mostrar tus cursos.';

  @override
  String learningViewAllCoursesCount(String count) {
    return 'Ver todos los cursos ($count)';
  }

  @override
  String learningSavedCoursesCount(String count) {
    return 'Cursos guardados ($count)';
  }

  @override
  String get learningClearAllSaved => 'Borrar todo';

  @override
  String get learningNoCertificatesTitle => 'Aún no hay certificados';

  @override
  String get learningNoCertificatesSubtitle =>
      'Completa tus cursos para obtener certificados acreditados que certifiquen tus logros';

  @override
  String get learningGoToCourses => 'Ir a mis cursos';

  @override
  String learningCertIssuedDate(String date) {
    return 'Emitido: $date';
  }

  @override
  String get learningCertView => 'Ver';

  @override
  String get learningResumeLesson => 'Reanudar lección';

  @override
  String learningProgressPercentComplete(String percent) {
    return '$percent% completado';
  }

  @override
  String learningViewCartCount(String count) {
    return 'Ver artículos del carrito ($count)';
  }

  @override
  String get learningGoToCart => 'Ir al carrito';

  @override
  String get playerLessonMarkedCompleted => 'Lección marcada como completada ✓';

  @override
  String get playerLessonMarkedIncomplete => 'Lección marcada como incompleta';

  @override
  String get playerCommentPostedSuccess => 'Comentario publicado con éxito';

  @override
  String get playerCommentPostFailed => 'Error al publicar el comentario';

  @override
  String get playerReplyPostedSuccess => 'Respuesta publicada con éxito';

  @override
  String get playerReplyPostFailed => 'Error al publicar la respuesta';

  @override
  String get playerCourseNotFound => 'Curso no encontrado';

  @override
  String get playerCheckEnrollmentPrompt =>
      'Por favor, verifica primero tu inscripción al curso';

  @override
  String get playerReturnToCourses => 'Mi aprendizaje';

  @override
  String get playerWatchLecture => 'Clase del curso';

  @override
  String get playerCertificateTooltip => 'Certificado';

  @override
  String get playerRateCourseTooltip => 'Calificar curso';

  @override
  String get playerReadingArticleBadge => 'Artículo de lectura • 5 min';

  @override
  String get playerReadFullTextBelow => 'Lee el texto completo abajo ↓';

  @override
  String get playerTabReviews => 'Reseñas';

  @override
  String get playerNoSectionsAvailable => 'No hay secciones disponibles';

  @override
  String playerLessonsCount(String count) {
    return '$count lecciones';
  }

  @override
  String get playerPlayingBadge => 'Reproduciendo';

  @override
  String get playerArticleBadge => 'Artículo';

  @override
  String get playerVideoBadge => 'Video';

  @override
  String get playerFullArticleContent => 'Contenido completo del artículo';

  @override
  String get playerArticlePlaceholder =>
      'Bienvenido a esta lección de lectura.\n\nEsta sección cubre los conceptos fundamentales y los pasos prácticos que necesitas para dominar las habilidades de esta lección.';

  @override
  String get playerAboutCourseTitle => 'Acerca de este curso';

  @override
  String get playerShowLess => 'Mostrar menos';

  @override
  String get playerReadMore => 'Leer más';

  @override
  String get playerWhatYouWillLearn => 'Lo que aprenderás';

  @override
  String get playerCourseInfoTitle => 'Detalles del curso';

  @override
  String get playerTotalDurationTitle => 'Duración total';

  @override
  String get playerTotalLessonsTitle => 'Total de lecciones';

  @override
  String playerLessonsNumber(String count) {
    return '$count lecciones';
  }

  @override
  String get playerLevelTitle => 'Nivel';

  @override
  String get playerAllLevels => 'Todos los niveles';

  @override
  String get playerLanguageTitle => 'Idioma';

  @override
  String get playerLanguageArabic => 'Árabe';

  @override
  String get playerPrerequisitesTitle => 'Requisitos del curso';

  @override
  String get playerCertificateCardTitle => 'Certificado del curso';

  @override
  String get playerCourseCompletedSuccess => '¡Felicidades! Curso completado';

  @override
  String get playerProgressLabel => 'Progreso';

  @override
  String get playerViewCertificateBtn => 'Ver certificado';

  @override
  String get playerCertifiedInstructor => 'Instructor certificado';

  @override
  String playerDiscussionsCount(String count) {
    return '$count preguntas y debates';
  }

  @override
  String get playerAskQuestionHint => 'Escribe tu pregunta o consulta aquí...';

  @override
  String get playerPostBtn => 'Publicar';

  @override
  String get playerNoDiscussionsTitle => 'No hay debates todavía';

  @override
  String get playerNoDiscussionsSubtitle =>
      '¡Sé el primero en hacer una pregunta!';

  @override
  String get playerInstructorBadge => 'Instructor';

  @override
  String get playerCancelReply => 'Cancelar';

  @override
  String get playerReplyAction => 'Responder';

  @override
  String playerRepliesCount(String count) {
    return '$count respuestas';
  }

  @override
  String get playerWriteReplyHint => 'Escribe tu respuesta...';

  @override
  String get playerSendReplyBtn => 'Responder';

  @override
  String get playerCourseFeedbackTitle =>
      'Calificación y comentarios del curso';

  @override
  String get playerOutOf5 => 'de 5';

  @override
  String playerRatingsFromEnrolledCount(String count) {
    return '$count calificaciones de estudiantes inscritos';
  }

  @override
  String get playerKeepLearningToRate => 'Sigue aprendiendo para calificar';

  @override
  String get playerRateAfter80Hint =>
      'Podrás calificar y opinar sobre este curso tras completar el 80% de su contenido';

  @override
  String get playerCurrentProgressLabel => 'Tu progreso:';

  @override
  String get playerYourCurrentRating => 'Tu calificación';

  @override
  String get playerEditRating => 'Editar calificación';

  @override
  String get playerDeleteRatingTooltip => 'Eliminar calificación';

  @override
  String get playerUpdateRatingTitle => 'Actualizar tu calificación';

  @override
  String get playerRateCourseTitle => 'Calificar este curso';

  @override
  String get playerWriteReviewHint =>
      'Escribe tus comentarios sobre la calidad del contenido (opcional)...';

  @override
  String get playerRatingSubmitSuccess => '¡Calificación enviada con éxito!';

  @override
  String get playerRatingSubmitFailed => 'Error al enviar la calificación';

  @override
  String get playerSaveChangesBtn => 'Guardar cambios';

  @override
  String get playerSubmitReviewBtn => 'Enviar opinión';

  @override
  String get playerLearnerReviewsTitle => 'Opiniones de los estudiantes';

  @override
  String playerReviewsCount(String count) {
    return '$count reseñas';
  }

  @override
  String get playerNoWrittenReviewsTitle => 'Sin opiniones escritas por ahora';

  @override
  String get playerNoWrittenReviewsSubtitle =>
      '¡Sé el primero en compartir tu opinión!';

  @override
  String get playerRatingLabel5 => 'Excelente 🌟 (5/5)';

  @override
  String get playerRatingLabel4 => 'Muy bueno 👍 (4/5)';

  @override
  String get playerRatingLabel3 => 'Promedio 👌 (3/5)';

  @override
  String get playerRatingLabel2 => 'Necesita mejorar 🤔 (2/5)';

  @override
  String get playerRatingLabel1 => 'Malo 👎 (1/5)';

  @override
  String get playerDeleteRatingDialogTitle => 'Eliminar calificación';

  @override
  String get playerDeleteRatingDialogMessage =>
      '¿Seguro que deseas eliminar tu opinión sobre este curso?';

  @override
  String get playerDeleteConfirmBtn => 'Eliminar';

  @override
  String get playerRatingDeleteSuccess => 'Calificación eliminada con éxito';

  @override
  String get playerPreviousLesson => 'Lección anterior';

  @override
  String get playerExitFullscreenTooltip => 'Salir de pantalla completa';

  @override
  String instructorsAvailableCount(String count) {
    return '$count instructores disponibles';
  }

  @override
  String get instructorsNotFound => 'No se encontraron instructores';

  @override
  String instructorsCoursesCount(String count) {
    return '$count cursos';
  }

  @override
  String get instructorsSearchHint =>
      'Buscar por nombre del instructor o especialidad...';

  @override
  String get instructorsSortAll => 'Todo';

  @override
  String get instructorsSortTopRated => 'Mejor valorados';

  @override
  String get instructorsSortMostStudents => 'La mayoría de los estudiantes';

  @override
  String get instructorsSortMostCourses => 'La mayoría de los cursos';

  @override
  String get instructorsNotFoundSubtitle =>
      'Intente buscar con un nombre diferente o borre los filtros';

  @override
  String get exploreCompleteCourse => 'Curso Integral';

  @override
  String get exploreGeneralCategory => 'General';

  @override
  String courseShareMessage(String title, String url) {
    return 'Consulta el curso \"$title\" en EduLab: $url';
  }

  @override
  String get courseDetailsDefaultTitle => 'Detalles del curso';

  @override
  String get courseDetailsTooltipShare => 'Compartir';

  @override
  String get courseDetailsTooltipWishlist => 'Lista de deseos';

  @override
  String get courseDetailsTooltipCart => 'Carro';

  @override
  String get courseDetailsNotFound => 'Curso no encontrado';

  @override
  String get courseDetailsDefaultCategory => 'Curso';

  @override
  String courseDetailsTotalRatingsCount(String count) {
    return '($count calificaciones)';
  }

  @override
  String courseDetailsLecturesCount(String count) {
    return '$count conferencias';
  }

  @override
  String get courseDetailsCertificateBadge => 'Certificado';

  @override
  String get courseDetailsTabOverview => 'Descripción general';

  @override
  String get courseDetailsTabCurriculum => 'Plan de estudios';

  @override
  String get courseDetailsTabInstructor => 'Instructor';

  @override
  String get courseDetailsTabReviews => 'Reseñas';

  @override
  String get courseDetailsFullDescriptionTitle => 'Descripción';

  @override
  String get courseDetailsShowLess => 'Mostrar menos';

  @override
  String get courseDetailsShowMore => 'Mostrar más...';

  @override
  String courseDetailsCurriculumSectionsLectures(
    String sections,
    String lectures,
  ) {
    return '$sections secciones • $lectures conferencias';
  }

  @override
  String get courseDetailsCollapseAll => 'Contraer todo';

  @override
  String get courseDetailsExpandAll => 'Expandir todo';

  @override
  String get courseDetailsCurriculumComingSoon =>
      'Próximamente detalles del plan de estudios';

  @override
  String courseDetailsSectionLecturesCount(String count) {
    return '$count conferencias';
  }

  @override
  String get courseDetailsLecturePreviewBtn => 'Avance';

  @override
  String get courseDetailsDefaultInstructorTitle =>
      'Instructor senior y experto certificado';

  @override
  String get courseDetailsInstructorRatingLabel => 'Clasificación';

  @override
  String get courseDetailsInstructorStudentsLabel => 'Estudiantes';

  @override
  String get courseDetailsInstructorSectionsLabel => 'Secciones';

  @override
  String get courseDetailsAboutInstructorTitle => 'Acerca del instructor:';

  @override
  String get courseDetailsDefaultInstructorAbout =>
      'Instructor certificado con amplia experiencia en brindar educación profesional a miles de estudiantes en todo el mundo.';

  @override
  String courseDetailsStudentRatingsCount(String count) {
    return '$count calificaciones de estudiantes';
  }

  @override
  String get courseDetailsNoWrittenReviews => 'Aún no hay reseñas escritas';

  @override
  String get courseDetailsRelatedCourses =>
      'Cursos relacionados que te pueden gustar';

  @override
  String courseDetailsDiscountPercent(String percent) {
    return '$percent% DE DESCUENTO';
  }

  @override
  String get courseDetailsResumeCourse => 'Reanudar curso';

  @override
  String get courseDetailsTryAgain => 'Intentar otra vez';

  @override
  String get courseDetailsEstimatedReading => '📖 Lectura estimada: 4 minutos';

  @override
  String get courseDetailsSampleArticleContent =>
      'Bienvenido a la conferencia de este artículo.\n\nEsta sección cubre conceptos teóricos clave y pasos prácticos para dominar la materia.\n\n• Conclusiones clave:\n1. Comprender la terminología básica y los patrones arquitectónicos.\n2. Ejercicios prácticos y práctica continua.\n3. Referencia de notas y tareas complementarias.\n\n¡Disfruta leyendo!';

  @override
  String certDownloadedSuccess(String course, String format) {
    return '¡El certificado para \"$course\" se descargó correctamente en formato $format!';
  }

  @override
  String certVerifiedFullRequirements(String code) {
    return 'ID de verificación: $code • 100% de requisitos completados';
  }

  @override
  String get certCompletionTitle => 'Certificado de finalización';

  @override
  String get certCompletionSubtitle => 'Certificado de finalización del curso';

  @override
  String get certAnnounceStudent =>
      'EducationLab Learning Academy certifica por la presente que:';

  @override
  String get certCompletionRequirementsMet =>
      'Ha completado con éxito todos los requisitos del curso de formación:';

  @override
  String certIssueDateText(String date) {
    return 'Fecha de emisión: $date';
  }

  @override
  String certIdNumberText(String code) {
    return 'ID de certificado: $code';
  }

  @override
  String get certPlatformManagement => 'Gestión de plataforma';

  @override
  String get certInstructorRoleTitle => 'Instructor del curso';

  @override
  String get commonLoading => 'Cargando...';

  @override
  String get homeGuestTagline =>
      'Plataforma inteligente de aprendizaje y desarrollo de habilidades';

  @override
  String get catTagHighestDemand => 'Mayor demanda';

  @override
  String get catTagMostPopular => 'Más popular';

  @override
  String get catTagTrending => 'Tendencia';

  @override
  String get catTagFastestGrowing => 'Crecimiento rápido';

  @override
  String get catTagHighDemand => 'Muy solicitado';

  @override
  String get catTagTopRated => 'Mejor valorados';

  @override
  String get catTagEssential => 'Esencial';

  @override
  String get catTagAdvanced => 'Nivel avanzado';

  @override
  String get catTagEntrepreneurs => 'Emprendedores';

  @override
  String get catTagSalesGrowth => 'Crecimiento de ventas';

  @override
  String get catDevTitle => 'Programación y desarrollo de software';

  @override
  String get catDevSubtitle => 'Ingeniería de software, sistemas y algoritmos';

  @override
  String get catWebTitle => 'Desarrollo Web';

  @override
  String get catWebSubtitle => 'Desarrollo Frontend, Backend y Fullstack';

  @override
  String get catMobileTitle => 'Desarrollo de aplicaciones móviles';

  @override
  String get catMobileSubtitle => 'Apps móviles con Flutter, iOS y Android';

  @override
  String get catAiTitle => 'Inteligencia Artificial';

  @override
  String get catAiSubtitle => 'Aprendizaje automático, Deep Learning e IA';

  @override
  String get catDataTitle => 'Ciencia de datos y analítica';

  @override
  String get catDataSubtitle => 'Análisis de datos, estadística y Big Data';

  @override
  String get catDesignTitle => 'Diseño UI/UX y de producto';

  @override
  String get catDesignSubtitle => 'UI/UX, prototipado y diseño de productos';

  @override
  String get catSecurityTitle => 'Ciberseguridad y redes';

  @override
  String get catSecuritySubtitle => 'Ciberseguridad, hacking ético y redes';

  @override
  String get catCloudTitle => 'Computación en la nube y DevOps';

  @override
  String get catCloudSubtitle => 'Infraestructura en la nube, DevOps y CI/CD';

  @override
  String get catBusinessTitle => 'Gestión empresarial y de proyectos';

  @override
  String get catBusinessSubtitle =>
      'Emprendimiento, metodologías ágiles y liderazgo';

  @override
  String get catMarketingTitle => 'Marketing Digital';

  @override
  String get catMarketingSubtitle => 'Marketing digital, SEO y crecimiento';

  @override
  String get timeJustNow => 'Ahora mismo';

  @override
  String timeMinutesAgo(String count) {
    return 'hace $count min';
  }

  @override
  String timeHoursAgo(String count) {
    return 'hace $count h';
  }

  @override
  String timeDaysAgo(String count) {
    return 'hace $count días';
  }

  @override
  String timeWeeksAgo(String count) {
    return 'hace $count semanas';
  }

  @override
  String timeMonthsAgo(String count) {
    return 'hace $count meses';
  }

  @override
  String wishlistLecturesCount(String count) {
    return '$count lecciones';
  }
}

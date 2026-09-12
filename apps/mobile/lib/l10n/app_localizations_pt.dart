// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get onboardingSkip => 'Pular';

  @override
  String get onboardingTitle1 => 'Bem-vindo ao EduLab';

  @override
  String get onboardingSubtitle1 =>
      'Sua plataforma ideal para aprendizado interativo moderno e crescimento profissional contínuo.';

  @override
  String get onboardingTitle2 => 'Aprenda com os melhores instrutores';

  @override
  String get onboardingSubtitle2 =>
      'Milhares de cursos profissionais em programação, design, negócios e ciência de dados.';

  @override
  String get onboardingTitle3 => 'Certificados e sucesso garantido';

  @override
  String get onboardingSubtitle3 =>
      'Acompanhe seu progresso, passe nos testes e obtenha certificados reconhecidos.';

  @override
  String get onboardingNext => 'Próximo';

  @override
  String get onboardingStart => 'Começar agora';

  @override
  String get splashAppName => 'Education Lab';

  @override
  String get splashTagline => 'Plataforma de Aprendizagem Inteligente';

  @override
  String get loginTagline =>
      'Bem-vindo à plataforma de aprendizagem inteligente';

  @override
  String get loginAppName => 'EduLab';

  @override
  String get loginTabLogin => 'Entrar';

  @override
  String get loginTabRegister => 'Criar Conta';

  @override
  String get loginEmailLabel => 'E-mail';

  @override
  String get loginEmailHint => 'exemplo@email.com';

  @override
  String get loginPasswordLabel => 'Senha';

  @override
  String get loginPasswordHint => '••••••';

  @override
  String get loginForgotPassword => 'Esqueceu a senha?';

  @override
  String get loginSubmit => 'Entrar';

  @override
  String get loginSubmitLoading => 'Entrando';

  @override
  String get loginGuest => 'Entrar como convidado';

  @override
  String get loginOr => 'ou';

  @override
  String get loginEmailRequired => 'O e-mail é obrigatório';

  @override
  String get loginEmailInvalid => 'Insira um e-mail válido';

  @override
  String get loginPasswordRequired => 'A senha é obrigatória';

  @override
  String get registerStepEmail => 'E-mail';

  @override
  String get registerStepCode => 'Código';

  @override
  String get registerStepData => 'Dados';

  @override
  String get registerSendCodeInfo =>
      'Enviaremos um código de ativação para este e-mail';

  @override
  String get registerSendCode => 'Enviar código de ativação';

  @override
  String get registerVerifying => 'Verificando';

  @override
  String get registerCodeSentTo => 'Código enviado para:';

  @override
  String get registerResendCode => 'Reenviar código';

  @override
  String get registerBack => 'Voltar';

  @override
  String get registerVerifyCode => 'Confirmar código';

  @override
  String get registerCodeIncomplete => 'Insira o código completo de 6 dígitos';

  @override
  String get registerFullNameLabel => 'Nome completo';

  @override
  String get registerFullNameHint => 'Seu nome completo';

  @override
  String get registerPasswordHint =>
      'Pelo menos 8 caracteres, uma maiúscula e um número';

  @override
  String get registerConfirmLabel => 'Confirmar senha';

  @override
  String get registerConfirmHint => 'Digite a senha novamente';

  @override
  String get registerSubmit => 'Criar conta';

  @override
  String get registerSubmitLoading => 'Criando conta';

  @override
  String get registerSuccess => 'Conta criada com sucesso';

  @override
  String get registerNameRequired => 'O nome completo é obrigatório';

  @override
  String get registerNameMinLength => 'O nome deve ter pelo menos 6 caracteres';

  @override
  String get registerPasswordMinLength =>
      'A senha deve ter pelo menos 8 caracteres';

  @override
  String get registerPasswordUppercase =>
      'A senha deve conter pelo menos uma letra maiúscula';

  @override
  String get registerPasswordNumber =>
      'A senha deve conter pelo menos um número';

  @override
  String get registerConfirmRequired => 'A confirmação de senha é obrigatória';

  @override
  String get registerConfirmMismatch => 'As senhas não coincidem';

  @override
  String get networkError => 'Erro de conexão, tente novamente';

  @override
  String homeGreeting(String name) {
    return 'Olá, $name!';
  }

  @override
  String get homeSubtitle => 'O que você quer aprender hoje?';

  @override
  String get homeSearchHint => 'Buscar curso ou habilidade...';

  @override
  String get homeSectionContinue => 'Continuar aprendendo';

  @override
  String get homeSectionRecommended => 'Recomendado para você';

  @override
  String get homeSectionPopular => 'Mais populares';

  @override
  String get homeSectionTopRated => 'Mais bem avaliados';

  @override
  String get homeSectionByCategory => 'Por categoria';

  @override
  String get homeHeroTitle => 'Explore as ofertas agora';

  @override
  String get homeHeroSubtitle => 'Até 70% de desconto em cursos selecionados';

  @override
  String get homeHeroButton => 'Descobrir agora';

  @override
  String get homeViewAll => 'Ver tudo';

  @override
  String get homeProgressLabel => 'Concluído';

  @override
  String get exploreTitle => 'Explorar Cursos';

  @override
  String get exploreSearchHint => 'Buscar curso, habilidade ou instrutor...';

  @override
  String get exploreAllCategories => 'Todas as categorias';

  @override
  String get exploreFilter => 'Filtrar';

  @override
  String get exploreSort => 'Ordenar';

  @override
  String get exploreNoResults => 'Nenhum resultado encontrado';

  @override
  String get exploreNoResultsHint =>
      'Tente palavras-chave diferentes ou altere os filtros';

  @override
  String exploreCoursesCount(int count) {
    return '$count cursos';
  }

  @override
  String get exploreFilterTitle => 'Filtrar resultados';

  @override
  String get exploreFilterApply => 'Aplicar filtro';

  @override
  String get exploreFilterReset => 'Redefinir';

  @override
  String get exploreFilterPrice => 'Preço';

  @override
  String get exploreFilterLevel => 'Nível';

  @override
  String get exploreFilterRating => 'Avaliação';

  @override
  String get exploreFilterDuration => 'Duração';

  @override
  String get exploreSortTitle => 'Ordenar por';

  @override
  String get exploreSortRelevance => 'Mais relevante';

  @override
  String get exploreSortNewest => 'Mais recente';

  @override
  String get exploreSortPopular => 'Mais popular';

  @override
  String get exploreSortRating => 'Melhor avaliação';

  @override
  String get exploreSortPriceLow => 'Preço: menor para maior';

  @override
  String get exploreSortPriceHigh => 'Preço: maior para menor';

  @override
  String get explorePriceFree => 'Gratuito';

  @override
  String get exploreLevelBeginner => 'Iniciante';

  @override
  String get exploreLevelIntermediate => 'Intermediário';

  @override
  String get exploreLevelAdvanced => 'Avançado';

  @override
  String get learningTitle => 'Meu Aprendizado';

  @override
  String get learningTabInProgress => 'Em andamento';

  @override
  String get learningTabCompleted => 'Concluído';

  @override
  String get learningTabSaved => 'Salvo';

  @override
  String get learningEmpty => 'Nenhum curso ainda';

  @override
  String get learningEmptyHint => 'Comece a explorar cursos agora';

  @override
  String get learningExploreButton => 'Explorar Cursos';

  @override
  String learningProgress(int percent) {
    return '$percent% concluído';
  }

  @override
  String get learningContinue => 'Continuar';

  @override
  String get learningViewCertificate => 'Ver Certificado';

  @override
  String get learningReview => 'Avaliar curso';

  @override
  String get learningLesson => 'Aula';

  @override
  String get learningLessons => 'Aulas';

  @override
  String get cartTitle => 'Carrinho';

  @override
  String get cartEmpty => 'Seu carrinho está vazio';

  @override
  String get cartEmptyHint => 'Adicione cursos para começar a aprender';

  @override
  String get cartExploreButton => 'Explorar Cursos';

  @override
  String get cartPromoPlaceholder => 'Código promocional';

  @override
  String get cartPromoApply => 'Aplicar';

  @override
  String get cartPromoInvalid => 'Código inválido';

  @override
  String get cartSummary => 'Resumo do pedido';

  @override
  String get cartSubtotal => 'Subtotal';

  @override
  String get cartDiscount => 'Desconto';

  @override
  String get cartTotal => 'Total';

  @override
  String get cartCheckout => 'Finalizar compra';

  @override
  String cartCourses(int count) {
    return '$count cursos';
  }

  @override
  String get cartRemove => 'Remover';

  @override
  String get cartGuarantee => 'Garantia de 30 dias de reembolso';

  @override
  String get checkoutTitle => 'Finalizar Compra';

  @override
  String get checkoutStepPayment => 'Pagamento';

  @override
  String get checkoutStepReview => 'Revisão';

  @override
  String get checkoutStepConfirm => 'Confirmação';

  @override
  String get checkoutOrderSummary => 'Resumo do pedido';

  @override
  String get checkoutTotal => 'Total';

  @override
  String get checkoutPayNow => 'Pagar agora';

  @override
  String get checkoutBack => 'Voltar';

  @override
  String get checkoutNext => 'Próximo';

  @override
  String get checkoutSecureSSL =>
      'Pagamento seguro com criptografia SSL de 256 bits';

  @override
  String get checkoutSuccessTitle => 'Compra realizada com sucesso!';

  @override
  String get checkoutSuccessSubtitle => 'Agora você já pode acessar seu curso';

  @override
  String get checkoutGoToLearning => 'Ir para Meus Cursos';

  @override
  String get checkoutPaymentMethod => 'Forma de pagamento';

  @override
  String get checkoutCardNumber => 'Número do cartão';

  @override
  String get checkoutCardName => 'Nome no cartão';

  @override
  String get checkoutCardExpiry => 'Validade';

  @override
  String get checkoutCardCVV => 'CVV';

  @override
  String get courseDetailsEnroll => 'Matricular-se agora';

  @override
  String get courseDetailsBuyNow => 'Comprar agora';

  @override
  String get courseDetailsAddToCart => 'Adicionar ao carrinho';

  @override
  String get courseDetailsAddedToCart => 'Adicionado ao carrinho';

  @override
  String get courseDetailsAlreadyEnrolled => 'Já matriculado';

  @override
  String get courseDetailsGoToCourse => 'Ir para o curso';

  @override
  String get courseDetailsFree => 'Gratuito';

  @override
  String courseDetailsStudents(String count) {
    return '$count alunos';
  }

  @override
  String get courseDetailsRating => 'Avaliação';

  @override
  String get courseDetailsReviews => 'avaliações';

  @override
  String get courseDetailsLastUpdated => 'Última atualização';

  @override
  String get courseDetailsCurriculum => 'Conteúdo do curso';

  @override
  String get courseDetailsSection => 'seção';

  @override
  String get courseDetailsLessons => 'aulas';

  @override
  String get courseDetailsInstructor => 'Instrutor';

  @override
  String get courseDetailsStudentsLabel => 'Alunos';

  @override
  String get courseDetailsCoursesLabel => 'Cursos';

  @override
  String get courseDetailsReviewsLabel => 'Avaliações';

  @override
  String get courseDetailsReviewsTitle => 'Avaliações dos alunos';

  @override
  String get courseDetailsWhatLearn => 'O que você aprenderá';

  @override
  String get courseDetailsRequirements => 'Requisitos';

  @override
  String get courseDetailsDescription => 'Descrição do curso';

  @override
  String get courseDetailsIncludesTitle => 'Este curso inclui';

  @override
  String get courseDetailsHoursVideo => 'horas de vídeo';

  @override
  String get courseDetailsArticles => 'artigos';

  @override
  String get courseDetailsMobileAccess => 'Acesso no celular e tablet';

  @override
  String get courseDetailsCertificate => 'Certificado de conclusão';

  @override
  String get courseDetailsLifetimeAccess => 'Acesso vitalício';

  @override
  String get lessonPlayerNotes => 'Minhas anotações';

  @override
  String get lessonPlayerResources => 'Recursos';

  @override
  String get lessonPlayerDiscussion => 'Discussão';

  @override
  String get lessonPlayerPrev => 'Anterior';

  @override
  String get lessonPlayerNext => 'Próximo';

  @override
  String get lessonPlayerSpeed => 'Velocidade';

  @override
  String get lessonPlayerQuality => 'Qualidade';

  @override
  String get lessonPlayerCompleted => 'Aula concluída';

  @override
  String get certificateTitle => 'Certificado de Conclusão';

  @override
  String get certificatePresentedTo => 'Concedido a';

  @override
  String get certificateCompletedCourse => 'por concluir com êxito o curso';

  @override
  String get certificateIssuedOn => 'Emitido em';

  @override
  String get certificateVerificationId => 'Código de verificação';

  @override
  String get certificateDownloadPDF => 'Baixar PDF';

  @override
  String get certificateDownloadPNG => 'Baixar imagem';

  @override
  String get certificateCopyLink => 'Copiar link de verificação';

  @override
  String get certificateLinkCopied => 'Link copiado';

  @override
  String get profileTitle => 'Perfil';

  @override
  String get profileEditProfile => 'Editar Perfil';

  @override
  String get profileCourses => 'Meus Cursos';

  @override
  String get profileCertificates => 'Certificados';

  @override
  String get profilePoints => 'Pontos';

  @override
  String get profileFollowers => 'Seguidores';

  @override
  String get profileFollowing => 'Seguindo';

  @override
  String get profileBio => 'Biografia';

  @override
  String get profileInstructor => 'Instrutor';

  @override
  String get profileStudent => 'Aluno';

  @override
  String get profileLevel => 'Nível';

  @override
  String get profileJoined => 'Membro desde';

  @override
  String get profileShareProfile => 'Compartilhar perfil';

  @override
  String get profileMenuLearning => 'Meus Cursos';

  @override
  String get profileMenuCertificates => 'Meus Certificados';

  @override
  String get profileMenuPurchaseHistory => 'Histórico de Compras';

  @override
  String get profileMenuTeachApplication => 'Ensine no EduLab';

  @override
  String get profileMenuAccountSecurity => 'Segurança da Conta';

  @override
  String get profileMenuNotifications => 'Notificações';

  @override
  String get profileMenuMessages => 'Mensagens';

  @override
  String get profileMenuSettings => 'Configurações';

  @override
  String get profileMenuSchedule => 'Minha Agenda';

  @override
  String get profileMenuAssignments => 'Tarefas';

  @override
  String get profileMenuQuiz => 'Testes';

  @override
  String get profileMenuLogout => 'Sair';

  @override
  String get profileLogoutConfirm => 'Tem certeza de que deseja sair?';

  @override
  String get profileLogoutYes => 'Sim, sair';

  @override
  String get profileLogoutNo => 'Cancelar';

  @override
  String get editProfileTitle => 'Editar Perfil';

  @override
  String get editProfileSave => 'Salvar alterações';

  @override
  String get editProfileFullName => 'Nome completo';

  @override
  String get editProfileBio => 'Biografia';

  @override
  String get editProfileEmail => 'E-mail';

  @override
  String get editProfilePhone => 'Telefone';

  @override
  String get editProfileWebsite => 'Site';

  @override
  String get editProfileSaved => 'Alterações salvas com sucesso';

  @override
  String get accountSecurityTitle => 'Segurança da Conta';

  @override
  String get accountSecurityChangePassword => 'Alterar senha';

  @override
  String get accountSecurityTwoFactor => 'Autenticação em duas etapas';

  @override
  String get accountSecurityActiveSessions => 'Sessões ativas';

  @override
  String get accountSecurityDeleteAccount => 'Excluir conta';

  @override
  String get purchaseHistoryTitle => 'Histórico de Compras';

  @override
  String get purchaseHistoryEmpty => 'Nenhuma compra realizada ainda';

  @override
  String get purchaseHistoryGuarantee => 'Garantia de 30 dias de reembolso';

  @override
  String get purchaseHistoryDate => 'Data da transação';

  @override
  String get purchaseHistoryStatus => 'Status';

  @override
  String get purchaseHistoryAmount => 'Montante';

  @override
  String get purchaseHistoryCompleted => 'Concluído';

  @override
  String get purchaseHistoryRefunded => 'Reembolsado';

  @override
  String get teachApplicationTitle => 'Ensine no EduLab';

  @override
  String get teachApplicationSubmit => 'Enviar candidatura';

  @override
  String get teachApplicationSent => 'Sua candidatura foi enviada com sucesso';

  @override
  String get notificationsTitle => 'Notificações';

  @override
  String get notificationsMarkAllRead => 'Marcar tudo como lido';

  @override
  String get notificationsMarkAllReadSnackbar =>
      'Todas as notificações foram marcadas como lidas';

  @override
  String get notificationsEmpty => 'Sem notificações';

  @override
  String get notification1Title => 'Lembrete: Continue seu curso';

  @override
  String get notification1Message =>
      'Você tem uma nova aula em Flutter para Iniciantes';

  @override
  String get notification1Time => 'Há 5 minutos';

  @override
  String get notification1Action => 'Continuar curso';

  @override
  String get notification2Title => 'Seu certificado está pronto!';

  @override
  String get notification2Message => 'Você concluiu o curso de UI/UX Design.';

  @override
  String get notification2Time => 'Há 2 horas';

  @override
  String get notification2Action => 'Ver certificado';

  @override
  String get notification3Title => 'Oferta exclusiva para você';

  @override
  String get notification3Message => '70% de desconto em cursos de programação';

  @override
  String get notification3Time => 'Há 1 dia';

  @override
  String get notification3Action => 'Ver oferta';

  @override
  String get notification4Title => 'Nova resposta para você';

  @override
  String get notification4Message => 'O instrutor respondeu à sua pergunta';

  @override
  String get notification4Time => 'Há 2 dias';

  @override
  String get notification4Action => 'Ver resposta';

  @override
  String get notification5Title => 'Atualização do curso';

  @override
  String get notification5Message =>
      'Novo conteúdo foi adicionado ao curso de Python';

  @override
  String get notification5Time => 'Há 3 dias';

  @override
  String get messagesTitle => 'Mensagens';

  @override
  String get settingsTitle => 'Configurações e Preferências';

  @override
  String get settingsVideoDownload => 'Vídeo e Download';

  @override
  String get settingsDownloadQuality => 'Qualidade padrão de download';

  @override
  String get settingsWifiOnly => 'Baixar apenas via Wi-Fi';

  @override
  String get settingsNotifications => 'Notificações e Alertas';

  @override
  String get settingsCourseNotifications =>
      'Notificações de cursos e mensagens';

  @override
  String get settingsPromoNotifications => 'Ofertas e descontos exclusivos';

  @override
  String get settingsAppearance => 'Aparência e Idioma';

  @override
  String get settingsDarkMode => 'Modo Escuro';

  @override
  String get settingsDarkModeEnabled => 'Ativado (economiza bateria)';

  @override
  String get settingsDarkModeDisabled => 'Desativado (modo claro)';

  @override
  String get settingsLanguage => 'Idioma do aplicativo';

  @override
  String get settingsStorage => 'Armazenamento e Cache';

  @override
  String get settingsClearCache => 'Limpar cache';

  @override
  String get settingsClearCacheSuccess => 'Cache limpo com sucesso';

  @override
  String get settingsHelp => 'Informações e Políticas';

  @override
  String get settingsHelpCenter => 'Central de ajuda e FAQ';

  @override
  String get settingsTermsPrivacy => 'Termos de uso e Privacidade';

  @override
  String get settingsAbout => 'Sobre o EduLab';

  @override
  String get settingsVersion => 'Versão v1.0.0';

  @override
  String get quizTitle => 'Teste';

  @override
  String get quizNext => 'Próxima pergunta';

  @override
  String get quizSubmit => 'Enviar teste';

  @override
  String get quizScore => 'Pontuação';

  @override
  String get quizCorrectAnswers => 'Respostas corretas';

  @override
  String get scheduleTitle => 'Minha Agenda';

  @override
  String get scheduleEmpty => 'Nenhuma sessão agendada';

  @override
  String get scheduleJoin => 'Entrar na sessão';

  @override
  String get scheduleReminder => 'Lembrete';

  @override
  String get assignmentsTitle => 'Tarefas';

  @override
  String get assignmentsEmpty => 'Nenhuma tarefa';

  @override
  String get assignmentsSubmit => 'Entregar tarefa';

  @override
  String get assignmentsDue => 'Prazo de entrega';

  @override
  String get assignmentsSubmitted => 'Entregue';

  @override
  String get assignmentsPending => 'Pendente';

  @override
  String get languageArabic => 'Árabe';

  @override
  String get languageEnglish => 'Inglês';

  @override
  String get languageDialogTitle => 'Selecionar idioma';

  @override
  String get languageSelect => 'Selecionar';

  @override
  String get generalCancel => 'Cancelar';

  @override
  String get generalConfirm => 'Confirmar';

  @override
  String get generalSave => 'Salvar';

  @override
  String get generalDelete => 'Excluir';

  @override
  String get generalEdit => 'Editar';

  @override
  String get generalClose => 'Fechar';

  @override
  String get generalBack => 'Voltar';

  @override
  String get generalDone => 'Concluído';

  @override
  String get generalOk => 'OK';

  @override
  String get generalYes => 'Sim';

  @override
  String get generalNo => 'Não';

  @override
  String get generalLoading => 'Carregando...';

  @override
  String get generalError => 'Ocorreu um erro';

  @override
  String get generalRetry => 'Tentar novamente';

  @override
  String get generalNoInternet => 'Sem conexão com a internet';

  @override
  String get generalFree => 'Gratuito';

  @override
  String get generalRating => 'Avaliação';

  @override
  String get generalStudents => 'Alunos';

  @override
  String get generalHours => 'Horas';

  @override
  String get generalMinutes => 'Minutos';

  @override
  String get generalBy => 'Por';

  @override
  String get navHome => 'Início';

  @override
  String get navExplore => 'Explorar';

  @override
  String get navMyCourses => 'Meus Cursos';

  @override
  String get navCart => 'Carrinho';

  @override
  String get navAccount => 'Conta';

  @override
  String get homeSubGreeting => 'O que você gostaria de aprender hoje?';

  @override
  String get homeVisitor => 'Visitante';

  @override
  String get homePromoTitle => 'Explore as ofertas agora';

  @override
  String get homePromoSubtitle => 'Até 70% de desconto em cursos selecionados';

  @override
  String get homePromoButton => 'Descobrir agora';

  @override
  String get homePromoBadge => 'Oferta exclusiva';

  @override
  String get homeContinueLearning => 'Continuar aprendendo';

  @override
  String get homeMyCoursesLink => 'Meus cursos';

  @override
  String get homeLesson => 'aula';

  @override
  String homeStudentsCount(String count) {
    return '$count alunos';
  }

  @override
  String get homeRecommendedTitle => 'Recomendado para você';

  @override
  String get homeRecommendedSubtitle =>
      'Personalizado com base em seus interesses';

  @override
  String get homeBestsellersTitle => 'Mais vendidos';

  @override
  String get homeBestsellersSubtitle => 'Cursos mais populares e bem avaliados';

  @override
  String get homeNewCoursesTitle => 'Novos cursos';

  @override
  String get homeNewCoursesSubtitle => 'Conteúdo novo e atualizado';

  @override
  String get homePopularTopicsTitle => 'Tópicos populares';

  @override
  String get homePopularTopicsSubtitle =>
      'Comece a aprender as habilidades mais procuradas';

  @override
  String get homeTopInstructorsTitle => 'Melhores instrutores';

  @override
  String get homeTopInstructorsSubtitle =>
      'Aprenda com especialistas certificados';

  @override
  String get homeExploreCategoriesTitle => 'Explorar categorias';

  @override
  String get homeExploreCategoriesSubtitle =>
      'Encontre o curso certo para você';

  @override
  String get catAll => 'Todos';

  @override
  String get catWebDev => 'Desenvolvimento Web';

  @override
  String get catMobileApps => 'Aplicativos Móveis';

  @override
  String get catDataScience => 'Ciência de Dados';

  @override
  String get catUIUX => 'Design UI/UX';

  @override
  String get catBusiness => 'Negócios';

  @override
  String get catAI => 'Inteligência Artificial';

  @override
  String get catCyberSecurity => 'Segurança da Informação';

  @override
  String get exploreNoResultsTitle => 'Nenhum resultado encontrado';

  @override
  String get exploreNoResultsSubtitle =>
      'Tente palavras-chave diferentes ou altere os filtros';

  @override
  String get exploreRecentSearches => 'Buscas recentes';

  @override
  String get exploreTopSearches => 'Mais buscados';

  @override
  String get exploreBrowseCategories => 'Navegar por categorias';

  @override
  String get exploreBrowseCategoriesSubtitle =>
      'Encontre o curso certo para você';

  @override
  String get exploreBackToAll => 'Voltar para todos';

  @override
  String get exploreClearAll => 'Limpar tudo';

  @override
  String get exploreAvailableResults => 'resultados disponíveis';

  @override
  String get exploreFilterBestseller => 'Mais vendido';

  @override
  String get exploreFilterTopRated => 'Mais bem avaliado';

  @override
  String get exploreFilterUnder50 => 'Menos de R\$ 50';

  @override
  String get learningHeroTitle => 'Continue sua jornada de aprendizado';

  @override
  String get learningSearchHint => 'Buscar em meus cursos...';

  @override
  String get learningFilterAll => 'Todos';

  @override
  String get learningFilterInProgress => 'Em andamento';

  @override
  String get learningFilterCompleted => 'Concluídos';

  @override
  String get learningFilterDownloaded => 'Baixados';

  @override
  String get learningEmptyTitle => 'Nenhum curso ainda';

  @override
  String get learningEmptySubtitle => 'Comece a explorar cursos agora';

  @override
  String get learningEmptySearch => 'Nenhum resultado encontrado';

  @override
  String get learningCompleted => 'Concluído';

  @override
  String get learningCompletedBadge => 'Concluído';

  @override
  String learningLecturesCount(int count) {
    return '$count aulas';
  }

  @override
  String get cartEmptyTitle => 'Seu carrinho está vazio';

  @override
  String get cartEmptySubtitle => 'Adicione cursos para começar a aprender';

  @override
  String get cartCouponHint => 'Insira o cupom';

  @override
  String get cartCouponApply => 'Aplicar';

  @override
  String get cartCouponInvalid => 'Cupom inválido';

  @override
  String get cartCouponApplied => 'Cupom aplicado';

  @override
  String get cartCouponDiscount => 'Desconto do cupom';

  @override
  String get cartCouponsTitle => 'Cupons';

  @override
  String get cartOrderSummary => 'Resumo do pedido';

  @override
  String get cartOriginalPrice => 'Preço original';

  @override
  String get cartPlatformDiscount => 'Desconto da plataforma';

  @override
  String get cartFinalTotal => 'Total final';

  @override
  String cartItemsCount(int count) {
    return '$count cursos';
  }

  @override
  String get cartRemovedSnackbar => 'Curso removido do carrinho';

  @override
  String get cartUndo => 'Desfazer';

  @override
  String get cartAddButton => 'Adicionar ao carrinho';

  @override
  String get cartAddedSnackbar => 'Adicionado ao carrinho';

  @override
  String get cartAlreadyInCart => 'Já está no carrinho';

  @override
  String get cartCheckoutButton => 'Finalizar compra';

  @override
  String get cartRecommendedTitle => 'Você também pode gostar';

  @override
  String get cartRecommendedSubtitle => 'Cursos recomendados para você';

  @override
  String get checkoutCreditCard => 'Cartão de crédito';

  @override
  String get checkoutSelectPayment => 'Selecione a forma de pagamento';

  @override
  String get checkoutCardNumberLabel => 'Número do cartão';

  @override
  String get checkoutCardHolderLabel => 'Nome do titular';

  @override
  String get checkoutExpiryLabel => 'Data de validade';

  @override
  String get checkoutCVVLabel => 'CVV';

  @override
  String get checkoutPersonalInfoTitle => 'Informações pessoais';

  @override
  String get checkoutFullNameLabel => 'Nome completo';

  @override
  String get checkoutFullNameHint => 'Seu nome completo';

  @override
  String get checkoutFullNameRequired => 'O nome completo é obrigatório';

  @override
  String get checkoutPhoneLabel => 'Telefone';

  @override
  String get checkoutPhoneRequired => 'O telefone é obrigatório';

  @override
  String get checkoutPostalLabel => 'CEP';

  @override
  String get checkoutPostalRequired => 'O CEP é obrigatório';

  @override
  String get checkoutBuyerInfo => 'Dados do comprador';

  @override
  String get checkoutSaveInfo => 'Salvar dados para a próxima vez';

  @override
  String get checkoutMoneyBackGuarantee => 'Garantia de 30 dias de reembolso';

  @override
  String get checkoutContinueToPayment => 'Continuar para o pagamento';

  @override
  String get checkoutContinueToReview => 'Continuar para a revisão';

  @override
  String get checkoutReviewConfirm => 'Revisar e confirmar';

  @override
  String get checkoutStartLearning => 'Começar a aprender';

  @override
  String get checkoutBackHome => 'Voltar para o início';

  @override
  String get courseDetailsTitle => 'Detalhes do Curso';

  @override
  String get courseDetailsShare => 'Compartilhar';

  @override
  String get courseDetailsWhatYouWillLearn => 'O que você aprenderá';

  @override
  String get courseDetailsLanguage => 'Idioma';

  @override
  String get courseDetailsCreatedBy => 'Criado por';

  @override
  String get courseDetailsPreviewLesson => 'Prévia da aula';

  @override
  String get courseDetailsHoursOnDemand => 'horas de vídeo sob demanda';

  @override
  String get courseDetailsFullLifetimeAccess => 'Acesso total e vitalício';

  @override
  String get courseDetailsCertifiedCertificate =>
      'Certificado de conclusão reconhecido';

  @override
  String get courseDetailsComprehensiveContent => 'Conteúdo completo';

  @override
  String get certTitle => 'Certificado de Conclusão';

  @override
  String get certStudentNameLabel => 'Aluno';

  @override
  String get certCourseLabel => 'Curso';

  @override
  String get certInstructorLabel => 'Instrutor';

  @override
  String get certIssueDateLabel => 'Data de emissão';

  @override
  String get certCodeLabel => 'ID do certificado';

  @override
  String get certVerifiedBadge => 'Verificado';

  @override
  String get certDownloadPDF => 'Baixar PDF';

  @override
  String get certDownloadPNG => 'Baixar imagem';

  @override
  String get certCopyVerifyLink => 'Copiar link de verificação';

  @override
  String get certShare => 'Compartilhar certificado';

  @override
  String get playerTabLessons => 'Aulas';

  @override
  String get playerTabOverview => 'Visão geral';

  @override
  String get playerTabNotes => 'Minhas anotações';

  @override
  String get playerTabQnA => 'Dúvidas e Respostas';

  @override
  String get playerNextLesson => 'Próxima aula';

  @override
  String get profileWelcome => 'Bem-vindo';

  @override
  String get profileLoginPrompt => 'Entre para acessar seu perfil';

  @override
  String get profileLoginOrRegister => 'Entrar / Criar Conta';

  @override
  String get profileVerifiedStudent => 'Aluno verificado';

  @override
  String get profileLogout => 'Sair';

  @override
  String get profileCancel => 'Cancelar';

  @override
  String get profileLogoutConfirmTitle => 'Sair da Conta';

  @override
  String get profileLogoutConfirmMessage => 'Tem certeza de que deseja sair?';

  @override
  String get profileAccountSettings => 'Configurações da conta';

  @override
  String get profileEditProfileSubtitle => 'Editar suas informações';

  @override
  String get profileSecurity => 'Segurança da conta';

  @override
  String get profileSecuritySubtitle => 'Senha e autenticação';

  @override
  String get profilePurchaseHistory => 'Histórico de compras';

  @override
  String get profilePurchaseHistorySubtitle => 'Ver transações';

  @override
  String get profileCertificatesSubtitle => 'Seus certificados obtidos';

  @override
  String get profileTeach => 'Ensine no EduLab';

  @override
  String get profileTeachSubtitle => 'Compartilhe seu conhecimento';

  @override
  String get profilePreferences => 'Preferências';

  @override
  String get profilePreferencesSubtitle => 'Configurações e aparência';

  @override
  String get profileNotifications => 'Notificações';

  @override
  String get profileNotificationsSubtitle => 'Gerenciar alertas';

  @override
  String get profileHelpSupport => 'Ajuda e Suporte';

  @override
  String get profileTerms => 'Termos de Uso';

  @override
  String get profilePrivacy => 'Política de Privacidade';

  @override
  String get profileAboutEduLab => 'Sobre o EduLab';

  @override
  String get profileWishlist => 'Lista de desejos';

  @override
  String get securityTitle => 'Segurança da Conta';

  @override
  String get teachTitle => 'Ensine no EduLab';

  @override
  String get notificationsTabAll => 'Todas';

  @override
  String get notificationsTabCourses => 'Cursos';

  @override
  String get notificationsTabPromos => 'Ofertas';

  @override
  String get notificationsEmptyTitle => 'Sem notificações';

  @override
  String get notificationsUnread => 'Não lidas';

  @override
  String get wishlistTitle => 'Lista de Desejos';

  @override
  String get wishlistEmptyTitle => 'Sua lista de desejos está vazia';

  @override
  String get wishlistEmptySubtitle => 'Salve cursos de seu interesse';

  @override
  String get wishlistAddToCart => 'Adicionar ao carrinho';

  @override
  String get wishlistRemovedSnackbar => 'Removido da lista de desejos';

  @override
  String get homeDefaultUser => 'Aluno';

  @override
  String get learningOf => 'de';

  @override
  String get cartInCartBadge => 'No carrinho';

  @override
  String get homePromo1Badge => 'Grande promoção • Tempo limitado';

  @override
  String get homePromo1Title => 'Comece a aprender com os melhores preços';

  @override
  String get homePromo1Subtitle =>
      'Até 65% de desconto em cursos de programação, design e negócios.';

  @override
  String get homePromo1Button => 'Ver ofertas';

  @override
  String get homePromo2Badge => 'Trilhas de carreira certificadas';

  @override
  String get homePromo2Title => 'Prepare-se para o emprego dos seus sonhos';

  @override
  String get homePromo2Subtitle =>
      'Cursos completos do zero ao avançado com projetos reais e certificados.';

  @override
  String get homePromo2Button => 'Explorar trilhas';

  @override
  String get homePromo3Badge => 'Instrutores e especialistas de ponta';

  @override
  String get homePromo3Title =>
      'Aprenda diretamente com especialistas do mercado';

  @override
  String get homePromo3Subtitle =>
      'Conteúdo sempre atualizado para você dominar as tecnologias mais recentes.';

  @override
  String get homePromo3Button => 'Começar agora';

  @override
  String get homePromoInstructorBadge =>
      'Ensine no EduLab • Compartilhe conhecimento';

  @override
  String get homePromoInstructorTitle => 'Torne-se um instrutor hoje';

  @override
  String get homePromoInstructorSubtitle =>
      'Inspire estudantes em todo o mundo, crie cursos e obtenha renda ensinando o que você ama.';

  @override
  String get homePromoInstructorButton => 'Inscreva-se já';

  @override
  String get homeSearchFilter => 'Filtrar';

  @override
  String get securitySectionChangePassword => 'Alterar palavra-passe';

  @override
  String get securityCurrentPasswordLabel => 'Palavra-passe atual *';

  @override
  String get securityCurrentPasswordError => 'Insira a palavra-passe atual';

  @override
  String get securityNewPasswordLabel => 'Nova palavra-passe *';

  @override
  String get securityNewPasswordError => 'Deve ter pelo menos 8 caracteres';

  @override
  String get securityConfirmPasswordLabel => 'Confirmar nova palavra-passe *';

  @override
  String get securityConfirmPasswordError => 'As palavras-passe não coincidem';

  @override
  String get securityUpdatePasswordBtn => 'Atualizar palavra-passe';

  @override
  String get securityPasswordUpdatedSuccess =>
      'Palavra-passe alterada com sucesso!';

  @override
  String get securitySection2FA => 'Autenticação de dois fatores (2FA)';

  @override
  String get security2FATitle => 'Autenticação de dois fatores';

  @override
  String get security2FAEnabledDesc =>
      'Ativada - Protege a sua conta com um código';

  @override
  String get security2FADisabledDesc => 'Desativada (Recomendado)';

  @override
  String get security2FASetupTitle => 'Ativar autenticação de dois fatores';

  @override
  String get security2FASetupContent =>
      'Um código de verificação de 6 dígitos será enviado para o seu e-mail em cada novo início de sessão.';

  @override
  String get security2FAEnableNow => 'Ativar agora';

  @override
  String get security2FAEnabledSuccess =>
      'Autenticação de dois fatores ativada com sucesso!';

  @override
  String get security2FADisabledSuccess =>
      'Autenticação de dois fatores desativada';

  @override
  String get securitySectionSessions => 'Sessões e dispositivos ativos';

  @override
  String get securityLogoutAllDevices =>
      'Terminar sessão em todos os dispositivos';

  @override
  String get securityThisDevice => 'Este dispositivo';

  @override
  String get securitySessionRevokedSuccess =>
      'Sessão terminada e dispositivo desconectado.';

  @override
  String get securityAllSessionsRevokedSuccess =>
      'Sessão terminada em todos os outros dispositivos.';

  @override
  String get purchaseHistoryInvoiceCertified => 'Fatura eletrónica certificada';

  @override
  String get purchaseHistoryInvoiceNumber => 'Número da fatura';

  @override
  String get purchaseHistoryCourse => 'Curso';

  @override
  String get purchaseHistoryPaymentMethod => 'Método de pagamento';

  @override
  String get purchaseHistoryTotalAmount => 'Montante total:';

  @override
  String get purchaseHistoryClose => 'Fechar';

  @override
  String get purchaseHistoryDownloadPdf => 'Transferir PDF';

  @override
  String get purchaseHistoryPdfDownloaded =>
      'Fatura em PDF transferida com sucesso';

  @override
  String get purchaseHistoryRefundRequestTitle => 'Pedido de reembolso';

  @override
  String get purchaseHistoryRefundPolicy =>
      'De acordo com a garantia de 30 dias da EduLab, pode obter um reembolso total.';

  @override
  String get purchaseHistoryRefundReasonHint =>
      'Motivo do reembolso (opcional)...';

  @override
  String get purchaseHistoryConfirmRefund => 'Confirmar reembolso';

  @override
  String get purchaseHistoryRefundSubmitted =>
      'Pedido de reembolso enviado com sucesso (3-5 dias úteis).';

  @override
  String get purchaseHistoryInstructor => 'Instrutor';

  @override
  String get purchaseHistoryRequestRefundBtn => 'Pedir reembolso';

  @override
  String get purchaseHistoryInvoiceBtn => 'Fatura';

  @override
  String get purchaseHistoryStatusCompleted => 'Concluído';

  @override
  String get purchaseHistoryStatusRefunded => 'Reembolsado';

  @override
  String get purchaseHistoryStatusProcessingRefund => 'A processar reembolso';

  @override
  String get editProfileSectionBasicInfo => 'Informações básicas';

  @override
  String get editProfileFullNameLabel => 'Nome completo *';

  @override
  String get editProfileFullNameHint => 'Insira o seu nome completo';

  @override
  String get editProfileFullNameError =>
      'Por favor, insira o seu nome completo';

  @override
  String get editProfileHeadlineLabel => 'Título profissional';

  @override
  String get editProfileHeadlineHint => 'ex. Desenvolvedor Flutter Sénior';

  @override
  String get editProfileLocationLabel => 'Cidade / País';

  @override
  String get editProfileLocationHint => 'Lisboa, Portugal';

  @override
  String get editProfilePhoneLabel => 'Telemóvel';

  @override
  String get editProfileBioLabel => 'Sobre mim (Biografia)';

  @override
  String get editProfileBioHint =>
      'Escreva um breve resumo dos seus interesses e experiência...';

  @override
  String get editProfileSectionLinks => 'Links e redes profissionais';

  @override
  String get editProfileWebsiteLabel => 'Website pessoal';

  @override
  String get editProfileSectionEmail => 'E-mail registado';

  @override
  String get editProfileEmailDesc =>
      'Associado à sua conta para início de sessão e certificados';

  @override
  String get editProfileEmailVerified => 'Verificado';

  @override
  String get editProfileSaveChangesBtn => 'Guardar alterações';

  @override
  String get editProfileSavedSuccess => 'Perfil atualizado com sucesso!';

  @override
  String get editProfileChangeAvatarTitle => 'Alterar foto de perfil';

  @override
  String get editProfileTakePhoto => 'Tirar fotografia';

  @override
  String get editProfileChooseGallery => 'Escolher da galeria';

  @override
  String get editProfilePhotoUpdatedSuccess =>
      'Foto de perfil atualizada com sucesso';

  @override
  String get teachJoinInstructorTitle => 'Junte-se como instrutor';

  @override
  String get teachJoinInstructorSubtitle =>
      'Publique os seus cursos e partilhe os seus conhecimentos com milhares de alunos.';

  @override
  String get teachStep1Title => 'Dados pessoais';

  @override
  String get teachStep2Title => 'Experiência e competências';

  @override
  String get teachStep3Title => 'Confirmação';

  @override
  String get teachStep1Header => '1. Informações pessoais e profissionais';

  @override
  String get teachFullNameArabicLabel => 'Nome completo *';

  @override
  String get teachFullNameArabicHint => 'ex. João Silva';

  @override
  String get teachHeadlineLabel => 'Título profissional e especialidade *';

  @override
  String get teachHeadlineHint =>
      'ex. Arquiteto de software sénior e formador Flutter';

  @override
  String get teachPhoneLabel => 'Número de telefone *';

  @override
  String get teachCountryLabel => 'País de residência *';

  @override
  String get teachBioLabel => 'Apresentação e experiência anterior *';

  @override
  String get teachBioHint =>
      'Escreva um breve resumo da sua carreira e projetos anteriores...';

  @override
  String get teachNextStepSkills => 'Continuar: Experiência e competências';

  @override
  String get teachStep2Header => '2. Conteúdo do curso e competências';

  @override
  String get teachTopicLabel => 'Tema ou percurso do curso proposto *';

  @override
  String get teachTopicHint => 'ex. Desenvolvimento Flutter do zero';

  @override
  String get teachYearsExperienceLabel => 'Anos de experiência no setor *';

  @override
  String get teachVideoLinkLabel =>
      'Link para vídeo de demonstração (YouTube/Drive/Loom) *';

  @override
  String get teachTargetAudienceLabel => 'Público-alvo do curso *';

  @override
  String get teachAudienceBeginners => 'Iniciantes';

  @override
  String get teachAudienceIntermediate => 'Iniciantes e intermédios';

  @override
  String get teachAudienceAdvanced => 'Avançados e profissionais';

  @override
  String get teachAudienceAll => 'Todos os níveis';

  @override
  String get teachSkillsCoveredLabel =>
      'Competências e tecnologias abordadas no curso *';

  @override
  String get teachAddSkillHint => 'Adicionar competência (ex. GraphQL)...';

  @override
  String get teachAddSkillBtn => 'Adicionar';

  @override
  String get teachNextStepConfirm => 'Continuar: Confirmar candidatura';

  @override
  String get teachStep3Header => '3. Detalhes de pagamento e termos';

  @override
  String get teachPayoutMethodLabel => 'Método para receber ganhos *';

  @override
  String get teachPayoutMethodBank => 'Transferência bancária direta (IBAN)';

  @override
  String get teachPayoutMethodPaypal => 'Conta PayPal verificada';

  @override
  String get teachPayoutMethodPayoneer => 'Cartão Payoneer';

  @override
  String get teachIbanDetailsLabel => 'Dados da conta / IBAN *';

  @override
  String get teachApplicationSummary => 'Resumo da candidatura:';

  @override
  String get teachApplicantName => 'Candidato';

  @override
  String get teachApplicantHeadline => 'Especialidade';

  @override
  String get teachApplicantTopic => 'Tema do curso';

  @override
  String get teachApplicantSkillsCount => 'Competências adicionadas';

  @override
  String get teachSkillsUnit => 'competências';

  @override
  String get teachAgreeTermsLabel =>
      'Aceito os termos, condições e acordo de propriedade intelectual da EduLab.';

  @override
  String get teachSubmitApplicationBtn => 'Submit Instructor Application';

  @override
  String get teachPrevStepBtn => 'Anterior';

  @override
  String get teachWhyEduLabTitle => 'Por que ensinar com a EduLab?';

  @override
  String get teachProp1Title => 'Rendimentos justos e atrativos';

  @override
  String get teachProp1Desc =>
      'Ganhe até 80% das vendas dos seus cursos sem taxas ocultas.';

  @override
  String get teachProp2Title => 'Alcance milhares de alunos';

  @override
  String get teachProp2Desc =>
      'Divulgue o seu curso para uma vasta comunidade de aprendizagem ativa.';

  @override
  String get teachProp3Title => 'Apoio técnico e de produção completo';

  @override
  String get teachProp3Desc =>
      'A nossa equipa ajuda a otimizar a qualidade de áudio, vídeo e plano de estudos.';

  @override
  String get teachSuccessDialogTitle => 'Candidatura recebida com sucesso!';

  @override
  String get teachSuccessDialogDesc =>
      'Obrigado por se juntar aos instrutores da EduLab. A nossa equipa irá analisar a sua candidatura e entrar em contacto dentro de 48 horas.';

  @override
  String get teachSuccessDialogOk => 'Compreendido';

  @override
  String get teachAddOneSkillError =>
      'Por favor, adicione pelo menos uma competência';

  @override
  String get teachAgreeTermsError => 'Por favor, aceite os termos de instrutor';

  @override
  String get commonCancel => 'Cancelar';

  @override
  String get commonClose => 'Fechar';

  @override
  String get myCertificatesBannerTitle => 'Certificados Acreditados';

  @override
  String get myCertificatesBannerSubtitle =>
      'Todos os certificados são acreditados e verificados com um ID exclusivo da EduLab';

  @override
  String get certBadgeVerified100 => '100% Acreditado';

  @override
  String get certCodeCopied => 'Código do certificado copiado';

  @override
  String get certGrantedTo => 'Concedido a';

  @override
  String get certViewAndDownload => 'Ver e baixar certificado';

  @override
  String get certIssuerLabel => 'Autoridade emissora';

  @override
  String get certIssuerName => 'Academia de Aprendizagem Interativa EduLab';

  @override
  String get certEmptyTitle => 'Nenhum certificado obtido ainda';

  @override
  String get certEmptyDesc =>
      'Conclua 100% de qualquer curso inscrito para receber um certificado credenciado com ID de verificação oficial.';

  @override
  String get certEmptyAction => 'Continuar meus cursos';

  @override
  String get certDetailsTitle => 'Detalhes e informações do certificado';

  @override
  String get certCopyLinkSuccess =>
      'Link de verificação direta copiado para a área de transferência!';

  @override
  String get certShareSuccess =>
      'Detalhes e link do certificado copiados para compartilhamento!';

  @override
  String get purchaseHistoryTaxInvoiceCertified =>
      'Fatura fiscal oficial certificada';

  @override
  String get purchaseHistoryInvoiceNumberLabel => 'N.º do pedido / fatura';

  @override
  String get purchaseHistoryCourseNameLabel => 'Nome do curso';

  @override
  String get purchaseHistoryPurchaseDateLabel => 'Data de compra';

  @override
  String get purchaseHistoryPaymentMethodLabel => 'Método de pagamento';

  @override
  String get purchaseHistoryPaymentMethodValue =>
      'Cartão de crédito / Stripe (Online)';

  @override
  String get purchaseHistoryOrderStatusLabel => 'Status do pedido';

  @override
  String get purchaseHistoryStatusPendingReview => 'Reembolso em análise';

  @override
  String get purchaseHistoryCopyInvoiceBtn => 'Copiar número da fatura';

  @override
  String get purchaseHistoryRefundReasonLabel =>
      'Motivo da solicitação de reembolso:';

  @override
  String get purchaseHistoryRefundReasonEmptyError =>
      'Por favor, insira o motivo da sua solicitação de reembolso';

  @override
  String get purchaseHistorySubmittingRefund => 'Enviando solicitação...';

  @override
  String get purchaseHistoryPaidDate => 'Data de pagamento';

  @override
  String get purchaseHistoryEmptyTitle => 'Nenhum histórico de compras ainda';

  @override
  String get purchaseHistoryEmptyDesc =>
      'Você ainda não comprou nenhum curso.\nSeus pedidos e faturas aparecerão aqui assim que concluídos.';

  @override
  String get purchaseHistoryExploreCourses => 'Explorar cursos agora';

  @override
  String get profileMyCourses => 'Meus Cursos';

  @override
  String get profileMyCoursesSubtitle =>
      'Acompanhar o progresso dos seus cursos inscritos';

  @override
  String get profileWishlistSubtitle => 'Cursos salvos na sua lista de desejos';

  @override
  String get navMyLearning => 'Meu Aprendizado';

  @override
  String get profileLogoutSafeNote =>
      'Seus dados, cursos e certificados estão totalmente seguros. Você pode continuar aprendendo a qualquer momento fazendo login novamente.';

  @override
  String learningRemainingHours(String hours) {
    return '$hours horas restantes';
  }

  @override
  String get learningCompletedFull => 'Concluído';

  @override
  String get learningFilterNotStarted => 'Não Iniciado';

  @override
  String get wishlistTopRatedBadge => 'Mais bem avaliado';

  @override
  String get wishlistFeaturedBadge => 'Destaque';

  @override
  String wishlistDiscountBadge(String percent) {
    return '$percent% de desconto';
  }

  @override
  String get courseFree => 'Grátis';

  @override
  String get badgeBestseller => 'Mais Vendido';

  @override
  String get badgeTopRated => 'Mais bem avaliado';

  @override
  String get badgeFeatured => 'Destaque';

  @override
  String get badgeRecommended => 'Recomendado para você';

  @override
  String get badgeNew => 'Novo';

  @override
  String get courseWord => 'Curso';

  @override
  String coursesCountText(String count) {
    return '$count+ Cursos';
  }

  @override
  String studentsCountText(String count) {
    return '$count Alunos';
  }

  @override
  String hoursCountText(String count) {
    return '$count Horas';
  }

  @override
  String get certifiedInstructor => 'Instrutor Certificado';

  @override
  String get expertCertifiedInstructor =>
      'Especialista & Instrutor Certificado';

  @override
  String get defaultCourseTitle => 'Curso Educativo';

  @override
  String get categoryWord => 'Categoria';

  @override
  String get previewCourseVideo => 'Prévia do Vídeo do Curso';

  @override
  String get freeSection => 'Seção Gratuita';

  @override
  String get freeDemoVideo => 'Vídeo Demo Gratuito';

  @override
  String get articleLecture => 'Aula em Artigo';

  @override
  String get articleViewer => 'Leitor de Artigos';

  @override
  String get courseVideoPlayer => 'Player de Vídeo do Curso';

  @override
  String get playingNow => 'Reproduzindo agora';

  @override
  String get readingNow => 'Lendo agora';

  @override
  String get noLecturesInFreeSection => 'Nenhuma aula na seção gratuita';

  @override
  String freeLecturesCount(String count) {
    return '$count aulas gratuitas';
  }

  @override
  String get enrollInFullCourse => 'Inscrever-se no Curso Completo';

  @override
  String get articleWord => 'Artigo';

  @override
  String get videoWord => 'Vídeo';

  @override
  String get quizWord => 'Questionário';

  @override
  String get courseShareCopied =>
      'Link do curso copiado para a área de transferência!';

  @override
  String get addedToCartSnackbar => 'Adicionado ao carrinho';

  @override
  String get viewCartAction => 'Ver Carrinho';

  @override
  String get inCartBadge => 'No Carrinho ✓';

  @override
  String get addToCartButton => 'Adicionar ao Carrinho';

  @override
  String get wishlistAddedSnackbar => 'Curso adicionado à lista de desejos';

  @override
  String get wishlistRemovedSuccessSnackbar =>
      'Curso removido da lista de desejos';

  @override
  String get lessonCompletedAll =>
      'Parabéns! Você concluiu todas as aulas deste curso.';

  @override
  String get noteAddedSuccess => 'Nota adicionada com sucesso';

  @override
  String get lessonAlreadyDownloaded =>
      'A aula já está salva para acesso offline';

  @override
  String get lessonLinkCopied => 'Link da aula copiado';

  @override
  String get contentReportThanks =>
      'Obrigado pelo feedback, nossa equipe irá analisar a aula.';

  @override
  String get courseCompletionCertificate => 'Certificado de Conclusão';

  @override
  String get reportContentIssue => 'Reportar problema no conteúdo';

  @override
  String get loginOrSocial => 'Ou entrar com';

  @override
  String get loginSuccessSnackbar => 'Login realizado com sucesso';

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
  String get cartClearAllTitle => 'Limpar todos os itens do carrinho?';

  @override
  String cartClearAllMessage(String count) {
    return 'Tem certeza de que deseja remover todos os cursos $count do seu carrinho de compras?';
  }

  @override
  String get cartClearAllHint =>
      'Todos os cursos serão removidos do seu carrinho. Você pode adicioná-los novamente a qualquer momento.';

  @override
  String cartClearAllConfirm(String count) {
    return 'Limpar tudo ($count)';
  }

  @override
  String get cartClearedSuccess => 'Carrinho limpo com sucesso';

  @override
  String get cartClearFailed => 'Falha ao limpar o carrinho';

  @override
  String cartViewWishlistCount(String count) {
    return 'Ver itens da lista de desejos ($count)';
  }

  @override
  String get cartGoToWishlist => 'Vá para a lista de desejos';

  @override
  String get wishlistClearAllTitle =>
      'Limpar todos os itens da lista de desejos?';

  @override
  String wishlistClearAllMessage(String count) {
    return 'Tem certeza de que deseja remover todos os cursos $count da sua lista de desejos?';
  }

  @override
  String get wishlistClearAllHint =>
      'Todos os cursos salvos serão apagados. Você pode adicioná-los novamente a qualquer momento no Explore.';

  @override
  String wishlistClearAllConfirm(String count) {
    return 'Limpar tudo ($count)';
  }

  @override
  String get wishlistClearedSuccess => 'Lista de desejos apagada com sucesso';

  @override
  String get wishlistClearFailed => 'Falha ao limpar a lista de desejos';

  @override
  String get wishlistClearTooltip => 'Limpar tudo';

  @override
  String wishlistViewCartCount(String count) {
    return 'Ver itens do carrinho ($count)';
  }

  @override
  String get wishlistGoToCart => 'Ir para o carrinho';

  @override
  String get checkoutCardNumberInvalid =>
      'Insira um número de cartão válido de 16 dígitos';

  @override
  String get checkoutCardExpiryInvalidFormat =>
      'Insira uma data de validade válida do cartão (MM/AA)';

  @override
  String get checkoutCardExpiredDate =>
      'A data de validade do cartão é inválida';

  @override
  String get checkoutCardCvcInvalid =>
      'Insira um código CVC válido de 3 ou 4 dígitos';

  @override
  String get checkoutCardHolderNameRequired =>
      'Por favor insira o nome do titular do cartão';

  @override
  String get checkoutCartEmptySnackbar => 'O carrinho de compras está vazio';

  @override
  String get checkoutPaymentStartFailed => 'Falha ao iniciar o pagamento';

  @override
  String get checkoutClientSecretMissing =>
      'A chave de segurança não foi recebida do gateway de pagamento';

  @override
  String get checkoutCardVerificationFailed => 'Falha na verificação do cartão';

  @override
  String get checkoutStripeProcessingFailed =>
      'Falha no processamento do pagamento stripe';

  @override
  String get checkoutServerConfirmationFailed =>
      'Falha na confirmação de pagamento do servidor';

  @override
  String get checkoutEmptyCartTitle => 'Seu carrinho está vazio';

  @override
  String get checkoutEmptyCartDesc =>
      'Você ainda não adicionou nenhum curso ao seu carrinho. Explore nossos cursos e comece a aprender!';

  @override
  String get checkoutContinueFreeReview => 'Continuar para revisão gratuita';

  @override
  String get checkoutFreeOrderBadge => 'Pedido 100% gratuito (zsh.00)';

  @override
  String get checkoutFreeOrderNotice =>
      'Este pedido não requer nenhuma informação de pagamento. Você pode prosseguir diretamente para confirmar a inscrição.';

  @override
  String get checkoutFreeCheckoutTitle => 'Finalização de compra 100% grátis';

  @override
  String get checkoutConfirmFreeEnrollment => 'Confirme a inscrição gratuita';

  @override
  String get checkoutFreePrice => 'Livre';

  @override
  String get checkoutFreeZero => 'Grátis (zsh.00)';

  @override
  String checkoutCoursesCount(String count) {
    return '$count cursos';
  }

  @override
  String get notificationsClearAllTitle => 'Limpar todas as notificações?';

  @override
  String notificationsClearAllMessage(String count) {
    return 'Tem certeza de que deseja excluir todas as notificações $count? Esta ação não pode ser desfeita.';
  }

  @override
  String get notificationsClearAllHint =>
      'Todas as suas notificações serão excluídas e sua caixa de entrada começará do zero.';

  @override
  String notificationsClearAllConfirm(String count) {
    return 'Limpar tudo ($count)';
  }

  @override
  String get notificationsClearSuccess =>
      'Todas as notificações foram apagadas com sucesso';

  @override
  String get notificationsClearFailed => 'Falha ao limpar notificações';

  @override
  String get notificationsClearTooltip => 'Limpar tudo';

  @override
  String get notificationsViewDetails => 'Ver detalhes';

  @override
  String get notificationsEmptyCategoryTitle =>
      'Nenhuma notificação nesta categoria';

  @override
  String get notificationsEmptyCategorySubtitle =>
      'Tente mudar para outra categoria ou navegar por todas as notificações';

  @override
  String get notificationsEmptyAllSubtitle =>
      'Manteremos você informado sobre as últimas atualizações e alertas aqui';

  @override
  String get notificationsViewAll => 'Ver todas as notificações';

  @override
  String get learningFilterAndSortTitle => 'Filtrar e classificar cursos';

  @override
  String get learningFilterReset => 'Reiniciar';

  @override
  String get learningSortByTitle => 'Ordenar por';

  @override
  String get learningSortRecentActivity => 'Acessado recentemente';

  @override
  String get learningSortRecentEnrolled => 'Inscrito recentemente';

  @override
  String get learningSortTitleAZ => 'Título (AZ)';

  @override
  String get learningSortProgress => '% de progresso';

  @override
  String get learningStatusTitle => 'Status do curso';

  @override
  String get learningStatusAll => 'Todos os cursos';

  @override
  String get learningStatusInProgress => 'Em andamento';

  @override
  String get learningStatusCompleted => 'Concluído';

  @override
  String get learningStatusNotStarted => 'Não iniciado';

  @override
  String get learningFilterApply => 'Aplicar filtros';

  @override
  String get learningSearchCoursesHint => 'Pesquisar seus cursos...';

  @override
  String get learningSearchWishlistHint => 'Pesquisar lista de desejos...';

  @override
  String get learningSearchCertificatesHint => 'Pesquisar certificados...';

  @override
  String get learningTabMyCourses => 'Meus cursos';

  @override
  String get learningTabFavourite => 'Meus favoritos';

  @override
  String get learningTabCertificates => 'Meus certificados';

  @override
  String get learningNoCoursesTitle => 'Nenhum curso ainda';

  @override
  String get learningNoCoursesSubtitle =>
      'Explore milhares de cursos premium e comece sua jornada de aprendizado hoje';

  @override
  String get learningFilterButton => 'Filtrar';

  @override
  String learningFilterAllCount(String count) {
    return 'Todos ($count)';
  }

  @override
  String get learningStatusNotStartedShort => 'Não iniciado';

  @override
  String get learningNoMatchTitle => 'Nenhum curso encontrado';

  @override
  String learningNoMatchSubtitle(String query) {
    return 'Nenhum curso encontrado contendo \"$query\". Tente pesquisar com termos diferentes.';
  }

  @override
  String get learningNoInProgressTitle => 'Nenhum curso em andamento';

  @override
  String get learningNoInProgressSubtitle =>
      'Comece a assistir às aulas nos cursos em que está matriculado para acompanhar seu progresso aqui.';

  @override
  String get learningNoCompletedTitle => 'Nenhum curso concluído ainda';

  @override
  String get learningNoCompletedSubtitle =>
      'Continue seus estudos para comemorar seu progresso e ver os cursos concluídos aqui.';

  @override
  String get learningNoUnstartedTitle => 'Nenhum curso não iniciado';

  @override
  String get learningNoUnstartedSubtitle =>
      'Incrível! Você já começou a aprender em todos os seus cursos matriculados.';

  @override
  String get learningNoFilterMatchTitle =>
      'Nenhum curso corresponde a este filtro';

  @override
  String get learningNoFilterMatchSubtitle =>
      'Altere as opções de filtro ou ordenação para exibir seus cursos.';

  @override
  String learningViewAllCoursesCount(String count) {
    return 'Ver todos os cursos ($count)';
  }

  @override
  String learningSavedCoursesCount(String count) {
    return 'Cursos salvos ($count)';
  }

  @override
  String get learningClearAllSaved => 'Limpar tudo';

  @override
  String get learningNoCertificatesTitle => 'Nenhum certificado ainda';

  @override
  String get learningNoCertificatesSubtitle =>
      'Conclua seus cursos para obter certificados reconhecidos que comprovem suas conquistas';

  @override
  String get learningGoToCourses => 'Ir para Meus Cursos';

  @override
  String learningCertIssuedDate(String date) {
    return 'Emitido: $date';
  }

  @override
  String get learningCertView => 'Visualizar';

  @override
  String get learningResumeLesson => 'Continuar aula';

  @override
  String learningProgressPercentComplete(String percent) {
    return '$percent% concluído';
  }

  @override
  String learningViewCartCount(String count) {
    return 'Ver itens do carrinho ($count)';
  }

  @override
  String get learningGoToCart => 'Ir para o carrinho';

  @override
  String get playerLessonMarkedCompleted => 'Aula marcada como concluída ✓';

  @override
  String get playerLessonMarkedIncomplete => 'Aula marcada como incompleta';

  @override
  String get playerCommentPostedSuccess => 'Comentário publicado com sucesso';

  @override
  String get playerCommentPostFailed => 'Falha ao publicar comentário';

  @override
  String get playerReplyPostedSuccess => 'Resposta publicada com sucesso';

  @override
  String get playerReplyPostFailed => 'Falha ao publicar resposta';

  @override
  String get playerCourseNotFound => 'Curso não encontrado';

  @override
  String get playerCheckEnrollmentPrompt =>
      'Por favor, verifique sua matrícula no curso primeiro';

  @override
  String get playerReturnToCourses => 'Meu aprendizado';

  @override
  String get playerWatchLecture => 'Aula do curso';

  @override
  String get playerCertificateTooltip => 'Certificado';

  @override
  String get playerRateCourseTooltip => 'Avaliar curso';

  @override
  String get playerReadingArticleBadge => 'Artigo de leitura • 5 min';

  @override
  String get playerReadFullTextBelow => 'Leia o texto completo abaixo ↓';

  @override
  String get playerTabReviews => 'Avaliações';

  @override
  String get playerNoSectionsAvailable => 'Nenhuma seção disponível';

  @override
  String playerLessonsCount(String count) {
    return '$count aulas';
  }

  @override
  String get playerPlayingBadge => 'Reproduzindo';

  @override
  String get playerArticleBadge => 'Artigo';

  @override
  String get playerVideoBadge => 'Vídeo';

  @override
  String get playerFullArticleContent => 'Conteúdo completo do artigo';

  @override
  String get playerArticlePlaceholder =>
      'Bem-vindo a esta aula de leitura.\n\nEsta seção aborda os conceitos principais e as etapas práticas necessárias para dominar as habilidades desta aula.';

  @override
  String get playerAboutCourseTitle => 'Sobre este curso';

  @override
  String get playerShowLess => 'Mostrar menos';

  @override
  String get playerReadMore => 'Ler mais';

  @override
  String get playerWhatYouWillLearn => 'O que você aprenderá';

  @override
  String get playerCourseInfoTitle => 'Detalhes do curso';

  @override
  String get playerTotalDurationTitle => 'Duração total';

  @override
  String get playerTotalLessonsTitle => 'Total de aulas';

  @override
  String playerLessonsNumber(String count) {
    return '$count aulas';
  }

  @override
  String get playerLevelTitle => 'Nível';

  @override
  String get playerAllLevels => 'Todos os níveis';

  @override
  String get playerLanguageTitle => 'Idioma';

  @override
  String get playerLanguageArabic => 'Árabe';

  @override
  String get playerPrerequisitesTitle => 'Requisitos do curso';

  @override
  String get playerCertificateCardTitle => 'Certificado do curso';

  @override
  String get playerCourseCompletedSuccess => 'Parabéns! Curso concluído';

  @override
  String get playerProgressLabel => 'Progresso';

  @override
  String get playerViewCertificateBtn => 'Ver certificado';

  @override
  String get playerCertifiedInstructor => 'Instrutor certificado';

  @override
  String playerDiscussionsCount(String count) {
    return '$count perguntas e discussões';
  }

  @override
  String get playerAskQuestionHint => 'Digite sua pergunta ou dúvida aqui...';

  @override
  String get playerPostBtn => 'Publicar';

  @override
  String get playerNoDiscussionsTitle => 'Nenhuma discussão ainda';

  @override
  String get playerNoDiscussionsSubtitle =>
      'Seja o primeiro a fazer uma pergunta!';

  @override
  String get playerInstructorBadge => 'Instrutor';

  @override
  String get playerCancelReply => 'Cancelar';

  @override
  String get playerReplyAction => 'Responder';

  @override
  String playerRepliesCount(String count) {
    return '$count respostas';
  }

  @override
  String get playerWriteReplyHint => 'Escreva sua resposta...';

  @override
  String get playerSendReplyBtn => 'Responder';

  @override
  String get playerCourseFeedbackTitle => 'Avaliação e feedback do curso';

  @override
  String get playerOutOf5 => 'de 5';

  @override
  String playerRatingsFromEnrolledCount(String count) {
    return '$count avaliações de alunos inscritos';
  }

  @override
  String get playerKeepLearningToRate => 'Continue aprendendo para avaliar';

  @override
  String get playerRateAfter80Hint =>
      'Você poderá avaliar este curso após concluir 80% do conteúdo';

  @override
  String get playerCurrentProgressLabel => 'Seu progresso:';

  @override
  String get playerYourCurrentRating => 'Sua avaliação';

  @override
  String get playerEditRating => 'Editar avaliação';

  @override
  String get playerDeleteRatingTooltip => 'Excluir avaliação';

  @override
  String get playerUpdateRatingTitle => 'Atualizar sua avaliação';

  @override
  String get playerRateCourseTitle => 'Avaliar este curso';

  @override
  String get playerWriteReviewHint =>
      'Escreva seu feedback sobre a qualidade do conteúdo (opcional)...';

  @override
  String get playerRatingSubmitSuccess => 'Avaliação enviada com sucesso!';

  @override
  String get playerRatingSubmitFailed => 'Falha ao enviar avaliação';

  @override
  String get playerSaveChangesBtn => 'Salvar alterações';

  @override
  String get playerSubmitReviewBtn => 'Enviar avaliação';

  @override
  String get playerLearnerReviewsTitle => 'Avaliações dos alunos';

  @override
  String playerReviewsCount(String count) {
    return '$count avaliações';
  }

  @override
  String get playerNoWrittenReviewsTitle =>
      'Nenhuma avaliação por escrito ainda';

  @override
  String get playerNoWrittenReviewsSubtitle =>
      'Seja o primeiro a compartilhar sua opinião!';

  @override
  String get playerRatingLabel5 => 'Excelente 🌟 (5/5)';

  @override
  String get playerRatingLabel4 => 'Muito bom 👍 (4/5)';

  @override
  String get playerRatingLabel3 => 'Regular 👌 (3/5)';

  @override
  String get playerRatingLabel2 => 'Precisa melhorar 🤔 (2/5)';

  @override
  String get playerRatingLabel1 => 'Ruim 👎 (1/5)';

  @override
  String get playerDeleteRatingDialogTitle => 'Excluir avaliação';

  @override
  String get playerDeleteRatingDialogMessage =>
      'Tem certeza de que deseja excluir sua avaliação deste curso?';

  @override
  String get playerDeleteConfirmBtn => 'Excluir';

  @override
  String get playerRatingDeleteSuccess => 'Avaliação excluída com sucesso';

  @override
  String get playerPreviousLesson => 'Aula anterior';

  @override
  String get playerExitFullscreenTooltip => 'Sair da tela cheia';

  @override
  String instructorsAvailableCount(String count) {
    return '$count instrutores disponíveis';
  }

  @override
  String get instructorsNotFound => 'Nenhum instrutor encontrado';

  @override
  String instructorsCoursesCount(String count) {
    return '$count cursos';
  }

  @override
  String get instructorsSearchHint =>
      'Pesquise por nome do instrutor ou especialidade...';

  @override
  String get instructorsSortAll => 'Todos';

  @override
  String get instructorsSortTopRated => 'Mais bem avaliados';

  @override
  String get instructorsSortMostStudents => 'A maioria dos alunos';

  @override
  String get instructorsSortMostCourses => 'A maioria dos cursos';

  @override
  String get instructorsNotFoundSubtitle =>
      'Tente pesquisar com um nome diferente ou limpe os filtros';

  @override
  String get exploreCompleteCourse => 'Curso Abrangente';

  @override
  String get exploreGeneralCategory => 'Em geral';

  @override
  String courseShareMessage(String title, String url) {
    return 'Confira o curso \"$title\" no EduLab: $url';
  }

  @override
  String get courseDetailsDefaultTitle => 'Detalhes do curso';

  @override
  String get courseDetailsTooltipShare => 'Compartilhar';

  @override
  String get courseDetailsTooltipWishlist => 'Lista de desejos';

  @override
  String get courseDetailsTooltipCart => 'Carrinho';

  @override
  String get courseDetailsNotFound => 'Curso não encontrado';

  @override
  String get courseDetailsDefaultCategory => 'Curso';

  @override
  String courseDetailsTotalRatingsCount(String count) {
    return '($count avaliações)';
  }

  @override
  String courseDetailsLecturesCount(String count) {
    return '$count palestras';
  }

  @override
  String get courseDetailsCertificateBadge => 'Certificado';

  @override
  String get courseDetailsTabOverview => 'Visão geral';

  @override
  String get courseDetailsTabCurriculum => 'Currículo';

  @override
  String get courseDetailsTabInstructor => 'Instrutor';

  @override
  String get courseDetailsTabReviews => 'Comentários';

  @override
  String get courseDetailsFullDescriptionTitle => 'Descrição';

  @override
  String get courseDetailsShowLess => 'Mostrar menos';

  @override
  String get courseDetailsShowMore => 'Mostrar mais...';

  @override
  String courseDetailsCurriculumSectionsLectures(
    String sections,
    String lectures,
  ) {
    return '$sections seções • $lectures palestras';
  }

  @override
  String get courseDetailsCollapseAll => 'Recolher tudo';

  @override
  String get courseDetailsExpandAll => 'Expandir tudo';

  @override
  String get courseDetailsCurriculumComingSoon =>
      'Detalhes do currículo em breve';

  @override
  String courseDetailsSectionLecturesCount(String count) {
    return '$count palestras';
  }

  @override
  String get courseDetailsLecturePreviewBtn => 'Visualização';

  @override
  String get courseDetailsDefaultInstructorTitle =>
      'Instrutor Sênior e Especialista Certificado';

  @override
  String get courseDetailsInstructorRatingLabel => 'Avaliação';

  @override
  String get courseDetailsInstructorStudentsLabel => 'Alunos';

  @override
  String get courseDetailsInstructorSectionsLabel => 'Seções';

  @override
  String get courseDetailsAboutInstructorTitle => 'Sobre o instrutor:';

  @override
  String get courseDetailsDefaultInstructorAbout =>
      'Instrutor certificado com ampla experiência no fornecimento de educação profissional para milhares de estudantes em todo o mundo.';

  @override
  String courseDetailsStudentRatingsCount(String count) {
    return '$count avaliações dos alunos';
  }

  @override
  String get courseDetailsNoWrittenReviews =>
      'Ainda não há comentários escritos';

  @override
  String get courseDetailsRelatedCourses =>
      'Cursos relacionados que você pode gostar';

  @override
  String courseDetailsDiscountPercent(String percent) {
    return '$percent% DE DESCONTO';
  }

  @override
  String get courseDetailsResumeCourse => 'Retomar curso';

  @override
  String get courseDetailsTryAgain => 'Tente novamente';

  @override
  String get courseDetailsEstimatedReading => '📖 Leitura estimada: 4 minutos';

  @override
  String get courseDetailsSampleArticleContent =>
      'Bem-vindo a esta palestra de artigo.\n\nEsta seção cobre os principais conceitos teóricos e etapas práticas para dominar o assunto.\n\n• Principais conclusões:\n1. Compreender a terminologia básica e os padrões arquitetônicos.\n2. Exercícios práticos e prática contínua.\n3. Notas e tarefas complementares de referência.\n\nAproveite a leitura!';

  @override
  String certDownloadedSuccess(String course, String format) {
    return 'Certificado para \"$course\" baixado no formato $format com sucesso!';
  }

  @override
  String certVerifiedFullRequirements(String code) {
    return 'ID de verificação: $code • 100% dos requisitos concluídos';
  }

  @override
  String get certCompletionTitle => 'Certificado de Conclusão';

  @override
  String get certCompletionSubtitle => 'Certificado de conclusão de curso';

  @override
  String get certAnnounceStudent =>
      'A EducationLab Learning Academy certifica que:';

  @override
  String get certCompletionRequirementsMet =>
      'Concluiu com sucesso todos os requisitos do curso de treinamento:';

  @override
  String certIssueDateText(String date) {
    return 'Data de emissão: $date';
  }

  @override
  String certIdNumberText(String code) {
    return 'ID do certificado: $code';
  }

  @override
  String get certPlatformManagement => 'Gerenciamento de plataforma';

  @override
  String get certInstructorRoleTitle => 'Instrutor de Curso';

  @override
  String get commonLoading => 'Carregando...';

  @override
  String get homeGuestTagline =>
      'Plataforma inteligente de aprendizagem e desenvolvimento de habilidades';

  @override
  String get catTagHighestDemand => 'Mais procurados';

  @override
  String get catTagMostPopular => 'Mais populares';

  @override
  String get catTagTrending => 'Em alta';

  @override
  String get catTagFastestGrowing => 'Crescimento mais rápido';

  @override
  String get catTagHighDemand => 'Alta demanda';

  @override
  String get catTagTopRated => 'Mais bem avaliados';

  @override
  String get catTagEssential => 'Essencial';

  @override
  String get catTagAdvanced => 'Nível avançado';

  @override
  String get catTagEntrepreneurs => 'Empreendedores';

  @override
  String get catTagSalesGrowth => 'Crescimento de vendas';

  @override
  String get catDevTitle => 'Programação e desenvolvimento de software';

  @override
  String get catDevSubtitle => 'Engenharia de software, sistemas e algoritmos';

  @override
  String get catWebTitle => 'Desenvolvimento Web';

  @override
  String get catWebSubtitle => 'Frontend, Backend e Fullstack Web';

  @override
  String get catMobileTitle => 'Desenvolvimento de apps mobile';

  @override
  String get catMobileSubtitle => 'Aplicativos com Flutter, iOS e Android';

  @override
  String get catAiTitle => 'Inteligência Artificial';

  @override
  String get catAiSubtitle => 'Machine Learning, Deep Learning e IA';

  @override
  String get catDataTitle => 'Ciência de dados e análise';

  @override
  String get catDataSubtitle => 'Análise de dados, estatística e Big Data';

  @override
  String get catDesignTitle => 'Design UI/UX e de produtos';

  @override
  String get catDesignSubtitle => 'UI/UX, prototipagem e design de produto';

  @override
  String get catSecurityTitle => 'Cibersegurança e redes';

  @override
  String get catSecuritySubtitle =>
      'Segurança cibernética, hacking ético e redes';

  @override
  String get catCloudTitle => 'Computação em nuvem e DevOps';

  @override
  String get catCloudSubtitle => 'Infraestrutura em nuvem, DevOps e CI/CD';

  @override
  String get catBusinessTitle => 'Gestão de negócios e projetos';

  @override
  String get catBusinessSubtitle => 'Empreendedorismo, Agile e liderança';

  @override
  String get catMarketingTitle => 'Marketing Digital';

  @override
  String get catMarketingSubtitle =>
      'Marketing digital, SEO e estratégias de crescimento';

  @override
  String get timeJustNow => 'Agora mesmo';

  @override
  String timeMinutesAgo(String count) {
    return 'há $count min';
  }

  @override
  String timeHoursAgo(String count) {
    return 'há $count h';
  }

  @override
  String timeDaysAgo(String count) {
    return 'há $count dias';
  }

  @override
  String timeWeeksAgo(String count) {
    return 'há $count semanas';
  }

  @override
  String timeMonthsAgo(String count) {
    return 'há $count meses';
  }

  @override
  String wishlistLecturesCount(String count) {
    return '$count aulas';
  }

  @override
  String get instructorProfileTitle => 'Perfil do instrutor';

  @override
  String instructorProfileLinkCopied(String name) {
    return 'Link de $name copiado para a área de transferência';
  }

  @override
  String get instructorDefaultName => 'Instrutor';

  @override
  String get instructorProfileBadge => 'INSTRUTOR';

  @override
  String get instructorProfileTotalStudents => 'Total de alunos';

  @override
  String get instructorProfileRating => 'Avaliação do instrutor';

  @override
  String get instructorProfileCourses => 'Cursos';

  @override
  String get instructorProfileShare => 'Compartilhar perfil';

  @override
  String get instructorProfileLinkOpenError =>
      'Não foi possível abrir o link, copiado para a área de transferência';

  @override
  String get instructorProfileWebsite => 'Site';

  @override
  String get instructorProfileAboutMe => 'Sobre mim';

  @override
  String get instructorProfileShowLess => 'Mostrar menos';

  @override
  String get instructorProfileShowMore => 'Mostrar mais';

  @override
  String get instructorProfileExpertise => 'Áreas de especialização';

  @override
  String get instructorProfileSortAll => 'Todos';

  @override
  String get instructorProfileSortTopRated => 'Mais bem avaliados';

  @override
  String get instructorProfileSortPopular => 'Populares';

  @override
  String get instructorProfileSortNewest => 'Mais recentes';

  @override
  String get instructorProfileCoursesTitle => 'Cursos do instrutor';

  @override
  String get instructorProfileNoCoursesFilter =>
      'Nenhum curso encontrado para este filtro';

  @override
  String instructorProfileLoadMoreCourses(String count) {
    return 'Carregar mais cursos ($count restantes)';
  }

  @override
  String get instructorProfileLoadingMoreCourses => 'Carregando mais cursos...';

  @override
  String instructorProfileAllCoursesLoaded(String count) {
    return 'Todos os $count cursos carregados';
  }

  @override
  String get instructorProfileStudentFeedback => 'Avaliações dos alunos';

  @override
  String instructorProfileReviewsCount(String count) {
    return '$count avaliações';
  }

  @override
  String instructorProfileBasedOnReviews(String count) {
    return 'Com base em $count avaliações';
  }

  @override
  String get instructorProfileRecentReviews => 'Avaliações recentes';

  @override
  String instructorProfileLoadMoreReviews(String count) {
    return 'Carregar mais avaliações ($count restantes)';
  }

  @override
  String get instructorProfileLoadingMoreReviews =>
      'Carregando mais avaliações...';

  @override
  String instructorProfileAllReviewsLoaded(String count) {
    return 'Todas as $count avaliações carregadas';
  }

  @override
  String get instructorProfileNoReviewsYet =>
      'Ainda não há comentários escritos';

  @override
  String get instructorProfileRatingDesc =>
      'A avaliação é baseada nas notas gerais dos alunos em todos os cursos do instrutor';

  @override
  String get instructorProfileLoadError =>
      'Falha ao carregar detalhes do instrutor, tente novamente mais tarde';

  @override
  String get instructorProfileDefaultStudentName => 'Aluno';

  @override
  String get instructorProfileDefaultHeadline =>
      'Instrutor sênior e especialista certificado';

  @override
  String get instructorProfileDefaultBio =>
      'Engenheiro de software certificado e instrutor técnico com ampla experiência no desenvolvimento de sistemas de software escaláveis e aplicativos móveis.\nTreinou milhares de alunos e engenheiros em todo o mundo, oferecendo conteúdo profissional com foco em Clean Code, Clean Architecture e soluções modernas e escaláveis.';

  @override
  String get supportNewChat => 'Novo chat';

  @override
  String get supportNoChatsTitle => 'Nenhum chat de suporte ainda';

  @override
  String get supportNoChatsDesc =>
      'Nossa equipe de suporte está pronta 24 horas por dia, 7 dias por semana, para ajudar e tirar suas dúvidas';

  @override
  String get supportStartNewConversation => 'Iniciar nova conversa';

  @override
  String get supportNoMessagesYet => 'Nenhuma mensagem ainda';

  @override
  String get supportRetry => 'Tentar novamente';

  @override
  String get supportOpenTicket => 'Ticket aberto';

  @override
  String get supportClosedTicket => 'Ticket fechado';

  @override
  String get supportCloseAction => 'Fechar';

  @override
  String get supportReopenAction => 'Reabrir';

  @override
  String get supportNoMessagesInChat => 'Nenhuma mensagem neste chat ainda';

  @override
  String get supportYou => 'Você';

  @override
  String get supportTeam => 'Equipe de suporte';

  @override
  String get supportTypeMessageHint => 'Digite sua mensagem aqui...';

  @override
  String get supportConversationClosedNotice =>
      'Esta conversa está encerrada no momento.';

  @override
  String get supportCloseDialogTitle => 'Fechar conversa?';

  @override
  String get supportCloseDialogDesc =>
      'Tem certeza de que deseja fechar este chat? Você pode reabri-lo a qualquer momento para continuar a conversa.';

  @override
  String get supportCancel => 'Cancelar';

  @override
  String get supportYesClose => 'Sim, fechar';

  @override
  String get supportNewChatTitle => 'Novo chat de suporte';

  @override
  String get supportNewChatSubtitle =>
      'Nossa equipe está aqui para ajudar você';

  @override
  String get supportSubjectLabel => 'Assunto';

  @override
  String get supportSubjectHint =>
      'ex.: Dúvida sobre o curso, Problema de pagamento...';

  @override
  String get supportMessageLabel => 'Mensagem';

  @override
  String get supportMessageHint =>
      'Descreva seu problema ou dúvida em detalhes...';

  @override
  String get supportMessageRequired => 'Por favor, digite uma mensagem';

  @override
  String get supportStartConversationBtn => 'Iniciar conversa';

  @override
  String get supportCreateError =>
      'Falha ao criar a conversa. Tente novamente mais tarde';

  @override
  String get supportTopicCourse => 'Dúvida sobre o curso';

  @override
  String get supportTopicPayment => 'Problema de pagamento';

  @override
  String get supportTopicCertificates => 'Certificados';

  @override
  String get supportTopicTech => 'Problema técnico';

  @override
  String get supportTopicGeneral => 'Dúvida geral';

  @override
  String get cartGuestTitle => 'Inicie sessão para ver o seu carrinho';

  @override
  String get cartGuestSubtitle =>
      'Inicie sessão para aceder ao seu carrinho e avançar para a compra de cursos.';

  @override
  String get wishlistGuestTitle =>
      'Inicie sessão para ver a sua lista de desejos';

  @override
  String get wishlistGuestSubtitle =>
      'Inicie sessão para aceder aos seus cursos guardados a qualquer momento.';

  @override
  String get courseDetailsLoginRequiredTitle => 'Início de sessão obrigatório';

  @override
  String get courseDetailsLoginRequiredDesc =>
      'Deve iniciar sessão primeiro para comprar este curso e guardar o seu progresso.';

  @override
  String get courseDetailsProceedToLogin => 'Ir para o início de sessão';

  @override
  String get messagesGuestTitle => 'Inicie sessão para ver as mensagens';

  @override
  String get messagesGuestSubtitle =>
      'Inicie sessão para aceder às conversas de suporte.';

  @override
  String get notificationsGuestTitle =>
      'Inicie sessão para ver as notificações';

  @override
  String get notificationsGuestSubtitle =>
      'Inicie sessão para ver as notificações mais recentes da sua conta e cursos.';

  @override
  String get legalTitle => 'Sobre e Informações Legais';

  @override
  String get legalTabAbout => 'Sobre o EduLab';

  @override
  String get legalTabPrivacy => 'Privacidade';

  @override
  String get legalTabTerms => 'Termos';

  @override
  String get legalUpdated => 'Atualizado:';

  @override
  String get legalNeedHelpTitle => 'Precisa de ajuda ou tem dúvidas?';

  @override
  String get legalNeedHelpDesc =>
      'A equipe de suporte da EduLab está disponível 24/7. Entre em contato conosco diretamente por e-mail.';

  @override
  String get legalEmailCopied =>
      'E-mail de suporte copiado para a área de transferência';

  @override
  String get legalNoContent => 'Nenhum conteúdo disponível no momento';

  @override
  String get checkoutDigitalReceipt => 'Recibo Digital';

  @override
  String get checkoutTransactionDate => 'Data da Transação';

  @override
  String get checkoutFreeEnrollment => 'Inscrição Gratuita';

  @override
  String get checkoutEnrolledCourses => 'Cursos Inscritos';

  @override
  String get checkoutTransactionStatus => 'Status';

  @override
  String get checkoutStatusSuccess => 'Concluído com Sucesso';

  @override
  String get checkoutTotalPaid => 'Valor Total Pago';

  @override
  String get checkoutCopied => 'Copiado!';

  @override
  String get checkoutCardHolderHint =>
      'Nome completo conforme consta no cartão';
}

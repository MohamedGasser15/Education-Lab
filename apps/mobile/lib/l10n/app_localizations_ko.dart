// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get onboardingSkip => '건너뛰기';

  @override
  String get onboardingTitle1 => 'EduLab에 오신 것을 환영합니다';

  @override
  String get onboardingSubtitle1 => '현대적인 대화형 학습과 지속적인 커리어 성장을 위한 최고의 플랫폼입니다.';

  @override
  String get onboardingTitle2 => '최고의 강사진에게 배우기';

  @override
  String get onboardingSubtitle2 =>
      '프로그래밍, 디자인, 비즈니스, 데이터 사이언스 분야의 수천 개 전문 강의.';

  @override
  String get onboardingTitle3 => '수료증과 확실한 성공';

  @override
  String get onboardingSubtitle3 => '학습 진도를 관리하고 시험을 통과하여 인정받는 수료증을 취득하세요.';

  @override
  String get onboardingNext => '다음';

  @override
  String get onboardingStart => '시작하기';

  @override
  String get splashAppName => 'Education Lab';

  @override
  String get splashTagline => '스마트 학습 플랫폼';

  @override
  String get loginTagline => '스마트 학습 플랫폼에 오신 것을 환영합니다';

  @override
  String get loginAppName => 'EduLab';

  @override
  String get loginTabLogin => '로그인';

  @override
  String get loginTabRegister => '회원가입';

  @override
  String get loginEmailLabel => '이메일';

  @override
  String get loginEmailHint => 'example@email.kr';

  @override
  String get loginPasswordLabel => '비밀번호';

  @override
  String get loginPasswordHint => '••••••';

  @override
  String get loginForgotPassword => '비밀번호를 잊으셨나요?';

  @override
  String get loginSubmit => '로그인';

  @override
  String get loginSubmitLoading => '로그인 중...';

  @override
  String get loginGuest => '게스트로 둘러보기';

  @override
  String get loginOr => '또는';

  @override
  String get loginEmailRequired => '이메일을 입력해주세요';

  @override
  String get loginEmailInvalid => '유효한 이메일 주소를 입력해주세요';

  @override
  String get loginPasswordRequired => '비밀번호를 입력해주세요';

  @override
  String get registerStepEmail => '이메일';

  @override
  String get registerStepCode => '인증코드';

  @override
  String get registerStepData => '정보입력';

  @override
  String get registerSendCodeInfo => '입력하신 이메일로 인증번호를 발송합니다';

  @override
  String get registerSendCode => '인증번호 발송';

  @override
  String get registerVerifying => '확인 중...';

  @override
  String get registerCodeSentTo => '발송된 이메일:';

  @override
  String get registerResendCode => '인증번호 재발송';

  @override
  String get registerBack => '뒤로';

  @override
  String get registerVerifyCode => '인증 완료';

  @override
  String get registerCodeIncomplete => '6자리 인증번호를 모두 입력해주세요';

  @override
  String get registerFullNameLabel => '이름';

  @override
  String get registerFullNameHint => '성함을 입력하세요';

  @override
  String get registerPasswordHint => '8자 이상, 대문자 및 숫자 포함';

  @override
  String get registerConfirmLabel => '비밀번호 확인';

  @override
  String get registerConfirmHint => '비밀번호를 다시 입력하세요';

  @override
  String get registerSubmit => '회원가입 완료';

  @override
  String get registerSubmitLoading => '가입 진행 중...';

  @override
  String get registerSuccess => '회원가입이 완료되었습니다';

  @override
  String get registerNameRequired => '이름을 입력해주세요';

  @override
  String get registerNameMinLength => '이름은 최소 6자 이상이어야 합니다';

  @override
  String get registerPasswordMinLength => '비밀번호는 최소 8자 이상이어야 합니다';

  @override
  String get registerPasswordUppercase => '대문자를 1자 이상 포함해야 합니다';

  @override
  String get registerPasswordNumber => '숫자를 1자 이상 포함해야 합니다';

  @override
  String get registerConfirmRequired => '비밀번호 확인을 입력해주세요';

  @override
  String get registerConfirmMismatch => '비밀번호가 일치하지 않습니다';

  @override
  String get networkError => '네트워크 연결 오류가 발생했습니다';

  @override
  String homeGreeting(String name) {
    return '안녕하세요, $name님!';
  }

  @override
  String get homeSubtitle => '오늘 어떤 지식을 배우고 싶으신가요?';

  @override
  String get homeSearchHint => '강의 또는 스킬 검색...';

  @override
  String get homeSectionContinue => '이어 학습하기';

  @override
  String get homeSectionRecommended => '맞춤 추천 강의';

  @override
  String get homeSectionPopular => '가장 인기 있는 강의';

  @override
  String get homeSectionTopRated => '최고 평점 강의';

  @override
  String get homeSectionByCategory => '카테고리별 탐색';

  @override
  String get homeHeroTitle => '특별 할인 프로모션';

  @override
  String get homeHeroSubtitle => '인기 강의 최대 70% 할인';

  @override
  String get homeHeroButton => '지금 확인하기';

  @override
  String get homeViewAll => '전체보기';

  @override
  String get homeProgressLabel => '완료';

  @override
  String get exploreTitle => '강의 탐색';

  @override
  String get exploreSearchHint => '강의명, 스킬, 강사명으로 검색...';

  @override
  String get exploreAllCategories => '전체 카테고리';

  @override
  String get exploreFilter => '필터';

  @override
  String get exploreSort => '정렬';

  @override
  String get exploreNoResults => '검색 결과가 없습니다';

  @override
  String get exploreNoResultsHint => '다른 검색어를 입력하거나 필터를 조정해보세요';

  @override
  String exploreCoursesCount(int count) {
    return '$count개 강의';
  }

  @override
  String get exploreFilterTitle => '필터 설정';

  @override
  String get exploreFilterApply => '적용하기';

  @override
  String get exploreFilterReset => '초기화';

  @override
  String get exploreFilterPrice => '가격';

  @override
  String get exploreFilterLevel => '난이도';

  @override
  String get exploreFilterRating => '평점';

  @override
  String get exploreFilterDuration => '강의 시간';

  @override
  String get exploreSortTitle => '정렬 기준';

  @override
  String get exploreSortRelevance => '추천순';

  @override
  String get exploreSortNewest => '최신순';

  @override
  String get exploreSortPopular => '인기순';

  @override
  String get exploreSortRating => '평점 높은순';

  @override
  String get exploreSortPriceLow => '가격 낮은순';

  @override
  String get exploreSortPriceHigh => '가격 높은순';

  @override
  String get explorePriceFree => '무료';

  @override
  String get exploreLevelBeginner => '입문/초급';

  @override
  String get exploreLevelIntermediate => '중급';

  @override
  String get exploreLevelAdvanced => '고급/전문가';

  @override
  String get learningTitle => '내 학습실';

  @override
  String get learningTabInProgress => '수강 중';

  @override
  String get learningTabCompleted => '수료 완료';

  @override
  String get learningTabSaved => '보관함';

  @override
  String get learningEmpty => '수강 중인 강의가 없습니다';

  @override
  String get learningEmptyHint => '새로운 강의를 찾아 수강해보세요';

  @override
  String get learningExploreButton => '강의 둘러보기';

  @override
  String learningProgress(int percent) {
    return '진도율 $percent%';
  }

  @override
  String get learningContinue => '이어듣기';

  @override
  String get learningViewCertificate => '수료증 보기';

  @override
  String get learningReview => '수강평 작성';

  @override
  String get learningLesson => '강';

  @override
  String get learningLessons => '강';

  @override
  String get cartTitle => '장바구니';

  @override
  String get cartEmpty => '장바구니가 비어 있습니다';

  @override
  String get cartEmptyHint => '배우고 싶은 강의를 담아보세요';

  @override
  String get cartExploreButton => '강의 찾기';

  @override
  String get cartPromoPlaceholder => '쿠폰 코드';

  @override
  String get cartPromoApply => '적용';

  @override
  String get cartPromoInvalid => '유효하지 않은 쿠폰입니다';

  @override
  String get cartSummary => '결제 금액 요약';

  @override
  String get cartSubtotal => '상품 총액';

  @override
  String get cartDiscount => '할인 금액';

  @override
  String get cartTotal => '총 결제금액';

  @override
  String get cartCheckout => '결제하기';

  @override
  String cartCourses(int count) {
    return '$count개 강의';
  }

  @override
  String get cartRemove => '삭제';

  @override
  String get cartGuarantee => '30일 100% 환불 보장';

  @override
  String get checkoutTitle => '주문 및 결제';

  @override
  String get checkoutStepPayment => '결제';

  @override
  String get checkoutStepReview => '확인';

  @override
  String get checkoutStepConfirm => '완료';

  @override
  String get checkoutOrderSummary => '주문 요약';

  @override
  String get checkoutTotal => '총액';

  @override
  String get checkoutPayNow => '결제하기';

  @override
  String get checkoutBack => '이전';

  @override
  String get checkoutNext => '다음';

  @override
  String get checkoutSecureSSL => '256비트 SSL 암호화 안전 결제';

  @override
  String get checkoutSuccessTitle => '결제가 완료되었습니다!';

  @override
  String get checkoutSuccessSubtitle => '지금 바로 강의실에서 수강하실 수 있습니다';

  @override
  String get checkoutGoToLearning => '내 강의실로 이동';

  @override
  String get checkoutPaymentMethod => '결제 수단';

  @override
  String get checkoutCardNumber => '카드 번호';

  @override
  String get checkoutCardName => '카드 소유자 이름';

  @override
  String get checkoutCardExpiry => '유효기간';

  @override
  String get checkoutCardCVV => 'CVC 번호';

  @override
  String get courseDetailsEnroll => '수강 신청하기';

  @override
  String get courseDetailsBuyNow => '바로 구매하기';

  @override
  String get courseDetailsAddToCart => '장바구니 담기';

  @override
  String get courseDetailsAddedToCart => '장바구니에 담겼습니다';

  @override
  String get courseDetailsAlreadyEnrolled => '이미 수강 중인 강의';

  @override
  String get courseDetailsGoToCourse => '강의실 입장';

  @override
  String get courseDetailsFree => '무료 강의';

  @override
  String courseDetailsStudents(String count) {
    return '$count명의 수강생';
  }

  @override
  String get courseDetailsRating => '평점';

  @override
  String get courseDetailsReviews => '개 수강평';

  @override
  String get courseDetailsLastUpdated => '최근 업데이트';

  @override
  String get courseDetailsCurriculum => '커리큘럼 목록';

  @override
  String get courseDetailsSection => '개 섹션';

  @override
  String get courseDetailsLessons => '개 강의';

  @override
  String get courseDetailsInstructor => '강사 소개';

  @override
  String get courseDetailsStudentsLabel => '수강생 수';

  @override
  String get courseDetailsCoursesLabel => '강의 수';

  @override
  String get courseDetailsReviewsLabel => '수강평 수';

  @override
  String get courseDetailsReviewsTitle => '생생한 수강생 후기';

  @override
  String get courseDetailsWhatLearn => '배우게 될 내용';

  @override
  String get courseDetailsRequirements => '수강 대상 및 선수 지식';

  @override
  String get courseDetailsDescription => '강의 상세 소개';

  @override
  String get courseDetailsIncludesTitle => '강의 혜택 및 포함 사항';

  @override
  String get courseDetailsHoursVideo => '시간 분량의 VOD 영상';

  @override
  String get courseDetailsArticles => '개의 학습 자료 및 아티클';

  @override
  String get courseDetailsMobileAccess => '모바일 및 태블릿 지원';

  @override
  String get courseDetailsCertificate => '공식 수료증 발급';

  @override
  String get courseDetailsLifetimeAccess => '무제한 평생 소장';

  @override
  String get lessonPlayerNotes => '필기 노트';

  @override
  String get lessonPlayerResources => '학습 자료';

  @override
  String get lessonPlayerDiscussion => '질문 및 토론';

  @override
  String get lessonPlayerPrev => '이전 강의';

  @override
  String get lessonPlayerNext => '다음 강의';

  @override
  String get lessonPlayerSpeed => '배속 설정';

  @override
  String get lessonPlayerQuality => '화질 설정';

  @override
  String get lessonPlayerCompleted => '강의 수강 완료';

  @override
  String get certificateTitle => '수료증서';

  @override
  String get certificatePresentedTo => '수여자';

  @override
  String get certificateCompletedCourse => '수료 과정명:';

  @override
  String get certificateIssuedOn => '발급일자';

  @override
  String get certificateVerificationId => '수료증 인증번호';

  @override
  String get certificateDownloadPDF => 'PDF 다운로드';

  @override
  String get certificateDownloadPNG => '이미지 다운로드';

  @override
  String get certificateCopyLink => '링크 복사';

  @override
  String get certificateLinkCopied => '링크가 복사되었습니다';

  @override
  String get profileTitle => '프로필';

  @override
  String get profileEditProfile => '프로필 수정';

  @override
  String get profileCourses => '수강 강의';

  @override
  String get profileCertificates => '수료증';

  @override
  String get profilePoints => '포인트';

  @override
  String get profileFollowers => '팔로워';

  @override
  String get profileFollowing => '팔로잉';

  @override
  String get profileBio => '한줄 소개';

  @override
  String get profileInstructor => '인증 강사';

  @override
  String get profileStudent => '수강생';

  @override
  String get profileLevel => '레벨';

  @override
  String get profileJoined => '가입일';

  @override
  String get profileShareProfile => '프로필 공유';

  @override
  String get profileMenuLearning => '내 강의실';

  @override
  String get profileMenuCertificates => '내 수료증';

  @override
  String get profileMenuPurchaseHistory => '구매 내역';

  @override
  String get profileMenuTeachApplication => '강사 지원하기';

  @override
  String get profileMenuAccountSecurity => '계정 보안';

  @override
  String get profileMenuNotifications => '알림 센터';

  @override
  String get profileMenuMessages => '쪽지함';

  @override
  String get profileMenuSettings => '환경설정';

  @override
  String get profileMenuSchedule => '학습 캘린더';

  @override
  String get profileMenuAssignments => '과제 제출함';

  @override
  String get profileMenuQuiz => '퀴즈/테스트';

  @override
  String get profileMenuLogout => '로그아웃';

  @override
  String get profileLogoutConfirm => '정말 로그아웃 하시겠습니까?';

  @override
  String get profileLogoutYes => '로그아웃';

  @override
  String get profileLogoutNo => '취소';

  @override
  String get editProfileTitle => '프로필 수정';

  @override
  String get editProfileSave => '저장하기';

  @override
  String get editProfileFullName => '이름';

  @override
  String get editProfileBio => '자기소개';

  @override
  String get editProfileEmail => '이메일';

  @override
  String get editProfilePhone => '휴대폰 번호';

  @override
  String get editProfileWebsite => '개인 웹사이트';

  @override
  String get editProfileSaved => '수정사항이 성공적으로 저장되었습니다';

  @override
  String get accountSecurityTitle => '계정 보안 센터';

  @override
  String get accountSecurityChangePassword => '비밀번호 변경';

  @override
  String get accountSecurityTwoFactor => '2단계 인증 활성화';

  @override
  String get accountSecurityActiveSessions => '로그인 기기 관리';

  @override
  String get accountSecurityDeleteAccount => '회원 탈퇴';

  @override
  String get purchaseHistoryTitle => '구매 내역';

  @override
  String get purchaseHistoryEmpty => '구매한 내역이 없습니다';

  @override
  String get purchaseHistoryGuarantee => '30일 100% 환불 보장';

  @override
  String get purchaseHistoryDate => '거래일';

  @override
  String get purchaseHistoryStatus => '상태';

  @override
  String get purchaseHistoryAmount => '금액';

  @override
  String get purchaseHistoryCompleted => '결제 완료';

  @override
  String get purchaseHistoryRefunded => '환불 완료';

  @override
  String get teachApplicationTitle => '강사 지원';

  @override
  String get teachApplicationSubmit => '지원서 제출하기';

  @override
  String get teachApplicationSent => '지원서가 접수되었습니다. 검토 후 연락드리겠습니다';

  @override
  String get notificationsTitle => '알림 센터';

  @override
  String get notificationsMarkAllRead => '모두 읽음으로 표시';

  @override
  String get notificationsMarkAllReadSnackbar => '모든 알림을 읽음 처리했습니다';

  @override
  String get notificationsEmpty => '새로운 알림이 없습니다';

  @override
  String get notification1Title => '학습 리마인더';

  @override
  String get notification1Message => '초보자를 위한 Flutter의 새로운 강의가 준비되었습니다';

  @override
  String get notification1Time => '5분 전';

  @override
  String get notification1Action => '강의 듣기';

  @override
  String get notification2Title => '수료증이 발급되었습니다!';

  @override
  String get notification2Message => 'UI/UX 디자인 과정을 성공적으로 수료하셨습니다.';

  @override
  String get notification2Time => '2시간 전';

  @override
  String get notification2Action => '수료증 확인';

  @override
  String get notification3Title => '회원 단독 특가 안내';

  @override
  String get notification3Message => '인기 프로그래밍 강의 최대 70% 할인';

  @override
  String get notification3Time => '1일 전';

  @override
  String get notification3Action => '특가 보기';

  @override
  String get notification4Title => '질문에 대한 강사님 답변';

  @override
  String get notification4Message => '강사님이 남기신 질문에 답변을 등록했습니다';

  @override
  String get notification4Time => '2일 전';

  @override
  String get notification4Action => '답변 보기';

  @override
  String get notification5Title => '강의 업데이트 소식';

  @override
  String get notification5Message => 'Python 강의에 새로운 실전 프로젝트가 추가되었습니다';

  @override
  String get notification5Time => '3일 전';

  @override
  String get messagesTitle => '쪽지함';

  @override
  String get settingsTitle => '앱 설정';

  @override
  String get settingsVideoDownload => '동영상 및 다운로드';

  @override
  String get settingsDownloadQuality => '기본 다운로드 화질';

  @override
  String get settingsWifiOnly => 'Wi-Fi 환경에서만 다운로드';

  @override
  String get settingsNotifications => '알림 및 사운드';

  @override
  String get settingsCourseNotifications => '강의 업데이트 및 쪽지 알림';

  @override
  String get settingsPromoNotifications => '할인 혜택 및 이벤트 알림';

  @override
  String get settingsAppearance => '화면 테마 및 언어';

  @override
  String get settingsDarkMode => '다크 모드';

  @override
  String get settingsDarkModeEnabled => '사용 (배터리 절약)';

  @override
  String get settingsDarkModeDisabled => '사용 안 함 (라이트 모드)';

  @override
  String get settingsLanguage => '앱 언어';

  @override
  String get settingsStorage => '저장공간 및 캐시';

  @override
  String get settingsClearCache => '캐시 데이터 삭제';

  @override
  String get settingsClearCacheSuccess => '캐시가 성공적으로 삭제되었습니다';

  @override
  String get settingsHelp => '고객지원 및 약관';

  @override
  String get settingsHelpCenter => '도움말 및 자주 묻는 질문';

  @override
  String get settingsTermsPrivacy => '이용약관 및 개인정보처리방침';

  @override
  String get settingsAbout => 'EduLab 정보';

  @override
  String get settingsVersion => '버전 v1.0.0';

  @override
  String get quizTitle => '학습 퀴즈';

  @override
  String get quizNext => '다음 문제';

  @override
  String get quizSubmit => '퀴즈 제출';

  @override
  String get quizScore => '퀴즈 점수';

  @override
  String get quizCorrectAnswers => '정답 수';

  @override
  String get scheduleTitle => '학습 캘린더';

  @override
  String get scheduleEmpty => '예정된 일정이 없습니다';

  @override
  String get scheduleJoin => '수업 입장';

  @override
  String get scheduleReminder => '알림 받기';

  @override
  String get assignmentsTitle => '과제 제출';

  @override
  String get assignmentsEmpty => '진행 중인 과제가 없습니다';

  @override
  String get assignmentsSubmit => '과제 제출하기';

  @override
  String get assignmentsDue => '제출 마감일';

  @override
  String get assignmentsSubmitted => '제출 완료';

  @override
  String get assignmentsPending => '채점 대기';

  @override
  String get languageArabic => '아랍어';

  @override
  String get languageEnglish => '영어';

  @override
  String get languageDialogTitle => '앱 언어 선택';

  @override
  String get languageSelect => '선택 완료';

  @override
  String get generalCancel => '취소';

  @override
  String get generalConfirm => '확인';

  @override
  String get generalSave => '저장';

  @override
  String get generalDelete => '삭제';

  @override
  String get generalEdit => '수정';

  @override
  String get generalClose => '닫기';

  @override
  String get generalBack => '뒤로';

  @override
  String get generalDone => '완료';

  @override
  String get generalOk => '확인';

  @override
  String get generalYes => '예';

  @override
  String get generalNo => '아니오';

  @override
  String get generalLoading => '로딩 중...';

  @override
  String get generalError => '오류가 발생했습니다';

  @override
  String get generalRetry => '다시 시도';

  @override
  String get generalNoInternet => '인터넷 연결이 원활하지 않습니다';

  @override
  String get generalFree => '무료';

  @override
  String get generalRating => '평점';

  @override
  String get generalStudents => '수강생';

  @override
  String get generalHours => '시간';

  @override
  String get generalMinutes => '분';

  @override
  String get generalBy => '강사:';

  @override
  String get navHome => '홈';

  @override
  String get navExplore => '탐색';

  @override
  String get navMyCourses => '내 학습';

  @override
  String get navCart => '장바구니';

  @override
  String get navAccount => '내 정보';

  @override
  String get homeSubGreeting => '오늘 배우고 싶은 스킬은 무엇인가요?';

  @override
  String get homeVisitor => '게스트';

  @override
  String get homePromoTitle => '특별 할인 프로모션';

  @override
  String get homePromoSubtitle => '인기 강의 최대 70% 할인';

  @override
  String get homePromoButton => '지금 확인하기';

  @override
  String get homePromoBadge => '단독 특가';

  @override
  String get homeContinueLearning => '이어 학습하기';

  @override
  String get homeMyCoursesLink => '내 강의실';

  @override
  String get homeLesson => '강';

  @override
  String homeStudentsCount(String count) {
    return '$count명의 수강생';
  }

  @override
  String get homeRecommendedTitle => '맞춤 추천 강의';

  @override
  String get homeRecommendedSubtitle => '관심 분야를 바탕으로 선별된 강의';

  @override
  String get homeBestsellersTitle => '베스트셀러';

  @override
  String get homeBestsellersSubtitle => '수강생 만족도가 높은 인기 강의';

  @override
  String get homeNewCoursesTitle => '신규 강의';

  @override
  String get homeNewCoursesSubtitle => '최신 트렌드를 반영한 신규 강의';

  @override
  String get homePopularTopicsTitle => '인기 토픽';

  @override
  String get homePopularTopicsSubtitle => '가장 수요가 높은 핵심 스킬 마스터';

  @override
  String get homeTopInstructorsTitle => '인기 강사진';

  @override
  String get homeTopInstructorsSubtitle => '공인된 분야별 전문가에게 직접 배우기';

  @override
  String get homeExploreCategoriesTitle => '카테고리 둘러보기';

  @override
  String get homeExploreCategoriesSubtitle => '나에게 꼭 맞는 강의 찾기';

  @override
  String get catAll => '전체';

  @override
  String get catWebDev => '웹 개발';

  @override
  String get catMobileApps => '모바일 앱';

  @override
  String get catDataScience => '데이터 사이언스';

  @override
  String get catUIUX => 'UI/UX 디자인';

  @override
  String get catBusiness => '비즈니스 및 경영';

  @override
  String get catAI => '인공지능 (AI)';

  @override
  String get catCyberSecurity => '정보보안 및 해킹';

  @override
  String get exploreNoResultsTitle => '검색 결과가 없습니다';

  @override
  String get exploreNoResultsSubtitle => '다른 검색어를 입력하거나 필터를 조정해보세요';

  @override
  String get exploreRecentSearches => '최근 검색어';

  @override
  String get exploreTopSearches => '인기 검색어';

  @override
  String get exploreBrowseCategories => '카테고리별 보기';

  @override
  String get exploreBrowseCategoriesSubtitle => '나에게 딱 맞는 강의 찾기';

  @override
  String get exploreBackToAll => '전체로 돌아가기';

  @override
  String get exploreClearAll => '초기화';

  @override
  String get exploreAvailableResults => '개의 검색 결과';

  @override
  String get exploreFilterBestseller => '베스트셀러';

  @override
  String get exploreFilterTopRated => '최고 평점';

  @override
  String get exploreFilterUnder50 => '5만원 이하';

  @override
  String get learningHeroTitle => '배움을 멈추지 마세요';

  @override
  String get learningSearchHint => '내 강의에서 검색...';

  @override
  String get learningFilterAll => '전체';

  @override
  String get learningFilterInProgress => '수강 중';

  @override
  String get learningFilterCompleted => '수료 완료';

  @override
  String get learningFilterDownloaded => '다운로드됨';

  @override
  String get learningEmptyTitle => '수강 중인 강의가 없습니다';

  @override
  String get learningEmptySubtitle => '새로운 강의를 찾아 수강해보세요';

  @override
  String get learningEmptySearch => '일치하는 강의가 없습니다';

  @override
  String get learningCompleted => '수료';

  @override
  String get learningCompletedBadge => '수료 완료';

  @override
  String learningLecturesCount(int count) {
    return '$count개 강의';
  }

  @override
  String get cartEmptyTitle => '장바구니가 비어 있습니다';

  @override
  String get cartEmptySubtitle => '배우고 싶은 강의를 담아보세요';

  @override
  String get cartCouponHint => '쿠폰 입력';

  @override
  String get cartCouponApply => '적용';

  @override
  String get cartCouponInvalid => '잘못된 쿠폰';

  @override
  String get cartCouponApplied => '쿠폰이 적용되었습니다';

  @override
  String get cartCouponDiscount => '쿠폰 할인금액';

  @override
  String get cartCouponsTitle => '보유 쿠폰';

  @override
  String get cartOrderSummary => '주문 내역';

  @override
  String get cartOriginalPrice => '정가';

  @override
  String get cartPlatformDiscount => '특별 할인';

  @override
  String get cartFinalTotal => '최종 결제금액';

  @override
  String cartItemsCount(int count) {
    return '$count개 강의';
  }

  @override
  String get cartRemovedSnackbar => '장바구니에서 삭제되었습니다';

  @override
  String get cartUndo => '되돌리기';

  @override
  String get cartAddButton => '장바구니 담기';

  @override
  String get cartAddedSnackbar => '장바구니에 담겼습니다';

  @override
  String get cartAlreadyInCart => '이미 장바구니에 있음';

  @override
  String get cartCheckoutButton => '주문 결제하기';

  @override
  String get cartRecommendedTitle => '추천 강의';

  @override
  String get cartRecommendedSubtitle => '함께 수강하면 좋은 강의';

  @override
  String get checkoutCreditCard => '신용/체크카드';

  @override
  String get checkoutSelectPayment => '결제 수단을 선택하세요';

  @override
  String get checkoutCardNumberLabel => '카드 번호';

  @override
  String get checkoutCardHolderLabel => '소유자 성명';

  @override
  String get checkoutExpiryLabel => '유효기간 (MM/YY)';

  @override
  String get checkoutCVVLabel => 'CVC/CVV';

  @override
  String get checkoutPersonalInfoTitle => '주문자 정보';

  @override
  String get checkoutFullNameLabel => '성명';

  @override
  String get checkoutFullNameHint => '성함을 입력하세요';

  @override
  String get checkoutFullNameRequired => '성명을 입력해주세요';

  @override
  String get checkoutPhoneLabel => '연락처';

  @override
  String get checkoutPhoneRequired => '연락처를 입력해주세요';

  @override
  String get checkoutPostalLabel => '우편번호';

  @override
  String get checkoutPostalRequired => '우편번호를 입력해주세요';

  @override
  String get checkoutBuyerInfo => '구매자 정보';

  @override
  String get checkoutSaveInfo => '다음 결제를 위해 정보 저장';

  @override
  String get checkoutMoneyBackGuarantee => '30일 무조건 환불 보장';

  @override
  String get checkoutContinueToPayment => '결제 진행하기';

  @override
  String get checkoutContinueToReview => '주문 확인하기';

  @override
  String get checkoutReviewConfirm => '확인 및 최종 결제';

  @override
  String get checkoutStartLearning => '학습 시작하기';

  @override
  String get checkoutBackHome => '홈으로 돌아가기';

  @override
  String get courseDetailsTitle => '강의 상세';

  @override
  String get courseDetailsShare => '공유하기';

  @override
  String get courseDetailsWhatYouWillLearn => '배우게 될 내용';

  @override
  String get courseDetailsLanguage => '강의 언어';

  @override
  String get courseDetailsCreatedBy => '지식공유자';

  @override
  String get courseDetailsPreviewLesson => '맛보기 강의 재생';

  @override
  String get courseDetailsHoursOnDemand => '시간 분량의 평생 소장 영상';

  @override
  String get courseDetailsFullLifetimeAccess => '무제한 평생 소장 권한';

  @override
  String get courseDetailsCertifiedCertificate => '인증된 공식 수료증 발급';

  @override
  String get courseDetailsComprehensiveContent => '체계적인 실전 커리큘럼';

  @override
  String get certTitle => '수료증서';

  @override
  String get certStudentNameLabel => '성명';

  @override
  String get certCourseLabel => '과정명';

  @override
  String get certInstructorLabel => '담당 강사';

  @override
  String get certIssueDateLabel => '발급 연월일';

  @override
  String get certCodeLabel => '수료증 ID';

  @override
  String get certVerifiedBadge => '공식 인증됨';

  @override
  String get certDownloadPDF => 'PDF 저장';

  @override
  String get certDownloadPNG => '이미지 저장';

  @override
  String get certCopyVerifyLink => '인증 링크 복사';

  @override
  String get certShare => '수료증 자랑하기';

  @override
  String get playerTabLessons => '커리큘럼';

  @override
  String get playerTabOverview => '강의 개요';

  @override
  String get playerTabNotes => '내 노트';

  @override
  String get playerTabQnA => '질문 & 답변';

  @override
  String get playerNextLesson => '다음 수업';

  @override
  String get profileWelcome => '환영합니다';

  @override
  String get profileLoginPrompt => '로그인하고 나만의 학습 공간을 확인하세요';

  @override
  String get profileLoginOrRegister => '로그인 / 회원가입';

  @override
  String get profileVerifiedStudent => '인증 수강생';

  @override
  String get profileLogout => '로그아웃';

  @override
  String get profileCancel => '취소';

  @override
  String get profileLogoutConfirmTitle => '로그아웃 확인';

  @override
  String get profileLogoutConfirmMessage => '로그아웃하시겠습니까?';

  @override
  String get profileAccountSettings => '계정 관리';

  @override
  String get profileEditProfileSubtitle => '개인정보 및 프로필 변경';

  @override
  String get profileSecurity => '보안 설정';

  @override
  String get profileSecuritySubtitle => '비밀번호 및 2단계 인증';

  @override
  String get profilePurchaseHistory => '결제 내역';

  @override
  String get profilePurchaseHistorySubtitle => '주문 내역 및 영수증 확인';

  @override
  String get profileCertificatesSubtitle => '취득한 공식 수료증 확인';

  @override
  String get profileTeach => 'EduLab 강사 지원';

  @override
  String get profileTeachSubtitle => '지식을 나누고 수익을 창출하세요';

  @override
  String get profilePreferences => '앱 환경설정';

  @override
  String get profilePreferencesSubtitle => '테마 및 언어 변경';

  @override
  String get profileNotifications => '알림 설정';

  @override
  String get profileNotificationsSubtitle => '푸시 및 이메일 알림 관리';

  @override
  String get profileHelpSupport => '고객지원 및 도움말';

  @override
  String get profileTerms => '이용약관';

  @override
  String get profilePrivacy => '개인정보 처리방침';

  @override
  String get profileAboutEduLab => 'EduLab 소개';

  @override
  String get profileWishlist => '위시리스트';

  @override
  String get securityTitle => '계정 보안 센터';

  @override
  String get teachTitle => '강사 지원';

  @override
  String get notificationsTabAll => '전체';

  @override
  String get notificationsTabCourses => '강의 알림';

  @override
  String get notificationsTabPromos => '혜택/이벤트';

  @override
  String get notificationsEmptyTitle => '알림이 없습니다';

  @override
  String get notificationsUnread => '안 읽음';

  @override
  String get wishlistTitle => '위시리스트';

  @override
  String get wishlistEmptyTitle => '위시리스트가 비어 있습니다';

  @override
  String get wishlistEmptySubtitle => '관심 있는 강의를 찜해두고 나중에 확인하세요';

  @override
  String get wishlistAddToCart => '장바구니 담기';

  @override
  String get wishlistRemovedSnackbar => '위시리스트에서 삭제되었습니다';

  @override
  String get homeDefaultUser => '수강생';

  @override
  String get learningOf => '/';

  @override
  String get cartInCartBadge => '담김';

  @override
  String get homePromo1Badge => '기간 한정 • 특별 할인';

  @override
  String get homePromo1Title => '최적의 가격으로 학습을 시작하세요';

  @override
  String get homePromo1Subtitle => '프로그래밍, 디자인, 비즈니스 강의 최대 65% 할인.';

  @override
  String get homePromo1Button => '할인 보기';

  @override
  String get homePromo2Badge => '공인 커리어 트랙';

  @override
  String get homePromo2Title => '꿈의 직업을 위한 실전 준비';

  @override
  String get homePromo2Subtitle => '실전 프로젝트와 수료증이 포함된 입문부터 전문가까지의 완성형 강의.';

  @override
  String get homePromo2Button => '트랙 둘러보기';

  @override
  String get homePromo3Badge => '업계 최고 수준의 강사진';

  @override
  String get homePromo3Title => '현업 최고 전문가에게 직접 배우세요';

  @override
  String get homePromo3Subtitle => '최신 트렌드 기술을 반영하여 지속적으로 업데이트되는 고품질 콘텐츠.';

  @override
  String get homePromo3Button => '지금 시작하기';

  @override
  String get homePromoInstructorBadge => 'EduLab에서 강의하기 • 지식 공유';

  @override
  String get homePromoInstructorTitle => '지금 바로 강사가 되어보세요';

  @override
  String get homePromoInstructorSubtitle =>
      '전 세계 수강생들에게 영감을 주고, 강좌를 개설하여 좋아하는 일을 가르치며 수익을 창출하세요.';

  @override
  String get homePromoInstructorButton => '지금 지원하기';

  @override
  String get homeSearchFilter => '필터';

  @override
  String get securitySectionChangePassword => '비밀번호 변경';

  @override
  String get securityCurrentPasswordLabel => '현재 비밀번호 *';

  @override
  String get securityCurrentPasswordError => '현재 비밀번호를 입력하세요';

  @override
  String get securityNewPasswordLabel => '새 비밀번호 *';

  @override
  String get securityNewPasswordError => '8자 이상이어야 합니다';

  @override
  String get securityConfirmPasswordLabel => '새 비밀번호 확인 *';

  @override
  String get securityConfirmPasswordError => '비밀번호가 일치하지 않습니다';

  @override
  String get securityUpdatePasswordBtn => '비밀번호 업데이트';

  @override
  String get securityPasswordUpdatedSuccess => '비밀번호가 성공적으로 변경되었습니다!';

  @override
  String get securitySection2FA => '2단계 인증 (2FA)';

  @override
  String get security2FATitle => '2단계 인증';

  @override
  String get security2FAEnabledDesc => '활성화됨 - 보안 코드로 계정 보호';

  @override
  String get security2FADisabledDesc => '비활성화됨 (활성화 권장)';

  @override
  String get security2FASetupTitle => '2단계 인증 활성화';

  @override
  String get security2FASetupContent =>
      '새로운 기기에서 로그인할 때마다 등록된 이메일로 6자리 인증 코드가 전송됩니다.';

  @override
  String get security2FAEnableNow => '지금 활성화';

  @override
  String get security2FAEnabledSuccess => '2단계 인증이 활성화되었습니다!';

  @override
  String get security2FADisabledSuccess => '2단계 인증이 비활성화되었습니다';

  @override
  String get securitySectionSessions => '로그인된 기기 및 세션';

  @override
  String get securityLogoutAllDevices => '모든 기기에서 로그아웃';

  @override
  String get securityThisDevice => '현재 기기';

  @override
  String get securitySessionRevokedSuccess => '해당 기기에서 로그아웃되었습니다.';

  @override
  String get securityAllSessionsRevokedSuccess => '다른 모든 기기에서 로그아웃되었습니다.';

  @override
  String get purchaseHistoryInvoiceCertified => '공인 전자 영수증';

  @override
  String get purchaseHistoryInvoiceNumber => '영수증 번호';

  @override
  String get purchaseHistoryCourse => '강좌';

  @override
  String get purchaseHistoryPaymentMethod => '결제 수단';

  @override
  String get purchaseHistoryTotalAmount => '총 금액:';

  @override
  String get purchaseHistoryClose => '닫기';

  @override
  String get purchaseHistoryDownloadPdf => 'PDF 다운로드';

  @override
  String get purchaseHistoryPdfDownloaded => '영수증 PDF가 다운로드되었습니다';

  @override
  String get purchaseHistoryRefundRequestTitle => '환불 요청';

  @override
  String get purchaseHistoryRefundPolicy =>
      'EduLab 30일 환불 보장 정책에 따라 전액 환불을 받으실 수 있습니다.';

  @override
  String get purchaseHistoryRefundReasonHint => '환불 사유 (선택 사항)...';

  @override
  String get purchaseHistoryConfirmRefund => '환불 확인';

  @override
  String get purchaseHistoryRefundSubmitted =>
      '환불 요청이 제출되었습니다 (영업일 기준 3-5일 소요).';

  @override
  String get purchaseHistoryInstructor => '강사';

  @override
  String get purchaseHistoryRequestRefundBtn => '환불 신청';

  @override
  String get purchaseHistoryInvoiceBtn => '영수증';

  @override
  String get purchaseHistoryStatusCompleted => '완료됨';

  @override
  String get purchaseHistoryStatusRefunded => '환불됨';

  @override
  String get purchaseHistoryStatusProcessingRefund => '환불 처리 중';

  @override
  String get editProfileSectionBasicInfo => '기본 정보';

  @override
  String get editProfileFullNameLabel => '성명 *';

  @override
  String get editProfileFullNameHint => '성명을 입력하세요';

  @override
  String get editProfileFullNameError => '이름을 올바르게 입력하세요';

  @override
  String get editProfileHeadlineLabel => '직함 / 전문 분야';

  @override
  String get editProfileHeadlineHint => '예: 시니어 Flutter 개발자';

  @override
  String get editProfileLocationLabel => '도시 / 국가';

  @override
  String get editProfileLocationHint => '서울, 대한민국';

  @override
  String get editProfilePhoneLabel => '휴대전화 번호';

  @override
  String get editProfileBioLabel => '자기소개 (Bio)';

  @override
  String get editProfileBioHint => '관심사 및 경험에 대해 간략히 작성해 주세요...';

  @override
  String get editProfileSectionLinks => '링크 및 소셜 네트워크';

  @override
  String get editProfileWebsiteLabel => '개인 웹사이트';

  @override
  String get editProfileSectionEmail => '등록된 이메일';

  @override
  String get editProfileEmailDesc => '로그인 및 수료증 수령에 사용됩니다';

  @override
  String get editProfileEmailVerified => '인증됨';

  @override
  String get editProfileSaveChangesBtn => '정보 저장 및 업데이트';

  @override
  String get editProfileSavedSuccess => '프로필이 성공적으로 업데이트되었습니다!';

  @override
  String get editProfileChangeAvatarTitle => '프로필 사진 변경';

  @override
  String get editProfileTakePhoto => '카메라로 촬영';

  @override
  String get editProfileChooseGallery => '갤러리에서 선택';

  @override
  String get editProfilePhotoUpdatedSuccess => '프로필 사진이 업데이트되었습니다';

  @override
  String get teachJoinInstructorTitle => '공인 강사로 참여하기';

  @override
  String get teachJoinInstructorSubtitle => '강좌를 개설하고 수많은 수강생과 지식을 공유하세요.';

  @override
  String get teachStep1Title => '개인 정보';

  @override
  String get teachStep2Title => '경력 및 기술';

  @override
  String get teachStep3Title => '신청 확인';

  @override
  String get teachStep1Header => '1. 개인 및 직무 정보';

  @override
  String get teachFullNameArabicLabel => '성명 *';

  @override
  String get teachFullNameArabicHint => '예: 홍길동';

  @override
  String get teachHeadlineLabel => '직무 및 전문 분야 *';

  @override
  String get teachHeadlineHint => '예: 수석 소프트웨어 엔지니어 및 Flutter 강사';

  @override
  String get teachPhoneLabel => '연락처 *';

  @override
  String get teachCountryLabel => '거주 국가 *';

  @override
  String get teachBioLabel => '소개 및 주요 경력 *';

  @override
  String get teachBioHint => '주요 경력 및 과거 프로젝트에 대해 간략히 설명해 주세요...';

  @override
  String get teachNextStepSkills => '다음: 경력 및 기술';

  @override
  String get teachStep2Header => '2. 강좌 내용 및 기술';

  @override
  String get teachTopicLabel => '개설 희망 강좌 주제 *';

  @override
  String get teachTopicHint => '예: 기초부터 배우는 Flutter 앱 개발';

  @override
  String get teachYearsExperienceLabel => '해당 분야 경력 (년) *';

  @override
  String get teachVideoLinkLabel => '샘플 강의 영상 링크 (YouTube/Drive/Loom) *';

  @override
  String get teachTargetAudienceLabel => '강좌 대상 수강생 *';

  @override
  String get teachAudienceBeginners => '완전 초보자';

  @override
  String get teachAudienceIntermediate => '초급 및 중급자';

  @override
  String get teachAudienceAdvanced => '고급 및 전문가';

  @override
  String get teachAudienceAll => '모든 대상';

  @override
  String get teachSkillsCoveredLabel => '강좌에서 다룰 주요 기술 및 스택 *';

  @override
  String get teachAddSkillHint => '기술 추가 (예: GraphQL)...';

  @override
  String get teachAddSkillBtn => '추가';

  @override
  String get teachNextStepConfirm => '다음: 신청 확인';

  @override
  String get teachStep3Header => '3. 정산 정보 및 약관 동의';

  @override
  String get teachPayoutMethodLabel => '수익금 수령 방법 *';

  @override
  String get teachPayoutMethodBank => '은행 계좌 입금 (IBAN)';

  @override
  String get teachPayoutMethodPaypal => '인증된 PayPal 계정';

  @override
  String get teachPayoutMethodPayoneer => 'Payoneer 카드';

  @override
  String get teachIbanDetailsLabel => '계좌 정보 / IBAN *';

  @override
  String get teachApplicationSummary => '신청 요약:';

  @override
  String get teachApplicantName => '신청자';

  @override
  String get teachApplicantHeadline => '직무';

  @override
  String get teachApplicantTopic => '강좌 주제';

  @override
  String get teachApplicantSkillsCount => '등록된 기술 수';

  @override
  String get teachSkillsUnit => '개 기술';

  @override
  String get teachAgreeTermsLabel => 'EduLab 강사 약관 및 지적 재산권 보호 규정에 동의합니다.';

  @override
  String get teachSubmitApplicationBtn => 'Submit Instructor Application';

  @override
  String get teachPrevStepBtn => '이전';

  @override
  String get teachWhyEduLabTitle => 'EduLab에서 강의해야 하는 이유';

  @override
  String get teachProp1Title => '공정하고 높은 수익 배분';

  @override
  String get teachProp1Desc => '숨겨진 수수료 없이 강좌 판매 수익의 최대 80%를 지급받으세요.';

  @override
  String get teachProp2Title => '수많은 수강생에게 홍보';

  @override
  String get teachProp2Desc => '활발한 학습 커뮤니티에 강좌를 소개하고 전문성을 알리세요.';

  @override
  String get teachProp3Title => '전문 제작 및 기술 지원';

  @override
  String get teachProp3Desc => '음질, 영상 퀄리티 및 커리큘럼 디자인을 전문 팀이 도와드립니다.';

  @override
  String get teachSuccessDialogTitle => '신청서가 성공적으로 접수되었습니다!';

  @override
  String get teachSuccessDialogDesc =>
      'EduLab 강사로 신청해 주셔서 감사합니다. 담당 부서에서 검토 후 48시간 이내에 이메일로 안내해 드립니다.';

  @override
  String get teachSuccessDialogOk => '확인';

  @override
  String get teachAddOneSkillError => '기술을 하나 이상 추가해 주세요';

  @override
  String get teachAgreeTermsError => '강사 약관에 동의해 주세요';

  @override
  String get commonCancel => '취소';

  @override
  String get commonClose => '닫기';

  @override
  String get myCertificatesBannerTitle => '인증 수료증';

  @override
  String get myCertificatesBannerSubtitle =>
      '모든 수료증은 EduLab의 고유 ID로 인증 및 검증됩니다.';

  @override
  String get certBadgeVerified100 => '100% 인증';

  @override
  String get certCodeCopied => '수료증 코드가 복사되었습니다';

  @override
  String get certGrantedTo => '수여 대상';

  @override
  String get certViewAndDownload => '수료증 보기 및 다운로드';

  @override
  String get certIssuerLabel => '발급 기관';

  @override
  String get certIssuerName => 'EduLab 인터랙티브 러닝 아카데미';

  @override
  String get certEmptyTitle => '아직 획득한 수료증이 없습니다';

  @override
  String get certEmptyDesc => '등록된 코스를 100% 완료하고 공식 인증 ID가 포함된 수료증을 받으세요.';

  @override
  String get certEmptyAction => '내 코스 계속하기';

  @override
  String get certDetailsTitle => '수료증 상세 정보';

  @override
  String get certCopyLinkSuccess => '직접 검증 링크가 클립보드에 복사되었습니다!';

  @override
  String get certShareSuccess => '공유를 위해 수료증 세부 정보와 링크가 복사되었습니다!';

  @override
  String get purchaseHistoryTaxInvoiceCertified => '공식 인증 세금계산서';

  @override
  String get purchaseHistoryInvoiceNumberLabel => '주문 / 인보이스 번호';

  @override
  String get purchaseHistoryCourseNameLabel => '코스 이름';

  @override
  String get purchaseHistoryPurchaseDateLabel => '구매 날짜';

  @override
  String get purchaseHistoryPaymentMethodLabel => '결제 수단';

  @override
  String get purchaseHistoryPaymentMethodValue => '신용카드 / Stripe (온라인)';

  @override
  String get purchaseHistoryOrderStatusLabel => '주문 상태';

  @override
  String get purchaseHistoryStatusPendingReview => '환불 검토 대기 중';

  @override
  String get purchaseHistoryCopyInvoiceBtn => '인보이스 번호 복사';

  @override
  String get purchaseHistoryRefundReasonLabel => '환불 요청 사유:';

  @override
  String get purchaseHistoryRefundReasonEmptyError => '환불 요청 사유를 입력해 주세요';

  @override
  String get purchaseHistorySubmittingRefund => '요청 제출 중...';

  @override
  String get purchaseHistoryPaidDate => '결제일';

  @override
  String get purchaseHistoryEmptyTitle => '구매 내역이 아직 없습니다';

  @override
  String get purchaseHistoryEmptyDesc =>
      '아직 구매한 코스가 없습니다.\n완료되면 주문 및 인보이스가 여기에 표시됩니다.';

  @override
  String get purchaseHistoryExploreCourses => '지금 코스 탐색하기';

  @override
  String get profileMyCourses => '내 코스';

  @override
  String get profileMyCoursesSubtitle => '등록한 코스의 진행 상황 추적';

  @override
  String get profileWishlistSubtitle => '위시리스트에 저장된 코스';

  @override
  String get navMyLearning => '내 학습';

  @override
  String get profileLogoutSafeNote =>
      '데이터, 코스 및 수료증은 안전하게 보관됩니다. 다시 로그인하면 언제든지 학습을 계속할 수 있습니다.';

  @override
  String learningRemainingHours(String hours) {
    return '$hours시간 남음';
  }

  @override
  String get learningCompletedFull => '완료됨';

  @override
  String get learningFilterNotStarted => '시작되지 않음';

  @override
  String get wishlistTopRatedBadge => '최고 평점';

  @override
  String get wishlistFeaturedBadge => '추천';

  @override
  String wishlistDiscountBadge(String percent) {
    return '$percent% 할인';
  }

  @override
  String get courseFree => '무료';

  @override
  String get badgeBestseller => '베스트셀러';

  @override
  String get badgeTopRated => '최고 평점';

  @override
  String get badgeFeatured => '추천';

  @override
  String get badgeRecommended => '회원님을 위한 추천';

  @override
  String get badgeNew => '신규';

  @override
  String get courseWord => '강좌';

  @override
  String coursesCountText(String count) {
    return '$count+ 강좌';
  }

  @override
  String studentsCountText(String count) {
    return '$count명의 수강생';
  }

  @override
  String hoursCountText(String count) {
    return '$count시간';
  }

  @override
  String get certifiedInstructor => '공인 강사';

  @override
  String get expertCertifiedInstructor => '전문가 및 공인 강사';

  @override
  String get defaultCourseTitle => '교육 과정';

  @override
  String get categoryWord => '카테고리';

  @override
  String get previewCourseVideo => '강의 미리보기 동영상';

  @override
  String get freeSection => '무료 섹션';

  @override
  String get freeDemoVideo => '무료 데모 영상';

  @override
  String get articleLecture => '아티클 강의';

  @override
  String get articleViewer => '아티클 뷰어';

  @override
  String get courseVideoPlayer => '강의 동영상 플레이어';

  @override
  String get playingNow => '재생 중';

  @override
  String get readingNow => '읽는 중';

  @override
  String get noLecturesInFreeSection => '무료 섹션에 강의가 없습니다';

  @override
  String freeLecturesCount(String count) {
    return '$count개의 무료 강의';
  }

  @override
  String get enrollInFullCourse => '전체 과정 등록하기';

  @override
  String get articleWord => '아티클';

  @override
  String get videoWord => '비디오';

  @override
  String get quizWord => '퀴즈';

  @override
  String get courseShareCopied => '강의 링크가 클립보드에 복사되었습니다!';

  @override
  String get addedToCartSnackbar => '장바구니에 추가되었습니다';

  @override
  String get viewCartAction => '장바구니 보기';

  @override
  String get inCartBadge => '장바구니 담김 ✓';

  @override
  String get addToCartButton => '장바구니 담기';

  @override
  String get wishlistAddedSnackbar => '위시리스트에 추가되었습니다';

  @override
  String get wishlistRemovedSuccessSnackbar => '위시리스트에서 삭제되었습니다';

  @override
  String get lessonCompletedAll => '축하합니다! 이 과정의 모든 강의를 완료했습니다.';

  @override
  String get noteAddedSuccess => '메모가 성공적으로 추가되었습니다';

  @override
  String get lessonAlreadyDownloaded => '오프라인 시청을 위해 이미 저장된 강의입니다';

  @override
  String get lessonLinkCopied => '강의 링크가 복사되었습니다';

  @override
  String get contentReportThanks => '의견 감사합니다. 팀에서 검토하겠습니다.';

  @override
  String get courseCompletionCertificate => '과정 수료증';

  @override
  String get reportContentIssue => '콘텐츠 문제 신고';

  @override
  String get loginOrSocial => '또는 다음으로 로그인';

  @override
  String get loginSuccessSnackbar => '로그인 성공';

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
  String get cartClearAllTitle => '장바구니의 모든 항목을 삭제하시겠습니까?';

  @override
  String cartClearAllMessage(String count) {
    return '장바구니에서 $count개의 강좌를 모두 삭제하시겠습니까?';
  }

  @override
  String get cartClearAllHint => '모든 강좌가 장바구니에서 삭제됩니다. 언제든지 다시 추가할 수 있습니다.';

  @override
  String cartClearAllConfirm(String count) {
    return '모두 삭제 ($count)';
  }

  @override
  String get cartClearedSuccess => '장바구니를 성공적으로 비웠습니다';

  @override
  String get cartClearFailed => '장바구니 비우기 실패';

  @override
  String cartViewWishlistCount(String count) {
    return '위시리스트 항목 보기 ($count)';
  }

  @override
  String get cartGoToWishlist => '위시리스트로 이동';

  @override
  String get wishlistClearAllTitle => '위시리스트의 모든 항목을 삭제하시겠습니까?';

  @override
  String wishlistClearAllMessage(String count) {
    return '위시리스트에서 $count개의 강좌를 모두 삭제하시겠습니까?';
  }

  @override
  String get wishlistClearAllHint =>
      '저장된 모든 강좌가 삭제됩니다. 둘러보기에서 언제든지 다시 추가할 수 있습니다.';

  @override
  String wishlistClearAllConfirm(String count) {
    return '모두 삭제 ($count)';
  }

  @override
  String get wishlistClearedSuccess => '위시리스트를 성공적으로 비웠습니다';

  @override
  String get wishlistClearFailed => '위시리스트 비우기 실패';

  @override
  String get wishlistClearTooltip => '모두 비우기';

  @override
  String wishlistViewCartCount(String count) {
    return '장바구니 항목 보기 ($count)';
  }

  @override
  String get wishlistGoToCart => '장바구니로 이동';

  @override
  String get checkoutCardNumberInvalid => '올바른 16자리 카드 번호를 입력해 주세요';

  @override
  String get checkoutCardExpiryInvalidFormat =>
      '올바른 카드 유효기간을 입력해 주세요 (MM / YY)';

  @override
  String get checkoutCardExpiredDate => '카드 유효기간이 지났거나 잘못되었습니다';

  @override
  String get checkoutCardCvcInvalid => '올바른 3자리 또는 4자리 CVC 코드를 입력해 주세요';

  @override
  String get checkoutCardHolderNameRequired => '카드 소유자 이름을 입력해 주세요';

  @override
  String get checkoutCartEmptySnackbar => '장바구니가 비어 있습니다';

  @override
  String get checkoutPaymentStartFailed => '결제 시작 실패';

  @override
  String get checkoutClientSecretMissing => '결제 게이트웨이로부터 보안 키를 받지 못했습니다';

  @override
  String get checkoutCardVerificationFailed => '카드 인증에 실패했습니다';

  @override
  String get checkoutStripeProcessingFailed => 'Stripe 결제 처리에 실패했습니다';

  @override
  String get checkoutServerConfirmationFailed => '서버 결제 확인에 실패했습니다';

  @override
  String get checkoutEmptyCartTitle => '장바구니가 비어 있습니다';

  @override
  String get checkoutEmptyCartDesc =>
      '장바구니에 추가된 강좌가 아직 없습니다. 강좌를 둘러보고 학습을 시작해 보세요!';

  @override
  String get checkoutContinueFreeReview => '무료 검토로 계속';

  @override
  String get checkoutFreeOrderBadge => '100% 무료 주문 (zsh.00)';

  @override
  String get checkoutFreeOrderNotice =>
      '이 주문에는 결제 정보가 필요하지 않습니다. 바로 등록 확인을 진행하실 수 있습니다.';

  @override
  String get checkoutFreeCheckoutTitle => '100% 무료 결제';

  @override
  String get checkoutConfirmFreeEnrollment => '무료 등록 확인';

  @override
  String get checkoutFreePrice => '무료';

  @override
  String get checkoutFreeZero => '무료 (zsh.00)';

  @override
  String checkoutCoursesCount(String count) {
    return '$count개 강좌';
  }

  @override
  String get notificationsClearAllTitle => '모든 알림을 삭제하시겠습니까?';

  @override
  String notificationsClearAllMessage(String count) {
    return '$count개의 알림을 모두 삭제하시겠습니까? 이 작업은 되돌릴 수 없습니다.';
  }

  @override
  String get notificationsClearAllHint => '모든 알림이 삭제되고 수신함이 깨끗해집니다.';

  @override
  String notificationsClearAllConfirm(String count) {
    return '모두 삭제 ($count)';
  }

  @override
  String get notificationsClearSuccess => '모든 알림이 성공적으로 삭제되었습니다';

  @override
  String get notificationsClearFailed => '알림 삭제 실패';

  @override
  String get notificationsClearTooltip => '모두 지우기';

  @override
  String get notificationsViewDetails => '상세 정보 보기';

  @override
  String get notificationsEmptyCategoryTitle => '이 카테고리에 알림이 없습니다';

  @override
  String get notificationsEmptyCategorySubtitle =>
      '다른 카테고리로 변경하거나 전체 알림을 확인해 보세요';

  @override
  String get notificationsEmptyAllSubtitle => '최신 업데이트와 알림이 여기에 표시됩니다';

  @override
  String get notificationsViewAll => '모든 알림 보기';

  @override
  String get learningFilterAndSortTitle => '강좌 필터 및 정렬';

  @override
  String get learningFilterReset => '초기화';

  @override
  String get learningSortByTitle => '정렬 기준';

  @override
  String get learningSortRecentActivity => '최근 이용순';

  @override
  String get learningSortRecentEnrolled => '최근 등록순';

  @override
  String get learningSortTitleAZ => '제목순 (A-Z)';

  @override
  String get learningSortProgress => '진도율 %';

  @override
  String get learningStatusTitle => '강좌 상태';

  @override
  String get learningStatusAll => '모든 강좌';

  @override
  String get learningStatusInProgress => '진행 중';

  @override
  String get learningStatusCompleted => '완전한';

  @override
  String get learningStatusNotStarted => '시작되지 않음';

  @override
  String get learningFilterApply => '필터 적용';

  @override
  String get learningSearchCoursesHint => '강좌 검색...';

  @override
  String get learningSearchWishlistHint => '위시리스트 검색...';

  @override
  String get learningSearchCertificatesHint => '인증서 검색...';

  @override
  String get learningTabMyCourses => '내 코스';

  @override
  String get learningTabFavourite => '내가 가장 좋아하는';

  @override
  String get learningTabCertificates => '내 인증서';

  @override
  String get learningNoCoursesTitle => '아직 강좌가 없습니다.';

  @override
  String get learningNoCoursesSubtitle =>
      '수천 개의 프리미엄 강좌를 살펴보고 지금 학습 여정을 시작하세요.';

  @override
  String get learningFilterButton => '필터';

  @override
  String learningFilterAllCount(String count) {
    return '모두($count)';
  }

  @override
  String get learningStatusNotStartedShort => '시작되지 않음';

  @override
  String get learningNoMatchTitle => '일치하는 강좌가 없습니다.';

  @override
  String learningNoMatchSubtitle(String query) {
    return '\"$query\"을(를) 포함하는 강좌를 찾을 수 없습니다. 다른 용어로 검색해 보세요.';
  }

  @override
  String get learningNoInProgressTitle => '진행 중인 강좌가 없습니다.';

  @override
  String get learningNoInProgressSubtitle =>
      '여기에서 진행 상황을 추적하려면 등록된 과정의 수업을 시청하세요.';

  @override
  String get learningNoCompletedTitle => '아직 완료된 과정이 없습니다.';

  @override
  String get learningNoCompletedSubtitle =>
      '학습을 계속하여 발전을 축하하고 여기에서 완료된 과정을 확인하세요.';

  @override
  String get learningNoUnstartedTitle => '시작되지 않은 강좌 없음';

  @override
  String get learningNoUnstartedSubtitle =>
      '엄청난! 귀하는 이미 등록한 모든 강좌에서 학습을 시작했습니다.';

  @override
  String get learningNoFilterMatchTitle => '이 필터와 일치하는 강좌가 없습니다.';

  @override
  String get learningNoFilterMatchSubtitle => '코스를 표시하려면 필터 또는 정렬 옵션을 변경하세요.';

  @override
  String learningViewAllCoursesCount(String count) {
    return '모든 강좌 보기($count)';
  }

  @override
  String learningSavedCoursesCount(String count) {
    return '저장된 강좌($count)';
  }

  @override
  String get learningClearAllSaved => '모두 지우기';

  @override
  String get learningNoCertificatesTitle => '아직 인증서가 없습니다.';

  @override
  String get learningNoCertificatesSubtitle =>
      '과정을 완료하여 성취도를 입증하는 공인 인증서를 획득하세요.';

  @override
  String get learningGoToCourses => '내 강좌로 이동';

  @override
  String learningCertIssuedDate(String date) {
    return '발행일: $date';
  }

  @override
  String get learningCertView => '보다';

  @override
  String get learningResumeLesson => '레슨 재개';

  @override
  String learningProgressPercentComplete(String percent) {
    return '$percent% 완료';
  }

  @override
  String learningViewCartCount(String count) {
    return '장바구니 항목 보기($count)';
  }

  @override
  String get learningGoToCart => '장바구니로 이동';

  @override
  String get playerLessonMarkedCompleted => '완료된 것으로 표시된 수업 ✓';

  @override
  String get playerLessonMarkedIncomplete => '강의가 완료되지 않은 것으로 표시됨';

  @override
  String get playerCommentPostedSuccess => '댓글이 성공적으로 게시되었습니다.';

  @override
  String get playerCommentPostFailed => '댓글을 게시하지 못했습니다.';

  @override
  String get playerReplyPostedSuccess => '답글이 성공적으로 게시되었습니다.';

  @override
  String get playerReplyPostFailed => '답글을 게시하지 못했습니다.';

  @override
  String get playerCourseNotFound => '강좌를 찾을 수 없습니다';

  @override
  String get playerCheckEnrollmentPrompt => '먼저 수강신청을 확인해주세요';

  @override
  String get playerReturnToCourses => '나의 학습';

  @override
  String get playerWatchLecture => '강좌강의';

  @override
  String get playerCertificateTooltip => '자격증';

  @override
  String get playerRateCourseTooltip => '평가 코스';

  @override
  String get playerReadingArticleBadge => '기사 읽기 • 5분';

  @override
  String get playerReadFullTextBelow => '아래 전문을 읽어보세요 ↓';

  @override
  String get playerTabReviews => '리뷰';

  @override
  String get playerNoSectionsAvailable => '사용 가능한 섹션이 없습니다.';

  @override
  String playerLessonsCount(String count) {
    return '$count 수업';
  }

  @override
  String get playerPlayingBadge => '재생';

  @override
  String get playerArticleBadge => '기사';

  @override
  String get playerVideoBadge => '동영상';

  @override
  String get playerFullArticleContent => '전체 기사 내용';

  @override
  String get playerArticlePlaceholder =>
      '이 읽기 수업에 오신 것을 환영합니다.\n\n이 섹션에서는 이 단원의 기술을 익히는 데 필요한 핵심 개념과 실제 단계를 다룹니다.';

  @override
  String get playerAboutCourseTitle => '이 과정 정보';

  @override
  String get playerShowLess => '간략히 표시';

  @override
  String get playerReadMore => '더 보기';

  @override
  String get playerWhatYouWillLearn => '학습 내용';

  @override
  String get playerCourseInfoTitle => '강의 상세 정보';

  @override
  String get playerTotalDurationTitle => '총 재생 시간';

  @override
  String get playerTotalLessonsTitle => '총 강의 수';

  @override
  String playerLessonsNumber(String count) {
    return '$count개의 강의';
  }

  @override
  String get playerLevelTitle => '난이도';

  @override
  String get playerAllLevels => '모든 레벨';

  @override
  String get playerLanguageTitle => '언어';

  @override
  String get playerLanguageArabic => '아랍어';

  @override
  String get playerPrerequisitesTitle => '수강 요건';

  @override
  String get playerCertificateCardTitle => '수료증';

  @override
  String get playerCourseCompletedSuccess => '축하합니다! 강의를 수료했습니다';

  @override
  String get playerProgressLabel => '진도율';

  @override
  String get playerViewCertificateBtn => '수료증 보기';

  @override
  String get playerCertifiedInstructor => '공인 강사';

  @override
  String playerDiscussionsCount(String count) {
    return '질문 및 토론 $count개';
  }

  @override
  String get playerAskQuestionHint => '궁금한 점이나 질문을 여기에 입력하세요...';

  @override
  String get playerPostBtn => '게시';

  @override
  String get playerNoDiscussionsTitle => '아직 토론이 없습니다';

  @override
  String get playerNoDiscussionsSubtitle => '첫 번째 질문을 남겨보세요!';

  @override
  String get playerInstructorBadge => '강사';

  @override
  String get playerCancelReply => '취소';

  @override
  String get playerReplyAction => '답글';

  @override
  String playerRepliesCount(String count) {
    return '답글 $count개';
  }

  @override
  String get playerWriteReplyHint => '답글을 작성하세요...';

  @override
  String get playerSendReplyBtn => '답글 작성';

  @override
  String get playerCourseFeedbackTitle => '강의 평점 및 수강평';

  @override
  String get playerOutOf5 => '5점 만점';

  @override
  String playerRatingsFromEnrolledCount(String count) {
    return '수강생 평점 $count개';
  }

  @override
  String get playerKeepLearningToRate => '평점을 남기려면 계속 학습하세요';

  @override
  String get playerRateAfter80Hint => '강의 내용의 80% 이상을 완료하면 수강평과 평점을 남길 수 있습니다';

  @override
  String get playerCurrentProgressLabel => '현재 진도율:';

  @override
  String get playerYourCurrentRating => '내 평점';

  @override
  String get playerEditRating => '평점 수정';

  @override
  String get playerDeleteRatingTooltip => '평점 삭제';

  @override
  String get playerUpdateRatingTitle => '평점 수정하기';

  @override
  String get playerRateCourseTitle => '강의 평가하기';

  @override
  String get playerWriteReviewHint => '강의 내용과 품질에 대한 의견을 작성해주세요 (선택 사항)...';

  @override
  String get playerRatingSubmitSuccess => '평점이 성공적으로 제출되었습니다!';

  @override
  String get playerRatingSubmitFailed => '평점 제출에 실패했습니다';

  @override
  String get playerSaveChangesBtn => '변경사항 저장';

  @override
  String get playerSubmitReviewBtn => '수강평 제출';

  @override
  String get playerLearnerReviewsTitle => '수강생 수강평';

  @override
  String playerReviewsCount(String count) {
    return '수강평 $count개';
  }

  @override
  String get playerNoWrittenReviewsTitle => '아직 작성된 수강평이 없습니다';

  @override
  String get playerNoWrittenReviewsSubtitle => '첫 번째 수강평을 남겨보세요!';

  @override
  String get playerRatingLabel5 => '최고예요 🌟 (5/5)';

  @override
  String get playerRatingLabel4 => '좋아요 👍 (4/5)';

  @override
  String get playerRatingLabel3 => '보통이에요 👌 (3/5)';

  @override
  String get playerRatingLabel2 => '아쉬워요 🤔 (2/5)';

  @override
  String get playerRatingLabel1 => '별로예요 👎 (1/5)';

  @override
  String get playerDeleteRatingDialogTitle => '평점 삭제';

  @override
  String get playerDeleteRatingDialogMessage => '이 강의에 남긴 수강평을 정말 삭제하시겠습니까?';

  @override
  String get playerDeleteConfirmBtn => '삭제';

  @override
  String get playerRatingDeleteSuccess => '평점이 성공적으로 삭제되었습니다';

  @override
  String get playerPreviousLesson => '이전 강의';

  @override
  String get playerExitFullscreenTooltip => '전체 화면 종료';

  @override
  String instructorsAvailableCount(String count) {
    return '$count명의 강사 이용 가능';
  }

  @override
  String get instructorsNotFound => '강사를 찾을 수 없습니다';

  @override
  String instructorsCoursesCount(String count) {
    return '$count 강좌';
  }

  @override
  String get instructorsSearchHint => '강사 이름이나 전문 분야로 검색하세요...';

  @override
  String get instructorsSortAll => '모두';

  @override
  String get instructorsSortTopRated => '최고 평점';

  @override
  String get instructorsSortMostStudents => '대부분의 학생';

  @override
  String get instructorsSortMostCourses => '대부분의 강좌';

  @override
  String get instructorsNotFoundSubtitle => '다른 이름으로 검색해 보거나 필터를 지워보세요.';

  @override
  String get exploreCompleteCourse => '종합과정';

  @override
  String get exploreGeneralCategory => '일반적인';

  @override
  String courseShareMessage(String title, String url) {
    return 'EduLab의 \"$title\" 과정을 확인하세요: $url';
  }

  @override
  String get courseDetailsDefaultTitle => '코스 세부정보';

  @override
  String get courseDetailsTooltipShare => '공유하다';

  @override
  String get courseDetailsTooltipWishlist => '위시리스트';

  @override
  String get courseDetailsTooltipCart => '카트';

  @override
  String get courseDetailsNotFound => '강좌를 찾을 수 없습니다';

  @override
  String get courseDetailsDefaultCategory => '강의';

  @override
  String courseDetailsTotalRatingsCount(String count) {
    return '($count 평가)';
  }

  @override
  String courseDetailsLecturesCount(String count) {
    return '$count 강의';
  }

  @override
  String get courseDetailsCertificateBadge => '자격증';

  @override
  String get courseDetailsTabOverview => '개요';

  @override
  String get courseDetailsTabCurriculum => '과정';

  @override
  String get courseDetailsTabInstructor => '강사';

  @override
  String get courseDetailsTabReviews => '리뷰';

  @override
  String get courseDetailsFullDescriptionTitle => '설명';

  @override
  String get courseDetailsShowLess => '간략히 보기';

  @override
  String get courseDetailsShowMore => '더 보기...';

  @override
  String courseDetailsCurriculumSectionsLectures(
    String sections,
    String lectures,
  ) {
    return '$sections 섹션 • $lectures 강의';
  }

  @override
  String get courseDetailsCollapseAll => '모두 접기';

  @override
  String get courseDetailsExpandAll => '모두 펼치기';

  @override
  String get courseDetailsCurriculumComingSoon => '커리큘럼 세부정보가 곧 제공될 예정입니다.';

  @override
  String courseDetailsSectionLecturesCount(String count) {
    return '$count 강의';
  }

  @override
  String get courseDetailsLecturePreviewBtn => '시사';

  @override
  String get courseDetailsDefaultInstructorTitle => '수석 강사 및 공인 전문가';

  @override
  String get courseDetailsInstructorRatingLabel => '평가';

  @override
  String get courseDetailsInstructorStudentsLabel => '재학생';

  @override
  String get courseDetailsInstructorSectionsLabel => '섹션';

  @override
  String get courseDetailsAboutInstructorTitle => '강사 소개:';

  @override
  String get courseDetailsDefaultInstructorAbout =>
      '전 세계 수천 명의 학생들에게 전문 교육을 제공한 경험이 풍부한 공인 강사입니다.';

  @override
  String courseDetailsStudentRatingsCount(String count) {
    return '$count 학생 평가';
  }

  @override
  String get courseDetailsNoWrittenReviews => '아직 작성된 리뷰가 없습니다.';

  @override
  String get courseDetailsRelatedCourses => '당신이 좋아할 만한 관련 강좌';

  @override
  String courseDetailsDiscountPercent(String percent) {
    return '$percent% 할인';
  }

  @override
  String get courseDetailsResumeCourse => '과정 재개';

  @override
  String get courseDetailsTryAgain => '다시 시도';

  @override
  String get courseDetailsEstimatedReading => '📖 예상 읽기 시간: 4분';

  @override
  String get courseDetailsSampleArticleContent =>
      '이 기사 강의에 오신 것을 환영합니다.\n\n이 섹션에서는 해당 주제를 마스터하기 위한 주요 이론적 개념과 실제 단계를 다룹니다.\n\n• 주요 시사점:\n1. 핵심 용어와 아키텍처 패턴을 파악합니다.\n2. 실습 및 지속적인 연습.\n3. 참고 보충 노트 및 과제.\n\n즐겁게 읽어보세요!';

  @override
  String certDownloadedSuccess(String course, String format) {
    return '\"$course\"에 대한 인증서가 $format 형식으로 다운로드되었습니다!';
  }

  @override
  String certVerifiedFullRequirements(String code) {
    return '인증 ID: $code • 100% 요구사항 완료';
  }

  @override
  String get certCompletionTitle => '수료증';

  @override
  String get certCompletionSubtitle => '과정 수료 증명서';

  @override
  String get certAnnounceStudent => 'EducationLab 학습 아카데미는 다음을 인증합니다.';

  @override
  String get certCompletionRequirementsMet => '교육 과정의 모든 요구 사항을 성공적으로 완료했습니다.';

  @override
  String certIssueDateText(String date) {
    return '발행 날짜: $date';
  }

  @override
  String certIdNumberText(String code) {
    return '인증서 ID: $code';
  }

  @override
  String get certPlatformManagement => '플랫폼 관리';

  @override
  String get certInstructorRoleTitle => '코스 강사';

  @override
  String get commonLoading => '로드 중...';

  @override
  String get homeGuestTagline => '스마트 학습 및 기술 구축 플랫폼';

  @override
  String get catTagHighestDemand => '최고 수요';

  @override
  String get catTagMostPopular => '가장 인기 있는';

  @override
  String get catTagTrending => '트렌딩';

  @override
  String get catTagFastestGrowing => '가장 빠른 성장';

  @override
  String get catTagHighDemand => '높은 수요';

  @override
  String get catTagTopRated => '최고 평점';

  @override
  String get catTagEssential => '필수 코스';

  @override
  String get catTagAdvanced => '고급 과정';

  @override
  String get catTagEntrepreneurs => '창업가';

  @override
  String get catTagSalesGrowth => '매출 성장';

  @override
  String get catDevTitle => '프로그래밍 및 소프트웨어 개발';

  @override
  String get catDevSubtitle => '소프트웨어 공학, 시스템 및 알고리즘';

  @override
  String get catWebTitle => '웹 개발';

  @override
  String get catWebSubtitle => '프론트엔드, 백엔드 및 풀스택 웹';

  @override
  String get catMobileTitle => '모바일 앱 개발';

  @override
  String get catMobileSubtitle => 'Flutter, iOS 및 Android 모바일 앱';

  @override
  String get catAiTitle => '인공지능 (AI)';

  @override
  String get catAiSubtitle => '머신러닝, 딥러닝 및 AI 응용';

  @override
  String get catDataTitle => '데이터 사이언스 및 분석';

  @override
  String get catDataSubtitle => '데이터 분석, 통계 및 빅데이터';

  @override
  String get catDesignTitle => 'UI/UX 및 프로덕트 디자인';

  @override
  String get catDesignSubtitle => 'UI/UX, 프로토타이핑 및 제품 디자인';

  @override
  String get catSecurityTitle => '사이버 보안 및 네트워크';

  @override
  String get catSecuritySubtitle => '정보 보안, 화이트해킹 및 네트워크';

  @override
  String get catCloudTitle => '클라우드 컴퓨팅 및 DevOps';

  @override
  String get catCloudSubtitle => '클라우드 인프라, DevOps 및 CI/CD';

  @override
  String get catBusinessTitle => '비즈니스 및 프로젝트 관리';

  @override
  String get catBusinessSubtitle => '창업, 애자일 및 리더십';

  @override
  String get catMarketingTitle => '디지털 마케팅';

  @override
  String get catMarketingSubtitle => '디지털 마케팅, SEO 및 성장 전략';

  @override
  String get timeJustNow => '방금 전';

  @override
  String timeMinutesAgo(String count) {
    return '$count분 전';
  }

  @override
  String timeHoursAgo(String count) {
    return '$count시간 전';
  }

  @override
  String timeDaysAgo(String count) {
    return '$count일 전';
  }

  @override
  String timeWeeksAgo(String count) {
    return '$count주 전';
  }

  @override
  String timeMonthsAgo(String count) {
    return '$count개월 전';
  }

  @override
  String wishlistLecturesCount(String count) {
    return '$count개 강의';
  }

  @override
  String get instructorProfileTitle => '강사 프로필';

  @override
  String instructorProfileLinkCopied(String name) {
    return '$name의 링크가 클립보드에 복사되었습니다';
  }

  @override
  String get instructorDefaultName => '강사';

  @override
  String get instructorProfileBadge => '강사';

  @override
  String get instructorProfileTotalStudents => '총 수강생';

  @override
  String get instructorProfileRating => '강사 평점';

  @override
  String get instructorProfileCourses => '강좌';

  @override
  String get instructorProfileShare => '프로필 공유';

  @override
  String get instructorProfileLinkOpenError => '링크를 열 수 없어 클립보드에 복사했습니다';

  @override
  String get instructorProfileWebsite => '웹사이트';

  @override
  String get instructorProfileAboutMe => '강사 소개';

  @override
  String get instructorProfileShowLess => '간략히 보기';

  @override
  String get instructorProfileShowMore => '더 보기';

  @override
  String get instructorProfileExpertise => '전문 분야';

  @override
  String get instructorProfileSortAll => '전체';

  @override
  String get instructorProfileSortTopRated => '최고 평점';

  @override
  String get instructorProfileSortPopular => '인기';

  @override
  String get instructorProfileSortNewest => '최신';

  @override
  String get instructorProfileCoursesTitle => '강사의 강좌';

  @override
  String get instructorProfileNoCoursesFilter => '이 조건에 일치하는 강좌가 없습니다';

  @override
  String instructorProfileLoadMoreCourses(String count) {
    return '강좌 더 불러오기 ($count개 남음)';
  }

  @override
  String get instructorProfileLoadingMoreCourses => '강좌를 더 불러오는 중...';

  @override
  String instructorProfileAllCoursesLoaded(String count) {
    return '모든 $count개 강좌를 불러왔습니다';
  }

  @override
  String get instructorProfileStudentFeedback => '수강생 평가';

  @override
  String instructorProfileReviewsCount(String count) {
    return '수강평 $count개';
  }

  @override
  String instructorProfileBasedOnReviews(String count) {
    return '$count개 수강평 기준';
  }

  @override
  String get instructorProfileRecentReviews => '최근 수강평';

  @override
  String instructorProfileLoadMoreReviews(String count) {
    return '수강평 더 불러오기 ($count개 남음)';
  }

  @override
  String get instructorProfileLoadingMoreReviews => '수강평을 더 불러오는 중...';

  @override
  String instructorProfileAllReviewsLoaded(String count) {
    return '모든 $count개 수강평을 불러왔습니다';
  }

  @override
  String get instructorProfileNoReviewsYet => '아직 작성된 수강평이 없습니다';

  @override
  String get instructorProfileRatingDesc =>
      '평점은 강사의 모든 강좌에 대한 수강생들의 종합 평가를 기반으로 산정됩니다';

  @override
  String get instructorProfileLoadError => '강사 정보를 불러오지 못했습니다. 잠시 후 다시 시도해 주세요';

  @override
  String get instructorProfileDefaultStudentName => '수강생';

  @override
  String get instructorProfileDefaultHeadline => '수석 강사 및 공인 전문가';

  @override
  String get instructorProfileDefaultBio =>
      '확장 가능한 소프트웨어 시스템과 모바일 애플리케이션 구축에 풍부한 경험을 보유한 공인 소프트웨어 엔지니어이자 전문 강사입니다.\n전 세계 수천 명의 수강생과 엔지니어를 지도하며 클린 코드, 클린 아키텍처 및 현대적인 확장형 솔루션에 집중된 전문 교육을 제공해 왔습니다.';

  @override
  String get supportNewChat => '새 문의';

  @override
  String get supportNoChatsTitle => '지원 대화 내역이 없습니다';

  @override
  String get supportNoChatsDesc =>
      '고객 지원팀이 24시간 언제나 질문에 답변하고 도움을 드릴 준비가 되어 있습니다';

  @override
  String get supportStartNewConversation => '새 문의 시작하기';

  @override
  String get supportNoMessagesYet => '메시지가 아직 없습니다';

  @override
  String get supportRetry => '다시 시도';

  @override
  String get supportOpenTicket => '진행 중인 티켓';

  @override
  String get supportClosedTicket => '종료된 티켓';

  @override
  String get supportCloseAction => '닫기';

  @override
  String get supportReopenAction => '다시 열기';

  @override
  String get supportNoMessagesInChat => '이 대화방에 아직 메시지가 없습니다';

  @override
  String get supportYou => '나';

  @override
  String get supportTeam => '지원팀';

  @override
  String get supportTypeMessageHint => '메시지를 입력하세요...';

  @override
  String get supportConversationClosedNotice => '이 대화는 현재 종료되었습니다.';

  @override
  String get supportCloseDialogTitle => '대화를 종료하시겠습니까?';

  @override
  String get supportCloseDialogDesc =>
      '정말로 이 채팅을 종료하시겠습니까? 언제든지 다시 열어 대화를 이어갈 수 있습니다.';

  @override
  String get supportCancel => '취소';

  @override
  String get supportYesClose => '예, 종료합니다';

  @override
  String get supportNewChatTitle => '새 지원 대화';

  @override
  String get supportNewChatSubtitle => '지원팀이 도움을 드리겠습니다';

  @override
  String get supportSubjectLabel => '제목';

  @override
  String get supportSubjectHint => '예: 강좌 문의, 결제 문제...';

  @override
  String get supportMessageLabel => '메시지';

  @override
  String get supportMessageHint => '문의사항이나 문제를 자세히 설명해 주세요...';

  @override
  String get supportMessageRequired => '메시지를 입력해 주세요';

  @override
  String get supportStartConversationBtn => '문의 시작하기';

  @override
  String get supportCreateError => '대화를 생성하지 못했습니다. 나중에 다시 시도해 주세요';

  @override
  String get supportTopicCourse => '강좌 문의';

  @override
  String get supportTopicPayment => '결제 문제';

  @override
  String get supportTopicCertificates => '수료증';

  @override
  String get supportTopicTech => '기술적 문제';

  @override
  String get supportTopicGeneral => '일반 문의';

  @override
  String get cartGuestTitle => '장바구니를 보려면 로그인하세요';

  @override
  String get cartGuestSubtitle => '장바구니에 접근하여 코스를 구매하려면 로그인하세요.';

  @override
  String get wishlistGuestTitle => '위시리스트를 보려면 로그인하세요';

  @override
  String get wishlistGuestSubtitle => '저장된 코스를 언제든지 확인하려면 로그인하세요.';

  @override
  String get courseDetailsLoginRequiredTitle => '로그인 필요';

  @override
  String get courseDetailsLoginRequiredDesc =>
      '이 코스를 구매하고 학습 진행 상황을 저장하려면 먼저 로그인해야 합니다.';

  @override
  String get courseDetailsProceedToLogin => '로그인으로 이동';

  @override
  String get messagesGuestTitle => '메시지를 보려면 로그인하세요';

  @override
  String get messagesGuestSubtitle => '지원 대화에 접근하려면 로그인하세요.';

  @override
  String get notificationsGuestTitle => '알림을 보려면 로그인하세요';

  @override
  String get notificationsGuestSubtitle => '계정 및 코스에 대한 최신 알림을 보려면 로그인하세요.';

  @override
  String get legalTitle => '정보 및 약관';

  @override
  String get legalTabAbout => 'EduLab 정보';

  @override
  String get legalTabPrivacy => '개인정보처리방침';

  @override
  String get legalTabTerms => '이용약관';

  @override
  String get legalUpdated => '업데이트:';

  @override
  String get legalNeedHelpTitle => '도움이 필요하시거나 질문이 있으신가요?';

  @override
  String get legalNeedHelpDesc =>
      'EduLab 지원팀이 24시간 연중무휴로 도와드립니다. 이메일로 직접 문의해 주세요.';

  @override
  String get legalEmailCopied => '지원 이메일이 클립보드에 복사되었습니다';

  @override
  String get legalNoContent => '현재 제공되는 콘텐츠가 없습니다';

  @override
  String get checkoutDigitalReceipt => '디지털 영수증';

  @override
  String get checkoutTransactionDate => '거래 일자';

  @override
  String get checkoutFreeEnrollment => '무료 등록';

  @override
  String get checkoutEnrolledCourses => '등록된 강좌';

  @override
  String get checkoutTransactionStatus => '상태';

  @override
  String get checkoutStatusSuccess => '완료됨';

  @override
  String get checkoutTotalPaid => '총 결제 금액';

  @override
  String get checkoutCopied => '복사됨!';

  @override
  String get checkoutCardHolderHint => '카드에 표시된 전체 이름';
}

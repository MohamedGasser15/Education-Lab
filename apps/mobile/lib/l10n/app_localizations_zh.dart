// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get onboardingSkip => '跳过';

  @override
  String get onboardingTitle1 => '欢迎来到 EduLab';

  @override
  String get onboardingSubtitle1 => '您进行现代互动学习和持续职业发展的理想平台。';

  @override
  String get onboardingTitle2 => '向顶尖名师学习';

  @override
  String get onboardingSubtitle2 => '涵盖编程、设计、商业和数据科学领域的数千门专业课程。';

  @override
  String get onboardingTitle3 => '证书与成功保障';

  @override
  String get onboardingSubtitle3 => '跟踪您的学习进度，通过考试并获取权威认证证书。';

  @override
  String get onboardingNext => '下一步';

  @override
  String get onboardingStart => '立即开始';

  @override
  String get splashAppName => 'Education Lab';

  @override
  String get splashTagline => '智能学习平台';

  @override
  String get loginTagline => '欢迎来到智能学习平台';

  @override
  String get loginAppName => 'EduLab';

  @override
  String get loginTabLogin => '登录';

  @override
  String get loginTabRegister => '注册账号';

  @override
  String get loginEmailLabel => '邮箱地址';

  @override
  String get loginEmailHint => 'example@email.com';

  @override
  String get loginPasswordLabel => '密码';

  @override
  String get loginPasswordHint => '••••••';

  @override
  String get loginForgotPassword => '忘记密码？';

  @override
  String get loginSubmit => '登录';

  @override
  String get loginSubmitLoading => '登录中';

  @override
  String get loginGuest => '以游客身份浏览';

  @override
  String get loginOr => '或';

  @override
  String get loginEmailRequired => '请输入邮箱地址';

  @override
  String get loginEmailInvalid => '请输入有效的邮箱地址';

  @override
  String get loginPasswordRequired => '请输入密码';

  @override
  String get registerStepEmail => '邮箱';

  @override
  String get registerStepCode => '验证码';

  @override
  String get registerStepData => '资料';

  @override
  String get registerSendCodeInfo => '我们将向此邮箱发送激活验证码';

  @override
  String get registerSendCode => '发送验证码';

  @override
  String get registerVerifying => '验证中';

  @override
  String get registerCodeSentTo => '验证码已发送至：';

  @override
  String get registerResendCode => '重新发送验证码';

  @override
  String get registerBack => '返回';

  @override
  String get registerVerifyCode => '验证并继续';

  @override
  String get registerCodeIncomplete => '请输入完整的6位验证码';

  @override
  String get registerFullNameLabel => '真实姓名';

  @override
  String get registerFullNameHint => '您的全名';

  @override
  String get registerPasswordHint => '至少8个字符，包含大写字母和数字';

  @override
  String get registerConfirmLabel => '确认密码';

  @override
  String get registerConfirmHint => '请再次输入密码';

  @override
  String get registerSubmit => '注册账号';

  @override
  String get registerSubmitLoading => '账号创建中';

  @override
  String get registerSuccess => '账号创建成功';

  @override
  String get registerNameRequired => '请输入真实姓名';

  @override
  String get registerNameMinLength => '姓名长度至少为6个字符';

  @override
  String get registerPasswordMinLength => '密码长度至少为8个字符';

  @override
  String get registerPasswordUppercase => '密码必须包含至少一个大写字母';

  @override
  String get registerPasswordNumber => '密码必须包含至少一个数字';

  @override
  String get registerConfirmRequired => '请确认密码';

  @override
  String get registerConfirmMismatch => '两次输入的密码不一致';

  @override
  String get networkError => '网络连接错误，请重试';

  @override
  String homeGreeting(String name) {
    return '你好，$name！';
  }

  @override
  String get homeSubtitle => '今天想学点什么？';

  @override
  String get homeSearchHint => '搜索课程或技能...';

  @override
  String get homeSectionContinue => '继续学习';

  @override
  String get homeSectionRecommended => '为您推荐';

  @override
  String get homeSectionPopular => '热门好课';

  @override
  String get homeSectionTopRated => '高分精选';

  @override
  String get homeSectionByCategory => '分类探索';

  @override
  String get homeHeroTitle => '限时特惠活动';

  @override
  String get homeHeroSubtitle => '精品课程低至3折';

  @override
  String get homeHeroButton => '立即查看';

  @override
  String get homeViewAll => '查看全部';

  @override
  String get homeProgressLabel => '已完成';

  @override
  String get exploreTitle => '发现课程';

  @override
  String get exploreSearchHint => '搜索课程、技能或讲师...';

  @override
  String get exploreAllCategories => '全部分类';

  @override
  String get exploreFilter => '筛选';

  @override
  String get exploreSort => '排序';

  @override
  String get exploreNoResults => '未找到相关结果';

  @override
  String get exploreNoResultsHint => '请尝试不同的关键词或重置筛选条件';

  @override
  String exploreCoursesCount(int count) {
    return '$count 门课程';
  }

  @override
  String get exploreFilterTitle => '筛选条件';

  @override
  String get exploreFilterApply => '应用筛选';

  @override
  String get exploreFilterReset => '重置';

  @override
  String get exploreFilterPrice => '价格';

  @override
  String get exploreFilterLevel => '难度级别';

  @override
  String get exploreFilterRating => '评分';

  @override
  String get exploreFilterDuration => '课时长度';

  @override
  String get exploreSortTitle => '排序方式';

  @override
  String get exploreSortRelevance => '综合排序';

  @override
  String get exploreSortNewest => '最新发布';

  @override
  String get exploreSortPopular => '最受欢迎';

  @override
  String get exploreSortRating => '评分最高';

  @override
  String get exploreSortPriceLow => '价格：从低到高';

  @override
  String get exploreSortPriceHigh => '价格：从高到低';

  @override
  String get explorePriceFree => '免费';

  @override
  String get exploreLevelBeginner => '初级入门';

  @override
  String get exploreLevelIntermediate => '中级进阶';

  @override
  String get exploreLevelAdvanced => '高级专家';

  @override
  String get learningTitle => '我的学习';

  @override
  String get learningTabInProgress => '学习中';

  @override
  String get learningTabCompleted => '已学完';

  @override
  String get learningTabSaved => '已收藏';

  @override
  String get learningEmpty => '暂无课程';

  @override
  String get learningEmptyHint => '快去探索并加入心仪的课程吧';

  @override
  String get learningExploreButton => '去发现课程';

  @override
  String learningProgress(int percent) {
    return '已完成 $percent%';
  }

  @override
  String get learningContinue => '继续学习';

  @override
  String get learningViewCertificate => '查看结业证书';

  @override
  String get learningReview => '评价课程';

  @override
  String get learningLesson => '课时';

  @override
  String get learningLessons => '课时';

  @override
  String get cartTitle => '购物车';

  @override
  String get cartEmpty => '购物车空空如也';

  @override
  String get cartEmptyHint => '挑选优质课程，开启学习之路';

  @override
  String get cartExploreButton => '去选课';

  @override
  String get cartPromoPlaceholder => '请输入优惠券码';

  @override
  String get cartPromoApply => '使用';

  @override
  String get cartPromoInvalid => '优惠券码无效';

  @override
  String get cartSummary => '订单明细';

  @override
  String get cartSubtotal => '商品总额';

  @override
  String get cartDiscount => '立减优惠';

  @override
  String get cartTotal => '实付金额';

  @override
  String get cartCheckout => '去结算';

  @override
  String cartCourses(int count) {
    return '$count 门课程';
  }

  @override
  String get cartRemove => '移除';

  @override
  String get cartGuarantee => '支持30天无理由全额退款';

  @override
  String get checkoutTitle => '确认订单';

  @override
  String get checkoutStepPayment => '支付';

  @override
  String get checkoutStepReview => '核对';

  @override
  String get checkoutStepConfirm => '完成';

  @override
  String get checkoutOrderSummary => '订单摘要';

  @override
  String get checkoutTotal => '应付金额';

  @override
  String get checkoutPayNow => '立即支付';

  @override
  String get checkoutBack => '返回';

  @override
  String get checkoutNext => '下一步';

  @override
  String get checkoutSecureSSL => '采用256位SSL安全银行级加密传输';

  @override
  String get checkoutSuccessTitle => '支付成功！';

  @override
  String get checkoutSuccessSubtitle => '您已成功购买，可立即开始学习';

  @override
  String get checkoutGoToLearning => '前往我的课程';

  @override
  String get checkoutPaymentMethod => '支付方式';

  @override
  String get checkoutCardNumber => '卡号';

  @override
  String get checkoutCardName => '持卡人姓名';

  @override
  String get checkoutCardExpiry => '有效期';

  @override
  String get checkoutCardCVV => '安全码 (CVV)';

  @override
  String get courseDetailsEnroll => '立即报名';

  @override
  String get courseDetailsBuyNow => '立即购买';

  @override
  String get courseDetailsAddToCart => '加入购物车';

  @override
  String get courseDetailsAddedToCart => '已加入购物车';

  @override
  String get courseDetailsAlreadyEnrolled => '已购买此课程';

  @override
  String get courseDetailsGoToCourse => '进入课程';

  @override
  String get courseDetailsFree => '免费课程';

  @override
  String courseDetailsStudents(String count) {
    return '$count 名学员';
  }

  @override
  String get courseDetailsRating => '课程评分';

  @override
  String get courseDetailsReviews => '条评价';

  @override
  String get courseDetailsLastUpdated => '最近更新';

  @override
  String get courseDetailsCurriculum => '课程目录大纲';

  @override
  String get courseDetailsSection => '个章节';

  @override
  String get courseDetailsLessons => '节课';

  @override
  String get courseDetailsInstructor => '主讲名师';

  @override
  String get courseDetailsStudentsLabel => '学员';

  @override
  String get courseDetailsCoursesLabel => '课程';

  @override
  String get courseDetailsReviewsLabel => '评价';

  @override
  String get courseDetailsReviewsTitle => '学员真实评价';

  @override
  String get courseDetailsWhatLearn => '你将学到什么';

  @override
  String get courseDetailsRequirements => '学习先决条件';

  @override
  String get courseDetailsDescription => '课程详细介绍';

  @override
  String get courseDetailsIncludesTitle => '课程权益包括';

  @override
  String get courseDetailsHoursVideo => '小时精讲视频';

  @override
  String get courseDetailsArticles => '篇实战文章';

  @override
  String get courseDetailsMobileAccess => '支持手机与平板学习';

  @override
  String get courseDetailsCertificate => '官方结业证书';

  @override
  String get courseDetailsLifetimeAccess => '终身无限次回看';

  @override
  String get lessonPlayerNotes => '随堂笔记';

  @override
  String get lessonPlayerResources => '参考资料';

  @override
  String get lessonPlayerDiscussion => '学员问答';

  @override
  String get lessonPlayerPrev => '上一节';

  @override
  String get lessonPlayerNext => '下一节';

  @override
  String get lessonPlayerSpeed => '播放速度';

  @override
  String get lessonPlayerQuality => '画质切换';

  @override
  String get lessonPlayerCompleted => '本节已完成';

  @override
  String get certificateTitle => '结业证书';

  @override
  String get certificatePresentedTo => '特此授予';

  @override
  String get certificateCompletedCourse => '以表彰其顺利完成';

  @override
  String get certificateIssuedOn => '发证日期';

  @override
  String get certificateVerificationId => '证书验证编号';

  @override
  String get certificateDownloadPDF => '下载 PDF 证书';

  @override
  String get certificateDownloadPNG => '保存证书图片';

  @override
  String get certificateCopyLink => '复制验证链接';

  @override
  String get certificateLinkCopied => '链接已复制到剪贴板';

  @override
  String get profileTitle => '个人中心';

  @override
  String get profileEditProfile => '编辑资料';

  @override
  String get profileCourses => '我的课程';

  @override
  String get profileCertificates => '我的证书';

  @override
  String get profilePoints => '积分商城';

  @override
  String get profileFollowers => '粉丝';

  @override
  String get profileFollowing => '关注';

  @override
  String get profileBio => '个人简介';

  @override
  String get profileInstructor => '认证讲师';

  @override
  String get profileStudent => '学员';

  @override
  String get profileLevel => '等级';

  @override
  String get profileJoined => '加入时间';

  @override
  String get profileShareProfile => '分享主页';

  @override
  String get profileMenuLearning => '我的课程';

  @override
  String get profileMenuCertificates => '我的证书';

  @override
  String get profileMenuPurchaseHistory => '购买记录';

  @override
  String get profileMenuTeachApplication => '申请成为讲师';

  @override
  String get profileMenuAccountSecurity => '账号安全';

  @override
  String get profileMenuNotifications => '消息通知';

  @override
  String get profileMenuMessages => '私信列表';

  @override
  String get profileMenuSettings => '系统设置';

  @override
  String get profileMenuSchedule => '学习课表';

  @override
  String get profileMenuAssignments => '作业批改';

  @override
  String get profileMenuQuiz => '随堂测验';

  @override
  String get profileMenuLogout => '退出登录';

  @override
  String get profileLogoutConfirm => '确定要退出登录吗？';

  @override
  String get profileLogoutYes => '确定退出';

  @override
  String get profileLogoutNo => '取消';

  @override
  String get editProfileTitle => '编辑个人资料';

  @override
  String get editProfileSave => '保存修改';

  @override
  String get editProfileFullName => '真实姓名';

  @override
  String get editProfileBio => '个人简介';

  @override
  String get editProfileEmail => '邮箱地址';

  @override
  String get editProfilePhone => '联系电话';

  @override
  String get editProfileWebsite => '个人主页';

  @override
  String get editProfileSaved => '资料已成功更新';

  @override
  String get accountSecurityTitle => '账号安全中心';

  @override
  String get accountSecurityChangePassword => '修改登录密码';

  @override
  String get accountSecurityTwoFactor => '双重身份验证';

  @override
  String get accountSecurityActiveSessions => '登录设备管理';

  @override
  String get accountSecurityDeleteAccount => '注销账号';

  @override
  String get purchaseHistoryTitle => '历史订单';

  @override
  String get purchaseHistoryEmpty => '暂无任何购买记录';

  @override
  String get purchaseHistoryGuarantee => '支持30天全额退款保障';

  @override
  String get purchaseHistoryDate => '交易日期';

  @override
  String get purchaseHistoryStatus => '订单状态';

  @override
  String get purchaseHistoryAmount => '金额';

  @override
  String get purchaseHistoryCompleted => '交易成功';

  @override
  String get purchaseHistoryRefunded => '已退款';

  @override
  String get teachApplicationTitle => '讲师入驻申请';

  @override
  String get teachApplicationSubmit => '提交入驻资料';

  @override
  String get teachApplicationSent => '入驻申请已成功提交，我们将尽快审核';

  @override
  String get notificationsTitle => '消息中心';

  @override
  String get notificationsMarkAllRead => '全部标为已读';

  @override
  String get notificationsMarkAllReadSnackbar => '已将所有消息设为已读';

  @override
  String get notificationsEmpty => '暂无新消息';

  @override
  String get notification1Title => '学习提醒：继续今日打卡';

  @override
  String get notification1Message => '《Flutter从入门到实战》有新的更新内容';

  @override
  String get notification1Time => '5分钟前';

  @override
  String get notification1Action => '立即学习';

  @override
  String get notification2Title => '您的专属结业证书已生成！';

  @override
  String get notification2Message => '恭喜您顺利完成《UI/UX高阶设计全书》';

  @override
  String get notification2Time => '2小时前';

  @override
  String get notification2Action => '查看证书';

  @override
  String get notification3Title => '尊享会员特惠通知';

  @override
  String get notification3Message => '精选热门编程好课限时3折抢购';

  @override
  String get notification3Time => '1天前';

  @override
  String get notification3Action => '立即抢购';

  @override
  String get notification4Title => '导师解答了您的提问';

  @override
  String get notification4Message => '讲师在 React 章节中回答了您的留言';

  @override
  String get notification4Time => '2天前';

  @override
  String get notification4Action => '查看回复';

  @override
  String get notification5Title => '课程内容重磅更新';

  @override
  String get notification5Message => '《Python高阶全栈》补充了人工智能项目实战';

  @override
  String get notification5Time => '3天前';

  @override
  String get messagesTitle => '私信消息';

  @override
  String get settingsTitle => '通用设置';

  @override
  String get settingsVideoDownload => '视频与离线缓存';

  @override
  String get settingsDownloadQuality => '默认下载清晰度';

  @override
  String get settingsWifiOnly => '仅在 Wi-Fi 网络下下载视频';

  @override
  String get settingsNotifications => '消息与提醒设置';

  @override
  String get settingsCourseNotifications => '课程更新与私信消息提醒';

  @override
  String get settingsPromoNotifications => '折扣特惠与活动推送';

  @override
  String get settingsAppearance => '外观与语言';

  @override
  String get settingsDarkMode => '深色模式';

  @override
  String get settingsDarkModeEnabled => '已开启（保护视力与省电）';

  @override
  String get settingsDarkModeDisabled => '已关闭（跟随系统浅色）';

  @override
  String get settingsLanguage => '界面语言';

  @override
  String get settingsStorage => '存储与缓存';

  @override
  String get settingsClearCache => '清除本地缓存';

  @override
  String get settingsClearCacheSuccess => '缓存已成功清空';

  @override
  String get settingsHelp => '关于与协议';

  @override
  String get settingsHelpCenter => '帮助中心与常见问题';

  @override
  String get settingsTermsPrivacy => '用户协议与隐私条款';

  @override
  String get settingsAbout => '关于 EduLab 平台';

  @override
  String get settingsVersion => '当前版本 v1.0.0';

  @override
  String get quizTitle => '课后随堂测验';

  @override
  String get quizNext => '下一题';

  @override
  String get quizSubmit => '提交测验';

  @override
  String get quizScore => '测验成绩';

  @override
  String get quizCorrectAnswers => '正确题数';

  @override
  String get scheduleTitle => '我的课表';

  @override
  String get scheduleEmpty => '近期无待上的直播/课程';

  @override
  String get scheduleJoin => '进入教室';

  @override
  String get scheduleReminder => '开启上课提醒';

  @override
  String get assignmentsTitle => '课后作业';

  @override
  String get assignmentsEmpty => '暂无待完成的作业';

  @override
  String get assignmentsSubmit => '提交作业';

  @override
  String get assignmentsDue => '截止时间';

  @override
  String get assignmentsSubmitted => '已提交';

  @override
  String get assignmentsPending => '待批改';

  @override
  String get languageArabic => '阿拉伯语 (Arabic)';

  @override
  String get languageEnglish => '英语 (English)';

  @override
  String get languageDialogTitle => '选择显示语言';

  @override
  String get languageSelect => '确定切换';

  @override
  String get generalCancel => '取消';

  @override
  String get generalConfirm => '确认';

  @override
  String get generalSave => '保存';

  @override
  String get generalDelete => '删除';

  @override
  String get generalEdit => '编辑';

  @override
  String get generalClose => '关闭';

  @override
  String get generalBack => '返回';

  @override
  String get generalDone => '完成';

  @override
  String get generalOk => '确定';

  @override
  String get generalYes => '是';

  @override
  String get generalNo => '否';

  @override
  String get generalLoading => '加载中...';

  @override
  String get generalError => '发生未知错误';

  @override
  String get generalRetry => '重试';

  @override
  String get generalNoInternet => '网络无法连接，请检查网络';

  @override
  String get generalFree => '免费';

  @override
  String get generalRating => '评分';

  @override
  String get generalStudents => '学员';

  @override
  String get generalHours => '小时';

  @override
  String get generalMinutes => '分钟';

  @override
  String get generalBy => '讲师：';

  @override
  String get navHome => '首页';

  @override
  String get navExplore => '发现';

  @override
  String get navMyCourses => '学习';

  @override
  String get navCart => '购物车';

  @override
  String get navAccount => '我的';

  @override
  String get homeSubGreeting => '今天想学习什么技能？';

  @override
  String get homeVisitor => '访客';

  @override
  String get homePromoTitle => '限时特惠活动';

  @override
  String get homePromoSubtitle => '精品课程低至3折';

  @override
  String get homePromoButton => '立即查看';

  @override
  String get homePromoBadge => '专属特惠';

  @override
  String get homeContinueLearning => '继续学习';

  @override
  String get homeMyCoursesLink => '我的课程';

  @override
  String get homeLesson => '节';

  @override
  String homeStudentsCount(String count) {
    return '$count 名学员';
  }

  @override
  String get homeRecommendedTitle => '为您推荐';

  @override
  String get homeRecommendedSubtitle => '根据您的兴趣个性化推荐';

  @override
  String get homeBestsellersTitle => '畅销排行榜';

  @override
  String get homeBestsellersSubtitle => '最受欢迎且评价极高的课程';

  @override
  String get homeNewCoursesTitle => '新课上线';

  @override
  String get homeNewCoursesSubtitle => '全新且紧跟前沿的教学内容';

  @override
  String get homePopularTopicsTitle => '热门话题';

  @override
  String get homePopularTopicsSubtitle => '学习当下最抢手的新技能';

  @override
  String get homeTopInstructorsTitle => '名师推荐';

  @override
  String get homeTopInstructorsSubtitle => '跟随行业认证专家学习';

  @override
  String get homeExploreCategoriesTitle => '探索所有分类';

  @override
  String get homeExploreCategoriesSubtitle => '找到最适合您的课程';

  @override
  String get catAll => '全部';

  @override
  String get catWebDev => 'Web前端与开发';

  @override
  String get catMobileApps => '移动端开发';

  @override
  String get catDataScience => '数据科学与大数据';

  @override
  String get catUIUX => 'UI/UX设计';

  @override
  String get catBusiness => '商业与管理';

  @override
  String get catAI => '人工智能与深度学习';

  @override
  String get catCyberSecurity => '网络与信息安全';

  @override
  String get exploreNoResultsTitle => '未找到相关结果';

  @override
  String get exploreNoResultsSubtitle => '请尝试不同的关键词或重置筛选条件';

  @override
  String get exploreRecentSearches => '历史搜索';

  @override
  String get exploreTopSearches => '热搜榜';

  @override
  String get exploreBrowseCategories => '浏览分类';

  @override
  String get exploreBrowseCategoriesSubtitle => '找到最适合您的课程';

  @override
  String get exploreBackToAll => '返回全部';

  @override
  String get exploreClearAll => '清空全部';

  @override
  String get exploreAvailableResults => '个可用结果';

  @override
  String get exploreFilterBestseller => '畅销榜';

  @override
  String get exploreFilterTopRated => '好评榜';

  @override
  String get exploreFilterUnder50 => '50元以下';

  @override
  String get learningHeroTitle => '开启您的知识精进之旅';

  @override
  String get learningSearchHint => '在已购课程中搜索...';

  @override
  String get learningFilterAll => '全部';

  @override
  String get learningFilterInProgress => '学习中';

  @override
  String get learningFilterCompleted => '已学完';

  @override
  String get learningFilterDownloaded => '已下载';

  @override
  String get learningEmptyTitle => '暂无课程';

  @override
  String get learningEmptySubtitle => '快去探索并加入心仪的课程吧';

  @override
  String get learningEmptySearch => '未搜索到相关课程';

  @override
  String get learningCompleted => '已学完';

  @override
  String get learningCompletedBadge => '已学完';

  @override
  String learningLecturesCount(int count) {
    return '$count 节课';
  }

  @override
  String get cartEmptyTitle => '购物车空空如也';

  @override
  String get cartEmptySubtitle => '挑选优质课程，开启学习之路';

  @override
  String get cartCouponHint => '输入优惠码';

  @override
  String get cartCouponApply => '使用';

  @override
  String get cartCouponInvalid => '优惠券无效';

  @override
  String get cartCouponApplied => '已成功使用优惠券';

  @override
  String get cartCouponDiscount => '优惠抵扣';

  @override
  String get cartCouponsTitle => '可用卡券';

  @override
  String get cartOrderSummary => '订单明细';

  @override
  String get cartOriginalPrice => '原价';

  @override
  String get cartPlatformDiscount => '平台折扣';

  @override
  String get cartFinalTotal => '合计实付';

  @override
  String cartItemsCount(int count) {
    return '$count 门课程';
  }

  @override
  String get cartRemovedSnackbar => '课程已从购物车移除';

  @override
  String get cartUndo => '撤销';

  @override
  String get cartAddButton => '加入购物车';

  @override
  String get cartAddedSnackbar => '已成功加入购物车';

  @override
  String get cartAlreadyInCart => '已在购物车中';

  @override
  String get cartCheckoutButton => '立即结算';

  @override
  String get cartRecommendedTitle => '猜你喜欢';

  @override
  String get cartRecommendedSubtitle => '根据购物车为您智能推荐';

  @override
  String get checkoutCreditCard => '信用卡 / 银联 / 支付宝';

  @override
  String get checkoutSelectPayment => '请选择支付方式';

  @override
  String get checkoutCardNumberLabel => '银行卡号';

  @override
  String get checkoutCardHolderLabel => '持卡人姓名';

  @override
  String get checkoutExpiryLabel => '有效期 (月/年)';

  @override
  String get checkoutCVVLabel => 'CVV安全码';

  @override
  String get checkoutPersonalInfoTitle => '联系人信息';

  @override
  String get checkoutFullNameLabel => '姓名';

  @override
  String get checkoutFullNameHint => '请输入您的姓名';

  @override
  String get checkoutFullNameRequired => '请输入姓名';

  @override
  String get checkoutPhoneLabel => '手机号码';

  @override
  String get checkoutPhoneRequired => '请输入手机号码';

  @override
  String get checkoutPostalLabel => '邮政编码';

  @override
  String get checkoutPostalRequired => '请输入邮政编码';

  @override
  String get checkoutBuyerInfo => '购买者信息';

  @override
  String get checkoutSaveInfo => '保存信息以便下次快捷支付';

  @override
  String get checkoutMoneyBackGuarantee => '30天退款保障';

  @override
  String get checkoutContinueToPayment => '继续前往支付';

  @override
  String get checkoutContinueToReview => '核对订单信息';

  @override
  String get checkoutReviewConfirm => '核对并确认';

  @override
  String get checkoutStartLearning => '开始学习';

  @override
  String get checkoutBackHome => '返回首页';

  @override
  String get courseDetailsTitle => '课程详情';

  @override
  String get courseDetailsShare => '分享课程';

  @override
  String get courseDetailsWhatYouWillLearn => '你将学到什么';

  @override
  String get courseDetailsLanguage => '授课语言';

  @override
  String get courseDetailsCreatedBy => '主讲人';

  @override
  String get courseDetailsPreviewLesson => '试看课程';

  @override
  String get courseDetailsHoursOnDemand => '小时点播视频';

  @override
  String get courseDetailsFullLifetimeAccess => '永久有效终身回看';

  @override
  String get courseDetailsCertifiedCertificate => '权威认证结业证书';

  @override
  String get courseDetailsComprehensiveContent => '完整系统化内容';

  @override
  String get certTitle => '结业证书';

  @override
  String get certStudentNameLabel => '学员姓名';

  @override
  String get certCourseLabel => '研修课程';

  @override
  String get certInstructorLabel => '导师';

  @override
  String get certIssueDateLabel => '颁发日期';

  @override
  String get certCodeLabel => '证书编号';

  @override
  String get certVerifiedBadge => '官方认证';

  @override
  String get certDownloadPDF => '下载 PDF 证书';

  @override
  String get certDownloadPNG => '保存证书图片';

  @override
  String get certCopyVerifyLink => '复制验证链接';

  @override
  String get certShare => '分享荣誉证书';

  @override
  String get playerTabLessons => '目录';

  @override
  String get playerTabOverview => '概览';

  @override
  String get playerTabNotes => '笔记';

  @override
  String get playerTabQnA => '问答';

  @override
  String get playerNextLesson => '下一节课';

  @override
  String get profileWelcome => '欢迎您';

  @override
  String get profileLoginPrompt => '登录以解锁更多学习特权';

  @override
  String get profileLoginOrRegister => '登录 / 注册账号';

  @override
  String get profileVerifiedStudent => '认证学员';

  @override
  String get profileLogout => '退出登录';

  @override
  String get profileCancel => '取消';

  @override
  String get profileLogoutConfirmTitle => '退出确认';

  @override
  String get profileLogoutConfirmMessage => '您确定要退出当前账号吗？';

  @override
  String get profileAccountSettings => '账号与设置';

  @override
  String get profileEditProfileSubtitle => '修改头像、昵称等个人资料';

  @override
  String get profileSecurity => '账号与安全';

  @override
  String get profileSecuritySubtitle => '密码修改及两步安全验证';

  @override
  String get profilePurchaseHistory => '订单记录';

  @override
  String get profilePurchaseHistorySubtitle => '查看全部消费与发票';

  @override
  String get profileCertificatesSubtitle => '查看已获得的结业证书';

  @override
  String get profileTeach => '入驻成为讲师';

  @override
  String get profileTeachSubtitle => '分享知识与经验，获取可观收益';

  @override
  String get profilePreferences => '偏好设置';

  @override
  String get profilePreferencesSubtitle => '界面主题与通用设置';

  @override
  String get profileNotifications => '通知管理';

  @override
  String get profileNotificationsSubtitle => '自定义推送与提醒';

  @override
  String get profileHelpSupport => '帮助与客服';

  @override
  String get profileTerms => '服务协议';

  @override
  String get profilePrivacy => '隐私保护政策';

  @override
  String get profileAboutEduLab => '关于 EduLab';

  @override
  String get profileWishlist => '心愿收藏单';

  @override
  String get securityTitle => '账号安全中心';

  @override
  String get teachTitle => '讲师入驻申请';

  @override
  String get notificationsTabAll => '全部';

  @override
  String get notificationsTabCourses => '课程动态';

  @override
  String get notificationsTabPromos => '优惠活动';

  @override
  String get notificationsEmptyTitle => '暂无新消息';

  @override
  String get notificationsUnread => '条未读';

  @override
  String get wishlistTitle => '心愿单';

  @override
  String get wishlistEmptyTitle => '心愿单为空';

  @override
  String get wishlistEmptySubtitle => '收藏喜欢的课程，方便随时查看';

  @override
  String get wishlistAddToCart => '移入购物车';

  @override
  String get wishlistRemovedSnackbar => '已从心愿单中移除';

  @override
  String get homeDefaultUser => '学员';

  @override
  String get learningOf => '/';

  @override
  String get cartInCartBadge => '已加购';

  @override
  String get homePromo1Badge => '限时特惠 • 抢购中';

  @override
  String get homePromo1Title => '以超值优惠开启学习之旅';

  @override
  String get homePromo1Subtitle => '编程、设计与商业精选课程高达 65% 优惠折扣。';

  @override
  String get homePromo1Button => '查看优惠';

  @override
  String get homePromo2Badge => '权威认证职业路径';

  @override
  String get homePromo2Title => '为你的理想职业生涯做好准备';

  @override
  String get homePromo2Subtitle => '从零基础到进阶实战，包含实战项目与结业证书。';

  @override
  String get homePromo2Button => '探索路径';

  @override
  String get homePromo3Badge => '行业资深名师授课';

  @override
  String get homePromo3Title => '向行业顶尖专家直接学习';

  @override
  String get homePromo3Subtitle => '持续更新的高质量内容，助你紧跟现代前沿技术。';

  @override
  String get homePromo3Button => '立即开始';

  @override
  String get homePromoInstructorBadge => '在 EduLab 教学 • 分享知识';

  @override
  String get homePromoInstructorTitle => '立即成为讲师';

  @override
  String get homePromoInstructorSubtitle => '启发全球学员，创建课程，通过传授所爱获得收入。';

  @override
  String get homePromoInstructorButton => '立即申请';

  @override
  String get homeSearchFilter => '筛选';

  @override
  String get securitySectionChangePassword => '修改密码';

  @override
  String get securityCurrentPasswordLabel => '当前密码 *';

  @override
  String get securityCurrentPasswordError => '请输入当前密码';

  @override
  String get securityNewPasswordLabel => '新密码 *';

  @override
  String get securityNewPasswordError => '密码至少需要8个字符';

  @override
  String get securityConfirmPasswordLabel => '确认新密码 *';

  @override
  String get securityConfirmPasswordError => '两次输入的密码不一致';

  @override
  String get securityUpdatePasswordBtn => '更新密码';

  @override
  String get securityPasswordUpdatedSuccess => '密码修改成功！';

  @override
  String get securitySection2FA => '双重认证 (2FA)';

  @override
  String get security2FATitle => '双重身份验证';

  @override
  String get security2FAEnabledDesc => '已开启 - 使用验证码保护您的账户';

  @override
  String get security2FADisabledDesc => '未开启（建议开启）';

  @override
  String get security2FASetupTitle => '开启双重认证';

  @override
  String get security2FASetupContent => '每次在新设备上登录时，系统都会向您的注册邮箱发送一个6位数的验证码。';

  @override
  String get security2FAEnableNow => '立即开启';

  @override
  String get security2FAEnabledSuccess => '双重认证已成功开启！';

  @override
  String get security2FADisabledSuccess => '双重认证已关闭';

  @override
  String get securitySectionSessions => '活跃会话与设备';

  @override
  String get securityLogoutAllDevices => '退出所有设备';

  @override
  String get securityThisDevice => '当前设备';

  @override
  String get securitySessionRevokedSuccess => '会话已结束并退出该设备。';

  @override
  String get securityAllSessionsRevokedSuccess => '已成功从所有其他设备退出登录。';

  @override
  String get purchaseHistoryInvoiceCertified => '认证电子发票';

  @override
  String get purchaseHistoryInvoiceNumber => '发票编号';

  @override
  String get purchaseHistoryCourse => '课程';

  @override
  String get purchaseHistoryPaymentMethod => '支付方式';

  @override
  String get purchaseHistoryTotalAmount => '总金额：';

  @override
  String get purchaseHistoryClose => '关闭';

  @override
  String get purchaseHistoryDownloadPdf => '下载 PDF';

  @override
  String get purchaseHistoryPdfDownloaded => '发票 PDF 下载成功';

  @override
  String get purchaseHistoryRefundRequestTitle => '申请退款';

  @override
  String get purchaseHistoryRefundPolicy =>
      '根据 EduLab 30天无条件退款保证政策，您可以申请全额退款至原支付方式。';

  @override
  String get purchaseHistoryRefundReasonHint => '退款原因（选填）...';

  @override
  String get purchaseHistoryConfirmRefund => '确认退款';

  @override
  String get purchaseHistoryRefundSubmitted => '退款申请已提交（3-5个工作日内到账）。';

  @override
  String get purchaseHistoryInstructor => '讲师';

  @override
  String get purchaseHistoryRequestRefundBtn => '申请退款';

  @override
  String get purchaseHistoryInvoiceBtn => '发票';

  @override
  String get purchaseHistoryStatusCompleted => '已完成';

  @override
  String get purchaseHistoryStatusRefunded => '已退款';

  @override
  String get purchaseHistoryStatusProcessingRefund => '退款处理中';

  @override
  String get editProfileSectionBasicInfo => '基本信息';

  @override
  String get editProfileFullNameLabel => '全名 *';

  @override
  String get editProfileFullNameHint => '请输入您的全名';

  @override
  String get editProfileFullNameError => '请输入完整的姓名';

  @override
  String get editProfileHeadlineLabel => '头衔 / 职业';

  @override
  String get editProfileHeadlineHint => '例如：资深 Flutter 架构师';

  @override
  String get editProfileLocationLabel => '城市 / 国家';

  @override
  String get editProfileLocationHint => '北京，中国';

  @override
  String get editProfilePhoneLabel => '手机号码';

  @override
  String get editProfileBioLabel => '个人简介 (Bio)';

  @override
  String get editProfileBioHint => '简要介绍您的兴趣与专业经历...';

  @override
  String get editProfileSectionLinks => '链接与社交网络';

  @override
  String get editProfileWebsiteLabel => '个人主页';

  @override
  String get editProfileSectionEmail => '已绑定的邮箱';

  @override
  String get editProfileEmailDesc => '用于账号登录与接收结业证书';

  @override
  String get editProfileEmailVerified => '已验证';

  @override
  String get editProfileSaveChangesBtn => '保存并更新信息';

  @override
  String get editProfileSavedSuccess => '个人资料更新成功！';

  @override
  String get editProfileChangeAvatarTitle => '更换头像';

  @override
  String get editProfileTakePhoto => '拍照';

  @override
  String get editProfileChooseGallery => '从相册选择';

  @override
  String get editProfilePhotoUpdatedSuccess => '头像更新成功';

  @override
  String get teachJoinInstructorTitle => '成为认证讲师';

  @override
  String get teachJoinInstructorSubtitle => '发布您的课程，与全球数万名学员分享您的知识与经验。';

  @override
  String get teachStep1Title => '个人信息';

  @override
  String get teachStep2Title => '经验与技能';

  @override
  String get teachStep3Title => '确认申请';

  @override
  String get teachStep1Header => '1. 个人与职业信息';

  @override
  String get teachFullNameArabicLabel => '全名 *';

  @override
  String get teachFullNameArabicHint => '例如：张伟';

  @override
  String get teachHeadlineLabel => '职业头衔与专业 *';

  @override
  String get teachHeadlineHint => '例如：高级软件工程师兼 Flutter 讲师';

  @override
  String get teachPhoneLabel => '联系电话 *';

  @override
  String get teachCountryLabel => '居住国家/地区 *';

  @override
  String get teachBioLabel => '个人简介与教学经历 *';

  @override
  String get teachBioHint => '简要介绍您的职业历程及以往教学项目...';

  @override
  String get teachNextStepSkills => '下一步：经验与技能';

  @override
  String get teachStep2Header => '2. 课程内容与技能';

  @override
  String get teachTopicLabel => '拟开课程主题或方向 *';

  @override
  String get teachTopicHint => '例如：从零构建 Flutter 跨平台应用';

  @override
  String get teachYearsExperienceLabel => '相关领域从业年限 *';

  @override
  String get teachVideoLinkLabel => '试讲视频链接 (YouTube/Drive/Loom) *';

  @override
  String get teachTargetAudienceLabel => '课程受众群体 *';

  @override
  String get teachAudienceBeginners => '零基础新手';

  @override
  String get teachAudienceIntermediate => '初学者与进阶者';

  @override
  String get teachAudienceAdvanced => '资深开发者与专业人士';

  @override
  String get teachAudienceAll => '所有人';

  @override
  String get teachSkillsCoveredLabel => '课程包含的技能与技术栈 *';

  @override
  String get teachAddSkillHint => '添加技能（如：GraphQL）...';

  @override
  String get teachAddSkillBtn => '添加';

  @override
  String get teachNextStepConfirm => '下一步：确认申请';

  @override
  String get teachStep3Header => '3. 收益结算与协议条款';

  @override
  String get teachPayoutMethodLabel => '收益提取方式 *';

  @override
  String get teachPayoutMethodBank => '银行电汇 / 直接转账 (IBAN)';

  @override
  String get teachPayoutMethodPaypal => '认证的 PayPal 账户';

  @override
  String get teachPayoutMethodPayoneer => 'Payoneer 账户 / 卡';

  @override
  String get teachIbanDetailsLabel => '账户详情 / IBAN *';

  @override
  String get teachApplicationSummary => '申请摘要：';

  @override
  String get teachApplicantName => '申请人';

  @override
  String get teachApplicantHeadline => '专业头衔';

  @override
  String get teachApplicantTopic => '课程主题';

  @override
  String get teachApplicantSkillsCount => '添加技能数';

  @override
  String get teachSkillsUnit => '项技能';

  @override
  String get teachAgreeTermsLabel => '我同意 EduLab 的讲师条款、协议及知识产权保护规则。';

  @override
  String get teachSubmitApplicationBtn => 'Submit Instructor Application';

  @override
  String get teachPrevStepBtn => '上一步';

  @override
  String get teachWhyEduLabTitle => '为什么选择在 EduLab 授课？';

  @override
  String get teachProp1Title => '丰厚而透明的分成';

  @override
  String get teachProp1Desc => '享受高达 80% 的课程销售分成，没有任何隐藏手续费。';

  @override
  String get teachProp2Title => '触达全球海量学员';

  @override
  String get teachProp2Desc => '向活跃的学习社区推广您的课程，提升个人技术影响力。';

  @override
  String get teachProp3Title => '全程技术与制作支持';

  @override
  String get teachProp3Desc => '专业团队协助优化音视频质量与课程大纲设计。';

  @override
  String get teachSuccessDialogTitle => '申请提交成功！';

  @override
  String get teachSuccessDialogDesc =>
      '感谢您加入 EduLab 讲师团队。学术审核团队将在 48 小时内审核您的申请并通过邮箱联系您。';

  @override
  String get teachSuccessDialogOk => '好的';

  @override
  String get teachAddOneSkillError => '请至少添加一项技能';

  @override
  String get teachAgreeTermsError => '请同意讲师协议与条款';

  @override
  String get commonCancel => '取消';

  @override
  String get commonClose => '关闭';

  @override
  String get myCertificatesBannerTitle => '认证证书';

  @override
  String get myCertificatesBannerSubtitle => '所有证书均经过EduLab唯一ID认证和验证';

  @override
  String get certBadgeVerified100 => '100% 认证';

  @override
  String get certCodeCopied => '证书代码已复制';

  @override
  String get certGrantedTo => '授予';

  @override
  String get certViewAndDownload => '查看并下载证书';

  @override
  String get certIssuerLabel => '发证机构';

  @override
  String get certIssuerName => 'EduLab 互动学习学院';

  @override
  String get certEmptyTitle => '尚未获得证书';

  @override
  String get certEmptyDesc => '完成所注册课程的100%，即可获得带有官方验证ID的认证证书。';

  @override
  String get certEmptyAction => '继续我的课程';

  @override
  String get certDetailsTitle => '证书详情与信息';

  @override
  String get certCopyLinkSuccess => '直接验证链接已复制到剪贴板！';

  @override
  String get certShareSuccess => '已复制证书详情和链接以供分享！';

  @override
  String get purchaseHistoryTaxInvoiceCertified => '官方认证税务发票';

  @override
  String get purchaseHistoryInvoiceNumberLabel => '订单 / 发票号';

  @override
  String get purchaseHistoryCourseNameLabel => '课程名称';

  @override
  String get purchaseHistoryPurchaseDateLabel => '购买日期';

  @override
  String get purchaseHistoryPaymentMethodLabel => '支付方式';

  @override
  String get purchaseHistoryPaymentMethodValue => '信用卡 / Stripe (在线)';

  @override
  String get purchaseHistoryOrderStatusLabel => '订单状态';

  @override
  String get purchaseHistoryStatusPendingReview => '退款审核中';

  @override
  String get purchaseHistoryCopyInvoiceBtn => '复制发票号';

  @override
  String get purchaseHistoryRefundReasonLabel => '退款申请原因：';

  @override
  String get purchaseHistoryRefundReasonEmptyError => '请输入您的退款申请原因';

  @override
  String get purchaseHistorySubmittingRefund => '正在提交申请...';

  @override
  String get purchaseHistoryPaidDate => '支付日期';

  @override
  String get purchaseHistoryEmptyTitle => '暂无购买记录';

  @override
  String get purchaseHistoryEmptyDesc => '您尚未购买任何课程。\n完成后，您的订单和发票将显示在此处。';

  @override
  String get purchaseHistoryExploreCourses => '立即探索课程';

  @override
  String get profileMyCourses => '我的课程';

  @override
  String get profileMyCoursesSubtitle => '跟踪已注册课程的进度';

  @override
  String get profileWishlistSubtitle => '心愿单中保存的课程';

  @override
  String get navMyLearning => '我的学习';

  @override
  String get profileLogoutSafeNote => '您的数据、课程和证书完全安全。重新登录后即可随时继续学习。';

  @override
  String learningRemainingHours(String hours) {
    return '剩余 $hours 小时';
  }

  @override
  String get learningCompletedFull => '已完成';

  @override
  String get learningFilterNotStarted => '未开始';

  @override
  String get wishlistTopRatedBadge => '最高评分';

  @override
  String get wishlistFeaturedBadge => '精选';

  @override
  String wishlistDiscountBadge(String percent) {
    return '$percent% 折扣';
  }

  @override
  String get courseFree => '免费';

  @override
  String get badgeBestseller => '畅销课程';

  @override
  String get badgeTopRated => '最高评分';

  @override
  String get badgeFeatured => '精选';

  @override
  String get badgeRecommended => '为您推荐';

  @override
  String get badgeNew => '最新';

  @override
  String get courseWord => '课程';

  @override
  String coursesCountText(String count) {
    return '$count+ 门课程';
  }

  @override
  String studentsCountText(String count) {
    return '$count 名学员';
  }

  @override
  String hoursCountText(String count) {
    return '$count 小时';
  }

  @override
  String get certifiedInstructor => '认证讲师';

  @override
  String get expertCertifiedInstructor => '专家及认证讲师';

  @override
  String get defaultCourseTitle => '教育课程';

  @override
  String get categoryWord => '分类';

  @override
  String get previewCourseVideo => '预览课程视频';

  @override
  String get freeSection => '免费章节';

  @override
  String get freeDemoVideo => '免费试看视频';

  @override
  String get articleLecture => '图文课';

  @override
  String get articleViewer => '文章阅读器';

  @override
  String get courseVideoPlayer => '课程视频播放器';

  @override
  String get playingNow => '正在播放';

  @override
  String get readingNow => '正在阅读';

  @override
  String get noLecturesInFreeSection => '免费章节暂无课时';

  @override
  String freeLecturesCount(String count) {
    return '$count个免费课时';
  }

  @override
  String get enrollInFullCourse => '立即加入完整课程';

  @override
  String get articleWord => '文章';

  @override
  String get videoWord => '视频';

  @override
  String get quizWord => '测验';

  @override
  String get courseShareCopied => '课程链接已复制到剪贴板！';

  @override
  String get addedToCartSnackbar => '已加入购物车';

  @override
  String get viewCartAction => '查看购物车';

  @override
  String get inCartBadge => '已在购物车 ✓';

  @override
  String get addToCartButton => '加入购物车';

  @override
  String get wishlistAddedSnackbar => '课程已成功加入愿望单';

  @override
  String get wishlistRemovedSuccessSnackbar => '课程已从愿望单中移除';

  @override
  String get lessonCompletedAll => '恭喜！您已完成本课程的所有课时。';

  @override
  String get noteAddedSuccess => '笔记添加成功';

  @override
  String get lessonAlreadyDownloaded => '该课时已保存供离线观看';

  @override
  String get lessonLinkCopied => '课时链接已复制';

  @override
  String get contentReportThanks => '感谢您的反馈，我们的团队将进行审核';

  @override
  String get courseCompletionCertificate => '课程结业证书';

  @override
  String get reportContentIssue => '举报内容问题';

  @override
  String get loginOrSocial => '或通过以下方式登录';

  @override
  String get loginSuccessSnackbar => '登录成功';

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
  String get cartClearAllTitle => '清空购物车中的所有商品？';

  @override
  String cartClearAllMessage(String count) {
    return '您确定要从购物车中移除全部 $count 门课程吗？';
  }

  @override
  String get cartClearAllHint => '所有课程将从您的购物车中移除。您可以随时重新添加它们。';

  @override
  String cartClearAllConfirm(String count) {
    return '全部清空 ($count)';
  }

  @override
  String get cartClearedSuccess => '购物车已成功清空';

  @override
  String get cartClearFailed => '清空购物车失败';

  @override
  String cartViewWishlistCount(String count) {
    return '查看心愿单商品 ($count)';
  }

  @override
  String get cartGoToWishlist => '前往心愿单';

  @override
  String get wishlistClearAllTitle => '清空心愿单中的所有商品？';

  @override
  String wishlistClearAllMessage(String count) {
    return '您确定要从心愿单中移除全部 $count 门课程吗？';
  }

  @override
  String get wishlistClearAllHint => '所有已收藏的课程将被清空。您可以随时从“探索”中重新添加。';

  @override
  String wishlistClearAllConfirm(String count) {
    return '全部清空 ($count)';
  }

  @override
  String get wishlistClearedSuccess => '心愿单已成功清空';

  @override
  String get wishlistClearFailed => '清空心愿单失败';

  @override
  String get wishlistClearTooltip => '全部清空';

  @override
  String wishlistViewCartCount(String count) {
    return '查看购物车商品 ($count)';
  }

  @override
  String get wishlistGoToCart => '前往购物车';

  @override
  String get checkoutCardNumberInvalid => '请输入有效的 16 位卡号';

  @override
  String get checkoutCardExpiryInvalidFormat => '请输入有效的卡有效期 (MM / YY)';

  @override
  String get checkoutCardExpiredDate => '卡有效期无效';

  @override
  String get checkoutCardCvcInvalid => '请输入有效的 3 位或 4 位 CVC 码';

  @override
  String get checkoutCardHolderNameRequired => '请输入持卡人姓名';

  @override
  String get checkoutCartEmptySnackbar => '购物车为空';

  @override
  String get checkoutPaymentStartFailed => '发起支付失败';

  @override
  String get checkoutClientSecretMissing => '未从支付网关接收到安全密钥';

  @override
  String get checkoutCardVerificationFailed => '银行卡验证失败';

  @override
  String get checkoutStripeProcessingFailed => 'Stripe 支付处理失败';

  @override
  String get checkoutServerConfirmationFailed => '服务器支付确认失败';

  @override
  String get checkoutEmptyCartTitle => '您的购物车是空的';

  @override
  String get checkoutEmptyCartDesc => '您尚未向购物车添加任何课程。探索我们的课程并开始学习吧！';

  @override
  String get checkoutContinueFreeReview => '继续免费审核';

  @override
  String get checkoutFreeOrderBadge => '100% 免费订单 (zsh.00)';

  @override
  String get checkoutFreeOrderNotice => '此订单无需任何支付信息。您可以直接确认报名。';

  @override
  String get checkoutFreeCheckoutTitle => '100% 免费结账';

  @override
  String get checkoutConfirmFreeEnrollment => '确认免费报名';

  @override
  String get checkoutFreePrice => '免费';

  @override
  String get checkoutFreeZero => '免费 (zsh.00)';

  @override
  String checkoutCoursesCount(String count) {
    return '$count 门课程';
  }

  @override
  String get notificationsClearAllTitle => '清空所有通知？';

  @override
  String notificationsClearAllMessage(String count) {
    return '您确定要删除所有 $count 条通知吗？此操作无法撤消。';
  }

  @override
  String get notificationsClearAllHint => '您的所有通知将被删除，收件箱将清空。';

  @override
  String notificationsClearAllConfirm(String count) {
    return '全部清空 ($count)';
  }

  @override
  String get notificationsClearSuccess => '所有通知已成功清空';

  @override
  String get notificationsClearFailed => '清空通知失败';

  @override
  String get notificationsClearTooltip => '全部清空';

  @override
  String get notificationsViewDetails => '查看详情';

  @override
  String get notificationsEmptyCategoryTitle => '该分类下暂无通知';

  @override
  String get notificationsEmptyCategorySubtitle => '请尝试切换到其他分类或浏览所有通知';

  @override
  String get notificationsEmptyAllSubtitle => '我们将在此处向您同步最新动态和提醒';

  @override
  String get notificationsViewAll => '查看所有通知';

  @override
  String get learningFilterAndSortTitle => '筛选与排序课程';

  @override
  String get learningFilterReset => '重置';

  @override
  String get learningSortByTitle => '排序方式';

  @override
  String get learningSortRecentActivity => '最近访问';

  @override
  String get learningSortRecentEnrolled => '最近加入';

  @override
  String get learningSortTitleAZ => '标题 (A-Z)';

  @override
  String get learningSortProgress => '学习进度 %';

  @override
  String get learningStatusTitle => '课程状态';

  @override
  String get learningStatusAll => '全部课程';

  @override
  String get learningStatusInProgress => '正在进行';

  @override
  String get learningStatusCompleted => '完全的';

  @override
  String get learningStatusNotStarted => '未开始';

  @override
  String get learningFilterApply => '应用过滤器';

  @override
  String get learningSearchCoursesHint => '搜索您的课程...';

  @override
  String get learningSearchWishlistHint => '搜索愿望清单...';

  @override
  String get learningSearchCertificatesHint => '搜索证书...';

  @override
  String get learningTabMyCourses => '我的课程';

  @override
  String get learningTabFavourite => '我的最爱';

  @override
  String get learningTabCertificates => '我的证书';

  @override
  String get learningNoCoursesTitle => '还没有课程';

  @override
  String get learningNoCoursesSubtitle => '探索数千门优质课程，立即开始您的学习之旅';

  @override
  String get learningFilterButton => '筛选';

  @override
  String learningFilterAllCount(String count) {
    return '全部 ($count)';
  }

  @override
  String get learningStatusNotStartedShort => '未开始';

  @override
  String get learningNoMatchTitle => '没有匹配的课程';

  @override
  String learningNoMatchSubtitle(String query) {
    return '找不到包含“$query”的课程。尝试使用不同的术语进行搜索。';
  }

  @override
  String get learningNoInProgressTitle => '没有正在进行中的课程';

  @override
  String get learningNoInProgressSubtitle => '在这里开始观看您注册的课程中的课程以跟踪您的进度。';

  @override
  String get learningNoCompletedTitle => '尚未完成课程';

  @override
  String get learningNoCompletedSubtitle => '继续学习以庆祝您的进步并在此处查看已完成的课程。';

  @override
  String get learningNoUnstartedTitle => '没有未开始的课程';

  @override
  String get learningNoUnstartedSubtitle => '惊人的！您已经开始学习所有注册的课程。';

  @override
  String get learningNoFilterMatchTitle => '没有课程符合此筛选条件';

  @override
  String get learningNoFilterMatchSubtitle => '更改过滤器或排序选项以显示您的课程。';

  @override
  String learningViewAllCoursesCount(String count) {
    return '查看所有课程 ($count)';
  }

  @override
  String learningSavedCoursesCount(String count) {
    return '已保存课程 ($count)';
  }

  @override
  String get learningClearAllSaved => '全部清除';

  @override
  String get learningNoCertificatesTitle => '还没有证书';

  @override
  String get learningNoCertificatesSubtitle => '完成您的课程以获得认证证书来验证您的成就';

  @override
  String get learningGoToCourses => '前往我的课程';

  @override
  String learningCertIssuedDate(String date) {
    return '发布：$date';
  }

  @override
  String get learningCertView => '看法';

  @override
  String get learningResumeLesson => '恢复课程';

  @override
  String learningProgressPercentComplete(String percent) {
    return '$percent% 完成';
  }

  @override
  String learningViewCartCount(String count) {
    return '查看购物车商品 ($count)';
  }

  @override
  String get learningGoToCart => '去购物车';

  @override
  String get playerLessonMarkedCompleted => '课程标记为已完成 ✓';

  @override
  String get playerLessonMarkedIncomplete => '课程标记为未完成';

  @override
  String get playerCommentPostedSuccess => '评论发表成功';

  @override
  String get playerCommentPostFailed => '无法发表评论';

  @override
  String get playerReplyPostedSuccess => '回复发布成功';

  @override
  String get playerReplyPostFailed => '无法发表回复';

  @override
  String get playerCourseNotFound => '找不到课程';

  @override
  String get playerCheckEnrollmentPrompt => '请先验证您的课程注册情况';

  @override
  String get playerReturnToCourses => '我的学习';

  @override
  String get playerWatchLecture => '课程讲座';

  @override
  String get playerCertificateTooltip => '证书';

  @override
  String get playerRateCourseTooltip => '课程价格';

  @override
  String get playerReadingArticleBadge => '阅读文章 • 5 分钟';

  @override
  String get playerReadFullTextBelow => '阅读全文如下↓';

  @override
  String get playerTabReviews => '评论';

  @override
  String get playerNoSectionsAvailable => '没有可用的部分';

  @override
  String playerLessonsCount(String count) {
    return '$count 课程';
  }

  @override
  String get playerPlayingBadge => '演奏';

  @override
  String get playerArticleBadge => '文章';

  @override
  String get playerVideoBadge => '视频';

  @override
  String get playerFullArticleContent => '完整文章内容';

  @override
  String get playerArticlePlaceholder =>
      '欢迎来到这堂阅读课。\n\n本节涵盖掌握本课程技能所需的核心概念和实践步骤。';

  @override
  String get playerAboutCourseTitle => '关于本课程';

  @override
  String get playerShowLess => '显示更少';

  @override
  String get playerReadMore => '阅读更多';

  @override
  String get playerWhatYouWillLearn => '您将学到什么';

  @override
  String get playerCourseInfoTitle => '课程详情';

  @override
  String get playerTotalDurationTitle => '总时长';

  @override
  String get playerTotalLessonsTitle => '总课时';

  @override
  String playerLessonsNumber(String count) {
    return '$count 节课';
  }

  @override
  String get playerLevelTitle => '难度级别';

  @override
  String get playerAllLevels => '所有级别';

  @override
  String get playerLanguageTitle => '语言';

  @override
  String get playerLanguageArabic => '阿拉伯语';

  @override
  String get playerPrerequisitesTitle => '课程要求';

  @override
  String get playerCertificateCardTitle => '结业证书';

  @override
  String get playerCourseCompletedSuccess => '恭喜！课程已完成';

  @override
  String get playerProgressLabel => '学习进度';

  @override
  String get playerViewCertificateBtn => '查看证书';

  @override
  String get playerCertifiedInstructor => '认证讲师';

  @override
  String playerDiscussionsCount(String count) {
    return '$count 个提问与讨论';
  }

  @override
  String get playerAskQuestionHint => '在此输入您的问题或疑问...';

  @override
  String get playerPostBtn => '发布';

  @override
  String get playerNoDiscussionsTitle => '暂无讨论';

  @override
  String get playerNoDiscussionsSubtitle => '成为第一个提问的人吧！';

  @override
  String get playerInstructorBadge => '讲师';

  @override
  String get playerCancelReply => '取消';

  @override
  String get playerReplyAction => '回复';

  @override
  String playerRepliesCount(String count) {
    return '$count 条回复';
  }

  @override
  String get playerWriteReplyHint => '写下您的回复...';

  @override
  String get playerSendReplyBtn => '回复';

  @override
  String get playerCourseFeedbackTitle => '课程评分与评价';

  @override
  String get playerOutOf5 => '满分 5 分';

  @override
  String playerRatingsFromEnrolledCount(String count) {
    return '来自已报名学生的 $count 条评分';
  }

  @override
  String get playerKeepLearningToRate => '继续学习以进行评价';

  @override
  String get playerRateAfter80Hint => '完成 80% 的课程内容后即可发表评价与评分';

  @override
  String get playerCurrentProgressLabel => '您的进度：';

  @override
  String get playerYourCurrentRating => '您的评分';

  @override
  String get playerEditRating => '编辑评分';

  @override
  String get playerDeleteRatingTooltip => '删除评分';

  @override
  String get playerUpdateRatingTitle => '更新您的评分';

  @override
  String get playerRateCourseTitle => '评价此课程';

  @override
  String get playerWriteReviewHint => '写下您对内容质量的评价和想法（选填）...';

  @override
  String get playerRatingSubmitSuccess => '评分提交成功！';

  @override
  String get playerRatingSubmitFailed => '提交评分失败';

  @override
  String get playerSaveChangesBtn => '保存更改';

  @override
  String get playerSubmitReviewBtn => '提交评价';

  @override
  String get playerLearnerReviewsTitle => '学员评价';

  @override
  String playerReviewsCount(String count) {
    return '$count 条评价';
  }

  @override
  String get playerNoWrittenReviewsTitle => '暂无文字评价';

  @override
  String get playerNoWrittenReviewsSubtitle => '成为第一个分享想法的人吧！';

  @override
  String get playerRatingLabel5 => '极佳 🌟 (5/5)';

  @override
  String get playerRatingLabel4 => '很好 👍 (4/5)';

  @override
  String get playerRatingLabel3 => '一般 👌 (3/5)';

  @override
  String get playerRatingLabel2 => '有待提高 🤔 (2/5)';

  @override
  String get playerRatingLabel1 => '较差 👎 (1/5)';

  @override
  String get playerDeleteRatingDialogTitle => '删除评分';

  @override
  String get playerDeleteRatingDialogMessage => '您确定要删除对此课程的评价吗？';

  @override
  String get playerDeleteConfirmBtn => '删除';

  @override
  String get playerRatingDeleteSuccess => '评分已成功删除';

  @override
  String get playerPreviousLesson => '上一节';

  @override
  String get playerExitFullscreenTooltip => '退出全屏';

  @override
  String instructorsAvailableCount(String count) {
    return '$count 位讲师可选';
  }

  @override
  String get instructorsNotFound => '未找到讲师';

  @override
  String instructorsCoursesCount(String count) {
    return '$count 课程';
  }

  @override
  String get instructorsSearchHint => '按讲师姓名或专业搜索...';

  @override
  String get instructorsSortAll => '全部';

  @override
  String get instructorsSortTopRated => '最受好评';

  @override
  String get instructorsSortMostStudents => '大多数学生';

  @override
  String get instructorsSortMostCourses => '大多数课程';

  @override
  String get instructorsNotFoundSubtitle => '尝试使用不同的名称或清除过滤器进行搜索';

  @override
  String get exploreCompleteCourse => '综合课程';

  @override
  String get exploreGeneralCategory => '一般的';

  @override
  String courseShareMessage(String title, String url) {
    return '查看 EduLab 上的课程“$title”：$url';
  }

  @override
  String get courseDetailsDefaultTitle => '课程详情';

  @override
  String get courseDetailsTooltipShare => '分享';

  @override
  String get courseDetailsTooltipWishlist => '愿望清单';

  @override
  String get courseDetailsTooltipCart => '大车';

  @override
  String get courseDetailsNotFound => '找不到课程';

  @override
  String get courseDetailsDefaultCategory => '课程';

  @override
  String courseDetailsTotalRatingsCount(String count) {
    return '（$count 评级）';
  }

  @override
  String courseDetailsLecturesCount(String count) {
    return '$count 讲座';
  }

  @override
  String get courseDetailsCertificateBadge => '证书';

  @override
  String get courseDetailsTabOverview => '概述';

  @override
  String get courseDetailsTabCurriculum => '课程';

  @override
  String get courseDetailsTabInstructor => '讲师';

  @override
  String get courseDetailsTabReviews => '评论';

  @override
  String get courseDetailsFullDescriptionTitle => '描述';

  @override
  String get courseDetailsShowLess => '显示较少';

  @override
  String get courseDetailsShowMore => '显示更多...';

  @override
  String courseDetailsCurriculumSectionsLectures(
    String sections,
    String lectures,
  ) {
    return '$sections 个部分 • $lectures 个讲座';
  }

  @override
  String get courseDetailsCollapseAll => '全部折叠';

  @override
  String get courseDetailsExpandAll => '全部展开';

  @override
  String get courseDetailsCurriculumComingSoon => '课程详情即将推出';

  @override
  String courseDetailsSectionLecturesCount(String count) {
    return '$count 讲座';
  }

  @override
  String get courseDetailsLecturePreviewBtn => '预览';

  @override
  String get courseDetailsDefaultInstructorTitle => '高级讲师和认证专家';

  @override
  String get courseDetailsInstructorRatingLabel => '等级';

  @override
  String get courseDetailsInstructorStudentsLabel => '学生';

  @override
  String get courseDetailsInstructorSectionsLabel => '部分';

  @override
  String get courseDetailsAboutInstructorTitle => '关于导师：';

  @override
  String get courseDetailsDefaultInstructorAbout =>
      '认证讲师在为全球数千名学生提供专业教育方面拥有丰富的经验。';

  @override
  String courseDetailsStudentRatingsCount(String count) {
    return '$count 学生评分';
  }

  @override
  String get courseDetailsNoWrittenReviews => '还没有书面评论';

  @override
  String get courseDetailsRelatedCourses => '您可能喜欢的相关课程';

  @override
  String courseDetailsDiscountPercent(String percent) {
    return '$percent% 折扣';
  }

  @override
  String get courseDetailsResumeCourse => '简历课程';

  @override
  String get courseDetailsTryAgain => '再试一次';

  @override
  String get courseDetailsEstimatedReading => '📖 预计阅读时间：4 分钟';

  @override
  String get courseDetailsSampleArticleContent =>
      '欢迎来到这篇文章讲座。\n\n本节涵盖关键的理论概念和掌握该主题的实践步骤。\n\n• 要点：\n1. 掌握核心术语和架构模式。\n2、动手练习，不断练习。\n3.参考补充笔记和作业。\n\n享受阅读的乐趣！';

  @override
  String certDownloadedSuccess(String course, String format) {
    return '已成功下载 $format 格式的“$course”证书！';
  }

  @override
  String certVerifiedFullRequirements(String code) {
    return '验证 ID：$code • 100% 已完成要求';
  }

  @override
  String get certCompletionTitle => '结业证书';

  @override
  String get certCompletionSubtitle => '课程结业证书';

  @override
  String get certAnnounceStudent => 'EducationLab 学习学院特此证明：';

  @override
  String get certCompletionRequirementsMet => '已成功完成培训课程的所有要求：';

  @override
  String certIssueDateText(String date) {
    return '发布日期：$date';
  }

  @override
  String certIdNumberText(String code) {
    return '证书 ID：$code';
  }

  @override
  String get certPlatformManagement => '平台管理';

  @override
  String get certInstructorRoleTitle => '课程导师';

  @override
  String get commonLoading => '加载中...';

  @override
  String get homeGuestTagline => '智能学习和技能培养平台';

  @override
  String get catTagHighestDemand => '需求最高';

  @override
  String get catTagMostPopular => '最受欢迎';

  @override
  String get catTagTrending => '当下热门';

  @override
  String get catTagFastestGrowing => '增长最快';

  @override
  String get catTagHighDemand => '极高需求';

  @override
  String get catTagTopRated => '最高评分';

  @override
  String get catTagEssential => '至关重要';

  @override
  String get catTagAdvanced => '高级进阶';

  @override
  String get catTagEntrepreneurs => '创业者';

  @override
  String get catTagSalesGrowth => '业绩增长';

  @override
  String get catDevTitle => '编程与软件开发';

  @override
  String get catDevSubtitle => '软件工程、系统架构与算法';

  @override
  String get catWebTitle => 'Web 开发';

  @override
  String get catWebSubtitle => '前端、后端与全栈开发';

  @override
  String get catMobileTitle => '移动应用开发';

  @override
  String get catMobileSubtitle => 'Flutter、iOS 与 Android 移动应用';

  @override
  String get catAiTitle => '人工智能';

  @override
  String get catAiSubtitle => '机器学习、深度学习与 AI 应用';

  @override
  String get catDataTitle => '数据科学与分析';

  @override
  String get catDataSubtitle => '数据分析、统计学与大数据';

  @override
  String get catDesignTitle => 'UI/UX 与产品设计';

  @override
  String get catDesignSubtitle => 'UI/UX、原型制作与产品设计';

  @override
  String get catSecurityTitle => '网络空间安全';

  @override
  String get catSecuritySubtitle => '网络安全、白帽黑客与网络防护';

  @override
  String get catCloudTitle => '云计算与 DevOps';

  @override
  String get catCloudSubtitle => '云基础设施、DevOps 与 CI/CD';

  @override
  String get catBusinessTitle => '商业与项目管理';

  @override
  String get catBusinessSubtitle => '创业创新、敏捷开发与领导力';

  @override
  String get catMarketingTitle => '数字营销';

  @override
  String get catMarketingSubtitle => '数字营销、SEO 与用户增长策略';

  @override
  String get timeJustNow => '刚刚';

  @override
  String timeMinutesAgo(String count) {
    return '$count 分钟前';
  }

  @override
  String timeHoursAgo(String count) {
    return '$count 小时前';
  }

  @override
  String timeDaysAgo(String count) {
    return '$count 天前';
  }

  @override
  String timeWeeksAgo(String count) {
    return '$count 周前';
  }

  @override
  String timeMonthsAgo(String count) {
    return '$count 个月前';
  }

  @override
  String wishlistLecturesCount(String count) {
    return '$count 节讲座';
  }

  @override
  String get instructorProfileTitle => '讲师资料';

  @override
  String instructorProfileLinkCopied(String name) {
    return '已复制 $name 的主页链接到剪贴板';
  }

  @override
  String get instructorDefaultName => '讲师';

  @override
  String get instructorProfileBadge => '讲师';

  @override
  String get instructorProfileTotalStudents => '学员总数';

  @override
  String get instructorProfileRating => '讲师评分';

  @override
  String get instructorProfileCourses => '课程';

  @override
  String get instructorProfileShare => '分享主页';

  @override
  String get instructorProfileLinkOpenError => '无法打开链接，已复制到剪贴板';

  @override
  String get instructorProfileWebsite => '个人网站';

  @override
  String get instructorProfileAboutMe => '关于我';

  @override
  String get instructorProfileShowLess => '显示较少';

  @override
  String get instructorProfileShowMore => '显示更多';

  @override
  String get instructorProfileExpertise => '专业领域';

  @override
  String get instructorProfileSortAll => '全部';

  @override
  String get instructorProfileSortTopRated => '最受好评';

  @override
  String get instructorProfileSortPopular => '最受欢迎';

  @override
  String get instructorProfileSortNewest => '最新';

  @override
  String get instructorProfileCoursesTitle => '讲师课程';

  @override
  String get instructorProfileNoCoursesFilter => '未找到符合此筛选条件的课程';

  @override
  String instructorProfileLoadMoreCourses(String count) {
    return '加载更多课程（剩余 $count 门）';
  }

  @override
  String get instructorProfileLoadingMoreCourses => '正在加载更多课程...';

  @override
  String instructorProfileAllCoursesLoaded(String count) {
    return '已加载全部 $count 门课程';
  }

  @override
  String get instructorProfileStudentFeedback => '学员评价';

  @override
  String instructorProfileReviewsCount(String count) {
    return '$count 条评价';
  }

  @override
  String instructorProfileBasedOnReviews(String count) {
    return '基于 $count 条评价';
  }

  @override
  String get instructorProfileRecentReviews => '最新评价';

  @override
  String instructorProfileLoadMoreReviews(String count) {
    return '加载更多评价（剩余 $count 条）';
  }

  @override
  String get instructorProfileLoadingMoreReviews => '正在加载更多评价...';

  @override
  String instructorProfileAllReviewsLoaded(String count) {
    return '已加载全部 $count 条评价';
  }

  @override
  String get instructorProfileNoReviewsYet => '暂无文字评价';

  @override
  String get instructorProfileRatingDesc => '评分基于该讲师所有课程的学员总体评价计算得出';

  @override
  String get instructorProfileLoadError => '加载讲师详情失败，请稍后重试';

  @override
  String get instructorProfileDefaultStudentName => '学员';

  @override
  String get instructorProfileDefaultHeadline => '资深讲师兼认证专家';

  @override
  String get instructorProfileDefaultBio =>
      '认证软件工程师和技术讲师，在构建可扩展软件系统和移动应用方面拥有丰富经验。\n曾培训全球成千上万名学员和工程师，致力于提供专注于整洁代码、清晰架构及现代可扩展解决方案的专业内容。';

  @override
  String get supportNewChat => '新建对话';

  @override
  String get supportNoChatsTitle => '暂无支持对话';

  @override
  String get supportNoChatsDesc => '我们的支持团队 7x24 小时随时为您提供帮助并解答所有疑问';

  @override
  String get supportStartNewConversation => '发起新对话';

  @override
  String get supportNoMessagesYet => '暂无消息';

  @override
  String get supportRetry => '重试';

  @override
  String get supportOpenTicket => '进行中的工单';

  @override
  String get supportClosedTicket => '已关闭的工单';

  @override
  String get supportCloseAction => '关闭';

  @override
  String get supportReopenAction => '重新开启';

  @override
  String get supportNoMessagesInChat => '此对话中暂无消息';

  @override
  String get supportYou => '你';

  @override
  String get supportTeam => '支持团队';

  @override
  String get supportTypeMessageHint => '在此输入您的消息...';

  @override
  String get supportConversationClosedNotice => '此对话当前已关闭。';

  @override
  String get supportCloseDialogTitle => '关闭对话？';

  @override
  String get supportCloseDialogDesc => '您确定要关闭此对话吗？您可以随时重新开启以继续交流。';

  @override
  String get supportCancel => '取消';

  @override
  String get supportYesClose => '确定关闭';

  @override
  String get supportNewChatTitle => '新建支持对话';

  @override
  String get supportNewChatSubtitle => '我们的团队随时为您提供帮助';

  @override
  String get supportSubjectLabel => '主题';

  @override
  String get supportSubjectHint => '例如：课程咨询、支付问题...';

  @override
  String get supportMessageLabel => '消息内容';

  @override
  String get supportMessageHint => '请详细描述您的问题或疑问...';

  @override
  String get supportMessageRequired => '请输入消息内容';

  @override
  String get supportStartConversationBtn => '发起对话';

  @override
  String get supportCreateError => '创建对话失败，请稍后重试';

  @override
  String get supportTopicCourse => '课程咨询';

  @override
  String get supportTopicPayment => '支付问题';

  @override
  String get supportTopicCertificates => '证书问题';

  @override
  String get supportTopicTech => '技术问题';

  @override
  String get supportTopicGeneral => '通用咨询';

  @override
  String get cartGuestTitle => '登录以查看您的购物车';

  @override
  String get cartGuestSubtitle => '请登录以访问您的购物车并顺利完成课程购买。';

  @override
  String get wishlistGuestTitle => '登录以查看您的愿望单';

  @override
  String get wishlistGuestSubtitle => '请登录以随时查看您保存的心仪课程。';

  @override
  String get courseDetailsLoginRequiredTitle => '需要登录';

  @override
  String get courseDetailsLoginRequiredDesc => '您必须先登录才能购买此课程并保存您的学习进度。';

  @override
  String get courseDetailsProceedToLogin => '前往登录';

  @override
  String get messagesGuestTitle => '登录以查看消息';

  @override
  String get messagesGuestSubtitle => '请登录以访问支持对话并与客服团队沟通。';

  @override
  String get notificationsGuestTitle => '登录以查看通知';

  @override
  String get notificationsGuestSubtitle => '请登录以查看您的帐户和课程的最新动态与通知。';

  @override
  String get legalTitle => '关于与法律条款';

  @override
  String get legalTabAbout => '关于 EduLab';

  @override
  String get legalTabPrivacy => '隐私政策';

  @override
  String get legalTabTerms => '使用条款';

  @override
  String get legalUpdated => '更新于：';

  @override
  String get legalNeedHelpTitle => '需要帮助或有任何疑问？';

  @override
  String get legalNeedHelpDesc => 'EduLab 支持团队 7x24 小时竭诚为您服务。欢迎直接通过电子邮件联系我们。';

  @override
  String get legalEmailCopied => '支持邮箱已复制到剪贴板';

  @override
  String get legalNoContent => '暂无可用内容';

  @override
  String get checkoutDigitalReceipt => '电子收据';

  @override
  String get checkoutTransactionDate => '交易日期';

  @override
  String get checkoutFreeEnrollment => '免费报名';

  @override
  String get checkoutEnrolledCourses => '已购课程';

  @override
  String get checkoutTransactionStatus => '状态';

  @override
  String get checkoutStatusSuccess => '已成功完成';

  @override
  String get checkoutTotalPaid => '实付总额';

  @override
  String get checkoutCopied => '已复制！';

  @override
  String get checkoutCardHolderHint => '持卡人姓名（如卡面所示）';

  @override
  String get teachUploadProfilePhoto => '上传头像';

  @override
  String get teachAttachCV => '附加简历';

  @override
  String get teachChooseClearPhotoForAccount => '为您的培训帐户选择一张清晰的照片';

  @override
  String get teachChooseClearDocForCV => '选择一份清晰的简历文档或照片';

  @override
  String get teachTakePhoto => '拍照';

  @override
  String get teachTakePhotoSubtitle => '使用相机拍摄新照片';

  @override
  String get teachChooseFromGallery => '从图库中选择';

  @override
  String get teachChooseFromGallerySubtitle => '从您的设备中选择一个文件';

  @override
  String get teachAddOneSkillRequired => '请至少添加一项技能';

  @override
  String get teachAgreeTermsRequired => '请同意教学条款和条件以继续';

  @override
  String get teachApplicationReceivedTitle => '已成功收到您的申请！';

  @override
  String get teachApplicationReceivedDesc =>
      '感谢您加入 EduLab 讲师社区。我们的学术审核团队将审核您的申请，并在做出决定时通知您。';

  @override
  String get teachTrackApplicationStatus => '跟踪申请状态';

  @override
  String get teachRefreshTooltip => '刷新';

  @override
  String get teachVerifyingApplicationData => '正在验证申请数据...';

  @override
  String get teachAlreadyInstructor => '您已经是受批准的讲师！';

  @override
  String get teachAlreadyInstructorDesc =>
      '您的帐户拥有所有讲师权限。您可以管理您的课程并在讲师仪表板中发布新内容。';

  @override
  String get teachBackToHome => '返回首页';

  @override
  String get teachStatusApproved => '您的讲师申请已获批准';

  @override
  String get teachStatusRejected => '您的申请已被拒绝';

  @override
  String get teachStatusPending => '您的申请目前正在审核中';

  @override
  String get teachApplicationDetails => '申请详情';

  @override
  String get teachApplicationNumber => '申请编号';

  @override
  String get teachApplicationDate => '申请日期';

  @override
  String get teachApplicant => '申请人';

  @override
  String get teachApplicantEmail => '电子邮件';

  @override
  String get teachSpecialization => '专业';

  @override
  String get teachExperienceYears => '经验年数';

  @override
  String get teachCVLabel => '简历';

  @override
  String get teachCVAttached => '已附加 ✓';

  @override
  String get teachReapply => '提交新申请';

  @override
  String get teachRefreshing => '正在刷新...';

  @override
  String get teachRefreshStatus => '刷新申请状态';

  @override
  String get teachApprovedMessage => '恭喜！您现在可以开始上传和分享您的培训课程了。';

  @override
  String teachRejectionReason(String reason) {
    return '拒绝原因：$reason';
  }

  @override
  String get teachRejectedDefault => '很遗憾，该申请不符合当前的要求。您可以查看您的数据并重新申请。';

  @override
  String get teachPendingMessage => '您的申请已收到，目前正在由平台管理部门审核。我们会将决定通知您。';

  @override
  String get teachStepPersonalData => '个人信息';

  @override
  String get teachStepExperienceSkills => '经验和技能';

  @override
  String get teachStepReviewApplication => '审核申请';

  @override
  String get teachStep1HeaderTitle => '1. 个人和职业信息';

  @override
  String get teachFullNameLabel => '全名 *';

  @override
  String get teachFullNameHintAr => '例如：张三';

  @override
  String get teachFullNameValidation => '请输入有效的姓名';

  @override
  String get teachEmailReadonly => '电子邮件（注册帐户）';

  @override
  String get teachPhoneLabelContact => '联系电话 *';

  @override
  String get teachPhoneValidation => '请输入有效的电话号码';

  @override
  String get teachBioLabelWithAsterisk => '简介 *';

  @override
  String teachBioCharCount(String count) {
    return '$count / 200 个字符';
  }

  @override
  String get teachBioHintDetail => '简要总结您的职业和培训专业（最多 200 个字符）...';

  @override
  String get teachBioMinLengthValidation => '简介必须至少为 10 个字符';

  @override
  String get teachBioMaxLengthValidation => '简介不得超过 200 个字符';

  @override
  String get teachProfilePhotoOptional => '讲师头像（可选）';

  @override
  String get teachNextExperienceSkills => '继续：经验和技能';

  @override
  String get teachStep2HeaderTitle => '2. 学术经验和技能';

  @override
  String get teachSpecializationLabel => '专业 *';

  @override
  String get teachSpecializationHint => '选择专业';

  @override
  String get teachExperienceLabel => '经验年数 *';

  @override
  String get teachExperience0to2 => '不到 2 年（0 - 2）';

  @override
  String get teachExperience2to5 => '2 到 5 年（2 - 5）';

  @override
  String get teachExperience5to10 => '5 到 10 年（5 - 10）';

  @override
  String get teachExperience10plus => '10 年以上（10+）';

  @override
  String get teachSkillsLabel => '技能和技术 *';

  @override
  String get teachSkillHint => '添加技能（例如 Flutter、Dart、UI/UX）...';

  @override
  String get teachSkillAddButton => '添加';

  @override
  String get teachSkillMinRequired => '* 请至少添加一项技能';

  @override
  String get teachCVFileLabel => '简历文件';

  @override
  String get teachPrevButton => '上一步';

  @override
  String get teachNextReviewApplication => '继续：审核申请';

  @override
  String get teachStep3HeaderTitle => '3. 审核申请并确认条款';

  @override
  String get teachReviewBanner => '提交前请仔细核对所有输入的数据。提交后，您的帐户状态将更新为待审核讲师。';

  @override
  String get teachSummaryFullName => '全名';

  @override
  String get teachSummaryEmail => '电子邮件';

  @override
  String get teachSummaryPhone => '电话号码';

  @override
  String get teachSummarySpecialization => '学术专业';

  @override
  String get teachSummaryExperience => '经验年数';

  @override
  String teachSummarySkillsCount(String count, String skills) {
    return '$count 项技能 ($skills)';
  }

  @override
  String get teachSummaryProfilePhoto => '头像';

  @override
  String get teachSummaryPhotoSelected => '已选择 ✓';

  @override
  String get teachSummaryPhotoNotSelected => '未选择';

  @override
  String get teachSummaryCVFile => '简历';

  @override
  String get teachSummaryCVAttached => '已附加 ✓';

  @override
  String get teachSummaryCVNotAttached => '未附加';

  @override
  String get teachTermsAgreement => '我同意 EduLab 的教学条款、条件和知识产权协议。';

  @override
  String get teachSubmitButton => '提交讲师申请';

  @override
  String get teachPhotoSelectedSuccess => '照片选择成功';

  @override
  String get teachChoosePhotoFromDevice => '从您的设备中选择头像';

  @override
  String get teachCVAttachedSuccess => '简历已成功附加';

  @override
  String get teachAttachCVFileOrPhoto => '附加简历（文件或照片）';

  @override
  String get teachSummarySkillsLabel => '添加的技能';
}

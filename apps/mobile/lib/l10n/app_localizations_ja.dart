// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get onboardingSkip => 'スキップ';

  @override
  String get onboardingTitle1 => 'EduLabへようこそ';

  @override
  String get onboardingSubtitle1 =>
      '最新のインタラクティブ学習と持続的なキャリア成長のための理想的なプラットフォームです。';

  @override
  String get onboardingTitle2 => '一流の講師陣から学ぶ';

  @override
  String get onboardingSubtitle2 => 'プログラミング、デザイン、ビジネス、データサイエンスなど数千の専門講座を提供。';

  @override
  String get onboardingTitle3 => '認定修了証と確かな成長';

  @override
  String get onboardingSubtitle3 => '学習進捗を管理し、テストに合格して信頼される修了証を取得しましょう。';

  @override
  String get onboardingNext => '次へ';

  @override
  String get onboardingStart => '今すぐ始める';

  @override
  String get splashAppName => 'Education Lab';

  @override
  String get splashTagline => 'スマート学習プラットフォーム';

  @override
  String get loginTagline => 'スマート学習プラットフォームへようこそ';

  @override
  String get loginAppName => 'EduLab';

  @override
  String get loginTabLogin => 'ログイン';

  @override
  String get loginTabRegister => '新規登録';

  @override
  String get loginEmailLabel => 'メールアドレス';

  @override
  String get loginEmailHint => 'example@email.jp';

  @override
  String get loginPasswordLabel => 'パスワード';

  @override
  String get loginPasswordHint => '••••••';

  @override
  String get loginForgotPassword => 'パスワードをお忘れですか？';

  @override
  String get loginSubmit => 'ログイン';

  @override
  String get loginSubmitLoading => 'ログイン中...';

  @override
  String get loginGuest => 'ゲストとして利用';

  @override
  String get loginOr => 'または';

  @override
  String get loginEmailRequired => 'メールアドレスを入力してください';

  @override
  String get loginEmailInvalid => '有効なメールアドレスを入力してください';

  @override
  String get loginPasswordRequired => 'パスワードを入力してください';

  @override
  String get registerStepEmail => 'メール';

  @override
  String get registerStepCode => '認証コード';

  @override
  String get registerStepData => '情報入力';

  @override
  String get registerSendCodeInfo => 'ご入力いただいたメールアドレスに認証コードを送信します';

  @override
  String get registerSendCode => '認証コードを送信';

  @override
  String get registerVerifying => '確認中...';

  @override
  String get registerCodeSentTo => '送信先:';

  @override
  String get registerResendCode => 'コードを再送信';

  @override
  String get registerBack => '戻る';

  @override
  String get registerVerifyCode => 'コードを確認';

  @override
  String get registerCodeIncomplete => '6桁のコードをすべて入力してください';

  @override
  String get registerFullNameLabel => '氏名';

  @override
  String get registerFullNameHint => 'お名前を入力';

  @override
  String get registerPasswordHint => '8文字以上、大文字と数字を各1文字以上';

  @override
  String get registerConfirmLabel => 'パスワード（確認）';

  @override
  String get registerConfirmHint => 'パスワードを再入力';

  @override
  String get registerSubmit => 'アカウントを作成';

  @override
  String get registerSubmitLoading => 'アカウント作成中...';

  @override
  String get registerSuccess => 'アカウントが作成されました';

  @override
  String get registerNameRequired => '氏名を入力してください';

  @override
  String get registerNameMinLength => '氏名は6文字以上で入力してください';

  @override
  String get registerPasswordMinLength => 'パスワードは8文字以上で入力してください';

  @override
  String get registerPasswordUppercase => '大文字を1文字以上含めてください';

  @override
  String get registerPasswordNumber => '数字を1文字以上含めてください';

  @override
  String get registerConfirmRequired => '確認用パスワードを入力してください';

  @override
  String get registerConfirmMismatch => 'パスワードが一致しません';

  @override
  String get networkError => '通信エラーが発生しました。再試行してください';

  @override
  String homeGreeting(String name) {
    return 'こんにちは、$nameさん！';
  }

  @override
  String get homeSubtitle => '今日は何を学びますか？';

  @override
  String get homeSearchHint => '講座やスキルを検索...';

  @override
  String get homeSectionContinue => '学習を再開する';

  @override
  String get homeSectionRecommended => 'あなたへのおすすめ';

  @override
  String get homeSectionPopular => '人気の講座';

  @override
  String get homeSectionTopRated => '最高評価';

  @override
  String get homeSectionByCategory => 'カテゴリ別';

  @override
  String get homeHeroTitle => '特別セール開催中';

  @override
  String get homeHeroSubtitle => '人気講座が最大70%OFF';

  @override
  String get homeHeroButton => '今すぐチェック';

  @override
  String get homeViewAll => 'すべて見る';

  @override
  String get homeProgressLabel => '完了';

  @override
  String get exploreTitle => '講座を探す';

  @override
  String get exploreSearchHint => '講座、スキル、講師名で検索...';

  @override
  String get exploreAllCategories => 'すべてのカテゴリ';

  @override
  String get exploreFilter => '絞り込み';

  @override
  String get exploreSort => '並び替え';

  @override
  String get exploreNoResults => '講座が見つかりません';

  @override
  String get exploreNoResultsHint => '別のキーワードで検索するか、条件を変更してください';

  @override
  String exploreCoursesCount(int count) {
    return '$countコース';
  }

  @override
  String get exploreFilterTitle => '条件で絞り込む';

  @override
  String get exploreFilterApply => '適用する';

  @override
  String get exploreFilterReset => 'リセット';

  @override
  String get exploreFilterPrice => '価格';

  @override
  String get exploreFilterLevel => 'レベル';

  @override
  String get exploreFilterRating => '評価';

  @override
  String get exploreFilterDuration => '講座時間';

  @override
  String get exploreSortTitle => '並び替え';

  @override
  String get exploreSortRelevance => 'おすすめ順';

  @override
  String get exploreSortNewest => '新着順';

  @override
  String get exploreSortPopular => '人気順';

  @override
  String get exploreSortRating => '評価の高い順';

  @override
  String get exploreSortPriceLow => '価格の安い順';

  @override
  String get exploreSortPriceHigh => '価格の高い順';

  @override
  String get explorePriceFree => '無料';

  @override
  String get exploreLevelBeginner => '初級';

  @override
  String get exploreLevelIntermediate => '中級';

  @override
  String get exploreLevelAdvanced => '上級';

  @override
  String get learningTitle => 'マイラーニング';

  @override
  String get learningTabInProgress => '受講中';

  @override
  String get learningTabCompleted => '修了済み';

  @override
  String get learningTabSaved => 'お気に入り';

  @override
  String get learningEmpty => '受講中の講座はありません';

  @override
  String get learningEmptyHint => '新しい講座を探してみましょう';

  @override
  String get learningExploreButton => '講座を探す';

  @override
  String learningProgress(int percent) {
    return '進捗率 $percent%';
  }

  @override
  String get learningContinue => '続ける';

  @override
  String get learningViewCertificate => '修了証を見る';

  @override
  String get learningReview => 'レビューを書く';

  @override
  String get learningLesson => 'レッスン';

  @override
  String get learningLessons => 'レッスン';

  @override
  String get cartTitle => 'カート';

  @override
  String get cartEmpty => 'カートは空です';

  @override
  String get cartEmptyHint => '興味のある講座を追加してみましょう';

  @override
  String get cartExploreButton => '講座を探す';

  @override
  String get cartPromoPlaceholder => 'クーポンコード';

  @override
  String get cartPromoApply => '適用';

  @override
  String get cartPromoInvalid => '無効なクーポンコードです';

  @override
  String get cartSummary => '注文内容';

  @override
  String get cartSubtotal => '小計';

  @override
  String get cartDiscount => '割引額';

  @override
  String get cartTotal => '合計金額';

  @override
  String get cartCheckout => '購入手続きへ';

  @override
  String cartCourses(int count) {
    return '$countコース';
  }

  @override
  String get cartRemove => '削除';

  @override
  String get cartGuarantee => '30日間返金保証付き';

  @override
  String get checkoutTitle => 'お支払い';

  @override
  String get checkoutStepPayment => 'お支払い';

  @override
  String get checkoutStepReview => '確認';

  @override
  String get checkoutStepConfirm => '完了';

  @override
  String get checkoutOrderSummary => 'ご注文内容';

  @override
  String get checkoutTotal => '合計';

  @override
  String get checkoutPayNow => '今すぐ支払う';

  @override
  String get checkoutBack => '戻る';

  @override
  String get checkoutNext => '次へ';

  @override
  String get checkoutSecureSSL => '256ビットSSL暗号化通信で保護されています';

  @override
  String get checkoutSuccessTitle => 'ご購入ありがとうございます！';

  @override
  String get checkoutSuccessSubtitle => '今すぐ講座を受講できます';

  @override
  String get checkoutGoToLearning => 'マイ講座へ';

  @override
  String get checkoutPaymentMethod => 'お支払い方法';

  @override
  String get checkoutCardNumber => 'カード番号';

  @override
  String get checkoutCardName => 'カード名義人';

  @override
  String get checkoutCardExpiry => '有効期限';

  @override
  String get checkoutCardCVV => 'セキュリティコード';

  @override
  String get courseDetailsEnroll => '今すぐ受講する';

  @override
  String get courseDetailsBuyNow => '今すぐ購入';

  @override
  String get courseDetailsAddToCart => 'カートに追加';

  @override
  String get courseDetailsAddedToCart => 'カートに追加しました';

  @override
  String get courseDetailsAlreadyEnrolled => '受講中';

  @override
  String get courseDetailsGoToCourse => '講座へ進む';

  @override
  String get courseDetailsFree => '無料講座';

  @override
  String courseDetailsStudents(String count) {
    return '$count人の受講生';
  }

  @override
  String get courseDetailsRating => '評価';

  @override
  String get courseDetailsReviews => '件の評価';

  @override
  String get courseDetailsLastUpdated => '最終更新日';

  @override
  String get courseDetailsCurriculum => '講座カリキュラム';

  @override
  String get courseDetailsSection => 'セクション';

  @override
  String get courseDetailsLessons => 'レッスン';

  @override
  String get courseDetailsInstructor => '講師';

  @override
  String get courseDetailsStudentsLabel => '受講生';

  @override
  String get courseDetailsCoursesLabel => '講座数';

  @override
  String get courseDetailsReviewsLabel => 'レビュー';

  @override
  String get courseDetailsReviewsTitle => '受講生からのレビュー';

  @override
  String get courseDetailsWhatLearn => '学べる内容';

  @override
  String get courseDetailsRequirements => '受講条件・前提知識';

  @override
  String get courseDetailsDescription => '講座概要';

  @override
  String get courseDetailsIncludesTitle => 'この講座に含まれるもの';

  @override
  String get courseDetailsHoursVideo => '時間のオンデマンド動画';

  @override
  String get courseDetailsArticles => '件の記事・教材';

  @override
  String get courseDetailsMobileAccess => 'スマホ・タブレット対応';

  @override
  String get courseDetailsCertificate => '修了証発行';

  @override
  String get courseDetailsLifetimeAccess => '無期限アクセス権';

  @override
  String get lessonPlayerNotes => 'ノート';

  @override
  String get lessonPlayerResources => '参考資料';

  @override
  String get lessonPlayerDiscussion => 'Q&A・ディスカッション';

  @override
  String get lessonPlayerPrev => '前のレッスン';

  @override
  String get lessonPlayerNext => '次のレッスン';

  @override
  String get lessonPlayerSpeed => '再生速度';

  @override
  String get lessonPlayerQuality => '画質';

  @override
  String get lessonPlayerCompleted => 'レッスン完了';

  @override
  String get certificateTitle => '修了証書';

  @override
  String get certificatePresentedTo => '授与対象者';

  @override
  String get certificateCompletedCourse => '修了認定講座名：';

  @override
  String get certificateIssuedOn => '発行日';

  @override
  String get certificateVerificationId => '認定番号';

  @override
  String get certificateDownloadPDF => 'PDFをダウンロード';

  @override
  String get certificateDownloadPNG => '画像を保存';

  @override
  String get certificateCopyLink => 'リンクをコピー';

  @override
  String get certificateLinkCopied => 'リンクをコピーしました';

  @override
  String get profileTitle => 'マイページ';

  @override
  String get profileEditProfile => 'プロフィール編集';

  @override
  String get profileCourses => '受講中の講座';

  @override
  String get profileCertificates => '修了証';

  @override
  String get profilePoints => 'ポイント';

  @override
  String get profileFollowers => 'フォロワー';

  @override
  String get profileFollowing => 'フォロー中';

  @override
  String get profileBio => '自己紹介';

  @override
  String get profileInstructor => '認定講師';

  @override
  String get profileStudent => '受講生';

  @override
  String get profileLevel => 'レベル';

  @override
  String get profileJoined => '登録日';

  @override
  String get profileShareProfile => 'プロフィールを共有';

  @override
  String get profileMenuLearning => '受講中の講座';

  @override
  String get profileMenuCertificates => '獲得した修了証';

  @override
  String get profileMenuPurchaseHistory => '購入履歴';

  @override
  String get profileMenuTeachApplication => '講師として教える';

  @override
  String get profileMenuAccountSecurity => 'セキュリティ';

  @override
  String get profileMenuNotifications => 'お知らせ';

  @override
  String get profileMenuMessages => 'メッセージ';

  @override
  String get profileMenuSettings => '設定';

  @override
  String get profileMenuSchedule => '学習スケジュール';

  @override
  String get profileMenuAssignments => '課題・レポート';

  @override
  String get profileMenuQuiz => '小テスト';

  @override
  String get profileMenuLogout => 'ログアウト';

  @override
  String get profileLogoutConfirm => 'ログアウトしてもよろしいですか？';

  @override
  String get profileLogoutYes => 'ログアウト';

  @override
  String get profileLogoutNo => 'キャンセル';

  @override
  String get editProfileTitle => 'プロフィール編集';

  @override
  String get editProfileSave => '保存する';

  @override
  String get editProfileFullName => '氏名';

  @override
  String get editProfileBio => '自己紹介';

  @override
  String get editProfileEmail => 'メールアドレス';

  @override
  String get editProfilePhone => '電話番号';

  @override
  String get editProfileWebsite => 'Webサイト';

  @override
  String get editProfileSaved => 'プロフィールを更新しました';

  @override
  String get accountSecurityTitle => 'セキュリティ設定';

  @override
  String get accountSecurityChangePassword => 'パスワード変更';

  @override
  String get accountSecurityTwoFactor => '2段階認証';

  @override
  String get accountSecurityActiveSessions => 'ログイン中の端末';

  @override
  String get accountSecurityDeleteAccount => 'アカウントの削除';

  @override
  String get purchaseHistoryTitle => '購入履歴';

  @override
  String get purchaseHistoryEmpty => '購入履歴はありません';

  @override
  String get purchaseHistoryGuarantee => '30日間全額返金保証';

  @override
  String get purchaseHistoryDate => '取引日';

  @override
  String get purchaseHistoryStatus => 'ステータス';

  @override
  String get purchaseHistoryAmount => '金額';

  @override
  String get purchaseHistoryCompleted => '決済完了';

  @override
  String get purchaseHistoryRefunded => '返金済み';

  @override
  String get teachApplicationTitle => '講師応募';

  @override
  String get teachApplicationSubmit => '応募する';

  @override
  String get teachApplicationSent => 'ご応募ありがとうございます。審査を開始いたします';

  @override
  String get notificationsTitle => 'お知らせ一覧';

  @override
  String get notificationsMarkAllRead => 'すべて既読にする';

  @override
  String get notificationsMarkAllReadSnackbar => 'すべてのお知らせを既読にしました';

  @override
  String get notificationsEmpty => '新しいお知らせはありません';

  @override
  String get notification1Title => '学習のリマインダー';

  @override
  String get notification1Message => '「初心者向けFlutter」の新しいレッスンが利用可能です';

  @override
  String get notification1Time => '5分前';

  @override
  String get notification1Action => '学習を続ける';

  @override
  String get notification2Title => '修了証が発行されました！';

  @override
  String get notification2Message => 'UI/UXデザイン講座の全レッスンを修了しました。';

  @override
  String get notification2Time => '2時間前';

  @override
  String get notification2Action => '修了証を見る';

  @override
  String get notification3Title => '特別割引クーポン配布中';

  @override
  String get notification3Message => 'プログラミング講座が最大70%OFF';

  @override
  String get notification3Time => '1日前';

  @override
  String get notification3Action => 'クーポンを見る';

  @override
  String get notification4Title => '質問への回答が届きました';

  @override
  String get notification4Message => '講師があなたの質問に回答しました';

  @override
  String get notification4Time => '2日前';

  @override
  String get notification4Action => '回答を確認';

  @override
  String get notification5Title => '講座アップデートのお知らせ';

  @override
  String get notification5Message => 'Python講座に新しい実践演習が追加されました';

  @override
  String get notification5Time => '3日前';

  @override
  String get messagesTitle => 'メッセージ';

  @override
  String get settingsTitle => 'アプリ設定';

  @override
  String get settingsVideoDownload => '動画とダウンロード';

  @override
  String get settingsDownloadQuality => 'デフォルト画質';

  @override
  String get settingsWifiOnly => 'Wi-Fi接続時のみダウンロード';

  @override
  String get settingsNotifications => '通知とアラート';

  @override
  String get settingsCourseNotifications => '講座更新・メッセージ通知';

  @override
  String get settingsPromoNotifications => '限定セール・お得情報通知';

  @override
  String get settingsAppearance => '外観と言語';

  @override
  String get settingsDarkMode => 'ダークモード';

  @override
  String get settingsDarkModeEnabled => 'オン（バッテリー節約）';

  @override
  String get settingsDarkModeDisabled => 'オフ（ライトモード）';

  @override
  String get settingsLanguage => '表示言語';

  @override
  String get settingsStorage => 'ストレージとキャッシュ';

  @override
  String get settingsClearCache => 'キャッシュを削除';

  @override
  String get settingsClearCacheSuccess => 'キャッシュを削除しました';

  @override
  String get settingsHelp => 'サポート・規約';

  @override
  String get settingsHelpCenter => 'ヘルプセンター・よくある質問';

  @override
  String get settingsTermsPrivacy => '利用規約とプライバシー';

  @override
  String get settingsAbout => 'EduLabについて';

  @override
  String get settingsVersion => 'バージョン v1.0.0';

  @override
  String get quizTitle => '確認テスト';

  @override
  String get quizNext => '次の問題';

  @override
  String get quizSubmit => 'テストを提出';

  @override
  String get quizScore => 'テスト結果';

  @override
  String get quizCorrectAnswers => '正解数';

  @override
  String get scheduleTitle => '学習スケジュール';

  @override
  String get scheduleEmpty => '予定されたセッションはありません';

  @override
  String get scheduleJoin => '参加する';

  @override
  String get scheduleReminder => 'リマインダー';

  @override
  String get assignmentsTitle => '課題一覧';

  @override
  String get assignmentsEmpty => '提出が必要な課題はありません';

  @override
  String get assignmentsSubmit => '課題を提出';

  @override
  String get assignmentsDue => '提出期限';

  @override
  String get assignmentsSubmitted => '提出済み';

  @override
  String get assignmentsPending => '採点待ち';

  @override
  String get languageArabic => 'アラビア語';

  @override
  String get languageEnglish => '英語';

  @override
  String get languageDialogTitle => '言語を選択';

  @override
  String get languageSelect => '決定';

  @override
  String get generalCancel => 'キャンセル';

  @override
  String get generalConfirm => '確定';

  @override
  String get generalSave => '保存';

  @override
  String get generalDelete => '削除';

  @override
  String get generalEdit => '編集';

  @override
  String get generalClose => '閉じる';

  @override
  String get generalBack => '戻る';

  @override
  String get generalDone => '完了';

  @override
  String get generalOk => 'OK';

  @override
  String get generalYes => 'はい';

  @override
  String get generalNo => 'いいえ';

  @override
  String get generalLoading => '読み込み中...';

  @override
  String get generalError => 'エラーが発生しました';

  @override
  String get generalRetry => '再試行';

  @override
  String get generalNoInternet => 'インターネットに接続されていません';

  @override
  String get generalFree => '無料';

  @override
  String get generalRating => '評価';

  @override
  String get generalStudents => '受講生';

  @override
  String get generalHours => '時間';

  @override
  String get generalMinutes => '分';

  @override
  String get generalBy => '講師:';

  @override
  String get navHome => 'ホーム';

  @override
  String get navExplore => '見つける';

  @override
  String get navMyCourses => 'マイ講座';

  @override
  String get navCart => 'カート';

  @override
  String get navAccount => 'アカウント';

  @override
  String get homeSubGreeting => '今日学びたいスキルは何ですか？';

  @override
  String get homeVisitor => 'ゲスト';

  @override
  String get homePromoTitle => '特別セール開催中';

  @override
  String get homePromoSubtitle => '人気講座が最大70%OFF';

  @override
  String get homePromoButton => '今すぐチェック';

  @override
  String get homePromoBadge => '期間限定';

  @override
  String get homeContinueLearning => '学習を再開';

  @override
  String get homeMyCoursesLink => '受講講座';

  @override
  String get homeLesson => 'レッスン';

  @override
  String homeStudentsCount(String count) {
    return '$count人の受講生';
  }

  @override
  String get homeRecommendedTitle => 'あなたへのおすすめ';

  @override
  String get homeRecommendedSubtitle => 'あなたの興味に合わせた講座';

  @override
  String get homeBestsellersTitle => 'ベストセラー';

  @override
  String get homeBestsellersSubtitle => '高評価で大人気の講座';

  @override
  String get homeNewCoursesTitle => '新着講座';

  @override
  String get homeNewCoursesSubtitle => '最新のトレンド講座';

  @override
  String get homePopularTopicsTitle => '注目のトピック';

  @override
  String get homePopularTopicsSubtitle => '今最も求められているスキルを習得';

  @override
  String get homeTopInstructorsTitle => 'トップ講師陣';

  @override
  String get homeTopInstructorsSubtitle => '各分野の専門家から直接学ぶ';

  @override
  String get homeExploreCategoriesTitle => 'カテゴリから探す';

  @override
  String get homeExploreCategoriesSubtitle => 'あなたに最適な講座が見つかる';

  @override
  String get catAll => 'すべて';

  @override
  String get catWebDev => 'Web開発';

  @override
  String get catMobileApps => 'モバイルアプリ';

  @override
  String get catDataScience => 'データサイエンス';

  @override
  String get catUIUX => 'UI/UXデザイン';

  @override
  String get catBusiness => 'ビジネス・経営';

  @override
  String get catAI => '人工知能 (AI)';

  @override
  String get catCyberSecurity => 'サイバーセキュリティ';

  @override
  String get exploreNoResultsTitle => '講座が見つかりません';

  @override
  String get exploreNoResultsSubtitle => '別のキーワードで検索するか、条件を変更してください';

  @override
  String get exploreRecentSearches => '最近の検索';

  @override
  String get exploreTopSearches => '急上昇ワード';

  @override
  String get exploreBrowseCategories => 'カテゴリ一覧';

  @override
  String get exploreBrowseCategoriesSubtitle => '最適な講座を見つける';

  @override
  String get exploreBackToAll => 'すべてに戻る';

  @override
  String get exploreClearAll => 'クリア';

  @override
  String get exploreAvailableResults => '件の講座が見つかりました';

  @override
  String get exploreFilterBestseller => 'ベストセラー';

  @override
  String get exploreFilterTopRated => '高評価';

  @override
  String get exploreFilterUnder50 => '¥5,000以下';

  @override
  String get learningHeroTitle => 'スキルアップを続けましょう';

  @override
  String get learningSearchHint => '受講中の講座を検索...';

  @override
  String get learningFilterAll => 'すべて';

  @override
  String get learningFilterInProgress => '受講中';

  @override
  String get learningFilterCompleted => '修了済み';

  @override
  String get learningFilterDownloaded => 'ダウンロード済み';

  @override
  String get learningEmptyTitle => '受講中の講座はありません';

  @override
  String get learningEmptySubtitle => '新しい講座を探してみましょう';

  @override
  String get learningEmptySearch => '該当する講座がありません';

  @override
  String get learningCompleted => '修了';

  @override
  String get learningCompletedBadge => '修了';

  @override
  String learningLecturesCount(int count) {
    return '$countレッスン';
  }

  @override
  String get cartEmptyTitle => 'カートは空です';

  @override
  String get cartEmptySubtitle => '興味のある講座を追加してみましょう';

  @override
  String get cartCouponHint => 'クーポンを入力';

  @override
  String get cartCouponApply => '適用';

  @override
  String get cartCouponInvalid => '無効なコード';

  @override
  String get cartCouponApplied => 'クーポンが適用されました';

  @override
  String get cartCouponDiscount => 'クーポン割引';

  @override
  String get cartCouponsTitle => 'クーポン一覧';

  @override
  String get cartOrderSummary => '注文内容の確認';

  @override
  String get cartOriginalPrice => '通常価格';

  @override
  String get cartPlatformDiscount => '特別割引';

  @override
  String get cartFinalTotal => 'お支払い総額';

  @override
  String cartItemsCount(int count) {
    return '$countコース';
  }

  @override
  String get cartRemovedSnackbar => 'カートから削除しました';

  @override
  String get cartUndo => '元に戻す';

  @override
  String get cartAddButton => 'カートに入れる';

  @override
  String get cartAddedSnackbar => 'カートに追加しました';

  @override
  String get cartAlreadyInCart => 'カートに追加済み';

  @override
  String get cartCheckoutButton => 'ご注文手続きへ';

  @override
  String get cartRecommendedTitle => 'おすすめの関連講座';

  @override
  String get cartRecommendedSubtitle => 'カート内容に合わせたおすすめ講座';

  @override
  String get checkoutCreditCard => 'クレジットカード';

  @override
  String get checkoutSelectPayment => 'お支払い方法を選択';

  @override
  String get checkoutCardNumberLabel => 'カード番号';

  @override
  String get checkoutCardHolderLabel => 'カード名義人氏名';

  @override
  String get checkoutExpiryLabel => '有効期限 (MM/YY)';

  @override
  String get checkoutCVVLabel => 'CVV番号';

  @override
  String get checkoutPersonalInfoTitle => 'お客様情報';

  @override
  String get checkoutFullNameLabel => 'お名前';

  @override
  String get checkoutFullNameHint => '氏名を入力';

  @override
  String get checkoutFullNameRequired => '氏名を入力してください';

  @override
  String get checkoutPhoneLabel => '電話番号';

  @override
  String get checkoutPhoneRequired => '電話番号を入力してください';

  @override
  String get checkoutPostalLabel => '郵便番号';

  @override
  String get checkoutPostalRequired => '郵便番号を入力してください';

  @override
  String get checkoutBuyerInfo => 'ご購入者情報';

  @override
  String get checkoutSaveInfo => '次回のために情報を保存する';

  @override
  String get checkoutMoneyBackGuarantee => '30日間全額返金保証';

  @override
  String get checkoutContinueToPayment => 'お支払いへ進む';

  @override
  String get checkoutContinueToReview => '注文内容の確認へ';

  @override
  String get checkoutReviewConfirm => '確認して決済';

  @override
  String get checkoutStartLearning => '学習を始める';

  @override
  String get checkoutBackHome => 'ホームに戻る';

  @override
  String get courseDetailsTitle => '講座詳細';

  @override
  String get courseDetailsShare => '共有';

  @override
  String get courseDetailsWhatYouWillLearn => '学べる内容';

  @override
  String get courseDetailsLanguage => '言語';

  @override
  String get courseDetailsCreatedBy => '講師名';

  @override
  String get courseDetailsPreviewLesson => 'プレビューを再生';

  @override
  String get courseDetailsHoursOnDemand => '時間のオンデマンド動画';

  @override
  String get courseDetailsFullLifetimeAccess => '無制限の永久アクセス権';

  @override
  String get courseDetailsCertifiedCertificate => '公式認定修了証';

  @override
  String get courseDetailsComprehensiveContent => '充実した講座カリキュラム';

  @override
  String get certTitle => '修了証書';

  @override
  String get certStudentNameLabel => '氏名';

  @override
  String get certCourseLabel => '講座名';

  @override
  String get certInstructorLabel => '担当講師';

  @override
  String get certIssueDateLabel => '発行年月日';

  @override
  String get certCodeLabel => '修了証ID';

  @override
  String get certVerifiedBadge => '公式認定';

  @override
  String get certDownloadPDF => 'PDF形式で保存';

  @override
  String get certDownloadPNG => '画像形式で保存';

  @override
  String get certCopyVerifyLink => '認証リンクをコピー';

  @override
  String get certShare => '修了証を共有';

  @override
  String get playerTabLessons => 'レッスン一覧';

  @override
  String get playerTabOverview => '概要';

  @override
  String get playerTabNotes => 'ノート';

  @override
  String get playerTabQnA => '質問と回答';

  @override
  String get playerNextLesson => '次のレッスン';

  @override
  String get profileWelcome => 'ようこそ';

  @override
  String get profileLoginPrompt => 'ログインして学習を管理しましょう';

  @override
  String get profileLoginOrRegister => 'ログイン / 新規登録';

  @override
  String get profileVerifiedStudent => '認定受講生';

  @override
  String get profileLogout => 'ログアウト';

  @override
  String get profileCancel => 'キャンセル';

  @override
  String get profileLogoutConfirmTitle => 'ログアウトの確認';

  @override
  String get profileLogoutConfirmMessage => '本当にログアウトしますか？';

  @override
  String get profileAccountSettings => 'アカウント設定';

  @override
  String get profileEditProfileSubtitle => 'プロフィール情報の変更';

  @override
  String get profileSecurity => 'アカウントセキュリティ';

  @override
  String get profileSecuritySubtitle => 'パスワード・2段階認証';

  @override
  String get profilePurchaseHistory => '購入履歴・領収書';

  @override
  String get profilePurchaseHistorySubtitle => '過去の決済履歴の確認';

  @override
  String get profileCertificatesSubtitle => '取得した修了証の一覧';

  @override
  String get profileTeach => 'EduLabで教える';

  @override
  String get profileTeachSubtitle => '知識とスキルを共有して収入を得る';

  @override
  String get profilePreferences => '環境設定';

  @override
  String get profilePreferencesSubtitle => 'テーマや言語の変更';

  @override
  String get profileNotifications => '通知設定';

  @override
  String get profileNotificationsSubtitle => 'プッシュ通知・メール設定';

  @override
  String get profileHelpSupport => 'ヘルプとサポート';

  @override
  String get profileTerms => '利用規約';

  @override
  String get profilePrivacy => 'プライバシーポリシー';

  @override
  String get profileAboutEduLab => 'EduLabについて';

  @override
  String get profileWishlist => 'お気に入りリスト';

  @override
  String get securityTitle => 'セキュリティ設定';

  @override
  String get teachTitle => '講師応募';

  @override
  String get notificationsTabAll => 'すべて';

  @override
  String get notificationsTabCourses => '講座更新';

  @override
  String get notificationsTabPromos => 'セール情報';

  @override
  String get notificationsEmptyTitle => 'お知らせはありません';

  @override
  String get notificationsUnread => '件の未読';

  @override
  String get wishlistTitle => 'お気に入り';

  @override
  String get wishlistEmptyTitle => 'お気に入りは空です';

  @override
  String get wishlistEmptySubtitle => '気になる講座を保存して後で見返しましょう';

  @override
  String get wishlistAddToCart => 'カートに入れる';

  @override
  String get wishlistRemovedSnackbar => 'お気に入りから削除しました';

  @override
  String get homeDefaultUser => '受講生';

  @override
  String get learningOf => '/';

  @override
  String get cartInCartBadge => 'カート内';

  @override
  String get homePromo1Badge => '期間限定 • ビッグセール';

  @override
  String get homePromo1Title => 'お得な価格で学習を始めよう';

  @override
  String get homePromo1Subtitle => 'プログラミング、デザイン、ビジネス講座が最大65%OFF。';

  @override
  String get homePromo1Button => 'セールを見る';

  @override
  String get homePromo2Badge => '認定キャリアパス';

  @override
  String get homePromo2Title => '理想のキャリアに向けて準備しよう';

  @override
  String get homePromo2Subtitle => '実践プロジェクトと修了証付きの本格的な体系的カリキュラム。';

  @override
  String get homePromo2Button => 'パスを探す';

  @override
  String get homePromo3Badge => '一流の講師陣・専門家';

  @override
  String get homePromo3Title => '業界のプロフェッショナルから直接学ぶ';

  @override
  String get homePromo3Subtitle => '最新技術に対応した常にアップデートされる高品質コンテンツ。';

  @override
  String get homePromo3Button => '今すぐ開始';

  @override
  String get homeSearchFilter => '絞り込み';

  @override
  String get securitySectionChangePassword => 'パスワード変更';

  @override
  String get securityCurrentPasswordLabel => '現在のパスワード *';

  @override
  String get securityCurrentPasswordError => '現在のパスワードを入力してください';

  @override
  String get securityNewPasswordLabel => '新しいパスワード *';

  @override
  String get securityNewPasswordError => '8文字以上で入力してください';

  @override
  String get securityConfirmPasswordLabel => '新しいパスワード（確認）*';

  @override
  String get securityConfirmPasswordError => 'パスワードが一致しません';

  @override
  String get securityUpdatePasswordBtn => 'パスワードを更新';

  @override
  String get securityPasswordUpdatedSuccess => 'パスワードが正常に変更されました！';

  @override
  String get securitySection2FA => '2要素認証 (2FA)';

  @override
  String get security2FATitle => '2要素認証';

  @override
  String get security2FAEnabledDesc => '有効 - 認証コードでアカウントを保護';

  @override
  String get security2FADisabledDesc => '無効（有効化を推奨）';

  @override
  String get security2FASetupTitle => '2要素認証を有効化';

  @override
  String get security2FASetupContent =>
      '新しいログインのたびに、登録されたメールアドレスに6桁の確認コードが送信されます。';

  @override
  String get security2FAEnableNow => '今すぐ有効化';

  @override
  String get security2FAEnabledSuccess => '2要素認証が有効化されました！';

  @override
  String get security2FADisabledSuccess => '2要素認証が無効化されました';

  @override
  String get securitySectionSessions => 'アクティブなセッションと端末';

  @override
  String get securityLogoutAllDevices => 'すべての端末からログアウト';

  @override
  String get securityThisDevice => 'この端末';

  @override
  String get securitySessionRevokedSuccess => 'セッションを終了しログアウトしました。';

  @override
  String get securityAllSessionsRevokedSuccess => '他のすべての端末からログアウトしました。';

  @override
  String get purchaseHistoryInvoiceCertified => '認証済み電子領収書';

  @override
  String get purchaseHistoryInvoiceNumber => '領収書番号';

  @override
  String get purchaseHistoryCourse => 'コース';

  @override
  String get purchaseHistoryPaymentMethod => 'お支払い方法';

  @override
  String get purchaseHistoryTotalAmount => '合計金額：';

  @override
  String get purchaseHistoryClose => '閉じる';

  @override
  String get purchaseHistoryDownloadPdf => 'PDFをダウンロード';

  @override
  String get purchaseHistoryPdfDownloaded => '領収書PDFが正常にダウンロードされました';

  @override
  String get purchaseHistoryRefundRequestTitle => '返金リクエスト';

  @override
  String get purchaseHistoryRefundPolicy =>
      'EduLabの30日間返金保証に基づき、全額返金を受けることができます。';

  @override
  String get purchaseHistoryRefundReasonHint => '返金理由（任意）...';

  @override
  String get purchaseHistoryConfirmRefund => '返金を確定';

  @override
  String get purchaseHistoryRefundSubmitted => '返金申請が送信されました（3〜5営業日以内）。';

  @override
  String get purchaseHistoryInstructor => '講師';

  @override
  String get purchaseHistoryRequestRefundBtn => '返金申請';

  @override
  String get purchaseHistoryInvoiceBtn => '領収書';

  @override
  String get purchaseHistoryStatusCompleted => '完了';

  @override
  String get purchaseHistoryStatusRefunded => '返金済み';

  @override
  String get purchaseHistoryStatusProcessingRefund => '返金処理中';

  @override
  String get editProfileSectionBasicInfo => '基本情報';

  @override
  String get editProfileFullNameLabel => '氏名 *';

  @override
  String get editProfileFullNameHint => '氏名を入力してください';

  @override
  String get editProfileFullNameError => '氏名を正確に入力してください';

  @override
  String get editProfileHeadlineLabel => '肩書・専門分野';

  @override
  String get editProfileHeadlineHint => '例：シニアFlutterエンジニア';

  @override
  String get editProfileLocationLabel => '都市 / 国';

  @override
  String get editProfileLocationHint => '東京都、日本';

  @override
  String get editProfilePhoneLabel => '携帯電話番号';

  @override
  String get editProfileBioLabel => '自己紹介 (Bio)';

  @override
  String get editProfileBioHint => '専門知識や経歴について簡単に記入してください...';

  @override
  String get editProfileSectionLinks => 'リンクとSNS';

  @override
  String get editProfileWebsiteLabel => '個人ウェブサイト';

  @override
  String get editProfileSectionEmail => '登録メールアドレス';

  @override
  String get editProfileEmailDesc => 'ログインおよび修了証の受け取りに使用されます';

  @override
  String get editProfileEmailVerified => '認証済み';

  @override
  String get editProfileSaveChangesBtn => '変更を保存';

  @override
  String get editProfileSavedSuccess => 'プロフィールが正常に更新されました！';

  @override
  String get editProfileChangeAvatarTitle => 'プロフィール写真を変更';

  @override
  String get editProfileTakePhoto => 'カメラで撮影';

  @override
  String get editProfileChooseGallery => 'ギャラリーから選択';

  @override
  String get editProfilePhotoUpdatedSuccess => 'プロフィール写真が更新されました';

  @override
  String get teachJoinInstructorTitle => '認定講師として登録';

  @override
  String get teachJoinInstructorSubtitle => 'コースを公開し、世界中の多くの受講生と知識を共有しましょう。';

  @override
  String get teachStep1Title => '基本情報';

  @override
  String get teachStep2Title => '経歴とスキル';

  @override
  String get teachStep3Title => '申請確認';

  @override
  String get teachStep1Header => '1. 個人および職歴情報';

  @override
  String get teachFullNameArabicLabel => '氏名 *';

  @override
  String get teachFullNameArabicHint => '例：山田 太郎';

  @override
  String get teachHeadlineLabel => '職種・専門分野 *';

  @override
  String get teachHeadlineHint => '例：シニアソフトウェアエンジニア / Flutter講師';

  @override
  String get teachPhoneLabel => '電話番号 *';

  @override
  String get teachCountryLabel => '居住国 *';

  @override
  String get teachBioLabel => '経歴と実績 *';

  @override
  String get teachBioHint => 'これまでのキャリアや実績について簡単に記入してください...';

  @override
  String get teachNextStepSkills => '次へ：経歴とスキル';

  @override
  String get teachStep2Header => '2. コース内容とスキル';

  @override
  String get teachTopicLabel => '提案するコースのテーマ *';

  @override
  String get teachTopicHint => '例：ゼロから学ぶFlutterアプリ開発';

  @override
  String get teachYearsExperienceLabel => '関連分野の経験年数 *';

  @override
  String get teachVideoLinkLabel => 'サンプル講義動画リンク (YouTube/Drive/Loom) *';

  @override
  String get teachTargetAudienceLabel => 'コースの対象受講者 *';

  @override
  String get teachAudienceBeginners => '完全な初心者';

  @override
  String get teachAudienceIntermediate => '初級・中級者';

  @override
  String get teachAudienceAdvanced => '上級者・プロフェッショナル';

  @override
  String get teachAudienceAll => '全レベル対象';

  @override
  String get teachSkillsCoveredLabel => 'コースで扱うスキル・技術 *';

  @override
  String get teachAddSkillHint => 'スキルを追加（例：GraphQL）...';

  @override
  String get teachAddSkillBtn => '追加';

  @override
  String get teachNextStepConfirm => '次へ：申請内容の確認';

  @override
  String get teachStep3Header => '3. 収益受け取りと利用規約';

  @override
  String get teachPayoutMethodLabel => '収益の受取方法 *';

  @override
  String get teachPayoutMethodBank => '銀行振込 (IBAN)';

  @override
  String get teachPayoutMethodPaypal => '認証済みPayPalアカウント';

  @override
  String get teachPayoutMethodPayoneer => 'Payoneerカード';

  @override
  String get teachIbanDetailsLabel => '口座情報 / IBAN *';

  @override
  String get teachApplicationSummary => '申請内容の概要：';

  @override
  String get teachApplicantName => '申請者';

  @override
  String get teachApplicantHeadline => '専門';

  @override
  String get teachApplicantTopic => 'コーステーマ';

  @override
  String get teachApplicantSkillsCount => '登録スキル数';

  @override
  String get teachSkillsUnit => '個のスキル';

  @override
  String get teachAgreeTermsLabel => 'EduLabの講師利用規約および知的財産権に関する合意に同意します。';

  @override
  String get teachSubmitApplicationBtn => 'Submit Instructor Application';

  @override
  String get teachPrevStepBtn => '戻る';

  @override
  String get teachWhyEduLabTitle => 'EduLabで教えるメリット';

  @override
  String get teachProp1Title => '公正で高い収益還元';

  @override
  String get teachProp1Desc => '隠れた手数料なしで、コース売上の最大80％を獲得できます。';

  @override
  String get teachProp2Title => '数千人の学習者にリーチ';

  @override
  String get teachProp2Desc => '活発な学習コミュニティに向けてコースをアピールできます。';

  @override
  String get teachProp3Title => '充実した制作・技術サポート';

  @override
  String get teachProp3Desc => '音声・映像のクオリティやカリキュラム設計をサポートします。';

  @override
  String get teachSuccessDialogTitle => '申請を受け付けました！';

  @override
  String get teachSuccessDialogDesc =>
      'EduLabへのご応募ありがとうございます。担当チームが内容を確認し、48時間以内にメールにてご連絡いたします。';

  @override
  String get teachSuccessDialogOk => 'OK';

  @override
  String get teachAddOneSkillError => 'スキルを少なくとも1つ追加してください';

  @override
  String get teachAgreeTermsError => '講師規約に同意してください';

  @override
  String get commonCancel => 'キャンセル';

  @override
  String get commonClose => '閉じる';

  @override
  String get myCertificatesBannerTitle => '認定証';

  @override
  String get myCertificatesBannerSubtitle =>
      'すべての認定証はEduLabの一意のIDで認定および検証されています';

  @override
  String get certBadgeVerified100 => '100% 認定';

  @override
  String get certCodeCopied => '認定コードをコピーしました';

  @override
  String get certGrantedTo => '授与先';

  @override
  String get certViewAndDownload => '認定証の表示とダウンロード';

  @override
  String get certIssuerLabel => '発行機関';

  @override
  String get certIssuerName => 'EduLab インタラクティブ・ラーニング・アカデミー';

  @override
  String get certEmptyTitle => 'まだ認定証がありません';

  @override
  String get certEmptyDesc => '登録済みのコースを100%完了して、公式の検証ID付き認定証を取得しましょう。';

  @override
  String get certEmptyAction => 'マイコースを続ける';

  @override
  String get certDetailsTitle => '認定証の詳細と情報';

  @override
  String get certCopyLinkSuccess => '直接検証リンクをクリップボードにコピーしました！';

  @override
  String get certShareSuccess => '共有用の認定証詳細とリンクをコピーしました！';

  @override
  String get purchaseHistoryTaxInvoiceCertified => '公式認定納税請求書';

  @override
  String get purchaseHistoryInvoiceNumberLabel => '注文 / 請求書番号';

  @override
  String get purchaseHistoryCourseNameLabel => 'コース名';

  @override
  String get purchaseHistoryPurchaseDateLabel => '購入日';

  @override
  String get purchaseHistoryPaymentMethodLabel => 'お支払い方法';

  @override
  String get purchaseHistoryPaymentMethodValue => 'クレジットカード / Stripe (オンライン)';

  @override
  String get purchaseHistoryOrderStatusLabel => '注文ステータス';

  @override
  String get purchaseHistoryStatusPendingReview => '返金審査中';

  @override
  String get purchaseHistoryCopyInvoiceBtn => '請求書番号をコピー';

  @override
  String get purchaseHistoryRefundReasonLabel => '返金リクエストの理由：';

  @override
  String get purchaseHistoryRefundReasonEmptyError => '返金リクエストの理由を入力してください';

  @override
  String get purchaseHistorySubmittingRefund => 'リクエストを送信中...';

  @override
  String get purchaseHistoryPaidDate => '支払い日';

  @override
  String get purchaseHistoryEmptyTitle => '購入履歴はまだありません';

  @override
  String get purchaseHistoryEmptyDesc =>
      'まだコースを購入していません。\n完了すると注文と請求書がここに表示されます。';

  @override
  String get purchaseHistoryExploreCourses => '今すぐコースを探す';

  @override
  String get profileMyCourses => 'マイコース';

  @override
  String get profileMyCoursesSubtitle => '受講中コースの進捗を確認';

  @override
  String get profileWishlistSubtitle => 'ウィッシュリストに保存されたコース';

  @override
  String get navMyLearning => 'マイラーニング';

  @override
  String get profileLogoutSafeNote =>
      'データ、コース、修了証は安全に保管されます。再ログインすればいつでも学習を再開できます。';

  @override
  String learningRemainingHours(String hours) {
    return '残り $hours 時間';
  }

  @override
  String get learningCompletedFull => '修了済み';

  @override
  String get learningFilterNotStarted => '未開始';

  @override
  String get wishlistTopRatedBadge => '最高評価';

  @override
  String get wishlistFeaturedBadge => '注目';

  @override
  String wishlistDiscountBadge(String percent) {
    return '$percent% オフ';
  }

  @override
  String get courseFree => '無料';

  @override
  String get badgeBestseller => 'ベストセラー';

  @override
  String get badgeTopRated => '最高評価';

  @override
  String get badgeFeatured => 'おすすめ';

  @override
  String get badgeRecommended => 'あなたへのおすすめ';

  @override
  String get badgeNew => '新着';

  @override
  String get courseWord => 'コース';

  @override
  String coursesCountText(String count) {
    return '$count+ コース';
  }

  @override
  String studentsCountText(String count) {
    return '$count 人の受講生';
  }

  @override
  String hoursCountText(String count) {
    return '$count 時間';
  }

  @override
  String get certifiedInstructor => '認定講師';

  @override
  String get expertCertifiedInstructor => 'エキスパート＆認定講師';

  @override
  String get defaultCourseTitle => '教育コース';

  @override
  String get categoryWord => 'カテゴリー';

  @override
  String get previewCourseVideo => 'コースプレビュー動画';

  @override
  String get freeSection => '無料セクション';

  @override
  String get freeDemoVideo => '無料デモ動画';

  @override
  String get articleLecture => '記事レクチャー';

  @override
  String get articleViewer => '記事ビューアー';

  @override
  String get courseVideoPlayer => 'コース動画プレーヤー';

  @override
  String get playingNow => '再生中';

  @override
  String get readingNow => '閲覧中';

  @override
  String get noLecturesInFreeSection => '無料セクションにレッスンがありません';

  @override
  String freeLecturesCount(String count) {
    return '$count件の無料レッスン';
  }

  @override
  String get enrollInFullCourse => 'フルコースに登録する';

  @override
  String get articleWord => '記事';

  @override
  String get videoWord => '動画';

  @override
  String get quizWord => 'クイズ';

  @override
  String get courseShareCopied => 'コースリンクをコピーしました！';

  @override
  String get addedToCartSnackbar => 'カートに追加しました';

  @override
  String get viewCartAction => 'カートを見る';

  @override
  String get inCartBadge => 'カート内 ✓';

  @override
  String get addToCartButton => 'カートに追加';

  @override
  String get wishlistAddedSnackbar => 'コースをお気に入りに追加しました';

  @override
  String get wishlistRemovedSuccessSnackbar => 'コースをお気に入りから削除しました';

  @override
  String get lessonCompletedAll => 'おめでとうございます！すべてのレッスンを修了しました。';

  @override
  String get noteAddedSuccess => 'メモを追加しました';

  @override
  String get lessonAlreadyDownloaded => 'レッスンはすでにオフライン保存されています';

  @override
  String get lessonLinkCopied => 'レッスンリンクをコピーしました';

  @override
  String get contentReportThanks => 'ご報告ありがとうございます。確認いたします。';

  @override
  String get courseCompletionCertificate => 'コース修了証';

  @override
  String get reportContentIssue => 'コンテンツの問題を報告';

  @override
  String get loginOrSocial => 'または次でログイン';

  @override
  String get loginSuccessSnackbar => 'ログインしました';

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
  String get cartClearAllTitle => 'カート内のすべての商品を削除しますか？';

  @override
  String cartClearAllMessage(String count) {
    return 'ショッピングカートから $count 件のコースをすべて削除してもよろしいですか？';
  }

  @override
  String get cartClearAllHint => 'すべてのコースがカートから削除されます。いつでも再度追加できます。';

  @override
  String cartClearAllConfirm(String count) {
    return 'すべて削除 ($count)';
  }

  @override
  String get cartClearedSuccess => 'カートを正常に空にしました';

  @override
  String get cartClearFailed => 'カートのクリアに失敗しました';

  @override
  String cartViewWishlistCount(String count) {
    return 'ウィッシュリストの商品を表示 ($count)';
  }

  @override
  String get cartGoToWishlist => 'ウィッシュリストへ';

  @override
  String get wishlistClearAllTitle => 'ウィッシュリスト内のすべての商品を削除しますか？';

  @override
  String wishlistClearAllMessage(String count) {
    return 'ウィッシュリストから $count 件のコースをすべて削除してもよろしいですか？';
  }

  @override
  String get wishlistClearAllHint => '保存されたコースがすべて削除されます。「見つける」からいつでも再度追加できます。';

  @override
  String wishlistClearAllConfirm(String count) {
    return 'すべて削除 ($count)';
  }

  @override
  String get wishlistClearedSuccess => 'ウィッシュリストを正常に空にしました';

  @override
  String get wishlistClearFailed => 'ウィッシュリストのクリアに失敗しました';

  @override
  String get wishlistClearTooltip => 'すべて削除';

  @override
  String wishlistViewCartCount(String count) {
    return 'カートの商品を表示 ($count)';
  }

  @override
  String get wishlistGoToCart => 'カートへ';

  @override
  String get checkoutCardNumberInvalid => '有効な16桁のカード番号を入力してください';

  @override
  String get checkoutCardExpiryInvalidFormat =>
      'カードの有効期限を正しく入力してください (MM / YY)';

  @override
  String get checkoutCardExpiredDate => 'カードの有効期限が無効です';

  @override
  String get checkoutCardCvcInvalid => '有効な3桁または4桁のCVCコードを入力してください';

  @override
  String get checkoutCardHolderNameRequired => 'カード名義人を入力してください';

  @override
  String get checkoutCartEmptySnackbar => 'ショッピングカートが空です';

  @override
  String get checkoutPaymentStartFailed => '支払いの開始に失敗しました';

  @override
  String get checkoutClientSecretMissing => '決済ゲートウェイからセキュリティキーを受信できませんでした';

  @override
  String get checkoutCardVerificationFailed => 'カードの確認に失敗しました';

  @override
  String get checkoutStripeProcessingFailed => 'Stripeでの支払い処理に失敗しました';

  @override
  String get checkoutServerConfirmationFailed => 'サーバーでの支払い確認に失敗しました';

  @override
  String get checkoutEmptyCartTitle => 'カートが空です';

  @override
  String get checkoutEmptyCartDesc => 'カートにコースが追加されていません。コースを探して学習を始めましょう！';

  @override
  String get checkoutContinueFreeReview => '無料確認に進む';

  @override
  String get checkoutFreeOrderBadge => '100% 無料注文 (zsh.00)';

  @override
  String get checkoutFreeOrderNotice =>
      'この注文には支払い情報は不要です。そのまま受講登録の確定に進むことができます。';

  @override
  String get checkoutFreeCheckoutTitle => '100% 無料チェックアウト';

  @override
  String get checkoutConfirmFreeEnrollment => '無料受講登録を確定';

  @override
  String get checkoutFreePrice => '無料';

  @override
  String get checkoutFreeZero => '無料 (zsh.00)';

  @override
  String checkoutCoursesCount(String count) {
    return '$count コース';
  }

  @override
  String get notificationsClearAllTitle => 'すべての通知を削除しますか？';

  @override
  String notificationsClearAllMessage(String count) {
    return '$count 件の通知をすべて削除してもよろしいですか？この操作は元に戻せません。';
  }

  @override
  String get notificationsClearAllHint => 'すべての通知が削除され、受信トレイが初期化されます。';

  @override
  String notificationsClearAllConfirm(String count) {
    return 'すべて削除 ($count)';
  }

  @override
  String get notificationsClearSuccess => 'すべての通知が正常に削除されました';

  @override
  String get notificationsClearFailed => '通知の削除に失敗しました';

  @override
  String get notificationsClearTooltip => 'すべて削除';

  @override
  String get notificationsViewDetails => '詳細を表示';

  @override
  String get notificationsEmptyCategoryTitle => 'このカテゴリには通知がありません';

  @override
  String get notificationsEmptyCategorySubtitle =>
      '他のカテゴリに切り替えるか、すべての通知を表示してください';

  @override
  String get notificationsEmptyAllSubtitle => '最新の更新情報やアラートはここに表示されます';

  @override
  String get notificationsViewAll => 'すべての通知を表示';

  @override
  String get learningFilterAndSortTitle => 'コースの絞り込みと並べ替え';

  @override
  String get learningFilterReset => 'リセット';

  @override
  String get learningSortByTitle => '並べ替え';

  @override
  String get learningSortRecentActivity => '最近アクセスした順';

  @override
  String get learningSortRecentEnrolled => '最近受講登録した順';

  @override
  String get learningSortTitleAZ => 'タイトル順 (A-Z)';

  @override
  String get learningSortProgress => '進捗率 %';

  @override
  String get learningStatusTitle => 'コースのステータス';

  @override
  String get learningStatusAll => 'すべてのコース';

  @override
  String get learningStatusInProgress => '進行中';

  @override
  String get learningStatusCompleted => '完了しました';

  @override
  String get learningStatusNotStarted => '未開始';

  @override
  String get learningFilterApply => 'フィルターを適用する';

  @override
  String get learningSearchCoursesHint => 'コースを検索...';

  @override
  String get learningSearchWishlistHint => 'ウィッシュリストを検索...';

  @override
  String get learningSearchCertificatesHint => '証明書を検索...';

  @override
  String get learningTabMyCourses => '私のコース';

  @override
  String get learningTabFavourite => '私のお気に入り';

  @override
  String get learningTabCertificates => '私の証明書';

  @override
  String get learningNoCoursesTitle => 'まだコースはありません';

  @override
  String get learningNoCoursesSubtitle => '何千ものプレミアムコースを探索して、今すぐ学習の旅を始めましょう';

  @override
  String get learningFilterButton => 'フィルター';

  @override
  String learningFilterAllCount(String count) {
    return 'すべて ($count)';
  }

  @override
  String get learningStatusNotStartedShort => '未開始';

  @override
  String get learningNoMatchTitle => '該当するコースはありません';

  @override
  String learningNoMatchSubtitle(String query) {
    return '「$query」を含むコースは見つかりませんでした。別の用語で検索してみてください。';
  }

  @override
  String get learningNoInProgressTitle => '進行中のコースはありません';

  @override
  String get learningNoInProgressSubtitle =>
      '登録したコースのレッスンの視聴を開始して、ここで進捗状況を追跡します。';

  @override
  String get learningNoCompletedTitle => 'まだ完了したコースはありません';

  @override
  String get learningNoCompletedSubtitle => '学習を続けて進歩を祝い、完了したコースをここで確認してください。';

  @override
  String get learningNoUnstartedTitle => '未開始のコースはありません';

  @override
  String get learningNoUnstartedSubtitle => '素晴らしい！登録済みのすべてのコースですでに学習を開始しています。';

  @override
  String get learningNoFilterMatchTitle => 'このフィルターに一致するコースはありません';

  @override
  String get learningNoFilterMatchSubtitle =>
      'フィルターまたは並べ替えオプションを変更してコースを表示します。';

  @override
  String learningViewAllCoursesCount(String count) {
    return 'すべてのコースを見る ($count)';
  }

  @override
  String learningSavedCoursesCount(String count) {
    return '保存されたコース ($count)';
  }

  @override
  String get learningClearAllSaved => 'すべてクリア';

  @override
  String get learningNoCertificatesTitle => 'まだ証明書がありません';

  @override
  String get learningNoCertificatesSubtitle => 'コースを完了して、成果を証明する認定証明書を取得してください';

  @override
  String get learningGoToCourses => '私のコースに移動';

  @override
  String learningCertIssuedDate(String date) {
    return '発行日: $date';
  }

  @override
  String get learningCertView => 'ビュー';

  @override
  String get learningResumeLesson => 'レッスンを再開する';

  @override
  String learningProgressPercentComplete(String percent) {
    return '$percent% 完了';
  }

  @override
  String learningViewCartCount(String count) {
    return 'カート項目を表示 ($count)';
  }

  @override
  String get learningGoToCart => 'カートに行く';

  @override
  String get playerLessonMarkedCompleted => '完了済みとしてマークされたレッスン ✓';

  @override
  String get playerLessonMarkedIncomplete => '未完了としてマークされたレッスン';

  @override
  String get playerCommentPostedSuccess => 'コメントが正常に投稿されました';

  @override
  String get playerCommentPostFailed => 'コメントの投稿に失敗しました';

  @override
  String get playerReplyPostedSuccess => '返信が正常に投稿されました';

  @override
  String get playerReplyPostFailed => '返信の投稿に失敗しました';

  @override
  String get playerCourseNotFound => 'コースが見つかりません';

  @override
  String get playerCheckEnrollmentPrompt => 'まずコース登録を確認してください';

  @override
  String get playerReturnToCourses => '私の学び';

  @override
  String get playerWatchLecture => 'コース講義';

  @override
  String get playerCertificateTooltip => '証明書';

  @override
  String get playerRateCourseTooltip => '料金コース';

  @override
  String get playerReadingArticleBadge => '記事を読む • 5 分';

  @override
  String get playerReadFullTextBelow => '全文は以下からお読みください↓';

  @override
  String get playerTabReviews => 'レビュー';

  @override
  String get playerNoSectionsAvailable => '利用可能なセクションがありません';

  @override
  String playerLessonsCount(String count) {
    return '$count レッスン';
  }

  @override
  String get playerPlayingBadge => '遊ぶ';

  @override
  String get playerArticleBadge => '記事';

  @override
  String get playerVideoBadge => 'ビデオ';

  @override
  String get playerFullArticleContent => '記事の全内容';

  @override
  String get playerArticlePlaceholder =>
      'この読書レッスンへようこそ。\n\nこのセクションでは、このレッスンのスキルを習得するために必要な中心的な概念と実践的な手順について説明します。';

  @override
  String get playerAboutCourseTitle => 'このコースについて';

  @override
  String get playerShowLess => '表示を減らす';

  @override
  String get playerReadMore => '続きを読む';

  @override
  String get playerWhatYouWillLearn => '学習内容';

  @override
  String get playerCourseInfoTitle => 'コース詳細';

  @override
  String get playerTotalDurationTitle => '合計時間';

  @override
  String get playerTotalLessonsTitle => '総レッスン数';

  @override
  String playerLessonsNumber(String count) {
    return '$count レッスン';
  }

  @override
  String get playerLevelTitle => 'レベル';

  @override
  String get playerAllLevels => 'すべてのレベル';

  @override
  String get playerLanguageTitle => '言語';

  @override
  String get playerLanguageArabic => 'アラビア語';

  @override
  String get playerPrerequisitesTitle => 'コース要件';

  @override
  String get playerCertificateCardTitle => 'コース修了証';

  @override
  String get playerCourseCompletedSuccess => 'おめでとうございます！コースを完了しました';

  @override
  String get playerProgressLabel => '進捗状況';

  @override
  String get playerViewCertificateBtn => '修了証を表示';

  @override
  String get playerCertifiedInstructor => '認定インストラクター';

  @override
  String playerDiscussionsCount(String count) {
    return '$count件の質問とディスカッション';
  }

  @override
  String get playerAskQuestionHint => '質問や疑問をここに入力してください...';

  @override
  String get playerPostBtn => '投稿';

  @override
  String get playerNoDiscussionsTitle => 'ディスカッションはまだありません';

  @override
  String get playerNoDiscussionsSubtitle => '最初の質問をしてみましょう！';

  @override
  String get playerInstructorBadge => 'インストラクター';

  @override
  String get playerCancelReply => 'キャンセル';

  @override
  String get playerReplyAction => '返信';

  @override
  String playerRepliesCount(String count) {
    return '$count件の返信';
  }

  @override
  String get playerWriteReplyHint => '返信を入力...';

  @override
  String get playerSendReplyBtn => '返信';

  @override
  String get playerCourseFeedbackTitle => 'コースの評価とフィードバック';

  @override
  String get playerOutOf5 => '5点中';

  @override
  String playerRatingsFromEnrolledCount(String count) {
    return '受講生からの評価 $count件';
  }

  @override
  String get playerKeepLearningToRate => '学習を続けて評価する';

  @override
  String get playerRateAfter80Hint => 'コース内容の80%を完了すると、レビューと評価ができるようになります';

  @override
  String get playerCurrentProgressLabel => 'あなたの進捗状況：';

  @override
  String get playerYourCurrentRating => 'あなたの評価';

  @override
  String get playerEditRating => '評価を編集';

  @override
  String get playerDeleteRatingTooltip => '評価を削除';

  @override
  String get playerUpdateRatingTitle => '評価を更新';

  @override
  String get playerRateCourseTitle => 'このコースを評価';

  @override
  String get playerWriteReviewHint => 'コンテンツの質に関する感想や意見を入力（任意）...';

  @override
  String get playerRatingSubmitSuccess => '評価を送信しました！';

  @override
  String get playerRatingSubmitFailed => '評価の送信に失敗しました';

  @override
  String get playerSaveChangesBtn => '変更を保存';

  @override
  String get playerSubmitReviewBtn => 'レビューを送信';

  @override
  String get playerLearnerReviewsTitle => '受講生のレビュー';

  @override
  String playerReviewsCount(String count) {
    return '$count件のレビュー';
  }

  @override
  String get playerNoWrittenReviewsTitle => 'まだレビューがありません';

  @override
  String get playerNoWrittenReviewsSubtitle => '最初のレビューを投稿してみましょう！';

  @override
  String get playerRatingLabel5 => '非常に良い 🌟 (5/5)';

  @override
  String get playerRatingLabel4 => '良い 👍 (4/5)';

  @override
  String get playerRatingLabel3 => '普通 👌 (3/5)';

  @override
  String get playerRatingLabel2 => '改善が必要 🤔 (2/5)';

  @override
  String get playerRatingLabel1 => '悪い 👎 (1/5)';

  @override
  String get playerDeleteRatingDialogTitle => '評価を削除';

  @override
  String get playerDeleteRatingDialogMessage => 'このコースのレビューを削除してもよろしいですか？';

  @override
  String get playerDeleteConfirmBtn => '削除';

  @override
  String get playerRatingDeleteSuccess => '評価を削除しました';

  @override
  String get playerPreviousLesson => '前のレッスン';

  @override
  String get playerExitFullscreenTooltip => '全画面表示を終了';

  @override
  String instructorsAvailableCount(String count) {
    return '$count人の講師が利用可能';
  }

  @override
  String get instructorsNotFound => '講師が見つかりません';

  @override
  String instructorsCoursesCount(String count) {
    return '$count コース';
  }

  @override
  String get instructorsSearchHint => '講師名や専門分野で検索...';

  @override
  String get instructorsSortAll => '全て';

  @override
  String get instructorsSortTopRated => '最高評価';

  @override
  String get instructorsSortMostStudents => 'ほとんどの学生';

  @override
  String get instructorsSortMostCourses => 'ほとんどのコース';

  @override
  String get instructorsNotFoundSubtitle => '別の名前で検索するか、フィルターをクリアしてください';

  @override
  String get exploreCompleteCourse => '総合コース';

  @override
  String get exploreGeneralCategory => '一般的な';

  @override
  String courseShareMessage(String title, String url) {
    return 'EduLab のコース「$title」をチェックしてください: $url';
  }

  @override
  String get courseDetailsDefaultTitle => 'コース詳細';

  @override
  String get courseDetailsTooltipShare => '共有';

  @override
  String get courseDetailsTooltipWishlist => 'ウィッシュリスト';

  @override
  String get courseDetailsTooltipCart => 'カート';

  @override
  String get courseDetailsNotFound => 'コースが見つかりません';

  @override
  String get courseDetailsDefaultCategory => 'コース';

  @override
  String courseDetailsTotalRatingsCount(String count) {
    return '($count 評価)';
  }

  @override
  String courseDetailsLecturesCount(String count) {
    return '$count 講義';
  }

  @override
  String get courseDetailsCertificateBadge => '証明書';

  @override
  String get courseDetailsTabOverview => '概要';

  @override
  String get courseDetailsTabCurriculum => 'カリキュラム';

  @override
  String get courseDetailsTabInstructor => 'インストラクター';

  @override
  String get courseDetailsTabReviews => 'レビュー';

  @override
  String get courseDetailsFullDescriptionTitle => '説明';

  @override
  String get courseDetailsShowLess => '表示を少なくする';

  @override
  String get courseDetailsShowMore => 'もっと見る...';

  @override
  String courseDetailsCurriculumSectionsLectures(
    String sections,
    String lectures,
  ) {
    return '$sections セクション • $lectures 講義';
  }

  @override
  String get courseDetailsCollapseAll => 'すべて折りたたむ';

  @override
  String get courseDetailsExpandAll => 'すべて展開';

  @override
  String get courseDetailsCurriculumComingSoon => 'カリキュラムの詳細は近日公開予定';

  @override
  String courseDetailsSectionLecturesCount(String count) {
    return '$count 講義';
  }

  @override
  String get courseDetailsLecturePreviewBtn => 'プレビュー';

  @override
  String get courseDetailsDefaultInstructorTitle => 'シニアインストラクターおよび認定エキスパート';

  @override
  String get courseDetailsInstructorRatingLabel => '評価';

  @override
  String get courseDetailsInstructorStudentsLabel => '学生';

  @override
  String get courseDetailsInstructorSectionsLabel => 'セクション';

  @override
  String get courseDetailsAboutInstructorTitle => '講師について:';

  @override
  String get courseDetailsDefaultInstructorAbout =>
      '世界中の何千人もの学生に専門教育を提供してきた豊富な経験を持つ認定インストラクター。';

  @override
  String courseDetailsStudentRatingsCount(String count) {
    return '$count 学生の評価';
  }

  @override
  String get courseDetailsNoWrittenReviews => '書かれたレビューはまだありません';

  @override
  String get courseDetailsRelatedCourses => 'あなたが好きかもしれない関連コース';

  @override
  String courseDetailsDiscountPercent(String percent) {
    return '$percent% オフ';
  }

  @override
  String get courseDetailsResumeCourse => 'コースを再開する';

  @override
  String get courseDetailsTryAgain => 'もう一度やり直してください';

  @override
  String get courseDetailsEstimatedReading => '📖 推定読了時間: 4 分';

  @override
  String get courseDetailsSampleArticleContent =>
      'この記事の講義へようこそ。\n\nこのセクションでは、主要な理論的概念とこの主題を習得するための実践的な手順について説明します。\n\n• 重要なポイント:\n1. 中心となる用語とアーキテクチャ パターンを理解します。\n2. 実践的な演習と継続的な練習。\n3. 補足メモと課題を参照します。\n\n読書をお楽しみください！';

  @override
  String certDownloadedSuccess(String course, String format) {
    return '「$course」の証明書が $format 形式で正常にダウンロードされました。';
  }

  @override
  String certVerifiedFullRequirements(String code) {
    return '検証 ID: $code • 要件を 100% 完了';
  }

  @override
  String get certCompletionTitle => '修了証明書';

  @override
  String get certCompletionSubtitle => 'コース修了証明書';

  @override
  String get certAnnounceStudent =>
      'EducationLab Learning Academy は、以下のことを証明します。';

  @override
  String get certCompletionRequirementsMet => 'トレーニング コースのすべての要件を正常に完了しました。';

  @override
  String certIssueDateText(String date) {
    return '発行日: $date';
  }

  @override
  String certIdNumberText(String code) {
    return '証明書 ID: $code';
  }

  @override
  String get certPlatformManagement => 'プラットフォーム管理';

  @override
  String get certInstructorRoleTitle => 'コースインストラクター';

  @override
  String get commonLoading => '読み込み中...';

  @override
  String get homeGuestTagline => 'スマートな学習とスキル構築のプラットフォーム';

  @override
  String get catTagHighestDemand => '最も需要が高い';

  @override
  String get catTagMostPopular => '最も人気';

  @override
  String get catTagTrending => 'トレンド';

  @override
  String get catTagFastestGrowing => '急成長中';

  @override
  String get catTagHighDemand => '高い需要';

  @override
  String get catTagTopRated => '最高評価';

  @override
  String get catTagEssential => '必須レベル';

  @override
  String get catTagAdvanced => '上級レベル';

  @override
  String get catTagEntrepreneurs => '起業家向け';

  @override
  String get catTagSalesGrowth => '売上成長';

  @override
  String get catDevTitle => 'プログラミング＆ソフトウェア開発';

  @override
  String get catDevSubtitle => 'ソフトウェア工学、システム＆アルゴリズム';

  @override
  String get catWebTitle => 'Web開発';

  @override
  String get catWebSubtitle => 'フロントエンド、バックエンド＆フルスタック';

  @override
  String get catMobileTitle => 'モバイルアプリ開発';

  @override
  String get catMobileSubtitle => 'Flutter、iOS＆Androidアプリ';

  @override
  String get catAiTitle => '人工知能（AI）';

  @override
  String get catAiSubtitle => '機械学習、ディープラーニング＆AI';

  @override
  String get catDataTitle => 'データサイエンス＆分析';

  @override
  String get catDataSubtitle => 'データ分析、統計＆ビッグデータ';

  @override
  String get catDesignTitle => 'UI/UX＆プロダクトデザイン';

  @override
  String get catDesignSubtitle => 'UI/UX、プロトタイピング＆プロダクト設計';

  @override
  String get catSecurityTitle => 'サイバーセキュリティ＆ネットワーク';

  @override
  String get catSecuritySubtitle => 'サイバーセキュリティ、倫理的ハッキング＆ネットワーク';

  @override
  String get catCloudTitle => 'クラウドコンピューティング＆DevOps';

  @override
  String get catCloudSubtitle => 'クラウドインフラ、DevOps＆CI/CD';

  @override
  String get catBusinessTitle => 'ビジネス＆プロジェクト管理';

  @override
  String get catBusinessSubtitle => 'アントレプレナーシップ、アジャイル＆リーダーシップ';

  @override
  String get catMarketingTitle => 'デジタルマーケティング';

  @override
  String get catMarketingSubtitle => 'デジタルマーケティング、SEO＆成長戦略';

  @override
  String get timeJustNow => 'たった今';

  @override
  String timeMinutesAgo(String count) {
    return '$count分前';
  }

  @override
  String timeHoursAgo(String count) {
    return '$count時間前';
  }

  @override
  String timeDaysAgo(String count) {
    return '$count日前';
  }

  @override
  String timeWeeksAgo(String count) {
    return '$count週間前';
  }

  @override
  String timeMonthsAgo(String count) {
    return '$countか月前';
  }

  @override
  String wishlistLecturesCount(String count) {
    return '$count講義';
  }
}

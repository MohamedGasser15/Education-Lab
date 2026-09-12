// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get onboardingSkip => 'Bỏ qua';

  @override
  String get onboardingTitle1 => 'Chào mừng đến với EduLab';

  @override
  String get onboardingSubtitle1 =>
      'Nền tảng lý tưởng cho việc học tập tương tác hiện đại và phát triển sự nghiệp không ngừng.';

  @override
  String get onboardingTitle2 => 'Học từ các giảng viên hàng đầu';

  @override
  String get onboardingSubtitle2 =>
      'Hàng ngàn khóa học chuyên nghiệp về lập trình, thiết kế, kinh doanh và khoa học dữ liệu.';

  @override
  String get onboardingTitle3 => 'Chứng chỉ & Thành công đảm bảo';

  @override
  String get onboardingSubtitle3 =>
      'Theo dõi tiến độ học tập, vượt qua các bài kiểm tra và nhận chứng chỉ uy tín.';

  @override
  String get onboardingNext => 'Tiếp theo';

  @override
  String get onboardingStart => 'Bắt đầu ngay';

  @override
  String get splashAppName => 'Education Lab';

  @override
  String get splashTagline => 'Nền tảng học tập thông minh';

  @override
  String get loginTagline =>
      'Chào mừng bạn đến với nền tảng học tập thông minh';

  @override
  String get loginAppName => 'EduLab';

  @override
  String get loginTabLogin => 'Đăng nhập';

  @override
  String get loginTabRegister => 'Đăng ký';

  @override
  String get loginEmailLabel => 'Email';

  @override
  String get loginEmailHint => 'example@email.com';

  @override
  String get loginPasswordLabel => 'Mật khẩu';

  @override
  String get loginPasswordHint => '••••••';

  @override
  String get loginForgotPassword => 'Quên mật khẩu?';

  @override
  String get loginSubmit => 'Đăng nhập';

  @override
  String get loginSubmitLoading => 'Đang đăng nhập...';

  @override
  String get loginGuest => 'Tiếp tục với tư cách Khách';

  @override
  String get loginOr => 'hoặc';

  @override
  String get loginEmailRequired => 'Vui lòng nhập email';

  @override
  String get loginEmailInvalid => 'Email không hợp lệ';

  @override
  String get loginPasswordRequired => 'Vui lòng nhập mật khẩu';

  @override
  String get registerStepEmail => 'Email';

  @override
  String get registerStepCode => 'Mã xác thực';

  @override
  String get registerStepData => 'Thông tin';

  @override
  String get registerSendCodeInfo =>
      'Chúng tôi sẽ gửi mã kích hoạt đến email này';

  @override
  String get registerSendCode => 'Gửi mã kích hoạt';

  @override
  String get registerVerifying => 'Đang xác thực...';

  @override
  String get registerCodeSentTo => 'Mã đã gửi đến:';

  @override
  String get registerResendCode => 'Gửi lại mã';

  @override
  String get registerBack => 'Quay lại';

  @override
  String get registerVerifyCode => 'Xác thực mã';

  @override
  String get registerCodeIncomplete => 'Vui lòng nhập đủ 6 chữ số mã xác thực';

  @override
  String get registerFullNameLabel => 'Họ và tên';

  @override
  String get registerFullNameHint => 'Nhập họ và tên đầy đủ';

  @override
  String get registerPasswordHint => 'Ít nhất 8 ký tự, gồm chữ hoa và số';

  @override
  String get registerConfirmLabel => 'Xác nhận mật khẩu';

  @override
  String get registerConfirmHint => 'Nhập lại mật khẩu';

  @override
  String get registerSubmit => 'Tạo tài khoản';

  @override
  String get registerSubmitLoading => 'Đang tạo tài khoản...';

  @override
  String get registerSuccess => 'Tạo tài khoản thành công';

  @override
  String get registerNameRequired => 'Vui lòng nhập họ và tên';

  @override
  String get registerNameMinLength => 'Họ tên phải có ít nhất 6 ký tự';

  @override
  String get registerPasswordMinLength => 'Mật khẩu phải có ít nhất 8 ký tự';

  @override
  String get registerPasswordUppercase =>
      'Mật khẩu phải chứa ít nhất một chữ hoa';

  @override
  String get registerPasswordNumber => 'Mật khẩu phải chứa ít nhất một chữ số';

  @override
  String get registerConfirmRequired => 'Vui lòng xác nhận mật khẩu';

  @override
  String get registerConfirmMismatch => 'Mật khẩu xác nhận không khớp';

  @override
  String get networkError => 'Lỗi kết nối, vui lòng thử lại';

  @override
  String homeGreeting(String name) {
    return 'Xin chào, $name!';
  }

  @override
  String get homeSubtitle => 'Hôm nay bạn muốn học gì?';

  @override
  String get homeSearchHint => 'Tìm kiếm khóa học hoặc kỹ năng...';

  @override
  String get homeSectionContinue => 'Tiếp tục học';

  @override
  String get homeSectionRecommended => 'Gợi ý cho bạn';

  @override
  String get homeSectionPopular => 'Khóa học phổ biến nhất';

  @override
  String get homeSectionTopRated => 'Đánh giá cao nhất';

  @override
  String get homeSectionByCategory => 'Theo danh mục';

  @override
  String get homeHeroTitle => 'Ưu đãi đặc biệt';

  @override
  String get homeHeroSubtitle =>
      'Giảm giá lên đến 70% các khóa học chất lượng cao';

  @override
  String get homeHeroButton => 'Khám phá ngay';

  @override
  String get homeViewAll => 'Xem tất cả';

  @override
  String get homeProgressLabel => 'Hoàn thành';

  @override
  String get exploreTitle => 'Khám phá Khóa học';

  @override
  String get exploreSearchHint =>
      'Tìm theo tên khóa học, kỹ năng hoặc giảng viên...';

  @override
  String get exploreAllCategories => 'Tất cả danh mục';

  @override
  String get exploreFilter => 'Bộ lọc';

  @override
  String get exploreSort => 'Sắp xếp';

  @override
  String get exploreNoResults => 'Không tìm thấy kết quả';

  @override
  String get exploreNoResultsHint =>
      'Hãy thử từ khóa khác hoặc thay đổi bộ lọc';

  @override
  String exploreCoursesCount(int count) {
    return '$count khóa học';
  }

  @override
  String get exploreFilterTitle => 'Bộ lọc kết quả';

  @override
  String get exploreFilterApply => 'Áp dụng';

  @override
  String get exploreFilterReset => 'Đặt lại';

  @override
  String get exploreFilterPrice => 'Giá';

  @override
  String get exploreFilterLevel => 'Trình độ';

  @override
  String get exploreFilterRating => 'Đánh giá';

  @override
  String get exploreFilterDuration => 'Thời lượng';

  @override
  String get exploreSortTitle => 'Sắp xếp theo';

  @override
  String get exploreSortRelevance => 'Phù hợp nhất';

  @override
  String get exploreSortNewest => 'Mới nhất';

  @override
  String get exploreSortPopular => 'Phổ biến nhất';

  @override
  String get exploreSortRating => 'Đánh giá cao nhất';

  @override
  String get exploreSortPriceLow => 'Giá: Thấp đến Cao';

  @override
  String get exploreSortPriceHigh => 'Giá: Cao đến Thấp';

  @override
  String get explorePriceFree => 'Miễn phí';

  @override
  String get exploreLevelBeginner => 'Cơ bản';

  @override
  String get exploreLevelIntermediate => 'Trung cấp';

  @override
  String get exploreLevelAdvanced => 'Nâng cao';

  @override
  String get learningTitle => 'Góc học tập';

  @override
  String get learningTabInProgress => 'Đang học';

  @override
  String get learningTabCompleted => 'Đã hoàn thành';

  @override
  String get learningTabSaved => 'Đã lưu';

  @override
  String get learningEmpty => 'Chưa có khóa học nào';

  @override
  String get learningEmptyHint => 'Bắt đầu khám phá các khóa học ngay hôm nay';

  @override
  String get learningExploreButton => 'Khám phá khóa học';

  @override
  String learningProgress(int percent) {
    return 'Đã học $percent%';
  }

  @override
  String get learningContinue => 'Học tiếp';

  @override
  String get learningViewCertificate => 'Xem chứng chỉ';

  @override
  String get learningReview => 'Đánh giá khóa học';

  @override
  String get learningLesson => 'Bài học';

  @override
  String get learningLessons => 'Bài học';

  @override
  String get cartTitle => 'Giỏ hàng';

  @override
  String get cartEmpty => 'Giỏ hàng của bạn đang trống';

  @override
  String get cartEmptyHint => 'Hãy thêm khóa học để bắt đầu học tập';

  @override
  String get cartExploreButton => 'Khám phá khóa học';

  @override
  String get cartPromoPlaceholder => 'Mã giảm giá';

  @override
  String get cartPromoApply => 'Áp dụng';

  @override
  String get cartPromoInvalid => 'Mã giảm giá không hợp lệ';

  @override
  String get cartSummary => 'Tóm tắt đơn hàng';

  @override
  String get cartSubtotal => 'Tạm tính';

  @override
  String get cartDiscount => 'Tiết kiệm';

  @override
  String get cartTotal => 'Tổng cộng';

  @override
  String get cartCheckout => 'Thanh toán';

  @override
  String cartCourses(int count) {
    return '$count khóa học';
  }

  @override
  String get cartRemove => 'Xóa';

  @override
  String get cartGuarantee => 'Đảm bảo hoàn tiền trong 30 ngày';

  @override
  String get checkoutTitle => 'Thanh toán đơn hàng';

  @override
  String get checkoutStepPayment => 'Thanh toán';

  @override
  String get checkoutStepReview => 'Xem lại';

  @override
  String get checkoutStepConfirm => 'Xác nhận';

  @override
  String get checkoutOrderSummary => 'Tóm tắt đơn hàng';

  @override
  String get checkoutTotal => 'Tổng tiền';

  @override
  String get checkoutPayNow => 'Thanh toán ngay';

  @override
  String get checkoutBack => 'Quay lại';

  @override
  String get checkoutNext => 'Tiếp tục';

  @override
  String get checkoutSecureSSL => 'Thanh toán bảo mật với mã hóa SSL 256-bit';

  @override
  String get checkoutSuccessTitle => 'Mua hàng thành công!';

  @override
  String get checkoutSuccessSubtitle => 'Bạn có thể bắt đầu học ngay bây giờ';

  @override
  String get checkoutGoToLearning => 'Vào khóa học của tôi';

  @override
  String get checkoutPaymentMethod => 'Phương thức thanh toán';

  @override
  String get checkoutCardNumber => 'Số thẻ';

  @override
  String get checkoutCardName => 'Tên in trên thẻ';

  @override
  String get checkoutCardExpiry => 'Hạn sử dụng';

  @override
  String get checkoutCardCVV => 'Mã CVV';

  @override
  String get courseDetailsEnroll => 'Đăng ký ngay';

  @override
  String get courseDetailsBuyNow => 'Mua ngay';

  @override
  String get courseDetailsAddToCart => 'Thêm vào giỏ hàng';

  @override
  String get courseDetailsAddedToCart => 'Đã thêm vào giỏ';

  @override
  String get courseDetailsAlreadyEnrolled => 'Đã sở hữu khóa học';

  @override
  String get courseDetailsGoToCourse => 'Vào học ngay';

  @override
  String get courseDetailsFree => 'Miễn phí';

  @override
  String courseDetailsStudents(String count) {
    return '$count học viên';
  }

  @override
  String get courseDetailsRating => 'Đánh giá';

  @override
  String get courseDetailsReviews => 'lượt đánh giá';

  @override
  String get courseDetailsLastUpdated => 'Cập nhật gần nhất';

  @override
  String get courseDetailsCurriculum => 'Nội dung khóa học';

  @override
  String get courseDetailsSection => 'chương';

  @override
  String get courseDetailsLessons => 'bài học';

  @override
  String get courseDetailsInstructor => 'Giảng viên';

  @override
  String get courseDetailsStudentsLabel => 'Học viên';

  @override
  String get courseDetailsCoursesLabel => 'Khóa học';

  @override
  String get courseDetailsReviewsLabel => 'Đánh giá';

  @override
  String get courseDetailsReviewsTitle => 'Đánh giá từ học viên';

  @override
  String get courseDetailsWhatLearn => 'Bạn sẽ học được gì';

  @override
  String get courseDetailsRequirements => 'Yêu cầu khóa học';

  @override
  String get courseDetailsDescription => 'Mô tả khóa học';

  @override
  String get courseDetailsIncludesTitle => 'Khóa học bao gồm';

  @override
  String get courseDetailsHoursVideo => 'giờ video theo yêu cầu';

  @override
  String get courseDetailsArticles => 'bài đọc chuyên sâu';

  @override
  String get courseDetailsMobileAccess => 'Học trên điện thoại & máy tính bảng';

  @override
  String get courseDetailsCertificate => 'Chứng chỉ hoàn thành';

  @override
  String get courseDetailsLifetimeAccess => 'Truy cập trọn đời';

  @override
  String get lessonPlayerNotes => 'Ghi chú của tôi';

  @override
  String get lessonPlayerResources => 'Tài liệu đính kèm';

  @override
  String get lessonPlayerDiscussion => 'Hỏi đáp & Thảo luận';

  @override
  String get lessonPlayerPrev => 'Bài trước';

  @override
  String get lessonPlayerNext => 'Bài tiếp';

  @override
  String get lessonPlayerSpeed => 'Tốc độ phát';

  @override
  String get lessonPlayerQuality => 'Chất lượng';

  @override
  String get lessonPlayerCompleted => 'Đã học xong bài này';

  @override
  String get certificateTitle => 'Chứng chỉ Hoàn thành';

  @override
  String get certificatePresentedTo => 'Chứng nhận trao cho';

  @override
  String get certificateCompletedCourse => 'vì đã hoàn thành xuất sắc khóa học';

  @override
  String get certificateIssuedOn => 'Ngày cấp';

  @override
  String get certificateVerificationId => 'Mã xác thực';

  @override
  String get certificateDownloadPDF => 'Tải về PDF';

  @override
  String get certificateDownloadPNG => 'Tải về hình ảnh';

  @override
  String get certificateCopyLink => 'Sao chép liên kết';

  @override
  String get certificateLinkCopied => 'Đã sao chép liên kết';

  @override
  String get profileTitle => 'Tài khoản';

  @override
  String get profileEditProfile => 'Chỉnh sửa hồ sơ';

  @override
  String get profileCourses => 'Khóa học của tôi';

  @override
  String get profileCertificates => 'Chứng chỉ';

  @override
  String get profilePoints => 'Điểm thưởng';

  @override
  String get profileFollowers => 'Người theo dõi';

  @override
  String get profileFollowing => 'Đang theo dõi';

  @override
  String get profileBio => 'Tiểu sử';

  @override
  String get profileInstructor => 'Giảng viên';

  @override
  String get profileStudent => 'Học viên';

  @override
  String get profileLevel => 'Cấp độ';

  @override
  String get profileJoined => 'Tham gia từ';

  @override
  String get profileShareProfile => 'Chia sẻ trang cá nhân';

  @override
  String get profileMenuLearning => 'Khóa học của tôi';

  @override
  String get profileMenuCertificates => 'Chứng chỉ của tôi';

  @override
  String get profileMenuPurchaseHistory => 'Lịch sử mua hàng';

  @override
  String get profileMenuTeachApplication => 'Trở thành giảng viên EduLab';

  @override
  String get profileMenuAccountSecurity => 'Bảo mật tài khoản';

  @override
  String get profileMenuNotifications => 'Thông báo';

  @override
  String get profileMenuMessages => 'Tin nhắn';

  @override
  String get profileMenuSettings => 'Cài đặt ứng dụng';

  @override
  String get profileMenuSchedule => 'Lịch học của tôi';

  @override
  String get profileMenuAssignments => 'Bài tập về nhà';

  @override
  String get profileMenuQuiz => 'Bài kiểm tra';

  @override
  String get profileMenuLogout => 'Đăng xuất';

  @override
  String get profileLogoutConfirm => 'Bạn có chắc chắn muốn đăng xuất không?';

  @override
  String get profileLogoutYes => 'Đăng xuất';

  @override
  String get profileLogoutNo => 'Hủy';

  @override
  String get editProfileTitle => 'Chỉnh sửa Hồ sơ';

  @override
  String get editProfileSave => 'Lưu thay đổi';

  @override
  String get editProfileFullName => 'Họ và tên';

  @override
  String get editProfileBio => 'Giới thiệu bản thân';

  @override
  String get editProfileEmail => 'Địa chỉ Email';

  @override
  String get editProfilePhone => 'Số điện thoại';

  @override
  String get editProfileWebsite => 'Trang web cá nhân';

  @override
  String get editProfileSaved => 'Đã lưu thay đổi thành công';

  @override
  String get accountSecurityTitle => 'Bảo mật Tài khoản';

  @override
  String get accountSecurityChangePassword => 'Đổi mật khẩu';

  @override
  String get accountSecurityTwoFactor => 'Xác thực hai yếu tố';

  @override
  String get accountSecurityActiveSessions => 'Thiết bị đang đăng nhập';

  @override
  String get accountSecurityDeleteAccount => 'Xóa tài khoản';

  @override
  String get purchaseHistoryTitle => 'Lịch sử Mua hàng';

  @override
  String get purchaseHistoryEmpty => 'Chưa có đơn hàng nào';

  @override
  String get purchaseHistoryGuarantee => 'Cam kết hoàn tiền trong 30 ngày';

  @override
  String get purchaseHistoryDate => 'Ngày giao dịch';

  @override
  String get purchaseHistoryStatus => 'Trạng thái';

  @override
  String get purchaseHistoryAmount => 'Số tiền';

  @override
  String get purchaseHistoryCompleted => 'Đã hoàn thành';

  @override
  String get purchaseHistoryRefunded => 'Đã hoàn tiền';

  @override
  String get teachApplicationTitle => 'Đăng ký Giảng dạy';

  @override
  String get teachApplicationSubmit => 'Gửi hồ sơ đăng ký';

  @override
  String get teachApplicationSent => 'Hồ sơ của bạn đã được gửi thành công';

  @override
  String get notificationsTitle => 'Thông báo';

  @override
  String get notificationsMarkAllRead => 'Đánh dấu tất cả đã đọc';

  @override
  String get notificationsMarkAllReadSnackbar =>
      'Đã đánh dấu tất cả thông báo là đã đọc';

  @override
  String get notificationsEmpty => 'Không có thông báo mới';

  @override
  String get notification1Title => 'Nhắc nhở: Tiếp tục bài học';

  @override
  String get notification1Message =>
      'Bạn có bài học mới trong khóa học Flutter cơ bản';

  @override
  String get notification1Time => '5 phút trước';

  @override
  String get notification1Action => 'Học tiếp';

  @override
  String get notification2Title => 'Chứng chỉ của bạn đã sẵn sàng!';

  @override
  String get notification2Message =>
      'Chúc mừng bạn đã hoàn thành khóa học Thiết kế UI/UX.';

  @override
  String get notification2Time => '2 giờ trước';

  @override
  String get notification2Action => 'Xem chứng chỉ';

  @override
  String get notification3Title => 'Ưu đãi đặc biệt dành cho bạn';

  @override
  String get notification3Message => 'Giảm giá 70% các khóa học lập trình';

  @override
  String get notification3Time => '1 ngày trước';

  @override
  String get notification3Action => 'Xem ngay';

  @override
  String get notification4Title => 'Giảng viên đã trả lời câu hỏi';

  @override
  String get notification4Message =>
      'Giảng viên đã phản hồi câu hỏi của bạn trong bài học';

  @override
  String get notification4Time => '2 ngày trước';

  @override
  String get notification4Action => 'Xem phản hồi';

  @override
  String get notification5Title => 'Khóa học vừa được cập nhật';

  @override
  String get notification5Message =>
      'Nội dung mới đã được thêm vào khóa học Python';

  @override
  String get notification5Time => '3 ngày trước';

  @override
  String get messagesTitle => 'Tin nhắn';

  @override
  String get settingsTitle => 'Cài đặt & Tùy chọn';

  @override
  String get settingsVideoDownload => 'Video & Tải xuống';

  @override
  String get settingsDownloadQuality => 'Chất lượng tải video mặc định';

  @override
  String get settingsWifiOnly => 'Chỉ tải xuống qua Wi-Fi';

  @override
  String get settingsNotifications => 'Thông báo & Âm thanh';

  @override
  String get settingsCourseNotifications => 'Thông báo khóa học và tin nhắn';

  @override
  String get settingsPromoNotifications => 'Ưu đãi và khuyến mãi độc quyền';

  @override
  String get settingsAppearance => 'Giao diện & Ngôn ngữ';

  @override
  String get settingsDarkMode => 'Chế độ tối';

  @override
  String get settingsDarkModeEnabled => 'Đã bật (tiết kiệm pin & dịu mắt)';

  @override
  String get settingsDarkModeDisabled => 'Đã tắt (giao diện sáng)';

  @override
  String get settingsLanguage => 'Ngôn ngữ ứng dụng';

  @override
  String get settingsStorage => 'Bộ nhớ & Bộ nhớ đệm';

  @override
  String get settingsClearCache => 'Xóa bộ nhớ đệm';

  @override
  String get settingsClearCacheSuccess => 'Đã xóa bộ nhớ đệm thành công';

  @override
  String get settingsHelp => 'Thông tin & Chính sách';

  @override
  String get settingsHelpCenter => 'Trung tâm trợ giúp & FAQ';

  @override
  String get settingsTermsPrivacy => 'Điều khoản & Quyền riêng tư';

  @override
  String get settingsAbout => 'Về EduLab';

  @override
  String get settingsVersion => 'Phiên bản v1.0.0';

  @override
  String get quizTitle => 'Bài kiểm tra';

  @override
  String get quizNext => 'Câu hỏi tiếp theo';

  @override
  String get quizSubmit => 'Nộp bài kiểm tra';

  @override
  String get quizScore => 'Điểm số';

  @override
  String get quizCorrectAnswers => 'Số câu đúng';

  @override
  String get scheduleTitle => 'Lịch học của tôi';

  @override
  String get scheduleEmpty => 'Không có buổi học nào sắp tới';

  @override
  String get scheduleJoin => 'Tham gia buổi học';

  @override
  String get scheduleReminder => 'Đặt nhắc nhở';

  @override
  String get assignmentsTitle => 'Bài tập';

  @override
  String get assignmentsEmpty => 'Không có bài tập cần nộp';

  @override
  String get assignmentsSubmit => 'Nộp bài tập';

  @override
  String get assignmentsDue => 'Hạn nộp';

  @override
  String get assignmentsSubmitted => 'Đã nộp';

  @override
  String get assignmentsPending => 'Đang chờ chấm';

  @override
  String get languageArabic => 'Tiếng Ả Rập';

  @override
  String get languageEnglish => 'Tiếng Anh';

  @override
  String get languageDialogTitle => 'Chọn ngôn ngữ ứng dụng';

  @override
  String get languageSelect => 'Chọn';

  @override
  String get generalCancel => 'Hủy';

  @override
  String get generalConfirm => 'Xác nhận';

  @override
  String get generalSave => 'Lưu';

  @override
  String get generalDelete => 'Xóa';

  @override
  String get generalEdit => 'Chỉnh sửa';

  @override
  String get generalClose => 'Đóng';

  @override
  String get generalBack => 'Quay lại';

  @override
  String get generalDone => 'Hoàn tất';

  @override
  String get generalOk => 'Đồng ý';

  @override
  String get generalYes => 'Có';

  @override
  String get generalNo => 'Không';

  @override
  String get generalLoading => 'Đang tải...';

  @override
  String get generalError => 'Đã xảy ra lỗi';

  @override
  String get generalRetry => 'Thử lại';

  @override
  String get generalNoInternet => 'Không có kết nối internet';

  @override
  String get generalFree => 'Miễn phí';

  @override
  String get generalRating => 'Đánh giá';

  @override
  String get generalStudents => 'Học viên';

  @override
  String get generalHours => 'Giờ';

  @override
  String get generalMinutes => 'Phút';

  @override
  String get generalBy => 'Bởi';

  @override
  String get navHome => 'Trang chủ';

  @override
  String get navExplore => 'Khám phá';

  @override
  String get navMyCourses => 'Khóa học';

  @override
  String get navCart => 'Giỏ hàng';

  @override
  String get navAccount => 'Tài khoản';

  @override
  String get homeSubGreeting => 'Bạn muốn nâng cao kỹ năng gì hôm nay?';

  @override
  String get homeVisitor => 'Khách';

  @override
  String get homePromoTitle => 'Ưu đãi đặc biệt';

  @override
  String get homePromoSubtitle =>
      'Giảm giá lên đến 70% các khóa học chất lượng cao';

  @override
  String get homePromoButton => 'Khám phá ngay';

  @override
  String get homePromoBadge => 'Ưu đãi độc quyền';

  @override
  String get homeContinueLearning => 'Tiếp tục học';

  @override
  String get homeMyCoursesLink => 'Khóa học của tôi';

  @override
  String get homeLesson => 'bài học';

  @override
  String homeStudentsCount(String count) {
    return '$count học viên';
  }

  @override
  String get homeRecommendedTitle => 'Gợi ý cho bạn';

  @override
  String get homeRecommendedSubtitle =>
      'Được cá nhân hóa theo sở thích của bạn';

  @override
  String get homeBestsellersTitle => 'Bán chạy nhất';

  @override
  String get homeBestsellersSubtitle =>
      'Các khóa học được yêu thích và đánh giá cao nhất';

  @override
  String get homeNewCoursesTitle => 'Khóa học mới';

  @override
  String get homeNewCoursesSubtitle => 'Nội dung cập nhật và mới mẻ';

  @override
  String get homePopularTopicsTitle => 'Chủ đề nổi bật';

  @override
  String get homePopularTopicsSubtitle => 'Học các kỹ năng được săn đón nhất';

  @override
  String get homeTopInstructorsTitle => 'Giảng viên hàng đầu';

  @override
  String get homeTopInstructorsSubtitle =>
      'Học từ các chuyên gia được chứng nhận';

  @override
  String get homeExploreCategoriesTitle => 'Khám phá danh mục';

  @override
  String get homeExploreCategoriesSubtitle => 'Tìm khóa học hoàn hảo cho bạn';

  @override
  String get catAll => 'Tất cả';

  @override
  String get catWebDev => 'Phát triển Web';

  @override
  String get catMobileApps => 'Ứng dụng Di động';

  @override
  String get catDataScience => 'Khoa học Dữ liệu';

  @override
  String get catUIUX => 'Thiết kế UI/UX';

  @override
  String get catBusiness => 'Kinh doanh & Quản lý';

  @override
  String get catAI => 'Trí tuệ Nhân tạo (AI)';

  @override
  String get catCyberSecurity => 'An ninh Mạng';

  @override
  String get exploreNoResultsTitle => 'Không tìm thấy kết quả';

  @override
  String get exploreNoResultsSubtitle =>
      'Hãy thử từ khóa khác hoặc thay đổi bộ lọc';

  @override
  String get exploreRecentSearches => 'Tìm kiếm gần đây';

  @override
  String get exploreTopSearches => 'Tìm kiếm phổ biến';

  @override
  String get exploreBrowseCategories => 'Duyệt danh mục';

  @override
  String get exploreBrowseCategoriesSubtitle => 'Tìm khóa học phù hợp nhất';

  @override
  String get exploreBackToAll => 'Trở lại tất cả';

  @override
  String get exploreClearAll => 'Xóa tất cả';

  @override
  String get exploreAvailableResults => 'kết quả có sẵn';

  @override
  String get exploreFilterBestseller => 'Bán chạy';

  @override
  String get exploreFilterTopRated => 'Đánh giá cao';

  @override
  String get exploreFilterUnder50 => 'Dưới 500.000đ';

  @override
  String get learningHeroTitle => 'Tiếp tục hành trình chinh phục tri thức';

  @override
  String get learningSearchHint => 'Tìm trong khóa học của tôi...';

  @override
  String get learningFilterAll => 'Tất cả';

  @override
  String get learningFilterInProgress => 'Đang học';

  @override
  String get learningFilterCompleted => 'Đã hoàn thành';

  @override
  String get learningFilterDownloaded => 'Đã tải xuống';

  @override
  String get learningEmptyTitle => 'Chưa có khóa học nào';

  @override
  String get learningEmptySubtitle =>
      'Bắt đầu khám phá các khóa học ngay hôm nay';

  @override
  String get learningEmptySearch => 'Không tìm thấy kết quả phù hợp';

  @override
  String get learningCompleted => 'Hoàn thành';

  @override
  String get learningCompletedBadge => 'Đã hoàn thành';

  @override
  String learningLecturesCount(int count) {
    return '$count bài giảng';
  }

  @override
  String get cartEmptyTitle => 'Giỏ hàng của bạn đang trống';

  @override
  String get cartEmptySubtitle => 'Hãy thêm khóa học để bắt đầu học tập';

  @override
  String get cartCouponHint => 'Nhập mã giảm giá';

  @override
  String get cartCouponApply => 'Áp dụng';

  @override
  String get cartCouponInvalid => 'Mã không hợp lệ';

  @override
  String get cartCouponApplied => 'Đã áp dụng mã giảm giá';

  @override
  String get cartCouponDiscount => 'Giảm giá voucher';

  @override
  String get cartCouponsTitle => 'Mã giảm giá có sẵn';

  @override
  String get cartOrderSummary => 'Tóm tắt đơn hàng';

  @override
  String get cartOriginalPrice => 'Giá gốc';

  @override
  String get cartPlatformDiscount => 'Giảm giá nền tảng';

  @override
  String get cartFinalTotal => 'Tổng thanh toán';

  @override
  String cartItemsCount(int count) {
    return '$count khóa học';
  }

  @override
  String get cartRemovedSnackbar => 'Đã xóa khóa học khỏi giỏ hàng';

  @override
  String get cartUndo => 'Hoàn tác';

  @override
  String get cartAddButton => 'Thêm vào giỏ';

  @override
  String get cartAddedSnackbar => 'Đã thêm vào giỏ hàng';

  @override
  String get cartAlreadyInCart => 'Đã có trong giỏ hàng';

  @override
  String get cartCheckoutButton => 'Tiến hành thanh toán';

  @override
  String get cartRecommendedTitle => 'Có thể bạn quan tâm';

  @override
  String get cartRecommendedSubtitle => 'Gợi ý dựa trên giỏ hàng của bạn';

  @override
  String get checkoutCreditCard => 'Thẻ tín dụng / Thẻ ghi nợ';

  @override
  String get checkoutSelectPayment => 'Chọn phương thức thanh toán';

  @override
  String get checkoutCardNumberLabel => 'Số thẻ thanh toán';

  @override
  String get checkoutCardHolderLabel => 'Tên chủ thẻ';

  @override
  String get checkoutExpiryLabel => 'Ngày hết hạn (MM/YY)';

  @override
  String get checkoutCVVLabel => 'Mã bảo mật CVV';

  @override
  String get checkoutPersonalInfoTitle => 'Thông tin cá nhân';

  @override
  String get checkoutFullNameLabel => 'Họ và tên';

  @override
  String get checkoutFullNameHint => 'Nhập họ tên đầy đủ';

  @override
  String get checkoutFullNameRequired => 'Vui lòng nhập họ và tên';

  @override
  String get checkoutPhoneLabel => 'Số điện thoại';

  @override
  String get checkoutPhoneRequired => 'Vui lòng nhập số điện thoại';

  @override
  String get checkoutPostalLabel => 'Mã bưu chính';

  @override
  String get checkoutPostalRequired => 'Vui lòng nhập mã bưu chính';

  @override
  String get checkoutBuyerInfo => 'Thông tin người mua';

  @override
  String get checkoutSaveInfo => 'Lưu thông tin cho lần thanh toán sau';

  @override
  String get checkoutMoneyBackGuarantee => 'Cam kết hoàn tiền trong 30 ngày';

  @override
  String get checkoutContinueToPayment => 'Tiếp tục thanh toán';

  @override
  String get checkoutContinueToReview => 'Xem lại đơn hàng';

  @override
  String get checkoutReviewConfirm => 'Xem lại & Xác nhận';

  @override
  String get checkoutStartLearning => 'Bắt đầu học ngay';

  @override
  String get checkoutBackHome => 'Về trang chủ';

  @override
  String get courseDetailsTitle => 'Chi tiết khóa học';

  @override
  String get courseDetailsShare => 'Chia sẻ';

  @override
  String get courseDetailsWhatYouWillLearn => 'Bạn sẽ học được gì';

  @override
  String get courseDetailsLanguage => 'Ngôn ngữ giảng dạy';

  @override
  String get courseDetailsCreatedBy => 'Giảng viên:';

  @override
  String get courseDetailsPreviewLesson => 'Học thử bài này';

  @override
  String get courseDetailsHoursOnDemand => 'giờ video bài giảng';

  @override
  String get courseDetailsFullLifetimeAccess =>
      'Quyền truy cập đầy đủ trọn đời';

  @override
  String get courseDetailsCertifiedCertificate =>
      'Chứng chỉ hoàn thành có xác thực';

  @override
  String get courseDetailsComprehensiveContent =>
      'Nội dung bài bản và chuyên sâu';

  @override
  String get certTitle => 'Chứng chỉ Hoàn thành';

  @override
  String get certStudentNameLabel => 'Học viên';

  @override
  String get certCourseLabel => 'Khóa học';

  @override
  String get certInstructorLabel => 'Giảng viên';

  @override
  String get certIssueDateLabel => 'Ngày cấp chứng chỉ';

  @override
  String get certCodeLabel => 'Mã chứng chỉ';

  @override
  String get certVerifiedBadge => 'Đã xác thực';

  @override
  String get certDownloadPDF => 'Tải về file PDF';

  @override
  String get certDownloadPNG => 'Lưu hình ảnh';

  @override
  String get certCopyVerifyLink => 'Sao chép liên kết xác thực';

  @override
  String get certShare => 'Chia sẻ chứng chỉ';

  @override
  String get playerTabLessons => 'Danh sách bài học';

  @override
  String get playerTabOverview => 'Tổng quan';

  @override
  String get playerTabNotes => 'Ghi chú';

  @override
  String get playerTabQnA => 'Hỏi & Đáp';

  @override
  String get playerNextLesson => 'Bài học tiếp theo';

  @override
  String get profileWelcome => 'Xin chào';

  @override
  String get profileLoginPrompt =>
      'Đăng nhập để xem thông tin và tiến độ học tập';

  @override
  String get profileLoginOrRegister => 'Đăng nhập / Đăng ký';

  @override
  String get profileVerifiedStudent => 'Học viên chính thức';

  @override
  String get profileLogout => 'Đăng xuất';

  @override
  String get profileCancel => 'Hủy';

  @override
  String get profileLogoutConfirmTitle => 'Xác nhận đăng xuất';

  @override
  String get profileLogoutConfirmMessage =>
      'Bạn có chắc chắn muốn đăng xuất khỏi tài khoản?';

  @override
  String get profileAccountSettings => 'Cài đặt tài khoản';

  @override
  String get profileEditProfileSubtitle => 'Cập nhật thông tin cá nhân';

  @override
  String get profileSecurity => 'Bảo mật';

  @override
  String get profileSecuritySubtitle => 'Mật khẩu và xác thực 2 lớp';

  @override
  String get profilePurchaseHistory => 'Lịch sử giao dịch';

  @override
  String get profilePurchaseHistorySubtitle =>
      'Xem lại các đơn hàng đã thanh toán';

  @override
  String get profileCertificatesSubtitle => 'Các chứng chỉ bạn đã nhận';

  @override
  String get profileTeach => 'Giảng dạy trên EduLab';

  @override
  String get profileTeachSubtitle => 'Chia sẻ tri thức và tạo nguồn thu nhập';

  @override
  String get profilePreferences => 'Tùy chọn hiển thị';

  @override
  String get profilePreferencesSubtitle => 'Cài đặt giao diện và ngôn ngữ';

  @override
  String get profileNotifications => 'Thông báo';

  @override
  String get profileNotificationsSubtitle => 'Quản lý thông báo và cảnh báo';

  @override
  String get profileHelpSupport => 'Trợ giúp & Hỗ trợ';

  @override
  String get profileTerms => 'Điều khoản sử dụng';

  @override
  String get profilePrivacy => 'Chính sách bảo mật';

  @override
  String get profileAboutEduLab => 'Giới thiệu về EduLab';

  @override
  String get profileWishlist => 'Danh sách yêu thích';

  @override
  String get securityTitle => 'Bảo mật Tài khoản';

  @override
  String get teachTitle => 'Đăng ký Giảng dạy';

  @override
  String get notificationsTabAll => 'Tất cả';

  @override
  String get notificationsTabCourses => 'Khóa học';

  @override
  String get notificationsTabPromos => 'Ưu đãi';

  @override
  String get notificationsEmptyTitle => 'Chưa có thông báo';

  @override
  String get notificationsUnread => 'Chưa đọc';

  @override
  String get wishlistTitle => 'Yêu thích';

  @override
  String get wishlistEmptyTitle => 'Danh sách yêu thích đang trống';

  @override
  String get wishlistEmptySubtitle => 'Lưu lại các khóa học bạn quan tâm';

  @override
  String get wishlistAddToCart => 'Thêm vào giỏ';

  @override
  String get wishlistRemovedSnackbar => 'Đã xóa khỏi danh sách yêu thích';

  @override
  String get homeDefaultUser => 'Học viên';

  @override
  String get learningOf => '/';

  @override
  String get cartInCartBadge => 'Trong giỏ';

  @override
  String get homePromo1Badge => 'Ưu đãi lớn • Thời gian có hạn';

  @override
  String get homePromo1Title => 'Bắt đầu học với mức giá tốt nhất';

  @override
  String get homePromo1Subtitle =>
      'Giảm giá tới 65% cho các khóa học lập trình, thiết kế và kinh doanh.';

  @override
  String get homePromo1Button => 'Xem ưu đãi';

  @override
  String get homePromo2Badge => 'Lộ trình nghề nghiệp chứng nhận';

  @override
  String get homePromo2Title => 'Chuẩn bị cho sự nghiệp mơ ước của bạn';

  @override
  String get homePromo2Subtitle =>
      'Các khóa học từ cơ bản đến nâng cao với dự án thực tế và chứng chỉ.';

  @override
  String get homePromo2Button => 'Khám phá lộ trình';

  @override
  String get homePromo3Badge => 'Giảng viên & Chuyên gia hàng đầu';

  @override
  String get homePromo3Title => 'Học trực tiếp từ các chuyên gia trong ngành';

  @override
  String get homePromo3Subtitle =>
      'Nội dung chất lượng cao liên tục cập nhật công nghệ mới nhất.';

  @override
  String get homePromo3Button => 'Bắt đầu ngay';

  @override
  String get homePromoInstructorBadge =>
      'Giảng dạy trên EduLab • Chia sẻ kiến thức';

  @override
  String get homePromoInstructorTitle => 'Trở thành giảng viên ngay hôm nay';

  @override
  String get homePromoInstructorSubtitle =>
      'Truyền cảm hứng cho học viên toàn cầu, tạo khóa học và kiếm thêm thu nhập khi giảng dạy đam mê của bạn.';

  @override
  String get homePromoInstructorButton => 'Ứng tuyển ngay';

  @override
  String get homeSearchFilter => 'Bộ lọc';

  @override
  String get securitySectionChangePassword => 'Đổi mật khẩu';

  @override
  String get securityCurrentPasswordLabel => 'Mật khẩu hiện tại *';

  @override
  String get securityCurrentPasswordError => 'Vui lòng nhập mật khẩu hiện tại';

  @override
  String get securityNewPasswordLabel => 'Mật khẩu mới *';

  @override
  String get securityNewPasswordError => 'Phải có ít nhất 8 ký tự';

  @override
  String get securityConfirmPasswordLabel => 'Xác nhận mật khẩu mới *';

  @override
  String get securityConfirmPasswordError => 'Mật khẩu không khớp';

  @override
  String get securityUpdatePasswordBtn => 'Cập nhật mật khẩu';

  @override
  String get securityPasswordUpdatedSuccess => 'Đổi mật khẩu thành công!';

  @override
  String get securitySection2FA => 'Xác thực hai yếu tố (2FA)';

  @override
  String get security2FATitle => 'Xác thực 2 bước';

  @override
  String get security2FAEnabledDesc =>
      'Đã bật - Bảo vệ tài khoản bằng mã xác minh';

  @override
  String get security2FADisabledDesc => 'Đã tắt (Khuyên dùng)';

  @override
  String get security2FASetupTitle => 'Bật xác thực 2 bước';

  @override
  String get security2FASetupContent =>
      'Mã xác minh gồm 6 chữ số sẽ được gửi đến email đã đăng ký của bạn mỗi khi đăng nhập mới.';

  @override
  String get security2FAEnableNow => 'Bật ngay';

  @override
  String get security2FAEnabledSuccess => 'Đã bật xác thực 2 bước thành công!';

  @override
  String get security2FADisabledSuccess => 'Đã tắt xác thực 2 bước';

  @override
  String get securitySectionSessions => 'Phiên hoạt động & Thiết bị';

  @override
  String get securityLogoutAllDevices => 'Đăng xuất khỏi tất cả thiết bị';

  @override
  String get securityThisDevice => 'Thiết bị này';

  @override
  String get securitySessionRevokedSuccess =>
      'Đã kết thúc phiên và đăng xuất khỏi thiết bị này.';

  @override
  String get securityAllSessionsRevokedSuccess =>
      'Đã đăng xuất khỏi tất cả các thiết bị khác.';

  @override
  String get purchaseHistoryInvoiceCertified => 'Hóa đơn điện tử hợp lệ';

  @override
  String get purchaseHistoryInvoiceNumber => 'Số hóa đơn';

  @override
  String get purchaseHistoryCourse => 'Khóa học';

  @override
  String get purchaseHistoryPaymentMethod => 'Phương thức thanh toán';

  @override
  String get purchaseHistoryTotalAmount => 'Tổng số tiền:';

  @override
  String get purchaseHistoryClose => 'Đóng';

  @override
  String get purchaseHistoryDownloadPdf => 'Tải xuống PDF';

  @override
  String get purchaseHistoryPdfDownloaded =>
      'Đã tải xuống hóa đơn PDF thành công';

  @override
  String get purchaseHistoryRefundRequestTitle => 'Yêu cầu hoàn tiền';

  @override
  String get purchaseHistoryRefundPolicy =>
      'Theo chính sách bảo đảm hoàn tiền trong 30 ngày của EduLab, bạn có thể nhận lại toàn bộ số tiền.';

  @override
  String get purchaseHistoryRefundReasonHint =>
      'Lý do hoàn tiền (không bắt buộc)...';

  @override
  String get purchaseHistoryConfirmRefund => 'Xác nhận hoàn tiền';

  @override
  String get purchaseHistoryRefundSubmitted =>
      'Yêu cầu hoàn tiền đã được gửi (xử lý trong 3-5 ngày làm việc).';

  @override
  String get purchaseHistoryInstructor => 'Giảng viên';

  @override
  String get purchaseHistoryRequestRefundBtn => 'Yêu cầu hoàn tiền';

  @override
  String get purchaseHistoryInvoiceBtn => 'Hóa đơn';

  @override
  String get purchaseHistoryStatusCompleted => 'Đã hoàn thành';

  @override
  String get purchaseHistoryStatusRefunded => 'Đã hoàn tiền';

  @override
  String get purchaseHistoryStatusProcessingRefund => 'Đang xử lý hoàn tiền';

  @override
  String get editProfileSectionBasicInfo => 'Thông tin cơ bản';

  @override
  String get editProfileFullNameLabel => 'Họ và tên *';

  @override
  String get editProfileFullNameHint => 'Nhập họ và tên đầy đủ';

  @override
  String get editProfileFullNameError => 'Vui lòng nhập họ tên đầy đủ';

  @override
  String get editProfileHeadlineLabel => 'Chức danh / Chuyên môn';

  @override
  String get editProfileHeadlineHint => 'ví dụ: Kỹ sư Flutter cấp cao';

  @override
  String get editProfileLocationLabel => 'Thành phố / Quốc gia';

  @override
  String get editProfileLocationHint => 'Hà Nội, Việt Nam';

  @override
  String get editProfilePhoneLabel => 'Số điện thoại di động';

  @override
  String get editProfileBioLabel => 'Giới thiệu bản thân (Bio)';

  @override
  String get editProfileBioHint =>
      'Viết tóm tắt ngắn gọn về sở thích và kinh nghiệm của bạn...';

  @override
  String get editProfileSectionLinks => 'Liên kết & Mạng xã hội';

  @override
  String get editProfileWebsiteLabel => 'Trang web cá nhân';

  @override
  String get editProfileSectionEmail => 'Email đã đăng ký';

  @override
  String get editProfileEmailDesc =>
      'Được liên kết với tài khoản để đăng nhập và nhận chứng chỉ';

  @override
  String get editProfileEmailVerified => 'Đã xác thực';

  @override
  String get editProfileSaveChangesBtn => 'Lưu và cập nhật thông tin';

  @override
  String get editProfileSavedSuccess => 'Cập nhật hồ sơ thành công!';

  @override
  String get editProfileChangeAvatarTitle => 'Thay đổi ảnh đại diện';

  @override
  String get editProfileTakePhoto => 'Chụp ảnh bằng máy ảnh';

  @override
  String get editProfileChooseGallery => 'Chọn từ thư viện ảnh';

  @override
  String get editProfilePhotoUpdatedSuccess =>
      'Cập nhật ảnh đại diện thành công';

  @override
  String get teachJoinInstructorTitle => 'Tham gia với tư cách giảng viên';

  @override
  String get teachJoinInstructorSubtitle =>
      'Xuất bản các khóa học và chia sẻ chuyên môn của bạn với hàng ngàn học viên.';

  @override
  String get teachStep1Title => 'Thông tin cá nhân';

  @override
  String get teachStep2Title => 'Kinh nghiệm & Kỹ năng';

  @override
  String get teachStep3Title => 'Xác nhận hồ sơ';

  @override
  String get teachStep1Header => '1. Thông tin cá nhân & chuyên môn';

  @override
  String get teachFullNameArabicLabel => 'Họ và tên *';

  @override
  String get teachFullNameArabicHint => 'ví dụ: Nguyễn Văn A';

  @override
  String get teachHeadlineLabel => 'Chức danh & Chuyên môn *';

  @override
  String get teachHeadlineHint =>
      'ví dụ: Kỹ sư phần mềm cao cấp & Giảng viên Flutter';

  @override
  String get teachPhoneLabel => 'Số điện thoại liên hệ *';

  @override
  String get teachCountryLabel => 'Quốc gia cư trú *';

  @override
  String get teachBioLabel => 'Giới thiệu bản thân & Kinh nghiệm giảng dạy *';

  @override
  String get teachBioHint =>
      'Viết tóm tắt ngắn gọn về sự nghiệp và các dự án của bạn...';

  @override
  String get teachNextStepSkills => 'Tiếp theo: Kinh nghiệm & Kỹ năng';

  @override
  String get teachStep2Header => '2. Nội dung khóa học & Kỹ năng';

  @override
  String get teachTopicLabel => 'Chủ đề khóa học đề xuất *';

  @override
  String get teachTopicHint => 'ví dụ: Phát triển ứng dụng Flutter từ số 0';

  @override
  String get teachYearsExperienceLabel => 'Số năm kinh nghiệm trong ngành *';

  @override
  String get teachVideoLinkLabel =>
      'Liên kết video bài giảng mẫu (YouTube/Drive/Loom) *';

  @override
  String get teachTargetAudienceLabel => 'Đối tượng học viên mục tiêu *';

  @override
  String get teachAudienceBeginners => 'Người mới bắt đầu hoàn toàn';

  @override
  String get teachAudienceIntermediate => 'Người mới và trung cấp';

  @override
  String get teachAudienceAdvanced => 'Lập trình viên nâng cao & Chuyên gia';

  @override
  String get teachAudienceAll => 'Tất cả các cấp độ';

  @override
  String get teachSkillsCoveredLabel => 'Kỹ năng & Công nghệ được giảng dạy *';

  @override
  String get teachAddSkillHint => 'Thêm kỹ năng (ví dụ: GraphQL)...';

  @override
  String get teachAddSkillBtn => 'Thêm';

  @override
  String get teachNextStepConfirm => 'Tiếp theo: Xác nhận hồ sơ';

  @override
  String get teachStep3Header => '3. Chi tiết thanh toán & Thỏa thuận';

  @override
  String get teachPayoutMethodLabel => 'Phương thức nhận doanh thu *';

  @override
  String get teachPayoutMethodBank => 'Chuyển khoản ngân hàng trực tiếp (IBAN)';

  @override
  String get teachPayoutMethodPaypal => 'Tài khoản PayPal đã xác minh';

  @override
  String get teachPayoutMethodPayoneer => 'Thẻ / Tài khoản Payoneer';

  @override
  String get teachIbanDetailsLabel => 'Thông tin tài khoản / IBAN *';

  @override
  String get teachApplicationSummary => 'Tóm tắt hồ sơ:';

  @override
  String get teachApplicantName => 'Người nộp đơn';

  @override
  String get teachApplicantHeadline => 'Chuyên môn';

  @override
  String get teachApplicantTopic => 'Chủ đề khóa học';

  @override
  String get teachApplicantSkillsCount => 'Số lượng kỹ năng';

  @override
  String get teachSkillsUnit => 'kỹ năng';

  @override
  String get teachAgreeTermsLabel =>
      'Tôi đồng ý với các điều khoản, điều kiện và thỏa thuận quyền sở hữu trí tuệ của EduLab.';

  @override
  String get teachSubmitApplicationBtn => 'Submit Instructor Application';

  @override
  String get teachPrevStepBtn => 'Quay lại';

  @override
  String get teachWhyEduLabTitle => 'Tại sao nên giảng dạy cùng EduLab?';

  @override
  String get teachProp1Title => 'Doanh thu hấp dẫn và minh bạch';

  @override
  String get teachProp1Desc =>
      'Nhận tới 80% doanh thu từ việc bán khóa học mà không có phí ẩn.';

  @override
  String get teachProp2Title => 'Tiếp cận hàng ngàn học viên';

  @override
  String get teachProp2Desc =>
      'Quảng bá khóa học của bạn tới cộng đồng học tập trực tuyến năng động.';

  @override
  String get teachProp3Title => 'Hỗ trợ sản xuất & kỹ thuật toàn diện';

  @override
  String get teachProp3Desc =>
      'Đội ngũ của chúng tôi giúp bạn tối ưu hóa âm thanh, hình ảnh và giáo trình.';

  @override
  String get teachSuccessDialogTitle => 'Đã nhận hồ sơ thành công!';

  @override
  String get teachSuccessDialogDesc =>
      'Cảm ơn bạn đã tham gia cộng đồng giảng viên EduLab. Đội ngũ học thuật sẽ xem xét hồ sơ và liên hệ trong vòng 48 giờ.';

  @override
  String get teachSuccessDialogOk => 'Đồng ý';

  @override
  String get teachAddOneSkillError => 'Vui lòng thêm ít nhất một kỹ năng';

  @override
  String get teachAgreeTermsError =>
      'Vui lòng đồng ý với các điều khoản giảng viên';

  @override
  String get commonCancel => 'Hủy';

  @override
  String get commonClose => 'Đóng';

  @override
  String get myCertificatesBannerTitle => 'Chứng chỉ Được Công nhận';

  @override
  String get myCertificatesBannerSubtitle =>
      'Tất cả các chứng chỉ đều được công nhận và xác minh với ID duy nhất từ EduLab';

  @override
  String get certBadgeVerified100 => '100% Được Công nhận';

  @override
  String get certCodeCopied => 'Đã sao chép mã chứng chỉ';

  @override
  String get certGrantedTo => 'Được cấp cho';

  @override
  String get certViewAndDownload => 'Xem & Tải xuống Chứng chỉ';

  @override
  String get certIssuerLabel => 'Cơ quan cấp';

  @override
  String get certIssuerName => 'Học viện Học tập Tương tác EduLab';

  @override
  String get certEmptyTitle => 'Chưa có chứng chỉ nào';

  @override
  String get certEmptyDesc =>
      'Hoàn thành 100% khóa học đã đăng ký để nhận chứng chỉ được công nhận với ID xác minh chính thức.';

  @override
  String get certEmptyAction => 'Tiếp tục các khóa học của tôi';

  @override
  String get certDetailsTitle => 'Chi tiết & Thông tin Chứng chỉ';

  @override
  String get certCopyLinkSuccess =>
      'Đã sao chép liên kết xác minh trực tiếp vào khay nhớ tạm!';

  @override
  String get certShareSuccess =>
      'Đã sao chép chi tiết chứng chỉ và liên kết để chia sẻ!';

  @override
  String get purchaseHistoryTaxInvoiceCertified =>
      'Hóa đơn Thuế Chính thức Được Chứng nhận';

  @override
  String get purchaseHistoryInvoiceNumberLabel => 'Mã Đơn hàng / Hóa đơn';

  @override
  String get purchaseHistoryCourseNameLabel => 'Tên khóa học';

  @override
  String get purchaseHistoryPurchaseDateLabel => 'Ngày mua';

  @override
  String get purchaseHistoryPaymentMethodLabel => 'Phương thức thanh toán';

  @override
  String get purchaseHistoryPaymentMethodValue =>
      'Thẻ tín dụng / Stripe (Trực tuyến)';

  @override
  String get purchaseHistoryOrderStatusLabel => 'Trạng thái đơn hàng';

  @override
  String get purchaseHistoryStatusPendingReview => 'Đang xem xét hoàn tiền';

  @override
  String get purchaseHistoryCopyInvoiceBtn => 'Sao chép số hóa đơn';

  @override
  String get purchaseHistoryRefundReasonLabel => 'Lý do yêu cầu hoàn tiền:';

  @override
  String get purchaseHistoryRefundReasonEmptyError =>
      'Vui lòng nhập lý do yêu cầu hoàn tiền của bạn';

  @override
  String get purchaseHistorySubmittingRefund => 'Đang gửi yêu cầu...';

  @override
  String get purchaseHistoryPaidDate => 'Ngày thanh toán';

  @override
  String get purchaseHistoryEmptyTitle => 'Chưa có lịch sử mua hàng';

  @override
  String get purchaseHistoryEmptyDesc =>
      'Bạn chưa mua khóa học nào.\nĐơn hàng và hóa đơn của bạn sẽ xuất hiện ở đây sau khi hoàn tất.';

  @override
  String get purchaseHistoryExploreCourses => 'Khám phá các khóa học ngay';

  @override
  String get profileMyCourses => 'Khóa học của tôi';

  @override
  String get profileMyCoursesSubtitle =>
      'Theo dõi tiến độ các khóa học đã đăng ký';

  @override
  String get profileWishlistSubtitle =>
      'Các khóa học đã lưu trong danh sách yêu thích';

  @override
  String get navMyLearning => 'Học tập của tôi';

  @override
  String get profileLogoutSafeNote =>
      'Dữ liệu, khóa học và chứng chỉ của bạn được bảo mật hoàn toàn. Bạn có thể tiếp tục học bất cứ lúc nào khi đăng nhập lại.';

  @override
  String learningRemainingHours(String hours) {
    return 'Còn $hours giờ';
  }

  @override
  String get learningCompletedFull => 'Đã hoàn thành';

  @override
  String get learningFilterNotStarted => 'Chưa Bắt Đầu';

  @override
  String get wishlistTopRatedBadge => 'Được đánh giá cao nhất';

  @override
  String get wishlistFeaturedBadge => 'Nổi bật';

  @override
  String wishlistDiscountBadge(String percent) {
    return 'Giảm giá $percent%';
  }

  @override
  String get courseFree => 'Miễn phí';

  @override
  String get badgeBestseller => 'Bán chạy nhất';

  @override
  String get badgeTopRated => 'Được đánh giá cao nhất';

  @override
  String get badgeFeatured => 'Nổi bật';

  @override
  String get badgeRecommended => 'Được đề xuất cho bạn';

  @override
  String get badgeNew => 'Mới';

  @override
  String get courseWord => 'Khóa học';

  @override
  String coursesCountText(String count) {
    return '$count+ Khóa học';
  }

  @override
  String studentsCountText(String count) {
    return '$count Học viên';
  }

  @override
  String hoursCountText(String count) {
    return '$count Giờ';
  }

  @override
  String get certifiedInstructor => 'Giảng viên được chứng nhận';

  @override
  String get expertCertifiedInstructor => 'Chuyên gia & Giảng viên chứng nhận';

  @override
  String get defaultCourseTitle => 'Khóa học giáo dục';

  @override
  String get categoryWord => 'Danh mục';

  @override
  String get previewCourseVideo => 'Xem trước video khóa học';

  @override
  String get freeSection => 'Phần miễn phí';

  @override
  String get freeDemoVideo => 'Video demo miễn phí';

  @override
  String get articleLecture => 'Bài học dạng bài viết';

  @override
  String get articleViewer => 'Trình đọc bài viết';

  @override
  String get courseVideoPlayer => 'Trình phát video khóa học';

  @override
  String get playingNow => 'Đang phát';

  @override
  String get readingNow => 'Đang đọc';

  @override
  String get noLecturesInFreeSection => 'Không có bài học trong phần miễn phí';

  @override
  String freeLecturesCount(String count) {
    return '$count bài học miễn phí';
  }

  @override
  String get enrollInFullCourse => 'Đăng ký toàn bộ khóa học';

  @override
  String get articleWord => 'Bài viết';

  @override
  String get videoWord => 'Video';

  @override
  String get quizWord => 'Trắc nghiệm';

  @override
  String get courseShareCopied => 'Đã sao chép liên kết khóa học!';

  @override
  String get addedToCartSnackbar => 'Đã thêm vào giỏ hàng';

  @override
  String get viewCartAction => 'Xem giỏ hàng';

  @override
  String get inCartBadge => 'Trong giỏ ✓';

  @override
  String get addToCartButton => 'Thêm vào giỏ';

  @override
  String get wishlistAddedSnackbar =>
      'Đã thêm khóa học vào danh sách yêu thích';

  @override
  String get wishlistRemovedSuccessSnackbar =>
      'Đã xóa khóa học khỏi danh sách yêu thích';

  @override
  String get lessonCompletedAll =>
      'Chúc mừng! Bạn đã hoàn thành tất cả các bài học.';

  @override
  String get noteAddedSuccess => 'Đã thêm ghi chú thành công';

  @override
  String get lessonAlreadyDownloaded =>
      'Bài học đã được lưu để xem ngoại tuyến';

  @override
  String get lessonLinkCopied => 'Đã sao chép liên kết bài học';

  @override
  String get contentReportThanks =>
      'Cảm ơn phản hồi của bạn, bài học sẽ được kiểm duyệt';

  @override
  String get courseCompletionCertificate => 'Chứng chỉ hoàn thành khóa học';

  @override
  String get reportContentIssue => 'Báo cáo sự cố nội dung';

  @override
  String get loginOrSocial => 'Hoặc đăng nhập bằng';

  @override
  String get loginSuccessSnackbar => 'Đăng nhập thành công';

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
  String get cartClearAllTitle => 'Xóa tất cả các mặt hàng trong giỏ hàng?';

  @override
  String cartClearAllMessage(String count) {
    return 'Bạn có chắc chắn muốn xóa tất cả $count khóa học khỏi giỏ hàng của mình không?';
  }

  @override
  String get cartClearAllHint =>
      'Tất cả các khóa học sẽ bị xóa khỏi giỏ hàng của bạn. Bạn có thể thêm chúng trở lại bất cứ lúc nào.';

  @override
  String cartClearAllConfirm(String count) {
    return 'Xóa tất cả ($count)';
  }

  @override
  String get cartClearedSuccess => 'Đã xóa giỏ hàng thành công';

  @override
  String get cartClearFailed => 'Không thể xóa giỏ hàng';

  @override
  String cartViewWishlistCount(String count) {
    return 'Xem các mục trong danh sách yêu thích ($count)';
  }

  @override
  String get cartGoToWishlist => 'Đi tới danh sách yêu thích';

  @override
  String get wishlistClearAllTitle =>
      'Xóa tất cả các mục trong danh sách mong muốn?';

  @override
  String wishlistClearAllMessage(String count) {
    return 'Bạn có chắc chắn muốn xóa tất cả $count khóa học khỏi danh sách mong muốn của mình không?';
  }

  @override
  String get wishlistClearAllHint =>
      'Tất cả các khóa học đã lưu sẽ bị xóa. Bạn có thể thêm lại họ bất cứ lúc nào từ Khám phá.';

  @override
  String wishlistClearAllConfirm(String count) {
    return 'Xóa tất cả ($count)';
  }

  @override
  String get wishlistClearedSuccess => 'Đã xóa danh sách yêu thích thành công';

  @override
  String get wishlistClearFailed => 'Không thể xóa danh sách yêu thích';

  @override
  String get wishlistClearTooltip => 'Xóa tất cả';

  @override
  String wishlistViewCartCount(String count) {
    return 'Xem các mặt hàng trong giỏ hàng ($count)';
  }

  @override
  String get wishlistGoToCart => 'Đi tới giỏ hàng';

  @override
  String get checkoutCardNumberInvalid =>
      'Vui lòng nhập số thẻ 16 chữ số hợp lệ';

  @override
  String get checkoutCardExpiryInvalidFormat =>
      'Vui lòng nhập ngày hết hạn thẻ hợp lệ (MM/YY)';

  @override
  String get checkoutCardExpiredDate => 'Ngày hết hạn thẻ không hợp lệ';

  @override
  String get checkoutCardCvcInvalid =>
      'Vui lòng nhập mã CVC gồm 3 hoặc 4 chữ số hợp lệ';

  @override
  String get checkoutCardHolderNameRequired => 'Vui lòng nhập tên chủ thẻ';

  @override
  String get checkoutCartEmptySnackbar => 'Giỏ hàng trống';

  @override
  String get checkoutPaymentStartFailed => 'Không thể bắt đầu thanh toán';

  @override
  String get checkoutClientSecretMissing =>
      'Không nhận được khóa bảo mật từ cổng thanh toán';

  @override
  String get checkoutCardVerificationFailed => 'Xác minh thẻ không thành công';

  @override
  String get checkoutStripeProcessingFailed =>
      'Xử lý thanh toán sọc không thành công';

  @override
  String get checkoutServerConfirmationFailed =>
      'Xác nhận thanh toán máy chủ không thành công';

  @override
  String get checkoutEmptyCartTitle => 'Giỏ hàng của bạn trống';

  @override
  String get checkoutEmptyCartDesc =>
      'Bạn chưa thêm khóa học nào vào giỏ hàng. Khám phá các khóa học của chúng tôi và bắt đầu học!';

  @override
  String get checkoutContinueFreeReview => 'Tiếp tục đánh giá miễn phí';

  @override
  String get checkoutFreeOrderBadge => 'Đơn hàng miễn phí 100% (zsh.00)';

  @override
  String get checkoutFreeOrderNotice =>
      'Đơn đặt hàng này không yêu cầu bất kỳ thông tin thanh toán nào. Bạn có thể tiến hành trực tiếp để xác nhận đăng ký.';

  @override
  String get checkoutFreeCheckoutTitle => 'Thanh toán miễn phí 100%';

  @override
  String get checkoutConfirmFreeEnrollment => 'Xác nhận đăng ký miễn phí';

  @override
  String get checkoutFreePrice => 'Miễn phí';

  @override
  String get checkoutFreeZero => 'Miễn phí (zsh.00)';

  @override
  String checkoutCoursesCount(String count) {
    return '$count khóa học';
  }

  @override
  String get notificationsClearAllTitle => 'Xóa tất cả thông báo?';

  @override
  String notificationsClearAllMessage(String count) {
    return 'Bạn có chắc chắn muốn xóa tất cả thông báo $count không? Không thể hoàn tác hành động này.';
  }

  @override
  String get notificationsClearAllHint =>
      'Tất cả thông báo của bạn sẽ bị xóa và hộp thư đến của bạn sẽ bắt đầu mới.';

  @override
  String notificationsClearAllConfirm(String count) {
    return 'Xóa tất cả ($count)';
  }

  @override
  String get notificationsClearSuccess =>
      'Tất cả thông báo đã được xóa thành công';

  @override
  String get notificationsClearFailed => 'Không thể xóa thông báo';

  @override
  String get notificationsClearTooltip => 'Xóa tất cả';

  @override
  String get notificationsViewDetails => 'Xem chi tiết';

  @override
  String get notificationsEmptyCategoryTitle =>
      'Không có thông báo trong danh mục này';

  @override
  String get notificationsEmptyCategorySubtitle =>
      'Hãy thử chuyển sang danh mục khác hoặc duyệt tất cả thông báo';

  @override
  String get notificationsEmptyAllSubtitle =>
      'Chúng tôi sẽ cập nhật cho bạn những thông tin cập nhật và cảnh báo mới nhất tại đây';

  @override
  String get notificationsViewAll => 'Xem tất cả thông báo';

  @override
  String get learningFilterAndSortTitle => 'Lọc & Sắp xếp các khóa học';

  @override
  String get learningFilterReset => 'Cài lại';

  @override
  String get learningSortByTitle => 'Sắp xếp theo';

  @override
  String get learningSortRecentActivity => 'Đã truy cập gần đây';

  @override
  String get learningSortRecentEnrolled => 'Đã đăng ký gần đây';

  @override
  String get learningSortTitleAZ => 'Tiêu đề (A-Z)';

  @override
  String get learningSortProgress => 'Tiến triển %';

  @override
  String get learningStatusTitle => 'Tình trạng khóa học';

  @override
  String get learningStatusAll => 'Tất cả các khóa học';

  @override
  String get learningStatusInProgress => 'Đang tiến hành';

  @override
  String get learningStatusCompleted => 'Hoàn thành';

  @override
  String get learningStatusNotStarted => 'Chưa bắt đầu';

  @override
  String get learningFilterApply => 'Áp dụng bộ lọc';

  @override
  String get learningSearchCoursesHint => 'Tìm kiếm các khóa học của bạn...';

  @override
  String get learningSearchWishlistHint => 'Tìm kiếm danh sách mong muốn...';

  @override
  String get learningSearchCertificatesHint => 'Tìm kiếm chứng chỉ...';

  @override
  String get learningTabMyCourses => 'Khóa học của tôi';

  @override
  String get learningTabFavourite => 'yêu thích của tôi';

  @override
  String get learningTabCertificates => 'Chứng chỉ của tôi';

  @override
  String get learningNoCoursesTitle => 'Chưa có khóa học nào';

  @override
  String get learningNoCoursesSubtitle =>
      'Khám phá hàng nghìn khóa học cao cấp và bắt đầu hành trình học tập của bạn ngay hôm nay';

  @override
  String get learningFilterButton => 'Lọc';

  @override
  String learningFilterAllCount(String count) {
    return 'Tất cả ($count)';
  }

  @override
  String get learningStatusNotStartedShort => 'Chưa bắt đầu';

  @override
  String get learningNoMatchTitle => 'Không có khóa học phù hợp';

  @override
  String learningNoMatchSubtitle(String query) {
    return 'Không tìm thấy khóa học nào có chứa \"$query\". Hãy thử tìm kiếm với các thuật ngữ khác nhau.';
  }

  @override
  String get learningNoInProgressTitle => 'Không có khóa học nào đang diễn ra';

  @override
  String get learningNoInProgressSubtitle =>
      'Bắt đầu xem các bài học trong các khóa học đã đăng ký của bạn để theo dõi tiến trình của bạn tại đây.';

  @override
  String get learningNoCompletedTitle => 'Chưa có khóa học nào hoàn thành';

  @override
  String get learningNoCompletedSubtitle =>
      'Tiếp tục việc học của bạn để kỷ niệm sự tiến bộ của bạn và xem các khóa học đã hoàn thành tại đây.';

  @override
  String get learningNoUnstartedTitle => 'Không có khóa học nào chưa bắt đầu';

  @override
  String get learningNoUnstartedSubtitle =>
      'Tuyệt vời! Bạn đã bắt đầu học tất cả các khóa học đã đăng ký của mình.';

  @override
  String get learningNoFilterMatchTitle =>
      'Không có khóa học nào phù hợp với bộ lọc này';

  @override
  String get learningNoFilterMatchSubtitle =>
      'Thay đổi tùy chọn lọc hoặc sắp xếp để hiển thị các khóa học của bạn.';

  @override
  String learningViewAllCoursesCount(String count) {
    return 'Xem tất cả các khóa học ($count)';
  }

  @override
  String learningSavedCoursesCount(String count) {
    return 'Khóa học đã lưu ($count)';
  }

  @override
  String get learningClearAllSaved => 'Xóa tất cả';

  @override
  String get learningNoCertificatesTitle => 'Chưa có chứng chỉ nào';

  @override
  String get learningNoCertificatesSubtitle =>
      'Hoàn thành các khóa học của bạn để nhận được chứng chỉ được công nhận xác minh thành tích của bạn';

  @override
  String get learningGoToCourses => 'Đi tới Khóa học của tôi';

  @override
  String learningCertIssuedDate(String date) {
    return 'Đã phát hành: $date';
  }

  @override
  String get learningCertView => 'Xem';

  @override
  String get learningResumeLesson => 'Tiếp tục bài học';

  @override
  String learningProgressPercentComplete(String percent) {
    return '$percent% hoàn thành';
  }

  @override
  String learningViewCartCount(String count) {
    return 'Xem các mặt hàng trong giỏ hàng ($count)';
  }

  @override
  String get learningGoToCart => 'Đi tới giỏ hàng';

  @override
  String get playerLessonMarkedCompleted =>
      'Bài học được đánh dấu là đã hoàn thành ✓';

  @override
  String get playerLessonMarkedIncomplete =>
      'Bài học được đánh dấu là chưa hoàn thành';

  @override
  String get playerCommentPostedSuccess => 'Bình luận được đăng thành công';

  @override
  String get playerCommentPostFailed => 'Không thể đăng bình luận';

  @override
  String get playerReplyPostedSuccess => 'Trả lời đã đăng thành công';

  @override
  String get playerReplyPostFailed => 'Không thể gửi câu trả lời';

  @override
  String get playerCourseNotFound => 'Không tìm thấy khóa học';

  @override
  String get playerCheckEnrollmentPrompt =>
      'Vui lòng xác minh đăng ký khóa học của bạn trước';

  @override
  String get playerReturnToCourses => 'Học tập của tôi';

  @override
  String get playerWatchLecture => 'Bài giảng khóa học';

  @override
  String get playerCertificateTooltip => 'Giấy chứng nhận';

  @override
  String get playerRateCourseTooltip => 'Đánh giá khóa học';

  @override
  String get playerReadingArticleBadge => 'Đọc bài viết • 5 phút';

  @override
  String get playerReadFullTextBelow => 'Đọc toàn văn bên dưới ↓';

  @override
  String get playerTabReviews => 'Đánh giá';

  @override
  String get playerNoSectionsAvailable => 'Không có phần nào có sẵn';

  @override
  String playerLessonsCount(String count) {
    return '$count bài học';
  }

  @override
  String get playerPlayingBadge => 'Đang chơi';

  @override
  String get playerArticleBadge => 'Bài báo';

  @override
  String get playerVideoBadge => 'Băng hình';

  @override
  String get playerFullArticleContent => 'Nội dung bài viết đầy đủ';

  @override
  String get playerArticlePlaceholder =>
      'Chào mừng bạn đến với bài đọc này.\n\nPhần này bao gồm các khái niệm cốt lõi và các bước thực tế mà bạn cần để nắm vững các kỹ năng trong bài học này.';

  @override
  String get playerAboutCourseTitle => 'Giới thiệu về khóa học này';

  @override
  String get playerShowLess => 'Hiển thị ít hơn';

  @override
  String get playerReadMore => 'Đọc thêm';

  @override
  String get playerWhatYouWillLearn => 'Bạn sẽ học được gì';

  @override
  String get playerCourseInfoTitle => 'Chi tiết khóa học';

  @override
  String get playerTotalDurationTitle => 'Tổng thời lượng';

  @override
  String get playerTotalLessonsTitle => 'Tổng số bài học';

  @override
  String playerLessonsNumber(String count) {
    return '$count bài học';
  }

  @override
  String get playerLevelTitle => 'Mức độ';

  @override
  String get playerAllLevels => 'Tất cả các cấp độ';

  @override
  String get playerLanguageTitle => 'Ngôn ngữ';

  @override
  String get playerLanguageArabic => 'tiếng Ả Rập';

  @override
  String get playerPrerequisitesTitle => 'Yêu cầu khóa học';

  @override
  String get playerCertificateCardTitle => 'Chứng chỉ khóa học';

  @override
  String get playerCourseCompletedSuccess =>
      'Chúc mừng! Khóa học đã hoàn thành';

  @override
  String get playerProgressLabel => 'Tiến triển';

  @override
  String get playerViewCertificateBtn => 'Xem chứng chỉ';

  @override
  String get playerCertifiedInstructor => 'Giảng viên được chứng nhận';

  @override
  String playerDiscussionsCount(String count) {
    return '$count câu hỏi và thảo luận';
  }

  @override
  String get playerAskQuestionHint =>
      'Nhập câu hỏi hoặc truy vấn của bạn vào đây...';

  @override
  String get playerPostBtn => 'Bưu kiện';

  @override
  String get playerNoDiscussionsTitle => 'Chưa có cuộc thảo luận nào';

  @override
  String get playerNoDiscussionsSubtitle =>
      'Hãy là người đầu tiên đặt câu hỏi!';

  @override
  String get playerInstructorBadge => 'Người hướng dẫn';

  @override
  String get playerCancelReply => 'Hủy bỏ';

  @override
  String get playerReplyAction => 'Hồi đáp';

  @override
  String playerRepliesCount(String count) {
    return '$count trả lời';
  }

  @override
  String get playerWriteReplyHint => 'Viết câu trả lời của bạn...';

  @override
  String get playerSendReplyBtn => 'Hồi đáp';

  @override
  String get playerCourseFeedbackTitle => 'Đánh giá và phản hồi khóa học';

  @override
  String get playerOutOf5 => 'trên 5';

  @override
  String playerRatingsFromEnrolledCount(String count) {
    return '$count xếp hạng từ các sinh viên đã đăng ký';
  }

  @override
  String get playerKeepLearningToRate => 'Tiếp tục học cách đánh giá';

  @override
  String get playerRateAfter80Hint =>
      'Bạn có thể xem lại và đánh giá khóa học này sau khi hoàn thành 80% nội dung của nó';

  @override
  String get playerCurrentProgressLabel => 'Sự tiến bộ của bạn:';

  @override
  String get playerYourCurrentRating => 'Đánh giá của bạn';

  @override
  String get playerEditRating => 'Chỉnh sửa xếp hạng';

  @override
  String get playerDeleteRatingTooltip => 'Xóa xếp hạng';

  @override
  String get playerUpdateRatingTitle => 'Cập nhật xếp hạng của bạn';

  @override
  String get playerRateCourseTitle => 'Đánh giá khóa học này';

  @override
  String get playerWriteReviewHint =>
      'Viết phản hồi và suy nghĩ của bạn về chất lượng nội dung (tùy chọn)...';

  @override
  String get playerRatingSubmitSuccess => 'Đã gửi đánh giá thành công!';

  @override
  String get playerRatingSubmitFailed => 'Không thể gửi xếp hạng';

  @override
  String get playerSaveChangesBtn => 'Lưu thay đổi';

  @override
  String get playerSubmitReviewBtn => 'Gửi đánh giá';

  @override
  String get playerLearnerReviewsTitle => 'Đánh giá của người học';

  @override
  String playerReviewsCount(String count) {
    return '$count bài đánh giá';
  }

  @override
  String get playerNoWrittenReviewsTitle => 'Chưa có đánh giá bằng văn bản nào';

  @override
  String get playerNoWrittenReviewsSubtitle =>
      'Hãy là người đầu tiên chia sẻ suy nghĩ của bạn!';

  @override
  String get playerRatingLabel5 => 'Tuyệt vời 🌟 (5/5)';

  @override
  String get playerRatingLabel4 => 'Rất tốt 👍 (4/5)';

  @override
  String get playerRatingLabel3 => 'Trung bình 👌 (3/5)';

  @override
  String get playerRatingLabel2 => 'Cần cải thiện 🤔 (2/5)';

  @override
  String get playerRatingLabel1 => 'Nghèo 👎 (1/5)';

  @override
  String get playerDeleteRatingDialogTitle => 'Xóa xếp hạng';

  @override
  String get playerDeleteRatingDialogMessage =>
      'Bạn có chắc chắn muốn xóa bài đánh giá của mình cho khóa học này không?';

  @override
  String get playerDeleteConfirmBtn => 'Xóa bỏ';

  @override
  String get playerRatingDeleteSuccess => 'Đã xóa xếp hạng thành công';

  @override
  String get playerPreviousLesson => 'Bài học trước';

  @override
  String get playerExitFullscreenTooltip => 'Thoát toàn màn hình';

  @override
  String instructorsAvailableCount(String count) {
    return '$count người hướng dẫn có sẵn';
  }

  @override
  String get instructorsNotFound => 'Không tìm thấy người hướng dẫn';

  @override
  String instructorsCoursesCount(String count) {
    return '$count khóa học';
  }

  @override
  String get instructorsSearchHint =>
      'Tìm kiếm theo tên người hướng dẫn hoặc chuyên ngành...';

  @override
  String get instructorsSortAll => 'Tất cả';

  @override
  String get instructorsSortTopRated => 'được xếp hạng hàng đầu';

  @override
  String get instructorsSortMostStudents => 'Hầu hết sinh viên';

  @override
  String get instructorsSortMostCourses => 'Hầu hết các khóa học';

  @override
  String get instructorsNotFoundSubtitle =>
      'Hãy thử tìm kiếm bằng tên khác hoặc xóa bộ lọc';

  @override
  String get exploreCompleteCourse => 'Khóa học tổng hợp';

  @override
  String get exploreGeneralCategory => 'Tổng quan';

  @override
  String courseShareMessage(String title, String url) {
    return 'Tham khảo khóa học \"$title\" trên EduLab: $url';
  }

  @override
  String get courseDetailsDefaultTitle => 'Chi tiết khóa học';

  @override
  String get courseDetailsTooltipShare => 'Chia sẻ';

  @override
  String get courseDetailsTooltipWishlist => 'Danh sách yêu thích';

  @override
  String get courseDetailsTooltipCart => 'Xe đẩy';

  @override
  String get courseDetailsNotFound => 'Không tìm thấy khóa học';

  @override
  String get courseDetailsDefaultCategory => 'Khóa học';

  @override
  String courseDetailsTotalRatingsCount(String count) {
    return '($count xếp hạng)';
  }

  @override
  String courseDetailsLecturesCount(String count) {
    return '$count bài giảng';
  }

  @override
  String get courseDetailsCertificateBadge => 'Giấy chứng nhận';

  @override
  String get courseDetailsTabOverview => 'Tổng quan';

  @override
  String get courseDetailsTabCurriculum => 'Chương trình giảng dạy';

  @override
  String get courseDetailsTabInstructor => 'Người hướng dẫn';

  @override
  String get courseDetailsTabReviews => 'Đánh giá';

  @override
  String get courseDetailsFullDescriptionTitle => 'Sự miêu tả';

  @override
  String get courseDetailsShowLess => 'Hiển thị ít hơn';

  @override
  String get courseDetailsShowMore => 'Hiển thị thêm...';

  @override
  String courseDetailsCurriculumSectionsLectures(
    String sections,
    String lectures,
  ) {
    return '$sections phần • $lectures bài giảng';
  }

  @override
  String get courseDetailsCollapseAll => 'Thu gọn tất cả';

  @override
  String get courseDetailsExpandAll => 'Mở rộng tất cả';

  @override
  String get courseDetailsCurriculumComingSoon =>
      'Thông tin chi tiết về chương trình giảng dạy sắp ra mắt';

  @override
  String courseDetailsSectionLecturesCount(String count) {
    return '$count bài giảng';
  }

  @override
  String get courseDetailsLecturePreviewBtn => 'Xem trước';

  @override
  String get courseDetailsDefaultInstructorTitle =>
      'Giảng viên cao cấp & Chuyên gia được chứng nhận';

  @override
  String get courseDetailsInstructorRatingLabel => 'Đánh giá';

  @override
  String get courseDetailsInstructorStudentsLabel => 'Sinh viên';

  @override
  String get courseDetailsInstructorSectionsLabel => 'Phần';

  @override
  String get courseDetailsAboutInstructorTitle => 'Về Giảng viên:';

  @override
  String get courseDetailsDefaultInstructorAbout =>
      'Giảng viên được chứng nhận có nhiều kinh nghiệm trong việc cung cấp giáo dục chuyên nghiệp cho hàng nghìn sinh viên trên toàn thế giới.';

  @override
  String courseDetailsStudentRatingsCount(String count) {
    return '$count xếp hạng của sinh viên';
  }

  @override
  String get courseDetailsNoWrittenReviews =>
      'Chưa có đánh giá bằng văn bản nào';

  @override
  String get courseDetailsRelatedCourses =>
      'Các khóa học liên quan bạn có thể thích';

  @override
  String courseDetailsDiscountPercent(String percent) {
    return '$percent% GIẢM GIÁ';
  }

  @override
  String get courseDetailsResumeCourse => 'Tiếp tục khóa học';

  @override
  String get courseDetailsTryAgain => 'Thử lại';

  @override
  String get courseDetailsEstimatedReading =>
      '📖 Thời gian đọc dự kiến: 4 phút';

  @override
  String get courseDetailsSampleArticleContent =>
      'Chào mừng bạn đến với bài giảng này.\n\nPhần này bao gồm các khái niệm lý thuyết chính và các bước thực hành để nắm vững chủ đề.\n\n• Những điểm chính:\n1. Nắm bắt các thuật ngữ cốt lõi và các mẫu kiến trúc.\n2. Bài tập thực hành và thực hành liên tục.\n3. Tham khảo ghi chú và bài tập bổ sung.\n\nChúc bạn đọc vui vẻ!';

  @override
  String certDownloadedSuccess(String course, String format) {
    return 'Đã tải xuống thành công chứng chỉ cho \"$course\" ở định dạng $format!';
  }

  @override
  String certVerifiedFullRequirements(String code) {
    return 'ID xác minh: $code • Đã hoàn thành 100% yêu cầu';
  }

  @override
  String get certCompletionTitle => 'Giấy chứng nhận hoàn thành';

  @override
  String get certCompletionSubtitle => 'Giấy chứng nhận hoàn thành khóa học';

  @override
  String get certAnnounceStudent =>
      'Học viện EducationLab dưới đây xác nhận rằng:';

  @override
  String get certCompletionRequirementsMet =>
      'Đã hoàn thành tốt tất cả các yêu cầu của khóa đào tạo:';

  @override
  String certIssueDateText(String date) {
    return 'Ngày phát hành: $date';
  }

  @override
  String certIdNumberText(String code) {
    return 'ID chứng chỉ: $code';
  }

  @override
  String get certPlatformManagement => 'Quản lý nền tảng';

  @override
  String get certInstructorRoleTitle => 'Giảng viên khóa học';

  @override
  String get commonLoading => 'Đang tải...';

  @override
  String get homeGuestTagline =>
      'Nền tảng học tập và xây dựng kỹ năng thông minh';

  @override
  String get catTagHighestDemand => 'Nhu cầu cao nhất';

  @override
  String get catTagMostPopular => 'Phổ biến nhất';

  @override
  String get catTagTrending => 'Xu hướng';

  @override
  String get catTagFastestGrowing => 'Phát triển nhanh nhất';

  @override
  String get catTagHighDemand => 'Nhu cầu cao';

  @override
  String get catTagTopRated => 'Đánh giá cao nhất';

  @override
  String get catTagEssential => 'Rất quan trọng';

  @override
  String get catTagAdvanced => 'Nâng cao';

  @override
  String get catTagEntrepreneurs => 'Doanh nhân';

  @override
  String get catTagSalesGrowth => 'Tăng trưởng doanh số';

  @override
  String get catDevTitle => 'Lập trình & Phát triển Phần mềm';

  @override
  String get catDevSubtitle => 'Kỹ thuật phần mềm, hệ thống & thuật toán';

  @override
  String get catWebTitle => 'Phát triển Web';

  @override
  String get catWebSubtitle => 'Frontend, Backend & Fullstack Web';

  @override
  String get catMobileTitle => 'Phát triển Ứng dụng Di động';

  @override
  String get catMobileSubtitle => 'Ứng dụng Flutter, iOS & Android';

  @override
  String get catAiTitle => 'Trí tuệ Nhân tạo';

  @override
  String get catAiSubtitle => 'Học máy, Học sâu & AI';

  @override
  String get catDataTitle => 'Khoa học Dữ liệu & Phân tích';

  @override
  String get catDataSubtitle => 'Phân tích dữ liệu, thống kê & Big Data';

  @override
  String get catDesignTitle => 'Thiết kế UI/UX & Sản phẩm';

  @override
  String get catDesignSubtitle => 'UI/UX, tạo mẫu & thiết kế sản phẩm';

  @override
  String get catSecurityTitle => 'An ninh mạng & Hệ thống mạng';

  @override
  String get catSecuritySubtitle => 'An toàn thông tin, Ethical Hacking & Mạng';

  @override
  String get catCloudTitle => 'Điện toán Đám mây & DevOps';

  @override
  String get catCloudSubtitle => 'Hạ tầng đám mây, DevOps & CI/CD';

  @override
  String get catBusinessTitle => 'Kinh doanh & Quản lý Dự án';

  @override
  String get catBusinessSubtitle => 'Khởi nghiệp, Agile & Lãnh đạo';

  @override
  String get catMarketingTitle => 'Tiếp thị Kỹ thuật số';

  @override
  String get catMarketingSubtitle =>
      'Digital Marketing, SEO & Chiến lược tăng trưởng';

  @override
  String get timeJustNow => 'Vừa xong';

  @override
  String timeMinutesAgo(String count) {
    return '$count phút trước';
  }

  @override
  String timeHoursAgo(String count) {
    return '$count giờ trước';
  }

  @override
  String timeDaysAgo(String count) {
    return '$count ngày trước';
  }

  @override
  String timeWeeksAgo(String count) {
    return '$count tuần trước';
  }

  @override
  String timeMonthsAgo(String count) {
    return '$count tháng trước';
  }

  @override
  String wishlistLecturesCount(String count) {
    return '$count bài giảng';
  }

  @override
  String get instructorProfileTitle => 'Hồ sơ giảng viên';

  @override
  String instructorProfileLinkCopied(String name) {
    return 'Đã sao chép liên kết của $name vào khay nhớ tạm';
  }

  @override
  String get instructorDefaultName => 'Giảng viên';

  @override
  String get instructorProfileBadge => 'GIẢNG VIÊN';

  @override
  String get instructorProfileTotalStudents => 'Tổng số học viên';

  @override
  String get instructorProfileRating => 'Đánh giá giảng viên';

  @override
  String get instructorProfileCourses => 'Khóa học';

  @override
  String get instructorProfileShare => 'Chia sẻ hồ sơ';

  @override
  String get instructorProfileLinkOpenError =>
      'Không thể mở liên kết, đã sao chép vào khay nhớ tạm';

  @override
  String get instructorProfileWebsite => 'Trang web';

  @override
  String get instructorProfileAboutMe => 'Giới thiệu bản thân';

  @override
  String get instructorProfileShowLess => 'Hiển thị ít hơn';

  @override
  String get instructorProfileShowMore => 'Hiển thị thêm';

  @override
  String get instructorProfileExpertise => 'Lĩnh vực chuyên môn';

  @override
  String get instructorProfileSortAll => 'Tất cả';

  @override
  String get instructorProfileSortTopRated => 'Đánh giá cao nhất';

  @override
  String get instructorProfileSortPopular => 'Phổ biến nhất';

  @override
  String get instructorProfileSortNewest => 'Mới nhất';

  @override
  String get instructorProfileCoursesTitle => 'Khóa học của giảng viên';

  @override
  String get instructorProfileNoCoursesFilter =>
      'Không tìm thấy khóa học nào cho bộ lọc này';

  @override
  String instructorProfileLoadMoreCourses(String count) {
    return 'Tải thêm khóa học (còn $count)';
  }

  @override
  String get instructorProfileLoadingMoreCourses => 'Đang tải thêm khóa học...';

  @override
  String instructorProfileAllCoursesLoaded(String count) {
    return 'Đã tải tất cả $count khóa học';
  }

  @override
  String get instructorProfileStudentFeedback => 'Phản hồi từ học viên';

  @override
  String instructorProfileReviewsCount(String count) {
    return '$count đánh giá';
  }

  @override
  String instructorProfileBasedOnReviews(String count) {
    return 'Dựa trên $count đánh giá';
  }

  @override
  String get instructorProfileRecentReviews => 'Đánh giá gần đây';

  @override
  String instructorProfileLoadMoreReviews(String count) {
    return 'Tải thêm đánh giá (còn $count)';
  }

  @override
  String get instructorProfileLoadingMoreReviews => 'Đang tải thêm đánh giá...';

  @override
  String instructorProfileAllReviewsLoaded(String count) {
    return 'Đã tải tất cả $count đánh giá';
  }

  @override
  String get instructorProfileNoReviewsYet =>
      'Chưa có đánh giá bằng văn bản nào';

  @override
  String get instructorProfileRatingDesc =>
      'Điểm đánh giá dựa trên toàn bộ đánh giá của học viên trên các khóa học của giảng viên';

  @override
  String get instructorProfileLoadError =>
      'Không thể tải thông tin chi tiết giảng viên, vui lòng thử lại sau';

  @override
  String get instructorProfileDefaultStudentName => 'Học viên';

  @override
  String get instructorProfileDefaultHeadline =>
      'Giảng viên cao cấp & Chuyên gia được chứng nhận';

  @override
  String get instructorProfileDefaultBio =>
      'Kỹ sư phần mềm và giảng viên kỹ thuật được chứng nhận với nhiều kinh nghiệm trong việc xây dựng các hệ thống phần mềm có khả năng mở rộng và ứng dụng di động.\nĐã đào tạo hàng ngàn học viên và kỹ sư trên toàn cầu, mang đến nội dung chuyên nghiệp tập trung vào clean code, kiến trúc sạch và các giải pháp hiện đại có khả năng mở rộng.';

  @override
  String get supportNewChat => 'Đoạn chat mới';

  @override
  String get supportNoChatsTitle => 'Chưa có đoạn chat hỗ trợ nào';

  @override
  String get supportNoChatsDesc =>
      'Đội ngũ hỗ trợ của chúng tôi luôn sẵn sàng 24/7 để giải đáp mọi thắc mắc của bạn';

  @override
  String get supportStartNewConversation => 'Bắt đầu cuộc trò chuyện mới';

  @override
  String get supportNoMessagesYet => 'Chưa có tin nhắn nào';

  @override
  String get supportRetry => 'Thử lại';

  @override
  String get supportOpenTicket => 'Yêu cầu đang mở';

  @override
  String get supportClosedTicket => 'Yêu cầu đã đóng';

  @override
  String get supportCloseAction => 'Đóng';

  @override
  String get supportReopenAction => 'Mở lại';

  @override
  String get supportNoMessagesInChat =>
      'Chưa có tin nhắn nào trong đoạn chat này';

  @override
  String get supportYou => 'Bạn';

  @override
  String get supportTeam => 'Đội ngũ hỗ trợ';

  @override
  String get supportTypeMessageHint => 'Nhập tin nhắn của bạn tại đây...';

  @override
  String get supportConversationClosedNotice =>
      'Cuộc trò chuyện này hiện đã được đóng.';

  @override
  String get supportCloseDialogTitle => 'Đóng cuộc trò chuyện?';

  @override
  String get supportCloseDialogDesc =>
      'Bạn có chắc chắn muốn đóng đoạn chat này không? Bạn có thể mở lại bất cứ lúc nào để tiếp tục nhắn tin.';

  @override
  String get supportCancel => 'Hủy';

  @override
  String get supportYesClose => 'Có, đóng';

  @override
  String get supportNewChatTitle => 'Đoạn chat hỗ trợ mới';

  @override
  String get supportNewChatSubtitle =>
      'Đội ngũ của chúng tôi luôn sẵn sàng giúp đỡ bạn';

  @override
  String get supportSubjectLabel => 'Chủ đề';

  @override
  String get supportSubjectHint => 'VD: Hỏi về khóa học, Vấn đề thanh toán...';

  @override
  String get supportMessageLabel => 'Tin nhắn';

  @override
  String get supportMessageHint =>
      'Mô tả chi tiết câu hỏi hoặc vấn đề của bạn...';

  @override
  String get supportMessageRequired => 'Vui lòng nhập tin nhắn';

  @override
  String get supportStartConversationBtn => 'Bắt đầu trò chuyện';

  @override
  String get supportCreateError =>
      'Không thể tạo cuộc trò chuyện, vui lòng thử lại sau';

  @override
  String get supportTopicCourse => 'Hỏi về khóa học';

  @override
  String get supportTopicPayment => 'Vấn đề thanh toán';

  @override
  String get supportTopicCertificates => 'Chứng chỉ';

  @override
  String get supportTopicTech => 'Vấn đề kỹ thuật';

  @override
  String get supportTopicGeneral => 'Thắc mắc chung';

  @override
  String get cartGuestTitle => 'Đăng nhập để xem giỏ hàng của bạn';

  @override
  String get cartGuestSubtitle =>
      'Vui lòng đăng nhập để truy cập giỏ hàng và tiếp tục thanh toán khóa học.';

  @override
  String get wishlistGuestTitle => 'Đăng nhập để xem danh sách yêu thích';

  @override
  String get wishlistGuestSubtitle =>
      'Vui lòng đăng nhập để theo dõi các khóa học bạn yêu thích bất cứ lúc nào.';

  @override
  String get courseDetailsLoginRequiredTitle => 'Yêu cầu đăng nhập';

  @override
  String get courseDetailsLoginRequiredDesc =>
      'Bạn phải đăng nhập trước để mua khóa học này và lưu tiến trình học tập của mình.';

  @override
  String get courseDetailsProceedToLogin => 'Chuyển đến đăng nhập';

  @override
  String get messagesGuestTitle => 'Đăng nhập để xem tin nhắn';

  @override
  String get messagesGuestSubtitle =>
      'Vui lòng đăng nhập để truy cập các cuộc trò chuyện hỗ trợ.';

  @override
  String get notificationsGuestTitle => 'Đăng nhập để xem thông báo';

  @override
  String get notificationsGuestSubtitle =>
      'Vui lòng đăng nhập để xem các cập nhật và thông báo mới nhất cho tài khoản và khóa học của bạn.';

  @override
  String get legalTitle => 'Giới thiệu & Pháp lý';

  @override
  String get legalTabAbout => 'Về EduLab';

  @override
  String get legalTabPrivacy => 'Quyền riêng tư';

  @override
  String get legalTabTerms => 'Điều khoản';

  @override
  String get legalUpdated => 'Cập nhật:';

  @override
  String get legalNeedHelpTitle => 'Cần hỗ trợ hoặc có thắc mắc?';

  @override
  String get legalNeedHelpDesc =>
      'Đội ngũ hỗ trợ EduLab luôn sẵn sàng 24/7. Liên hệ trực tiếp qua email với chúng tôi.';

  @override
  String get legalEmailCopied =>
      'Email hỗ trợ đã được sao chép vào khay nhớ tạm';

  @override
  String get legalNoContent => 'Hiện chưa có nội dung';
}

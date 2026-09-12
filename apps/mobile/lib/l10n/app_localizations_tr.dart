// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get onboardingSkip => 'Atla';

  @override
  String get onboardingTitle1 => 'EduLab\'a Hoş Geldiniz';

  @override
  String get onboardingSubtitle1 =>
      'Modern etkileşimli öğrenim ve sürekli kariyer gelişimi için ideal platformunuz.';

  @override
  String get onboardingTitle2 => 'En iyi eğitmenlerden öğrenin';

  @override
  String get onboardingSubtitle2 =>
      'Yazılım, tasarım, işletme ve veri biliminde binlerce profesyonel kurs.';

  @override
  String get onboardingTitle3 => 'Sertifikalar ve garantili başarı';

  @override
  String get onboardingSubtitle3 =>
      'İlerlemenizi takip edin, sınavları geçin ve geçerli sertifikalar kazanın.';

  @override
  String get onboardingNext => 'İleri';

  @override
  String get onboardingStart => 'Hemen Başla';

  @override
  String get splashAppName => 'Education Lab';

  @override
  String get splashTagline => 'Akıllı Öğrenme Platformu';

  @override
  String get loginTagline => 'Akıllı öğrenme platformuna hoş geldiniz';

  @override
  String get loginAppName => 'EduLab';

  @override
  String get loginTabLogin => 'Giriş Yap';

  @override
  String get loginTabRegister => 'Kayıt Ol';

  @override
  String get loginEmailLabel => 'E-posta';

  @override
  String get loginEmailHint => 'ornek@email.com';

  @override
  String get loginPasswordLabel => 'Şifre';

  @override
  String get loginPasswordHint => '••••••';

  @override
  String get loginForgotPassword => 'Şifrenizi mi unuttunuz?';

  @override
  String get loginSubmit => 'Giriş Yap';

  @override
  String get loginSubmitLoading => 'Giriş yapılıyor';

  @override
  String get loginGuest => 'Misafir olarak devam et';

  @override
  String get loginOr => 'veya';

  @override
  String get loginEmailRequired => 'E-posta alanı zorunludur';

  @override
  String get loginEmailInvalid => 'Geçerli bir e-posta adresi girin';

  @override
  String get loginPasswordRequired => 'Şifre alanı zorunludur';

  @override
  String get registerStepEmail => 'E-posta';

  @override
  String get registerStepCode => 'Kod';

  @override
  String get registerStepData => 'Bilgiler';

  @override
  String get registerSendCodeInfo =>
      'Bu e-posta adresine bir doğrulama kodu göndereceğiz';

  @override
  String get registerSendCode => 'Doğrulama Kodu Gönder';

  @override
  String get registerVerifying => 'Doğrulanıyor';

  @override
  String get registerCodeSentTo => 'Kod gönderildi:';

  @override
  String get registerResendCode => 'Kodu Tekrar Gönder';

  @override
  String get registerBack => 'Geri';

  @override
  String get registerVerifyCode => 'Kodu Doğrula';

  @override
  String get registerCodeIncomplete => '6 haneli kodu eksiksiz girin';

  @override
  String get registerFullNameLabel => 'Ad Soyad';

  @override
  String get registerFullNameHint => 'Adınız ve soyadınız';

  @override
  String get registerPasswordHint =>
      'En az 8 karakter, bir büyük harf ve bir rakam';

  @override
  String get registerConfirmLabel => 'Şifreyi Onayla';

  @override
  String get registerConfirmHint => 'Şifrenizi tekrar girin';

  @override
  String get registerSubmit => 'Hesap Oluştur';

  @override
  String get registerSubmitLoading => 'Hesap oluşturuluyor';

  @override
  String get registerSuccess => 'Hesap başarıyla oluşturuldu';

  @override
  String get registerNameRequired => 'Ad Soyad zorunludur';

  @override
  String get registerNameMinLength => 'Ad Soyad en az 6 karakter olmalıdır';

  @override
  String get registerPasswordMinLength => 'Şifre en az 8 karakter olmalıdır';

  @override
  String get registerPasswordUppercase =>
      'Şifre en az bir büyük harf içermelidir';

  @override
  String get registerPasswordNumber => 'Şifre en az bir rakam içermelidir';

  @override
  String get registerConfirmRequired => 'Şifre onayı zorunludur';

  @override
  String get registerConfirmMismatch => 'Şifreler eşleşmiyor';

  @override
  String get networkError => 'Bağlantı hatası, lütfen tekrar deneyin';

  @override
  String homeGreeting(String name) {
    return 'Merhaba, $name!';
  }

  @override
  String get homeSubtitle => 'Bugün ne öğrenmek istersiniz?';

  @override
  String get homeSearchHint => 'Kurs veya beceri ara...';

  @override
  String get homeSectionContinue => 'Öğrenmeye Devam Et';

  @override
  String get homeSectionRecommended => 'Sizin İçin Önerilenler';

  @override
  String get homeSectionPopular => 'En Popüler Kurslar';

  @override
  String get homeSectionTopRated => 'En Yüksek Puanlılar';

  @override
  String get homeSectionByCategory => 'Kategoriye Göre';

  @override
  String get homeHeroTitle => 'Fırsatları Keşfedin';

  @override
  String get homeHeroSubtitle => 'Popüler kurslarda %70\'e varan indirim';

  @override
  String get homeHeroButton => 'Şimdi Keşfet';

  @override
  String get homeViewAll => 'Tümünü Gör';

  @override
  String get homeProgressLabel => 'Tamamlandı';

  @override
  String get exploreTitle => 'Kursları Keşfet';

  @override
  String get exploreSearchHint => 'Kurs, beceri veya eğitmen ara...';

  @override
  String get exploreAllCategories => 'Tüm Kategoriler';

  @override
  String get exploreFilter => 'Filtrele';

  @override
  String get exploreSort => 'Sırala';

  @override
  String get exploreNoResults => 'Sonuç bulunamadı';

  @override
  String get exploreNoResultsHint =>
      'Farklı anahtar kelimeler deneyin veya filtreleri değiştirin';

  @override
  String exploreCoursesCount(int count) {
    return '$count kurs';
  }

  @override
  String get exploreFilterTitle => 'Sonuçları Filtrele';

  @override
  String get exploreFilterApply => 'Filtreyi Uygula';

  @override
  String get exploreFilterReset => 'Sıfırla';

  @override
  String get exploreFilterPrice => 'Fiyat';

  @override
  String get exploreFilterLevel => 'Seviye';

  @override
  String get exploreFilterRating => 'Puan';

  @override
  String get exploreFilterDuration => 'Süre';

  @override
  String get exploreSortTitle => 'Sıralama Ölçütü';

  @override
  String get exploreSortRelevance => 'En İlgili';

  @override
  String get exploreSortNewest => 'En Yeni';

  @override
  String get exploreSortPopular => 'En Popüler';

  @override
  String get exploreSortRating => 'En Yüksek Puan';

  @override
  String get exploreSortPriceLow => 'Fiyat: Düşükten Yükseğe';

  @override
  String get exploreSortPriceHigh => 'Fiyat: Yüksekten Düşüğe';

  @override
  String get explorePriceFree => 'Ücretsiz';

  @override
  String get exploreLevelBeginner => 'Başlangıç';

  @override
  String get exploreLevelIntermediate => 'Orta Seviye';

  @override
  String get exploreLevelAdvanced => 'İleri Seviye';

  @override
  String get learningTitle => 'Öğrenimim';

  @override
  String get learningTabInProgress => 'Devam Edenler';

  @override
  String get learningTabCompleted => 'Tamamlananlar';

  @override
  String get learningTabSaved => 'Kaydedilenler';

  @override
  String get learningEmpty => 'Henüz kursunuz yok';

  @override
  String get learningEmptyHint => 'Hemen yeni kurslar keşfetmeye başlayın';

  @override
  String get learningExploreButton => 'Kursları Keşfet';

  @override
  String learningProgress(int percent) {
    return '%$percent tamamlandı';
  }

  @override
  String get learningContinue => 'Devam Et';

  @override
  String get learningViewCertificate => 'Sertifikayı Görüntüle';

  @override
  String get learningReview => 'Kursu Değerlendir';

  @override
  String get learningLesson => 'Ders';

  @override
  String get learningLessons => 'Dersler';

  @override
  String get cartTitle => 'Sepet';

  @override
  String get cartEmpty => 'Sepetiniz boş';

  @override
  String get cartEmptyHint => 'Öğrenmeye başlamak için kurs ekleyin';

  @override
  String get cartExploreButton => 'Kursları Keşfet';

  @override
  String get cartPromoPlaceholder => 'İndirim kodu';

  @override
  String get cartPromoApply => 'Uygula';

  @override
  String get cartPromoInvalid => 'Geçersiz indirim kodu';

  @override
  String get cartSummary => 'Sipariş Özeti';

  @override
  String get cartSubtotal => 'Ara Toplam';

  @override
  String get cartDiscount => 'İndirim';

  @override
  String get cartTotal => 'Toplam';

  @override
  String get cartCheckout => 'Ödemeye Geç';

  @override
  String cartCourses(int count) {
    return '$count kurs';
  }

  @override
  String get cartRemove => 'Kaldır';

  @override
  String get cartGuarantee => '30 Günlük Para İade Garantisi';

  @override
  String get checkoutTitle => 'Ödeme';

  @override
  String get checkoutStepPayment => 'Ödeme';

  @override
  String get checkoutStepReview => 'İnceleme';

  @override
  String get checkoutStepConfirm => 'Onay';

  @override
  String get checkoutOrderSummary => 'Sipariş Özeti';

  @override
  String get checkoutTotal => 'Toplam';

  @override
  String get checkoutPayNow => 'Şimdi Öde';

  @override
  String get checkoutBack => 'Geri';

  @override
  String get checkoutNext => 'İleri';

  @override
  String get checkoutSecureSSL => '256-bit SSL şifreleme ile güvenli ödeme';

  @override
  String get checkoutSuccessTitle => 'Satın Alma Başarılı!';

  @override
  String get checkoutSuccessSubtitle => 'Artık kursunuza erişebilirsiniz';

  @override
  String get checkoutGoToLearning => 'Kurslarıma Git';

  @override
  String get checkoutPaymentMethod => 'Ödeme Yöntemi';

  @override
  String get checkoutCardNumber => 'Kart Numarası';

  @override
  String get checkoutCardName => 'Kart Üzerindeki İsim';

  @override
  String get checkoutCardExpiry => 'Son Kullanma Tarihi';

  @override
  String get checkoutCardCVV => 'CVV';

  @override
  String get courseDetailsEnroll => 'Hemen Kaydol';

  @override
  String get courseDetailsBuyNow => 'Şimdi Satın Al';

  @override
  String get courseDetailsAddToCart => 'Sepete Ekle';

  @override
  String get courseDetailsAddedToCart => 'Sepete Eklendi';

  @override
  String get courseDetailsAlreadyEnrolled => 'Zaten Kayıtlısınız';

  @override
  String get courseDetailsGoToCourse => 'Kursa Git';

  @override
  String get courseDetailsFree => 'Ücretsiz';

  @override
  String courseDetailsStudents(String count) {
    return '$count öğrenci';
  }

  @override
  String get courseDetailsRating => 'Puan';

  @override
  String get courseDetailsReviews => 'değerlendirme';

  @override
  String get courseDetailsLastUpdated => 'Son Güncelleme';

  @override
  String get courseDetailsCurriculum => 'Kurs İçeriği';

  @override
  String get courseDetailsSection => 'bölüm';

  @override
  String get courseDetailsLessons => 'ders';

  @override
  String get courseDetailsInstructor => 'Eğitmen';

  @override
  String get courseDetailsStudentsLabel => 'Öğrenci';

  @override
  String get courseDetailsCoursesLabel => 'Kurs';

  @override
  String get courseDetailsReviewsLabel => 'Değerlendirme';

  @override
  String get courseDetailsReviewsTitle => 'Öğrenci Değerlendirmeleri';

  @override
  String get courseDetailsWhatLearn => 'Neler Öğreneceksiniz';

  @override
  String get courseDetailsRequirements => 'Gereksinimler';

  @override
  String get courseDetailsDescription => 'Kurs Açıklaması';

  @override
  String get courseDetailsIncludesTitle => 'Bu Kursun İçeriği';

  @override
  String get courseDetailsHoursVideo => 'saat video';

  @override
  String get courseDetailsArticles => 'makale';

  @override
  String get courseDetailsMobileAccess => 'Mobil ve tabletten erişim';

  @override
  String get courseDetailsCertificate => 'Bitirme sertifikası';

  @override
  String get courseDetailsLifetimeAccess => 'Ömür boyu erişim';

  @override
  String get lessonPlayerNotes => 'Notlarım';

  @override
  String get lessonPlayerResources => 'Kaynaklar';

  @override
  String get lessonPlayerDiscussion => 'Tartışma';

  @override
  String get lessonPlayerPrev => 'Önceki';

  @override
  String get lessonPlayerNext => 'Sonraki';

  @override
  String get lessonPlayerSpeed => 'Hız';

  @override
  String get lessonPlayerQuality => 'Kalite';

  @override
  String get lessonPlayerCompleted => 'Ders tamamlandı';

  @override
  String get certificateTitle => 'Bitirme Sertifikası';

  @override
  String get certificatePresentedTo => 'Verilen Kişi';

  @override
  String get certificateCompletedCourse => 'kursunu başarıyla tamamladığı için';

  @override
  String get certificateIssuedOn => 'Veriliş Tarihi';

  @override
  String get certificateVerificationId => 'Sertifika No';

  @override
  String get certificateDownloadPDF => 'PDF İndir';

  @override
  String get certificateDownloadPNG => 'Resmi İndir';

  @override
  String get certificateCopyLink => 'Bağlantıyı Kopyala';

  @override
  String get certificateLinkCopied => 'Bağlantı kopyalandı';

  @override
  String get profileTitle => 'Profil';

  @override
  String get profileEditProfile => 'Profili Düzenle';

  @override
  String get profileCourses => 'Kurslarım';

  @override
  String get profileCertificates => 'Sertifikalar';

  @override
  String get profilePoints => 'Puan';

  @override
  String get profileFollowers => 'Takipçi';

  @override
  String get profileFollowing => 'Takip Edilen';

  @override
  String get profileBio => 'Biyografi';

  @override
  String get profileInstructor => 'Eğitmen';

  @override
  String get profileStudent => 'Öğrenci';

  @override
  String get profileLevel => 'Seviye';

  @override
  String get profileJoined => 'Katılma Tarihi';

  @override
  String get profileShareProfile => 'Profili Paylaş';

  @override
  String get profileMenuLearning => 'Kurslarım';

  @override
  String get profileMenuCertificates => 'Sertifikalarım';

  @override
  String get profileMenuPurchaseHistory => 'Satın Alma Geçmişi';

  @override
  String get profileMenuTeachApplication => 'EduLab\'da Eğitmen Olun';

  @override
  String get profileMenuAccountSecurity => 'Hesap Güvenliği';

  @override
  String get profileMenuNotifications => 'Bildirimler';

  @override
  String get profileMenuMessages => 'Mesajlar';

  @override
  String get profileMenuSettings => 'Ayarlar';

  @override
  String get profileMenuSchedule => 'Ders Programım';

  @override
  String get profileMenuAssignments => 'Ödevler';

  @override
  String get profileMenuQuiz => 'Sınavlar';

  @override
  String get profileMenuLogout => 'Çıkış Yap';

  @override
  String get profileLogoutConfirm =>
      'Çıkış yapmak istediğinizden emin misiniz?';

  @override
  String get profileLogoutYes => 'Evet, çıkış yap';

  @override
  String get profileLogoutNo => 'İptal';

  @override
  String get editProfileTitle => 'Profili Düzenle';

  @override
  String get editProfileSave => 'Değişiklikleri Kaydet';

  @override
  String get editProfileFullName => 'Ad Soyad';

  @override
  String get editProfileBio => 'Biyografi';

  @override
  String get editProfileEmail => 'E-posta';

  @override
  String get editProfilePhone => 'Telefon Numarası';

  @override
  String get editProfileWebsite => 'Web Sitesi';

  @override
  String get editProfileSaved => 'Değişiklikler başarıyla kaydedildi';

  @override
  String get accountSecurityTitle => 'Hesap Güvenliği';

  @override
  String get accountSecurityChangePassword => 'Şifre Değiştir';

  @override
  String get accountSecurityTwoFactor => 'İki Adımlı Doğrulama';

  @override
  String get accountSecurityActiveSessions => 'Aktif Oturumlar';

  @override
  String get accountSecurityDeleteAccount => 'Hesabı Sil';

  @override
  String get purchaseHistoryTitle => 'Satın Alma Geçmişi';

  @override
  String get purchaseHistoryEmpty => 'Henüz satın alma yok';

  @override
  String get purchaseHistoryGuarantee => '30 Günlük Para İade Garantisi';

  @override
  String get purchaseHistoryDate => 'İşlem Tarihi';

  @override
  String get purchaseHistoryStatus => 'Durum';

  @override
  String get purchaseHistoryAmount => 'Tutar';

  @override
  String get purchaseHistoryCompleted => 'Tamamlandı';

  @override
  String get purchaseHistoryRefunded => 'İade Edildi';

  @override
  String get teachApplicationTitle => 'EduLab\'da Eğitmen Olun';

  @override
  String get teachApplicationSubmit => 'Başvuruyu Gönder';

  @override
  String get teachApplicationSent => 'Başvurunuz başarıyla iletildi';

  @override
  String get notificationsTitle => 'Bildirimler';

  @override
  String get notificationsMarkAllRead => 'Tümünü okundu işaretle';

  @override
  String get notificationsMarkAllReadSnackbar =>
      'Tüm bildirimler okundu olarak işaretlendi';

  @override
  String get notificationsEmpty => 'Bildirim yok';

  @override
  String get notification1Title => 'Hatırlatma: Kursunuza devam edin';

  @override
  String get notification1Message =>
      'Flutter Başlangıç kursunda yeni bir dersiniz var';

  @override
  String get notification1Time => '5 dakika önce';

  @override
  String get notification1Action => 'Kursa devam et';

  @override
  String get notification2Title => 'Sertifikanız hazır!';

  @override
  String get notification2Message =>
      'UI/UX Tasarım kursunu başarıyla tamamladınız.';

  @override
  String get notification2Time => '2 saat önce';

  @override
  String get notification2Action => 'Sertifikayı gör';

  @override
  String get notification3Title => 'Size özel fırsat';

  @override
  String get notification3Message => 'Yazılım kurslarında %70 indirim';

  @override
  String get notification3Time => '1 gün önce';

  @override
  String get notification3Action => 'Fırsatı gör';

  @override
  String get notification4Title => 'Sorunuza yeni yanıt';

  @override
  String get notification4Message => 'Eğitmen dersle ilgili sorunuzu yanıtladı';

  @override
  String get notification4Time => '2 gün önce';

  @override
  String get notification4Action => 'Yanıtı gör';

  @override
  String get notification5Title => 'Kurs güncellemesi';

  @override
  String get notification5Message => 'Python kursuna yeni içerikler eklendi';

  @override
  String get notification5Time => '3 gün önce';

  @override
  String get messagesTitle => 'Mesajlar';

  @override
  String get settingsTitle => 'Ayarlar ve Tercihler';

  @override
  String get settingsVideoDownload => 'Video ve İndirme';

  @override
  String get settingsDownloadQuality => 'Varsayılan indirme kalitesi';

  @override
  String get settingsWifiOnly => 'Yalnızca Wi-Fi üzerinden indir';

  @override
  String get settingsNotifications => 'Bildirimler ve Uyarılar';

  @override
  String get settingsCourseNotifications => 'Kurs ve mesaj bildirimleri';

  @override
  String get settingsPromoNotifications => 'Özel fırsatlar ve indirimler';

  @override
  String get settingsAppearance => 'Görünüm ve Dil';

  @override
  String get settingsDarkMode => 'Karanlık Mod';

  @override
  String get settingsDarkModeEnabled => 'Açık (pil tasarrufu sağlar)';

  @override
  String get settingsDarkModeDisabled => 'Kapalı (açık tema)';

  @override
  String get settingsLanguage => 'Uygulama Dili';

  @override
  String get settingsStorage => 'Depolama ve Önbellek';

  @override
  String get settingsClearCache => 'Önbelleği Temizle';

  @override
  String get settingsClearCacheSuccess => 'Önbellek başarıyla temizlendi';

  @override
  String get settingsHelp => 'Bilgi ve Politikalar';

  @override
  String get settingsHelpCenter => 'Yardım Merkezi ve SSS';

  @override
  String get settingsTermsPrivacy => 'Kullanım Şartları ve Gizlilik';

  @override
  String get settingsAbout => 'EduLab Hakkında';

  @override
  String get settingsVersion => 'Sürüm v1.0.0';

  @override
  String get quizTitle => 'Sınav';

  @override
  String get quizNext => 'Sonraki Soru';

  @override
  String get quizSubmit => 'Sınavı Tamamla';

  @override
  String get quizScore => 'Sınav Puanı';

  @override
  String get quizCorrectAnswers => 'Doğru Cevaplar';

  @override
  String get scheduleTitle => 'Ders Programım';

  @override
  String get scheduleEmpty => 'Planlanmış ders yok';

  @override
  String get scheduleJoin => 'Derse Katıl';

  @override
  String get scheduleReminder => 'Hatırlatıcı';

  @override
  String get assignmentsTitle => 'Ödevler';

  @override
  String get assignmentsEmpty => 'Ödev bulunmuyor';

  @override
  String get assignmentsSubmit => 'Ödevi Gönder';

  @override
  String get assignmentsDue => 'Son Teslim Tarihi';

  @override
  String get assignmentsSubmitted => 'Gönderildi';

  @override
  String get assignmentsPending => 'Beklemede';

  @override
  String get languageArabic => 'Arapça';

  @override
  String get languageEnglish => 'İngilizce';

  @override
  String get languageDialogTitle => 'Uygulama Dilini Seçin';

  @override
  String get languageSelect => 'Seç';

  @override
  String get generalCancel => 'İptal';

  @override
  String get generalConfirm => 'Onayla';

  @override
  String get generalSave => 'Kaydet';

  @override
  String get generalDelete => 'Sil';

  @override
  String get generalEdit => 'Düzenle';

  @override
  String get generalClose => 'Kapat';

  @override
  String get generalBack => 'Geri';

  @override
  String get generalDone => 'Tamam';

  @override
  String get generalOk => 'Tamam';

  @override
  String get generalYes => 'Evet';

  @override
  String get generalNo => 'Hayır';

  @override
  String get generalLoading => 'Yükleniyor...';

  @override
  String get generalError => 'Bir hata oluştu';

  @override
  String get generalRetry => 'Tekrar Dene';

  @override
  String get generalNoInternet => 'İnternet bağlantısı yok';

  @override
  String get generalFree => 'Ücretsiz';

  @override
  String get generalRating => 'Puan';

  @override
  String get generalStudents => 'Öğrenci';

  @override
  String get generalHours => 'Saat';

  @override
  String get generalMinutes => 'Dakika';

  @override
  String get generalBy => 'Hazırlayan';

  @override
  String get navHome => 'Ana Sayfa';

  @override
  String get navExplore => 'Keşfet';

  @override
  String get navMyCourses => 'Kurslarım';

  @override
  String get navCart => 'Sepet';

  @override
  String get navAccount => 'Hesabım';

  @override
  String get homeSubGreeting => 'Bugün ne öğrenmek istersiniz?';

  @override
  String get homeVisitor => 'Misafir';

  @override
  String get homePromoTitle => 'Fırsatları Keşfedin';

  @override
  String get homePromoSubtitle => 'Popüler kurslarda %70\'e varan indirim';

  @override
  String get homePromoButton => 'Şimdi Keşfet';

  @override
  String get homePromoBadge => 'Özel Fırsat';

  @override
  String get homeContinueLearning => 'Öğrenmeye Devam Et';

  @override
  String get homeMyCoursesLink => 'Kurslarım';

  @override
  String get homeLesson => 'ders';

  @override
  String homeStudentsCount(String count) {
    return '$count öğrenci';
  }

  @override
  String get homeRecommendedTitle => 'Sizin İçin Önerilenler';

  @override
  String get homeRecommendedSubtitle =>
      'İlgi alanlarınıza göre kişiselleştirildi';

  @override
  String get homeBestsellersTitle => 'En Çok Satanlar';

  @override
  String get homeBestsellersSubtitle => 'En beğenilen ve popüler kurslar';

  @override
  String get homeNewCoursesTitle => 'Yeni Kurslar';

  @override
  String get homeNewCoursesSubtitle => 'Yeni ve güncel içerikler';

  @override
  String get homePopularTopicsTitle => 'Popüler Konular';

  @override
  String get homePopularTopicsSubtitle =>
      'En çok talep gören becerileri öğrenin';

  @override
  String get homeTopInstructorsTitle => 'En İyi Eğitmenler';

  @override
  String get homeTopInstructorsSubtitle => 'Sertifikalı uzmanlardan öğrenin';

  @override
  String get homeExploreCategoriesTitle => 'Kategorileri Keşfet';

  @override
  String get homeExploreCategoriesSubtitle => 'Size en uygun kursu bulun';

  @override
  String get catAll => 'Tümü';

  @override
  String get catWebDev => 'Web Geliştirme';

  @override
  String get catMobileApps => 'Mobil Uygulama';

  @override
  String get catDataScience => 'Veri Bilimi';

  @override
  String get catUIUX => 'UI/UX Tasarım';

  @override
  String get catBusiness => 'İş & Yönetim';

  @override
  String get catAI => 'Yapay Zeka';

  @override
  String get catCyberSecurity => 'Siber Güvenlik';

  @override
  String get exploreNoResultsTitle => 'Sonuç bulunamadı';

  @override
  String get exploreNoResultsSubtitle =>
      'Farklı anahtar kelimeler deneyin veya filtreleri değiştirin';

  @override
  String get exploreRecentSearches => 'Son Aramalar';

  @override
  String get exploreTopSearches => 'Popüler Aramalar';

  @override
  String get exploreBrowseCategories => 'Kategorilere Göz At';

  @override
  String get exploreBrowseCategoriesSubtitle => 'Size en uygun kursu bulun';

  @override
  String get exploreBackToAll => 'Tümüne Dön';

  @override
  String get exploreClearAll => 'Temizle';

  @override
  String get exploreAvailableResults => 'sonuç bulundu';

  @override
  String get exploreFilterBestseller => 'Çok Satan';

  @override
  String get exploreFilterTopRated => 'En Çok Beğenilen';

  @override
  String get exploreFilterUnder50 => '50 TL Altı';

  @override
  String get learningHeroTitle => 'Öğrenme yolculuğunuza devam edin';

  @override
  String get learningSearchHint => 'Kurslarımda ara...';

  @override
  String get learningFilterAll => 'Tümü';

  @override
  String get learningFilterInProgress => 'Devam Edenler';

  @override
  String get learningFilterCompleted => 'Tamamlananlar';

  @override
  String get learningFilterDownloaded => 'İndirilenler';

  @override
  String get learningEmptyTitle => 'Henüz kursunuz yok';

  @override
  String get learningEmptySubtitle => 'Hemen yeni kurslar keşfetmeye başlayın';

  @override
  String get learningEmptySearch => 'Aramanıza uygun sonuç bulunamadı';

  @override
  String get learningCompleted => 'Tamamlandı';

  @override
  String get learningCompletedBadge => 'Tamamlandı';

  @override
  String learningLecturesCount(int count) {
    return '$count ders';
  }

  @override
  String get cartEmptyTitle => 'Sepetiniz boş';

  @override
  String get cartEmptySubtitle => 'Öğrenmeye başlamak için kurs ekleyin';

  @override
  String get cartCouponHint => 'Kupon kodunu girin';

  @override
  String get cartCouponApply => 'Uygula';

  @override
  String get cartCouponInvalid => 'Geçersiz kupon';

  @override
  String get cartCouponApplied => 'Kupon uygulandı';

  @override
  String get cartCouponDiscount => 'Kupon İndirimi';

  @override
  String get cartCouponsTitle => 'Kuponlar';

  @override
  String get cartOrderSummary => 'Sipariş Özeti';

  @override
  String get cartOriginalPrice => 'Orijinal Fiyat';

  @override
  String get cartPlatformDiscount => 'Platform İndirimi';

  @override
  String get cartFinalTotal => 'Toplam Tutar';

  @override
  String cartItemsCount(int count) {
    return '$count kurs';
  }

  @override
  String get cartRemovedSnackbar => 'Kurs sepetten kaldırıldı';

  @override
  String get cartUndo => 'Geri Al';

  @override
  String get cartAddButton => 'Sepete Ekle';

  @override
  String get cartAddedSnackbar => 'Sepete eklendi';

  @override
  String get cartAlreadyInCart => 'Zaten sepette';

  @override
  String get cartCheckoutButton => 'Ödemeyi Tamamla';

  @override
  String get cartRecommendedTitle => 'Bunlar da İlginizi Çekebilir';

  @override
  String get cartRecommendedSubtitle => 'Sepetinize göre önerilen kurslar';

  @override
  String get checkoutCreditCard => 'Kredi Kartı';

  @override
  String get checkoutSelectPayment => 'Ödeme yöntemini seçin';

  @override
  String get checkoutCardNumberLabel => 'Kart Numarası';

  @override
  String get checkoutCardHolderLabel => 'Kart Sahibi';

  @override
  String get checkoutExpiryLabel => 'Son Kullanma Tarihi';

  @override
  String get checkoutCVVLabel => 'CVV';

  @override
  String get checkoutPersonalInfoTitle => 'Kişisel Bilgiler';

  @override
  String get checkoutFullNameLabel => 'Ad Soyad';

  @override
  String get checkoutFullNameHint => 'Adınız ve soyadınız';

  @override
  String get checkoutFullNameRequired => 'Ad Soyad zorunludur';

  @override
  String get checkoutPhoneLabel => 'Telefon Numarası';

  @override
  String get checkoutPhoneRequired => 'Telefon numarası zorunludur';

  @override
  String get checkoutPostalLabel => 'Posta Kodu';

  @override
  String get checkoutPostalRequired => 'Posta kodu zorunludur';

  @override
  String get checkoutBuyerInfo => 'Alıcı Bilgileri';

  @override
  String get checkoutSaveInfo => 'Bilgilerimi sonraki alışverişler için kaydet';

  @override
  String get checkoutMoneyBackGuarantee => '30 Günlük Para İade Garantisi';

  @override
  String get checkoutContinueToPayment => 'Ödemeye Devam Et';

  @override
  String get checkoutContinueToReview => 'İncelemeye Devam Et';

  @override
  String get checkoutReviewConfirm => 'İncele ve Onayla';

  @override
  String get checkoutStartLearning => 'Öğrenmeye Başla';

  @override
  String get checkoutBackHome => 'Ana Sayfaya Dön';

  @override
  String get courseDetailsTitle => 'Kurs Detayı';

  @override
  String get courseDetailsShare => 'Paylaş';

  @override
  String get courseDetailsWhatYouWillLearn => 'Neler Öğreneceksiniz';

  @override
  String get courseDetailsLanguage => 'Dil';

  @override
  String get courseDetailsCreatedBy => 'Hazırlayan';

  @override
  String get courseDetailsPreviewLesson => 'Önizleme';

  @override
  String get courseDetailsHoursOnDemand => 'saat isteğe bağlı video';

  @override
  String get courseDetailsFullLifetimeAccess => 'Tam ömür boyu erişim';

  @override
  String get courseDetailsCertifiedCertificate => 'Resmi bitirme sertifikası';

  @override
  String get courseDetailsComprehensiveContent => 'Kapsamlı içerik';

  @override
  String get certTitle => 'Bitirme Sertifikası';

  @override
  String get certStudentNameLabel => 'Öğrenci';

  @override
  String get certCourseLabel => 'Kurs';

  @override
  String get certInstructorLabel => 'Eğitmen';

  @override
  String get certIssueDateLabel => 'Düzenleme Tarihi';

  @override
  String get certCodeLabel => 'Sertifika ID';

  @override
  String get certVerifiedBadge => 'Doğrulandı';

  @override
  String get certDownloadPDF => 'PDF İndir';

  @override
  String get certDownloadPNG => 'Resmi İndir';

  @override
  String get certCopyVerifyLink => 'Doğrulama bağlantısını kopyala';

  @override
  String get certShare => 'Sertifikayı Paylaş';

  @override
  String get playerTabLessons => 'Dersler';

  @override
  String get playerTabOverview => 'Genel Bakış';

  @override
  String get playerTabNotes => 'Notlarım';

  @override
  String get playerTabQnA => 'Soru & Cevap';

  @override
  String get playerNextLesson => 'Sonraki Ders';

  @override
  String get profileWelcome => 'Hoş Geldiniz';

  @override
  String get profileLoginPrompt => 'Profilinize erişmek için giriş yapın';

  @override
  String get profileLoginOrRegister => 'Giriş Yap / Kayıt Ol';

  @override
  String get profileVerifiedStudent => 'Doğrulanmış Öğrenci';

  @override
  String get profileLogout => 'Çıkış Yap';

  @override
  String get profileCancel => 'İptal';

  @override
  String get profileLogoutConfirmTitle => 'Çıkış Yap';

  @override
  String get profileLogoutConfirmMessage =>
      'Hesabınızdan çıkış yapmak istediğinizden emin misiniz?';

  @override
  String get profileAccountSettings => 'Hesap Ayarları';

  @override
  String get profileEditProfileSubtitle => 'Kişisel bilgilerinizi düzenleyin';

  @override
  String get profileSecurity => 'Hesap Güvenliği';

  @override
  String get profileSecuritySubtitle => 'Şifre ve iki adımlı doğrulama';

  @override
  String get profilePurchaseHistory => 'Satın Alma Geçmişi';

  @override
  String get profilePurchaseHistorySubtitle => 'İşlem geçmişini görüntüleyin';

  @override
  String get profileCertificatesSubtitle => 'Kazandığınız sertifikalar';

  @override
  String get profileTeach => 'EduLab\'da Eğitmen Olun';

  @override
  String get profileTeachSubtitle => 'Bilginizi başkalarıyla paylaşın';

  @override
  String get profilePreferences => 'Tercihler';

  @override
  String get profilePreferencesSubtitle => 'Görünüm ve ayarlar';

  @override
  String get profileNotifications => 'Bildirimler';

  @override
  String get profileNotificationsSubtitle => 'Bildirimleri yönetin';

  @override
  String get profileHelpSupport => 'Yardım & Destek';

  @override
  String get profileTerms => 'Kullanım Şartları';

  @override
  String get profilePrivacy => 'Gizlilik Politikası';

  @override
  String get profileAboutEduLab => 'EduLab Hakkında';

  @override
  String get profileWishlist => 'İstek Listesi';

  @override
  String get securityTitle => 'Hesap Güvenliği';

  @override
  String get teachTitle => 'EduLab\'da Eğitmen Olun';

  @override
  String get notificationsTabAll => 'Tümü';

  @override
  String get notificationsTabCourses => 'Kurslar';

  @override
  String get notificationsTabPromos => 'Fırsatlar';

  @override
  String get notificationsEmptyTitle => 'Bildirim yok';

  @override
  String get notificationsUnread => 'Okunmamış';

  @override
  String get wishlistTitle => 'İstek Listesi';

  @override
  String get wishlistEmptyTitle => 'İstek listeniz boş';

  @override
  String get wishlistEmptySubtitle => 'İlginizi çeken kursları kaydedin';

  @override
  String get wishlistAddToCart => 'Sepete Ekle';

  @override
  String get wishlistRemovedSnackbar => 'İstek listesinden kaldırıldı';

  @override
  String get homeDefaultUser => 'Öğrenci';

  @override
  String get learningOf => '/';

  @override
  String get cartInCartBadge => 'Sepette';

  @override
  String get homePromo1Badge => 'Büyük İndirim • Sınırlı Süre';

  @override
  String get homePromo1Title => 'En iyi fiyatlarla öğrenmeye başlayın';

  @override
  String get homePromo1Subtitle =>
      'Yazılım, tasarım ve işletme kurslarında %65\'e varan indirim.';

  @override
  String get homePromo1Button => 'Fırsatları Gör';

  @override
  String get homePromo2Badge => 'Sertifikalı Kariyer Yolları';

  @override
  String get homePromo2Title => 'Hayalinizdeki teknoloji kariyerine hazırlanın';

  @override
  String get homePromo2Subtitle =>
      'Sıfırdan uzmanlığa gerçek projeli ve sertifikalı eğitimler.';

  @override
  String get homePromo2Button => 'Yolları Keşfet';

  @override
  String get homePromo3Badge => 'Uzman Eğitmenler';

  @override
  String get homePromo3Title => 'Doğrudan sektör profesyonellerinden öğrenin';

  @override
  String get homePromo3Subtitle =>
      'En güncel teknolojiler için sürekli yenilenen kaliteli içerik.';

  @override
  String get homePromo3Button => 'Hemen Başla';

  @override
  String get homePromoInstructorBadge =>
      'EduLab\'da Eğitmen Olun • Bilginizi Paylaşın';

  @override
  String get homePromoInstructorTitle => 'Bugün Eğitmen Olun';

  @override
  String get homePromoInstructorSubtitle =>
      'Dünya çapında öğrencilere ilham verin, kurslar oluşturun ve sevdiğiniz şeyi öğreterek gelir elde edin.';

  @override
  String get homePromoInstructorButton => 'Hemen Başvur';

  @override
  String get homeSearchFilter => 'Filtrele';

  @override
  String get securitySectionChangePassword => 'Şifreyi Değiştir';

  @override
  String get securityCurrentPasswordLabel => 'Mevcut Şifre *';

  @override
  String get securityCurrentPasswordError => 'Mevcut şifrenizi girin';

  @override
  String get securityNewPasswordLabel => 'Yeni Şifre *';

  @override
  String get securityNewPasswordError => 'En az 8 karakter olmalıdır';

  @override
  String get securityConfirmPasswordLabel => 'Yeni Şifreyi Onayla *';

  @override
  String get securityConfirmPasswordError => 'Şifreler eşleşmiyor';

  @override
  String get securityUpdatePasswordBtn => 'Şifreyi Güncelle';

  @override
  String get securityPasswordUpdatedSuccess => 'Şifre başarıyla değiştirildi!';

  @override
  String get securitySection2FA => 'İki Adımlı Doğrulama (2FA)';

  @override
  String get security2FATitle => 'İki Adımlı Doğrulama';

  @override
  String get security2FAEnabledDesc => 'Etkin - Hesabınızı ek bir kodla korur';

  @override
  String get security2FADisabledDesc => 'Devre Dışı (Önerilir)';

  @override
  String get security2FASetupTitle => 'İki Adımlı Doğrulamayı Etkinleştir';

  @override
  String get security2FASetupContent =>
      'Her yeni girişte e-posta adresinize 6 haneli bir doğrulama kodu gönderilecektir.';

  @override
  String get security2FAEnableNow => 'Şimdi Etkinleştir';

  @override
  String get security2FAEnabledSuccess =>
      'İki adımlı doğrulama başarıyla etkinleştirildi!';

  @override
  String get security2FADisabledSuccess =>
      'İki adımlı doğrulama devre dışı bırakıldı';

  @override
  String get securitySectionSessions => 'Aktif Oturumlar ve Cihazlar';

  @override
  String get securityLogoutAllDevices => 'Tüm Cihazlardan Çıkış Yap';

  @override
  String get securityThisDevice => 'Bu Cihaz';

  @override
  String get securitySessionRevokedSuccess =>
      'Oturum sonlandırıldı ve cihazdan çıkış yapıldı.';

  @override
  String get securityAllSessionsRevokedSuccess =>
      'Diğer tüm cihazlardan başarıyla çıkış yapıldı.';

  @override
  String get purchaseHistoryInvoiceCertified => 'Onaylı E-Fatura';

  @override
  String get purchaseHistoryInvoiceNumber => 'Fatura Numarası';

  @override
  String get purchaseHistoryCourse => 'Kurs';

  @override
  String get purchaseHistoryPaymentMethod => 'Ödeme Yöntemi';

  @override
  String get purchaseHistoryTotalAmount => 'Toplam Tutar:';

  @override
  String get purchaseHistoryClose => 'Kapat';

  @override
  String get purchaseHistoryDownloadPdf => 'PDF İndir';

  @override
  String get purchaseHistoryPdfDownloaded =>
      'Fatura PDF formatında başarıyla indirildi';

  @override
  String get purchaseHistoryRefundRequestTitle => 'İade Talebi (Refund)';

  @override
  String get purchaseHistoryRefundPolicy =>
      'EduLab\'ın 30 günlük para iade garantisi uyarınca tam tutar iadesi talep edebilirsiniz.';

  @override
  String get purchaseHistoryRefundReasonHint => 'İade nedeni (isteğe bağlı)...';

  @override
  String get purchaseHistoryConfirmRefund => 'İadeyi Onayla';

  @override
  String get purchaseHistoryRefundSubmitted =>
      'İade talebiniz başarıyla alındı (3-5 iş günü içinde yatırılacaktır).';

  @override
  String get purchaseHistoryInstructor => 'Eğitmen';

  @override
  String get purchaseHistoryRequestRefundBtn => 'İade Talep Et';

  @override
  String get purchaseHistoryInvoiceBtn => 'Fatura';

  @override
  String get purchaseHistoryStatusCompleted => 'Tamamlandı';

  @override
  String get purchaseHistoryStatusRefunded => 'İade Edildi';

  @override
  String get purchaseHistoryStatusProcessingRefund => 'İade İşleniyor';

  @override
  String get editProfileSectionBasicInfo => 'Temel Bilgiler';

  @override
  String get editProfileFullNameLabel => 'Ad Soyad *';

  @override
  String get editProfileFullNameHint => 'Adınızı ve soyadınızı girin';

  @override
  String get editProfileFullNameError =>
      'Lütfen adınızı ve soyadınızı eksiksiz girin';

  @override
  String get editProfileHeadlineLabel => 'Unvan / Uzmanlık';

  @override
  String get editProfileHeadlineHint => 'ör. Kıdemli Flutter Geliştirici';

  @override
  String get editProfileLocationLabel => 'Şehir / Ülke';

  @override
  String get editProfileLocationHint => 'İstanbul, Türkiye';

  @override
  String get editProfilePhoneLabel => 'Cep Telefonu';

  @override
  String get editProfileBioLabel => 'Hakkımda (Bio)';

  @override
  String get editProfileBioHint =>
      'İlgi alanlarınız ve deneyiminiz hakkında kısa bir özet yazın...';

  @override
  String get editProfileSectionLinks => 'Bağlantılar ve Sosyal Ağlar';

  @override
  String get editProfileWebsiteLabel => 'Kişisel Web Sitesi';

  @override
  String get editProfileSectionEmail => 'Kayıtlı E-posta';

  @override
  String get editProfileEmailDesc =>
      'Giriş yapmak ve sertifikalar almak için hesabınıza bağlıdır';

  @override
  String get editProfileEmailVerified => 'Doğrulandı';

  @override
  String get editProfileSaveChangesBtn => 'Bilgileri Kaydet ve Güncelle';

  @override
  String get editProfileSavedSuccess =>
      'Profil bilgileri başarıyla güncellendi!';

  @override
  String get editProfileChangeAvatarTitle => 'Profil Resmini Değiştir';

  @override
  String get editProfileTakePhoto => 'Kamera ile Çek';

  @override
  String get editProfileChooseGallery => 'Galeriden Seç';

  @override
  String get editProfilePhotoUpdatedSuccess =>
      'Profil resmi başarıyla güncellendi';

  @override
  String get teachJoinInstructorTitle => 'Eğitmen Olarak Katılın';

  @override
  String get teachJoinInstructorSubtitle =>
      'Kurslarınızı yayınlayın ve uzmanlığınızı binlerce öğrenciyle paylaşın.';

  @override
  String get teachStep1Title => 'Kişisel Bilgiler';

  @override
  String get teachStep2Title => 'Deneyim ve Beceriler';

  @override
  String get teachStep3Title => 'Başvuruyu Onayla';

  @override
  String get teachStep1Header => '1. Kişisel ve Mesleki Bilgiler';

  @override
  String get teachFullNameArabicLabel => 'Ad Soyad *';

  @override
  String get teachFullNameArabicHint => 'ör. Ahmet Yılmaz';

  @override
  String get teachHeadlineLabel => 'Mesleki Unvan ve Uzmanlık *';

  @override
  String get teachHeadlineHint =>
      'ör. Kıdemli Yazılım Mimarı ve Flutter Eğitmeni';

  @override
  String get teachPhoneLabel => 'İletişim Telefonu *';

  @override
  String get teachCountryLabel => 'İkamet Edilen Ülke *';

  @override
  String get teachBioLabel => 'Özgeçmiş ve Deneyimler *';

  @override
  String get teachBioHint =>
      'Kariyeriniz ve geçmiş projeleriniz hakkında kısa bir özet yazın...';

  @override
  String get teachNextStepSkills => 'Devam: Deneyim ve Beceriler';

  @override
  String get teachStep2Header => '2. Eğitim İçeriği ve Beceriler';

  @override
  String get teachTopicLabel => 'Önerilen Kurs Konusu *';

  @override
  String get teachTopicHint => 'ör. Sıfırdan İleri Seviye Flutter Geliştirme';

  @override
  String get teachYearsExperienceLabel => 'Alandaki Deneyim Yılı *';

  @override
  String get teachVideoLinkLabel =>
      'Örnek Ders Video Bağlantısı (YouTube/Drive/Loom) *';

  @override
  String get teachTargetAudienceLabel => 'Kursun Hedef Kitlesi *';

  @override
  String get teachAudienceBeginners => 'Tamamen Yeni Başlayanlar';

  @override
  String get teachAudienceIntermediate => 'Başlangıç ve Orta Seviye';

  @override
  String get teachAudienceAdvanced => 'İleri Düzey ve Profesyoneller';

  @override
  String get teachAudienceAll => 'Herkes';

  @override
  String get teachSkillsCoveredLabel =>
      'Kursun Kapsayacağı Beceriler ve Teknolojiler *';

  @override
  String get teachAddSkillHint => 'Beceri ekle (ör. GraphQL)...';

  @override
  String get teachAddSkillBtn => 'Ekle';

  @override
  String get teachNextStepConfirm => 'Devam: Başvuruyu Onayla';

  @override
  String get teachStep3Header => '3. Kazanç Detayları ve Şartlar';

  @override
  String get teachPayoutMethodLabel => 'Kazanç Ödeme Yöntemi *';

  @override
  String get teachPayoutMethodBank => 'Banka Havalesi (IBAN)';

  @override
  String get teachPayoutMethodPaypal => 'Doğrulanmış PayPal Hesabı';

  @override
  String get teachPayoutMethodPayoneer => 'Payoneer Kartı';

  @override
  String get teachIbanDetailsLabel => 'Hesap Bilgileri / IBAN *';

  @override
  String get teachApplicationSummary => 'Başvuru Özeti:';

  @override
  String get teachApplicantName => 'Başvuran';

  @override
  String get teachApplicantHeadline => 'Uzmanlık';

  @override
  String get teachApplicantTopic => 'Kurs Konusu';

  @override
  String get teachApplicantSkillsCount => 'Eklenen Beceri Sayısı';

  @override
  String get teachSkillsUnit => 'beceri';

  @override
  String get teachAgreeTermsLabel =>
      'EduLab eğitmenlik şartlarını, koşullarını ve fikri mülkiyet sözleşmesini onaylıyorum.';

  @override
  String get teachSubmitApplicationBtn => 'Submit Instructor Application';

  @override
  String get teachPrevStepBtn => 'Önceki';

  @override
  String get teachWhyEduLabTitle => 'Neden EduLab ile Eğitim Vermelisiniz?';

  @override
  String get teachProp1Title => 'Adil ve Kazançlı Gelir Payı';

  @override
  String get teachProp1Desc =>
      'Gizli ücretler olmadan kurs satışlarınızdan %80\'e varan gelir elde edin.';

  @override
  String get teachProp2Title => 'Binlerce Öğrenciye Ulaşın';

  @override
  String get teachProp2Desc =>
      'Kursunuzu bölgenin ve dünyanın en aktif öğrenci topluluğuna tanıtın.';

  @override
  String get teachProp3Title => 'Tam Teknik ve Prodüksiyon Desteği';

  @override
  String get teachProp3Desc =>
      'Ekibimiz ses, video kalitesi ve müfredat tasarımını optimize etmenize yardımcı olur.';

  @override
  String get teachSuccessDialogTitle => 'Başvurunuz Başarıyla Alındı!';

  @override
  String get teachSuccessDialogDesc =>
      'EduLab eğitmen topluluğuna katıldığınız için teşekkür ederiz. Ekibimiz 48 saat içinde sizinle iletişime geçecektir.';

  @override
  String get teachSuccessDialogOk => 'Tamam';

  @override
  String get teachAddOneSkillError => 'Lütfen en az bir beceri ekleyin';

  @override
  String get teachAgreeTermsError => 'Lütfen eğitmenlik şartlarını kabul edin';

  @override
  String get commonCancel => 'İptal';

  @override
  String get commonClose => 'Kapat';

  @override
  String get myCertificatesBannerTitle => 'Akredite Sertifikalar';

  @override
  String get myCertificatesBannerSubtitle =>
      'Tüm sertifikalar EduLab\'ın benzersiz bir kimliğiyle akredite edilmiş ve doğrulanmıştır';

  @override
  String get certBadgeVerified100 => '%100 Akredite';

  @override
  String get certCodeCopied => 'Sertifika kodu kopyalandı';

  @override
  String get certGrantedTo => 'Verilen kişi';

  @override
  String get certViewAndDownload => 'Sertifikayı Görüntüle ve İndir';

  @override
  String get certIssuerLabel => 'Veren Kurum';

  @override
  String get certIssuerName => 'EduLab İnteraktif Öğrenme Akademisi';

  @override
  String get certEmptyTitle => 'Henüz kazanılmış bir sertifika yok';

  @override
  String get certEmptyDesc =>
      'Resmi doğrulama kimliğine sahip akredite bir sertifika almak için kayıtlı herhangi bir kursun %100\'ünü tamamlayın.';

  @override
  String get certEmptyAction => 'Kurslarıma Devam Et';

  @override
  String get certDetailsTitle => 'Sertifika Detayları ve Bilgileri';

  @override
  String get certCopyLinkSuccess =>
      'Doğrudan doğrulama bağlantısı panoya kopyalandı!';

  @override
  String get certShareSuccess =>
      'Sertifika detayları ve bağlantısı paylaşım için kopyalandı!';

  @override
  String get purchaseHistoryTaxInvoiceCertified =>
      'Resmi Onaylı Vergi Faturası';

  @override
  String get purchaseHistoryInvoiceNumberLabel => 'Sipariş / Fatura No';

  @override
  String get purchaseHistoryCourseNameLabel => 'Kurs Adı';

  @override
  String get purchaseHistoryPurchaseDateLabel => 'Satın Alma Tarihi';

  @override
  String get purchaseHistoryPaymentMethodLabel => 'Ödeme Yöntemi';

  @override
  String get purchaseHistoryPaymentMethodValue =>
      'Kredi Kartı / Stripe (Çevrimiçi)';

  @override
  String get purchaseHistoryOrderStatusLabel => 'Sipariş Durumu';

  @override
  String get purchaseHistoryStatusPendingReview => 'İade İncelemesi Bekliyor';

  @override
  String get purchaseHistoryCopyInvoiceBtn => 'Fatura Numarasını Kopyala';

  @override
  String get purchaseHistoryRefundReasonLabel => 'İade Talebi Nedeni:';

  @override
  String get purchaseHistoryRefundReasonEmptyError =>
      'Lütfen iade talebinizin nedenini girin';

  @override
  String get purchaseHistorySubmittingRefund => 'İstek gönderiliyor...';

  @override
  String get purchaseHistoryPaidDate => 'Ödeme Tarihi';

  @override
  String get purchaseHistoryEmptyTitle => 'Henüz satın alma geçmişi yok';

  @override
  String get purchaseHistoryEmptyDesc =>
      'Henüz herhangi bir kurs satın almadınız.\nSiparişleriniz ve faturalarınız tamamlandığında burada görünecektir.';

  @override
  String get purchaseHistoryExploreCourses => 'Şimdi Kursları Keşfet';

  @override
  String get profileMyCourses => 'Kurslarım';

  @override
  String get profileMyCoursesSubtitle =>
      'Kayıtlı kurslarınızdaki ilerlemeyi takip edin';

  @override
  String get profileWishlistSubtitle => 'İstek listenizde kayıtlı kurslar';

  @override
  String get navMyLearning => 'Öğrenimim';

  @override
  String get profileLogoutSafeNote =>
      'Verileriniz, kurslarınız ve sertifikalarınız güvendedir. Tekrar giriş yaparak dilediğiniz zaman öğrenmeye devam edebilirsiniz.';

  @override
  String learningRemainingHours(String hours) {
    return '$hours saat kaldı';
  }

  @override
  String get learningCompletedFull => 'Tamamlandı';

  @override
  String get learningFilterNotStarted => 'Başlanmadı';

  @override
  String get wishlistTopRatedBadge => 'En Çok Değerlendirilen';

  @override
  String get wishlistFeaturedBadge => 'Öne Çıkan';

  @override
  String wishlistDiscountBadge(String percent) {
    return '%$percent İndirim';
  }

  @override
  String get courseFree => 'Ücretsiz';

  @override
  String get badgeBestseller => 'Çok Satan';

  @override
  String get badgeTopRated => 'En Çok Değerlendirilen';

  @override
  String get badgeFeatured => 'Öne Çıkan';

  @override
  String get badgeRecommended => 'Sizin için önerilen';

  @override
  String get badgeNew => 'Yeni';

  @override
  String get courseWord => 'Kurs';

  @override
  String coursesCountText(String count) {
    return '$count+ Kurs';
  }

  @override
  String studentsCountText(String count) {
    return '$count Öğrenci';
  }

  @override
  String hoursCountText(String count) {
    return '$count Saat';
  }

  @override
  String get certifiedInstructor => 'Sertifikalı Eğitmen';

  @override
  String get expertCertifiedInstructor => 'Uzman & Sertifikalı Eğitmen';

  @override
  String get defaultCourseTitle => 'Eğitim Kursu';

  @override
  String get categoryWord => 'Kategori';

  @override
  String get previewCourseVideo => 'Kurs Videosu Önizleme';

  @override
  String get freeSection => 'Ücretsiz Bölüm';

  @override
  String get freeDemoVideo => 'Ücretsiz Tanıtım Videosu';

  @override
  String get articleLecture => 'Makale Dersi';

  @override
  String get articleViewer => 'Makale Okuyucu';

  @override
  String get courseVideoPlayer => 'Kurs Video Oynatıcı';

  @override
  String get playingNow => 'Şimdi Oynatılıyor';

  @override
  String get readingNow => 'Şimdi Okunuyor';

  @override
  String get noLecturesInFreeSection => 'Ücretsiz bölümde ders bulunmamaktadır';

  @override
  String freeLecturesCount(String count) {
    return '$count ücretsiz ders';
  }

  @override
  String get enrollInFullCourse => 'Tüm Kursa Kaydol';

  @override
  String get articleWord => 'Makale';

  @override
  String get videoWord => 'Video';

  @override
  String get quizWord => 'Sınav';

  @override
  String get courseShareCopied => 'Kurs bağlantısı panoya kopyalandı!';

  @override
  String get addedToCartSnackbar => 'Sepete eklendi';

  @override
  String get viewCartAction => 'Sepeti Görüntüle';

  @override
  String get inCartBadge => 'Sepette ✓';

  @override
  String get addToCartButton => 'Sepete Ekle';

  @override
  String get wishlistAddedSnackbar => 'Kurs istek listesine eklendi';

  @override
  String get wishlistRemovedSuccessSnackbar =>
      'Kurs istek listesinden çıkarıldı';

  @override
  String get lessonCompletedAll =>
      'Tebrikler! Bu kurstaki tüm dersleri tamamladınız.';

  @override
  String get noteAddedSuccess => 'Not başarıyla eklendi';

  @override
  String get lessonAlreadyDownloaded =>
      'Ders zaten çevrimdışı izleme için kayıtlı';

  @override
  String get lessonLinkCopied => 'Ders bağlantısı kopyalandı';

  @override
  String get contentReportThanks =>
      'Geri bildiriminiz için teşekkürler, ders incelenecektir.';

  @override
  String get courseCompletionCertificate => 'Kurs Bitirme Sertifikası';

  @override
  String get reportContentIssue => 'İçerik sorunu bildir';

  @override
  String get loginOrSocial => 'Veya şununla giriş yapın';

  @override
  String get loginSuccessSnackbar => 'Başarıyla giriş yapıldı';

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
  String get cartClearAllTitle => 'Sepetteki Tüm Öğeler Temizlensin mi?';

  @override
  String cartClearAllMessage(String count) {
    return 'Tüm $count kursu alışveriş sepetinizden kaldırmak istediğinizden emin misiniz?';
  }

  @override
  String get cartClearAllHint =>
      'Tüm kurslar sepetinizden kaldırılacaktır. Bunları istediğiniz zaman tekrar ekleyebilirsiniz.';

  @override
  String cartClearAllConfirm(String count) {
    return 'Tümünü Temizle ($count)';
  }

  @override
  String get cartClearedSuccess => 'Sepet başarıyla temizlendi';

  @override
  String get cartClearFailed => 'Sepet temizlenemedi';

  @override
  String cartViewWishlistCount(String count) {
    return 'İstek Listesi Öğelerini Görüntüle ($count)';
  }

  @override
  String get cartGoToWishlist => 'İstek Listesine Git';

  @override
  String get wishlistClearAllTitle =>
      'İstek Listesindeki Tüm Öğeler Temizlensin mi?';

  @override
  String wishlistClearAllMessage(String count) {
    return 'Tüm $count kursu istek listenizden kaldırmak istediğinizden emin misiniz?';
  }

  @override
  String get wishlistClearAllHint =>
      'Kayıtlı tüm kurslar temizlenecektir. Bunları istediğiniz zaman Keşfet sayfasından tekrar ekleyebilirsiniz.';

  @override
  String wishlistClearAllConfirm(String count) {
    return 'Tümünü Temizle ($count)';
  }

  @override
  String get wishlistClearedSuccess => 'İstek listesi başarıyla temizlendi';

  @override
  String get wishlistClearFailed => 'İstek listesi temizlenemedi';

  @override
  String get wishlistClearTooltip => 'Tümünü Temizle';

  @override
  String wishlistViewCartCount(String count) {
    return 'Sepet Öğelerini Görüntüle ($count)';
  }

  @override
  String get wishlistGoToCart => 'Sepete Git';

  @override
  String get checkoutCardNumberInvalid =>
      'Lütfen geçerli bir 16 haneli kart numarası girin';

  @override
  String get checkoutCardExpiryInvalidFormat =>
      'Lütfen geçerli bir son kullanma tarihi girin (MM / YY)';

  @override
  String get checkoutCardExpiredDate => 'Kart son kullanma tarihi geçersiz';

  @override
  String get checkoutCardCvcInvalid =>
      'Lütfen geçerli bir 3 veya 4 haneli CVC kodu girin';

  @override
  String get checkoutCardHolderNameRequired =>
      'Lütfen kart sahibinin adını girin';

  @override
  String get checkoutCartEmptySnackbar => 'Alışveriş sepeti boş';

  @override
  String get checkoutPaymentStartFailed => 'Ödeme başlatılamadı';

  @override
  String get checkoutClientSecretMissing =>
      'Ödeme ağ geçidinden güvenlik anahtarı alınamadı';

  @override
  String get checkoutCardVerificationFailed =>
      'Kart doğrulaması başarısız oldu';

  @override
  String get checkoutStripeProcessingFailed =>
      'Stripe ödeme işlemi başarısız oldu';

  @override
  String get checkoutServerConfirmationFailed =>
      'Sunucu ödeme onayı başarısız oldu';

  @override
  String get checkoutEmptyCartTitle => 'Sepetiniz boş';

  @override
  String get checkoutEmptyCartDesc =>
      'Henüz sepetinize kurs eklemediniz. Kurslarımızı keşfedin ve öğrenmeye başlayın!';

  @override
  String get checkoutContinueFreeReview => 'Ücretsiz İncelemeye Devam Et';

  @override
  String get checkoutFreeOrderBadge => '%100 Ücretsiz Sipariş (zsh.00)';

  @override
  String get checkoutFreeOrderNotice =>
      'Bu sipariş herhangi bir ödeme bilgisi gerektirmez. Kaydı onaylamak için doğrudan devam edebilirsiniz.';

  @override
  String get checkoutFreeCheckoutTitle => '%100 Ücretsiz Ödeme';

  @override
  String get checkoutConfirmFreeEnrollment => 'Ücretsiz Kaydı Onayla';

  @override
  String get checkoutFreePrice => 'Ücretsiz';

  @override
  String get checkoutFreeZero => 'Ücretsiz (zsh.00)';

  @override
  String checkoutCoursesCount(String count) {
    return '$count kurs';
  }

  @override
  String get notificationsClearAllTitle => 'Tüm Bildirimler Temizlensin mi?';

  @override
  String notificationsClearAllMessage(String count) {
    return 'Tüm $count bildirimi silmek istediğinizden emin misiniz? Bu işlem geri alınamaz.';
  }

  @override
  String get notificationsClearAllHint =>
      'Tüm bildirimleriniz silinecek ve gelen kutunuz sıfırlanacaktır.';

  @override
  String notificationsClearAllConfirm(String count) {
    return 'Tümünü Temizle ($count)';
  }

  @override
  String get notificationsClearSuccess =>
      'Tüm bildirimler başarıyla temizlendi';

  @override
  String get notificationsClearFailed => 'Bildirimler temizlenemedi';

  @override
  String get notificationsClearTooltip => 'Tümünü Temizle';

  @override
  String get notificationsViewDetails => 'Ayrıntıları Görüntüle';

  @override
  String get notificationsEmptyCategoryTitle => 'Bu kategoride bildirim yok';

  @override
  String get notificationsEmptyCategorySubtitle =>
      'Başka bir kategoriye geçmeyi deneyin veya tüm bildirimlere göz atın';

  @override
  String get notificationsEmptyAllSubtitle =>
      'En son güncellemeleri ve duyuruları burada sizinle paylaşacağız';

  @override
  String get notificationsViewAll => 'Tüm Bildirimleri Görüntüle';

  @override
  String get learningFilterAndSortTitle => 'Kursları Filtrele ve Sırala';

  @override
  String get learningFilterReset => 'Sıfırla';

  @override
  String get learningSortByTitle => 'Sıralama ölçütü';

  @override
  String get learningSortRecentActivity => 'Son Erişilenler';

  @override
  String get learningSortRecentEnrolled => 'Son Kayıt Olunanlar';

  @override
  String get learningSortTitleAZ => 'Başlık (A-Z)';

  @override
  String get learningSortProgress => 'İlerleme %';

  @override
  String get learningStatusTitle => 'Kurs Durumu';

  @override
  String get learningStatusAll => 'Tüm Kurslar';

  @override
  String get learningStatusInProgress => 'Devam Edenler';

  @override
  String get learningStatusCompleted => 'Tamamlanmış';

  @override
  String get learningStatusNotStarted => 'Başlatılmadı';

  @override
  String get learningFilterApply => 'Filtreleri Uygula';

  @override
  String get learningSearchCoursesHint => 'Kurslarınızı arayın...';

  @override
  String get learningSearchWishlistHint => 'İstek listesinde ara...';

  @override
  String get learningSearchCertificatesHint => 'Sertifikaları ara...';

  @override
  String get learningTabMyCourses => 'Kurslarım';

  @override
  String get learningTabFavourite => 'Favorim';

  @override
  String get learningTabCertificates => 'Sertifikalarım';

  @override
  String get learningNoCoursesTitle => 'Henüz kurs yok';

  @override
  String get learningNoCoursesSubtitle =>
      'Binlerce premium kursu keşfedin ve öğrenme yolculuğunuza bugün başlayın';

  @override
  String get learningFilterButton => 'Filtre';

  @override
  String learningFilterAllCount(String count) {
    return 'Hepsi ($count)';
  }

  @override
  String get learningStatusNotStartedShort => 'Başlatılmadı';

  @override
  String get learningNoMatchTitle => 'Eşleşen kurs yok';

  @override
  String learningNoMatchSubtitle(String query) {
    return '\"$query\" içeren kurs bulunamadı. Farklı terimlerle aramayı deneyin.';
  }

  @override
  String get learningNoInProgressTitle => 'Devam eden kurs yok';

  @override
  String get learningNoInProgressSubtitle =>
      'İlerlemenizi buradan takip etmek için kayıtlı kurslarınızdaki dersleri izlemeye başlayın.';

  @override
  String get learningNoCompletedTitle => 'Henüz tamamlanan kurs yok';

  @override
  String get learningNoCompletedSubtitle =>
      'İlerlemenizi kutlamak için çalışmalarınıza devam edin ve tamamlanan kursları burada görün.';

  @override
  String get learningNoUnstartedTitle => 'Başlatılmamış ders yok';

  @override
  String get learningNoUnstartedSubtitle =>
      'Mükemmel! Kayıtlı olduğunuz tüm derslerinizde öğrenmeye zaten başladınız.';

  @override
  String get learningNoFilterMatchTitle => 'Bu filtreyle eşleşen kurs yok';

  @override
  String get learningNoFilterMatchSubtitle =>
      'Kurslarınızı görüntülemek için filtreyi veya sıralama seçeneklerini değiştirin.';

  @override
  String learningViewAllCoursesCount(String count) {
    return 'Tüm kursları görüntüle ($count)';
  }

  @override
  String learningSavedCoursesCount(String count) {
    return 'Kaydedilen Kurslar ($count)';
  }

  @override
  String get learningClearAllSaved => 'Tümünü Temizle';

  @override
  String get learningNoCertificatesTitle => 'Henüz sertifika yok';

  @override
  String get learningNoCertificatesSubtitle =>
      'Başarılarınızı doğrulayan akredite sertifikalar kazanmak için kurslarınızı tamamlayın';

  @override
  String get learningGoToCourses => 'Kurslarıma Git';

  @override
  String learningCertIssuedDate(String date) {
    return 'Yayınlanma Tarihi: $date';
  }

  @override
  String get learningCertView => 'Görüş';

  @override
  String get learningResumeLesson => 'Derse Devam Et';

  @override
  String learningProgressPercentComplete(String percent) {
    return '%$percent tamamlandı';
  }

  @override
  String learningViewCartCount(String count) {
    return 'Sepet Öğelerini Görüntüle ($count)';
  }

  @override
  String get learningGoToCart => 'Sepete Git';

  @override
  String get playerLessonMarkedCompleted =>
      'Ders tamamlandı olarak işaretlendi ✓';

  @override
  String get playerLessonMarkedIncomplete =>
      'Ders tamamlanmamış olarak işaretlendi';

  @override
  String get playerCommentPostedSuccess => 'Yorum başarıyla gönderildi';

  @override
  String get playerCommentPostFailed => 'Yorum gönderilemedi';

  @override
  String get playerReplyPostedSuccess => 'Yanıt başarıyla gönderildi';

  @override
  String get playerReplyPostFailed => 'Yanıt gönderilemedi';

  @override
  String get playerCourseNotFound => 'Kurs bulunamadı';

  @override
  String get playerCheckEnrollmentPrompt =>
      'Lütfen önce ders kaydınızı doğrulayın';

  @override
  String get playerReturnToCourses => 'Öğrenimlerim';

  @override
  String get playerWatchLecture => 'Ders Anlatımı';

  @override
  String get playerCertificateTooltip => 'Sertifika';

  @override
  String get playerRateCourseTooltip => 'Kurs Oranı';

  @override
  String get playerReadingArticleBadge => 'Makaleyi Okumak • 5 dakika';

  @override
  String get playerReadFullTextBelow => 'Aşağıdaki tam metni okuyun ↓';

  @override
  String get playerTabReviews => 'Yorumlar';

  @override
  String get playerNoSectionsAvailable => 'Hiçbir bölüm mevcut değil';

  @override
  String playerLessonsCount(String count) {
    return '$count ders';
  }

  @override
  String get playerPlayingBadge => 'Oynanıyor';

  @override
  String get playerArticleBadge => 'Madde';

  @override
  String get playerVideoBadge => 'Video';

  @override
  String get playerFullArticleContent => 'Tam Makale İçeriği';

  @override
  String get playerArticlePlaceholder =>
      'Bu okuma dersine hoş geldiniz.\n\nBu bölüm, bu dersteki becerilerde uzmanlaşmak için ihtiyaç duyduğunuz temel kavramları ve pratik adımları kapsar.';

  @override
  String get playerAboutCourseTitle => 'Bu Kurs Hakkında';

  @override
  String get playerShowLess => 'Daha Az Göster';

  @override
  String get playerReadMore => 'Devamını oku';

  @override
  String get playerWhatYouWillLearn => 'Ne Öğreneceksiniz';

  @override
  String get playerCourseInfoTitle => 'Kurs Detayları';

  @override
  String get playerTotalDurationTitle => 'Toplam Süre';

  @override
  String get playerTotalLessonsTitle => 'Toplam Ders';

  @override
  String playerLessonsNumber(String count) {
    return '$count ders';
  }

  @override
  String get playerLevelTitle => 'Seviye';

  @override
  String get playerAllLevels => 'Tüm Seviyeler';

  @override
  String get playerLanguageTitle => 'Dil';

  @override
  String get playerLanguageArabic => 'Arapça';

  @override
  String get playerPrerequisitesTitle => 'Kurs Gereksinimleri';

  @override
  String get playerCertificateCardTitle => 'Kurs Sertifikası';

  @override
  String get playerCourseCompletedSuccess => 'Tebrikler! Kurs tamamlandı';

  @override
  String get playerProgressLabel => 'İlerlemek';

  @override
  String get playerViewCertificateBtn => 'Sertifikayı Görüntüle';

  @override
  String get playerCertifiedInstructor => 'Sertifikalı Eğitmen';

  @override
  String playerDiscussionsCount(String count) {
    return '$count sorular ve tartışmalar';
  }

  @override
  String get playerAskQuestionHint => 'Sorunuzu veya sorgunuzu buraya yazın...';

  @override
  String get playerPostBtn => 'Postalamak';

  @override
  String get playerNoDiscussionsTitle => 'Henüz tartışma yok';

  @override
  String get playerNoDiscussionsSubtitle => 'İlk soru soran siz olun!';

  @override
  String get playerInstructorBadge => 'Eğitmen';

  @override
  String get playerCancelReply => 'İptal etmek';

  @override
  String get playerReplyAction => 'Cevap vermek';

  @override
  String playerRepliesCount(String count) {
    return '$count yanıtlar';
  }

  @override
  String get playerWriteReplyHint => 'Cevabınızı yazın...';

  @override
  String get playerSendReplyBtn => 'Cevap vermek';

  @override
  String get playerCourseFeedbackTitle =>
      'Kurs Değerlendirmesi ve Geri Bildirim';

  @override
  String get playerOutOf5 => '5 üzerinden';

  @override
  String playerRatingsFromEnrolledCount(String count) {
    return 'Kayıtlı öğrencilerden $count puan';
  }

  @override
  String get playerKeepLearningToRate =>
      'Derecelendirmeyi öğrenmeye devam edin';

  @override
  String get playerRateAfter80Hint =>
      'İçeriğinin %80\'ini tamamladıktan sonra bu kursu inceleyebilir ve puanlayabilirsiniz.';

  @override
  String get playerCurrentProgressLabel => 'İlerlemeniz:';

  @override
  String get playerYourCurrentRating => 'Derecelendirmeniz';

  @override
  String get playerEditRating => 'Derecelendirmeyi Düzenle';

  @override
  String get playerDeleteRatingTooltip => 'Derecelendirmeyi Sil';

  @override
  String get playerUpdateRatingTitle => 'Derecelendirmenizi Güncelleyin';

  @override
  String get playerRateCourseTitle => 'Bu Kursu Değerlendirin';

  @override
  String get playerWriteReviewHint =>
      'İçerik kalitesiyle ilgili geri bildirimlerinizi ve düşüncelerinizi yazın (isteğe bağlı)...';

  @override
  String get playerRatingSubmitSuccess => 'Değerlendirme başarıyla gönderildi!';

  @override
  String get playerRatingSubmitFailed => 'Derecelendirme gönderilemedi';

  @override
  String get playerSaveChangesBtn => 'Değişiklikleri Kaydet';

  @override
  String get playerSubmitReviewBtn => 'İncelemeyi Gönder';

  @override
  String get playerLearnerReviewsTitle => 'Öğrenci İncelemeleri';

  @override
  String playerReviewsCount(String count) {
    return '$count inceleme';
  }

  @override
  String get playerNoWrittenReviewsTitle => 'Henüz yazılı inceleme yok';

  @override
  String get playerNoWrittenReviewsSubtitle =>
      'Düşüncelerinizi ilk paylaşan siz olun!';

  @override
  String get playerRatingLabel5 => 'Mükemmel 🌟 (5/5)';

  @override
  String get playerRatingLabel4 => 'Çok İyi 👍 (4/5)';

  @override
  String get playerRatingLabel3 => 'Ortalama 👌 (3/5)';

  @override
  String get playerRatingLabel2 => 'Geliştirilmesi Gerekiyor 🤔 (2/5)';

  @override
  String get playerRatingLabel1 => 'Kötü 👎 (1/5)';

  @override
  String get playerDeleteRatingDialogTitle => 'Derecelendirmeyi Sil';

  @override
  String get playerDeleteRatingDialogMessage =>
      'Bu kursa ilişkin değerlendirmenizi silmek istediğinizden emin misiniz?';

  @override
  String get playerDeleteConfirmBtn => 'Silmek';

  @override
  String get playerRatingDeleteSuccess => 'Derecelendirme başarıyla silindi';

  @override
  String get playerPreviousLesson => 'Önceki Ders';

  @override
  String get playerExitFullscreenTooltip => 'Tam Ekrandan Çık';

  @override
  String instructorsAvailableCount(String count) {
    return '$count eğitmen mevcut';
  }

  @override
  String get instructorsNotFound => 'Eğitmen bulunamadı';

  @override
  String instructorsCoursesCount(String count) {
    return '$count kurs';
  }

  @override
  String get instructorsSearchHint =>
      'Eğitmen adına veya uzmanlığına göre arayın...';

  @override
  String get instructorsSortAll => 'Tüm';

  @override
  String get instructorsSortTopRated => 'En Çok Oy Alan';

  @override
  String get instructorsSortMostStudents => 'Çoğu Öğrenci';

  @override
  String get instructorsSortMostCourses => 'Çoğu Kurs';

  @override
  String get instructorsNotFoundSubtitle =>
      'Farklı bir adla aramayı veya filtreleri temizlemeyi deneyin';

  @override
  String get exploreCompleteCourse => 'Kapsamlı Kurs';

  @override
  String get exploreGeneralCategory => 'Genel';

  @override
  String courseShareMessage(String title, String url) {
    return 'EduLab\'daki \"$title\" kursuna göz atın: $url';
  }

  @override
  String get courseDetailsDefaultTitle => 'Kurs Detayları';

  @override
  String get courseDetailsTooltipShare => 'Paylaşmak';

  @override
  String get courseDetailsTooltipWishlist => 'İstek listesi';

  @override
  String get courseDetailsTooltipCart => 'Sepet';

  @override
  String get courseDetailsNotFound => 'Kurs bulunamadı';

  @override
  String get courseDetailsDefaultCategory => 'Kurs';

  @override
  String courseDetailsTotalRatingsCount(String count) {
    return '($count derecelendirme)';
  }

  @override
  String courseDetailsLecturesCount(String count) {
    return '$count ders';
  }

  @override
  String get courseDetailsCertificateBadge => 'Sertifika';

  @override
  String get courseDetailsTabOverview => 'Genel Bakış';

  @override
  String get courseDetailsTabCurriculum => 'Müfredat';

  @override
  String get courseDetailsTabInstructor => 'Eğitmen';

  @override
  String get courseDetailsTabReviews => 'Yorumlar';

  @override
  String get courseDetailsFullDescriptionTitle => 'Tanım';

  @override
  String get courseDetailsShowLess => 'Daha az göster';

  @override
  String get courseDetailsShowMore => 'Daha fazlasını göster...';

  @override
  String courseDetailsCurriculumSectionsLectures(
    String sections,
    String lectures,
  ) {
    return '$sections bölümler • $lectures dersler';
  }

  @override
  String get courseDetailsCollapseAll => 'Tümünü daralt';

  @override
  String get courseDetailsExpandAll => 'Tümünü genişlet';

  @override
  String get courseDetailsCurriculumComingSoon =>
      'Müfredat detayları yakında gelecek';

  @override
  String courseDetailsSectionLecturesCount(String count) {
    return '$count ders';
  }

  @override
  String get courseDetailsLecturePreviewBtn => 'Önizleme';

  @override
  String get courseDetailsDefaultInstructorTitle =>
      'Kıdemli Eğitmen ve Sertifikalı Uzman';

  @override
  String get courseDetailsInstructorRatingLabel => 'Derecelendirme';

  @override
  String get courseDetailsInstructorStudentsLabel => 'Öğrenciler';

  @override
  String get courseDetailsInstructorSectionsLabel => 'Bölümler';

  @override
  String get courseDetailsAboutInstructorTitle => 'Eğitmen Hakkında:';

  @override
  String get courseDetailsDefaultInstructorAbout =>
      'Dünya çapında binlerce öğrenciye profesyonel eğitim sunma konusunda geniş deneyime sahip sertifikalı eğitmen.';

  @override
  String courseDetailsStudentRatingsCount(String count) {
    return '$count öğrenci derecelendirmesi';
  }

  @override
  String get courseDetailsNoWrittenReviews => 'Henüz yazılı inceleme yok';

  @override
  String get courseDetailsRelatedCourses => 'Beğenebileceğiniz İlgili Kurslar';

  @override
  String courseDetailsDiscountPercent(String percent) {
    return '$percent% KAPALI';
  }

  @override
  String get courseDetailsResumeCourse => 'Kursa Devam Et';

  @override
  String get courseDetailsTryAgain => 'Tekrar deneyin';

  @override
  String get courseDetailsEstimatedReading => '📖 Tahmini okuma: 4 dakika';

  @override
  String get courseDetailsSampleArticleContent =>
      'Bu makale dersine hoş geldiniz.\n\nBu bölüm, konuya hakim olmak için temel teorik kavramları ve pratik adımları kapsamaktadır.\n\n• Temel Çıkarımlar:\n1. Temel terminolojiyi ve mimari kalıpları kavrayın.\n2. Uygulamalı alıştırmalar ve sürekli pratik.\n3. Referans ek notları ve ödevleri.\n\nOkumanın tadını çıkarın!';

  @override
  String certDownloadedSuccess(String course, String format) {
    return '\"$course\" sertifikası $format biçiminde başarıyla indirildi!';
  }

  @override
  String certVerifiedFullRequirements(String code) {
    return 'Doğrulama Kimliği: $code • Gereksinimlerin %100\'ü Tamamlandı';
  }

  @override
  String get certCompletionTitle => 'Bitirme Sertifikası';

  @override
  String get certCompletionSubtitle => 'Kurs Bitirme Sertifikası';

  @override
  String get certAnnounceStudent =>
      'EducationLab Learning Academy işbu belgeyle şunları onaylar:';

  @override
  String get certCompletionRequirementsMet =>
      'Eğitim kursunun tüm gerekliliklerini başarıyla tamamladı:';

  @override
  String certIssueDateText(String date) {
    return 'Veriliş Tarihi: $date';
  }

  @override
  String certIdNumberText(String code) {
    return 'Sertifika Kimliği: $code';
  }

  @override
  String get certPlatformManagement => 'Platform Yönetimi';

  @override
  String get certInstructorRoleTitle => 'Kurs Eğitmeni';

  @override
  String get commonLoading => 'Yükleniyor...';

  @override
  String get homeGuestTagline =>
      'Akıllı öğrenme ve beceri geliştirme platformu';

  @override
  String get catTagHighestDemand => 'En Çok Talep Edilen';

  @override
  String get catTagMostPopular => 'En Popüler';

  @override
  String get catTagTrending => 'Trend';

  @override
  String get catTagFastestGrowing => 'En Hızlı Büyüyen';

  @override
  String get catTagHighDemand => 'Yüksek Talep';

  @override
  String get catTagTopRated => 'En Çok Puan Alan';

  @override
  String get catTagEssential => 'Çok Önemli';

  @override
  String get catTagAdvanced => 'İleri Düzey';

  @override
  String get catTagEntrepreneurs => 'Girişimciler';

  @override
  String get catTagSalesGrowth => 'Satış Büyümesi';

  @override
  String get catDevTitle => 'Programlama ve Yazılım Geliştirme';

  @override
  String get catDevSubtitle =>
      'Yazılım Mühendisliği, Sistemler ve Algoritmalar';

  @override
  String get catWebTitle => 'Web Geliştirme';

  @override
  String get catWebSubtitle => 'Frontend, Backend ve Fullstack Web';

  @override
  String get catMobileTitle => 'Mobil Uygulama Geliştirme';

  @override
  String get catMobileSubtitle => 'Flutter, iOS ve Android Mobil Uygulamaları';

  @override
  String get catAiTitle => 'Yapay Zeka';

  @override
  String get catAiSubtitle => 'Makine Öğrenimi, Derin Öğrenme ve Yapay Zeka';

  @override
  String get catDataTitle => 'Veri Bilimi ve Analitik';

  @override
  String get catDataSubtitle => 'Veri Analizi, İstatistik ve Büyük Veri';

  @override
  String get catDesignTitle => 'UI/UX ve Ürün Tasarımı';

  @override
  String get catDesignSubtitle => 'UI/UX, Prototipleme ve Ürün Tasarımı';

  @override
  String get catSecurityTitle => 'Siber Güvenlik ve Ağlar';

  @override
  String get catSecuritySubtitle => 'Siber Güvenlik, Etik Hackleme ve Ağlar';

  @override
  String get catCloudTitle => 'Bulut Bilişim ve DevOps';

  @override
  String get catCloudSubtitle => 'Bulut Altyapısı, DevOps ve CI/CD';

  @override
  String get catBusinessTitle => 'İşletme ve Proje Yönetimi';

  @override
  String get catBusinessSubtitle => 'Girişimcilik, Çevik Yönetim ve Liderlik';

  @override
  String get catMarketingTitle => 'Dijital Pazarlama';

  @override
  String get catMarketingSubtitle =>
      'Dijital Pazarlama, SEO ve Büyüme Stratejileri';

  @override
  String get timeJustNow => 'Az önce';

  @override
  String timeMinutesAgo(String count) {
    return '$count dk önce';
  }

  @override
  String timeHoursAgo(String count) {
    return '$count saat önce';
  }

  @override
  String timeDaysAgo(String count) {
    return '$count gün önce';
  }

  @override
  String timeWeeksAgo(String count) {
    return '$count hafta önce';
  }

  @override
  String timeMonthsAgo(String count) {
    return '$count ay önce';
  }

  @override
  String wishlistLecturesCount(String count) {
    return '$count ders';
  }

  @override
  String get instructorProfileTitle => 'Eğitmen Profili';

  @override
  String instructorProfileLinkCopied(String name) {
    return '$name için bağlantı panoya kopyalandı';
  }

  @override
  String get instructorDefaultName => 'Eğitmen';

  @override
  String get instructorProfileBadge => 'EĞİTMEN';

  @override
  String get instructorProfileTotalStudents => 'Toplam Öğrenci';

  @override
  String get instructorProfileRating => 'Eğitmen Puanı';

  @override
  String get instructorProfileCourses => 'Kurslar';

  @override
  String get instructorProfileShare => 'Profili Paylaş';

  @override
  String get instructorProfileLinkOpenError =>
      'Bağlantı açılamadı, panoya kopyalandı';

  @override
  String get instructorProfileWebsite => 'Web Sitesi';

  @override
  String get instructorProfileAboutMe => 'Hakkımda';

  @override
  String get instructorProfileShowLess => 'Daha az göster';

  @override
  String get instructorProfileShowMore => 'Daha fazla göster';

  @override
  String get instructorProfileExpertise => 'Uzmanlık Alanları';

  @override
  String get instructorProfileSortAll => 'Tümü';

  @override
  String get instructorProfileSortTopRated => 'En Yüksek Puanlı';

  @override
  String get instructorProfileSortPopular => 'Popüler';

  @override
  String get instructorProfileSortNewest => 'En Yeni';

  @override
  String get instructorProfileCoursesTitle => 'Eğitmen Kursları';

  @override
  String get instructorProfileNoCoursesFilter =>
      'Bu filtre için kurs bulunamadı';

  @override
  String instructorProfileLoadMoreCourses(String count) {
    return 'Daha Fazla Kurs Yükle ($count kaldı)';
  }

  @override
  String get instructorProfileLoadingMoreCourses =>
      'Daha fazla kurs yükleniyor...';

  @override
  String instructorProfileAllCoursesLoaded(String count) {
    return 'Tüm $count kurs yüklendi';
  }

  @override
  String get instructorProfileStudentFeedback => 'Öğrenci Geri Bildirimleri';

  @override
  String instructorProfileReviewsCount(String count) {
    return '$count değerlendirme';
  }

  @override
  String instructorProfileBasedOnReviews(String count) {
    return '$count değerlendirmeye göre';
  }

  @override
  String get instructorProfileRecentReviews => 'Son Değerlendirmeler';

  @override
  String instructorProfileLoadMoreReviews(String count) {
    return 'Daha Fazla Değerlendirme Yükle ($count kaldı)';
  }

  @override
  String get instructorProfileLoadingMoreReviews =>
      'Daha fazla değerlendirme yükleniyor...';

  @override
  String instructorProfileAllReviewsLoaded(String count) {
    return 'Tüm $count değerlendirme yüklendi';
  }

  @override
  String get instructorProfileNoReviewsYet =>
      'Henüz yazılı bir değerlendirme yok';

  @override
  String get instructorProfileRatingDesc =>
      'Puan, eğitmenin tüm kurslarındaki genel öğrenci değerlendirmelerine dayanmaktadır';

  @override
  String get instructorProfileLoadError =>
      'Eğitmen bilgileri yüklenemedi, lütfen daha sonra tekrar deneyin';

  @override
  String get instructorProfileDefaultStudentName => 'Öğrenci';

  @override
  String get instructorProfileDefaultHeadline =>
      'Kıdemli Eğitmen ve Sertifikalı Uzman';

  @override
  String get instructorProfileDefaultBio =>
      'Ölçeklenebilir yazılım sistemleri ve mobil uygulamalar geliştirme konusunda geniş deneyime sahip, sertifikalı yazılım mühendisi ve teknik eğitmen.\nDünya çapında binlerce öğrenciye ve mühendise eğitim vermiş; temiz kod, temiz mimari ve modern ölçeklenebilir çözümlere odaklanan profesyonel içerikler sunmuştur.';

  @override
  String get supportNewChat => 'Yeni Sohbet';

  @override
  String get supportNoChatsTitle => 'Henüz Destek Sohbeti Yok';

  @override
  String get supportNoChatsDesc =>
      'Destek ekibimiz tüm sorularınızı yanıtlamak ve size yardımcı olmak için 7/24 hazır';

  @override
  String get supportStartNewConversation => 'Yeni Konuşma Başlat';

  @override
  String get supportNoMessagesYet => 'Henüz mesaj yok';

  @override
  String get supportRetry => 'Tekrar Dene';

  @override
  String get supportOpenTicket => 'Açık Destek Talebi';

  @override
  String get supportClosedTicket => 'Kapatılan Destek Talebi';

  @override
  String get supportCloseAction => 'Kapat';

  @override
  String get supportReopenAction => 'Yeniden Aç';

  @override
  String get supportNoMessagesInChat => 'Bu sohbette henüz mesaj yok';

  @override
  String get supportYou => 'Siz';

  @override
  String get supportTeam => 'Destek Ekibi';

  @override
  String get supportTypeMessageHint => 'Mesajınızı buraya yazın...';

  @override
  String get supportConversationClosedNotice => 'Bu konuşma şu anda kapatıldı.';

  @override
  String get supportCloseDialogTitle => 'Konuşmayı Kapat?';

  @override
  String get supportCloseDialogDesc =>
      'Bu sohbeti kapatmak istediğinizden emin misiniz? Mesajlaşmaya devam etmek için istediğiniz zaman yeniden açabilirsiniz.';

  @override
  String get supportCancel => 'İptal';

  @override
  String get supportYesClose => 'Evet, Kapat';

  @override
  String get supportNewChatTitle => 'Yeni Destek Sohbeti';

  @override
  String get supportNewChatSubtitle =>
      'Ekibimiz size yardımcı olmak için burada';

  @override
  String get supportSubjectLabel => 'Konu';

  @override
  String get supportSubjectHint => 'örn: Kurs sorgusu, Ödeme sorunu...';

  @override
  String get supportMessageLabel => 'Mesaj';

  @override
  String get supportMessageHint =>
      'Sorununuzu veya sorunuzu ayrıntılı olarak açıklayın...';

  @override
  String get supportMessageRequired => 'Lütfen bir mesaj girin';

  @override
  String get supportStartConversationBtn => 'Konuşmayı Başlat';

  @override
  String get supportCreateError =>
      'Konuşma oluşturulamadı, lütfen daha sonra tekrar deneyin';

  @override
  String get supportTopicCourse => 'Kurs Sorgusu';

  @override
  String get supportTopicPayment => 'Ödeme Sorunu';

  @override
  String get supportTopicCertificates => 'Sertifikalar';

  @override
  String get supportTopicTech => 'Teknik Sorun';

  @override
  String get supportTopicGeneral => 'Genel Sorgu';

  @override
  String get cartGuestTitle => 'Sepetinizi görüntülemek için giriş yapın';

  @override
  String get cartGuestSubtitle =>
      'Sepetinize erişmek ve kursları satın almak için lütfen giriş yapın.';

  @override
  String get wishlistGuestTitle =>
      'İstek listenizi görüntülemek için giriş yapın';

  @override
  String get wishlistGuestSubtitle =>
      'Kaydettiğiniz kurslara istediğiniz zaman erişmek için lütfen giriş yapın.';

  @override
  String get courseDetailsLoginRequiredTitle => 'Giriş Yapılması Gerekiyor';

  @override
  String get courseDetailsLoginRequiredDesc =>
      'Bu kursu satın almak ve ilerlemenizi kaydetmek için önce giriş yapmalısınız.';

  @override
  String get courseDetailsProceedToLogin => 'Giriş Yapmaya Git';

  @override
  String get messagesGuestTitle => 'Mesajları görüntülemek için giriş yapın';

  @override
  String get messagesGuestSubtitle =>
      'Destek görüşmelerine erişmek için lütfen giriş yapın.';

  @override
  String get notificationsGuestTitle =>
      'Bildirimleri görüntülemek için giriş yapın';

  @override
  String get notificationsGuestSubtitle =>
      'Hesabınız ve kurslarınızla ilgili son bildirimleri görmek için lütfen giriş yapın.';

  @override
  String get legalTitle => 'Hakkında & Yasal Bilgiler';

  @override
  String get legalTabAbout => 'EduLab Hakkında';

  @override
  String get legalTabPrivacy => 'Gizlilik';

  @override
  String get legalTabTerms => 'Şartlar';

  @override
  String get legalUpdated => 'Güncellendi:';

  @override
  String get legalNeedHelpTitle =>
      'Yardıma mı ihtiyacınız var veya sorunuz mu var?';

  @override
  String get legalNeedHelpDesc =>
      'EduLab destek ekibi 7/24 yanınızda. Bize doğrudan e-posta ile ulaşabilirsiniz.';

  @override
  String get legalEmailCopied => 'Destek e-postası panoya kopyalandı';

  @override
  String get legalNoContent => 'Şu anda içerik bulunmamaktadır';

  @override
  String get checkoutDigitalReceipt => 'Dijital Makbuz';

  @override
  String get checkoutTransactionDate => 'İşlem Tarihi';

  @override
  String get checkoutFreeEnrollment => 'Ücretsiz Kayıt';

  @override
  String get checkoutEnrolledCourses => 'Kayıt Olunan Kurslar';

  @override
  String get checkoutTransactionStatus => 'Durum';

  @override
  String get checkoutStatusSuccess => 'Başarıyla Tamamlandı';

  @override
  String get checkoutTotalPaid => 'Ödenen Toplam Tutar';

  @override
  String get checkoutCopied => 'Kopyalandı!';

  @override
  String get checkoutCardHolderHint => 'Kartın üzerindeki tam isim';

  @override
  String get teachUploadProfilePhoto => 'Profil Fotoğrafı Yükle';

  @override
  String get teachAttachCV => 'CV (Özgeçmiş) Ekle';

  @override
  String get teachChooseClearPhotoForAccount =>
      'Eğitmen hesabınız için net bir fotoğraf seçin';

  @override
  String get teachChooseClearDocForCV =>
      'CV\'nizin net bir belgesini veya fotoğrafını seçin';

  @override
  String get teachTakePhoto => 'Fotoğraf Çek';

  @override
  String get teachTakePhotoSubtitle =>
      'Yeni bir fotoğraf çekmek için kamerayı kullanın';

  @override
  String get teachChooseFromGallery => 'Galeriden Seç';

  @override
  String get teachChooseFromGallerySubtitle => 'Cihazınızdan bir dosya seçin';

  @override
  String get teachAddOneSkillRequired => 'Lütfen en az bir beceri ekleyin';

  @override
  String get teachAgreeTermsRequired =>
      'Devam etmek için lütfen eğitmen şartlarını ve koşullarını kabul edin';

  @override
  String get teachApplicationReceivedTitle => 'Başvurunuz başarıyla alındı!';

  @override
  String get teachApplicationReceivedDesc =>
      'EduLab eğitmen topluluğuna katıldığınız için teşekkür ederiz. Akademik inceleme ekibimiz başvurunuzu inceleyecek ve bir karar verildiğinde size bildirilecektir.';

  @override
  String get teachTrackApplicationStatus => 'Başvuru Durumunu Takip Et';

  @override
  String get teachRefreshTooltip => 'Yenile';

  @override
  String get teachVerifyingApplicationData =>
      'Başvuru verileri doğrulanıyor...';

  @override
  String get teachAlreadyInstructor => 'Zaten onaylanmış bir eğitmensiniz!';

  @override
  String get teachAlreadyInstructorDesc =>
      'Hesabınız tam eğitmen izinlerine sahip. Eğitmen panelinden kurslarınızı yönetebilir ve yeni içerik yayınlayabilirsiniz.';

  @override
  String get teachBackToHome => 'Ana Sayfaya Dön';

  @override
  String get teachStatusApproved => 'Eğitmen başvurunuz onaylandı';

  @override
  String get teachStatusRejected => 'Başvurunuz reddedildi';

  @override
  String get teachStatusPending => 'Başvurunuz şu anda inceleniyor';

  @override
  String get teachApplicationDetails => 'Başvuru Detayları';

  @override
  String get teachApplicationNumber => 'Başvuru Numarası';

  @override
  String get teachApplicationDate => 'Başvuru Tarihi';

  @override
  String get teachApplicant => 'Başvuran';

  @override
  String get teachApplicantEmail => 'E-posta';

  @override
  String get teachSpecialization => 'Uzmanlık';

  @override
  String get teachExperienceYears => 'Deneyim Yılı';

  @override
  String get teachCVLabel => 'CV / Özgeçmiş';

  @override
  String get teachCVAttached => 'Eklendi ✓';

  @override
  String get teachReapply => 'Yeni Başvuru Gönder';

  @override
  String get teachRefreshing => 'Yenileniyor...';

  @override
  String get teachRefreshStatus => 'Başvuru Durumunu Yenile';

  @override
  String get teachApprovedMessage =>
      'Tebrikler! Artık eğitim kurslarınızı yüklemeye ve paylaşmaya başlayabilirsiniz.';

  @override
  String teachRejectionReason(String reason) {
    return 'Reddedilme nedeni: $reason';
  }

  @override
  String get teachRejectedDefault =>
      'Maalesef başvuru mevcut gereksinimleri karşılamadı. Verilerinizi inceleyip tekrar başvurabilirsiniz.';

  @override
  String get teachPendingMessage =>
      'Başvurunuz alındı ve şu anda platform yönetimi tarafından inceleniyor. Karar size bildirilecektir.';

  @override
  String get teachStepPersonalData => 'Kişisel Bilgiler';

  @override
  String get teachStepExperienceSkills => 'Deneyim ve Beceriler';

  @override
  String get teachStepReviewApplication => 'Başvuruyu İncele';

  @override
  String get teachStep1HeaderTitle => '1. Kişisel ve Mesleki Bilgiler';

  @override
  String get teachFullNameLabel => 'Ad Soyad *';

  @override
  String get teachFullNameHintAr => 'örn. Ali Yılmaz';

  @override
  String get teachFullNameValidation => 'Lütfen geçerli bir ad girin';

  @override
  String get teachEmailReadonly => 'E-posta (Kayıtlı Hesap)';

  @override
  String get teachPhoneLabelContact => 'İletişim Numarası *';

  @override
  String get teachPhoneValidation =>
      'Lütfen geçerli bir telefon numarası girin';

  @override
  String get teachBioLabelWithAsterisk => 'Hakkımda *';

  @override
  String teachBioCharCount(String count) {
    return '$count / 200 karakter';
  }

  @override
  String get teachBioHintDetail =>
      'Kariyeriniz ve uzmanlık alanınız hakkında kısa bir özet yazın (maks. 200 karakter)...';

  @override
  String get teachBioMinLengthValidation =>
      'Hakkımda en az 10 karakter olmalıdır';

  @override
  String get teachBioMaxLengthValidation =>
      'Hakkımda 200 karakteri geçmemelidir';

  @override
  String get teachProfilePhotoOptional =>
      'Eğitmen Profil Fotoğrafı (İsteğe Bağlı)';

  @override
  String get teachNextExperienceSkills => 'Devam Et: Deneyim ve Beceriler';

  @override
  String get teachStep2HeaderTitle => '2. Akademik Deneyim ve Beceriler';

  @override
  String get teachSpecializationLabel => 'Uzmanlık *';

  @override
  String get teachSpecializationHint => 'Uzmanlık seçin';

  @override
  String get teachExperienceLabel => 'Deneyim Yılı *';

  @override
  String get teachExperience0to2 => '2 yıldan az (0 - 2)';

  @override
  String get teachExperience2to5 => '2 ila 5 yıl (2 - 5)';

  @override
  String get teachExperience5to10 => '5 ila 10 yıl (5 - 10)';

  @override
  String get teachExperience10plus => '10 yıldan fazla (10+)';

  @override
  String get teachSkillsLabel => 'Beceriler ve Teknolojiler *';

  @override
  String get teachSkillHint => 'Beceri ekle (örn. Flutter, Dart, UI/UX)...';

  @override
  String get teachSkillAddButton => 'Ekle';

  @override
  String get teachSkillMinRequired => '* Lütfen en az bir beceri ekleyin';

  @override
  String get teachCVFileLabel => 'CV Dosyası (Özgeçmiş)';

  @override
  String get teachPrevButton => 'Önceki';

  @override
  String get teachNextReviewApplication => 'Devam Et: Başvuruyu İncele';

  @override
  String get teachStep3HeaderTitle => '3. Başvuruyu İncele ve Şartları Onayla';

  @override
  String get teachReviewBanner =>
      'Lütfen göndermeden önce girilen tüm verileri dikkatlice inceleyin. Gönderildikten sonra hesap durumunuz inceleme bekleyen eğitmen olarak güncellenecektir.';

  @override
  String get teachSummaryFullName => 'Ad Soyad';

  @override
  String get teachSummaryEmail => 'E-posta';

  @override
  String get teachSummaryPhone => 'Telefon Numarası';

  @override
  String get teachSummarySpecialization => 'Akademik Uzmanlık';

  @override
  String get teachSummaryExperience => 'Deneyim Yılı';

  @override
  String teachSummarySkillsCount(String count, String skills) {
    return '$count beceri ($skills)';
  }

  @override
  String get teachSummaryProfilePhoto => 'Profil Fotoğrafı';

  @override
  String get teachSummaryPhotoSelected => 'Seçildi ✓';

  @override
  String get teachSummaryPhotoNotSelected => 'Seçilmedi';

  @override
  String get teachSummaryCVFile => 'CV (Özgeçmiş)';

  @override
  String get teachSummaryCVAttached => 'Eklendi ✓';

  @override
  String get teachSummaryCVNotAttached => 'Eklenmedi';

  @override
  String get teachTermsAgreement =>
      'EduLab eğitmenlik şartlarını, koşullarını ve fikri mülkiyet sözleşmesini kabul ediyorum.';

  @override
  String get teachSubmitButton => 'Eğitmen Başvurusunu Gönder';

  @override
  String get teachPhotoSelectedSuccess => 'Fotoğraf başarıyla seçildi';

  @override
  String get teachChoosePhotoFromDevice =>
      'Cihazınızdan bir profil fotoğrafı seçin';

  @override
  String get teachCVAttachedSuccess => 'CV başarıyla eklendi';

  @override
  String get teachAttachCVFileOrPhoto => 'CV Ekle (dosya veya fotoğraf)';

  @override
  String get teachSummarySkillsLabel => 'Eklenen Beceriler';
}

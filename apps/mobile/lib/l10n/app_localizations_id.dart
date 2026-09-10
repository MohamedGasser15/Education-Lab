// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get onboardingSkip => 'Lewati';

  @override
  String get onboardingTitle1 => 'Selamat Datang di EduLab';

  @override
  String get onboardingSubtitle1 =>
      'Platform ideal Anda untuk pembelajaran interaktif modern dan perkembangan karier berkelanjutan.';

  @override
  String get onboardingTitle2 => 'Belajar dari Instruktur Terbaik';

  @override
  String get onboardingSubtitle2 =>
      'Ribuan kursus profesional di bidang pemrograman, desain, bisnis, dan data science.';

  @override
  String get onboardingTitle3 => 'Sertifikat & Sukses Terjamin';

  @override
  String get onboardingSubtitle3 =>
      'Pantau kemajuan Anda, lulus ujian, dan raih sertifikat yang diakui.';

  @override
  String get onboardingNext => 'Lanjut';

  @override
  String get onboardingStart => 'Mulai Sekarang';

  @override
  String get splashAppName => 'Education Lab';

  @override
  String get splashTagline => 'Platform Pembelajaran Cerdas';

  @override
  String get loginTagline => 'Selamat datang di platform pembelajaran cerdas';

  @override
  String get loginAppName => 'EduLab';

  @override
  String get loginTabLogin => 'Masuk';

  @override
  String get loginTabRegister => 'Daftar';

  @override
  String get loginEmailLabel => 'Email';

  @override
  String get loginEmailHint => 'contoh@email.com';

  @override
  String get loginPasswordLabel => 'Kata Sandi';

  @override
  String get loginPasswordHint => '••••••';

  @override
  String get loginForgotPassword => 'Lupa kata sandi?';

  @override
  String get loginSubmit => 'Masuk';

  @override
  String get loginSubmitLoading => 'Sedang masuk';

  @override
  String get loginGuest => 'Masuk sebagai Tamu';

  @override
  String get loginOr => 'atau';

  @override
  String get loginEmailRequired => 'Email wajib diisi';

  @override
  String get loginEmailInvalid => 'Masukkan alamat email yang valid';

  @override
  String get loginPasswordRequired => 'Kata sandi wajib diisi';

  @override
  String get registerStepEmail => 'Email';

  @override
  String get registerStepCode => 'Kode';

  @override
  String get registerStepData => 'Data';

  @override
  String get registerSendCodeInfo =>
      'Kami akan mengirimkan kode aktivasi ke email ini';

  @override
  String get registerSendCode => 'Kirim Kode Aktivasi';

  @override
  String get registerVerifying => 'Memverifikasi';

  @override
  String get registerCodeSentTo => 'Kode dikirim ke:';

  @override
  String get registerResendCode => 'Kirim Ulang Kode';

  @override
  String get registerBack => 'Kembali';

  @override
  String get registerVerifyCode => 'Verifikasi Kode';

  @override
  String get registerCodeIncomplete => 'Masukkan kode lengkap 6 digit';

  @override
  String get registerFullNameLabel => 'Nama Lengkap';

  @override
  String get registerFullNameHint => 'Nama lengkap Anda';

  @override
  String get registerPasswordHint =>
      'Minimal 8 karakter, huruf besar dan angka';

  @override
  String get registerConfirmLabel => 'Konfirmasi Kata Sandi';

  @override
  String get registerConfirmHint => 'Ketik ulang kata sandi';

  @override
  String get registerSubmit => 'Buat Akun';

  @override
  String get registerSubmitLoading => 'Membuat akun';

  @override
  String get registerSuccess => 'Akun berhasil dibuat';

  @override
  String get registerNameRequired => 'Nama lengkap wajib diisi';

  @override
  String get registerNameMinLength => 'Nama lengkap minimal 6 karakter';

  @override
  String get registerPasswordMinLength => 'Kata sandi minimal 8 karakter';

  @override
  String get registerPasswordUppercase =>
      'Kata sandi harus mengandung minimal satu huruf besar';

  @override
  String get registerPasswordNumber =>
      'Kata sandi harus mengandung minimal satu angka';

  @override
  String get registerConfirmRequired => 'Konfirmasi kata sandi wajib diisi';

  @override
  String get registerConfirmMismatch => 'Kata sandi tidak cocok';

  @override
  String get networkError => 'Terjadi kesalahan koneksi, coba lagi';

  @override
  String homeGreeting(String name) {
    return 'Halo, $name!';
  }

  @override
  String get homeSubtitle => 'Apa yang ingin Anda pelajari hari ini?';

  @override
  String get homeSearchHint => 'Cari kursus atau keahlian...';

  @override
  String get homeSectionContinue => 'Lanjutkan Belajar';

  @override
  String get homeSectionRecommended => 'Direkomendasikan untuk Anda';

  @override
  String get homeSectionPopular => 'Paling Populer';

  @override
  String get homeSectionTopRated => 'Rating Tertinggi';

  @override
  String get homeSectionByCategory => 'Berdasarkan Kategori';

  @override
  String get homeHeroTitle => 'Jelajahi Penawaran Sekarang';

  @override
  String get homeHeroSubtitle => 'Diskon hingga 70% untuk kursus premium';

  @override
  String get homeHeroButton => 'Temukan Sekarang';

  @override
  String get homeViewAll => 'Lihat Semua';

  @override
  String get homeProgressLabel => 'Selesai';

  @override
  String get exploreTitle => 'Jelajahi Kursus';

  @override
  String get exploreSearchHint => 'Cari kursus, keahlian, atau instruktur...';

  @override
  String get exploreAllCategories => 'Semua Kategori';

  @override
  String get exploreFilter => 'Filter';

  @override
  String get exploreSort => 'Urutkan';

  @override
  String get exploreNoResults => 'Tidak ada hasil ditemukan';

  @override
  String get exploreNoResultsHint => 'Coba kata kunci lain atau ubah filter';

  @override
  String exploreCoursesCount(int count) {
    return '$count kursus';
  }

  @override
  String get exploreFilterTitle => 'Filter Hasil';

  @override
  String get exploreFilterApply => 'Terapkan Filter';

  @override
  String get exploreFilterReset => 'Atur Ulang';

  @override
  String get exploreFilterPrice => 'Harga';

  @override
  String get exploreFilterLevel => 'Tingkat';

  @override
  String get exploreFilterRating => 'Rating';

  @override
  String get exploreFilterDuration => 'Durasi';

  @override
  String get exploreSortTitle => 'Urutkan Berdasarkan';

  @override
  String get exploreSortRelevance => 'Paling Relevan';

  @override
  String get exploreSortNewest => 'Terbaru';

  @override
  String get exploreSortPopular => 'Paling Populer';

  @override
  String get exploreSortRating => 'Rating Tertinggi';

  @override
  String get exploreSortPriceLow => 'Harga: Rendah ke Tinggi';

  @override
  String get exploreSortPriceHigh => 'Harga: Tinggi ke Rendah';

  @override
  String get explorePriceFree => 'Gratis';

  @override
  String get exploreLevelBeginner => 'Pemula';

  @override
  String get exploreLevelIntermediate => 'Menengah';

  @override
  String get exploreLevelAdvanced => 'Lanjutan';

  @override
  String get learningTitle => 'Pembelajaran Saya';

  @override
  String get learningTabInProgress => 'Sedang Berjalan';

  @override
  String get learningTabCompleted => 'Selesai';

  @override
  String get learningTabSaved => 'Disimpan';

  @override
  String get learningEmpty => 'Belum ada kursus';

  @override
  String get learningEmptyHint => 'Mulai jelajahi kursus sekarang';

  @override
  String get learningExploreButton => 'Jelajahi Kursus';

  @override
  String learningProgress(int percent) {
    return '$percent% selesai';
  }

  @override
  String get learningContinue => 'Lanjutkan';

  @override
  String get learningViewCertificate => 'Lihat Sertifikat';

  @override
  String get learningReview => 'Beri Nilai Kursus';

  @override
  String get learningLesson => 'Pelajaran';

  @override
  String get learningLessons => 'Pelajaran';

  @override
  String get cartTitle => 'Keranjang';

  @override
  String get cartEmpty => 'Keranjang Anda kosong';

  @override
  String get cartEmptyHint => 'Tambahkan kursus untuk mulai belajar';

  @override
  String get cartExploreButton => 'Jelajahi Kursus';

  @override
  String get cartPromoPlaceholder => 'Kode promo';

  @override
  String get cartPromoApply => 'Terapkan';

  @override
  String get cartPromoInvalid => 'Kode promo tidak valid';

  @override
  String get cartSummary => 'Ringkasan Pesanan';

  @override
  String get cartSubtotal => 'Subtotal';

  @override
  String get cartDiscount => 'Diskon';

  @override
  String get cartTotal => 'Total';

  @override
  String get cartCheckout => 'Checkout';

  @override
  String cartCourses(int count) {
    return '$count kursus';
  }

  @override
  String get cartRemove => 'Hapus';

  @override
  String get cartGuarantee => 'Jaminan Uang Kembali 30 Hari';

  @override
  String get checkoutTitle => 'Pembayaran';

  @override
  String get checkoutStepPayment => 'Pembayaran';

  @override
  String get checkoutStepReview => 'Tinjauan';

  @override
  String get checkoutStepConfirm => 'Konfirmasi';

  @override
  String get checkoutOrderSummary => 'Ringkasan Pesanan';

  @override
  String get checkoutTotal => 'Total';

  @override
  String get checkoutPayNow => 'Bayar Sekarang';

  @override
  String get checkoutBack => 'Kembali';

  @override
  String get checkoutNext => 'Lanjut';

  @override
  String get checkoutSecureSSL => 'Pembayaran aman dengan enkripsi SSL 256-bit';

  @override
  String get checkoutSuccessTitle => 'Pembelian Berhasil!';

  @override
  String get checkoutSuccessSubtitle =>
      'Anda sekarang dapat mengakses kursus Anda';

  @override
  String get checkoutGoToLearning => 'Buka Kursus Saya';

  @override
  String get checkoutPaymentMethod => 'Metode Pembayaran';

  @override
  String get checkoutCardNumber => 'Nomor Kartu';

  @override
  String get checkoutCardName => 'Nama Pemegang Kartu';

  @override
  String get checkoutCardExpiry => 'Masa Berlaku';

  @override
  String get checkoutCardCVV => 'CVV';

  @override
  String get courseDetailsEnroll => 'Daftar Sekarang';

  @override
  String get courseDetailsBuyNow => 'Beli Sekarang';

  @override
  String get courseDetailsAddToCart => 'Tambah ke Keranjang';

  @override
  String get courseDetailsAddedToCart => 'Ditambahkan ke keranjang';

  @override
  String get courseDetailsAlreadyEnrolled => 'Sudah Terdaftar';

  @override
  String get courseDetailsGoToCourse => 'Buka Kursus';

  @override
  String get courseDetailsFree => 'Gratis';

  @override
  String courseDetailsStudents(String count) {
    return '$count siswa';
  }

  @override
  String get courseDetailsRating => 'Rating';

  @override
  String get courseDetailsReviews => 'ulasan';

  @override
  String get courseDetailsLastUpdated => 'Terakhir Diperbarui';

  @override
  String get courseDetailsCurriculum => 'Materi Kursus';

  @override
  String get courseDetailsSection => 'bagian';

  @override
  String get courseDetailsLessons => 'pelajaran';

  @override
  String get courseDetailsInstructor => 'Instruktur';

  @override
  String get courseDetailsStudentsLabel => 'Siswa';

  @override
  String get courseDetailsCoursesLabel => 'Kursus';

  @override
  String get courseDetailsReviewsLabel => 'Ulasan';

  @override
  String get courseDetailsReviewsTitle => 'Ulasan Siswa';

  @override
  String get courseDetailsWhatLearn => 'Yang Akan Anda Pelajari';

  @override
  String get courseDetailsRequirements => 'Persyaratan';

  @override
  String get courseDetailsDescription => 'Deskripsi Kursus';

  @override
  String get courseDetailsIncludesTitle => 'Kursus Ini Mencakup';

  @override
  String get courseDetailsHoursVideo => 'jam video';

  @override
  String get courseDetailsArticles => 'artikel';

  @override
  String get courseDetailsMobileAccess => 'Akses di ponsel dan tablet';

  @override
  String get courseDetailsCertificate => 'Sertifikat kelulusan';

  @override
  String get courseDetailsLifetimeAccess => 'Akses seumur hidup';

  @override
  String get lessonPlayerNotes => 'Catatan Saya';

  @override
  String get lessonPlayerResources => 'Sumber Daya';

  @override
  String get lessonPlayerDiscussion => 'Diskusi';

  @override
  String get lessonPlayerPrev => 'Sebelumnya';

  @override
  String get lessonPlayerNext => 'Berikutnya';

  @override
  String get lessonPlayerSpeed => 'Kecepatan';

  @override
  String get lessonPlayerQuality => 'Kualitas';

  @override
  String get lessonPlayerCompleted => 'Pelajaran selesai';

  @override
  String get certificateTitle => 'Sertifikat Kelulusan';

  @override
  String get certificatePresentedTo => 'Diberikan kepada';

  @override
  String get certificateCompletedCourse =>
      'karena berhasil menyelesaikan kursus';

  @override
  String get certificateIssuedOn => 'Tanggal Penerbitan';

  @override
  String get certificateVerificationId => 'Nomor Verifikasi';

  @override
  String get certificateDownloadPDF => 'Unduh PDF';

  @override
  String get certificateDownloadPNG => 'Unduh Gambar';

  @override
  String get certificateCopyLink => 'Salin Tautan';

  @override
  String get certificateLinkCopied => 'Tautan disalin';

  @override
  String get profileTitle => 'Profil';

  @override
  String get profileEditProfile => 'Edit Profil';

  @override
  String get profileCourses => 'Kursus Saya';

  @override
  String get profileCertificates => 'Sertifikat';

  @override
  String get profilePoints => 'Poin';

  @override
  String get profileFollowers => 'Pengikut';

  @override
  String get profileFollowing => 'Mengikuti';

  @override
  String get profileBio => 'Bio';

  @override
  String get profileInstructor => 'Instruktur';

  @override
  String get profileStudent => 'Siswa';

  @override
  String get profileLevel => 'Tingkat';

  @override
  String get profileJoined => 'Bergabung sejak';

  @override
  String get profileShareProfile => 'Bagikan Profil';

  @override
  String get profileMenuLearning => 'Kursus Saya';

  @override
  String get profileMenuCertificates => 'Sertifikat Saya';

  @override
  String get profileMenuPurchaseHistory => 'Riwayat Pembelian';

  @override
  String get profileMenuTeachApplication => 'Mengajar di EduLab';

  @override
  String get profileMenuAccountSecurity => 'Keamanan Akun';

  @override
  String get profileMenuNotifications => 'Notifikasi';

  @override
  String get profileMenuMessages => 'Pesan';

  @override
  String get profileMenuSettings => 'Pengaturan';

  @override
  String get profileMenuSchedule => 'Jadwal Saya';

  @override
  String get profileMenuAssignments => 'Tugas';

  @override
  String get profileMenuQuiz => 'Kuis';

  @override
  String get profileMenuLogout => 'Keluar';

  @override
  String get profileLogoutConfirm => 'Apakah Anda yakin ingin keluar?';

  @override
  String get profileLogoutYes => 'Ya, Keluar';

  @override
  String get profileLogoutNo => 'Batal';

  @override
  String get editProfileTitle => 'Edit Profil';

  @override
  String get editProfileSave => 'Simpan Perubahan';

  @override
  String get editProfileFullName => 'Nama Lengkap';

  @override
  String get editProfileBio => 'Bio';

  @override
  String get editProfileEmail => 'Email';

  @override
  String get editProfilePhone => 'Nomor Telepon';

  @override
  String get editProfileWebsite => 'Situs Web';

  @override
  String get editProfileSaved => 'Perubahan berhasil disimpan';

  @override
  String get accountSecurityTitle => 'Keamanan Akun';

  @override
  String get accountSecurityChangePassword => 'Ubah Kata Sandi';

  @override
  String get accountSecurityTwoFactor => 'Autentikasi Dua Langkah';

  @override
  String get accountSecurityActiveSessions => 'Sesi Aktif';

  @override
  String get accountSecurityDeleteAccount => 'Hapus Akun';

  @override
  String get purchaseHistoryTitle => 'Riwayat Pembelian';

  @override
  String get purchaseHistoryEmpty => 'Belum ada pembelian';

  @override
  String get purchaseHistoryGuarantee => 'Jaminan Uang Kembali 30 Hari';

  @override
  String get purchaseHistoryDate => 'Tanggal Transaksi';

  @override
  String get purchaseHistoryStatus => 'Status';

  @override
  String get purchaseHistoryAmount => 'Jumlah';

  @override
  String get purchaseHistoryCompleted => 'Selesai';

  @override
  String get purchaseHistoryRefunded => 'Dikembalikan';

  @override
  String get teachApplicationTitle => 'Mengajar di EduLab';

  @override
  String get teachApplicationSubmit => 'Kirim Lamaran';

  @override
  String get teachApplicationSent => 'Lamaran Anda berhasil dikirim';

  @override
  String get notificationsTitle => 'Notifikasi';

  @override
  String get notificationsMarkAllRead => 'Tandai semua telah dibaca';

  @override
  String get notificationsMarkAllReadSnackbar =>
      'Semua notifikasi ditandai telah dibaca';

  @override
  String get notificationsEmpty => 'Tidak ada notifikasi';

  @override
  String get notification1Title => 'Pengingat: Lanjutkan kursus Anda';

  @override
  String get notification1Message =>
      'Pelajaran baru di Flutter untuk Pemula siap untuk Anda';

  @override
  String get notification1Time => '5 menit yang lalu';

  @override
  String get notification1Action => 'Lanjut kursus';

  @override
  String get notification2Title => 'Sertifikat Anda siap!';

  @override
  String get notification2Message =>
      'Anda telah menyelesaikan kursus Desain UI/UX.';

  @override
  String get notification2Time => '2 jam yang lalu';

  @override
  String get notification2Action => 'Lihat sertifikat';

  @override
  String get notification3Title => 'Penawaran eksklusif';

  @override
  String get notification3Message => 'Diskon 70% untuk kursus pemrograman';

  @override
  String get notification3Time => '1 hari yang lalu';

  @override
  String get notification3Action => 'Lihat penawaran';

  @override
  String get notification4Title => 'Jawaban baru untuk pertanyaan Anda';

  @override
  String get notification4Message =>
      'Instruktur telah menjawab pertanyaan Anda';

  @override
  String get notification4Time => '2 hari yang lalu';

  @override
  String get notification4Action => 'Lihat jawaban';

  @override
  String get notification5Title => 'Pembaruan kursus';

  @override
  String get notification5Message => 'Materi baru ditambahkan ke kursus Python';

  @override
  String get notification5Time => '3 hari yang lalu';

  @override
  String get messagesTitle => 'Pesan';

  @override
  String get settingsTitle => 'Pengaturan & Preferensi';

  @override
  String get settingsVideoDownload => 'Video & Unduhan';

  @override
  String get settingsDownloadQuality => 'Kualitas unduhan default';

  @override
  String get settingsWifiOnly => 'Unduh hanya via Wi-Fi';

  @override
  String get settingsNotifications => 'Notifikasi & Pemberitahuan';

  @override
  String get settingsCourseNotifications => 'Notifikasi kursus dan pesan';

  @override
  String get settingsPromoNotifications => 'Penawaran dan diskon eksklusif';

  @override
  String get settingsAppearance => 'Tampilan & Bahasa';

  @override
  String get settingsDarkMode => 'Mode Gelap';

  @override
  String get settingsDarkModeEnabled => 'Aktif (menghemat baterai)';

  @override
  String get settingsDarkModeDisabled => 'Nonaktif (mode terang)';

  @override
  String get settingsLanguage => 'Bahasa Aplikasi';

  @override
  String get settingsStorage => 'Penyimpanan & Cache';

  @override
  String get settingsClearCache => 'Bersihkan Cache';

  @override
  String get settingsClearCacheSuccess => 'Cache berhasil dibersihkan';

  @override
  String get settingsHelp => 'Informasi & Kebijakan';

  @override
  String get settingsHelpCenter => 'Pusat Bantuan & FAQ';

  @override
  String get settingsTermsPrivacy => 'Syarat Penggunaan & Privasi';

  @override
  String get settingsAbout => 'Tentang EduLab';

  @override
  String get settingsVersion => 'Versi v1.0.0';

  @override
  String get quizTitle => 'Kuis';

  @override
  String get quizNext => 'Pertanyaan Berikutnya';

  @override
  String get quizSubmit => 'Kirim Kuis';

  @override
  String get quizScore => 'Skor Kuis';

  @override
  String get quizCorrectAnswers => 'Jawaban Benar';

  @override
  String get scheduleTitle => 'Jadwal Saya';

  @override
  String get scheduleEmpty => 'Tidak ada sesi terjadwal';

  @override
  String get scheduleJoin => 'Gabung Sesi';

  @override
  String get scheduleReminder => 'Pengingat';

  @override
  String get assignmentsTitle => 'Tugas';

  @override
  String get assignmentsEmpty => 'Tidak ada tugas';

  @override
  String get assignmentsSubmit => 'Kumpulkan Tugas';

  @override
  String get assignmentsDue => 'Batas Waktu';

  @override
  String get assignmentsSubmitted => 'Dikumpulkan';

  @override
  String get assignmentsPending => 'Tertunda';

  @override
  String get languageArabic => 'Bahasa Arab';

  @override
  String get languageEnglish => 'Bahasa Inggris';

  @override
  String get languageDialogTitle => 'Pilih Bahasa Aplikasi';

  @override
  String get languageSelect => 'Pilih';

  @override
  String get generalCancel => 'Batal';

  @override
  String get generalConfirm => 'Konfirmasi';

  @override
  String get generalSave => 'Simpan';

  @override
  String get generalDelete => 'Hapus';

  @override
  String get generalEdit => 'Edit';

  @override
  String get generalClose => 'Tutup';

  @override
  String get generalBack => 'Kembali';

  @override
  String get generalDone => 'Selesai';

  @override
  String get generalOk => 'OK';

  @override
  String get generalYes => 'Ya';

  @override
  String get generalNo => 'Tidak';

  @override
  String get generalLoading => 'Memuat...';

  @override
  String get generalError => 'Terjadi kesalahan';

  @override
  String get generalRetry => 'Coba Lagi';

  @override
  String get generalNoInternet => 'Tidak ada koneksi internet';

  @override
  String get generalFree => 'Gratis';

  @override
  String get generalRating => 'Rating';

  @override
  String get generalStudents => 'Siswa';

  @override
  String get generalHours => 'Jam';

  @override
  String get generalMinutes => 'Menit';

  @override
  String get generalBy => 'Oleh';

  @override
  String get navHome => 'Beranda';

  @override
  String get navExplore => 'Jelajahi';

  @override
  String get navMyCourses => 'Kursus Saya';

  @override
  String get navCart => 'Keranjang';

  @override
  String get navAccount => 'Akun';

  @override
  String get homeSubGreeting => 'Apa yang ingin Anda pelajari hari ini?';

  @override
  String get homeVisitor => 'Tamu';

  @override
  String get homePromoTitle => 'Jelajahi Penawaran Sekarang';

  @override
  String get homePromoSubtitle => 'Diskon hingga 70% untuk kursus premium';

  @override
  String get homePromoButton => 'Temukan Sekarang';

  @override
  String get homePromoBadge => 'Penawaran Eksklusif';

  @override
  String get homeContinueLearning => 'Lanjutkan Belajar';

  @override
  String get homeMyCoursesLink => 'Kursus Saya';

  @override
  String get homeLesson => 'pelajaran';

  @override
  String homeStudentsCount(String count) {
    return '$count siswa';
  }

  @override
  String get homeRecommendedTitle => 'Direkomendasikan untuk Anda';

  @override
  String get homeRecommendedSubtitle => 'Disesuaikan berdasarkan minat Anda';

  @override
  String get homeBestsellersTitle => 'Terlaris';

  @override
  String get homeBestsellersSubtitle =>
      'Kursus paling populer dan berperingkat tinggi';

  @override
  String get homeNewCoursesTitle => 'Kursus Baru';

  @override
  String get homeNewCoursesSubtitle => 'Materi segar dan terbaru';

  @override
  String get homePopularTopicsTitle => 'Topik Populer';

  @override
  String get homePopularTopicsSubtitle =>
      'Mulai pelajari keahlian yang paling diminati';

  @override
  String get homeTopInstructorsTitle => 'Instruktur Terbaik';

  @override
  String get homeTopInstructorsSubtitle =>
      'Belajar dari para ahli bersertifikat';

  @override
  String get homeExploreCategoriesTitle => 'Jelajahi Kategori';

  @override
  String get homeExploreCategoriesSubtitle =>
      'Temukan kursus yang tepat untuk Anda';

  @override
  String get catAll => 'Semua';

  @override
  String get catWebDev => 'Pengembangan Web';

  @override
  String get catMobileApps => 'Aplikasi Mobile';

  @override
  String get catDataScience => 'Sains Data';

  @override
  String get catUIUX => 'Desain UI/UX';

  @override
  String get catBusiness => 'Bisnis & Manajemen';

  @override
  String get catAI => 'Kecerdasan Buatan';

  @override
  String get catCyberSecurity => 'Keamanan Siber';

  @override
  String get exploreNoResultsTitle => 'Tidak ada hasil ditemukan';

  @override
  String get exploreNoResultsSubtitle =>
      'Coba kata kunci lain atau ubah filter';

  @override
  String get exploreRecentSearches => 'Pencarian Terakhir';

  @override
  String get exploreTopSearches => 'Pencarian Populer';

  @override
  String get exploreBrowseCategories => 'Telusuri Kategori';

  @override
  String get exploreBrowseCategoriesSubtitle => 'Temukan kursus yang tepat';

  @override
  String get exploreBackToAll => 'Kembali ke Semua';

  @override
  String get exploreClearAll => 'Hapus Semua';

  @override
  String get exploreAvailableResults => 'hasil tersedia';

  @override
  String get exploreFilterBestseller => 'Terlaris';

  @override
  String get exploreFilterTopRated => 'Rating Tertinggi';

  @override
  String get exploreFilterUnder50 => 'Di bawah Rp 100rb';

  @override
  String get learningHeroTitle => 'Lanjutkan perjalanan belajar Anda';

  @override
  String get learningSearchHint => 'Cari di kursus saya...';

  @override
  String get learningFilterAll => 'Semua';

  @override
  String get learningFilterInProgress => 'Sedang Berjalan';

  @override
  String get learningFilterCompleted => 'Selesai';

  @override
  String get learningFilterDownloaded => 'Diunduh';

  @override
  String get learningEmptyTitle => 'Belum ada kursus';

  @override
  String get learningEmptySubtitle => 'Mulai jelajahi kursus sekarang';

  @override
  String get learningEmptySearch => 'Tidak ada hasil untuk pencarian Anda';

  @override
  String get learningCompleted => 'Selesai';

  @override
  String get learningCompletedBadge => 'Selesai';

  @override
  String learningLecturesCount(int count) {
    return '$count pelajaran';
  }

  @override
  String get cartEmptyTitle => 'Keranjang Anda kosong';

  @override
  String get cartEmptySubtitle => 'Tambahkan kursus untuk mulai belajar';

  @override
  String get cartCouponHint => 'Masukkan kode promo';

  @override
  String get cartCouponApply => 'Terapkan';

  @override
  String get cartCouponInvalid => 'Kode tidak valid';

  @override
  String get cartCouponApplied => 'Kupon berhasil diterapkan';

  @override
  String get cartCouponDiscount => 'Diskon Kupon';

  @override
  String get cartCouponsTitle => 'Kupon';

  @override
  String get cartOrderSummary => 'Ringkasan Pesanan';

  @override
  String get cartOriginalPrice => 'Harga Asli';

  @override
  String get cartPlatformDiscount => 'Diskon Platform';

  @override
  String get cartFinalTotal => 'Total Akhir';

  @override
  String cartItemsCount(int count) {
    return '$count kursus';
  }

  @override
  String get cartRemovedSnackbar => 'Kursus dihapus dari keranjang';

  @override
  String get cartUndo => 'Urungkan';

  @override
  String get cartAddButton => 'Tambah ke Keranjang';

  @override
  String get cartAddedSnackbar => 'Ditambahkan ke keranjang';

  @override
  String get cartAlreadyInCart => 'Sudah di keranjang';

  @override
  String get cartCheckoutButton => 'Lanjut ke Pembayaran';

  @override
  String get cartRecommendedTitle => 'Anda Mungkin Juga Suka';

  @override
  String get cartRecommendedSubtitle =>
      'Kursus yang direkomendasikan untuk Anda';

  @override
  String get checkoutCreditCard => 'Kartu Kredit/Debit';

  @override
  String get checkoutSelectPayment => 'Pilih metode pembayaran';

  @override
  String get checkoutCardNumberLabel => 'Nomor Kartu';

  @override
  String get checkoutCardHolderLabel => 'Nama Pemegang Kartu';

  @override
  String get checkoutExpiryLabel => 'Masa Berlaku';

  @override
  String get checkoutCVVLabel => 'CVV';

  @override
  String get checkoutPersonalInfoTitle => 'Informasi Pribadi';

  @override
  String get checkoutFullNameLabel => 'Nama Lengkap';

  @override
  String get checkoutFullNameHint => 'Nama lengkap Anda';

  @override
  String get checkoutFullNameRequired => 'Nama lengkap wajib diisi';

  @override
  String get checkoutPhoneLabel => 'Nomor Telepon';

  @override
  String get checkoutPhoneRequired => 'Nomor telepon wajib diisi';

  @override
  String get checkoutPostalLabel => 'Kode Pos';

  @override
  String get checkoutPostalRequired => 'Kode pos wajib diisi';

  @override
  String get checkoutBuyerInfo => 'Informasi Pembeli';

  @override
  String get checkoutSaveInfo => 'Simpan info untuk pembelian berikutnya';

  @override
  String get checkoutMoneyBackGuarantee => 'Jaminan Uang Kembali 30 Hari';

  @override
  String get checkoutContinueToPayment => 'Lanjut ke Pembayaran';

  @override
  String get checkoutContinueToReview => 'Lanjut ke Tinjauan';

  @override
  String get checkoutReviewConfirm => 'Tinjau & Konfirmasi';

  @override
  String get checkoutStartLearning => 'Mulai Belajar';

  @override
  String get checkoutBackHome => 'Kembali ke Beranda';

  @override
  String get courseDetailsTitle => 'Detail Kursus';

  @override
  String get courseDetailsShare => 'Bagikan';

  @override
  String get courseDetailsWhatYouWillLearn => 'Yang Akan Anda Pelajari';

  @override
  String get courseDetailsLanguage => 'Bahasa';

  @override
  String get courseDetailsCreatedBy => 'Dibuat oleh';

  @override
  String get courseDetailsPreviewLesson => 'Pratinjau Pelajaran';

  @override
  String get courseDetailsHoursOnDemand => 'jam video on-demand';

  @override
  String get courseDetailsFullLifetimeAccess => 'Akses penuh seumur hidup';

  @override
  String get courseDetailsCertifiedCertificate => 'Sertifikat kelulusan resmi';

  @override
  String get courseDetailsComprehensiveContent => 'Materi lengkap';

  @override
  String get certTitle => 'Sertifikat Kelulusan';

  @override
  String get certStudentNameLabel => 'Siswa';

  @override
  String get certCourseLabel => 'Kursus';

  @override
  String get certInstructorLabel => 'Instruktur';

  @override
  String get certIssueDateLabel => 'Tanggal Penerbitan';

  @override
  String get certCodeLabel => 'ID Sertifikat';

  @override
  String get certVerifiedBadge => 'Terverifikasi';

  @override
  String get certDownloadPDF => 'Unduh PDF';

  @override
  String get certDownloadPNG => 'Unduh Gambar';

  @override
  String get certCopyVerifyLink => 'Salin tautan verifikasi';

  @override
  String get certShare => 'Bagikan Sertifikat';

  @override
  String get playerTabLessons => 'Pelajaran';

  @override
  String get playerTabOverview => 'Ikhtisar';

  @override
  String get playerTabNotes => 'Catatan Saya';

  @override
  String get playerTabQnA => 'Tanya Jawab';

  @override
  String get playerNextLesson => 'Pelajaran Berikutnya';

  @override
  String get profileWelcome => 'Selamat Datang';

  @override
  String get profileLoginPrompt => 'Masuk untuk melihat profil Anda';

  @override
  String get profileLoginOrRegister => 'Masuk / Buat Akun';

  @override
  String get profileVerifiedStudent => 'Siswa Terverifikasi';

  @override
  String get profileLogout => 'Keluar';

  @override
  String get profileCancel => 'Batal';

  @override
  String get profileLogoutConfirmTitle => 'Keluar';

  @override
  String get profileLogoutConfirmMessage =>
      'Apakah Anda yakin ingin keluar dari akun?';

  @override
  String get profileAccountSettings => 'Pengaturan Akun';

  @override
  String get profileEditProfileSubtitle => 'Ubah data pribadi Anda';

  @override
  String get profileSecurity => 'Keamanan Akun';

  @override
  String get profileSecuritySubtitle => 'Kata sandi dan verifikasi';

  @override
  String get profilePurchaseHistory => 'Riwayat Pembelian';

  @override
  String get profilePurchaseHistorySubtitle => 'Lihat riwayat transaksi';

  @override
  String get profileCertificatesSubtitle => 'Sertifikat yang Anda peroleh';

  @override
  String get profileTeach => 'Mengajar di EduLab';

  @override
  String get profileTeachSubtitle => 'Bagikan keahlian Anda';

  @override
  String get profilePreferences => 'Preferensi';

  @override
  String get profilePreferencesSubtitle => 'Tampilan dan pengaturan';

  @override
  String get profileNotifications => 'Notifikasi';

  @override
  String get profileNotificationsSubtitle => 'Kelola pemberitahuan';

  @override
  String get profileHelpSupport => 'Bantuan & Dukungan';

  @override
  String get profileTerms => 'Syarat Penggunaan';

  @override
  String get profilePrivacy => 'Kebijakan Privasi';

  @override
  String get profileAboutEduLab => 'Tentang EduLab';

  @override
  String get profileWishlist => 'Daftar Keinginan';

  @override
  String get securityTitle => 'Keamanan Akun';

  @override
  String get teachTitle => 'Mengajar di EduLab';

  @override
  String get notificationsTabAll => 'Semua';

  @override
  String get notificationsTabCourses => 'Kursus';

  @override
  String get notificationsTabPromos => 'Penawaran';

  @override
  String get notificationsEmptyTitle => 'Tidak ada notifikasi';

  @override
  String get notificationsUnread => 'Belum dibaca';

  @override
  String get wishlistTitle => 'Daftar Keinginan';

  @override
  String get wishlistEmptyTitle => 'Daftar keinginan Anda kosong';

  @override
  String get wishlistEmptySubtitle => 'Simpan kursus yang Anda minati';

  @override
  String get wishlistAddToCart => 'Tambah ke Keranjang';

  @override
  String get wishlistRemovedSnackbar => 'Dihapus dari daftar keinginan';

  @override
  String get homeDefaultUser => 'Siswa';

  @override
  String get learningOf => 'dari';

  @override
  String get cartInCartBadge => 'Di keranjang';

  @override
  String get homePromo1Badge => 'Diskon Besar • Waktu Terbatas';

  @override
  String get homePromo1Title => 'Mulai Belajar dengan Harga Terbaik';

  @override
  String get homePromo1Subtitle =>
      'Diskon hingga 65% untuk kursus pemrograman, desain, dan bisnis.';

  @override
  String get homePromo1Button => 'Lihat Penawaran';

  @override
  String get homePromo2Badge => 'Jalur Karir Bersertifikat';

  @override
  String get homePromo2Title => 'Siapkan Diri untuk Karir Impian Anda';

  @override
  String get homePromo2Subtitle =>
      'Kursus lengkap dari nol hingga mahir dengan proyek nyata dan sertifikat.';

  @override
  String get homePromo2Button => 'Jelajahi Jalur';

  @override
  String get homePromo3Badge => 'Instruktur & Pakar Terbaik';

  @override
  String get homePromo3Title => 'Belajar Langsung dari Profesional Industri';

  @override
  String get homePromo3Subtitle =>
      'Konten yang selalu diperbarui untuk menguasai teknologi terkini.';

  @override
  String get homePromo3Button => 'Mulai Sekarang';

  @override
  String get homePromoInstructorBadge =>
      'Mengajar di EduLab • Berbagi Pengetahuan';

  @override
  String get homePromoInstructorTitle => 'Jadilah Instruktur Hari Ini';

  @override
  String get homePromoInstructorSubtitle =>
      'Inspirasi pelajar di seluruh dunia, buat kursus, dan dapatkan penghasilan dari mengajar apa yang Anda sukai.';

  @override
  String get homePromoInstructorButton => 'Daftar Sekarang';

  @override
  String get homeSearchFilter => 'Filter';

  @override
  String get securitySectionChangePassword => 'Ubah Kata Sandi';

  @override
  String get securityCurrentPasswordLabel => 'Kata Sandi Saat Ini *';

  @override
  String get securityCurrentPasswordError => 'Masukkan kata sandi saat ini';

  @override
  String get securityNewPasswordLabel => 'Kata Sandi Baru *';

  @override
  String get securityNewPasswordError => 'Minimal harus 8 karakter';

  @override
  String get securityConfirmPasswordLabel => 'Konfirmasi Kata Sandi Baru *';

  @override
  String get securityConfirmPasswordError => 'Kata sandi tidak cocok';

  @override
  String get securityUpdatePasswordBtn => 'Perbarui Kata Sandi';

  @override
  String get securityPasswordUpdatedSuccess =>
      'Kata sandi berhasil diperbarui!';

  @override
  String get securitySection2FA => 'Autentikasi Dua Faktor (2FA)';

  @override
  String get security2FATitle => 'Autentikasi Dua Faktor';

  @override
  String get security2FAEnabledDesc =>
      'Aktif - Mengamankan akun Anda dengan kode verifikasi';

  @override
  String get security2FADisabledDesc => 'Nonaktif (Disarankan)';

  @override
  String get security2FASetupTitle => 'Aktifkan Autentikasi Dua Faktor';

  @override
  String get security2FASetupContent =>
      'Kode verifikasi 6 digit akan dikirim ke email terdaftar Anda setiap kali masuk dari perangkat baru.';

  @override
  String get security2FAEnableNow => 'Aktifkan Sekarang';

  @override
  String get security2FAEnabledSuccess =>
      'Autentikasi Dua Faktor berhasil diaktifkan!';

  @override
  String get security2FADisabledSuccess =>
      'Autentikasi Dua Faktor dinonaktifkan';

  @override
  String get securitySectionSessions => 'Sesi & Perangkat Aktif';

  @override
  String get securityLogoutAllDevices => 'Keluar dari Semua Perangkat';

  @override
  String get securityThisDevice => 'Perangkat Ini';

  @override
  String get securitySessionRevokedSuccess =>
      'Sesi diakhiri dan perangkat berhasil keluar.';

  @override
  String get securityAllSessionsRevokedSuccess =>
      'Berhasil keluar dari semua perangkat lain.';

  @override
  String get purchaseHistoryInvoiceCertified =>
      'Faktur Elektronik Bersertifikat';

  @override
  String get purchaseHistoryInvoiceNumber => 'Nomor Faktur';

  @override
  String get purchaseHistoryCourse => 'Kursus';

  @override
  String get purchaseHistoryPaymentMethod => 'Metode Pembayaran';

  @override
  String get purchaseHistoryTotalAmount => 'Jumlah Total:';

  @override
  String get purchaseHistoryClose => 'Tutup';

  @override
  String get purchaseHistoryDownloadPdf => 'Unduh PDF';

  @override
  String get purchaseHistoryPdfDownloaded => 'Faktur PDF berhasil diunduh';

  @override
  String get purchaseHistoryRefundRequestTitle => 'Ajukan Pengembalian Dana';

  @override
  String get purchaseHistoryRefundPolicy =>
      'Sesuai jaminan uang kembali 30 hari EduLab, Anda dapat meminta pengembalian dana penuh.';

  @override
  String get purchaseHistoryRefundReasonHint =>
      'Alasan pengembalian dana (opsional)...';

  @override
  String get purchaseHistoryConfirmRefund => 'Konfirmasi Pengembalian';

  @override
  String get purchaseHistoryRefundSubmitted =>
      'Permintaan pengembalian dana berhasil diajukan (3-5 hari kerja).';

  @override
  String get purchaseHistoryInstructor => 'Instruktur';

  @override
  String get purchaseHistoryRequestRefundBtn => 'Minta Pengembalian';

  @override
  String get purchaseHistoryInvoiceBtn => 'Faktur';

  @override
  String get purchaseHistoryStatusCompleted => 'Selesai';

  @override
  String get purchaseHistoryStatusRefunded => 'Dikembalikan';

  @override
  String get purchaseHistoryStatusProcessingRefund => 'Memproses Pengembalian';

  @override
  String get editProfileSectionBasicInfo => 'Informasi Dasar';

  @override
  String get editProfileFullNameLabel => 'Nama Lengkap *';

  @override
  String get editProfileFullNameHint => 'Masukkan nama lengkap Anda';

  @override
  String get editProfileFullNameError => 'Silakan masukkan nama lengkap';

  @override
  String get editProfileHeadlineLabel => 'Gelar Profesional / Keahlian';

  @override
  String get editProfileHeadlineHint => 'mis. Senior Flutter Developer';

  @override
  String get editProfileLocationLabel => 'Kota / Negara';

  @override
  String get editProfileLocationHint => 'Jakarta, Indonesia';

  @override
  String get editProfilePhoneLabel => 'Nomor Ponsel';

  @override
  String get editProfileBioLabel => 'Tentang Saya (Bio)';

  @override
  String get editProfileBioHint =>
      'Tulis ringkasan singkat tentang minat dan pengalaman Anda...';

  @override
  String get editProfileSectionLinks => 'Tautan & Jaringan Profesional';

  @override
  String get editProfileWebsiteLabel => 'Situs Web Pribadi';

  @override
  String get editProfileSectionEmail => 'Email Terdaftar';

  @override
  String get editProfileEmailDesc =>
      'Tertaut ke akun Anda untuk masuk dan sertifikat';

  @override
  String get editProfileEmailVerified => 'Terverifikasi';

  @override
  String get editProfileSaveChangesBtn => 'Simpan & Perbarui Data';

  @override
  String get editProfileSavedSuccess => 'Profil berhasil diperbarui!';

  @override
  String get editProfileChangeAvatarTitle => 'Ubah Foto Profil';

  @override
  String get editProfileTakePhoto => 'Ambil Foto dengan Kamera';

  @override
  String get editProfileChooseGallery => 'Pilih dari Galeri';

  @override
  String get editProfilePhotoUpdatedSuccess =>
      'Foto profil berhasil diperbarui';

  @override
  String get teachJoinInstructorTitle => 'Gabung sebagai Instruktur';

  @override
  String get teachJoinInstructorSubtitle =>
      'Publikasikan kursus Anda dan bagikan keahlian kepada ribuan siswa.';

  @override
  String get teachStep1Title => 'Informasi Pribadi';

  @override
  String get teachStep2Title => 'Pengalaman & Keahlian';

  @override
  String get teachStep3Title => 'Konfirmasi Aplikasi';

  @override
  String get teachStep1Header => '1. Informasi Pribadi & Profesional';

  @override
  String get teachFullNameArabicLabel => 'Nama Lengkap *';

  @override
  String get teachFullNameArabicHint => 'mis. Budi Santoso';

  @override
  String get teachHeadlineLabel => 'Gelar Profesional & Keahlian *';

  @override
  String get teachHeadlineHint =>
      'mis. Senior Software Architect & Trainer Flutter';

  @override
  String get teachPhoneLabel => 'Nomor Telepon Kontak *';

  @override
  String get teachCountryLabel => 'Negara Domisili *';

  @override
  String get teachBioLabel => 'Bio & Pengalaman Mengajar *';

  @override
  String get teachBioHint =>
      'Tulis ringkasan singkat tentang karier dan proyek Anda...';

  @override
  String get teachNextStepSkills => 'Lanjut: Pengalaman & Keahlian';

  @override
  String get teachStep2Header => '2. Konten Kursus & Keahlian';

  @override
  String get teachTopicLabel => 'Topik Kursus yang Diusulkan *';

  @override
  String get teachTopicHint => 'mis. Pengembangan Aplikasi Flutter dari Nol';

  @override
  String get teachYearsExperienceLabel => 'Tahun Pengalaman di Bidang Ini *';

  @override
  String get teachVideoLinkLabel =>
      'Tautan Video Contoh Mengajar (YouTube/Drive/Loom) *';

  @override
  String get teachTargetAudienceLabel => 'Target Peserta Kursus *';

  @override
  String get teachAudienceBeginners => 'Pemula Total';

  @override
  String get teachAudienceIntermediate => 'Pemula & Menengah';

  @override
  String get teachAudienceAdvanced => 'Tingkat Lanjut & Profesional';

  @override
  String get teachAudienceAll => 'Semua Tingkat';

  @override
  String get teachSkillsCoveredLabel => 'Keahlian & Teknologi dalam Kursus *';

  @override
  String get teachAddSkillHint => 'Tambah keahlian (mis. GraphQL)...';

  @override
  String get teachAddSkillBtn => 'Tambah';

  @override
  String get teachNextStepConfirm => 'Lanjut: Konfirmasi Aplikasi';

  @override
  String get teachStep3Header => '3. Rincian Pembayaran & Persetujuan';

  @override
  String get teachPayoutMethodLabel => 'Metode Penerimaan Pendapatan *';

  @override
  String get teachPayoutMethodBank => 'Transfer Bank Langsung (IBAN)';

  @override
  String get teachPayoutMethodPaypal => 'Akun PayPal Terverifikasi';

  @override
  String get teachPayoutMethodPayoneer => 'Kartu Payoneer';

  @override
  String get teachIbanDetailsLabel => 'Detail Akun / IBAN *';

  @override
  String get teachApplicationSummary => 'Ringkasan Aplikasi:';

  @override
  String get teachApplicantName => 'Pemohon';

  @override
  String get teachApplicantHeadline => 'Keahlian';

  @override
  String get teachApplicantTopic => 'Topik Kursus';

  @override
  String get teachApplicantSkillsCount => 'Jumlah Keahlian Ditambahkan';

  @override
  String get teachSkillsUnit => 'keahlian';

  @override
  String get teachAgreeTermsLabel =>
      'Saya menyetujui syarat, ketentuan, dan perjanjian kekayaan intelektual instruktur EduLab.';

  @override
  String get teachSubmitApplicationBtn => 'Submit Instructor Application';

  @override
  String get teachPrevStepBtn => 'Sebelumnya';

  @override
  String get teachWhyEduLabTitle => 'Mengapa Mengajar di EduLab?';

  @override
  String get teachProp1Title => 'Penghasilan Menarik & Adil';

  @override
  String get teachProp1Desc =>
      'Dapatkan hingga 80% bagi hasil penjualan kursus tanpa biaya tersembunyi.';

  @override
  String get teachProp2Title => 'Jangkau Ribuan Siswa';

  @override
  String get teachProp2Desc =>
      'Promosikan kursus Anda ke komunitas belajar aktif yang luas.';

  @override
  String get teachProp3Title => 'Dukungan Teknis & Produksi Penuh';

  @override
  String get teachProp3Desc =>
      'Tim kami membantu mengoptimalkan kualitas audio, video, dan rancangan kurikulum.';

  @override
  String get teachSuccessDialogTitle => 'Aplikasi Berhasil Diterima!';

  @override
  String get teachSuccessDialogDesc =>
      'Terima kasih telah bergabung dengan instruktur EduLab. Tim akademik kami akan meninjau dan menghubungi Anda dalam 48 jam.';

  @override
  String get teachSuccessDialogOk => 'Baik';

  @override
  String get teachAddOneSkillError =>
      'Harap tambahkan setidaknya satu keahlian';

  @override
  String get teachAgreeTermsError =>
      'Harap setujui syarat dan ketentuan instruktur';

  @override
  String get commonCancel => 'Batal';

  @override
  String get commonClose => 'Tutup';

  @override
  String get myCertificatesBannerTitle => 'Sertifikat Terakreditasi';

  @override
  String get myCertificatesBannerSubtitle =>
      'Semua sertifikat terakreditasi dan diverifikasi dengan ID unik dari EduLab';

  @override
  String get certBadgeVerified100 => '100% Terakreditasi';

  @override
  String get certCodeCopied => 'Kode sertifikat disalin';

  @override
  String get certGrantedTo => 'Diberikan kepada';

  @override
  String get certViewAndDownload => 'Lihat & Unduh Sertifikat';

  @override
  String get certIssuerLabel => 'Otoritas Penerbit';

  @override
  String get certIssuerName => 'Akademi Pembelajaran Interaktif EduLab';

  @override
  String get certEmptyTitle => 'Belum ada sertifikat yang diperoleh';

  @override
  String get certEmptyDesc =>
      'Selesaikan 100% kursus yang terdaftar untuk menerima sertifikat terakreditasi dengan ID verifikasi resmi.';

  @override
  String get certEmptyAction => 'Lanjutkan Kursus Saya';

  @override
  String get certDetailsTitle => 'Detail & Informasi Sertifikat';

  @override
  String get certCopyLinkSuccess =>
      'Tautan verifikasi langsung disalin ke papan klip!';

  @override
  String get certShareSuccess =>
      'Detail dan tautan sertifikat disalin untuk dibagikan!';

  @override
  String get purchaseHistoryTaxInvoiceCertified =>
      'Faktur Pajak Resmi Bersertifikat';

  @override
  String get purchaseHistoryInvoiceNumberLabel => 'Nomor Pesanan / Faktur';

  @override
  String get purchaseHistoryCourseNameLabel => 'Nama Kursus';

  @override
  String get purchaseHistoryPurchaseDateLabel => 'Tanggal Pembelian';

  @override
  String get purchaseHistoryPaymentMethodLabel => 'Metode Pembayaran';

  @override
  String get purchaseHistoryPaymentMethodValue =>
      'Kartu Kredit / Stripe (Online)';

  @override
  String get purchaseHistoryOrderStatusLabel => 'Status Pesanan';

  @override
  String get purchaseHistoryStatusPendingReview =>
      'Tinjauan Pengembalian Dana Tertunda';

  @override
  String get purchaseHistoryCopyInvoiceBtn => 'Salin Nomor Faktur';

  @override
  String get purchaseHistoryRefundReasonLabel =>
      'Alasan Permintaan Pengembalian Dana:';

  @override
  String get purchaseHistoryRefundReasonEmptyError =>
      'Silakan masukkan alasan permintaan pengembalian dana Anda';

  @override
  String get purchaseHistorySubmittingRefund => 'Mengirimkan permintaan...';

  @override
  String get purchaseHistoryPaidDate => 'Tanggal Pembayaran';

  @override
  String get purchaseHistoryEmptyTitle => 'Belum ada riwayat pembelian';

  @override
  String get purchaseHistoryEmptyDesc =>
      'Anda belum membeli kursus apa pun.\nPesanan dan faktur Anda akan muncul di sini setelah selesai.';

  @override
  String get purchaseHistoryExploreCourses => 'Jelajahi Kursus Sekarang';

  @override
  String get profileMyCourses => 'Kursus Saya';

  @override
  String get profileMyCoursesSubtitle => 'Lacak progres kursus terdaftar Anda';

  @override
  String get profileWishlistSubtitle =>
      'Kursus yang disimpan di daftar keinginan Anda';

  @override
  String get navMyLearning => 'Pembelajaran Saya';

  @override
  String get profileLogoutSafeNote =>
      'Data, kursus, dan sertifikat Anda sepenuhnya aman. Anda dapat melanjutkan pembelajaran kapan saja dengan masuk kembali.';

  @override
  String learningRemainingHours(String hours) {
    return 'Tersisa $hours jam';
  }

  @override
  String get learningCompletedFull => 'Selesai Sepenuhnya';

  @override
  String get learningFilterNotStarted => 'Belum Dimulai';

  @override
  String get wishlistTopRatedBadge => 'Nilai Tertinggi';

  @override
  String get wishlistFeaturedBadge => 'Unggulan';

  @override
  String wishlistDiscountBadge(String percent) {
    return 'Diskon $percent%';
  }

  @override
  String get courseFree => 'Gratis';

  @override
  String get badgeBestseller => 'Terlaris';

  @override
  String get badgeTopRated => 'Nilai Tertinggi';

  @override
  String get badgeFeatured => 'Unggulan';

  @override
  String get badgeRecommended => 'Direkomendasikan untuk Anda';

  @override
  String get badgeNew => 'Baru';

  @override
  String get courseWord => 'Kursus';

  @override
  String coursesCountText(String count) {
    return '$count+ Kursus';
  }

  @override
  String studentsCountText(String count) {
    return '$count Siswa';
  }

  @override
  String hoursCountText(String count) {
    return '$count Jam';
  }

  @override
  String get certifiedInstructor => 'Instruktur Bersertifikat';

  @override
  String get expertCertifiedInstructor => 'Pakar & Instruktur Bersertifikat';

  @override
  String get defaultCourseTitle => 'Kursus Pendidikan';

  @override
  String get categoryWord => 'Kategori';

  @override
  String get previewCourseVideo => 'Pratinjau Video Kursus';

  @override
  String get freeSection => 'Bagian Gratis';

  @override
  String get freeDemoVideo => 'Video Demo Gratis';

  @override
  String get articleLecture => 'Materi Artikel';

  @override
  String get articleViewer => 'Pembaca Artikel';

  @override
  String get courseVideoPlayer => 'Pemutar Video Kursus';

  @override
  String get playingNow => 'Sedang Diputar';

  @override
  String get readingNow => 'Sedang Dibaca';

  @override
  String get noLecturesInFreeSection => 'Tidak ada materi di bagian gratis';

  @override
  String freeLecturesCount(String count) {
    return '$count materi gratis';
  }

  @override
  String get enrollInFullCourse => 'Daftar Kursus Lengkap';

  @override
  String get articleWord => 'Artikel';

  @override
  String get videoWord => 'Video';

  @override
  String get quizWord => 'Kuis';

  @override
  String get courseShareCopied => 'Tautan kursus disalin ke papan klip!';

  @override
  String get addedToCartSnackbar => 'Ditambahkan ke keranjang';

  @override
  String get viewCartAction => 'Lihat Keranjang';

  @override
  String get inCartBadge => 'Di Keranjang ✓';

  @override
  String get addToCartButton => 'Tambah ke Keranjang';

  @override
  String get wishlistAddedSnackbar => 'Kursus berhasil ditambahkan ke wishlist';

  @override
  String get wishlistRemovedSuccessSnackbar => 'Kursus dihapus dari wishlist';

  @override
  String get lessonCompletedAll =>
      'Selamat! Anda telah menyelesaikan semua materi kursus ini.';

  @override
  String get noteAddedSuccess => 'Catatan berhasil ditambahkan';

  @override
  String get lessonAlreadyDownloaded => 'Materi sudah tersimpan untuk offline';

  @override
  String get lessonLinkCopied => 'Tautan materi disalin';

  @override
  String get contentReportThanks =>
      'Terima kasih atas masukan Anda, materi akan ditinjau tim kami';

  @override
  String get courseCompletionCertificate => 'Sertifikat Penyelesaian Kursus';

  @override
  String get reportContentIssue => 'Laporkan masalah konten';

  @override
  String get loginOrSocial => 'Atau masuk dengan';

  @override
  String get loginSuccessSnackbar => 'Berhasil masuk';

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
  String get cartClearAllTitle => 'Hapus Semua Item Keranjang?';

  @override
  String cartClearAllMessage(String count) {
    return 'Apakah Anda yakin ingin menghapus semua kursus $count dari keranjang belanja Anda?';
  }

  @override
  String get cartClearAllHint =>
      'Semua kursus akan dihapus dari keranjang Anda. Anda dapat menambahkannya kembali kapan saja.';

  @override
  String cartClearAllConfirm(String count) {
    return 'Hapus Semua ($count)';
  }

  @override
  String get cartClearedSuccess => 'Keranjang berhasil dibersihkan';

  @override
  String get cartClearFailed => 'Gagal menghapus keranjang';

  @override
  String cartViewWishlistCount(String count) {
    return 'Lihat Item Daftar Keinginan ($count)';
  }

  @override
  String get cartGoToWishlist => 'Buka Daftar Keinginan';

  @override
  String get wishlistClearAllTitle => 'Hapus Semua Item Daftar Keinginan?';

  @override
  String wishlistClearAllMessage(String count) {
    return 'Apakah Anda yakin ingin menghapus semua kursus $count dari daftar keinginan Anda?';
  }

  @override
  String get wishlistClearAllHint =>
      'Semua kursus yang disimpan akan dihapus. Anda dapat menambahkannya kembali kapan saja dari Jelajahi.';

  @override
  String wishlistClearAllConfirm(String count) {
    return 'Hapus Semua ($count)';
  }

  @override
  String get wishlistClearedSuccess => 'Daftar Keinginan berhasil dibersihkan';

  @override
  String get wishlistClearFailed => 'Gagal menghapus daftar keinginan';

  @override
  String get wishlistClearTooltip => 'Hapus Semua';

  @override
  String wishlistViewCartCount(String count) {
    return 'Lihat Item Keranjang ($count)';
  }

  @override
  String get wishlistGoToCart => 'Pergi ke Keranjang';

  @override
  String get checkoutCardNumberInvalid =>
      'Silakan masukkan 16 digit nomor kartu yang valid';

  @override
  String get checkoutCardExpiryInvalidFormat =>
      'Silakan masukkan tanggal kedaluwarsa kartu yang valid (MM / YY)';

  @override
  String get checkoutCardExpiredDate => 'Tanggal kedaluwarsa kartu tidak valid';

  @override
  String get checkoutCardCvcInvalid =>
      'Silakan masukkan kode CVC 3 atau 4 digit yang valid';

  @override
  String get checkoutCardHolderNameRequired =>
      'Silakan masukkan nama pemegang kartu';

  @override
  String get checkoutCartEmptySnackbar => 'Keranjang belanja kosong';

  @override
  String get checkoutPaymentStartFailed => 'Gagal memulai pembayaran';

  @override
  String get checkoutClientSecretMissing =>
      'Kunci keamanan tidak diterima dari gateway pembayaran';

  @override
  String get checkoutCardVerificationFailed => 'Verifikasi kartu gagal';

  @override
  String get checkoutStripeProcessingFailed =>
      'Pemrosesan pembayaran Stripe gagal';

  @override
  String get checkoutServerConfirmationFailed =>
      'Konfirmasi pembayaran server gagal';

  @override
  String get checkoutEmptyCartTitle => 'Keranjang Anda kosong';

  @override
  String get checkoutEmptyCartDesc =>
      'Anda belum menambahkan kursus apa pun ke keranjang Anda. Jelajahi kursus kami dan mulailah belajar!';

  @override
  String get checkoutContinueFreeReview => 'Lanjutkan ke Tinjauan Gratis';

  @override
  String get checkoutFreeOrderBadge => '100% Pesanan Gratis (zsh.00)';

  @override
  String get checkoutFreeOrderNotice =>
      'Pesanan ini tidak memerlukan informasi pembayaran apa pun. Anda dapat langsung melanjutkan untuk mengonfirmasi pendaftaran.';

  @override
  String get checkoutFreeCheckoutTitle => '100% Pembayaran Gratis';

  @override
  String get checkoutConfirmFreeEnrollment => 'Konfirmasi Pendaftaran Gratis';

  @override
  String get checkoutFreePrice => 'Bebas';

  @override
  String get checkoutFreeZero => 'Gratis (zsh.00)';

  @override
  String checkoutCoursesCount(String count) {
    return '$count kursus';
  }

  @override
  String get notificationsClearAllTitle => 'Hapus Semua Notifikasi?';

  @override
  String notificationsClearAllMessage(String count) {
    return 'Apakah Anda yakin ingin menghapus semua notifikasi $count? Tindakan ini tidak dapat dibatalkan.';
  }

  @override
  String get notificationsClearAllHint =>
      'Semua notifikasi Anda akan dihapus dan kotak masuk Anda akan mulai segar.';

  @override
  String notificationsClearAllConfirm(String count) {
    return 'Hapus Semua ($count)';
  }

  @override
  String get notificationsClearSuccess => 'Semua notifikasi berhasil dihapus';

  @override
  String get notificationsClearFailed => 'Gagal menghapus notifikasi';

  @override
  String get notificationsClearTooltip => 'Hapus Semua';

  @override
  String get notificationsViewDetails => 'Lihat Detail';

  @override
  String get notificationsEmptyCategoryTitle =>
      'Tidak ada pemberitahuan dalam kategori ini';

  @override
  String get notificationsEmptyCategorySubtitle =>
      'Coba beralih ke kategori lain atau telusuri semua notifikasi';

  @override
  String get notificationsEmptyAllSubtitle =>
      'Kami akan terus mengabari Anda dengan pembaruan dan peringatan terkini di sini';

  @override
  String get notificationsViewAll => 'Lihat Semua Pemberitahuan';

  @override
  String get learningFilterAndSortTitle => 'Filter & Sortir Kursus';

  @override
  String get learningFilterReset => 'Mengatur ulang';

  @override
  String get learningSortByTitle => 'Urutkan berdasarkan';

  @override
  String get learningSortRecentActivity => 'Baru Diakses';

  @override
  String get learningSortRecentEnrolled => 'Baru-baru ini Mendaftar';

  @override
  String get learningSortTitleAZ => 'Judul (A-Z)';

  @override
  String get learningSortProgress => 'Kemajuan %';

  @override
  String get learningStatusTitle => 'Status Kursus';

  @override
  String get learningStatusAll => 'Semua Kursus';

  @override
  String get learningStatusInProgress => 'Sedang Berlangsung';

  @override
  String get learningStatusCompleted => 'Selesai';

  @override
  String get learningStatusNotStarted => 'Belum Dimulai';

  @override
  String get learningFilterApply => 'Terapkan Filter';

  @override
  String get learningSearchCoursesHint => 'Telusuri kursus Anda...';

  @override
  String get learningSearchWishlistHint => 'Cari daftar keinginan...';

  @override
  String get learningSearchCertificatesHint => 'Cari sertifikat...';

  @override
  String get learningTabMyCourses => 'Kursus Saya';

  @override
  String get learningTabFavourite => 'Favoritku';

  @override
  String get learningTabCertificates => 'Sertifikat Saya';

  @override
  String get learningNoCoursesTitle => 'Belum ada kursus';

  @override
  String get learningNoCoursesSubtitle =>
      'Jelajahi ribuan kursus premium dan mulailah perjalanan belajar Anda hari ini';

  @override
  String get learningFilterButton => 'Menyaring';

  @override
  String learningFilterAllCount(String count) {
    return 'Semua ($count)';
  }

  @override
  String get learningStatusNotStartedShort => 'Belum Dimulai';

  @override
  String get learningNoMatchTitle => 'Tidak ada kursus yang cocok';

  @override
  String learningNoMatchSubtitle(String query) {
    return 'Tidak ditemukan kursus yang mengandung \"$query\". Coba telusuri dengan istilah lain.';
  }

  @override
  String get learningNoInProgressTitle =>
      'Tidak ada kursus yang sedang berlangsung';

  @override
  String get learningNoInProgressSubtitle =>
      'Mulailah menonton pelajaran di kursus terdaftar Anda untuk melacak kemajuan Anda di sini.';

  @override
  String get learningNoCompletedTitle => 'Belum ada kursus yang diselesaikan';

  @override
  String get learningNoCompletedSubtitle =>
      'Lanjutkan studi Anda untuk merayakan kemajuan Anda dan lihat kursus yang telah diselesaikan di sini.';

  @override
  String get learningNoUnstartedTitle => 'Tidak ada kursus yang belum dimulai';

  @override
  String get learningNoUnstartedSubtitle =>
      'Luar biasa! Anda sudah mulai belajar di semua kursus terdaftar Anda.';

  @override
  String get learningNoFilterMatchTitle =>
      'Tidak ada kursus yang cocok dengan filter ini';

  @override
  String get learningNoFilterMatchSubtitle =>
      'Ubah opsi filter atau pengurutan untuk menampilkan kursus Anda.';

  @override
  String learningViewAllCoursesCount(String count) {
    return 'Lihat semua kursus ($count)';
  }

  @override
  String learningSavedCoursesCount(String count) {
    return 'Kursus Tersimpan ($count)';
  }

  @override
  String get learningClearAllSaved => 'Hapus Semua';

  @override
  String get learningNoCertificatesTitle => 'Belum ada sertifikat';

  @override
  String get learningNoCertificatesSubtitle =>
      'Selesaikan kursus Anda untuk mendapatkan sertifikat terakreditasi yang memverifikasi pencapaian Anda';

  @override
  String get learningGoToCourses => 'Buka Kursus Saya';

  @override
  String learningCertIssuedDate(String date) {
    return 'Dikeluarkan: $date';
  }

  @override
  String get learningCertView => 'Melihat';

  @override
  String get learningResumeLesson => 'Lanjutkan Pelajaran';

  @override
  String learningProgressPercentComplete(String percent) {
    return '$percent% selesai';
  }

  @override
  String learningViewCartCount(String count) {
    return 'Lihat Item Keranjang ($count)';
  }

  @override
  String get learningGoToCart => 'Pergi ke Keranjang';

  @override
  String get playerLessonMarkedCompleted =>
      'Pelajaran ditandai sebagai selesai ✓';

  @override
  String get playerLessonMarkedIncomplete =>
      'Pelajaran ditandai sebagai tidak lengkap';

  @override
  String get playerCommentPostedSuccess => 'Komentar berhasil diposting';

  @override
  String get playerCommentPostFailed => 'Gagal mengirim komentar';

  @override
  String get playerReplyPostedSuccess => 'Balasan berhasil diposting';

  @override
  String get playerReplyPostFailed => 'Gagal mengirim balasan';

  @override
  String get playerCourseNotFound => 'Kursus tidak ditemukan';

  @override
  String get playerCheckEnrollmentPrompt =>
      'Harap verifikasi pendaftaran kursus Anda terlebih dahulu';

  @override
  String get playerReturnToCourses => 'Pembelajaran Saya';

  @override
  String get playerWatchLecture => 'Kuliah Mata Kuliah';

  @override
  String get playerCertificateTooltip => 'Sertifikat';

  @override
  String get playerRateCourseTooltip => 'Nilai Kursus';

  @override
  String get playerReadingArticleBadge => 'Membaca Artikel • 5 menit';

  @override
  String get playerReadFullTextBelow => 'Baca teks lengkap di bawah ↓';

  @override
  String get playerTabReviews => 'Ulasan';

  @override
  String get playerNoSectionsAvailable => 'Tidak ada bagian yang tersedia';

  @override
  String playerLessonsCount(String count) {
    return '$count pelajaran';
  }

  @override
  String get playerPlayingBadge => 'Bermain';

  @override
  String get playerArticleBadge => 'Artikel';

  @override
  String get playerVideoBadge => 'Video';

  @override
  String get playerFullArticleContent => 'Isi Artikel Lengkap';

  @override
  String get playerArticlePlaceholder =>
      'Selamat datang di pelajaran membaca ini.\n\nBagian ini mencakup konsep inti dan langkah praktis yang Anda perlukan untuk menguasai keterampilan dalam pelajaran ini.';

  @override
  String get playerAboutCourseTitle => 'Tentang Kursus ini';

  @override
  String get playerShowLess => 'Tampilkan Lebih Sedikit';

  @override
  String get playerReadMore => 'Baca selengkapnya';

  @override
  String get playerWhatYouWillLearn => 'Apa yang Akan Anda Pelajari';

  @override
  String get playerCourseInfoTitle => 'Detail Kursus';

  @override
  String get playerTotalDurationTitle => 'Durasi Total';

  @override
  String get playerTotalLessonsTitle => 'Jumlah Pelajaran';

  @override
  String playerLessonsNumber(String count) {
    return '$count pelajaran';
  }

  @override
  String get playerLevelTitle => 'Tingkat';

  @override
  String get playerAllLevels => 'Semua Tingkat';

  @override
  String get playerLanguageTitle => 'Bahasa';

  @override
  String get playerLanguageArabic => 'Arab';

  @override
  String get playerPrerequisitesTitle => 'Persyaratan Kursus';

  @override
  String get playerCertificateCardTitle => 'Sertifikat Kursus';

  @override
  String get playerCourseCompletedSuccess => 'Selamat! Kursus selesai';

  @override
  String get playerProgressLabel => 'Kemajuan';

  @override
  String get playerViewCertificateBtn => 'Lihat Sertifikat';

  @override
  String get playerCertifiedInstructor => 'Instruktur Bersertifikat';

  @override
  String playerDiscussionsCount(String count) {
    return '$count pertanyaan & diskusi';
  }

  @override
  String get playerAskQuestionHint =>
      'Ketik pertanyaan atau pertanyaan Anda di sini...';

  @override
  String get playerPostBtn => 'Pos';

  @override
  String get playerNoDiscussionsTitle => 'Belum ada diskusi';

  @override
  String get playerNoDiscussionsSubtitle =>
      'Jadilah orang pertama yang mengajukan pertanyaan!';

  @override
  String get playerInstructorBadge => 'Pengajar';

  @override
  String get playerCancelReply => 'Membatalkan';

  @override
  String get playerReplyAction => 'Membalas';

  @override
  String playerRepliesCount(String count) {
    return '$count balasan';
  }

  @override
  String get playerWriteReplyHint => 'Tulis balasan Anda...';

  @override
  String get playerSendReplyBtn => 'Membalas';

  @override
  String get playerCourseFeedbackTitle => 'Penilaian & Masukan Kursus';

  @override
  String get playerOutOf5 => 'dari 5';

  @override
  String playerRatingsFromEnrolledCount(String count) {
    return '$count peringkat dari siswa yang terdaftar';
  }

  @override
  String get playerKeepLearningToRate => 'Teruslah belajar menilai';

  @override
  String get playerRateAfter80Hint =>
      'Anda dapat meninjau dan menilai kursus ini setelah menyelesaikan 80% kontennya';

  @override
  String get playerCurrentProgressLabel => 'Kemajuan Anda:';

  @override
  String get playerYourCurrentRating => 'Peringkat Anda';

  @override
  String get playerEditRating => 'Sunting Peringkat';

  @override
  String get playerDeleteRatingTooltip => 'Hapus Peringkat';

  @override
  String get playerUpdateRatingTitle => 'Perbarui Peringkat Anda';

  @override
  String get playerRateCourseTitle => 'Nilai Kursus ini';

  @override
  String get playerWriteReviewHint =>
      'Tulis tanggapan dan pemikiran Anda tentang kualitas konten (opsional)...';

  @override
  String get playerRatingSubmitSuccess => 'Penilaian berhasil dikirimkan!';

  @override
  String get playerRatingSubmitFailed => 'Gagal mengirimkan peringkat';

  @override
  String get playerSaveChangesBtn => 'Simpan Perubahan';

  @override
  String get playerSubmitReviewBtn => 'Kirim Ulasan';

  @override
  String get playerLearnerReviewsTitle => 'Ulasan Pelajar';

  @override
  String playerReviewsCount(String count) {
    return '$count ulasan';
  }

  @override
  String get playerNoWrittenReviewsTitle => 'Belum ada ulasan tertulis';

  @override
  String get playerNoWrittenReviewsSubtitle =>
      'Jadilah orang pertama yang membagikan pemikiran Anda!';

  @override
  String get playerRatingLabel5 => 'Luar biasa 🌟 (5/5)';

  @override
  String get playerRatingLabel4 => 'Sangat Bagus 👍 (4/5)';

  @override
  String get playerRatingLabel3 => 'Rata-rata 👌 (3/5)';

  @override
  String get playerRatingLabel2 => 'Perlu Perbaikan 🤔 (2/5)';

  @override
  String get playerRatingLabel1 => 'Kasihan 👎 (1/5)';

  @override
  String get playerDeleteRatingDialogTitle => 'Hapus Peringkat';

  @override
  String get playerDeleteRatingDialogMessage =>
      'Apakah Anda yakin ingin menghapus ulasan Anda untuk kursus ini?';

  @override
  String get playerDeleteConfirmBtn => 'Menghapus';

  @override
  String get playerRatingDeleteSuccess => 'Peringkat berhasil dihapus';

  @override
  String get playerPreviousLesson => 'Pelajaran Sebelumnya';

  @override
  String get playerExitFullscreenTooltip => 'Keluar dari Layar Penuh';

  @override
  String instructorsAvailableCount(String count) {
    return '$count instruktur tersedia';
  }

  @override
  String get instructorsNotFound => 'Tidak ada instruktur yang ditemukan';

  @override
  String instructorsCoursesCount(String count) {
    return '$count kursus';
  }

  @override
  String get instructorsSearchHint =>
      'Cari berdasarkan nama instruktur atau spesialisasi...';

  @override
  String get instructorsSortAll => 'Semua';

  @override
  String get instructorsSortTopRated => 'Nilai Tertinggi';

  @override
  String get instructorsSortMostStudents => 'Kebanyakan Siswa';

  @override
  String get instructorsSortMostCourses => 'Kebanyakan Kursus';

  @override
  String get instructorsNotFoundSubtitle =>
      'Coba telusuri dengan nama lain atau hapus filter';

  @override
  String get exploreCompleteCourse => 'Kursus Komprehensif';

  @override
  String get exploreGeneralCategory => 'Umum';

  @override
  String courseShareMessage(String title, String url) {
    return 'Lihat kursus \"$title\" di EduLab: $url';
  }

  @override
  String get courseDetailsDefaultTitle => 'Detail Kursus';

  @override
  String get courseDetailsTooltipShare => 'Membagikan';

  @override
  String get courseDetailsTooltipWishlist => 'Daftar Keinginan';

  @override
  String get courseDetailsTooltipCart => 'Keranjang';

  @override
  String get courseDetailsNotFound => 'Kursus tidak ditemukan';

  @override
  String get courseDetailsDefaultCategory => 'Kursus';

  @override
  String courseDetailsTotalRatingsCount(String count) {
    return '($count peringkat)';
  }

  @override
  String courseDetailsLecturesCount(String count) {
    return '$count kuliah';
  }

  @override
  String get courseDetailsCertificateBadge => 'Sertifikat';

  @override
  String get courseDetailsTabOverview => 'Ringkasan';

  @override
  String get courseDetailsTabCurriculum => 'Kurikulum';

  @override
  String get courseDetailsTabInstructor => 'Pengajar';

  @override
  String get courseDetailsTabReviews => 'Ulasan';

  @override
  String get courseDetailsFullDescriptionTitle => 'Keterangan';

  @override
  String get courseDetailsShowLess => 'Tampilkan lebih sedikit';

  @override
  String get courseDetailsShowMore => 'Tampilkan lebih banyak...';

  @override
  String courseDetailsCurriculumSectionsLectures(
    String sections,
    String lectures,
  ) {
    return '$sections bagian • $lectures kuliah';
  }

  @override
  String get courseDetailsCollapseAll => 'Ciutkan semuanya';

  @override
  String get courseDetailsExpandAll => 'Perluas semuanya';

  @override
  String get courseDetailsCurriculumComingSoon =>
      'Detail kurikulum segera hadir';

  @override
  String courseDetailsSectionLecturesCount(String count) {
    return '$count kuliah';
  }

  @override
  String get courseDetailsLecturePreviewBtn => 'Pratinjau';

  @override
  String get courseDetailsDefaultInstructorTitle =>
      'Instruktur Senior & Ahli Bersertifikat';

  @override
  String get courseDetailsInstructorRatingLabel => 'Peringkat';

  @override
  String get courseDetailsInstructorStudentsLabel => 'Siswa';

  @override
  String get courseDetailsInstructorSectionsLabel => 'Bagian';

  @override
  String get courseDetailsAboutInstructorTitle => 'Tentang Instruktur:';

  @override
  String get courseDetailsDefaultInstructorAbout =>
      'Instruktur bersertifikat dengan pengalaman luas dalam memberikan pendidikan profesional kepada ribuan siswa di seluruh dunia.';

  @override
  String courseDetailsStudentRatingsCount(String count) {
    return '$count peringkat siswa';
  }

  @override
  String get courseDetailsNoWrittenReviews => 'Belum ada ulasan tertulis';

  @override
  String get courseDetailsRelatedCourses =>
      'Kursus Terkait yang Mungkin Anda Suka';

  @override
  String courseDetailsDiscountPercent(String percent) {
    return 'DISKON $percent%.';
  }

  @override
  String get courseDetailsResumeCourse => 'Lanjutkan Kursus';

  @override
  String get courseDetailsTryAgain => 'Coba Lagi';

  @override
  String get courseDetailsEstimatedReading => '📖 Perkiraan bacaan: 4 menit';

  @override
  String get courseDetailsSampleArticleContent =>
      'Selamat datang di artikel kuliah ini.\n\nBagian ini mencakup konsep-konsep teoretis utama dan langkah-langkah praktis untuk menguasai subjek.\n\n• Poin Penting:\n1. Pahami terminologi inti dan pola arsitektur.\n2. Latihan langsung dan latihan terus menerus.\n3. Referensi catatan tambahan dan tugas.\n\nSelamat membaca!';

  @override
  String certDownloadedSuccess(String course, String format) {
    return 'Sertifikat untuk \"$course\" berhasil diunduh dalam format $format!';
  }

  @override
  String certVerifiedFullRequirements(String code) {
    return 'ID Verifikasi: $code • Persyaratan Selesai 100%.';
  }

  @override
  String get certCompletionTitle => 'Sertifikat Penyelesaian';

  @override
  String get certCompletionSubtitle => 'Sertifikat Penyelesaian Kursus';

  @override
  String get certAnnounceStudent =>
      'EducationLab Learning Academy dengan ini menyatakan bahwa:';

  @override
  String get certCompletionRequirementsMet =>
      'Telah berhasil menyelesaikan semua persyaratan kursus pelatihan:';

  @override
  String certIssueDateText(String date) {
    return 'Tanggal Penerbitan: $date';
  }

  @override
  String certIdNumberText(String code) {
    return 'ID Sertifikat: $code';
  }

  @override
  String get certPlatformManagement => 'Manajemen Platform';

  @override
  String get certInstructorRoleTitle => 'Instruktur Kursus';

  @override
  String get commonLoading => 'Memuat...';

  @override
  String get homeGuestTagline =>
      'Platform pembelajaran cerdas & pengembangan keterampilan';

  @override
  String get catTagHighestDemand => 'Paling Diminati';

  @override
  String get catTagMostPopular => 'Paling Populer';

  @override
  String get catTagTrending => 'Sedang Tren';

  @override
  String get catTagFastestGrowing => 'Paling Cepat Berkembang';

  @override
  String get catTagHighDemand => 'Permintaan Tinggi';

  @override
  String get catTagTopRated => 'Rating Tertinggi';

  @override
  String get catTagEssential => 'Sangat Penting';

  @override
  String get catTagAdvanced => 'Tingkat Lanjut';

  @override
  String get catTagEntrepreneurs => 'Wirausahawan';

  @override
  String get catTagSalesGrowth => 'Pertumbuhan Penjualan';

  @override
  String get catDevTitle => 'Pemrograman & Pengembangan Perangkat Lunak';

  @override
  String get catDevSubtitle => 'Rekayasa Perangkat Lunak, Sistem & Algoritma';

  @override
  String get catWebTitle => 'Pengembangan Web';

  @override
  String get catWebSubtitle => 'Frontend, Backend & Fullstack Web';

  @override
  String get catMobileTitle => 'Pengembangan Aplikasi Seluler';

  @override
  String get catMobileSubtitle => 'Aplikasi Flutter, iOS & Android';

  @override
  String get catAiTitle => 'Kecerdasan Buatan';

  @override
  String get catAiSubtitle => 'Machine Learning, Deep Learning & AI';

  @override
  String get catDataTitle => 'Sains Data & Analitik';

  @override
  String get catDataSubtitle => 'Analisis Data, Statistik & Big Data';

  @override
  String get catDesignTitle => 'Desain UI/UX & Produk';

  @override
  String get catDesignSubtitle => 'UI/UX, Prototyping & Desain Produk';

  @override
  String get catSecurityTitle => 'Keamanan Siber & Jaringan';

  @override
  String get catSecuritySubtitle =>
      'Keamanan Siber, Ethical Hacking & Jaringan';

  @override
  String get catCloudTitle => 'Cloud Computing & DevOps';

  @override
  String get catCloudSubtitle => 'Infrastruktur Cloud, DevOps & CI/CD';

  @override
  String get catBusinessTitle => 'Bisnis & Manajemen Proyek';

  @override
  String get catBusinessSubtitle => 'Kewirausahaan, Agile & Kepemimpinan';

  @override
  String get catMarketingTitle => 'Pemasaran Digital';

  @override
  String get catMarketingSubtitle =>
      'Pemasaran Digital, SEO & Strategi Pertumbuhan';

  @override
  String get timeJustNow => 'Baru saja';

  @override
  String timeMinutesAgo(String count) {
    return '$count mnt lalu';
  }

  @override
  String timeHoursAgo(String count) {
    return '$count jam lalu';
  }

  @override
  String timeDaysAgo(String count) {
    return '$count hari lalu';
  }

  @override
  String timeWeeksAgo(String count) {
    return '$count minggu lalu';
  }

  @override
  String timeMonthsAgo(String count) {
    return '$count bulan lalu';
  }

  @override
  String wishlistLecturesCount(String count) {
    return '$count pelajaran';
  }

  @override
  String get instructorProfileTitle => 'Profil Instruktur';

  @override
  String instructorProfileLinkCopied(String name) {
    return 'Tautan untuk $name disalin ke papan klip';
  }

  @override
  String get instructorDefaultName => 'Instruktur';

  @override
  String get instructorProfileBadge => 'INSTRUKTUR';

  @override
  String get instructorProfileTotalStudents => 'Total Siswa';

  @override
  String get instructorProfileRating => 'Rating Instruktur';

  @override
  String get instructorProfileCourses => 'Kursus';

  @override
  String get instructorProfileShare => 'Bagikan Profil';

  @override
  String get instructorProfileLinkOpenError =>
      'Tidak dapat membuka tautan, disalin ke papan klip';

  @override
  String get instructorProfileWebsite => 'Situs Web';

  @override
  String get instructorProfileAboutMe => 'Tentang Saya';

  @override
  String get instructorProfileShowLess => 'Tampilkan lebih sedikit';

  @override
  String get instructorProfileShowMore => 'Tampilkan lebih banyak';

  @override
  String get instructorProfileExpertise => 'Bidang Keahlian';

  @override
  String get instructorProfileSortAll => 'Semua';

  @override
  String get instructorProfileSortTopRated => 'Rating Tertinggi';

  @override
  String get instructorProfileSortPopular => 'Populer';

  @override
  String get instructorProfileSortNewest => 'Terbaru';

  @override
  String get instructorProfileCoursesTitle => 'Kursus Instruktur';

  @override
  String get instructorProfileNoCoursesFilter =>
      'Tidak ada kursus yang ditemukan untuk filter ini';

  @override
  String instructorProfileLoadMoreCourses(String count) {
    return 'Muat Lebih Banyak Kursus ($count tersisa)';
  }

  @override
  String get instructorProfileLoadingMoreCourses =>
      'Memuat lebih banyak kursus...';

  @override
  String instructorProfileAllCoursesLoaded(String count) {
    return 'Semua $count kursus telah dimuat';
  }

  @override
  String get instructorProfileStudentFeedback => 'Umpan Balik Siswa';

  @override
  String instructorProfileReviewsCount(String count) {
    return '$count ulasan';
  }

  @override
  String instructorProfileBasedOnReviews(String count) {
    return 'Berdasarkan $count ulasan';
  }

  @override
  String get instructorProfileRecentReviews => 'Ulasan Terbaru';

  @override
  String instructorProfileLoadMoreReviews(String count) {
    return 'Muat Lebih Banyak Ulasan ($count tersisa)';
  }

  @override
  String get instructorProfileLoadingMoreReviews =>
      'Memuat lebih banyak ulasan...';

  @override
  String instructorProfileAllReviewsLoaded(String count) {
    return 'Semua $count ulasan telah dimuat';
  }

  @override
  String get instructorProfileNoReviewsYet => 'Belum ada ulasan tertulis';

  @override
  String get instructorProfileRatingDesc =>
      'Rating didasarkan pada penilaian siswa secara keseluruhan di seluruh kursus instruktur';

  @override
  String get instructorProfileLoadError =>
      'Gagal memuat detail instruktur, silakan coba lagi nanti';

  @override
  String get instructorProfileDefaultStudentName => 'Siswa';

  @override
  String get instructorProfileDefaultHeadline =>
      'Instruktur Senior & Ahli Bersertifikat';

  @override
  String get instructorProfileDefaultBio =>
      'Insinyur perangkat lunak dan instruktur teknis bersertifikat dengan pengalaman luas dalam membangun sistem perangkat lunak yang dapat diskalakan dan aplikasi seluler.\nTelah melatih ribuan siswa dan insinyur di seluruh dunia, menyajikan konten profesional yang berfokus pada clean code, clean architecture, dan solusi skalabel modern.';

  @override
  String get supportNewChat => 'Obrolan Baru';

  @override
  String get supportNoChatsTitle => 'Belum Ada Obrolan Dukungan';

  @override
  String get supportNoChatsDesc =>
      'Tim dukungan kami siap 24/7 untuk membantu dan menjawab semua pertanyaan Anda';

  @override
  String get supportStartNewConversation => 'Mulai Percakapan Baru';

  @override
  String get supportNoMessagesYet => 'Belum ada pesan';

  @override
  String get supportRetry => 'Coba Lagi';

  @override
  String get supportOpenTicket => 'Tiket Terbuka';

  @override
  String get supportClosedTicket => 'Tiket Ditutup';

  @override
  String get supportCloseAction => 'Tutup';

  @override
  String get supportReopenAction => 'Buka Kembali';

  @override
  String get supportNoMessagesInChat => 'Belum ada pesan di obrolan ini';

  @override
  String get supportYou => 'Anda';

  @override
  String get supportTeam => 'Tim Dukungan';

  @override
  String get supportTypeMessageHint => 'Ketik pesan Anda di sini...';

  @override
  String get supportConversationClosedNotice =>
      'Percakapan ini saat ini ditutup.';

  @override
  String get supportCloseDialogTitle => 'Tutup Percakapan?';

  @override
  String get supportCloseDialogDesc =>
      'Apakah Anda yakin ingin menutup obrolan ini? Anda dapat membukanya kembali kapan saja untuk melanjutkan obrolan.';

  @override
  String get supportCancel => 'Batal';

  @override
  String get supportYesClose => 'Ya, Tutup';

  @override
  String get supportNewChatTitle => 'Obrolan Dukungan Baru';

  @override
  String get supportNewChatSubtitle => 'Tim kami siap membantu Anda';

  @override
  String get supportSubjectLabel => 'Subjek';

  @override
  String get supportSubjectHint =>
      'cth: Pertanyaan kursus, Masalah pembayaran...';

  @override
  String get supportMessageLabel => 'Pesan';

  @override
  String get supportMessageHint =>
      'Jelaskan kendala atau pertanyaan Anda secara rinci...';

  @override
  String get supportMessageRequired => 'Silakan masukkan pesan';

  @override
  String get supportStartConversationBtn => 'Mulai Percakapan';

  @override
  String get supportCreateError =>
      'Gagal membuat percakapan, silakan coba lagi nanti';

  @override
  String get supportTopicCourse => 'Pertanyaan Kursus';

  @override
  String get supportTopicPayment => 'Masalah Pembayaran';

  @override
  String get supportTopicCertificates => 'Sertifikat';

  @override
  String get supportTopicTech => 'Masalah Teknis';

  @override
  String get supportTopicGeneral => 'Pertanyaan Umum';

  @override
  String get cartGuestTitle => 'Masuk untuk melihat keranjang Anda';

  @override
  String get cartGuestSubtitle =>
      'Silakan masuk untuk mengakses keranjang dan melanjutkan pembelian kursus.';

  @override
  String get wishlistGuestTitle => 'Masuk untuk melihat daftar keinginan';

  @override
  String get wishlistGuestSubtitle =>
      'Silakan masuk untuk mengakses kursus yang Anda simpan kapan saja.';

  @override
  String get courseDetailsLoginRequiredTitle => 'Perlu Masuk';

  @override
  String get courseDetailsLoginRequiredDesc =>
      'Anda harus masuk terlebih dahulu untuk membeli kursus ini dan melacak progres belajar.';

  @override
  String get courseDetailsProceedToLogin => 'Lanjutkan ke Masuk';

  @override
  String get messagesGuestTitle => 'Masuk untuk melihat pesan';

  @override
  String get messagesGuestSubtitle =>
      'Silakan masuk untuk mengakses percakapan bantuan dan dukungan.';

  @override
  String get notificationsGuestTitle => 'Masuk untuk melihat notifikasi';

  @override
  String get notificationsGuestSubtitle =>
      'Silakan masuk untuk melihat pemberitahuan terbaru untuk akun dan kursus Anda.';
}

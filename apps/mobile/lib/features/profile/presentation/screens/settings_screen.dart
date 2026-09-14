import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mobile/core/extensions/localization_ext.dart';
import 'package:mobile/core/services/api_client.dart';
import 'package:mobile/core/services/theme_service.dart';
import 'package:mobile/core/services/locale_service.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/core/utils/app_responsive.dart';
import 'package:mobile/core/utils/app_snackbar.dart';
import 'package:mobile/features/legal/presentation/screens/legal_content_screen.dart';
import 'package:mobile/features/learning/presentation/providers/download_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _downloadWifiOnly = true;
  bool _pushNotifications = true;
  bool _promoNotifications = true;
  String _videoQuality = '1080p';

  @override
  void initState() {
    super.initState();
    _loadStoredPreferences();
  }

  Future<void> _loadStoredPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (mounted) {
        setState(() {
          _downloadWifiOnly =
              prefs.getBool('settings_download_wifi_only') ?? true;
          _pushNotifications =
              prefs.getBool('settings_course_notifications') ?? true;
          _promoNotifications =
              prefs.getBool('settings_promo_notifications') ?? true;
          _videoQuality =
              prefs.getString('settings_video_quality') ?? '1080p';
        });
      }
    } catch (_) {}
  }

  Future<void> _updateWifiOnly(bool value) async {
    setState(() => _downloadWifiOnly = value);
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('settings_download_wifi_only', value);
    } catch (_) {}
  }

  Future<void> _updatePushNotifications(bool value) async {
    setState(() => _pushNotifications = value);
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('settings_course_notifications', value);
    } catch (_) {}
  }

  Future<void> _updatePromoNotifications(bool value) async {
    setState(() => _promoNotifications = value);
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('settings_promo_notifications', value);
    } catch (_) {}
  }

  Future<void> _updateVideoQuality(String value) async {
    setState(() => _videoQuality = value);
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('settings_video_quality', value);
    } catch (_) {}
  }

  static const List<Map<String, String>> _allLanguages = [
    {'code': 'ar', 'nativeName': 'العربية', 'englishName': 'Arabic'},
    {'code': 'en', 'nativeName': 'English', 'englishName': 'English'},
    {'code': 'de', 'nativeName': 'Deutsch', 'englishName': 'German'},
    {'code': 'es', 'nativeName': 'Español', 'englishName': 'Spanish'},
    {'code': 'fr', 'nativeName': 'Français', 'englishName': 'French'},
    {'code': 'it', 'nativeName': 'Italiano', 'englishName': 'Italian'},
    {'code': 'pt', 'nativeName': 'Português', 'englishName': 'Portuguese'},
    {'code': 'nl', 'nativeName': 'Nederlands', 'englishName': 'Dutch'},
    {'code': 'tr', 'nativeName': 'Türkçe', 'englishName': 'Turkish'},
    {'code': 'ru', 'nativeName': 'Русский', 'englishName': 'Russian'},
    {'code': 'uk', 'nativeName': 'Українська', 'englishName': 'Ukrainian'},
    {'code': 'pl', 'nativeName': 'Polski', 'englishName': 'Polish'},
    {
      'code': 'id',
      'nativeName': 'Bahasa Indonesia',
      'englishName': 'Indonesian',
    },
    {'code': 'ms', 'nativeName': 'Bahasa Melayu', 'englishName': 'Malay'},
    {'code': 'hi', 'nativeName': 'हिन्दी', 'englishName': 'Hindi'},
    {'code': 'ur', 'nativeName': 'اردو', 'englishName': 'Urdu'},
    {'code': 'zh', 'nativeName': '中文', 'englishName': 'Chinese'},
    {'code': 'ja', 'nativeName': '日本語', 'englishName': 'Japanese'},
    {'code': 'ko', 'nativeName': '한국어', 'englishName': 'Korean'},
    {'code': 'vi', 'nativeName': 'Tiếng Việt', 'englishName': 'Vietnamese'},
  ];

  Future<void> _clearCache() async {
    HapticFeedback.selectionClick();
    final downloadProvider = context.read<DownloadProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isAr = context.isArabic;
    final textColor =
        isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final textSubColor =
        isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;
    final bgColor = isDark ? AppColors.darkSurface : Colors.white;
    final cardBg =
        isDark ? AppColors.darkSurfaceMuted : const Color(0xFFF8FAFC);
    final borderColor =
        isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0);

    final totalSize = downloadProvider.totalStorageFormatted;
    final lectureCount = downloadProvider.downloadedLectures.length;
    final certCount = downloadProvider.downloadedCertificates.length;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        bool isClearing = false;
        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            return Container(
              padding: EdgeInsets.fromLTRB(
                20,
                12,
                20,
                MediaQuery.of(ctx).padding.bottom + 20,
              ),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(28),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.12),
                    blurRadius: 24,
                    offset: const Offset(0, -6),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Drag Handle
                  Center(
                    child: Container(
                      width: 42,
                      height: 4.5,
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF475569)
                            : const Color(0xFFCBD5E1),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Hero Icon with Glowing Halo
                  Center(
                    child: Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFFF43F5E),
                            Color(0xFFE11D48),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFE11D48).withValues(
                              alpha: 0.35,
                            ),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.cleaning_services_rounded,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Title & Subtitle
                  Text(
                    isAr
                        ? 'تفريغ الذاكرة ومساحة التخزين'
                        : 'Clear Cache & Storage',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'Tajawal',
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    isAr
                        ? 'تحرير مساحة الهاتف وتسريع أداء التطبيق والاستجابة'
                        : 'Free up phone storage and optimize app loading speed',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12.5,
                      fontFamily: 'Tajawal',
                      color: textSubColor,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Storage Breakdown Card
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: cardBg,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: borderColor),
                    ),
                    child: Column(
                      children: [
                        // Row 1: Offline downloads
                        _buildStorageRow(
                          icon: Icons.download_done_rounded,
                          iconColor: const Color(0xFF3B82F6),
                          title: isAr
                              ? 'المحتوى المنزّل بدون إنترنت'
                              : 'Offline Downloads',
                          subtitle: isAr
                              ? '$lectureCount محاضرات • $certCount شهادات'
                              : '$lectureCount lectures • $certCount certs',
                          trailingBadge: totalSize,
                          isHighlightBadge: true,
                          isDark: isDark,
                          textColor: textColor,
                          textSubColor: textSubColor,
                        ),
                        Divider(color: borderColor, height: 20),

                        // Row 2: Image Cache
                        _buildStorageRow(
                          icon: Icons.image_outlined,
                          iconColor: const Color(0xFFF59E0B),
                          title: isAr
                              ? 'صور المعاينة المؤقتة'
                              : 'Cached Media & Images',
                          subtitle: isAr
                              ? 'صور الدورات والمدربين المخزنة للتصفح'
                              : 'Course covers and instructor avatars',
                          trailingBadge: isAr ? 'ذاكرة مؤقتة' : 'Cached',
                          isHighlightBadge: false,
                          isDark: isDark,
                          textColor: textColor,
                          textSubColor: textSubColor,
                        ),
                        Divider(color: borderColor, height: 20),

                        // Row 3: API & Network Cache
                        _buildStorageRow(
                          icon: Icons.bolt_rounded,
                          iconColor: const Color(0xFF10B981),
                          title: isAr
                              ? 'بيانات الاستجابة السريعة'
                              : 'API & Network Cache',
                          subtitle: isAr
                              ? 'استجابات البحث وتوفير استهلاك البيانات'
                              : 'Saved network responses saving data',
                          trailingBadge: isAr ? 'محلي' : 'Local',
                          isHighlightBadge: false,
                          isDark: isDark,
                          textColor: textColor,
                          textSubColor: textSubColor,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Safety Guarantee Notice
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981).withValues(
                        alpha: isDark ? 0.15 : 0.08,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFF10B981).withValues(alpha: 0.25),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.verified_user_rounded,
                          color: Color(0xFF10B981),
                          size: 18,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            isAr
                                ? 'حسابك والدورات التي اشتريتها وشهاداتك محفوظة بأمان تام على السحابة، ويمكنك إعادة تنزيل أي محتوى مجدداً في أي وقت.'
                                : 'Your account, purchased courses, and certificates are securely stored in the cloud. You can re-download anytime.',
                            style: TextStyle(
                              fontSize: 11.5,
                              fontFamily: 'Tajawal',
                              color: isDark
                                  ? const Color(0xFFA7F3D0)
                                  : const Color(0xFF065F46),
                              height: 1.35,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Primary Clean Button
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE11D48),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: isClearing
                          ? null
                          : () async {
                              setSheetState(() => isClearing = true);
                              HapticFeedback.mediumImpact();

                              try {
                                await downloadProvider.clearAll();
                                ApiClient.clearCache();
                                PaintingBinding.instance.imageCache.clear();
                                PaintingBinding.instance.imageCache
                                    .clearLiveImages();
                              } catch (_) {}

                              if (ctx.mounted) {
                                Navigator.pop(ctx);
                              }

                              if (mounted) {
                                HapticFeedback.heavyImpact();
                                AppSnackbar.showSuccess(
                                  context,
                                  isAr
                                      ? 'تم تفريغ الذاكرة المؤقتة وتحرير $totalSize بنجاح'
                                      : context.loc.settingsClearCacheSuccess,
                                );
                              }
                            },
                      child: isClearing
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.5,
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.delete_sweep_rounded,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  isAr
                                      ? 'تأكيد تفريغ الذاكرة والملفات'
                                      : 'Clear Storage & Cache',
                                  style: const TextStyle(
                                    fontSize: 14.5,
                                    fontWeight: FontWeight.w900,
                                    fontFamily: 'Tajawal',
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Cancel Button
                  SizedBox(
                    height: 44,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: isClearing ? null : () => Navigator.pop(ctx),
                      child: Text(
                        isAr
                            ? 'إلغاء والاحتفاظ بالملفات'
                            : 'Keep Files & Cancel',
                        style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Tajawal',
                          color: textSubColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildStorageRow({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required String trailingBadge,
    required bool isHighlightBadge,
    required bool isDark,
    required Color textColor,
    required Color textSubColor,
  }) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: isDark ? 0.22 : 0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: iconColor, size: 19),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'Tajawal',
                  color: textColor,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 11,
                  fontFamily: 'Tajawal',
                  color: textSubColor,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
          decoration: BoxDecoration(
            color: isHighlightBadge
                ? const Color(0xFFE11D48).withValues(alpha: isDark ? 0.22 : 0.1)
                : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            trailingBadge,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              fontFamily: 'Tajawal',
              color: isHighlightBadge ? const Color(0xFFE11D48) : textSubColor,
            ),
          ),
        ),
      ],
    );
  }

  void _showLanguageBottomSheet(BuildContext context) {
    HapticFeedback.selectionClick();
    final localeService = context.read<LocaleService>();
    final currentCode = localeService.locale.languageCode;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        String searchQuery = '';
        return StatefulBuilder(
          builder: (context, setModalState) {
            final filtered = _allLanguages.where((lang) {
              final query = searchQuery.trim().toLowerCase();
              if (query.isEmpty) return true;
              return lang['nativeName']!.toLowerCase().contains(query) ||
                  lang['englishName']!.toLowerCase().contains(query) ||
                  lang['code']!.toLowerCase().contains(query);
            }).toList();

            final sheetBg = isDark ? AppColors.darkSurface : Colors.white;
            final sheetText = isDark
                ? AppColors.darkTextPrimary
                : AppColors.textPrimary;
            final sheetSubText = isDark
                ? AppColors.darkTextSecondary
                : AppColors.textSecondary;
            final searchBg = isDark
                ? AppColors.darkSurfaceMuted
                : const Color(0xFFF1F5F9);

            return Container(
              height: MediaQuery.of(context).size.height * 0.78,
              decoration: BoxDecoration(
                color: sheetBg,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 20,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  // Drag handle
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF475569)
                          : const Color(0xFFCBD5E1),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Header
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.translate_rounded,
                            color: AppColors.primary,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                context.loc.languageDialogTitle,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                  fontFamily: 'Tajawal',
                                  color: sheetText,
                                ),
                              ),
                              Text(
                                '${_allLanguages.length} Languages available',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'Tajawal',
                                  color: sheetSubText,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.close_rounded, color: sheetSubText),
                          onPressed: () => Navigator.pop(sheetContext),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Search Bar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      decoration: BoxDecoration(
                        color: searchBg,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: TextField(
                        onChanged: (val) =>
                            setModalState(() => searchQuery = val),
                        style: TextStyle(
                          fontSize: 13.5,
                          color: sheetText,
                          fontFamily: 'Tajawal',
                        ),
                        decoration: InputDecoration(
                          hintText: context.loc.homeSearchHint,
                          hintStyle: TextStyle(
                            fontSize: 13,
                            color: sheetSubText,
                            fontFamily: 'Tajawal',
                          ),
                          prefixIcon: Icon(
                            Icons.search_rounded,
                            color: sheetSubText,
                            size: 20,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Languages List
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      itemCount: filtered.length,
                      separatorBuilder: (_, index) => const SizedBox(height: 8),
                      itemBuilder: (ctx, idx) {
                        final item = filtered[idx];
                        final isSelected = item['code'] == currentCode;

                        return Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              HapticFeedback.mediumImpact();
                              Navigator.pop(sheetContext);
                              localeService.setLocale(item['code']!);
                            },
                            borderRadius: BorderRadius.circular(14),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.primary.withValues(
                                        alpha: isDark ? 0.2 : 0.08,
                                      )
                                    : (isDark
                                          ? AppColors.darkSurfaceMuted
                                          : const Color(0xFFF8FAFC)),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.primary
                                      : (isDark
                                            ? AppColors.darkBorder
                                            : const Color(0xFFE2E8F0)),
                                  width: isSelected ? 1.8 : 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  // Language Icon badge
                                  Container(
                                    width: 38,
                                    height: 38,
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? AppColors.primary.withValues(
                                              alpha: 0.15,
                                            )
                                          : (isDark
                                                ? AppColors.darkSurface
                                                : Colors.white),
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: isSelected
                                            ? AppColors.primary.withValues(
                                                alpha: 0.3,
                                              )
                                            : (isDark
                                                  ? AppColors.darkBorder
                                                  : const Color(0xFFE2E8F0)),
                                      ),
                                    ),
                                    alignment: Alignment.center,
                                    child: Icon(
                                      Icons.translate_rounded,
                                      size: 19,
                                      color: isSelected
                                          ? AppColors.primary
                                          : sheetSubText,
                                    ),
                                  ),
                                  const SizedBox(width: 14),

                                  // Names
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item['nativeName']!,
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: isSelected
                                                ? FontWeight.w900
                                                : FontWeight.bold,
                                            color: isSelected
                                                ? AppColors.primary
                                                : sheetText,
                                            fontFamily: 'Tajawal',
                                          ),
                                        ),
                                        Text(
                                          item['englishName']!,
                                          style: TextStyle(
                                            fontSize: 11.5,
                                            color: sheetSubText,
                                            fontFamily: 'Tajawal',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Selection Indicator
                                  if (isSelected)
                                    Container(
                                      width: 24,
                                      height: 24,
                                      decoration: const BoxDecoration(
                                        color: AppColors.primary,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.check_rounded,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                    )
                                  else
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 3,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isDark
                                            ? AppColors.darkSurface
                                            : const Color(0xFFF1F5F9),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        item['code']!.toUpperCase(),
                                        style: TextStyle(
                                          fontSize: 10.5,
                                          fontWeight: FontWeight.bold,
                                          color: sheetSubText,
                                          fontFamily: 'Inter',
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showQualityDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Text(
          context.loc.settingsDownloadQuality,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            fontFamily: 'Tajawal',
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ['1080p', '720p', '480p', '360p'].map((q) {
            final isSelected = _videoQuality == q;
            return ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              title: Text(
                q,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13.5,
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: isSelected
                  ? const Icon(
                      Icons.check_circle_rounded,
                      color: AppColors.primary,
                    )
                  : null,
              onTap: () {
                _updateVideoQuality(q);
                Navigator.pop(ctx);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeService = context.watch<ThemeService>();
    final localeService = context.watch<LocaleService>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final isAr = context.isArabic;

    final currentLang = _allLanguages.firstWhere(
      (l) => l['code'] == localeService.locale.languageCode,
      orElse: () => {
        'nativeName': 'العربية',
        'englishName': 'Arabic',
        'flag': '🇸🇦',
      },
    );

    final bgColor = AppColors.getBackground(context);
    final cardBgColor = AppColors.getSurface(context);
    final borderColor = AppColors.getBorder(context);
    final textColor = AppColors.getTextPrimary(context);
    final textSubColor = AppColors.getTextSecondary(context);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: cardBgColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            isRtl ? Icons.arrow_forward_rounded : Icons.arrow_back_rounded,
            color: textColor,
          ),
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            } else {
              Navigator.of(context).pushReplacementNamed('/main');
            }
          },
        ),
        title: Text(
          context.loc.settingsTitle,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w900,
            color: textColor,
            fontFamily: 'Tajawal',
          ),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.fromLTRB(
          AppResponsive.screenPadding(context),
          16,
          AppResponsive.screenPadding(context),
          40,
        ),
        children: [
          // 1. Appearance & Theme Mode
          _buildSectionHeader(context.loc.settingsAppearance),
          _buildGroupContainer(cardBgColor, borderColor, isDark, [
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 6),
              child: Row(
                children: [
                  _buildIconBadge(
                    icon: isDark
                        ? Icons.dark_mode_rounded
                        : Icons.light_mode_rounded,
                    color: isDark
                        ? const Color(0xFF818CF8)
                        : const Color(0xFFF59E0B),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isAr ? 'نمط المظهر والعرض' : 'Display Theme',
                          style: TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w900,
                            fontFamily: 'Tajawal',
                            color: textColor,
                          ),
                        ),
                        Text(
                          themeService.isDarkMode
                              ? context.loc.settingsDarkModeEnabled
                              : context.loc.settingsDarkModeDisabled,
                          style: TextStyle(
                            fontSize: 11.5,
                            fontFamily: 'Tajawal',
                            color: textSubColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 8, 14, 14),
              child: Row(
                children: [
                  Expanded(
                    child: _buildThemeCard(
                      title: context.loc.themeLight,
                      englishTitle: 'Light',
                      icon: Icons.light_mode_rounded,
                      iconColor: const Color(0xFFF59E0B),
                      isSelected: themeService.themeMode == ThemeMode.light,
                      isDark: isDark,
                      previewBg: Colors.white,
                      previewBorder: const Color(0xFFE2E8F0),
                      onTap: () {
                        HapticFeedback.selectionClick();
                        themeService.setThemeMode(ThemeMode.light);
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildThemeCard(
                      title: context.loc.themeDark,
                      englishTitle: 'Dark',
                      icon: Icons.dark_mode_rounded,
                      iconColor: const Color(0xFF818CF8),
                      isSelected: themeService.themeMode == ThemeMode.dark,
                      isDark: isDark,
                      previewBg: const Color(0xFF0F172A),
                      previewBorder: const Color(0xFF334155),
                      onTap: () {
                        HapticFeedback.selectionClick();
                        themeService.setThemeMode(ThemeMode.dark);
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildThemeCard(
                      title: context.loc.themeSystem,
                      englishTitle: 'System',
                      icon: Icons.settings_brightness_rounded,
                      iconColor: const Color(0xFF10B981),
                      isSelected: themeService.themeMode == ThemeMode.system,
                      isDark: isDark,
                      previewBg: isDark
                          ? const Color(0xFF1E293B)
                          : const Color(0xFFF1F5F9),
                      previewBorder: isDark
                          ? const Color(0xFF475569)
                          : const Color(0xFFCBD5E1),
                      onTap: () {
                        HapticFeedback.selectionClick();
                        themeService.setThemeMode(ThemeMode.system);
                      },
                    ),
                  ),
                ],
              ),
            ),
            _buildDivider(isDark),
            _buildSwitchTile(
              icon: Icons.brightness_2_rounded,
              iconColor: const Color(0xFF6366F1),
              title: isAr
                  ? 'الوضع الداكن الفائق (AMOLED)'
                  : 'Pure AMOLED Dark',
              subtitle: isAr
                  ? 'سواد تام لشاشات OLED لتوفير البطارية'
                  : 'True pitch-black for OLED battery saving',
              value: themeService.isAmoled,
              textColor: textColor,
              textSubColor: textSubColor,
              onChanged: (val) => themeService.toggleAmoled(val),
            ),
          ]),

          const SizedBox(height: 18),

          // 2. Text Size & Reading Experience
          _buildSectionHeader(
            isAr ? 'حجم الخط والقراءة' : 'Text Size & Typography',
          ),
          _buildGroupContainer(cardBgColor, borderColor, isDark, [
            _buildTextScaleSelector(
              themeService: themeService,
              isAr: isAr,
              isDark: isDark,
              textColor: textColor,
              textSubColor: textSubColor,
            ),
          ]),

          const SizedBox(height: 20),

          // 2. Language Selection Card
          _buildSectionHeader(context.loc.settingsLanguage),
          Container(
            decoration: BoxDecoration(
              color: cardBgColor,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: borderColor),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => _showLanguageBottomSheet(context),
                borderRadius: BorderRadius.circular(18),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  child: Row(
                    children: [
                      _buildIconBadge(
                        icon: Icons.translate_rounded,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              context.loc.settingsLanguage,
                              style: TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Tajawal',
                                color: textColor,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${currentLang['nativeName']} (${currentLang['englishName']})',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Tajawal',
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(
                            alpha: isDark ? 0.2 : 0.08,
                          ),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: AppColors.primary.withValues(alpha: 0.2),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              context.loc.generalEdit,
                              style: const TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w900,
                                color: AppColors.primary,
                                fontFamily: 'Tajawal',
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              isRtl
                                  ? Icons.chevron_left_rounded
                                  : Icons.chevron_right_rounded,
                              color: AppColors.primary,
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // 3. Notifications & Reminders
          _buildSectionHeader(context.loc.settingsNotifications),
          _buildGroupContainer(cardBgColor, borderColor, isDark, [
            _buildSwitchTile(
              icon: Icons.notifications_active_outlined,
              iconColor: const Color(0xFF3B82F6),
              title: context.loc.settingsCourseNotifications,
              subtitle: isAr
                  ? 'تنبيهات الدروس والواجبات والتذكيرات'
                  : 'Lesson updates, assignments & reminders',
              value: _pushNotifications,
              textColor: textColor,
              textSubColor: textSubColor,
              onChanged: (val) => _updatePushNotifications(val),
            ),
            _buildDivider(isDark),
            _buildSwitchTile(
              icon: Icons.local_offer_outlined,
              iconColor: const Color(0xFFF59E0B),
              title: context.loc.settingsPromoNotifications,
              subtitle: isAr
                  ? 'العروض الحصرية والتخفيضات الخاصة'
                  : 'Exclusive offers & special discounts',
              value: _promoNotifications,
              textColor: textColor,
              textSubColor: textSubColor,
              onChanged: (val) => _updatePromoNotifications(val),
            ),
          ]),

          const SizedBox(height: 20),

          // 4. Video & Download
          _buildSectionHeader(context.loc.settingsVideoDownload),
          _buildGroupContainer(cardBgColor, borderColor, isDark, [
            _buildSettingTile(
              icon: Icons.high_quality_rounded,
              iconColor: const Color(0xFF8B5CF6),
              textColor: textColor,
              textSubColor: textSubColor,
              title: context.loc.settingsDownloadQuality,
              subtitle: _videoQuality,
              onTap: _showQualityDialog,
              isRtl: isRtl,
            ),
            _buildDivider(isDark),
            _buildSwitchTile(
              icon: Icons.wifi_rounded,
              iconColor: const Color(0xFF10B981),
              title: context.loc.settingsWifiOnly,
              subtitle: isAr
                  ? 'منع استهلاك باقة الهاتف الخلوي أثناء التحميل'
                  : 'Prevent cellular data usage when downloading',
              value: _downloadWifiOnly,
              textColor: textColor,
              textSubColor: textSubColor,
              onChanged: (val) => _updateWifiOnly(val),
            ),
          ]),

          const SizedBox(height: 20),

          // 5. Storage & Cache
          _buildSectionHeader(context.loc.settingsStorage),
          _buildGroupContainer(cardBgColor, borderColor, isDark, [
            Consumer<DownloadProvider>(
              builder: (context, downloadProvider, _) {
                return _buildSettingTile(
                  icon: Icons.cleaning_services_rounded,
                  iconColor: const Color(0xFFEC4899),
                  textColor: textColor,
                  textSubColor: textSubColor,
                  title: context.loc.settingsClearCache,
                  subtitle: downloadProvider.totalStorageFormatted,
                  onTap: _clearCache,
                  isRtl: isRtl,
                );
              },
            ),
          ]),

          const SizedBox(height: 20),

          // 6. Help & Policies
          _buildSectionHeader(context.loc.settingsHelp),
          _buildGroupContainer(cardBgColor, borderColor, isDark, [
            _buildSettingTile(
              icon: Icons.help_outline_rounded,
              iconColor: const Color(0xFF06B6D4),
              textColor: textColor,
              textSubColor: textSubColor,
              title: context.loc.settingsHelpCenter,
              subtitle: isAr
                  ? 'الأسئلة الشائعة ودعم العملاء الفوري'
                  : 'FAQs & Instant 24/7 support',
              onTap: () => _showHelpCenterBottomSheet(context),
              isRtl: isRtl,
            ),
            _buildDivider(isDark),
            _buildSettingTile(
              icon: Icons.shield_outlined,
              iconColor: const Color(0xFF10B981),
              textColor: textColor,
              textSubColor: textSubColor,
              title: context.loc.settingsTermsPrivacy,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) =>
                        const LegalContentScreen(initialTab: LegalTab.privacy),
                  ),
                );
              },
              isRtl: isRtl,
            ),
            _buildDivider(isDark),
            _buildSettingTile(
              icon: Icons.info_outline_rounded,
              iconColor: const Color(0xFF64748B),
              textColor: textColor,
              textSubColor: textSubColor,
              title: context.loc.settingsAbout,
              subtitle: 'v1.0.0 (Build 1)',
              onTap: () => _showAboutModal(context),
              isRtl: isRtl,
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildThemeCard({
    required String title,
    required String englishTitle,
    required IconData icon,
    required Color iconColor,
    required bool isSelected,
    required bool isDark,
    required Color previewBg,
    required Color previewBorder,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primary.withValues(alpha: isDark ? 0.22 : 0.08)
                : (isDark
                      ? AppColors.darkSurfaceMuted
                      : const Color(0xFFF8FAFC)),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected
                  ? AppColors.primary
                  : (isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0)),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Column(
            children: [
              // Mini preview badge
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: previewBg,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primary.withValues(alpha: 0.5)
                        : previewBorder,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.06),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  icon,
                  color: isSelected ? AppColors.primary : iconColor,
                  size: 20,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: isSelected ? FontWeight.w900 : FontWeight.bold,
                  color: isSelected
                      ? AppColors.primary
                      : (isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.textPrimary),
                  fontFamily: 'Tajawal',
                ),
              ),
              Text(
                englishTitle,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected
                      ? AppColors.primary.withValues(alpha: 0.85)
                      : (isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.textSecondary),
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIconBadge({required IconData icon, required Color color}) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10),
      ),
      alignment: Alignment.center,
      child: Icon(icon, color: color, size: 20),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(right: 6, left: 6, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 12.5,
          fontWeight: FontWeight.w800,
          color: Color(0xFF64748B),
          fontFamily: 'Tajawal',
          letterSpacing: 0.2,
        ),
      ),
    );
  }

  Widget _buildGroupContainer(
    Color bgColor,
    Color borderColor,
    bool isDark,
    List<Widget> children,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    String? subtitle,
    required bool value,
    required Color textColor,
    Color? textSubColor,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      child: Row(
        children: [
          _buildIconBadge(icon: icon, color: iconColor),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Tajawal',
                    color: textColor,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 11,
                      fontFamily: 'Tajawal',
                      color: textSubColor ?? const Color(0xFF94A3B8),
                    ),
                  ),
                ],
              ],
            ),
          ),
          Switch(
            value: value,
            activeThumbColor: Colors.white,
            activeTrackColor: AppColors.primary,
            onChanged: (val) {
              HapticFeedback.selectionClick();
              onChanged(val);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTextScaleSelector({
    required ThemeService themeService,
    required bool isAr,
    required bool isDark,
    required Color textColor,
    required Color textSubColor,
  }) {
    final currentScale = themeService.textScale;
    final percent = (currentScale * 100).round();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildIconBadge(
                icon: Icons.format_size_rounded,
                color: AppColors.primary,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isAr ? 'حجم خط التطبيق' : 'App Text Size',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'Tajawal',
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      isAr
                          ? 'ضبط حجم النصوص لسهولة القراءة'
                          : 'Adjust text scaling for comfortable reading',
                      style: TextStyle(
                        fontSize: 11,
                        fontFamily: 'Tajawal',
                        color: textSubColor,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(
                    alpha: isDark ? 0.22 : 0.1,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.35),
                  ),
                ),
                child: Text(
                  '$percent%',
                  style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'Tajawal',
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Presets buttons row
          Row(
            children: ThemeService.textScalePresets.map((preset) {
              final isSelected = (currentScale - preset.scale).abs() < 0.01;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        HapticFeedback.selectionClick();
                        themeService.setTextScale(preset.scale);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        padding: const EdgeInsets.symmetric(vertical: 9),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary.withValues(
                                  alpha: isDark ? 0.25 : 0.12,
                                )
                              : (isDark
                                  ? AppColors.darkSurfaceMuted
                                  : const Color(0xFFF1F5F9)),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primary
                                : (isDark
                                    ? AppColors.darkBorder
                                    : const Color(0xFFE2E8F0)),
                            width: isSelected ? 1.8 : 1,
                          ),
                        ),
                        child: Text(
                          isAr ? preset.labelAr : preset.labelEn,
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight:
                                isSelected ? FontWeight.w900 : FontWeight.w600,
                            fontFamily: 'Tajawal',
                            color: isSelected
                                ? AppColors.primary
                                : textSubColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 14),

          // Live Interactive Mini Course Card Preview
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark
                  ? (themeService.isAmoled
                      ? const Color(0xFF0A0A0A)
                      : AppColors.darkSurfaceMuted)
                  : const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.visibility_rounded,
                          size: 14,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          isAr ? 'معاينة حية للبطاقات والنصوص' : 'Live Preview',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primary,
                            fontFamily: 'Tajawal',
                          ),
                        ),
                      ],
                    ),
                    Text(
                      isAr ? 'تأثير فوري' : 'Instant',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: textSubColor,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B) : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDark
                          ? const Color(0xFF334155)
                          : const Color(0xFFE2E8F0),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(
                          alpha: isDark ? 0.2 : 0.04,
                        ),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(
                            alpha: isDark ? 0.25 : 0.12,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.school_rounded,
                          color: AppColors.primary,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isAr
                                  ? 'تطوير تطبيقات الهاتف المتكاملة'
                                  : 'Full-Stack Mobile App Development',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 12.5 * currentScale,
                                fontWeight: FontWeight.w900,
                                fontFamily: 'Tajawal',
                                color: textColor,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(
                                  Icons.star_rounded,
                                  size: 13 * currentScale,
                                  color: const Color(0xFFF59E0B),
                                ),
                                const SizedBox(width: 3),
                                Text(
                                  '4.9',
                                  style: TextStyle(
                                    fontSize: 10.5 * currentScale,
                                    fontWeight: FontWeight.bold,
                                    color: textSubColor,
                                    fontFamily: 'Tajawal',
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  isAr ? '199 ر.س' : '199 SAR',
                                  style: TextStyle(
                                    fontSize: 11.5 * currentScale,
                                    fontWeight: FontWeight.w900,
                                    fontFamily: 'Tajawal',
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showHelpCenterBottomSheet(BuildContext context) {
    HapticFeedback.selectionClick();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isAr = context.isArabic;
    final textColor = isDark
        ? AppColors.darkTextPrimary
        : AppColors.textPrimary;
    final textSubColor = isDark
        ? AppColors.darkTextSecondary
        : AppColors.textSecondary;
    final bgColor = isDark ? AppColors.darkSurface : Colors.white;

    final faqs = [
      {
        'q': isAr
            ? 'كيف يمكنني تحميل المحاضرات لمشاهدتها بدون إنترنت؟'
            : 'How do I download lectures for offline viewing?',
        'a': isAr
            ? 'يمكنك تنزيل أي محاضرة بالضغط على زر التنزيل بجانب عنوان الدرس داخل مشغل المحاضرات. بعد اكتمال التنزيل، ستتمكن من تشغيل المحتوى كاملاً في تبويب "المحملة" بشاشة تعلّمي بدون اتصال بالإنترنت.'
            : 'You can download any lecture by clicking the download icon next to the lesson title inside the player. Once completed, you can access your content anytime under the "Downloaded" tab in My Courses without internet.',
      },
      {
        'q': isAr
            ? 'كيف ومتى أحصل على شهادة إتمام الدورة المعتمدة؟'
            : 'When and how do I receive my verified certificate?',
        'a': isAr
            ? 'بمجرد إكمال 100% من جميع دروس الدورة واجتياز التقييمات، يتم إصدار شهادتك الرقمية فوراً بكود تحقق فريد. يمكنك معاينتها، تنزيلها كملف PDF عالي الدقة، أو مشاركتها على LinkedIn.'
            : 'Upon completing 100% of the curriculum and quizzes, your digital certificate is instantly issued with a unique verification code. You can preview, download as high-res PDF, or share to LinkedIn.',
      },
      {
        'q': isAr
            ? 'ما هي شروط وسياسة استرداد المبلغ المدفوع؟'
            : 'What is the refund and cancellation policy?',
        'a': isAr
            ? 'نضمن لك استرداد كامل المبلغ خلال 14 يوماً من تاريخ الشراء بشرط عدم مشاهدة أكثر من 20% من إجمالي محتوى الدورة، ويتم تحويل المبلغ لنفس وسيلة الدفع المستخدمة.'
            : 'We offer a full 14-day refund guarantee provided you have watched less than 20% of the total course content. Funds are returned to the original payment method.',
      },
      {
        'q': isAr
            ? 'كيف يمكنني التواصل مع المدرب لطرح استفسارات؟'
            : 'How can I reach out to my instructor with questions?',
        'a': isAr
            ? 'يمكنك كتابة استفسارك في تبويب "المناقشات" أسفل كل درس ليتفاعل معك المدرب والطلاب، أو التوجه للملف الشخصي للمدرب لإرسال رسالة مباشرة أو حجز جلسة استشارية.'
            : 'You can post your question in the "Discussions" tab under any lesson, or visit the instructor profile to send a direct message or book a consultation session.',
      },
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetCtx) => Container(
        height: MediaQuery.of(context).size.height * 0.82,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF475569)
                    : const Color(0xFFCBD5E1),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),

            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF06B6D4).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.help_outline_rounded,
                      color: Color(0xFF06B6D4),
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isAr
                              ? 'مركز المساعدة والأسئلة الشائعة'
                              : 'Help Center & FAQs',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            fontFamily: 'Tajawal',
                            color: textColor,
                          ),
                        ),
                        Text(
                          isAr
                              ? 'إجابات سريعة ودعم فني متواصل'
                              : 'Quick answers & 24/7 technical support',
                          style: TextStyle(
                            fontSize: 11.5,
                            fontFamily: 'Tajawal',
                            color: textSubColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close_rounded, color: textSubColor),
                    onPressed: () => Navigator.pop(sheetCtx),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Quick Contact Buttons Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 11),
                        side: BorderSide(
                          color: AppColors.primary.withValues(alpha: 0.4),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(
                        Icons.email_outlined,
                        size: 18,
                        color: AppColors.primary,
                      ),
                      label: Text(
                        isAr ? 'راسل الدعم' : 'Email Us',
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Tajawal',
                          color: AppColors.primary,
                        ),
                      ),
                      onPressed: () async {
                        final uri = Uri.parse(
                          'mailto:support@edulab.education?subject=EduLab Support Request',
                        );
                        if (await canLaunchUrl(uri)) {
                          await launchUrl(uri);
                        } else if (context.mounted) {
                          AppSnackbar.show(
                            context,
                            'support@edulab.education',
                          );
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 11),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(
                        Icons.chat_bubble_outline_rounded,
                        size: 18,
                      ),
                      label: Text(
                        isAr ? 'الدردشة الحية' : 'Live Chat',
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Tajawal',
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(sheetCtx);
                        Navigator.of(context).pushNamed('/messages');
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // FAQ Accordion List
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                itemCount: faqs.length,
                separatorBuilder: (_, index) => const SizedBox(height: 10),
                itemBuilder: (ctx, idx) {
                  final faq = faqs[idx];
                  return Container(
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.darkSurfaceMuted
                          : const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isDark
                            ? AppColors.darkBorder
                            : const Color(0xFFE2E8F0),
                      ),
                    ),
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        dividerColor: Colors.transparent,
                      ),
                      child: ExpansionTile(
                        tilePadding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 4,
                        ),
                        childrenPadding: const EdgeInsets.fromLTRB(
                          14,
                          0,
                          14,
                          12,
                        ),
                        leading: CircleAvatar(
                          radius: 14,
                          backgroundColor: AppColors.primary.withValues(
                            alpha: 0.12,
                          ),
                          child: Text(
                            '${idx + 1}',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ),
                        title: Text(
                          faq['q']!,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Tajawal',
                            color: textColor,
                          ),
                        ),
                        children: [
                          Text(
                            faq['a']!,
                            style: TextStyle(
                              fontSize: 12,
                              fontFamily: 'Tajawal',
                              color: textSubColor,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAboutModal(BuildContext context) {
    HapticFeedback.selectionClick();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isAr = context.isArabic;
    final textColor = isDark
        ? AppColors.darkTextPrimary
        : AppColors.textPrimary;
    final textSubColor = isDark
        ? AppColors.darkTextSecondary
        : AppColors.textSecondary;
    final cardBg = isDark ? AppColors.darkSurface : Colors.white;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: cardBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            // EduLab Logo Badge
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1D61E7), Color(0xFF3B82F6)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF1D61E7).withValues(alpha: 0.35),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.school_rounded,
                color: Colors.white,
                size: 34,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              'EduLab',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                fontFamily: 'Tajawal',
                color: textColor,
              ),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'v1.0.0 (Build 1)',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                  fontFamily: 'Inter',
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              isAr
                  ? 'المنصة التعليمية الشاملة لتمكين الطلاب والمدربين في العالم العربي بتجربة تعلم رقمية تفاعلية حديثة.'
                  : 'Comprehensive digital learning platform empowering students and instructors across the Arab world.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontFamily: 'Tajawal',
                color: textSubColor,
                height: 1.45,
              ),
            ),
            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 8),

            // Licenses action
            TextButton.icon(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
              ),
              icon: const Icon(Icons.verified_outlined, size: 18),
              label: Text(
                isAr ? 'تراخيص المصادر المفتوحة' : 'Open Source Licenses',
                style: const TextStyle(
                  fontFamily: 'Tajawal',
                  fontSize: 12.5,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.pop(ctx);
                showLicensePage(
                  context: context,
                  applicationName: 'EduLab',
                  applicationVersion: '1.0.0+1',
                );
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              isAr ? 'إغلاق' : 'Close',
              style: const TextStyle(fontFamily: 'Tajawal'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required Color iconColor,
    required Color textColor,
    required Color textSubColor,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
    required bool isRtl,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          HapticFeedback.selectionClick();
          onTap();
        },
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              _buildIconBadge(icon: icon, color: iconColor),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 11,
                          color: textSubColor,
                          fontFamily: 'Tajawal',
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Icon(
                isRtl
                    ? Icons.chevron_left_rounded
                    : Icons.chevron_right_rounded,
                color: const Color(0xFF94A3B8),
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDivider(bool isDark) {
    return Divider(
      height: 1,
      indent: 62,
      endIndent: 14,
      color: isDark ? AppColors.darkDivider : const Color(0xFFF1F5F9),
    );
  }
}

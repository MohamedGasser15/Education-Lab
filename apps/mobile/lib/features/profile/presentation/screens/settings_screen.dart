import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:mobile/core/extensions/localization_ext.dart';
import 'package:mobile/core/services/theme_service.dart';
import 'package:mobile/core/services/locale_service.dart';
import 'package:mobile/core/theme/app_colors.dart';

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

  static const List<Map<String, String>> _allLanguages = [
    {'code': 'ar', 'nativeName': 'العربية', 'englishName': 'Arabic', 'flag': '🇸🇦'},
    {'code': 'en', 'nativeName': 'English', 'englishName': 'English', 'flag': '🇺🇸'},
    {'code': 'de', 'nativeName': 'Deutsch', 'englishName': 'German', 'flag': '🇩🇪'},
    {'code': 'es', 'nativeName': 'Español', 'englishName': 'Spanish', 'flag': '🇪🇸'},
    {'code': 'fr', 'nativeName': 'Français', 'englishName': 'French', 'flag': '🇫🇷'},
    {'code': 'it', 'nativeName': 'Italiano', 'englishName': 'Italian', 'flag': '🇮🇹'},
    {'code': 'pt', 'nativeName': 'Português', 'englishName': 'Portuguese', 'flag': '🇧🇷'},
    {'code': 'nl', 'nativeName': 'Nederlands', 'englishName': 'Dutch', 'flag': '🇳🇱'},
    {'code': 'tr', 'nativeName': 'Türkçe', 'englishName': 'Turkish', 'flag': '🇹🇷'},
    {'code': 'ru', 'nativeName': 'Русский', 'englishName': 'Russian', 'flag': '🇷🇺'},
    {'code': 'uk', 'nativeName': 'Українська', 'englishName': 'Ukrainian', 'flag': '🇺🇦'},
    {'code': 'pl', 'nativeName': 'Polski', 'englishName': 'Polish', 'flag': '🇵🇱'},
    {'code': 'id', 'nativeName': 'Bahasa Indonesia', 'englishName': 'Indonesian', 'flag': '🇮🇩'},
    {'code': 'ms', 'nativeName': 'Bahasa Melayu', 'englishName': 'Malay', 'flag': '🇲🇾'},
    {'code': 'hi', 'nativeName': 'हिन्दी', 'englishName': 'Hindi', 'flag': '🇮🇳'},
    {'code': 'ur', 'nativeName': 'اردو', 'englishName': 'Urdu', 'flag': '🇵🇰'},
    {'code': 'zh', 'nativeName': '中文', 'englishName': 'Chinese', 'flag': '🇨🇳'},
    {'code': 'ja', 'nativeName': '日本語', 'englishName': 'Japanese', 'flag': '🇯🇵'},
    {'code': 'ko', 'nativeName': '한국어', 'englishName': 'Korean', 'flag': '🇰🇷'},
    {'code': 'vi', 'nativeName': 'Tiếng Việt', 'englishName': 'Vietnamese', 'flag': '🇻🇳'},
  ];

  void _clearCache() {
    HapticFeedback.mediumImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                context.loc.settingsClearCacheSuccess,
                style: const TextStyle(fontFamily: 'Tajawal', fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF059669),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
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
            final sheetText = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
            final sheetSubText = isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;
            final searchBg = isDark ? AppColors.darkSurfaceMuted : const Color(0xFFF1F5F9);

            return Container(
              height: MediaQuery.of(context).size.height * 0.78,
              decoration: BoxDecoration(
                color: sheetBg,
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
                  // Drag handle
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF475569) : const Color(0xFFCBD5E1),
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
                        onChanged: (val) => setModalState(() => searchQuery = val),
                        style: TextStyle(fontSize: 13.5, color: sheetText, fontFamily: 'Tajawal'),
                        decoration: InputDecoration(
                          hintText: context.loc.homeSearchHint,
                          hintStyle: TextStyle(fontSize: 13, color: sheetSubText, fontFamily: 'Tajawal'),
                          prefixIcon: Icon(Icons.search_rounded, color: sheetSubText, size: 20),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Languages List
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
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
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.primary.withValues(alpha: isDark ? 0.2 : 0.08)
                                    : (isDark ? AppColors.darkSurfaceMuted : const Color(0xFFF8FAFC)),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.primary
                                      : (isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0)),
                                  width: isSelected ? 1.8 : 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  // Flag / Code badge
                                  Container(
                                    width: 38,
                                    height: 38,
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? AppColors.primary.withValues(alpha: 0.15)
                                          : (isDark ? AppColors.darkSurface : Colors.white),
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: isSelected
                                            ? AppColors.primary.withValues(alpha: 0.3)
                                            : (isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0)),
                                      ),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      item['flag'] ?? '🌐',
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                  ),
                                  const SizedBox(width: 14),

                                  // Names
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item['nativeName']!,
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: isSelected ? FontWeight.w900 : FontWeight.bold,
                                            color: isSelected ? AppColors.primary : sheetText,
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
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: isDark ? AppColors.darkSurface : const Color(0xFFF1F5F9),
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
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, fontFamily: 'Tajawal'),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ['1080p', '720p', '480p', '360p'].map((q) {
            final isSelected = _videoQuality == q;
            return ListTile(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              title: Text(q, style: const TextStyle(fontFamily: 'Inter', fontSize: 13.5, fontWeight: FontWeight.bold)),
              trailing: isSelected ? const Icon(Icons.check_circle_rounded, color: AppColors.primary) : null,
              onTap: () {
                setState(() => _videoQuality = q);
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

    final currentLang = _allLanguages.firstWhere(
      (l) => l['code'] == localeService.locale.languageCode,
      orElse: () => {'nativeName': 'العربية', 'englishName': 'Arabic', 'flag': '🇸🇦'},
    );

    final bgColor = isDark ? AppColors.darkBackground : const Color(0xFFF8FAFC);
    final cardBgColor = isDark ? AppColors.darkSurface : Colors.white;
    final borderColor = isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0);
    final textColor = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final textSubColor = isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: cardBgColor,
        elevation: 0,
        centerTitle: false,
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
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
        children: [
          // 1. Appearance & Theme Selection
          _buildSectionHeader(context.loc.settingsAppearance),
          Container(
            padding: const EdgeInsets.all(14),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _buildIconBadge(
                      icon: isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                      color: isDark ? const Color(0xFF818CF8) : const Color(0xFFF59E0B),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.loc.settingsAppearance,
                            style: TextStyle(
                              fontSize: 14,
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
                const SizedBox(height: 14),

                // 3-way Theme Selection Cards (Light / Dark / System)
                Row(
                  children: [
                    Expanded(
                      child: _buildThemeCard(
                        title: 'فاتح',
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
                        title: 'داكن',
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
                        title: 'تلقائي',
                        englishTitle: 'System',
                        icon: Icons.settings_brightness_rounded,
                        iconColor: const Color(0xFF10B981),
                        isSelected: themeService.themeMode == ThemeMode.system,
                        isDark: isDark,
                        previewBg: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                        previewBorder: isDark ? const Color(0xFF475569) : const Color(0xFFCBD5E1),
                        onTap: () {
                          HapticFeedback.selectionClick();
                          themeService.setThemeMode(ThemeMode.system);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

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
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
                              '${currentLang['flag']} ${currentLang['nativeName']} (${currentLang['englishName']})',
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
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: isDark ? 0.2 : 0.08),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
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
                              isRtl ? Icons.chevron_left_rounded : Icons.chevron_right_rounded,
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
              value: _pushNotifications,
              textColor: textColor,
              onChanged: (val) => setState(() => _pushNotifications = val),
            ),
            _buildDivider(isDark),
            _buildSwitchTile(
              icon: Icons.local_offer_outlined,
              iconColor: const Color(0xFFF59E0B),
              title: context.loc.settingsPromoNotifications,
              value: _promoNotifications,
              textColor: textColor,
              onChanged: (val) => setState(() => _promoNotifications = val),
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
              value: _downloadWifiOnly,
              textColor: textColor,
              onChanged: (val) => setState(() => _downloadWifiOnly = val),
            ),
          ]),

          const SizedBox(height: 20),

          // 5. Storage & Cache
          _buildSectionHeader(context.loc.settingsStorage),
          _buildGroupContainer(cardBgColor, borderColor, isDark, [
            _buildSettingTile(
              icon: Icons.cleaning_services_rounded,
              iconColor: const Color(0xFFEC4899),
              textColor: textColor,
              textSubColor: textSubColor,
              title: context.loc.settingsClearCache,
              subtitle: '124 MB',
              onTap: _clearCache,
              isRtl: isRtl,
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
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(context.loc.settingsHelpCenter),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
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
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(context.loc.settingsTermsPrivacy),
                    behavior: SnackBarBehavior.floating,
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
              subtitle: context.loc.settingsVersion,
              onTap: () {},
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
                : (isDark ? AppColors.darkSurfaceMuted : const Color(0xFFF8FAFC)),
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
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: previewBg,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: previewBorder),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: isSelected ? FontWeight.w900 : FontWeight.bold,
                  color: isSelected
                      ? AppColors.primary
                      : (isDark ? AppColors.darkTextPrimary : AppColors.textPrimary),
                  fontFamily: 'Tajawal',
                ),
              ),
              Text(
                englishTitle,
                style: TextStyle(
                  fontSize: 10,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
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

  Widget _buildGroupContainer(Color bgColor, Color borderColor, bool isDark, List<Widget> children) {
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
    required bool value,
    required Color textColor,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      child: Row(
        children: [
          _buildIconBadge(icon: icon, color: iconColor),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                fontFamily: 'Tajawal',
                color: textColor,
              ),
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
                isRtl ? Icons.chevron_left_rounded : Icons.chevron_right_rounded,
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


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile/core/theme/app_colors.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isDarkMode = false;
  bool _downloadWifiOnly = true;
  bool _pushNotifications = true;
  bool _promoNotifications = true;
  String _videoQuality = '1080p';
  String _language = 'العربية (Arabic)';

  void _clearCache() {
    HapticFeedback.mediumImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم تفريغ الملفات المؤقتة وذاكرة التخزين بنجاح (124 MB)'),
        backgroundColor: Color(0xFF059669),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('اختر لغة التطبيق', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Tajawal')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('العربية (Arabic)', style: TextStyle(fontFamily: 'Tajawal', fontWeight: FontWeight.bold)),
              value: 'العربية (Arabic)',
              groupValue: _language,
              onChanged: (val) {
                setState(() => _language = val!);
                Navigator.pop(ctx);
              },
            ),
            RadioListTile<String>(
              title: const Text('English (الإنجليزية)', style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold)),
              value: 'English (الإنجليزية)',
              groupValue: _language,
              onChanged: (val) {
                setState(() => _language = val!);
                Navigator.pop(ctx);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showQualityDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('جودة تحميل وتنزيل الفيديو', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Tajawal')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ['تلقائي (مستحسن)', '1080p (عالية الدقة)', '720p (متوسطة)', '480p (موفرة للبيانات)'].map((q) {
            return RadioListTile<String>(
              title: Text(q, style: const TextStyle(fontFamily: 'Tajawal', fontSize: 13)),
              value: q,
              groupValue: _videoQuality,
              onChanged: (val) {
                setState(() => _videoQuality = val!);
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
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_forward_rounded, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'تفضيلات وإعدادات التطبيق',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w900,
            color: AppColors.textPrimary,
            fontFamily: 'Tajawal',
          ),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
        children: [
          // 1. Video & Download Preferences
          _buildSectionHeader('الفيديو والتحميل'),
          _buildGroupContainer([
            _buildSettingTile(
              icon: Icons.high_quality_rounded,
              title: 'جودة تنزيل الفيديو الافتراضية',
              subtitle: _videoQuality,
              onTap: _showQualityDialog,
            ),
            _buildDivider(),
            SwitchListTile(
              secondary: const Icon(Icons.wifi_rounded, color: Color(0xFF475569), size: 22),
              title: const Text('التنزيل عبر Wi-Fi فقط', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, fontFamily: 'Tajawal')),
              subtitle: const Text('توفير باقة بيانات الجوال', style: TextStyle(fontSize: 11, color: AppColors.textSecondary, fontFamily: 'Tajawal')),
              value: _downloadWifiOnly,
              activeThumbColor: AppColors.primary,
              onChanged: (val) => setState(() => _downloadWifiOnly = val),
            ),
          ]),

          const SizedBox(height: 20),

          // 2. Notifications & Reminders
          _buildSectionHeader('الإشعارات والتذكيرات'),
          _buildGroupContainer([
            SwitchListTile(
              secondary: const Icon(Icons.notifications_active_outlined, color: Color(0xFF475569), size: 22),
              title: const Text('إشعارات تقدم الدورات والرسائل', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, fontFamily: 'Tajawal')),
              value: _pushNotifications,
              activeThumbColor: AppColors.primary,
              onChanged: (val) => setState(() => _pushNotifications = val),
            ),
            _buildDivider(),
            SwitchListTile(
              secondary: const Icon(Icons.local_offer_outlined, color: Color(0xFF475569), size: 22),
              title: const Text('العروض والخصومات الحصرية', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, fontFamily: 'Tajawal')),
              value: _promoNotifications,
              activeThumbColor: AppColors.primary,
              onChanged: (val) => setState(() => _promoNotifications = val),
            ),
          ]),

          const SizedBox(height: 20),

          // 3. Language & Appearance
          _buildSectionHeader('اللغة والمظهر'),
          _buildGroupContainer([
            _buildSettingTile(
              icon: Icons.language_rounded,
              title: 'لغة التطبيق (App Language)',
              subtitle: _language,
              onTap: _showLanguageDialog,
            ),
            _buildDivider(),
            SwitchListTile(
              secondary: const Icon(Icons.dark_mode_outlined, color: Color(0xFF475569), size: 22),
              title: const Text('الوضع الداكن (Dark Mode)', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, fontFamily: 'Tajawal')),
              value: _isDarkMode,
              activeThumbColor: AppColors.primary,
              onChanged: (val) => setState(() => _isDarkMode = val),
            ),
          ]),

          const SizedBox(height: 20),

          // 4. Storage & Cache
          _buildSectionHeader('التخزين والذاكرة المؤقتة'),
          _buildGroupContainer([
            _buildSettingTile(
              icon: Icons.cleaning_services_rounded,
              title: 'تفريغ الذاكرة المؤقتة (Clear Cache)',
              subtitle: '124 MB مستخدمة للملفات المؤقتة',
              onTap: _clearCache,
            ),
          ]),

          const SizedBox(height: 20),

          // 5. Help & Policies
          _buildSectionHeader('المعلومات والسياسات'),
          _buildGroupContainer([
            _buildSettingTile(
              icon: Icons.help_outline_rounded,
              title: 'مركز المساعدة والأسئلة الشائعة',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('تم فتح مركز المساعدة والدعم الفني'), behavior: SnackBarBehavior.floating),
                );
              },
            ),
            _buildDivider(),
            _buildSettingTile(
              icon: Icons.shield_outlined,
              title: 'شروط الاستخدام وسياسة الخصوصية',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('شروط وسياسات منصة EduLab التعليمية'), behavior: SnackBarBehavior.floating),
                );
              },
            ),
            _buildDivider(),
            _buildSettingTile(
              icon: Icons.info_outline_rounded,
              title: 'عن منصة EduLab التعليمية',
              subtitle: 'الإصدار v1.0.0 (Build 2026)',
              onTap: () {},
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(right: 4, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w800,
          color: Color(0xFF64748B),
          fontFamily: 'Tajawal',
        ),
      ),
    );
  }

  Widget _buildGroupContainer(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Icon(icon, size: 22, color: const Color(0xFF475569)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textPrimary, fontFamily: 'Tajawal'),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(fontSize: 11, color: AppColors.textSecondary, fontFamily: 'Tajawal'),
                    ),
                  ],
                ],
              ),
            ),
            const Icon(Icons.chevron_left_rounded, color: Color(0xFF94A3B8), size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(height: 1, indent: 48, color: Color(0xFFF1F5F9));
  }
}

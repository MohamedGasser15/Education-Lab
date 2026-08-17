import 'package:flutter/material.dart';
import 'package:mobile/core/theme/app_theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isDarkMode = false;
  bool pushNotifs = true;
  bool promoNotifs = true;
  bool downloadWifiOnly = true;
  String language = 'ar';
  String videoQuality = '1080p';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF0F172A) : AppColors.background,
      appBar: AppBar(
        title: const Text('الإعدادات'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_forward),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildSectionHeader('المظهر والألوان'),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  secondary: Icon(isDarkMode ? Icons.dark_mode : Icons.light_mode, color: Colors.amber),
                  title: const Text('الوضع الليلي (Dark Mode)'),
                  subtitle: Text(isDarkMode ? 'الوضع الداكن مفعل' : 'الوضع الفاتح مفعل'),
                  value: isDarkMode,
                  onChanged: (val) => setState(() => isDarkMode = val),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          _buildSectionHeader('اللغة'),
          Card(
            child: ListTile(
              leading: const Icon(Icons.language, color: Colors.blue),
              title: const Text('لغة التطبيق'),
              trailing: DropdownButton<String>(
                value: language,
                items: const [
                  DropdownMenuItem(value: 'ar', child: Text('العربية')),
                  DropdownMenuItem(value: 'en', child: Text('English')),
                ],
                onChanged: (val) => setState(() => language = val!),
              ),
            ),
          ),
          const SizedBox(height: 16),

          _buildSectionHeader('الإشعارات والتنبيهات'),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  secondary: const Icon(Icons.notifications_active_outlined, color: Colors.purple),
                  title: const Text('إشعارات الدروس والمتابعة'),
                  value: pushNotifs,
                  onChanged: (val) => setState(() => pushNotifs = val),
                ),
                const Divider(),
                SwitchListTile(
                  secondary: const Icon(Icons.local_offer_outlined, color: Colors.amber),
                  title: const Text('العروض والخصومات الحصرية'),
                  value: promoNotifs,
                  onChanged: (val) => setState(() => promoNotifs = val),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          _buildSectionHeader('الفيديو والتحميل'),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  secondary: const Icon(Icons.wifi, color: Colors.green),
                  title: const Text('التحميل عبر Wi-Fi فقط'),
                  value: downloadWifiOnly,
                  onChanged: (val) => setState(() => downloadWifiOnly = val),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Logout Button
          ElevatedButton.icon(
            onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
            icon: const Icon(Icons.logout, color: Colors.red),
            label: const Text('تسجيل الخروج', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.withValues(alpha: 0.08),
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, right: 4.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
      ),
    );
  }
}

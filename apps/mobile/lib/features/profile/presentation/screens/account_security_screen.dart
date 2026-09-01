import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile/core/theme/app_colors.dart';

class AccountSecurityScreen extends StatefulWidget {
  const AccountSecurityScreen({super.key});

  @override
  State<AccountSecurityScreen> createState() => _AccountSecurityScreenState();
}

class _AccountSecurityScreenState extends State<AccountSecurityScreen> {
  final _passwordFormKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;
  bool _isChangingPassword = false;

  // Two Factor Authentication (2FA)
  bool _is2FaEnabled = false;

  // Active Sessions (Matching MVC ActiveSessionDTO)
  final List<Map<String, dynamic>> _activeSessions = [
    {
      'id': 'sess_1',
      'device': 'iPhone 15 Pro (تطبيق الموبايل الحالي)',
      'ip': '197.38.120.45',
      'location': 'الرياض، السعودية',
      'lastActive': 'نشط الآن',
      'isCurrent': true,
      'icon': Icons.phone_iphone_rounded,
    },
    {
      'id': 'sess_2',
      'device': 'Google Chrome - macOS Sonoma',
      'ip': '197.38.120.45',
      'location': 'الرياض، السعودية',
      'lastActive': 'منذ ساعتين',
      'isCurrent': false,
      'icon': Icons.laptop_mac_rounded,
    },
    {
      'id': 'sess_3',
      'device': 'Safari - iPad Air',
      'ip': '82.178.44.12',
      'location': 'دبي، الإمارات',
      'lastActive': 'منذ 3 أيام',
      'isCurrent': false,
      'icon': Icons.tablet_mac_rounded,
    },
  ];

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _changePassword() async {
    if (!_passwordFormKey.currentState!.validate()) return;
    HapticFeedback.mediumImpact();
    setState(() => _isChangingPassword = true);

    await Future.delayed(const Duration(milliseconds: 1000));
    if (!mounted) return;
    setState(() => _isChangingPassword = false);

    _currentPasswordController.clear();
    _newPasswordController.clear();
    _confirmPasswordController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم تغيير كلمة المرور بنجاح'),
        backgroundColor: Color(0xFF059669),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _toggle2FA(bool value) {
    HapticFeedback.selectionClick();
    if (value) {
      // Show 2FA Setup Dialog (QR & Secret)
      _show2FaSetupDialog();
    } else {
      setState(() => _is2FaEnabled = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم تعطيل التحقق بخطوتين (2FA)'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _show2FaSetupDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.qr_code_2_rounded, color: AppColors.primary, size: 24),
            SizedBox(width: 8),
            Text(
              'تفعيل التحقق بخطوتين (2FA)',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, fontFamily: 'Tajawal'),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'امسح الرمز عبر تطبيق Google Authenticator أو أدخل المفتاح السري أدناه:',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary, fontFamily: 'Tajawal', height: 1.4),
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: const Icon(Icons.qr_code_rounded, size: 100, color: AppColors.primary),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF4FF),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'EDULAB-SEC-8924-X99Q',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'Inter', color: AppColors.primary),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('إلغاء', style: TextStyle(color: AppColors.textSecondary, fontFamily: 'Tajawal')),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              setState(() => _is2FaEnabled = true);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('تم تفعيل التحقق بخطوتين (2FA) لحسابك بنجاح'),
                  backgroundColor: Color(0xFF059669),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('تأكيد التفعيل', style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Tajawal')),
          ),
        ],
      ),
    );
  }

  void _revokeSession(String id) {
    HapticFeedback.lightImpact();
    setState(() {
      _activeSessions.removeWhere((s) => s['id'] == id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم إنهاء الجلسة وتسجيل الخروج من الجهاز المحدد'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _revokeAllOtherSessions() {
    HapticFeedback.mediumImpact();
    setState(() {
      _activeSessions.removeWhere((s) => s['isCurrent'] == false);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم إنهاء جميع الجلسات وتسجيل الخروج من كل الأجهزة الأخرى بنجاح'),
        backgroundColor: Color(0xFF059669),
        behavior: SnackBarBehavior.floating,
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
          'أمان الحساب والجلسات',
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
          // 1. Change Password Section (ChangePasswordDTO)
          _buildSectionHeader('تغيير كلمة المرور'),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Form(
              key: _passwordFormKey,
              child: Column(
                children: [
                  _buildPasswordField(
                    controller: _currentPasswordController,
                    label: 'كلمة المرور الحالية *',
                    obscure: _obscureCurrent,
                    onToggle: () => setState(() => _obscureCurrent = !_obscureCurrent),
                    validator: (v) => (v == null || v.length < 6) ? 'أدخل كلمة المرور الحالية' : null,
                  ),
                  const SizedBox(height: 12),
                  _buildPasswordField(
                    controller: _newPasswordController,
                    label: 'كلمة المرور الجديدة *',
                    obscure: _obscureNew,
                    onToggle: () => setState(() => _obscureNew = !_obscureNew),
                    validator: (v) => (v == null || v.length < 8) ? 'يجب ألا تقل عن 8 أحرف وأرقام' : null,
                  ),
                  const SizedBox(height: 12),
                  _buildPasswordField(
                    controller: _confirmPasswordController,
                    label: 'تأكيد كلمة المرور الجديدة *',
                    obscure: _obscureConfirm,
                    onToggle: () => setState(() => _obscureConfirm = !_obscureConfirm),
                    validator: (v) => (v != _newPasswordController.text) ? 'كلمة المرور غير متطابقة' : null,
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isChangingPassword ? null : _changePassword,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        elevation: 0,
                      ),
                      child: _isChangingPassword
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                            )
                          : const Text(
                              'تحديث كلمة المرور',
                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, fontFamily: 'Tajawal'),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // 2. Two-Factor Authentication (2FA) (TwoFactorDTO)
          _buildSectionHeader('التحقق بخطوتين (2FA)'),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: _is2FaEnabled ? const Color(0xFFECFDF5) : const Color(0xFFF1F5F9),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.shield_rounded,
                    color: _is2FaEnabled ? const Color(0xFF059669) : AppColors.textSecondary,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'المصادقة الثنائية (2FA)',
                        style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                          fontFamily: 'Tajawal',
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _is2FaEnabled ? 'مفعلة وتؤمن حسابك برمز إضافي' : 'غير مفعلة (يُنصح بتفعيلها)',
                        style: TextStyle(
                          fontSize: 11,
                          color: _is2FaEnabled ? const Color(0xFF059669) : AppColors.textSecondary,
                          fontFamily: 'Tajawal',
                        ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: _is2FaEnabled,
                  activeThumbColor: AppColors.primary,
                  onChanged: _toggle2FA,
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // 3. Active Sessions & Logged-in Devices (ActiveSessionsDTO)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSectionHeader('الأجهزة والجلسات المسجلة'),
              if (_activeSessions.length > 1)
                GestureDetector(
                  onTap: _revokeAllOtherSessions,
                  child: const Text(
                    'تسجيل الخروج من الكل',
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.bold,
                      color: Colors.redAccent,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                ),
            ],
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                for (int i = 0; i < _activeSessions.length; i++) ...[
                  if (i > 0) const Divider(height: 1, color: Color(0xFFF1F5F9)),
                  _buildSessionItem(_activeSessions[i]),
                ],
              ],
            ),
          ),
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

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool obscure,
    required VoidCallback onToggle,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: AppColors.textPrimary, fontFamily: 'Tajawal'),
        ),
        const SizedBox(height: 4),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.border),
          ),
          child: TextFormField(
            controller: controller,
            obscureText: obscure,
            validator: validator,
            style: const TextStyle(fontSize: 12.5, fontFamily: 'Tajawal'),
            decoration: InputDecoration(
              hintText: '••••••••',
              prefixIcon: const Icon(Icons.lock_outline_rounded, size: 18, color: AppColors.textSecondary),
              suffixIcon: IconButton(
                icon: Icon(obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined, size: 18, color: AppColors.textSecondary),
                onPressed: onToggle,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSessionItem(Map<String, dynamic> session) {
    final isCurrent = session['isCurrent'] == true;

    return Padding(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isCurrent ? const Color(0xFFEFF4FF) : const Color(0xFFF8FAFC),
              shape: BoxShape.circle,
            ),
            child: Icon(session['icon'] as IconData, color: isCurrent ? AppColors.primary : AppColors.textSecondary, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        session['device'] as String,
                        style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: AppColors.textPrimary, fontFamily: 'Tajawal'),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (isCurrent)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFECFDF5),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text('الجهاز الحالي', style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.bold, color: Color(0xFF059669), fontFamily: 'Tajawal')),
                      ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  '${session['location']} • ${session['ip']} • ${session['lastActive']}',
                  style: const TextStyle(fontSize: 10.5, color: AppColors.textSecondary, fontFamily: 'Tajawal'),
                ),
              ],
            ),
          ),
          if (!isCurrent)
            IconButton(
              tooltip: 'إنهاء الجلسة',
              icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent, size: 20),
              onPressed: () => _revokeSession(session['id'] as String),
            ),
        ],
      ),
    );
  }
}

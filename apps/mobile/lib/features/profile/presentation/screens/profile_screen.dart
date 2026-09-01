import 'package:flutter/material.dart';
import 'package:mobile/core/services/auth_storage_service.dart';
import 'package:mobile/core/theme/app_colors.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isLoggedIn = false;
  String _userName = '';
  String _userEmail = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final loggedIn = await AuthStorageService.isLoggedIn();
    final user = await AuthStorageService.getUser();
    if (!mounted) return;
    setState(() {
      _isLoggedIn = loggedIn;
      _userName = user?['fullName']?.toString() ?? (loggedIn ? 'محمد ناصر' : '');
      _userEmail = user?['email']?.toString() ?? (loggedIn ? 'mohamed.nasser@example.com' : '');
    });
  }

  Future<void> _handleLogout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.logout_rounded, color: Colors.redAccent, size: 22),
            SizedBox(width: 8),
            Text(
              'تسجيل الخروج',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'Tajawal',
              ),
            ),
          ],
        ),
        content: const Text(
          'هل أنت متأكد من رغبتك في تسجيل الخروج من حسابك؟',
          style: TextStyle(
            fontSize: 13,
            color: AppColors.textSecondary,
            fontFamily: 'Tajawal',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text(
              'إلغاء',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.bold,
                fontFamily: 'Tajawal',
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              elevation: 0,
            ),
            child: const Text(
              'تسجيل الخروج',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'Tajawal',
              ),
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await AuthStorageService.logout();
      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        automaticallyImplyLeading: false,
        title: const Text(
          'الحساب',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w900,
            color: AppColors.textPrimary,
            fontFamily: 'Tajawal',
          ),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
        children: [
          // 1. User Profile Header Card (Udemy Style)
          _buildUserProfileHeader(),

          const SizedBox(height: 20),

          // 2. Account Settings Group (FIRST PRIORITY AS REQUESTED)
          _buildSectionHeader('إعدادات الحساب والملف الشخصي'),
          _buildGroupContainer([
            _buildMenuItem(
              icon: Icons.person_outline_rounded,
              title: 'تعديل الملف الشخصي والبيانات',
              subtitle: 'الاسم، النبذة التعريفية، الروابط المهنية',
              onTap: () => Navigator.pushNamed(context, '/edit-profile'),
            ),
            _buildDivider(),
            _buildMenuItem(
              icon: Icons.security_rounded,
              title: 'أمان الحساب وكلمة المرور',
              subtitle: 'تغيير كلمة السر، التحقق بخطوتين 2FA، الجلسات النشطة',
              onTap: () => Navigator.pushNamed(context, '/account-security'),
            ),
            _buildDivider(),
            _buildMenuItem(
              icon: Icons.receipt_long_rounded,
              title: 'سجل المشتريات والفواتير',
              subtitle: 'فواتير الدورات، إيصالات الدفع، طلبات الاسترجاع',
              onTap: () => Navigator.pushNamed(context, '/purchase-history'),
            ),
          ]),

          const SizedBox(height: 20),

          // 3. Learning & Achievements Group
          _buildSectionHeader('التعلم والشهادات'),
          _buildGroupContainer([
            _buildMenuItem(
              icon: Icons.workspace_premium_outlined,
              title: 'شهادات الإتمام المعتمدة',
              subtitle: 'عرض وتحميل ومشاركة شهادات الدورات المكتملة',
              onTap: () => Navigator.pushNamed(context, '/certificate_view'),
            ),
          ]),

          const SizedBox(height: 20),

          // 4. Teaching on EduLab (MVC Instructor Application)
          _buildSectionHeader('التدريس والمدربين'),
          _buildGroupContainer([
            _buildMenuItem(
              icon: Icons.school_outlined,
              title: 'التدريس على منصة EduLab',
              subtitle: 'انضم كمدرب معتمد وانشر دوراتك لآلاف الطلاب',
              onTap: () => Navigator.pushNamed(context, '/teach-apply'),
            ),
          ]),

          const SizedBox(height: 20),

          // 5. App Preferences & Video Settings
          _buildSectionHeader('تفضيلات التطبيق'),
          _buildGroupContainer([
            _buildMenuItem(
              icon: Icons.tune_rounded,
              title: 'تفضيلات التطبيق والفيديو والتحميل',
              subtitle: 'جودة الفيديو، الوضع الداكن، التنزيل عبر Wi-Fi',
              onTap: () => Navigator.pushNamed(context, '/settings'),
            ),
            _buildDivider(),
            _buildMenuItem(
              icon: Icons.notifications_none_rounded,
              title: 'تفضيلات الإشعارات والتنبيهات',
              subtitle: 'تحديثات الدورات، العروض الحصرية، الرسائل',
              onTap: () => Navigator.pushNamed(context, '/notifications'),
            ),
          ]),

          const SizedBox(height: 20),

          // 6. Help & Support Group
          _buildSectionHeader('المساعدة والدعم'),
          _buildGroupContainer([
            _buildMenuItem(
              icon: Icons.help_outline_rounded,
              title: 'مركز المساعدة والأسئلة الشائعة',
              onTap: () => _showFeatureDialog('مركز المساعدة والأسئلة الشائعة'),
            ),
            _buildDivider(),
            _buildMenuItem(
              icon: Icons.shield_outlined,
              title: 'شروط الخدمة وسياسة الخصوصية',
              onTap: () => _showFeatureDialog('شروط الخدمة وسياسة الخصوصية'),
            ),
            _buildDivider(),
            _buildMenuItem(
              icon: Icons.info_outline_rounded,
              title: 'عن منصة EduLab التعليمية',
              trailingText: 'v1.0.0 (Build 2026)',
              onTap: () => _showFeatureDialog('عن تطبيق EduLab'),
            ),
          ]),

          const SizedBox(height: 24),

          // 7. Sign Out Button (If Logged In)
          if (_isLoggedIn)
            _buildLogoutButton()
          else
            _buildLoginPromptButton(),
        ],
      ),
    );
  }

  // ================= 1. USER PROFILE HEADER =================
  Widget _buildUserProfileHeader() {
    if (!_isLoggedIn) {
      return Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: const BoxDecoration(
                color: Color(0xFFEFF4FF),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.person_outline_rounded,
                color: AppColors.primary,
                size: 28,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'مرحباً بك في EduLab',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'سجل الدخول لحفظ دوراتك وشهاداتك',
                    style: TextStyle(
                      fontSize: 11.5,
                      color: AppColors.textSecondary,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/login'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                elevation: 0,
              ),
              child: const Text(
                'تسجيل الدخول',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'Tajawal'),
              ),
            ),
          ],
        ),
      );
    }

    final initial = _userName.isNotEmpty ? _userName.substring(0, 1) : 'م';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1D61E7), Color(0xFF2563EB)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.25),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Center(
              child: Text(
                initial,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'Tajawal',
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),

          // User Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _userName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                    fontFamily: 'Tajawal',
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _userEmail,
                  style: const TextStyle(
                    fontSize: 11.5,
                    color: AppColors.textSecondary,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF4FF),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'طالب معتمد في EduLab',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Edit Profile Action
          IconButton(
            tooltip: 'تعديل الملف الشخصي',
            onPressed: () => Navigator.pushNamed(context, '/edit-profile'),
            icon: const Icon(
              Icons.edit_outlined,
              color: AppColors.primary,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  // Section Header
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

  // Group Box Container (Udemy Card Style)
  Widget _buildGroupContainer(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: children,
      ),
    );
  }

  // Menu List Item
  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    String? subtitle,
    String? trailingText,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Icon(
              icon,
              size: 21,
              color: const Color(0xFF475569),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 10.5,
                        color: AppColors.textSecondary,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (trailingText != null) ...[
              Text(
                trailingText,
                style: const TextStyle(
                  fontSize: 11.5,
                  color: AppColors.textSecondary,
                  fontFamily: 'Inter',
                ),
              ),
              const SizedBox(width: 6),
            ],
            const Icon(
              Icons.chevron_left_rounded,
              color: Color(0xFF94A3B8),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(
      height: 1,
      thickness: 1,
      indent: 48,
      color: Color(0xFFF1F5F9),
    );
  }

  // Logout Button
  Widget _buildLogoutButton() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFFEE2E2)),
      ),
      child: InkWell(
        onTap: _handleLogout,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 13),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(
                Icons.logout_rounded,
                color: Colors.redAccent,
                size: 20,
              ),
              SizedBox(width: 8),
              Text(
                'تسجيل الخروج',
                style: TextStyle(
                  color: Colors.redAccent,
                  fontSize: 13.5,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Tajawal',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoginPromptButton() {
    return ElevatedButton(
      onPressed: () => Navigator.pushNamed(context, '/login'),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(vertical: 13),
        elevation: 0,
      ),
      child: const Text(
        'تسجيل الدخول / إنشاء حساب',
        style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, fontFamily: 'Tajawal'),
      ),
    );
  }

  void _showFeatureDialog(String featureTitle) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          featureTitle,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            fontFamily: 'Tajawal',
          ),
        ),
        content: const Text(
          'هذه الميزة مفعلة وتعمل بكفاءة ضمن منظومة التعليم المعتمدة في منصة EduLab.',
          style: TextStyle(
            fontSize: 12.5,
            color: AppColors.textSecondary,
            fontFamily: 'Tajawal',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'حسناً',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontFamily: 'Tajawal',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile/core/services/auth_storage_service.dart';
import 'package:mobile/core/theme/app_colors.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _fullNameController;
  late TextEditingController _headlineController;
  late TextEditingController _bioController;
  late TextEditingController _locationController;
  late TextEditingController _phoneController;
  late TextEditingController _websiteController;
  late TextEditingController _linkedInController;
  late TextEditingController _githubController;
  late TextEditingController _twitterController;

  bool _isLoading = false;
  String _avatarInitial = 'م';
  String _userEmail = 'mohamed.nasser@example.com';

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController(text: 'محمد ناصر');
    _headlineController = TextEditingController(text: 'مهندس برمجيات ومطور تطبيقات فلاتر');
    _bioController = TextEditingController(
      text: 'شغوف بتعلم أحدث تقنيات تطوير التطبيقات والذكاء الاصطناعي وبناء تجارب مستخدم استثنائية.',
    );
    _locationController = TextEditingController(text: 'الرياض، المملكة العربية السعودية');
    _phoneController = TextEditingController(text: '+966 50 123 4567');
    _websiteController = TextEditingController(text: 'https://mohamednasser.dev');
    _linkedInController = TextEditingController(text: 'https://linkedin.com/in/mohamednasser');
    _githubController = TextEditingController(text: 'https://github.com/mohamednasser');
    _twitterController = TextEditingController(text: 'https://x.com/mohamednasser');

    _bioController.addListener(() => setState(() {}));
    _loadUser();
  }

  Future<void> _loadUser() async {
    final user = await AuthStorageService.getUser();
    if (user != null && mounted) {
      setState(() {
        if (user['fullName'] != null && user['fullName'].toString().isNotEmpty) {
          _fullNameController.text = user['fullName'].toString();
          _avatarInitial = user['fullName'].toString().substring(0, 1);
        }
        if (user['email'] != null) {
          _userEmail = user['email'].toString();
        }
      });
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _headlineController.dispose();
    _bioController.dispose();
    _locationController.dispose();
    _phoneController.dispose();
    _websiteController.dispose();
    _linkedInController.dispose();
    _githubController.dispose();
    _twitterController.dispose();
    super.dispose();
  }

  void _showImagePickerSheet() {
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFE2E8F0),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'تغيير الصورة الشخصية',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Tajawal',
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              ListTile(
                leading: const Icon(Icons.camera_alt_outlined, color: AppColors.primary),
                title: const Text('التقاط صورة بالكاميرا', style: TextStyle(fontFamily: 'Tajawal', fontWeight: FontWeight.w600)),
                onTap: () {
                  Navigator.pop(ctx);
                  _onPhotoSelected('تم تشغيل الكاميرا بنجاح');
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined, color: Color(0xFF10B981)),
                title: const Text('اختيار من معرض الصور', style: TextStyle(fontFamily: 'Tajawal', fontWeight: FontWeight.w600)),
                onTap: () {
                  Navigator.pop(ctx);
                  _onPhotoSelected('تم اختيار الصورة من المعرض');
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
                title: const Text('إزالة الصورة الحالية', style: TextStyle(fontFamily: 'Tajawal', color: Colors.redAccent, fontWeight: FontWeight.w600)),
                onTap: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('تمت إزالة الصورة واستعادة الرمز الافتراضي'), behavior: SnackBarBehavior.floating),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onPhotoSelected(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: const Color(0xFF059669),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;
    HapticFeedback.mediumImpact();
    setState(() => _isLoading = true);

    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    setState(() => _isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم حفظ وتحديث بياناتك بنجاح'),
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
          'تعديل الملف الشخصي',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w900,
            color: AppColors.textPrimary,
            fontFamily: 'Tajawal',
          ),
        ),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _saveProfile,
            child: _isLoading
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
                  )
                : const Text(
                    'حفظ',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                      color: AppColors.primary,
                      fontFamily: 'Tajawal',
                    ),
                  ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
          children: [
            // 1. Sleek Avatar Hero Section
            _buildAvatarHero(),

            const SizedBox(height: 20),

            // 2. Personal Information Card
            _buildSectionHeader('البيانات الأساسية'),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  _buildInputField(
                    controller: _fullNameController,
                    label: 'الاسم الكامل *',
                    hint: 'أدخل اسمك الثلاثي',
                    icon: Icons.person_rounded,
                    validator: (v) =>
                        (v == null || v.trim().length < 3) ? 'يرجى إدخال الاسم كاملاً' : null,
                  ),
                  const SizedBox(height: 14),
                  _buildInputField(
                    controller: _headlineController,
                    label: 'المسمى المهني / التخصص',
                    hint: 'مثال: مطور تطبيقات فلاتر',
                    icon: Icons.badge_outlined,
                  ),
                  const SizedBox(height: 14),
                  _buildInputField(
                    controller: _locationController,
                    label: 'المدينة / الدولة',
                    hint: 'الرياض، المملكة العربية السعودية',
                    icon: Icons.location_on_rounded,
                  ),
                  const SizedBox(height: 14),
                  _buildInputField(
                    controller: _phoneController,
                    label: 'رقم الهاتف الجوال',
                    hint: '+966 50 123 4567',
                    icon: Icons.phone_rounded,
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 14),

                  // Bio / About You with live counter
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'نبذة عني (Bio)',
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                              fontFamily: 'Tajawal',
                            ),
                          ),
                          Text(
                            '${_bioController.text.length} / 500',
                            style: const TextStyle(
                              fontSize: 10.5,
                              color: AppColors.textSecondary,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: TextFormField(
                          controller: _bioController,
                          maxLines: 3,
                          maxLength: 500,
                          style: const TextStyle(fontSize: 12.5, fontFamily: 'Tajawal'),
                          decoration: const InputDecoration(
                            hintText: 'اكتب نبذة مختصرة عن اهتماماتك وخبراتك...',
                            hintStyle: TextStyle(fontSize: 11.5, color: AppColors.textMuted, fontFamily: 'Tajawal'),
                            prefixIcon: Icon(Icons.edit_note_rounded, size: 20, color: AppColors.textSecondary),
                            border: InputBorder.none,
                            counterText: '',
                            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 3. Social & Professional Links Card
            _buildSectionHeader('الروابط والشبكات المهنية'),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  _buildInputField(
                    controller: _websiteController,
                    label: 'الموقع الشخصي',
                    hint: 'https://yourwebsite.com',
                    icon: Icons.language_rounded,
                    isLtr: true,
                  ),
                  const SizedBox(height: 12),
                  _buildInputField(
                    controller: _linkedInController,
                    label: 'LinkedIn',
                    hint: 'https://linkedin.com/in/username',
                    icon: Icons.business_center_outlined,
                    isLtr: true,
                  ),
                  const SizedBox(height: 12),
                  _buildInputField(
                    controller: _githubController,
                    label: 'GitHub',
                    hint: 'https://github.com/username',
                    icon: Icons.code_rounded,
                    isLtr: true,
                  ),
                  const SizedBox(height: 12),
                  _buildInputField(
                    controller: _twitterController,
                    label: 'X (Twitter)',
                    hint: 'https://x.com/username',
                    icon: Icons.chat_bubble_outline_rounded,
                    isLtr: true,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 4. Verified Email Card
            _buildSectionHeader('البريد الإلكتروني المسجل'),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: const BoxDecoration(
                      color: Color(0xFFEFF4FF),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.email_outlined, color: AppColors.primary, size: 18),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _userEmail,
                          style: const TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                            fontFamily: 'Inter',
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'مرتبط بحسابك لتسجيل الدخول واستلام الشهادات',
                          style: TextStyle(fontSize: 10, color: AppColors.textSecondary, fontFamily: 'Tajawal'),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFECFDF5),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check_circle_rounded, size: 13, color: Color(0xFF059669)),
                        SizedBox(width: 4),
                        Text(
                          'موثق',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF059669),
                            fontFamily: 'Tajawal',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 5. Big Save Changes Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  elevation: 0,
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.check_circle_outline_rounded, size: 18),
                          SizedBox(width: 8),
                          Text(
                            'حفظ وتحديث البيانات',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Tajawal',
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= AVATAR HERO =================
  Widget _buildAvatarHero() {
    return Center(
      child: Column(
        children: [
          GestureDetector(
            onTap: _showImagePickerSheet,
            child: Stack(
              children: [
                Container(
                  width: 96,
                  height: 96,
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
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      _avatarInitial,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2.5),
                    ),
                    child: const Icon(
                      Icons.camera_alt_rounded,
                      color: Colors.white,
                      size: 15,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: _showImagePickerSheet,
            child: const Text(
              'تغيير الصورة الشخصية',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
                fontFamily: 'Tajawal',
              ),
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

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool isLtr = false,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
            fontFamily: 'Tajawal',
          ),
        ),
        const SizedBox(height: 5),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            validator: validator,
            textDirection: isLtr ? TextDirection.ltr : TextDirection.rtl,
            style: TextStyle(fontSize: 12.5, fontFamily: isLtr ? 'Inter' : 'Tajawal'),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(fontSize: 11.5, color: AppColors.textMuted, fontFamily: 'Tajawal'),
              prefixIcon: Icon(icon, size: 18, color: AppColors.textSecondary),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
            ),
          ),
        ),
      ],
    );
  }
}

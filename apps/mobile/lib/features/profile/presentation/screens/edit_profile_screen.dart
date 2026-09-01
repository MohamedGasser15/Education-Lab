import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile/core/extensions/localization_ext.dart';
import 'package:mobile/core/services/auth_storage_service.dart';
import 'package:mobile/core/theme/app_colors.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for MVC User Profile DTO
  late TextEditingController _fullNameController;
  late TextEditingController _headlineController;
  late TextEditingController _bioController;
  late TextEditingController _websiteController;
  late TextEditingController _linkedInController;
  late TextEditingController _githubController;
  late TextEditingController _twitterController;
  late TextEditingController _phoneController;
  late TextEditingController _locationController;

  bool _isLoading = false;
  String _userEmail = '';
  String _avatarInitial = 'م';

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController(text: 'محمد النجار');
    _headlineController = TextEditingController(text: 'Senior Flutter & Mobile Architect');
    _bioController = TextEditingController(
      text: 'مطور تطبيقات هواتف ذكية شغوف بالمعماريات النظيفة وبناء حلول رقمية عالية الأداء.',
    );
    _websiteController = TextEditingController(text: 'https://mohamedelnaggar.dev');
    _linkedInController = TextEditingController(text: 'https://linkedin.com/in/mohamedelnaggar');
    _githubController = TextEditingController(text: 'https://github.com/mohamedelnaggar');
    _twitterController = TextEditingController(text: 'https://x.com/mohamedelnaggar');
    _phoneController = TextEditingController(text: '+966 50 123 4567');
    _locationController = TextEditingController(text: 'الرياض، المملكة العربية السعودية');

    _loadStoredUserData();
  }

  Future<void> _loadStoredUserData() async {
    final name = await AuthStorageService.getUserName();
    final email = await AuthStorageService.getUserEmail();

    if (!mounted) return;
    setState(() {
      if (name.isNotEmpty) {
        _fullNameController.text = name;
        _avatarInitial = name.substring(0, 1);
      }
      _userEmail = email.isNotEmpty ? email : 'mohamed.elnaggar@edulab.edu';
    });
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _headlineController.dispose();
    _bioController.dispose();
    _websiteController.dispose();
    _linkedInController.dispose();
    _githubController.dispose();
    _twitterController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    HapticFeedback.mediumImpact();
    setState(() => _isLoading = true);

    await Future.delayed(const Duration(milliseconds: 900));

    if (!mounted) return;
    setState(() => _isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(context.loc.editProfileSavedSuccess),
        backgroundColor: Color(0xFF059669),
        behavior: SnackBarBehavior.floating,
      ),
    );

    Navigator.pop(context);
  }

  void _showImagePickerSheet(Color cardBg, Color textColor, Color borderColor) {
    showModalBottomSheet(
      context: context,
      backgroundColor: cardBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                context.loc.editProfileChangeAvatarTitle,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: textColor,
                  fontFamily: 'Tajawal',
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.camera_alt_rounded, color: AppColors.primary),
                title: Text(context.loc.editProfileTakePhoto, style: TextStyle(fontFamily: 'Tajawal', fontWeight: FontWeight.bold, color: textColor)),
                onTap: () {
                  Navigator.pop(ctx);
                  _onPhotoSelected();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_rounded, color: AppColors.primary),
                title: Text(context.loc.editProfileChooseGallery, style: TextStyle(fontFamily: 'Tajawal', fontWeight: FontWeight.bold, color: textColor)),
                onTap: () {
                  Navigator.pop(ctx);
                  _onPhotoSelected();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onPhotoSelected() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(context.loc.editProfilePhotoUpdatedSuccess),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.darkBackground : const Color(0xFFF8FAFC);
    final cardBg = isDark ? AppColors.darkSurface : Colors.white;
    final inputFill = isDark ? AppColors.darkSurfaceMuted : const Color(0xFFF8FAFC);
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;
    final textColor = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final textSubColor = isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: cardBg,
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
          context.loc.editProfileTitle,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w900,
            color: textColor,
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
                : Text(
                    context.loc.editProfileSave,
                    style: const TextStyle(
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
            _buildAvatarHero(cardBg, textColor, borderColor),

            const SizedBox(height: 20),

            // 2. Personal Information Card
            _buildSectionHeader(context.loc.editProfileSectionBasicInfo),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: borderColor),
              ),
              child: Column(
                children: [
                  _buildInputField(
                    controller: _fullNameController,
                    label: context.loc.editProfileFullNameLabel,
                    hint: context.loc.editProfileFullNameHint,
                    icon: Icons.person_rounded,
                    inputFill: inputFill,
                    borderColor: borderColor,
                    textColor: textColor,
                    validator: (v) =>
                        (v == null || v.trim().length < 3) ? context.loc.editProfileFullNameError : null,
                  ),
                  const SizedBox(height: 14),
                  _buildInputField(
                    controller: _headlineController,
                    label: context.loc.editProfileHeadlineLabel,
                    hint: context.loc.editProfileHeadlineHint,
                    icon: Icons.badge_outlined,
                    inputFill: inputFill,
                    borderColor: borderColor,
                    textColor: textColor,
                  ),
                  const SizedBox(height: 14),
                  _buildInputField(
                    controller: _locationController,
                    label: context.loc.editProfileLocationLabel,
                    hint: context.loc.editProfileLocationHint,
                    icon: Icons.location_on_rounded,
                    inputFill: inputFill,
                    borderColor: borderColor,
                    textColor: textColor,
                  ),
                  const SizedBox(height: 14),
                  _buildInputField(
                    controller: _phoneController,
                    label: context.loc.editProfilePhoneLabel,
                    hint: '+966 50 123 4567',
                    icon: Icons.phone_rounded,
                    keyboardType: TextInputType.phone,
                    isLtr: true,
                    inputFill: inputFill,
                    borderColor: borderColor,
                    textColor: textColor,
                  ),
                  const SizedBox(height: 14),

                  // Bio / About You with live counter
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            context.loc.editProfileBioLabel,
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                              fontFamily: 'Tajawal',
                            ),
                          ),
                          Text(
                            '${_bioController.text.length} / 500',
                            style: TextStyle(
                              fontSize: 10.5,
                              color: textSubColor,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Container(
                        decoration: BoxDecoration(
                          color: inputFill,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: borderColor),
                        ),
                        child: TextFormField(
                          controller: _bioController,
                          maxLines: 3,
                          maxLength: 500,
                          style: TextStyle(fontSize: 12.5, fontFamily: 'Tajawal', color: textColor),
                          decoration: InputDecoration(
                            hintText: context.loc.editProfileBioHint,
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
            _buildSectionHeader(context.loc.editProfileSectionLinks),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: borderColor),
              ),
              child: Column(
                children: [
                  _buildInputField(
                    controller: _websiteController,
                    label: context.loc.editProfileWebsiteLabel,
                    hint: 'https://yourwebsite.com',
                    icon: Icons.language_rounded,
                    isLtr: true,
                    inputFill: inputFill,
                    borderColor: borderColor,
                    textColor: textColor,
                  ),
                  const SizedBox(height: 12),
                  _buildInputField(
                    controller: _linkedInController,
                    label: 'LinkedIn',
                    hint: 'https://linkedin.com/in/username',
                    icon: Icons.business_center_outlined,
                    isLtr: true,
                    inputFill: inputFill,
                    borderColor: borderColor,
                    textColor: textColor,
                  ),
                  const SizedBox(height: 12),
                  _buildInputField(
                    controller: _githubController,
                    label: 'GitHub',
                    hint: 'https://github.com/username',
                    icon: Icons.code_rounded,
                    isLtr: true,
                    inputFill: inputFill,
                    borderColor: borderColor,
                    textColor: textColor,
                  ),
                  const SizedBox(height: 12),
                  _buildInputField(
                    controller: _twitterController,
                    label: 'X (Twitter)',
                    hint: 'https://x.com/username',
                    icon: Icons.chat_bubble_outline_rounded,
                    isLtr: true,
                    inputFill: inputFill,
                    borderColor: borderColor,
                    textColor: textColor,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 4. Verified Email Card
            _buildSectionHeader(context.loc.editProfileSectionEmail),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: borderColor),
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
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                            fontFamily: 'Inter',
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          context.loc.editProfileEmailDesc,
                          style: TextStyle(fontSize: 10, color: textSubColor, fontFamily: 'Tajawal'),
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
                        children: [
                          const Icon(Icons.check_circle_outline_rounded, size: 18),
                          const SizedBox(width: 8),
                          Text(
                            context.loc.editProfileSaveChangesBtn,
                            style: const TextStyle(
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
  Widget _buildAvatarHero(Color cardBg, Color textColor, Color borderColor) {
    return Center(
      child: Column(
        children: [
          GestureDetector(
            onTap: () => _showImagePickerSheet(cardBg, textColor, borderColor),
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
            onTap: () => _showImagePickerSheet(cardBg, textColor, borderColor),
            child: Text(
              context.loc.editProfileChangeAvatarTitle,
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
    required Color inputFill,
    required Color borderColor,
    required Color textColor,
    TextInputType keyboardType = TextInputType.text,
    bool isLtr = false,
    String? Function(String?)? validator,
  }) {
    final isAppRtl = Directionality.of(context) == TextDirection.rtl;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.bold,
            color: textColor,
            fontFamily: 'Tajawal',
          ),
        ),
        const SizedBox(height: 5),
        Container(
          decoration: BoxDecoration(
            color: inputFill,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor),
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            validator: validator,
            textDirection: isLtr ? TextDirection.ltr : (isAppRtl ? TextDirection.rtl : TextDirection.ltr),
            textAlign: isLtr ? (isAppRtl ? TextAlign.left : TextAlign.start) : TextAlign.start,
            style: TextStyle(
              fontSize: 12.5,
              fontFamily: isLtr ? 'Inter' : 'Tajawal',
              color: textColor,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                fontSize: 11.5,
                color: AppColors.textMuted,
                fontFamily: isLtr ? 'Inter' : 'Tajawal',
              ),
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

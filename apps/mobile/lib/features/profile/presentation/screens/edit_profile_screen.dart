import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile/core/extensions/localization_ext.dart';
import 'package:mobile/core/services/api_client.dart';
import 'package:mobile/core/services/auth_storage_service.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/core/utils/app_snackbar.dart';
import 'package:mobile/core/widgets/app_button.dart';
import 'package:mobile/features/profile/data/models/user_profile_model.dart';
import 'package:mobile/features/profile/presentation/providers/profile_provider.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  // Controllers for MVC User Profile DTO (matches ASP.NET Core ProfileDTO)
  late TextEditingController _fullNameController;
  late TextEditingController _headlineController;
  late TextEditingController _bioController;
  late TextEditingController _githubController;
  late TextEditingController _linkedInController;
  late TextEditingController _twitterController;
  late TextEditingController _facebookController;
  late TextEditingController _phoneController;
  late TextEditingController _locationController;

  bool _isLoading = false;
  bool _isUploadingAvatar = false;
  String _userEmail = '';
  String? _avatarUrl;

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController();
    _headlineController = TextEditingController();
    _bioController = TextEditingController();
    _githubController = TextEditingController();
    _linkedInController = TextEditingController();
    _twitterController = TextEditingController();
    _facebookController = TextEditingController();
    _phoneController = TextEditingController();
    _locationController = TextEditingController();

    _loadStoredUserData();
  }

  Future<void> _loadStoredUserData() async {
    final profile = context.read<ProfileProvider>().profile;

    if (profile != null) {
      if (!mounted) return;
      setState(() {
        _fullNameController.text = profile.fullName;
        _headlineController.text = profile.title ?? '';
        _bioController.text = profile.about ?? '';
        _githubController.text = profile.socialLinks.gitHub ?? '';
        _linkedInController.text = profile.socialLinks.linkedIn ?? '';
        _twitterController.text = profile.socialLinks.twitter ?? '';
        _facebookController.text = profile.socialLinks.facebook ?? '';
        _phoneController.text = profile.phoneNumber ?? '';
        _locationController.text = profile.location ?? '';
        _userEmail = profile.email;
        _avatarUrl = profile.profileImageUrl;
      });
    } else {
      final name = await AuthStorageService.getUserName();
      final email = await AuthStorageService.getUserEmail();

      if (!mounted) return;
      setState(() {
        if (name.isNotEmpty) {
          _fullNameController.text = name;
        }
        _userEmail = email.isNotEmpty ? email : '';
      });
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _headlineController.dispose();
    _bioController.dispose();
    _githubController.dispose();
    _linkedInController.dispose();
    _twitterController.dispose();
    _facebookController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  // ================= SAVE PROFILE VIA API =================
  void _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<ProfileProvider>();
    final successMsg = context.loc.editProfileSavedSuccess;
    final currentProfile = provider.profile;

    HapticFeedback.mediumImpact();
    setState(() => _isLoading = true);

    final userId = currentProfile?.id.isNotEmpty == true
        ? currentProfile!.id
        : await AuthStorageService.getUserId() ?? '';

    final updatedProfile = (currentProfile ??
            UserProfileModel(
              id: userId,
              fullName: _fullNameController.text.trim(),
              email: _userEmail,
            ))
        .copyWith(
      fullName: _fullNameController.text.trim(),
      title: _headlineController.text.trim(),
      about: _bioController.text.trim(),
      location: _locationController.text.trim(),
      phoneNumber: _phoneController.text.trim(),
      profileImageUrl: _avatarUrl,
      socialLinks: SocialLinksModel(
        gitHub: _githubController.text.trim(),
        linkedIn: _linkedInController.text.trim(),
        twitter: _twitterController.text.trim(),
        facebook: _facebookController.text.trim(),
      ),
    );

    // Call real Backend API (PUT /api/Profile)
    final result = await provider.saveProfile(updatedProfile);

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (result is Success<bool>) {
      Navigator.pop(context);
      AppSnackbar.showSuccess(
        context,
        successMsg,
      );
    } else if (result is Failure<bool>) {
      AppSnackbar.showError(
        context,
        result.message,
      );
    }
  }

  // ================= PICK & UPLOAD AVATAR VIA API =================
  Future<void> _pickAndUploadImage(ImageSource source) async {
    final provider = context.read<ProfileProvider>();
    final photoSuccessMsg = context.loc.editProfilePhotoUpdatedSuccess;

    try {
      final pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 1024,
      );

      if (pickedFile == null) return;

      setState(() => _isUploadingAvatar = true);
      HapticFeedback.selectionClick();

      final result = await provider.uploadAvatar(pickedFile);

      if (!mounted) return;
      setState(() => _isUploadingAvatar = false);

      if (result is Success<String>) {
        setState(() => _avatarUrl = result.data);
        AppSnackbar.showSuccess(
          context,
          photoSuccessMsg,
        );
      } else if (result is Failure<String>) {
        AppSnackbar.showError(
          context,
          result.message,
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isUploadingAvatar = false);
      AppSnackbar.showError(
        context,
        'حدث خطأ أثناء اختيار الصورة: $e',
      );
    }
  }

  // ================= MODERN PHOTO PICKER BOTTOM SHEET =================
  void _showImagePickerSheet(Color cardBg, Color textColor, Color textSubColor, Color borderColor, bool isDark) {
    HapticFeedback.lightImpact();
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    showModalBottomSheet(
      context: context,
      backgroundColor: cardBg,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 1. Drag Handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF475569) : const Color(0xFFCBD5E1),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 18),

              // 2. Header
              Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.add_a_photo_outlined,
                      color: AppColors.primary,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                        const SizedBox(height: 2),
                        Text(
                          'اختر صورة واضحة ومناسبة لملفك الشخصي',
                          style: TextStyle(
                            fontSize: 11.5,
                            color: textSubColor,
                            fontFamily: 'Tajawal',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // 3. Option 1: Camera
              _buildPickerOptionTile(
                icon: Icons.camera_alt_rounded,
                iconColor: const Color(0xFF2563EB),
                iconBgColor: isDark ? const Color(0xFF1E3A8A).withValues(alpha: 0.3) : const Color(0xFFEFF6FF),
                title: context.loc.editProfileTakePhoto,
                subtitle: 'التقاط صورة جديدة بواسطة الكاميرا',
                textColor: textColor,
                textSubColor: textSubColor,
                borderColor: borderColor,
                isDark: isDark,
                isRtl: isRtl,
                onTap: () {
                  Navigator.pop(ctx);
                  _pickAndUploadImage(ImageSource.camera);
                },
              ),
              const SizedBox(height: 10),

              // 4. Option 2: Gallery
              _buildPickerOptionTile(
                icon: Icons.photo_library_rounded,
                iconColor: const Color(0xFF8B5CF6),
                iconBgColor: isDark ? const Color(0xFF4C1D95).withValues(alpha: 0.3) : const Color(0xFFFAF5FF),
                title: context.loc.editProfileChooseGallery,
                subtitle: 'اختيار صورة محفوظة من ألبوم الصور',
                textColor: textColor,
                textSubColor: textSubColor,
                borderColor: borderColor,
                isDark: isDark,
                isRtl: isRtl,
                onTap: () {
                  Navigator.pop(ctx);
                  _pickAndUploadImage(ImageSource.gallery);
                },
              ),
              const SizedBox(height: 16),

              // 5. Cancel Button
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    context.loc.profileCancel,
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.bold,
                      color: textSubColor,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPickerOptionTile({
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String title,
    required String subtitle,
    required Color textColor,
    required Color textSubColor,
    required Color borderColor,
    required bool isDark,
    required bool isRtl,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: borderColor),
          color: isDark ? AppColors.darkSurfaceMuted : const Color(0xFFF8FAFC),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 10.5,
                      color: textSubColor,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              isRtl ? Icons.chevron_left_rounded : Icons.chevron_right_rounded,
              size: 20,
              color: textSubColor,
            ),
          ],
        ),
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
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          context.loc.profileEditProfile,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w900,
            color: textColor,
            fontFamily: 'Tajawal',
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
          children: [
            // 1. Avatar Hero
            _buildAvatarHero(cardBg, textColor, textSubColor, borderColor, isDark),

            const SizedBox(height: 24),

            // 2. Section: Basic Personal Info
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
                    icon: Icons.person_outline_rounded,
                    inputFill: inputFill,
                    borderColor: borderColor,
                    textColor: textColor,
                    validator: (v) => (v == null || v.trim().isEmpty) ? context.loc.editProfileFullNameError : null,
                  ),
                  const SizedBox(height: 14),
                  _buildInputField(
                    controller: _headlineController,
                    label: context.loc.editProfileHeadlineLabel,
                    hint: context.loc.editProfileHeadlineHint,
                    icon: Icons.work_outline_rounded,
                    inputFill: inputFill,
                    borderColor: borderColor,
                    textColor: textColor,
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'المسمى الوظيفي مطلوب' : null,
                  ),
                  const SizedBox(height: 14),
                  _buildInputField(
                    controller: _locationController,
                    label: context.loc.editProfileLocationLabel,
                    hint: context.loc.editProfileLocationHint,
                    icon: Icons.location_on_outlined,
                    inputFill: inputFill,
                    borderColor: borderColor,
                    textColor: textColor,
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'الموقع مطلوب' : null,
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
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'رقم الهاتف مطلوب' : null,
                  ),
                  const SizedBox(height: 14),
                  // Bio
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
                            '500 / ${_bioController.text.length}',
                            style: TextStyle(fontSize: 10, color: textSubColor, fontFamily: 'Inter'),
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
                          validator: (v) => (v == null || v.trim().isEmpty) ? 'النبذة التعريفية مطلوبة' : null,
                          onChanged: (_) => setState(() {}),
                          style: TextStyle(fontSize: 12.5, fontFamily: 'Tajawal', color: textColor),
                          decoration: InputDecoration(
                            hintText: context.loc.editProfileBioHint,
                            hintStyle: const TextStyle(fontSize: 11.5, color: AppColors.textMuted, fontFamily: 'Tajawal'),
                            prefixIcon: const Icon(Icons.edit_note_rounded, size: 20, color: AppColors.textSecondary),
                            border: InputBorder.none,
                            counterText: '',
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 3. Section: Professional & Social Links (MVC & Backend compatible)
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
                    controller: _githubController,
                    label: 'GitHub',
                    hint: 'https://github.com/username',
                    icon: Icons.code_rounded,
                    isLtr: true,
                    keyboardType: TextInputType.url,
                    inputFill: inputFill,
                    borderColor: borderColor,
                    textColor: textColor,
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'رابط GitHub مطلوب' : null,
                  ),
                  const SizedBox(height: 14),
                  _buildInputField(
                    controller: _linkedInController,
                    label: 'LinkedIn',
                    hint: 'https://linkedin.com/in/username',
                    icon: Icons.link_rounded,
                    isLtr: true,
                    keyboardType: TextInputType.url,
                    inputFill: inputFill,
                    borderColor: borderColor,
                    textColor: textColor,
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'رابط LinkedIn مطلوب' : null,
                  ),
                  const SizedBox(height: 14),
                  _buildInputField(
                    controller: _twitterController,
                    label: 'X (Twitter)',
                    hint: 'https://x.com/username',
                    icon: Icons.alternate_email_rounded,
                    isLtr: true,
                    keyboardType: TextInputType.url,
                    inputFill: inputFill,
                    borderColor: borderColor,
                    textColor: textColor,
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'رابط Twitter مطلوب' : null,
                  ),
                  const SizedBox(height: 14),
                  _buildInputField(
                    controller: _facebookController,
                    label: 'Facebook',
                    hint: 'https://facebook.com/username',
                    icon: Icons.facebook_rounded,
                    isLtr: true,
                    keyboardType: TextInputType.url,
                    inputFill: inputFill,
                    borderColor: borderColor,
                    textColor: textColor,
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'رابط Facebook مطلوب' : null,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 4. Section: Email Status (Without verified badge)
            _buildSectionHeader(context.loc.editProfileSectionEmail),
            Container(
              padding: const EdgeInsets.all(14),
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
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF4FF),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.email_outlined, color: AppColors.primary, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _userEmail.isNotEmpty ? _userEmail : 'user@edulab.edu',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                            fontFamily: 'Inter',
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          context.loc.editProfileEmailDesc,
                          style: TextStyle(fontSize: 10.5, color: textSubColor, fontFamily: 'Tajawal'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 5. Big Save Changes Button (Unified AppButton with gradient & spinner)
            AppButton(
              label: context.loc.editProfileSaveChangesBtn,
              loadingLabel: 'جاري حفظ التعديلات',
              isLoading: _isLoading,
              icon: const Icon(Icons.check_circle_outline_rounded, size: 19, color: Colors.white),
              onPressed: _saveProfile,
            ),
          ],
        ),
      ),
    );
  }

  // ================= AVATAR HERO =================
  Widget _buildAvatarHero(Color cardBg, Color textColor, Color textSubColor, Color borderColor, bool isDark) {
    final hasAvatar = _avatarUrl != null &&
        _avatarUrl!.trim().isNotEmpty &&
        (_avatarUrl!.startsWith('http://') || _avatarUrl!.startsWith('https://'));

    return Center(
      child: Column(
        children: [
          GestureDetector(
            onTap: _isUploadingAvatar
                ? null
                : () => _showImagePickerSheet(cardBg, textColor, textSubColor, borderColor, isDark),
            child: Stack(
              children: [
                Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    color: cardBg,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: _isUploadingAvatar
                        ? const Center(
                            child: SizedBox(
                              width: 28,
                              height: 28,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: AppColors.primary,
                              ),
                            ),
                          )
                        : (hasAvatar
                            ? CachedNetworkImage(
                                imageUrl: _avatarUrl!,
                                fit: BoxFit.cover,
                                errorWidget: (context, url, error) => Image.asset(
                                  'assets/images/default_avatar.png',
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Image.asset(
                                'assets/images/default_avatar.png',
                                fit: BoxFit.cover,
                              )),
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
                      border: Border.all(
                        color: isDark ? AppColors.darkSurface : Colors.white,
                        width: 2.5,
                      ),
                    ),
                    child: const Icon(
                      Icons.camera_alt_rounded,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            _fullNameController.text.isNotEmpty ? _fullNameController.text : context.loc.profileStudent,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: textColor,
              fontFamily: 'Tajawal',
            ),
          ),
          const SizedBox(height: 2),
          Text(
            _userEmail.isNotEmpty ? _userEmail : '',
            style: TextStyle(
              fontSize: 11.5,
              color: textSubColor,
              fontFamily: 'Inter',
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
          fontSize: 12.5,
          fontWeight: FontWeight.bold,
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
              errorStyle: const TextStyle(
                fontSize: 11,
                fontFamily: 'Tajawal',
                color: Color(0xFFEF4444),
                fontWeight: FontWeight.bold,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
            ),
          ),
        ),
      ],
    );
  }
}

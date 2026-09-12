import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:provider/provider.dart';

import 'package:mobile/core/extensions/localization_ext.dart';
import 'package:mobile/core/services/api_client.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/core/utils/app_responsive.dart';
import 'package:mobile/core/utils/app_snackbar.dart';
import 'package:mobile/core/widgets/app_button.dart';
import 'package:mobile/features/profile/data/models/instructor_application_models.dart';
import 'package:mobile/features/profile/presentation/providers/profile_provider.dart';
import 'package:mobile/features/profile/presentation/providers/teach_application_provider.dart';

class TeachApplicationScreen extends StatefulWidget {
  const TeachApplicationScreen({super.key});

  @override
  State<TeachApplicationScreen> createState() => _TeachApplicationScreenState();
}

class _TeachApplicationScreenState extends State<TeachApplicationScreen> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final profileProvider = context.read<ProfileProvider>();
      context.read<TeachApplicationProvider>().initialize(
        profileProvider.profile,
      );
    });
  }

  // ================= MODERN PHOTO PICKER BOTTOM SHEET =================
  void _showImagePickerSheet({
    required BuildContext context,
    required bool isForProfileImage,
    required Color cardBg,
    required Color textColor,
    required Color textSubColor,
    required Color borderColor,
    required bool isDark,
  }) {
    HapticFeedback.lightImpact();
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final provider = context.read<TeachApplicationProvider>();

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
              // Drag Handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF475569)
                        : const Color(0xFFCBD5E1),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 18),

              // Header
              Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isForProfileImage
                          ? Icons.add_a_photo_outlined
                          : Icons.description_outlined,
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
                          isForProfileImage
                              ? context.loc.teachUploadProfilePhoto
                              : context.loc.teachAttachCV,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            color: textColor,
                            fontFamily: 'Tajawal',
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          isForProfileImage
                              ? context.loc.teachChooseClearPhotoForAccount
                              : context.loc.teachChooseClearDocForCV,
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

              // Option 1: Camera
              _buildPickerOptionTile(
                icon: Icons.camera_alt_rounded,
                iconColor: AppColors.roleInstructor,
                iconBgColor: isDark
                    ? AppColors.darkRoleInstructorBg
                    : AppColors.roleInstructorBg,
                title: context.loc.teachTakePhoto,
                subtitle: context.loc.teachTakePhotoSubtitle,
                textColor: textColor,
                textSubColor: textSubColor,
                borderColor: borderColor,
                isDark: isDark,
                isRtl: isRtl,
                onTap: () async {
                  Navigator.pop(ctx);
                  final file = await _picker.pickImage(
                    source: ImageSource.camera,
                    imageQuality: 85,
                  );
                  if (file != null) {
                    if (isForProfileImage) {
                      provider.setProfileImage(file);
                    } else {
                      provider.setCvFile(file);
                    }
                  }
                },
              ),
              const SizedBox(height: 10),

              // Option 2: Gallery
              _buildPickerOptionTile(
                icon: Icons.photo_library_rounded,
                iconColor: AppColors.purple,
                iconBgColor: isDark
                    ? const Color(0xFF4C1D95).withValues(alpha: 0.3)
                    : AppColors.purpleLight,
                title: context.loc.teachChooseFromGallery,
                subtitle: context.loc.teachChooseFromGallerySubtitle,
                textColor: textColor,
                textSubColor: textSubColor,
                borderColor: borderColor,
                isDark: isDark,
                isRtl: isRtl,
                onTap: () async {
                  Navigator.pop(ctx);
                  final file = await _picker.pickImage(
                    source: ImageSource.gallery,
                    imageQuality: 85,
                  );
                  if (file != null) {
                    if (isForProfileImage) {
                      provider.setProfileImage(file);
                    } else {
                      provider.setCvFile(file);
                    }
                  }
                },
              ),
              const SizedBox(height: 16),

              // Cancel
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

  // ================= STEP NAVIGATION & SUBMIT =================
  void _handleNextStep(TeachApplicationProvider provider) {
    if (provider.currentStep == 1) {
      if (!_formKey.currentState!.validate()) return;
      HapticFeedback.lightImpact();
      provider.nextStep();
    } else if (provider.currentStep == 2) {
      if (provider.skills.isEmpty) {
        AppSnackbar.showError(context, context.loc.teachAddOneSkillRequired);
        return;
      }
      HapticFeedback.lightImpact();
      provider.nextStep();
    }
  }

  void _handleSubmit(TeachApplicationProvider provider) async {
    if (!provider.agreeTerms) {
      AppSnackbar.showError(context, context.loc.teachAgreeTermsRequired);
      return;
    }

    HapticFeedback.mediumImpact();
    final result = await provider.submit();

    if (!mounted) return;

    if (result is Success<String>) {
      // Refresh global profile so roles update (InstructorPending)
      context.read<ProfileProvider>().fetchProfile();
      _showSuccessDialog(result.data);
    } else if (result is Failure<String>) {
      AppSnackbar.showError(context, result.message);
    }
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: const EdgeInsets.all(24),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: const BoxDecoration(
                color: AppColors.emeraldLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle_rounded,
                color: AppColors.emerald,
                size: 36,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              context.loc.teachApplicationReceivedTitle,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w900,
                color: AppColors.textPrimary,
                fontFamily: 'Tajawal',
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message.isNotEmpty
                  ? message
                  : context.loc.teachApplicationReceivedDesc,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
                fontFamily: 'Tajawal',
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            AppButton(
              height: 48,
              borderRadius: 12,
              label: context.loc.teachTrackApplicationStatus,
              fontSize: 13.5,
              onPressed: () {
                Navigator.pop(ctx);
              },
            ),
          ],
        ),
      ),
    );
  }

  // ================= MAIN BUILD =================
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = AppColors.getBackground(context);
    final cardBg = AppColors.getSurface(context);
    final inputFill = isDark
        ? AppColors.darkSurfaceMuted
        : AppColors.background;
    final borderColor = AppColors.getBorder(context);
    final textColor = AppColors.getTextPrimary(context);
    final textSubColor = AppColors.getTextSecondary(context);
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return Consumer2<TeachApplicationProvider, ProfileProvider>(
      builder: (context, provider, profileProvider, _) {
        final profile = profileProvider.profile;
        final isAlreadyInstructor = profile?.isInstructor == true;

        return Scaffold(
          backgroundColor: bgColor,
          appBar: AppBar(
            backgroundColor: cardBg,
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
              context.loc.teachTitle,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w900,
                color: textColor,
                fontFamily: 'Tajawal',
              ),
            ),
            actions: [
              if (provider.hasActiveApplication)
                IconButton(
                  tooltip: context.loc.teachRefreshTooltip,
                  icon: provider.isRefreshing
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.primary,
                            ),
                          ),
                        )
                      : Icon(Icons.refresh_rounded, color: textColor),
                  onPressed: provider.isRefreshing
                      ? null
                      : () {
                          HapticFeedback.lightImpact();
                          provider.fetchMyApplications(isRefresh: true);
                        },
                ),
            ],
          ),
          body: provider.isLoading
              ? _buildLoadingState(textColor, textSubColor)
              : isAlreadyInstructor
              ? _buildAlreadyInstructorState(
                  cardBg,
                  borderColor,
                  textColor,
                  textSubColor,
                )
              : provider.hasActiveApplication
              ? _buildApplicationStatusView(
                  provider.activeApplication!,
                  cardBg,
                  borderColor,
                  textColor,
                  textSubColor,
                  isDark,
                  provider,
                )
              : _buildWizardForm(
                  provider,
                  cardBg,
                  inputFill,
                  borderColor,
                  textColor,
                  textSubColor,
                  isDark,
                ),
        );
      },
    );
  }

  // ================= 0. LOADING & EMPTY STATES =================
  Widget _buildLoadingState(Color textColor, Color textSubColor) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            width: 38,
            height: 38,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            context.loc.teachVerifyingApplicationData,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: textSubColor,
              fontFamily: 'Tajawal',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlreadyInstructorState(
    Color cardBg,
    Color borderColor,
    Color textColor,
    Color textSubColor,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: borderColor),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(
                  color: AppColors.emeraldLight,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.verified_rounded,
                  color: AppColors.emerald,
                  size: 36,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                context.loc.teachAlreadyInstructor,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: textColor,
                  fontFamily: 'Tajawal',
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                context.loc.teachAlreadyInstructorDesc,
                style: TextStyle(
                  fontSize: 12.5,
                  color: textSubColor,
                  fontFamily: 'Tajawal',
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              AppButton(
                height: 48,
                borderRadius: 12,
                label: context.loc.teachBackToHome,
                fontSize: 13.5,
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ================= 1. APPLICATION STATUS VIEW (MVC MyApplications) =================
  Widget _buildApplicationStatusView(
    InstructorApplicationResponseDto app,
    Color cardBg,
    Color borderColor,
    Color textColor,
    Color textSubColor,
    bool isDark,
    TeachApplicationProvider provider,
  ) {
    final dateFormat = DateFormat('yyyy/MM/dd - hh:mm a');
    final formattedDate = app.appliedDate != null
        ? dateFormat.format(app.appliedDate!.toLocal())
        : '-';

    return RefreshIndicator(
      onRefresh: () async {
        HapticFeedback.lightImpact();
        await provider.fetchMyApplications(isRefresh: true);
      },
      color: AppColors.primary,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
        children: [
          // Status Hero Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: borderColor),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Icon
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: app.statusBgColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    app.isApproved
                        ? Icons.check_circle_rounded
                        : (app.isRejected
                              ? Icons.cancel_rounded
                              : Icons.hourglass_top_rounded),
                    color: app.statusColor,
                    size: 32,
                  ),
                ),
                const SizedBox(height: 14),

                // Title
                Text(
                  app.isApproved
                      ? context.loc.teachStatusApproved
                      : (app.isRejected
                            ? context.loc.teachStatusRejected
                            : context.loc.teachStatusPending),
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                    color: textColor,
                    fontFamily: 'Tajawal',
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 6),

                // Status Badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: app.statusBgColor,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: app.statusColor.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: app.statusColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        app.statusDisplay,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: app.statusColor,
                          fontFamily: 'Tajawal',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // Description banner
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: app.statusBgColor.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        size: 18,
                        color: app.statusColor,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          app.isApproved
                              ? context.loc.teachApprovedMessage
                              : (app.isRejected
                                    ? (app.rejectionReason != null &&
                                              app.rejectionReason!.isNotEmpty
                                          ? context.loc.teachRejectionReason(
                                              app.rejectionReason!,
                                            )
                                          : context.loc.teachRejectedDefault)
                                    : context.loc.teachPendingMessage),
                          style: TextStyle(
                            fontSize: 11.5,
                            color: textColor,
                            fontFamily: 'Tajawal',
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Application Details Card
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: borderColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.loc.teachApplicationDetails,
                  style: TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w900,
                    color: textColor,
                    fontFamily: 'Tajawal',
                  ),
                ),
                const SizedBox(height: 14),

                _buildStatusDetailRow(
                  context.loc.teachApplicationNumber,
                  '#${app.id.length > 8 ? app.id.substring(0, 8) : app.id}',
                  textColor,
                  textSubColor,
                ),
                _buildStatusDetailRow(
                  context.loc.teachApplicationDate,
                  formattedDate,
                  textColor,
                  textSubColor,
                ),
                if (app.fullName != null)
                  _buildStatusDetailRow(
                    context.loc.teachApplicant,
                    app.fullName!,
                    textColor,
                    textSubColor,
                  ),
                if (app.email != null)
                  _buildStatusDetailRow(
                    context.loc.teachApplicantEmail,
                    app.email!,
                    textColor,
                    textSubColor,
                  ),
                if (app.specialization != null)
                  _buildStatusDetailRow(
                    context.loc.teachSpecialization,
                    app.specialization!,
                    textColor,
                    textSubColor,
                  ),
                if (app.experience != null)
                  _buildStatusDetailRow(
                    context.loc.teachExperienceYears,
                    app.experience == '0-2'
                        ? context.loc.teachExperience0to2
                        : (app.experience == '2-5'
                              ? context.loc.teachExperience2to5
                              : (app.experience == '5-10'
                                    ? context.loc.teachExperience5to10
                                    : (app.experience == '10+'
                                          ? context.loc.teachExperience10plus
                                          : app.experience!))),
                    textColor,
                    textSubColor,
                  ),
                if (app.cvUrl != null && app.cvUrl!.isNotEmpty)
                  _buildStatusDetailRow(
                    context.loc.teachCVLabel,
                    context.loc.teachCVAttached,
                    const Color(0xFF059669),
                    textSubColor,
                  ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Action Buttons
          if (app.isRejected)
            AppButton(
              height: 48,
              borderRadius: 12,
              icon: const Icon(
                Icons.refresh_rounded,
                size: 18,
                color: Colors.white,
              ),
              label: context.loc.teachReapply,
              fontSize: 13.5,
              onPressed: () {
                provider.resetFormForNewApplication();
              },
            )
          else
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: provider.isRefreshing
                    ? null
                    : () {
                        HapticFeedback.lightImpact();
                        provider.fetchMyApplications(isRefresh: true);
                      },
                icon: provider.isRefreshing
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.primary,
                          ),
                        ),
                      )
                    : const Icon(Icons.refresh_rounded, size: 18),
                label: Text(
                  provider.isRefreshing
                      ? context.loc.teachRefreshing
                      : context.loc.teachRefreshStatus,
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Tajawal',
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatusDetailRow(
    String label,
    String value,
    Color textColor,
    Color subColor,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: subColor,
              fontFamily: 'Tajawal',
              fontWeight: FontWeight.w500,
            ),
          ),
          Flexible(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 12.5,
                color: textColor,
                fontFamily: 'Tajawal',
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.end,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // ================= 2. WIZARD FORM =================
  Widget _buildWizardForm(
    TeachApplicationProvider provider,
    Color cardBg,
    Color inputFill,
    Color borderColor,
    Color textColor,
    Color textSubColor,
    bool isDark,
  ) {
    return Form(
      key: _formKey,
      child: ListView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.fromLTRB(
          AppResponsive.screenPadding(context),
          16,
          AppResponsive.screenPadding(context),
          40,
        ),
        children: [
          // 1. Intro Header
          _buildIntroHeader(cardBg, borderColor, textColor, textSubColor),

          const SizedBox(height: 18),

          // 2. Stepper Progress
          _buildStepper(provider.currentStep, cardBg, borderColor, isDark),

          const SizedBox(height: 20),

          // 3. Step Content
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 240),
            child: _buildStepContent(
              provider,
              cardBg,
              inputFill,
              borderColor,
              textColor,
              textSubColor,
              isDark,
            ),
          ),

          const SizedBox(height: 24),

          // 4. Value Props
          _buildValueProps(cardBg, borderColor, textColor, textSubColor),
        ],
      ),
    );
  }

  // ================= INTRO HEADER =================
  Widget _buildIntroHeader(
    Color cardBg,
    Color borderColor,
    Color textColor,
    Color textSubColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.school_outlined,
              color: AppColors.primary,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.loc.teachJoinInstructorTitle,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                    color: textColor,
                    fontFamily: 'Tajawal',
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  context.loc.teachJoinInstructorSubtitle,
                  style: TextStyle(
                    fontSize: 11,
                    color: textSubColor,
                    fontFamily: 'Tajawal',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ================= STEPPER =================
  Widget _buildStepper(
    int currentStep,
    Color cardBg,
    Color borderColor,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          _buildStepItem(
            1,
            currentStep,
            context.loc.teachStepPersonalData,
            isDark,
          ),
          _buildStepDivider(1, currentStep, isDark),
          _buildStepItem(
            2,
            currentStep,
            context.loc.teachStepExperienceSkills,
            isDark,
          ),
          _buildStepDivider(2, currentStep, isDark),
          _buildStepItem(
            3,
            currentStep,
            context.loc.teachStepReviewApplication,
            isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildStepItem(int step, int currentStep, String title, bool isDark) {
    final isDone = currentStep > step;
    final isActive = currentStep == step;

    Color circleColor = isDark
        ? AppColors.darkSurfaceMuted
        : AppColors.surfaceMuted;
    Color textColor = AppColors.textSecondary;
    Color border = isDark ? AppColors.darkBorder : AppColors.border;

    if (isDone) {
      circleColor = AppColors.emerald;
      textColor = Colors.white;
      border = AppColors.emerald;
    } else if (isActive) {
      circleColor = AppColors.primary;
      textColor = Colors.white;
      border = AppColors.primary;
    }

    return Expanded(
      child: Column(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: circleColor,
              shape: BoxShape.circle,
              border: Border.all(color: border, width: 1.5),
            ),
            child: Center(
              child: isDone
                  ? const Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                      size: 16,
                    )
                  : Text(
                      '$step',
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        fontFamily: 'Inter',
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: TextStyle(
              fontSize: 10,
              fontWeight: isActive || isDone
                  ? FontWeight.bold
                  : FontWeight.normal,
              color: isActive
                  ? AppColors.primary
                  : (isDone ? AppColors.emerald : AppColors.textMuted),
              fontFamily: 'Tajawal',
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildStepDivider(int step, int currentStep, bool isDark) {
    final isDone = currentStep > step;
    return Container(
      width: 24,
      height: 2,
      margin: const EdgeInsets.only(bottom: 18),
      color: isDone
          ? AppColors.emerald
          : (isDark ? AppColors.darkBorder : AppColors.border),
    );
  }

  // ================= STEP SWITCHER =================
  Widget _buildStepContent(
    TeachApplicationProvider provider,
    Color cardBg,
    Color inputFill,
    Color borderColor,
    Color textColor,
    Color textSubColor,
    bool isDark,
  ) {
    switch (provider.currentStep) {
      case 1:
        return _buildStepOne(
          provider,
          cardBg,
          inputFill,
          borderColor,
          textColor,
          textSubColor,
          isDark,
        );
      case 2:
        return _buildStepTwo(
          provider,
          cardBg,
          inputFill,
          borderColor,
          textColor,
          textSubColor,
          isDark,
        );
      case 3:
        return _buildStepThree(
          provider,
          cardBg,
          inputFill,
          borderColor,
          textColor,
          textSubColor,
          isDark,
        );
      default:
        return const SizedBox.shrink();
    }
  }

  // ================= STEP 1: PERSONAL INFO =================
  Widget _buildStepOne(
    TeachApplicationProvider provider,
    Color cardBg,
    Color inputFill,
    Color borderColor,
    Color textColor,
    Color textSubColor,
    bool isDark,
  ) {
    return Container(
      key: const ValueKey('step_1'),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.loc.teachStep1HeaderTitle,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w900,
              color: textColor,
              fontFamily: 'Tajawal',
            ),
          ),
          const SizedBox(height: 14),

          // Full Name
          _buildInputField(
            controller: provider.nameController,
            label: context.loc.teachFullNameLabel,
            hint: context.loc.teachFullNameHintAr,
            icon: Icons.person_outline_rounded,
            inputFill: inputFill,
            borderColor: borderColor,
            textColor: textColor,
            validator: (v) => (v == null || v.trim().length < 3)
                ? context.loc.teachFullNameValidation
                : null,
          ),
          const SizedBox(height: 12),

          // Email (read-only from account)
          _buildInputField(
            controller: provider.emailController,
            label: context.loc.teachEmailReadonly,
            hint: 'email@example.com',
            icon: Icons.email_outlined,
            readOnly: true,
            isLtr: true,
            inputFill: inputFill,
            borderColor: borderColor,
            textColor: textSubColor,
          ),
          const SizedBox(height: 12),

          // Phone
          _buildInputField(
            controller: provider.phoneController,
            label: context.loc.teachPhoneLabelContact,
            hint: '+966 50 123 4567',
            icon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
            isLtr: true,
            inputFill: inputFill,
            borderColor: borderColor,
            textColor: textColor,
            validator: (v) => (v == null || v.trim().length < 8)
                ? context.loc.teachPhoneValidation
                : null,
          ),
          const SizedBox(height: 12),

          // Bio with live counter (Max 200)
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: provider.bioController,
            builder: (context, value, _) {
              final length = value.text.length;
              final isOver = length > 200;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        context.loc.teachBioLabelWithAsterisk,
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                          fontFamily: 'Tajawal',
                        ),
                      ),
                      Text(
                        context.loc.teachBioCharCount('$length'),
                        style: TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.bold,
                          color: isOver
                              ? Colors.red
                              : (length < 10
                                    ? AppColors.textMuted
                                    : const Color(0xFF059669)),
                          fontFamily: 'Inter',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Container(
                    decoration: BoxDecoration(
                      color: inputFill,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isOver ? Colors.red : borderColor,
                      ),
                    ),
                    child: TextFormField(
                      controller: provider.bioController,
                      maxLines: 3,
                      maxLength: 200,
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'Tajawal',
                        color: textColor,
                      ),
                      decoration: InputDecoration(
                        hintText: context.loc.teachBioHintDetail,
                        hintStyle: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textMuted,
                          fontFamily: 'Tajawal',
                        ),
                        border: InputBorder.none,
                        counterText: '',
                        contentPadding: const EdgeInsets.all(12),
                      ),
                      validator: (v) {
                        if (v == null || v.trim().length < 10) {
                          return context.loc.teachBioMinLengthValidation;
                        }
                        if (v.trim().length > 200) {
                          return context.loc.teachBioMaxLengthValidation;
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 14),

          // Profile Image Picker
          Text(
            context.loc.teachProfilePhotoOptional,
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.bold,
              color: textColor,
              fontFamily: 'Tajawal',
            ),
          ),
          const SizedBox(height: 6),
          _buildImageUploadBox(
            file: provider.profileImage,
            isDark: isDark,
            borderColor: borderColor,
            textColor: textColor,
            textSubColor: textSubColor,
            onPick: () => _showImagePickerSheet(
              context: context,
              isForProfileImage: true,
              cardBg: cardBg,
              textColor: textColor,
              textSubColor: textSubColor,
              borderColor: borderColor,
              isDark: isDark,
            ),
            onRemove: () => provider.setProfileImage(null),
          ),

          const SizedBox(height: 20),

          // Next Button
          AppButton(
            height: 48,
            borderRadius: 12,
            icon: Icon(
              Directionality.of(context) == TextDirection.rtl
                  ? Icons.arrow_back_rounded
                  : Icons.arrow_forward_rounded,
              size: 16,
              color: Colors.white,
            ),
            label: context.loc.teachNextExperienceSkills,
            fontSize: 13,
            onPressed: () => _handleNextStep(provider),
          ),
        ],
      ),
    );
  }

  // ================= STEP 2: EXPERIENCE & SKILLS =================
  Widget _buildStepTwo(
    TeachApplicationProvider provider,
    Color cardBg,
    Color inputFill,
    Color borderColor,
    Color textColor,
    Color textSubColor,
    bool isDark,
  ) {
    final categories = provider.categories;

    return Container(
      key: const ValueKey('step_2'),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.loc.teachStep2HeaderTitle,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w900,
              color: textColor,
              fontFamily: 'Tajawal',
            ),
          ),
          const SizedBox(height: 14),

          // Specialization Category Dropdown
          Text(
            context.loc.teachSpecializationLabel,
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.bold,
              color: textColor,
              fontFamily: 'Tajawal',
            ),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: inputFill,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: borderColor),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value:
                    provider.specialization ??
                    (categories.isNotEmpty ? categories.first.name : null),
                isExpanded: true,
                dropdownColor: cardBg,
                hint: Text(
                  context.loc.teachSpecializationHint,
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: 'Tajawal',
                    color: textSubColor,
                  ),
                ),
                items: categories.map((cat) {
                  return DropdownMenuItem<String>(
                    value: cat.name,
                    child: Text(
                      cat.name,
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'Tajawal',
                        color: textColor,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) provider.setSpecialization(val);
                },
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Experience Dropdown (0-2, 2-5, 5-10, 10+)
          Text(
            context.loc.teachExperienceLabel,
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.bold,
              color: textColor,
              fontFamily: 'Tajawal',
            ),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: inputFill,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: borderColor),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: provider.experience,
                isExpanded: true,
                dropdownColor: cardBg,
                items: [
                  DropdownMenuItem(
                    value: '0-2',
                    child: Text(
                      context.loc.teachExperience0to2,
                      style: const TextStyle(
                        fontSize: 12,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                  ),
                  DropdownMenuItem(
                    value: '2-5',
                    child: Text(
                      context.loc.teachExperience2to5,
                      style: const TextStyle(
                        fontSize: 12,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                  ),
                  DropdownMenuItem(
                    value: '5-10',
                    child: Text(
                      context.loc.teachExperience5to10,
                      style: const TextStyle(
                        fontSize: 12,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                  ),
                  DropdownMenuItem(
                    value: '10+',
                    child: Text(
                      context.loc.teachExperience10plus,
                      style: const TextStyle(
                        fontSize: 12,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                  ),
                ],
                onChanged: (val) {
                  if (val != null) provider.setExperience(val);
                },
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Skills Chips Input
          Text(
            context.loc.teachSkillsLabel,
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.bold,
              color: textColor,
              fontFamily: 'Tajawal',
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: inputFill,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: borderColor),
                  ),
                  child: TextField(
                    controller: provider.skillInputController,
                    style: TextStyle(
                      fontSize: 12,
                      fontFamily: 'Tajawal',
                      color: textColor,
                    ),
                    decoration: InputDecoration(
                      hintText: context.loc.teachSkillHint,
                      hintStyle: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textMuted,
                        fontFamily: 'Tajawal',
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                    ),
                    onSubmitted: (val) => provider.addSkill(val),
                  ),
                ),
              ),
              AppButton(
                width: 75,
                height: 42,
                borderRadius: 10,
                label: context.loc.teachSkillAddButton,
                fontSize: 12,
                onPressed: () =>
                    provider.addSkill(provider.skillInputController.text),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Skills Tag Chips
          if (provider.skills.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text(
                context.loc.teachSkillMinRequired,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.orange.shade700,
                  fontFamily: 'Tajawal',
                ),
              ),
            )
          else
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: provider.skills.map((skill) {
                return Chip(
                  label: Text(
                    skill,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Inter',
                      color: AppColors.primary,
                    ),
                  ),
                  backgroundColor: const Color(0xFFEFF4FF),
                  deleteIcon: const Icon(
                    Icons.close_rounded,
                    size: 14,
                    color: AppColors.primary,
                  ),
                  onDeleted: () => provider.removeSkill(skill),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide.none,
                  ),
                );
              }).toList(),
            ),

          const SizedBox(height: 16),

          // CV Upload
          Text(
            context.loc.teachCVFileLabel,
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.bold,
              color: textColor,
              fontFamily: 'Tajawal',
            ),
          ),
          const SizedBox(height: 6),
          _buildCvUploadBox(
            file: provider.cvFile,
            isDark: isDark,
            borderColor: borderColor,
            textColor: textColor,
            textSubColor: textSubColor,
            onPick: () => _showImagePickerSheet(
              context: context,
              isForProfileImage: false,
              cardBg: cardBg,
              textColor: textColor,
              textSubColor: textSubColor,
              borderColor: borderColor,
              isDark: isDark,
            ),
            onRemove: () => provider.setCvFile(null),
          ),

          const SizedBox(height: 20),

          // Navigation Row
          Row(
            children: [
              Expanded(
                flex: 1,
                child: AppButton(
                  height: 48,
                  borderRadius: 12,
                  outlined: true,
                  label: context.loc.teachPrevButton,
                  fontSize: 13,
                  onPressed: () => provider.prevStep(),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 2,
                child: AppButton(
                  height: 48,
                  borderRadius: 12,
                  icon: Icon(
                    Directionality.of(context) == TextDirection.rtl
                        ? Icons.arrow_back_rounded
                        : Icons.arrow_forward_rounded,
                    size: 16,
                    color: Colors.white,
                  ),
                  label: context.loc.teachNextReviewApplication,
                  fontSize: 13,
                  onPressed: () => _handleNextStep(provider),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ================= STEP 3: REVIEW & SUBMIT =================
  Widget _buildStepThree(
    TeachApplicationProvider provider,
    Color cardBg,
    Color inputFill,
    Color borderColor,
    Color textColor,
    Color textSubColor,
    bool isDark,
  ) {
    return Container(
      key: const ValueKey('step_3'),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.loc.teachStep3HeaderTitle,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w900,
              color: textColor,
              fontFamily: 'Tajawal',
            ),
          ),
          const SizedBox(height: 14),

          // Info Banner
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.darkSurfaceMuted
                  : AppColors.roleInstructorBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark
                    ? AppColors.darkBorder
                    : AppColors.roleInstructorBorder,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.info_rounded,
                  color: AppColors.primary,
                  size: 20,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    context.loc.teachReviewBanner,
                    style: TextStyle(
                      fontSize: 11.5,
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.primaryDark,
                      fontFamily: 'Tajawal',
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Review Summary Card
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: inputFill,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: borderColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSummaryRow(
                  context.loc.teachSummaryFullName,
                  provider.nameController.text.trim(),
                  textColor,
                  textSubColor,
                ),
                _buildSummaryRow(
                  context.loc.teachSummaryEmail,
                  provider.emailController.text.trim(),
                  textColor,
                  textSubColor,
                ),
                _buildSummaryRow(
                  context.loc.teachSummaryPhone,
                  provider.phoneController.text.trim(),
                  textColor,
                  textSubColor,
                ),
                _buildSummaryRow(
                  context.loc.teachSummarySpecialization,
                  provider.specialization ?? '-',
                  textColor,
                  textSubColor,
                ),
                _buildSummaryRow(
                  context.loc.teachSummaryExperience,
                  provider.experience == '0-2'
                      ? context.loc.teachExperience0to2
                      : (provider.experience == '2-5'
                            ? context.loc.teachExperience2to5
                            : (provider.experience == '5-10'
                                  ? context.loc.teachExperience5to10
                                  : (provider.experience == '10+'
                                        ? context.loc.teachExperience10plus
                                        : provider.experience))),
                  textColor,
                  textSubColor,
                ),
                _buildSummaryRow(
                  context.loc.teachSummarySkillsLabel,
                  context.loc.teachSummarySkillsCount(
                    '${provider.skills.length}',
                    provider.skills.join(", "),
                  ),
                  textColor,
                  textSubColor,
                ),
                _buildSummaryRow(
                  context.loc.teachSummaryProfilePhoto,
                  provider.profileImage != null
                      ? context.loc.teachSummaryPhotoSelected
                      : context.loc.teachSummaryPhotoNotSelected,
                  textColor,
                  textSubColor,
                ),
                _buildSummaryRow(
                  context.loc.teachSummaryCVFile,
                  provider.cvFile != null
                      ? context.loc.teachSummaryCVAttached
                      : context.loc.teachSummaryCVNotAttached,
                  textColor,
                  textSubColor,
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Terms Checkbox
          InkWell(
            onTap: () => provider.setAgreeTerms(!provider.agreeTerms),
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: Checkbox(
                      value: provider.agreeTerms,
                      activeColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      onChanged: (val) => provider.setAgreeTerms(val ?? false),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      context.loc.teachTermsAgreement,
                      style: TextStyle(
                        fontSize: 11.5,
                        color: textColor,
                        fontFamily: 'Tajawal',
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Submit & Prev Buttons
          Row(
            children: [
              Expanded(
                flex: 1,
                child: AppButton(
                  height: 48,
                  borderRadius: 12,
                  outlined: true,
                  label: context.loc.teachPrevButton,
                  fontSize: 13,
                  onPressed: provider.isSubmitting
                      ? null
                      : () => provider.prevStep(),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 2,
                child: AppButton(
                  height: 48,
                  borderRadius: 12,
                  isLoading: provider.isSubmitting,
                  icon: const Icon(
                    Icons.send_rounded,
                    size: 16,
                    color: Colors.white,
                  ),
                  label: context.loc.teachSubmitButton,
                  fontSize: 13,
                  onPressed: () => _handleSubmit(provider),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(
    String label,
    String value,
    Color textColor,
    Color subColor,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: subColor,
                fontFamily: 'Tajawal',
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.bold,
                color: textColor,
                fontFamily: 'Tajawal',
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= HELPER WIDGETS =================
  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required Color inputFill,
    required Color borderColor,
    required Color textColor,
    bool readOnly = false,
    bool isLtr = false,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
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
        const SizedBox(height: 4),
        Container(
          decoration: BoxDecoration(
            color: inputFill,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: borderColor),
          ),
          child: TextFormField(
            controller: controller,
            readOnly: readOnly,
            keyboardType: keyboardType,
            textDirection: isLtr ? TextDirection.ltr : null,
            style: TextStyle(
              fontSize: 12,
              fontFamily: isLtr ? 'Inter' : 'Tajawal',
              color: textColor,
            ),
            decoration: InputDecoration(
              prefixIcon: Icon(icon, size: 18, color: AppColors.primary),
              hintText: hint,
              hintStyle: const TextStyle(
                fontSize: 11,
                color: AppColors.textMuted,
                fontFamily: 'Tajawal',
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
            ),
            validator: validator,
          ),
        ),
      ],
    );
  }

  Widget _buildImageUploadBox({
    required XFile? file,
    required bool isDark,
    required Color borderColor,
    required Color textColor,
    required Color textSubColor,
    required VoidCallback onPick,
    required VoidCallback onRemove,
  }) {
    if (file != null) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.emerald),
          color: AppColors.emeraldLight.withValues(alpha: isDark ? 0.1 : 0.6),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.file(
                File(file.path),
                width: 44,
                height: 44,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    file.name,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                      fontFamily: 'Inter',
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    context.loc.teachPhotoSelectedSuccess,
                    style: const TextStyle(
                      fontSize: 10,
                      color: AppColors.emerald,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(
                Icons.delete_outline_rounded,
                color: Colors.red,
                size: 20,
              ),
              onPressed: onRemove,
            ),
          ],
        ),
      );
    }

    return InkWell(
      onTap: onPick,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor, style: BorderStyle.solid),
          color: isDark ? AppColors.darkSurfaceMuted : AppColors.background,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.cloud_upload_outlined,
              color: AppColors.primary,
              size: 22,
            ),
            const SizedBox(width: 8),
            Text(
              context.loc.teachChoosePhotoFromDevice,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
                fontFamily: 'Tajawal',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCvUploadBox({
    required XFile? file,
    required bool isDark,
    required Color borderColor,
    required Color textColor,
    required Color textSubColor,
    required VoidCallback onPick,
    required VoidCallback onRemove,
  }) {
    if (file != null) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.emerald),
          color: AppColors.emeraldLight.withValues(alpha: isDark ? 0.1 : 0.6),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.emerald.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.description_rounded,
                color: AppColors.emerald,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    file.name,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                      fontFamily: 'Inter',
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    context.loc.teachCVAttachedSuccess,
                    style: const TextStyle(
                      fontSize: 10,
                      color: AppColors.emerald,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(
                Icons.delete_outline_rounded,
                color: Colors.red,
                size: 20,
              ),
              onPressed: onRemove,
            ),
          ],
        ),
      );
    }

    return InkWell(
      onTap: onPick,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor),
          color: isDark ? AppColors.darkSurfaceMuted : AppColors.background,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.attach_file_rounded,
              color: AppColors.primary,
              size: 22,
            ),
            const SizedBox(width: 8),
            Text(
              context.loc.teachAttachCVFileOrPhoto,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
                fontFamily: 'Tajawal',
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= 4. VALUE PROPS =================
  Widget _buildValueProps(
    Color cardBg,
    Color borderColor,
    Color textColor,
    Color textSubColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.loc.teachWhyEduLabTitle,
            style: TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w900,
              color: textColor,
              fontFamily: 'Tajawal',
            ),
          ),
          const SizedBox(height: 12),
          _buildValuePropItem(
            Icons.payments_outlined,
            context.loc.teachProp1Title,
            context.loc.teachProp1Desc,
            textColor,
            textSubColor,
          ),
          _buildValuePropItem(
            Icons.groups_outlined,
            context.loc.teachProp2Title,
            context.loc.teachProp2Desc,
            textColor,
            textSubColor,
          ),
          _buildValuePropItem(
            Icons.support_agent_outlined,
            context.loc.teachProp3Title,
            context.loc.teachProp3Desc,
            textColor,
            textSubColor,
          ),
        ],
      ),
    );
  }

  Widget _buildValuePropItem(
    IconData icon,
    String title,
    String desc,
    Color textColor,
    Color textSubColor,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppColors.primary, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                    fontFamily: 'Tajawal',
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  desc,
                  style: TextStyle(
                    fontSize: 10.5,
                    color: textSubColor,
                    fontFamily: 'Tajawal',
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

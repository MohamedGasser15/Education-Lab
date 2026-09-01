import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile/core/extensions/localization_ext.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/core/widgets/app_button.dart';

class TeachApplicationScreen extends StatefulWidget {
  const TeachApplicationScreen({super.key});

  @override
  State<TeachApplicationScreen> createState() => _TeachApplicationScreenState();
}

class _TeachApplicationScreenState extends State<TeachApplicationScreen> {
  final _formKey = GlobalKey<FormState>();

  int _currentStep = 1;
  bool _isSubmitting = false;

  // Step 1: Personal & Profile Info
  final _nameController = TextEditingController(text: 'محمد النجار');
  final _headlineController = TextEditingController(text: 'Senior Software Architect & Flutter Trainer');
  final _bioController = TextEditingController(
    text: 'خبير في تطوير تطبيقات الموبايل وحلول المؤسسات بخبرة أكثر من 8 سنوات في تدريب وتوجيه المطورين.',
  );
  final _phoneController = TextEditingController(text: '+966 50 123 4567');
  final _countryController = TextEditingController(text: 'المملكة العربية السعودية');

  // Step 2: Teaching & Skills Info
  final _topicController = TextEditingController(text: 'تطوير تطبيقات Flutter و Dart المتقدمة');
  final _yearsOfExperienceController = TextEditingController(text: '8');
  final _sampleVideoLinkController = TextEditingController(text: 'https://youtube.com/watch?v=sample-lesson');
  final _skillInputController = TextEditingController();

  final List<String> _skillsList = ['Flutter', 'Dart', 'Clean Architecture', 'Riverpod', 'RESTful APIs', 'Firebase'];
  String _targetAudience = 'مبتدئين ومتوسطين';

  // Step 3: Terms & Payouts
  bool _agreeTerms = true;
  String _preferredPayoutMethod = 'تحويل بنكي مباشر (IBAN)';
  final _payoutDetailsController = TextEditingController(text: 'SA0380000000608010167519');

  @override
  void dispose() {
    _nameController.dispose();
    _headlineController.dispose();
    _bioController.dispose();
    _phoneController.dispose();
    _countryController.dispose();
    _topicController.dispose();
    _yearsOfExperienceController.dispose();
    _sampleVideoLinkController.dispose();
    _skillInputController.dispose();
    _payoutDetailsController.dispose();
    super.dispose();
  }

  void _addSkill() {
    final skill = _skillInputController.text.trim();
    if (skill.isNotEmpty && !_skillsList.contains(skill)) {
      setState(() {
        _skillsList.add(skill);
        _skillInputController.clear();
      });
    }
  }

  void _removeSkill(String skill) {
    setState(() {
      _skillsList.remove(skill);
    });
  }

  void _nextStep() {
    if (_currentStep == 1) {
      if (!_formKey.currentState!.validate()) return;
      HapticFeedback.lightImpact();
      setState(() => _currentStep = 2);
    } else if (_currentStep == 2) {
      if (_skillsList.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.loc.teachAddOneSkillError), behavior: SnackBarBehavior.floating),
        );
        return;
      }
      HapticFeedback.lightImpact();
      setState(() => _currentStep = 3);
    }
  }

  void _prevStep() {
    if (_currentStep > 1) {
      HapticFeedback.lightImpact();
      setState(() => _currentStep--);
    }
  }

  void _submitApplication() async {
    if (!_agreeTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.loc.teachAgreeTermsError), behavior: SnackBarBehavior.floating),
      );
      return;
    }

    HapticFeedback.mediumImpact();
    setState(() => _isSubmitting = true);

    await Future.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;
    setState(() => _isSubmitting = false);

    _showSuccessDialog();
  }

  void _showSuccessDialog() {
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
                color: Color(0xFFECFDF5),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_circle_rounded, color: Color(0xFF059669), size: 36),
            ),
            const SizedBox(height: 16),
            Text(
              context.loc.teachSuccessDialogTitle,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w900,
                color: AppColors.textPrimary,
                fontFamily: 'Tajawal',
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              context.loc.teachSuccessDialogDesc,
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
                fontFamily: 'Tajawal',
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  elevation: 0,
                ),
                child: Text(
                  context.loc.teachSuccessDialogOk,
                  style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, fontFamily: 'Tajawal'),
                ),
              ),
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
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
          children: [
            // 1. Clean Title & Intro Card
            _buildIntroHeader(cardBg, borderColor, textColor, textSubColor),

            const SizedBox(height: 18),

            // 2. Stepper Progress
            _buildStepper(cardBg, borderColor, isDark),

            const SizedBox(height: 20),

            // 3. Step Content
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 240),
              child: _buildStepContent(cardBg, inputFill, borderColor, textColor, textSubColor, isDark),
            ),

            const SizedBox(height: 24),

            // 4. Value Props
            _buildValueProps(cardBg, borderColor, textColor, textSubColor),
          ],
        ),
      ),
    );
  }

  // ================= 1. INTRO HEADER =================
  Widget _buildIntroHeader(Color cardBg, Color borderColor, Color textColor, Color textSubColor) {
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
            child: const Icon(Icons.school_outlined, color: AppColors.primary, size: 24),
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

  // ================= 2. STEPPER =================
  Widget _buildStepper(Color cardBg, Color borderColor, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          _buildStepItem(1, context.loc.teachStep1Title, isDark),
          _buildStepDivider(1, isDark),
          _buildStepItem(2, context.loc.teachStep2Title, isDark),
          _buildStepDivider(2, isDark),
          _buildStepItem(3, context.loc.teachStep3Title, isDark),
        ],
      ),
    );
  }

  Widget _buildStepItem(int step, String title, bool isDark) {
    final isDone = _currentStep > step;
    final isActive = _currentStep == step;

    Color circleColor = isDark ? AppColors.darkSurfaceMuted : const Color(0xFFF1F5F9);
    Color textColor = const Color(0xFF64748B);
    Color border = isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0);

    if (isDone) {
      circleColor = const Color(0xFF059669);
      textColor = Colors.white;
      border = const Color(0xFF059669);
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
                  ? const Icon(Icons.check_rounded, color: Colors.white, size: 16)
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
              fontWeight: isActive || isDone ? FontWeight.bold : FontWeight.normal,
              color: isActive
                  ? AppColors.primary
                  : (isDone ? const Color(0xFF059669) : const Color(0xFF94A3B8)),
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

  Widget _buildStepDivider(int step, bool isDark) {
    final isDone = _currentStep > step;
    return Container(
      width: 24,
      height: 2,
      margin: const EdgeInsets.only(bottom: 18),
      color: isDone ? const Color(0xFF059669) : (isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0)),
    );
  }

  // ================= 3. STEP CONTENT =================
  Widget _buildStepContent(Color cardBg, Color inputFill, Color borderColor, Color textColor, Color textSubColor, bool isDark) {
    switch (_currentStep) {
      case 1:
        return _buildStepOne(cardBg, inputFill, borderColor, textColor, textSubColor);
      case 2:
        return _buildStepTwo(cardBg, inputFill, borderColor, textColor, textSubColor, isDark);
      case 3:
        return _buildStepThree(cardBg, inputFill, borderColor, textColor, textSubColor, isDark);
      default:
        return const SizedBox.shrink();
    }
  }

  // Step 1 Widget
  Widget _buildStepOne(Color cardBg, Color inputFill, Color borderColor, Color textColor, Color textSubColor) {
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
            context.loc.teachStep1Header,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: textColor, fontFamily: 'Tajawal'),
          ),
          const SizedBox(height: 14),

          _buildInputField(
            controller: _nameController,
            label: context.loc.teachFullNameArabicLabel,
            hint: context.loc.teachFullNameArabicHint,
            icon: Icons.person_outline_rounded,
            inputFill: inputFill,
            borderColor: borderColor,
            textColor: textColor,
            validator: (v) => (v == null || v.trim().length < 3) ? 'أدخل الاسم كاملاً' : null,
          ),
          const SizedBox(height: 12),

          _buildInputField(
            controller: _headlineController,
            label: context.loc.teachHeadlineLabel,
            hint: context.loc.teachHeadlineHint,
            icon: Icons.badge_outlined,
            inputFill: inputFill,
            borderColor: borderColor,
            textColor: textColor,
            validator: (v) => (v == null || v.trim().isEmpty) ? 'أدخل المسمى المهني' : null,
          ),
          const SizedBox(height: 12),

          _buildInputField(
            controller: _phoneController,
            label: context.loc.teachPhoneLabel,
            hint: '+966 50 123 4567',
            icon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
            isLtr: true,
            inputFill: inputFill,
            borderColor: borderColor,
            textColor: textColor,
            validator: (v) => (v == null || v.trim().isEmpty) ? 'أدخل رقم الهاتف' : null,
          ),
          const SizedBox(height: 12),

          _buildInputField(
            controller: _countryController,
            label: context.loc.teachCountryLabel,
            hint: context.loc.editProfileLocationHint,
            icon: Icons.public_rounded,
            inputFill: inputFill,
            borderColor: borderColor,
            textColor: textColor,
            validator: (v) => (v == null || v.trim().isEmpty) ? 'أدخل بلد الإقامة' : null,
          ),
          const SizedBox(height: 12),

          // Bio
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.loc.teachBioLabel,
                style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: textColor, fontFamily: 'Tajawal'),
              ),
              const SizedBox(height: 4),
              Container(
                decoration: BoxDecoration(
                  color: inputFill,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: borderColor),
                ),
                child: TextFormField(
                  controller: _bioController,
                  maxLines: 3,
                  style: TextStyle(fontSize: 12, fontFamily: 'Tajawal', color: textColor),
                  decoration: InputDecoration(
                    hintText: context.loc.teachBioHint,
                    hintStyle: TextStyle(fontSize: 11, color: AppColors.textMuted, fontFamily: 'Tajawal'),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(12),
                  ),
                  validator: (v) => (v == null || v.trim().length < 20) ? 'يرجى كتابة نبذة لا تقل عن 20 حرفاً' : null,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Next Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _nextStep,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(vertical: 12),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(context.loc.teachNextStepSkills, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, fontFamily: 'Tajawal')),
                  const SizedBox(width: 6),
                  Icon(
                    Directionality.of(context) == TextDirection.rtl
                        ? Icons.arrow_back_rounded
                        : Icons.arrow_forward_rounded,
                    size: 16,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Step 2 Widget
  Widget _buildStepTwo(Color cardBg, Color inputFill, Color borderColor, Color textColor, Color textSubColor, bool isDark) {
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
            context.loc.teachStep2Header,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: textColor, fontFamily: 'Tajawal'),
          ),
          const SizedBox(height: 14),

          _buildInputField(
            controller: _topicController,
            label: context.loc.teachTopicLabel,
            hint: context.loc.teachTopicHint,
            icon: Icons.topic_outlined,
            inputFill: inputFill,
            borderColor: borderColor,
            textColor: textColor,
          ),
          const SizedBox(height: 12),

          _buildInputField(
            controller: _yearsOfExperienceController,
            label: context.loc.teachYearsExperienceLabel,
            hint: '8',
            icon: Icons.history_edu_rounded,
            keyboardType: TextInputType.number,
            isLtr: true,
            inputFill: inputFill,
            borderColor: borderColor,
            textColor: textColor,
          ),
          const SizedBox(height: 12),

          _buildInputField(
            controller: _sampleVideoLinkController,
            label: context.loc.teachVideoLinkLabel,
            hint: 'https://...',
            icon: Icons.video_library_outlined,
            keyboardType: TextInputType.url,
            isLtr: true,
            inputFill: inputFill,
            borderColor: borderColor,
            textColor: textColor,
          ),
          const SizedBox(height: 12),

          // Target Audience Dropdown
          Text(context.loc.teachTargetAudienceLabel, style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: textColor, fontFamily: 'Tajawal')),
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
                value: _targetAudience,
                isExpanded: true,
                dropdownColor: cardBg,
                items: ['مبتدئين تماماً', 'مبتدئين ومتوسطين', 'مطورين متقدمين ومحترفين', 'الجميع']
                    .map((val) => DropdownMenuItem(value: val, child: Text(val, style: TextStyle(fontSize: 12, fontFamily: 'Tajawal', color: textColor))))
                    .toList(),
                onChanged: (val) => setState(() => _targetAudience = val!),
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Skills Chips Input
          Text(context.loc.teachSkillsCoveredLabel, style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: textColor, fontFamily: 'Tajawal')),
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
                    controller: _skillInputController,
                    style: TextStyle(fontSize: 12, fontFamily: 'Tajawal', color: textColor),
                    decoration: InputDecoration(
                      hintText: context.loc.teachAddSkillHint,
                      hintStyle: TextStyle(fontSize: 11, color: AppColors.textMuted, fontFamily: 'Tajawal'),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                    onSubmitted: (_) => _addSkill(),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: _addSkill,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  elevation: 0,
                ),
                child: Text(context.loc.teachAddSkillBtn, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'Tajawal')),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Chips List
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: _skillsList.map((skill) {
              return Chip(
                label: Text(skill, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, fontFamily: 'Inter', color: AppColors.primary)),
                backgroundColor: const Color(0xFFEFF4FF),
                deleteIcon: const Icon(Icons.close_rounded, size: 14, color: AppColors.primary),
                onDeleted: () => _removeSkill(skill),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide.none),
              );
            }).toList(),
          ),

          const SizedBox(height: 20),

          // Navigation Row
          Row(
            children: [
              OutlinedButton(
                onPressed: _prevStep,
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                child: Text(context.loc.teachPrevStepBtn, style: TextStyle(fontFamily: 'Tajawal', fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: _nextStep,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(context.loc.teachNextStepConfirm, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, fontFamily: 'Tajawal')),
                      const SizedBox(width: 6),
                      Icon(
                        Directionality.of(context) == TextDirection.rtl
                            ? Icons.arrow_back_rounded
                            : Icons.arrow_forward_rounded,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Step 3 Widget
  Widget _buildStepThree(Color cardBg, Color inputFill, Color borderColor, Color textColor, Color textSubColor, bool isDark) {
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
            context.loc.teachStep3Header,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: textColor, fontFamily: 'Tajawal'),
          ),
          const SizedBox(height: 14),

          // Payout Method Dropdown
          Text(context.loc.teachPayoutMethodLabel, style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: textColor, fontFamily: 'Tajawal')),
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
                value: _preferredPayoutMethod,
                isExpanded: true,
                dropdownColor: cardBg,
                items: ['تحويل بنكي مباشر (IBAN)', 'حساب PayPal معتمد', 'بطاقة Payoneer']
                    .map((val) => DropdownMenuItem(value: val, child: Text(val, style: TextStyle(fontSize: 12, fontFamily: 'Tajawal', color: textColor))))
                    .toList(),
                onChanged: (val) => setState(() => _preferredPayoutMethod = val!),
              ),
            ),
          ),
          const SizedBox(height: 12),

          _buildInputField(
            controller: _payoutDetailsController,
            label: context.loc.teachIbanDetailsLabel,
            hint: 'SA0380000000000000000000',
            icon: Icons.account_balance_rounded,
            isLtr: true,
            inputFill: inputFill,
            borderColor: borderColor,
            textColor: textColor,
          ),
          const SizedBox(height: 14),

          // Application Summary Box
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurfaceMuted : const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(context.loc.teachApplicationSummary, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: textColor, fontFamily: 'Tajawal')),
                const SizedBox(height: 4),
                Text('• ${context.loc.teachApplicantName}: ${_nameController.text}', style: TextStyle(fontSize: 11, color: textSubColor, fontFamily: 'Tajawal')),
                Text('• ${context.loc.teachApplicantHeadline}: ${_headlineController.text}', style: TextStyle(fontSize: 11, color: textSubColor, fontFamily: 'Tajawal')),
                Text('• ${context.loc.teachApplicantTopic}: ${_topicController.text}', style: TextStyle(fontSize: 11, color: textSubColor, fontFamily: 'Tajawal')),
                Text('• ${context.loc.teachApplicantSkillsCount}: ${_skillsList.length} ${context.loc.teachSkillsUnit}', style: TextStyle(fontSize: 11, color: textSubColor, fontFamily: 'Tajawal')),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Agree to Terms Checkbox
          CheckboxListTile(
            value: _agreeTerms,
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
            activeColor: AppColors.primary,
            title: Text(
              context.loc.teachAgreeTermsLabel,
              style: TextStyle(fontSize: 11.5, color: textColor, fontFamily: 'Tajawal', height: 1.3),
            ),
            onChanged: (val) => setState(() => _agreeTerms = val ?? false),
          ),

          const SizedBox(height: 16),

          // Submit / Prev Buttons
          Row(
            children: [
              OutlinedButton(
                onPressed: _prevStep,
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                child: Text(context.loc.teachPrevStepBtn, style: TextStyle(fontFamily: 'Tajawal', fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: AppButton(
                  height: 48,
                  label: 'إرسال طلب الانضمام كمدرب',
                  loadingLabel: 'جاري الإرسال',
                  isLoading: _isSubmitting,
                  icon: const Icon(Icons.send_rounded, size: 16, color: Colors.white),
                  onPressed: _submitApplication,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ================= 4. VALUE PROPS =================
  Widget _buildValueProps(Color cardBg, Color borderColor, Color textColor, Color textSubColor) {
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
              fontWeight: FontWeight.bold,
              color: textColor,
              fontFamily: 'Tajawal',
            ),
          ),
          const SizedBox(height: 12),

          _buildPropItem(Icons.monetization_on_outlined, context.loc.teachProp1Title, context.loc.teachProp1Desc, textColor, textSubColor),
          const SizedBox(height: 10),
          _buildPropItem(Icons.public_rounded, context.loc.teachProp2Title, context.loc.teachProp2Desc, textColor, textSubColor),
          const SizedBox(height: 10),
          _buildPropItem(Icons.support_agent_rounded, context.loc.teachProp3Title, context.loc.teachProp3Desc, textColor, textSubColor),
        ],
      ),
    );
  }

  Widget _buildPropItem(IconData icon, String title, String subtitle, Color textColor, Color textSubColor) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.primary, size: 20),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: textColor, fontFamily: 'Tajawal')),
              const SizedBox(height: 2),
              Text(subtitle, style: TextStyle(fontSize: 10.5, color: textSubColor, fontFamily: 'Tajawal')),
            ],
          ),
        ),
      ],
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
          style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: textColor, fontFamily: 'Tajawal'),
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
            keyboardType: keyboardType,
            validator: validator,
            textDirection: isLtr ? TextDirection.ltr : (isAppRtl ? TextDirection.rtl : TextDirection.ltr),
            textAlign: isLtr ? (isAppRtl ? TextAlign.left : TextAlign.start) : TextAlign.start,
            style: TextStyle(fontSize: 12, fontFamily: isLtr ? 'Inter' : 'Tajawal', color: textColor),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(fontSize: 11, color: AppColors.textMuted, fontFamily: isLtr ? 'Inter' : 'Tajawal'),
              prefixIcon: Icon(icon, size: 18, color: AppColors.textSecondary),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
          ),
        ),
      ],
    );
  }
}

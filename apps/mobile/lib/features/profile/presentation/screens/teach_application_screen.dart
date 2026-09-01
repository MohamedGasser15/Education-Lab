import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile/core/services/auth_storage_service.dart';
import 'package:mobile/core/theme/app_colors.dart';

class TeachApplicationScreen extends StatefulWidget {
  const TeachApplicationScreen({super.key});

  @override
  State<TeachApplicationScreen> createState() => _TeachApplicationScreenState();
}

class _TeachApplicationScreenState extends State<TeachApplicationScreen> {
  int _currentStep = 1; // 1: Personal, 2: Experience, 3: Review
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _fullNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _bioController;
  final TextEditingController _skillInputController = TextEditingController();

  String _selectedSpecialization = 'تطوير تطبيقات الموبايل (Flutter & Native)';
  String _selectedExperience = 'من 2 إلى 5 سنوات (متوسط الخبرة)';
  final List<String> _skillsList = ['Flutter', 'Dart', 'Clean Architecture', 'REST APIs', 'UI/UX'];
  String _cvFileName = 'Mohamed_Nasser_CV.pdf';
  bool _agreeTerms = true;
  bool _isSubmitting = false;

  final List<String> _specializations = [
    'تطوير تطبيقات الموبايل (Flutter & Native)',
    'تطوير الويب المتكامل (Full-Stack Web Dev)',
    'الذكاء الاصطناعي وتعلم الآلة (AI & Machine Learning)',
    'تصميم واجهات وتجربة المستخدم (UI/UX Design)',
    'علوم البيانات والتحليلات (Data Science)',
    'الأمن السيبراني والشبكات (Cybersecurity)',
    'إدارة الأعمال والريادة (Business & Management)',
  ];

  final List<String> _experienceLevels = [
    'أقل من سنتين (مبتدئ في التدريب)',
    'من 2 إلى 5 سنوات (متوسط الخبرة)',
    'من 5 إلى 10 سنوات (خبير متقدم)',
    'أكثر من 10 سنوات (استشاري أول)',
  ];

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController(text: 'محمد ناصر');
    _emailController = TextEditingController(text: 'mohamed.nasser@example.com');
    _phoneController = TextEditingController(text: '+966 50 123 4567');
    _bioController = TextEditingController(
      text: 'مهندس برمجيات متخصص في بناء وتطوير تطبيقات الموبايل ولدي شغف كبير بنقل الخبرات وإعداد كوادر برمجية متميزة.',
    );

    _bioController.addListener(() => setState(() {}));
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = await AuthStorageService.getUser();
    if (user != null && mounted) {
      setState(() {
        if (user['fullName'] != null && user['fullName'].toString().isNotEmpty) {
          _fullNameController.text = user['fullName'].toString();
        }
        if (user['email'] != null && user['email'].toString().isNotEmpty) {
          _emailController.text = user['email'].toString();
        }
      });
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _bioController.dispose();
    _skillInputController.dispose();
    super.dispose();
  }

  void _addSkill() {
    final text = _skillInputController.text.trim();
    if (text.isNotEmpty && !_skillsList.contains(text)) {
      HapticFeedback.lightImpact();
      setState(() {
        _skillsList.add(text);
        _skillInputController.clear();
      });
    }
  }

  void _removeSkill(String skill) {
    HapticFeedback.lightImpact();
    setState(() {
      _skillsList.remove(skill);
    });
  }

  void _showSpecializationPicker() {
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFE2E8F0),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'اختر مجال التخصص الرئيسي',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Tajawal',
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  children: _specializations.map((spec) {
                    final isSelected = _selectedSpecialization == spec;
                    return ListTile(
                      title: Text(
                        spec,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected ? AppColors.primary : AppColors.textPrimary,
                          fontFamily: 'Tajawal',
                        ),
                      ),
                      trailing: isSelected
                          ? const Icon(Icons.check_circle_rounded, color: AppColors.primary, size: 20)
                          : null,
                      onTap: () {
                        setState(() => _selectedSpecialization = spec);
                        Navigator.pop(ctx);
                      },
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showExperiencePicker() {
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFE2E8F0),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'سنوات الخبرة في التدريب والعمل',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Tajawal',
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              ..._experienceLevels.map((exp) {
                final isSelected = _selectedExperience == exp;
                return ListTile(
                  title: Text(
                    exp,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? AppColors.primary : AppColors.textPrimary,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                  trailing: isSelected
                      ? const Icon(Icons.check_circle_rounded, color: AppColors.primary, size: 20)
                      : null,
                  onTap: () {
                    setState(() => _selectedExperience = exp);
                    Navigator.pop(ctx);
                  },
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  void _nextStep() {
    if (_currentStep == 1) {
      if (!_formKey.currentState!.validate()) return;
      HapticFeedback.lightImpact();
      setState(() => _currentStep = 2);
    } else if (_currentStep == 2) {
      if (_skillsList.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('يرجى إضافة مهارة واحدة على الأقل'), behavior: SnackBarBehavior.floating),
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
        const SnackBar(content: Text('يرجى الموافقة على شروط واتفاقية التدريس'), behavior: SnackBarBehavior.floating),
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
              width: 60,
              height: 60,
              decoration: const BoxDecoration(
                color: Color(0xFFECFDF5),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle_rounded,
                color: Color(0xFF059669),
                size: 36,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'تم استلام طلبك بنجاح',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w900,
                color: AppColors.textPrimary,
                fontFamily: 'Tajawal',
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'شكراً لاهتمامك بالانضمام إلى فريق مدربي EduLab. سيقوم الفريق الأكاديمي بمراجعة طلبك والتواصل معك عبر البريد الإلكتروني خلال 48 ساعة.',
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
                child: const Text(
                  'حسناً',
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
          'التدريس في EduLab',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w900,
            color: AppColors.textPrimary,
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
            _buildIntroHeader(),

            const SizedBox(height: 18),

            // 2. Stepper Progress
            _buildStepper(),

            const SizedBox(height: 20),

            // 3. Step Content
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 240),
              child: _buildStepContent(),
            ),

            const SizedBox(height: 24),

            // 4. Value Props
            _buildValueProps(),
          ],
        ),
      ),
    );
  }

  // ================= 1. INTRO HEADER =================
  Widget _buildIntroHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
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
              children: const [
                Text(
                  'انضم كمدرب معتمد',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textPrimary,
                    fontFamily: 'Tajawal',
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'انشر دوراتك وشارك خبراتك مع آلاف الطلاب حول العالم.',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
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
  Widget _buildStepper() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          _buildStepItem(1, 'البيانات الشخصية'),
          _buildStepDivider(1),
          _buildStepItem(2, 'الخبرات والمهارات'),
          _buildStepDivider(2),
          _buildStepItem(3, 'تأكيد الطلب'),
        ],
      ),
    );
  }

  Widget _buildStepItem(int step, String title) {
    final isDone = _currentStep > step;
    final isActive = _currentStep == step;

    Color circleColor = const Color(0xFFF1F5F9);
    Color textColor = const Color(0xFF64748B);
    Color border = const Color(0xFFE2E8F0);

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
                  : (isDone ? const Color(0xFF059669) : AppColors.textSecondary),
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

  Widget _buildStepDivider(int step) {
    final isPassed = _currentStep > step;
    return Container(
      width: 24,
      height: 2,
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: isPassed ? const Color(0xFF059669) : const Color(0xFFE2E8F0),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  // ================= 3. STEP CONTENT =================
  Widget _buildStepContent() {
    switch (_currentStep) {
      case 1:
        return _buildStep1();
      case 2:
        return _buildStep2();
      case 3:
      default:
        return _buildStep3();
    }
  }

  // ---------- STEP 1 ----------
  Widget _buildStep1() {
    return Container(
      key: const ValueKey(1),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('المعلومات الشخصية وبيانات التواصل'),
          const SizedBox(height: 14),

          _buildInputField(
            controller: _fullNameController,
            label: 'الاسم الكامل',
            hint: 'أدخل اسمك كاملاً',
            icon: Icons.person_outline_rounded,
            validator: (v) => (v == null || v.trim().length < 3) ? 'يرجى إدخال الاسم كاملاً' : null,
          ),
          const SizedBox(height: 12),

          _buildInputField(
            controller: _emailController,
            label: 'البريد الإلكتروني المعتمد',
            hint: 'your.email@example.com',
            icon: Icons.email_outlined,
            isReadOnly: true,
          ),
          const SizedBox(height: 12),

          _buildInputField(
            controller: _phoneController,
            label: 'رقم الهاتف الجوال',
            hint: '+966 50 123 4567',
            icon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
            validator: (v) => (v == null || v.trim().isEmpty) ? 'يرجى إدخال رقم الهاتف' : null,
          ),
          const SizedBox(height: 12),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'نبذة مهنية عنك',
                    style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: AppColors.textPrimary, fontFamily: 'Tajawal'),
                  ),
                  Text(
                    '${_bioController.text.length} / 200',
                    style: const TextStyle(fontSize: 10, color: AppColors.textSecondary, fontFamily: 'Inter'),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.border),
                ),
                child: TextFormField(
                  controller: _bioController,
                  maxLines: 3,
                  maxLength: 200,
                  validator: (v) => (v == null || v.trim().length < 10) ? 'يرجى كتابة نبذة مهنية' : null,
                  style: const TextStyle(fontSize: 12, fontFamily: 'Tajawal'),
                  decoration: const InputDecoration(
                    hintText: 'اكتب نبذة عن مجالك وخبراتك التدريبية...',
                    hintStyle: TextStyle(fontSize: 11, color: AppColors.textMuted, fontFamily: 'Tajawal'),
                    prefixIcon: Icon(Icons.edit_note_outlined, size: 20, color: AppColors.textSecondary),
                    border: InputBorder.none,
                    counterText: '',
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _nextStep,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(vertical: 13),
                elevation: 0,
              ),
              child: const Text(
                'متابعة إلى الخبرات والمهارات',
                style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, fontFamily: 'Tajawal'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------- STEP 2 ----------
  Widget _buildStep2() {
    return Container(
      key: const ValueKey(2),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('التخصص والخبرات العملية والمهارات'),
          const SizedBox(height: 14),

          const Text(
            'مجال التخصص الرئيسي',
            style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: AppColors.textPrimary, fontFamily: 'Tajawal'),
          ),
          const SizedBox(height: 5),
          InkWell(
            onTap: _showSpecializationPicker,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  const Icon(Icons.category_outlined, size: 18, color: AppColors.textSecondary),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      _selectedSpecialization,
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimary, fontFamily: 'Tajawal'),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.textSecondary),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          const Text(
            'سنوات الخبرة العملية',
            style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: AppColors.textPrimary, fontFamily: 'Tajawal'),
          ),
          const SizedBox(height: 5),
          InkWell(
            onTap: _showExperiencePicker,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  const Icon(Icons.timeline_rounded, size: 18, color: AppColors.textSecondary),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      _selectedExperience,
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimary, fontFamily: 'Tajawal'),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.textSecondary),
                ],
              ),
            ),
          ),

          const SizedBox(height: 14),

          const Text(
            'المهارات والتقنيات',
            style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: AppColors.textPrimary, fontFamily: 'Tajawal'),
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: _skillsList.map((skill) {
              return Chip(
                label: Text(skill, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primary, fontFamily: 'Tajawal')),
                backgroundColor: const Color(0xFFEFF6FF),
                side: const BorderSide(color: Color(0xFFDBEAFE)),
                deleteIcon: const Icon(Icons.close_rounded, size: 13, color: AppColors.primary),
                onDeleted: () => _removeSkill(skill),
              );
            }).toList(),
          ),

          const SizedBox(height: 8),

          Row(
            children: [
              Expanded(
                child: Container(
                  height: 42,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(9),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: TextField(
                    controller: _skillInputController,
                    style: const TextStyle(fontSize: 11.5, fontFamily: 'Tajawal'),
                    onSubmitted: (_) => _addSkill(),
                    decoration: const InputDecoration(
                      hintText: 'أضف مهارة جديدة (مثلاً: Flutter, Git)...',
                      hintStyle: TextStyle(fontSize: 10.5, color: AppColors.textMuted, fontFamily: 'Tajawal'),
                      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: _addSkill,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  elevation: 0,
                ),
                child: const Text('إضافة', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, fontFamily: 'Tajawal')),
              ),
            ],
          ),

          const SizedBox(height: 14),

          const Text(
            'السيرة الذاتية (CV / Portfolio PDF)',
            style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: AppColors.textPrimary, fontFamily: 'Tajawal'),
          ),
          const SizedBox(height: 5),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFCBD5E1)),
            ),
            child: Row(
              children: [
                const Icon(Icons.description_outlined, color: Color(0xFFDC2626), size: 24),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    _cvFileName,
                    style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, fontFamily: 'Tajawal'),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() => _cvFileName = 'Mohamed_Nasser_Updated_CV.pdf');
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('تم اختيار ملف السيرة الذاتية بنجاح'), behavior: SnackBarBehavior.floating),
                    );
                  },
                  child: const Text('تغيير الملف', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, fontFamily: 'Tajawal')),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _prevStep,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text('السابق', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, fontFamily: 'Tajawal')),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: _nextStep,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    elevation: 0,
                  ),
                  child: const Text('مراجعة الطلب', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, fontFamily: 'Tajawal')),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ---------- STEP 3 ----------
  Widget _buildStep3() {
    return Container(
      key: const ValueKey(3),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('مراجعة وتأكيد بيانات الطلب'),
          const SizedBox(height: 12),

          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFDBEAFE)),
            ),
            child: Row(
              children: const [
                Icon(Icons.info_outline_rounded, color: Color(0xFF2563EB), size: 18),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'سيقوم الفريق الأكاديمي بمراجعة طلبك خلال 48 ساعة والتواصل معك عبر البريد الإلكتروني.',
                    style: TextStyle(fontSize: 11, color: Color(0xFF1E40AF), fontFamily: 'Tajawal', height: 1.35),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                _buildReviewRow('الاسم الكامل:', _fullNameController.text),
                const Divider(height: 12, color: Color(0xFFE2E8F0)),
                _buildReviewRow('البريد الإلكتروني:', _emailController.text),
                const Divider(height: 12, color: Color(0xFFE2E8F0)),
                _buildReviewRow('رقم الهاتف:', _phoneController.text),
                const Divider(height: 12, color: Color(0xFFE2E8F0)),
                _buildReviewRow('مجال التخصص:', _selectedSpecialization),
                const Divider(height: 12, color: Color(0xFFE2E8F0)),
                _buildReviewRow('سنوات الخبرة:', _selectedExperience),
                const Divider(height: 12, color: Color(0xFFE2E8F0)),
                _buildReviewRow('المهارات:', _skillsList.join(' • ')),
              ],
            ),
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Checkbox(
                value: _agreeTerms,
                activeColor: AppColors.primary,
                onChanged: (val) => setState(() => _agreeTerms = val!),
              ),
              const Expanded(
                child: Text(
                  'أوافق على اتفاقية وشروط التدريس في منصة EduLab',
                  style: TextStyle(fontSize: 11, color: AppColors.textPrimary, fontFamily: 'Tajawal'),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _prevStep,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text('السابق', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, fontFamily: 'Tajawal')),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitApplication,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF059669),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    elevation: 0,
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : const Text(
                          'إرسال طلب التدريس',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, fontFamily: 'Tajawal'),
                        ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 14,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, color: AppColors.textPrimary, fontFamily: 'Tajawal'),
        ),
      ],
    );
  }

  Widget _buildReviewRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 85,
          child: Text(
            label,
            style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: AppColors.textSecondary, fontFamily: 'Tajawal'),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textPrimary, fontFamily: 'Tajawal'),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  // ================= 4. VALUE PROPS =================
  Widget _buildValueProps() {
    return Column(
      children: [
        _buildPropCard(
          icon: Icons.groups_outlined,
          iconColor: const Color(0xFF2563EB),
          bgColor: const Color(0xFFEFF6FF),
          title: 'مجتمع طلابي متفاعل',
          desc: 'انشر دوراتك لآلاف الطلاب والباحثين عن المعرفة.',
        ),
        const SizedBox(height: 8),
        _buildPropCard(
          icon: Icons.trending_up_rounded,
          iconColor: const Color(0xFF059669),
          bgColor: const Color(0xFFECFDF5),
          title: 'عوائد مالية متنامية',
          desc: 'حقق دخلاً مستمراً من تسجيلات الطلاب في دوراتك.',
        ),
      ],
    );
  }

  Widget _buildPropCard({
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    required String title,
    required String desc,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimary, fontFamily: 'Tajawal'),
                ),
                const SizedBox(height: 1),
                Text(
                  desc,
                  style: const TextStyle(fontSize: 10, color: AppColors.textSecondary, fontFamily: 'Tajawal'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool isReadOnly = false,
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
        const SizedBox(height: 4),
        Container(
          decoration: BoxDecoration(
            color: isReadOnly ? const Color(0xFFF1F5F9) : const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.border),
          ),
          child: TextFormField(
            controller: controller,
            readOnly: isReadOnly,
            keyboardType: keyboardType,
            validator: validator,
            style: const TextStyle(fontSize: 12, fontFamily: 'Tajawal'),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(fontSize: 11, color: AppColors.textMuted, fontFamily: 'Tajawal'),
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

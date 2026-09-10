import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile/core/services/api_client.dart';
import 'package:mobile/features/home/data/models/home_models.dart';
import 'package:mobile/features/home/data/services/home_api_service.dart';
import 'package:mobile/features/profile/data/models/instructor_application_models.dart';
import 'package:mobile/features/profile/data/models/user_profile_model.dart';
import 'package:mobile/features/profile/data/services/instructor_application_api_service.dart';

class TeachApplicationProvider extends ChangeNotifier {
  final InstructorApplicationApiService _apiService;
  final HomeApiService _homeApiService;

  TeachApplicationProvider({
    InstructorApplicationApiService? apiService,
    HomeApiService? homeApiService,
  })  : _apiService = apiService ?? InstructorApplicationApiService(),
        _homeApiService = homeApiService ?? HomeApiService();

  // State
  bool _isLoading = true;
  bool _isRefreshing = false;
  bool _isSubmitting = false;
  String? _errorMessage;

  List<InstructorApplicationResponseDto> _myApplications = [];
  List<HomeCategoryDTO> _categories = [];
  bool _categoriesLoading = false;

  // Wizard Step (1: Personal, 2: Experience & Skills, 3: Review & Submit)
  int _currentStep = 1;

  // Form Fields & Controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final TextEditingController skillInputController = TextEditingController();

  String? _specialization;
  String _experience = '0-2';
  final List<String> _skills = [];
  XFile? _profileImage;
  XFile? _cvFile;
  bool _agreeTerms = false;

  bool _initialized = false;

  // Getters
  bool get isLoading => _isLoading;
  bool get isRefreshing => _isRefreshing;
  bool get isSubmitting => _isSubmitting;
  String? get errorMessage => _errorMessage;
  List<InstructorApplicationResponseDto> get myApplications => _myApplications;
  List<HomeCategoryDTO> get categories => _categories;
  bool get categoriesLoading => _categoriesLoading;

  int get currentStep => _currentStep;
  String? get specialization => _specialization;
  String get experience => _experience;
  List<String> get skills => List.unmodifiable(_skills);
  XFile? get profileImage => _profileImage;
  XFile? get cvFile => _cvFile;
  bool get agreeTerms => _agreeTerms;

  bool _isReapplying = false;
  bool get isReapplying => _isReapplying;

  InstructorApplicationResponseDto? get activeApplication {
    if (_myApplications.isEmpty) return null;
    try {
      return _myApplications.firstWhere((a) => a.isPending || a.isApproved);
    } catch (_) {
      return _myApplications.first;
    }
  }

  bool get shouldShowStatusView {
    if (_isReapplying) return false;
    return _myApplications.isNotEmpty;
  }

  bool get hasActiveApplication => shouldShowStatusView;

  InstructorApplicationResponseDto? get latestApplication {
    return _myApplications.isNotEmpty ? _myApplications.first : null;
  }

  /// Initialize state and prefill data from user profile
  Future<void> initialize(UserProfileModel? profile) async {
    if (!_initialized) {
      if (profile != null) {
        if (nameController.text.isEmpty && profile.fullName.isNotEmpty) {
          nameController.text = profile.fullName;
        }
        if (emailController.text.isEmpty && profile.email.isNotEmpty) {
          emailController.text = profile.email;
        }
        if (phoneController.text.isEmpty && profile.phoneNumber != null) {
          phoneController.text = profile.phoneNumber!;
        }
        if (bioController.text.isEmpty && profile.about != null) {
          bioController.text = profile.about!;
        }
      }
      _initialized = true;
    }

    _isLoading = true;
    notifyListeners();

    await Future.wait([
      fetchMyApplications(),
      loadCategories(),
    ]);

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchMyApplications({bool isRefresh = false}) async {
    if (isRefresh) {
      _isRefreshing = true;
      notifyListeners();
    }
    try {
      final result = await _apiService.getMyApplications();
      if (result is Success<List<InstructorApplicationResponseDto>>) {
        _myApplications = result.data;
        _myApplications.sort((a, b) {
          if (a.appliedDate == null) return 1;
          if (b.appliedDate == null) return -1;
          return b.appliedDate!.compareTo(a.appliedDate!);
        });
      }
    } finally {
      if (isRefresh) {
        _isRefreshing = false;
        notifyListeners();
      }
    }
  }

  Future<void> loadCategories() async {
    if (_categories.isNotEmpty) return;
    _categoriesLoading = true;
    final result = await _homeApiService.getCategories(count: 50);
    if (result is Success<List<HomeCategoryDTO>>) {
      _categories = result.data;
      if (_specialization == null && _categories.isNotEmpty) {
        _specialization = _categories.first.name;
      }
    }
    _categoriesLoading = false;
  }

  void setSpecialization(String val) {
    _specialization = val;
    notifyListeners();
  }

  void setExperience(String val) {
    _experience = val;
    notifyListeners();
  }

  void setProfileImage(XFile? file) {
    _profileImage = file;
    notifyListeners();
  }

  void setCvFile(XFile? file) {
    _cvFile = file;
    notifyListeners();
  }

  void setAgreeTerms(bool val) {
    _agreeTerms = val;
    notifyListeners();
  }

  void addSkill(String skill) {
    final trimmed = skill.trim();
    if (trimmed.isNotEmpty && !_skills.contains(trimmed)) {
      _skills.add(trimmed);
      skillInputController.clear();
      notifyListeners();
    }
  }

  void removeSkill(String skill) {
    _skills.remove(skill);
    notifyListeners();
  }

  void nextStep() {
    if (_currentStep < 3) {
      _currentStep++;
      notifyListeners();
    }
  }

  void prevStep() {
    if (_currentStep > 1) {
      _currentStep--;
      notifyListeners();
    }
  }

  void goToStep(int step) {
    if (step >= 1 && step <= 3) {
      _currentStep = step;
      notifyListeners();
    }
  }

  void resetFormForNewApplication() {
    _isReapplying = true;
    _currentStep = 1;
    _skills.clear();
    _profileImage = null;
    _cvFile = null;
    _agreeTerms = false;
    _errorMessage = null;
    notifyListeners();
  }

  Future<Result<String>> submit() async {
    _isSubmitting = true;
    _errorMessage = null;
    notifyListeners();

    final spec = _specialization ?? (_categories.isNotEmpty ? _categories.first.name : 'عام');

    final dto = InstructorApplicationDTO(
      fullName: nameController.text.trim(),
      email: emailController.text.trim().isNotEmpty ? emailController.text.trim() : null,
      phone: phoneController.text.trim(),
      bio: bioController.text.trim(),
      specialization: spec,
      experience: _experience,
      skills: _skills,
      profileImage: _profileImage,
      cvFile: _cvFile,
    );

    final result = await _apiService.submitApplication(dto);

    if (result is Success<String>) {
      _isReapplying = false;
      await fetchMyApplications();
    } else if (result is Failure<String>) {
      _errorMessage = result.message;
    }

    _isSubmitting = false;
    notifyListeners();
    return result;
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    bioController.dispose();
    skillInputController.dispose();
    super.dispose();
  }
}

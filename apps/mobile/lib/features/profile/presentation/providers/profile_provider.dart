import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile/core/services/api_client.dart';
import 'package:mobile/core/services/auth_storage_service.dart';
import 'package:mobile/features/profile/data/models/user_profile_model.dart';
import 'package:mobile/features/profile/data/repositories/profile_repository.dart';

class ProfileProvider extends ChangeNotifier {
  final ProfileRepository _repository;

  ProfileProvider({ProfileRepository? repository})
      : _repository = repository ?? ProfileRepository() {
    init();
  }

  UserProfileModel? _profile;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isLoggedIn = false;

  UserProfileModel? get profile => _profile;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isLoggedIn => _isLoggedIn;
  bool get hasProfile => _profile != null;

  Future<void> init() async {
    _isLoggedIn = await AuthStorageService.isLoggedIn();
    if (_isLoggedIn) {
      await fetchProfile(forceRefresh: true);
    }
  }

  Future<void> fetchProfile({bool forceRefresh = false}) async {
    _isLoggedIn = await AuthStorageService.isLoggedIn();
    if (!_isLoggedIn) {
      _isLoading = false;
      _profile = null;
      notifyListeners();
      return;
    }

    if (_profile == null || forceRefresh) {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();
    }

    final result = await _repository.fetchRemoteProfile();

    if (result is Success<UserProfileModel>) {
      _profile = result.data;
      _errorMessage = null;
    } else if (result is Failure<UserProfileModel>) {
      _errorMessage = result.message;
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Updates profile via PUT /api/Profile and syncs state
  Future<Result<bool>> saveProfile(UserProfileModel updated) async {
    final result = await _repository.updateProfile(updated);
    if (result is Success<bool>) {
      _profile = updated;
      notifyListeners();
    }
    return result;
  }

  /// Uploads avatar image via POST /api/Profile/upload-image and syncs state
  Future<Result<String>> uploadAvatar(XFile file) async {
    final userId = _profile?.id ?? await AuthStorageService.getUserId() ?? '';
    if (userId.isEmpty) {
      return const Failure('معرف المستخدم غير متوفر');
    }

    final result = await _repository.uploadProfileImage(
      userId: userId,
      imageFile: file,
    );

    if (result is Success<String>) {
      if (_profile != null) {
        _profile = _profile!.copyWith(profileImageUrl: result.data);
      }
      notifyListeners();
    }
    return result;
  }

  void updateProfileLocally(UserProfileModel updated) {
    _profile = updated;
    notifyListeners();
  }

  Future<void> logout() async {
    await AuthStorageService.logout();
    _profile = null;
    _isLoggedIn = false;
    _errorMessage = null;
    _isLoading = false;
    notifyListeners();
  }
}

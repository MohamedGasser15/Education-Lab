import 'package:image_picker/image_picker.dart';
import 'package:mobile/core/services/api_client.dart';
import 'package:mobile/core/services/auth_storage_service.dart';
import 'package:mobile/features/profile/data/models/user_profile_model.dart';
import 'package:mobile/features/profile/data/services/profile_api_service.dart';

class ProfileRepository {
  final ProfileApiService _apiService;

  ProfileRepository({ProfileApiService? apiService})
      : _apiService = apiService ?? ProfileApiService();

  Future<UserProfileModel?> getCachedProfile() async {
    final cached = await AuthStorageService.getUser();
    if (cached != null) {
      try {
        return UserProfileModel.fromJson(cached);
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  Future<Result<UserProfileModel>> fetchRemoteProfile() async {
    final result = await _apiService.getProfile();
    if (result is Success<UserProfileModel>) {
      await _cacheProfile(result.data);
    }
    return result;
  }

  Future<Result<bool>> updateProfile(UserProfileModel profile) async {
    final result = await _apiService.updateProfile(profile);
    if (result is Success<bool>) {
      await _cacheProfile(profile);
    }
    return result;
  }

  Future<Result<String>> uploadProfileImage({
    required String userId,
    required XFile imageFile,
  }) async {
    final result = await _apiService.uploadProfileImage(
      userId: userId,
      imageFile: imageFile,
    );
    if (result is Success<String>) {
      final cached = await getCachedProfile();
      if (cached != null) {
        final updated = cached.copyWith(profileImageUrl: result.data);
        await _cacheProfile(updated);
      }
    }
    return result;
  }

  Future<void> _cacheProfile(UserProfileModel profile) async {
    try {
      final token = await AuthStorageService.getAccessToken() ?? '';
      final refresh = await AuthStorageService.getRefreshToken() ?? '';
      if (token.isNotEmpty) {
        await AuthStorageService.saveAuth(
          accessToken: token,
          refreshToken: refresh,
          user: profile.toJson(),
        );
      }
    } catch (_) {}
  }
}

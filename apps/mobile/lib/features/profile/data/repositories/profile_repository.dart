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
        final profile = UserProfileModel.fromJson(cached);
        return await _enrichProfileWithRoles(profile);
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  Future<Result<UserProfileModel>> fetchRemoteProfile() async {
    final result = await _apiService.getProfile();
    if (result is Success<UserProfileModel>) {
      final enriched = await _enrichProfileWithRoles(result.data);
      await _cacheProfile(enriched);
      return Success(enriched);
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

  Future<UserProfileModel> _enrichProfileWithRoles(UserProfileModel profile) async {
    final rolesSet = <String>{...profile.roles};
    final claimsSet = <String>{...profile.claims};

    final cached = await AuthStorageService.getUser();
    if (cached != null) {
      final cachedModel = UserProfileModel.fromJson(cached);
      rolesSet.addAll(cachedModel.roles);
      claimsSet.addAll(cachedModel.claims);
    }

    final token = await AuthStorageService.getAccessToken();
    if (token != null && token.isNotEmpty) {
      final jwtData = AuthStorageService.extractRolesAndClaimsFromJwt(token);
      final jwtRoles = jwtData['roles'] ?? [];
      final jwtClaims = jwtData['claims'] ?? [];
      rolesSet.addAll(jwtRoles);
      claimsSet.addAll(jwtClaims);
    }

    if (rolesSet.isEmpty) {
      rolesSet.add('Student');
    }

    return profile.copyWith(
      roles: rolesSet.toList(),
      claims: claimsSet.toList(),
    );
  }
}


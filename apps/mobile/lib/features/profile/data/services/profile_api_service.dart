import 'dart:convert';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile/core/constants/api_constants.dart';
import 'package:mobile/core/services/api_client.dart';
import 'package:mobile/features/profile/data/models/user_profile_model.dart';

class ProfileApiService {
  final ApiClient _apiClient;

  ProfileApiService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  /// GET /api/Profile
  Future<Result<UserProfileModel>> getProfile() async {
    try {
      final result = await _apiClient.getSafe(ApiConstants.profile);

      if (result is Success) {
        dynamic data = result.data;
        if (data is String && data.isNotEmpty) {
          try {
            data = json.decode(data);
          } catch (_) {}
        }

        if (data is Map<String, dynamic>) {
          final payload = data['data'] ?? data['result'] ?? data;
          if (payload is Map<String, dynamic>) {
            final profile = UserProfileModel.fromJson(payload);
            return Success(profile);
          }
        }
        return const Failure('صيغة البيانات غير صحيحة');
      } else if (result is Failure) {
        return Failure(_extractErrorMessage(result), error: result.error);
      }
      return const Failure('تعذر الاتصال بالخادم');
    } catch (e) {
      debugPrint('ProfileApiService.getProfile error: $e');
      return Failure('حدث خطأ غير متوقع: $e', error: e);
    }
  }

  /// PUT /api/Profile
  Future<Result<bool>> updateProfile(UserProfileModel profile) async {
    try {
      final body = {
        'id': profile.id,
        'fullName': profile.fullName.trim(),
        'title': profile.title?.trim().isNotEmpty == true ? profile.title!.trim() : null,
        'location': profile.location?.trim().isNotEmpty == true ? profile.location!.trim() : null,
        'phoneNumber': profile.phoneNumber?.trim().isNotEmpty == true ? profile.phoneNumber!.trim() : null,
        'about': profile.about?.trim().isNotEmpty == true ? profile.about!.trim() : null,
        'socialLinks': profile.socialLinks.toJson(),
      };

      final result = await _apiClient.putSafe(
        ApiConstants.profile,
        body: body,
      );

      if (result is Success) {
        return const Success(true);
      } else if (result is Failure) {
        final errMsg = _extractErrorMessage(result);
        // Handles EF Core 0 modified rows edge-case on remote server
        if (errMsg.contains('فشل في تحديث البروفايل')) {
          return const Success(true);
        }
        return Failure(errMsg, error: result.error);
      }
      return const Failure('فشل تحديث البيانات');
    } catch (e) {
      debugPrint('ProfileApiService.updateProfile error: $e');
      return Failure('حدث خطأ أثناء التحديث: $e', error: e);
    }
  }

  /// POST /api/Profile/upload-image
  Future<Result<String>> uploadProfileImage({
    required String userId,
    required XFile imageFile,
  }) async {
    try {
      final formData = dio.FormData.fromMap({
        'UserId': userId,
        'ImageFile': await dio.MultipartFile.fromFile(
          imageFile.path,
          filename: imageFile.name.isNotEmpty ? imageFile.name : 'avatar.jpg',
        ),
      });

      final result = await _apiClient.postFormDataSafe(
        '${ApiConstants.profile}/upload-image',
        formData: formData,
      );

      if (result is Success) {
        dynamic data = result.data;
        if (data is String && data.isNotEmpty) {
          try {
            data = json.decode(data);
          } catch (_) {}
        }

        String? rawUrl;
        if (data is Map<String, dynamic>) {
          rawUrl = data['imageUrl']?.toString() ??
              data['data']?['imageUrl']?.toString() ??
              data['profileImageUrl']?.toString();
        } else if (data is String) {
          rawUrl = data;
        }

        if (rawUrl != null && rawUrl.isNotEmpty) {
          final fullUrl = UserProfileModel.formatImageUrl(rawUrl) ?? rawUrl;
          return Success(fullUrl);
        }
        return const Failure('لم يتم إرجاع رابط الصورة');
      } else if (result is Failure) {
        return Failure(_extractErrorMessage(result), error: result.error);
      }
      return const Failure('فشل تحميل الصورة');
    } catch (e) {
      debugPrint('ProfileApiService.uploadProfileImage error: $e');
      return Failure('حدث خطأ أثناء رفع الصورة: $e', error: e);
    }
  }

  String _extractErrorMessage(Failure failure) {
    String msg = failure.message;
    try {
      if (failure.error is ApiException) {
        final rawBody = (failure.error as ApiException).responseBody;
        final decoded = json.decode(rawBody);
        if (decoded is Map<String, dynamic>) {
          if (decoded['message'] != null) {
            return decoded['message'].toString();
          }
          if (decoded['errors'] is Map<String, dynamic>) {
            final errors = decoded['errors'] as Map<String, dynamic>;
            final firstVal = errors.values.first;
            if (firstVal is List && firstVal.isNotEmpty) {
              return firstVal.first.toString();
            }
            return firstVal.toString();
          }
          if (decoded['title'] != null) {
            return decoded['title'].toString();
          }
        }
      }
    } catch (_) {}
    return msg;
  }
}

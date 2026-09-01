import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:mobile/core/constants/api_constants.dart';
import 'package:mobile/core/services/api_client.dart';
import 'package:mobile/features/profile/data/models/security_models.dart';

class SecurityApiService {
  final ApiClient _apiClient;

  SecurityApiService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  /// POST /api/Settings/change-password
  Future<Result<bool>> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      final body = {
        'currentPassword': currentPassword,
        'newPassword': newPassword,
        'confirmPassword': confirmPassword,
      };

      final result = await _apiClient.postSafe(
        ApiConstants.changePassword,
        body: body,
      );

      if (result is Success) {
        return const Success(true);
      } else if (result is Failure) {
        return Failure(_extractErrorMessage(result), error: result.error);
      }
      return const Failure('فشل تغيير كلمة المرور');
    } catch (e) {
      debugPrint('SecurityApiService.changePassword error: $e');
      return Failure('حدث خطأ أثناء تغيير كلمة المرور: $e', error: e);
    }
  }

  /// GET /api/Settings/two-factor/status
  Future<Result<bool>> getTwoFactorStatus() async {
    try {
      final result = await _apiClient.getSafe(ApiConstants.twoFactorStatus);

      if (result is Success) {
        dynamic data = result.data;
        if (data is bool) return Success(data);
        if (data is String) return Success(data.toLowerCase() == 'true');
        if (data is Map<String, dynamic>) {
          return Success(data['isEnabled'] == true || data['data'] == true);
        }
        return const Success(false);
      } else if (result is Failure) {
        return Failure(_extractErrorMessage(result), error: result.error);
      }
      return const Failure('تعذر جلب حالة التحقق بخطوتين');
    } catch (e) {
      debugPrint('SecurityApiService.getTwoFactorStatus error: $e');
      return Failure('حدث خطأ: $e', error: e);
    }
  }

  /// GET /api/Settings/two-factor/setup
  Future<Result<TwoFactorSetupModel>> getTwoFactorSetup() async {
    try {
      final result = await _apiClient.getSafe(ApiConstants.twoFactorSetup);

      if (result is Success) {
        dynamic data = result.data;
        if (data is String && data.isNotEmpty) {
          try {
            data = json.decode(data);
          } catch (_) {}
        }
        if (data is Map<String, dynamic>) {
          final payload = data['data'] ?? data;
          return Success(TwoFactorSetupModel.fromJson(payload));
        }
        return const Failure('بيانات الإعداد غير صالحة');
      } else if (result is Failure) {
        return Failure(_extractErrorMessage(result), error: result.error);
      }
      return const Failure('فشل جلب إعدادات التحقق بخطوتين');
    } catch (e) {
      debugPrint('SecurityApiService.getTwoFactorSetup error: $e');
      return Failure('حدث خطأ: $e', error: e);
    }
  }

  /// POST /api/Settings/two-factor/enable
  Future<Result<bool>> enableTwoFactor(String code) async {
    try {
      final result = await _apiClient.postSafe(
        ApiConstants.twoFactorEnable,
        body: {'code': code},
      );

      if (result is Success) {
        return const Success(true);
      } else if (result is Failure) {
        return Failure(_extractErrorMessage(result), error: result.error);
      }
      return const Failure('فشل تفعيل التحقق بخطوتين');
    } catch (e) {
      debugPrint('SecurityApiService.enableTwoFactor error: $e');
      return Failure('حدث خطأ: $e', error: e);
    }
  }

  /// POST /api/Settings/two-factor/disable
  Future<Result<bool>> disableTwoFactor() async {
    try {
      final result = await _apiClient.postSafe(
        ApiConstants.twoFactorDisable,
        body: {},
      );

      if (result is Success) {
        return const Success(true);
      } else if (result is Failure) {
        return Failure(_extractErrorMessage(result), error: result.error);
      }
      return const Failure('فشل تعطيل التحقق بخطوتين');
    } catch (e) {
      debugPrint('SecurityApiService.disableTwoFactor error: $e');
      return Failure('حدث خطأ: $e', error: e);
    }
  }

  /// GET /api/Settings/active-sessions
  Future<Result<List<ActiveSessionModel>>> getActiveSessions() async {
    try {
      final result = await _apiClient.getSafe(ApiConstants.activeSessions);

      if (result is Success) {
        dynamic data = result.data;
        if (data is String && data.isNotEmpty) {
          try {
            data = json.decode(data);
          } catch (_) {}
        }

        List<dynamic> list = [];
        if (data is List) {
          list = data;
        } else if (data is Map<String, dynamic> && data['data'] is List) {
          list = data['data'] as List;
        }

        final sessions = list
            .map((item) => ActiveSessionModel.fromJson(item as Map<String, dynamic>))
            .toList();
        return Success(sessions);
      } else if (result is Failure) {
        return Failure(_extractErrorMessage(result), error: result.error);
      }
      return const Failure('تعذر جلب الجلسات النشطة');
    } catch (e) {
      debugPrint('SecurityApiService.getActiveSessions error: $e');
      return Failure('حدث خطأ: $e', error: e);
    }
  }

  /// POST /api/Settings/active-sessions/revoke/{sessionId}
  Future<Result<bool>> revokeSession(String sessionId) async {
    try {
      final result = await _apiClient.postSafe(
        '${ApiConstants.revokeSession}/$sessionId',
        body: {},
      );

      if (result is Success) {
        return const Success(true);
      } else if (result is Failure) {
        return Failure(_extractErrorMessage(result), error: result.error);
      }
      return const Failure('فشل إنهاء الجلسة');
    } catch (e) {
      debugPrint('SecurityApiService.revokeSession error: $e');
      return Failure('حدث خطأ: $e', error: e);
    }
  }

  /// POST /api/Settings/active-sessions/revoke-all
  Future<Result<bool>> revokeAllSessions() async {
    try {
      final result = await _apiClient.postSafe(
        ApiConstants.revokeAllSessions,
        body: {},
      );

      if (result is Success) {
        return const Success(true);
      } else if (result is Failure) {
        return Failure(_extractErrorMessage(result), error: result.error);
      }
      return const Failure('فشل إنهاء جميع الجلسات');
    } catch (e) {
      debugPrint('SecurityApiService.revokeAllSessions error: $e');
      return Failure('حدث خطأ: $e', error: e);
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
        }
      }
    } catch (_) {}
    return msg;
  }
}

import 'package:mobile/core/services/api_client.dart';
import 'package:mobile/features/profile/data/models/security_models.dart';
import 'package:mobile/features/profile/data/services/security_api_service.dart';

class SecurityRepository {
  final SecurityApiService _apiService;

  SecurityRepository({SecurityApiService? apiService})
      : _apiService = apiService ?? SecurityApiService();

  Future<Result<bool>> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) {
    return _apiService.changePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
      confirmPassword: confirmPassword,
    );
  }

  Future<Result<bool>> getTwoFactorStatus() {
    return _apiService.getTwoFactorStatus();
  }

  Future<Result<TwoFactorSetupModel>> getTwoFactorSetup() {
    return _apiService.getTwoFactorSetup();
  }

  Future<Result<bool>> enableTwoFactor(String code) {
    return _apiService.enableTwoFactor(code);
  }

  Future<Result<bool>> disableTwoFactor() {
    return _apiService.disableTwoFactor();
  }

  Future<Result<List<ActiveSessionModel>>> getActiveSessions() {
    return _apiService.getActiveSessions();
  }

  Future<Result<bool>> revokeSession(String sessionId) {
    return _apiService.revokeSession(sessionId);
  }

  Future<Result<bool>> revokeAllSessions() {
    return _apiService.revokeAllSessions();
  }
}

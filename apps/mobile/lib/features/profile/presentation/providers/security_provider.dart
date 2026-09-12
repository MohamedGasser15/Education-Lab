import 'package:flutter/foundation.dart';
import 'package:mobile/core/di/service_locator.dart';
import 'package:mobile/core/services/api_client.dart';
import 'package:mobile/features/profile/data/models/security_models.dart';
import 'package:mobile/features/profile/data/repositories/security_repository.dart';

class SecurityProvider with ChangeNotifier {
  final SecurityRepository _repository;

  bool _isLoading = false;
  bool _is2FaEnabled = false;
  List<ActiveSessionModel> _activeSessions = [];
  String? _errorMessage;

  SecurityProvider({SecurityRepository? repository})
    : _repository = repository ?? resolveOr(() => SecurityRepository());

  bool get isLoading => _isLoading;
  bool get is2FaEnabled => _is2FaEnabled;
  List<ActiveSessionModel> get activeSessions => _activeSessions;
  String? get errorMessage => _errorMessage;

  Future<void> loadSecurityData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final faResult = await _repository.getTwoFactorStatus();
      if (faResult is Success<bool>) {
        _is2FaEnabled = faResult.data;
      }

      final sessionsResult = await _repository.getActiveSessions();
      if (sessionsResult is Success<List<ActiveSessionModel>>) {
        _activeSessions = sessionsResult.data;
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Result<bool>> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) {
    return _repository.changePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
      confirmPassword: confirmPassword,
    );
  }

  Future<Result<TwoFactorSetupModel>> getTwoFactorSetup() {
    return _repository.getTwoFactorSetup();
  }

  Future<Result<bool>> enableTwoFactor(String code) async {
    final result = await _repository.enableTwoFactor(code);
    if (result is Success<bool> && result.data) {
      _is2FaEnabled = true;
      notifyListeners();
    }
    return result;
  }

  Future<Result<bool>> disableTwoFactor() async {
    final result = await _repository.disableTwoFactor();
    if (result is Success<bool> && result.data) {
      _is2FaEnabled = false;
      notifyListeners();
    }
    return result;
  }

  Future<Result<bool>> revokeSession(String sessionId) async {
    final result = await _repository.revokeSession(sessionId);
    if (result is Success<bool> && result.data) {
      _activeSessions.removeWhere((s) => s.id == sessionId);
      notifyListeners();
    }
    return result;
  }

  Future<Result<bool>> revokeAllSessions() async {
    final result = await _repository.revokeAllSessions();
    if (result is Success<bool> && result.data) {
      _activeSessions.removeWhere((s) => !s.isCurrent);
      notifyListeners();
    }
    return result;
  }
}

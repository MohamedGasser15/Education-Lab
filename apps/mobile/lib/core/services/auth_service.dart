import 'dart:convert';
import 'package:mobile/core/constants/api_constants.dart';
import 'package:mobile/core/services/api_client.dart';
import 'package:mobile/core/services/auth_storage_service.dart';

class AuthService {
  final ApiClient _apiClient;

  AuthService({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final data = await _apiClient.post(
      ApiConstants.login,
      body: {'email': email, 'password': password},
    );
    final map = data as Map<String, dynamic>;
    if (map['success'] == false) {
      throw AuthException(
        message: (map['message'] as String?) ?? 'Login failed',
        isLockedOut: map['data']?['isLockedOut'] == true,
        isBanned: map['data']?['isBanned'] == true,
      );
    }
    final result = map['data'] as Map<String, dynamic>;
    await AuthStorageService.saveAuth(
      accessToken: result['token'] as String,
      refreshToken: result['refreshToken'] as String,
      user: result['user'] as Map<String, dynamic>,
    );
    return result;
  }

  Future<Map<String, dynamic>> register({
    required String fullName,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    final data = await _apiClient.post(
      ApiConstants.register,
      body: {
        'fullName': fullName,
        'email': email,
        'password': password,
        'confirmPassword': confirmPassword,
      },
    );
    final map = data as Map<String, dynamic>;
    if (map['success'] == false) {
      final errors = (map['errors'] as List?)?.cast<String>();
      throw AuthException(
        message: errors != null && errors.isNotEmpty
            ? errors.first
            : (map['message'] as String?) ?? 'Registration failed',
      );
    }
    return map;
  }

  Future<void> refreshToken() async {
    final accessToken = await AuthStorageService.getAccessToken();
    final refreshToken = await AuthStorageService.getRefreshToken();
    if (accessToken == null || refreshToken == null) {
      throw AuthException(message: 'No tokens found');
    }
    final data = await _apiClient.post(
      ApiConstants.refresh,
      body: {'accessToken': accessToken, 'refreshToken': refreshToken},
    );
    final map = data as Map<String, dynamic>;
    if (map['success'] == false) {
      throw AuthException(message: (map['message'] as String?) ?? 'Refresh failed');
    }
    final result = map['data'] as Map<String, dynamic>;
    await AuthStorageService.saveTokens(
      accessToken: result['accessToken'] as String,
      refreshToken: result['refreshToken'] as String,
    );
  }

  Future<void> revokeToken() async {
    final refreshToken = await AuthStorageService.getRefreshToken();
    if (refreshToken == null) return;
    try {
      await _apiClient.postRaw(
        ApiConstants.revoke,
        body: json.encode(refreshToken),
      );
    } catch (_) {}
  }

  Future<Map<String, dynamic>?> getCurrentUser() =>
      AuthStorageService.getUser();

  Future<bool> isLoggedIn() => AuthStorageService.isLoggedIn();

  Future<void> logout() async {
    await revokeToken();
    await AuthStorageService.logout();
  }
}

class AuthException implements Exception {
  final String message;
  final bool isLockedOut;
  final bool isBanned;

  const AuthException({
    required this.message,
    this.isLockedOut = false,
    this.isBanned = false,
  });

  @override
  String toString() => message;
}
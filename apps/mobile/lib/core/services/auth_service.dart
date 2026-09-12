import 'dart:convert';
import 'package:mobile/core/constants/api_constants.dart';
import 'package:mobile/core/services/api_client.dart';
import 'package:mobile/core/services/auth_storage_service.dart';
import 'package:mobile/core/services/notification_service.dart';

class AuthService {
  final ApiClient _apiClient;

  AuthService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final map = await _postEnvelope(ApiConstants.login, {
      'email': email,
      'password': password,
    });
    if (map['success'] == false) {
      throw _authError(map);
    }
    final result = map['data'] as Map<String, dynamic>;
    await AuthStorageService.saveAuth(
      accessToken: result['token'] as String,
      refreshToken: result['refreshToken'] as String,
      user: result['user'] as Map<String, dynamic>,
    );
    try {
      NotificationService().syncDeviceTokenWithServer();
    } catch (_) {}
    return result;
  }

  Future<Map<String, dynamic>> register({
    required String fullName,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    final map = await _postEnvelope(ApiConstants.register, {
      'fullName': fullName,
      'email': email,
      'password': password,
      'confirmPassword': confirmPassword,
    });
    if (map['success'] == false) {
      throw _authError(map);
    }
    return map;
  }

  Future<void> sendCode({required String email}) async {
    final map = await _postEnvelope(ApiConstants.sendCode, {'email': email});
    if (map['success'] == false) {
      throw _authError(map);
    }
  }

  Future<void> verifyEmail({
    required String email,
    required String code,
  }) async {
    final map = await _postEnvelope(ApiConstants.verifyEmail, {
      'email': email,
      'code': code,
    });
    if (map['success'] == false) {
      throw _authError(map);
    }
  }

  Future<Map<String, dynamic>> externalLogin(String idToken) async {
    final map = await _postEnvelope(ApiConstants.googleMobile, {
      'idToken': idToken,
    });
    if (map['success'] == false) {
      throw _authError(map);
    }
    final result = (map['data'] as Map<String, dynamic>?) ?? {};
    final token = (result['token'] ?? result['accessToken'] ?? '') as String;
    final refreshToken = (result['refreshToken'] ?? '') as String;
    final user =
        (result['user'] as Map<String, dynamic>?) ??
        {
          'id': result['id'] ?? result['userId'] ?? '',
          'email': result['email'] ?? '',
          'fullName': result['fullName'] ?? result['displayName'] ?? '',
        };

    await AuthStorageService.saveAuth(
      accessToken: token,
      refreshToken: refreshToken,
      user: user,
    );
    try {
      NotificationService().syncDeviceTokenWithServer();
    } catch (_) {}
    return result;
  }

  Future<void> refreshToken() async {
    final accessToken = await AuthStorageService.getAccessToken();
    final refreshToken = await AuthStorageService.getRefreshToken();
    if (accessToken == null || refreshToken == null) {
      throw const AuthException(message: 'No tokens found');
    }
    final map = await _postEnvelope(ApiConstants.refresh, {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
    });
    if (map['success'] == false) {
      throw _authError(map);
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

  Future<Map<String, dynamic>> _postEnvelope(
    String path,
    Map<String, dynamic> body,
  ) async {
    try {
      return (await _apiClient.post(path, body: body)) as Map<String, dynamic>;
    } on ApiException catch (e) {
      final envelope = _tryEnvelope(e.responseBody);
      if (envelope == null) rethrow;
      return envelope;
    }
  }

  static Map<String, dynamic>? _tryEnvelope(String body) {
    if (body.isEmpty) return null;
    try {
      final decoded = json.decode(body);
      return decoded is Map<String, dynamic> ? decoded : null;
    } catch (_) {
      return null;
    }
  }

  static AuthException _authError(Map<String, dynamic> map) {
    final message = (map['message'] as String?)?.trim();
    final error = (map['error'] as String?)?.trim();
    final errors = (map['errors'] as List?)?.cast<String>();
    final data = map['data'];
    final String msg;
    if (message != null && message.isNotEmpty) {
      msg = message;
    } else if (errors != null && errors.isNotEmpty) {
      msg = errors.first;
    } else if (error != null && error.isNotEmpty) {
      msg = error;
    } else {
      msg = 'حدث خطأ غير متوقع، حاول مرة أخرى';
    }
    return AuthException(
      message: msg,
      isLockedOut: data is Map<String, dynamic>
          ? data['isLockedOut'] == true
          : false,
      isBanned: data is Map<String, dynamic> ? data['isBanned'] == true : false,
    );
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

import 'package:mobile/core/services/auth_service.dart';

abstract class AuthRepositoryBase {
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  });
  Future<Map<String, dynamic>> register({
    required String fullName,
    required String email,
    required String password,
    required String confirmPassword,
  });
  Future<void> refreshToken();
  Future<void> logout();
  Future<Map<String, dynamic>?> getCurrentUser();
  Future<bool> isLoggedIn();
}

class AuthRepository implements AuthRepositoryBase {
  final AuthService _service;

  AuthRepository({AuthService? service}) : _service = service ?? AuthService();

  @override
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) =>
      _service.login(email: email, password: password);

  @override
  Future<Map<String, dynamic>> register({
    required String fullName,
    required String email,
    required String password,
    required String confirmPassword,
  }) =>
      _service.register(
        fullName: fullName,
        email: email,
        password: password,
        confirmPassword: confirmPassword,
      );

  @override
  Future<void> refreshToken() => _service.refreshToken();

  @override
  Future<void> logout() => _service.logout();

  @override
  Future<Map<String, dynamic>?> getCurrentUser() =>
      _service.getCurrentUser();

  @override
  Future<bool> isLoggedIn() => _service.isLoggedIn();
}
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
  Future<void> sendCode({required String email});
  Future<void> verifyEmail({required String email, required String code});
  Future<Map<String, dynamic>> externalLogin(String idToken);
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
  Future<void> sendCode({required String email}) =>
      _service.sendCode(email: email);

  @override
  Future<void> verifyEmail({required String email, required String code}) =>
      _service.verifyEmail(email: email, code: code);

  @override
  Future<Map<String, dynamic>> externalLogin(String idToken) =>
      _service.externalLogin(idToken);

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
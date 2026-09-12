import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/repositories/auth_repository.dart';
import 'package:mobile/core/services/auth_service.dart';

class FakeAuthService extends AuthService {
  bool didLogout = false;

  @override
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    return {'id': '123', 'email': email, 'token': 'jwt_token'};
  }

  @override
  Future<Map<String, dynamic>> register({
    required String fullName,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    return {'id': '124', 'fullName': fullName, 'email': email};
  }

  @override
  Future<bool> isLoggedIn() async {
    return true;
  }

  @override
  Future<void> logout() async {
    didLogout = true;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AuthRepository Tests', () {
    late AuthRepository repo;
    late FakeAuthService fakeService;

    setUp(() {
      fakeService = FakeAuthService();
      repo = AuthRepository(service: fakeService);
    });

    test('login delegates to auth service and returns payload', () async {
      final res = await repo.login(
        email: 'user@test.com',
        password: 'password123',
      );
      expect(res['email'], 'user@test.com');
      expect(res['token'], 'jwt_token');
    });

    test(
      'register delegates to auth service and returns created profile',
      () async {
        final res = await repo.register(
          fullName: 'Test User',
          email: 'user@test.com',
          password: 'password123',
          confirmPassword: 'password123',
        );
        expect(res['fullName'], 'Test User');
      },
    );

    test('isLoggedIn and logout work properly', () async {
      final loggedIn = await repo.isLoggedIn();
      expect(loggedIn, isTrue);

      await repo.logout();
      expect(fakeService.didLogout, isTrue);
    });
  });
}

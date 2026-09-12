import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/services/api_client.dart';
import 'package:mobile/features/profile/data/models/security_models.dart';
import 'package:mobile/features/profile/data/repositories/security_repository.dart';
import 'package:mobile/features/profile/data/services/security_api_service.dart';

class FakeSecurityApiService extends SecurityApiService {
  @override
  Future<Result<bool>> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    return const Success(true);
  }

  @override
  Future<Result<bool>> getTwoFactorStatus() async {
    return const Success(true);
  }

  @override
  Future<Result<TwoFactorSetupModel>> getTwoFactorSetup() async {
    return const Success(
      TwoFactorSetupModel(
        qrCodeUrl: 'https://edulab.com/qr',
        secret: 'KEY-123',
      ),
    );
  }

  @override
  Future<Result<bool>> enableTwoFactor(String code) async {
    return const Success(true);
  }

  @override
  Future<Result<bool>> disableTwoFactor() async {
    return const Success(true);
  }

  @override
  Future<Result<List<ActiveSessionModel>>> getActiveSessions() async {
    return Success([
      ActiveSessionModel(
        id: 'sess-1',
        deviceName: 'iPhone 15 Pro',
        deviceType: 'phone',
        location: 'Cairo, Egypt',
        ipAddress: '192.168.1.1',
        lastActive: DateTime(2026, 1, 1),
        isCurrent: true,
      ),
    ]);
  }

  @override
  Future<Result<bool>> revokeSession(String sessionId) async {
    return const Success(true);
  }

  @override
  Future<Result<bool>> revokeAllSessions() async {
    return const Success(true);
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SecurityRepository Tests', () {
    late SecurityRepository repository;
    late FakeSecurityApiService fakeService;

    setUp(() {
      fakeService = FakeSecurityApiService();
      repository = SecurityRepository(apiService: fakeService);
    });

    test('changePassword and twoFactor methods delegate properly', () async {
      final changeRes = await repository.changePassword(
        currentPassword: 'old',
        newPassword: 'new',
        confirmPassword: 'new',
      );
      expect((changeRes as Success<bool>).data, isTrue);

      final tfaStatus = await repository.getTwoFactorStatus();
      expect((tfaStatus as Success<bool>).data, isTrue);

      final setup = await repository.getTwoFactorSetup();
      expect((setup as Success<TwoFactorSetupModel>).data.secret, 'KEY-123');
    });

    test('getActiveSessions and revokeSession delegate properly', () async {
      final sessionsRes = await repository.getActiveSessions();
      expect((sessionsRes as Success<List<ActiveSessionModel>>).data.length, 1);

      final revokeRes = await repository.revokeSession('sess-1');
      expect((revokeRes as Success<bool>).data, isTrue);
    });
  });
}

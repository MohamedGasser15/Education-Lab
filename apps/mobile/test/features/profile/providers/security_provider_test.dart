import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/services/api_client.dart';
import 'package:mobile/features/profile/data/models/security_models.dart';
import 'package:mobile/features/profile/data/repositories/security_repository.dart';
import 'package:mobile/features/profile/presentation/providers/security_provider.dart';

class FakeSecurityRepository extends SecurityRepository {
  bool is2Fa;
  List<ActiveSessionModel> sessions;
  bool shouldSucceed;

  FakeSecurityRepository({
    this.is2Fa = false,
    this.sessions = const [],
    this.shouldSucceed = true,
  });

  @override
  Future<Result<bool>> getTwoFactorStatus() async {
    if (shouldSucceed) return Success(is2Fa);
    return const Failure('Error fetching 2FA status');
  }

  @override
  Future<Result<List<ActiveSessionModel>>> getActiveSessions() async {
    if (shouldSucceed) return Success(sessions);
    return const Failure('Error fetching sessions');
  }

  @override
  Future<Result<bool>> enableTwoFactor(String code) async {
    if (shouldSucceed && code == '123456') {
      is2Fa = true;
      return const Success(true);
    }
    return const Failure('Invalid code');
  }

  @override
  Future<Result<bool>> disableTwoFactor() async {
    if (shouldSucceed) {
      is2Fa = false;
      return const Success(true);
    }
    return const Failure('Failed to disable');
  }

  @override
  Future<Result<bool>> revokeSession(String sessionId) async {
    if (shouldSucceed) {
      sessions.removeWhere((s) => s.id == sessionId);
      return const Success(true);
    }
    return const Failure('Failed to revoke session');
  }

  @override
  Future<Result<bool>> revokeAllSessions() async {
    if (shouldSucceed) {
      sessions.removeWhere((s) => !s.isCurrent);
      return const Success(true);
    }
    return const Failure('Failed to revoke all sessions');
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SecurityProvider Tests', () {
    test(
      'loadSecurityData updates 2FA and active sessions on success',
      () async {
        final fakeRepo = FakeSecurityRepository(
          is2Fa: true,
          sessions: [
            const ActiveSessionModel(
              id: 'sess-1',
              deviceName: 'iPhone 15',
              deviceType: 'phone',
              ipAddress: '192.168.1.1',
              location: 'Riyadh, SA',
              isCurrent: true,
            ),
            const ActiveSessionModel(
              id: 'sess-2',
              deviceName: 'Chrome on Mac',
              deviceType: 'desktop',
              ipAddress: '192.168.1.2',
              location: 'Cairo, EG',
              isCurrent: false,
            ),
          ],
        );

        final provider = SecurityProvider(repository: fakeRepo);

        expect(provider.isLoading, false);
        expect(provider.is2FaEnabled, false);
        expect(provider.activeSessions, isEmpty);

        await provider.loadSecurityData();

        expect(provider.isLoading, false);
        expect(provider.is2FaEnabled, true);
        expect(provider.activeSessions.length, 2);
      },
    );

    test('enableTwoFactor updates 2FA state on success', () async {
      final fakeRepo = FakeSecurityRepository(is2Fa: false);
      final provider = SecurityProvider(repository: fakeRepo);

      final result = await provider.enableTwoFactor('123456');
      expect(result is Success, true);
      expect(provider.is2FaEnabled, true);
    });

    test('disableTwoFactor updates 2FA state on success', () async {
      final fakeRepo = FakeSecurityRepository(is2Fa: true);
      final provider = SecurityProvider(repository: fakeRepo);
      await provider.loadSecurityData();
      expect(provider.is2FaEnabled, true);

      final result = await provider.disableTwoFactor();
      expect(result is Success, true);
      expect(provider.is2FaEnabled, false);
    });

    test('revokeSession removes specific session from list', () async {
      final sessionList = [
        const ActiveSessionModel(
          id: 'sess-1',
          deviceName: 'iPhone 15',
          deviceType: 'phone',
          ipAddress: '1.1.1.1',
          location: 'Riyadh',
          isCurrent: true,
        ),
        const ActiveSessionModel(
          id: 'sess-2',
          deviceName: 'Android',
          deviceType: 'phone',
          ipAddress: '1.1.1.2',
          location: 'Dubai',
          isCurrent: false,
        ),
      ];
      final fakeRepo = FakeSecurityRepository(sessions: List.from(sessionList));
      final provider = SecurityProvider(repository: fakeRepo);
      await provider.loadSecurityData();

      expect(provider.activeSessions.length, 2);
      final res = await provider.revokeSession('sess-2');
      expect(res is Success, true);
      expect(provider.activeSessions.length, 1);
      expect(provider.activeSessions.first.id, 'sess-1');
    });
  });
}

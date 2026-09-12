import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/services/api_client.dart';
import 'package:mobile/features/legal/data/models/legal_content_model.dart';
import 'package:mobile/features/legal/data/services/legal_api_service.dart';
import 'package:mobile/features/legal/presentation/providers/legal_provider.dart';

class FakeLegalApiService extends LegalApiService {
  final bool shouldSucceed;

  FakeLegalApiService({this.shouldSucceed = true});

  @override
  Future<Result<Map<String, LegalContentModel>>> getAllLegalInfo({
    String? language,
  }) async {
    if (shouldSucceed) {
      return Success({
        'about': LegalContentModel(
          type: 'about',
          title: 'عن التطبيق',
          subtitle: 'نبذة عنا',
          lastUpdated: '2026-09-01',
          appVersion: '1.0.0',
          contactEmail: 'support@edulab.com',
          websiteUrl: 'https://edulab.com',
          sections: [],
        ),
        'privacy': LegalContentModel(
          type: 'privacy',
          title: 'سياسة الخصوصية',
          subtitle: 'خصوصيتك تهمنا',
          lastUpdated: '2026-09-01',
          appVersion: '1.0.0',
          contactEmail: 'support@edulab.com',
          websiteUrl: 'https://edulab.com',
          sections: [],
        ),
        'terms': LegalContentModel(
          type: 'terms',
          title: 'الشروط والأحكام',
          subtitle: 'شروط الاستخدام',
          lastUpdated: '2026-09-01',
          appVersion: '1.0.0',
          contactEmail: 'support@edulab.com',
          websiteUrl: 'https://edulab.com',
          sections: [],
        ),
      });
    }
    return const Failure('Failed to fetch legal docs');
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('LegalProvider Tests', () {
    test('fetchLegalDocs populates docs on success', () async {
      final fakeService = FakeLegalApiService(shouldSucceed: true);
      final provider = LegalProvider(service: fakeService);

      expect(provider.isLoading, false);
      expect(provider.aboutDoc, isNull);

      await provider.fetchLegalDocs(language: 'ar');

      expect(provider.isLoading, false);
      expect(provider.aboutDoc?.title, 'عن التطبيق');
      expect(provider.privacyDoc?.title, 'سياسة الخصوصية');
      expect(provider.termsDoc?.title, 'الشروط والأحكام');
    });

    test('fetchLegalDocs falls back to default docs on failure', () async {
      final fakeService = FakeLegalApiService(shouldSucceed: false);
      final provider = LegalProvider(service: fakeService);

      await provider.fetchLegalDocs(language: 'ar');

      expect(provider.isLoading, false);
      expect(provider.aboutDoc, isNotNull);
      expect(provider.privacyDoc, isNotNull);
      expect(provider.termsDoc, isNotNull);
    });
  });
}

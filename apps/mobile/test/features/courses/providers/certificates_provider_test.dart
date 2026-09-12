import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/services/api_client.dart';
import 'package:mobile/features/courses/data/models/certificate_model.dart';
import 'package:mobile/features/courses/data/repositories/certificates_repository.dart';
import 'package:mobile/features/courses/presentation/providers/certificates_provider.dart';

class FakeCertificatesRepository extends CertificatesRepository {
  final bool shouldSucceed;
  final List<CertificateModel> mockCertificates;

  FakeCertificatesRepository({
    this.shouldSucceed = true,
    this.mockCertificates = const [],
  });

  @override
  Future<Result<List<CertificateModel>>> getMyCertificates() async {
    if (shouldSucceed) {
      return Success(mockCertificates);
    }
    return const Failure('Error fetching certificates');
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('CertificatesProvider Tests', () {
    final List<CertificateModel> mockCerts = [
      CertificateModel(
        id: 1,
        courseId: 101,
        certificateCode: 'CERT-001',
        issuedDate: DateTime(2026, 1, 1),
        studentName: 'Ali Ahmed',
        courseTitle: 'Flutter Clean Architecture',
        verifyUrl: 'https://edulab.com/verify/CERT-001',
      ),
    ];

    test('fetchMyCertificates updates certificates on success', () async {
      final fakeRepo = FakeCertificatesRepository(mockCertificates: mockCerts);
      final provider = CertificatesProvider(repository: fakeRepo);

      expect(provider.certificates, isEmpty);
      expect(provider.isLoading, false);

      await provider.fetchMyCertificates();

      expect(provider.isLoading, false);
      expect(provider.certificates.length, 1);
      expect(provider.certificates.first.certificateCode, 'CERT-001');
      expect(provider.errorMessage, isNull);
    });

    test('fetchMyCertificates sets errorMessage on failure', () async {
      final fakeRepo = FakeCertificatesRepository(shouldSucceed: false);
      final provider = CertificatesProvider(repository: fakeRepo);

      await provider.fetchMyCertificates();

      expect(provider.isLoading, false);
      expect(provider.certificates, isEmpty);
      expect(provider.errorMessage, 'Error fetching certificates');
    });

    test('reset clears certificates and error state', () async {
      final fakeRepo = FakeCertificatesRepository(mockCertificates: mockCerts);
      final provider = CertificatesProvider(repository: fakeRepo);

      await provider.fetchMyCertificates();
      expect(provider.certificates.length, 1);

      provider.reset();
      expect(provider.certificates, isEmpty);
      expect(provider.errorMessage, isNull);
      expect(provider.isLoading, false);
    });
  });
}
